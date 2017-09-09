unit UnitMainBWQueryPublisher;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,  AdvOfficePager, BW_Query_Class,
  Vcl.StdCtrls, UnitFrameCommServer, Vcl.Menus, SynCommons, mORMot,
  UnitBWQuery, UnitBWQueryInterface,
  // cromis units
  Cromis.Comm.Custom, Cromis.Comm.IPC, Cromis.Threading, Cromis.AnyValue,
  //STOMP units
  UnitSTOMPClass,
  RMISConst, tmsAdvGridExcel, UnitFrameCromisIPCServer;

type
  TBWQueryPublisherF = class(TForm)
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    Edit1: TEdit;
    AdvOfficePager12: TAdvOfficePage;
    Memo1: TMemo;
    PopupMenu1: TPopupMenu;
    DataView1: TMenuItem;
    N12: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Header1: TMenuItem;
    Header2: TMenuItem;
    N15: TMenuItem;
    N19: TMenuItem;
    N18: TMenuItem;
    N17: TMenuItem;
    N20: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    Inquiry1: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    GS1: TMenuItem;
    N13: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    HEADER3: TMenuItem;
    N16: TMenuItem;
    N28: TMenuItem;
    N14: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N29: TMenuItem;
    est1: TMenuItem;
    AdvGridExcelIO1: TAdvGridExcelIO;
    FCIPCServer: TFrameCromisIPCServer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Header1Click(Sender: TObject);
    procedure Header2Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure N26Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure Inquiry1Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure N33Click(Sender: TObject);
    procedure N34Click(Sender: TObject);
    procedure N35Click(Sender: TObject);
    procedure GS1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure HEADER3Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N28Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure FCIPCServerJvXPButton6Click(Sender: TObject);
    procedure FCIPCServerJvXPButton5Click(Sender: TObject);
  private
    FUserId, FPasswd, FTopic, FMQServerIp,
    FExeFilePath: string;
    FBWQuery: TBWQuery;
    FpjhSTOMPClass: TpjhSTOMPClass;

    procedure StartServer;
  public
    procedure InitVar;
    procedure DestroyVar;

    procedure OnExecuteRequest(const Context: ICommContext; const Request, Response: IMessageData);

    procedure DisplayMessage(msg: string);
    procedure ClearMessage;
    procedure SetFormCaption(ACaption: string);
    function GetFormCaption: string;
  end;

var
  BWQueryPublisherF: TBWQueryPublisherF;

implementation

{$R *.dfm}

{ TBWQueryPublisherF }

procedure TBWQueryPublisherF.ClearMessage;
begin
  Memo1.Lines.Clear;
end;

procedure TBWQueryPublisherF.DestroyVar;
begin
  FpjhSTOMPClass.Free;
  FBWQuery.Free;
end;

procedure TBWQueryPublisherF.DisplayMessage(msg: string);
begin
  if msg = ' ' then
    exit;

  with Memo1 do
  begin
    if Lines.Count > 10000 then
      Clear;

    Lines.Add(msg);
  end;//with
end;

procedure TBWQueryPublisherF.FCIPCServerJvXPButton5Click(Sender: TObject);
var
  i: integer;
  LKey: string;
  LData: RawUTF8;
  LBWQry: TBWQryClass;
  LValid: Boolean;
begin
  for LKey in FBWQuery.FBWQryDataClass.FBWQryList.Keys do
  begin
    LData := ObjectToJson(FBWQuery.FBWQryDataClass.FBWQryList.Items[LKey]);
    ShowMessage(FBWQuery.FBWQryDataClass.FBWQryList.Items[LKey].BWQryColumnHeaderCollect.Items[0].ColumnHeaderData);
    break;
  end;

  LBWQry := TBWQryClass.Create(nil);
  try
    JSONToObject(LBWQry, Pointer(LData), LValid);
    ShowMessage(LBWQry.BWQryColumnHeaderCollect.Items[0].ColumnHeaderData);
  finally
    LBWQry.Free;
  end;
end;

procedure TBWQueryPublisherF.FCIPCServerJvXPButton6Click(Sender: TObject);
begin
  FpjhSTOMPClass.StompSendMsg(FTopic, 'aaaaa');
end;

procedure TBWQueryPublisherF.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TBWQueryPublisherF.FormDestroy(Sender: TObject);
begin
  DestroyVar;
end;

function TBWQueryPublisherF.GetFormCaption: string;
begin
  Result := Caption;
end;

