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
unit w_dzProgress;

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
  u_dzTranslator;

type
  EdzProgress = class(Exception);

type
  Tf_dzProgress = class(TForm)
    l_Action: TLabel;
    pb_Progress: TProgressBar;
    b_Abort: TButton;
    procedure b_AbortClick(Sender: TObject);
  private
    FIsAbortVisible: Boolean;
    FCancelPressed: Boolean;
    FProgressPos: Integer;
    FMax: Integer;
    FAction: string;
    FIsActionVisible: Boolean;
    FPercent: Integer;
    FFormCaption: string;
    FFormCaptionParams: Integer;
    FFormCaptionPercent: Boolean;
    FLastTickCount: Cardinal;
    FProgressTimeInterval: Cardinal;
    FConfirmAbort: Boolean;
    procedure SetFormCaption(const _FormCaption: string);
    procedure InternalSetCaption;
    procedure SetProgressPos(_ProgressPos: Integer);
    procedure SetMax(_Max: Integer);
    procedure SetAction(const _Action: string);
    procedure SetIsAbortVisible(_Visible: Boolean);
    procedure SetIsActionVisible(_Visible: Boolean);
    function AnalyseCaption(const _Caption: string;
      var _ParamCount: Integer; var _Percent: Boolean;
      var _Error: string): Boolean;
  public
    constructor Create(_Owner: TComponent); override;
    property FormCaption: string read FFormCaption write SetFormCaption;
    property ProgressPos: Integer read FProgressPos write SetProgressPos;
    property ProgressMax: Integer read FMax write SetMax;
    property Action: string read FAction write SetAction;
    property IsAbortVisible: Boolean read FIsAbortVisible write SetIsAbortVisible;
    property IsActionVisible: Boolean read FIsActionVisible write SetIsActionVisible;
    property ConfirmAbort: Boolean read FConfirmAbort write FConfirmAbort default True;
    ///<summary>
    /// @param AbortOnButton: if true, an EAbort exception is raised if the user pressed the
    ///                       AbortButton, otherwise the function just returns true in that case.
    ///                       defaults to true
    /// @returns true, if the user pressed abort </summary>
    function Progress(_Position: Integer; const _Action: string; _AbortOnButton: Boolean = True): Boolean; overload;
    ///<summary>
    /// @param AbortOnButton: if true, an EAbort exception is raised if the user pressed the
    ///                       AbortButton, otherwise the function just returns true in that case.
    ///                       defaults to true
    /// @returns true, if the user pressed abort </summary>
    function Progress(_Position: Integer; _AbortOnButton: Boolean = True): Boolean; overload;
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

constructor Tf_dzProgress.Create(_Owner: tComponent);
begin
  inherited;
  TranslateComponent(Self, 'dzlib');
  FConfirmAbort := True;
  FProgressTimeInterval := 200;
  FLastTickCount := 0;
  pb_Progress.Position := 0;
  FMax := 100;
  l_Action.Caption := '';
  FormCaption := _('Progress (%d%%)');

  PopupMode := pmExplicit;
  if _Owner is TCustomForm then
    PopupParent := _Owner as TCustomForm;
end;

procedure Tf_dzProgress.b_AbortClick(Sender: TObject);
begin
  if FConfirmAbort then
    FCancelPressed := (mrYes = Tf_dzDialog.ShowMessage(mtConfirmation, _('Do you really want to abort?'), [dbeYes, dbeNo], Self))
  else
    FCancelPressed := True;
end;

procedure Tf_dzProgress.InternalSetCaption;
var
  OldPercent: Integer;
begin
  if FFormCaptionPercent then begin
    OldPercent := FPercent;
    FPercent := (FProgressPos * 100) div FMax;
    if OldPercent = FPercent then
      exit;
  end;
  case FFormCaptionParams of
    0: Caption := FFormCaption;
    1:
      if FFormCaptionPercent then
        Caption := Format(FFormCaption, [FPercent])
      else
        Caption := Format(FFormCaption, [FProgressPos]);
    2: Caption := Format(FFormCaption, [FProgressPos, FMax]);
  end;
