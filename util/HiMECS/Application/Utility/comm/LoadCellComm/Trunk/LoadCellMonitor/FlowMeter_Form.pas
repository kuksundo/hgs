unit FlowMeter_Form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, SyncObjs, SCLED, ShadowButton,
  ModbusComStruct, DeCAL_pjh, IPCThrd2, IPCThrdMonitor2, ModbusComConst,
  DB, DBTables, XBaloon, XBaloon_Util, janSQL,
  AnalogMeter, EngMonitorConfig, iniFiles, Menus, StdCtrls;

const
  ENGMONITOR_SECTION = 'Engine Monitor';
  INIFILENAME = '.\EngMonitor2.ini';

type
  TDataType = (dtmA, dtRTD, dtTC, dtDirect, dtDigital);

  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    StatusBar1: TStatusBar;
    MsgLed: TSCLED;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    Config1: TMenuItem;
    Timer2: TTimer;
    GroupBox3: TGroupBox;
    bt_CheckStart: TButton;
    Label1: TLabel;
    cb_LoadCell: TComboBox;
    bt_CheckStop: TButton;
    Label9: TLabel;
    lb_CheckStatus: TLabel;
    GroupBox1: TGroupBox;
    ed_weight: TPanel;
    Label10: TLabel;
    pl_Time: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ed_LogSec: TEdit;
    ed_LogMin: TEdit;
    ed_LogHour: TEdit;
    Timer3: TTimer;
    GroupBox2: TGroupBox;
    mm_Check: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OnSignal(Sender: TIPCThread2; Data: TEventData2);
    procedure OnSignal2(Sender: TIPCThread2; Data: TEventData2);
    procedure UpdateTraceData(var Msg: TWMModbusData); message WM_MODBUSDATA;
    procedure UpdateTraceData2(var Msg: TWMModbusData); message WM_MODBUSDATA2;
    procedure Timer1Timer(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure bt_CheckStartClick(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure bt_CheckStopClick(Sender: TObject);
  private
    FFilePath: string;      //파일을 저장할 경로
    FMapFileName: string;   //Modbus Map 파일 이름
    FHiMap: THiMap;         //Modbus Address 구조체 -> 동적으로 생성함
    FAddressMap: DMap;      //Modbus Map 데이타 저장 구초체
    FIPCMonitor: TIPCMonitor2;//공유 메모리 및 이벤트 객체
    FModBusData: TWMModbusData;

    FMapFileName2: string;   //Modbus Map 파일 이름
    FAddressMap2: DMap;      //Modbus Map 데이타 저장 구초체
    FIPCMonitor2: TIPCMonitor2;//공유 메모리 및 이벤트 객체
    FModBusData2: TWMModbusData;

    FCriticalSection: TCriticalSection;
    FMonitorStart: Boolean; //타이머 동작 완료하면 True
    FCheckStart: Boolean;  //체크가 시작되면 True
    FLastCheckTime: TDateTime;  //마지막으로 체크된 시간
    FNextCheckTime: TDateTime;  //다음 체크할 시간

    FMsgList: TStringList;  //Message를 저장하는 리스트
    FjanDB : TjanSQL; //text 기반 SQL DB
    FErrCount: integer;
  public
    procedure InitVar;
    procedure ReadMapAddress(AddressMap: DMap; MapFileName: string);
    procedure ReadRange;
    procedure Value2Screen(BlockNo: integer);
    procedure Value2Screen2(BlockNo: integer);
    procedure Value2Screen_Analog(Name: string; AValue: Integer; AMaxVal: real);
    procedure Value2Screen_Analog_FlowMeter(Name: string; AValue: Integer; AValue2: Integer);

    procedure Value2Screen_Digital(Name: string; AValue: Integer;
                                    AMaxVal: real; AContact: integer);
    function  ModBusValueResolve(value:integer; max: real; datatype: TDataType): string;
    procedure AddMessage2List(Msg: string);
    procedure DisplayMessage(Msg: string);

    procedure LoadConfigDataini2Form(ConfigForm:TEngMonitorConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:TEngMonitorConfigF);
    procedure SetConfigData;
  end;

var
  Form1: TForm1;

implementation

uses CommonUtil;

{$R *.dfm}

{ TForm1 }

procedure TForm1.OnSignal(Sender: TIPCThread2; Data: TEventData2);
var
  i,dcount: integer;
begin
  if not FMonitorStart then
    exit;

  FillChar(FModBusData.InpDataBuf[0], High(FModBusData.InpDataBuf) - 1, #0);

  //  FModBusData.ModBusMode := Data.ModBusMode;
  FModBusData.ModBusMode := 0;
  Data.ModBusMode := 0;

  if Data.ModBusMode = 0 then //ASCII Mode이면
  begin
//    ModePanel.Caption := 'ASCII Mode';
    dcount := Data.NumOfData;
    //FModBusData.NumOfBit := Data.NumOfBit;

    for i := 0 to dcount - 1 do
      FModBusData.InpDataBuf[i] := Data.InpDataBuf[i];
  end
  else
  if Data.ModBusMode = 1 then// RTU Mode 이면
  begin
//    ModePanel.Caption := 'RTU Mode';
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

  //FModBusData.ModBusAddress := String(Data.ModBusAddress);

  FModBusData.NumOfData := dcount;
  FModBusData.ModBusFunctionCode := Data.ModBusFunctionCode;

  StatusBar1.SimplePanel := True;
  StatusBar1.SimpleText := '데이타 도착';

  SendMessage(Handle, WM_MODBUSDATA, 0,0);
end;

procedure TForm1.OnSignal2(Sender: TIPCThread2; Data: TEventData2);
var
  i,dcount: integer;
begin
  if not FMonitorStart then
    exit;

  FillChar(FModBusData2.InpDataBuf[0], High(FModBusData2.InpDataBuf) - 1, #0);
  FModBusData2.ModBusMode := Data.ModBusMode;

  if Data.ModBusMode = 0 then //ASCII Mode이면
  begin
//    ModePanel.Caption := 'ASCII Mode';
    dcount := Data.NumOfData;
    FModBusData2.NumOfBit := Data.NumOfBit;

    for i := 0 to dcount - 1 do
      FModBusData2.InpDataBuf[i] := Data.InpDataBuf[i];
  end
  else
  if Data.ModBusMode = 1 then// RTU Mode 이면
  begin
//    ModePanel.Caption := 'RTU Mode';
    dcount := Data.NumOfData div 2;
    FModBusData2.NumOfBit := Data.NumOfBit;

    if dcount = 0 then
      Inc(dcount);

    for i := 0 to dcount - 1 do
    begin
      FModBusData2.InpDataBuf[i] := Data.InpDataBuf2[i*2] ;
      FModBusData2.InpDataBuf[i] := FModBusData2.InpDataBuf[i] shl 8 + Data.InpDataBuf2[i*2 + 1];
    end;
  end;//else

  FModBusData2.ModBusAddress := String(Data.ModBusAddress);

  FModBusData2.NumOfData := dcount;
  FModBusData2.ModBusFunctionCode := Data.ModBusFunctionCode;

  StatusBar1.SimplePanel := True;
  StatusBar1.SimpleText := FModBusData2.ModBusAddress + ' 데이타 도착';

  SendMessage(Handle, WM_MODBUSDATA2, 0,0);
end;

procedure TForm1.InitVar;
begin
  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  FCriticalSection := TCriticalSection.Create;

  FAddressMap := DMap.Create;
  FIPCMonitor := TIPCMonitor2.Create(0, 'ModBusCom', True);
  FIPCMonitor.OnSignal := OnSignal;
  FIPCMonitor.Resume;
  //FMapFileName := 'Wago_Control_FullOption_Modbus_Map.txt';

  FAddressMap2 := DMap.Create;
  FIPCMonitor2 := TIPCMonitor2.Create(0, 'ModBusCom2', True);
  FIPCMonitor2.OnSignal := OnSignal2;
  FIPCMonitor2.Resume;
  //FMapFileName2 := 'Wago_Safety_FullOption_Modbus_Map.txt';

  FMonitorStart := False;
  FMsgList := TStringList.Create;

  LoadConfigDataini2Var;
  FErrCount := 0;
end;

procedure TForm1.UpdateTraceData(var Msg: TWMModbusData);
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
  pHiMap.FValue := FModBusData.InpDataBuf[i];

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
  Value2Screen(BlockNo);
end;

procedure TForm1.UpdateTraceData2(var Msg: TWMModbusData);
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

  tmpStr := IntToStr(FModBusData2.ModBusFunctionCode) + FModBusData2.ModBusAddress;
  it := FAddressMap2.locate( [tmpStr] );
  SetToValue(it);

  while not atEnd(it) do
  begin
    if i > FModBusData2.NumOfData - 1 then
      break;

    pHiMap := GetObject(it) as THiMap;

    if FModBusData2.ModBusFunctionCode = 3 then
    begin
      pHiMap.FValue := FModBusData2.InpDataBuf[i];
      Inc(i);
    end
    else
    begin

      if ((j = 8) and IsSecond) or (ProcessBitCnt >= FModBusData2.NumOfBit) then
      begin
        Inc(i);
        IsFirst := True;
        IsSecond := False;
        ProcessBitCnt := 0;
        Continue;
      end;

      if IsFirst then
      begin
        tmpByte := Hi(FModBusData2.InpDataBuf[i]);
        IsFirst := False;
      end;

      if j = 8 then
      begin
        if not IsSecond then
        begin
          tmpByte := Lo(FModBusData2.InpDataBuf[i]);
          IsSecond := True;
          j := 1;
        end;
      end
      else
        Inc(j);

      pHiMap.FValue := GetBitVal(tmpByte, j-1);
      Inc(ProcessBitCnt);
    end;

    BlockNo := pHiMap.FBlockNo;
    Advance(it);
  end;//while

  StatusBar1.SimpleText := FModBusData2.ModBusAddress + ' 처리중...';

  //수신된 데이타를 화면에 뿌려줌
  Value2Screen2(BlockNo);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ObjFree(FAddressMap);
  FAddressMap.free;

  ObjFree(FAddressMap2);
  FAddressMap2.free;

  FIPCMonitor.Free;
  FIPCMonitor2.Free;
  FCriticalSection.Free;
  FMsgList.Free;
end;

//세미콜론(;)으로 분리된 텍스트 화일을 ODBC를 거치지 않고 직접 접근함
procedure TForm1.ReadMapAddress(AddressMap: DMap; MapFileName: string);
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
    FjanDB :=TjanSQL.create;
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

//각 아날로그 값의 Low, High 범위를 파일로 부터 읽어 온다.
procedure TForm1.ReadRange;
begin

end;

procedure TForm1.Value2Screen(BlockNo: integer);
var
  it: DIterator;
  pHiMap: THiMap;
  LInt: integer;
begin
//  if BlockNo = 0 then
//    exit;

  it := FAddressMap.start;
  //LInt is First half of FlowMeter value
  //pHiMap is Second half of FlowMeter vlaue
  //Show Values in Monitor Using fuction below
  LInt := 0;
  Value2Screen_Analog_FlowMeter(pHiMap.FName ,LInt, pHiMap.FValue);



////////////////////////////////////////////////////////////////////////////////
//Scan pHiMap 'Block' which is called as 'it' in this paragraph
{  while not atEnd(it) do
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
          Value2Screen_Analog_FlowMeter(pHiMap.FName ,LInt, pHiMap.FValue);
        end
////////////////////////////////////////////////////////////////////////////////
        else
          Value2Screen_Analog(pHiMap.FName ,pHiMap.FValue, pHiMap.FMaxval);
      end
      else
        Value2Screen_Digital(pHiMap.FName ,pHiMap.FValue, pHiMap.FMaxval, pHiMap.FContact);
    end;
    Advance(it);
  end;//while
}
end;

procedure TForm1.Value2Screen2(BlockNo: integer);
var
  it: DIterator;
  pHiMap: THiMap;
begin
  if BlockNo = 0 then
    exit;

  it := FAddressMap2.start;

  while not atEnd(it) do
  begin
    pHiMap := GetObject(it) as THiMap;

    if pHiMap.FBlockNo = BlockNo then
      if pHiMap.FAlarm then
        Value2Screen_Analog(pHiMap.FName ,pHiMap.FValue, pHiMap.FMaxval)
      else
        Value2Screen_Digital(pHiMap.FName ,pHiMap.FValue, pHiMap.FMaxval, pHiMap.FContact);

    Advance(it);
  end;//while
end;

procedure TForm1.Value2Screen_Analog(Name: string; AValue: Integer; AMaxVal: real);
var
  tmpPanel: TPanel;
  //tmpGnouMeter: TGnouMeter;
  tmpint: integer;
begin
  tmpPanel := nil;
  //ReplaceName 함수 추가할것
  //RPM인 경우
  if (Name = 'AO_ENG_RPM') or (Name = 'S_AO_ENG_RPM') or (Name = 'AO_TC_RPM') then
  begin
    with TAnalogMeter(FindComponent(Name)) do
      if Name = 'AO_ENG_RPM' then
        Value := AValue
      else
        Value := StrToFloat(ModBusValueResolve(AValue,AMaxVal,dtDirect));

    //with TLCD99(FindComponent('A'+Address+'RPMLCD')) do
    with TPanel(FindComponent(Name+'RPM')) do
        Caption := IntToStr(AValue);
  end
  else
  begin
    tmpPanel := TPanel(FindComponent(Name));

    if tmpPanel <> nil then
    begin
      //if Pos('AI_466', Name) > 0 then
      if (Pos('AI_466', Name) > 0) or (Pos('AI_469', Name) > 0) then
        tmpPanel.Caption := ModBusValueResolve(AValue,AMaxVal,dtmA)
      else
      if Pos('AI_461', Name) > 0 then
      begin
        tmpPanel.Caption := IntToStr(Round(StrToFloat(ModBusValueResolve(AValue,AMaxVal,dtRTD))))
{        tmpint := Round(StrToFloat(ModBusValueResolve(AValue,AMaxVal,dtRTD)));
        if (tmpint > TGnouMeter(tmpPanel).ValueMax) then
          tmpint := Round(TGnouMeter(tmpPanel).ValueMax);
        TGnouMeter(tmpPanel).Value := tmpint;
}
      end
      else
        tmpPanel.Caption := ModBusValueResolve(AValue,AMaxVal,dtTC);
    end
    else
    begin
      //tmpGnouMeter := nil;
      //tmpGnouMeter := TGnouMeter(FindComponent(Name));
      //if tmpGnouMeter <> nil then
      //begin
        //tmpGnouMeter.Value := Round(StrToFloat(ModBusValueResolve(AValue,AMaxVal,dtDirect)));
      //end;
    end;
  end;
end;

//AContact: 1 = A접점, 2 = B접점, 3 = C접점
procedure TForm1.Value2Screen_Digital(Name: string; AValue: Integer;
                                              AMaxVal: real; AContact: integer);
var
  rslt: string;
  shbtn: TShadowButton;
  tmponColor, tmpoffColor: TColor;
begin
  shbtn := nil;
  shbtn := TShadowButton(FindComponent(Name));

  if shbtn <> nil then
  begin
    rslt := ModBusValueResolve(AValue,AMaxVal,dtDigital);

    case AContact of
      1: begin
          if shbtn.tag = 100 then
          begin
            tmpOnColor := COLOR_ON2;
            tmpOffColor := COLOR_OFF2;
          end
          else
          begin
            tmpOnColor := COLOR_ON;
            tmpOffColor := COLOR_OFF;
          end;

          if rslt = 'ON' then
            AddMessage2List(shbtn.hint)
            //MsgLed.Caption := shbtn.hint
          else
            //MsgLed.Caption := '';
        end;
      2: begin
          if shbtn.tag = 100 then
          begin
            tmpOnColor := COLOR_OFF2;
            tmpOffColor := COLOR_ON2;
          end
          else
          begin
            tmpOnColor := COLOR_OFF;
            tmpOffColor := COLOR_ON;
          end;

          if rslt = 'OFF' then
          begin
            if name = 'iSSH81' then
            begin
              Inc(FErrCount);
              //Panel21.Caption := IntToStr(FerrCount);
            end;
            AddMessage2List(shbtn.hint);
            //MsgLed.Caption := shbtn.hint
          end
          else
            //MsgLed.Caption := '';
        end;
     end;

    if rslt = 'ON' then
      shbtn.Color := tmpOnColor
    else
      shbtn.Color := tmpOffColor;
  end;
end;

function TForm1.ModBusValueResolve(value:integer; max: real; datatype: TDataType ): string;
var tmpvalue: real;
begin
  case datatype of
    dtmA:begin
      tmpvalue := (value * max) / 32767;
      Result := Real2Str(tmpvalue,2);
    end;

    dtRTD, dtTC:
      if max <> 0 then
        Result := IntToStr(value div Round(max))
      else
        Result := '0';
    //들어오는 값 그대로 표시함
    dtDirect: Result := IntToStr(value);
    //Digital 값인 경우
    dtDigital:begin
      if Value > 0 then  //$FF로 들어옴
        Result := 'ON'
      else
        Result := 'OFF';
    end;
  end;//case


{  if max = 0 then
  begin
    Result := IntToStr(value);
  end
  else//Calibration 하여 표시함
  begin
    //tmpvalue := (Value * max) / 4095;
    //Result := Real2Str(tmpvalue,2);
    tmpvalue := Round(value * max) div 32760;
  end;//if
}
end;

procedure TForm1.Timer1Timer(Sender: TObject);
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

procedure TForm1.DisplayMessage(Msg: string);
var
  i: integer;
begin
  if (Msg = '') and (FMsgList.Count > 0) then
    Msg := FMsgList.Strings[0];

  MsgLed.Caption := Msg;
  i := FMsgList.IndexOf(Msg);
  //메세지 출력 후 리스트에서 삭제함(매번 Timer함수에 의해 다시 들어도기 때문임)
  if i > -1 then
    FMsgList.Delete(i);
end;


procedure TForm1.AddMessage2List(Msg: string);
begin
  if FMsgList.IndexOf(Msg) = -1 then
    FMsgList.Add(Msg);
end;

procedure TForm1.LoadConfigDataini2Form(ConfigForm: TEngMonitorConfigF);
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

procedure TForm1.LoadConfigDataini2Var;
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

procedure TForm1.SaveConfigDataForm2ini(ConfigForm: TEngMonitorConfigF);
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
        FAddressMap.clear;
        ReadMapAddress(FAddressMap,FMapFileName);
        //ReadMapAddress(FAddressMap2,FMapFileName2);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TForm1.Config1Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TForm1.Value2Screen_Analog_FlowMeter(Name: string; AValue,
  AValue2: Integer);
var
  tmpPanel: TPanel;
  tmpint: integer;
  tmpdouble: double;
begin
    tmpint := AValue2;
    tmpdouble := tmpint;
    tmpdouble := tmpdouble/10;
    ed_Weight.Caption := FloatToStr(tmpdouble);
    StatusBar1.SimpleText := '마지막 데이터처리 : ' + DateTimeToStr(now) +', ' + FloatToStr(tmpdouble);
    //tmpPanel.Caption := ModBusValueResolve(AValue,AMaxVal,dtTC);
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  FCurrentTime : TDateTime;
begin
  pl_Time.caption := formatdatetime('yyyy-mm-dd hh:nn:ss am/pm', now);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  v_hnd : hwnd;
  c_hnd : hwnd;
  cc_hnd : hwnd;
begin
  v_hnd := FindWindow(nil, 'MODBUS 통신 화면(Multi-Drop)');
  if v_hnd <> 0 then
    c_hnd := FindWindowEx(v_hnd, 0, 'TPanel', nil);
  cc_hnd := FindWindowEx(c_hnd, 0, 'TButton', nil);
  if cc_hnd <> 0 then
  begin
    sendmessage(cc_hnd, WM_LBUTTONDOWN, 0, 0);
    sendmessage(cc_hnd, WM_LBUTTONUP, 0, 0);
  end;
  if v_hnd <> 0 then
    PostMessage(v_hnd, WM_CLOSE, 0, 0);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  v_hnd: hwnd;
begin
  WinExec(PChar('.\LoadCellComm\LoadCellComm.exe'), SW_MINIMIZE);
  v_hnd := FindWindow(nil, 'LoadCell Communication Program. (현대중공업 엔진시험기술부)');
  if v_hnd <> 0 then
    ShowWindow(v_hnd, SW_SHOW);
  SetForeGroundWindow(handle);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  v_hnd : hwnd;
begin
  v_hnd := FindWindow(nil, 'DataSavep');
  if v_hnd <> 0 then
    PostMessage(v_hnd, WM_CLOSE, 0, 0);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  v_hnd : hwnd;
  c_hnd : hwnd;
  cc_hnd : hwnd;
begin
  WinExec(PChar('.\ModBusComP_multidrop.exe'), SW_SHOWNOACTIVATE);
  v_hnd := FindWindow(nil, 'MODBUS 통신 화면(Multi-Drop)');
  if v_hnd <> 0 then
//    SendMessage(v_hnd, WM_CLOSE, 0, 0);
  c_hnd := FindWindowEx(v_hnd, 0, 'TPanel', nil);
  cc_hnd := FindWindowEx(c_hnd, 0, 'TButton', nil);
  if cc_hnd <> 0 then
  begin
    sendmessage(cc_hnd, WM_LBUTTONDOWN, 0, 0);
    sendmessage(cc_hnd, WM_LBUTTONUP, 0, 0);
  end;
  SetForeGroundWindow(handle);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  v_hnd: thandle;
begin
  v_hnd := FindWindow(nil, 'DataSavep');
  if v_hnd <> 0 then
//    ShowWindow(v_hnd, SW_MINIMIZE);
end;

procedure TForm1.bt_CheckStartClick(Sender: TObject);
begin
  if(cb_LoadCell.Text = '로드셀 선택') then
  begin
    Showmessage('로드셀을 선택하세요');
    exit;
  end;

  lb_CheckStatus.Caption := '체크중';
  lb_CheckStatus.Font.Color := clRed;
  Timer3.Interval := StrToInt(ed_LogSec.Text)*1000 + StrToInt(ed_LogMin.Text)*60000
                      +StrToInt(ed_LogHour.Text)*3600000;
  mm_Check.Text := cb_LoadCell.Text + '   '+ pl_Time.caption + '   :   '
                    + ed_weight.caption + #13#10 + mm_Check.Text;                      
  Timer3.Enabled := True;

  cb_LoadCell.Enabled := False;
  ed_LogHour.Enabled := False;
  ed_LogMin.Enabled := False;
  ed_LogSec.Enabled := False;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
  mm_Check.Text := cb_LoadCell.Text + '   '+ pl_Time.caption + '   :   '
                    + ed_weight.caption + #13#10 + mm_Check.Text;
end;

procedure TForm1.bt_CheckStopClick(Sender: TObject);
begin
  Timer3.Enabled := False;
  lb_CheckStatus.Font.Color := clGreen;
  lb_CheckStatus.Caption := '대기중';
  StatusBar1.SimpleText := '대기중';

  cb_LoadCell.Enabled := True;
  ed_LogHour.Enabled := True;
  ed_LogMin.Enabled := True;
  ed_LogSec.Enabled := True;
end;

end.
