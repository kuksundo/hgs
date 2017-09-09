unit UnitExtraMHInfoClass;

interface

uses classes, SysUtils, ExtCtrls, Vcl.Graphics, BaseConfigCollect;

type
  TExtraMHPerMonthCollect = class;//월별 추가 공수
  TExtraMHPerMonthItem = class;
  TExtraMHPerProductPerMonthCollect = class; //제품별 월별 추가 공수(대형,중형,선미재,환경기계,산업기계,터보기계,발전설비,로봇)
  TExtraMHPerProductPerMonthItem = class;
  TExtraMHPerDeptCollect = class;//부서별 추가 공수
  TExtraMHPerDeptItem = class;
  TExtraMHPerProductPerDeptCollect = class; //제품별 부서별 추가 공수(대형,중형,선미재,환경기계,산업기계,터보기계,발전설비,로봇)
  TExtraMHPerProductPerDeptItem = class;
  TFailExtraMHPerMonthCollect = class;//월별 실패 비용(금액변제 추가공수)
  TFailExtraMHPerMonthItem = class;
  TOriginalMHPerMonthCollect = class;//월별 본공수
  TOriginalMHPerMonthItem = class;

  TExtraMHInfo = class(TpjhBase)
  private
    FExtraMHPerMonthCollect: TExtraMHPerMonthCollect;
    FExtraMHPerProductPerMonthCollect: TExtraMHPerProductPerMonthCollect;
    FExtraMHPerDeptCollect: TExtraMHPerDeptCollect;
    FExtraMHPerProductPerDeptCollect: TExtraMHPerProductPerDeptCollect;
    FFailExtraMHPerMonthCollect: TFailExtraMHPerMonthCollect;
    FOriginalMHPerMonthCollect: TOriginalMHPerMonthCollect;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
  published
    property ExtraMHPerMonthCollect: TExtraMHPerMonthCollect read FExtraMHPerMonthCollect write FExtraMHPerMonthCollect;
    property ExtraMHPerProductPerMonthCollect: TExtraMHPerProductPerMonthCollect read FExtraMHPerProductPerMonthCollect write FExtraMHPerProductPerMonthCollect;
    property ExtraMHPerDeptCollect: TExtraMHPerDeptCollect read FExtraMHPerDeptCollect write FExtraMHPerDeptCollect;
    property ExtraMHPerProductPerDeptCollect: TExtraMHPerProductPerDeptCollect read FExtraMHPerProductPerDeptCollect write FExtraMHPerProductPerDeptCollect;
    property FailExtraMHPerMonthCollect: TFailExtraMHPerMonthCollect read FFailExtraMHPerMonthCollect write FFailExtraMHPerMonthCollect;
    property OriginalMHPerMonthCollect: TOriginalMHPerMonthCollect read FOriginalMHPerMonthCollect write FOriginalMHPerMonthCollect;
  end;

  TExtraMHPerMonthItem = class(TCollectionItem)
  private
    FYYYYMM: string;
    FYYYY, FMM: integer;
    FM_H: double;
  published
    property YYYYMM: string read FYYYYMM write FYYYYMM;
    property YYYY: integer read FYYYY write FYYYY;
    property MM: integer read FMM write FMM;
    property M_H: double read FM_H write FM_H;
  end;

  TExtraMHPerMonthCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TExtraMHPerMonthItem;
    procedure SetItem(Index: Integer; const Value: TExtraMHPerMonthItem);
  public
    function Add: TExtraMHPerMonthItem;
    function Insert(Index: Integer): TExtraMHPerMonthItem;
    property Items[Index: Integer]: TExtraMHPerMonthItem read GetItem  write SetItem; default;
  end;

  TExtraMHPerProductPerMonthItem = class(TCollectionItem)
  private
    FProductName,
    FYYYYMM: string;
    FYYYY, FMM: integer;
    FM_H: double;
  published
    property ProductName: string read FProductName write FProductName;
    property YYYYMM: string read FYYYYMM write FYYYYMM;
    property YYYY: integer read FYYYY write FYYYY;
    property MM: integer read FMM write FMM;
    property M_H: double read FM_H write FM_H;
  end;

  TExtraMHPerProductPerMonthCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TExtraMHPerProductPerMonthItem;
    procedure SetItem(Index: Integer; const Value: TExtraMHPerProductPerMonthItem);
  public
    function Add: TExtraMHPerProductPerMonthItem;
    function Insert(Index: Integer): TExtraMHPerProductPerMonthItem;
    property Items[Index: Integer]: TExtraMHPerProductPerMonthItem read GetItem  write SetItem; default;
  end;

  TExtraMHPerDeptItem = class(TCollectionItem)
  private
    FDeptCode: string;
    FM_H: double;
  published
    property DeptCode: string read FDeptCode write FDeptCode;
    property M_H: double read FM_H write FM_H;
  end;

  TExtraMHPerDeptCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TExtraMHPerDeptItem;
    procedure SetItem(Index: Integer; const Value: TExtraMHPerDeptItem);
  public
    function Add: TExtraMHPerDeptItem;
    function Insert(Index: Integer): TExtraMHPerDeptItem;
    property Items[Index: Integer]: TExtraMHPerDeptItem read GetItem  write SetItem; default;
  end;

  TExtraMHPerProductPerDeptItem = class(TCollectionItem)
  private
    FProductName,
    FDeptCode: string;
    FM_H: double;
  published
    property ProductName: string read FProductName write FProductName;
    property DeptCode: string read FDeptCode write FDeptCode;
    property M_H: double read FM_H write FM_H;
  end;

  TExtraMHPerProductPerDeptCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TExtraMHPerProductPerDeptItem;
    procedure SetItem(Index: Integer; const Value: TExtraMHPerProductPerDeptItem);
  public
    function Add: TExtraMHPerProductPerDeptItem;
    function Insert(Index: Integer): TExtraMHPerProductPerDeptItem;
    property Items[Index: Integer]: TExtraMHPerProductPerDeptItem read GetItem  write SetItem; default;
  end;

  TFailExtraMHPerMonthItem = class(TCollectionItem)
  private
    FMM: integer;
    FM_H: double;
  published
    property MM: integer read FMM write FMM;
    property M_H: double read FM_H write FM_H;
  end;

  TFailExtraMHPerMonthCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TFailExtraMHPerMonthItem;
    procedure SetItem(Index: Integer; const Value: TFailExtraMHPerMonthItem);
  public
    function Add: TFailExtraMHPerMonthItem;
    function Insert(Index: Integer): TFailExtraMHPerMonthItem;
    property Items[Index: Integer]: TFailExtraMHPerMonthItem read GetItem  write SetItem; default;
  end;

  TOriginalMHPerMonthItem = class(TCollectionItem)
  private
    FMM: integer;
    FM_H: double;
  published
    property MM: integer read FMM write FMM;
    property M_H: double read FM_H write FM_H;
  end;

  TOriginalMHPerMonthCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TOriginalMHPerMonthItem;
    procedure SetItem(Index: Integer; const Value: TOriginalMHPerMonthItem);
  public
    function Add: TOriginalMHPerMonthItem;
    function Insert(Index: Integer): TOriginalMHPerMonthItem;
    property Items[Index: Integer]: TOriginalMHPerMonthItem read GetItem  write SetItem; default;
  end;

