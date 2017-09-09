unit CommLogic_old;
// -----------------------------------------------------------------------------
// Project:	State Machine
// Module:	statmach
// Description: Visual Finite State Machine.
// Version:	1.1
// Release:	3
// Date:	9-MAY-1998
// Target:	Delphi 2 & 3. Not tested with Delphi 1.
// Author(s):	anme: Anders Melander, anders@melander.dk
// Copyright	(c) 1997,98 by Anders Melander
// Formatting:	2 space indent, 8 space tabs, 80 columns.
// -----------------------------------------------------------------------------
// This software is copyrighted as noted above.  It may be freely copied,
// modified, and redistributed, provided that the copyright notice(s) is
// preserved on all copies.
//
// There is no warranty or other guarantee of fitness for this software,
// it is provided solely "as is".  Bug reports or fixes may be sent
// to the author, who may or may not act on them as he desires.
//
// You may not include this software in a program or other software product
// without supplying the source, or without informing the end-user that the
// source is available for no extra charge.
//
// If you modify this software, you should include a notice in the "Revision
// history" section giving the name of the person performing the modification,
// the date of modification, and the reason for such modification.
// -----------------------------------------------------------------------------
// Revision history:
//
// 0000	130298	anme	- Released for internal use.
//
// 0001	130298	anme	- Released for public beta.
//
// 0100	280398	anme	- Implemented TStateConnector persistence.
//			- Many small design time bugs fixed.
//			- Implemented soSingleStep option.
//			- Released as version 1.0
//
// 0101	090598	anme	- Fixed design time TStateConnector editor with help
//			  from Filip Larsen.
//
// -----------------------------------------------------------------------------
// To do (in rough order of priority):
// * Implement "state blocks".
//   I imagine a state block as being a state machine encapsulated in a
//   "black box".
// * Implement TStateLoopBegin and TStateLoopEnd for loop control.
// -----------------------------------------------------------------------------
interface

uses
  ExtCtrls, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ScrollPanel;

// Windows message used to initiate state transitions
const
  CL_STATE_TRANSITION = WM_USER;

type
  TCustomLogicPanel = class;
  TCustomLogicControl = class;
  TCustomLogicConnector = class;

  // Type of the OnChangeState event
  TChangeStateEvent = procedure(Sender: TCustomLogicPanel;
    FromState, ToState: TCustomLogicControl) of object;

  // Type of the OnException event
  TStateExceptionEvent = procedure(Sender: TCustomLogicPanel; Node: TCustomLogicControl;
    Error: Exception) of object;

  // Run-time options:
  //
  //   soInteractive
  //			If set, the TCustomLogicPanel will be visible at run-time.
  //			The current state will be painted in red and bold.
  //
  //   soSingleStep
  //			If set, the execution will stop after each transition.
  //			Use the Execute method to resume execution.
  //
  //   soVerifyTransitions
  //			If set, transitions (TCustomLogicTransition) will verify their
  //			source states when executed.
  //			An attempt to move through a transition from a state
  //			other than the one specified as the "FromState" will
  //			cause an exception to be raised.
  //			If the transition does not specify a "FromState", the
  //			transition will not be validated.
  //
  TCustomLogicPanelOption = (soInteractive, soSingleStep, soVerifyTransitions);
  TCustomLogicPanelOptions = set of TCustomLogicPanelOption;

  TDesignMove = (dmSource, dmFirstHandle, dmOffset, dmLastHandle, dmDestination, dmNone);
  TConnectorLines = array[dmSource..dmDestination] of TPoint;

  TCustomLogicPanel = class(TCustomAdvancedScroller_pjh)
  private
    FState: TCustomLogicControl;
    FInitialState: TCustomLogicControl;//Reset이 True일때 시작되는 State를 가리킴
    FOnChangeState: TChangeStateEvent;
    FOnException: TStateExceptionEvent;
    FActive: boolean;
    StateChanged: boolean;
    FConnector: TCustomLogicConnector;
    FDesignMoving: TDesignMove;
    Lines: TConnectorLines;
    FStopSignalled: Boolean;
    FOptions: TCustomLogicPanelOptions;
    FStartExec: Boolean;//True이면 실행됨
    FReset: Boolean;//True이면 Execute시에 처음(TCustomLogicPanel의 State
  protected
    procedure SetState(Value :TCustomLogicControl);
    procedure SetInitialState(Value :TCustomLogicControl);
    procedure SetStartExec(Value :Boolean);
    procedure SetReset(Value :Boolean);
    procedure DoSetState(Value :TCustomLogicControl);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DoOnChangeState(FromState, ToState: TCustomLogicControl); dynamic;
    procedure DoOnException(Node: TCustomLogicControl; E: Exception); dynamic;
    procedure SMStateTransition(var Message: TMessage); message CL_STATE_TRANSITION;
    procedure CMDesignHitTest(var Msg: TWMMouse); message cm_DesignHitTest;
    property Active: boolean read FActive write FActive default False;
    property StartExec: boolean read FStartExec write SetStartExec default False;
    property State: TCustomLogicControl read FState write SetState;
    property StopSignalled: Boolean read FStopSignalled;
    property OnChangeState: TChangeStateEvent read FOnChangeState write FOnChangeState;
    property OnException: TStateExceptionEvent read FOnException write FOnException;
  public
    procedure Execute; virtual;
    procedure Stop;
    procedure ChangeState(Transition: TCustomLogicControl);
    procedure PostStateChange(State: TCustomLogicControl);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Options: TCustomLogicPanelOptions read FOptions write FOptions;
  published
    property StartPoint: TCustomLogicControl read FInitialState write SetInitialState;
    property Reset: boolean read FReset write SetReset default False;
    property Align;
    property Color;
    property Font;

  end;

  TTransitionDirection = (tdFrom, tdTo);
  TVisualElement = (veShadow, veFrame, vePanel, veText, veConnector);
  TStatePathOwner = (poOwnedBySource, poOwnedByDestination);
  TDiagramType = (dtDefault, dtStart, dtStop, dtProcess, dtIf, dtData, dtInput, dtOutput, dtDelay);

  TCustomLogicControl = class(TGraphicControl)
  private
    { Private declarations }
    FStateMachine: TCustomLogicPanel;
    FConnectors: TList;
    FDiagramType: TDiagramType;
    FRoundSize: integer;
    //FCaption: string;
    procedure ReadConnectors(Reader: TReader);
    procedure WriteConnectors(Writer: TWriter);
  protected
    { Protected declarations }
    procedure CMTextChanged (var msg: TMessage); message CM_TEXTCHANGED;
    procedure DefineProperties(Filer: TFiler); override;
    procedure SetHint(Value: string);
    function GetHint: string;
    procedure SetCaption(Value: string);
    procedure SetActive(Value: boolean); virtual;
    function GetActive: boolean; virtual;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetDiagramType(Value: TDiagramType);
    procedure SetRoundSize(Value: integer);

    procedure Click; override;
    function GetCheckStateMachine: TCustomLogicPanel;
    property CheckStateMachine: TCustomLogicPanel read GetCheckStateMachine;
    procedure Paint; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure DoOnEnter; virtual;
    procedure DoOnExit; virtual;
    function DoDefault: Boolean; virtual;
    procedure PrepareCanvas(Element: TVisualElement; Canvas: TCanvas); virtual;
    procedure DrawText(TextRect: TRect); virtual;
    procedure DoPaint; virtual;
    function AddConnector(OwnerRole: TStatePathOwner): TCustomLogicConnector;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property StateMachine: TCustomLogicPanel read FStateMachine;
    procedure PaintConnector; virtual;
    function HitTest(Mouse: TPoint): TCustomLogicConnector; virtual;
    procedure CheckTransition(Transition: TCustomLogicControl; Direction: TTransitionDirection); virtual;
    property Active: boolean read GetActive write SetActive default False;
    property Connectors: TList read FConnectors;
    property DiagramType: TDiagramType read FDiagramType write SetDiagramType;
    property RoundSize: integer read FRoundSize write SetRoundSize;
  published
    property Hint: string read GetHint write SetHint;
    //property Caption: string read FCaption write SetCaption;
    property Caption;
  end;

  // Yeah, I know!
  TCustomLogicNodeBase = class(TCustomLogicControl)
  protected
    procedure SetParent(AParent: TWinControl); override;
  end;

  TStatePath = (spAuto, spDirect, spLL, spLR, spLT, spLB, spRL, spRR, spRT, spRB,
                spTL, spTR, spTT, spTB, spBL, spBR, spBT, spBB);

  TCustomLogicConnector = class(TObject)
  private
    FSelected: Boolean;
    FOffset: integer;
    FPath: TStatePath;
    FActualPath: TStatePath;
    FOwner: TStatePathOwner;
    FSource: TCustomLogicControl;
    FDestination: TCustomLogicControl;
    BoundsRect: TRect;
  protected
    procedure SetPeer(Index: integer; Value: TCustomLogicControl);
    function GetPeer(Index: integer): TCustomLogicControl;
  public
    constructor Create(AOwner: TCustomLogicControl; OwnerRole: TStatePathOwner);
    //destructor Destroy; override;
    procedure Paint;
    procedure PaintFlipLine;
    function HitTest(Mouse: TPoint): Boolean;
    function GetLines(var Lines: TConnectorLines): Boolean;
    class function MakeRect(pa, pb: TPoint): TRect;
    class function RectCenter(r: TRect): TPoint;
    property Source: TCustomLogicControl index 1 read FSource write SetPeer;
    property Destination: TCustomLogicControl index 2 read FDestination write SetPeer;
    property PeerNode: TCustomLogicControl index 0 read GetPeer write SetPeer;
    property ActualPath: TStatePath read FActualPath;
    property Selected: Boolean read FSelected write FSelected;
  published
    property Path: TStatePath read FPath write FPath;
    property Offset: integer read FOffset write FOffset;
  end;

  TCustomLogicBoolean = class;
  TBooleanStateEvent = procedure(Sender: TCustomLogicBoolean; var Result: Boolean) of Object;

  TCustomLogicBoolean = class(TCustomLogicNodeBase)
  private
    { Private declarations }
    FOnEnterState: TBooleanStateEvent;
    FOnExitState: TNotifyEvent;
    FTrueState: TCustomLogicControl;
    FFalseState: TCustomLogicControl;
    FTrueConnector: TCustomLogicConnector;
    FFalseConnector: TCustomLogicConnector;
    FResult: Boolean;
    FDefault: Boolean;
    FBeforeDelay,
    FAfterDelay: Longint;
  protected
    { Protected declarations }
    procedure DoPaint; override;
    procedure PrepareCanvas(Element: TVisualElement; Canvas: TCanvas); override;
    procedure SetTrueState(Value :TCustomLogicControl);
    procedure SetFalseState(Value :TCustomLogicControl);
    procedure SetDefault(Value :Boolean);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure DoOnEnter; override;
    procedure DoOnExit; override;
    function DoDefault: Boolean; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PaintConnector; override;
    function HitTest(Mouse: TPoint): TCustomLogicConnector; override;

    property OnEnterState: TBooleanStateEvent read FOnEnterState write FOnEnterState;
    property OnExitState: TNotifyEvent read FOnExitState write FOnExitState;
    property DefaultState: Boolean read FDefault write SetDefault default True;
  published
    { Published declarations }
    property TrueStep: TCustomLogicControl read FTrueState write SetTrueState;
    property FalseStep: TCustomLogicControl read FFalseState write SetFalseState;
    property BeforeDelay: LongInt read FBeforeDelay write FBeforeDelay default 0;
    property AfterDelay: LongInt read FAfterDelay write FAfterDelay default 0;
  end;

  TCustomLogicNode = class(TCustomLogicNodeBase)
  private
    { Private declarations }
    FOnEnterState: TNotifyEvent;
    FOnExitState: TNotifyEvent;
    FDefaultTransition: TCustomLogicControl;
    FToConnector: TCustomLogicConnector;
    FBeforeDelay,
    FAfterDelay: Longint;
  protected
    { Protected declarations }
    procedure PrepareCanvas(Element: TVisualElement; Canvas: TCanvas); override;
    procedure SetDefaultTransition(Value: TCustomLogicControl);
    procedure SetNextState(Value :TCustomLogicControl);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure DoOnEnter; override;
    procedure DoOnExit; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    function DoDefault: Boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PaintConnector; override;
    function HitTest(Mouse: TPoint): TCustomLogicConnector; override;
    // NextState is obsolete!
    property NextState: TCustomLogicControl read FDefaultTransition write SetNextState stored False;
  published
    { Published declarations }
    property OnEnterState: TNotifyEvent read FOnEnterState write FOnEnterState;
    property OnExitState: TNotifyEvent read FOnExitState write FOnExitState;
    property NextStep: TCustomLogicControl read FDefaultTransition write SetDefaultTransition;
    property BeforeDelay: LongInt read FBeforeDelay write FBeforeDelay default 0;
    property AfterDelay: LongInt read FAfterDelay write FAfterDelay default 0;
  end;

  TCustomLogicStart = class(TCustomLogicNode)
  protected
    { Protected declarations }
    procedure PrepareCanvas(Element: TVisualElement; Canvas: TCanvas); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TCustomLogicStop = class(TCustomLogicControl)
  protected
    { Protected declarations }
    procedure PrepareCanvas(Element: TVisualElement; Canvas: TCanvas); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TCustomLogicTransition = class(TCustomLogicControl)
  private
    { Private declarations }
    FFromState: TCustomLogicControl;
    FToState: TCustomLogicControl;
    FOnTransition: TNotifyEvent;
    FToConnector: TCustomLogicConnector;
    FFromConnector: TCustomLogicConnector;
  protected
    { Protected declarations }
    procedure DoPaint; override;
    procedure PrepareCanvas(Element: TVisualElement; Canvas: TCanvas); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetFromState(Value :TCustomLogicControl);
    procedure SetToState(Value :TCustomLogicControl);
    procedure DoOnEnter; override;
    function DoDefault: Boolean; override;
    procedure CheckTransition(Transition: TCustomLogicControl; Direction: TTransitionDirection); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PaintConnector; override;
    function HitTest(Mouse: TPoint): TCustomLogicConnector; override;
  published
    { Published declarations }
    property FromStep: TCustomLogicControl read FFromState write SetFromState;
    property ToStep: TCustomLogicControl read FToState write SetToState;
    property OnTransition: TNotifyEvent read FOnTransition write FOnTransition;
  end;

  TLinkDirection = (ldIncoming, ldOutgoing);

  TCustomLogicLinkBase = class(TCustomLogicControl)
  end;

  TCustomLogicLink = class(TCustomLogicLinkBase)
  private
    { Private declarations }
    FDestination: TCustomLogicControl;
    FConnector: TCustomLogicConnector;
    FDirection: TLinkDirection;
  protected
    { Protected declarations }
    procedure PrepareCanvas(Element: TVisualElement; Canvas: TCanvas); override;
    procedure DoPaint; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetDestination(Value :TCustomLogicControl);
    procedure SetDirection(Value :TLinkDirection);
    function DoDefault: Boolean; override;
    procedure CheckTransition(Transition: TCustomLogicControl; Direction: TTransitionDirection); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PaintConnector; override;
    function HitTest(Mouse: TPoint): TCustomLogicConnector; override;

    property NextStep: TCustomLogicControl read FDestination write SetDestination;
    property Direction: TLinkDirection read FDirection write SetDirection;
  published
    { Published declarations }
  end;

