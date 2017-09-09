unit UnitGeneratorInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask,
  ExtCtrls, ComCtrls,
  NxCollection, NxScrollControl, NxSheet, GeneratorBaseClass, GeneratorEfficiencyClass,
  NxColumns, NxColumnClasses, NxCustomGridControl, NxCustomGrid, NxGrid,
  JvDialogs, JvExButtons, JvBitBtn, JvExMask, JvToolEdit;

type
  TFrmGeneratorInfo = class(TForm)
    NxSplitter1: TNxSplitter;
    NxSplitter2: TNxSplitter;
    NxFlipPanel1: TNxFlipPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    TypeEdit: TEdit;
    SerialEdit: TEdit;
    APEdit: TEdit;
    PFEdit: TEdit;
    VoltageEdit: TEdit;
    FreqEdit: TEdit;
    PoleEdit: TEdit;
    STEdit: TEdit;
    CREdit: TEdit;
    RarmEdit: TEdit;
    RfldEdit: TEdit;
    RfldTempEdit: TEdit;
    NxFlipPanel2: TNxFlipPanel;
    NextSheet1: TNextSheet;
    NxFlipPanel3: TNxFlipPanel;
    Panel2: TPanel;
    Label90: TLabel;
    JvFilenameEdit1: TJvFilenameEdit;
    JvBitBtn1: TJvBitBtn;
    CheckBox1: TCheckBox;
    NextGrid1: TNextGrid;
    Load: TNxTextColumn;
    EngOutput: TNxTextColumn;
    Efficiency: TNxTextColumn;
    GenOutput: TNxTextColumn;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    JvOpenDialog1: TJvOpenDialog;
    procedure JvBitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure NxFlipPanel2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FApplicationPath,
    FGenInfoFileName,
    FGenEfficiencyFileName: string;

    FIsEncrypt: Boolean;

    FGeneratorInfo: TGeneratorInfo; //Generator Basic Info
    FGeneratorEfficiency: TGeneratorEfficiency; //Generator Efficiency Info
  public
    procedure SetGridHeader;

    procedure LoadGeneratorInfo(AFileName:string; AIsEncrypt: Boolean);
    procedure SaveGeneratorInfo(AFileName:string; AIsEncrypt: Boolean);
    procedure LoadGeneratorEfficiency(AFileName:string; AIsEncrypt: Boolean);
    procedure SaveGeneratorEfficiency(AFileName:string; AIsEncrypt: Boolean);
  end;

var
  FrmGeneratorInfo: TFrmGeneratorInfo;

implementation

uses
  NxSheetCell;

{$R *.dfm}

//콤마로 분리된 문자를 하나씩 반환한다.
//원본에서는 추출된 문자를 지운다.
function GetTokenWithComma( var str1: string ): String;
var i: integer;
begin
  i := Pos(',',Str1);
  if i > 0 then
  begin
    Result := System.Copy(Str1, 1, i-1);
    System.Delete(Str1,1,i);
  end
  else
    Result := Str1;
end;

procedure Create_GeneratorInfop;
begin
  TFrmGeneratorInfo.Create(Application);
end;

procedure TFrmGeneratorInfo.BitBtn2Click(Sender: TObject);
begin
  SetCurrentDir(FApplicationPath);
  SaveGeneratorInfo(FGenInfoFileName, FIsEncrypt);
  SaveGeneratorEfficiency(FGenEfficiencyFileName, FIsEncrypt);
end;

procedure TFrmGeneratorInfo.BitBtn3Click(Sender: TObject);
begin
{  JvOpenDialog1.InitialDir := FApplicationPath;
  if JvOpenDialog1.Execute then
  begin
    if jvOpenDialog1.FileName <> '' then
    begin
      LoadEngineInfo(JvOpenDialog1.FileName, False);
    end;
  end;
}
  LoadGeneratorInfo(FGenInfoFileName, FIsEncrypt);
  LoadGeneratorEfficiency(FGenEfficiencyFileName, FIsEncrypt);
end;

procedure TFrmGeneratorInfo.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
    NextGrid1.Options := NextGrid1.Options - [goSelectFullRow]
  else NextGrid1.Options := NextGrid1.Options + [goSelectFullRow];

end;

