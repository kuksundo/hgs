unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ComCtrls, dfsStatusBar, Buttons, ALed, iniFiles,
  CSV2DBConst, ToolEdit, CSV2DBConfig, File2DBThread, Menus, CopyData,
  SCLED, FSMClass, FSMState, ExtCtrls;

type
  TCsv2DBF = class(TForm)
    FilenameEdit1: TFilenameEdit;
    Label1: TLabel;
    dfsStatusBar1: TdfsStatusBar;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    SCLED1: TSCLED;
    Label2: TLabel;
    ALed1: TALed;
    BitBtn3: TBitBtn;
    FileOpt_RG: TRadioGroup;
    DirectoryEdit1: TDirectoryEdit;
    Label3: TLabel;
    procedure BitBtn2Click(Sender: TObject);
    procedure FilenameEdit1AfterDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure FormDestroy(Sender: TObject);
    procedure SetCurrentState(AValue: TCsv2DBState);
    procedure BitBtn3Click(Sender: TObject);
    procedure FileOpt_RGClick(Sender: TObject);
    procedure DirectoryEdit1AfterDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
  private
    FFileName: string; //CSV File Name (include path)
    FSQLFileName: string;//DB에 저장할 Sql문이 포함된 FileName
    FFilePath: string;      //파일을 저장할 경로
    FCurrentState: TCsv2DBState;//현재 진행 상태를 저장함
    FHostName: string;//DB Host Name(IP address)
    FDBName: string;  //DB Name(Mysql의 DB Name)
    FLoginID: string;   //Login Name
    FPasswd: string;  //Password
    FFileOption: TFileOption;//파일 선택 옵션
    FDf2db: TDataFile2DBThread;

    FFSMclass: TFSMclass;
  public
    procedure LoadConfigDataini2Form(ConfigForm:Tcsv2dbConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:Tcsv2dbConfigF);
    procedure SetConfigData;
    procedure DisplayMsg2SB(MsgType: TMsgType; msg: string);
    procedure CreateFSM();

    procedure ActionFromState(AStateId: TCsv2DBState);
    procedure BeforeStart();
    procedure SuspendInsert();
    procedure FinishInsert();
    procedure InsertRun();
  published
    property FilePath: string read FFilePath;
    property CurrentState: TCsv2DBState read FCurrentState write SetCurrentState;
  end;

var
  Csv2DBF: TCsv2DBF;

implementation

{$R *.dfm}

procedure TCsv2DBF.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TCsv2DBF.FilenameEdit1AfterDialog(Sender: TObject;
  var Name: String; var Action: Boolean);
begin
  FFileName := Name;
end;

procedure TCsv2DBF.DirectoryEdit1AfterDialog(Sender: TObject;
  var Name: String; var Action: Boolean);
begin
  FFileName := Name;
end;

procedure TCsv2DBF.BitBtn1Click(Sender: TObject);
begin
  if FFileName = '' then
  begin
    ShowMessage('파일을 선택하시오!!!');
    exit;
  end;

  ActionFromState(I_RUN);
end;

procedure TCsv2DBF.LoadConfigDataini2Form(ConfigForm: Tcsv2dbConfigF);
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

      FileOpt_RG.ItemIndex := ReadInteger(SAVEDATA_FILE_SECTION, 'File Option', 0);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TCsv2DBF.LoadConfigDataini2Var;
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

      FFileOption := TFileOption(ReadInteger(SAVEDATA_FILE_SECTION, 'File Option', 0));
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try

end;

procedure TCsv2DBF.SaveConfigDataForm2ini(ConfigForm: Tcsv2dbConfigF);
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

      WriteInteger(SAVEDATA_FILE_SECTION, 'File Option', FileOpt_RG.ItemIndex);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TCsv2DBF.SetConfigData;
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

procedure TCsv2DBF.FormCreate(Sender: TObject);
begin
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  FSQLFileName := 'sql\insert_pps_monitor.txt';
  LoadConfigDataini2Var;
  FDf2db := TDataFile2DBThread.Create(Self);
  FCurrentState := S_BEFORESTART;
  CreateFSM;
  FileOpt_RGClick(nil);
  ALed1.TrueColor := clRed;
  ALed1.Value := True;
end;

procedure TCsv2DBF.N4Click(Sender: TObject);
begin
  Close;
end;

procedure TCsv2DBF.N3Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TCsv2DBF.DisplayMsg2SB(MsgType: TMsgType; msg: string);
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

procedure TCsv2DBF.WMCopyData(var Msg: TMessage);
begin
  DisplayMsg2SB(TMsgType(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.iHandle),
                PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.StrMsg);
