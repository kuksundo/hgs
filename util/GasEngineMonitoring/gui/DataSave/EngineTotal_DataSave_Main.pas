unit EngineTotal_DataSave_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus, IPCThrdMonitor2, DataSaveConst, ComCtrls,
  IPCThrd2, DataSave2FileThread, DataSave2DBThread, SyncObjs,inifiles,
  DataSaveConfig;

const
  INIFILENAME = '.\EngineTotal_DatasaveConfig_';
  DeviceName = 'GasEngineTotal';
  DATASAVE_SECTION = 'Datasave';

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
    Timer2: TTimer;
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
  private
    //DB에 데이터저장을 위한 변수선언부
    FDataSave2DBThread: TDataSave2DBThread; //DB에 데이타 저장하는 객체
    FHostName: string;//DB Host Name(IP address)
    FDBName: string;  //DB Name(Mysql의 DB Name)
    FLoginID: string;   //Login Name
    FPasswd: string;  //Password

    //CSV 파일 저장을 위한 변수선언부///////////////////////////////////////////
    FLogStart: Boolean;  //Log save Start sig.
    FTagNameBuf: string;  //파일에 제목을 저장하기 위한 버퍼
    FSaveFileName: string; //데이타를 저장할 File 이름(설정에 따라 변경됨)
    FSaveDataBuf: string; //파일에 저장할 데이타를 저장하는 버퍼
    FFileName_Convention: TFileName_Convetion;//파일에 저장시에 파일이름부여 방법
    FDataSave2FileThread: TDataSave2FileThread;//파일에 데이타 저장하는 객체

    //평균계산을 위한 변수선언부////////////////////////////////////////////////
    //Sumof_CO2: Double;
    TotalDataNo: Integer;

    //Critical Section 변수선언부///////////////////////////////////////////////
    FCriticalSection: TCriticalSection;

    procedure OnSignal(Sender: TIPCThread2; Data: TEventData2);
    procedure LoadConfigDataini2Form(FSaveConfigF: TSaveConfigF);
    procedure SaveConfigDataForm2ini(FSaveConfigF: TSaveConfigF);
    procedure LoadConfigDataini2Var;
  public
    { Public declarations }
    FFilePath: string;      //파일을 저장할 경로
    FIPCMonitor: TIPCMonitor2;//공유 메모리 및 이벤트 객체
    FMonitorStart: Boolean; //타이머 동작 완료하면 True
    FSharedMMName: string;  //공유 메모리 이름
    procedure SaveData2DB;
    procedure SaveData2File;
    procedure SaveDataAverage2File;    
    procedure CreateSave2DBThread;
    procedure CreateSave2FileThread;
    procedure DisplayMessage(msg: string; ADspNo: TDisplayTarget);
    procedure DestroySave2FileThread;
    procedure DestroySave2DBThread;
  end;

var
  DataSaveMain: TDataSaveMain;
//  DataSave_Start: Boolean;

implementation

{$R *.dfm}

procedure TDataSaveMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FCriticalSection.Enter;
  FMonitorStart := False;
  try
    if Assigned(FDataSave2FileThread) then
    begin
      FDataSave2FileThread.FDataSaveEvent.Pulse;
      FDataSave2FileThread.Terminate;
      //FDataSave2FileThread.Free;
    end;//if

    if Assigned(FDataSave2DBThread) then
    begin
      FDataSave2DBThread.FDataSaveEvent.Pulse;
      FDataSave2DBThread.Terminate;
      //FDataSave2DBThread.Free;
    end;//if

    if Assigned(FIPCMonitor) then
    begin
      FIPCMonitor.FMonitorEvent.Signal(evMonitorSignal);
      FIPCMonitor.Terminate;
      //FIPCMonitor.Free;
    end;//if

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
  FIPCMonitor := TIPCMonitor2.Create(0, FSharedMMName, True);
  FIPCMonitor.FreeOnTerminate := True;
  FIPCMonitor.OnSignal := OnSignal;
  //공유메모리 모니터쓰레드 동작 시작
  FIPCMonitor.Resume;

  DisplayMessage('Shared Memory: ' + FSharedMMName + ' Created!', dtSendMemo);

  CreateSave2FileThread;
//  FDataSave2FileThread.FName_Convention := FC_YMD;
end;






