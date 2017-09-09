unit pjhadvSmoothProgressBar;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
  AdvSmoothProgressBar, pjhclasses, pjhDesignCompIntf, pjhTMSSmoothCompConst;

type
  TpjhAdvSmoothProgressBar = class(TAdvSmoothProgressBar, IpjhDesignCompInterface)
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

{ TpjhAdvSmoothProgressBar }

constructor TpjhAdvSmoothProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhTMSSmoothCompBplFileName;
end;

destructor TpjhAdvSmoothProgressBar.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;


function TpjhAdvSmoothProgressBar.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhAdvSmoothProgressBar.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhAdvSmoothProgressBar.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhAdvSmoothProgressBar.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhAdvSmoothProgressBar.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);
end;

procedure TpjhAdvSmoothProgressBar.SetpjhValue(AValue: string);
begin
  if FpjhValue <> AValue then
  begin
    FpjhValue := AValue;
    Position := StrToFloatDef(AValue,0.0);
    //Value := StrToFloatDef(AValue,0.0);
  end;
end;

end.
