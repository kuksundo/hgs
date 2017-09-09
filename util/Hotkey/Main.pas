unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, StdCtrls,
  ComCtrls, HotKeyManager, CoolTrayIcon, Mask, ExtCtrls, Buttons,
  Commctrl, ajRegPathManager, Registry, Menus, ImgList, rxToolEdit,
  JvExComCtrls, JvHotKey, JvDotNetControls;

const
  REGISTRY_FULLPATH = 'HKCU\software\JHPark\HotKey\HotKey_List';

type
  TMainForm = class(TForm)
    GroupBox2: TGroupBox;
    BtnGetHotKey: TButton;
    GroupBox4: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Label2: TLabel;
    HotKeyManager1: THotKeyManager;
    Panel1: TPanel;
    BtnRemove: TButton;
    BtnClear: TButton;
    ListView1: TListView;
    pnToolbar: TPanel;
    btnCancel: TSpeedButton;
    btnUpdate: TSpeedButton;
    Bevel2: TBevel;
    SpeedButton1: TSpeedButton;
    FilenameEdit1: TFilenameEdit;
    Splitter1: TSplitter;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N4: TMenuItem;
    N2: TMenuItem;
    N5: TMenuItem;
    N3: TMenuItem;
    TrayIcon1: TCoolTrayIcon;
    ImageList2: TImageList;
    JvHotKey1: TJvHotKey;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnGetHotKeyClick(Sender: TObject);
    procedure BtnRemoveClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure HotKeyManager1HotKeyPressed(HotKey: Cardinal; Index: Word);
    procedure btnCancelClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure TrayIcon1BalloonHintClick(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
  private
    OriginalListViewWindowProc : TWndMethod;
    //ListView에서 삭제한 키값을 보유해서 레지스트리에 적용시킴
    FDeletedItemList: TStringList;
    FRegPathManager   : TajRegPathManager;

    procedure ListViewWindowProcEx(var Message: TMessage);
    procedure GetCheckedButtonClick(Sender: TObject);
    procedure AddHotKey(HotKey: Cardinal; LChecked: Boolean);
    procedure GetPotentialKeys;
    procedure SaveLVData2Registry(lv: TListView);
    procedure AddHotKeyFromRegistry(AHotKey: String; AChecked: Boolean; AFunction: string);
    function DeleteRegistryKeyWithSubKey(const RootKey: HKEY;
                                                    const Key: string): Boolean;
    procedure GetRegistryKey2ListView(Path: String);
    procedure GetRegKeyValueNames   (SubPath : string; KeyValueNameList: TStringList);

//    procedure SaveOptionData2Registry(AForm: TForm);
  end;

var
  MainForm: TMainForm;
  ToShow: Boolean = False;

implementation

uses ShellAPI;

{$R *.DFM}

const
  LOCALIZED_KEYNAMES = True;

type
  THotKeyEntry = class
    HotKey: Cardinal;
    constructor Create(iHotKey: Cardinal);
  end;

  TPotentialKey = class
    Key: Word;
    constructor Create(iKey: Word);
  end;

constructor THotKeyEntry.Create(iHotKey: Cardinal);
begin
  inherited Create;
  HotKey := iHotKey;
end;

constructor TPotentialKey.Create(iKey: Word);
begin
  inherited Create;
  Key := iKey;
end;

function RelativeKey(const Key: string): PChar;
begin
  Result := PChar(Key);
  if (Key <> '') and (Key[1] = '\') then
    Inc(Result);
end;

{--------------------- TMainForm ----------------------}
procedure TMainForm.ListViewWindowProcEx(var Message: TMessage);
var
  listItem : TListItem;
begin
  if Message.Msg = CN_NOTIFY then
  begin
    if PNMHdr(Message.LParam)^.Code = LVN_ITEMCHANGED then
    begin
      with PNMListView(Message.LParam)^ do
      begin
        if (uChanged and LVIF_STATE) <> 0 then
        begin
          if ((uOldState and LVIS_STATEIMAGEMASK) shr 12) <> ((uNewState and LVIS_STATEIMAGEMASK) shr 12) then
          begin
            listItem := listView1.Items[iItem];
            if listItem.Checked then
              HotKeyManager1.AddHotKey(TextToHotKey(listItem.Caption,LOCALIZED_KEYNAMES),listItem.SubItems.Text)
            else
              HotKeyManager1.RemoveHotKey(TextToHotKey(listItem.Caption,LOCALIZED_KEYNAMES));
            //memo1.Lines.Add(Format('%s checked:%s', [listItem.Caption, BoolToStr(listItem.Checked, True)]));
          end;
        end;
      end;
    end;
  end;
  OriginalListViewWindowProc(Message);
end;

procedure TMainForm.GetCheckedButtonClick(Sender: TObject);
var
  li : TListItem;
  I: integer;
begin
  //memo1.Lines.Clear;
  //memo1.Lines.Add('Checked Items:');
  for I := 0 to Listview1.Items.Count -1 do
  begin
    li := ListView1.Items[I];
    if li.Checked then
    begin
      //memo1.Lines.Add(Format('%s %s %s', [li.Caption, li.SubItems[0], li.SubItems[1]]));
    end;
  end;
end;

procedure TMainForm.AddHotKey(HotKey: Cardinal; LChecked: Boolean);
var
  LListItem: TListItem;
begin
  if HotKeyManager1.AddHotKey(HotKey,FilenameEdit1.FileName) <> 0 then
  begin
    with Listview1.Items.Add do
    begin
      Checked := LChecked;
      Caption := ShortCutToText(JvHotKey1.HotKey); //HotKeyToText(HotKey, LOCALIZED_KEYNAMES);
      SubItems.Add(FilenameEdit1.FileName);
      //SubItems.AddObject(HotKeyToText(HotKey, LOCALIZED_KEYNAMES), THotKeyEntry.Create(HotKey));
    end;//with
  end
  else
    MessageDlg(HotKeyToText(HotKey, LOCALIZED_KEYNAMES) + ' couldn''t be assigned to a hotkey.',
               mtWarning, [mbOk], 0);
end;


procedure TMainForm.FormCreate(Sender: TObject);
begin
  OriginalListViewWindowProc := ListView1.WindowProc;
  ListView1.WindowProc := ListViewWindowProcEx;

  FRegPathManager := TajRegPathManager.Create;  // Create the path manager.
  fRegPathManager.FullPath := REGISTRY_FULLPATH;
  FDeletedItemList := TStringList.Create;
  GetPotentialKeys;
end;


procedure TMainForm.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  FreeAndNil(FRegPathManager);
  FreeAndNil(FDeletedItemList);

//  for I := ComboBox1.Items.Count -1 downto 0 do
//    ComboBox1.Items.Objects[I].Free;
end;


procedure TMainForm.BtnGetHotKeyClick(Sender: TObject);
var
  HotKeyVar: Cardinal;
  Modifiers: Word;
  PotentialKey: TPotentialKey;
begin
  Modifiers := 0;
//  if CheckBox1.Checked then
//    Modifiers := Modifiers or MOD_CONTROL;
//  if CheckBox2.Checked then
//    Modifiers := Modifiers or MOD_SHIFT;
//  if CheckBox3.Checked then
//    Modifiers := Modifiers or MOD_ALT;
//  if CheckBox4.Checked then
//    Modifiers := Modifiers or MOD_WIN;

//  if ComboBox1.ItemIndex <> -1 then
//  begin
//    PotentialKey := (ComboBox1.Items.Objects[ComboBox1.ItemIndex] as TPotentialKey);
    HotKeyVar := HotKeyManager.GetHotKey(Modifiers, JvHotKey1.HotKey);
    AddHotKey(HotKeyVar, True);
//  end
//  else
//    MessageDlg('No key selected from the list.', mtWarning, [mbOk], 0);
end;


procedure TMainForm.BtnRemoveClick(Sender: TObject);
var
//  HotKeyEntry: THotKeyEntry;
  HotKeyEntry: Cardinal;
begin
  if Listview1.ItemIndex > -1 then
  begin                            
    // HotKeyEntry := (ListView1.Items.Item[Listview1.ItemIndex].SubItems.Objects[Listview1.ItemIndex] as THotKeyEntry);
    HotKeyEntry := TextToHotKey(ListView1.Items.Item[Listview1.ItemIndex].Caption, LOCALIZED_KEYNAMES);
    if HotKeyManager1.RemoveHotKey(HotKeyEntry) then
    begin
      //HotKeyEntry.Free;
      FDeletedItemList.Add(fRegPathManager.SubPath + '\' + ListView1.Selected.Caption);
      Listview1.Items.Delete(Listview1.ItemIndex);
    end
    else
      MessageDlg(HotKeyToText(HotKeyEntry, LOCALIZED_KEYNAMES) +
                 ' couldn''t be removed.', mtWarning, [mbOk], 0);
  end;
end;


procedure TMainForm.BtnClearClick(Sender: TObject);
var
  I: Integer;
begin
  if MessageDlg('All hotkey is deleted. r u sure?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
  begin
    for i := 0 to ListView1.Items.Count - 1 do
    begin
      FDeletedItemList.Add(fRegPathManager.SubPath + '\' + Listview1.Items[i].Caption);
    end;//for

    HotKeyManager1.ClearHotKeys;
    Listview1.Items.Clear;
  end;//if
end;


procedure ShowDesktop(const YesNo : boolean) ;
var
  h : THandle;
  rc: boolean;
begin
  h := FindWindow('ProgMan', nil) ;
  h := GetWindow(h, GW_CHILD) ;
  if YesNo = True then
    rc := ShowWindow(h, SW_SHOW)
  else
    rc := ShowWindow(h, SW_HIDE) ;
  if rc then
    messagebeep(0);
end;

procedure TMainForm.HotKeyManager1HotKeyPressed(HotKey: Cardinal; Index: Word);
var
  s: string;
  LErrorCode: Word;
begin
  //SetForegroundWindow(Application.Handle);
  //MessageDlg('Hotkey ' + HotKeyToText(HotKey, LOCALIZED_KEYNAMES) + ' pressed.', mtInformation, [mbOk], 0);
  //MessageDlg(HotKeyManager1.GetCommand(Index), mtInformation, [mbOk], 0);
  s := HotKeyManager1.GetCommand(Index);
  if Pos(' ',s) <> 0 then s := '"'+s+'"';

//  LErrorCode := Windows.WinExec(s,SW_SHOWNORMAL);
  ShellExecuteW(0, 'open', PChar(s), nil, nil, SW_SHOW);


//  case LErrorCode of
//    0:ShowMessage('The system is out of memory or resources.');
//    ERROR_BAD_FORMAT:	ShowMessage('The .EXE file is invalid (non-Win32 .EXE or error in .EXE image).');
//    ERROR_FILE_NOT_FOUND:	ShowMessage('The specified file was not found.');
//    ERROR_PATH_NOT_FOUND:	ShowMessage('The specified path was not found.');
//  end;
end;

procedure TMainForm.GetPotentialKeys;

  procedure AddKeys(Min, Max: Word);
  var
    I: Integer;
    KeyName: String;
  begin
    for I := Min to Max do
    begin
      KeyName := HotKeyToText(I, LOCALIZED_KEYNAMES);
//      if KeyName <> '' then
//        ComboBox1.Items.AddObject(KeyName, TPotentialKey.Create(I));
    end;
  end;

begin
  // Add standard keys
//  AddKeys($08, $09);
//  AddKeys($0D, $0D);
//  AddKeys($14, $91);
//  AddKeys($BA, $FF);
//  // Add extended keys
//  AddKeys(_VK_BROWSER_BACK, _VK_LAUNCH_APP2);
//  if ComboBox1.Items.Count > 0 then
//    ComboBox1.ItemIndex := 0;
end;

procedure TMainForm.btnCancelClick(Sender: TObject);
begin
  hide;
end;

procedure TMainForm.SaveLVData2Registry(lv: TListView);
var
  SubPath : string;
  i: integer;
begin
  //만약 삭제한 키가 있다면 먼저 해당키를 Registry에서 삭제함.
  for i := 0 to FDeletedItemList.Count - 1 do
  begin
    SubPath := FDeletedItemList.Strings[i];
    if DeleteRegistryKeyWithSubKey(fRegPathManager.RootHKEY, SubPath) then
      ShowMessage(FDeletedItemList.Strings[i] + ' 삭제 성공 !');
  end;//for

  //삭제한 키 리스트를 없앰
  FDeletedItemList.Clear;

  if lv.Items.Count <= 0 then
    exit;

  with TRegistry.Create do
  begin
    RootKey := fRegPathManager.RootHKEY;

    for i := 0 to Listview1.Items.Count -1 do
    begin
      SubPath := fRegPathManager.SubPath + '\' + Listview1.Items[i].Caption;

      if OpenKey(SubPath, True) then
      begin
        WriteBool(Listview1.Items[i].SubItems.Strings[0],Listview1.Items.Item[i].Checked);
        CloseKey;
      end;//if
    end;//for

    Free;
    ShowMessage('환경설정값 저장 완료!!!');
  end;//with
end;

function TMainForm.DeleteRegistryKeyWithSubKey(const RootKey: HKEY;
  const Key: string): Boolean;
var
  RegKey: HKEY;
  I: DWORD;
  Size: DWORD;
  NumSubKeys: DWORD;
  MaxSubKeyLen: DWORD;
  KeyName: string;
begin
  Result := RegOpenKeyEx(RootKey, RelativeKey(Key), 0, KEY_ALL_ACCESS, RegKey) = ERROR_SUCCESS;
  if Result then
  begin
    RegQueryInfoKey(RegKey, nil, nil, nil, @NumSubKeys, @MaxSubKeyLen, nil, nil, nil, nil, nil, nil);
    if NumSubKeys <> 0 then
      for I := NumSubKeys-1 downto 0 do
      begin
        Size := MaxSubKeyLen+1;
        SetLength(KeyName, Size);
        RegEnumKeyEx(RegKey, I, PChar(KeyName), Size, nil, nil, nil, nil);
        SetLength(KeyName, StrLen(PChar(KeyName)));
        Result := DeleteRegistryKeyWithSubKey(RootKey, Key + '\' + KeyName);
        if not Result then
          Break;
      end;
    RegCloseKey(RegKey);
    if Result then
      Result := Windows.RegDeleteKey(RootKey, RelativeKey(Key)) = ERROR_SUCCESS;
  end
  else
    ;//ShowMessage('레지스트리 삭제 에러!');
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
  SaveLVData2Registry(Listview1);
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
begin
  //CoolMainForm.Show;
end;

procedure TMainForm.GetRegistryKey2ListView(Path: String);
var
  RegPathManager   : TajRegPathManager;
  KeyNameList: TStringList;
  KeyValueNameList : TStringList;
  i,j: integer;
  SubPath: string;
  LChecked: Boolean;
begin
  try
    ListView1.Clear;
    HotKeyManager1.ClearHotKeys;

    KeyNameList := TStringList.Create;
    KeyNameList.Sorted  := true;
    KeyNameList.BeginUpdate;

    KeyValueNameList := TStringList.Create;

    RegPathManager := TajRegPathManager.Create;
    RegPathManager.FullPath := Path;

    with TRegistry.Create do
    begin
      RootKey := RegPathManager.RootHKEY;
      OpenKeyReadOnly(RegPathManager.SubPath);
      GetKeyNames(KeyNameList);
      CloseKey;

      KeyNameList.EndUpdate;

      for i := 0 to KeyNameList.Count - 1 do
      begin
        RootKey := fRegPathManager.RootHKEY;
        OpenKeyReadOnly(RegPathManager.SubPath + '\' + KeyNameList.Strings[i]);
        GetValueNames(KeyValueNameList);
        //GetRegKeyValueNames(RegPathManager.SubPath + '\' + KeyNameList.Strings[i],KeyValueNameList);

        for j := 0 to KeyValueNameList.Count -  1 do
        begin
          LChecked := ReadBool(KeyValueNameList.Strings[j]);

          with Listview1.Items.Add do
          begin
            Checked := LChecked;
            Caption := KeyNameList.Strings[i];
            SubItems.Add(KeyValueNameList.Strings[j]);
            AddHotKeyFromRegistry(Caption, Checked,KeyValueNameList.Strings[j]);
          end;//with
        end;//for

        KeyValueNameList.Clear;
        CloseKey;

      end;//for

      Free;
    end; {with}


  finally
    FreeAndNil(KeyValueNameList);
    FreeAndNil(RegPathManager);
    FreeAndNil(KeyNameList);
  end;//try
end;

procedure TMainForm.btnUpdateClick(Sender: TObject);
begin
  GetRegistryKey2ListView(REGISTRY_FULLPATH);
end;

procedure TMainForm.GetRegKeyValueNames(SubPath: string;
  KeyValueNameList: TStringList);
begin
  KeyValueNameList.Sorted := true;
  KeyValueNameList.BeginUpdate;

  with TRegistry.Create do
  begin
    RootKey := fRegPathManager.RootHKEY;
    OpenKeyReadOnly(SubPath);
    GetValueNames(KeyValueNameList);
    CloseKey;
    Free;
  end; {with}

  KeyValueNameList.EndUpdate;
end; {GetRegKeyValueNames}

procedure TMainForm.AddHotKeyFromRegistry(AHotKey: String; AChecked: Boolean; AFunction: string);
var
  HotKeyVar: Cardinal;
  Modifiers: Word;
  PotentialKey: TPotentialKey;
begin
  HotKeyVar := TextToHotkey(AHotKey,LOCALIZED_KEYNAMES);
  if AChecked then
    HotKeyManager1.AddHotKey(HotKeyVar,AFunction)
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  GetRegistryKey2ListView(REGISTRY_FULLPATH);
  TrayIcon1.IconList := ImageList2;
  TrayIcon1.CycleInterval := 400;
  TrayIcon1.CycleIcons := True;
end;

procedure TMainForm.N1Click(Sender: TObject);
begin
  application.Restore;
  ShowWindow(Application.Handle, SW_HIDE);
  Show;
end;

procedure TMainForm.N3Click(Sender: TObject);
begin
  application.Terminate;
end;

procedure TMainForm.TrayIcon1BalloonHintClick(Sender: TObject);
begin
  SetForegroundWindow(Application.Handle);  // Move focus from tray icon to this form
  ShowMessage('POP!');
end;

procedure TMainForm.TrayIcon1DblClick(Sender: TObject);
begin
  application.Restore;
  ShowWindow(Application.Handle, SW_HIDE);
  Show;
end;

end.

