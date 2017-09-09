unit DataModule_Unit;

interface

uses
  System.SysUtils, System.Classes, Data.DB, MemDS, DBAccess, Ora, OraTransaction;

type
  TDM1 = class(TDataModule)
    OraTransaction1: TOraTransaction;
    OraSession1: TOraSession;
    OraQuery1: TOraQuery;
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
