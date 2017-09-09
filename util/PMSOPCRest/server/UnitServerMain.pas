unit UnitServerMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  SynCommons, mORMot, mORMotSQLite3, mORMotHttpServer,
  UnitPMSOPCInterface, OmniXML, OmniXMLUtils, OmniXMLXPath,
  UnitTagCollect, UnitOPCServer, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.ExtCtrls, NxColumnClasses, NxColumns,
  UnitRegistrationClass, UnitSTOMPClass, UnitWorker4OmniMsgQ, Vcl.ComCtrls;

type
  TServicePMSOPC = class(TInterfacedObject, IPMSOPC)
  public
    function GetTagNames: TRawUTF8DynArray;
    procedure GetTagnames2(out ATagNames: TTagCollect);
    function GetTagValues: TRawUTF8DynArray;
  end;

  TServerMainF = class(TForm)
    Label4: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    TagGrid: TNextGrid;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    NxIncrementColumn1: TNxIncrementColumn;
    TagNameText: TNxTextColumn;
    DescriptText: TNxTextColumn;
    ValueText: TNxTextColumn;
    Button2: TButton;
    Button3: TButton;
    Label5: TLabel;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    Label6: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FpjhSTOMPClass: TpjhSTOMPClass;

    procedure CreateHttpServer;
    procedure InitSTOMP(AUserId, APasswd, AServerIP, ATopic: string);
    procedure DestroySTOMP;
    procedure WorkerResult(var msg: TMessage); message MSG_RESULT;
    procedure ProcessSubscribeMsg;
    procedure SendData2MQ(AMsg: string; ATopic: string = '');
    procedure GetTagNameListFromXml(AFileName: string);
    procedure SetTagName2Grid;
  public
    FModel: TSQLModel;
    FHTTPServer: TSQLHttpServer;
    FRestServer: TSQLRestServer;
    FOPCServer: TpjhOPCServer;

    DB: TSQLRestServerDB;

    procedure SetTagData2Grid(ARow: integer; AValue: string);
    function GetTagNamesFromList: TRawUTF8DynArray;
    function GetTagValuesFromList: TRawUTF8DynArray;
    function GetTagCount: integer;
    function GetTagNames: TTagCollect;
    procedure SendCollectData2MQ;

//    property TagGrid: TNextGrid read Tag_Grid write Tag_Grid;
  end;

var
  ServerMainF: TServerMainF;

implementation

uses getIp, OtlComm;

{$R *.dfm}

procedure TServerMainF.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TServerMainF.Button2Click(Sender: TObject);
begin
  CreateHttpServer;
  Label2.Visible := True;
end;

procedure TServerMainF.Button3Click(Sender: TObject);
begin
  GetTagNameListFromXml('.\OpcMap_sort.xml');
  SetTagName2Grid;
  FOPCServer.InitItemId;
  FOPCServer.OPCConnect;
end;

procedure TServerMainF.ComboBox1DropDown(Sender: TObject);
begin
  ComboBox1.Items.Assign(GetLocalIPList);
end;

procedure TServerMainF.CreateHttpServer;
begin
  //PortNum := '8080';
  FModel := TSQLModel.Create([],ROOT_NAME);
  // initialize a TObjectList-based database engine
  FRestServer := TSQLRestServerFullMemory.Create(FModel,'test.json',false,true);
  // register our ICalculator service on the server side
  FRestServer.ServiceRegister(TServicePMSOPC,[TypeInfo(IPMSOPC)],sicShared);
  // launch the HTTP server
  FHTTPServer := TSQLHttpServer.Create(PORT_NAME,[FRestServer],'+',useHttpApiRegisteringURI);
  FHTTPServer.AccessControlAllowOrigin := '*'; // for AJAX requests to work
end;

procedure TServerMainF.DestroySTOMP;
begin
  FpjhSTOMPClass.Free;
end;

