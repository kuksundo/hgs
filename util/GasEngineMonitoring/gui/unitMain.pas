unit unitMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, iComponent, ExtCtrls, math, iPlotComponent, iXYPlot, iPlotAxis,
  iVCLComponent, iCustomComponent, iPositionComponent, iScaleComponent,
  iGaugeComponent,iXYPlotChannel, iAngularGauge, iPanel, iLabel, iAnalogDisplay,
  iProgressComponent, iLedBar, iniFiles, DeCAL, ConfigConst, EngMonitorConfig, SBPro, Menus,
  JvComponentBase, JvgXMLSerializer, Options, ConfigForm,
  SuperStrList, CUtils, iEditCustom, iEdit, ComCtrls, JvgPage, JclUnitConv,
  IPCThrd_GasCalc, IPCThrdClient_Gas, ModbusComStruct, UnitFrameIPCMonitorAll,
  EngineBaseClass, UnitIPCClientAll;

type
  TEventData_MEXA7000_2 = packed record
    CO2: Double;//String 변수는 공유메모리에 사용 불가함
    CO_L: Double;
    O2: Double;
    NOx: Double;
    THC: Double;
    CH4: Double;
    non_CH4: Double;
    CollectedValue: Double;
 end;

  TForm1 = class(TForm)
    Timer1: TTimer;
    Panel2: TPanel;
    Panel4: TPanel;
    Panel46: TPanel;
    StatusBar1: TStatusBarPro;
    PopupMenu1: TPopupMenu;
    Config1: TMenuItem;
    JvgXMLSerializer: TJvgXMLSerializer;
    EmissionConfig1: TMenuItem;
    Timer2: TTimer;
    N1: TMenuItem;
    ViewEngDataCB: TCheckBox;
    SaveAFRtoCSV1: TMenuItem;
    JvgPageControl1: TJvgPageControl;
    TabSheet1: TTabSheet;
    iXYPlot1: TiXYPlot;
    TabSheet2: TTabSheet;
    iXYPlot2: TiXYPlot;
    TabSheet3: TTabSheet;
    iXYPlot3: TiXYPlot;
    Button2: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    Setting1: TMenuItem;
    ModbusConfig1: TMenuItem;
    EmissionConfig2: TMenuItem;
    N2: TMenuItem;
    SaveGraphtoCSV1: TMenuItem;
    N3: TMenuItem;
    Graph1: TMenuItem;
    ClearKnockingData1: TMenuItem;
    ClearMisfiringData1: TMenuItem;
    N4: TMenuItem;
    SelectKnocking1: TMenuItem;
    SelectMisfiring1: TMenuItem;
    About1: TMenuItem;
    About2: TMenuItem;
    N5: TMenuItem;
    Update1: TMenuItem;
    ExecuteCommunication1: TMenuItem;
    N6: TMenuItem;
    Button3: TButton;
    GenOutput: TiAnalogDisplay;
    iLabel14: TiLabel;
    A0106: TiAnalogDisplay;
    iLabel15: TiLabel;
    iLabel1: TiLabel;
    EfficiencyEdit: TiAnalogDisplay;
    iLabel7: TiLabel;
    EngLoadAnalog: TiAnalogDisplay;
    iLabel12: TiLabel;
    A00DD: TiAnalogDisplay;
    iLabel13: TiLabel;
    FuelConsum: TiAnalogDisplay;
    EngineOutput: TiAnalogDisplay;
    iLabel2: TiLabel;
    iLabel3: TiLabel;
    BMEP: TiAnalogDisplay;
    iLabel4: TiLabel;
    LamdaAnalog: TiAnalogDisplay;
    AirFuelRatioAnalog: TiAnalogDisplay;
    Noxato2: TiAnalogDisplay;
    iLabel6: TiLabel;
    iLabel8: TiLabel;
    iLabel9: TiLabel;
    iLabel10: TiLabel;
    C_AirFlowAnalog: TiAnalogDisplay;
    iLabel11: TiLabel;
    iLabel16: TiLabel;
    iLabel17: TiLabel;
    iLabel18: TiLabel;
    iLabel5: TiLabel;
    iLabel19: TiLabel;
    iLabel20: TiLabel;
    iLabel21: TiLabel;
    iLabel22: TiLabel;
    MT210Analog: TiAnalogDisplay;
    M_AirFlowAnalog: TiAnalogDisplay;
    M_AirFuelRatioAnalog: TiAnalogDisplay;
    M_LamdaAnalog: TiAnalogDisplay;
    IPCMonitorAll1: TFrameIPCMonitor;
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure AddChannelButtonClick(Sender: TObject);
    procedure RemoveAllChannelsClick(Sender: TObject);
    procedure EnableRingBufferClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure EmissionConfig1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure ViewEngDataCBClick(Sender: TObject);
    procedure SaveAFRtoCSV1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure ModbusConfig1Click(Sender: TObject);
    procedure EmissionConfig2Click(Sender: TObject);
    procedure SaveGraphtoCSV1Click(Sender: TObject);
    procedure iXYPlot1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure iXYPlot1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure iXYPlot1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ClearKnockingData1Click(Sender: TObject);
    procedure SelectKnocking1Click(Sender: TObject);
    procedure SelectMisfiring1Click(Sender: TObject);
    procedure ClearMisfiringData1Click(Sender: TObject);
    procedure Update1Click(Sender: TObject);
    procedure About2Click(Sender: TObject);
    procedure ExecuteCommunication1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FEngineMonitoringData: TEngineMonitoringData;

    FAngle : Double;

    FMonitorStart: Boolean; //타이머 동작 완료하면 True
    FFilePath: string;      //파일을 저장할 경로
    FMapFileName: string;   //Modbus Map 파일 이름
    FGenOutputType: integer;//Gen. Output 선택
    FOptionFileName: string;//Option 저장하는  XML file name

    FKnockingMap: DMultiMap;//Knocking Point List(BMEP + AFR)
    FMisFiringMap: DMultiMap;//Misfiring Point List(BMEP + ...)
    FEfficiencyMap: DMultiMap;//Efficiency Point List(Efficiency + AFR)
    FNOx13O2Map: DMultiMap;//NOx at 13% O2 Point List(NOx + AFR)
    FWasteGateMap: DMultiMap;//WasteGate Point List(WasteGate Position + AFR)
    FBoostPressMap: DMultiMap;//BoostPressPoint List(BoostPress Position + AFR)
    FExhTempMap: DMultiMap;//Exhaust Temp Point List(/Exhaust Temp Average + AFR)

    FIsKnocking: Boolean;//True = Knocking point is now by real time data
    FStartGraph: Boolean;//True = Display the data to graph
    FIsKnockDataFromMouse: boolean;//True = 마우스 좌표로 knocking point 입력
    FIsMisFireDataFromMouse: boolean;//True = 마우스 좌표로 MifFiring point 입력

    procedure DisplayMessage(Msg: string);
    procedure Value2Screen_ECS(BlockNo: integer);
    procedure Value2Screen_Analog_ECS(AName: string; AValue: Integer;
                          AMaxVal: real; AModbusMode: integer);
    procedure Value2Screen_Digital_ECS(Name: string; AValue: Integer;
                                    AMaxVal: real; AContact: integer);
    procedure Value2Screen_WT1600;

    procedure LoadConfigDataini2Form(ConfigForm:TEngMonitorConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:TEngMonitorConfigF);
    procedure LoadConfigFile2Var(AFileName: string);
    procedure SetConfigData;
    procedure SetConfig;
    procedure SaveGraph2CSV;

    procedure DisplayGraph(APlotChannel: TiXYPlotChannel; AMap: DMultiMap);
    procedure SaveDMultiMap2File(AFileName: string; AMap: DMultiMap);
    procedure ReplaceOrAddMap(AMap: DMultiMap; AKey, AValue: double; AIsXAxis:Boolean);
  public
