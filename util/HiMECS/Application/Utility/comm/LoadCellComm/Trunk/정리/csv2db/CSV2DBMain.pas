unit CSV2DBMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ImgList, StdCtrls, dxWinXPBar, dxCore, dxContainer,
  ExtCtrls, ComCtrls, ATXPtask, dxCheckCtrls, Spin, dxButtons, ToolEdit,
  SCLED, Mask, dfsStatusBar, ALed, Menus;

type
  TForm2 = class(TForm)
    spltMain: TSplitter;
    dxContainer3: TdxContainer;
    ScrollBox1: TScrollBox;
    dxContainer4: TdxContainer;
    dxWinXPBar4: TdxWinXPBar;
    dxContainer5: TdxContainer;
    dxWinXPBar5: TdxWinXPBar;
    dxContainer6: TdxContainer;
    dxWinXPBar6: TdxWinXPBar;
    imlWinXPBar: TImageList;
    aclWinXPBar: TActionList;
    acConnectRemoteServer: TAction;
    acConnectLocalServer: TAction;
    acConnectAdministrator: TAction;
    acSettingsUsers: TAction;
    acSettingsStatistics: TAction;
    acSettingsDatabase: TAction;
    acSettingsDownloads: TAction;
    acSynchronizeUnknown: TAction;
    acSynchronizeWeb: TAction;
    Action1: TAction;
    dxContainer1: TdxContainer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label8: TLabel;
    TabSheet3: TTabSheet;
    dxCheckbox2: TdxCheckbox;
    dxCheckbox3: TdxCheckbox;
    dxContainer2: TdxContainer;
    btnOK: TdxButton;
    btnCancel: TdxButton;
    dfsStatusBar1: TdfsStatusBar;
    Label5: TLabel;
    FilenameEdit1: TFilenameEdit;
    SCLED1: TSCLED;
    DirectoryEdit1: TDirectoryEdit;
    dxButton1: TdxButton;
    ALed1: TALed;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N4: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure FilenameEdit1AfterDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure dxButton1Click(Sender: TObject);
  private
    FFileName: string; //CSV File Name (include path)
    FSQLFileName: string;//DB에 저장할 Sql문이 포함된 FileName
    FFilePath: string;      //파일을 저장할 경로
    FCurrentState: TCsv2DBState;//현재 진행 상태를 저장함
    FHostName: string;//DB Host Name(IP address)
    FDBName: string;  //DB Name(Mysql의 DB Name)
    FLoginID: string;   //Login Name
    FPasswd: string;  //Password
    FDf2db: TDataFile2DBThread;

    m_pFSMclass: TFSMclass;
    m_iCurrentState,
    m_iOutputState: integer;

    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure SetCurrentState(AValue: TCsv2DBState);
  public
    procedure LoadConfigDataini2Form(ConfigForm:Tcsv2dbConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:Tcsv2dbConfigF);
    procedure SetConfigData;
    procedure DisplayMsg2SB(MsgType: TMsgType; msg: string);
    procedure CreateFSM();

    procedure BeforeStart();

  published
    property FilePath: string read FFilePath;
    property CurrentState: TCsv2DBState read FCurrentState write SetCurrentState;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FilenameEdit1AfterDialog(Sender: TObject;
  var Name: String; var Action: Boolean);
begin
  FFileName := Name;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  FSQLFileName := 'sql\insert_pps_monitor.txt';
  LoadConfigDataini2Var;
  FDf2db := TDataFile2DBThread.Create(Self);
  FCurrentState := S_BEFORESTART;
  CreateFSM;
end;

procedure TForm2.WMCopyData(var Msg: TMessage);
begin
  DisplayMsg2SB(TMsgType(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.iHandle),
                PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.StrMsg);
end;

procedure TForm2.SetCurrentState(AValue: TCsv2DBState);
begin
  if FCurrentState <> AValue then
    FCurrentState := AValue;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  With FDf2db do
  begin
    Terminate;
    FDataSaveEvent.Signal;
    Free;
  end;

  FDf2db := nil;
  m_pFSMclass.Free;
  m_pFSMclass := nil;
end;

procedure TForm2.CreateFSM;
var pFSMstate: TFSMstate;
begin
  m_pFSMclass := nil;
  // FSMclass( int iStateID )
  m_pFSMclass := TFSMclass.Create(Ord(S_BEFORESTART));

  pFSMstate := nil;
  pFSMstate := TFSMstate.Create( Ord(S_BEFORESTART), 1 );

	pFSMstate.AddTransition( Ord(I_RUN), Ord(S_INSERTING) );
	m_pFSMclass.AddState( pFSMstate );

  pFSMstate := TFSMstate.Create( Ord(S_INSERTING), 2 );

	pFSMstate.AddTransition( Ord(I_SUSPEND), Ord(S_SUSPEND_INSERT) );
	pFSMstate.AddTransition( Ord(I_STOP), Ord(S_FINISHED_INSERT) );
	m_pFSMclass.AddState( pFSMstate );

  pFSMstate := TFSMstate.Create( Ord(S_SUSPEND_INSERT), 3 );
	pFSMstate.AddTransition( Ord(I_RUN), Ord(S_INSERTING) );
	pFSMstate.AddTransition( Ord(I_NULL), Ord(S_BEFORESTART) );
	pFSMstate.AddTransition( Ord(I_STOP), Ord(S_FINISHED_INSERT) );
	m_pFSMclass.AddState( pFSMstate );

  pFSMstate := TFSMstate.Create( Ord(S_FINISHED_INSERT), 2 );
	pFSMstate.AddTransition( Ord(I_NULL), Ord(S_BEFORESTART) );
	pFSMstate.AddTransition( Ord(I_RUN), Ord(S_INSERTING) );
	m_pFSMclass.AddState( pFSMstate );
