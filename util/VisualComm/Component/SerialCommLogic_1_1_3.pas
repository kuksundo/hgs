unit SerialCommLogic_1_1_3;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Forms, Graphics,
  StdCtrls, Menus, Dialogs, MyPropertyUnit, CommLogic, SerialComport, UtilUnit,
  CopyData, ByteArray, pjhClasses, FAMemMan_pjh;

type
  TExpression = (eEqual, eLessThan, eLessThanEqual, eGreaterThan, eGreaterThanEqual);
  //cdtInteger, cdtBoolean, cdtFloat, cdtBCD, cdtDate, cdtTime, cdtDateTime,
  TCommDataType = (cdtString, cdtDecimal, cdtHexaDecimal);
  //수신 조건           일정크기,특정문자수신여부,일정시간,조건없음
  TCommDataCondition = (cdcSize, cdcChar, cdcInterval, cdcDontCare);
  TDelimiter = (delCR, delLF, delComma, delSemiColon, delColon, delNotUse);

  TCompareData = class(TPersistent)
  private
    FDataType: TCommDataType;
    FData: string;
    //FByteData: TByteArray2;

  protected
    procedure SetData(Value: string);
  published
    property DataType: TCommDataType read FDataType write FDataType;
    property Data: string read FData write SetData;
  end;

  TDataFile = class(TPersistent)
  private
    FEnabled: Boolean;
    FFileName: TFileNameDlgClass;

  protected
    function GetFileName: TFileNameDlgClass;
    procedure SetFileName(const Value: TFileNameDlgClass);
  published
    property Enabled: Boolean read FEnabled write FEnabled;
    property FileName: TFileNameDlgClass read GetFileName write SetFileName;
  end;

  TpjhLogicPanel = class(TCustomLogicPanel)
    FComport : TPjhComLed;
  protected
{    function GetAnchors: TAnchors;
    function GetAutoScroll: Boolean;
    function GetAutoSize: Boolean;
    function GetBevelEdges: TBevelEdges;
    function GetBevelInner: TBevelCut;
    function GetBevelKind: TBevelKind;
    function GetBevelOuter: TBevelCut;
    function GetBevelWidth: TBevelWidth;
    function GetBidiMode: TBidiMode;
    function GetBorderStyle: TBorderStyle;
    function GetConstraints: TMySizeConstraints;
    function GetCtl3D: Boolean;
    function GetCursor: TCursor;
    function GetDockSite: Boolean;
    function GetDragCursor: TCursor;
    function GetDragKind: TDragKind;
    function GetDragMode: TDragMode;
    function GetEnabled: Boolean;
    //function GetFont: TFont;
    function GetHelpContext: THelpContext;
    function GetHelpKeyWord: String;
    function GetHelpType: THelpType;
    function GetHint: String;
    function GetHorzScrollBar: TControlScrollBar;
    function GetParentBidiMode: Boolean;
    function GetParentColor: Boolean;
    function GetParentCtl3D: Boolean;
    //function GetParentFont: Boolean;
    function GetParentShowHint: Boolean;
    function GetPopupMenu: TPopupMenu;
    function GetShowHint: Boolean;
    function GetTabOrder: TTabOrder;
    function GetTabStop: Boolean;
    function GetTag: Longint;
    function GetVertScrollBar: TControlScrollBar;
    function GetVisible: Boolean;
}
    procedure SetComPort(const Value: TPjhComLed);
  public
    procedure Execute; override;

  published
{    property Anchors: TAnchors read GetAnchors;
    property AutoScroll: Boolean read GetAutoScroll;
    property AutoSize: Boolean read GetAutoSize;
    property BevelEdges: TBevelEdges read GetBevelEdges;
    //property BevelInner: TBevelCut read GetBevelInner;
    property BevelKind: TBevelKind read GetBevelKind;
    property BevelOuter: TBevelCut read GetBevelOuter;
    property BevelWidth: TBevelWidth read GetBevelWidth;
    property BidiMode: TBidiMode read GetBiDiMode;
    property BorderStyle: TBorderStyle read GetBorderStyle;
    property Constraints: TMySizeConstraints read GetConstraints;
    property Ctl3D: Boolean read GetCtl3D;
    property Cursor: TCursor read GetCursor;
    property DockSite: Boolean read GetDockSite;
    property DragCursor: TCursor read GetDragCursor;
    property DragKind: TDragKind read GetDragKind;
    property DragMode: TDragMode read GetDragMode;
    property Enabled: Boolean read GetEnabled;
    //property Font: TFont read GetFont;
    property HelpContext: THelpContext read GetHelpContext;
    property HelpKeyWord: String read GetHelpKeyWord;
    property HelpType: THelpType read GetHelpType;
    property Hint: String read GetHint;
    property HorzScrollBar: TControlScrollBar read GetHorzScrollBar;
    property ParentBidiMode: Boolean read GetParentBidiMode;
    property ParentColor: Boolean read GetParentColor;
    property ParentCtl3D: Boolean read GetParentCtl3D;
    //property ParentFont: Boolean read GetParentFont;
    property ParentShowHint: Boolean read GetParentShowHint;
    property PopupMenu: TPopupMenu read GetPopupMenu;
    property ShowHint: Boolean read GetShowHint;
    //property TabOrder: TTabOrder read GetTabOrder;
    property TabStop: Boolean read GetTabStop;
    property Tag: Longint read GetTag;
    property VertScrollBar: TControlScrollBar read GetVertScrollBar;
    //property Visible: Boolean read GetVisible;
    property Active;
    //property Align;
    //property Color;
    //property Font;
    //property StartPoint;
}    property Comport: TPjhComLed read FComport write SetComport;

  end;

  TpjhProcess = class(TCustomLogicNode)
  private
    function GetCursor: TCursor;
    function GetHelpContext: THelpContext;
    function GetHelpKeyWord: String;
    function GetHelpType: THelpType;
    function GetHint: String;
    function GetTag: Longint;
  published
    property Cursor: TCursor read GetCursor;
    property HelpContext: THelpContext read GetHelpContext;
    property HelpKeyWord: String read GetHelpKeyWord;
    property HelpType: THelpType read GetHelpType;
    property Hint: String read GetHint;
    property Tag: Longint read GetTag;
    property NextStep;
  end;

  TpjhProcess2 = class(TCustomLogicTransition)
  private
    function GetCursor: TCursor;
    function GetHelpContext: THelpContext;
    function GetHelpKeyWord: String;
    function GetHelpType: THelpType;
    function GetHint: String;
    function GetTag: Longint;
  published
    property Cursor: TCursor read GetCursor;
    property HelpContext: THelpContext read GetHelpContext;
    property HelpKeyWord: String read GetHelpKeyWord;
    property HelpType: THelpType read GetHelpType;
    property Hint: String read GetHint;
    property Tag: Longint read GetTag;
    property FromStep;
    property ToStep;
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

    function GetCursor: TCursor;
    function GetHelpContext: THelpContext;
    function GetHelpKeyWord: String;
    function GetHelpType: THelpType;
    function GetHint: String;
    function GetTag: Longint;
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
    property Cursor: TCursor read GetCursor;
    property HelpContext: THelpContext read GetHelpContext;
    property HelpKeyWord: String read GetHelpKeyWord;
    property HelpType: THelpType read GetHelpType;
    property Hint: String read GetHint;
    property Tag: Longint read GetTag;
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
    function GetCursor: TCursor;
    function GetHelpContext: THelpContext;
    function GetHelpKeyWord: String;
    function GetHelpType: THelpType;
    function GetHint: String;
    function GetTag: Longint;
  published
    property Cursor: TCursor read GetCursor;
    property HelpContext: THelpContext read GetHelpContext;
    property HelpKeyWord: String read GetHelpKeyWord;
    property HelpType: THelpType read GetHelpType;
    property Hint: String read GetHint;
    property Tag: Longint read GetTag;
    property NextStep;
    property Direction;
  end;

  TpjhStartControl = class(TCustomLogicStart)
  private
    function GetCursor: TCursor;
    function GetHelpContext: THelpContext;
    function GetHelpKeyWord: String;
    function GetHelpType: THelpType;
    function GetHint: String;
    function GetTag: Longint;
  published
    property Cursor: TCursor read GetCursor;
    property HelpContext: THelpContext read GetHelpContext;
    property HelpKeyWord: String read GetHelpKeyWord;
    property HelpType: THelpType read GetHelpType;
    property Hint: String read GetHint;
    property Tag: Longint read GetTag;
    property NextStep;
  end;

  TpjhStopControl = class(TCustomLogicStop)
  private
    function GetCursor: TCursor;
    //function GetHeight: Integer;
    function GetHelpContext: THelpContext;
    function GetHelpKeyWord: String;
    function GetHelpType: THelpType;
    function GetHint: String;
    //function GetLeft: Integer;
    function GetTag: Longint;
    //function GetTop: Integer;
    //function GetWidth: Integer;
  published
    property Cursor: TCursor read GetCursor;
    //property Height: Integer read GetHeight;
    property HelpContext: THelpContext read GetHelpContext;
    property HelpKeyWord: String read GetHelpKeyWord;
    property HelpType: THelpType read GetHelpType;
    property Hint: String read GetHint;
    //property Left: Integer read GetLeft;
    property Tag: Longint read GetTag;
    //property Top: Integer read GetTop;
    //property Width: Integer read GetWidth;
  end;

  TpjhWriteComport = class( TpjhProcess )
  private
    FComport: TPjhComLed;
    FWriteDataType: TCommDataType;
    FWriteBuffer4String: TStrings;
    FDelimiter: Char;
    FLoadFromFile: TDataFile;
    FFAMemMan: TpjhFAMemMan;
    FMemIndex : integer;       // PLC에서 가져온 데이타를 보관할 메모리 위치
    FMemName  : TMemName;      //                  "                    종류
    //FWriteBuffer4Byte: array of byte;
  protected
    function GetDataType: TCommDataType;
    procedure SetDataType(const Value: TCommDataType);
    procedure SetLines(Value: TStrings);
    procedure SetComPort(const Value: TPjhComLed);
    function GetDelimiter: TDelimiter;
    procedure SetDelimiter(const Value: TDelimiter);
    procedure SetFAMemMan(mm:TpjhFAMemMan);
    procedure SetMemName(A: TMemName);
    procedure SetLoadFromFile(Value: TDataFile);

    procedure WriteData2Comport;
    procedure WriteData2MemMan(Data: String);

    procedure WriteDecimalData;
    procedure WriteHexaDecimalData;
    procedure WriteDecimalData2MemMan(Data: integer);
    procedure WriteHexaDecimalData2MemMan(Data: integer);

    procedure DoOnEnter; override;
  published
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property LoadFromFile: TDataFile read FLoadFromFile write SetLoadFromFile;
    property Comport: TPjhComLed read FComport write SetComport;
    property Delimiter: TDelimiter read GetDelimiter write SetDelimiter;
    property WriteDataType: TCommDataType read GetDataType write SetDataType;
    property WriteData: TStrings read FWriteBuffer4String write SetLines;
    property FAMemoryManager: TpjhFAMemMan read FFAMemMan write SetFAMemMan;
    property FAMemName: TMemName read FMemName write SetMemName;
    property FAMemIndex: Integer read FMemIndex write FMemIndex;
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
    FFAMemMan: TpjhFAMemMan;
    FMemIndex : integer;       // PLC에서 가져온 데이타를 보관할 메모리 위치
    FMemName  : TMemName;      //                  "                    종류
    FReadDataIndex: integer;    // FA MEM에 기록할 FReadBuffer4Byte 의 Index

  protected
    procedure SetDataType(const Value: TCommDataType);
    procedure SetLines(Value: TStrings);
    procedure SetComPort(const Value: TPjhComLed);
    procedure SetCommDataCondition(const Value: TCommDataCondition);
    procedure SetReadDataCount(const Value: integer);
    procedure SetSaveToFile(Value: TDataFile);
    procedure SetFAMemMan(mm:TpjhFAMemMan);
    procedure SetMemName(A: TMemName);
    procedure SetReadDataIndex(const Value: integer);

    procedure ReadDataFromComport;
    procedure ReadStrDataFromComport;
    procedure ReadByteDataFromComport;
    procedure WriteDecimalData2MemMan(Data: integer);

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
    property FAMemoryManager: TpjhFAMemMan read FFAMemMan write SetFAMemMan;
    property FAMemName: TMemName read FMemName write SetMemName;
    property FAMemIndex: Integer read FMemIndex write FMemIndex;
  end;

  TpjhDelay = class(TpjhProcess)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{ TpjhLogicPanel }