procedure TFrmGeneratorInfo.FormActivate(Sender: TObject);
begin
  Invalidate;
end;

procedure TFrmGeneratorInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FGeneratorInfo.Free;
  FGeneratorEfficiency.Free;

  Action := caFree;
end;

procedure TFrmGeneratorInfo.FormCreate(Sender: TObject);
begin
  FApplicationPath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨

  FGeneratorInfo := TGeneratorInfo.Create(Self);
  FGeneratorEfficiency := TGeneratorEfficiency.Create(Self);

  FGenInfoFileName := '.\doc\GenInfo.himecs';
  FGenEfficiencyFileName := '.\doc\GenEfficiency.himecs';

  FIsEncrypt := False;
  SetGridHeader;
  LoadGeneratorInfo(FGenInfoFileName, FIsEncrypt);
  LoadGeneratorEfficiency(FGenEfficiencyFileName, FIsEncrypt);
end;

procedure TFrmGeneratorInfo.FormShow(Sender: TObject);
begin
  Invalidate;
  NxFlipPanel1.Invalidate;
  NxFlipPanel2.Invalidate;
  NxFlipPanel3.Invalidate;
end;

procedure TFrmGeneratorInfo.JvBitBtn1Click(Sender: TObject);
var
  i: integer;
  LStrLst: TStringList;
  LStr: string;
  ListItem: TListItem;
begin
  if JvFilenameEdit1.FileName = '' then
  begin
    ShowMessage('Filename is empty!');
    exit;
  end;

  LStrLst := TStringList.Create;
  try
    LStrLst.LoadFromFile(JvFilenameEdit1.FileName);

    NextGrid1.AddRow(LStrLst.Count);
    NextGrid1.BeginUpdate; { much faster, skip OnChange and Cell refreshing }

    for i := 0 to NextGrid1.RowCount - 1 do
    begin
      LStr := LStrLst.Strings[i];
      NextGrid1.Cell[0, i].AsString := GetTokenWithComma(LStr);
      NextGrid1.Cell[1, i].AsString := GetTokenWithComma(LStr);
      NextGrid1.Cell[2, i].AsString := GetTokenWithComma(LStr);
      NextGrid1.Cell[3, i].AsString := GetTokenWithComma(LStr);
      //NextGrid1.Cell[9, i].Hint := 'Delete Row';
    end;

    NextGrid1.EndUpdate;

  finally
    LStrLst.Free;
  end;
end;

procedure TFrmGeneratorInfo.LoadGeneratorEfficiency(AFileName: string;
  AIsEncrypt: Boolean);
var
  i: integer;
begin
  FGeneratorEfficiency.GeneratorEfficiencyCollect.Clear;
  FGeneratorEfficiency.Clear;
  FGeneratorEfficiency.LoadFromFile(FApplicationPath+AFileName,AFileName,AIsEncrypt);

  if FGeneratorEfficiency.GeneratorEfficiencyCollect.Count > 0 then
    NextGrid1.ClearRows;

  for i := 0 to FGeneratorEfficiency.GeneratorEfficiencyCollect.Count - 1 do
  begin
    With FGeneratorEfficiency.GeneratorEfficiencyCollect.Items[i] do
    begin
      NextGrid1.AddRow;
      NextGrid1.Cell[0, i].AsString := IntToStr(EngineLoad);
      NextGrid1.Cell[1, i].AsString := FloatToStr(EngineOutput);
      NextGrid1.Cell[2, i].AsString := FloatToStr(GenEfficiency);
      NextGrid1.Cell[3, i].AsString := FloatToStr(GenOutput);
    end;//with
  end;//for

end;

procedure TFrmGeneratorInfo.LoadGeneratorInfo(AFileName: string;
  AIsEncrypt: Boolean);
var
  i: integer;
