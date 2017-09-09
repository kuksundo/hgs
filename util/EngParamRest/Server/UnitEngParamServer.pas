unit UnitEngParamServer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitFrameCommServer, UnitFrameIPCMonitorAll,
  SynCommons, mORMot, mORMotSQLite3, mORMotHttpServer, UnitEngParamInterface,
  UnitFrameWatchGrid, AdvPageControl, Vcl.ExtCtrls, Vcl.ComCtrls, EngineParameterClass,
  AdvOfficePager, Vcl.Menus, JvDialogs, JvExComCtrls, JvStatusBar, HiMECSConst,
  Vcl.StdCtrls
  ;

type
//  TServiceEngParam = class(TInterfacedCollection)
  TServiceEngParam = class(TInterfacedObject, IEngParameter)
  public
    function GetTagNames: TRawUTF8DynArray;
    procedure GetEngParam(out AEPCollect: TEngineParameterCollect);
    function GetTagValues: TRawUTF8DynArray;
  end;

  TEngParamServerF = class(TForm)
    Panel1: TPanel;
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    ItemsTabSheet: TAdvOfficePage;
    FCS: TFrameCommServer;
    FWG: TFrameWatchGrid;
    ItemsPopup: TPopupMenu;
    DeleteItems1: TMenuItem;
    JvOpenDialog1: TJvOpenDialog;
    LoadParameterFromFile1: TMenuItem;
    N1: TMenuItem;
    JvStatusBar1: TJvStatusBar;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    IPCMonitorAll1: TFrameIPCMonitor;
    procedure TFrameCommServer1JvXPButton1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DeleteItems1Click(Sender: TObject);
    procedure LoadParameterFromFile1Click(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FServiceEngParam: TServiceEngParam;
    FIpAddr, FEngProjNo: string;
    FPortNo: integer;
    FItemsChanged: Boolean;

    procedure CreateHttpServer;
    procedure DestroyHttpServer;
    procedure NotifyItemsChanged;

    procedure DeleteEngineParamterFromGrid(AIndex: integer);
    procedure WatchValue2Screen_Analog(Name: string; AValue: string;
                                AEPIndex: integer);
    procedure WatchValue2Screen_Digital(Name: string; AValue: string;
                                AEPIndex: integer);
    procedure GetEngineParameterFromSavedWatchListFile(AAutoStart: Boolean;
              AFileName: string);
    function SessionCreate(Sender: TSQLRestServer; Session: TAuthSession;
                  Ctxt: TSQLRestServerURIContext): boolean;
    function SessionClosed(Sender: TSQLRestServer; Session: TAuthSession;
                  Ctxt: TSQLRestServerURIContext): boolean;
  public
    FModel: TSQLModel;
    FHTTPServer: TSQLHttpServer;
    FRestServer: TSQLRestServer;

    function GetValuesFromEngParamCollect: TRawUTF8DynArray;
    function GetEngProjNoFromparam: string;
  end;

var
  EngParamServerF: TEngParamServerF;

implementation

uses getIp, DataModule_Unit;

{$R *.dfm}

procedure TEngParamServerF.ComboBox1DropDown(Sender: TObject);
begin
  ComboBox1.Items.Assign(GetLocalIPList);
end;

procedure TEngParamServerF.CreateHttpServer;
begin
  if not Assigned(FModel) then
    FModel := TSQLModel.Create([],ROOT_NAME);

  if not Assigned(FRestServer) then
  begin
    // initialize a TObjectList-based database engine
    FRestServer := TSQLRestServerFullMemory.Create(FModel,'EngParam.json',false,true);
    // register our ICalculator service on the server side
    FRestServer.ServiceRegister(TServiceEngParam,[TypeInfo(IEngParameter)],sicShared);
    FRestServer.OnSessionCreate := SessionCreate;
    FRestServer.OnSessionClosed := SessionClosed;
  end;

  if not Assigned(FHTTPServer) then
  begin
    // launch the HTTP server
    FHTTPServer := TSQLHttpServer.Create(PORT_NAME,[FRestServer],'+',useHttpApiRegisteringURI);
    FHTTPServer.AccessControlAllowOrigin := '*'; // for AJAX requests to work
    FCS.FServiceRunning := True;
  end;
end;

procedure TEngParamServerF.DeleteEngineParamterFromGrid(AIndex: integer);
begin
  FWG.FreeStrListFromGrid(AIndex);
  FWG.NextGrid1.DeleteRow(AIndex);
  IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Delete(AIndex);
end;

procedure TEngParamServerF.DeleteItems1Click(Sender: TObject);
begin
  FWG.DeleteGridItem;
end;

procedure TEngParamServerF.DestroyHttpServer;
begin
  if Assigned(FHTTPServer) then
    FHTTPServer.Free;

  if Assigned(FRestServer) then
    FRestServer.Free;

  if Assigned(FModel) then
    FModel.Free;

  if Assigned(FServiceEngParam) then
    FServiceEngParam.Free;
end;

procedure TEngParamServerF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  DM1.Update_Mon_Table_IpAddr(FEngProjNo, FIpAddr, 0, FPortNo);
end;

procedure TEngParamServerF.FormCreate(Sender: TObject);
begin
  FWG.FCalculatedItemTimerHandle := -1;
  FWG.SetIPCMonitorAll(IPCMonitorAll1);
  FWG.SetStatusBar(JvStatusBar1);
  FWG.SetMainFormHandle(Handle);
  FWG.SetDeleteEngineParamterFromGrid(DeleteEngineParamterFromGrid);
  FWG.SetWatchValue2Screen_Analog(WatchValue2Screen_Analog); //Calculated Item을 표시하기 위함
  FWG.NextGrid1.PopupMenu := ItemsPopup;
  FWG.NextGrid1.DoubleBuffered := False;

  IPCMonitorAll1.FNextGrid := FWG.NextGrid1;
  IPCMonitorAll1.FPageControl := AdvOfficePager1;
//  IPCMonitorAll1.FWatchValue2Screen_AnalogEvent := WatchValue2Screen_Analog;
//  IPCMonitorAll1.FWatchValue2Screen_DigitalEvent := WatchValue2Screen_Digital;

  FWG.NextGrid1.DoubleBuffered := False;

  //mORMOt Framework의 Service Parameter로서 TCollection을 사용하기 위해서는 아래 코드가 필수임
  TJSONSerializer.RegisterCollectionForJSON(TEngineParameterCollect, TEngineParameterItem);
end;

procedure TEngParamServerF.FormDestroy(Sender: TObject);
begin
  DestroyHttpServer;
end;

procedure TEngParamServerF.FormShow(Sender: TObject);
begin
  ComboBox1.Text := GetLocalIP(0);
  FCS.LblIP.Caption := GetLocalIP(0);
  FCS.LblPort.Caption := PORT_NAME;
//  Label1.Caption := 'IP Address:' + ComboBox1.Text + ', Port No:' + PORT_NAME;;
end;

procedure TEngParamServerF.GetEngineParameterFromSavedWatchListFile(
  AAutoStart: Boolean; AFileName: string);
var
  i, j: integer;
  LStrList: TStringList;
  LStr: string;
begin
  if FileExists(AFileName) then
  begin
    if FWG.NextGrid1.RowCount > 0 then
    begin
      i := MessageDlg('Do you want to apppend the items to the grid?' + #13#10 + 'If you want to clear the items, Click ''No''',
                                mtConfirmation, [mbYes, mbNo, mbCancel], 0);
      case i of
        mrNo: begin
          IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Clear;
          FWG.NextGrid1.ClearRows;
        end;
        mrCancel: exit;
      end;
    end;

    FWG.AppendEngineParameterFromFile(AFileName, 1, False, False);
    FWG.FCompoundItemList.clear;

    for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
    begin
      //DisplayFormat 속성이 나중에 추가 되었기 때문에 적용 안된 WatchList파일의 경우 적용하기 위함
      if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat = '' then
      begin
        IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].DisplayFormat :=
          GetDisplayFormat(IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].RadixPosition,
                          IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].DisplayThousandSeperator);
      end;

      FWG.AddEngineParameter2Grid(i);
    end; //for
  end;
