unit main_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, JvExMask,
  JvToolEdit, AdvGrid, AsgLinks, Vcl.Grids, AdvObj, BaseGrid, Vcl.ExtCtrls,
  Vcl.OleCtrls, NxCollection, iComponent, iVCLComponent,
  iCustomComponent, iPlotComponent, iPlot, Data.Bind.EngExt, Vcl.Bind.DBEngExt,
  System.Rtti, System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.Components,
  Vcl.ComCtrls, AdvDateTimePicker, AdvSmoothGauge,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, AdvScrollBox, AdvSmoothProgressBar,
  UnitFrameIPCMonitorAll, iLabel, iPositionComponent, iProgressComponent,
  iLedBar;

type
  DFLoad = (df10, df15, df20,df25,df30,df35,df40,df45,df50,df55,dfnull);

const
  R_GasRatio : array[0..9] of record
    Load : DFLoad;
    Duration: double;
  end = ((Load : df10; Duration : 50),
         (Load : df15; Duration : 52.5),
         (Load : df20; Duration : 55),
         (Load : df25; Duration : 57.5),
         (Load : df30; Duration : 60),
         (Load : df35; Duration : 62.5),
         (Load : df40; Duration : 65),
         (Load : df45; Duration : 67.5),
         (Load : df50; Duration : 70),
         (Load : df55; Duration : 72.5));

type
  TForm3 = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    Button1: TButton;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    Panel4: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    LoadPanel: TPanel;
    Panel5: TPanel;
    Panel10: TPanel;
    Label3: TLabel;
    DieselLoad: TAdvSmoothProgressBar;
    Panel14: TPanel;
    Label1: TLabel;
    GasLoad: TAdvSmoothProgressBar;
    Panel7: TPanel;
    iPlot1: TiPlot;
    Panel9: TPanel;
    iLabel1: TiLabel;
    Panel13: TPanel;
    iLabel2: TiLabel;
    Panel15: TPanel;
    iLabel3: TiLabel;
    TFrameIPCMonitorAll1: TFrameIPCMonitorAll;
    Panel1: TPanel;
    Panel6: TPanel;
    Panel8: TPanel;
    EngRpmPanel: TPanel;
    TCRpmPanel: TPanel;
    DLoadPanel: TPanel;
    GLoadPanel: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FCurrentChannel : integer;
    FPrevOperationMode: integer;
    FOperatingMode : integer; //0 : Diesel, 1 : Gas
    FstartRow : integer;
    FIdx : integer;
    FStep: integer;

    procedure initvar;
    procedure ChangeMode;
    function GetFuelMode: boolean;
  public
    function Set_Channel(aChannel,aOpMode:integer) : Boolean;
    procedure WatchValue2Screen_Analog(Name: string; AValue: string;
                                AEPIndex: integer);
    function GetLoad(aLoad: double): double;
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses HiMECSConst;

procedure TForm3.Button1Click(Sender: TObject);
var
  lb : TButton;
begin
  lb := TButton(Sender);
  if lb.Caption = 'Start Monitoring' then
  begin
    lb.Caption := 'Stop Monitoring';
    Timer1.Enabled := True;
  end
  else
  begin
    lb.Caption := 'Start Monitoring';
    Timer1.Enabled := False;

  end;
end;

procedure TForm3.ChangeMode;
var
  lCurrentChannel : integer;
  lStatus : String;
begin
  if GetFuelMode then
  begin
    lCurrentChannel := FCurrentChannel;
    Inc(lCurrentChannel);

    //DieselLoad.Position := 0;
    //GasLoad.Position := 0;

    if lCurrentChannel > 0 then
    begin
      if lCurrentChannel > 2 then
        lCurrentChannel := iPlot1.AddChannel;

      if Set_Channel(lCurrentChannel,FOperatingMode) = True then
        FCurrentChannel := lCurrentChannel;
    end
    else
      FCurrentChannel := lCurrentChannel;
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
var
  li : integer;