begin
  FGeneratorInfo.GeneratorInfoCollect.Clear;
  FGeneratorInfo.Clear;
  FGeneratorInfo.LoadFromFile(FApplicationPath+AFileName,AFileName,AIsEncrypt);

  TypeEdit.Text := FGeneratorInfo.GeneratorType;
  SerialEdit.Text := FGeneratorInfo.SerialNo;
  APEdit.Text := FGeneratorInfo.ApparentPower;
  //FGeneratorInfo.ActivePower := '';
  //FGeneratorInfo.ReactivePower := '';
  PFEdit.Text := FGeneratorInfo.PowerFactor;
  VoltageEdit.Text := FGeneratorInfo.Voltage;
  FreqEdit.Text := FGeneratorInfo.Frequency;
  PoleEdit.Text := FGeneratorInfo.Poles;
  STEdit.Text := FGeneratorInfo.SpecificTemp;
  CREdit.Text := FGeneratorInfo.CurrentRatio;
  RarmEdit.Text := FGeneratorInfo.Rarm;
  RfldEdit.Text := FGeneratorInfo.Rfld;
  RfldTempEdit.Text := FGeneratorInfo.Rfld_temp;

  for i := 1 to FGeneratorInfo.GeneratorInfoCollect.Count do
    With FGeneratorInfo.GeneratorInfoCollect.Items[i-1] do
    begin
      NextSheet1.Cell[i, 0].Text := IntToStr(EngineLoad);
      NextSheet1.Cell[i, 1].Text := FloatToStr(GenOutput);
      NextSheet1.Cell[i, 2].Text := FloatToStr(GenCurrent);
      NextSheet1.Cell[i, 3].Text := FloatToStr(Exc_Amps);
      NextSheet1.Cell[i, 4].Text := FloatToStr(Field_Amps);
      NextSheet1.Cell[i, 5].Text := FloatToStr(Mech_Loss);
      NextSheet1.Cell[i, 6].Text := FloatToStr(Core_Loss);
      NextSheet1.Cell[i, 7].Text := FloatToStr(Arm_Copper);
      NextSheet1.Cell[i, 8].Text := FloatToStr(Fld_Copper);
      NextSheet1.Cell[i, 9].Text := FloatToStr(StrayLoad);
      NextSheet1.Cell[i, 10].Text := FloatToStr(TotalLoss);
      NextSheet1.Cell[i, 11].Text := FloatToStr(GenInput);
      NextSheet1.Cell[i, 12].Text := FloatToStr(GenEfficiency);

      NextSheet1.Cell[i, 0].Alignment := caCenter;
      NextSheet1.Cell[i, 1].Alignment := caCenter;
      NextSheet1.Cell[i, 2].Alignment := caCenter;
      NextSheet1.Cell[i, 3].Alignment := caCenter;
      NextSheet1.Cell[i, 4].Alignment := caCenter;
      NextSheet1.Cell[i, 5].Alignment := caCenter;
      NextSheet1.Cell[i, 6].Alignment := caCenter;
      NextSheet1.Cell[i, 7].Alignment := caCenter;
      NextSheet1.Cell[i, 8].Alignment := caCenter;
      NextSheet1.Cell[i, 9].Alignment := caCenter;
      NextSheet1.Cell[i, 10].Alignment := caCenter;
      NextSheet1.Cell[i, 11].Alignment := caCenter;
      NextSheet1.Cell[i, 12].Alignment := caCenter;
    end;
end;

procedure TFrmGeneratorInfo.NxFlipPanel2MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  NxFlipPanel2.Invalidate;
end;

procedure TFrmGeneratorInfo.SaveGeneratorEfficiency(AFileName: string;
  AIsEncrypt: Boolean);
var
  i: integer;
begin
  FGeneratorEfficiency.GeneratorEfficiencyCollect.Clear;
  FGeneratorEfficiency.Clear;

  for i := 0 to NextGrid1.RowCount - 1 do
  begin
    with FGeneratorEfficiency.GeneratorEfficiencyCollect.Add do
    begin
      EngineLoad := StrToIntDef(NextGrid1.Cell[0, i].AsString, 0);
      EngineOutput := StrToFloatDef(NextGrid1.Cell[1, i].AsString, 0.0);
      GenEfficiency := StrToFloatDef(NextGrid1.Cell[2, i].AsString, 0.0);
      GenOutput := StrToFloatDef(NextGrid1.Cell[3, i].AsString, 0.0);
    end;
  end;

  FGeneratorEfficiency.SaveToFile(AFileName,'',AIsEncrypt);
end;

procedure TFrmGeneratorInfo.SaveGeneratorInfo(AFileName: string;
  AIsEncrypt: Boolean);