//procedure Register;

implementation

{$DEBUGINFO ON}

uses
{$IFDEF DEBUG}
  debugit,
{$ENDIF}
  TypInfo;

{$IFNDEF DEBUG}
procedure DebugStr(s: string);
begin
end;
{$ENDIF}


const
  ShadowHeight = 2;
  OverlapXMargin = 10;
  OverlapYMargin = 10;
  SelectMarginX = 4;
  SelectMarginY = 4;
  DefaultMargin = 20;//add 2004.1.20 도형위치 변경시 자동으로 더해지는 수치

//******************************************************************************
//**
//**			Component Registration
//**
//******************************************************************************
(*
type
  TConnectorProperty = class(TClassProperty)
  protected
    Connector: TCustomLogicConnector;
  public
    procedure GetProperties(Proc: TGetPropEditProc); override;
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

function TConnectorProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paSubProperties, paValueList, paSortList];
end;

procedure TConnectorProperty.GetProperties(Proc: TGetPropEditProc);
var
  I: Integer;
  Components: TComponentList;
  StateControl: TCustomLogicControl;
begin
  Components := TComponentList.Create;
  try
    StateControl := TCustomLogicControl(GetOrdValue);
    // Find all properties of type
function GetPropList(TypeInfo: PTypeInfo; TypeKinds: TTypeKinds;
  PropList: PPropList): Integer;
    Components.Add(TComponent(GetOrdValueAt(I)));
    GetComponentProperties(Components, tkProperties, Designer, Proc);
  finally
    Components.Free;
  end;
end;

procedure TConnectorProperty.GetValues(Proc: TGetStrProc);
begin
  Designer.GetComponentNames(GetTypeData(TypeInfo(TCustomLogicControl)), Proc);
end;

function TConnectorProperty.GetValue: string;
begin
  if (TCustomLogicConnector(GetOrdValue).PeerNode <> nil) then
    FmtStr(Result, '(%s)', [TCustomLogicControl(GetOrdValue).Name])
  else
    Result := '';
end;

procedure TConnectorProperty.SetValue(const Value: string);
var
  Component: TComponent;
begin
  if Value = '' then Component := nil else
  begin
    Component := Designer.GetComponent(Value);
    if not (Component is TCustomLogicControl) then
      raise EPropertyError.Create(SInvalidPropertyValue);
  end;
  SetOrdValue(LongInt(Component));
end;
*)
//procedure Register;
//begin
//  RegisterComponents('Logic',
//    [TCustomLogicPanel, TCustomLogicNode, TCustomLogicTransition, TCustomLogicBoolean, TCustomLogicLink,
//     TCustomLogicStart, TCustomLogicStop]);
//  RegisterPropertyEditor(TypeInfo(TCustomLogicControl), TCustomLogicControl, '', TConnectorProperty);
//end;

//******************************************************************************
//**
//**			TCustomLogicPanel
//**
//******************************************************************************
constructor TCustomLogicPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle-[csSetCaption, csReplicatable]+[csDesignInteractive];
  FDesignMoving := dmNone;
  BevelInner := bvLowered;
  BorderStyle := bsSingle;
  FOptions := [soVerifyTransitions, soInteractive];//designer때문에 soInteractive 추가함
  Visible := (soInteractive in FOptions);
  FActive := False;
end;

