unit pjhadvSmoothCalculator;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
  AdvSmoothCalculator, pjhclasses, pjhDesignCompIntf, pjhTMSSmoothCompConst;

type
  TpjhAdvSmoothCalculator = class(TAdvSmoothCalculator, IpjhDesignCompInterface)
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
  public
    constructor Create(AOwner: TComponent);  override;
    destructor  Destroy;                     override;
  published
    //For IpjhDesignCompInterface
    property pjhTagInfo: TpjhTagInfo read GetpjhTagInfo write SetpjhTagInfo;
    property pjhValue: string read GetpjhValue write SetpjhValue;
    property pjhBplFileName: string read GetBplFileName write SetBplFileName;
    //For IpjhDesignCompInterface
  end;

implementation

{ TpjhAdvSmoothCalculator }

constructor TpjhAdvSmoothCalculator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhTMSSmoothCompBplFileName;
end;

destructor TpjhAdvSmoothCalculator.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;


function TpjhAdvSmoothCalculator.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhAdvSmoothCalculator.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhAdvSmoothCalculator.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhAdvSmoothCalculator.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhAdvSmoothCalculator.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);
end;

procedure TpjhAdvSmoothCalculator.SetpjhValue(AValue: string);
begin
  if FpjhValue <> AValue then
  begin
    FpjhValue := AValue;
    //Value := StrToFloatDef(AValue,0.0);
  end;
end;

end.