//    FIPCClient: TIPCClient_GasCalc;//공유 메모리 및 이벤트 객체
    FIPCClientAll: TIPCClientAll;

    procedure Config_Calc;// Config Form에서 필요한 계산 항목들 계산하기

    procedure DisplayGraphAndPulseMonitor;
  end;

var
  Form1  : TForm1;

implementation

uses CommonUtil, uHTTPs, constUpdate, about, JvgXMLSerializer_Encrypt;

{$R *.DFM}

//******************************************************************************
procedure TForm1.FormActivate(Sender: TObject);
begin
  //iXYPlot1.RemoveAllChannels;
  //AddChannelButtonClick(Sender);
  //EngDataF.Show;
  //Self.Caption := Self.Caption + IntToStr(Self.Handle);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  LHandle : THandle;
begin
  if FEngineMonitoringData.CloseTCPClient then
  begin
    LHandle := FindWindow(nil, 'AVAT_ECS ==> ModBusCom_Avat');
    if LHandle > 0 then
      PostMessage(LHandle, WM_CLOSE, 0, 0);

    LHandle := FindWindow(nil, 'WT1600 ==> 192.168.0.48');
    if LHandle > 0 then
      PostMessage(LHandle, WM_CLOSE, 0, 0);

    LHandle := FindWindow(nil, '10.14.23.63 ==> Horiba_MEXA_7000');
    if LHandle > 0 then
      PostMessage(LHandle, WM_CLOSE, 0, 0);

    LHandle := FindWindow(nil, '10.14.23.63 ==> MT210');
    if LHandle > 0 then
      PostMessage(LHandle, WM_CLOSE, 0, 0);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FEngineMonitoringData := TEngineMonitoringData.Create(Self);
  FIPCClientAll := TIPCClientAll.Create;