end;

procedure TForm2.DisplayMsg2SB(MsgType: TMsgType; msg: string);
begin
  with dfsStatusBar1 do
  begin
    case MsgType of
    SB_SIMPLE :
      begin
        SimplePanel := True;
        SimpleText := msg;
      end;

    SB_PROGRESS:
      begin
        Panels[0].PanelType := sptGauge;
        Panels[0].GaugeAttrs.Position := StrToInt(msg);
      end;

    SB_LED:
      begin
        SCLED1.Caption := msg;
      end;

    else
      Panels[Ord(MsgType)].Text := msg;
    end;//case
  end;//with
end;

procedure TForm2.LoadConfigDataini2Form(ConfigForm: Tcsv2dbConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile, ConfigForm do
    begin
      HostName_Edit.Text := ReadString(SAVEDATA_DB_SECTION, 'Host Name', '127.0.0.1');
      DBName_Edit.Text := ReadString(SAVEDATA_DB_SECTION, 'Database Name', 'HIMSENDB');
      LoginID_Edit.Text := ReadString(SAVEDATA_DB_SECTION, 'Login ID', 'root');
      Passwd_Edit.Text := ReadString(SAVEDATA_DB_SECTION, 'Passwd', 'root');
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TForm2.LoadConfigDataini2Var;
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile do
    begin
      FHostName := ReadString(SAVEDATA_DB_SECTION, 'Host Name', '127.0.0.1');
      FDBName := ReadString(SAVEDATA_DB_SECTION, 'Database Name', 'HIMSENDB');
      FLoginID := ReadString(SAVEDATA_DB_SECTION, 'Login ID', 'root');
      FPasswd := ReadString(SAVEDATA_DB_SECTION, 'Passwd', 'root');
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TForm2.SaveConfigDataForm2ini(ConfigForm: Tcsv2dbConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile, ConfigForm do
    begin
      WriteString(SAVEDATA_DB_SECTION, 'Host Name', HostName_Edit.Text);
      WriteString(SAVEDATA_DB_SECTION, 'Database Name', DBName_Edit.Text);
      WriteString(SAVEDATA_DB_SECTION, 'Login ID', LoginID_Edit.Text);
      WriteString(SAVEDATA_DB_SECTION, 'Passwd', Passwd_Edit.Text);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TForm2.SetConfigData;
var
  scf: Tcsv2dbConfigF;
begin
  try
    scf := nil;
    scf := Tcsv2dbConfigF.Create(nil);

    with scf do
    begin
      LoadConfigDataini2Form(scf);

      while ShowModal = mrOK do
      begin
        //if (SaveFile_ChkBox.Checked) and (FNameType_RG.ItemIndex = 1) and
        //  (FilenameEdit1.Text = '') then
        //begin
        //  ShowMessage('파일 이름을 입력하시오!');
        //  Continue;
        //end
        //else
        //begin
          SaveConfigDataForm2ini(scf);
          LoadConfigDataini2Var;
          break;
        //end;

      end;//while
    end;//with
  finally
    scf.Free;
    scf := nil;
  end;//try
end;

procedure TForm2.N4Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.N3Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TForm2.btnOKClick(Sender: TObject);
begin
begin
  if FFileName = '' then
  begin
    ShowMessage('파일을 선택하시오!!!');
    exit;
  end;

  case FCurrentState of
    S_BEFORESTART: BeforeStart();
  end;//case
end;

procedure TForm2.dxButton1Click(Sender: TObject);
begin
  m_iCurrentState := m_pFSMclass.GetCurrentState();
end;

procedure TForm2.BeforeStart;
begin
  try
    with FDf2db do
    begin
      FullFileName := Self.FFileName;
      InitVar();

      with FData2MySQLDBThread do
      begin
        FHostName := Self.FHostName;
        FDBName := Self.FDBName;
        FLoginID := Self.FLoginID;
        FPasswd := Self.FPasswd;
        if ConnectDB then
        begin
          ALed1.TrueColor := clLime;
          CreateDBParam(FSQLFileName,'pps_monitor');
          Resume;
        end
        else
          ALed1.TrueColor := clRed;
      end;//with

      Resume;
    end;//with
  finally
  end;//try
end;

end.
