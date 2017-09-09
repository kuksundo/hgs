unit DataSaveAll_ConfigUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  JvExMask, JvToolEdit, Vcl.Samples.Spin, Vcl.ComCtrls, Vcl.Buttons, Ora,
  Vcl.CheckLst, EditBtn, SynCommons;

type
  TFrmDataSaveAllConfig = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    TabSheet4: TTabSheet;
    Label14: TLabel;
    MapFilenameEdit: TJvFilenameEdit;
    TabSheet2: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    HourCnt_SpinEdit: TSpinEdit;
    MinuteCnt_SpinEdit: TSpinEdit;
    RepeatCnt_ChkBox: TCheckBox;
    SecondCnt_SpinEdit: TSpinEdit;
    TabSheet3: TTabSheet;
    Label9: TLabel;
    SaveDB_ChkBox: TCheckBox;
    SaveFile_ChkBox: TCheckBox;
    FNameType_RG: TRadioGroup;
    TabSheet5: TTabSheet;
    GroupBox1: TGroupBox;
    IntervalSE: TSpinEdit;
    Label15: TLabel;
    ParaFilenameEdit: TJvFilenameEdit;
    Label16: TLabel;
    Label13: TLabel;
    BlockNoEdit: TEdit;
    Label17: TLabel;
    ConfFileFormatRG: TRadioGroup;
    EngParamEncryptCB: TCheckBox;
    OracleTS: TTabSheet;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    ServerEdit: TEdit;
    UserEdit: TEdit;
    PasswdEdit: TEdit;
    TableNameCombo: TComboBox;
    SaveOnlyCB: TCheckBox;
    ParamIndexLabel: TLabel;
    SaveRunHourCB: TCheckBox;
    Label24: TLabel;
    RunHourIndexEdit: TEdit;
    IntervalLbl: TLabel;
    RHIntervalSE: TSpinEdit;
    mSecLbl: TLabel;
    Label25: TLabel;
    ReConnectIntervalEdit: TSpinEdit;
    Label26: TLabel;
    Panel2: TPanel;
    ParamSourceCLB: TCheckListBox;
    Label19: TLabel;
    AppendStrEdit: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    MongoDBTS: TTabSheet;
    Label18: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    MongoServerEdit: TEdit;
    MongoUserEdit: TEdit;
    MongoPasswdEdit: TEdit;
    MongoDBNameCombo: TComboBox;
    MongoReConnectEdit: TSpinEdit;
    Label32: TLabel;
    MongoCollNameCombo: TComboBox;
    DB_Type_RG: TRadioGroup;
    ParamIndexEdit: TEditBtn;
    Label33: TLabel;
    MongoCollNameCombo2: TComboBox;
    Label34: TLabel;
    MongoCollNameCombo3: TComboBox;
    Button1: TButton;
    Label35: TLabel;
    AutoStartAfterEdit: TSpinEdit;
    Label36: TLabel;
    TabSheet6: TTabSheet;
    DisplySavedRawDataCB: TCheckBox;
    procedure TableNameComboDropDown(Sender: TObject);
    procedure SaveOnlyCBClick(Sender: TObject);
    procedure SaveRunHourCBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveDB_ChkBoxClick(Sender: TObject);
    procedure SaveFile_ChkBoxClick(Sender: TObject);
    procedure ParamIndexEditClickBtn(Sender: TObject);
    procedure DB_Type_RGClick(Sender: TObject);
    procedure MongoCollNameCombo2DropDown(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FFrameDataSaveAll: Pointer;

    procedure FillCollectName2Combo(ACombo: TComboBox);
    procedure FillOraTableName2Combo(ACombo: TComboBox);
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  FrmDataSaveAllConfig: TFrmDataSaveAllConfig;

implementation

uses TagNameListView, UnitFrameDataSaveAll;

{$R *.dfm}

procedure TFrmDataSaveAllConfig.Button1Click(Sender: TObject);
var
  LFileName: string;
begin
  LFileName := ParaFilenameEdit.FileName;

  if FileExists(LFileName) then
  begin
    ParamSourceCLB.Clear;

//    DataSaveAllF.TFrameDataSaveAll1.ParamSource2CLBFromFile(ParamSourceCLB,
//      LFileName, ConfFileFormatRG.ItemIndex, EngParamEncryptCB.Checked);
    TFrameDataSaveAll(FFrameDataSaveAll).UniqueParamSource2CLBFromFile(ParamSourceCLB,
      LFileName, ConfFileFormatRG.ItemIndex, EngParamEncryptCB.Checked);
  end;

  ParamSourceCLB.Refresh;
end;

constructor TFrmDataSaveAllConfig.Create(AOwner: TComponent);
begin
  inherited;

  FFrameDataSaveAll := Pointer(AOwner);
end;

procedure TFrmDataSaveAllConfig.DB_Type_RGClick(Sender: TObject);
begin
  OracleTS.Visible := DB_Type_RG.ItemIndex = 0;
  MongoDBTS.Visible := DB_Type_RG.ItemIndex = 1;
end;

procedure TFrmDataSaveAllConfig.FillCollectName2Combo(ACombo: TComboBox);
var
  LDocs: TVariantDynArray;
  i: integer;
  LStr2: string;
begin
//  if FFrameDataSaveAll.FConnectedMongoDB then
//  begin
//    if FFrameDataSaveAll.FDataSave2MongoDBThread.SelectAllDBData(LDocs,'system.namespaces') then
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
////        LStr := LStr + LStr2 + #13#10;
//      end;
//    end;
//  end;
end;

procedure TFrmDataSaveAllConfig.FillOraTableName2Combo(ACombo: TComboBox);
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

procedure TFrmDataSaveAllConfig.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet5;
end;

procedure TFrmDataSaveAllConfig.MongoCollNameCombo2DropDown(Sender: TObject);
begin
  FillCollectName2Combo(MongoCollNameCombo3);
end;

procedure TFrmDataSaveAllConfig.ParamIndexEditClickBtn(Sender: TObject);
var
  LTagInfoEditorDlg: TTagInfoEditorDlg;
  LTagList, LDescList, LValueList: TStringList;
  i, LIdx: integer;
  LItem: TListItem;
begin
  LTagInfoEditorDlg := TTagInfoEditorDlg.Create(nil);
  try
    LTagList := TStringList.Create;
    LDescList := TStringList.Create;
    LValueList := TStringList.Create;

    try
      for i := 0 to TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Count - 1 do
      begin
        LTagList.Add(TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Items[i].TagName);
        LDescList.Add(TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Items[i].Description);
        LValueList.Add(TFrameDataSaveAll(FFrameDataSaveAll).FIPCMonitorAll.FEngineParameter.EngineParameterCollect.Items[i].Value);
      end;

      with LTagInfoEditorDlg do
      begin
        GetTagList(LTagList, LDescList, LValueList);

        LIdx := StrToIntDef(ParamIndexEdit.Text,-1);

        if (LIdx >= 0) and (LIdx < ListView1.Items.Count) then
        begin
          LItem := ListView1.Items[LIdx];
          LItem.MakeVisible(False);
          LItem.Selected := True;
          LItem.Focused := True;
        end;

        if Execute then
          ParamIndexEdit.Text := IntToStr(FParamIndex);
      end;
    finally
      LTagList.Free;
      LDescList.Free;
    end;
  finally
    LTagInfoEditorDlg.Free;
  end;
end;

procedure TFrmDataSaveAllConfig.SaveDB_ChkBoxClick(Sender: TObject);
begin
  DB_Type_RG.Enabled := SaveDB_ChkBox.Checked;

  OracleTS.Visible := DB_Type_RG.ItemIndex = 0;
  MongoDBTS.Visible := DB_Type_RG.ItemIndex = 1;
end;

procedure TFrmDataSaveAllConfig.SaveFile_ChkBoxClick(Sender: TObject);
begin
  FNameType_RG.Enabled := SaveFile_ChkBox.Checked;
end;

procedure TFrmDataSaveAllConfig.SaveOnlyCBClick(Sender: TObject);
begin
  ParamIndexLabel.Enabled := SaveOnlyCB.Checked;
  ParamIndexEdit.Enabled := SaveOnlyCB.Checked;
end;

procedure TFrmDataSaveAllConfig.SaveRunHourCBClick(Sender: TObject);
begin
  Label24.Enabled := SaveRunHourCB.Checked;
  RunHourIndexEdit.Enabled := SaveRunHourCB.Checked;
  IntervalLbl.Enabled := SaveRunHourCB.Checked;
  RHIntervalSE.Enabled := SaveRunHourCB.Checked;
  mSecLbl.Enabled := SaveRunHourCB.Checked;
end;

procedure TFrmDataSaveAllConfig.TableNameComboDropDown(Sender: TObject);
begin
  if OracleTS.Visible then
    FillOraTableName2Combo(TableNameCombo)
  else
  if MongoDBTS.Visible then
    FillCollectName2Combo(MongoCollNameCombo);
end;

end.
