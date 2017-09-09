unit DataSaveAll_ConfigUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  JvExMask, JvToolEdit, Vcl.Samples.Spin, Vcl.ComCtrls, Vcl.Buttons, Ora,
  Vcl.CheckLst, EditBtn;

type
  TFrmDataSaveAllConfig = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
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
    Database: TTabSheet;
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
    ParamIndexEdit: TEditBtn;
    Label18: TLabel;
    AutoStartAfterEdit: TSpinEdit;
    Label27: TLabel;
    Button1: TButton;
    procedure TableNameComboDropDown(Sender: TObject);
    procedure SaveOnlyCBClick(Sender: TObject);
    procedure SaveRunHourCBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ParamIndexEditClickBtn(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ParamSourceCLBDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDataSaveAllConfig: TFrmDataSaveAllConfig;

implementation

uses TagNameListView, DataSaveAll_FrameUnit;

{$R *.dfm}

procedure TFrmDataSaveAllConfig.Button1Click(Sender: TObject);
var
  LFileName: string;
begin
  LFileName := ParaFilenameEdit.FileName;

  if FileExists(LFileName) then
  begin
    ParamSourceCLB.Clear;

    DataSaveAllF.TFrameDataSaveAll1.ParamSource2CLBFromFile(ParamSourceCLB,
      LFileName, ConfFileFormatRG.ItemIndex, EngParamEncryptCB.Checked);
  end;

  ParamSourceCLB.Refresh;
end;

procedure TFrmDataSaveAllConfig.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet5;
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
      for i := 0 to DataSaveAllF.TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Count - 1 do
      begin
        LTagList.Add(DataSaveAllF.TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].TagName);
        LDescList.Add(DataSaveAllF.TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Description);
        LValueList.Add(DataSaveAllF.TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[i].Value);
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

procedure TFrmDataSaveAllConfig.ParamSourceCLBDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Flags: Longint;
begin
  with ParamSourceCLB.Canvas do
  begin
    if ParamSourceCLB.ItemEnabled[Index] then
    begin
//      Brush.Color := $00E5E5E5;
      FillRect(Rect);
      Font.Color := clBlue;

//      Canvas.Brush.Color := $00E5E5E5;
//      Canvas.FillRect(Rect);
//      Canvas.Font.Color := clBlue;
//      Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
//
//      if not UseRightToLeftAlignment then
//        Inc(Rect.Left, 2)
//      else
//        Dec(Rect.Right, 2);
//
//      DrawText(Canvas.Handle, Items[Index], Length(Items[Index]), Rect, Flags);
    end
    else
      Font.Style := [fsStrikeOut];
  end;


  ParamSourceCLB.Canvas.TextOut(Rect.Left, Rect.Top, ParamSourceCLB.Items[Index]);
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

end.
