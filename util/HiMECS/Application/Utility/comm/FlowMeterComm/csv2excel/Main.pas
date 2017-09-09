unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ComCtrls, dfsStatusBar, Buttons, ALed, iniFiles,
  CSV2xlsConst, ToolEdit, Menus, SCLED, ExtCtrls, dxButtons, dxCore, dxCheckCtrls,
  Spin, dxWinXPBar, dxContainer, FSMClass, FSMState, CopyData, CSV2xlsConfig,
  File2xlsThread, xlsThread, Grids;

type
  TCsv2XlsF = class(TForm)
    dfsStatusBar1: TdfsStatusBar;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    SCLED1: TSCLED;
    spltMain: TSplitter;
    dxContainer3: TdxContainer;
    ScrollBox1: TScrollBox;
    dxContainer5: TdxContainer;
    dxWinXPBar5: TdxWinXPBar;
    dxContainer6: TdxContainer;
    dxWinXPBar6: TdxWinXPBar;
    dxContainer1: TdxContainer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label5: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ComboBox1: TComboBox;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    chk2: TdxCheckbox;
    chk1: TdxCheckbox;
    TabSheet2: TTabSheet;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    SpinEdit5: TSpinEdit;
    SpinEdit6: TSpinEdit;
    dxCheckbox1: TdxCheckbox;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label11: TLabel;
    DateTimePicker1: TDateTimePicker;
    dxButton1: TdxButton;
    TabSheet5: TTabSheet;
    Label1: TLabel;
    Label3: TLabel;
    DirectoryEdit1: TDirectoryEdit;
    FilenameEdit1: TFilenameEdit;
    FileOpt_RG: TRadioGroup;
    dxContainer2: TdxContainer;
    btnOK: TdxButton;
    btnCancel: TdxButton;
    dxButton2: TdxButton;
    dxButton3: TdxButton;
    dxContainer4: TdxContainer;
    dxWinXPBar4: TdxWinXPBar;
    StringGrid1: TStringGrid;
    procedure BitBtn2Click(Sender: TObject);
    procedure FilenameEdit1AfterDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure FormDestroy(Sender: TObject);
    procedure SetCurrentState(AValue: TCsv2xlsState);
    procedure BitBtn3Click(Sender: TObject);
    procedure FileOpt_RGClick(Sender: TObject);
    procedure DirectoryEdit1AfterDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure btnOKClick(Sender: TObject);
    procedure dxButton1Click(Sender: TObject);
    procedure dxWinXPBar4Items0Click(Sender: TObject);
    procedure dxWinXPBar4Items1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FFileName: string; //CSV File Name (include path)
    //FSQLFileName: string;//DB에 저장할 Sql문이 포함된 FileName
    FFilePath: string;      //파일을 저장할 경로
    FCurrentState: TCsv2xlsState;//현재 진행 상태를 저장함
    FHostName: string;//DB Host Name(IP address)
    FDBName: string;  //DB Name(Mysql의 DB Name)
    FLoginID: string;   //Login Name
    FPasswd: string;  //Password
    FFileOption: TFileOption;//파일 선택 옵션
    FDf2xls: TDataFile2xlsThread;

    FFSMclass: TFSMclass;

  public
    procedure LoadConfigDataini2Form(ConfigForm:Tcsv2xlsConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:Tcsv2xlsConfigF);
    procedure SetConfigData;
    procedure DisplayMsg2SB(MsgType: TMsgType; msg: string);
    procedure CreateFSM();

    procedure ActionFromState(AStateId: TCsv2xlsState);
    procedure BeforeStart();
    procedure SuspendInsert();
    procedure FinishInsert();
    procedure InsertRun();

    procedure GetFileNames(var AFileList: TStringList); //FileNameList에 파일 이름을 Add함
  published
    property FilePath: string read FFilePath;
    property CurrentState: TCsv2xlsState read FCurrentState write SetCurrentState;
  end;

var
  Csv2XlsF: TCsv2XlsF;

implementation

{$R *.dfm}

procedure TCsv2XlsF.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TCsv2XlsF.FilenameEdit1AfterDialog(Sender: TObject;
  var Name: String; var Action: Boolean);
begin
  FFileName := Name;
end;

procedure TCsv2XlsF.DirectoryEdit1AfterDialog(Sender: TObject;
  var Name: String; var Action: Boolean);
begin
  FFileName := Name;
end;

procedure TCsv2XlsF.BitBtn1Click(Sender: TObject);
begin
  if FFileName = '' then
  begin
    ShowMessage('파일을 선택하시오!!!');
    exit;
  end;

  ActionFromState(I_RUN);
end;

procedure TCsv2XlsF.LoadConfigDataini2Form(ConfigForm: Tcsv2xlsConfigF);
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

