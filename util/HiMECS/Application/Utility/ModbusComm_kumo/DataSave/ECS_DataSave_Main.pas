unit ECS_DataSave_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus, DataSaveConst, ComCtrls,
  IPCThrd_ECS_kumo, DataSave2FileThread, DataSave2DBThread, SyncObjs,inifiles,
  DataSaveConfig, IPCThrdMonitor_ECS_kumo, IPCThrdMonitor_Dynamo, DeCAL,
  janSQL, commonUtil, IPCThrd_dynamo;

type
  TDisplayTarget = (dtSendMemo, dtRecvMemo, dtStatusBar);
  TDataSaveMain = class(TForm)
    MainMenu1: TMainMenu;
    FILE1: TMenuItem;
    HELP1: TMenuItem;
    Timer1: TTimer;
    Protocol: TMemo;
    StatusBar1: TStatusBar;
    CB_Active: TCheckBox;
    Connect1: TMenuItem;
    Disconnect1: TMenuItem;
    Close1: TMenuItem;
    Option1: TMenuItem;
    Help2: TMenuItem;
    N1: TMenuItem;
    About1: TMenuItem;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    RB_byevent: TRadioButton;
    CB_DBlogging: TCheckBox;
    CB_CSVlogging: TCheckBox;
    RB_byinterval: TRadioButton;
    ED_interval: TEdit;
    ED_csv: TEdit;
    Label1: TLabel;
    RB_bydate: TRadioButton;
    RB_byfilename: TRadioButton;
//    GLUserShader1: TGLUserShader;
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CB_ActiveClick(Sender: TObject);
    procedure Connect1Click(Sender: TObject);
    procedure Disconnect1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure RB_bydateClick(Sender: TObject);
    procedure RB_byfilenameClick(Sender: TObject);
    procedure RB_byeventClick(Sender: TObject);
    procedure RB_byintervalClick(Sender: TObject);
    procedure Option1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure CB_DBloggingClick(Sender: TObject);
  private
    //DB에 데이터저장을 위한 변수선언부
    FDataSave2DBThread: TDataSave2DBThread; //DB에 데이타 저장하는 객체
    FHostName: string;//DB Host Name(IP address)
    FDBName: string;  //DB Name(Mysql의 DB Name)
    FLoginID: string;   //Login Name
    FPasswd: string;  //Password
    FSaveDataBuf_Value1: double;
    FSaveDataBuf_Value2: double;

    //CSV 파일 저장을 위한 변수선언부///////////////////////////////////////////
    FLogStart: Boolean;  //Log save Start sig.
    FTagNameBuf: string;  //파일에 제목을 저장하기 위한 버퍼
    FSaveFileName: string; //데이타를 저장할 File 이름(설정에 따라 변경됨)
    FSaveDataBuf: string; //파일에 저장할 데이타를 저장하는 버퍼
    FSaveDBDataBuf: string; //DB에 저장할 데이타를 저장하는 버퍼
    FFileName_Convention: TFileName_Convetion;//파일에 저장시에 파일이름부여 방법
    FDataSave2FileThread: TDataSave2FileThread;//파일에 데이타 저장하는 객체
    FCSVHeader: string;
    FDynamoHeader:string;
    FDynamoCSVData: string;

    //ECS를 위한 변수 선언부
    FECSData: TEventData_ECS_kumo;
    FMapFileName: string;   //Modbus Map 파일 이름
    FMapFilePath: string;   //Map이 있는파일 경로
    FAddressMap: DMap;      //Modbus Map 데이타 저장 구초체
    FjanDB : TjanSQL; //text 기반 SQL DB
    FHiMap: THiMap;         //Modbus Address 구조체 -> 동적으로 생성함

    //Dynamo를 위한 변수 선언부
    FDynamoData: TEventData_Dynamo;

    //Critical Section 변수선언부///////////////////////////////////////////////
    FCriticalSection: TCriticalSection;

    //ECS를 위한 함수 선언부
    procedure ReadMapAddress(AddressMap: DMap; MapFileName: string);
    procedure ECS_OnSignal(Sender: TIPCThread_ECS_kumo; Data: TEventData_ECS_kumo);
    procedure Dynamo_OnSignal(Sender: TIPCThread_Dynamo; Data: TEventData_Dynamo);
    procedure UpdateTrace_ECS_kumo(var Msg: TEventData_ECS_kumo); message WM_EVENT_ECS;
    procedure UpdateTrace_Dynamo(var Msg: TEventData_Dynamo); message WM_EVENT_DYNAMO;
    procedure Value2Screen(BlockNo: integer);
    procedure Value2Screen_Analog(Name: string; AValue: Integer; AMaxVal: real);
    procedure Value2Screen_Digital(Name: string; AValue: Integer;
                                    AMaxVal: real; AContact: integer);

    //ini 파일 설정과 저장을 위한 함수 선언부
    procedure LoadConfigDataini2Form(FSaveConfigF: TSaveConfigF);
    procedure SaveConfigDataForm2ini(FSaveConfigF: TSaveConfigF);
    procedure LoadConfigDataini2Var;
  public
    { Public declarations }
    FFilePath: string;      //파일을 저장할 경로
    FIPCMonitor_ECS_kumo: TIPCMonitor_ECS_kumo;//공유 메모리 및 이벤트 객체
    FIPCMonitor_Dynamo: TIPCMonitor_Dynamo;//공유 메모리 및 이벤트 객체
    FMonitorStart: Boolean; //타이머 동작 완료하면 True
    FSharedMMName: string;  //공유 메모리 이름
    FDynamoSharedMMName: string;// Dynamo 공유메모리 이름
    //DB 저장시 모든 데이터 수신 후 DB 입력해야 하므로 현재 수신된 Block No가 필요
    FCurrentBlockNo: integer;
    FLastBlockNo: integer;

    procedure SaveData2DB;
    procedure SaveData2File;
    procedure CreateSave2DBThread;
    procedure CreateSave2FileThread;
    procedure DisplayMessage(msg: string; ADspNo: TDisplayTarget);
    procedure DisplayMessage2SB(Msg: string);
    procedure DestroySave2FileThread;
    procedure DestroySave2DBThread;
  end;

