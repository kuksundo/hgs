unit DataModule_Unit;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Ora, MemDS, OraTransaction,
  OraSmart;

type
  TDM1 = class(TDataModule)
    OraSession1: TOraSession;
    OraQuery1: TOraQuery;
    OraTransaction1: TOraTransaction;
    OraDataSource1: TOraDataSource;
    OraQuery2: TOraQuery;
  private
    { Private declarations }
  public
    FStop: Boolean;
  end;

var
  DM1: TDM1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.
