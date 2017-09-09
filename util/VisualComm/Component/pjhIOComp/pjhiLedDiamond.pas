unit pjhiLedDiamond;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
  iLedDiamond, pjhclasses, pjhDesignCompIntf, pjhIOCompProConst;

type
  TpjhiLedDiamond = class(TiLedDiamond, IpjhDesignCompInterface)
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

{ TpjhiLedDiamond }

constructor TpjhiLedDiamond.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhIOCompProBplFileName;
end;

destructor TpjhiLedDiamond.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;


function TpjhiLedDiamond.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhiLedDiamond.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhiLedDiamond.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhiLedDiamond.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhiLedDiamond.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);
end;

procedure TpjhiLedDiamond.SetpjhValue(AValue: string);
begin
  if FpjhValue <> AValue then
  begin
    FpjhValue := AValue;
    Active := StrToBool(AValue);
  end;
end;

end.

