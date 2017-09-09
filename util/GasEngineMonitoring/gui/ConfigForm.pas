unit ConfigForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, JvPageListTreeView, ExtCtrls, StdCtrls, ActnList,
  JvButton, JvFooter, JvComponent, JvGroupHeader, JvCombobox, JvColorCombo,
  Buttons, JvBitBtn, JvExStdCtrls, JvExControls, JvExButtons, JvExExtCtrls,
  JvExComCtrls, JvPageList, JvCtrls, JvExtComponent, JvComCtrls, Options,
  JvComponentBase, JvgXMLSerializer, Mask, JvExMask, JvToolEdit, math,
  iComponent, iVCLComponent, iCustomComponent, iAnalogDisplay, JvListView,
  System.Actions;

type
  TConfigFormF = class(TForm)
    ImageList1: TImageList;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Splitter1: TSplitter;
    JvPagedTreeView1: TJvSettingsTreeView;
    ActionList1: TActionList;
    JvStandardPage2: TJvStandardPage;
    JvStandardPage4: TJvStandardPage;
    JvStandardPage1: TJvStandardPage;
    JvStandardPage5: TJvStandardPage;
    JvFooter1: TJvFooter;
    JvFooterBtn2: TJvFooterBtn;
    JvFooterBtn3: TJvFooterBtn;
    JvPageList1: TJvPageList;
    pgEnvironment: TJvStandardPage;
    JvGroupHeader1: TJvGroupHeader;
    JvGroupHeader2: TJvGroupHeader;
    ImageList2: TImageList;
    JvgXMLSerializer: TJvgXMLSerializer;
    XMLFilenameEdit: TJvFilenameEdit;
    Label3: TLabel;
    pgMEP: TJvStandardPage;
    Label5: TLabel;
    BoreEdit: TEdit;
    Label6: TLabel;
    StrokeEdit: TEdit;
    Label9: TLabel;
    CylEdit: TEdit;
    Label10: TLabel;
    MCREdit: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    pgAmbient: TJvStandardPage;
    Label14: TLabel;
    BPEdit: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    IATEdit: TEdit;
    Label17: TLabel;
    Label18: TLabel;
    SATEdit: TEdit;
    Label19: TLabel;
    SAPEdit: TEdit;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    SVPEdit: TEdit;
    Label23: TLabel;
    pgGovernor: TJvStandardPage;
    Label24: TLabel;
    IAHEdit: TEdit;
    Label25: TLabel;
    Label26: TLabel;
    IARTEdit: TEdit;
    Label27: TLabel;
    Label28: TLabel;
    CWITEdit: TEdit;
    Label29: TLabel;
    Label30: TLabel;
    FIMVEdit: TEdit;
    Label31: TLabel;
    Label32: TLabel;
    LIGEdit: TEdit;
    CWOTEdit: TEdit;
    Label34: TLabel;
    Label33: TLabel;
    EBPEdit: TEdit;
    Label35: TLabel;
    Label36: TLabel;
    EGTEdit: TEdit;
    Label37: TLabel;
    Label38: TLabel;
    TCSEdit: TEdit;
    Label39: TLabel;
    pgFuel: TJvStandardPage;
    Label40: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    GOFEdit: TEdit;
    FCEdit: TEdit;
    NOFEdit: TEdit;
    KOFEdit: TEdit;
    UFCEdit: TEdit;
    Label50: TLabel;
    GOEdit: TEdit;
    Label51: TLabel;
    Label52: TLabel;
    ESEdit: TEdit;
    Label53: TLabel;
    IAH2Edit: TEdit;
    Label54: TLabel;
    pgGaseous: TJvStandardPage;
    co2lbl: TiAnalogDisplay;
    collbl: TiAnalogDisplay;
    o2lbl: TiAnalogDisplay;
    noxlbl: TiAnalogDisplay;
    thclbl: TiAnalogDisplay;
    ch4lbl: TiAnalogDisplay;
    nonch4lbl: TiAnalogDisplay;
    Label41: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    CarbonEdit: TEdit;
    HydrogenEdit: TEdit;
    NitrogenEdit: TEdit;
    OxygenEdit: TEdit;
    SulfurEdit: TEdit;
    DensityEdit: TEdit;
    ViscosityEdit: TEdit;
    C_residueEdit: TEdit;
    WaterEdit: TEdit;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    pgNox: TJvStandardPage;
    Label74: TLabel;
    NhtCFEdit: TEdit;
    Label75: TLabel;
    Label76: TLabel;
    DWCFEEdit: TEdit;
    Label77: TLabel;
    Label78: TLabel;
    EGFEdit: TEdit;
    Label79: TLabel;
    AFEdit: TEdit;
    AF2Edit: TEdit;
    Label80: TLabel;
    AF3Edit: TEdit;
    Label81: TLabel;
    Label82: TLabel;
    LCVEdit: TEdit;
    Label83: TLabel;
    Label1: TLabel;
    CH4Edit: TEdit;
    Label2: TLabel;
    C2H6Edit: TEdit;
    Label4: TLabel;
    C3H8Edit: TEdit;
    Label7: TLabel;
    C4H10Edit: TEdit;
    Label8: TLabel;
    C5H12Edit: TEdit;
    Label73: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    UseInputDensityCB: TCheckBox;
    Label88: TLabel;
    RatedPowerEdit: TEdit;
    Label89: TLabel;
    pgGenerator: TJvStandardPage;
    JvListView1: TJvListView;
    Panel2: TPanel;
    JvFilenameEdit1: TJvFilenameEdit;
    JvBitBtn1: TJvBitBtn;
    Label90: TLabel;
    Label91: TLabel;
    StoiRatioEdit: TEdit;
    UseMT210CB: TCheckBox;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    RealtimeKnockCB: TCheckBox;
    RealtimeMisFireCB: TCheckBox;
    CloseTCPCB: TCheckBox;
    Label92: TLabel;
    TCCountEdit: TEdit;

    procedure FormCreate(Sender: TObject);
    procedure JvFooterBtn2Click(Sender: TObject);
    procedure JvFooterBtn3Click(Sender: TObject);
    procedure JvGroupHeader2Click(Sender: TObject);
    procedure JvBitBtn1Click(Sender: TObject);
  protected
  public
    FOptions: TOptionComponent;
    FConfigFileName: string;

    procedure SaveConfigVar2File(AFileName: string);
    procedure LoadConfigVar2Form;
    procedure LoadConfigForm2Var;
    procedure LoadGeneratorVarFromListView;
    procedure LoadGeneratorCSV2ListView;
    procedure LoadGeneratorVar2ListView;
  end;