destructor TCustomLogicPanel.Destroy;
begin
  inherited Destroy;
end;

procedure TCustomLogicPanel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent is TCustomLogicControl) and (TCustomLogicControl(AComponent).StateMachine = self) then
    case Operation of
      opRemove:
        begin
          Invalidate;
//        FConnector: TCustomLogicConnector;
        end;
    end;
end;

procedure TCustomLogicPanel.Execute;
var
  InitialState		: TCustomLogicControl;
begin
  if (State = nil) then
    raise Exception.Create('No initial state specified');

  InitialState := FState;
  FState := nil;
  FActive := True;
  FStopSignalled := False;
  SetState(InitialState);
end;

procedure TCustomLogicPanel.Stop;
begin
  FStopSignalled := True;
//  Active := False;
  Application.ProcessMessages;
end;

procedure TCustomLogicPanel.SetState(Value :TCustomLogicControl);
begin
  if (Active) and ([csLoading, csDesigning] * ComponentState = []) then
    DoOnChangeState(State, Value);
  DoSetState(Value);
//  PostStateChange(Value);
end;

procedure TCustomLogicPanel.SetStartExec(Value: Boolean);
begin
  if FStartExec <> Value then
    FStartExec := Value;

  if FStartExec then
    Execute
  else
    Stop;
end;

procedure TCustomLogicPanel.SetReset(Value: Boolean);
begin
  if FReset <> Value then
    FReset := Value;

  if (FReset) and Assigned(FInitialState) then
  begin
    State := FInitialState;
    FReset := False;
  end;//if
end;

procedure TCustomLogicPanel.DoSetState(Value :TCustomLogicControl);
var
  OldState		: TCustomLogicControl;
begin
  if (Value <> nil) and (Value.FStateMachine <> self) then
    raise Exception.Create('Cannot change to state in other state machine');

  OldState := FState;
  FState := Value;

  // Repaint old and new state
  if (OldState <> nil) then
  begin
    OldState.Invalidate;
    OldState.Update;
  end;

  if (FState <> nil) then
  begin
    FState.Invalidate;
    FState.Update;
  end;

  if not(Active) then
    exit;

  // State change without transition
  if ([csLoading, csDesigning] * ComponentState = []) then
  begin
    if (OldState <> nil) then
      try
        OldState.DoOnExit;
      except
        on E: Exception do
          DoOnException(OldState, E);
      end;

    if (FStopSignalled) or (State = nil) then
    begin
      Active := False;
      exit;
    end;

    StateChanged := False;
    try
      State.DoOnEnter;
    except
      on E: Exception do
        DoOnException(State, E);
    end;

    if (FStopSignalled) then
    begin
      Active := False;
      exit;
    end;

    if not(StateChanged) then
      if not(State.DoDefault) then
        Active := False;

    if (soSingleStep in FOptions) then
      FStopSignalled := True;

  end;
end;

procedure TCustomLogicPanel.ChangeState(Transition: TCustomLogicControl);
begin
  // State change with transition
  if (Transition = nil) then
    raise Exception.Create('Invalid transition');
  if not(Active) then
    raise Exception.Create('Cannot execute transition in stopped state');

  // Check transitions
  if (soVerifyTransitions in FOptions) then
    try
      State.CheckTransition(Transition, tdFrom);
      Transition.CheckTransition(State, tdTo);
    except
      on E: Exception do
        raise Exception.CreateFmt('Invalid transition from %s to %s:'+#13+'%s',
          [State.Name, Transition.Name, E.Message]);
    end;

  StateChanged := True;

  DoOnChangeState(State, Transition);

  PostStateChange(Transition);
end;

procedure TCustomLogicPanel.PostStateChange(State: TCustomLogicControl);
begin
  PostMessage(Handle, CL_STATE_TRANSITION, 0, LongInt(State));
end;

procedure TCustomLogicPanel.DoOnChangeState(FromState, ToState: TCustomLogicControl);
begin
  if (Assigned(FOnChangeState)) then
    try
      FOnChangeState(self, FromState, ToState);
    except
      on E: Exception do
        DoOnException(nil, E);
    end;
end;

procedure TCustomLogicPanel.DoOnException(Node: TCustomLogicControl; E: Exception);
begin
  if (Assigned(FOnException)) then
    FOnException(self, Node, E)
  else
    raise E;
end;

procedure TCustomLogicPanel.SMStateTransition(var Message: TMessage);
begin
  if (Message.LParam <> 0) then
    DoSetState(TCustomLogicNode(Message.LParam));
end;

procedure TCustomLogicPanel.Paint;
begin
  if (soInteractive in FOptions) or (csDesigning in ComponentState) then
  begin
    inherited Paint;
    if (FDesignMoving in [dmFirstHandle, dmLastHandle]) then
      FConnector.PaintFlipLine;
  end;
end;

procedure TCustomLogicPanel.CMDesignHitTest(var Msg: TWMMouse);
var
  NewPnt		: TPoint;
  i			: integer;
  Connector		: TCustomLogicConnector;

  function TestConnector(Connector: TCustomLogicConnector; p: TPoint): boolean;
  var
    HandleRect		: TRect;
    j			: TDesignMove;
  begin
    Result := False;
    if (Connector = nil) or not(Connector.GetLines(Lines)) then
      exit;

    for j := Low(Lines) to Pred(High(Lines)) do
    begin
      HandleRect := TCustomLogicConnector.MakeRect(Lines[j], Lines[Succ(j)]);
      InflateRect(HandleRect, SelectMarginX, SelectMarginY);
      if (PtInRect(HandleRect, p)) then
      begin
        Result := True;
        exit;
      end;
    end;
  end;

begin
{$IFDEF WIN32}
  NewPnt := SmallPointToPoint(Msg.Pos);
{$ELSE}
  NewPnt := Msg.Pos;
{$ENDIF}
  if (FDesignMoving <> dmNone) then
  begin
    Msg.Result := 1;
    exit;
  end;

  Msg.Result := 0;

  if not(ssLeft in KeysToShiftState(Msg.Keys)) then
    exit;

  if (TestConnector(FConnector, NewPnt)) then
  begin
    Msg.Result := 1;
    exit;
  end;

  for i := 0 to ControlCount-1 do
    if (Controls[i] is TCustomLogicControl) then
    begin
      Connector := (TCustomLogicControl(Controls[i]).HitTest(NewPnt));

      if not(TestConnector(Connector, NewPnt)) then
        continue;

      if (FConnector <> nil) and (FConnector <> Connector) then
      begin
        FConnector.Selected := False;
        Invalidate;
      end;

      FConnector := Connector;
      Connector.Selected := True;
      Connector.Paint;
      Msg.Result := 1;
      exit;
    end;

  if (FConnector <> nil) then
  begin
    FConnector.Selected := False;
    FConnector := nil;
    invalidate;
  end;
end;

procedure TCustomLogicPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i			: TDesignMove;
  HandleRect		: TRect;
  r			: TRect;
begin
  if (csDesigning in ComponentState) and (FConnector <> nil) and
    (FConnector.GetLines(Lines)) then
  begin
    for i := dmFirstHandle to dmLastHandle do
    begin
      if (i = dmOffset) and (FConnector.ActualPath in [spTopLeft, spRightBottom]) then
        continue;
      HandleRect.TopLeft := Lines[i];
      HandleRect.BottomRight := HandleRect.TopLeft;
      InflateRect(HandleRect, SelectMarginX, SelectMarginY);
      if (PtInRect(HandleRect, Point(X,Y))) then
      begin
        FDesignMoving := i;
        MouseCapture := True;
        Canvas.Pen.Width := 3;
        Canvas.Pen.Mode := pmNotXor;
        FConnector.Paint;
        if (FDesignMoving in [dmFirstHandle, dmLastHandle]) then
        begin
          if (Lines[dmDestination].y > Lines[dmSource].y) then
          begin
            if (Lines[dmDestination].x > Lines[dmSource].x) then
              Screen.Cursor := crSizeNESW
            else
              Screen.Cursor := crSizeNWSE;
          end else
          begin
            if (Lines[dmDestination].x > Lines[dmSource].x) then
              Screen.Cursor := crSizeNWSE
            else
              Screen.Cursor := crSizeNESW;
          end;
          FConnector.PaintFlipLine;
        end else
        begin
          { Confine cursor }
          r := FConnector.MakeRect(ClientToScreen(Lines[dmSource]),
            ClientToScreen(Lines[dmDestination]));
          ClipCursor(@r);

          if (FConnector.ActualPath = spLeftRight) then
            Screen.Cursor := crHSplit
          else if (FConnector.ActualPath = spTopBottom) then
            Screen.Cursor := crVSplit;
        end;
        Canvas.Pen.Width := 1;
        Canvas.Pen.Mode := pmCopy;
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Color := clBlack;
        exit;
      end;
    end;//for
  end;//if
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TCustomLogicPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Vector			: TRect;
  NewOffset			: integer;
  NewPath			: TStatePath;
  DoPaint			: Boolean;

  // Function to determine on which side of the vector c1->c2 the point a lies
  function cross(a: TPoint; c: TRect): integer;
  var
    b			: TPoint;
  begin
    a := Point(a.x-c.Left, a.y-c.Top);
    b := Point(c.Right-c.Left, c.Bottom-c.Top);
    Result := (a.x*b.y)-(a.y*b.x);
  end;

  function NewState(OldState: TStatePath; Handle: TDesignMove; Diagonal: TRect;
    OldHandle, NewHandle: TPoint): TStatePath;
  const
    Paths: array[dmFirstHandle..dmLastHandle, spLeftRight..spRightBottom] of TStatePath =
      ((spTopLeft,spRightBottom,spLeftRight,spTopBottom),
       (spTopLeft,spRightBottom,spLeftRight,spTopBottom),//Dummy not used
       (spRightBottom, spTopLeft, spTopBottom, spLeftRight));
  begin
    if (cross(NewHandle, Diagonal)*cross(OldHandle, Diagonal) < 0) then
      Result := Paths[Handle, OldState]
    else
      Result := OldState;
  end;

