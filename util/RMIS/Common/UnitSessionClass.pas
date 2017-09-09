unit UnitSessionClass;

interface

uses Classes, Generics.Legacy, BaseConfigCollect;

type
  TRMISUserCollect = class;//월별 추가 공수
  TRMISUserItem = class;

  TRMISSessionInfo = class(TpjhBase)
  private
    FRMISUserCollect: TRMISUserCollect;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
  published
    property RMISUserCollect: TRMISUserCollect read FRMISUserCollect write FRMISUserCollect;
  end;

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
    property YYYYMM: string read FYYYYMM write FYYYYMM;
    property YYYY: integer read FYYYY write FYYYY;
    property MM: integer read FMM write FMM;
    property M_H: double read FM_H write FM_H;
  end;


implementation

end.