end;

function TEngParamServerF.GetEngProjNoFromparam: string;
begin
//  IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[0].
  Result := Edit1.Text;
end;

function TEngParamServerF.GetValuesFromEngParamCollect: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
  LValue: RawUTF8;
  i: integer;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);

  for i := 0 to IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    LValue := StringToUTF8(IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value);
    LDynArr.Add(LValue);
  end;
end;

procedure TEngParamServerF.LoadParameterFromFile1Click(Sender: TObject);
var
  LEngineParameter: TEngineParameter;
  i: integer;
begin
//  JvOpenDialog1.InitialDir := FApplicationPath+'doc';
  JvOpenDialog1.Filter := '*.param||*.*';

  if JvOpenDialog1.Execute then
  begin
    if jvOpenDialog1.FileName <> '' then
    begin
      GetEngineParameterFromSavedWatchListFile(False, jvOpenDialog1.FileName);
      FItemsChanged := True;
    end;
  end;
end;

procedure TEngParamServerF.NotifyItemsChanged;
begin
  if FItemsChanged then
  begin
    FItemsChanged := False;
  end;
end;

//Server.Stats.ClientsCurrent = number of session
//Ctxt.InHeader[RemoteIP]
//Ctxt.InHeader[Host]
function TEngParamServerF.SessionClosed(Sender: TSQLRestServer;
  Session: TAuthSession; Ctxt: TSQLRestServerURIContext): boolean;