procedure TServerMainF.FormCreate(Sender: TObject);
begin
  TagGrid.DoubleBuffered := False;

  FOPCServer := TpjhOPCServer.Create;
  InitSTOMP('pjh','pjh','127.0.0.1',PPP_PMS_TOPIC);
//  CreateHttpServer;
//  PortNum := '8080';
//  Model := CreateSampleModel;
//  DB := TSQLRestServerDB.Create(Model,ChangeFileExt(paramstr(0),'.db3'),true);
//  DB.CreateMissingTables(0);
//  Server := TSQLHttpServer.Create(PortNum,[DB],'+',useHttpApiRegisteringURI);
//  Server.AccessControlAllowOrigin := '*'; // allow cross-site AJAX queries
end;

procedure TServerMainF.FormDestroy(Sender: TObject);
begin
  FOPCServer.Free;

  if Assigned(FHTTPServer) then
    FHTTPServer.Free;

  if Assigned(FRestServer) then
    FRestServer.Free;

  if Assigned(FModel) then
    FModel.Free;

  DestroySTOMP;
//  DB.Free;
end;

procedure TServerMainF.FormShow(Sender: TObject);
begin
  ComboBox1.Text := GetLocalIP(0);
  Label1.Caption := 'IP Address:' + ComboBox1.Text + ', Port No:' + PORT_NAME;;
end;

function TServerMainF.GetTagCount: integer;
begin
  Result := FOPCServer.FTagList.Count;
end;

procedure TServerMainF.GetTagNameListFromXml(AFileName: string);
var
  LXMLDoc: IXMLDocument;
  LRootNode, LSubNode: IXMLNode;
  i,j: integer;
  LList: TStringList;
  LStr: string;
begin
  LXMLDoc := CreateXMLDoc;
  try
    LXMLDoc.Load(AFileName);

    if LXMLDoc.DocumentElement <> nil then
    begin
      LRootNode := LXMLDoc.DocumentElement;

      for i := 0 to LRootNode.ChildNodes.Length - 1 do
      begin
        LSubNode := LRootNode.ChildNodes.Item[i];

        if LSubNode.NodeName = 'Module' then
        begin
          FOPCServer.FTagList.Clear;
          FOPCServer.FTagList4AddItem.Clear;

          for j := 0 to LSubNode.ChildNodes.Length - 1 do
          begin
            if LSubNode.ChildNodes.Item[j].NodeName = 'Tag' then
            begin
              if Pos('@', LSubNode.ChildNodes.Item[j].Attributes.GetNamedItem('Name').NodeValue) = 0 then
              begin
                LStr := LSubNode.ChildNodes.Item[j].Attributes.GetNamedItem('Name').NodeValue;
                FOPCServer.FTagList.Add.TagName := LStr;
                FOPCServer.FTagList4AddItem.Add.TagName := LStr;
              end;
            end;
          end;

          break;
        end;
      end;
    end;
  finally
//    if FTagList.Count > 0 then
//    begin
//      LList := TStringList.Create;
//      try
////        LList.Add(UTF8ToString(ObjectToJSON(FTagList,[woHumanReadable])));
//        LList.Add(UTF8ToString(ObjectToJSON(FTagList)));
//        LList.SaveToFile('E:\pjh\project\util\RestCS\Server\OpcMap.txt');
//      finally
//        LList.Free;
//      end;
//    end;

    LXMLDoc := nil;
  end;
end;

function TServerMainF.GetTagNames: TTagCollect;
//var
//  LTagList: TTagCollect;
begin
//  Result := TTagCollect.Create;
  Result := FOPCServer.GetTagList;
//  CopyObject(LTagList, Result);
//  ShowMessage(IntToStr(Result.Count));
end;

function TServerMainF.GetTagNamesFromList: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
  LValue: RawUTF8;
  i: integer;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);

  for i := 0 to FOPCServer.FTagList.Count - 1 do
  begin
    LValue := FOPCServer.FTagList.Item[i].TagName;
    LDynArr.Add(LValue);
  end;
