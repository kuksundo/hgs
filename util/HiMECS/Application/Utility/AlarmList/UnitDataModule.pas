unit UnitDataModule;

interface

uses
  System.SysUtils, System.Classes, DBAccess, OraTransaction, Data.DB, MemDS,
  Ora, OraCall;

type
  TDataModule1 = class(TDataModule)
    OraSession1: TOraSession;
    OraQuery1: TOraQuery;
    OraTransaction1: TOraTransaction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
