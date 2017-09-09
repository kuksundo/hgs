{.GXFormatter.config=twm}
///<summary> generic progress form
///          This unit implements a generic progress form.
///          Create it, set FormCaption, optionally set ProgressMax, show the form.
///          Every now and then call Progress.
///          Free after you are done.
///          Note: You can use up to two %d and %% in FormCaption, examples:
///            FormCaption := 'progress %d of %d';
///            FormCaption := '%d%% done'; // display percentage
///            FormCaption := 'Progress - Line %d';
///          @author twm </summary>
unit w_dzMultiProgress;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  u_dzTranslator,
  u_dzProgressBarText;

type
  EdzProgress = class(Exception);

type
  Tf_dzMultiProgress = class(TForm)
    pb_Progress: TProgressBar;
    b_Abort: TButton;
    procedure b_AbortClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    const
      WM_CALLBACK = WM_USER + 4711;
    type
      TBarRec = record
      private
        FBar: TProgressBarText;
        FMax: Integer;
        FPos: Integer;
        procedure SetMax(const _Value: Integer);
        procedure SetPos(const _Value: Integer);
        procedure UpdatePos;
      public
        procedure Init(_Bar: TProgressBarText);
        property Max: Integer read FMax write SetMax;
        property Pos: Integer read FPos;
      end;
  private
    FIsAbortVisible: Boolean;
    FAbortPressed: Boolean;
    FPercent: Integer;
    FFormCaption: string;
    FFormCaptionParams: Integer;
    FFormCaptionPercent: Boolean;
    FNextTickCount: Int64;
    FProgressTimeInterval: Cardinal;
    FConfirmAbort: Boolean;
    FBars: array of TBarRec;
    FHeightMargin: Integer;
    FOwnerWindowProc: TWndMethod;
    FOwnerWasDisabled: Boolean;
    procedure SetFormCaption(const _FormCaption: string);
    procedure InternalSetCaption;
    function GetProgressPos(_Idx: Integer): Integer;
    procedure SetProgressPos(_Idx: Integer; _Value: Integer);
    function GetProgressMax(_Idx: Integer): Integer;
    procedure SetProgressMax(_Idx: Integer; _Value: Integer);
    function _GetAction(_Idx: Integer): string;
    procedure SetAction(_Idx: Integer; const _Action: string);
    procedure SetIsAbortVisible(_Visible: Boolean);
    function AnalyseCaption(const _Caption: string;
      var _ParamCount: Integer; var _Percent: Boolean;
      var _Error: string): Boolean;
    procedure doAbortPressed;
    procedure WMCallback(var _Msg: TMessage); message WM_CALLBACK;
    procedure WMSize(var _Msg: TWMSize); message WM_SIZE;
    procedure OwnerWindowProc(var _Msg: TMessage);
  public
    constructor Create(_Owner: TComponent); override;
    procedure ShowProgressModal(_Callback: TNotifyEvent);
    procedure Init(const _FormCaption: string; _BarCount: Integer);
    property FormCaption: string read FFormCaption write SetFormCaption;
    property ProgressPos[_Idx: Integer]: Integer read GetProgressPos write SetProgressPos;
    property ProgressMax[_Idx: Integer]: Integer read GetProgressMax write SetProgressMax;
    property Action[_Idx: Integer]: string read _GetAction write SetAction;
    property IsAbortVisible: Boolean read FIsAbortVisible write SetIsAbortVisible;
    property ConfirmAbort: Boolean read FConfirmAbort write FConfirmAbort default True;
    ///<summary>
    /// @param AbortOnButton: if true, an EAbort exception is raised if the user pressed the
    ///                       AbortButton, otherwise the function just returns true in that case.
    ///                       defaults to true
    /// @returns true, if the user pressed abort </summary>
    function Progress(_Idx: Integer; _Position: Integer; const _Action: string;
      _AbortOnButton: Boolean = True): Boolean; overload;
    ///<summary>
    /// @param AbortOnButton: if true, an EAbort exception is raised if the user pressed the
    ///                       AbortButton, otherwise the function just returns true in that case.
    ///                       defaults to true
    /// @returns true, if the user pressed abort </summary>
    function Progress(_Idx: Integer; _Position: Integer; _AbortOnButton: Boolean = True): Boolean; overload;
    procedure UpdateDisplay(_Force: Boolean);
    property ProgressTimeInterval: Cardinal read FProgressTimeInterval write FProgressTimeInterval;
  end;