implementation

{ TExtraMHPerMonthCollect }

function TExtraMHPerMonthCollect.Add: TExtraMHPerMonthItem;
begin
  Result := TExtraMHPerMonthItem(inherited Add);
end;

function TExtraMHPerMonthCollect.GetItem(Index: Integer): TExtraMHPerMonthItem;
begin
  Result := TExtraMHPerMonthItem(inherited Items[Index]);
end;

function TExtraMHPerMonthCollect.Insert(Index: Integer): TExtraMHPerMonthItem;
begin
  Result := TExtraMHPerMonthItem(inherited Insert(Index));
end;

procedure TExtraMHPerMonthCollect.SetItem(Index: Integer;
  const Value: TExtraMHPerMonthItem);
begin
  Items[Index].Assign(Value);
end;

{ TExtraMHInfo }

procedure TExtraMHInfo.Clear;
begin
  FExtraMHPerMonthCollect.Clear;
end;

constructor TExtraMHInfo.Create(AOwner: TComponent);
begin
  FExtraMHPerMonthCollect := TExtraMHPerMonthCollect.Create(TExtraMHPerMonthItem);
  FExtraMHPerProductPerMonthCollect := TExtraMHPerProductPerMonthCollect.Create(TExtraMHPerProductPerMonthItem);
  FExtraMHPerDeptCollect := TExtraMHPerDeptCollect.Create(TExtraMHPerDeptItem);
  FExtraMHPerProductPerDeptCollect := TExtraMHPerProductPerDeptCollect.Create(TExtraMHPerProductPerDeptItem);
  FFailExtraMHPerMonthCollect := TFailExtraMHPerMonthCollect.Create(TFailExtraMHPerMonthItem);
  FOriginalMHPerMonthCollect := TOriginalMHPerMonthCollect.Create(TOriginalMHPerMonthItem);
end;

