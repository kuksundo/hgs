unit pjhadvSmoothToggleButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
  AdvSmoothToggleButton, pjhclasses, pjhDesignCompIntf, pjhTMSSmoothCompConst;

type
  TpjhAdvSmoothToggleButton = class(TAdvSmoothToggleButton, IpjhDesignCompInterface)
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

{ TpjhAdvSmoothToggleButton }

constructor TpjhAdvSmoothToggleButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhTMSSmoothCompBplFileName;
end;

destructor TpjhAdvSmoothToggleButton.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;


function TpjhAdvSmoothToggleButton.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhAdvSmoothToggleButton.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhAdvSmoothToggleButton.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhAdvSmoothToggleButton.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhAdvSmoothToggleButton.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);
end;

procedure TpjhAdvSmoothToggleButton.SetpjhValue(AValue: string);
begin
  if FpjhValue <> AValue then
  begin
    FpjhValue := AValue;
    Caption := AValue;
    //Value := StrToFloatDef(AValue,0.0);
  end;
end;

end.