implementation

{$R *.DFM}

uses
  StrUtils,
  w_dzDialog;

function _(const _s: string): string; inline;
begin
  Result := dzDGetText(_s, 'dzlib');
end;

{ Tf_dzMultiProgress }

constructor Tf_dzMultiProgress.Create(_Owner: TComponent);
begin
  inherited;
  TranslateComponent(Self, 'dzlib');
  FConfirmAbort := True;
  FProgressTimeInterval := 200;
  FNextTickCount := 0;
  FHeightMargin := ClientHeight - (pb_Progress.Top + pb_Progress.Height);
  Init(_('Progress (%d%%)'), 1);

  if _Owner is TCustomForm then begin
    PopupMode := pmExplicit;
    PopupParent := _Owner as TCustomForm;
    BorderIcons := [biSystemMenu, biMinimize];
  end;

  HandleNeeded;
end;

procedure Tf_dzMultiProgress.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  doAbortPressed;
  CanClose := FAbortPressed;
end;

function SizeTypeToStr(const _st: Integer): string;
begin
  case _st of
    SIZE_MAXHIDE: Result := 'SIZE_MAXHIDE';
    SIZE_MAXIMIZED: Result := 'SIZE_MAXIMIZED';
    SIZE_MAXSHOW: Result := 'SIZE_MAXSHOW';
    SIZE_MINIMIZED: Result := 'SIZE_MINIMIZED';
    SIZE_RESTORED: Result := 'SIZE_RESTORED';
  else
    Result := IntToStr(_st);
  end;
end;

procedure Tf_dzMultiProgress.OwnerWindowProc(var _Msg: TMessage);
var
  frm: TCustomForm;
  WndMethod: TWndMethod;
begin
  if Assigned(Owner) and (Owner is TCustomForm) then begin
    frm := Owner as TCustomForm;
    if (_Msg.Msg = WM_SYSCOMMAND) and (_Msg.wParam = SC_RESTORE) then begin
      if FOwnerWasDisabled then
        EnableWindow(frm.Handle, False);
      WndMethod := FOwnerWindowProc;
      if Assigned(FOwnerWindowProc) then begin
        frm.WindowProc := FOwnerWindowProc;
        FOwnerWindowProc := nil;
      end;
      frm.WindowState := wsNormal;
      WindowState := wsNormal;
      BringToFront;
      Application.BringToFront;
      if Assigned(WndMethod) then
        WndMethod(_Msg);
    end;
  end;
end;

procedure Tf_dzMultiProgress.WMSize(var _Msg: TWMSize);
var
  frm: TCustomForm;
begin
  inherited;
  if Assigned(Owner) and (Owner is TCustomForm) then begin
    frm := Owner as TCustomForm;
    if _Msg.SizeType = SIZE_MINIMIZED then begin
      frm.WindowState := wsMinimized;
      if not Assigned(FOwnerWindowProc) then begin
        FOwnerWindowProc := frm.WindowProc;
        frm.WindowProc := Self.OwnerWindowProc;
        FOwnerWasDisabled := EnableWindow(frm.Handle, True);
      end;
    end;
  end;
end;

procedure Tf_dzMultiProgress.Init(const _FormCaption: string; _BarCount: Integer);

  procedure AddBar(_Idx: Integer);
  var
    pb: TProgressBarText;
  begin
    pb := FBars[_Idx].FBar;
    if not Assigned(pb) then begin
      pb := TProgressBarText.Create(Self);
      pb.Name := '';
      pb.Parent := Self;
      pb.Left := 8;
      pb.Top := pb_Progress.Top + b_Abort.Height * _Idx;
      pb.Width := 297;
      pb.Height := 16;
    end;
    FBars[_Idx].Init(pb);
  end;

