unit UnitMonitorFromDBConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  iniFiles, Vcl.Mask, JvExMask, JvToolEdit, Vcl.Samples.Spin, Vcl.ComCtrls, Ora, SynCommons;

const
  FILE_SECTION = 'File';
  ORACLE_SECTION = 'Oracle';
  MONGODB_SECTION = 'MongoDB';

type
  TMonitorDataFromDBConfigF = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ampm_combo: TComboBox;
    Hour_SpinEdit: TSpinEdit;
    Minute_SpinEdit: TSpinEdit;
    UseDate_ChkBox: TCheckBox;
    Month_SpinEdit: TSpinEdit;
    Date_SpinEdit: TSpinEdit;
    Repeat_ChkBox: TCheckBox;
    TabSheet4: TTabSheet;
    Label16: TLabel;
    ParaFilenameEdit: TJvFilenameEdit;
    ConfFileFormatRG: TRadioGroup;
    EngParamEncryptCB: TCheckBox;
    OracleTS: TTabSheet;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    ServerEdit: TEdit;
    UserEdit: TEdit;
    PasswdEdit: TEdit;
    TableNameCombo: TComboBox;
    ReConnectIntervalEdit: TSpinEdit;
    MongoDBTS: TTabSheet;
    Label18: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    MongoServerEdit: TEdit;
    MongoUserEdit: TEdit;
    MongoPasswdEdit: TEdit;
    MongoDBNameCombo: TComboBox;
    MongoReConnectEdit: TSpinEdit;
    MongoCollNameCombo: TComboBox;
    MongoCollNameCombo2: TComboBox;
    MongoCollNameCombo3: TComboBox;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DB_Type_RG: TRadioGroup;
    procedure TableNameComboDropDown(Sender: TObject);
  private
    procedure FillCollectName2Combo(ACombo: TComboBox);
    procedure FillOraTableName2Combo(ACombo: TComboBox);
  public
    FFilepath: string;
    procedure LoadConfigDataini2Form(AIniFileName: string);
    procedure SaveConfigDataForm2ini(AIniFileName: string);
  end;

var
  MonitorDataFromDBConfigF: TMonitorDataFromDBConfigF;

implementation

{$R *.dfm}

procedure TMonitorDataFromDBConfigF.FillCollectName2Combo(ACombo: TComboBox);
var
  LDocs: TVariantDynArray;
  i: integer;
  LStr2: string;
begin
//  if DataSaveAllF.TFrameDataSaveAll1.FConnectedMongoDB then
//  begin
//    if DataSaveAllF.TFrameDataSaveAll1.FDataSave2MongoDBThread.SelectAllDBData(LDocs,'system.namespaces') then
//    begin
//      ACombo.Clear;
//
//      for i := 0 to High(LDocs) do
//      begin
//        LStr2 := LDocs[i].Name;
//
//        if (Pos('$', LStr2) > 0) or (Pos('system.index', LStr2) > 0) then
//          continue;
//
//        LStr2 := StringReplace(LStr2, 'PMS_DB.', '', [rfReplaceAll, rfIgnoreCase]);
//        ACombo.AddItem(LStr2, nil);
//      end;
//    end;
//  end;
end;

procedure TMonitorDataFromDBConfigF.FillOraTableName2Combo(ACombo: TComboBox);
var
  OraSession1 : TOraSession;
  OraQuery1 : TOraQuery;
  lTable : String;
  i: integer;
begin
  OraSession1 := TOraSession.Create(nil);
  OraQuery1 := TOraQuery.Create(nil);
  try
    with OraSession1 do
    begin
      UserName := UserEdit.Text;//'TBACS';
      Password := PassWdEdit.Text;//'TBACS';
      Server   := ServerEdit.Text;//'10.100.23.114:1521:TBACS';
      LoginPrompt := False;
      Options.Direct := True;
      Options.Charset := 'KO16KSC5601';
      Connected := True;
      OraQuery1.AutoCommit := False;
      OraQuery1.Connection := OraSession1;
    end;

    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HITEMS.MON_TABLES');

      Open;

      if RecordCount = 0 then
        raise Exception.Create('테이블이 존재하지 않습니다.'+#10#13+
                               '테이블 이름 가져오기에 실패하였습니다.');

      TableNameCombo.Clear;

      for i := 0 to RecordCount - 1 do
      begin
        TableNameCombo.AddItem(FieldByName('TABLE_NAME').AsString, nil);
        next;
      end;
    end;
  finally
    FreeAndNil(OraQuery1);
    FreeAndNil(OraSession1);
  end;
end;

procedure TMonitorDataFromDBConfigF.LoadConfigDataini2Form(AIniFileName: string);
var
  iniFile: TIniFile;
