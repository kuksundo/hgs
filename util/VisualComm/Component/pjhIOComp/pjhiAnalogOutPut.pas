unit pjhiAnalogOutPut;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
  iAnalogOutPut, pjhclasses, pjhDesignCompIntf, pjhIOCompStdConst;

type
  TpjhiAnalogOutPut = class(TiAnalogOutPut, IpjhDesignCompInterface)
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

{ TpjhiAnalogOutPut }

constructor TpjhiAnalogOutPut.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhIOCompStdBplFileName;
end;

destructor TpjhiAnalogOutPut.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;

function TpjhiAnalogOutPut.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhiAnalogOutPut.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhiAnalogOutPut.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhiAnalogOutPut.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhiAnalogOutPut.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);
end;

procedure TpjhiAnalogOutPut.SetpjhValue(AValue: string);
begin
  if FpjhValue <> AValue then
  begin
    FpjhValue := AValue;
    Value := StrToFloatDef(AValue, 0.0);
  end;
end;

end.