begin
  FStep := 0;
  FOperatingMode := 0;
  FCurrentChannel := 0;
//  AdvStringGrid1.LoadFromCSV('D:\00.Develop\00.Delphi\01.Project\Demo\H35DF_MONITORING\ss\test .csv');


  iPlot1.YAxis[0].Min := 0;
  iPlot1.YAxis[0].Span := 120;

  iPlot1.XAxis[0].Min := Now;
  iPlot1.XAxis[0].Span := 0.008333333333333;
  iPlot1.XAxis[0].TrackingMaxMargin := 0.001;

  DieselLoad.Position := 0;
  GasLoad.Position := 0;

  //iPlot1.Channel[0].Color := clBlue;
  //iPlot1.Channel[1].Color := clLime;
  iPlot1.Channel[0].FillEnabled := True;
  iPlot1.Channel[1].FillEnabled := True;
  iPlot1.Channel[2].FillEnabled := True;

  initvar;
//  iPlot1.XAxis[0].Span := 0.0208333333333333;
{
  for li := 0 to 10 do
  begin
    if AdvStringGrid1.Cells[0,li] = '1' then
    begin
      FStartRow := li;
      FIdx := FStartRow;
      Break;
    end;
  end;
}
end;

function TForm3.GetFuelMode: boolean;
var
  ld, lg: double;
  lmode: integer;
begin
  Result := False;

  ld := StrToFloatDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[301].Value,0);
  lg := StrToFloatDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[302].Value,0);

  if (ld > 0) and (lg > 0) then
    FOperatingMode := 1 //Change over Mdoe
  else if (ld = 0) and (lg > 0) then
    FOperatingMode := 2 //Gas Mdoe
  else// if ((ld > 0) and (lg = 0)) or ((ld = 0) and (lg = 0)) then
    FOperatingMode := 0; //Diesel Mode

  if FPrevOperationMode <> FOperatingMode then
  begin
    FPrevOperationMode := FOperatingMode;
    Result := True;
  end;
end;

function TForm3.GetLoad(aLoad: double): double;
var
  Lload: DFLoad;
begin
  Result := -1;

  if (aLoad > 0) and (aLoad <= 10) then
    Lload := df10
  else if (aLoad > 10) and (aLoad <= 15) then
    Lload := df15
  else if (aLoad > 15) and (aLoad <= 20) then
    Lload := df20
  else if (aLoad > 20) and (aLoad <= 25) then
    Lload := df25
  else if (aLoad > 25) and (aLoad <= 30) then
    Lload := df30
  else if (aLoad > 30) and (aLoad <= 35) then
    Lload := df35
  else if (aLoad > 35) and (aLoad <= 40) then
    Lload := df40
  else if (aLoad > 40) and (aLoad <= 45) then
    Lload := df45
  else if (aLoad > 45) and (aLoad <= 50) then
    Lload := df50
  else if (aLoad > 50) and (aLoad <= 55) then
    Lload := df55
  else
    Lload := dfnull;

  if Lload <> dfnull then
  begin
    Result := R_GasRatio[ord(Lload)].Duration;
  end;
end;

procedure TForm3.initvar;
var
  LStr: string;
  LFileName: string;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  LFileName := '8H35DF.param';
  TFrameIPCMonitorAll1.SetModbusMapFileName(LFileName, psECS_woodward);
  LStr := TFrameIPCMonitorAll1.CreateIPCMonitor_ECS_Woodward;
  Statusbar1.SimplePanel := True;
  Statusbar1.SimpleText := LStr + ' Created.';

  iPlot1.YAxis[0].Min := 0;
  iPlot1.YAxis[0].Span := 60;
  iPlot1.YAxis[0].LabelsPrecision := 2;
  //iplot1.Channel[1].Color := clLime;
  //iplot1.Channel[1].VisibleInLegend := True;
  FPrevOperationMode := 0;

  TFrameIPCMonitorAll1.FWatchValue2Screen_AnalogEvent := WatchValue2Screen_Analog;
