unit FlowChartLogic;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics,
  Vcl.StdCtrls, Vcl.Menus, Vcl.Dialogs, CustomLogic, UtilUnit,
  ByteArray, pjhClasses, CustomLogicType;

type
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

  TpjhDelay = class(TpjhProcess)
  public
    constructor Create(AOwner: TComponent); override;
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

{  if TComponent(VarControl).ClassName = 'TpjhReadComport' then
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
  }
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

{ TpjhDelay }

constructor TpjhDelay.Create(AOwner: TComponent);
begin
  inherited;

  DiagramType := dtDelay;
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
      FTimerHandle := DrawPanel.FTimerPool.AddOneShot(TimerTriggerEvent, TimeLimit);
  end
  else
  if FTimerHandle > -1 then
  begin
    DrawPanel.FTimerPool.Remove(FTimerHandle);
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