begin
  if  (csDesigning in ComponentState) and (FDesignMoving <> dmNone) and
    (FConnector <> nil) then
  begin
    DoPaint := False;
    NewOffset := FConnector.Offset;
    NewPath := FConnector.Path;
    if (FDesignMoving in [dmFirstHandle, dmLastHandle]) then
    begin
      Vector.TopLeft :=  TCustomLogicConnector.RectCenter(FConnector.Source.BoundsRect);
      Vector.BottomRight :=  TCustomLogicConnector.RectCenter(FConnector.Destination.BoundsRect);
      NewPath := NewState(FConnector.ActualPath, FDesignMoving, Vector,
        Lines[FDesignMoving], Point(X,Y));
      if (NewPath <> FConnector.ActualPath) then
      begin
        DebugStr('Flip:'+IntToStr(Ord(NewPath)));
        DoPaint := True;
      end else
        DebugStr('Back:'+IntToStr(Ord(FConnector.ActualPath)));
    end else
    begin
      case (FConnector.ActualPath) of
        spLeftRight:
          NewOffset := FConnector.Offset+X-Lines[dmOffset].x;
        spTopBottom:
          NewOffset := FConnector.Offset+Y-Lines[dmOffset].y;
      end;
      DebugStr('Change offset:'+IntToStr(NewOffset));
      if (NewOffset <> FConnector.Offset) then
      begin
        DoPaint := True;
      end;
    end;
    if (DoPaint) then
    begin
      Canvas.Pen.Width := 3;
      Canvas.Pen.Mode := pmNotXor;
      FConnector.Paint;  // Erase previous

      FConnector.Offset := NewOffset;
      FConnector.Path := NewPath;
      FConnector.GetLines(Lines);

      FConnector.Paint; // Paint new
      Canvas.Pen.Width := 1;
      Canvas.Pen.Mode := pmCopy;
    end;
  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TCustomLogicPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
{$IFNDEF VER90}
  Form			: TCustomForm;
{$ELSE}
  Form			: TForm;
{$ENDIF}
begin
  if (csDesigning in ComponentState) and (FDesignMoving <> dmNone) then
  begin
    DebugStr('StateMachine.MouseUp');
    Canvas.Pen.Mode := pmCopy;
    Form := GetParentForm(self);
    if (Form <> nil) and (Form.Designer <> nil) then
      Form.Designer.Modified;
    FDesignMoving := dmNone;
    Screen.Cursor := crDefault;
    ClipCursor(nil);
    MouseCapture := false;
    Invalidate;
  end;
  inherited MouseUp(Button, Shift, X, Y);
  Repaint;
end;

//******************************************************************************
//**
//**			TCustomLogicConnector
//**
//******************************************************************************
constructor TCustomLogicConnector.Create(AOwner: TCustomLogicControl; OwnerRole: TStatePathOwner);
begin
  inherited Create;
  FOwner := OwnerRole;
  if (FOwner = poOwnedBySource) then
    FSource := AOwner
  else
    FDestination := AOwner;
  FPath := spAuto;
  FActualPath := FPath;
end;

//destructor TCustomLogicConnector.Destroy;
//begin
//  inherited;
//end;

procedure TCustomLogicConnector.SetPeer(Index: integer; Value: TCustomLogicControl);
begin
  if ((Index = 1) and (FOwner = poOwnedBySource)) or
    ((Index = 2) and (FOwner = poOwnedByDestination)) then
    raise Exception.Create('Cannot modify owner of connector');
  case (Index) of
    0: if (FOwner = poOwnedBySource) then
         FDestination := Value
       else
         FSource := Value;
    1: FSource := Value;
    2: FDestination := Value;
  end;
end;

function TCustomLogicConnector.GetPeer(Index: integer): TCustomLogicControl;
begin
  if (FOwner = poOwnedBySource) then
    Result := FDestination
  else
    Result := FSource;
end;

function TCustomLogicConnector.GetLines(var Lines: TConnectorLines): Boolean;
var
  OverlapX		,
  OverlapY		: Boolean;
  p1			,
  p2			: TPoint;
  r1			,
  r2			: TRect;
  dx			,
  dy			: integer;
  d2x			,
  d2y			: integer;
  DirectionX		,
  DirectionY		: integer;
//                   +--------+
//                   |  Dest  |
//                d1 |   p2   | ^
//                   |        | |
//                   +--------+ |
//          ^            d2     |
//          |                   |
//         d2y                  |
//          |                   dy
//     s2   v                   |
// +--------+<--d2x->           |
// | Source |                   |
// |   p1   | s1                v
// |        |
// +--------+
//      <------- dx ----->

  function Min(a,b: integer): integer;
  begin
    if (a <= b) then
      Result := a
    else
      Result := b;
  end;

  function Max(a,b: integer): integer;
  begin
    if (a >= b) then
      Result := a
    else
      Result := b;
  end;

begin
  if (Source = nil) or (Destination = nil) then
  begin
    Result := False;
    exit;
  end;

  Result := True;

  r1 := Source.BoundsRect;
  r2 := Destination.BoundsRect;
  p1 := Point(r1.Left+Source.Width DIV 2,r1.Top+(Source.Height) DIV 2);
  p2 := Point(r2.Left+Destination.Width DIV 2,r2.Top+Destination.Height DIV 2);

  dx := p2.x-p1.x;
  dy := p2.y-p1.y;

  if (dx = 0) then
    DirectionX := 0
  else
    DirectionX := dx DIV ABS(dx);

  if (dy = 0) then
    DirectionY := 0
  else
    DirectionY := dy DIV ABS(dy);

  d2x := ABS(dx)-(Source.Width+Destination.Width) DIV 2;
  d2y := ABS(dy)-(Source.Height+Destination.Height) DIV 2;

  OverlapX := (d2x <= OverlapXMargin);
  OverlapY := (d2y <= OverlapYMargin);

  FActualPath := Path;
  // Switch to auto if position makes path impossible
  //comment 2004.1.19 처음 시작할 때 한번만 spAuto이면 됨
  {if ((ActualPath = spRightBottom) and
      ((ABS(dx) - (Source.Width DIV 2) < OverlapXMargin) or
       (d2y + (Source.Height DIV 2) < OverlapYMargin)) or
     ((ActualPath = spTopLeft) and
      ((ABS(dy) - (Source.Height DIV 2) < OverlapYMargin) or
       (d2x + (Source.Width DIV 2) < OverlapXMargin)))) then
    FActualPath := spAuto;
  }
  if (ActualPath in [spAuto, spDirect]) then
  begin
    if (OverlapY) or (d2x > d2y) then
      //FActualPath := spLeftRight
      Path := spLeftRight
    else
      //FActualPath := spTopBottom;
      Path := spTopBottom;
  end;
  //end else

  FActualPath := Path;

  case ActualPath of
    spLeftRight,
    spRightBottom:
      if (DirectionX > 0) then
        Lines[dmSource] := Point(r1.Right+1, p1.y)
      else if (DirectionX < 0) then
        Lines[dmSource] := Point(r1.Left-1, p1.y)
      else
        Lines[dmSource] := p1;
    spTopBottom,
    spTopLeft:
      if (DirectionY > 0) then
        Lines[dmSource] := Point(p1.x, r1.Bottom+1)
      else if (DirectionY < 0) then
        Lines[dmSource] := Point(p1.x, r1.Top-1)
      else
        Lines[dmSource] := p1;
  end;

  case ActualPath of
    spLeftRight,
    spTopLeft:
      if (DirectionX > 0) then
        Lines[dmDestination] := Point(r2.Left-1, p2.y)
      else if (DirectionX < 0) then
        Lines[dmDestination] := Point(r2.Right+1, p2.y)
      else
        Lines[dmDestination] := p2;
    spTopBottom,
    spRightBottom:
      if (DirectionY > 0) then
        Lines[dmDestination] := Point(p2.x, r2.Top-1)
      else if (DirectionY < 0) then
        Lines[dmDestination] := Point(p2.x, r2.Bottom+1)
      else
        Lines[dmDestination] := p2;
  end;

  if (Path = spDirect) then
    FActualPath := spDirect;

  case ActualPath of
    spDirect:
      begin
        dx := (Lines[dmDestination].x-Lines[dmSource].x) DIV 4;
        dy := (Lines[dmDestination].y-Lines[dmSource].y) DIV 4;
        Lines[dmFirstHandle] := Point(Lines[dmSource].x + dx, Lines[dmSource].y + dy);
        Lines[dmOffset] := Point(Lines[dmSource].x + dx*2, Lines[dmSource].y + dy*2);
        Lines[dmLastHandle] := Point(Lines[dmSource].x + dx*3, Lines[dmSource].y + dy*3);
      end;
    spLeftRight:
      begin
        Lines[dmFirstHandle] := Point(Lines[dmSource].x + DirectionX * d2x DIV 2, p1.y);
        Lines[dmLastHandle] := Point(Lines[dmSource].x + DirectionX * d2x DIV 2, p2.y);
      end;
    spTopBottom:
      begin
        if OverlapY then
        begin
          if OverlapX then
          begin//S가 D보다 왼쪽에 있을 경우에만 해당됨
            Lines[dmFirstHandle] := Point(p1.x,
                            Min(r1.Top, r2.Top) + DefaultMargin);
            //Lines[dmSecondHandle] := Point(Min(r1.Right,r2.Right) + DirectionY *DefaultMargin,
            //                      Lines[dmFirstHandle].y);
            Lines[dmLastHandle] := Point(Max(r1.Right,r2.Right) + DefaultMargin,
                                    r2.Bottom + DefaultMargin);
          end
          else
          begin
            Lines[dmFirstHandle] := Point(p1.x, Lines[dmSource].y + DefaultMargin);
            //Lines[dmSecondHandle] := Point(r1.Right + d2x div 2, Lines[dmFirstHandle].y);
            Lines[dmLastHandle] := Point(r1.Right + d2x div 2, Lines[dmFirstHandle].y);
          end;
        end
        else//original routine
        begin
          Lines[dmFirstHandle] := Point(p1.x, Lines[dmSource].y + DirectionY * d2y DIV 2);
          Lines[dmLastHandle] := Point(p2.x, Lines[dmSource].y + DirectionY * d2y DIV 2);
        end;
      end;
    spRightBottom:
      begin
        Lines[dmFirstHandle] := Point(Lines[dmSource].x + (p2.x-Lines[dmSource].x) DIV 2, p1.y);
        Lines[dmLastHandle] := Point(p2.x, Lines[dmDestination].y - (Lines[dmDestination].y - p1.y) DIV 2);
      end;
    spTopLeft:
      begin
        Lines[dmFirstHandle] := Point(p1.x, Lines[dmSource].y + (p2.y-Lines[dmSource].y) DIV 2);
        Lines[dmLastHandle] := Point(Lines[dmDestination].x - (Lines[dmDestination].x - p1.x) DIV 2, p2.y);
      end;
  end;

  case ActualPath of
    spLeftRight:
      begin
        Lines[dmFirstHandle].x := Lines[dmFirstHandle].x + Offset;
        Lines[dmLastHandle].x := Lines[dmFirstHandle].x;
        Lines[dmOffset] := Point(Lines[dmFirstHandle].x,
          Lines[dmFirstHandle].y+(Lines[dmLastHandle].y-Lines[dmFirstHandle].y) DIV 2);
      end;
    spTopLeft:
      Lines[dmOffset] := Point(Lines[dmFirstHandle].x, Lines[dmLastHandle].y);
    spTopBottom:
      begin
        //Lines[dmFirstHandle].y := Lines[dmFirstHandle].y + Offset;
        //Lines[dmLastHandle].y := Lines[dmFirstHandle].y;
        Lines[dmOffset] := Point(Lines[dmFirstHandle].x+(Lines[dmLastHandle].x-Lines[dmFirstHandle].x) DIV 2,
          Lines[dmFirstHandle].y);
      end;
    spRightBottom:
      Lines[dmOffset] := Point(Lines[dmLastHandle].x, Lines[dmFirstHandle].y);
  end;
