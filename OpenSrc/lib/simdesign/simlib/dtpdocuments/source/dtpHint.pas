{ Unit dtpDocument

  Project: DtpDocuments

  Creation Date: July 2011 (J.F.)
  Version: See "versions.txt"

  Contributors:

  JohnF

  Copyright (c) 2002-2011 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.
}
unit dtpHint;

interface

uses Windows, Classes, ExtCtrls, Controls, SysUtils;

type

  TdtpHintOffsetType = (hoNormal,hoVertical,hoHorizontal);

  TdtpHint = class(TPersistent)
  private
    FAutoDisplayHint: boolean;
    FHint: string;
    FHintShowing: boolean;
    FHintHidePause: integer;     // Pause for hint before disappearing if mouse still over control
    FHintInterval: integer;
    FHintPos: TPoint;            // Position of mouse when hint was invoked
    FHintTimer: TTimer;          // TTimer control that is used for margin hint sequensing   //  added by J.F. July 2011
    FHintWindow: THintWindow;    // A standard windows hintwindow used to display hints
    FHintOffset: TdtpHintOffsetType;
    FOwnerDocument: TObject;

    procedure TimerHintDisplay(Sender: TObject);
    procedure TimerHintRemove(Sender: TObject);
  protected
    procedure DoStartHint;
  public

    constructor Create(AOwner: TObject);
    destructor Destroy; override;

    procedure CancelHint; virtual; // added by J.F. June 2011

    procedure DisplayHint(APos: TPoint; Hint: string);

    procedure StartHint(APos: TPoint; Hint: string;APause: integer;ShowHint: boolean = true);

    property HintOffset: TdtpHintOffsetType read FHintOffset write FHintOffset;
    property Hint: string read FHint write FHint;
    // HintHidePause defines the time in msec that a hint is shown before it
    // is hidden again.
    property HintHidePause: integer read FHintHidePause write FHintHidePause default 2500;
    property HintPos: TPoint read FHintPos write FHintPos;
    property HintShowing: boolean read FHintShowing;
  end;

implementation

uses Forms, dtpDefaults, dtpDocument;

constructor TdtpHint.Create(AOwner: TObject);
begin
  FOwnerDocument:= AOwner;
  FHintHidePause:= 2500;
  inherited Create;
end;

destructor TdtpHint.Destroy;
begin
  FreeAndNil(FHintTimer);
  inherited;
end;

procedure TdtpHint.CancelHint; // added by J.F. July 2011
begin
  FAutoDisplayHint:= false;
  FHintShowing:= false;
  if assigned(FHintWindow) then
  begin
    FHintWindow.ReleaseHandle;
    FreeAndNil(FHintWindow);
  end;
  FreeAndNil(FHintTimer);
end;

procedure TdtpHint.DisplayHint(APos: TPoint; Hint: string);
begin
  FHint:= Hint;
  FHintPos:= APos;
  FAutoDisplayHint:= true;
  TimerHintDisplay(nil);
end;

procedure TdtpHint.DoStartHint;
begin
    // if it exists
  FreeAndNil(FHintTimer);
    // Create timer
  FHintTimer := TTimer.Create(nil);
  FHintTimer.Interval := FHintInterval;
  FHintTimer.OnTimer := TimerHintDisplay;
  FHintTimer.Enabled := True;
end;

procedure TdtpHint.StartHint(APos: TPoint; Hint: string; APause: integer; ShowHint:boolean = true);
begin
  // First cancel old hint (if any)
  CancelHint;
  // Do we need to display a hint?
  if not ShowHint or (length(Hint) = 0) then
    exit
  else
  begin
    FHint:= Hint;
    FHintPos:= APos;
    FHintInterval:= APause;
    DoStartHint;
  end;
end;

procedure TdtpHint.TimerHintDisplay(Sender: TObject); // added by J.F. July 2011
// Setup the hint window and display the margin hint
var
  HintBox: TRect;
  HintWindowYOffset, HintWindowXOffset: integer;
begin
  // init
  HintWindowXOffset := 0;
  HintWindowYOffset := 0;

  if not FAutoDisplayHint then
  if not assigned(FHintTimer) then
    exit;

  if not Assigned(FHintWindow) then
  begin
    FHintWindow := THintWindow.Create(nil);
    FHintWindow.Color := cDefaultHintColor;
  end;

  case FHintOffset of
    hoNormal:   begin
                  HintWindowXOffset:= 10;
                  HintWindowYOffset:= 24;
                end;
    hoVertical: begin
                  HintWindowXOffset:= 10;
                  HintWindowYOffset:= 10;
                end;
    hoHorizontal: begin
                    HintWindowXOffset:= 2;
                    HintWindowYOffset:= 16;
                  end;
  end;

  // Calculate hint window position and size
  HintBox := FHintWindow.CalcHintRect(Screen.Width div 2, FHint, nil);
  OffsetRect(HintBox,
    FHintPos.X + TdtpDocument(FOwnerDocument).ClientOrigin.X + HintWindowXOffset,
    FHintPos.Y + TdtpDocument(FOwnerDocument).ClientOrigin.Y + HintWindowYOffset);

  // Now show the window
  FHintWindow.ActivateHint(HintBox, FHint);
  FHintShowing:= true;

  // Next step: set timer for hint removal
  if not FAutoDisplayHint then
  begin
    FHintTimer.Interval := FHintHidePause;
    FHintTimer.OnTimer  := TimerHintRemove;
  end
  else
    FreeAndNil(FHintTimer);
end;

procedure TdtpHint.TimerHintRemove(Sender: TObject);
begin
  CancelHint;
end;

end.
