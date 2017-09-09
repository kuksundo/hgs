unit pjhiSevenSegmentAnalog;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
  iSevenSegmentAnalog, pjhclasses, pjhDesignCompIntf, pjhIOCompStdConst;

type
  TpjhiSevenSegmentAnalog = class(TiSevenSegmentAnalog, IpjhDesignCompInterface)
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

{ TpjhiSevenSegmentAnalog }

constructor TpjhiSevenSegmentAnalog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhIOCompStdBplFileName;
end;

destructor TpjhiSevenSegmentAnalog.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;

function TpjhiSevenSegmentAnalog.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhiSevenSegmentAnalog.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhiSevenSegmentAnalog.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhiSevenSegmentAnalog.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhiSevenSegmentAnalog.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);
end;

procedure TpjhiSevenSegmentAnalog.SetpjhValue(AValue: string);
begin
  if FpjhValue <> AValue then
  begin
    FpjhValue := AValue;
    Value := StrToFloatDef(AValue, 0.0);
  end;
end;

end.