end;

class function TCustomLogicConnector.MakeRect(pa, pb: TPoint): TRect;
  function Min(a,b: integer): integer;
  begin
    if (a <= b) then
      Result := a
    else
      Result := b;
  end;

  function Max(a,b: integer): integer;
  begin
    if (a >= b) then
      Result := a
    else
      Result := b;
  end;
begin
  Result.TopLeft := Point(Min(pa.x, pb.x), Min(pa.y, pb.y));
  Result.BottomRight := Point(Max(pa.x, pb.x), Max(pa.y, pb.y));
end;

class function TCustomLogicConnector.RectCenter(r: TRect): TPoint;
begin
  Result.x := r.Left+(r.Right-r.Left) DIV 2;
  Result.y := r.Top+(r.Bottom-r.Top) DIV 2;
end;

procedure TCustomLogicConnector.Paint;
var
  Lines			: TConnectorLines;
  Arrow			: array[0..2] of TPoint;
  i			: TDesignMove;
  Direction		: integer;
  Size			: integer;
  SaveWidth		: integer;
  WorkPath		: TStatePath;
//  LogBrush		: TLogBrush;

begin
  if not(GetLines(Lines)) then
    exit;

  with Source.StateMachine.Canvas do
  begin
    Pen.Style := psSolid;
  //Pen.Color := clBlack;

    Brush.Style := bsSolid;
    Brush.Color := Pen.Color;

    Size := Pen.Width DIV 2;
  end;//with

  Arrow[0] := Lines[dmDestination];
  if (ActualPath = spDirect) then
  begin
    if (ABS(Lines[dmDestination].x-Lines[dmSource].x) >
      ABS(Lines[dmDestination].y-Lines[dmSource].y)) then
      WorkPath := spLeftRight
    else
      WorkPath := spTopBottom;
  end else
    WorkPath := ActualPath;

  case WorkPath of
    spLeftRight,
    spTopLeft:
      begin
        Direction := Lines[dmDestination].x-Lines[dmLastHandle].x;
        if (Direction <> 0) then
          Direction := Direction DIV ABS(Direction);

        Lines[dmDestination].x :=
          Lines[dmDestination].x-Source.StateMachine.Canvas.Pen.Width*Direction;
        Arrow[1] := Point(Arrow[0].x-(3+Size)*Direction, Arrow[0].y-(3+Size));
        Arrow[2] := Point(Arrow[0].x-(3+Size)*Direction, Arrow[0].y+(3+Size));
      end;
    spTopBottom,
    spRightBottom:
      begin
        Direction := Lines[dmDestination].y-Lines[dmLastHandle].y;
        if (Direction <> 0) then
          Direction := Direction DIV ABS(Direction);

        Lines[dmDestination].y :=
          Lines[dmDestination].y-Source.StateMachine.Canvas.Pen.Width*Direction;
        Arrow[1] := Point(Arrow[0].x-(3+Size), Arrow[0].y-(3+Size)*Direction);
        Arrow[2] := Point(Arrow[0].x+(3+Size), Arrow[0].y-(3+Size)*Direction);
      end;
  end;

{
  LogBrush.lbStyle := BS_SOLID;
  LogBrush.lbColor := clGreen;

  Source.StateMachine.Canvas.Pen.Handle := ExtCreatePen(
    PS_GEOMETRIC or PS_SOLID or PS_ENDCAP_FLAT or PS_JOIN_ROUND, // PS_JOIN_BEVEL,
    Source.StateMachine.Canvas.Pen.Width,
    LogBrush, // CONST LOGBRUSH *  lplb,	// address of structure for brush attributes
    0, nil);
}
  with Source.StateMachine.Canvas do
  begin
    //선분을 그림
    PolyLine(Lines);

    SaveWidth := Pen.Width;
    Pen.Width := 1;
    //화살표 모양을 그려줌
    Polygon(Arrow);
    Pen.Width := SaveWidth;
  end;//with

  if (csDesigning in Source.StateMachine.ComponentState) then
  begin
    if (Selected) and (Source.StateMachine.FConnector = self) then
      for i := dmFirstHandle to dmLastHandle do
      begin
        //디자인 타임에 마우스로 화살표 선택시에 3개의 점을 찍어줌
        if (i <> dmOffset) or not(ActualPath in [spTopLeft, spRightBottom]) then
          Source.StateMachine.Canvas.Rectangle(Lines[i].x-2, Lines[i].y-2, Lines[i].x+2, Lines[i].y+2);
      end;

    //마우스로 누르면 선택되는 영역 계산
    BoundsRect := MakeRect(Lines[dmSource], Lines[dmDestination]);
    InflateRect(BoundsRect, SelectMarginX, SelectMarginY);
  end;
end;

procedure TCustomLogicConnector.PaintFlipLine;
var
  p			: TPoint;
begin
  if (Source <> nil) and (Destination <> nil) then
  begin
    Source.StateMachine.Canvas.Pen.Width := 1;
    Source.StateMachine.Canvas.Pen.Mode := pmXor;
    Source.StateMachine.Canvas.Pen.Style := psDot;
    Source.StateMachine.Canvas.Pen.Color := clWhite;
    p := TCustomLogicConnector.RectCenter(Source.BoundsRect);
    Source.StateMachine.Canvas.MoveTo(p.x, p.y);
    p := TCustomLogicConnector.RectCenter(Destination.BoundsRect);
    Source.StateMachine.Canvas.LineTo(p.x, p.y);
    Source.StateMachine.Canvas.Pen.Width := 1;
    Source.StateMachine.Canvas.Pen.Mode := pmCopy;
    Source.StateMachine.Canvas.Pen.Style := psSolid;
    Source.StateMachine.Canvas.Pen.Color := clBlack;
  end;
end;

function TCustomLogicConnector.HitTest(Mouse: TPoint): Boolean;
begin
  Result := PtInRect(BoundsRect, Mouse);
end;

//******************************************************************************
//**
//**			TCustomLogicControl
//**
//******************************************************************************
constructor TCustomLogicControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited SetBounds(0, 0, 69, 41);
  FConnectors := TList.Create;
  ShowHint := True;
  FRoundSize := 30;