end;

function TForm3.Set_Channel(aChannel,aOpMode:integer) : Boolean;
begin
  Result := False;

  with iPlot1 do
  begin
    BeginUpdate;
    try
      case aOpMode of
        0 : Channel[aChannel].Color := clBlue;
        1 : Channel[aChannel].Color := clMaroon;
        2 : Channel[aChannel].Color := clLime;
      end;
      Channel[aChannel].TraceLineWidth := 5;

      if AChannel > 2 then
        Channel[aChannel].VisibleInLegend := False;

      Channel[aChannel].FillEnabled := True;
      Result := True;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TForm3.Timer1Timer(Sender: TObject);
var
  lx,ly,ldratio, lgratio, k : Double;
begin
  lx := Now;
  ly := StrToFloatDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[217].Value,0);//LOAD_LOAD_KW_M4_PV

  //ldratio := StrToFloatDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[301].Value,0);
  //lgratio := StrToFloatDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[302].Value,0);

  ChangeMode;

  //DieselLoad.Position := ldratio;
  //GasLoad.Position := lgratio;

  with iPlot1 do
  begin
    BeginUpdate;
    try
      Channel[FCurrentChannel].AddXY(lx,ly);
      Channel[FCurrentChannel].XAxis.ZoomToFitFast;
    finally
      EndUpdate;
    end;
  end;

  lgratio :=  StrToFloatDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[277].Value,0);
  k := GetLoad(ly);

  ldratio := StrToFloatDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[302].Value,0);
  if ldratio >= 99 then
  begin
    GasLoad.Position := 100;
    DieselLoad.Position := 0;
  end
  else
  begin
    GasLoad.Position := (lgratio/k)*100;
    DieselLoad.Position := 100 - GasLoad.Position;
  end;

  DLoadPanel.Caption := IntToStr(Round(DieselLoad.Position)) + '%';
  GLoadPanel.Caption := IntToStr(Round(GasLoad.Position)) + '%';
  //DieselLoad.Position := StrToFloatDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[301].Value,0);
  //GasLoad.Position := StrToFloatDef(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[302].Value,0);

  LoadPanel.Caption := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[217].Value + '%';
  EngRpmPanel.Caption := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[316].Value;
  TCRpmPanel.Caption := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[319].Value;

  //AdvSmoothGauge1.Value := StrToFloat(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[316].Value);//RPM
  //AdvSmoothGauge2.Value := StrToFloat(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[319].Value);//TC RPM

{
  panel4.Caption := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[112].Value;
  panel5.Caption := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[113].Value;
  panel6.Caption := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[114].Value;
  panel7.Caption := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[115].Value;
  panel8.Caption := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[116].Value;
  panel9.Caption := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[117].Value;
  panel10.Caption := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[118].Value;
  panel11.Caption := TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[119].Value;

  iLedBar1.Position := StrToFloat(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[112].Value);
  iLedBar2.Position := StrToFloat(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[113].Value);
  iLedBar3.Position := StrToFloat(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[114].Value);
  iLedBar4.Position := StrToFloat(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[115].Value);
  iLedBar5.Position := StrToFloat(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[116].Value);
  iLedBar6.Position := StrToFloat(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[117].Value);
  iLedBar7.Position := StrToFloat(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[118].Value);
  iLedBar8.Position := StrToFloat(TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[119].Value);
}
  Statusbar1.SimpleText := '';
end;

procedure TForm3.WatchValue2Screen_Analog(Name, AValue: string;
  AEPIndex: integer);
begin
  //if TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Tagname = 'LOAD_LOAD_KW_M4_PV' then
  //  ;//TFrameIPCMonitorAll1.FEngineParameter.EngineParameterCollect.Items[AEPIndex].Value;
end;

end.
