unit HKOptConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ExtCtrls, StdCtrls, Buttons, Menus, Registry,CommCtrl,
  ajAlterMenu, ajRegPathManager, ValueEdit;

const
  cMyRegistry     = 0;
  cClosedPage     = 1;
  cOpenPage       = 2;
  cClosedBook     = 3;
  cOpenBook       = 4;
  cDateValue      = 5;
  cStringValue    = 6;
  cBinaryValue    = 7;
  cAddBookmark    = 10;
  cRemoveBookmark = 11;

  DEFAULT_NODE_NAME = '노드1';
  REGISTRY_FULLPATH = 'HKCU\software\JHPark\HotKey\HotKey_List';
  {................................................................................................}

  cNumRegValType  = 11; // Number of type supported.
  cRegValTypeLookUp : array[0..pred(cNumRegValType)] of record
    Description : string;
    Value       : DWORD;
  end = ((Description : 'REG_NONE';                       Value : REG_NONE),
         (Description : 'REG_SZ';                         Value : REG_SZ),
         (Description : 'REG_EXPAND_SZ';                  Value : REG_EXPAND_SZ),
         (Description : 'REG_BINARY';                     Value : REG_BINARY),
         (Description : 'REG_DWORD';                      Value : REG_DWORD),
         (Description : 'REG_DWORD_BIG_ENDIAN';           Value : REG_DWORD_BIG_ENDIAN),
         (Description : 'REG_LINK';                       Value : REG_LINK),
         (Description : 'REG_MULTI_SZ';                   Value : REG_MULTI_SZ),
         (Description : 'REG_RESOURCE_LIST';              Value : REG_RESOURCE_LIST),
         (Description : 'REG_FULL_RESOURCE_DESCRIPTOR';   Value : REG_FULL_RESOURCE_DESCRIPTOR),
         (Description : 'REG_RESOURCE_REQUIREMENTS_LIST'; Value : REG_RESOURCE_REQUIREMENTS_LIST));

type
  TRegBuffer  = record
    case integer of
      0 : (BuffChars  : array[0..1023] of char);
      1 : (BuffWord   : Cardinal);
      2 : (BuffReal   : Real);
    end;

  //Registry Value를 저장하기 위한 Record
  PRegValue = ^TRegValue;
  TRegValue = record
    sName: string;
    dwType: DWORD;
    tData: TRegBuffer;
    ImageIndex: integer;
  end;

