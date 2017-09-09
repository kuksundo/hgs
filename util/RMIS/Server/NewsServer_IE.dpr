program NewsServer_IE;

uses
  Vcl.Forms,
  UnitNewsMain_IE in 'UnitNewsMain_IE.pas' {Form1},
  UnitNewsInterface in '..\Common\UnitNewsInterface.pas',
  UnitNewsConfig in 'UnitNewsConfig.pas' {ConfigF},
  UnitHhiOfficeNewsInterface in '..\Common\UnitHhiOfficeNewsInterface.pas',
  UnitFrameCommServer in '..\..\HiMECS\Application\Utility\CommonFrame\UnitFrameCommServer.pas' {FrameCommServer: TFrame},
  WebBrowserUtil in '..\..\..\common\WebBrowserUtil.pas',
  UnitRSSAddressClass in '..\Common\UnitRSSAddressClass.pas',
  UnitRSSAddrEdit in '..\Common\UnitRSSAddrEdit.pas' {RSSAddressEditF},
  SortCollections in '..\..\..\common\SortCollections.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TConfigF, ConfigF);
  Application.CreateForm(TRSSAddressEditF, RSSAddressEditF);
  Application.Run;
end.