var
  ConfigFormF: TConfigFormF;

implementation

uses CommonUtil;

{$R *.dfm}

procedure TConfigFormF.FormCreate(Sender: TObject);
begin
  //FOptions := TOptionComponent.Create(Self);
end;

procedure TConfigFormF.JvBitBtn1Click(Sender: TObject);
begin
  LoadGeneratorCSV2ListView;
end;

procedure TConfigFormF.JvFooterBtn2Click(Sender: TObject);
begin
  if Assigned(FOptions) then
  begin
    if FConfigFileName = '' then
      ShowMessage('Not assigned file name!')
    else
    begin
      if MessageDlg('Are you save?', mtConfirmation,[mbYes, mbNo],0) = mrYes then
      begin
        LoadConfigForm2Var;
        SaveConfigVar2File(FConfigFileName);
      end;
    end;
  end;
end;

procedure TConfigFormF.JvFooterBtn3Click(Sender: TObject);
begin
  Close;
end;

procedure TConfigFormF.JvGroupHeader2Click(Sender: TObject);
begin

end;

//FOptions Data를 XML 파일에 저장함.
procedure TConfigFormF.SaveConfigVar2File(AFileName: string);
var
  Fs: TFileStream;
begin
  Fs := TFileStream.Create(AFileName, fmCreate);
  try
    JvgXMLSerializer.Serialize(FOptions, Fs);
  finally
    Fs.Free;
  end;

  ShowMessage('Object has been saved to the file '#13#10 + AFileName);
end;

//Config Form의 설정값을 FOptions에 저장함.
procedure TConfigFormF.LoadConfigForm2Var;
begin
  FOptions.FileName := XMLFilenameEdit.Text;
  FOptions.Option.Clear;

  FOptions.Bore             := StrToIntDef(BoreEdit.Text,0);
  FOptions.Stroke           := StrToIntDef(StrokeEdit.Text, 0);
  FOptions.CylinderCount    := StrToIntDef(CylEdit.Text,0);
  FOptions.MCR              := StrToIntDef(MCREdit.Text,0);
  FOptions.RatedPower      := StrToFloatDef(RatedPowerEdit.Text, 0.0);
  FOptions.GeneratorOutput      := StrToFloatDef(GOEdit.Text, 0.0);
  FOptions.EngineSpeed      := StrToIntDef(ESEdit.Text, 0);

  FOPtions.IntakeAirTemp    := StrToFloatDef(IATEdit.Text, 0.0);
  //FOPtions.SVP              := StrToFloatDef(SVPEdit.Text, 0.0);
  FOptions.SAP              := StrToFloatDef(SAPEdit.Text, 0.0);
  FOPtions.SAT              := StrToFloatDef(SATEdit.Text, 0.0);
  FOptions.BP               := StrToFloatDef(BPEdit.Text, 0.0);

  FOptions.IAH              := StrToFloatDef(IAHEdit.Text, 0.0);
  FOptions.IART             := StrToFloatDef(IARTEdit.Text, 0.0);
  FOptions.CWIT             := StrToFloatDef(CWITEdit.Text, 0.0);
  FOptions.CWOT             := StrToFloatDef(CWOTEdit.Text, 0.0);

  //FOptions.FC               := StrToFloatDef(FCEdit.Text, 0.0);
  FOptions.LCV              := StrToIntDef(LCVEdit.Text, 0);

  FOptions.CH4              := StrToFloatDef(CH4Edit.Text, 0.0);
  FOptions.C2H6             := StrToFloatDef(C2H6Edit.Text, 0.0);
  FOptions.C3H8             := StrToFloatDef(C3H8Edit.Text, 0.0);
  FOptions.C4H10            := StrToFloatDef(C4H10Edit.Text, 0.0);
  FOptions.C5H12            := StrToFloatDef(C5H12Edit.Text, 0.0);

  //FOptions.Carbon           := StrToFloatDef(CarbonEdit.Text, 0.0);
  //FOptions.Hydrogen         := StrToFloatDef(HydrogenEdit.Text, 0.0);
  //FOptions.Nitrogen         := StrToFloatDef(NitroGenEdit.Text, 0.0);
  //FOptions.Oxygen           := StrToFloatDef(OxygenEdit.Text, 0.0);
  //FOptions.Sulfur           := StrToFloatDef(SulfurEdit.Text, 0.0);
  FOptions.StoichiometricRatio := StrToFloatDef(StoiRatioEdit.Text, 0.0);
  FOptions.UseInputDensity := UseInputDensityCB.Checked;
  if FOptions.UseInputDensity then
    FOptions.Density          := StrToFloatDef(DensityEdit.Text, 0.0);
  FOptions.Viscosity          := StrToFloatDef(ViscosityEdit.Text, 0.0);
  FOptions.C_residue          := StrToFloatDef(C_ResidueEdit.Text, 0.0);
  FOptions.Water              := StrToFloatDef(WaterEdit.Text, 0.0);

  FOptions.UseMT210Data := UseMT210CB.Checked;
  FOptions.RealtimeKnockData := RealtimeKnockCB.Checked;
  FOptions.RealtimeMisfireData := RealtimeMisFireCB.Checked;
  FOptions.CloseTCPClient := CloseTCPCB.Checked;
  FOptions.TCCount := StrToIntDef(TCCountEdit.Text,1);

  LoadGeneratorVarFromListView;
end;

procedure TConfigFormF.LoadConfigVar2Form;
begin
  if FOptions.Option.Count = 0 then
    FOptions.AddDefautProperties;

  XMLFilenameEdit.Text    := FOptions.FileName;

  BoreEdit.Text           := IntToStr(FOptions.Bore);
  StrokeEdit.Text         := IntToStr(FOptions.Stroke);
  CylEdit.Text            := IntToStr(FOptions.CylinderCount);
  MCREdit.Text            := IntToStr(FOptions.MCR);
  GOEdit.Text             := FloatToStr(FOptions.GeneratorOutput);
  RatedPowerEdit.Text     := FloatToStr(FOptions.RatedPower);
  ESEdit.Text             := FloatToStr(FOptions.EngineSpeed);

  IATEdit.Text            := FloatToStr(FOPtions.IntakeAirTemp);
  SVPEdit.Text            := Format('%.3f',[FOPtions.SVP]);
  SAPEdit.Text            := FloatToStr(FOptions.SAP);
  SATEdit.Text            := FloatToStr(FOPtions.SAT);
  BPEdit.Text             := FloatToStr(FOptions.BP);

  IAHEdit.Text            := FloatToStr(FOptions.IAH);
  IAH2Edit.Text           := FloatToStr(FOptions.IAH2); //
  IARTEdit.Text           := FloatToStr(FOptions.IART);
  CWITEdit.Text           := FloatToStr(FOptions.CWIT);
  CWOTEdit.Text           := FloatToStr(FOptions.CWOT);

  FCEdit.Text             := FloatToStr(FOptions.FC);
  UFCEdit.Text            := Format('%.3f',[FOptions.UFC]);
  LCVEdit.Text            := FloatToStr(FOptions.LCV);

  CH4Edit.Text            := FloatToStr(FOptions.CH4);
  C2H6Edit.Text           := FloatToStr(FOptions.C2H6);
  C3H8Edit.Text           := FloatToStr(FOptions.C3H8);
  C4H10Edit.Text          := FloatToStr(FOptions.C4H10);
  C5H12Edit.Text          := FloatToStr(FOptions.C5H12);

  CarbonEdit.Text         := Format('%.3f',[FOptions.Carbon]);
  HydrogenEdit.Text       := Format('%.3f',[FOptions.Hydrogen]);
  NitroGenEdit.Text       := Format('%.3f',[FOptions.Nitrogen]);
  OxygenEdit.Text         := Format('%.3f',[FOptions.Oxygen]);
  SulfurEdit.Text         := Format('%.3f',[FOptions.Sulfur]);
  UseInputDensityCB.Checked := FOptions.UseInputDensity;
  StoiRatioEdit.Text        := Format('%.4f',[FOptions.StoichiometricRatio]);
  DensityEdit.Text        := Format('%.4f',[FOptions.Density]);
  ViscosityEdit.Text      := FloatToStr(FOptions.Viscosity);
  C_ResidueEdit.Text      := FloatToStr(FOptions.C_residue);
  WaterEdit.Text          := FloatToStr(FOptions.Water);

  NhtCFEdit.Text          := FloatToStr(FOptions.NhtCF);
  DWCFEEdit.Text          := FloatToStr(FOptions.DWCFE);
  EGFEdit.Text            := FloatToStr(FOptions.EGF);
  AFEdit.Text             := FloatToStr(FOptions.AF1);
  AF2Edit.Text            := FloatToStr(FOptions.AF2);
  AF3Edit.Text            := FloatToStr(FOptions.AF3);
  UseMT210CB.Checked := FOptions.UseMT210Data;
  RealtimeKnockCB.Checked := FOptions.RealtimeKnockData;
  RealtimeMisFireCB.Checked := FOptions.RealtimeMisfireData;
  CloseTCPCB.Checked := FOptions.CloseTCPClient;
  TCCountEdit.Text := IntToStr(FOptions.TCCount);

  LoadGeneratorVar2ListView;
end;

procedure TConfigFormF.LoadGeneratorVar2ListView;
var
  Li: integer;
  ListItem: TListItem;
begin
  JvListView1.Items.Clear;

  for Li := 0 to FOptions.Option.Count - 1 do
  begin
    with JvListView1.Items do
    begin
      ListItem := Add;
      ListItem.Caption := IntToStr(FOptions.Option[Li].EngineLoad);
      ListItem.SubItems.Add(Format('%.1f',[FOptions.Option[Li].EngineOutput]));
      ListItem.SubItems.Add(Format('%.3f',[FOptions.Option[Li].GenEfficiency]));
      ListItem.SubItems.Add(Format('%.1f',[FOptions.Option[Li].GenOutput]));
    end;//with

    with FOptions.Option.Add do
    begin
      EngineLoad := StrToIntDef(JvListView1.Items[Li].Caption,0);
      EngineOutput := StrToFloatDef(JvListView1.Items[Li].SubItems[0],0.0);
      GenEfficiency := StrToFloatDef(JvListView1.Items[Li].SubItems[1],0.0);
      GenOutput := StrToFloatDef(JvListView1.Items[Li].SubItems[2], 0.0);
    end;//with
  end;//for
end;

procedure TConfigFormF.LoadGeneratorVarFromListView;
var
  Li: integer;
begin
  for Li := 0 to JvListView1.Items.Count - 1 do
  begin
    with FOptions.Option.Add do
    begin
      EngineLoad := StrToIntDef(JvListView1.Items[Li].Caption,0);
      EngineOutput := StrToFloatDef(JvListView1.Items[Li].SubItems[0],0.0);
      GenEfficiency := StrToFloatDef(JvListView1.Items[Li].SubItems[1],0.0);
      GenOutput := StrToFloatDef(JvListView1.Items[Li].SubItems[2], 0.0);
    end;//with
  end;//for
end;

procedure TConfigFormF.LoadGeneratorCSV2ListView;
var
  Li: integer;
  LStrLst: TStringList;
  LStr: string;
  ListItem: TListItem;
begin
  if JvFilenameEdit1.FileName = '' then
  begin
    ShowMessage('Filename is empty!');
    exit;
  end;

  JvListView1.Items.Clear;
  
  LStrLst := TStringList.Create;
  try
    LStrLst.LoadFromFile(JvFilenameEdit1.FileName);
    for Li := 0 to LStrLst.Count - 1 do
    begin
      LStr := LStrLst.Strings[Li];
      with JvListView1.Items do
      begin
        ListItem := Add;
        ListItem.Caption := GetTokenWithComma(LStr);
        ListItem.SubItems.Add(GetTokenWithComma(LStr));
        ListItem.SubItems.Add(GetTokenWithComma(LStr));
        ListItem.SubItems.Add(GetTokenWithComma(LStr));
      end;//with
    end;//for
  finally
    LStrLst.Free;
  end;
end;

end.


