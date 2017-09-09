unit frmDocUnit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ELDsgnr, ExtCtrls, ELControls, Menus, ELUtils, StdCtrls, Buttons, ScrollPanel,
  Statmach_scroll, StartButton, CommLogic, SerialCommLogic;

type
  TfrmDoc3 = class;
  // Type of the OnChangeState event
  TChangeStateEvent2 = procedure(Sender: TfrmDoc3;
    FromState, ToState: TCustomLogicControl) of object;

  // Type of the OnException event
  TStateExceptionEvent2 = procedure(Sender: TfrmDoc3; Node: TCustomLogicControl;
    Error: Exception) of object;

  TCustomLogicPanelOption2 = (soInteractive, soSingleStep, soVerifyTransitions);
  TCustomLogicPanelOptions2 = set of TCustomLogicPanelOption2;

  TfrmDoc3 = class(TForm)
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    //===============================
    FFileName: string;
    FModified: Boolean;
    FISDesignMode: Boolean;
    //===============================

    FState: TCustomLogicControl;
    FInitialState: TCustomLogicControl;//Reset이 True일때 시작되는 State를 가리킴
    FOnChangeState: TChangeStateEvent2;
    FOnException: TStateExceptionEvent2;
    FActive: boolean;
    StateChanged: boolean;
    FConnector: TCustomLogicConnector;
    FDesignMoving: TDesignMove;
    Lines: TConnectorLines;
    FStopSignalled: Boolean;
    FOptions: TCustomLogicPanelOptions2;
    FStartExec: Boolean;//True이면 실행됨
    FReset: Boolean;//True이면 Execute시에 처음(TCustomLogicPanel의 State
    FNewPath			: TStatePath;//마우스로 Path 변경 가능

    //===============================
    function LoadFromFile(AFileName: string): integer;
    procedure SaveToFile(AFileName: string);
    procedure WriteDFM(Form:TForm;FormName:string);
    //===============================

    function pointinpoly(x,y:integer):boolean; {to recognize mouse clicks}
    procedure SetState(Value :TCustomLogicControl);
    procedure SetInitialState(Value :TCustomLogicControl);
    procedure SetStartExec(Value :Boolean);
    procedure SetReset(Value :Boolean);
    procedure DoSetState(Value :TCustomLogicControl);
    function NewState(NewHandle: TPoint): TStatePath;

    procedure DoOnChangeState(FromState, ToState: TCustomLogicControl); dynamic;
    procedure DoOnException(Node: TCustomLogicControl; E: Exception); dynamic;
    procedure SMStateTransition(var Message: TMessage); message CL_STATE_TRANSITION;

    property Active: boolean read FActive write FActive default False;
    property StartExec: boolean read FStartExec write SetStartExec default False;
    property State: TCustomLogicControl read FState write SetState;
    property StopSignalled: Boolean read FStopSignalled;
    property OnChangeState: TChangeStateEvent2 read FOnChangeState write FOnChangeState;
    property OnException: TStateExceptionEvent2 read FOnException write FOnException;
  public
    //===============================
    constructor Create(AOwner: TComponent); override;
    constructor CreateDocument(AOwner: TComponent; AFileName: string);
    procedure Save;
    procedure SaveAs(AFileName: string);
    procedure Modify;
    property FileName: string read FFileName;
    property Modified: Boolean read FModified;
    property IsDesignMode: Boolean read FIsDesignMode write FIsDesignMode;
    //===============================

    procedure Execute; virtual;
    procedure Stop;
    procedure ChangeState(Transition: TCustomLogicControl);
    procedure PostStateChange(State: TCustomLogicControl);
  end;

var
  //frmDoc: TfrmDoc;
  FormWasClosed: Boolean;

implementation

uses frmMainUnit, pjhObjectInspector, frmConst, UtilUnit;

{$R *.dfm}

{ TForm1 }

procedure TfrmDoc3.ChangeState(Transition: TCustomLogicControl);
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

constructor TfrmDoc3.Create(AOwner: TComponent);
begin
  inherited;

  Caption := UniqueName(Self);
  Name := Caption;
end;

constructor TfrmDoc3.CreateDocument(AOwner: TComponent; AFileName: string);
begin
  Create(AOwner);

  LoadFromFile(AFileNAme);
  FFileName := AFileNAme;
  Caption := ExtractFileName(AFileName);
end;

procedure TfrmDoc3.DoOnChangeState(FromState, ToState: TCustomLogicControl);
begin
  if (Assigned(FOnChangeState)) then
    try
      FOnChangeState(self, FromState, ToState);
    except
      on E: Exception do
        DoOnException(nil, E);
    end;
end;

procedure TfrmDoc3.DoOnException(Node: TCustomLogicControl; E: Exception);
begin
  if (Assigned(FOnException)) then
    FOnException(self, Node, E)
  else
    raise E;