procedure TBWQueryPublisherF.GS1Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.Header1Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.Header2Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.HEADER3Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.InitVar;
begin
  FExeFilePath := ExtractFilePath(Application.ExeName);
  FBWQuery := TBWQuery.Create;
  FBWQuery.FExeFilePath := FExeFilePath;
  FCIPCServer.SetCustomOnRequest(OnExecuteRequest);

  g_ClearMessage := ClearMessage;
  g_DisplayMessage2MainForm := DisplayMessage;
  g_SetFormCaption := SetFormCaption;
  g_GetFormCaption := GetFormCaption;

  //  FCS.FStartServerProc := StartServer;
  FCIPCServer.FAutoStartInterval := 10000; //10ÃÊ

  FUserId := 'pjh';
  FPasswd := 'pjh';
  FTopic := 'BWQry';
  FMQServerIp := '10.14.21.117';

  FpjhSTOMPClass := TpjhSTOMPClass.CreateWithStr(FUserId,FPasswd,FMQServerIp,FTopic,Self.Handle);
end;

procedure TBWQueryPublisherF.Inquiry1Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N10Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N11Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N15Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N16Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N17Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N18Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N19Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N1Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N20Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N23Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N24Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N25Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N26Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N27Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N28Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N29Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N2Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N31Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N32Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N33Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N34Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N35Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N3Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N4Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N5Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N6Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N7Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N8Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.N9Click(Sender: TObject);
begin
  FBWQuery.QryData2DataView(TMenuItem(Sender).Hint);
end;

procedure TBWQueryPublisherF.OnExecuteRequest(const Context: ICommContext;
  const Request, Response: IMessageData);
var
  Command: String;
  LData: string;
  LSendIsOk: Boolean;
begin
  LSendIsOk := False;
  Command := UpperCase(Request.Data.ReadUnicodeString('Command'));
  Response.Data.WriteDateTime('TDateTime', Now);
  Response.Data.WriteUnicodeString('Command', Command);

  if Command = 'GET_BWQRYCLASS_ALL' then
  begin
    Response.ID := '4';
    LData := FBWQuery.FBWQryDataClass.GetBWQryList2CellDataAllCollect2JSON;
    LSendIsOk := True;
  end
//  else
//  if Command = 'GET_OrderPlanPerProduct' then
//  begin
//    Response.ID := '5';
//    LData := FBWQuery.FBWQryDataClass.GetBWQryList2CellDataAllCollect2JSON;
//    LSendIsOk := True;
//  end
//  else
//  if Command = 'GET_SalesPlanPerProduct' then
//  begin
//    Response.ID := '6';
//    LData := FBWQuery.FBWQryDataClass.GetBWQryList2CellDataAllCollect2JSON;
//    LSendIsOk := True;
//  end
//  else
//  if Command = 'GET_ProfitPlanPerProduct' then
//  begin
//    Response.ID := '7';
//    LData := FBWQuery.FBWQryDataClass.GetBWQryList2CellDataAllCollect2JSON;
//    LSendIsOk := True;
//  end
  else
  begin
    if Command = 'GET_BWQRY_CELL_DATA_ALL' then
      Response.ID := '1'
    else if Command = 'GET_BWQRY_COLUMN_HEADER_DATA_ALL' then
      Response.ID := '2'
    else if Command = 'GET_BWQRY_ROW_HEADER_DATA_ALL' then
      Response.ID := '3';

    if FBWQuery.FBWQryDataClass.GetCellDataAll(Command) then
    begin
      LData := UTF8ToString(ObjectToJson(FBWQuery.FBWQryDataClass.FCellDataAllCollect));
      LSendIsOk := True;
    end;
  end;

  if LSendIsOk then
  begin
    Response.Data.WriteUnicodeString('Data', LData);
    FCIPCServer.DisplayMessageFromOuter(DateTimeToStr(Response.Data.ReadDateTime('TDateTime')) +
      ': Command = ' + Command + ' >>> Send Data = ' + LData, 2);
  end;
end;

procedure TBWQueryPublisherF.SetFormCaption(ACaption: string);
begin
  Caption := ACaption;
end;

procedure TBWQueryPublisherF.StartServer;
begin
//  FCS.CreateHttpServer(BWQRY_ROOT_NAME, 'BWQuery.json', BWQRY_PORT_NAME, TServiceBWQuery,
//    [TypeInfo(IBWQuery), TypeInfo(IDPMSInfo), TypeInfo(IExtraMHInfo), TypeInfo(IRMISSessionLog)], sicClientDriven, True);
//  FCS.ServerStartBtnClick(nil);
end;

end.