var
  i: Integer;
  pb: TProgressBar;
  OldLen: Integer;
  NewHeight: Integer;
begin
  FormCaption := _FormCaption;
  OldLen := Length(FBars);
  for i := _BarCount to OldLen - 1 do begin
    FreeAndNil(FBars[i].FBar);
  end;
  SetLength(FBars, _BarCount);
  for i := OldLen to _BarCount - 1 do begin
    AddBar(i);
  end;
  pb := FBars[_BarCount - 1].FBar;
  NewHeight := pb.Top + pb.Height + FHeightMargin;
  if NewHeight > ClientHeight then
    ClientHeight := NewHeight;
end;

procedure Tf_dzMultiProgress.b_AbortClick(Sender: TObject);
begin
  doAbortPressed;
end;

procedure Tf_dzMultiProgress.InternalSetCaption;
var
  OldPercent: Integer;
  ProgPos: Integer;
  ProgMax: Integer;
begin
  ProgPos := ProgressPos[0];
  ProgMax := ProgressMax[0];
  if FFormCaptionPercent then begin
    OldPercent := FPercent;
    FPercent := (ProgPos * 100) div ProgMax;
    if OldPercent = FPercent then
      Exit;
  end;
  case FFormCaptionParams of
    0: Caption := FFormCaption;
    1:
      if FFormCaptionPercent then
        Caption := Format(FFormCaption, [FPercent])
      else
        Caption := Format(FFormCaption, [ProgPos]);
    2: Caption := Format(FFormCaption, [ProgPos, ProgMax]);
  end;
end;

procedure Tf_dzMultiProgress.UpdateDisplay(_Force: Boolean);
var
  ThisTickCount: Int64;
  i: Integer;
begin
  // Calling ProcessMessages displaying the progress often takes longer than the actual processing
  // in which the Progress function is being called.
  // We therefore only update every 200msec -> This makes it much faster in many cases and
  // only marginally slows it down in all other cases.
  // GetTickCount overflows after apx. 25 days, so that's why there is the and $FFFFFFFF and
  // FNextTickCount is an Int64.
  ThisTickCount := GetTickCount;
  if _Force or (ThisTickCount > FNextTickCount) then begin
    FNextTickCount := (ThisTickCount + Int64(FProgressTimeInterval)) and $FFFFFFFF;
    InternalSetCaption;
    for i := Low(FBars) to High(FBars) do
      FBars[i].UpdatePos;
    Application.ProcessMessages;
  end;
end;

function Tf_dzMultiProgress.Progress(_Idx: Integer; _Position: Integer;
  _AbortOnButton: Boolean = True): Boolean;
begin
  FBars[_Idx].SetPos(_Position);
  UpdateDisplay(_Position = 0);
  Result := FAbortPressed;
  if Result and _AbortOnButton then
    Abort;
end;

procedure Tf_dzMultiProgress.doAbortPressed;
begin
  if not FAbortPressed then begin
    if FConfirmAbort then
      FAbortPressed := (mrYes = Tf_dzDialog.ShowMessage(mtConfirmation, _('Do you really want to abort?'), [dbeYes, dbeNo], Self))
    else
      FAbortPressed := True;
  end;
end;

function Tf_dzMultiProgress.Progress(_Idx: Integer; _Position: Integer; const _Action: string;
  _AbortOnButton: Boolean = True): Boolean;
begin
  Action[_Idx] := _Action;
  Result := Progress(_Idx, _Position, _AbortOnButton);
end;

function Tf_dzMultiProgress.AnalyseCaption(const _Caption: string; var _ParamCount: Integer;
  var _Percent: Boolean; var _Error: string): Boolean;
var
  p: Integer;
