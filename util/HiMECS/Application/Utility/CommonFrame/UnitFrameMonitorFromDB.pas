unit UnitFrameMonitorFromDB;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  JvExControls, JvLabel,
  EngineParameterClass, IPCThrdClient_Generic,
  UnitIPCClientAll, Vcl.Menus, iniFiles, Ora, Vcl.ExtCtrls, synCommons,  mORMot,
  Vcl.ImgList, UnitFrameWatchGrid;

type
  TTFrameIPCClientFromDB = class(TFrame)
    Timer1: TTimer;
    ImageList16x16: TImageList;
    Panel6: TPanel;
    JvLabel2: TJvLabel;
    JvLabel4: TJvLabel;
    cb_codeType: TComboBox;
    et_filter: TComboBox;
    FWG: TFrameWatchGrid;
    procedure Timer1Timer(Sender: TObject);
    procedure cb_codeTypeDropDown(Sender: TObject);
    procedure et_filterSelect(Sender: TObject);
    procedure cb_codeTypeSelect(Sender: TObject);
    procedure FWGNextGrid1DblClick(Sender: TObject);
  private
    FIniFileName: string;   //ini File name
    FSharedMemName: string; //IPCClient Shared Memory Name
    FEngineParameter: TEngineParameter;
    FIPCClientAll: TIPCClientAll;

    FOraSession1 : TOraSession;
    FOraQuery1 : TOraQuery;

    function ConnectOracleDB: Boolean;
    procedure DisConnectOracleDB;
    procedure LoadConfigDataini2Var;

    procedure GetDataFromDB;
    function GetTableName(AProjNo, AEngNo: string): string;
    procedure SelectEngParamFileFromDB(AProjNo, AEngNo: string; out AEP: TEngineParameterCollect);

    //공장 리스트 반환
    function GetPlantList: TRawUTF8DynArray;
    //공장 내에 있는 엔진 리스트 반환
    function GetEngineListFromPlant(APlantName: string): TRawUTF8DynArray;
    //엔진의 센서(태그)리스트 반환
    procedure GetTagListFromEngine(AProjNo, AEngNo: string);
    procedure Get_ProjNo_EngNo(AText: string; var AProjNo, AEngNo: string);
    procedure AdjustGridVisible;
  public
    FParamFileName: string;
    FEngParamEncrypt: Boolean;
    FEngParamFileFormat: integer;
    FDBType: integer; //DT_ORACLE=0, DT_MONGODB=1
    //Oracle DB
    FHostName: string;//DB Host Name(IP address)
    FDBName: string;  //DB Name(Mysql의 DB Name)
    FLoginID: string;   //Login Name
    FPasswd: string;  //Password
    FSaveTableName,
    FEngType: string;
    FConnectedOracleDB,
    FDestorying: Boolean;
    FReConnectInterval: integer;

    //Mongo DB
    FMongoHostName: string;//Mongo DB Host Name(IP address)
    FMongoDBName: string;  //Mongo DB Name(Mysql의 DB Name)
    FMongoLoginID: string; //Mongo Login Name
    FMongoPasswd: string;  //Mongo Password
    FMongoCollectionName,  //Mongo Collection Name
    FMongoCollectionName2,
    FMongoCollectionName3: string;//3개의 Collection에 Insert 할때 필요함(1개만 사용할때는 반드시 ''로 할것)
    FConnectedMongoDB: Boolean;
    FMongoReConnect: integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure InitVar;
    procedure DestroyVar;
    procedure ProcessCommandLine;

    function InitEngineParameter(AFileName: string): Boolean;
    procedure MFDBConfig;
    procedure ApplyEP2Grid;
  end;

implementation

uses UnitMonitorFromDBConfig, DateUtils, CommonUtil, IPC_Modbus_Standard_Const,
  UnitStrMsg.Events;

{$R *.dfm}

{ TMonitorDataFromDBFrame }