destructor TExtraMHInfo.Destroy;
begin
  FExtraMHPerProductPerMonthCollect.Free;
  FExtraMHPerMonthCollect.Free;
  FExtraMHPerDeptCollect.Free;
  FExtraMHPerProductPerDeptCollect.Free;
  FFailExtraMHPerMonthCollect.Free;
  FOriginalMHPerMonthCollect.Free;

  inherited;
end;

{ TExtraMHPerProductPerMonthCollect }

function TExtraMHPerProductPerMonthCollect.Add: TExtraMHPerProductPerMonthItem;
begin
  Result := TExtraMHPerProductPerMonthItem(inherited Add);
end;

function TExtraMHPerProductPerMonthCollect.GetItem(
  Index: Integer): TExtraMHPerProductPerMonthItem;
begin
  Result := TExtraMHPerProductPerMonthItem(inherited Items[Index]);
end;

function TExtraMHPerProductPerMonthCollect.Insert(Index: Integer): TExtraMHPerProductPerMonthItem;
begin
  Result := TExtraMHPerProductPerMonthItem(inherited Insert(Index));
end;

procedure TExtraMHPerProductPerMonthCollect.SetItem(Index: Integer;
  const Value: TExtraMHPerProductPerMonthItem);
begin
  Items[Index].Assign(Value);
end;

{ TExtraMHPerDeptCollect }

function TExtraMHPerDeptCollect.Add: TExtraMHPerDeptItem;
begin
  Result := TExtraMHPerDeptItem(inherited Add);
end;

function TExtraMHPerDeptCollect.GetItem(Index: Integer): TExtraMHPerDeptItem;
begin
  Result := TExtraMHPerDeptItem(inherited Items[Index]);
end;

function TExtraMHPerDeptCollect.Insert(Index: Integer): TExtraMHPerDeptItem;
begin
  Result := TExtraMHPerDeptItem(inherited Insert(Index));
end;

procedure TExtraMHPerDeptCollect.SetItem(Index: Integer;
  const Value: TExtraMHPerDeptItem);
begin
  Items[Index].Assign(Value);
end;

{ TExtraMHPerProductPerDeptCollect }

function TExtraMHPerProductPerDeptCollect.Add: TExtraMHPerProductPerDeptItem;
begin
  Result := TExtraMHPerProductPerDeptItem(inherited Add);
end;

function TExtraMHPerProductPerDeptCollect.GetItem(
  Index: Integer): TExtraMHPerProductPerDeptItem;
begin
  Result := TExtraMHPerProductPerDeptItem(inherited Items[Index]);
end;

function TExtraMHPerProductPerDeptCollect.Insert(
  Index: Integer): TExtraMHPerProductPerDeptItem;
begin
  Result := TExtraMHPerProductPerDeptItem(inherited Insert(Index));
end;

procedure TExtraMHPerProductPerDeptCollect.SetItem(Index: Integer;
  const Value: TExtraMHPerProductPerDeptItem);
begin
  Items[Index].Assign(Value);
end;

{ TFailExtraMHPerMonthCollect }

function TFailExtraMHPerMonthCollect.Add: TFailExtraMHPerMonthItem;
begin
  Result := TFailExtraMHPerMonthItem(inherited Add);
end;

function TFailExtraMHPerMonthCollect.GetItem(
  Index: Integer): TFailExtraMHPerMonthItem;
begin
  Result := TFailExtraMHPerMonthItem(inherited Items[Index]);
end;

function TFailExtraMHPerMonthCollect.Insert(
  Index: Integer): TFailExtraMHPerMonthItem;
begin
  Result := TFailExtraMHPerMonthItem(inherited Insert(Index));
end;

procedure TFailExtraMHPerMonthCollect.SetItem(Index: Integer;
  const Value: TFailExtraMHPerMonthItem);
begin
  Items[Index].Assign(Value);
end;

{ TOriginalMHPerMonthCollect }

function TOriginalMHPerMonthCollect.Add: TOriginalMHPerMonthItem;
begin
  Result := TOriginalMHPerMonthItem(inherited Add);
end;

function TOriginalMHPerMonthCollect.GetItem(
  Index: Integer): TOriginalMHPerMonthItem;
begin
  Result := TOriginalMHPerMonthItem(inherited Items[Index]);
end;

function TOriginalMHPerMonthCollect.Insert(
  Index: Integer): TOriginalMHPerMonthItem;
begin
  Result := TOriginalMHPerMonthItem(inherited Insert(Index));
end;

procedure TOriginalMHPerMonthCollect.SetItem(Index: Integer;
  const Value: TOriginalMHPerMonthItem);
begin
  Items[Index].Assign(Value);
end;

end.