end;

destructor TCustomLogicControl.Destroy;
var i: integer;
begin
  //FConnectors의 각 Item들은 각 Component의 소멸자에서 Free를 실행함.
  //따라서 TList형인 FConnectors만 Free하면 됨.
  FConnectors.Free;
  inherited Destroy;
end;

function TCustomLogicControl.AddConnector(OwnerRole: TStatePathOwner): TCustomLogicConnector;
begin
  Result := TCustomLogicConnector.Create(self, OwnerRole);
  Connectors.Add(Result);
end;

procedure TCustomLogicControl.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Connectors', ReadConnectors, WriteConnectors,
    (Connectors.Count > 0));
end;

procedure TCustomLogicControl.WriteConnectors(Writer: TWriter);
var
  i			: integer;
begin
  Writer.WriteListBegin;
  try
    for i := 0 to Connectors.Count-1 do
    begin
      Writer.WriteInteger(ord(TCustomLogicConnector(Connectors[i]).Path));
      Writer.WriteInteger(TCustomLogicConnector(Connectors[i]).Offset);
    end;
  finally
    Writer.WriteListEnd;
  end;
end;

procedure TCustomLogicControl.ReadConnectors(Reader: TReader);
var
  i			: integer;
begin
  Reader.ReadListBegin;
  try
    i := 0;
    while not(Reader.EndOfList) do
    begin
      if (i < Connectors.Count) then
      begin
        TCustomLogicConnector(Connectors[i]).Path := TStatePath(Reader.ReadInteger);
        TCustomLogicConnector(Connectors[i]).Offset := Reader.ReadInteger;
      end else
        Reader.ReadInteger;
      inc(i);
    end;
  finally
    Reader.ReadListEnd;
  end;
end;

procedure TCustomLogicControl.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if (AParent <> nil) and not(AParent is TCustomLogicPanel) then
    raise Exception.Create(ClassName+' must have a TCustomLogicPanel as parent')
  else
    FStateMachine := TCustomLogicPanel(AParent);
end;

procedure TCustomLogicControl.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if (FStateMachine <> nil) then
    FStateMachine.Invalidate;
end;

procedure TCustomLogicControl.SetDiagramType(Value: TDiagramType);
begin
  if Value <> FDiagramType then
  begin
    FDiagramType := Value;
    Invalidate;
  end;
end;

procedure TCustomLogicControl.SetRoundSize(Value: integer);
begin
  if Value <> FRoundSize then
  begin
    FRoundSize := Value;
    Invalidate;
  end;
end;

procedure TCustomLogicControl.CMTextChanged(var msg: TMessage);
begin
  Invalidate;
end;

procedure TCustomLogicControl.Click;
begin
  //if (FStateMachine <> nil) then
  //  FStateMachine.ChangeState(self);
end;

function TCustomLogicControl.GetCheckStateMachine: TCustomLogicPanel;
begin
  if (FStateMachine = nil) then
    raise Exception.Create('Orphan '+ClassName);
  Result := FStateMachine;
end;

procedure TCustomLogicControl.SetHint(Value: string);
begin
  inherited Hint := Value;
  invalidate;
end;

function TCustomLogicControl.GetHint: string;
begin
  Result := inherited Hint;
end;

procedure TCustomLogicControl.SetCaption(Value: string);
begin
  if Caption <> Value then
    Caption := Value;
  //invalidate;
end;

procedure TCustomLogicControl.SetActive(Value: boolean);
begin
  if not(Value) then
    CheckStateMachine.State := nil
  else
    CheckStateMachine.State := self;
end;

function TCustomLogicControl.GetActive: boolean;
begin
  Result := (CheckStateMachine.State = self);
end;

procedure TCustomLogicControl.PrepareCanvas(Element: TVisualElement; Canvas: TCanvas);
begin
  case (Element) of
    veShadow:
      begin
        Canvas.Pen.Width := 1;
        Canvas.Pen.Color := clGray;
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Mode := pmCopy;
        Canvas.Brush.Style := bsSolid;
        Canvas.Brush.Color := clGray;
      end;
    veFrame:
      begin
        Canvas.Pen.Color := clBlack;
        Canvas.Pen.Style := psInsideFrame;
        Canvas.Pen.Mode := pmCopy;
        if (Active) then
          Canvas.Pen.Width := 2
        else
          Canvas.Pen.Width := 1;
      end;
    vePanel:
      begin
        Canvas.Brush.Style := bsSolid;
        if (Active) then
          Canvas.Brush.Color := clRed
        else
          Canvas.Brush.Color := clWhite;
      end;
    veText:
      begin
        Canvas.Brush.Style := bsClear;
        if (Active) then
          Canvas.Font.Color := clWhite
        else
          Canvas.Font.Color := clBlack;
      end;
    veConnector:
      begin
        Canvas.Pen.Width := 1;
        Canvas.Pen.Color := clBlack;
      end;
  end;
end;

procedure TCustomLogicControl.DrawText(TextRect: TRect);
var
  Opt			: integer;
begin
  //if (Hint <> '') then
  //  Caption := Hint
  //else
  //  Caption := Name;
  Opt := DT_CENTER or DT_NOPREFIX;// or DT_NOCLIP;
  if (Canvas.TextWidth(Caption) >= TextRect.Right-TextRect.Left) then
    Opt := Opt or DT_WORDBREAK
  else
    Opt := Opt or DT_VCENTER or DT_SINGLELINE;
  windows.DrawText(Canvas.Handle, PChar(Caption), -1, TextRect, Opt);
end;

procedure TCustomLogicControl.DoPaint;
var
  r: TRect;
  i,j,k: integer;
  rgn0,rgn1,rgn2,rgn3,rgn4 :Hrgn;
begin
  // Draw shadow
  PrepareCanvas(veShadow, Canvas);
  r.TopLeft :=  Point(ShadowHeight,ShadowHeight);
  r.BottomRight := Point(Width, Height);

  with r do
  begin
    case FDiagramType of
      dtStart, dtStop:
        Canvas.RoundRect(Left, Top, Right, Bottom, FRoundSize, FRoundSize);
      dtDelay:
        begin
          rgn0 := CreateEllipticRgn(Left, Top, Right, Bottom);
          rgn1 := CreateEllipticRgn(Left, Top, Right, Bottom);
          i := Round(Width div 2);
          rgn2 := CreateRectRgn(Left + i, Top, Right, Bottom);
          combineRgn(rgn0,rgn1,rgn2,RGN_And);
          rgn3 := CreateRectRgn(Left, Top, Right, Bottom);
          rgn4 := CreateRectRgn(Left, Top, Right - i + 2, Bottom);
          combineRgn(rgn3,rgn4,rgn0,RGN_OR);
          FillRgn(Canvas.Handle,rgn3,Canvas.Brush.Handle);
          DeleteObject(rgn4);
          DeleteObject(rgn3);
          DeleteObject(rgn2);
          DeleteObject(rgn1);
          DeleteObject(rgn0);
        end;
      else
        Canvas.FillRect(r);
    end;//case
  end;//with

  // Draw rectangle
  PrepareCanvas(veFrame, Canvas);
  PrepareCanvas(vePanel, Canvas);
  OffsetRect(r, -ShadowHeight, -ShadowHeight);

  with r do
  begin
    case FDiagramType of
      dtStart, dtStop:
        Canvas.RoundRect(Left, Top, Right, Bottom, FRoundSize, FRoundSize);
      dtDelay:
        begin
          //k := Left - ShadowConst;
          //j := Right - ShadowConst;
          rgn0 := CreateEllipticRgn(Left, Top, Right, Bottom);
          rgn1 := CreateEllipticRgn(Left, Top, Right, Bottom);
          i := Round(Width div 2);
          rgn2 := CreateRectRgn(Left + i, Top, Right, Bottom);
          combineRgn(rgn0,rgn1,rgn2,RGN_And);
          rgn3 := CreateRectRgn(Left, Top, Right, Bottom);
          rgn4 := CreateRectRgn(Left, Top, Right - i + 2, Bottom);
          combineRgn(rgn3,rgn4,rgn0,RGN_OR);
          FillRgn(Canvas.Handle,rgn3,Canvas.Brush.Handle);
          FrameRgn(Canvas.Handle, rgn3, Canvas.Pen.Handle,Canvas.Pen.Width, Canvas.Pen.Width);
          DeleteObject(rgn4);
          DeleteObject(rgn3);
          DeleteObject(rgn2);
          DeleteObject(rgn1);
          DeleteObject(rgn0);
        end;
      else
        Canvas.Rectangle(Left, Top, Right, Bottom);
    end;//case
  end;//with

  // Draw name
  PrepareCanvas(veText, Canvas);
  // Margin for text
  InflateRect(r, -Canvas.Pen.Width, -Canvas.Pen.Width);
  DrawText(r);
end;

procedure TCustomLogicControl.PaintConnector;
begin
  PrepareCanvas(veConnector, StateMachine.Canvas);
end;

procedure TCustomLogicControl.Paint;
var
  Painting: Boolean;	// To avoide recursion by accidentally calling
  				// inherited Paint in overloaded DoPaint
begin
  Painting := False;

  if (Painting) then
    raise Exception.Create('Recursion detected in TCustomLogicControl.Paint');
  Painting := True;
  try
    inherited Paint;
    DoPaint;
    PaintConnector;
    // StateMachine.Canvas.Pen.Width := 1;
  finally
    Painting := False;
  end;
