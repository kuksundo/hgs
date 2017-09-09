program HhiOfficeNewsServer_IE;

uses
  Vcl.Forms,
  UnitHhiOfficeNewsMain_IE in 'UnitHhiOfficeNewsMain_IE.pas' {Form1},
  WebBrowserUtil in '..\..\common\WebBrowserUtil.pas',
  UnitHhiOfficeNewsInterface in '..\Common\UnitHhiOfficeNewsInterface.pas',
  UnitNewsConfig in 'UnitNewsConfig.pas' {ConfigF},
  Sea_Ocean_News_Class in '..\Common\Sea_Ocean_News_Class.pas',
  UnitFrameCommServer in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameCommServer.pas' {FrameCommServer: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
