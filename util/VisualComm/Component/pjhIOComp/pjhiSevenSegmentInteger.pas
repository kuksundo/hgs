unit pjhiSevenSegmentInteger;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
  iSevenSegmentInteger, pjhclasses, pjhDesignCompIntf, pjhIOCompStdConst;

type
  TpjhiSevenSegmentInteger = class(TiSevenSegmentInteger, IpjhDesignCompInterface)
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

{ TpjhiSevenSegmentInteger }

constructor TpjhiSevenSegmentInteger.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhIOCompStdBplFileName;
end;

destructor TpjhiSevenSegmentInteger.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;

function TpjhiSevenSegmentInteger.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhiSevenSegmentInteger.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhiSevenSegmentInteger.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhiSevenSegmentInteger.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhiSevenSegmentInteger.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);
end;

procedure TpjhiSevenSegmentInteger.SetpjhValue(AValue: string);
begin
  if FpjhValue <> AValue then
  begin
    FpjhValue := AValue;
    Value := StrToInt(AValue);
  end;
end;

end.

