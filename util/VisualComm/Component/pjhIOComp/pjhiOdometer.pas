unit pjhiOdometer;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
  iOdometer, pjhclasses, pjhDesignCompIntf, pjhIOCompStdConst;

type
  TpjhiOdometer = class(TiOdometer, IpjhDesignCompInterface)
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

{ TpjhiOdometer }

constructor TpjhiOdometer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhIOCompStdBplFileName;
end;

destructor TpjhiOdometer.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;

function TpjhiOdometer.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhiOdometer.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhiOdometer.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhiOdometer.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhiOdometer.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);
end;

procedure TpjhiOdometer.SetpjhValue(AValue: string);
begin
  if FpjhValue <> AValue then
  begin
    FpjhValue := AValue;
    Value := StrToInt(AValue);
  end;
end;

end.

