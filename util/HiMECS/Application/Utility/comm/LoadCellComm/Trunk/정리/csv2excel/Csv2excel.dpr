program Csv2excel;

uses
  Forms,
  Main in 'Main.pas' {Csv2XlsF},
  CSV2xlsConfig in 'CSV2xlsConfig.pas' {csv2xlsConfigF},
  CSV2XlsConst in 'CSV2XlsConst.pas',
  File2xlsThread in 'File2xlsThread.pas',
  xlsThread in 'xlsThread.pas',
  FSMClass in 'common\FSMClass.pas',
  FSMState in 'common\FSMState.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TCsv2XlsF, Csv2XlsF);
  Application.CreateForm(Tcsv2xlsConfigF, csv2xlsConfigF);
  Application.Run;
end.
