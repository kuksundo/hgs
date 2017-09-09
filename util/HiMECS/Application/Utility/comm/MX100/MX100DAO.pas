unit MX100DAO;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, SimpleDS,
  Data.SqlExpr, Data.DBXOracle, DBAccess, Ora;

type
  TMX100DM = class(TDataModule)
    OraSession1: TOraSession;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MX100DM: TMX100DM;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.