type
  TControlConfigF = class(TForm)
    pnToolbar: TPanel;
    btnCancel: TSpeedButton;
    btnUpdate: TSpeedButton;
    Bevel2: TBevel;
    pnRegPath: TPanel;
    edRegPath: TEdit;
    pnBack: TPanel;
    Splitter: TSplitter;
    tvRegistry: TTreeView;
    lvRegistry: TListView;
    StatusBar: TStatusBar;
    imTreeView: TImageList;
    imButtons: TImageList;
    MainMenu: TMainMenu;
    mnuRegistry: TMenuItem;
    mnuUpdate: TMenuItem;
    N1: TMenuItem;
    mnuExit: TMenuItem;
    mnuOptions: TMenuItem;
    mnuRefresh: TMenuItem;
    N2: TMenuItem;
    mnuAddGUID: TMenuItem;
    mnuView: TMenuItem;
    mnuXPMenu: TMenuItem;
    mnuAbout: TMenuItem;
    tvPopupMenu: TPopupMenu;
    mnuPopAddKey: TMenuItem;
    mnuPopDeleteKey: TMenuItem;
    lvPopupMenu: TPopupMenu;
    mnuNewValue: TMenuItem;
    mnuString: TMenuItem;
    mnuBinary: TMenuItem;
    mnuDWORD: TMenuItem;
    mnuDeleteValue: TMenuItem;
    mnuEditValue: TMenuItem;
    ChangeName1: TMenuItem;
    SpeedButton1: TSpeedButton;
    ChgKeyNameEdit: TEdit;
    N3: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuXPMenuClick(Sender: TObject);
    procedure mnuPopAddKeyClick(Sender: TObject);
    procedure tvRegistryMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuExitClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure tvRegistryDeletion(Sender: TObject; Node: TTreeNode);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tvRegistryChange(Sender: TObject; Node: TTreeNode);
    procedure ChangeName1Click(Sender: TObject);
    procedure ChgKeyNameEditExit(Sender: TObject);
    procedure ChgKeyNameEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure lvRegistryDblClick(Sender: TObject);
    procedure mnuPopDeleteKeyClick(Sender: TObject);
  private
    FajAlterMenu : TajAlterMenu;
    FRootNode : TTreeNode;
    FCurrentNode: TTreeNode;
    FRegPathManager   : TajRegPathManager;

    FRegValueList: TList;
    //TreeView에서 삭제한 키값을 보유해서 레지스트리에 적요시킴
    FDeletedItemList: TStringList;

    //Change Key Name에서 Edit Exit시에 참조하기 위해 사용
    FTempNode: TTreeNode;

    FModalResult: Integer;
    FFirstNodeString: string;
  protected
    Procedure tvRegistryinit(AFirstNodeString: string);

    procedure AddListNames          (Node: TTreeNode);
    function  GetValueString(BuffType: DWORD; Value:TRegBuffer ): string;
    procedure GetRegKeyValueNames   (SubPath : string; KeyValueNameList: TStringList);

    procedure GetRegistryWithSubKey(Node: TTreeNode; Path: String);
    Procedure AddKeyName2TreeObject(SubPath:string;Node:TTreeNode;List:TStrings);
    function DeleteRegistryKeyWithSubKey(const RootKey: HKEY;
                                                    const Key: string): Boolean;

    procedure GetRegValue2Var(Path, ValueName: String; RegVal: pRegValue);
    procedure SetEditValue2Var(var pRegVal: PRegValue; Data: String);
    function  SetDefaultValue2Var(Node: TTreeNode; NameList: TStringList;
                              NodeName: String; NodeImage: Boolean): TTreeNode;
    procedure DeleteTreeViewObject(tv: TTreeView);
    procedure DeleteNodeObject(Node: TTreeNode);

    procedure ChangeKeyName(Node: TTreeNode);
    procedure ApplyChangedKeyName2Node(NewName: String; Node: TTreeNode);
    Procedure SaveTVData2Registry(tv:TTreeView);

    procedure AddKey(Node: TTreeNode);
    procedure EditRegistryValue;
  public
    procedure StartConfig;
  end;

var
  ControlConfigF: TControlConfigF;

implementation

uses ajRegistry;

{$R *.dfm}

