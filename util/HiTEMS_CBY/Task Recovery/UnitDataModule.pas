unit UnitDataModule;

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
    { Public declarations }
  end;

var
  DM1: TDM1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
