program WebCrawler4ShipSearch;

uses
  SynSqlite3Static,
  sysutils,
  ceflib,
  Windows,
  Forms,
  main in 'main.pas' {MainForm},
  ceffilescheme in '..\..\..\..\vcl\dcef\dcef3\demos\filescheme\ceffilescheme.pas',
  HtmlParserEx in '..\..\..\OpenSrc\htmlparser-master\HtmlParserEx.pas',
  UnitStringUtil in '..\..\..\common\UnitStringUtil.pas',
  UnitVesselMasterRecord in '..\UnitVesselMasterRecord.pas',
  CommonData in '..\CommonData.pas',
  IPC.Events in '..\..\..\common\SharedMemoryTest-master\IPC.Events.pas',
  FrmIMONoEdit in 'FrmIMONoEdit.pas' {IMONoEditF};

{$R *.res}

procedure RegisterSchemes(const registrar: ICefSchemeRegistrar);
begin
  registrar.AddCustomScheme('local', True, True, False);
end;

begin
  CefCache := 'cache';
  CefOnRegisterCustomSchemes := RegisterSchemes;
  CefSingleProcess := False;
  if not CefLoadLibDefault then
    Exit;

  CefRegisterSchemeHandlerFactory('local', '', TFileScheme);


  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
