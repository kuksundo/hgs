unit UViewMailList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.XPStyleActnCtrls, Vcl.ActnMan, Vcl.ComCtrls, Vcl.Buttons, PngBitBtn,
  Vcl.StdCtrls, Vcl.ToolWin, Vcl.ActnCtrls, Vcl.ExtCtrls, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  AdvOfficeTabSet, System.Rtti, DateUtils,
  CommonData, DragDrop, DropTarget, UElecDataRecord, SynCommons, mORMot,
  Vcl.Menus, FrmEditEmailInfo;

type
  TViewMailListF = class(TForm)
    mailPanel1: TPanel;
    tabMail: TTabControl;
    StatusBar: TStatusBar;
    panMailButtons: TPanel;
    btnStartProgram: TBitBtn;
    btnCheckAll: TPngBitBtn;
    btnToTray: TPngBitBtn;
    panProgress: TPanel;
    btnStop: TSpeedButton;
    Progress: TProgressBar;
    ActionManager: TActionManager;
    actPreview: TAction;
    actDelete: TAction;
    actNewMail: TAction;
    actReply: TAction;
    actCheck: TAction;
    actNoSort: TAction;
    actShowMessages: TAction;
    actCheckAll: TAction;
    actStartProgram: TAction;
    actAutoCheck: TAction;
    actOptions: TAction;
    actRules: TAction;
    actAbout: TAction;
    actHelp: TAction;
    actQuit: TAction;
    actToTray: TAction;
    actCustomize: TAction;
    actHideViewed: TAction;
    actAddWhiteList: TAction;
    actAddBlackList: TAction;
    actRuleFromDelete: TAction;
    actRuleFromSpam: TAction;
    actRuleSubjectDelete: TAction;
    actRuleSubjectSpam: TAction;
    actMarkViewed: TAction;
    actMarkSpam: TAction;
    actDeleteSpam: TAction;
    actUnmarkSpam: TAction;
    actSelectSpam: TAction;
    actSuspendSound: TAction;
    actSpam: TAction;
    actStopChecking: TAction;
    actUndelete: TAction;
    actOpenMessage: TAction;
    actSelectAll: TAction;
    actReplyAll: TAction;
    actArchive: TAction;
    actStar: TAction;
    actUnstar: TAction;
    actMarkAsRead: TAction;
    actMarkAsUnread: TAction;
    actMark: TAction;
    actAddGmailLabel: TAction;
    actRemoveGmailLabel: TAction;
    actMore: TAction;
    EmailTab: TAdvOfficeTabSet;
    grid_Mail: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    Subject: TNxTextColumn;
    ProcDirection: TNxTextColumn;
    RecvDate: TNxDateColumn;
    Sender: TNxMemoColumn;
    Receiver: TNxMemoColumn;
    CC: TNxMemoColumn;
    BCC: TNxMemoColumn;
    EMailId: TNxTextColumn;
    EntryId: TNxTextColumn;
    StoreId: TNxTextColumn;
    DropEmptyTarget1: TDropEmptyTarget;
    DataFormatAdapterOutlook: TDataFormatAdapter;
    PopupMenu1: TPopupMenu;
    DeleteMail1: TMenuItem;
    BitBtn1: TBitBtn;
    EditMailInfo1: TMenuItem;
    N1: TMenuItem;
    MoveEmail1: TMenuItem;
    ContainData: TNxTextColumn;
    SendReply1: TMenuItem;
    SendInvoice1: TMenuItem;
    N2: TMenuItem;
    CreateEMail1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Panel1: TPanel;
    AutoMoveCB: TCheckBox;
    MoveFolderCB: TComboBox;
    Label1: TLabel;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    ShowMailInfo1: TMenuItem;
    ShowEntryID1: TMenuItem;
    ShowStoreID1: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    procedure grid_MailCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure DropEmptyTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure DeleteMail1Click(Sender: TObject);
    procedure EditMailInfo1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure btnStartProgramClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure SendInvoice1Click(Sender: TObject);
    procedure EmailTabChange(Sender: TObject);
    procedure MoveFolderCBDropDown(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure ShowEntryID1Click(Sender: TObject);
    procedure ShowStoreID1Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
  private
    procedure DeleteMail(ARow: integer);
    function GetEmailIDFromGrid(ARow: integer): TID;
    procedure InitFolderListMenu;
    procedure FinilizeFolderListMenu;
    procedure MoveEmailToFolderClick(Sender: TObject);
//    function GetMailBody(AMailType: integer): string;
    function GetFirstStoreIdFromEmail: string;
  public
    FTask: TSQLGSTask;
    //메일을 이동시킬 폴더 리스트,
    //HGS Task/Send Folder Name 2 IPC 메뉴에 의해 OL으로 부터 수신함
    FFolderListFromOL: TStringList;

    procedure SetMoveFolderIndex;
  end;

var
  ViewMailListF: TViewMailListF;

implementation

uses TaskForm, SynMustache, UnitMakeReport, UnitStringUtil, UnitIPCModule,
  DragDropInternet;

{$R *.dfm}

{ TViewMailListF }

procedure TViewMailListF.EmailTabChange(Sender: TObject);
var
  i : Integer;
  LContainData: string;
begin
  with grid_Mail do
  begin
    BeginUpdate;
    try
//      LContainData := EmailTab.AdvOfficeTabs[EmailTab.ActiveTabIndex].Tag;
      LContainData := EmailTab.AdvOfficeTabs[EmailTab.ActiveTabIndex].Name;

      for i := 0 to RowCount-1 do
      begin
        if EmailTab.ActiveTabIndex = 0 then
          RowVisible[i] := True
        else
        if CellByName['ContainData',i].AsString = LContainData then
          RowVisible[i] := True
        else
          RowVisible[i] := False;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TViewMailListF.btnStartProgramClick(Sender: TObject);
begin
  if grid_Mail.SelectedRow = -1 then
  begin
    ShowMessage('Select mail first.');
    exit;
  end;

  SendCmd2IPC4ViewEmail(grid_Mail, grid_Mail.SelectedRow);
end;

procedure TViewMailListF.DeleteMail(ARow: integer);
var
  LEmailID: integer;
begin
  LEmailID := GetEmailIDFromGrid(ARow);

  if LEmailID > -1 then
  begin
    FTask.EmailMsg.ManyDelete(g_ProjectDB, FTask.ID, LEmailID);
    g_ProjectDB.Delete(TSQLEmailMsg, LEmailID);
  end;
end;

procedure TViewMailListF.DeleteMail1Click(Sender: TObject);
var
  LIds: TIDDynArray;
begin
  DeleteMail(grid_Mail.SelectedRow);
  FTask.EmailMsg.DestGet(g_ProjectDB, FTask.ID, LIds);
  ShowEmailListFromIDs(grid_Mail, LIds);
end;

procedure TViewMailListF.DropEmptyTarget1Drop(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
var
  LStoreId, LStorePath, LOriginalEntryId, LOriginalStoreId: string;
  OutlookDataFormat: TOutlookDataFormat;
  LIsMultiDrop: boolean;
  i: integer;
  LIds: TIDDynArray;
  LIsNewMailAdded: Boolean;
  LStrList: TStringList;
begin
  if (DataFormatAdapterOutlook.DataFormat <> nil) then
  begin
    OutlookDataFormat := DataFormatAdapterOutlook.DataFormat as TOutlookDataFormat;
    LIsMultiDrop := OutlookDataFormat.Messages.Count > 1;

    LStoreId := '';
    LStorePath := '';

    if (MoveFolderCB.ItemIndex > -1) and (AutoMoveCB.Checked) then
    begin
      LStoreId := FFolderListFromOL.ValueFromIndex[MoveFolderCB.ItemIndex];
      LStorePath := FFolderListFromOL.Names[MoveFolderCB.ItemIndex];
    end;

    LStrList := TStringList.Create;
    try
//      for i := 0 to OutlookDataFormat.Messages.Count - 1 do
//      begin
        if SendReqOLEmailInfo2(grid_Mail, FTask, LStrList) then
          LIsNewMailAdded := True;
//      end;

      //새 메일이 그리드에 추가 되었으면 Refresh
      if LIsNewMailAdded then
      begin
        FTask.EmailMsg.DestGet(g_ProjectDB, FTask.ID, LIds);
        ShowEmailListFromIDs(grid_Mail ,LIds);

        if (LStoreId <> '') and (LStorePath <> '') then
        begin
          for i := 0 to LStrList.Count - 1 do
          begin
            LOriginalEntryId := LStrList.Names[i];
            LOriginalStoreId := LStrList.ValueFromIndex[i];
            SendCmd2IPC4MoveFolderEmail(LOriginalEntryId, LOriginalStoreId, LStoreId, LStorePath, FTask);
          end;

          ShowMessage('Email move to folder( ' + LStorePath + ' ) completed!' + #13#10 +
            '( ' + IntToStr(OutlookDataFormat.Messages.Count) + ' 건 )');
        end;

//        if (LIsMultiDrop) and (LStorePath <> '') then
//          ShowMessage('Email move to folder( ' + LStorePath + ' ) completed!' + #13#10 +
//            '( ' + IntToStr(OutlookDataFormat.Messages.Count) + ' 건 )');
      end;
    finally
      LStrList.Free;
    end;
  end;
end;

procedure TViewMailListF.EditMailInfo1Click(Sender: TObject);
var
  LEmailInfoF: TEmailInfoF;
  LEmailID: integer;
  LEmailMsg: TSQLEmailMsg;
begin
  LEmailID := GetEmailIDFromGrid(grid_Mail.SelectedRow);

  if LEmailID > -1 then
  begin
    LEmailInfoF := TEmailInfoF.Create(nil);
    try
      LEmailMsg := TSQLEmailMsg.CreateAndFillPrepare(g_ProjectDB,
        'ID = ?', [LEmailID]);

      //데이터가 있으면
      if LEmailMsg.FillOne then
      begin
        LEmailInfoF.ContainDataCB.ItemIndex := Ord(LEmailMsg.ContainData);
        LEmailInfoF.EmailDirectionCB.ItemIndex := Ord(LEmailMsg.ProcDirection);
      end;

      if LEmailInfoF.ShowModal = mrOK then
      begin
        LEmailMsg.ContainData := TContainData4Mail(LEmailInfoF.ContainDataCB.ItemIndex);
        LEmailMsg.ProcDirection := TProcessDirection(LEmailInfoF.EmailDirectionCB.ItemIndex);

        g_ProjectDB.Update(LEmailMsg);
        TTaskEditF.LoadEmailListFromTask(FTask, Self);
      end;
    finally
      FreeAndNil(LEmailMsg);
      LEmailInfoF.Free;
    end;

//    FTask.EmailMsg.ManyDelete(g_ProjectDB, FTask.ID, LEmailID);
//    g_ProjectDB.Delete(TSQLEmailMsg, LEmailID);
  end;
end;

procedure TViewMailListF.FinilizeFolderListMenu;
var
  i: integer;
  LMenu: TMenuItem;
begin
//  MoveEmail1.Clear;
//
//  for i := 0 to FFolderListFromOL.Count - 1 do
//  begin
//    LMenu := TMenuItem.Create(MoveEmail1);
//    LMenu.Caption := FFolderListFromOL.Names[i];
//    LMenu.Tag := i;
//    LMenu.OnClick := MoveEmailToFolderClick;
//    MoveEmail1.Add(LMenu);
//  end;
end;

procedure TViewMailListF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FFolderListFromOL.Free;
end;

procedure TViewMailListF.FormCreate(Sender: TObject);
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  FFolderListFromOL := TStringList.Create;

  if FileExists('.\'+FOLDER_LIST_FILE_NAME) then
    FFolderListFromOL.LoadFromFile('.\'+FOLDER_LIST_FILE_NAME);

  MoveFolderCBDropDown(nil);
end;

function TViewMailListF.GetEmailIDFromGrid(ARow: integer): TID;
begin
  if ARow <> -1 then
  begin
    Result := grid_Mail.CellByName['EMailId', ARow].AsInteger
  end
  else
    Result := -1;
end;

function TViewMailListF.GetFirstStoreIdFromEmail: string;
var
  LIds: TIDDynArray;
  LSQLEmailMsg: TSQLEmailMsg;
begin
  FTask.EmailMsg.DestGet(g_ProjectDB, FTask.ID, LIds);
  LSQLEmailMsg:= TSQLEmailMsg.CreateAndFillPrepare(g_ProjectDB, TInt64DynArray(LIds));

  try
    if LSQLEmailMsg.FillOne then
    begin
      Result := LSQLEmailMsg.StoreID;
    end;
  finally
    FreeAndNil(LSQLEmailMsg);
  end;
end;

procedure TViewMailListF.grid_MailCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    exit;

  SendCmd2IPC4ViewEmail(grid_Mail, ARow);
end;

procedure TViewMailListF.InitFolderListMenu;
var
  i: integer;
  LMenu: TMenuItem;
begin
  MoveEmail1.Clear;

  for i := 0 to FFolderListFromOL.Count - 1 do
  begin
    LMenu := TMenuItem.Create(MoveEmail1);
    LMenu.Caption := FFolderListFromOL.Names[i];
//    ShowMessage(FFolderListFromOL.Names[i]);
    LMenu.Tag := i;
    LMenu.OnClick := MoveEmailToFolderClick;
    MoveEmail1.Add(LMenu);
  end;
end;

procedure TViewMailListF.MoveEmailToFolderClick(Sender: TObject);
var
  LEntryId, LStoreId: string;
begin
  if grid_Mail.SelectedRow = -1 then
    exit;

  LEntryId := grid_Mail.CellByName['EntryId', grid_Mail.SelectedRow].AsString;
  LStoreId := grid_Mail.CellByName['StoreId', grid_Mail.SelectedRow].AsString;

  if SendCmd2IPC4MoveFolderEmail(LEntryId, LStoreId,
      FFolderListFromOL.ValueFromIndex[TMenuItem(Sender).Tag],
      FFolderListFromOL.Names[TMenuItem(Sender).Tag], FTask) then
    ShowMessage('Email move to folder( ' + FFolderListFromOL.Names[TMenuItem(Sender).Tag] + ' ) completed!');
end;

procedure TViewMailListF.MoveFolderCBDropDown(Sender: TObject);
var
  i: integer;
begin
  MoveFolderCB.Clear;

  for i := 0 to FFolderListFromOL.Count - 1 do
    MoveFolderCB.Items.Add(FFolderListFromOL.Names[i]);
end;

procedure TViewMailListF.N10Click(Sender: TObject);
var
  LEntryId, LStoreId: string;
begin
  LEntryId := grid_Mail.CellByName['EntryId', grid_Mail.SelectedRow].AsString;
  LStoreId := grid_Mail.CellByName['StoreId', grid_Mail.SelectedRow].AsString;

  SendCmd2IPC4ReplyMail(LEntryId, LStoreId, TMenuItem(Sender).Tag, FTask);
end;

procedure TViewMailListF.N2Click(Sender: TObject);
var
  LEntryId, LStoreId: string;
begin
  LEntryId := grid_Mail.CellByName['EntryId', grid_Mail.SelectedRow].AsString;
  LStoreId := grid_Mail.CellByName['StoreId', grid_Mail.SelectedRow].AsString;

  SendCmd2IPC4ReplyMail(LEntryId, LStoreId, TMenuItem(Sender).Tag, FTask);
end;

procedure TViewMailListF.N3Click(Sender: TObject);
begin
  SendCmd2IPC4CreateMail(grid_Mail, grid_Mail.SelectedRow, TMenuItem(Sender).Tag, FTask);
end;

procedure TViewMailListF.N5Click(Sender: TObject);
begin
  SendCmd2IPC4CreateMail(grid_Mail, grid_Mail.SelectedRow, TMenuItem(Sender).Tag, FTask);
end;

procedure TViewMailListF.N6Click(Sender: TObject);
begin
  SendCmd2IPC4CreateMail(grid_Mail, grid_Mail.SelectedRow, TMenuItem(Sender).Tag, FTask);
end;

procedure TViewMailListF.N7Click(Sender: TObject);
begin
  SendCmd2IPC4CreateMail(grid_Mail, grid_Mail.SelectedRow, TMenuItem(Sender).Tag, FTask);
end;

procedure TViewMailListF.N9Click(Sender: TObject);
begin
  SendCmd2IPC4CreateMail(grid_Mail, grid_Mail.SelectedRow, TMenuItem(Sender).Tag, FTask);
end;

procedure TViewMailListF.PopupMenu1Popup(Sender: TObject);
begin
  InitFolderListMenu;
end;

procedure TViewMailListF.SendInvoice1Click(Sender: TObject);
var
  LEntryId, LStoreId: string;
begin
  LEntryId := grid_Mail.CellByName['EntryId', grid_Mail.SelectedRow].AsString;
  LStoreId := grid_Mail.CellByName['StoreId', grid_Mail.SelectedRow].AsString;
  SendCmd2IPC4ReplyMail(LEntryId, LStoreId, TMenuItem(Sender).Tag, FTask);
end;

procedure TViewMailListF.SetMoveFolderIndex;
var
  i: integer;
  LStr: RawUTF8;
begin
  LStr := GetFirstStoreIdFromEmail;
  for i := 0 to FFolderListFromOL.Count - 1 do
    if FFolderListFromOL.ValueFromIndex[i] = UTF8ToString(LStr) then
    begin
      MoveFolderCB.ItemIndex := i;
      Break;
    end;
end;

procedure TViewMailListF.ShowEntryID1Click(Sender: TObject);
begin
  ShowMessage(grid_Mail.CellByName['EntryId', grid_Mail.SelectedRow].AsString);
end;

procedure TViewMailListF.ShowStoreID1Click(Sender: TObject);
begin
  ShowMessage(grid_Mail.CellByName['StoreId', grid_Mail.SelectedRow].AsString);
end;

end.
