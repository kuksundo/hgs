program Csv2Db;

uses
  Forms,
  Main in 'Main.pas' {Csv2DBF},
  CSV2DBConfig in 'CSV2DBConfig.pas' {csv2dbConfigF},
  CSV2DBConst in 'CSV2DBConst.pas',
  File2DBThread in 'File2DBThread.pas',
  MySqlDBThread in 'MySqlDBThread.pas',
  FSMClass in 'common\FSMClass.pas',
  FSMState in 'common\FSMState.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TCsv2DBF, Csv2DBF);
  Application.CreateForm(Tcsv2dbConfigF, csv2dbConfigF);
  Application.Run;
end.
