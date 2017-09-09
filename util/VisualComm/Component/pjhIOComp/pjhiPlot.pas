unit pjhiPlot;

interface

uses
  Windows, Messages, SysUtils, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus,
  iPlot, pjhclasses, pjhDesignCompIntf, pjhDesignCompIntf2, pjhIOCompPlotConst;

type
  TpjhiPlot = class(TiPlot, IpjhDesignCompInterface, IpjhDesignCompInterface2)
  private
    //function GetpjhValues(AIndex: integer): string;
    //procedure SetpjhValues(AIndex: integer; AValueX, AValueY: string);
  protected
    FpjhTagInfo: TpjhTagInfo;
    FpjhValue: string;
    FpjhBplFileName: string;
    FpjhTagInfoList: TStringList;

    //For IpjhDesignCompInterface
    function GetpjhValue: string;
    procedure SetpjhValue(AValue: string);
    function GetpjhTagInfo: TpjhTagInfo;
    procedure SetpjhTagInfo(AValue: TpjhTagInfo);
    function GetBplFileName: string;
    procedure SetBplFileName(AValue: string);
    //For IpjhDesignCompInterface

    //For IpjhDesignCompInterface2
    //function GetpjhValues(AIndex: integer): string;
    //procedure SetpjhValues(AIndex: integer; AValueX, AValueY: string);
    function GetpjhTagInfoList: TStringList;
    procedure SetpjhTagInfoList(AValue: TStringList);
    function GetpjhChannelCount: integer;
    //function GetpjhTagInfos(AIndex: integer): TpjhTagInfo;
    //procedure SetpjhTagInfos(AIndex: integer; AValue: TpjhTagInfo);
    //For IpjhDesignCompInterface2

    procedure iPlotOnAddChannel(Index: Integer);
    procedure iPlotOnRemoveChannel(Index: Integer);
  public
    constructor Create(AOwner: TComponent);  override;
    destructor  Destroy;                     override;

    //For IpjhDesignCompInterface2
    procedure SetpjhValues2Channel(AIndex: integer; AValueX, AValueY: string);
  published
    //For IpjhDesignCompInterface
    property pjhTagInfo: TpjhTagInfo read GetpjhTagInfo write SetpjhTagInfo;
    property pjhValue: string read GetpjhValue write SetpjhValue;
    property pjhBplFileName: string read GetBplFileName write SetBplFileName;
    //For IpjhDesignCompInterface

    //For IpjhDesignCompInterface2
    property pjhTagInfoList: TStringList read GetpjhTagInfoList write SetpjhTagInfoList;
    //property pjhTagInfos[Idx: integer]: TpjhTagInfo read GetpjhTagInfos write SetpjhTagInfos;
    //property pjhValues[Idx: integer]: string read GetpjhValues write SetpjhValues;
    property pjhChannelCount: integer read GetpjhChannelCount;
    //For IpjhDesignCompInterface2
  end;

implementation

{ TpjhiPlot }

constructor TpjhiPlot.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  OnAddChannel := iPlotOnAddChannel;
  OnRemoveChannel := iPlotOnRemoveChannel;
  //FpjhTagInfo := TpjhTagInfo.Create;
  FpjhTagInfoList := TStringList.Create;
  FpjhBplFileName := pjhIOCompPlotBplFileName;
end;

destructor TpjhiPlot.Destroy;
var
  i: integer;
begin
  //FpjhTagInfo.Free;
  for i := 0 to FpjhTagInfoList.Count - 1 do
  begin
    TpjhTagInfo(FpjhTagInfoList.Objects[i]).Free;
  end;

  FpjhTagInfoList.Free;

  inherited;
end;


function TpjhiPlot.GetBplFileName: string;
begin
  Result := FpjhBplFileName;
end;

function TpjhiPlot.GetpjhChannelCount: integer;
begin
  Result := ChannelCount;
end;

function TpjhiPlot.GetpjhTagInfo: TpjhTagInfo;
begin
  Result := FpjhTagInfo;
end;

function TpjhiPlot.GetpjhTagInfoList: TStringList;
begin
  Result := FpjhTagInfoList;
end;
{
function TpjhiPlot.GetpjhTagInfos(AIndex: integer): TpjhTagInfo;
begin
  Result := TpjhTagInfo(FpjhTagInfoList.Objects[AIndex]);
end;
}
function TpjhiPlot.GetpjhValue: string;
begin
  Result := FpjhValue;
end;

{
function TpjhiPlot.GetpjhValues(AIndex: integer): string;
begin
  Result := FpjhTagInfoList.Strings[AIndex];
end;
}

procedure TpjhiPlot.iPlotOnAddChannel(Index: Integer);
begin
  FpjhTagInfoList.AddObject(IntToStr(Index), TpjhTagInfo.Create);
end;

procedure TpjhiPlot.iPlotOnRemoveChannel(Index: Integer);
begin
  TpjhTagInfo(FpjhTagInfoList.Objects[Index]).Free;
  FpjhTagInfoList.Delete(Index);
end;

procedure TpjhiPlot.SetBplFileName(AValue: string);
begin
  FpjhBplFileName := AValue;
end;

procedure TpjhiPlot.SetpjhTagInfo(AValue: TpjhTagInfo);
begin
  FpjhTagInfo.Assign(AValue);
end;

procedure TpjhiPlot.SetpjhTagInfoList(AValue: TStringList);
begin
  FpjhTagInfoList.Assign(AValue);
end;

{
procedure TpjhiPlot.SetpjhTagInfos(AIndex: integer; AValue: TpjhTagInfo);
begin
  if Assigned(FpjhTagInfoList.Objects[AIndex]) then
  begin
    TpjhTagInfo(FpjhTagInfoList.Objects[AIndex]).Free;
    FpjhTagInfoList.AddObject(AIndex, AValue);
  end;
end;
}

procedure TpjhiPlot.SetpjhValue(AValue: string);
begin
  if FpjhValue <> AValue then
  begin
    FpjhValue := AValue;
  end;
end;
{
procedure TpjhiPlot.SetpjhValues(AIndex: integer; AValueX, AValueY: string);
var
  LDouble1, LDouble2: Extended;
begin
  if AIndex < ChannelCount then
  begin
    LDouble1 := StrToFloatDef(AValueX, 0.0);
    LDouble2 := StrToFloatDef(AValueY, 0.0);

    Channel[AIndex].AddXY(LDouble1, LDouble2);
  end;
end;
}
procedure TpjhiPlot.SetpjhValues2Channel(AIndex: integer; AValueX,
  AValueY: string);
var
  LDouble1, LDouble2: Extended;
begin
  if AIndex < ChannelCount then
  begin
    LDouble1 := StrToFloatDef(AValueX, 0.0);
    LDouble2 := StrToFloatDef(AValueY, 0.0);

    Channel[AIndex].AddXY(LDouble1, LDouble2);
  end;
end;

end.