end;

function TServerMainF.GetTagValuesFromList: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
  LValue: RawUTF8;
  i: integer;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);

  for i := 0 to FOPCServer.FTagList.Count - 1 do
  begin
    LValue := FOPCServer.FTagList.Item[i].TagValue;
    LDynArr.Add(LValue);
  end;
end;

procedure TServerMainF.InitSTOMP(AUserId, APasswd, AServerIP, ATopic: string);
begin
  if not Assigned(FpjhSTOMPClass) then
  begin
    FpjhSTOMPClass := TpjhSTOMPClass.CreateWithStr(AUserId,
                                            APasswd,
                                            AServerIP,
                                            ATopic,
                                            Self.Handle);
  end;

  Label6.Caption := 'Topic: ' + ATopic;
end;

procedure TServerMainF.ProcessSubscribeMsg;
var
  msg: TOmniMessage;
begin
  while FpjhSTOMPClass.GetResponseQMsg(msg) do
  begin
//    Memo1.Lines.Add(msg.MsgData);
  end;
end;

procedure TServerMainF.SendCollectData2MQ;
var
  LCount: integer;
  LDynArr: TDynArray;
  LUTF8DayArr: TRawUTF8DynArray;
  LValue: RawUTF8;
  i: integer;
  LStr: string;
begin
  if not Assigned(FpjhSTOMPClass) then
    exit;

  LDynArr.Init(TypeInfo(TRawUTF8DynArray),LUTF8DayArr,@LCount);

  for i := 0 to FOPCServer.FTagList.Count - 1 do
  begin
    LValue := FOPCServer.FTagList.Item[i].TagValue;
    LDynArr.Add(LValue);
  end;

  LValue := LDynArr.SaveToJSON;
  LStr := UTF8ToString(LValue);
  SendData2MQ(LStr, PPP_PMS_VALUE_TOPIC);
end;

procedure TServerMainF.SendData2MQ(AMsg: string; ATopic: string);
begin
  FpjhSTOMPClass.StompSendMsg(AMsg, ATopic);
  StatusBar1.SimplePanel := True;
  StatusBar1.SimpleText := DateTimeToStr(now) + ' => ' + ATopic + ' : ' + Copy(AMsg, 1, 10);
end;

procedure TServerMainF.SetTagData2Grid(ARow: integer; AValue: string);
begin
  TagGrid.Cells[3, ARow] := AValue;
end;

procedure TServerMainF.SetTagName2Grid;
var
  i: integer;
begin
  TagGrid.ClearRows;

  if FOPCServer.FTagList.Count > 0 then
    TagGrid.AddRow(FOPCServer.FTagList.Count);

  for i := 0 to FOPCServer.FTagList.Count - 1 do
  begin
    TagGrid.Cells[1, i] := FOPCServer.FTagList.Item[i].TagName;
  end;

  Label5.Caption := 'Tag Count: ' + IntToStr(GetTagCount);
end;

procedure TServerMainF.Timer1Timer(Sender: TObject);
begin
  SendCollectData2MQ;
end;

procedure TServerMainF.WorkerResult(var msg: TMessage);
begin
  ProcessSubscribeMsg;
end;

{ TServicePMSOPC }

function TServicePMSOPC.GetTagNames: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);
  Result := ServerMainF.GetTagNamesFromList;
end;

procedure TServicePMSOPC.GetTagnames2(out ATagNames: TTagCollect);
var
  LTagList: TTagCollect;
begin
  LTagList := ServerMainF.GetTagNames;
  CopyObject(LTagList, ATagNames);
end;

function TServicePMSOPC.GetTagValues: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
begin
  LDynArr.Init(TypeInfo(TDoubleDynArray),Result,@LCount);
  Result := ServerMainF.GetTagValuesFromList;
end;

end.