end;

procedure TCustomLogicControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = self) and (FStateMachine <> nil) then
    StateMachine.Invalidate;
end;

procedure TCustomLogicControl.DoOnEnter;
begin
  // Nothing to do here
end;

procedure TCustomLogicControl.DoOnExit;
begin
  // Nothing to do here
end;

function TCustomLogicControl.DoDefault: Boolean;
begin
  Result := False;
end;

procedure TCustomLogicControl.CheckTransition(Transition: TCustomLogicControl; Direction: TTransitionDirection);
begin
  if (self = nil) then
    raise Exception.Create('nil State');
end;

function TCustomLogicControl.HitTest(Mouse: TPoint): TCustomLogicConnector;
begin
  Result := nil;
end;

//******************************************************************************
//**
//**			TCustomLogicNodeBase
//**
//******************************************************************************
procedure TCustomLogicNodeBase.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);

  // First state will be used as default
  if (StateMachine <> nil) and (StateMachine.State = nil) then
    StateMachine.State := self;
end;

//******************************************************************************
//**
//**			TCustomLogicNode
//**
//******************************************************************************
constructor TCustomLogicNode.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  DiagramType := dtDefault;
  FToConnector := AddConnector(poOwnedBySource);
//  ControlStyle := [csCaptureMouse, { csOpaque, } csDoubleClicks];
end;

destructor TCustomLogicNode.Destroy;
begin
  FToConnector.Free;
  inherited Destroy;
end;

procedure TCustomLogicNode.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  FToConnector.Offset := 0;
end;

procedure TCustomLogicNode.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent = FDefaultTransition) then
    begin
      FDefaultTransition := nil;
      FToConnector.Destination := nil;
    end;
  end;
end;

procedure TCustomLogicNode.PaintConnector;
begin
  inherited PaintConnector;
  StateMachine.Canvas.Pen.Width := 2;
  FToConnector.Paint;
end;

function TCustomLogicNode.HitTest(Mouse: TPoint): TCustomLogicConnector;
begin
  Result := nil;
  if (FToConnector.HitTest(Mouse)) then
    Result := FToConnector;
end;

procedure TCustomLogicNode.PrepareCanvas(Element: TVisualElement; Canvas: TCanvas);
begin
  inherited PrepareCanvas(Element, Canvas);
  if (Element = veText) and
    not(Assigned(OnEnterState) or (csDesigning in ComponentState)) then
    Canvas.Font.Color := clGray;
end;

procedure TCustomLogicNode.SetDefaultTransition(Value: TCustomLogicControl);
begin
  FDefaultTransition := Value;
  FToConnector.Destination := Value;
  if (FStateMachine <> nil) then
    StateMachine.Invalidate;
end;

// NextState is obsolete!
procedure TCustomLogicNode.SetNextState(Value :TCustomLogicControl);
begin
  if not(csLoading in ComponentState) then
    ShowMessage('The NextState property is obsolete!'+#13+'Use DefaultTransition instead');
  // Only assign value if non-nil
  if (Value <> nil) then
    FDefaultTransition := Value;
end;

procedure TCustomLogicNode.DoOnEnter;
begin
  Sleep(FBeforeDelay);

  if (Assigned(FOnEnterState)) then
    FOnEnterState(self);

  Sleep(FAfterDelay);
end;

procedure TCustomLogicNode.DoOnExit;
begin
  if (Assigned(FOnExitState)) then
    FOnExitState(self);
end;

function TCustomLogicNode.DoDefault: Boolean;
begin
  Result := True;
  if Assigned(FDefaultTransition) then
    StateMachine.ChangeState(FDefaultTransition)
  else
    Result := False;
end;

//******************************************************************************
//**
//**			TCustomLogicStart
//**
//******************************************************************************
constructor TCustomLogicStart.Create(AOwner: TComponent);
begin
  inherited;
  DiagramType := dtStart;
  Caption := '시작';
end;

procedure TCustomLogicStart.PrepareCanvas(Element: TVisualElement; Canvas: TCanvas);
begin
  inherited PrepareCanvas(Element, Canvas);
  case (Element) of
    veText:
      Canvas.Font.Style := [fsBold];
    veFrame:
      Canvas.Pen.Color := clGreen;
  end;
end;

//******************************************************************************
//**
//**			TCustomLogicStop
//**
//******************************************************************************
constructor TCustomLogicStop.Create(AOwner: TComponent);
begin
  inherited;
  DiagramType := dtStop;
  Caption := '끝';
end;

procedure TCustomLogicStop.PrepareCanvas(Element: TVisualElement; Canvas: TCanvas);
begin
  inherited PrepareCanvas(Element, Canvas);
  case (Element) of
    veText:
      Canvas.Font.Style := [fsBold];
    veFrame:
      Canvas.Pen.Color := clRed;
  end;
end;

//******************************************************************************
//**
//**			TCustomLogicBoolean
//**
//******************************************************************************
constructor TCustomLogicBoolean.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDefault := True;
  FTrueConnector := AddConnector(poOwnedBySource);
  FFalseConnector := AddConnector(poOwnedBySource);
end;

destructor TCustomLogicBoolean.Destroy;
begin
  FTrueConnector.Free;
  FFalseConnector.Free;

  inherited Destroy;
end;

procedure TCustomLogicBoolean.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  FTrueConnector.Offset := 0;
  FFalseConnector.Offset := 0;
end;

procedure TCustomLogicBoolean.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent = FTrueState) then
    begin
      FTrueState := nil;
      FTrueConnector.Destination := nil;
    end;
    if (AComponent = FFalseState) then
    begin
      FFalseState := nil;
      FFalseConnector.Destination := nil;
    end;
  end;
end;

procedure TCustomLogicBoolean.PaintConnector;
begin
  inherited PaintConnector;
  if (DefaultState) then
    StateMachine.Canvas.Pen.Width := 2
  else
    StateMachine.Canvas.Pen.Width := 1;
  StateMachine.Canvas.Pen.Color := clGreen;
  FTrueConnector.Paint;

  if not(DefaultState) then
    StateMachine.Canvas.Pen.Width := 2
  else
    StateMachine.Canvas.Pen.Width := 1;
  StateMachine.Canvas.Pen.Color := clRed;
  FFalseConnector.Paint;
end;

function TCustomLogicBoolean.HitTest(Mouse: TPoint): TCustomLogicConnector;
begin
  Result := nil;
  if (FTrueConnector.HitTest(Mouse)) then
    Result := FTrueConnector
  else if (FFalseConnector.HitTest(Mouse)) then
    Result := FFalseConnector;
end;

procedure TCustomLogicBoolean.PrepareCanvas(Element: TVisualElement; Canvas: TCanvas);
begin
  inherited PrepareCanvas(Element, Canvas);
  case (Element) of
    veText:
      if not(Assigned(OnEnterState) or (csDesigning in ComponentState)) then
        Canvas.Font.Color := clGray;
    veShadow:
      Canvas.Pen.Color := clBlack;
  end;
end;

procedure TCustomLogicBoolean.DoPaint;
var
  r			: TRect;
  Diamond		: array[0..3] of TPoint;
begin
  // Draw shadow
  PrepareCanvas(veShadow, Canvas);
  Diamond[0] := Point(0, Height DIV 2);
  Diamond[1] := Point(Width DIV 2, 0);
  Diamond[2] := Point(Width-1, Height DIV 2);
  Diamond[3] := Point(Width DIV 2, Height-1);
  Canvas.Polygon(Diamond);
  // Draw rectangle
  PrepareCanvas(veFrame, Canvas);
  PrepareCanvas(vePanel, Canvas);
  r := Rect(Width DIV 7, Height DIV 7,Width-(Width DIV 7), Height-(Height DIV 7));
  Canvas.Rectangle(r.left, r.top, r.right, r.bottom);
  // Draw name
  PrepareCanvas(veText, Canvas);
  InflateRect(r, -Canvas.Pen.Width, -Canvas.Pen.Width);
  DrawText(r);
end;

procedure TCustomLogicBoolean.SetTrueState(Value :TCustomLogicControl);
begin
  FTrueState := Value;
  FTrueConnector.Destination := Value;
  // True and False should not be the same
  if (Value <> nil) and (FFalseState = Value) then
    FFalseState := nil;
  if (FStateMachine <> nil) then
    StateMachine.Invalidate;
end;

procedure TCustomLogicBoolean.SetFalseState(Value :TCustomLogicControl);
begin
  FFalseState := Value;
  FFalseConnector.Destination := Value;
  // True and False should not be the same
  if (Value <> nil) and (FtrueState = Value) then
    FTrueState := nil;
  if (FStateMachine <> nil) then
    StateMachine.Invalidate;
end;

procedure TCustomLogicBoolean.SetDefault(Value :Boolean);
begin
  if (Value <> FDefault) then
  begin
    FDefault := Value;
    StateMachine.Invalidate; // To erase previous fat line
    // Invalidate;
  end;
end;

procedure TCustomLogicBoolean.DoOnEnter;
begin
  Sleep(FBeforeDelay);

  FResult := FDefault;
  if (Assigned(FOnEnterState)) then
  begin
    FOnEnterState(self, FResult);
    if not(StateMachine.StateChanged) then
    begin
      if (FResult) and (Assigned(FTrueState)) then
        StateMachine.ChangeState(FTrueState)
      else if (not FResult) and (Assigned(FFalseState)) then
        StateMachine.ChangeState(FFalseState);
    end;
  end;

  Sleep(FAfterDelay);