var
  DataSaveMain: TDataSaveMain;
//  DataSave_Start: Boolean;

implementation

uses HiMECSConst;

{$R *.dfm}

procedure TDataSaveMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FCriticalSection.Enter;
  FMonitorStart := False;
  try
    if Assigned(FDataSave2FileThread) then
    begin
      FDataSave2FileThread.Terminate;
      FDataSave2FileThread.FDataSaveEvent.Signal;
      FDataSave2FileThread.Free;
    end;//if

    if Assigned(FDataSave2DBThread) then
    begin
      FDataSave2DBThread.Terminate;
      FDataSave2DBThread.FDataSaveEvent.Signal;
      FDataSave2DBThread.Free;
    end;//if

    ObjFree(FAddressMap);
    FAddressMap.free;
    FIPCMonitor_ECS_kumo.Free;
    FIPCMonitor_Dynamo.Free;

  finally
    FCriticalSection.Leave;
  end;//try

  FCriticalSection.Free;
end;

////////////////////////////////////////////////////////////////////////////////
//프로그램 초기화 Timer1Timer 구문
procedure TDataSaveMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  ED_CSV.Text := FormatDatetime('yyyymmdd',date)+'.'+'CSV';
  FFilePath := ExtractFilePath(Application.ExeName);

  LoadConfigDataini2Var;

  //IPC Monitor 함수 초기화 구문
  FIPCMonitor_ECS_kumo := TIPCMonitor_ECS_kumo.Create(0, FSharedMMName, True);
  FIPCMonitor_ECS_kumo.OnSignal := ECS_OnSignal;
  DisplayMessage('Shared Memory: ' + FSharedMMName + ' Created!', dtSendMemo);

  FIPCMonitor_Dynamo := TIPCMonitor_Dynamo.Create(0, FDynamoSharedMMName, True);
  FIPCMonitor_Dynamo.OnSignal := Dynamo_OnSignal;
  DisplayMessage('Shared Memory: ' + FDynamoSharedMMName + ' Created!', dtSendMemo);

  FAddressMap := DMap.Create;
  ReadMapAddress(FAddressMap,FMapFileName);

  CreateSave2FileThread;
end;

//Map address 읽기 함수
procedure TDataSaveMain.ReadMapAddress(AddressMap: DMap; MapFileName: string);
var
  sqltext: string;
  sqlresult, reccnt, fldcnt: integer;
  i: integer;
  filename, fcode: string;