end;

procedure TCsv2DBF.FormDestroy(Sender: TObject);
begin
  With FDf2db do
  begin
    Terminate;
    FDataSaveEvent.Signal;
    Free;
  end;

  FDf2db := nil;
  FFSMclass.Free;
  FFSMclass := nil;
end;

procedure TCsv2DBF.SetCurrentState(AValue: TCsv2DBState);
begin
  if FFSMClass.GetCurrentState() <> Ord(AValue) then
  begin
    FFSMClass.SetCurrentState(Ord(AValue));
    FCurrentState := AValue;
  end;
end;

procedure TCsv2DBF.CreateFSM;
var pFSMstate: TFSMstate;
begin
  FFSMclass := nil;
  // FSMclass( int iStateID )
  FFSMclass := TFSMclass.Create(Ord(S_BEFORESTART));

  pFSMstate := nil;
  pFSMstate := TFSMstate.Create( Ord(S_BEFORESTART), 1 );

	pFSMstate.AddTransition( Ord(I_RUN), Ord(S_INSERTING) );
	FFSMclass.AddState( pFSMstate );

  pFSMstate := TFSMstate.Create( Ord(S_INSERTING), 2 );

	pFSMstate.AddTransition( Ord(I_SUSPEND), Ord(S_SUSPEND_INSERT) );
	pFSMstate.AddTransition( Ord(I_STOP), Ord(S_FINISHED_INSERT) );
	FFSMclass.AddState( pFSMstate );

  pFSMstate := TFSMstate.Create( Ord(S_SUSPEND_INSERT), 3 );
	pFSMstate.AddTransition( Ord(I_RUN), Ord(S_INSERTING) );
	pFSMstate.AddTransition( Ord(I_NULL), Ord(S_BEFORESTART) );
	pFSMstate.AddTransition( Ord(I_STOP), Ord(S_FINISHED_INSERT) );
	FFSMclass.AddState( pFSMstate );

  pFSMstate := TFSMstate.Create( Ord(S_FINISHED_INSERT), 2 );
	pFSMstate.AddTransition( Ord(I_NULL), Ord(S_BEFORESTART) );
	pFSMstate.AddTransition( Ord(I_RUN), Ord(S_INSERTING) );
	FFSMclass.AddState( pFSMstate );
end;

procedure TCsv2DBF.BitBtn3Click(Sender: TObject);
begin
  ActionFromState(I_SUSPEND);
end;

procedure TCsv2DBF.BeforeStart;
begin
  try
    with FDf2db do
    begin
      if Assigned(FFileList) then
        FFileList.Clear
      else
        FFileList := TStringList.Create;

      if FFileOption = FO_FILE then
        FFileList.Add(Self.FFileName)
      else
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

procedure TCsv2DBF.SuspendInsert;
begin
  if not FDf2db.FSuspendInsert then
    FDf2db.FSuspendInsert := True;
end;

procedure TCsv2DBF.InsertRun;
begin
  if (FDf2db.Suspended) and (FDf2db.FSuspendInsert) then
    FDf2db.Resume
  else
  begin
    BeforeStart;
  end;
end;

procedure TCsv2DBF.FinishInsert;
begin

end;

procedure TCsv2DBF.ActionFromState(AStateId: TCsv2DBState);
var OutPutState: TCsv2DBState;
begin
  OutPutState := TCsv2DBState(FFSMclass.StateTransition(Ord(AStateId)));

  if OutPutState = FCurrentState then
    exit;

  FCurrentState := OutPutState;
  
  case OutPutState of
    S_NULL: exit;
    S_BEFORESTART: BeforeStart();
    S_INSERTING:InsertRun();
    S_SUSPEND_INSERT: SuspendInsert();
    S_FINISHED_INSERT: FinishInsert();
  end;//case
end;

procedure TCsv2DBF.FileOpt_RGClick(Sender: TObject);
begin
  FFileOption := TFileOption(FileOpt_RG.ItemIndex);

  if FileOpt_RG.ItemIndex = 0 then
  begin
    Label1.Visible := True;
    FileNameEdit1.Visible := True;
    Label3.Visible := not Label1.Visible;
    DirectoryEdit1.Visible := not FileNameEdit1.Visible;
    DirectoryEdit1.Text := '';
  end
  else
  begin
    Label1.Visible := False;
    FileNameEdit1.Visible := False;
    FileNameEdit1.Text := '';
    Label3.Visible := not Label1.Visible;
    DirectoryEdit1.Visible := not FileNameEdit1.Visible;
  end;
end;

end.