begin
  Result := False;
  _Percent := False;
  _ParamCount := 0;
  p := PosEx('%', _Caption, 1);
  while p <> 0 do begin
    if (p >= Length(_Caption)) then begin
      _Error := _('must not contain a % at the end');
      Exit;
    end;
    if _Caption[p + 1] = 'd' then
      Inc(_ParamCount)
    else if _Caption[p + 1] = '%' then begin
      _Percent := True;
      Inc(p)
    end else begin
      _Error := _('"%" must be followed by "d" or "%".');
      Exit;
    end;
    p := PosEx('%', _Caption, p + 1);
  end;
  if _ParamCount > 2 then
    _Error := _('too many parameters')
  else
    Result := True;
end;

procedure Tf_dzMultiProgress.SetFormCaption(const _FormCaption: string);
var
  Error: string;
  Percent: Boolean;
  Params: Integer;
begin
  if not AnalyseCaption(_FormCaption, Params, Percent, Error) then
    raise EdzProgress.CreateFmt(_('Invalid FormCaption, %s'), [Error]);
  FFormCaption := _FormCaption;
  FFormCaptionParams := Params;
  FFormCaptionPercent := Percent;
  InternalSetCaption;
end;

function Tf_dzMultiProgress.GetProgressPos(_Idx: Integer): Integer;
begin
  if _Idx > High(FBars) then
    Result := 0
  else
    Result := FBars[_Idx].Pos;
end;

procedure Tf_dzMultiProgress.SetProgressPos(_Idx: Integer; _Value: Integer);
begin
  FBars[_Idx].SetPos(_Value);
  UpdateDisplay(_Value = 0);
end;

procedure Tf_dzMultiProgress.ShowProgressModal(_Callback: TNotifyEvent);
var
  Method: TMethod;
begin
  HandleNeeded;
  Method := TMethod(_Callback);
  PostMessage(Handle, WM_CALLBACK, Integer(Method.Data), Integer(Method.Code));
  ShowModal;
end;

procedure Tf_dzMultiProgress.WMCallback(var _Msg: TMessage);
var
  Method: TMethod;
begin
  Method.Data := Pointer(_Msg.wParam);
  Method.Code := Pointer(_Msg.LParam);
  try
    TNotifyEvent(Method)(Self);
  finally
    Close;
  end;
end;

function Tf_dzMultiProgress._GetAction(_Idx: Integer): string;
begin
  Result := FBars[_Idx].FBar.Text;
end;

function Tf_dzMultiProgress.GetProgressMax(_Idx: Integer): Integer;
begin
  if _Idx > High(FBars) then
    Result := 100
  else
    Result := FBars[_Idx].Max;
end;

procedure Tf_dzMultiProgress.SetProgressMax(_Idx: Integer; _Value: Integer);
begin
  FBars[_Idx].Max := _Value;
  InternalSetCaption;
end;

procedure Tf_dzMultiProgress.SetAction(_Idx: Integer; const _Action: string);
begin
  FBars[_Idx].FBar.Text := _Action;
end;

procedure Tf_dzMultiProgress.SetIsAbortVisible(_Visible: Boolean);
begin
  FIsAbortVisible := _Visible;
  b_Abort.Visible := FIsAbortVisible;
  if not FIsAbortVisible then
    pb_Progress.Width := ClientWidth - 2 * pb_Progress.Left
  else
    pb_Progress.Width := b_Abort.Left - 2 * pb_Progress.Left;
end;

{ Tf_dzMultiProgress.TBarRec }

procedure Tf_dzMultiProgress.TBarRec.Init(_Bar: TProgressBarText);
begin
  FPos := 0;
  FMax := 100;
  FBar := _Bar;
  FBar.Max := 100;
  FBar.Position := 0;
end;

procedure Tf_dzMultiProgress.TBarRec.SetMax(const _Value: Integer);
begin
  FMax := _Value;
  FBar.Max := _Value;
end;

procedure Tf_dzMultiProgress.TBarRec.SetPos(const _Value: Integer);
begin
  FPos := _Value;
end;

procedure Tf_dzMultiProgress.TBarRec.UpdatePos;
begin
  FBar.Position := FPos;
end;

end.