////////////////////////////////////////////////////////////////////////////////
//메인메뉴-Connect 버튼
procedure TDataSaveMain.Connect1Click(Sender: TObject);
begin
//  CreateSave2DBThread;
end;
//메인메뉴-Disconnect 버튼
procedure TDataSaveMain.Disconnect1Click(Sender: TObject);
begin
//  FDataSave2DBThread.ZConnection1.Connected := False;
//  DisplayMessage('Server Disconnected'+#13#10, dtSendMemo);
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
      LoadConfigDataini2Form(FSaveConfigF);
      if ShowModal = mrOK then
      begin
        SaveConfigDataForm2ini(FSaveConfigF);
{        LoadConfigDataini2Var;
        AdjustConfigData;
}      end;
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
  +'for Horiba Mexa 7000'+#13#10
  +'2010.4.29'+#13#10
  +'#######################'+#13#10, dtSendMemo);
end;











//Active 버튼 클릭
procedure TDataSaveMain.CB_ActiveClick(Sender: TObject);
begin
//  if not Assigned(FDataSave2DBThread) then
//    CreateSave2DBThread;

  //Data save를 시작했을 경우
  if CB_Active.Checked then
  begin
    FMonitorStart := True;
    DisplayMessage (#13#10+ '#####################' +#13#10+ TimeToStr(Time)+' Start Data Receiving', dtSendMemo);
    FLogStart := True;

    //CSV 파일에 Data Save할 경우
    if CB_CSVlogging.Checked then
    begin
      FSaveDataBuf :=#13#10+TimeToStr(Time)+','+'START DATA LOGGING'+#13#10;
      FSaveDataBuf := FSaveDataBuf + 'Time,Saturation Vapour Press.(kPa),Intake Air Humidity(g/kg),';
      FSaveDataBuf := FSaveDataBuf + 'Uncorrected Fuel Consumption(g/kwh),Nox humidity/temp. Correction Factor,';
      FSaveDataBuf := FSaveDataBuf + 'Dry/Wet Correction Factor Exhaust,Exhaust Gas Flow(kg/h),NOx at 13% O2,';
      FSaveDataBuf := FSaveDataBuf + 'Air Flow (kg/h),Air Flow (kg/kwh),Air Flow (kg/s),Fuel Consumption(kg/h),';
      FSaveDataBuf := FSaveDataBuf + 'Engine Output(kW/h),Engine Load(%),Generator Efficiency at current Load(%/100),';
      FSaveDataBuf := FSaveDataBuf + 'Brake Horse Power,Brake Mean Effective Press,Lamda Ratio,';
      FSaveDataBuf := FSaveDataBuf + 'Lamda(Brettschneider equation),Air Fuel Ratio';
      FSaveFileName := ED_csv.Text;
      SaveData2File;
    end;

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
    if CB_CSVlogging.Checked then
    begin
      //SaveDataAverage2File;   //CSV 파일에 저장할 때, 각 수치의 평균값 입력
    end;
    FMonitorStart := False;
    DisplayMessage (TimeToStr(Time)+' Processing terminated', dtSendMemo);
    FlogStart := False;
    //FIPCMonitor.Suspend;    //공유메모리 모니터쓰레드 동작 중지

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
//TCPClient 프로그램에서 데이터 onsignal이 오는지를 인식하여 Data Save 함수를
//구동시키는 함수
procedure TDataSaveMain.OnSignal(Sender: TIPCThread2; Data: TEventData2);
begin
  if not FMonitorStart then
    exit;

  if CB_CSVlogging.Checked then
  begin
    with Data do
    begin
     DisplayMessage(#13#10+TimeToStr(Time)+' Data Received', dtSendMemo);

     FSaveDataBuf :=TimeToStr(Time)+','+
            FloatToStr(FSVP)+','+// Saturation Vapour Press.(kPa)
            FloatToStr(FIAH2)+','+// Intake Air Humidity(g/kg)
            FloatToStr(FUFC)+','+// Uncorrected Fuel Consumption(g/kwh)
            FloatToStr(FNhtCF)+','+  //Nox humidity/temp. Correction Factor
            FloatToStr(FDWCFE)+','+//Dry/Wet Correction Factor Exhaust:
            FloatToStr(FEGF)+','+ //Exhaust Gas Flow(kg/h)
            FloatToStr(FNOxAtO213)+','+//
            FloatToStr(FAF1)+','+ //Air Flow (kg/h)
            FloatToStr(FAF2)+','+ //Air Flow (kg/kwh)
            FloatToStr(FAF3)+','+ //Air Flow (kg/s)
            FloatToStr(FFC)+','+//Fuel Consumption(kg/h)
            FloatToStr(FEngineOutput)+','+ //Calculated(kW/h)
            FloatToStr(FEngineLoad)+','+ //Current Engine Load(%)
            FloatToStr(FGenEfficiency)+','+ //Generator Efficiency at current Load(%/100)
            FloatToStr(FBHP)+','+ //Brake Horse Power
            FloatToStr(FBMEP)+','+//Brake Mean Effective Press.
            FloatToStr(FLamda)+','+ //Lamda Ratio
            FloatToStr(FLamda_Brettschneider)+','+ //Lamda(Brettschneider equation) - Normalized Air/Fuel balance
            FloatToStr(FAFRatio);//Air Fuel Ratio
    end;//with
    
    SaveData2File;

    //데이터의 평균값을 구하기 위한 부분
    //Sumof_CO2 := Sumof_CO2 + StrToFloat(Data.CO2);
    TotalDataNo := TotalDataNo+1;

  end;
  
  if CB_DBlogging.Checked then
  begin
    DisplayMessage(#13#10+TimeToStr(Time)+' Data Received', dtSendMemo);
    
    if not Assigned(FDataSave2DBThread) then
    begin
      DisplayMessage('DataBase is not connected', dtSendMemo);
      exit;
    end;

    if FDataSave2DBThread.ZConnection1.Connected then
    begin
      SaveData2DB;
    end
    else if not FDataSave2DBThread.ZConnection1.Connected then
    begin
      DisplayMessage('Server Disconnected! Please Connect Again', dtSendMemo);
    end;
  end;
end;










////////////////////////////////////////////////////////////////////////////////
//DB 저장 쓰레드 생성 함수
procedure TDataSaveMain.CreateSave2DBThread;
begin
  if not Assigned(FDataSave2DBThread) then
  begin
    FDataSave2DBThread := TDataSave2DBThread.Create(Self);
    FDataSave2DBThread.FreeOnTerminate := True;

    with FDataSave2DBThread do
    begin
      FHostName := Self.FHostName;
      FDBName := Self.FDBName;
      FLoginID := Self.FLoginID;
      FPasswd := Self.FPasswd;
      if FDataSave2DBThread.ZConnection1.Connected then
      begin
//      ALed1.Value := True;
//      CreateDBParam(INSERT_FILE_NAME,'pps_monitor');
        DisplayMessage ('Server Connected', dtSendMemo);
        Resume;
      end
      else
//        ALed1.Value := False;
    end;//with
  end//if
  else if not FDataSave2DBThread.ZConnection1.Connected then
  begin
    FDataSave2DBThread.ZConnection1.Connected := True;
    if FDataSave2DBThread.ZConnection1.Connected then
      DisplayMessage ('Server Re-Connected', dtSendMemo);
  end;
end;

//DB 저장 쓰레드 명령 함수
procedure TDataSaveMain.SaveData2DB;
begin
  with FDataSave2DBThread do
  begin
    if not FSaving then
      FDataSaveEvent.Pulse;
  end;//with
end;

//DB 저장 쓰레드 제거 함수
procedure TDataSaveMain.DestroySave2DBThread;
begin
  if Assigned(FDataSave2DBThread) then
  begin
    FDataSave2DBThread.Terminate;
    FDataSave2DBThread.FDataSaveEvent.Pulse;
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
    FDataSave2FileThread.FreeOnTerminate := True;
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
    FDataSaveEvent.Pulse;
  end;//with
end;

//CSV 파일 저장 쓰레드 삭제 함수
procedure TDataSaveMain.DestroySave2FileThread;
begin
  if Assigned(FDataSave2FileThread) then
  begin
    FDataSave2FileThread.Terminate;
    FDataSave2FileThread.FDataSaveEvent.Pulse;
    FDataSave2FileThread.Free;
    FDataSave2FileThread := nil;
  end;//if
end;

//CSV 파일 평균계산 함수
procedure TDataSaveMain.SaveDataAverage2File;
begin
  if TotalDataNo = 0 then
  begin
    FSaveDataBuf :=#13#10+'Average'+',0,0,0,0,0,0,0,0'+#13#10+#13#10+#13#10;
  end
  else
  begin
    //FSaveDataBuf :=#13#10+'Average'
    //+','+FloatToStr(Sumof_CO2/TotalDataNo)
  end;
  SaveData2File;

  //데이터의 합산을 초기화 하기 위한 부분
  //Sumof_CO2 := 0.0;
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
      Ed_sharedmemory.Text := ReadString(DATASAVE_SECTION, 'IPCCLIENTNAME1', 'Horiba_MEXA_7000_Client');
      Ed_hostname.Text := ReadString(DATASAVE_SECTION, 'SAVEDATA_HOSTNAME', '10.100.23.114');
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
      WriteString(DATASAVE_SECTION, 'SAVEDATA_HOSTNAME', Ed_hostname.Text);
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
      FSharedMMName := ReadString(DATASAVE_SECTION, 'IPCCLIENTNAME1', 'Horiba_MEXA_7000_Client');
      FHostName := ReadString(DATASAVE_SECTION, 'SAVEDATA_HOSTNAME', 'Horiba_MEXA_7000_Client');
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

end.