procedure TCsv2XlsF.LoadConfigDataini2Var;
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

procedure TCsv2XlsF.SaveConfigDataForm2ini(ConfigForm: Tcsv2xlsConfigF);
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

procedure TCsv2XlsF.SetConfigData;
var
  scf: Tcsv2xlsConfigF;
begin
  try
    scf := nil;
    scf := Tcsv2xlsConfigF.Create(nil);

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

procedure TCsv2XlsF.FormCreate(Sender: TObject);
begin
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  //FSQLFileName := 'sql\insert_pps_monitor.txt';
  LoadConfigDataini2Var;
  FDf2xls := TDataFile2xlsThread.Create(Self);
  FCurrentState := S_BEFORESTART;
  CreateFSM;
  FileOpt_RGClick(nil);
end;

procedure TCsv2XlsF.N4Click(Sender: TObject);
begin
  Close;
end;

procedure TCsv2XlsF.N3Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TCsv2XlsF.DisplayMsg2SB(MsgType: TMsgType; msg: string);
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

procedure TCsv2XlsF.WMCopyData(var Msg: TMessage);
begin
  DisplayMsg2SB(TMsgType(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.iHandle),
                PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.StrMsg);
end;

procedure TCsv2XlsF.FormDestroy(Sender: TObject);
begin
  With FDf2xls do
  begin
    Terminate;
    FDataSaveEvent.Signal;
    Free;
  end;

  FDf2xls := nil;
  FFSMclass.Free;
  FFSMclass := nil;
end;

procedure TCsv2XlsF.SetCurrentState(AValue: TCsv2xlsState);
begin
  if FFSMClass.GetCurrentState() <> Ord(AValue) then
  begin
    FFSMClass.SetCurrentState(Ord(AValue));
    FCurrentState := AValue;
  end;
end;

procedure TCsv2XlsF.CreateFSM;
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

procedure TCsv2XlsF.BitBtn3Click(Sender: TObject);
begin
  ActionFromState(I_SUSPEND);
end;

procedure TCsv2XlsF.BeforeStart;
begin
  try
    with FDf2xls do
    begin
      if Assigned(FFileList) then
        FFileList.Clear
      else
      begin
        FFileList := TStringList.Create;
        FFileList.Sorted := False;
      end;

      //if FFileOption = FO_FILE then
      GetFileNames(FFileList); //Query할 FileName을 가져옴
      //else
      //  FullFileName := Self.FFileName;

      InitVar();

      with FData2xlsThread do
      begin
        FGrid := StringGrid1;
        Resume;
        if ConnectExcel then
        begin
          ;
        end
        else
          ;
      end;//with

      Resume;
    end;//with
  finally
  end;//try
end;

procedure TCsv2XlsF.SuspendInsert;
begin
  if not FDf2xls.FSuspendInsert then
    FDf2xls.FSuspendInsert := True;
end;

procedure TCsv2XlsF.InsertRun;
begin
  if (FDf2xls.Suspended) and (FDf2xls.FSuspendInsert) then
    FDf2xls.Resume
  else
  begin
    BeforeStart;
  end;
end;

procedure TCsv2XlsF.FinishInsert;
begin

end;

procedure TCsv2XlsF.ActionFromState(AStateId: TCsv2xlsState);
var OutPutState: TCsv2xlsState;
begin
  OutPutState := TCsv2xlsState(FFSMclass.StateTransition(Ord(AStateId)));

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

procedure TCsv2XlsF.FileOpt_RGClick(Sender: TObject);
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

procedure TCsv2XlsF.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TCsv2XlsF.dxButton1Click(Sender: TObject);
begin
  ActionFromState(I_RUN);
end;

procedure TCsv2XlsF.GetFileNames(var AFileList: TStringList);
begin
  AFileList.Add(ECU_PATH + DateToStr(DateTimePicker1.Date - 1) + FILE_EXT);
  AFileList.Add(ECU_PATH + DateToStr(DateTimePicker1.Date) + FILE_EXT);
  AFileList.Add(WOOD_PATH + DateToStr(DateTimePicker1.Date - 1) + FILE_EXT);
  AFileList.Add(WOOD_PATH + DateToStr(DateTimePicker1.Date) + FILE_EXT);
  AFileList.Add(GTI_PATH + DateToStr(DateTimePicker1.Date - 1) + FILE_EXT);
  AFileList.Add(GTI_PATH + DateToStr(DateTimePicker1.Date) + FILE_EXT);
end;

procedure TCsv2XlsF.dxWinXPBar4Items0Click(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet4;
end;

procedure TCsv2XlsF.dxWinXPBar4Items1Click(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet3;
end;

procedure TCsv2XlsF.FormActivate(Sender: TObject);
begin
  DateTimePicker1.Date := Date;
end;

end.
