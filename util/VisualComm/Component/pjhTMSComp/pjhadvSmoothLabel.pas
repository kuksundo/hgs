unit pjhadvSmoothLabel;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
  AdvSmoothLabel, pjhclasses, pjhDesignCompIntf, pjhTMSSmoothCompConst;

type
  TpjhAdvSmoothLabel = class(TAdvSmoothLabel, IpjhDesignCompInterface)
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

{ TpjhAdvSmoothLabel }

constructor TpjhAdvSmoothLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhTMSSmoothCompBplFileName;
end;

destructor TpjhAdvSmoothLabel.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;


function TpjhAdvSmoothLabel.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhAdvSmoothLabel.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhAdvSmoothLabel.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhAdvSmoothLabel.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhAdvSmoothLabel.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);
end;

procedure TpjhAdvSmoothLabel.SetpjhValue(AValue: string);
begin
  if FpjhValue <> AValue then
  begin
    FpjhValue := AValue;
    Caption.Text := AValue;
    //Value := StrToFloatDef(AValue,0.0);
  end;
end;

end.