procedure TpjhLogicPanel.Execute;
begin
  if Assigned(FComport) then
    if not (FComport.ComPort.Connected) then
      FComport.ComPort.Open;

  inherited;

end;
{
function TpjhLogicPanel.GetAnchors: TAnchors;
begin
  Result := inherited Anchors;
end;

function TpjhLogicPanel.GetAutoScroll: Boolean;
begin
  Result := inherited AutoScroll;
end;

function TpjhLogicPanel.GetAutoSize: Boolean;
begin
  Result := inherited AutoSize;
end;

function TpjhLogicPanel.GetBevelEdges: TBevelEdges;
begin
  Result := inherited BevelEdges;
end;

function TpjhLogicPanel.GetBevelInner: TBevelCut;
begin
  Result := inherited BevelInner;
end;

function TpjhLogicPanel.GetBevelKind: TBevelKind;
begin
  Result := inherited BevelKind;
end;

function TpjhLogicPanel.GetBevelOuter: TBevelCut;
begin
  Result := inherited BevelOuter;
end;

function TpjhLogicPanel.GetBevelWidth: TBevelWidth;
begin
  Result := inherited BevelWidth;
end;

function TpjhLogicPanel.GetBidiMode: TBidiMode;
begin
  Result := inherited BidiMode;
end;

function TpjhLogicPanel.GetBorderStyle: TBorderStyle;
begin
  Result := inherited BorderStyle;
end;

function TpjhLogicPanel.GetConstraints: TMySizeConstraints;
begin
  Result := TMySizeConstraints (inherited Constraints);
end;

function TpjhLogicPanel.GetCtl3D: Boolean;
begin
  Result := inherited Ctl3D;
end;

function TpjhLogicPanel.GetCursor: TCursor;
begin
  Result := inherited Cursor;
end;

function TpjhLogicPanel.GetDockSite: Boolean;
begin
  Result := inherited DockSite;
end;

function TpjhLogicPanel.GetDragCursor: TCursor;
begin
  Result := inherited DragCursor;
end;

function TpjhLogicPanel.GetDragKind: TDragKind;
begin
  Result := inherited DragKind;
end;

function TpjhLogicPanel.GetDragMode: TDragMode;
begin
  Result := inherited DragMode;
end;

function TpjhLogicPanel.GetEnabled: Boolean;
begin
  Result := inherited Enabled;
end;

//function TpjhLogicPanel.GetFont: TFont;
//begin
//  Result := inherited Font;
//end;

function TpjhLogicPanel.GetHelpContext: THelpContext;
begin
  Result := inherited HelpContext;
end;

function TpjhLogicPanel.GetHelpKeyWord: String;
begin
  Result := inherited HelpKeyWord;
end;

function TpjhLogicPanel.GetHelpType: THelpType;
begin
  Result := inherited HelpType;
end;

function TpjhLogicPanel.GetHint: String;
begin
  Result := inherited Hint;
end;

function TpjhLogicPanel.GetHorzScrollBar: TControlScrollBar;
begin
  Result := inherited HorzScrollBar;
end;

function TpjhLogicPanel.GetParentBidiMode: Boolean;
begin
  Result := inherited ParentBidiMode;
end;

function TpjhLogicPanel.GetParentColor: Boolean;
begin
  Result := inherited ParentColor;
end;

function TpjhLogicPanel.GetParentCtl3D: Boolean;
begin
  Result := inherited ParentCtl3D;
end;

//function TpjhLogicPanel.GetParentFont: Boolean;
//begin
//  Result := inherited ParentFont;
//end;

function TpjhLogicPanel.GetParentShowHint: Boolean;
begin
  Result := inherited ParentShowHint;
end;

function TpjhLogicPanel.GetPopupMenu: TPopupMenu;
begin
  Result := inherited PopupMenu;
end;

function TpjhLogicPanel.GetShowHint: Boolean;
begin
  Result := inherited ShowHint;
end;

function TpjhLogicPanel.GetTabOrder: TTabOrder;
begin
  Result := inherited TabOrder;
end;

function TpjhLogicPanel.GetTabStop: Boolean;
begin
  Result := inherited TabStop;
end;

function TpjhLogicPanel.GetTag: Longint;
begin
  Result := inherited Tag;
end;

function TpjhLogicPanel.GetVertScrollBar: TControlScrollBar;
begin
  Result := inherited VertScrollBar;
end;

function TpjhLogicPanel.GetVisible: Boolean;
begin
  Result := inherited Visible;
end;
}
procedure TpjhLogicPanel.SetComPort(const Value: TPjhComLed);
begin
  FComport := Value;
