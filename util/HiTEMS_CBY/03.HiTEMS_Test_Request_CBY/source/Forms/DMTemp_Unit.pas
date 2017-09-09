unit DMTemp_Unit;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Ora, MemDS, OraTransaction,
  OraSmart, OraCall, HoliDayCollect;

type
  TuserInfo = Record
    FUserID,
    FUserName,
    FDept_Cd,
    FDeptName,
    FTeam_Cd,
    TEAMNO,//FDept_Cd와 동일함(업무관리시스템과 소스 공유 위해 유지 필요)
    FTeamName,
    FGradeCode,
    FGradeName,
    FPosition,
    FManager : String;
    FPriv : Integer;
  private

    procedure SetUserId(aId:String);
    procedure SetUserName(aName:String);
    procedure SetDeptCd(aCode:String);
    procedure SetDeptName(aName:String);
    procedure SetTeamCd(aCode:String);
    procedure SetTeamName(aName:String);
    procedure SetGradeCode(aCode:String);
    procedure SetGradeName(aName:String);
    procedure SetPostion(aText:String);
    procedure SetManager(aText:String);
    procedure SetPriv(aInt:Integer);

  public
    function CurrentUsers: string;
    function CurrentUsersTeam: string;

    property UserId : String read FUserId write SetUserId;
    property UserName : String read FUserName write SetUserName;
    property Dept_Cd : String read FDept_Cd write SetDeptCd;
    property DeptName : String read FDeptName write SetDeptName;

    property GradeCode : String read FGradeCode write SetGradeCode;
    property GradeName : String read FGradeName write SetGradeName;
    property JobPosition : String read FPosition write SetPostion;
    property Manager : String read FManager write SetManager;
    property Priv : Integer read FPriv write SetPriv;
  end;

  TDM1 = class(TDataModule)
    OraSession1: TOraSession;
    OraQuery1: TOraQuery;
    OraTransaction1: TOraTransaction;
    OraDataSource1: TOraDataSource;
    OraQuery2: TOraQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure GetHolidayFromDB;
  public
    FUSerInfo : TuserInfo;
    FHoliDayList : THoliDayList;
    procedure SetUserInfo(aUserId:String);
  end;

var
  DM1: TDM1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TDM1 }

procedure TDM1.DataModuleCreate(Sender: TObject);
begin
  FHoliDayList := THoliDayList.Create(Self);

  GetHolidayFromDB;
end;

procedure TDM1.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FHoliDayList);
end;

procedure TDM1.GetHolidayFromDB;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM HiTEMS_HOLIDAY ' +
            ' WHERE TO_CHAR(FROMDATE, ''YYYY'') = :param1 ORDER BY FROMDATE');
    ParamByName('param1').AsString := IntToStr(CurrentYear);
    Open;

    if RecordCount > 0 then
    begin
      while not Eof do
      begin
        with FHoliDayList.HoliDayCollect.Add do
        begin
          FromDate := FieldByName('FROMDATE').AsDateTime;
          ToDate := FieldByName('TODATE').AsDateTime;
          Description := FieldByName('Description').AsString;
        end;//with

        Next;
      end;//while
    end;
  end;//with
end;

procedure TDM1.SetUserInfo(aUserId: String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ' +
            '   USERID, SUBSTR(DEPT_CD,1,3) DEPT_CD, DEPT_CD TEAM_CD, ' +
            '   NAME_KOR, PRIV, GRADE, POSITION, ' +
            '   (SELECT DEPT_NAME FROM HITEMS_DEPT WHERE DEPT_CD LIKE SUBSTR(A.DEPT_CD,1,3)) DEPT_NAME, ' +
            '   (SELECT DEPT_NAME FROM HITEMS_DEPT WHERE DEPT_CD LIKE A.DEPT_CD) TEAM_NAME,     ' +
            '   (SELECT DESCR FROM HITEMS_USER_GRADE WHERE GRADE LIKE A.GRADE) GRADE_NAME ' +
            'FROM HITEMS_USER A ' +
            'WHERE GUNMU LIKE ''I'' ' +
            'AND USERID LIKE :param1 ' +
            'ORDER BY PRIV DESC, POSITION, GRADE, USERID ');


    ParamByName('param1').AsString := aUserId;
    Open;

    with DM1.FUSerInfo do
    begin
      SetUserId(FieldByName('USERID').AsString);
      SetUserName(FieldByName('NAME_KOR').AsString);
      SetDeptCd(FieldByName('DEPT_CD').AsString);
      SetDeptName(FieldByName('DEPT_NAME').AsString);
      SetTeamCd(FieldByName('TEAM_CD').AsString);
      SetTeamName(FieldByName('TEAM_NAME').AsString);
      SetGradeCode(FieldByName('GRADE').AsString);
      SetGradeName(FieldByName('GRADE_NAME').AsString);
      SetPostion(FieldByName('POSITION').AsString);
      SetPriv(FieldByName('PRIV').AsInteger);
    end;
  end;
end;

{ TuserInfo }

function TuserInfo.CurrentUsers: string;
begin
  Result := FUserId;
end;

function TuserInfo.CurrentUsersTeam: string;
begin
  Result := FTeam_Cd;
end;

procedure TuserInfo.SetDeptCd(aCode: String);
begin
  FDept_Cd := aCode;
end;

procedure TuserInfo.SetDeptName(aName: String);
begin
  FDeptName := aName;
end;

procedure TuserInfo.SetGradeCode(aCode: String);
begin
  FGradeCode := aCode;
end;

procedure TuserInfo.SetGradeName(aName: String);
begin
  FGradeName := aName;
end;

procedure TuserInfo.SetManager(aText: String);
begin
  FManager := aText;
end;

procedure TuserInfo.SetPostion(aText: String);
begin
  FPosition := aText;
end;

procedure TuserInfo.SetPriv(aInt: Integer);
begin
  FPriv := aInt;
end;

procedure TuserInfo.SetTeamCd(aCode: String);
begin
  FTeam_Cd := ACode;
end;

procedure TuserInfo.SetTeamName(aName: String);
begin
  FTeamName := aName;
end;

procedure TuserInfo.SetUserId(aId: String);
begin
  FUserID := aId;
end;

procedure TuserInfo.SetUserName(aName: String);
begin
  FUserName := aName;
end;

end.