//  FIPCClient := TIPCClient_GasCalc.Create(0, GAS_TOTAL_SHARE_NAME, True);
//  FIPCClient.FreeOnTerminate := True;
  //FIPCClient.Resume;

  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨

  FKnockingMap := DMultiMap.create;
  FMisFiringMap := DMultiMap.create;
  FEfficiencyMap := DMultiMap.create;
  FNOx13O2Map := DMultiMap.create;
  FWasteGateMap := DMultiMap.create;
  FBoostPressMap := DMultiMap.create;
  FExhTempMap := DMultiMap.create;

  LoadConfigDataini2Var;
  FOptionFileName := ChangeFileExt(Application.ExeName, '.xml');
  LoadConfigFile2Var(FOptionFileName);

  FIPCClientAll.FEngineParameter.LoadFromJSONFile(FEngineMonitoringData.FileName);
  FIPCClientAll.CreateIPCClientAll;

  FStartGraph := False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ObjFree(FMisFiringMap);
  FMisFiringMap.Free;
  ObjFree(FKnockingMap);
  FKnockingMap.Free;
  ObjFree(FEfficiencyMap);
  FEfficiencyMap.Free;
  ObjFree(FNOx13O2Map);
  FNOx13O2Map.Free;
  ObjFree(FWasteGateMap);
  FWasteGateMap.Free;
  ObjFree(FBoostPressMap);
  FBoostPressMap.Free;
  ObjFree(FExhTempMap);
  FExhTempMap.Free;

  FEngineMonitoringData.Free;
  FIPCClientAll.Free;
end;

procedure TForm1.iXYPlot1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin                                         
  if not FEngineMonitoringData.RealtimeKnockData and SelectKnocking1.Checked then
  begin
    FIsKnockDataFromMouse := True;
    FKnockingMap.clear;
  end;

  if not FEngineMonitoringData.RealtimeMisfireData and SelectMisfiring1.Checked then
  begin
    FIsMisFireDataFromMouse := True;
    FMisFiringMap.clear;
  end;
end;

procedure TForm1.iXYPlot1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  LX, LY: double;
begin
  if not FEngineMonitoringData.RealtimeKnockData and FIsKnockDataFromMouse then
  begin
    LX := iXYPlot1.Channel[0].XAxis.PixelsToPosition(X);
    LY := iXYPlot1.Channel[0].YAxis.PixelsToPosition(Y);
    ReplaceOrAddMap(FKnockingMap, LX, LY, True);
    DisplayGraph(iXYPlot1.Channel[0], FKnockingMap);
    //iXYPlot1.Channel[0].AddXY(LX,LY);
  end;

  if not FEngineMonitoringData.RealtimeMisfireData and FIsMisFireDataFromMouse then
  begin
    LX := iXYPlot1.Channel[2].XAxis.PixelsToPosition(X);
    LY := iXYPlot1.Channel[2].YAxis.PixelsToPosition(Y);
    ReplaceOrAddMap(FMisFiringMap, LX, LY, True);
    DisplayGraph(iXYPlot1.Channel[2], FMisFiringMap);
    //iXYPlot1.Channel[2].AddXY(LX,LY);
  end;
end;

procedure TForm1.iXYPlot1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not FEngineMonitoringData.RealtimeKnockData then
  begin
    FIsKnockDataFromMouse := False;
    SelectKnocking1.Checked := False;
  end;

  if not FEngineMonitoringData.RealtimeMisfireData then
  begin
    FIsMisFireDataFromMouse := False;
    SelectMisfiring1.Checked := False;
  end;
end;