end;

{ TpjhProcess }

function TpjhProcess.GetCursor: TCursor;
begin
  Result := inherited Cursor;
end;

function TpjhProcess.GetHelpContext: THelpContext;
begin
  Result := inherited HelpContext;
end;

function TpjhProcess.GetHelpKeyWord: String;
begin
  Result := inherited HelpKeyWord;
end;

function TpjhProcess.GetHelpType: THelpType;
begin
  Result := inherited HelpType;
end;

function TpjhProcess.GetHint: String;
begin
  Result := inherited Hint;
end;

function TpjhProcess.GetTag: Longint;
begin
  Result := inherited Tag;
end;

{ TpjhProcess2 }

function TpjhProcess2.GetCursor: TCursor;
begin
  Result := inherited Cursor;
end;

function TpjhProcess2.GetHelpContext: THelpContext;
begin
  Result := inherited HelpContext;
end;

function TpjhProcess2.GetHelpKeyWord: String;
begin
  Result := inherited HelpKeyWord;
end;

function TpjhProcess2.GetHelpType: THelpType;
begin
  Result := inherited HelpType;
end;

function TpjhProcess2.GetHint: String;
begin
  Result := inherited Hint;
end;

function TpjhProcess2.GetTag: Longint;
begin
  Result := inherited Tag;
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
//      if Count = 0 then
//      begin
//        for i := 0 to TpjhReadComport(VarControl).ReadDataBuf.Count - 1 do
//          Result := Pos(
//      end
//      else
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