procedure TTFrameIPCClientFromDB.AdjustGridVisible;
begin
  FWG.NextGrid1.ColumnByName['NxIndex'].Visible := True;
  FWG.NextGrid1.ColumnByName['SimpleDisplay'].Visible := False;
  FWG.NextGrid1.ColumnByName['TrendDisplay'].Visible := False;
  FWG.NextGrid1.ColumnByName['XYDisplay'].Visible := False;
  FWG.NextGrid1.ColumnByName['AlarmEnable'].Visible := False;
end;

procedure TTFrameIPCClientFromDB.ApplyEP2Grid;
begin
  FIPCClientAll.FProjNo := FEngineParameter.EngineParameterCollect.Items[0].ProjNo;
  FIPCClientAll.FEngNo := FEngineParameter.EngineParameterCollect.Items[0].EngNo;
  FSaveTableName := GetTableName(FIPCClientAll.FProjNo,FIPCClientAll.FEngNo);
  et_Filter.Text := FIPCClientAll.FProjNo + '(' + FIPCClientAll.FEngNo + ') : ' + FEngType;
  cb_codeType.Text := FEngineParameter.FactoryName;
  FWG.NextGrid1.ClearRows;
  FWG.AddEngineParameter2Grid(FEngineParameter.EngineParameterCollect);
  TStrMsgEvent.Create( '"' + FSaveTableName + '" is Monitor Table Name').Queue;
end;

procedure TTFrameIPCClientFromDB.cb_codeTypeDropDown(Sender: TObject);
var
  LDynArr: TRawUTF8DynArray;
  i: integer;
begin
  cb_codeType.Clear;
  LDynArr := nil;
  LDynArr := GetPlantList;

  for i := Low(LDynArr) to High(LDynArr) do
  begin
    if LDynArr[i] <> '' then
      cb_codeType.Items.Add(LDynArr[i]);
  end;
end;

procedure TTFrameIPCClientFromDB.cb_codeTypeSelect(Sender: TObject);
var
  i: integer;
  LDynArr: TRawUTF8DynArray;
  LStr, LProjNo, LEngNo, LEngType: string;
begin
  LDynArr := nil;
  if cb_codeType.Text <> '' then
  begin
    FEngineParameter.FactoryName := cb_codeType.Text;
    LDynArr := GetEngineListFromPlant(cb_codeType.Text);
    et_filter.Clear;

    for i := Low(LDynArr) to High(LDynArr) do
    begin
      if LDynArr[i] <> '' then
      begin
        LStr := UTF8ToString(LDynArr[i]);
        LProjNo := strToken(LStr, ';');
        LEngNo := strToken(LStr, ';');
        LEngType := strToken(LStr, ';');

        et_filter.Items.Add(LProjNo + '(' +
                          LEngNo + ') : ' +
                          LEngType);
      end;
    end;
  end;
end;

function TTFrameIPCClientFromDB.ConnectOracleDB: Boolean;
begin
  Result := False;

  if not Assigned(FOraSession1) then
    FOraSession1 := TOraSession.Create(nil);

  with FOraSession1 do
  begin
    UserName := FLoginID;// 'TBACS';
    Password := FPasswd; //'TBACS';
    Server   := FHostName; //'10.100.23.114:1521:TBACS';
    LoginPrompt := False;
    Options.Direct := True;
    Options.Charset := 'KO16KSC5601';
    Connect;

    if Connected then
      Result := True;
  end;

  if not Assigned(FOraQuery1) then
    FOraQuery1 := TOraQuery.Create(nil);

  with FOraQuery1 do
  begin
    AutoCommit := False;
    Connection := FOraSession1;
  end;
end;

constructor TTFrameIPCClientFromDB.Create(AOwner: TComponent);
begin
  inherited;

  InitVar;
end;

destructor TTFrameIPCClientFromDB.Destroy;
begin
  FDestorying := True;
  DestroyVar;

  inherited;
end;

procedure TTFrameIPCClientFromDB.DestroyVar;
begin
  if Assigned(ForaQuery1) then
  begin
    FOraQuery1.Close;
    FOraQuery1.Free;
  end;

  if Assigned(FOraSession1) then
  begin
    FOraSession1.Disconnect;
    FOraSession1.Free;
  end;
  FIPCClientAll.Free;