procedure TForm1.LoadConfigDataini2Form(ConfigForm: TEngMonitorConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME2);
  try
    with iniFile, ConfigForm do
    begin
      FilenameEdit.Filename := ReadString(ENGMONITOR_SECTION, 'Modbus Map File Name1', '.\ss197_Modbus_Map.txt');
      GenOutputRG.ItemIndex := ReadInteger(ENGMONITOR_SECTION, 'Generator Output Type', 0);
       end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TForm1.LoadConfigDataini2Var;
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME2);
  try
    with iniFile do
    begin
      FMapFileName := ReadString(ENGMONITOR_SECTION, 'Modbus Map File Name1', '');
      FGenOutputType := ReadInteger(ENGMONITOR_SECTION, 'Generator Output Type', 0);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TForm1.LoadConfigFile2Var(AFileName: string);
var
  Fs: TFileStream;
begin
  try
    //file이 없으면 생성하고
    if not FileExists(AFileName) then
    begin
      //FEngineMonitoringData.FileName := AFileName;
      //Fs := TFileStream.Create(AFileName, fmCreate);
      FEngineMonitoringData.SaveToFile(AFileName);
      //JvgXMLSerializer.Serialize(FEngineMonitoringData, Fs);
    end
    else
    begin
      FEngineMonitoringData.Option.Clear;
      //Fs := TFileStream.Create(AFileName, fmOpenRead);
      FEngineMonitoringData.LoadFromFile(AFileName);
      //JvgXMLSerializer.DeSerialize(FEngineMonitoringData, Fs);
    end;
  finally
    //Fs.Free;
  end;

  Config_Calc;
end;

procedure TForm1.ModbusConfig1Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TForm1.Update1Click(Sender: TObject);
begin
  //if pCheckINIFile(SERVER_PATH, INI_FILE, UPDATE_FILE_NAME) then
  //begin
    UpdateThroughHttp(Self);
  //end
  //else
  //  ShowMessage('지금 실행중인 파일이 최신 버젼입니다.!');
end;

//procedure TForm1.UpdateTrace_MEXA7000(var Msg: TEventData_MEXA7000);
//begin
  //Nox.Value := FMEXA7000Data.NOx;
//  Noxato2.Value := FMEXA7000Data.CollectedValue;
//end;

//procedure TForm1.UpdateTrace_MT210(var Msg: TEventData_MT210);
//var
//  Ld:double;
//begin
//  try
//    MT210Analog.Value := FMT210Data.FData;
//
//    //Ld := Sqrt( (abs(FMT210Data.FData)*FEngineMonitoringData.BP*7.500617*1000000*287)/((FEngineMonitoringData.IntakeAirTemp+273) * 750));
//    Ld := Sqrt( (abs(FMT210Data.FData*FEngineMonitoringData.TCCount)*FEngineMonitoringData.BP*7.500617*100000/750/287)/(FEngineMonitoringData.IntakeAirTemp+273));
//                      //mmH2O            //kPA -> mmHg
//    FEngineMonitoringData.AF_Measured := K_AirFlow * Ld * 3600; //(kg/h)
//
//    M_AirFlowAnalog.Value := FEngineMonitoringData.AF_Measured;
//    FAFRatio_Measured := FEngineMonitoringData.AF_Measured / FEngineMonitoringData.FC;
//    M_AirFuelRatioAnalog.Value := FAFRatio_Measured;
//    FLamda_Measured := FAFRatio_Measured/FEngineMonitoringData.StoichiometricRatio;
//    M_LamdaAnalog.Value := FLamda_Measured;
//
//    if FMEXA7000Data.NOx = 0.0 then
//      FEngineMonitoringData.AF1 := 0;
//
//    C_AirFlowAnalog.Value := FEngineMonitoringData.AF1;
//  except on Exception do
//  end;
//end;

//procedure TForm1.UpdateTrace_WT1600(var Msg: TEventData_WT1600);
//var
//  LMsg: TMessage;
//begin
//  Value2Screen_WT1600;
//end;

procedure TForm1.Value2Screen_ECS(BlockNo: integer);
begin
end;

procedure TForm1.Value2Screen_WT1600;
var
  LDouble: double;
begin
  //LDouble := StrToFloatDef(FWT1600Data.PSIGMA,0.0);
  //LDouble := LDouble + StrToFloatDef(FWT1600Data.SSIGMA,0.0);
  //LDouble := LDouble + StrToFloatDef(FWT1600Data.QSIGMA,0.0);
  //EngineOutput.Value := LDouble/3;
  case FGenOutputType of
    0: GenOutput.Value := StrToFloatDef(FWT1600Data.PSIGMA,0.0);///1000;//∑P(Active Power)
    1: GenOutput.Value := StrToFloatDef(FWT1600Data.F1,0.0);///1000;//F1(P∑A+P∑B)
  end;

  FEngineMonitoringData.GeneratorOutput := GenOutput.Value;

  EngineLoad_Calc;
  BMEP_Calc;
  //BMEP_pnl.Caption := format('%.1f', [FBMEP]);
  //BMEP2_pnl.Caption := format('%.1f', [FBMEP2]);
  Efficiency_Calc;