end;

procedure TCustomLogicBoolean.DoOnExit;
begin
  if (Assigned(FOnExitState)) then
    FOnExitState(self);
end;

function TCustomLogicBoolean.DoDefault: Boolean;
begin
  Result := True;
  if (DefaultState) and (Assigned(FTrueState)) then
    StateMachine.ChangeState(FTrueState)
  else if (not DefaultState) and (Assigned(FFalseState)) then
    StateMachine.ChangeState(FFalseState)
  else
    Result := False;
end;

//******************************************************************************
//**
//**			TCustomLogicTransition
//**
//******************************************************************************
constructor TCustomLogicTransition.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FToConnector := AddConnector(poOwnedBySource);
  FFromConnector := AddConnector(poOwnedByDestination);
  SetBounds(0, 0, 89, 41);
end;

destructor TCustomLogicTransition.Destroy;
begin
  FFromState := nil;
  FFromConnector.Free;
  FToState := nil;
  FToConnector.Free;
  inherited Destroy;
end;

procedure TCustomLogicTransition.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
end;

procedure TCustomLogicTransition.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  FToConnector.Offset := 0;
  FFromConnector.Offset := 0;
end;

procedure TCustomLogicTransition.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (FFromState = AComponent) then
    begin
      FFromState := nil;
      FFromConnector.Source := nil;
    end;
    if (FToState = AComponent) then
    begin
      FToState := nil;
      FToConnector.Destination := nil;
    end;
  end;
end;

procedure TCustomLogicTransition.PaintConnector;
begin
  inherited PaintConnector;
  StateMachine.Canvas.Pen.Width := 1;
  FFromConnector.Paint;
  FToConnector.Paint;
end;

function TCustomLogicTransition.HitTest(Mouse: TPoint): TCustomLogicConnector;
begin
  Result := nil;
  if (FToConnector.HitTest(Mouse)) then
    Result := FToConnector
  else
    if (FFromConnector.HitTest(Mouse)) then
      Result := FFromConnector;
end;

procedure TCustomLogicTransition.PrepareCanvas(Element: TVisualElement; Canvas: TCanvas);
begin
  inherited PrepareCanvas(Element, Canvas);
  case (Element) of
    veText:
      if not((Assigned(FFromState)) and (Assigned(FToState)) or
        (csDesigning in ComponentState)) then
        Canvas.Font.Color := clGray;
  end;
end;

procedure TCustomLogicTransition.DoPaint;
var
  RoundSize		: integer;
  r			: TRect;
begin
  RoundSize := 16;
  if (Height < RoundSize) then
    RoundSize := Height;
  if (Width < RoundSize) then
    RoundSize := Width;

  // Draw shadow
  PrepareCanvas(veShadow, Canvas);
  Canvas.RoundRect(ShadowHeight,ShadowHeight, Width, Height, RoundSize,RoundSize);
  // Draw rectangle
  PrepareCanvas(veFrame, Canvas);
  PrepareCanvas(vePanel, Canvas);
  Canvas.RoundRect(0,0, Width-ShadowHeight,Height-ShadowHeight, RoundSize,RoundSize);
  // Draw name
  PrepareCanvas(veText, Canvas);
  r := Rect(ShadowHeight+1,ShadowHeight+1,Width-(Canvas.Pen.Width+1), Height-(Canvas.Pen.Width+1));
  DrawText(r);
end;

procedure TCustomLogicTransition.SetFromState(Value :TCustomLogicControl);
begin
  if (Value <>  nil) and (Value.StateMachine <> CheckStateMachine) then
    raise Exception.Create('Cannot link to state in other state machine');
  FFromState := Value;
  FFromConnector.Source := Value;
  if (FStateMachine <> nil) then
    StateMachine.Invalidate;
end;

procedure TCustomLogicTransition.SetToState(Value :TCustomLogicControl);
begin
  if (Value <>  nil) and (Value.StateMachine <> CheckStateMachine) then
    raise Exception.Create('Cannot link to state in other state machine');
  FToState := Value;
  FToConnector.Destination := Value;
  if (FStateMachine <> nil) then
    StateMachine.Invalidate;
end;

procedure TCustomLogicTransition.DoOnEnter;
begin
  if (Assigned(FOnTransition)) then
    FOnTransition(self);
end;

function TCustomLogicTransition.DoDefault: Boolean;
begin
  Result := True;
  if Assigned(ToStep) then
    StateMachine.ChangeState(ToStep)
  else
    Result := False;
end;

procedure TCustomLogicTransition.CheckTransition(Transition: TCustomLogicControl; Direction: TTransitionDirection);
begin
  inherited CheckTransition(Transition, Direction);
  if (Direction = tdTo) and Assigned(FFromState) and (Transition <> FFromState) then
    raise Exception.Create('FromState does not match');
  if (Direction = tdFrom) and Assigned(FToState) and (Transition <> FToState) then
    raise Exception.Create('ToState does not match');
end;

//******************************************************************************
//**
//**			TCustomLogicLink
//**
//******************************************************************************
constructor TCustomLogicLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDirection := ldOutgoing;
  FConnector := AddConnector(poOwnedBySource);
  SetBounds(0, 0, 41, 41);
end;

destructor TCustomLogicLink.Destroy;
begin
  FConnector.Free;
  FDestination := nil;
  inherited Destroy;
end;

procedure TCustomLogicLink.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
end;

procedure TCustomLogicLink.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if (AWidth <> Width) then
    AHeight := AWidth
  else if (AHeight <> Height) then
    AWidth := AHeight;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  FConnector.Offset := 0;
end;

procedure TCustomLogicLink.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (FDestination = AComponent) then
    begin
      if (Direction = ldOutgoing) then
        FConnector.Destination := nil;
      FDestination := nil;
    end;
  end;
end;

procedure TCustomLogicLink.PaintConnector;
begin
  inherited PaintConnector;
  FConnector.Paint;
end;

function TCustomLogicLink.HitTest(Mouse: TPoint): TCustomLogicConnector;
begin
  Result := nil;
  if (FConnector.HitTest(Mouse)) then
    Result := FConnector;
end;

procedure TCustomLogicLink.PrepareCanvas(Element: TVisualElement; Canvas: TCanvas);
begin
  inherited PrepareCanvas(Element, Canvas);
  case (Element) of
    veText:
      if not(Assigned(FDestination) or (csDesigning in ComponentState)) then
        Canvas.Font.Color := clGray;
  end;
end;

procedure TCustomLogicLink.DoPaint;
var
  r			: TRect;
begin
  // Draw shadow
  PrepareCanvas(veShadow, Canvas);
  r.TopLeft :=  Point(ShadowHeight,ShadowHeight);
  r.BottomRight := Point(Width, Height);
  Canvas.Ellipse(r.Left, r.Top, r.Right, r.Bottom);
  // Draw rectangle
  PrepareCanvas(veFrame, Canvas);
  PrepareCanvas(vePanel, Canvas);
  OffsetRect(r, -r.Left, -r.Top);
  Canvas.Ellipse(r.Left, r.Top, r.Right, r.Bottom);
  // Draw name
  PrepareCanvas(veText, Canvas);
  // Margin for text
  InflateRect(r, -Canvas.Pen.Width, -Canvas.Pen.Width);
  DrawText(r);
end;

procedure TCustomLogicLink.SetDestination(Value :TCustomLogicControl);
begin
  if (Value <>  nil) and (Value.StateMachine <> CheckStateMachine) then
    raise Exception.Create('Cannot connect to node in other state machine');

  if (Value = Self) then
    raise Exception.Create('Cannot connect link to self');

  FDestination := Value;

  if (Value <>  nil) then
  begin
    if (Value is TCustomLogicLink) then
    begin
      FDirection := ldOutgoing;
      FConnector.Destination := nil;
    end else
    begin
      FDirection := ldIncoming;
      FConnector.Destination := Value;
    end;

    FConnector.Paint;
  end;
  StateMachine.Invalidate;
end;

procedure TCustomLogicLink.SetDirection(Value :TLinkDirection);
begin
  if (Value <> FDirection) then
  begin
    FDirection := Value;
    NextStep := nil;
    StateMachine.Invalidate;
  end;
end;

procedure TCustomLogicLink.CheckTransition(Transition: TCustomLogicControl; Direction: TTransitionDirection);
begin
  inherited CheckTransition(Transition, Direction);
  if (Direction = tdTo) and
  (((FDirection = ldOutgoing) and (Transition is TCustomLogicLink)) or
   ((FDirection = ldIncoming) and not(Transition is TCustomLogicLink))) then
    raise Exception.Create('Direction and previous state type is illegal');

  if (Direction = tdFrom) and
  (((FDirection = ldOutgoing) and not(Transition is TCustomLogicLink)) or
   ((FDirection = ldIncoming) and (Transition is TCustomLogicLink))) then
    raise Exception.Create('Direction and next state type is illegal');
end;

function TCustomLogicLink.DoDefault: Boolean;
begin
  Result := True;
  if Assigned(NextStep) then
    StateMachine.ChangeState(NextStep)
  else
    Result := False;
end;

procedure TCustomLogicPanel.SetInitialState(Value: TCustomLogicControl);
begin
  if FInitialState <> Value then
  begin
    FInitialState := Value;
    State := Value;
  end;//if

end;

end.
