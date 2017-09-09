unit UnitClientMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SynCommons, mORMot, mORMotHttpClient,
  NxColumnClasses, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ExtCtrls, TimerPool,
//  IPCThrd_PMS, IPCThrdClient_PMS,
  UnitTagCollect, UnitIPCClientAll, IPCThrdConst_PMS, UnitBuzzerInterface, UnitPMSOPCInterface,
  EngineParameterClass, IPC_PMS_Const, Vcl.ComCtrls, Vcl.Menus, ParamSaveUnit,
  UnitAlarmCollect, UnitSTOMPClass, UnitWorker4OmniMsgQ;

type
  TDisplayTarget = (dtSendMemo, dtStatusBar);

  TPMSOPCClientF = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ServerIPEdit: TEdit;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    QuitButton: TButton;
    TagGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    TagNameText: TNxTextColumn;
    DescriptText: TNxTextColumn;
    ValueText: TNxTextColumn;
    Timer1: TTimer;
    Button3: TButton;
    SearchEdit: TEdit;
    Button4: TButton;
    Label1: TLabel;
    StatusBar1: TStatusBar;
    NxTextColumn1: TNxTextColumn;
    PopupMenu1: TPopupMenu;
    SaveToFile1: TMenuItem;
    DBNameCombo: TNxComboBoxColumn;
    DBIndex: TNxTextColumn;
    SaveOnlyCB: TNxCheckBoxColumn;
    Label2: TLabel;
    AlarmServerIPEdit: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure QuitButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure SearchEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure SaveToFile1Click(Sender: TObject);
    procedure StatusBar1Click(Sender: TObject);
    procedure TagGridCellColoring(Sender: TObject; ACol, ARow: Integer;
      var CellColor, GridColor: TColor; CellState: TCellState);
  private
    FpjhSTOMPClass: TpjhSTOMPClass;
    FIPCClientAll: TIPCClientAll;
    FSharedMemName: string;
//    FEngineParameter: TEngineParameter;
    FParamFileName: string;
    FAlarmListFileName: string;

    FOldRedLamp,
    FOldYellowLamp,
    FOldGreenLamp,
    FCurRedLamp,
    FCurYellowLamp,
    FCurGreenLamp : TLampType;
    FOldSoundIdx,
    FCurSoundIdx: TSoundType;

    procedure WorkerResult(var msg: TMessage); message MSG_RESULT;
    procedure ProcessResults;
    procedure OnResetLamp(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : LongInt);

    procedure CreateHTTPClient(AServerIP: string);
    procedure CreateAlarmClient(AServerIP: string);
    procedure ConnectToServer;
    procedure InitSTOMP(AUserId, APasswd, AServerIP, ATopic: string);
    procedure DestroySTOMP;

    procedure MakeAlarmListFile;
  public
    FClient: TSQLRestClientURI;
    FAlarmClient: TSQLRestClientURI;
    Database: TSQLRest;
    FModel: TSQLModel;
    FAlarmModel: TSQLModel;
    Server: AnsiString;
    PortNum: string;

    FTagList: TTagCollect;
    FAlarmList: TAlarmList;
    FPJHTimerPool: TPJHTimerPool;
    FTimerHandleList: TStringList;

    procedure GetTagName2Grid;
    procedure GetTagListCollect;
    procedure GetTagValuesFromRest;
    procedure GetTagValuesFromMQ;
    procedure SetDBNameCombo2Grid;
    procedure SaveTagCollect2ParamFile;
    procedure _SetLamp(ARedLamp, AYellowLamp, AGreenLamp, A_dont, ASoundType: integer);
    procedure SetRedLamp(ALampType: TLampType; ASoundType: integer);
    procedure SetYellowLamp(ALampType: TLampType; ASoundType: integer);
    procedure SetGreenLamp(ALampType: TLampType; ASoundType: integer);
    procedure ReSetRedLamp(ALampType: TLampType; ASoundType: integer);
    procedure ReSetYellowLamp(ALampType: TLampType; ASoundType: integer);
    procedure ReSetGreenLamp(ALampType: TLampType; ASoundType: integer);
    procedure BackupLamp;

    procedure SendAlarm2Server;

    procedure DisplayMessage(msg: string; ADspNo: TDisplayTarget);
  end;

var
  PMSOPCClientF: TPMSOPCClientF;

