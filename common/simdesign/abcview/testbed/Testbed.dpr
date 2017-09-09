program Testbed;

uses
  Forms,
  Testbed_main in 'Testbed_main.pas' {Form1},
  SHFileOp in '..\..\Units\SHFileOp.pas',
  Streams in '..\..\Units\Streams.pas',
  DiskInfo in '..\..\Units\DiskInfo.pas',
  GrCanonCRWs in 'GrCanonCRWs.pas',
  FileTags in '..\..\Units\FileTags.pas',
  XML in '..\..\Units\XML.pas',
  ReadCIFFs in '..\..\Units\ReadCIFFs.pas',
  ReadIPTCs in '..\..\Units\ReadIPTCs.pas',
  dEXIF in '..\..\Units\dEXIF.pas',
  msData in '..\..\Units\msData.pas',
  ReadEXIFs in '..\..\Units\ReadEXIFs.pas',
  ReadJPGs in '..\..\Units\ReadJPGs.pas',
  ReadTIFFs in '..\..\Units\ReadTIFFs.pas',
  OptionsManagers in 'OptionsManagers.pas',
  SortedLists in 'SortedLists.pas',
  CodecsJPG in '..\..\Units\CodecsJPG.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
