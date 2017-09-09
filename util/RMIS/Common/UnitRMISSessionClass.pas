unit UnitRMISSessionClass;

interface

uses Classes, Generics.Legacy, BaseConfigCollect;

type

//  TRMISUserCollect<TRMISUserItem> = class;//월별 추가 공수
//  TRMISUserItem = class;

  TRMISUserItem = class(TCollectionItem)
  private
    FUserId,
    FPassword,
    FUserName,
    FTeamCode,
    FTeamName,
    FDeptCode,
    FDeptName,
    FGrade,  //직급
    FPosition: string;//직책(생산반장,생산팀장,직책과장,부서장,중역,담당임원)
  published
    property UserId: string read FUserId write FUserId;
    property Password: string read FPassword write FPassword;
    property UserName: string read FUserName write FUserName;
    property TeamCode: string read FTeamCode write FTeamCode;
    property TeamName: string read FTeamName write FTeamName;
    property DeptCode: string read FDeptCode write FDeptCode;
    property DeptName: string read FDeptName write FDeptName;
    property Grade: string read FGrade write FGrade;
    property Position: string read FPosition write FPosition;
  end;

  TRMISUserCollect<T: TRMISUserItem> = class(Generics.Legacy.TCollection<T>)
  end;

  TRMISSessionInfo = class(TpjhBase)
  private
    FRMISUserCollect: TRMISUserCollect<TRMISUserItem>;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
  published
    property RMISUserCollect: TRMISUserCollect<TRMISUserItem> read FRMISUserCollect write FRMISUserCollect;
  end;

implementation

{ TRMISSessionInfo }

procedure TRMISSessionInfo.Clear;
begin

end;

constructor TRMISSessionInfo.Create(AOwner: TComponent);
begin
  FRMISUserCollect := TRMISUserCollect<TRMISUserItem>.Create;
end;

destructor TRMISSessionInfo.Destroy;
begin
  FRMISUserCollect.Free;

  inherited;
end;

end.