implementation

uses CommonUtil_Unit, OtlComm, StompTypes;

{$R *.dfm}

procedure TPMSOPCClientF.FormActivate(Sender: TObject);
begin
  GetTagName2Grid;
  GetTagListCollect;
  SetDBNameCombo2Grid;
//  Button1Click(nil);
end;

procedure TPMSOPCClientF.FormCreate(Sender: TObject);
begin
//  FEngineParameter := TEngineParameter.Create(nil);
//  FEngineParameter.LoadFromJSONFile('E:\pjh\project\util\PMSOPCRest\common\PMS_OPC.param');
//
//  FSharedMemName := FEngineParameter.EngineParameterCollect.Items[0].SharedName;
  SetCurrentDir(ExtractFilePath(Application.ExeName));
//  FParamFileName := 'E:\pjh\project\util\내구성관리시스템\bin\PMS_OPC.param';
//  FAlarmListFileName := 'E:\pjh\project\util\내구성관리시스템\bin\AlarmList.list';
  FParamFileName := '.\PMS_OPC.param';
  FAlarmListFileName := '.\AlarmList.list';
//  if not Assigned(FIPCClientAll) then
  FIPCClientAll := TIPCClientAll.Create;

  FIPCClientAll.ReadAddressFromParamFile(FParamFileName);
  FIPCClientAll.CreateIPCClientAll;

  if FSharedMemName = '' then
    FSharedMemName := 'PMS_SM';

//  FIPCClient := TIPCClient_PMS.Create(0, FSharedMemName, True);
//  StatusBar1.Panels[0].Text := FIPCClient.FMonitorEvent.SharedMemName;
//  StatusBar1.Panels[1].Text := IntToStr(FIPCClient.FMonitorEvent.SharedMemSize);
  //FSharedMemName;
  FTagList := TTagCollect.Create;
  FAlarmList := TAlarmList.Create(nil);
  FAlarmList.LoadFromJSONFile(FAlarmListFileName);

  FPJHTimerPool := TPJHTimerPool.Create(Self);
  FTimerHandleList := TStringList.Create;
  InitSTOMP('pjh','pjh','10.14.21.116',PPP_PMS_VALUE_TOPIC);
// CreateHTTPClient;
//  PortNum := '8080';
//
//  FModel := CreateSampleModel; // from SampleData unit
//
//  if ParamCount=0 then
//    Server := 'localhost'
//  else
//    Server := AnsiString(Paramstr(1));
//
//  Database := TSQLHttpClient.Create(Server, PortNum, FModel);
//  TSQLHttpClient(Database).SetUser('User','synopse');
end;

procedure TPMSOPCClientF.FormDestroy(Sender: TObject);
begin
//  Database.Free;
  FTimerHandleList.Free;
  FModel.Free;
  FIPCClientAll.Free;
//  FIPCClient.Free;
  FAlarmList.Free;
  FTagList.Free;
  FPJHTimerPool.RemoveAll;
  FPJHTimerPool.Free;
  DestroySTOMP;
//  FEngineParameter.Free;
end;

procedure TPMSOPCClientF.GetTagListCollect;
var
  I: IPMSOPC;
  LDynArr: TRawUTF8DynArray;
  Lip: string;
  Li,LRow: integer;
begin
  I := FClient.Service<IPMSOPC>;

  if I <> nil then
    I.GetTagnames2(FTagList);

  if Assigned(FTagList) then
  begin
    TagGrid.ClearRows;

    for Li := 0 to FTagList.Count - 1 do
    begin
      if FTagList.Item[Li].TagName <> '' then
      begin
        LRow := TagGrid.AddRow;
        TagGrid.Cells[1,LRow] := FTagList.Item[Li].TagName;
      end;
    end;
  end;
end;

procedure TPMSOPCClientF.GetTagName2Grid;
var
  I: IPMSOPC;
  LDynArr: TRawUTF8DynArray;
  Li,LRow: integer;
begin
  ConnectToServer;

  I := FClient.Service<IPMSOPC>;

  if I <> nil then
    LDynArr := I.GetTagNames;

  for Li := 0 to High(LDynArr) - 1 do
  begin
    if LDynArr[Li] <> '' then
    begin
      LRow := TagGrid.AddRow;
      TagGrid.Cells[1,LRow] := LDynArr[Li];
    end;
  end;