{--------------------------------------------------------------------------------------------------}
{                             Miscellaneous FileTime Functions                                     }
{--------------------------------------------------------------------------------------------------}
function RelativeKey(const Key: string): PChar;
begin
  Result := PChar(Key);
  if (Key <> '') and (Key[1] = '\') then
    Inc(Result);
end;

function GetNodePath(Node : TTreeNode) : string;
// Iterate from the node to the root building up the path string.
begin
  Result  := Node.Text;
  while (Node.Level > 1) do begin
    Node    := Node.Parent;
    Result  := Node.Text + '\' + Result;
  end; {while}
end; {GetNodePath}

procedure SetNodeImages(Node : TTreeNode; HasChildren : boolean);
begin
  if HasChildren then begin
    Node.HasChildren    := true;
    Node.ImageIndex     := cClosedBook;
    Node.SelectedIndex  := cOpenBook;
  end else begin
    Node.ImageIndex     := cClosedPage;
    Node.SelectedIndex  := cOpenPage;
  end; {if}
end; {SetNodeImages}

function FileTimeToDateTime(FileTime : TFileTime) : TDateTime;
// Convert FileTime to TDateTime.
var
  SystemTime  : TSystemTime;
begin
  FileTimeToLocalFileTime(FileTime, FileTime);
  FileTimeToSystemTime(FileTime, SystemTime);
  Result  := SystemTimeToDateTime(SystemTime);
end; {FileTimeToDateTime}

Function Str2Real(Str:string):real;
var
  code : integer;
  Temp : real;
begin
    If length(Str)=0 then Result:=0
    else begin
       If Copy(Str,1,1)='.' Then Str:='0'+Str;
       If (Copy(Str,1,1)='-') and (Copy(Str,2,1)='.') Then Insert('0',Str,2);
       If Str[length(Str)]='.' then Delete(Str,length(Str),1);
       val(Str,temp,code);
       if code=0 then Result:=temp
       else Result:=0;
    end;
end;

procedure TControlConfigF.FormCreate(Sender: TObject);
begin
  FRegPathManager := TajRegPathManager.Create;  // Create the path manager.
  fRegPathManager.FullPath := REGISTRY_FULLPATH;
  FajAlterMenu := TajAlterMenu.Create(Self);

  FRegValueList := TList.Create;
  FDeletedItemList := TStringList.Create;

  tvRegistryInit(FFirstNodeString);

  FModalResult := mrCancel;
  FFirstNodeString := 'aaa';
end;

procedure TControlConfigF.FormDestroy(Sender: TObject);
var i: integer;
begin
  FajAlterMenu.Free;
  FRegPathManager.Free;  // the path manager.
  for i := 0 to FRegValueList.Count -1 do
    TList(FRegValueList.Items[i]).Free;

  FDeletedItemList.Free;
  FRegValueList.Free;
end;

procedure TControlConfigF.mnuXPMenuClick(Sender: TObject);
// Set XP menu styles.
begin
  with Sender as TMenuItem do begin
    Checked               := not Checked;
    fajAlterMenu.Enabled  := Checked;
  end; {with}
end;

procedure TControlConfigF.mnuPopAddKeyClick(Sender: TObject);
begin
  AddKey(tvRegistry.Selected);
end;

procedure TControlConfigF.tvRegistryMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if tvRegistry.Selected = nil then Exit;
  if (Button = mbRight) then
    tvRegistry.Selected :=  tvRegistry.GetNodeAt(X, Y);
end;

procedure TControlConfigF.mnuExitClick(Sender: TObject);
begin
  Close;
end;

//선택한 Node의 내용을 ListBox에 추가한다.
procedure TControlConfigF.AddListNames(Node: TTreeNode);
var
  ListItem    : TListItem;
  CurItem : TTreeNode;
  pRegVal : PRegValue;
  TmpList : TList;
  i       : integer;
begin
  with lvRegistry.Items do
  begin
    Clear;

    CurItem := Node;
    if CurItem <> nil then
    begin

      if Assigned(CurItem.Data) then
      begin
        TmpList := CurItem.Data;
        for i := 0 to TmpList.Count - 1 do
        begin
          ListItem  := Add;
          with ListItem do
          begin
            pRegVal := TmpList.Items[i];
            Caption := pRegVal.sName;
            ImageIndex  := pRegVal.ImageIndex;
            SubItems.Add(cRegValTypeLookUp[pRegVal.dwType].Description);
            SubItems.Add(GetValueString(pRegVal.dwType, pRegVal.tData));
          end;//with
        end;//for
      end;//if

      CurItem := CurItem.GetNext;
    end;//if
  end; {with}
end; {AddListNames}

function TControlConfigF.GetValueString(BuffType: DWORD;Value:TRegBuffer): string;
var i: integer;
    BuffSize,
    LongWordVal: DWORD;
begin
  Result := '';

  BuffSize := SizeOf(Value.BuffChars);

  case BuffType of
    REG_NONE, REG_BINARY, REG_MULTI_SZ, REG_RESOURCE_LIST, REG_FULL_RESOURCE_DESCRIPTOR
      : begin
        if ( BuffSize = 0) then
          Result := '(zero-length binary value)'
        else
        begin
          Result := '';
          for i := 0 to pred(BuffSize) do
            Result := Result + IntToHex(ord(Value.BuffChars[i]), 2) + ' ';
          Result := Trim(LowerCase(Result));
        end; {if}
      end;

      REG_SZ, REG_EXPAND_SZ
        : Result := Value.BuffChars;
      REG_DWORD, REG_DWORD_BIG_ENDIAN
        : begin
          LongWordVal := Value.BuffWord;
          Result := IntToStr(LongWordVal);
          //Result := '0x' + LowerCase(IntToHex(LongWordVal, 8)) + ' (' + IntToStr(LongWordVal) + ')';
        end;
    else
      Result := 'ERROR - VALUE NOT READ';
  end; {case}
end;

procedure TControlConfigF.GetRegKeyValueNames(SubPath: string; KeyValueNameList: TStringList);
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

//Registry에서 Path에 해당하는 키의 모든 하위 키를 Node에 저장함
//처음 Call할떄 Node = FRootNode 대입
procedure TControlConfigF.GetRegistryWithSubKey(Node: TTreeNode; Path: String);
var
  KeyValueNameList,
  KeyNameList: TStringList;
  i: integer;
  Node1: TTreeNode;
  RegPathManager   : TajRegPathManager;
begin
  KeyNameList := TStringList.Create;
  KeyNameList.Sorted  := true;
  KeyNameList.BeginUpdate;

  RegPathManager := TajRegPathManager.Create;

  RegPathManager.FullPath := Path;

  with TRegistry.Create do
  begin
    RootKey := RegPathManager.RootHKEY;
    OpenKeyReadOnly(RegPathManager.SubPath);
    GetKeyNames(KeyNameList);
    CloseKey;
    Free;
  end; {with}

  KeyNameList.EndUpdate;

  //key값의 속성을 TreeObject에 저장함
  if KeyNameList.Count > 0 then
    AddKeyName2TreeObject(RegPathManager.FullPath,Node,KeyNameList);

  Node1 := Node.getFirstChild;

  //재귀호출로 하위 키들에 대한 값들 처리
  for i := 0 to KeyNameList.Count - 1 do
  begin
    GetRegistryWithSubKey(Node1, RegPathManager.FullPath+ '\'+KeyNameList[i]);
    Node1 := Node.GetNextChild(Node1);
  end;

  RegPathManager.Free;
  KeyNameList.Free;
end;

procedure TControlConfigF.AddKeyName2TreeObject(SubPath:string;Node:TTreeNode;List:TStrings);
var
  lp1   : integer;
  i,j   : integer;
  Node1 : TTreeNode;
  str1  : string;
  pRegVal: PRegValue;
  KeyValueNameList : TStringList;
begin
  KeyValueNameList := TStringList.Create;

  try
    tvRegistry.Items.BeginUpdate;
    with tvRegistry.Items do
    begin
      for lp1 := 0 to pred(List.Count) do
      begin
        str1 := fRegPathManager.FullPath;
        fRegPathManager.FullPath  := SubPath + '\' + List[lp1];
        //TreeView의 이미지 설정(+, -)
        //List에 Value name List 가져옴
        GetRegKeyValueNames(fRegPathManager.Subpath,KeyValueNameList);

        j := FRegValueList.Add(TList.Create);
        //Value Name 갯수만큼 TRegVal에 저장
        for i := 0 to pred(KeyValueNameList.Count) do
        begin
          New(pRegVal);
          GetRegValue2Var(fRegPathManager.Subpath,KeyValueNameList[i],pRegVal);
          TList(FRegValueList.Items[j]).Add(pRegVal);
        end; //for

        //TreeView Node애 Data 저장
        Node1 := AddChildObject(Node, List[lp1], FRegValueList.Items[j]);
        SetNodeImages(Node1, (RegNumSubKeys(fRegPathManager.RootHKEY,
                                                fRegPathManager.SubPath)) > 0);
        fRegPathManager.FullPath := str1;
      end;
    end; {with}

    tvRegistry.Items.EndUpdate;
  finally
    KeyValueNameList.Free;
  end; //try
end;

//Registry의 키를 삭제한다. SubKey도 함께 삭제됨.
//JclRegistry에서 발췌
function TControlConfigF.DeleteRegistryKeyWithSubKey(const RootKey: HKEY;
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

procedure TControlConfigF.btnUpdateClick(Sender: TObject);
begin
  StartConfig;
end;

procedure TControlConfigF.tvRegistryinit(AFirstNodeString: string);
begin
  tvRegistry.Items.Clear;
  FRootNode := tvRegistry.Items.Add(nil, AFirstNodeString);
  FCurrentNode := FRootNode;
  FRootNode.ImageIndex  := 0;
end;

//Registry Value를 TRegValue 변수에 대입한다.
procedure TControlConfigF.GetRegValue2Var(Path, ValueName: String; RegVal: pRegValue);
var
  BuffType    : DWORD;
  BuffSize	  : DWORD;
  Key         : HKEY;
  ImgIndex    : integer;
begin
  //Registry Open
  if (RegOpenKeyEx(fRegPathManager.RootHKEY, PChar(Path), 0,
                                    KEY_QUERY_VALUE, Key) = ERROR_SUCCESS) then
  begin
    BuffSize    := SizeOf(RegVal.tData.BuffChars);

    if (RegQueryValueEx(Key,PChar(ValueName),nil,@BuffType,
                    @(RegVal.tData.BuffChars),@BuffSize) = ERROR_SUCCESS) then
    begin
      RegVal.sName := ValueName;
      RegVal.dwType := BuffType;

      case BuffType of
        REG_NONE, REG_BINARY, REG_MULTI_SZ, REG_RESOURCE_LIST,
        REG_FULL_RESOURCE_DESCRIPTOR
          : begin
            ImgIndex  := cBinaryValue;
          end;
        REG_DWORD, REG_DWORD_BIG_ENDIAN
          : begin
            ImgIndex  := cBinaryValue;
          end;
      end; //case}
    end else
    begin
      //Error 인경우 이곳에
    end;//if
      RegVal.ImageIndex := ImgIndex;
  end;//if
end;

function TControlConfigF.SetDefaultValue2Var(Node: TTreeNode; NameList: TStringList;
                              NodeName: String; NodeImage: Boolean): TTreeNode;
var
  i,j: integer;
  Node1: TTreeNode;
  pRegVal: PRegValue;
begin
  Result := nil;

  j := FRegValueList.Add(TList.Create);

  //Value Name 갯수만큼 TRegVal에 저장
  for i := 0 to pred(NameList.Count) do
  begin
    New(pRegVal);

    with PRegValue(pRegVal)^ do
    begin
      sName := NameList.Strings[i];
      dwType := REG_DWORD;
      ImageIndex := cBinaryValue;
      tData.BuffWord := 0;
    end;//with

    TList(FRegValueList.Items[j]).Add(pRegVal);
  end; //for

  //TreeView Node애 Data 저장
  Node1 := tvRegistry.Items.AddChildObject(Node, NodeName,
                                                        FRegValueList.Items[j]);
  SetNodeImages(Node1, NodeImage);

  Result := Node1;
end;

procedure TControlConfigF.DeleteTreeViewObject(tv: TTreeView);
var
  CurItem : TTreeNode;
  pRegVal : PRegValue;
  TmpList : TList;
  i       : integer;
begin
  CurItem := tv.Items.GetFirstNode;
  while CurItem <> nil do
  begin
    if Assigned(CurItem.Data) then
    begin
      TmpList := CurItem.Data;
      for i := 0 to TmpList.Count - 1 do
      begin
        pRegVal := TmpList.Items[i];
        Dispose(pRegVal);
        pRegVal := nil;
      end;//for
    end;//if
    CurItem.Data := nil;
    CurItem := CurItem.GetNext;
  end;//while
end;

//키보드로 키를 삭제할 경우에 객체를 처리하는 함수.
procedure TControlConfigF.DeleteNodeObject(Node: TTreeNode);
var
  tmpNode : TTreeNode;
  tmpList : TList;
  i       : integer;
  pRegVal : PRegValue;
begin
  tmpNode := Node;

  if Assigned(tmpNode.Data) then
  begin
    TmpList := tmpNode.Data;
    for i := 0 to TmpList.Count - 1 do
    begin
      pRegVal := TmpList.Items[i];
      Dispose(pRegVal);
      pRegVal := nil;
    end;//for
  end;//if

  tmpNode.Data := nil;
end;

procedure TControlConfigF.tvRegistryDeletion(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node.Data) then
  begin
    //Dispose(Node.Data);
    DeleteNodeObject(Node);
  end;
end;

procedure TControlConfigF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DeleteTreeViewObject(tvRegistry);
  ModalResult := FModalResult;
end;

//Key Name을 변경선택할 때마다 변경된 Node의 값을 ListBox에 뿌려줌
procedure TControlConfigF.tvRegistryChange(Sender: TObject; Node: TTreeNode);
begin
  FCurrentNode := Node;
  AddListNames(Node);
end;

procedure TControlConfigF.ChangeKeyName(Node: TTreeNode);
var
  Noderect,
  EditRect : TRect;
  Point: TPoint;
begin
  With Node do
  begin
    ChgKeyNameEdit.Text := Text;
    FTempNode := Node;    //Edit Exit시에 참조함

    NodeRect := DisplayRect(True);
    Point := Self.ScreenToClient(ClientToScreen(NodeRect.TopLeft));
    ChgKeyNameEdit.Top := Point.Y;
    ChgKeyNameedit.Left := Point.X;
    ChgKeyNameEdit.Show;
    ChgKeyNameEdit.SetFocus;
  end;//with
end;

procedure TControlConfigF.ChangeName1Click(Sender: TObject);
begin
  ChangeKeyName(tvRegistry.Selected);
end;

procedure TControlConfigF.ChgKeyNameEditExit(Sender: TObject);
begin
  ApplyChangedKeyName2Node(ChgKeyNameEdit.Text, FTempNode);
  ChgKeyNameEdit.Hide;
end;

procedure TControlConfigF.ApplyChangedKeyName2Node(NewName: String; Node: TTreeNode);
begin
  if NewName <> '' then
  begin
    if Node.Text <> NewName then
      Node.Text := NewName;
  end
  else
    ShowMessage('변경하려는 이름이 공란이면 안됩니다.');
end;

procedure TControlConfigF.ChgKeyNameEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = ord(#13) then
    ChgKeyNameEditExit(self);
end;

//TreeView의 데이타를 읽어서 Registry에 저장함.
procedure TControlConfigF.SaveTVData2Registry(tv: TTreeView);
var
  CurItem : TTreeNode;
  pRegVal : PRegValue;
  TmpList : TList;
  i       : integer;
  SubPath : string;
  tmpstr  : string;
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

  with TRegistry.Create do
  begin
    RootKey := fRegPathManager.RootHKEY;

    CurItem := tv.Items.GetFirstNode;

    while CurItem <> nil do
    begin
      //'Dynamo 제어' Node는 Registry에 없음
      if CurItem.Level = 0 then
      begin
        CurItem := CurItem.GetNext;
        Continue;
      end;

      SubPath := fRegPathManager.SubPath + '\' + GetNodePath(CurItem);

      if OpenKey(SubPath, True) then
      begin
        //노드에 저장된 Data값 중에서 새로운 값이 있는지 Check함
        if Assigned(CurItem.Data) then
        begin
          TmpList := CurItem.Data;
          for i := 0 to TmpList.Count - 1 do
          begin
            pRegVal := TmpList.Items[i];

            case pRegVal.dwType of
              REG_NONE, REG_BINARY, REG_MULTI_SZ, REG_RESOURCE_LIST,
              REG_FULL_RESOURCE_DESCRIPTOR
              : begin
                ;//WriteBinary;
              end;

              REG_SZ, REG_EXPAND_SZ
              :begin
                tmpStr := String(pRegVal.tData.BuffChars);
                WriteString(pRegVal.sName,tmpStr);
              end;

              REG_DWORD, REG_DWORD_BIG_ENDIAN
              : WriteInteger(pRegVal.sName, pRegVal.tData.BuffWord);
            end;//case
          end;//for
        end;//if
      end;//if

      CloseKey;

      CurItem := CurItem.GetNext;

    end; {while}
    Free;

    ShowMessage('환경설정값 저장 완료!!!');
  end; {with}
end;

procedure TControlConfigF.SpeedButton1Click(Sender: TObject);
begin
  SaveTVData2Registry(tvRegistry);
  FModalResult := mrOK;
end;

procedure TControlConfigF.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TControlConfigF.AddKey(Node: TTreeNode);
var
  Node0 : TTreeNode;
  Node1 : TTreeNode;
  Node2 : TTreeNode;
  Node3 : TTreeNode;
  NameList: TStringList;
begin
  Node1 := nil;

  NameList := TStringList.Create;

  try
    if Node.Level = 0 then
    begin
      if Node.HasChildren then
      begin
        ShowMessage('저주기 피로시험 외에는 다른 기능추가 안됨'+#10#13+'추후 기능 추가 예정');
        exit;
      end;

      NameList.Add('반복회수');
      NameList.Add('스텝수');
      NameList.Add('시작시간');
      NameList.Add('실행하기');
      NameList.Add('간격조정시간');
      Node0 := SetDefaultValue2Var(Node,NameList,'저주기 피로 시험',True);
    end;//if


    if Node.Level = 1 then
    begin
      NameList.Clear;
      NameList.Add('목표값');
      NameList.Add('목표값 도달방법');
      NameList.Add('상한오차값');
      NameList.Add('실행순서');
      NameList.Add('지속시간(mSec)');
      NameList.Add('초기값');
      NameList.Add('하한오차값');
      NameList.Add('HIGH 상한오차값');
      NameList.Add('LOW 하한오차값');
      NameList.Add('스텝간격조정시간');
      NameList.Add('EX 스텝간격조정시간');
      Node1 := SetDefaultValue2Var(Node,NameList,DEFAULT_NODE_NAME,True);
    end;

    if Assigned(Node1) then
    begin
      NameList.Clear;
      NameList.Add('목표값(x10)');
      NameList.Add('초기값(x10)');
      NameList.Add('간격');
      NameList.Add('EX 간격');
      Node2 := SetDefaultValue2Var(Node1,NameList,'InLet Valve', False);
      Node3 := SetDefaultValue2Var(Node1,NameList,'OutLet Valve', False);
      ChangeKeyName(Node1);
    end;

  finally
    NameList.Free;
    NameList := nil;
  end;//try
end;

procedure TControlConfigF.lvRegistryDblClick(Sender: TObject);
begin
  EditRegistryValue;
end;

procedure TControlConfigF.EditRegistryValue;
var
  EditItem : TListItem;
  Vef: TValueEditForm;
  pRegVal : PRegValue;
  pch: PChar;
  TmpList : TList;
  i: integer;
begin
  Vef := nil;
  Vef := TValueEditForm.Create(Self);
  try
    with Vef do
    begin
      EditItem := lvRegistry.Selected;
      NameEdit.Text := EditItem.Caption;
      ValueEdit.Text := EditItem.SubItems[1];
      if ShowModal = mrOK then
      begin
        TmpList := FCurrentNode.Data;
        for i := 0 to TmpList.Count - 1 do
        begin
          pRegVal := TmpList.Items[i];
          if pRegVal.sName = NameEdit.Text then
          begin
            SetEditValue2Var(pRegVal, ValueEdit.Text);
            Break;
          end;//if
        end;//for

        //Value 이름은 바뀔수 없음
        EditItem.SubItems[1] := ValueEdit.Text;
      end;
    end;//with
  finally
    Vef.Free;
    Vef := nil;
  end;//try
end;

//ListBox에서 Value를 수정할 경우 그 값(String Type)을 변수에 저장함
procedure TControlConfigF.SetEditValue2Var(var pRegVal: PRegValue; Data: String);
var pch: PChar;
begin
  case pRegVal.dwType of
    REG_NONE, REG_BINARY, REG_MULTI_SZ, REG_RESOURCE_LIST,
    REG_FULL_RESOURCE_DESCRIPTOR
      :begin
        pRegVal.tData.BuffReal := Str2Real(Data);
      end;

    REG_SZ, REG_EXPAND_SZ
      :begin
        pch := @pRegVal.tData.BuffChars;
        StrPCopy(pch,Data);
      end;

    REG_DWORD, REG_DWORD_BIG_ENDIAN
      :pRegVal.tData.BuffWord := StrToInt(Data);
  end;//case
end;

procedure TControlConfigF.mnuPopDeleteKeyClick(Sender: TObject);
begin
  if (tvRegistry.Selected.Level = 0) or (tvRegistry.Selected.Level = 1) then
  begin
    ShowMessage('이 항목은 지울 수 없습니다!');
    exit;
  end;
  
  if (MessageDlg(tvRegistry.Selected.Text + ' 키를 지우시겠습니까? ' +#13#10#10, mtWarning, [mbYes, mbNo], 0) = mrYes) then
  begin
    FDeletedItemList.Add(fRegPathManager.SubPath + '\' + GetNodePath(tvRegistry.Selected));
    tvRegistry.Selected.DeleteChildren;
    tvRegistry.Selected.Delete;
  end;
end;

//편집 시작
procedure TControlConfigF.StartConfig;
begin
  tvRegistryinit(FFirstNodeString);

  GetRegistryWithSubKey(FRootNode, FRegPathManager.FullPath);
  FRootNode.Expand(True);
end;

end.