//  if MessageDlg('현재 설정된 엔진 모니터링 센서 리스트를 로컬 컴퓨터에 저장 하시겠습니까?',
//                          mtConfirmation, [mbYes, mbNo], 0)= mrYes then
//  begin
  if FEngineParameter.EngineParameterCollect.Count > 0 then
  begin
    FEngineParameter.SaveToJSONFile(FParamFileName,
            ExtractFileName(FParamFileName),FEngParamEncrypt);
  end;
//  end;

  FreeAndNil(FEngineParameter);
end;

procedure TTFrameIPCClientFromDB.DisConnectOracleDB;
begin

end;

procedure TTFrameIPCClientFromDB.et_filterSelect(Sender: TObject);
var
  LStr, LProjNo, LEngNo: string;
begin
  if et_filter.Text <> '' then
  begin
    Timer1.Enabled := False;
    try
      Get_ProjNo_EngNo(et_filter.Text, LProjNo, LEngNo);
      //FEngineParameter에 데이터 가져옴
      GetTagListFromEngine(LProjNo, LEngNo);

      if FEngineParameter.EngineParameterCollect.Count > 0 then
      begin
        ApplyEP2Grid;
      end
      else
        ShowMessage(LProjNo + '(' + LEngNo + ') Parameter File does not exist');
    finally
    end;
  end;
end;

procedure TTFrameIPCClientFromDB.FWGNextGrid1DblClick(Sender: TObject);
var
  LRect: TRect;
begin
  LRect := FWG.NextGrid1.GetHeaderRect;

  if PtInRect(LRect, FWG.FMousePoint) then
    exit;

  FWG.ShowProperties(FEngineParameter.EngineParameterCollect);
end;

procedure TTFrameIPCClientFromDB.GetDataFromDB;
var
  i: integer;
  LValue: string;
  LDouble: Double;
  EventData: TEventData_Modbus_Standard;
begin
  if FDestorying then
    exit;

  try
    with FOraQuery1 do
    begin
      Close;
      SQL.clear;
      SQL.add('SELECT * FROM ' + FSaveTableName);// +
      Open;

      if RecordCount > 0 then
      begin
//        if FieldByName('datasavedtime').AsString < FormatDateTime('YYYYMMDDHHMMSSzzz',IncSecond(Now,-3)) then
//          exit;

        with EventData do
        begin
          for i := 1 to FieldCount - 1 do
          begin
            if i <= FEngineParameter.EngineParameterCollect.Count then
            begin
              LDouble := Fields.Fields[i].AsFloat; //첫번째 필드(datasavedtime)은 제외
              InpDataBuf_double[i-1] := LDouble;
              LValue := FloatToStr(LDouble);
              FEngineParameter.EngineParameterCollect.Items[i-1].Value := LValue;
              FWG.NextGrid1.CellByName['Value',i-1].AsString := LValue;
            end;
          end;

          NumOfData := FieldCount - 1;
          ModBusMode := 3;
        end;

        FIPCClientAll.PulseEventData<TEventData_Modbus_Standard>(EventData);
      end;
    end;
  finally
  end;
end;

function TTFrameIPCClientFromDB.GetEngineListFromPlant(APlantName: string): TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
  LValue: RawUTF8;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);

  with FOraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HiTEMS.mon_tables where loc_code = (select loc_code from TBACS.HITEMS_LOC_CODE where loc_name = :Plant)');

    if APlantName = '' then
      SQL.Text := StringReplace(SQL.Text,'where loc_code = (select loc_code from TBACS.HITEMS_LOC_CODE where loc_name = :Plant)','',[rfReplaceAll])
    else
      ParamByName('Plant').AsString := APlantName;
    Open;

    while not eof do
    begin
      LValue := FieldByName('ENG_PROJNO').AsString + ';' +
        FieldByName('ENG_NO').AsString + ';' +
        FieldByName('ENG_TYPE').AsString;
      LDynArr.Add(LValue);

      Next;
    end;
  end;