end;

procedure TPMSOPCClientF.GetTagValuesFromMQ;
begin

end;

procedure TPMSOPCClientF.GetTagValuesFromRest;
var
  I: IPMSOPC;
//  LDynArr: TDoubleDynArray;
  LDynArr: TRawUTF8DynArray;
  Lip: string;
  Li,LRow: integer;
  LEventData: TEventData_PMS;
begin
  Timer1.Enabled := False;
  try
    if ServerIPEdit.Text <> '' then
      Lip := ServerIPEdit.Text
    else
      Lip := 'localhost';

    CreateHTTPClient(Lip);

  //  if FClient.Services['PMSOPC'].Get(I) then
  //  begin
      LDynArr := nil;

      I := FClient.Service<IPMSOPC>;
      if I <> nil then

  //    if FClient.Services.Info(TypeInfo(IPMSOPC)).Get(I) then
        LDynArr := I.GetTagValues;
  //  end;
  //    lblResult.Caption := IntToStr(I.Add(a,b));

//    LAnalogData.PMSDataType := Ord(pdtAnalog);
//    LDigitalData.PMSDataType := Ord(pdtDigital);

    for Li := 0 to High(LDynArr) - 1 do
    begin
      if LDynArr[Li] <> '' then
      begin
        TagGrid.Cells[3,Li] := LDynArr[Li];
        FTagList.Item[Li].TagValue := LDynArr[Li];

        if Li < High(LEventData.InpDataBuf) then
          LEventData.InpDataBuf[Li] := UTF8ToString(LDynArr[Li]);
      end
      else
        if Li < High(LEventData.InpDataBuf) then
          LEventData.InpDataBuf[Li] := '';
    end;

    FIPCClientAll.PulseEventData_PMSOPC(LEventData);
    DisplayMessage(FIPCClientAll.FEngineParameter.EngineParameterCollect.Items[0].SharedName + ' Pulse Event', dtStatusBar);

//    SendAlarm2Server;
  finally
    Timer1.Enabled := True;
  end;
end;

procedure TPMSOPCClientF.InitSTOMP(AUserId, APasswd, AServerIP, ATopic: string);
begin
  if not Assigned(FpjhSTOMPClass) then
  begin
    FpjhSTOMPClass := TpjhSTOMPClass.CreateWithStr(AUserId,
                                            APasswd,
                                            AServerIP,
                                            ATopic,
                                            Self.Handle);
  end;
end;

procedure TPMSOPCClientF.MakeAlarmListFile;
begin
  with FAlarmList.AlarmCollect.Add do
  begin
    AlarmName := 'VCB_G2_GEN_RUN';
    AlarmIndex := 37;
    BitIndex := 6;
    AlarmDesc := 'VCB_G2_GEN_RUN';
    AlarmType := '';
    AlarmValue := '';
    LampColor := lcGreen;
    SoundType := siPiPi;
    Duration := 3;
    UnitID := '';
  end;
end;