end;

procedure TfrmDoc3.DoSetState(Value: TCustomLogicControl);
var
  OldState		: TCustomLogicControl;
begin
//  if (Value <> nil) and (Value.FStateMachine <> self) then
//    raise Exception.Create('Cannot change to state in other state machine');

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
//        OldState.DoOnExit;
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
//      State.DoOnEnter;
    except
      on E: Exception do
        DoOnException(State, E);
    end;

    if (FStopSignalled) then
    begin
      Active := False;
      exit;
    end;

    if not(StateChanged) then ;
//      if not(State.DoDefault) then
//        Active := False;

    if (soSingleStep in FOptions) then
      FStopSignalled := True;

  end;
end;

procedure TfrmDoc3.Execute;
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

function TfrmDoc3.LoadFromFile(AFileName: string): integer;
begin
  Result := ReadDFM(Self, AFileName);

end;

procedure TfrmDoc3.Modify;
begin
  FModified := True;
end;

function TfrmDoc3.NewState(NewHandle: TPoint): TStatePath;
var
  Diagonal, LeftRegion, RightRegion, TopRegion, BottomRegion: TRect;
  LI,LI2: integer;
  Lb, Lb2: Byte;
begin
  if FDesignMoving = dmDestination then
  begin
    case FConnector.ActualPath of
      spLL, spLR, spLT, spLB: Lb := 0;
      spRL, spRR, spRT, spRB: Lb := 1;
      spTL, spTR, spTT, spTB: Lb := 2;
      spBL, spBR, spBT, spBB: Lb := 3;
    end;//case

    Lb := Lb Shl 2;
    Diagonal := FConnector.Destination.BoundsRect;
  end//if
  else
  if FDesignMoving = dmSource then
  begin
    case FConnector.ActualPath of
      spLL, spRL, spTL, spBL: Lb2 := 0;
      spLR, spRR, spTR, spBR: Lb2 := 1;
      spLT, spRT, spTT, spBT: Lb2 := 2;
      spLB, spRB, spTB, spBB: Lb2 := 3;
    end;//case
    Diagonal := FConnector.Source.BoundsRect;
  end;//else if

  with Diagonal do
  begin
    LI := (Right - Left) DIV 4;
    LI2 := (Bottom - Top) DIV 2;
    LeftRegion := Rect(Left, Top, Left + LI, Bottom);
    RightRegion := Rect(Right - LI, Top, Right, Bottom);
    TopRegion := Rect(Left + LI, Top, Right - LI, Top + LI2);
    BottomRegion := Rect(Left + LI, Bottom - LI2, Right - LI, Bottom);
  end;//with

  if PtInRect(LeftRegion, NewHandle) then
  begin
    Lb2 := Lb2 + $0;
    Lb := Lb + 0;
  end
  else if PtInRect(RightRegion, NewHandle) then
  begin
    Lb2 := Lb2 + $4;
    Lb := Lb + 1;
  end
  else if PtInRect(TopRegion, NewHandle) then
  begin
    Lb2 := Lb2 + $8;
    Lb := Lb + 2;
  end
  else if PtInRect(BottomRegion, NewHandle) then
  begin
    Lb := Lb + 3;
    Lb2 := Lb2 + $C;
  end
  else
    Lb := $FF;

  if Lb = $FF then
    Result := FConnector.ActualPath
  else
  if FDesignMoving = dmDestination then
    Result := TStatePath(Lb+2)
  else
  if FDesignMoving = dmSource then
    Result := TStatePath(Lb2+2);
end;

function TfrmDoc3.pointinpoly(x, y: integer): boolean;
  function sameside(L:TLine_pjh; p1,p2:TPoint):int64;
  {same side =>result>0
   opposite sides => result <0
   a point on the line => result=0 }
  var
    dx,dy,dx1,dy1,dx2,dy2:int64;
  begin
    dx:=L.p2.x-L.P1.x;
    dy:=L.p2.y-L.P1.y;
    dx1:=p1.x-L.p1.x;
    dy1:=p1.y-L.p1.y;
    dx2:=p2.x-L.p2.x;
    dy2:=p2.y-L.p2.y;
    result:=(dx*dy1-dy*dx1)*(dx*dy2-dy*dx2);
  end;

  function  intersect(L1,L2:TLine_pjh):boolean;
  var
    a,b:int64;
  begin
    a:=sameside(L1,L2.p1,L2.p2);
    b:=sameside(L2,L1.p1,L1.p2);
    result:=(a<=0) and (b<=0);
  end;

var
  count,i,j:integer;
  lt,lp:TLine_pjh;
