unit pjhTJvGIFAnimator;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Extctrls,
  JvGIFCtrl, pjhclasses, pjhDesignCompIntf, pjhJvCompConst;

type
  TpjhTJvGIFImage = class(TJvGIFAnimator, IpjhDesignCompInterface)
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
    destructor  Destroy;override;
  published
    //For IpjhDesignCompInterface
    property pjhTagInfo: TpjhTagInfo read GetpjhTagInfo write SetpjhTagInfo;
    property pjhValue: string read GetpjhValue write SetpjhValue;
    property pjhBplFileName: string read GetBplFileName write SetBplFileName;
    //For IpjhDesignCompInterface
  end;

implementation

{ TpjhadvSmoothGauge }

constructor TpjhTJvGIFImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhJvCompBplFileName;
end;

destructor TpjhTJvGIFImage.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;

function TpjhTJvGIFImage.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhTJvGIFImage.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhTJvGIFImage.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhTJvGIFImage.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhTJvGIFImage.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);
end;

procedure TpjhTJvGIFImage.SetpjhValue(AValue: string);
begin
  if FpjhValue <> AValue then
  begin
    FpjhValue := AValue;
//    Caption := AValue;
  end;
end;

end.
