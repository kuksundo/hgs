unit u_dzLogConsole;

interface

uses
  Windows,
  SysUtils,
  Classes,
  u_dzLogging;

type
  TdzCustomLogConsole = class(TComponent)
  protected
    FAutoShow: boolean;
    FVisible: boolean;
    FOwnConsole: boolean;
    procedure SetVisible(const _Visible: boolean);
  public
    constructor Create(_Owner: TComponent); override;
    destructor Destroy; override;
    procedure LogCallback(const _s: string; _Level: TLogLevel);
    function ShowConsole: boolean;
    procedure HideConsole;
    property AutoShow: boolean read FAutoShow write FAutoShow default true;
    property Visible: boolean read FVisible write SetVisible default false;
  end;

  TdzLogConsole = class(TdzCustomLogConsole)
    property AutoShow;
    property Visible;
  end;

implementation

uses
  u_dzDateUtils;

{ TdzCustomLogConsole }

constructor TdzCustomLogConsole.Create(_Owner: TComponent);
begin
  inherited;
  FVisible := IsConsole;
  FOwnConsole := false;
  FAutoShow := true;
end;

destructor TdzCustomLogConsole.Destroy;
begin
  HideConsole;
  inherited;
end;

function TdzCustomLogConsole.ShowConsole: boolean;
begin
  if not FVisible then begin
    FVisible := AllocConsole;
    if FVisible then
      FOwnConsole := true;
  end;
  Result := FVisible;
end;

procedure TdzCustomLogConsole.LogCallback(const _s: string; _Level: TLogLevel);
var
  Marker: string;
  s: string;
begin
  if not FVisible then
    if FAutoShow then
      if not ShowConsole then
        exit;
  if not FVisible then
    exit;

  case _Level of
    llError: Marker := '!';
    llWarning: Marker := '+';
    llInfo: Marker := '-';
  else
    Marker := ' ';
  end;
  s := Format('%s%s %s', [Marker, DateTime2Iso(Now, True), _s]);
  WriteLn(s);
end;

procedure TdzCustomLogConsole.SetVisible(const _Visible: boolean);
begin
  if FVisible = _Visible then
    exit;
  if _Visible then
    ShowConsole
  else
    HideConsole;
end;

procedure TdzCustomLogConsole.HideConsole;
begin
  if not (FOwnConsole and FVisible) then
    exit;
  FreeConsole;
  FVisible := false;
  FOwnConsole := false;
end;

end.