end;

procedure TForm1.Value2Screen_Analog_ECS(AName: string; AValue: Integer;
  AMaxVal: real; AModbusMode: integer);
var
  LisPress: boolean;
  Le, Le2: Single;
begin
  LisPress := False;

  if AModbusMode = 3 then
    Le := AValue
  else
    Le := (AValue * AMaxVal);

  if (AName = '0106') or (AName = '00DD') then //Engine RPM
  begin
    with TiAnalogDisplay(FindComponent('A'+AName)) do
    begin
      Value := Le;

      if AName = '00DD' then //Gas Flow
      begin
        Value := AValue;
        FEngineMonitoringData.GasFlow := AValue;
        FEngineMonitoringData.FC := AValue * FEngineMonitoringData.Density;
        //FEngineMonitoringData.FC := Value * (FEngineMonitoringData.GasPress + 1) * 1000 / 1013.25 *
        //                273 / (273 + FEngineMonitoringData.GasTemp) * FEngineMonitoringData.Density;//Fuel Consumption(kg/h)
        FuelConsum.Value := FEngineMonitoringData.FC;
      end;
    end;
  end
  else
  begin
    if (AName = '0109') then //TC RPM
      with TPanel(FindComponent('A'+AName)) do
        Caption := format('%.f', [Le * 60])
    else
    begin
      if (AName = '0132') then //Scavange Air Temp
        FEngineMonitoringData.SAT := Le
      else if (AName = '00F9') then
      begin
        FEngineMonitoringData.SAP := Le;
        LisPress := True;
      end
      else if (AName = '00F3') then
      begin
        FEngineMonitoringData.GasPress := Le;
        LisPress := True;
      end
      else if (AName = '0131') then
        FEngineMonitoringData.GasTemp := Le
      else if (AName = '00F4') or (AName = '00F5') or (AName = '00EF') or
              (AName = '00F0') then
        LisPress := True
      else if (AName = '00DE') then
        FThrottlePosition := Le//Throttle Valve Position
      else if (AName = '00E6') then
        FWasteGatePosition := Le;//Waste Gate Position
      //else if (AName = '00F9') then
      //  FBoostPress := AValue * AMaxVal;//Boost Pressure

      if (AName > '0145') and (AName < '014E') then
      begin
        if Le > 0 then
          FIsKnocking := True;
      end;
      
      with TPanel(FindComponent('A'+AName)) do
      begin
        if LisPress then
          Caption := format('%.2f', [Le])
        else
          Caption := format('%.f', [Le]);
      end;
    end;
  end;
end;

procedure TForm1.Value2Screen_Digital_ECS(Name: string; AValue: Integer;
  AMaxVal: real; AContact: integer);
begin
;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  FStartGraph := not FStartGraph;

  if FStartGraph then
    Button2.Caption := 'Stop Graph'
  else
    Button2.Caption := 'Start Graph';
end;

procedure TForm1.ViewEngDataCBClick(Sender: TObject);
begin
  if ViewEngDataCB.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

procedure TForm1.ClearKnockingData1Click(Sender: TObject);
begin
  if MessageDlg('Are you sure to clear the knocking data?', mtConfirmation,
                                                [mbYes, mbNo],0) = mrYes then
  begin
    FKnockingMap.clear;
    iXYPlot1.Channel[0].Clear;
  end;
end;

procedure TForm1.ClearMisfiringData1Click(Sender: TObject);
begin
  if MessageDlg('Are you sure to clear the knocking data?', mtConfirmation,
                                                [mbYes, mbNo],0) = mrYes then
  begin
    FMisFiringMap.clear;
    iXYPlot1.Channel[2].Clear;
  end;
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Config1Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TForm1.Config_Calc;
begin
  FuelComposition_Calc;
end;

procedure TForm1.DisplayGraph(APlotChannel: TiXYPlotChannel; AMap: DMultiMap);
var
  Li: integer;
  it: DIterator;
  LDoublePoint: TDoublePoint;
begin
  APlotChannel.Clear;
  it := AMap.startKey;
  SetToValue(it);

  while not atEnd(it) do
  begin
    LDoublePoint := GetObject(it) as TDoublePoint;
    APlotChannel.AddXY(LDoublePoint.X, LDoublePoint.Y);
    Advance(it);
  end;//while