var
  i: integer;
begin
  FGeneratorInfo.GeneratorInfoCollect.Clear;
  FGeneratorInfo.Clear;

  FGeneratorInfo.GeneratorType := TypeEdit.Text;
  FGeneratorInfo.SerialNo := SerialEdit.Text;
  FGeneratorInfo.ApparentPower := APEdit.Text;
  FGeneratorInfo.PowerFactor := PFEdit.Text;
  FGeneratorInfo.ActivePower := '';
  FGeneratorInfo.ReactivePower := '';
  FGeneratorInfo.Voltage := VoltageEdit.Text;
  FGeneratorInfo.Frequency := FreqEdit.Text;
  FGeneratorInfo.Poles := PoleEdit.Text;
  FGeneratorInfo.SpecificTemp := STEdit.Text;
  FGeneratorInfo.CurrentRatio := CREdit.Text;
  FGeneratorInfo.Rarm := RarmEdit.Text;
  FGeneratorInfo.Rfld := RfldEdit.Text;
  FGeneratorInfo.Rfld_temp := RfldTempEdit.Text;

  for i := 1 to 4 do
    With FGeneratorInfo.GeneratorInfoCollect.Add do
    begin
      EngineLoad := StrToIntDef(NextSheet1.Cell[i, 0].Text, 0);
      GenOutput := StrToFloatDef(NextSheet1.Cell[i, 1].Text, 0.0);
      GenCurrent := StrToFloatDef(NextSheet1.Cell[i, 2].Text, 0.0);
      Exc_Amps := StrToFloatDef(NextSheet1.Cell[i, 3].Text, 0.0);
      Field_Amps := StrToFloatDef(NextSheet1.Cell[i, 4].Text, 0.0);
      Mech_Loss := StrToFloatDef(NextSheet1.Cell[i, 5].Text, 0.0);
      Core_Loss := StrToFloatDef(NextSheet1.Cell[i, 6].Text, 0.0);
      Arm_Copper := StrToFloatDef(NextSheet1.Cell[i, 7].Text, 0.0);
      Fld_Copper := StrToFloatDef(NextSheet1.Cell[i, 8].Text, 0.0);
      StrayLoad := StrToFloatDef(NextSheet1.Cell[i, 9].Text, 0.0);
      TotalLoss := StrToFloatDef(NextSheet1.Cell[i, 10].Text, 0.0);
      GenInput := StrToFloatDef(NextSheet1.Cell[i, 11].Text, 0.0);
      GenEfficiency := StrToFloatDef(NextSheet1.Cell[i, 12].Text, 0.0);
    end;

  FGeneratorInfo.SaveToFile(AFileName,'',AIsEncrypt);
end;