function TpjhIfControl.GetCursor: TCursor;
begin
  Result := inherited Cursor;
end;

function TpjhIfControl.GetHelpContext: THelpContext;
begin
  Result := inherited HelpContext;
end;

function TpjhIfControl.GetHelpKeyWord: String;
begin
  Result := inherited HelpKeyWord;
end;

function TpjhIfControl.GetHelpType: THelpType;
begin
  Result := inherited HelpType;
end;

function TpjhIfControl.GetHint: String;
begin
  Result := inherited Hint;
end;

function TpjhIfControl.GetTag: Longint;
begin
  Result := inherited Tag;
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

{ TpjhGotoControl }

function TpjhGotoControl.GetCursor: TCursor;
begin
  Result := inherited Cursor;
end;

function TpjhGotoControl.GetHelpContext: THelpContext;
begin
  Result := inherited HelpContext;
end;

function TpjhGotoControl.GetHelpKeyWord: String;
begin
  Result := inherited HelpKeyWord;
end;

function TpjhGotoControl.GetHelpType: THelpType;
begin
  Result := inherited HelpType;
end;

function TpjhGotoControl.GetHint: String;
begin
  Result := inherited Hint;
end;

function TpjhGotoControl.GetTag: Longint;
begin
  Result := inherited Tag;