end;

function TTFrameIPCClientFromDB.GetPlantList: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
  LValue: RawUTF8;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);

  with FOraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select distinct(loc_name) from TBACS.HITEMS_LOC_CODE where loc_grp is null and loc_lv = 0');
//    ParamByName('CODE_TYPE').AsString := aCodeType;
    Open;

    while not eof do
    begin
      LValue := StringToUTF8(FieldByName('LOC_NAME').AsString);
      LDynArr.Add(LValue);

      Next;
    end;
  end;
end;

function TTFrameIPCClientFromDB.GetTableName(AProjNo, AEngNo: string): string;
begin
  if FDestorying then
    exit;

  try
    with FOraQuery1 do
    begin
      Close;
      SQL.clear;
      SQL.Add('select * from HiTEMS.mon_tables where ENG_PROJNO = :projno and ENG_NO = :engno');
      ParamByName('projno').AsString := AProjNo;
      ParamByName('engno').AsString := AEngNo;
      Open;

      if RecordCount > 0 then
      begin
        Result := FieldByName('TABLE_NAME').AsString;
        Result := StringReplace(Result ,'MEASURE_DATA','RECENT_DATA',[rfReplaceAll]);
        FEngType := FieldByName('ENG_TYPE').AsString;
      end;
    end;
  finally
  end;
end;

procedure TTFrameIPCClientFromDB.GetTagListFromEngine(AProjNo, AEngNo: string);
var
  LEP: TEngineParameterCollect;
begin
  LEP := FEngineParameter.EngineParameterCollect;
  SelectEngParamFileFromDB(AProjNo, AEngNo, LEP);
end;

procedure TTFrameIPCClientFromDB.Get_ProjNo_EngNo(AText: string; var AProjNo,
  AEngNo: string);
var
  LStr: string;
begin
  LStr := AText;
  AProjNo := strToken(LStr, '(');
  LStr := AText;
  AEngNo := ExtractText(LStr, '(', ')');
end;

function TTFrameIPCClientFromDB.InitEngineParameter(AFileName: string): Boolean;
begin
  Result := False;
  SetCurrentDir(ExtractFilePath(Application.ExeName));

  if not FileExists(AFilename) then
  begin
    ShowMessage('"' + AFilename + '" file is not exist');
    exit;
  end;

  FEngineParameter.LoadFromJSONFile(AFilename,
                                    ExtractFileName(AFilename),
                                    FEngParamEncrypt);

  if FEngineParameter.EngineParameterCollect.count > 0 then
  begin
    Result := True;
    ApplyEP2Grid;
  end;
end;

procedure TTFrameIPCClientFromDB.InitVar;
begin
  AdjustGridVisible;
  FIPCClientAll := TIPCClientAll.Create;
  FEngineParameter := TEngineParameter.Create(Self);
  FIniFileName := '';

  //FIniFileName 가져오기(기본값: 실행화일.ini)
  ProcessCommandLine;

  if not FileExists(FIniFileName) then
    MFDBConfig;

  //Ini 파일에서 설정값 불러오기
  LoadConfigDataini2Var;
  ConnectOracleDB;
  //Param File 불러오기
  InitEngineParameter(FParamFileName);
end;

procedure TTFrameIPCClientFromDB.LoadConfigDataini2Var;
var
  iniFile: TIniFile;
  LStr: string;
  LBool: Boolean;
begin
  iniFile := nil;
  iniFile := TInifile.create(FIniFileName);
  try
    with iniFile do
    begin
      LStr := ReadString(FILE_SECTION, 'Parameter File Name', '');

      if (FParamFileName <> LStr) or (LStr = '') then
      begin
        FParamFileName := LStr;
