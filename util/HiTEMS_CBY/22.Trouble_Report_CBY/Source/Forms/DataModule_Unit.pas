unit DataModule_Unit;

interface

uses
  System.SysUtils, System.Classes, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdFTP, Ora,
  Data.DB, DBAccess, tmsAdvGridExcel, AdvSmoothSplashScreen, MemDS,
  OraTransaction, OraCall, System.Generics.Collections, Dialogs;

type
  TUserInfo = class
    FUserID,
    FUserName,
    FDept_Cd,
    FDeptName,
    FTeamName,
    FGradeCode,
    FGradeName,
    FPosition,
    FManager : String;
  End;

  TDM1 = class(TDataModule)
    TQuery1: TOraQuery;
    TQuery2: TOraQuery;
    EQuery1: TOraQuery;
    EQuery2: TOraQuery;
    Splash1: TAdvSmoothSplashScreen;
    AdvGridExcelIO1: TAdvGridExcelIO;
    TSession1: TOraSession;
    ESession1: TOraSession;
    IdFTP1: TIdFTP;
    IdFTP2: TIdFTP;
    OraQuery2: TOraQuery;
    OraStoredProc1: TOraStoredProc;
    OraQuery1: TOraQuery;
    OraTransaction1: TOraTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    FUserDic : TDictionary<string, TUserInfo>;

    procedure GetUserListFromDB;
    function GetKORNameFromID(AID: string): string;
  end;

var
  DM1: TDM1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TDM1.DataModuleCreate(Sender: TObject);
begin
  FUserDic := TDictionary<string, TUserInfo>.Create;

  GetUserListFromDB;
end;

procedure TDM1.DataModuleDestroy(Sender: TObject);
var
  LKey: string;
  LUserInfo: TUserInfo;
begin
  if Assigned(FUserDic) then
  begin
    for LKey in FUserDic.Keys do
    begin
      LUserInfo := FUserDic.Items[LKey];
      LUserInfo.Free;
    end;

    FreeAndNil(FUserDic);
  end;
end;

function TDM1.GetKORNameFromID(AID: string): string;
var
  LUserInfo: TUserInfo;
begin
  Result := '';

  if FUserDic.ContainsKey(AID) then
    LUserInfo := FUserDic.Items[AID]
  else
    LUserInfo := nil;

  if Assigned(LUserInfo) then
    Result := LUserInfo.FUserName;
end;

procedure TDM1.GetUserListFromDB;
var
  LUserInfo: TUserInfo;
  LUserID: string;
begin
  with TQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * from HITEMS.HITEMS_USER');

    Open;

    while not Eof do
    begin
      LUserID := FieldByName('USERID').AsString;
      LUserInfo := TUserInfo.Create;

      with LUserInfo do
      begin
        FUserID := LUserID;
        FUserName := FieldByName('NAME_KOR').AsString;
        FDept_Cd := FieldByName('DEPT_CD').AsString;
        FDeptName := '';
        FTeamName := '';
        FGradeCode :=FieldByName('GRADE').AsString;
        FGradeName := '';
        FPosition := FieldByName('POSITION').AsString;
        FManager := '';
      end;

      FUserDic.Add(LUserID, LUserInfo);

      Next;
    end;
  end;
end;

end.