end;

procedure TForm1.DisplayGraphAndPulseMonitor;
var
  XData : Double;
  YData : Double;
begin
  if FEngineMonitoringData.UseMT210Data then
    FEngineMonitoringData.AFRatio := FEngineMonitoringData.AFRatio_Measured
  else
    FEngineMonitoringData.AFRatio := FEngineMonitoringData.AFRatio_Calculated;

  XData := FEngineMonitoringData.AFRatio;
  YData := FEngineMonitoringData.BMEP;

  //Plot Data Point
  if FStartGraph then
  begin
    if FIsKnocking then
    begin
      ReplaceOrAddMap(FKnockingMap, FEngineMonitoringData.AFRatio, FEngineMonitoringData.BMEP, True);
      DisplayGraph(iXYPlot1.Channel[0], FKnockingMap);
      DisplayGraph(iXYPlot2.Channel[2], FKnockingMap);
      FIsKnocking := False;
    end;

    ReplaceOrAddMap(FEfficiencyMap,FEngineMonitoringData.AFRatio,FEngineMonitoringData.Efficiency, True);
    DisplayGraph(iXYPlot2.Channel[0], FEfficiencyMap);

    ReplaceOrAddMap(FNOx13O2Map,FEngineMonitoringData.AFRatio,FMEXA7000Data.CollectedValue, True);
    DisplayGraph(iXYPlot2.Channel[1], FNOx13O2Map);

    ReplaceOrAddMap(FWasteGateMap,FEngineMonitoringData.EngineLoad,FEngineMonitoringData.WasteGatePosition, True);
    DisplayGraph(iXYPlot3.Channel[0], FWasteGateMap);

    ReplaceOrAddMap(FBoostPressMap,FEngineMonitoringData.EngineLoad,FEngineMonitoringData.SAP, True);
    DisplayGraph(iXYPlot3.Channel[1], FBoostPressMap);

    ReplaceOrAddMap(FExhTempMap,FEngineMonitoringData.EngineLoad, FEngineMonitoringData.ExhTempAvg, True);
    DisplayGraph(iXYPlot3.Channel[2], FExhTempMap);

    iXYPlot1.Channel[1].AddXY(XData, YData);
  end;

  with FEngineMonitoringData do
  begin
    FGasTotalData.FSVP := SVP;
    FGasTotalData.FIAH2 := IAH2;
    FGasTotalData.FUFC := UFC;
    FGasTotalData.FNhtCF := NhtCF;
    FGasTotalData.FDWCFE := DWCFE;
    FGasTotalData.FEGF := EGF;
    FGasTotalData.FNOxAtO213 := FMEXA7000Data.CollectedValue;
    FGasTotalData.FNOx := FMEXA7000Data.NOx;
    FGasTotalData.FAF1 := AF1;
    FGasTotalData.FAF2 := AF2;
    FGasTotalData.FAF3 := AF3;
    FGasTotalData.FAF_Measured := FEngineMonitoringData.AF_Measured;
    FGasTotalData.FMT210 := FMT210Data.FData;
    FGasTotalData.FFC := FEngineMonitoringData.FC;
    FGasTotalData.FEngineOutput:= FEngineOutput; //Calculated(kW/h)
    FGasTotalData.FGeneratorOutput := FEngineMonitoringData.GeneratorOutput;
    FGasTotalData.FEngineLoad:= FEngineLoad; //Current Engine Load(%)
    FGasTotalData.FGenEfficiency:= FGenEfficiency; //Generator Efficiency at current Load(%/100)
    FGasTotalData.FBHP:= FBHP; //Brake Horse Power
    FGasTotalData.FBMEP:= FBMEP;//Brake Mean Effective Press.
    FGasTotalData.FLamda_Calculated:= FLamda_Calculated; //Lamda Ratio
    FGasTotalData.FLamda_Measured:= FLamda_Measured; //Lamda Ratio
    FGasTotalData.FLamda_Brettschneider:= FLamda_Brettschneider; //Lamda(Brettschneider equation) - Normalized Air/Fuel balance
    FGasTotalData.FAFRatio_Calculated := FAFRatio_Calculated;
    FGasTotalData.FAFRatio_Measured := FAFRatio_Measured;
    FGasTotalData.FExhTempAvg:= FExhTempAvg;
    FGasTotalData.FWasteGatePosition:= FWasteGatePosition;
    FGasTotalData.FThrottlePosition:= FThrottlePosition;
    //FGasTotalData.FBoostPress :=
    FGasTotalData.FDensity:= FEngineMonitoringData.Density;
    FGasTotalData.FLCV:= FEngineMonitoringData.LCV;
  end;//with

  FIPCClient.PulseMonitor(FGasTotalData);
