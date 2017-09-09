unit DataModule_Unit;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Ora, MemDS, OraTransaction;

type
  TDM1 = class(TDataModule)
    OraSession1: TOraSession;
    OraQuery1: TOraQuery;
    OraTransaction1: TOraTransaction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM1: TDM1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.
