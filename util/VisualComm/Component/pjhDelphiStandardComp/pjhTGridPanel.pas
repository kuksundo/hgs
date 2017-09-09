unit pjhTGridPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Extctrls,
  pjhclasses, pjhDesignCompIntf, pjhDelphiStandardCompConst;

type
  TpjhTGridPanel = class(TGridPanel, IpjhDesignCompInterface)
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

{ TpjhadvSmoothGauge }

constructor TpjhTGridPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhDelphiStandardBplFileName;
end;

destructor TpjhTGridPanel.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;


function TpjhTGridPanel.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhTGridPanel.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhTGridPanel.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhTGridPanel.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhTGridPanel.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);
end;

procedure TpjhTGridPanel.SetpjhValue(AValue: string);
begin
  if FpjhValue <> AValue then
  begin
    FpjhValue := AValue;
    //Value := StrToFloatDef(AValue,0.0);
    Caption := AValue;
  end;
end;

end.