end;

procedure TForm1.DisplayMessage(Msg: string);
begin
  StatusBar1.SimplePanel := True;
  StatusBar1.SimpleText := Msg;
end;

procedure TForm1.EmissionConfig1Click(Sender: TObject);
begin
  SetConfig;
end;

procedure TForm1.EmissionConfig2Click(Sender: TObject);
begin
  SetConfig;
end;

//******************************************************************************
procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  try
    if FMonitorStart then
    begin
      DisplayMessage('');
      AirFlow_Calc;
      DisplayGraphAndPulseMonitor;
    end
    else
    begin

    end;
  finally
    FMonitorStart := True;
    Timer1.Enabled := True;
  end;//try
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  x     : Integer;
  XData : Double;
  YData : Double;
begin
  //Loop through channels
  //for x := 0 to iXYPlot1.ChannelCount - 1 do
  //  begin
      //Generate Random Data
      XData := Sin(FAngle - 1)*(20 + 5 + Random(500)/100) + 50;
      YData := Cos(FAngle - 1)*(20 + 5 + Random(500)/100) + 50;

      //Plot Data Point
      iXYPlot1.Channel[1].AddXY(XData, YData);
  //  end;

  //Increase Angle counter for random data generation
  FAngle := FAngle + 0.1;

end;

//******************************************************************************
procedure TForm1.About2Click(Sender: TObject);
begin
  with TAboutF.Create(nil) do
  begin
    ShowModal;
    Free;
  end;
end;

procedure TForm1.AddChannelButtonClick(Sender: TObject);
var
  x : Integer;
begin
  iXYPlot1.AddChannel;

  //Reset Parameters for all channels
  //Loop through channels
  for x := 0 to iXYPlot1.ChannelCount - 1 do
    begin
      //Ring Buffer is a FIFO (First In First Out) type buffer.
      //After 50 data points, the first added data will start to drop out of
      //the buffer.  This is used when you want to limit the amount of memory
      //used by the buffer.

      //If you don't want to use a Ring Buffer, set this value to 0, and all
      //of the data you plot will remain in the buffer.
      //if EnableRingBuffer.Checked = True then
      //  iXYPlot1.Channel[x].RingBufferSize := 50
      //else
      //  iXYPlot1.Channel[x].RingBufferSize := 0;

      //Make the Trace Invisible.  If you want a line connected between the
      //data points, set this value to true.
      iXYPlot1.Channel[x].TraceVisible   := False;

      //Make the Data Point Markers   Visible
      iXYPlot1.Channel[x].MarkersVisible := True;

      //Set Scroll style to automatically adjust X/Y Scale Min and Max
      iXYPlot1.XAxis[0].TrackingStyle := iptsScaleMinMax;
    end;
end;
//******************************************************************************
procedure TForm1.RemoveAllChannelsClick(Sender: TObject);
begin
  //Remove all of the channels in the chart
  iXYPlot1.RemoveAllChannels;
end;

procedure TForm1.ReplaceOrAddMap(AMap: DMultiMap; AKey, AValue: double; AIsXAxis:Boolean);
var
  it: DIterator;
  LDoublePoint : TDoublePoint;
begin
  it := AMap.locate([AKey]);
  LDoublePoint := GetObject(it) as TDoublePoint;
  if Assigned(LDoublePoint) then
  begin
    if AIsXAxis then  //Key Is X Axis
      LDoublePoint.Y := AValue
    else
      LDoublePoint.X := AValue
  end
  else
  begin
    LDoublePoint := TDoublePoint.Create;
    if AIsXAxis then  //Key Is X Axis
    begin
      LDoublePoint.X := AKey;
      LDoublePoint.Y := AValue;
    end
    else
    begin
      LDoublePoint.Y := AKey;
      LDoublePoint.X := AValue;
    end;
    AMap.putPair([AKey, LDoublePoint]);
  end;

end;

procedure TForm1.SaveAFRtoCSV1Click(Sender: TObject);
begin
  SaveGraph2CSV;
end;

