unit pjhTouchKeyboard;

interface

uses SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Winapi.Windows, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Touch.Keyboard,
  Vcl.Touch.KeyboardTypes;

type
  TpjhKeyboardToolForm = class(TCustomForm)
  private
    FShowCaption: boolean;
    FShowClose: boolean;
    procedure WMActivate(var Message: TMessage); message WM_ACTIVATE;
    procedure WMMouseActivate(var Message: TMessage); message WM_MOUSEACTIVATE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  published
    property ShowClose: boolean read FShowClose write FShowClose;
    property ShowCaption: boolean read FShowCaption write FShowCaption;
  end;

  TpjhPopupTouchKeyBoard = class(TComponent)
  private
    FTimer: TTimer;
    FFrm : TpjhKeyboardToolForm;
    FKbd : TTouchKeyboard;
    FOwnerform: TCustomForm;
    FAutoCapsDisplay: Boolean;
    FAutoPostKey: Boolean;
    FHighlightCaps: TColor;
    FKeyboardType: TKeyboardLayout;
    FHighlightAltGr: TColor;
    FAutoFollowFocus: Boolean;
    FAutoHide: Boolean;
    FShowCaption: boolean;
    FShowClose: boolean;
    FDisableSizing: boolean;
    FOnClose: TNotifyEvent;
    FOnShow: TNotifyEvent;
    FOnKeyboardCreated: TNotifyEvent;
    FLastX,FLastY: integer;
    procedure SetAutoCapsDisplay(const Value: Boolean);
    procedure SetAutoPostKey(const Value: Boolean);
    procedure SetHighlightAltGr(const Value: TColor);
    procedure SetHighlightCaps(const Value: TColor);
    procedure SetKeyboardType(const Value: TKeyboardLayout);
    procedure KeyboardSizeChanged(Sender: TObject);
    function GetKeyboardRect: TRect;
  protected
    procedure TimerProc(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateForm; virtual;
    procedure Show;
    procedure ShowAtXY(x,y: integer); overload;
    procedure ShowAtXY(AParent: TCustomForm; x,y: integer); overload;
    procedure Hide;
    property KeyboardRect: TRect read GetKeyboardRect;
    property Keyboard: TTouchKeyboard read FKbd;
  published
    property ShowCaption: boolean read FShowCaption write FShowCaption default true;
    property ShowClose: boolean read FShowClose write FShowClose default true;
    property AutoFollowFocus: Boolean read FAutoFollowFocus write FAutoFollowFocus default false;
    property AutoHide: Boolean read FAutoHide write FAutoHide default false;
    property AutoPostKey : Boolean read FAutoPostKey write SetAutoPostKey default true;
    property AutoCapsDisplay: Boolean read FAutoCapsDisplay write SetAutoCapsDisplay default false;
    property HighlightCaps: TColor read FHighlightCaps write SetHighlightCaps default clNone;
    property HighlightAltGr: TColor read FHighlightAltGr write SetHighlightAltGr default clNone;
    property KeyboardType : TKeyboardLayout read FKeyboardType write SetKeyboardType;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnKeyboardCreated: TNotifyEvent read FOnKeyboardCreated write FOnKeyboardCreated;
  end;

implementation

procedure TpjhKeyboardToolForm.CreateParams(var Params: TCreateParams);
begin
  inherited;

  with Params do
  begin
    WndParent := (Owner as TCustomForm).Handle;
    Style := WS_POPUP;

    if ShowClose then
      Style := Style or WS_SYSMENU;
    if ShowCaption then
      Style := Style or WS_CAPTION;

    ExStyle := WS_EX_PALETTEWINDOW;
  end;
end;

procedure TpjhKeyboardToolForm.WMActivate(var Message: TMessage);
begin
  inherited;
//  SetActiveWindow((Owner as TCustomForm).Handle);
  message.Result := 1;
end;

procedure TpjhKeyboardToolForm.WMMouseActivate(var Message: TMessage);
begin
  Message.Result := MA_NOACTIVATE;
end;

{ TpjhPopupTouchKeyBoard }

constructor TpjhPopupTouchKeyBoard.Create(AOwner: TComponent);
begin
  inherited;
  FFrm := nil;
  FKbd := nil;
  FOwnerForm := nil;

  if (AOwner is TWinControl) then
    FOwnerform := GetParentForm(AOwner as TWinControl);

  FTimer := TTimer.Create(self);
  FTimer.OnTimer := TimerProc;
  FTimer.Interval := 250;
  FTimer.Enabled := false;

  FAutoPostKey := true;
  FAutoFollowFocus := True;
  FAutoCapsDisplay := false;
  FHighlightCaps := clNone;
  FHighlightAltGr := clNone;
  FKeyboardType := 'NumPad';
  FShowClose := true;
  FShowCaption := true;
  FDisableSizing := false;
  FLastX := -1;
  FLastY := -1;

end;

destructor TpjhPopupTouchKeyBoard.Destroy;
begin
  FTimer.Free;
  inherited;
end;

procedure TpjhPopupTouchKeyBoard.Hide;
begin
  FLastX := -1;
  FLastY := -1;
  FTimer.Enabled := false;
  if Assigned(FFrm) then
    FFrm.Free;
  FFrm := nil;
  FKbd := nil;
end;


procedure TpjhPopupTouchKeyBoard.KeyboardSizeChanged(Sender: TObject);
begin
  if not FDisableSizing then
  begin
    if ShowCaption then
    begin
      //FFrm.Width := (FKbd.Width + GetSystemMetrics(SM_CXDLGFRAME) * 2) + FKbd.KeyDistance;
      //FFrm.Height := (FKbd.Height + GetSystemMetrics(SM_CYDLGFRAME) * 2 + GetSystemMetrics(SM_CYSMCAPTION)) + FKbd.KeyDistance;
    end
    else
    begin
      FFrm.Width := FKbd.Width;
      FFrm.Height := FKbd.Height;
    end;
  end;
end;

procedure TpjhPopupTouchKeyBoard.SetAutoCapsDisplay(const Value: Boolean);
begin
  FAutoCapsDisplay := Value;
  //if Assigned(FKbd) then
  //  FKbd.AutoCapsDisplay := Value;
end;

procedure TpjhPopupTouchKeyBoard.SetAutoPostKey(const Value: Boolean);
begin
  FAutoPostKey := Value;
  //if Assigned(FKbd) then
  //  FKbd.AutoPostKey := Value;
end;

procedure TpjhPopupTouchKeyBoard.SetHighlightAltGr(const Value: TColor);
begin
  FHighlightAltGr := Value;
  //if Assigned(FKbd) then
  //  FKbd.HighlightAltGr := Value;
end;

procedure TpjhPopupTouchKeyBoard.SetHighlightCaps(const Value: TColor);
begin
  FHighlightCaps := Value;
  //if Assigned(FKbd) then
  //  FKbd.HighlightCaps := Value;
end;

procedure TpjhPopupTouchKeyBoard.SetKeyboardType(const Value: TKeyboardLayout);
begin
  FKeyboardType := Value;
  if Assigned(FKbd) then
    FKbd.Layout := Value;
end;

procedure TpjhPopupTouchKeyBoard.CreateForm;
begin
  FFrm := TpjhKeyboardToolForm.CreateNew(FOwnerForm);
  FFrm.ShowCaption := FShowCaption;
  FFrm.ShowClose := FShowClose;
  FFrm.OnCloseQuery := FormCloseQuery;
  FFrm.BorderStyle := bsToolWindow;

  FKbd := TTouchKeyboard.Create(FFrm);
  FKbd.Parent := FFrm;
  FKbd.Align := alClient;

  //FKbd.AutoPostKey := FAutoPostKey;
  //FKbd.AutoCapsDisplay := FAutoCapsDisplay;
  //FKbd.HighlightCaps := FHighlightCaps;
  //FKbd.HighlightAltGr := FHighlightAltGr;
  FKbd.Layout := FKeyboardType;
  //FKbd.OnResize := KeyboardSizeChanged;

  if Assigned(OnKeyboardCreated) then
    OnKeyboardCreated(Self);


  if ShowCaption then
  begin
    //FKbd.Width := FFrm.Width;
    //FKbd.Height := FFrm.Height-30;
    //FFrm.Width := (FKbd.Width + GetSystemMetrics(SM_CXDLGFRAME) * 2) + FKbd.KeyDistance;
    //FFrm.Height := (FKbd.Height + GetSystemMetrics(SM_CYDLGFRAME) * 2 + GetSystemMetrics(SM_CYSMCAPTION)) + FKbd.KeyDistance;
  end
  else
  begin
    FFrm.Width := FKbd.Width;
    FFrm.Height := FKbd.Height;
  end;

  //FFrm.Visible := false;

end;

procedure TpjhPopupTouchKeyBoard.Show;
var
  wnd: THandle;
begin
  wnd := GetActiveWindow;
  if not Assigned(FFrm) then
    CreateForm;

  //FFrm.Width := Keyboard.Width;
  //FFrm.Height := Keyboard.Height;
  //FFrm.Visible := true;
  FTimer.Enabled := true;
  SetActiveWindow(wnd);

  if Assigned(OnShow) then
    OnShow(Self);
end;

procedure TpjhPopupTouchKeyBoard.ShowAtXY(AParent: TCustomForm; x, y: integer);
begin
  FOwnerForm := AParent;
  ShowAtXY(x,y);
end;

procedure TpjhPopupTouchKeyBoard.ShowAtXY(x, y: integer);
var
  wnd: THandle;
  w,h: integer;
begin
  if (FLastX = x) and (FLastY = y) then
    Exit;

  FLastX := x;
  FLastY := y;

  wnd := GetActiveWindow;
  if not Assigned(FFrm) then
    CreateForm;

  w := FFrm.Width;
  h := FFrm.Height;

  FDisableSizing := true;

  FFrm.Width := 0;
  FFrm.Height  := 0;
  FFrm.Left := X;
  FFrm.Top := Y;

  FFrm.Visible := true;

  FDisableSizing := false;
  MoveWindow(FFrm.Handle, X,Y, W, H, true);

  (*
  FFrm.Left := X;
  FFrm.Top := Y;
  FFrm.Width := w - 20 ;
  FFrm.Height := h;
  *)

  FTimer.Enabled := true;
  SetActiveWindow(wnd);
end;

procedure TpjhPopupTouchKeyBoard.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   FTimer.Enabled := False;
   if Assigned(FOnClose) then
     FOnClose(self);
end;

function TpjhPopupTouchKeyBoard.GetKeyboardRect: TRect;
begin
  Result := Rect(-1,-1,-1,-1);

  if Assigned(FFrm) then
    Result := Rect(FFrm.Left, FFrm.Top, FFrm.Left + FFrm.Width, FFrm.Top + FFrm.Height);
end;

procedure TpjhPopupTouchKeyBoard.TimerProc(Sender: TObject);
var
  wnd, awnd: THandle;
  r, wa: TRect;
  Selection: TSelection;
  pt: TPoint;
  isEdit, isCombo: boolean;
begin
  FTimer.Enabled := False;
  try
    awnd := GetActiveWindow;
    if awnd = FFrm.Handle then
      Exit;

    if FAutoFollowFocus then
    begin
      isCombo := false;

      wnd := WinApi.Windows.GetFocus;
      Selection.StartPos := -1;
      Selection.EndPos := -1;
      SendMessage(wnd, EM_GETSEL, Longint(@Selection.StartPos), LParam(@Selection.EndPos));

      // tests for edit, memo, spin, rich edit & descending components
      isEdit := Selection.StartPos <> -1;

      // tests for combo, datepicker
      if not isEdit then
      begin
        isCombo := SendMessage(wnd,CB_GETTOPINDEX,0,0) > 0;
        //isCombo := SendMessage(wnd,CB_GETCOUNT,0,0) > 0;
      end;

      if isEdit or isCombo then
      begin
        GetWindowRect(wnd,r);

        {$IFNDEF DELPHI7_LVL}

        SystemParametersInfo(SPI_GETWORKAREA, 0, @wa, 0);

        {$ENDIF}

        {$IFDEF DELPHI7_LVL}
        wa := Screen.MonitorFromPoint(Point(r.Left, r.Top)).WorkareaRect;
        {$ENDIF}

        // default X,Y pos
        pt.X := r.Left + 50;
        pt.Y := r.Bottom;

        if r.Left + 50 + FFrm.Width > wa.Right then
           pt.X := r.Right - FFrm.Width;

        if r.Bottom + FFrm.Height > wa.Bottom then
           pt.Y := r.Top - FFrm.Height;

        if pt.X < 0 then
          pt.X := 0;

        if pt.Y < 0 then
          pt.Y := 0;

        ShowAtXY(pt.X, pt.Y);
        //FFrm.Width := FKbd.Width;
      end
      else
      begin
        if FAutoHide then
        begin
          //FFrm.Width := 0;
          FFrm.Visible := false;
          FLastX := -1;
          FLastY := -1;
        end;
      end;
    end;
  finally
    FFrm.Visible := true;
    FTimer.Enabled := True;
  end;
end;

end.
