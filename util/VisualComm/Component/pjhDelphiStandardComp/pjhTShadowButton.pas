unit pjhTShadowButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Extctrls,
  Vcl.Graphics, pjhclasses, pjhDesignCompIntf, pjhDelphiStandardCompConst, ShadowButton;

type
  TpjhTShadowButton = class(TShadowButton, IpjhDesignCompInterface)
  private
    FActiveColor: TColor;
    FInActiveColor: TColor;
  protected
    //For IpjhDesignCompInterface
    FpjhTagInfo: TpjhTagInfo;
    FpjhValue: string;
    FpjhBplFileName: string;

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
    property InActiveColor: TColor read FInActiveColor write SetInActiveColor default clRed;
  end;

implementation

{ TpjhadvSmoothGauge }

constructor TpjhTShadowButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhDelphiStandardBplFileName;

  FActiveColor := clLime;
  FInActiveColor := clRed;
end;

destructor TpjhTShadowButton.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;


function TpjhTShadowButton.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhTShadowButton.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhTShadowButton.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhTShadowButton.SetActiveColor(const Value: TColor);
begin
  if FActiveColor <> Value then
    FActiveColor := Value;
end;

procedure TpjhTShadowButton.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhTShadowButton.SetInactiveColor(const Value: TColor);
begin
  if FInActiveColor <> Value then
    FInActiveColor := Value;
end;

procedure TpjhTShadowButton.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);
end;

procedure TpjhTShadowButton.SetpjhValue(AValue: string);
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