procedure TPMSOPCClientF.OnResetLamp(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
var
  LAlarmItem: TAlarmItem;
  i: integer;
begin
  LAlarmItem := nil;
  i := FTimerHandleList.IndexOf(IntToStr(Handle));

  if (0 <= i) and (i < FTimerHandleList.Count) then
    LAlarmItem := TAlarmItem(FTimerHandleList.Objects[i]);

  if Assigned(LAlarmItem) then
  begin
    case LAlarmItem.LampColor of
      lcRed: ReSetRedLamp(FOldRedLamp, 0);
      lcYellow: ReSetYellowLamp(FOldYellowLamp, 0);
      lcGreen: ReSetGreenLamp(FOldGreenLamp, 0);
    end;
  end;
end;

procedure TPMSOPCClientF.ProcessResults;
var
  msg: TOmniMessage;
  FStompFrame: IStompFrame;
  LUTF8DynArr: TRawUTF8DynArray;
  LDynArr: TDynArray;
  LValue: RawUTF8;
  LCount, Li: integer;
  LEventData: TEventData_PMS;
begin
  while FpjhSTOMPClass.GetResponseQMsg(msg) do
  begin
    FStompFrame := msg.MsgData.AsInterface as IStompFrame;
    LValue := StringToUTF8(FStompFrame.GetBody);
    LDynArr.Init(TypeInfo(TRawUTF8DynArray),LUTF8DynArr,@LCount);
    LDynArr.LoadFromJSON(PUTF8Char(LValue));

    if TagGrid.RowCount = 0 then
      continue;

    for Li := 0 to LDynArr.Count - 1 do
    begin
      if LUTF8DynArr[Li] <> '' then
      begin
        TagGrid.Cells[3,Li] := LUTF8DynArr[Li];
        FTagList.Item[Li].TagValue := LUTF8DynArr[Li];

        if Li < High(LEventData.InpDataBuf) then
          LEventData.InpDataBuf[Li] := UTF8ToString(LUTF8DynArr[Li]);
      end
      else
        if Li < High(LEventData.InpDataBuf) then
          LEventData.InpDataBuf[Li] := '';
    end;

    FIPCClientAll.PulseEventData_PMSOPC(LEventData);
    DisplayMessage(FIPCClientAll.FEngineParameter.EngineParameterCollect.Items[0].SharedName + ' Pulse Event', dtStatusBar);
  end;
end;

procedure TPMSOPCClientF.QuitButtonClick(Sender: TObject);
begin
//  Database.Delete()
  Close;
end;

procedure TPMSOPCClientF.ReSetGreenLamp(ALampType: TLampType;
  ASoundType: integer);
begin
  _SetLamp(Ord(FCurRedLamp), Ord(FCurYellowLamp), Ord(ALampType),0,ASoundType);
end;

procedure TPMSOPCClientF.ReSetRedLamp(ALampType: TLampType;
  ASoundType: integer);
begin
  _SetLamp(Ord(ALampType), Ord(FCurYellowLamp), Ord(FCurGreenLamp),0,ASoundType);
end;

procedure TPMSOPCClientF.ReSetYellowLamp(ALampType: TLampType;
  ASoundType: integer);
begin
  _SetLamp(Ord(FCurRedLamp), Ord(ALampType), Ord(FCurGreenLamp),0,ASoundType);
end;

procedure TPMSOPCClientF.SaveTagCollect2ParamFile;
var
  LFileName:string;
  i: integer;
begin
  for i := 0 to TagGrid.RowCount - 1 do
  begin
    FIPCClientAll.FEngineParameter.EngineParameterCollect.Items[i].Address := 'V' + IntToStr(i+1);
    FIPCClientAll.FEngineParameter.EngineParameterCollect.Items[i].BlockNo := StrToIntDef(TagGrid.CellByName['DBNameCombo',i].AsString,0);
    FIPCClientAll.FEngineParameter.EngineParameterCollect.Items[i].LevelIndex := TagGrid.CellByName['DBIndex',i].AsInteger;
    FIPCClientAll.FEngineParameter.EngineParameterCollect.Items[i].IsSaveItem := TagGrid.CellByName['SaveOnlyCB',i].AsBoolean;

  end;//for

  with TParamSaveF.create(nil) do
  begin
    try
      JvFilenameEdit1.FileName := FParamFileName;

      if ShowModal = mrOK then
      begin
        LFileName := JvFilenameEdit1.FileName;

        if LFileName <> '' then
        begin
          if FileExists(LFileName) then
          begin

            if MessageDlg('이전에 작업한자료가 있습니다. 덮어쓰시겠습니까?',
            mtConfirmation, [mbYes, mbNo], 0)=mrNo then
              exit
            else
            begin
              FIPCClientAll.FEngineParameter.SaveToJSONFile(LFileName);
            end;
          end;
        end
        else
          ShowMessage('File name is empty!');
      end;
    finally
      free;
    end;
  end;
end;

procedure TPMSOPCClientF.SaveToFile1Click(Sender: TObject);
begin
  SaveTagCollect2ParamFile;
end;

procedure TPMSOPCClientF.SearchEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Button4Click(nil);
end;

procedure TPMSOPCClientF.SendAlarm2Server;
var
  i,j: integer;
begin
  with FAlarmList.AlarmCollect do
  begin
    for i := 0 to Count - 1 do
    begin
      if Item[i].BitIndex <> -1 then
      begin
        if IsbitSet(StrToIntDef(FTagList.Item[Item[i].AlarmIndex].TagValue,0), Item[i].BitIndex) then
        begin
          case Item[i].LampColor of
            lcRed: SetRedLamp(Item[i].LampType, Ord(Item[i].SoundType));
            lcYellow: SetYellowLamp(Item[i].LampType, Ord(Item[i].SoundType));
            lcGreen: SetGreenLamp(Item[i].LampType, Ord(Item[i].SoundType));
          end;

          j := FPJHTimerPool.AddOneTime(OnResetLamp, Item[i].Duration);
          FTimerHandleList.AddObject(IntToStr(j), Item[i]);
        end;
      end
      else
      begin

      end;


    end;//for

  end;//with
end;

procedure TPMSOPCClientF.SetDBNameCombo2Grid;
var
  i,j,k1,k2,k3: integer;
begin
  j := 0;
  k1 := 1;
  k2 := 1;
  k3 := 1;

  for i := 0 to TagGrid.RowCount - 1 do
  begin
    j := FIPCClientAll.FEngineParameter.EngineParameterCollect.Items[i].BlockNo;
    TagGrid.CellByName['DBNameCombo',i].AsInteger := j;
//    TagGrid.CellByName['DBIndex',i].AsString := IntToStr(FIPCClientAll.FEngineParameter.EngineParameterCollect.Items[i].LevelIndex);

    case j of
      1: begin
        inc(k1);
        FIPCClientAll.FEngineParameter.EngineParameterCollect.Items[i].LevelIndex := k1;
        TagGrid.CellByName['DBIndex',i].AsInteger := k1;
      end;
      2: begin
        inc(k2);
        FIPCClientAll.FEngineParameter.EngineParameterCollect.Items[i].LevelIndex := k2;
        TagGrid.CellByName['DBIndex',i].AsInteger := k2;
      end;
      3: begin
        inc(k3);
        FIPCClientAll.FEngineParameter.EngineParameterCollect.Items[i].LevelIndex := k3;
        TagGrid.CellByName['DBIndex',i].AsInteger := k3;
      end;
    end;

    TagGrid.CellByName['SaveOnlyCB',i].AsBoolean := FIPCClientAll.FEngineParameter.EngineParameterCollect.Items[i].IsSaveItem;
//    if FIPCClientAll.FEngineParameter.EngineParameterCollect.Items[i].Alarm then
//      TagGrid.CellByName['DBNameCombo',i].AsInteger := 1
//    else
//      TagGrid.CellByName['DBNameCombo',i].AsInteger := 2;
  end;//for
end;

procedure TPMSOPCClientF.SetGreenLamp(ALampType: TLampType;
  ASoundType: integer);
begin
  _SetLamp(0,0,Ord(ALampType),0,ASoundType);
end;

procedure TPMSOPCClientF.SetRedLamp(ALampType: TLampType; ASoundType: integer);
begin
  _SetLamp(Ord(ALampType),0,0,0,ASoundType);
end;

procedure TPMSOPCClientF.SetYellowLamp(ALampType: TLampType;
  ASoundType: integer);
begin
  _SetLamp(0,Ord(ALampType),0,0,ASoundType);
end;

procedure TPMSOPCClientF.StatusBar1Click(Sender: TObject);
begin
  StatusBar1.SimplePanel := not StatusBar1.SimplePanel;
end;

procedure TPMSOPCClientF.TagGridCellColoring(Sender: TObject; ACol,
  ARow: Integer; var CellColor, GridColor: TColor; CellState: TCellState);
begin
  if ARow < TagGrid.RowCount then
  begin
    case TagGrid.Cell[4,ARow].AsInteger of
      1: CellColor := clSkyBlue;
      2: CellColor := clMoneyGreen;
      3: CellColor := clOlive;
    end;
  end;
end;

procedure TPMSOPCClientF.Timer1Timer(Sender: TObject);
begin
//  GetTagValuesFromRest;
end;

procedure TPMSOPCClientF.WorkerResult(var msg: TMessage);
begin
  ProcessResults;
end;

procedure TPMSOPCClientF._SetLamp(ARedLamp, AYellowLamp, AGreenLamp, A_dont,
  ASoundType: integer);
var
  I: IBuzzerServer;
begin
  I := FAlarmClient.Service<IBuzzerServer>;

  if I <> nil then
  begin
    BackupLamp;

    I.SetLamp(ARedLamp, AYellowLamp, AGreenLamp, A_dont, ASoundType);

    FCurRedLamp := TLampType(ARedLamp);
    FCurYellowLamp := TLampType(AYellowLamp);
    FCurGreenLamp := TLampType(AGreenLamp);
    FCurSoundIdx := TSoundType(ASoundType);
  end;
end;

//procedure TPMSOPCClientF.SetRedLamp(ALampType: TLampType;
//  ASoundType: TSoundType);
//begin
//  _SetLamp(Ord(ALampType),0,0,0,Ord(ASoundType));
//end;

procedure TPMSOPCClientF.BackupLamp;
begin
  FOldRedLamp := FCurRedLamp;
  FOldYellowLamp := FCurYellowLamp;
  FOldGreenLamp := FCurGreenLamp;
  FOldSoundIdx := FCurSoundIdx;
end;

procedure TPMSOPCClientF.Button1Click(Sender: TObject);
begin
//  GetTagValues;
  Timer1.Enabled := not Timer1.Enabled;
end;

procedure TPMSOPCClientF.Button2Click(Sender: TObject);
begin
//  _SetLamp(1,0,0,0,0);

  GetTagName2Grid;
end;

procedure TPMSOPCClientF.Button3Click(Sender: TObject);
begin
  ConnectToServer;

  GetTagListCollect;
end;

procedure TPMSOPCClientF.Button4Click(Sender: TObject);
begin
  if TagGrid.SearchRow(SearchEdit.Text) then
    TagGrid.SetFocus;
end;

procedure TPMSOPCClientF.ConnectToServer;
var
  Lip: string;
begin
  if ServerIPEdit.Text <> '' then
    Lip := ServerIPEdit.Text
  else
    Lip := 'localhost';

  CreateHTTPClient(Lip);

//  if AlarmServerIPEdit.Text <> '' then
//    Lip := AlarmServerIPEdit.Text
//  else
//    Lip := 'localhost';
//
//  CreateAlarmClient(Lip);
end;

procedure TPMSOPCClientF.CreateAlarmClient(AServerIP: string);
begin
  if FAlarmClient = nil then
  begin
    if FAlarmModel=nil then
      FAlarmModel := TSQLModel.Create([],ALARM_ROOT_NAME);

    FAlarmClient := TSQLHttpClient.Create(AServerIP,ALARM_PORT,FAlarmModel);

    if not FAlarmClient.ServerTimeStampSynchronize then begin
      ShowMessage(UTF8ToString(FAlarmClient.LastErrorMessage));
      exit;
    end;

    //TSQLRestServerAuthenticationNone.ClientSetUser(Client,'User','');
    FAlarmClient.SetUser('User','synopse');
    FAlarmClient.ServiceRegister([TypeInfo(IBuzzerServer)],sicShared);
  end;
end;

procedure TPMSOPCClientF.CreateHTTPClient(AServerIP: string);
begin
  if FClient = nil then
  begin
    if FModel=nil then
      FModel := TSQLModel.Create([],ROOT_NAME);

    FClient := TSQLHttpClient.Create(AServerIP,PORT_NAME,FModel);

    if not FClient.ServerTimeStampSynchronize then begin
      ShowMessage(UTF8ToString(FClient.LastErrorMessage));
      exit;
    end;

    //TSQLRestServerAuthenticationNone.ClientSetUser(Client,'User','');
    FClient.SetUser('User','synopse');
    FClient.ServiceRegister([TypeInfo(IPMSOPC)],sicShared);
  end;
end;

procedure TPMSOPCClientF.DestroySTOMP;
begin
  FpjhSTOMPClass.Free;
end;

procedure TPMSOPCClientF.DisplayMessage(msg: string; ADspNo: TDisplayTarget);
begin
//  if FToggleBackground then
//    Protocol.Color := $0080FF80
//  else
//    Protocol.Color := clWhite;

  case ADspNo of
    dtSendMemo : begin
      if msg = ' ' then
      begin
        exit;
      end
      else
        ;

//      with Protocol do
//      begin
//        if Lines.Count > 100 then
//          Clear;
//
//        Lines.Add(msg);
//      end;//with
    end;//dtSendMemo

    dtStatusBar: begin
       StatusBar1.SimplePanel := True;
       StatusBar1.SimpleText := DateTimeToStr(now) + ' => ' + msg;
    end;//dtStatusBar
  end;//case

end;

end.
