unit pjhIOCompStd;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
  iAngularGauge, pjhclasses, pjhDesignCompIntf, pjhIOCompStdConst;

type
  TpjhiAngularGuage = class(TiAngularGauge, IpjhDesignCompInterface)
  protected
    //For IpjhDesignCompInterface
    FpjhTagInfo: TpjhTagInfo;
    FpjhValue: string;
    FpjhBplFileName: string;

    function GetpjhValue: string;
    procedure SetpjhValue(Value: string);
    function GetpjhTagInfo: TpjhTagInfo;
    procedure SetpjhTagInfo(Value: TpjhTagInfo);
    function GetBplFileName: string;
    procedure SetBplFileName(Value: string);
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

{ TpjhiAngularGuage }

constructor TpjhiAngularGuage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhIOCompStdBplFileName;
end;

destructor TpjhiAngularGuage.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;


function TpjhiAngularGuage.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhiAngularGuage.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhiAngularGuage.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhiAngularGuage.SetBplFileName(Value: string);
begin
  FpjhBplFileName := Value;
end;

procedure TpjhiAngularGuage.SetpjhTagInfo(Value: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(Value);
end;

procedure TpjhiAngularGuage.SetpjhValue(Value: string);
begin
  if FpjhValue <> Value then
  begin
    FpjhValue := Value;
    Position := StrToFloat(Value);
  end;
end;

end.