begin
  iniFile := nil;
  iniFile := TInifile.create(AIniFileName);
  try
    with iniFile do
    begin
      ParaFilenameEdit.FileName := ReadString(FILE_SECTION, 'Parameter File Name', '');
      DB_Type_RG.ItemIndex := ReadInteger(FILE_SECTION, 'DB Type', 0);
      EngParamEncryptCB.Checked := ReadBool(FILE_SECTION, 'Parameter Encrypt', False);
      ConfFileFormatRG.ItemIndex := ReadInteger(FILE_SECTION, 'Param File Format', 0);

      ServerEdit.Text := ReadString(ORACLE_SECTION, 'DB Server', '10.100.23.114:1521:TBACS');
      UserEdit.Text := ReadString(ORACLE_SECTION, 'User ID', 'TBACS');
      PasswdEdit.Text := ReadString(ORACLE_SECTION, 'Passwd', 'TBACS');
      TableNameCombo.Text := ReadString(ORACLE_SECTION, 'Table Name', 'BF1562_18H3240V_ANALOG_DATA');
      ReConnectIntervalEdit.Value := ReadInteger(ORACLE_SECTION, 'Reconnect Interval', 10000);

      MongoServerEdit.Text := ReadString(MONGODB_SECTION, 'DB Server Address', '10.100.23.114');
      MongoUserEdit.Text := ReadString(MONGODB_SECTION, 'User ID', 'TBACS');
      MongoPasswdEdit.Text := ReadString(MONGODB_SECTION, 'Passwd', 'TBACS');
      MongoDBNameCombo.Text := ReadString(MONGODB_SECTION, 'DataBase Name', 'PMS_DB');
      MongoCollNameCombo.Text := ReadString(MONGODB_SECTION, 'Collection Name', 'PMS_COLL');
      MongoCollNameCombo2.Text := ReadString(MONGODB_SECTION, 'Collection Name 2', '');
      MongoCollNameCombo3.Text := ReadString(MONGODB_SECTION, 'Collection Name 3', '');
      MongoReConnectEdit.Value := ReadInteger(MONGODB_SECTION, 'Reconnect Interval', 10000);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TMonitorDataFromDBConfigF.SaveConfigDataForm2ini(AIniFileName: string);
var
  iniFile: TIniFile;
  LFileName: string;
begin
  iniFile := nil;
  iniFile := TInifile.create(AIniFileName);
  try
    with iniFile do
    begin
      LFileName := ParaFilenameEdit.FileName;
      if LFileName = '' then
        LFileName := ChangeFileExt(ExtractFileName(Application.ExeName), '.param');

      WriteString(FILE_SECTION, 'Parameter File Name', ExtractRelativePath(FFilepath, LFileName));
      WriteInteger(FILE_SECTION, 'DB Type', DB_Type_RG.ItemIndex);

      WriteString(ORACLE_SECTION, 'DB Server', ServerEdit.Text);
      WriteString(ORACLE_SECTION, 'User ID', UserEdit.Text);
      WriteString(ORACLE_SECTION, 'Passwd', PasswdEdit.Text);
      WriteString(ORACLE_SECTION, 'Table Name', TableNameCombo.Text);
      WriteInteger(ORACLE_SECTION, 'Reconnect Interval', ReConnectIntervalEdit.Value);

      WriteString(MONGODB_SECTION, 'DB Server Address', MongoServerEdit.Text);
      WriteString(MONGODB_SECTION, 'User ID', MongoUserEdit.Text);
      WriteString(MONGODB_SECTION, 'Passwd', MongoPasswdEdit.Text);
      WriteString(MONGODB_SECTION, 'DataBase Name', MongoDBNameCombo.Text);
      WriteString(MONGODB_SECTION, 'Collection Name', MongoCollNameCombo.Text);
      WriteString(MONGODB_SECTION, 'Collection Name 2', MongoCollNameCombo2.Text);
      WriteString(MONGODB_SECTION, 'Collection Name 3', MongoCollNameCombo3.Text);
      WriteInteger(MONGODB_SECTION, 'Reconnect Interval', MongoReConnectEdit.Value);

      WriteBool(FILE_SECTION, 'Parameter Encrypt', EngParamEncryptCB.Checked);
      WriteInteger(FILE_SECTION, 'Param File Format', ConfFileFormatRG.ItemIndex);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TMonitorDataFromDBConfigF.TableNameComboDropDown(Sender: TObject);
begin
  if OracleTS.Visible then
    FillOraTableName2Combo(TableNameCombo)
  else
  if MongoDBTS.Visible then
    FillCollectName2Combo(MongoCollNameCombo);
end;

end.
