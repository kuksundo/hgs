unit pjhiPipe;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
  iPipe, pjhclasses, pjhDesignCompIntf, pjhIOCompProConst;

type
  TpjhiPipe = class(TiPipe, IpjhDesignCompInterface)
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

{ TpjhiPipe }

constructor TpjhiPipe.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FpjhTagInfo := TpjhTagInfo.Create;
  FpjhBplFileName := pjhIOCompProBplFileName;
end;

destructor TpjhiPipe.Destroy;
begin
  FpjhTagInfo.Free;
  inherited;
end;


function TpjhiPipe.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhiPipe.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhiPipe.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

procedure TpjhiPipe.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhiPipe.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);
end;

procedure TpjhiPipe.SetpjhValue(AValue: string);
begin
  if FpjhValue <> AValue then
  begin
    FpjhValue := AValue;
    FlowOn := StrToBool(AValue);
  end;
end;

end.