procedure TForm1.SaveConfigDataForm2ini(ConfigForm: TEngMonitorConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME2);
  try
    with iniFile, ConfigForm do
    begin
      WriteString(ENGMONITOR_SECTION, 'Modbus Map File Name1', FilenameEdit.Filename);
      WriteInteger(ENGMONITOR_SECTION, 'Generator Output Type', GenOutputRG.ItemIndex);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TForm1.SaveDMultiMap2File(AFileName: string; AMap: DMultiMap);
var
  it: DIterator;
  LDoublePoint: TDoublePoint;
  LStr: string;
begin
  it := AMap.startKey;
  SetToValue(it);

  while not atEnd(it) do
  begin
    LDoublePoint := GetObject(it) as TDoublePoint;
    LStr := format('%f'+#9+'%f',[LDoublePoint.X,LDoublePoint.Y]);
    SaveData2DateFile(AFileName,'dat', LStr, soFromEnd);
    Advance(it);
  end;//while
end;

procedure TForm1.SaveGraph2CSV;
var
  Lstr: string;
begin
  SaveDMultiMap2File('Knocking_CSVFile', FKnockingMap);
  SaveDMultiMap2File('MisFiring_CSVFile', FMisFiringMap);
  SaveDMultiMap2File('Efficiency_CSVFile', FEfficiencyMap);
  SaveDMultiMap2File('NOx13O2_CSVFile', FNOx13O2Map);
  SaveDMultiMap2File('WasteGate_CSVFile', FWasteGateMap);
  SaveDMultiMap2File('BoostPress_CSVFile', FBoostPressMap);

  Lstr := 'Knocking Data is saved to ''.\Knocking_CSVFile\yyyymmdd.dat'''+#13#10;
  LStr := LStr + 'MisFiring Data is saved to ''.\MisFiring_CSVFile\yyyymmdd.dat'''+#13#10;
  LStr := LStr + 'Efficiency Data is saved to ''.\Efficiency_CSVFile\yyyymmdd.dat'''+#13#10;
  LStr := LStr + 'NOx at 13% O2 Data is saved to ''.\NOx13O2_CSVFile\yyyymmdd.dat'''+#13#10;
  LStr := LStr + 'WasteGate Data is saved to ''.\WasteGate_CSVFile\yyyymmdd.dat'''+#13#10;
  LStr := LStr + 'BoostPress Data is saved to ''.\BoostPress_CSVFile\오yyyymmdd.dat''';

  ShowMessage(Lstr);
end;

procedure TForm1.SaveGraphtoCSV1Click(Sender: TObject);
begin
  SaveGraph2CSV;
end;

procedure TForm1.SelectKnocking1Click(Sender: TObject);
begin
  SelectKnocking1.Checked := not SelectKnocking1.Checked;
  SelectMisfiring1.Checked := False;
end;

procedure TForm1.SelectMisfiring1Click(Sender: TObject);
begin
  SelectKnocking1.Checked := False;
  SelectMisfiring1.Checked := not SelectMisfiring1.Checked;
end;

procedure TForm1.SetConfig;
begin
  with TConfigFormF.Create(self) do
  begin
    FEngineMonitoringData := Self.FEngineMonitoringData;
    FConfigFileName := ChangeFileExt(Application.ExeName, '.xml');
    LoadConfigVar2Form;

    if ShowModal = mrOK then
    begin
      Config_Calc;
    end;
    Free;
  end;
end;

procedure TForm1.SetConfigData;
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
      end;
    finally
      Free;
    end;
  end;
end;

//******************************************************************************

procedure TForm1.EnableRingBufferClick(Sender: TObject);
var
  x : Integer;
begin
  //Loop through channels
  for x := 0 to iXYPlot1.ChannelCount - 1 do
    begin
      //Ring Buffer is a FIFO (First In First Out) type buffer.
      //After 50 data points, the first added data will start to drop out of
      //the buffer.  This is used when you want to limit the amount of memory
      //used by the buffer.

      //If you don't want to use a Ring Buffer, set this value to 0, and all
      //of the data you plot will remain in the buffer.
      //if EnableRingBuffer.Checked = True then
      //  iXYPlot1.Channel[x].RingBufferSize := 50
      //else
      //  iXYPlot1.Channel[x].RingBufferSize := 1;
    end;
end;

procedure TForm1.ExecuteCommunication1Click(Sender: TObject);
begin
  WinExec('MT210_TCPClient_D2007.exe', SW_HIDE);
  WinExec('MEXA7000_TCPClient_D2007.exe', SW_HIDE);
  WinExec('ECS_TCPClient_D2007.exe', SW_HIDE);
  WinExec('WT1600_TCPClient_D2007.exe 8', SW_HIDE);
end;

//******************************************************************************
end.
