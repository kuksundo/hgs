unit Watch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, iComponent, iVCLComponent, iCustomComponent,
  iPlotComponent, iPlot, StdCtrls, ExtCtrls,SyncObjs, iniFiles,
  DeCAL, IPCThrd_Kral, IPCThrdMonitor_Kral, EngMonitorConfig,//janSQL,
  ModbusComStruct,ModbusComConst, Menus, iProgressComponent, iLedBar,
  iPositionComponent, iScaleComponent, iGaugeComponent, iAngularGauge;

type
  TWatchF = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Panel2: TPanel;
    Label1: TLabel;
    Panel1: TPanel;
    Label3: TLabel;
    CurLabel: TLabel;
    Button1: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    MinLabel: TLabel;
    MaxLabel: TLabel;
    iPlot1: TiPlot;
    WatchLabel: TLabel;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    PopupMenu1: TPopupMenu;
    Config1: TMenuItem;
    Label10: TLabel;
    AvgEdit: TEdit;
    UpDown1: TUpDown;
    Button2: TButton;
    Label2: TLabel;
    AvgLabel: TLabel;
    iAngularGauge1: TiAngularGauge;
    iLedBar1: TiLedBar;
    PopupMenu2: TPopupMenu;
    Add1: TMenuItem;
    CurrentValue1: TMenuItem;
    Average1: TMenuItem;
    MinValue1: TMenuItem;
    MaxValue1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CurrentValue1Click(Sender: TObject);
    procedure Average1Click(Sender: TObject);
    procedure MinValue1Click(Sender: TObject);
    procedure MaxValue1Click(Sender: TObject);
  private
    FFilePath: string;      //파일을 저장할 경로
    FMapFileName: string;   //Modbus Map 파일 이름
    FHiMap: THiMap;         //Modbus Address 구조체 -> 동적으로 생성함
    FAddressMap: DMap;      //Modbus Map 데이타 저장 구초체
    FIPCMonitor: TIPCMonitor_Kral;//공유 메모리 및 이벤트 객체
    FModBusData: TWMModbusData;
    FCriticalSection: TCriticalSection;
    FMonitorStart: Boolean; //타이머 동작 완료하면 True
//    FjanDB : TjanSQL; //text 기반 SQL DB
    FMsgList: TStringList;  //Message를 저장하는 리스트

    procedure OnSignal(Sender: TIPCThread_Kral; Data: TEventData_Kral);
    procedure UpdateTraceData(var Msg: TWMModbusData); message WM_MODBUSDATA;
  public
    FLabelName: string; //모니터링하고자 하는 데이타의 이름을 저장함.
    FWatchName: string; //component 이름을 저장함.(FunctionCode+Address)
    FWatchValue: string; //모니터링 데이타
    
    FWatchValueMin: double; //Min data
    FWatchValueMax: double; //Max data
    FWatchValueSum: double; //Sum data
    FWatchValueAvg: double; //Average data
    FWatchValueAry: array of double;
    FCurrentAryIndex: integer; //처음에 배열에 저장시에 평균값 구하기 위함
    FAvgSize: integer; //평균을 위한 배열 size
    FFirstCalcAry: boolean; //처음 배열을 채워갈때는 True, 한번 다 채우면 False

    FIsCurrentValueGraph: boolean;//현재값을 그래프로 표현하면 True
    FCurrentValueChannel: integer;// FIsCurrentValueGraph=true 일 경우 채널 번호
    FCurrentValueX: double;

    FIsAverageValueGraph: boolean;//평균값을 그래프로 표현하면 True
    FAverageValueChannel: integer;// FIsCurrentValueGraph=true 일 경우 채널 번호
    FAverageValueX: double;

    FIsMinValueGraph: boolean;//최소값을 그래프로 표현하면 True
    FMinValueChannel: integer;// FIsCurrentValueGraph=true 일 경우 채널 번호
    FMinValueX: double;

    FIsMaxValueGraph: boolean;//최대값을 그래프로 표현하면 True
    FMaxValueChannel: integer;// FIsCurrentValueGraph=true 일 경우 채널 번호
    FMaxValueX: double;

    procedure InitVar;
    procedure DisplayMessage(Msg: string);
    procedure Value2Screen(BlockNo: integer);
    procedure Value2WatchScreen(BlockNo: integer);
    procedure WatchValue2Screen_Analog_FlowMeter(Name: string; AValue: Integer; AValue2: Integer);

    procedure ApplyAvgSize;
    