end;

function Tf_dzProgress.Progress(_Position: Integer; _AbortOnButton: Boolean = True): Boolean;
var
  NextTickCount: Int64;
begin
  // Durch ProcessMessages dauert die Anzeige meistens laenger als die eigentliche Berechnung
  // innerhalb der Schleife bei der die Progress-Funktion aufgerufen wird.
  // Deshalb nur alle 200msec updaten -> SUPER GESCHWINDIGKEITSOPTIMIERUNG
  // z.b. in Rd2Ea und Ea2Er (wurde sonst über AuswerteOdometer gemacht)
  // aber Vorsicht: GetTickCount laeuft nach ca. 25 Tagen ueber

  NextTickCount := (Int64(FLastTickCount) + Int64(FProgressTimeInterval)) and $FFFFFFFF;
  if (GetTickCount > NextTickCount) or (_Position = 0) then begin
    FProgressPos := _Position;
    pb_Progress.Position := _Position;
    InternalSetCaption;
    Application.ProcessMessages;
    FLastTickCount := GetTickCount;
    Result := FCancelPressed;
    if Result and _AbortOnButton then
      Abort;
  end else
    Result := False;
end;

function Tf_dzProgress.Progress(_Position: Integer; const _Action: string; _AbortOnButton: Boolean = True): Boolean;
begin
  FAction := _Action;
  l_Action.Caption := _Action;
  l_Action.Update;
  Result := Progress(_Position, _AbortOnButton);
end;

function Tf_dzProgress.AnalyseCaption(const _Caption: string; var _ParamCount: Integer;
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
      exit;
    end;
    if _Caption[p + 1] = 'd' then
      Inc(_ParamCount)
    else if _Caption[p + 1] = '%' then begin
      _Percent := True;
      Inc(p)
    end else begin
      _Error := _('"%" must be followed by "d" or "%".');
      exit;
    end;
    p := PosEx('%', _Caption, p + 1);
  end;
  if _ParamCount > 2 then
    _Error := _('too many parameters')
  else
    Result := True;
end;

procedure Tf_dzProgress.SetFormCaption(const _FormCaption: string);
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

procedure Tf_dzProgress.SetProgressPos(_ProgressPos: Integer);
begin
  FProgressPos := _ProgressPos;
  pb_Progress.Position := _ProgressPos;
  InternalSetCaption;
end;

procedure Tf_dzProgress.SetMax(_Max: Integer);
begin
  FMax := _Max;
  pb_Progress.Max := _Max;
  InternalSetCaption;
end;

procedure Tf_dzProgress.SetAction(const _Action: string);
begin
  FAction := _Action;
  l_Action.Caption := _Action;
  l_Action.Layout := tlCenter;
end;

procedure Tf_dzProgress.SetIsAbortVisible(_Visible: Boolean);
begin
  FIsAbortVisible := _Visible;
  b_Abort.Visible := FIsAbortVisible;
  if not FIsAbortVisible then
    pb_Progress.Width := ClientWidth - 2 * pb_Progress.Left
  else
    pb_Progress.Width := b_Abort.Left - 2 * pb_Progress.Left;
end;

procedure Tf_dzProgress.SetIsActionVisible(_Visible: Boolean);
begin
  FIsActionVisible := _Visible;
  l_Action.Visible := FIsActionVisible;
  if not FIsActionVisible then begin
    ClientHeight := 2 * 5 + b_Abort.Height;
    b_Abort.Top := (ClientHeight - b_Abort.Height) div 2;
    pb_Progress.Top := (ClientHeight - pb_Progress.Height) div 2;
  end else begin
    // as designed
    b_Abort.Top := 20;
    pb_Progress.Top := 24;
    Height := 76;
  end;
end;

end.