begin
  if fileexists(MapFileName) then //FFilePath
  begin
    Filename := ExtractFileName(MapFileName);
    FileName := Copy(Filename,1, Pos('.',Filename) - 1);
    FMapFilePath := ExtractFilePath(MapFileName);
    FjanDB :=TjanSQL.create;
    try
      sqltext := 'connect to ''' + FMapFilePath + '''';

      sqlresult := FjanDB.SQLDirect(sqltext);
      //Connect 성공
      if sqlresult <> 0 then
      begin
        with FjanDB do
        begin
          sqltext := 'select * from ' + FileName + ' group by cnt';
          sqlresult := SQLDirect(sqltext);
          //Query 정상
          if sqlresult <> 0 then
          begin
            //데이타 건수가 1개 이상 있으면
            if sqlresult>0 then
            begin
              fldcnt := RecordSets[sqlresult].FieldCount;
              //Field Count가 0 이면
              if fldcnt = 0 then exit;

              reccnt := RecordSets[sqlresult].RecordCount;
              //Record Count가 0 이면
              if reccnt = 0 then exit;

              for i := 0 to reccnt - 1 do
              begin
                FHiMap := THiMap.Create;
                with FHiMap, RecordSets[SqlResult].Records[i] do
                begin
                  FName := Fields[0].Value;
                  FDescription := Fields[1].Value;
                  FSid := StrToInt(Fields[2].Value);
                  FAddress := Fields[3].Value;
                  FBlockNo := StrToInt(Fields[4].Value);
                  //kumo ECS를 Value2Screen_ECS_kumo 함수에서 처리하기 위함
                  FUnit := Fields[5].Value;
                  
                  if Fields[5].Value = 'FALSE' then
                  begin
                    FAlarm := False;
                    fcode := '1';
                  end
                  else if Fields[5].Value = 'TRUE4' then
                  begin
                    FAlarm := True;
                    fcode := '4';
                  end
                  else if Fields[5].Value = 'TRUE' then
                  begin
                    FAlarm := True;
                    fcode := '3';
                  end
                  else if Fields[5].Value = 'FALSE3' then
                  begin
                    FAlarm := False;
                    fcode := '3';
                  end;

                  FMaxval := StrToFloatDef(Fields[6].Value, 0.0);
                  FContact := StrToIntDef(Fields[7].Value, 0);
                  FUnit := '';
                  if Uppercase(FName) <> 'DUMMY' then
                    FCSVHeader := FCSVHeader + ',' + FName;
                end;//with
                AddressMap.PutPair([fcode + FHiMap.FAddress,FHiMap]);
              end;//for
            end;

            FDynamoHeader := ',Power,Torque,RPM,Bearing TB Temp,Bearing MTR Temp,';
            FDynamoHeader := FDynamoHeader + 'Water Inlet Temp,Water Outlet Temp,Body1 Press,Body2 Press,';
            FDynamoHeader := FDynamoHeader + 'Inlet Open 1,Inlet Open 2, Outlet Open1, Outlet Open2';
          end
          else
            DisplayMessage(FjanDB.Error, dtSendMemo);
        end;//with
      end
      else
        Application.MessageBox('Connect 실패',
            PChar('폴더 ' + FFilePath + ' 를 만든 후 다시 하시오'),MB_ICONSTOP+MB_OK);
    finally
      FjanDB.Free;
    end;
  end
  else
  begin
    sqltext := FileName + '파일을 만든 후에 다시 하시오';
    Application.MessageBox('Data file does not exist!', PChar(sqltext) ,MB_ICONSTOP+MB_OK);
  end;
end;
//On signal - Client 프로그램이 공용 메모리에 데이터 저장확인
procedure TDataSaveMain.ECS_OnSignal(Sender: TIPCThread_ECS_kumo; Data: TEventData_ECS_kumo);
var
  i,dcount: integer;
begin
  if not FMonitorStart then
    exit;

  FillChar(FECSData.InpDataBuf[0], High(FECSData.InpDataBuf) - 1, #0);
  FECSData.ModBusMode := Data.ModBusMode;
  
  if Data.ModBusMode = 0 then //ASCII Mode이면
  begin
    //ModePanel.Caption := 'ASCII Mode';
    dcount := Data.NumOfData;
    FECSData.NumOfBit := Data.NumOfBit;

    for i := 0 to dcount - 1 do
      FECSData.InpDataBuf[i] := Data.InpDataBuf[i];
  end
  else
  if Data.ModBusMode = 1 then// RTU Mode 이면
  begin
    //ModePanel.Caption := 'RTU Mode';
    dcount := Data.NumOfData div 2;
    FECSData.NumOfBit := Data.NumOfBit;

    if dcount = 0 then
      Inc(dcount);

    for i := 0 to dcount - 1 do
    begin
      FECSData.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      FECSData.InpDataBuf[i] := FECSData.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//      FModBusData.InpDataBuf[i] :=  ;
    end;

    if (Data.NumOfData mod 2) > 0 then
      FECSData.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
  end;//else

  FECSData.ModBusAddress := Data.ModBusAddress;

  FECSData.NumOfData := dcount;
  FECSData.ModBusFunctionCode := Data.ModBusFunctionCode;

  DisplayMessage2SB(FECSData.ModBusAddress + ' 데이타 도착');

  SendMessage(Handle, WM_EVENT_ECS, 0,0);
end;
//On signal에서 받은 데이터 정리
procedure TDataSaveMain.UpdateTrace_Dynamo(var Msg: TEventData_Dynamo);
begin
  FDynamoCSVData := FloatToStr(FDynamoData.FPower);
  FDynamoCSVData := FDynamoCSVData + ',' + FloatToStr(FDynamoData.FTorque);
  FDynamoCSVData := FDynamoCSVData + ',' + FloatToStr(FDynamoData.FRevolution);
  FDynamoCSVData := FDynamoCSVData + ',' + FloatToStr(FDynamoData.FBrgTBTemp);
  FDynamoCSVData := FDynamoCSVData + ',' + FloatToStr(FDynamoData.FBrgMTRTemp);
  FDynamoCSVData := FDynamoCSVData + ',' + FloatToStr(FDynamoData.FWaterInletTemp);
  FDynamoCSVData := FDynamoCSVData + ',' + FloatToStr(FDynamoData.FWaterOutletTemp);
  FDynamoCSVData := FDynamoCSVData + ',' + FloatToStr(FDynamoData.FBody1Press);
  FDynamoCSVData := FDynamoCSVData + ',' + FloatToStr(FDynamoData.FBody2Press);
  FDynamoCSVData := FDynamoCSVData + ',' + FloatToStr(FDynamoData.FInletOpen1);
  FDynamoCSVData := FDynamoCSVData + ',' + FloatToStr(FDynamoData.FInletOpen2);
  FDynamoCSVData := FDynamoCSVData + ',' + FloatToStr(FDynamoData.FOutletOpen1);
  FDynamoCSVData := FDynamoCSVData + ',' + FloatToStr(FDynamoData.FOutletOpen2);

  DisplayMessage2SB('Dynamo Data 처리중...');
end;

procedure TDataSaveMain.UpdateTrace_ECS_kumo(var Msg: TEventData_ECS_kumo);
var
  it: DIterator;
  pHiMap: THiMap;
  i, j, BlockNo: integer;
  tmpStr: string;
  tmpByte, ProcessBitCnt: Byte;
  IsFirst, IsSecond: Boolean;
begin
  BlockNo := 0;
  i := 0;
  j := 0;
  ProcessBitCnt := 0;

  IsFirst := True;
  IsSecond := False;

  tmpStr := IntToStr(FECSData.ModBusFunctionCode) + FECSData.ModBusAddress;
  it := FAddressMap.locate( [tmpStr] );
  SetToValue(it);

  while not atEnd(it) do
  begin
    if i > FECSData.NumOfData - 1 then
      break;

    pHiMap := GetObject(it) as THiMap;

    if (FECSData.ModBusFunctionCode = 3) or (FECSData.ModBusFunctionCode = 4) then
    begin
      pHiMap.FValue := FECSData.InpDataBuf[i];
      Inc(i);
      BlockNo := pHiMap.FBlockNo;
      Advance(it);
    end
    else
    begin
      BlockNo := pHiMap.FBlockNo;
      for i := 0 to FECSData.NumOfData - 1 do
      begin
        tmpByte := Hi(FECSData.InpDataBuf[i]);
        for j := 0 to 7 do
        begin
          pHiMap := GetObject(it) as THiMap;
          if not atEnd(it) then
          begin
            pHiMap.FValue := GetBitVal(tmpByte, j);
            Inc(ProcessBitCnt);
            Advance(it);
          end;
        end;

        tmpByte := Lo(FECSData.InpDataBuf[i]);
        for j := 0 to 7 do
        begin
          pHiMap := GetObject(it) as THiMap;
          if not atEnd(it) then
          begin
            pHiMap.FValue := GetBitVal(tmpByte, j);
            Inc(ProcessBitCnt);
            Advance(it);
          end;
        end;
      end;

      if ((FECSData.NumOfBit div 8) mod 2) > 0 then
      begin
        tmpByte := Lo(FECSData.InpDataBuf[i]);
        for j := 0 to 7 do
        begin
          pHiMap := GetObject(it) as THiMap;
          if not atEnd(it) then
          begin
            pHiMap.FValue := GetBitVal(tmpByte, j);
            Inc(ProcessBitCnt);
            Advance(it);
          end;
        end;
      end;
    end;

  end;//while

  DisplayMessage2SB(FECSData.ModBusAddress + ' 처리중...');

  //수신된 데이타를 화면에 뿌려줌
  Value2Screen(BlockNo);
end;
//데이터의 저장
procedure TDataSaveMain.Value2Screen(BlockNo: integer);
var
  it: DIterator;
  pHiMap: THiMap;
  Lstr: string;
begin
  if BlockNo = 0 then
    exit;

  //첫번째 저장일 경우 1 Cycle skip(중간부터 저장될 수 있으므로)
  if FlogStart then
  begin
    if FLastBlockNo > BlockNo then
    begin
      exit;
    end
    else //BlockNo == 5
    begin
      FlogStart := False;
      exit;
    end;
  end;

  FCurrentBlockNo := BlockNo;

  it := FAddressMap.start;

  DisplayMessage(#13#10+TimeToStr(Time)+' Data Received', dtSendMemo);
  //FSaveDataBuf := TimeToStr(Time);

  while not atEnd(it) do
  begin
    pHiMap := GetObject(it) as THiMap;

    if pHiMap.FBlockNo = BlockNo then
    begin
      //CSV에 데이터 저장
      if CB_CSVlogging.Checked then
      begin
        if UpperCase(pHiMap.FName) <> 'DUMMY' then
        begin
          if pHiMap.FAlarm then
          begin
            if pHiMap.FMaxval > 0.0 then
            begin
              if (UpperCase(pHiMap.FName) = 'AI_TC_A_RPM') or
                (UpperCase(pHiMap.FName) = 'AI_TC_B_RPM') then
                FSaveDataBuf := FSaveDataBuf+ ',' + FloatToStr(pHiMap.FValue * pHiMap.FMaxval)
              else
                FSaveDataBuf := FSaveDataBuf+ ',' + FloatToStr(pHiMap.FValue / pHiMap.FMaxval);
            end
            else
              FSaveDataBuf := FSaveDataBuf+ ',' + FloatToStr(pHiMap.FValue);

            //FSaveDataBuf := FSaveDataBuf+ ',' + FloatToStr(pHiMap.FValue * pHiMap.FMaxval / 4095);
            //FSaveDBDataBuf := FSaveDBDataBuf+ ',' + FloatToStr(pHiMap.FValue * pHiMap.FMaxval / 4095);
          end
          else
          begin
            if pHiMap.FValue > 0 then
              Lstr := 'TRUE'
            else
              Lstr := 'FALSE';

            FSaveDataBuf := FSaveDataBuf+ ',' + LStr;
            FSaveDBDataBuf := FSaveDBDataBuf+ ',' + LStr;
          end;
        end;//if
      end;//if
    end;//if

    Advance(it);

  end;//while

  if CB_CSVlogging.Checked then
  begin
    if FLastBlockNo = FCurrentBlockNo then
    begin
      FSaveDataBuf := FSaveDataBuf+ ',' + FDynamoCSVData;
      SaveData2File;    //CSV 파일에 저장
    end;
  end;

  if CB_DBlogging.Checked then
  begin
    SaveData2DB;      //DB에 저장
  end;
end;//begin

//Analog 데이터의 저장
procedure TDataSaveMain.Value2Screen_Analog(Name: string; AValue: Integer;
  AMaxVal: real);
begin
{  DisplayMessage(#13#10+TimeToStr(Time)+' Data Received', dtSendMemo);

  //CSV 파일에 저장할 경우
  if CB_CSVlogging.Checked then
  begin
    if (Name = '0106') then
    begin
      FSaveDataBuf :=TimeToStr(Time)+','+Name+','+FloatToStr(AValue * AMaxVal);
      SaveData2File;
    end
    else
    begin
      FSaveDataBuf :=TimeToStr(Time)+','+Name+','+FloatToStr(AValue * AMaxVal);
      SaveData2File;
    end;
  end;

  //오라클 데이터 베이스에 저장할 경우
  if CB_DBlogging.Checked then
  begin
    if not Assigned(FDataSave2DBThread) then
    begin
      DisplayMessage('DataBase is not connected', dtSendMemo);
      exit;
    end;

    if (Name = '0106') then
    begin
      if FDataSave2DBThread.ZConnection1.Connected then
      begin
        FSaveDataBuf_Name := Name;
        FSaveDataBuf_Value := AValue * AMaxVal;
      end
      else
      begin
        FSaveDataBuf_Name := Name;
        FSaveDataBuf_Value := AValue * AMaxVal;
      end;
    end
    else if not FDataSave2DBThread.ZConnection1.Connected then
    begin
      DisplayMessage('Server Disconnected! Please Connect Again', dtSendMemo);
    end;
  end;
}
end;

//Digital 데이터의 저장
procedure TDataSaveMain.Value2Screen_Digital(Name: string; AValue: Integer;
  AMaxVal: real; AContact: integer);
begin
;
end;

////////////////////////////////////////////////////////////////////////////////
//메인메뉴-Connect 버튼
procedure TDataSaveMain.Connect1Click(Sender: TObject);
begin
  CreateSave2DBThread;
end;
//메인메뉴-Disconnect 버튼
procedure TDataSaveMain.Disconnect1Click(Sender: TObject);
begin
  FDataSave2DBThread.DisConnectDB;
  DisplayMessage('Server Disconnected'+#13#10, dtSendMemo);
end;
//메인메뉴-Close 버튼
procedure TDataSaveMain.Close1Click(Sender: TObject);
begin
  Close;
end;
//메인메뉴-Option 버튼
procedure TDataSaveMain.Option1Click(Sender: TObject);
var
  FSaveConfigF: TSaveConfigF;
begin
  FSaveConfigF := TSaveConfigF.Create(Application);

  with FSaveConfigF do
  begin
    try
      SharedName2Combo(Ed_sharedmemory);
      SharedName2Combo(Ed_DynamoMM);

      LoadConfigDataini2Form(FSaveConfigF);
      if ShowModal = mrOK then
      begin
        SaveConfigDataForm2ini(FSaveConfigF);
        LoadConfigDataini2Var;
      end;
    finally
      Free;
    end;
  end;
end;
//메인메뉴-About 버튼
procedure TDataSaveMain.About1Click(Sender: TObject);
begin
  DisplayMessage (
  #13#10+#13#10
  +'#######################'+#13#10
  +'DataSave Program'+#13#10
  +'for AVAT ECS'+#13#10
  +'2010.4.30'+#13#10
  +'#######################'+#13#10, dtSendMemo);
end;

//Active 버튼 클릭
procedure TDataSaveMain.CB_ActiveClick(Sender: TObject);
begin
  //Data save를 시작했을 경우
  if CB_Active.Checked then
  begin
    FMonitorStart := True;
    DisplayMessage (#13#10+ '#####################' +#13#10+ TimeToStr(Time)+' Start Data Receiving', dtSendMemo);
    FLogStart := True;

    //CSV 파일에 Data Save할 경우
    if CB_CSVlogging.Checked then
    begin
      FSaveDataBuf :=#13#10+TimeToStr(Time) + FCSVHeader + ',' + FDynamoHeader;
      FSaveFileName := ED_csv.Text;
      SaveData2File;
    end;

    //공유메모리 모니터쓰레드 동작 시작
    FIPCMonitor_ECS_kumo.Resume;

    //Data save 도중엔 세팅변경 불가
    CB_DBlogging.Enabled := False;
    CB_CSVlogging.Enabled := False;
    RB_bydate.Enabled := False;
    RB_byfilename.Enabled := False;
    ED_csv.Enabled := False;
    RB_byevent.Enabled := False;
    RB_byinterval.Enabled := False;
    ED_interval.Enabled := False;
  end

  //Data save를 종료할 경우
  else
  begin
    FMonitorStart := False;
    DisplayMessage (TimeToStr(Time)+#13#10+' Processing terminated', dtSendMemo);
    FlogStart := False;
    FIPCMonitor_ECS_kumo.Suspend;    //공유메모리 모니터쓰레드 동작 중지

    //Data save해제와 동시에 각 버튼 세팅변경불가 해지
    CB_DBlogging.Enabled := True;
    CB_CSVlogging.Enabled := True;
    RB_bydate.Enabled := True;
    RB_byfilename.Enabled := True;

    if RB_byfilename.Checked then
    begin
      ED_csv.Enabled := True;
    end;
    RB_byevent.Enabled := True;
    RB_byinterval.Enabled := True;
    if RB_byinterval.Checked then
    begin
      ED_interval.Enabled := True;
    end;
  end;
end;

procedure TDataSaveMain.CB_DBloggingClick(Sender: TObject);
begin

end;

////////////////////////////////////////////////////////////////////////////////
//Save by date 라디오 버튼
procedure TDataSaveMain.RB_bydateClick(Sender: TObject);
begin
  FFileName_Convention := FC_YMD;
  ED_CSV.Text := FormatDatetime('yyyymmdd',date)+'.'+'CSV';
  ED_csv.enabled := False;
end;

//Save by filename 라디오 버튼
procedure TDataSaveMain.RB_byfilenameClick(Sender: TObject);
begin
  FFileName_Convention := FC_FIXED;
  ED_csv.enabled := True;
end;

//Save by interval 라디오 버튼//////////////////////////////////////////////////
procedure TDataSaveMain.RB_byintervalClick(Sender: TObject);
begin
  ED_interval.Enabled := True;
  ED_interval.Text := '1000';
end;

//Save by event 라디오 버튼/////////////////////////////////////////////////////
procedure TDataSaveMain.RB_byeventClick(Sender: TObject);
begin
  ED_interval.Enabled := False;
  ED_interval.Text := '';
end;

////////////////////////////////////////////////////////////////////////////////
//DB 저장 쓰레드 생성 함수
procedure TDataSaveMain.CreateSave2DBThread;
begin
  if not Assigned(FDataSave2DBThread) then
  begin
    FDataSave2DBThread := TDataSave2DBThread.Create(Self);
    with FDataSave2DBThread do
    begin
      //FHostName := Self.FHostName;
      //FDBName := Self.FDBName;
      //FLoginID := Self.FLoginID;
      //FPasswd := Self.FPasswd;
      if FDataSave2DBThread.OraSession1.Connected then
      begin
        DisplayMessage ('Server Connected', dtSendMemo);
        Resume;
      end
    end;//with
  end//if
  else if not FDataSave2DBThread.OraSession1.Connected then
  begin
    FDataSave2DBThread.ConnectDB;
    if FDataSave2DBThread.OraSession1.Connected then
      DisplayMessage ('Server Re-Connected', dtSendMemo);
  end;
end;

//DB 저장 쓰레드 명령 함수
procedure TDataSaveMain.SaveData2DB;
begin
  //if FCurrentBlockNo < 5 then
  //  exit;

  with FDataSave2DBThread do
  begin
    FStrData := FSaveDBDataBuf; //저장할 데이터(FSaveDataBuf)를 변수(FStrData)에 입력
    FSaveDBDataBuf := '';

    if not FSaving then
      FDataSaveEvent.Signal;
  end;//with
end;

//DB 저장 쓰레드 제거 함수
procedure TDataSaveMain.DestroySave2DBThread;
begin
  if Assigned(FDataSave2DBThread) then
  begin
    FDataSave2DBThread.Terminate;
    FDataSave2DBThread.FDataSaveEvent.Signal;
    FDataSave2DBThread.Free;
    FDataSave2DBThread := nil;
  end;//if

end;

////////////////////////////////////////////////////////////////////////////////
//CSV 파일 저장 쓰레드  생성 함수
procedure TDataSaveMain.CreateSave2FileThread;
begin
  if not Assigned(FDataSave2FileThread) then
  begin
    FDataSave2FileThread := TDataSave2FileThread.Create(Self);
    FDataSave2FileThread.Resume;
  end;
end;
//CSV 파일 저장 명령 함수
procedure TDataSaveMain.SaveData2File;
begin
  with FDataSave2FileThread do
  begin
    FStrData := FSaveDataBuf; //저장할 데이터(FSaveDataBuf)를 변수(FStrData)에 입력
    FTagData := FTagNameBuf;  //최초에 저장파일 생성 시 헤더(머릿말) 입력
    FName_Convention := FFileName_Convention; //파일명을 지정해주는 방법설정
    FFileName := FSaveFileName; //파일명 지정 (FName_Convention이 FC_Fixed에서만 사용)
    if not FSaving then
      DisplayMessage(TimeToStr(Time)+' Processing DataSave to CSV file', dtSendMemo);
    FDataSaveEvent.Signal;
  end;//with

  FSaveDataBuf := formatDateTime('yyyy-mm-dd hh:nn:ss:zzz',now);
end;

//CSV 파일 저장 쓰레드 삭제 함수
procedure TDataSaveMain.DestroySave2FileThread;
begin
  if Assigned(FDataSave2FileThread) then
  begin
    FDataSave2FileThread.Terminate;
    FDataSave2FileThread.FDataSaveEvent.Signal;
    FDataSave2FileThread.Free;
    FDataSave2FileThread := nil;
  end;//if
end;

////////////////////////////////////////////////////////////////////////////////
//메시지를 화면에 표시하는 함수 ////////////////////////////////////////////////
procedure TDataSaveMain.DisplayMessage(msg: string; ADspNo: TDisplayTarget);
begin
  case ADspNo of
    dtSendMemo : begin
      if msg = ' ' then
      begin
        exit;
      end
      else
        ;

      with Protocol do
      begin
        if Lines.Count > 100 then
          Clear;

        Lines.Add(msg);
      end;//with
    end;//dtSendMemo

    dtStatusBar: begin
       StatusBar1.SimplePanel := True;
       StatusBar1.SimpleText := msg;
    end;//dtStatusBar
  end;//case
end;

procedure TDataSaveMain.DisplayMessage2SB(Msg: string);
begin
  StatusBar1.SimplePanel := True;
  StatusBar1.SimpleText := Msg;
end;

procedure TDataSaveMain.Dynamo_OnSignal(Sender: TIPCThread_Dynamo;
  Data: TEventData_Dynamo);
begin
  FDynamoData.FPower := Data.FPower;
  FDynamoData.FPowerUnit := Data.FPowerUnit;
  FDynamoData.FTorque := Data.FTorque;
  FDynamoData.FTorqueUnit := Data.FTorqueUnit;
  FDynamoData.FRevolution := Data.FRevolution;
  FDynamoData.FBrgTBTemp := Data.FBrgTBTemp;
  FDynamoData.FBrgMTRTemp := Data.FBrgMTRTemp;
  FDynamoData.FWaterInletTemp := Data.FWaterInletTemp;
  FDynamoData.FWaterOutletTemp := Data.FWaterOutletTemp;
  FDynamoData.FBody1Press := Data.FBody1Press;
  FDynamoData.FBody2Press := Data.FBody2Press;
  FDynamoData.FInletOpen1 := Data.FInletOpen1;
  FDynamoData.FInletOpen2 := Data.FInletOpen2;
  FDynamoData.FOutletOpen1 := Data.FOutletOpen1;
  FDynamoData.FOutletOpen2 := Data.FOutletOpen2;

  SendMessage(Handle, WM_EVENT_DYNAMO, 0,0);
end;

//ini 파일에 있는 Host IP, Port를 Form에 표시하는 함수 /////////////////////////
procedure TDataSaveMain.LoadConfigDataini2Form(FSaveConfigF: TSaveConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME+DeviceName+'.ini');
  try
    with iniFile, FSaveConfigF do
    begin
      Ed_sharedmemory.Text := ReadString(DATASAVE_SECTION, 'IPCCLIENTNAME1', '');
      Ed_DynamoMM.Text := ReadString(DATASAVE_SECTION, 'IPCCLIENTNAME_DYNAMO', '');
      BlockNoEdit.Text := ReadString(DATASAVE_SECTION, 'Block No', '1');
      MapFilenameEdit.FileName := ReadString(DATASAVE_SECTION, 'Modbus Map File Name1', '');
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

//ini파일로 Host의 Port, IP 주소를 저장하는 함수 ///////////////////////////////
procedure TDataSaveMain.SaveConfigDataForm2ini(FSaveConfigF: TSaveConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  DisplayMessage(#13#10+'System configuration changed'+#13#10+'Please restart program...' , dtSendMemo);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME+DeviceName+'.ini');
  try
    with iniFile, FSaveConfigF do
    begin
      WriteString(DATASAVE_SECTION, 'IPCCLIENTNAME1', Ed_sharedmemory.Text);
      WriteString(DATASAVE_SECTION, 'IPCCLIENTNAME_DYNAMO', Ed_DynamoMM.Text);
      WriteString(DATASAVE_SECTION, 'Modbus Map File Name1', MapFilenameEdit.FileName);
      WriteString(DATASAVE_SECTION, 'Block No', BlockNoEdit.Text);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

//ini 파일에서 초기화정보를 읽어 프로그램에서 사용하는 변수로 저장하는 함수/////
procedure TDataSaveMain.LoadConfigDataini2Var;
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME+DeviceName+'.ini');
  try
    with iniFile do
    begin
      //DB 접속정보 초기화 구문
      FSharedMMName := ReadString(DATASAVE_SECTION, 'IPCCLIENTNAME1', '');
      FDynamoSharedMMName := ReadString(DATASAVE_SECTION, 'IPCCLIENTNAME_DYNAMO', '');
      FHostName := ReadString(DATASAVE_SECTION, 'SAVEDATA_HOSTNAME', '');
      FMapFileName := ReadString(DATASAVE_SECTION, 'Modbus Map File Name1', '');
      FLastBlockNo := ReadInteger(DATASAVE_SECTION, 'Block No', 1);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

end.