procedure TFrmGeneratorInfo.SetGridHeader;
begin
  NextSheet1.Column[0].Size := 120;   //Column size

  NextSheet1.Cell[0, 0].Text := 'Load        [%]';
  NextSheet1.Cell[0, 0].Color := $00F1E5DB;
  NextSheet1.Cell[0, 0].Font.Size := 10;
  NextSheet1.FrameCell(0, 0, lsThinLine, $00D58E53);

  NextSheet1.Cell[0, 1].Text := 'Output      [kW]';
  NextSheet1.Cell[0, 1].Color := $00F1E5DB;
  NextSheet1.Cell[0, 1].Font.Size := 10;
  NextSheet1.FrameCell(0, 1, lsThinLine, $00D58E53);

  NextSheet1.Cell[0, 2].Text := 'Current       [A]';
  NextSheet1.Cell[0, 2].Color := $00F1E5DB;
  NextSheet1.Cell[0, 2].Font.Size := 10;
  NextSheet1.FrameCell(0, 2, lsThinLine, $00D58E53);

  NextSheet1.Cell[0, 3].Text := 'Exc. Amps   [A]';
  NextSheet1.Cell[0, 3].Color := $00F1E5DB;
  NextSheet1.Cell[0, 3].Font.Size := 10;
  NextSheet1.FrameCell(0, 3, lsThinLine, $00D58E53);

  NextSheet1.Cell[0, 4].Text := 'Field Amps  [A]';
  NextSheet1.Cell[0, 4].Color := $00F1E5DB;
  NextSheet1.Cell[0, 4].Font.Size := 10;
  NextSheet1.FrameCell(0, 4, lsThinLine, $00D58E53);

  NextSheet1.Cell[0, 5].Text := 'Mech. Loss  [kW]';
  NextSheet1.Cell[0, 5].Color := $00F1E5DB;
  NextSheet1.Cell[0, 5].Font.Size := 10;
  NextSheet1.FrameCell(0, 5, lsThinLine, $00D58E53);

  NextSheet1.Cell[0, 6].Text := 'Core Loss    [kW]';
  NextSheet1.Cell[0, 6].Color := $00F1E5DB;
  NextSheet1.Cell[0, 6].Font.Size := 10;
  NextSheet1.FrameCell(0, 6, lsThinLine, $00D58E53);

  NextSheet1.Cell[0, 7].Text := 'Arm. Copper [kW]';
  NextSheet1.Cell[0, 7].Color := $00F1E5DB;
  NextSheet1.Cell[0, 7].Font.Size := 10;
  NextSheet1.FrameCell(0, 7, lsThinLine, $00D58E53);

  NextSheet1.Cell[0, 8].Text := 'Fld. Copper  [kW]';
  NextSheet1.Cell[0, 8].Color := $00F1E5DB;
  NextSheet1.Cell[0, 8].Font.Size := 10;
  NextSheet1.FrameCell(0, 8, lsThinLine, $00D58E53);

  NextSheet1.Cell[0, 9].Text := 'Stray Load  [kW]';
  NextSheet1.Cell[0, 9].Color := $00F1E5DB;
  NextSheet1.Cell[0, 9].Font.Size := 10;
  NextSheet1.FrameCell(0, 9, lsThinLine, $00D58E53);

  NextSheet1.Cell[0, 10].Text := 'Total Loss   [kW]';
  NextSheet1.Cell[0, 10].Color := $00F1E5DB;
  NextSheet1.Cell[0, 10].Font.Size := 10;
  NextSheet1.FrameCell(0, 10, lsThinLine, $00D58E53);

  NextSheet1.Cell[0, 11].Text := 'Input        [kW]';
  NextSheet1.Cell[0, 11].Color := $00F1E5DB;
  NextSheet1.Cell[0, 11].Font.Size := 10;
  NextSheet1.FrameCell(0, 11, lsThinLine, $00D58E53);

  NextSheet1.Cell[0, 12].Text := 'Efficiency[%/100]';
  NextSheet1.Cell[0, 12].Color := $00F1E5DB;
  NextSheet1.Cell[0, 12].Font.Size := 10;
  NextSheet1.FrameCell(0, 12, lsThinLine, $00D58E53);

  NextSheet1.Cell[1, 0].Text := '50';
  NextSheet1.Cell[1, 0].Color := $00F1E5DB;
  NextSheet1.Cell[1, 0].Font.Size := 10;
  NextSheet1.FrameCell(1, 0, lsThinLine, $00D58E53);
  NextSheet1.Cell[1, 0].Alignment := caCenter;

  NextSheet1.Cell[2, 0].Text := '75';
  NextSheet1.Cell[2, 0].Color := $00F1E5DB;
  NextSheet1.Cell[2, 0].Font.Size := 10;
  NextSheet1.FrameCell(2, 0, lsThinLine, $00D58E53);
  NextSheet1.Cell[2, 0].Alignment := caCenter;

  NextSheet1.Cell[3, 0].Text := '100';
  NextSheet1.Cell[3, 0].Color := $00F1E5DB;
  NextSheet1.Cell[3, 0].Font.Size := 10;
  NextSheet1.FrameCell(3, 0, lsThinLine, $00D58E53);
  NextSheet1.Cell[3, 0].Alignment := caCenter;

  NextSheet1.Cell[4, 0].Text := '110';
  NextSheet1.Cell[4, 0].Color := $00F1E5DB;
  NextSheet1.Cell[4, 0].Font.Size := 10;
  NextSheet1.FrameCell(4, 0, lsThinLine, $00D58E53);
  NextSheet1.Cell[4, 0].Alignment := caCenter;
end;

exports //The export name is Case Sensitive
  Create_GeneratorInfop;

end.