begin
  count:=0;
  j:=3;
  lt.p1:=point(x,y);
  lt.p2:=point(x,y);
  lt.p2.x:=2000;
  for i:= 1 to 3 do
  begin
    Lp.p1:=Arrow[i];
    Lp.p2:=Arrow[i];
    if not intersect(Lp,Lt) then
    begin
      Lp.p2:=Arrow[j];
      j:=i;
      if intersect(Lp,lT) then inc(count);
    end;
  end;
  result:=count mod 2 =1;
end;

procedure TfrmDoc3.PostStateChange(State: TCustomLogicControl);
begin
  PostMessage(Handle, CL_STATE_TRANSITION, 0, LongInt(State));
end;

procedure TfrmDoc3.Save;
begin
  SaveToFile(FFileName);
  FModified := False;
end;

procedure TfrmDoc3.SaveAs(AFileName: string);
begin
  SaveToFile(AFileName);
  FFileName := AFileName;
  Caption := ExtractFileName(AFileName);
  FModified := False;
end;

procedure TfrmDoc3.SaveToFile(AFileName: string);
begin
  WriteDFM(Self, AFileName);
end;

procedure TfrmDoc3.SetInitialState(Value: TCustomLogicControl);
begin
  if FInitialState <> Value then
  begin
    FInitialState := Value;
    State := Value;
  end;//if
end;

procedure TfrmDoc3.SetReset(Value: Boolean);
begin
  if FReset <> Value then
    FReset := Value;

  if (FReset) and Assigned(FInitialState) then
  begin
    State := FInitialState;
    FReset := False;
  end;//if
end;

procedure TfrmDoc3.SetStartExec(Value: Boolean);
begin
  if FStartExec <> Value then
    FStartExec := Value;

  if FStartExec then
    Execute
  else
    Stop;
end;

procedure TfrmDoc3.SetState(Value: TCustomLogicControl);
begin
  if (Active) and ([csLoading, csDesigning] * ComponentState = []) then
    DoOnChangeState(State, Value);
  DoSetState(Value);
//  PostStateChange(Value);
end;

procedure TfrmDoc3.SMStateTransition(var Message: TMessage);
begin
  if (Message.LParam <> 0) then
    DoSetState(TCustomLogicNode(Message.LParam));
end;

procedure TfrmDoc3.Stop;
begin
  FStopSignalled := True;
//  Active := False;
  Application.ProcessMessages;
end;

procedure TfrmDoc3.WriteDFM(Form: TForm; FormName: string);
var
  Output: TFileStream;
  ResName:string;
  I, Po:Integer;
  Writer:TWriter;
  HeaderSize: Integer;
  Origin, ImageSize: Longint;
  Header: array[0..79] of Char;
  LI: Longint;
  LB: Byte;
begin
  ResName:= Form.ClassName;
  // ResName:= FormName;
  try
    if FileExists(FormName) then
      Output:= TFileStream.Create(FormName, fmOpenReadWrite)
    else
      Output:= TFileStream.Create(FormName, fmCreate);
    //LI := Longint(Signature);
    //Output.Write(LI, SizeOf(Longint));
    //LB := $03;
    //Output.Write(LB, SizeOf(Byte));
    Byte((@Header[0])^) := $FF;
    Word((@Header[1])^) := 10;
    HeaderSize := StrLen(StrUpper(StrPLCopy(@Header[3], ResName, 63))) + 10;
    Word((@Header[HeaderSize - 6])^) := $1030;
    Longint((@Header[HeaderSize - 4])^) := 0;
    Output.WriteBuffer(Header, HeaderSize);
    Po:= Output.Position;
    Writer:= TWriter.Create(Output, 4096);
    Writer.Position:= Po;
    Writer.WriteRootComponent(Form);
    // write dfm file size
    ImageSize := Writer.Position - Po;
    Writer.Position := Po - 4;
    Writer.Write(ImageSize, SizeOf(ImageSize));
    Writer.Position := Po + ImageSize;
  finally
    Writer.Free;
    Output.Free;
  end;
end;

procedure TfrmDoc3.FormActivate(Sender: TObject);
begin
  frmProps.Doc := Self;
  frmMain.AdjustChangeSelection;
end;

procedure TfrmDoc3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  if Modified then
    case MessageDlg('Save document "' + Caption + '"?', mtConfirmation,
      [mbYes, mbNo, mbCancel], 0) of
      mrYes:
        if FileName <> '' then
          frmMain.Save(Self)
        else
          if not frmMain.SaveAs(Self) then Action := caNone;
      mrNo: {Do nothind};
      mrCancel: Action := caNone;
    end;
  FormWasClosed := Action = caFree;
  frmProps.ClearObjOfCombo();

//  if Assigned(FpjhLogicPanel) then
//    FpjhLogicPanel.Free;
end;

procedure TfrmDoc3.FormCreate(Sender: TObject);
begin
  FISDesignMode := True;
end;

procedure TfrmDoc3.FormDestroy(Sender: TObject);
begin
  if frmProps.Doc = Self then frmProps.Doc := nil;
end;

end.
