unit MonitorFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DeCAL_pjh, IPCThrd2, IPCThrdMonitor2, ExtCtrls, EngMonitorConfig;

const MONITORNAME = 'ModBusCom';

type
  TFrame1 = class(TFrame)
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    FFilePath: string;      //파일을 저장할 경로
    FMapFileName: string;   //Modbus Map 파일 이름
    FHiMap: THiMap;         //Modbus Address 구조체 -> 동적으로 생성함
    FAddressMap: DMap;      //Modbus Map 데이타 저장 구초체
    FIPCMonitor: TIPCMonitor2;//공유 메모리 및 이벤트 객체
    FModBusData: TWMModbusData;
    FCriticalSection: TCriticalSection;
    FMonitorStart: Boolean; //타이머 동작 완료하면 True
    FjanDB : TjanSQL; //text 기반 SQL DB
  public
    procedure InitVar;
    procedure ReadMapAddress(AddressMap: DMap; MapFileName: string);
    procedure LoadConfigDataini2Form(ConfigForm:TEngMonitorConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:TEngMonitorConfigF);
    procedure SetConfigData;
  end;

implementation

{$R *.dfm}

procedure TFrame1.InitVar;
begin
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  FCriticalSection := TCriticalSection.Create;

  FAddressMap := DMap.Create;
  FIPCMonitor := TIPCMonitor2.Create(0, MONITORNAME, True);
  FIPCMonitor.OnSignal := OnSignal;
  FIPCMonitor.Resume;
  
  FMonitorStart := False;
end;

procedure TFrame1.LoadConfigDataini2Form(ConfigForm: TEngMonitorConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile, ConfigForm do
    begin
      FilenameEdit.Filename := ReadString(ENGMONITOR_SECTION, 'Modbus Map File Name1', '.\ss197_Modbus_Map.txt');
      //FilenameEdit2.Filename := ReadString(ENGMONITOR_SECTION, 'Modbus Map File Name2', '.\ss197_Modbus_Map.txt');
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TFrame1.LoadConfigDataini2Var;
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile do
    begin
      FMapFileName := ReadString(ENGMONITOR_SECTION, 'Modbus Map File Name1', '');
      FMapFileName2 := ReadString(ENGMONITOR_SECTION, 'Modbus Map File Name2', '');
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TFrame1.SaveConfigDataForm2ini(ConfigForm: TEngMonitorConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile, ConfigForm do
    begin
      WriteString(ENGMONITOR_SECTION, 'Modbus Map File Name1', FilenameEdit.Filename);
      //WriteString(ENGMONITOR_SECTION, 'Modbus Map File Name2', FilenameEdit2.Filename);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TFrame1.SetConfigData;
var EngMonitorConfigF: TEngMonitorConfigF;
begin
  EngMonitorConfigF := TEngMonitorConfigF.Create(Application);
  with EngMonitorConfigF do
  begin
    try
      LoadConfigDataini2Form(EngMonitorConfigF);
      if ShowModal = mrOK then
      begin
        SaveConfigDataForm2ini(EngMonitorConfigF);
        LoadConfigDataini2Var;
        FAddressMap.clear;
        ReadMapAddress(FAddressMap,FMapFileName);
        //ReadMapAddress(FAddressMap2,FMapFileName2);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TFrame1.ReadMapAddress(AddressMap: DMap; MapFileName: string);
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
    FjanDB := TjanSQL.create;
    sqltext := 'connect to ''' + FFilePath + '''';

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
                if Fields[5].Value = 'FALSE' then
                begin
                  FAlarm := False;
                  fcode := '1';
                end
                else
                begin
                  FAlarm := True;
                  fcode := '3';
                end;

                FMaxval := StrToFloat(Fields[6].Value);
                FContact := StrToInt(Fields[7].Value);
                FUnit := '';
              end;//with

              AddressMap.PutPair([fcode + FHiMap.FAddress,FHiMap]);
            end;//for
          end;

        end
        else
          DisplayMessage(FjanDB.Error);
      end;//with
    end
    else
      Application.MessageBox('Connect 실패',
          PChar('폴더 ' + FFilePath + ' 를 만든 후 다시 하시오'),MB_ICONSTOP+MB_OK);
  end
  else
  begin
    sqltext := FileName + '파일을 만든 후에 다시 하시오';
    Application.MessageBox('Data file does not exist!', PChar(sqltext) ,MB_ICONSTOP+MB_OK);
  end;
end;

procedure TFrame1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  try
    if FMonitorStart then
    begin
      DisplayMessage('');
    end
    else
    begin
      ReadMapAddress(FAddressMap,FMapFileName);
      //ReadMapAddress(FAddressMap2,FMapFileName2);
    end;
  finally
    FMonitorStart := True;
    Timer1.Enabled := True;
  end;//try

end;

end.
 