unit pjhTLedPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Extctrls,
  Vcl.Graphics, pjhclasses, pjhDesignCompIntf, pjhDelphiStandardCompConst;

type
  TpjhLedPanel = class(TPanel, IpjhDesignCompInterface)
  protected
    //For IpjhDesignCompInterface
    FpjhTagInfo: TpjhTagInfo;
    FpjhValue: string;
    FpjhBplFileName: string;

    FActiveColor,
    FInActiveColor: TColor;
    FDesc2Caption: Boolean;

    function GetpjhValue: string;
    procedure SetpjhValue(AValue: string);
    function GetpjhTagInfo: TpjhTagInfo;
    procedure SetpjhTagInfo(AValue: TpjhTagInfo);
    function GetBplFileName: string;
    procedure SetBplFileName(AValue: string);
    //For IpjhDesignCompInterface

    procedure SetActiveColor      (const Value: TColor);
    procedure SetInactiveColor    (const Value: TColor);
  public
    constructor Create(AOwner: TComponent);  override;
    destructor  Destroy;                     override;
  published
    //For IpjhDesignCompInterface
    property pjhTagInfo: TpjhTagInfo read GetpjhTagInfo write SetpjhTagInfo;
    property pjhValue: string read GetpjhValue write SetpjhValue;
    property pjhBplFileName: string read GetBplFileName write SetBplFileName;
    //For IpjhDesignCompInterface

    property ActiveColor: TColor read FActiveColor write SetActiveColor default clLime;
    property InActiveColor: TColor read FInActiveColor write SetInActiveColor default $00005500;
    property AutoCaption: Boolean read FDesc2Caption write FDesc2Caption default False;
  end;

implementation

{ TpjhadvSmoothGauge }

constructor TpjhLedPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhDelphiStandardBplFileName;

  FActiveColor := clLime;
  FInActiveColor := $00005500;
end;

destructor TpjhLedPanel.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;


function TpjhLedPanel.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhLedPanel.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhLedPanel.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhLedPanel.SetActiveColor(const Value: TColor);
begin
  if FActiveColor <> Value then
  begin
    FActiveColor := Value;

    if StrToBoolDef(pjhValue, False) then
      Color := Value;
  end;
end;

procedure TpjhLedPanel.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhLedPanel.SetInactiveColor(const Value: TColor);
begin
  if FInActiveColor <> Value then
  begin
    FInActiveColor := Value;

    if not StrToBoolDef(pjhValue, False) then
      Color := Value;
  end;
end;

procedure TpjhLedPanel.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);

  if FDesc2Caption then
    Caption := pjhTagInfo.Description;
end;

procedure TpjhLedPanel.SetpjhValue(AValue: string);
var
  LActive: Boolean;
begin
  if FpjhValue <> AValue then
  begin
    FpjhValue := AValue;
    LActive := StrToBool(AValue);
    if LActive then
      Color := ActiveColor
    else
      Color := InActiveColor;
  end;
end;

end.
