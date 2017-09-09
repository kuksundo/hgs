program DataSavep;

uses
  Forms,
  DataSave in 'DataSave.pas' {Form1},
  IPCThrd2 in 'common\IPCThrd2.pas',
  IPCThrdMonitor2 in 'common\IPCThrdMonitor2.pas',
  DataSaveConfig in 'DataSaveConfig.pas' {SaveConfigF},
  IPCThrdConst in 'common\IPCThrdConst.pas',
  mwStringHashList in 'common\mwStringHashList.pas',
  janSQLExpression2 in 'common\janSQLExpression2.pas',
  janSQLStrings in 'common\janSQLStrings.pas',
  janSQLTokenizer in 'common\janSQLTokenizer.pas',
  janSQL in 'common\janSQL.pas',
  DataSaveConst in 'DataSaveConst.pas',
  DeCAL_pjh in 'common\DeCAL_pjh.pas',
  CommonUtil in 'common\CommonUtil.pas',
  DataSave2DBThread in 'DataSave2DBThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TSaveConfigF, SaveConfigF);
  Application.Run;
end.