begin
  FCS.DeleteConnectionFromLV(Session.RemoteIP,PORT_NAME, Session.ID, Session.User.LogonName);
  Result := False;
end;

function TEngParamServerF.SessionCreate(Sender: TSQLRestServer;
  Session: TAuthSession; Ctxt: TSQLRestServerURIContext): boolean;
begin
//  FCS.AddConnectionToLV(Ctxt.SessionRemoteIP,PORT_NAME,Ctxt.SessionUserName);
  FCS.AddConnectionToLV(Session.RemoteIP,PORT_NAME, Session.ID, Session.User.LogonName);

  Result := False;
end;

procedure TEngParamServerF.TFrameCommServer1JvXPButton1Click(Sender: TObject);
begin
  CreateHttpServer;

  FCS.ApplyStatus2Component;

//  if IPCMonitorAll1.FEngineParameter.EngineParameterCollect.PowerOn then
  if True then
  begin
    FEngProjNo := GetEngProjNoFromparam;
    FIpAddr := TStringList(GetLocalIPList).Strings[0];
    FPortNo := StrToIntDef(PORT_NAME, 0);
//    DM1.Update_Mon_Table_IpAddr(FEngProjNo, FIpAddr, 1, FPortNo);
  end;
end;

procedure TEngParamServerF.WatchValue2Screen_Analog(Name, AValue: string;
  AEPIndex: integer);
begin
  if UpperCase(AdvOfficePager1.ActivePage.Name) = ITEMS_SHEET_NAME then
  begin
    FWG.NextGrid1.CellsByName['Value', AEPIndex] := IPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;
  end;
end;

procedure TEngParamServerF.WatchValue2Screen_Digital(Name, AValue: string;
  AEPIndex: integer);
begin
;
end;

procedure TServiceEngParam.GetEngParam(out AEPCollect: TEngineParameterCollect);
var
  LTagList: TEngineParameterCollect;
begin
  LTagList := TEngineParameterCollect.Create(TEngineParameterItem);

  try
    LTagList.Assign(EngParamServerF.IPCMonitorAll1.FEngineParameter.EngineParameterCollect);
    CopyObject(LTagList, AEPCollect);
  finally
    LTagList.Free;
  end;
end;

function TServiceEngParam.GetTagNames: TRawUTF8DynArray;
begin

end;

function TServiceEngParam.GetTagValues: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TDoubleDynArray),Result,@LCount);
  Result := EngParamServerF.GetValuesFromEngParamCollect;
end;

end.