end;

{ TpjhStartControl }

function TpjhStartControl.GetCursor: TCursor;
begin
  Result := inherited Cursor;
end;

function TpjhStartControl.GetHelpContext: THelpContext;
begin
  Result := inherited HelpContext;
end;

function TpjhStartControl.GetHelpKeyWord: String;
begin
  Result := inherited HelpKeyWord;
end;

function TpjhStartControl.GetHelpType: THelpType;
begin
  Result := inherited HelpType;
end;

function TpjhStartControl.GetHint: String;
begin
  Result := inherited Hint;
end;

function TpjhStartControl.GetTag: Longint;
begin
  Result := inherited Tag;
end;

{ TpjhStopControl }

function TpjhStopControl.GetCursor: TCursor;
begin
  Result := inherited Cursor;
end;

function TpjhStopControl.GetHelpContext: THelpContext;
begin
  Result := inherited HelpContext;
end;

function TpjhStopControl.GetHelpKeyWord: String;
begin
  Result := inherited HelpKeyWord;
end;

function TpjhStopControl.GetHelpType: THelpType;
begin
  Result := inherited HelpType;
end;

function TpjhStopControl.GetHint: String;
begin
  Result := inherited Hint;
end;

function TpjhStopControl.GetTag: Longint;
begin
  Result := inherited Tag;
