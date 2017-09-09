unit DataModule_Unit;

interface

uses
  System.SysUtils, System.Classes, Data.DB, MemDS, DBAccess, Ora,
  AdvSmoothSplashScreen, OraTransaction, OraCall;

type
  TDM1 = class(TDataModule)
    OraSession1: TOraSession;
    OraQuery1: TOraQuery;
    OraQuery2: TOraQuery;
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
