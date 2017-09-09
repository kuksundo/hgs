unit UnitDPMSInfoClass;

interface

uses classes, SysUtils, ExtCtrls, Vcl.Graphics, BaseConfigCollect;

type
  TDPMSUsagePerDateCollect = class;
  TDPMSUsagePerDateItem = class;
  TDPMSUsagePerDeptCollect = class;
  TDPMSUsagePerDeptItem = class;

  TDPMSInfo = class(TpjhBase)
  private
    FDPMSUsagePerDateCollect: TDPMSUsagePerDateCollect;
    FDPMSUsagePerDeptCollect: TDPMSUsagePerDeptCollect;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
  published
    property DPMSUsagePerDateCollect: TDPMSUsagePerDateCollect read FDPMSUsagePerDateCollect write FDPMSUsagePerDateCollect;
    property DPMSUsagePerDeptCollect: TDPMSUsagePerDeptCollect read FDPMSUsagePerDeptCollect write FDPMSUsagePerDeptCollect;
  end;

  TDPMSUsagePerDateItem = class(TCollectionItem)
  private
    FDate: string;
    FUsageCount: integer; //mSec
  published
    property FFDate: string read FDate write FDate;
    property UsageCount: integer read FUsageCount write FUsageCount;
  end;

  TDPMSUsagePerDateCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TDPMSUsagePerDateItem;
    procedure SetItem(Index: Integer; const Value: TDPMSUsagePerDateItem);
  public
    function Add: TDPMSUsagePerDateItem;
    function Insert(Index: Integer): TDPMSUsagePerDateItem;
    property Items[Index: Integer]: TDPMSUsagePerDateItem read GetItem  write SetItem; default;
  end;

  TDPMSUsagePerDeptItem = class(TCollectionItem)
  private
    FDept: string;
    FUserCount: integer;
    FProjCount: integer;
    FTaskCount: integer;
    FTotalUserCount : integer; //전체 부서원 수
    FUsage: Double; //사용률 (FUserCount/FTotalUserCount)
  published
    property Dept: string read FDept write FDept;
    property UserCount: integer read FUserCount write FUserCount;
    property ProjCount: integer read FProjCount write FProjCount;
    property TaskCount: integer read FTaskCount write FTaskCount;
    property TotalUserCount: integer read FTotalUserCount write FTotalUserCount;
    property Usage: Double read FUsage write FUsage;
  end;

  TDPMSUsagePerDeptCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TDPMSUsagePerDeptItem;
    procedure SetItem(Index: Integer; const Value: TDPMSUsagePerDeptItem);
  public
    function Add: TDPMSUsagePerDeptItem;
    function Insert(Index: Integer): TDPMSUsagePerDeptItem;
    property Items[Index: Integer]: TDPMSUsagePerDeptItem read GetItem  write SetItem; default;
  end;

implementation

{ TDPMSUsagePerDateCollect }

function TDPMSUsagePerDateCollect.Add: TDPMSUsagePerDateItem;
begin
  Result := TDPMSUsagePerDateItem(inherited Add);
end;

function TDPMSUsagePerDateCollect.GetItem(Index: Integer): TDPMSUsagePerDateItem;
begin
  Result := TDPMSUsagePerDateItem(inherited Items[Index]);
end;

function TDPMSUsagePerDateCollect.Insert(Index: Integer): TDPMSUsagePerDateItem;
begin
  Result := TDPMSUsagePerDateItem(inherited Insert(Index));
end;

procedure TDPMSUsagePerDateCollect.SetItem(Index: Integer;
  const Value: TDPMSUsagePerDateItem);
begin
  Items[Index].Assign(Value);
end;

{ TDPMSInfo }

procedure TDPMSInfo.Clear;
begin
  FDPMSUsagePerDateCollect.Clear;
end;

constructor TDPMSInfo.Create(AOwner: TComponent);
begin
  FDPMSUsagePerDateCollect := TDPMSUsagePerDateCollect.Create(TDPMSUsagePerDateItem);
  FDPMSUsagePerDeptCollect := TDPMSUsagePerDeptCollect.Create(TDPMSUsagePerDeptItem);
end;

destructor TDPMSInfo.Destroy;
begin
  FDPMSUsagePerDeptCollect.Free;
  FDPMSUsagePerDateCollect.Free;

  inherited;
end;

{ TDPMSUsagePerDeptCollect }

function TDPMSUsagePerDeptCollect.Add: TDPMSUsagePerDeptItem;
begin
  Result := TDPMSUsagePerDeptItem(inherited Add);
end;

function TDPMSUsagePerDeptCollect.GetItem(
  Index: Integer): TDPMSUsagePerDeptItem;
begin
  Result := TDPMSUsagePerDeptItem(inherited Items[Index]);
end;

function TDPMSUsagePerDeptCollect.Insert(Index: Integer): TDPMSUsagePerDeptItem;
begin
  Result := TDPMSUsagePerDeptItem(inherited Insert(Index));
end;

procedure TDPMSUsagePerDeptCollect.SetItem(Index: Integer;
  const Value: TDPMSUsagePerDeptItem);
begin
  Items[Index].Assign(Value);
end;

end.