//    procedure ReadMapAddress(AddressMap: DMap; MapFileName: string);
    procedure LoadConfigDataini2Form(ConfigForm:TEngMonitorConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:TEngMonitorConfigF);
    procedure SetConfigData;
  end;

var
  WatchF: TWatchF;

implementation

uses CommonUtil;

{$R *.dfm}

procedure TWatchF.InitVar;
begin
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  FCriticalSection := TCriticalSection.Create;

  FAddressMap := DMap.Create;
  FIPCMonitor := TIPCMonitor_Kral.Create(0, MONITORNAME, True);
  FIPCMonitor.OnSignal := OnSignal;
  FIPCMonitor.Resume;

  FMsgList := TStringList.Create;
  FMonitorStart := False;

  LoadConfigDataini2Var;
  LoadConfigDataini2Form(nil);
  SetLength(FWatchValueAry, FAvgSize);
  //FillChar(FWatchValueAry,Sizeof(FWatchValueAry) * FAvgSize,0);
  FCurrentAryIndex := 0;
  FFirstCalcAry := True;

end;

procedure TWatchF.LoadConfigDataini2Form(ConfigForm: TEngMonitorConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile do
    begin
      if Assigned(ConfigForm) then
      begin
        with ConfigForm do
        begin
          FilenameEdit.Text := ReadString(ENGMONITOR_SECTION, 'Modbus Map File Name1', '.\ss197_Modbus_Map.txt');
        end;//with
      end
      else
      begin
        AvgEdit.Text := ReadString(ENGMONITOR_SECTION, 'Aveage Size', '1');
      end;
      //FilenameEdit2.Filename := ReadString(ENGMONITOR_SECTION, 'Modbus Map File Name2', '.\ss197_Modbus_Map.txt');
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TWatchF.LoadConfigDataini2Var;
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
      FAvgSize := ReadInteger(ENGMONITOR_SECTION, 'Aveage Size', 1);
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TWatchF.SaveConfigDataForm2ini(ConfigForm: TEngMonitorConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FFilePath);
  iniFile := nil;
  iniFile := TInifile.create(INIFILENAME);
  try
    with iniFile do
    begin
      if Assigned(ConfigForm) then
      begin
        with ConfigForm do
        begin
          WriteString(ENGMONITOR_SECTION, 'Modbus Map File Name1', FilenameEdit.Text);
        end;
      end
      else
      begin
        WriteString(ENGMONITOR_SECTION, 'Aveage Size', AvgEdit.Text);
      end;
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TWatchF.SetConfigData;
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
//        ReadMapAddress(FAddressMap,FMapFileName);
      end;
    finally
      Free;
    end;
  end;
end;

//procedure TWatchF.ReadMapAddress(AddressMap: DMap; MapFileName: string);
//var
//  sqltext: string;
//  sqlresult, reccnt, fldcnt: integer;
//  i: integer;
//  filename, fcode: string;
//begin
//  if fileexists(MapFileName) then //FFilePath
//  begin
//    Filename := ExtractFileName(MapFileName);
//    FileName := Copy(Filename,1, Pos('.',Filename) - 1);
//    FjanDB := TjanSQL.create;
//    sqltext := 'connect to ''' + FFilePath + '''';
//
//    sqlresult := FjanDB.SQLDirect(sqltext);
//    //Connect 성공
//    if sqlresult <> 0 then
//    begin
//      with FjanDB do
//      begin
//        sqltext := 'select * from ' + FileName + ' group by cnt';
//        sqlresult := SQLDirect(sqltext);
//        //Query 정상
//        if sqlresult <> 0 then
//        begin
//          //데이타 건수가 1개 이상 있으면
//          if sqlresult>0 then
//          begin
//            fldcnt := RecordSets[sqlresult].FieldCount;
//            //Field Count가 0 이면
//            if fldcnt = 0 then exit;
//
//            reccnt := RecordSets[sqlresult].RecordCount;
//            //Record Count가 0 이면
//            if reccnt = 0 then exit;
//
//            for i := 0 to reccnt - 1 do
//            begin
//              FHiMap := THiMap.Create;
//              with FHiMap, RecordSets[SqlResult].Records[i] do
//              begin
//                FName := Fields[0].Value;
//                FDescription := Fields[1].Value;
//                FSid := StrToInt(Fields[2].Value);
//                FAddress := Fields[3].Value;
//                FBlockNo := StrToInt(Fields[4].Value);
//                if Fields[5].Value = 'FALSE' then
//                begin
//                  FAlarm := False;
//                  fcode := '1';
//                end
//                else
//                begin
//                  FAlarm := True;
//                  fcode := '3';
//                end;
//
//                FMaxval := StrToFloat(Fields[6].Value);
//                FContact := StrToInt(Fields[7].Value);
//                FUnit := '';
//              end;//with
//
//              AddressMap.PutPair([fcode + FHiMap.FAddress,FHiMap]);
//            end;//for
//          end;
//
//        end
//        else
//          DisplayMessage(FjanDB.Error);
//      end;//with
//    end
//    else
//      Application.MessageBox('Connect 실패',
//          PChar('폴더 ' + FFilePath + ' 를 만든 후 다시 하시오'),MB_ICONSTOP+MB_OK);
//  end
//  else
//  begin
//    sqltext := FileName + '파일을 만든 후에 다시 하시오';
//    Application.MessageBox('Data file does not exist!', PChar(sqltext) ,MB_ICONSTOP+MB_OK);
//  end;
//end;

procedure TWatchF.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  try
    if FMonitorStart then
    begin
      DisplayMessage('');
    end
    else
    begin
//      ReadMapAddress(FAddressMap,FMapFileName);
    end;
  finally
    FMonitorStart := True;
    Timer1.Enabled := True;
  end;//try

end;

procedure TWatchF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TWatchF.OnSignal(Sender: TIPCThread_Kral; Data: TEventData_Kral);
var
  i,dcount: integer;
begin
  if not FMonitorStart then
    exit;

  FillChar(FModBusData.InpDataBuf[0], High(FModBusData.InpDataBuf) - 1, #0);
  FModBusData.ModBusMode := Data.ModBusMode;
  
  if Data.ModBusMode = 0 then //ASCII Mode이면
  begin
    //ModePanel.Caption := 'ASCII Mode';
    dcount := Data.NumOfData;
    FModBusData.NumOfBit := Data.NumOfBit;

    for i := 0 to dcount - 1 do
      FModBusData.InpDataBuf[i] := Data.InpDataBuf[i];
  end
  else
  if Data.ModBusMode = 1 then// RTU Mode 이면
  begin
    //ModePanel.Caption := 'RTU Mode';
    dcount := Data.NumOfData div 2;
    FModBusData.NumOfBit := Data.NumOfBit;

    if dcount = 0 then
      Inc(dcount);

    for i := 0 to dcount - 1 do
    begin
      FModBusData.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      FModBusData.InpDataBuf[i] := FModBusData.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
//      FModBusData.InpDataBuf[i] :=  ;
    end;

    if (Data.NumOfData mod 2) > 0 then
      FModBusData.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
  end;//else

  FModBusData.ModBusAddress := String(Data.ModBusAddress);

  FModBusData.NumOfData := dcount;
  FModBusData.ModBusFunctionCode := Data.ModBusFunctionCode;

  StatusBar1.SimplePanel := True;
  StatusBar1.SimpleText := FModBusData.ModBusAddress + ' 데이타 도착';

  SendMessage(Handle, WM_MODBUSDATA, 0,0);
end;

procedure TWatchF.UpdateTraceData(var Msg: TWMModbusData);
var
  it: DIterator;
  pHiMap: THiMap;
  i, j, BlockNo: integer;
  tmpStr: string;
  tmpByte, ProcessBitCnt: Byte;
  IsFirst, IsSecond: Boolean;
begin
  BlockNo := 0;
  i := 0;
  j := 0;
  ProcessBitCnt := 0;

  IsFirst := True;
  IsSecond := False;

////////////////////////////////////////////////////////////////////////////////
  //Add modbus functioncode + modbusaddress
  tmpStr := IntToStr(FModBusData.ModBusFunctionCode) + FModBusData.ModBusAddress;
  it := FAddressMap.locate( [tmpStr] );
  SetToValue(it);

  //Get more information and make 'it'
  while not atEnd(it) do
  begin
    if i > FModBusData.NumOfData - 1 then
      break;

    pHiMap := GetObject(it) as THiMap;

    //if ModBusFunction Code is 3
    if FModBusData.ModBusFunctionCode = 3 then
    begin
      pHiMap.FValue := FModBusData.InpDataBuf[i];
      Inc(i);
      BlockNo := pHiMap.FBlockNo;
      Advance(it);
    end
////////////////////////////////////////////////////////////////////////////////

    //if ModBusFunction Code is not 3
    else
    begin
      BlockNo := pHiMap.FBlockNo;
      for i := 0 to FModBusData.NumOfData - 1 do
      begin
        tmpByte := Hi(FModBusData.InpDataBuf[i]);
        for j := 0 to 7 do
        begin
          pHiMap := GetObject(it) as THiMap;
          if not atEnd(it) then
          begin
            pHiMap.FValue := GetBitVal(tmpByte, j);
            Inc(ProcessBitCnt);
            Advance(it);
          end;
        end;

        tmpByte := Lo(FModBusData.InpDataBuf[i]);
        for j := 0 to 7 do
        begin
          pHiMap := GetObject(it) as THiMap;
          if not atEnd(it) then
          begin
            pHiMap.FValue := GetBitVal(tmpByte, j);
            Inc(ProcessBitCnt);
            Advance(it);
          end;
        end;
      end;

      if ((FModBusData.NumOfBit div 8) mod 2) > 0 then
      begin
        tmpByte := Lo(FModBusData.InpDataBuf[i]);
        for j := 0 to 7 do
        begin
          pHiMap := GetObject(it) as THiMap;
          if not atEnd(it) then
          begin
            pHiMap.FValue := GetBitVal(tmpByte, j);
            Inc(ProcessBitCnt);
            Advance(it);
          end;
        end;
      end;
{      if ((j = 8) and IsSecond) or (ProcessBitCnt >= FModBusData.NumOfBit) then
      begin
        Inc(i);
        IsFirst := True;
        IsSecond := False;
        ProcessBitCnt := 0;
        Continue;
      end;

      if IsFirst then
      begin
        tmpByte := Hi(FModBusData.InpDataBuf[i]);
        IsFirst := False;
      end;

      if j = 8 then
      begin
        if not IsSecond then
        begin
          tmpByte := Lo(FModBusData.InpDataBuf[i]);
          IsSecond := True;
          j := 1;
        end;
      end
      else
        Inc(j);

      pHiMap.FValue := GetBitVal(tmpByte, j-1);
      Inc(ProcessBitCnt);
}
    end;

  end;//while

  StatusBar1.SimpleText := FModBusData.ModBusAddress + ' 처리중...';

  //수신된 데이타를 화면에 뿌려줌
  //Value2Screen(BlockNo);
  Value2WatchScreen(BlockNo);
end;

procedure TWatchF.DisplayMessage(Msg: string);
var
  i: integer;
begin
  if (Msg = '') and (FMsgList.Count > 0) then
    Msg := FMsgList.Strings[0];

  //MsgLed.Caption := Msg;
  i := FMsgList.IndexOf(Msg);
  //메세지 출력 후 리스트에서 삭제함(매번 Timer함수에 의해 다시 들어오기 때문임)
  if i > -1 then
    FMsgList.Delete(i);
end;

procedure TWatchF.Value2Screen(BlockNo: integer);
var
  it: DIterator;
  pHiMap: THiMap;
  LInt: integer;
begin
  if BlockNo = 0 then
    exit;

  it := FAddressMap.start;

////////////////////////////////////////////////////////////////////////////////
//Scan pHiMap 'Block' which is called as 'it' in this paragraph
  while not atEnd(it) do
  begin
    pHiMap := GetObject(it) as THiMap;

    //Find Ordered Block using BlockNo which taken from upper fuction
    if pHiMap.FBlockNo = BlockNo then
    begin
      if pHiMap.FAlarm then
      begin

        //if FContact is 2 then Program for FlowMeter is running
        if pHiMap.FContact = 2 then
        begin
          //LInt is First half of FlowMeter value
          LInt := pHiMap.FValue;
          Advance(it);

          //pHiMap is Second half of FlowMeter vlaue
          pHiMap := GetObject(it) as THiMap;

          //Show Values in Monitor Using fuction below
          //Value2Screen_Analog_FlowMeter(pHiMap.FName ,LInt, pHiMap.FValue);
        end;
////////////////////////////////////////////////////////////////////////////////
        //else
          //Value2Screen_Analog(pHiMap.FName ,pHiMap.FValue, pHiMap.FMaxval);
      end
      else
        ;//Value2Screen_Digital(pHiMap.FName ,pHiMap.FValue, pHiMap.FMaxval, pHiMap.FContact);
    end;
    Advance(it);
  end;//while
end;

procedure TWatchF.WatchValue2Screen_Analog_FlowMeter(Name: string; AValue,
  AValue2: Integer);
var
  tmpint: integer;
  tmpdouble: double;
begin
  tmpint := ((AValue shl 16) or AValue2);
  tmpdouble := tmpint;
  tmpdouble := tmpdouble/10;

  if tmpdouble > FWatchValueMax then
    FWatchValueMax := tmpdouble;

  if tmpdouble < FWatchValueMin then
    FWatchValueMin := tmpdouble;


  if FCurrentAryIndex = (FAvgSize - 1) then
  begin
    FFirstCalcAry := False;
    FCurrentAryIndex := 0;
    FWatchValueSum := FWatchValueSum - FWatchValueAry[FCurrentAryIndex] + tmpdouble;
  end
  else
  begin
    Inc(FCurrentAryIndex);

    if FFirstCalcAry = true then
      FWatchValueSum := FWatchValueSum  + tmpdouble
    else
      FWatchValueSum := FWatchValueSum - FWatchValueAry[FCurrentAryIndex] + tmpdouble;
  end;

  FCriticalSection.Enter;

  try
    if FFirstCalcAry = true then
      if FCurrentAryIndex = 0 then
        FWatchValueAvg := FWatchValueSum
      else
        FWatchValueAvg := FWatchValueSum / FCurrentAryIndex
    else
      FWatchValueAvg := FWatchValueSum / FAvgSize;

    FWatchValueAry[FCurrentAryIndex] := tmpdouble;
  finally
    FCriticalSection.Leave;
  end;//try

  FWatchValue := FloatToStr(tmpdouble);
  case PageControl1.ActivePageIndex of
    0: begin //simple
      WatchLabel.Caption := FWatchValue;
      AvgLabel.Caption := format('%10.2f',[FWatchValueAvg]);//FloatToStr(FWatchValueAvg);
    end;
    1: begin //Min/Max
      MinLabel.Caption :=  format('%10.2f',[FWatchValueMin]);//FloatToStr(FWatchValueMin);
      MaxLabel.Caption :=  format('%10.2f',[FWatchValueMax]);//FloatToStr(FWatchValueMax);
      CurLabel.Caption := FWatchValue;
    end;
    2: begin //Graph
      if FIsCurrentValueGraph then
      begin
        iPlot1.Channel[FCurrentValueChannel].AddXY(FCurrentValueX, tmpdouble);
        FCurrentValueX := FCurrentValueX + 1;
      end;

      if FIsAverageValueGraph then
      begin
        iPlot1.Channel[FAverageValueChannel].AddXY(FAverageValueX, FWatchValueAvg);
        FAverageValueX := FAverageValueX + 1;
      end;

      if FIsMinValueGraph then
      begin
        iPlot1.Channel[FMinValueChannel].AddXY(FMinValueX, FWatchValueMin);
        FMinValueX := FMinValueX + 1;
      end;

      if FIsMaxValueGraph then
      begin
        iPlot1.Channel[FMaxValueChannel].AddXY(FMaxValueX, FWatchValueMax);
        FMaxValueX := FMaxValueX + 1;
      end;
    end;
    3: begin //Meter
    end;
    4: begin //Bar
    end;
  end;//case

end;

procedure TWatchF.Value2WatchScreen(BlockNo: integer);
var
  it: DIterator;
  pHiMap: THiMap;
  LInt: integer;
begin
  if BlockNo = 0 then
    exit;

  pHiMap := nil;

  it := FAddressMap.locate( [FWatchName] );
  SetToValue(it);
  pHiMap := GetObject(it) as THiMap;

  if Assigned(pHiMap) then
  begin
    //if FContact is 2 then Program for FlowMeter is running
    if pHiMap.FContact = 2 then
    begin
      //LInt is First half of FlowMeter value
      LInt := pHiMap.FValue;
      Advance(it);

      //pHiMap is Second half of FlowMeter vlaue
      pHiMap := GetObject(it) as THiMap;

      //Show Values in Monitor Using fuction below
      WatchValue2Screen_Analog_FlowMeter(pHiMap.FName ,LInt, pHiMap.FValue);
    end;
  end;//if
end;

procedure TWatchF.FormDestroy(Sender: TObject);
begin
  FWatchValueAry := nil;
  
  FCriticalSection.Free;

  ObjFree(FAddressMap);
  FAddressMap.free;
  FIPCMonitor.Free;
  FMsgList.Free;
end;

procedure TWatchF.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TWatchF.Config1Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TWatchF.Button2Click(Sender: TObject);
begin
  ApplyAvgSize;
end;

procedure TWatchF.ApplyAvgSize;
begin
  SaveConfigDataForm2ini(nil);
  LoadConfigDataini2Form(nil);
  LoadConfigDataini2Var;
  FCriticalSection.Enter;
  try
    SetLength(FWatchValueAry, FAvgSize);
    FCurrentAryIndex := 0;
    FFirstCalcAry := True;
  finally
    FCriticalSection.Leave;
  end;//try
end;

procedure TWatchF.FormShow(Sender: TObject);
begin
  Label1.Caption := FLabelName;
  Label3.Caption := FLabelName;
  Self.Caption := Self.Caption + ' :: ' + FLabelName;
end;

procedure TWatchF.Button1Click(Sender: TObject);
begin
  FWatchValueMax := 0;
  FWatchValueMin := 0;
end;

procedure TWatchF.CurrentValue1Click(Sender: TObject);
begin
  FIsCurrentValueGraph := True;
  FCurrentValueChannel := iPlot1.AddChannel;
  iPlot1.Channel[FCurrentValueChannel].VisibleInLegend := False;
  FCurrentValueX := 0;
  CurrentValue1.Enabled := False;
end;

procedure TWatchF.Average1Click(Sender: TObject);
begin
  FIsAverageValueGraph := True;
  FAverageValueChannel := iPlot1.AddChannel;
  iPlot1.Channel[FAverageValueChannel].VisibleInLegend := False;
  FAverageValueX := 0;
  Average1.Enabled := False;

end;

procedure TWatchF.MinValue1Click(Sender: TObject);
begin
  FIsMinValueGraph := True;
  FMinValueChannel := iPlot1.AddChannel;
  iPlot1.Channel[FMinValueChannel].VisibleInLegend := False;
  FMinValueX := 0;
  MinValue1.Enabled := False;

end;

procedure TWatchF.MaxValue1Click(Sender: TObject);
begin
  FIsMaxValueGraph := True;
  FMaxValueChannel := iPlot1.AddChannel;
  iPlot1.Channel[FMaxValueChannel].VisibleInLegend := False;
  FMaxValueX := 0;
  MaxValue1.Enabled := False;

end;

end.




