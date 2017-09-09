unit SerialCommLogic;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Forms, Graphics,
  StdCtrls, Menus, Dialogs, CommLogic, SerialComport, UtilUnit,
  CopyData, ByteArray, pjhClasses, FAMemMan_pjh, CommLogicType;

type

  TpjhLogicPanel = class(TCustomLogicPanel)
    FComport : TPjhComLed;

  protected
    procedure SetComPort(const Value: TPjhComLed);
  public

    procedure Execute; override;

  published
    property Comport: TPjhComLed read FComport write SetComport;
  end;

  TpjhIfControl = class(TCustomLogicBoolean)
  private
    FVarControl: TCustomLogicControl; //변수
    FExpression: TExpression;
    FStartIndex: integer;
    FCount: integer;
    FCompareData: TCompareData;

    procedure SetVarControl(Value: TCustomLogicControl);
    procedure SetExpression(Value: TExpression);
    procedure SetStartIndex(Value: integer);
    procedure SetCount(Value: integer);
    procedure SetCompareData(Value: TCompareData);

    procedure DoOnEnter; override;
    procedure DoOnEnterState(Sender: TCustomLogicBoolean; var Result: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function DoCompareData(Value: string): Boolean;
    function CompareStrData(Value1, Value2: string): Boolean;
    function CompareDecData(Value1, Value2: string): Boolean;
    function CompareHexData(Value1, Value2: string): Boolean;
  published
    property TrueStep;
    property FalseStep;

    property VarControl: TCustomLogicControl read FVarControl write SetVarControl;
    property Expression: TExpression read FExpression write SetExpression;
    property StartIndex: integer read FStartIndex write SetStartIndex;
    property Count: integer read FCount write SetCount;
    property CompareData: TCompareData read FCompareData write SetCompareData;
  end;

  TpjhGotoControl = class(TCustomLogicLink)
  private
  published
    property NextStep;
    property Direction;
  end;

  TpjhStartControl = class(TCustomLogicStart)
  private
  published
    property NextStep;
  end;

  TpjhStopControl = class(TCustomLogicStop)
  private
  published
  end;

  TpjhWriteComport = class( TpjhProcess )
  private
    FComport: TPjhComLed;
    FWriteDataType: TCommDataType;
    FWriteBuffer4String: TStrings;
    FDelimiter: Char;
    FLoadFromFile: TDataFile;
    //FWriteBuffer4Byte: array of byte;
  protected
    function GetDataType: TCommDataType;
    procedure SetDataType(const Value: TCommDataType);
    procedure SetLines(Value: TStrings);
    procedure SetComPort(const Value: TPjhComLed);
    function GetDelimiter: TDelimiter;
    procedure SetDelimiter(const Value: TDelimiter);
    procedure SetLoadFromFile(Value: TDataFile);

    procedure WriteData2Comport;

    procedure WriteDecimalData;
    procedure WriteHexaDecimalData;

    procedure DoOnEnter; override;
  published
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property DataFile: TDataFile read FLoadFromFile write SetLoadFromFile;
    property Comport: TPjhComLed read FComport write SetComport;
    property Delimiter: TDelimiter read GetDelimiter write SetDelimiter;
    property WriteDataType: TCommDataType read GetDataType write SetDataType;
    property WriteData: TStrings read FWriteBuffer4String write SetLines;
  end;

  TpjhReadComport = class( TpjhProcess )
  private
    FComport: TPjhComLed;
    FReadDataType: TCommDataType;
    FReadBuffer4String: TStrings;
    FCommDataCondition: TCommDataCondition;
    FReadDataCount: integer;
    FDisplayFormName: string;
    FReadBuffer4Byte: TByteArray2;
    FBufClearB4Enter: Boolean;
    FSaveToFile: TDataFile;
    FReadDataIndex: integer;    // FA MEM에 기록할 FReadBuffer4Byte 의 Index

  protected
    procedure SetDataType(const Value: TCommDataType);
    procedure SetLines(Value: TStrings);
    procedure SetComPort(const Value: TPjhComLed);
    procedure SetCommDataCondition(const Value: TCommDataCondition);
    procedure SetReadDataCount(const Value: integer);
    procedure SetSaveToFile(Value: TDataFile);
    procedure SetReadDataIndex(const Value: integer);

    procedure ReadDataFromComport;
    procedure ReadStrDataFromComport;
    procedure ReadByteDataFromComport;

    procedure DoOnEnter; override;
  published
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property SaveToFile: TDataFile read FSaveToFile write SetSaveToFile;
    property BufClearB4Enter: Boolean read FBufClearB4Enter write FBufClearB4Enter;
    property Comport: TPjhComLed read FComport write SetComport;
    property DataCondition: TCommDataCondition read FCommDataCondition
                                                write SetCommDataCondition;
    property DisplayFormName: string read FDisplayFormName write FDisplayFormName;
    property ReadDataType: TCommDataType read FReadDataType write SetDataType;
    property ReadDataBuf: TStrings read FReadBuffer4String write SetLines;
    property ReadDataCount: integer read FReadDataCount write SetReadDataCount;
    property ReadDataIndex: integer read FReadDataIndex write SetReadDataIndex;
  end;

  TpjhDelay = class(TpjhProcess)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TpjhWriteFile = class( TpjhProcess )
    FDataFile: TDataFile;
    FVarControl: TCustomLogicControl;
  protected
    procedure SetDataFile(Value: TDataFile);
    procedure DoOnEnter; override;
    procedure SetVarControl(Value: TCustomLogicControl);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DataFile: TDataFile read FDataFile write SetDataFile;
    property VarControl: TCustomLogicControl read FVarControl write SetVarControl;
  end;

  TpjhWriteFAMem = class( TpjhProcess )
  private
    FFAMemMan: TpjhFAMemMan;
    FMemIndex : integer;       // PLC에서 가져온 데이타를 보관할 메모리 위치
    FMemName  : TMemName;      //                  "                    종류
    FReadDataIndex: integer;
    FVarControl: TCustomLogicControl;
    FDataIndex,//FAMem에 기록할 데이타 시작 위치
    FDataCount: integer; //데이타 갯수

    procedure SetVarControl(const Value: TCustomLogicControl);    // FA MEM에 기록할 FReadBuffer4Byte 의 Index
  protected
    procedure SetFAMemMan(mm:TpjhFAMemMan);
    procedure SetMemName(A: TMemName);
    procedure DoOnEnter; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure WriteDecimalData2MemMan(Data: integer);
  published
    property FAMemoryManager: TpjhFAMemMan read FFAMemMan write SetFAMemMan;
    property FAMemName: TMemName read FMemName write SetMemName;
    property FAMemIndex: Integer read FMemIndex write FMemIndex;
    property DataCount: integer read FDataCount write FDataCount;
    property DataIndex: integer read FDataIndex write FDataIndex;
    property VarControl: TCustomLogicControl read FVarControl write SetVarControl;
  end;

  TpjhSetTimer = class(TpjhProcess)
  private
    FStart: Boolean;
    FTimeOut: Boolean;
    FTimeLimit: Cardinal;
    FTimerHandle: integer;

  protected
    procedure SetStart(Value: Boolean);
    procedure TimerTriggerEvent(Sender : TObject; Handle : Integer;
              Interval : Cardinal; ElapsedTime : LongInt);
    procedure DoOnEnter; override;
  public
    constructor Create(AOwner: TComponent); override;
    property Timeout: Boolean read FTimeOut write FTimeOut;
  published
    //property Start: Boolean read FStart write SetStart;
    property TimeLimit: Cardinal read FTimeLimit write FTimeLimit;
  end;

  TpjhIFTimer = class(TCustomLogicBoolean)
  private
    FVarControl: TpjhSetTimer;

  protected
    procedure SetVarControl(Value: TpjhSetTimer);
    procedure DoOnEnterState(Sender: TCustomLogicBoolean; var Result: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property VarControl: TpjhSetTimer read FVarControl write SetVarControl;
  end;

implementation

{ TpjhLogicPanel }

procedure TpjhLogicPanel.Execute;
var i: integer;
begin
  if Assigned(FComport) then
    if not (FComport.FComPort.Connected) then
      FComport.FComPort.Open;

  for i := 0 to ComponentCount - 1 do
    if Components[i].ClassName = 'TpjhStartControl' then
    begin
      State := TCustomLogicControl(Components[i]);
      break;
    end;//if

  inherited;

end;
procedure TpjhLogicPanel.SetComPort(const Value: TPjhComLed);
begin
  FComport := Value;
end;

{ TpjhIfControl }

function TpjhIfControl.DoCompareData(Value: string): Boolean;
begin
  Result := False;

  case CompareData.DataType of
    cdtString: Result := CompareStrData(Value, CompareData.Data);
    cdtDecimal: Result := CompareDecData(Value, CompareData.Data);
    cdtHexaDecimal: Result := CompareHexData(Value, CompareData.Data);
  end;//case

end;

constructor TpjhIfControl.Create(AOwner: TComponent);
begin
  inherited;

  DiagramType := dtIf;
  OnEnterState := DoOnEnterState;
  FCompareData := TCompareData.Create;
end;

destructor TpjhIfControl.Destroy;
begin
  FreeAndNil(FCompareData);

  inherited;
end;

procedure TpjhIfControl.DoOnEnter;
begin
  Application.ProcessMessages;
  inherited;//조상 DoOnEnter에서 DoOnEnterState함수를 Call함
end;

procedure TpjhIfControl.DoOnEnterState(Sender: TCustomLogicBoolean; var Result: Boolean);
var
  str1: string;
  i: integer;
begin
  Result := False;

  if VarControl = nil then
  begin
    ShowMessage('VarControl should be TpjhReadComport');
    exit;
  end;

  if TComponent(VarControl).ClassName = 'TpjhReadComport' then
  begin
    if TpjhReadComport(VarControl).ReadDataBuf.Count > 0 then
    begin
      str1 := TpjhReadComport(VarControl).ReadDataBuf.Strings[0];
      if Count = 0 then
      begin
        //for i := 0 to TpjhReadComport(VarControl).ReadDataBuf.Count - 1 do
          Result := Pos(CompareData.Data, Str1) > 0;
      end
      else
        Result := DoCompareData( Copy(Str1, StartIndex, Count) );
    end;
  end
  else
    ShowMessage('VarControl should be TpjhReadComport');
end;

function TpjhIfControl.CompareDecData(Value1, Value2: string): Boolean;
var LI: Longint;
begin
  Result := False;

  if StrIsNumeric(Value1) and StrIsNumeric(Value2) then
  begin
    LI := Length(Value1) - Length(Value2);
    if LI > 0 then
      PadLeft(Value2, '0', LI)
    else
      PadLeft(Value1, '0', LI)
  end
  else
    exit;

  Result := CompareStrData(Value1, Value2);
end;

function TpjhIfControl.CompareHexData(Value1, Value2: string): Boolean;
var
  //ByteAry1, ByteAry2: TByteArray2;
  LI: integer;
begin
  Result := False;

  if StrIsHex(Value1) and StrIsHex(Value2) then
  begin
    LI := Length(Value1) - Length(Value2);
    if LI > 0 then
      PadLeft(Value2, '0', LI)
    else
      PadLeft(Value1, '0', LI)
  end
  else
    exit;

  Result := CompareStrData(Value1, Value2);

{  if StrIsHex(Value1) then
  begin
    ByteAry1 := TByteArray2.Create();

    try
      with ByteAry1 do
      begin
        i := Length(Value1) div 2;

        if Odd(Length(Value1)) then
          inc(i);

        SetLengthAndZero(i);
        
        if String2HexByteAry(Value1, FBuffer) < 0 then
          exit;
      end;//with
    finally
      ByteAry1.Free;
    end;//try
  end
  else
    exit;

  if StrIsHex(Value2) then
  begin
    ByteAry2 := TByteArray2.Create();

    try
      with ByteAry2 do
      begin
        i := Length(Value2) div 2;

        if Odd(Length(Value2)) then
          inc(i);

        SetLengthAndZero(i);

        if String2HexByteAry(Value2, FBuffer) < 0 then
          exit;
      end;//with
    finally
      ByteAry2.Free;
    end;//try
  end
  else
    exit;

  case Expression of
    eEqual: Result := ByteAry1.IsEqual(ByteAry1, ByteAry2);
    eLessThan: Result := (Value < CompareData.Data);
    eLessThanEqual: Result := (Value <= CompareData.Data);
    eGreaterThan: Result := (Value > CompareData.Data);
    eGreaterThanEqual: Result := (Value >= CompareData.Data);
  end;//case
}
end;

function TpjhIfControl.CompareStrData(Value1, Value2: string): Boolean;
begin
  Result := False;

  case Expression of
    eEqual: Result := (Value1 = Value2);
    eLessThan: Result := (Value1 < Value2);
    eLessThanEqual: Result := (Value1 <= Value2);
    eGreaterThan: Result := (Value1 > Value2);
    eGreaterThanEqual: Result := (Value1 >= Value2);
  end;//case
end;

procedure TpjhIfControl.SetCompareData(Value: TCompareData);
begin
  if FCompareData <> Value then
    FCompareData := Value;
end;

procedure TpjhIfControl.SetCount(Value: integer);
begin
  if FCount <> Value then
    FCount := Value;
end;

procedure TpjhIfControl.SetExpression(Value: TExpression);
begin
  if FExpression <> Value then
    FExpression := Value;
end;

procedure TpjhIfControl.SetStartIndex(Value: integer);
begin
  if FStartIndex <> Value then
    FStartIndex := Value;
end;

procedure TpjhIfControl.SetVarControl(Value: TCustomLogicControl);
begin
  if FVarControl <> Value then
    FVarControl := Value;
end;

{ TpjhWriteComport }

constructor TpjhWriteComport.Create(AOwner: TComponent);
begin
  //비트맵을 컴포넌트 좌상단에 뿌려줌
  //Inherited 전에 실행해 주어야 함. False는 Default
  FShowLabelBmp := True;

  inherited;

  FWriteBuffer4String := TStringList.Create;
  FLoadFromFile := TDataFile.Create;
end;

destructor TpjhWriteComport.Destroy;
begin
  FWriteBuffer4String.Free;
  FLoadFromFile.Free;
  inherited;
end;

procedure TpjhWriteComport.DoOnEnter;
begin
  Application.ProcessMessages;
  inherited;
  WriteData2Comport;
  Application.ProcessMessages;
end;

function TpjhWriteComport.GetDataType: TCommDataType;
begin
  Result := FWriteDataType;
end;

function TpjhWriteComport.GetDelimiter: TDelimiter;
begin
  case FDelimiter of
    #13: Result := delCR;
    #10: Result := delLF;
    ',': Result := delComma;
    ';': Result := delSemiColon;
    ':': Result := delColon;
    #0 : Result := delNotUse;
  end;//case
end;

procedure TpjhWriteComport.SetComPort(const Value: TPjhComLed);
begin
  FComport := Value;
end;

procedure TpjhWriteComport.SetDataType(const Value: TCommDataType);
begin
  FWriteDataType := Value;
end;

procedure TpjhWriteComport.SetDelimiter(const Value: TDelimiter);
begin
  case Value of
    delCR: FDelimiter := #13;
    delLF: FDelimiter := #10;
    delComma: FDelimiter := ',';
    delSemiColon: FDelimiter := ';';
    delColon: FDelimiter := ':';
    delNotUse: FDelimiter := #0;
  end;//case
end;

procedure TpjhWriteComport.SetLines(Value: TStrings);
begin
  FWriteBuffer4String.Assign(Value);
end;

procedure TpjhWriteComport.WriteData2Comport;
var
  i: integer;
  str1,str2: string;
begin
  if not Assigned(FComport) then
  begin
    if Assigned(TpjhLogicPanel(Self.Parent).Comport) then
      FComport := TpjhLogicPanel(Self.Parent).Comport
    else
    begin
      for i := 0 to TComponent(Self.Parent).ComponentCount - 1 do
      begin
        if TComponent(Self.Parent).Components[i].ClassType = TPjhComLed then
        begin
          FComport := TPjhComLed(TComponent(Self.Parent).Components[i]);
          Break;
        end;
      end;//for
    end;//else
  end;

  if Assigned(FComport) then
  begin
    if not (FComport.FComPort.Connected) then
      FComport.FComPort.Open;

    if FComport.FComPort.Connected then
    begin
      case FWriteDataType of
        cdtString:
          begin
            if FLoadFromFile.FileAction = faRead then
            begin
              if (FLoadFromFile.Enabled) and (FLoadFromFile.FileName <> '') then
              begin
                FWriteBuffer4String.Clear;
                FWriteBuffer4String.LoadFromFile(FLoadFromFile .FileName);
              end;

              for i := 0 to FWriteBuffer4String.Count - 1 do
              begin
                str1 := FWriteBuffer4String.Strings[i];
                while str1 <> '' do
                begin
                  str2 := strToken(Str1, FDelimiter);
                  FComport.FComPort.WriteStr(str2 + #13#10);
                end;//while
              end;//for
            end
            else
            if FLoadFromFile.FileAction = faWrite then
            begin
              ;
            end;
          end;
        cdtDecimal:
          begin
            WriteDecimalData();
          end;
        cdtHexaDecimal:
          begin
            WriteHexaDecimalData();
          end;
      end;//case
    end
    else
      raise Exception.Create('Comport not connected');
  end
  else
//  if 
    raise Exception.Create('Not assigned TPjhComled to TpjhLogicPanel or TpjhWriteComport');
end;

procedure TpjhWriteComport.WriteDecimalData;
var
  i: integer;
  ByteAry: TByteArray2;
  str1,str2: string;
begin
  ByteAry := TByteArray2.Create();
  try
    with ByteAry do
    begin
      for i := 0 to FWriteBuffer4String.Count - 1 do
      begin
        str1 := FWriteBuffer4String.Strings[i];
        if str1 = '' then
          Continue;

        str2 := str1;
        str2 := ReplaceStr(str2,FDelimiter,'');
        if StrIsNumeric(str2) then
        begin
          FBuffer := StrToByteArray(str1,FDelimiter);
          FComport.FComPort.Write(FBuffer[0],Size);
        end
        else
        begin
          ShowMessage('Not integer data');
        end;//else
      end;//for
    end;//with
  finally
    ByteAry.Free;
  end;
end;

procedure TpjhWriteComport.WriteHexaDecimalData;
var
  i,j: integer;
  ByteAry: TByteArray2;
  str1,str2: string;
begin
  ByteAry := TByteArray2.Create();
  try
    with ByteAry do
    begin
      for i := 0 to FWriteBuffer4String.Count - 1 do
      begin
        str1 := FWriteBuffer4String.Strings[i];

        if str1 = '' then
          Continue;

        str2 := str1;
        str2 := ReplaceStr(str2,FDelimiter,'');
        if StrIsHex(str2) then
        begin
          while str1 <> '' do
          begin
            str2 := strToken(Str1, FDelimiter);
            j := Length(str2) div 2;

            if Odd(Length(str2)) then
              inc(j);

            ByteAry.SetLengthAndZero(j);

            if String2HexByteAry(str2, FBuffer) > 0 then
              FComport.FComPort.Write(FBuffer[0],Size);
          end;//while
        end
        else
          ShowMessage('Not Hexadecimal data.'+#13#10+'Check the Delimiter or WriteDataType for TpjhWriteComport');

      end;//for
    end;//with
  finally
    ByteAry.Free;
  end;
end;

procedure TpjhWriteComport.SetLoadFromFile(Value: TDataFile);
begin
  if FLoadFromFile <> Value then
  begin
    FLoadFromFile := Value;
    if (FLoadFromFile.Enabled) and (FLoadFromFile.FileName <> '') then
    begin
      FWriteBuffer4String.Clear;
      if Value.FileAction = faRead then
        FWriteBuffer4String.LoadFromFile(FLoadFromFile.FileName)
      else
      begin
        ShowMessage('faRead is not available');
        Value.FileAction := faRead;
      end;
    end;
  end;
end;

{ TpjhReadComport }

constructor TpjhReadComport.Create(AOwner: TComponent);
begin
  //비트맵을 컴포넌트 좌상단에 뿌려줌
  //Inherited 전에 실행해 주어야 함. False는 Default
  FShowLabelBmp := True;

  inherited;

  FBufClearB4Enter := True;
  FReadBuffer4String := TStringList.Create;
  FReadBuffer4Byte := TByteArray2.Create();
end;

destructor TpjhReadComport.Destroy;
begin
  FReadBuffer4Byte.Clear;
  FReadBuffer4Byte.Free;
  FReadBuffer4String.Free;
  inherited;
end;

procedure TpjhReadComport.DoOnEnter;
begin
  Application.ProcessMessages;
  inherited;

  if FBufClearB4Enter then
  begin
    FReadBuffer4Byte.Clear;
    FReadBuffer4String.Clear;
  end;

  ReadDataFromComport;
  Application.ProcessMessages;
end;

procedure TpjhReadComport.ReadByteDataFromComport;
var
  str1: string;
  ByteAry: TByteArray2;
  rCount: integer;
  Len: integer;
begin
  if not Assigned(FComport) then
  begin
    if Assigned(TpjhLogicPanel(Self.Parent).Comport) then
      FComport := TpjhLogicPanel(Self.Parent).Comport
    else
    begin
      for Len := 0 to TComponent(Self.Parent).ComponentCount - 1 do
      begin
        if TComponent(Self.Parent).Components[Len].ClassType = TPjhComLed then
        begin
          FComport := TPjhComLed(TComponent(Self.Parent).Components[Len]);
          Break;
        end;
      end;//for
    end;//else
  end;

  if Assigned(FComport) then
  begin
    ByteAry := TByteArray2.Create();
    try
      with ByteAry do
      begin
        case FCommDataCondition of
          cdcSize:
            begin
              if ReadDataCount <= 0 then
                Len := FComport.FBufByteQ.WrCount - FComport.FBufByteQ.RdCount
              else
                Len := ReadDataCount;

              Size := Len;//FBuffer 의 메모리 확보를 위해 필요함
              rCount := FComport.FBufByteQ.Read(@FBuffer[0] ,Len);

              if rCount > 0 then
              begin
                FReadBuffer4Byte.AppendByteArray(FBuffer, Len);

                if FReadDataType = cdtDecimal then
                begin
                  str1 := CopyToDecString(0, rCount);
                end
                else
                  str1 := CopyToHexString(0, rCount);

                FReadBuffer4String.Add(str1);
                //디버그 화면에 데이타 전송
                SendCopyData('', FDisplayFormName, str1, 0);
              end;
            end;
          cdcChar:
            begin
            end;
          cdcInterval:;
          cdcDontCare:;
        end;//case
      end;//with
    finally
      ByteAry.Free;
    end;//try
  end
  else
    raise Exception.Create('Not assigned TPjhComled to TpjhLogicPanel or TpjhReadComport');
end;

procedure TpjhReadComport.ReadDataFromComport;
begin
  case FReadDataType of
    cdtString: ReadStrDataFromComport;

    cdtDecimal,
    cdtHexaDecimal: ReadByteDataFromComport;
  end;//case
end;

procedure TpjhReadComport.ReadStrDataFromComport;
var str1: string;
    Len: integer;
begin
  if not Assigned(FComport) then
  begin
    if Assigned(TpjhLogicPanel(Self.Parent).Comport) then
      FComport := TpjhLogicPanel(Self.Parent).Comport
    else
    begin
      for Len := 0 to TComponent(Self.Parent).ComponentCount - 1 do
      begin
        if TComponent(Self.Parent).Components[Len].ClassType = TPjhComLed then
          FComport := TPjhComLed(TComponent(Self.Parent).Components[Len]);
      end;//for
    end;//else
  end;

  if Assigned(FComport) then
  begin
    if not (FComport.FComPort.Connected) then
      FComport.FComPort.Open;

    case FCommDataCondition of
      cdcSize:
        begin
          if ReadDataCount <= 0 then
            Len := FComport.FBufByteQ.WrCount - FComport.FBufByteQ.RdCount
          else
            Len := ReadDataCount;

          SetLength(str1, Len);

          if FComport.FBufByteQ.Read(@str1[1],Len) > 0 then
          begin
            FReadBuffer4String.Add(str1);
            if FDisplayFormName = '' then
              FDisplayFormName := Application.MainForm.Caption;
            SendCopyData('', FDisplayFormName, str1, 0);
          end;
        end;
      cdcChar:
        begin
        end;
      cdcInterval:;
      cdcDontCare:;
    end;//case
  end
  else
    raise Exception.Create('Not assigned TPjhComled to TpjhLogicPanel or TpjhReadComport');
end;

procedure TpjhReadComport.SetCommDataCondition(const Value: TCommDataCondition);
begin
  if FCommDataCondition <> Value then
    FCommDataCondition := Value;
end;

procedure TpjhReadComport.SetComPort(const Value: TPjhComLed);
begin
  FComport := Value;
end;

procedure TpjhReadComport.SetDataType(const Value: TCommDataType);
begin
  FReadDataType := Value;
end;

procedure TpjhReadComport.SetLines(Value: TStrings);
begin
  FReadBuffer4String.Assign(Value);
end;

procedure TpjhReadComport.SetReadDataCount(const Value: integer);
begin
  if FCommDataCondition = cdcSize then
  begin
    if FReadDataCount <> Value then
      FReadDataCount := Value;
  end
  else
    ShowMessage('This property is used only when ReadDataType set cdcSize');
end;

procedure TpjhReadComport.SetSaveToFile(Value: TDataFile);
begin
  if FSaveToFile <> Value then
    FSaveToFile := Value;
end;

procedure TpjhReadComport.SetReadDataIndex(const Value: integer);
begin
  if FReadDataCount <> Value then
    FReadDataCount := Value;
end;

{ TpjhDelay }

constructor TpjhDelay.Create(AOwner: TComponent);
begin
  inherited;

  DiagramType := dtDelay;
end;

{ TpjhWriteFile }

constructor TpjhWriteFile.Create(AOwner: TComponent);
begin
  //비트맵을 컴포넌트 좌상단에 뿌려줌
  //Inherited 전에 실행해 주어야 함. False는 Default
  FShowLabelBmp := True;

  inherited;

  FDataFile := TDataFile.Create;
end;

destructor TpjhWriteFile.Destroy;
begin
  FDataFile.Free;

  inherited;
end;

procedure TpjhWriteFile.DoOnEnter;
var
  str1: string;
begin
  inherited;

  if VarControl = nil then
  begin
    ShowMessage('VarControl should be TpjhReadComport');
    exit;
  end;

  if TComponent(VarControl).ClassName = 'TpjhReadComport' then
  begin
    if TpjhReadComport(VarControl).ReadDataBuf.Count > 0 then
    begin
      Str1 := TpjhReadComport(VarControl).ReadDataBuf.Strings[0];
      File_Open_Append(FDataFile.FileName,Str1,False);
    end;
  end
  else
    ShowMessage('VarControl should be TpjhReadComport');
end;

procedure TpjhWriteFile.SetDataFile(Value: TDataFile);
begin
  if FDataFile <> Value then
    FDataFile := Value;
end;

procedure TpjhWriteFile.SetVarControl(Value: TCustomLogicControl);
begin
  if FVarControl <> Value then
    FVarControl := Value;
end;

{ TpjhWriteFAMem }

constructor TpjhWriteFAMem.Create(AOwner: TComponent);
begin
  //비트맵을 컴포넌트 좌상단에 뿌려줌
  //Inherited 전에 실행해 주어야 함. False는 Default
  FShowLabelBmp := True;

  inherited;
end;

procedure TpjhWriteFAMem.DoOnEnter;
var
  str1: string;
begin
  inherited;

  if VarControl = nil then
  begin
    ShowMessage('VarControl should be TpjhReadComport');
    exit;
  end;

  if TComponent(VarControl).ClassName = 'TpjhReadComport' then
  begin
    if TpjhReadComport(VarControl).ReadDataBuf.Count > 0 then
    begin
      Str1 := TpjhReadComport(VarControl).ReadDataBuf.Strings[0];
      Str1 := Copy(Str1, DataIndex, DataCount);
      if StrIsNumeric(Str1) then
        WriteDecimalData2MemMan(StrToInt(Str1))
      else
        ShowMessage('Data is not integer');
    end;
  end
  else
    ShowMessage('VarControl should be TpjhReadComport');

end;

procedure TpjhWriteFAMem.SetFAMemMan(mm: TpjhFAMemMan);
begin
  FFAMemMan := mm;
end;

procedure TpjhWriteFAMem.SetMemName(A: TMemName);
begin
  if FMemName <> A then
    FMemName := A;
end;

procedure TpjhWriteFAMem.SetVarControl(const Value: TCustomLogicControl);
begin
  FVarControl := Value;
end;

procedure TpjhWriteFAMem.WriteDecimalData2MemMan(Data: integer);
begin
  if Assigned(FAMemoryManager) then
  begin
    case FMemName of
      A_MEM: FAMemoryManager.SetA(FAMemIndex, Data);
      F_MEM: FAMemoryManager.SetF(FAMemIndex, Data);
      R_MEM: FAMemoryManager.SetR(FAMemIndex, Data);
      W_MEM: FAMemoryManager.SetW(FAMemIndex, Data);
    end;//case
  end;
end;

{ TpjhSetTimer }

constructor TpjhSetTimer.Create(AOwner: TComponent);
begin
  //비트맵을 컴포넌트 좌상단에 뿌려줌
  //Inherited 전에 실행해 주어야 함. False는 Default
  FShowLabelBmp := True;

  inherited;

  FTimerHandle := -1;
  FTimeOut := False;
end;

procedure TpjhSetTimer.DoOnEnter;
begin
  inherited;

  if FIsInitialize then
  begin
    FTimeOut := False;
    FIsInitialize := False;
    SetStart(False);
  end;

  SetStart(True);
end;

procedure TpjhSetTimer.SetStart(Value: Boolean);
begin
  if Value = FStart then
    exit; 

  FStart := Value;
  
  FTimeOut := False;

  if Value then
  begin
    if FTimerHandle = -1 then
      FTimerHandle := StateMachine.FTimerPool.AddOneShot(TimerTriggerEvent, TimeLimit);
  end
  else
  if FTimerHandle > -1 then
  begin
    StateMachine.FTimerPool.Remove(FTimerHandle);
    FTimerHandle := -1;
  end;
end;

procedure TpjhSetTimer.TimerTriggerEvent(Sender: TObject; Handle: Integer;
  Interval: Cardinal; ElapsedTime: Integer);
begin
  FTimeOut := True;
  FTimerHandle := -1;
end;

{ TpjhIFTimer }

constructor TpjhIFTimer.Create(AOwner: TComponent);
begin
  //비트맵을 컴포넌트 좌상단에 뿌려줌
  //Inherited 전에 실행해 주어야 함. False는 Default
  FShowLabelBmp := True;

  inherited;

  DiagramType := dtIf;
  OnEnterState := DoOnEnterState;
end;

procedure TpjhIFTimer.DoOnEnterState(Sender: TCustomLogicBoolean;
  var Result: Boolean);
begin
  Result := False;

  if VarControl = nil then
  begin
    //ShowMessage('VarControl should be TpjhSetTimer');
    exit;
  end;

  if TComponent(VarControl).ClassName = 'TpjhSetTimer' then
  begin
    Result := VarControl.FTimeout;
  end
  else
    ShowMessage('VarControl should be TpjhSetTimer');
end;

procedure TpjhIFTimer.SetVarControl(Value: TpjhSetTimer);
begin
  if (Value <> nil) and (Value.ClassName <> 'TpjhSetTimer') then
  begin
    ShowMessage('VarControl should be TpjhSetTimer');
    exit;
  end;

  if FVarControl <> Value then
    FVarControl := Value;
end;

end.
