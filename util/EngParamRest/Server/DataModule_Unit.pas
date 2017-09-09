unit DataModule_Unit;

interface

uses
  System.SysUtils, System.Classes, DBAccess, OraTransaction, Data.DB, MemDS,
  Ora, OraCall;

type
  TDM1 = class(TDataModule)
    OraSession1: TOraSession;
    OraQuery1: TOraQuery;
    OraTransaction1: TOraTransaction;
    OraQuery2: TOraQuery;
  private
    { Private declarations }
  public
    procedure Update_Mon_Table_IpAddr(AEngProjNo, AIpAddr: string; AUseYN, APortNo: integer);
    function Get_Mon_Table_UseCount(AEngProjNo: string): integer;
  end;

var
  DM1: TDM1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule1 }

function TDM1.Get_Mon_Table_UseCount(AEngProjNo: string): integer;
begin
  Result := -1;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT USE_YN FROM MON_TABLES ' +
            'WHERE ENG_PROJNO = :PROJNO');

    ParamByName('PROJNO').AsString := AEngProjNo;
    Open;

    if RecordCount > 0 then
    begin
      Result := Fields[0].AsInteger;
    end;
  end;
end;

//AUseYN = 0 또는 1임
//USE_YN  값이 0이면 모니터링 서버 없음, 1이상이면 모니터링 서버 1대 이상 실행 중
procedure TDM1.Update_Mon_Table_IpAddr(AEngProjNo, AIpAddr: string; AUseYN, APortNo: integer);
var
  LCount: integer;
begin
  LCount := Get_Mon_Table_UseCount(AEngProjNo);

  if LCount > 0 then
  begin
    if AUseYN > 0 then
      LCount := LCount + AUseYN
    else
      LCount := LCount - 1;
  end
  else
    LCount := AUseYN;

  DM1.OraTransaction1.StartTransaction;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE MON_TABLES SET MON_IP_ADDR = :IPADDR, MON_IP_PORT = :IPPORT, USE_YN = :USEYN ' +
              'WHERE ENG_PROJNO = :PROJNO');

      ParamByName('IPADDR').AsString := AIpAddr;
      ParamByName('IPPORT').AsInteger := APortNo;
      ParamByName('USEYN').AsInteger := LCount;
      ParamByName('PROJNO').AsString := AEngProjNo;

      ExecSql;

      DM1.OraTransaction1.Commit;
    end;
  except
    DM1.OraTransaction1.Rollback;
  end;

end;

end.