end;

{ TpjhWriteComport }

constructor TpjhWriteComport.Create(AOwner: TComponent);
begin
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

procedure TpjhWriteComport.SetFAMemMan(mm: TpjhFAMemMan);
begin
  FFAMemMan := mm;
end;

procedure TpjhWriteComport.SetLines(Value: TStrings);
begin
  FWriteBuffer4String.Assign(Value);
end;

procedure TpjhWriteComport.SetMemName(A: TMemName);
begin
  if FMemName <> A then
    FMemName := A;
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
          FComport := TPjhComLed(TComponent(Self.Parent).Components[i]);
      end;//for
    end;//else
  end;

  if Assigned(FComport) then
  begin
    if not (FComport.ComPort.Connected) then
      FComport.ComPort.Open;

    if FComport.ComPort.Connected then
    begin
      case FWriteDataType of
        cdtString:
          begin
            if (FLoadFromFile.FEnabled) and (FLoadFromFile.FFileName <> '') then
            begin
              FWriteBuffer4String.Clear;
              FWriteBuffer4String.LoadFromFile(FLoadFromFile .FFileName);
            end;
            
            for i := 0 to FWriteBuffer4String.Count - 1 do
            begin
              str1 := FWriteBuffer4String.Strings[i];
              while str1 <> '' do
              begin
                str2 := strToken(Str1, FDelimiter);
                FComport.ComPort.WriteStr(str2);
                WriteData2MemMan(Str2);
              end;//while
            end;//for
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

//정수로 구성된 문자를 Byte로 변환하여 시리얼 포트로 전송함
procedure TpjhWriteComport.WriteData2MemMan(Data: String);
begin
;
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
          FComport.ComPort.Write(FBuffer[0],Size);
          WriteDecimalData2MemMan(StrToInt(str2));
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

//헥사로 구성된 문자를 Byte로 변환하여 시리얼 포트로 전송함
//두개의 문자가 한 Byte를 구성함
procedure TpjhWriteComport.WriteDecimalData2MemMan(Data: integer);
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

procedure TpjhWriteComport.WriteHexaDecimalData2MemMan(Data: integer);
begin
;
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
              FComport.ComPort.Write(FBuffer[0],Size);
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
    if (FLoadFromFile.FEnabled) and (FLoadFromFile.FFileName <> '') then
    begin
      FWriteBuffer4String.Clear;
      FWriteBuffer4String.LoadFromFile(FLoadFromFile .FFileName);
    end;
  end;
end;

{ TpjhReadComport }

constructor TpjhReadComport.Create(AOwner: TComponent);
begin
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
          FComport := TPjhComLed(TComponent(Self.Parent).Components[Len]);
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
                  WriteDecimalData2MemMan(FReadBuffer4Byte.Items[ReadDataIndex]);
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
    if not (FComport.ComPort.Connected) then
      FComport.ComPort.Open;

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

procedure TpjhReadComport.SetFAMemMan(mm: TpjhFAMemMan);
begin
  FFAMemMan := mm;
end;

procedure TpjhReadComport.SetMemName(A: TMemName);
begin
  if FMemName <> A then
    FMemName := A;
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

procedure TpjhReadComport.WriteDecimalData2MemMan(Data: integer);
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

{ TCompareData }

procedure TCompareData.SetData(Value: string);
begin
  case FDataType of
    cdtString,
    cdtDecimal,
    cdtHexaDecimal: FData := Value;
  end;//case
end;

{ TpjhDelay }

constructor TpjhDelay.Create(AOwner: TComponent);
begin
  inherited;

  DiagramType := dtDelay;
end;

{ TDataFile }

function TDataFile.GetFileName: TFileNameDlgClass;
begin
  Result := TFileNameDlgClass(FFileName);
end;

procedure TDataFile.SetFileName(const Value: TFileNameDlgClass);
begin
  FFileName := String(Value);
end;

end.