//        FConfigModified := True;
      end;

      FEngParamEncrypt := ReadBool(FILE_SECTION, 'Parameter Encrypt', false);
      FEngParamFileFormat := ReadInteger(FILE_SECTION, 'Param File Format', 0);
      FDBType := ReadInteger(FILE_SECTION, 'DB Type', 0);

      FHostName := ReadString(ORACLE_SECTION, 'DB Server', '10.100.23.114:1521:TBACS');
      FLoginID := ReadString(ORACLE_SECTION, 'User ID', 'TBACS');
      FPasswd := ReadString(ORACLE_SECTION, 'Passwd', 'TBACS');
      FSaveTableName := ReadString(ORACLE_SECTION, 'Table Name', '');
      FReConnectInterval := ReadInteger(ORACLE_SECTION, 'Reconnect Interval', 10000);

      FMongoHostName := ReadString(MONGODB_SECTION, 'DB Server Address', '10.100.23.114');
      FMongoDBName := ReadString(MONGODB_SECTION, 'DataBase Name', 'PMS_DB');
      FMongoLoginID := ReadString(MONGODB_SECTION, 'User ID', 'TBACS');
      FMongoPasswd := ReadString(MONGODB_SECTION, 'Passwd', 'TBACS');
      FMongoCollectionName := ReadString(MONGODB_SECTION, 'Collection Name', 'PMS_COLL');
      FMongoCollectionName2 := ReadString(MONGODB_SECTION, 'Collection Name 2', '');
      FMongoCollectionName3 := ReadString(MONGODB_SECTION, 'Collection Name 3', '');
      FMongoReConnect := ReadInteger(MONGODB_SECTION, 'Reconnect Interval', 10000);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TTFrameIPCClientFromDB.MFDBConfig;
var
  FSaveConfigF: TMonitorDataFromDBConfigF;
begin
  FSaveConfigF := TMonitorDataFromDBConfigF.Create(Application);

  try
    with FSaveConfigF do
    begin
      FFilepath := ExtractFilePath(Application.ExeName);
      LoadConfigDataini2Form(FIniFileName);

      if ShowModal = mrOK then
      begin
        SaveConfigDataForm2ini(FIniFileName);
        LoadConfigDataini2Var;
      end;
    end;
  finally
    FSaveConfigF.Free;
  end;
end;

procedure TTFrameIPCClientFromDB.ProcessCommandLine;
var
  LStr: string;
  i: integer;
begin
  if ParamCount > 0 then
  begin
    LStr := ParamStr(1);
    i := Pos('/F', UpperCase(LStr)); //ini file name
    if i > 0 then  //A 제거
    begin
      FIniFileName := Copy(LStr, i+2, Length(LStr)-i-1);
    end;
  end;

  if FIniFileName = '' then
    FIniFileName := ChangeFileExt(Application.ExeName, '.ini');
end;

procedure TTFrameIPCClientFromDB.SelectEngParamFileFromDB(AProjNo,
  AEngNo: string; out AEP: TEngineParameterCollect);
var
  lms: TStringStream;
  LEP: TEngineParameter;
  LStr: RawUTF8;
  LSuccessed: Boolean;
begin
  with FOraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM HiTEMS.MON_TABLES ' +
            'WHERE ENG_PROJNO = :projno and ENG_NO = :engno ');
    ParamByName('projno').AsString     := AProjNo;
    ParamByName('engno').AsString      := AEngNo;
    Open;

    if RecordCount > 0 then
    begin
      lms := TStringStream.Create;
      LEP := TEngineParameter.Create(nil);
      try
        (FieldByName('ENG_PARAMETER') as TBlobField).SaveToStream(lms);

        if lms.Size > 0 then
        begin
          LStr := StringToUTF8(lms.DataString);
          JSONToObject(LEP, PUTF8Char(LStr), LSuccessed);

          if LSuccessed then
          begin
            AEP.Clear;
            CopyObject(LEP.EngineParameterCollect, AEP);
          end;
        end;
      finally
        FreeAndNil(lms);
        FreeAndNil(LEP);
      end;
    end;
  end;
end;

procedure TTFrameIPCClientFromDB.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  try
    GetDataFromDB;
  finally
    Timer1.Enabled := True;
  end;
end;

end.
