unit pjhadvSmoothTimeLine;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
  AdvSmoothTimeLine, pjhclasses, pjhDesignCompIntf, pjhTMSSmoothCompConst;

type
  TpjhAdvSmoothTimeLine = class(TAdvSmoothTimeLine, IpjhDesignCompInterface)
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

{ TpjhAdvSmoothTimeLine }

constructor TpjhAdvSmoothTimeLine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhTMSSmoothCompBplFileName;
end;

destructor TpjhAdvSmoothTimeLine.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;


function TpjhAdvSmoothTimeLine.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhAdvSmoothTimeLine.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhAdvSmoothTimeLine.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhAdvSmoothTimeLine.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhAdvSmoothTimeLine.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);
end;

procedure TpjhAdvSmoothTimeLine.SetpjhValue(AValue: string);
begin
  if FpjhValue <> AValue then
  begin
    FpjhValue := AValue;
    //Value := StrToFloatDef(AValue,0.0);
  end;
end;

end.
