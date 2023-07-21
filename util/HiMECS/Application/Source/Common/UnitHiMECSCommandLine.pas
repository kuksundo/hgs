unit UnitHiMECSCommandLine;
//Project Source에 UnitHiMECSCommandLine Unit Name이 UnitHiMECS unit보다 먼저 나와야 함
//왜냐하면 UnitHiMECSCommandLine Initialization 의 CommandLineParser함수 실행 후 UnitHiMECS Initialization이 실행 되어야 하기 때문임
interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.StrUtils,
  GpCommandLineParser;

type
  THiMECSCommandLine = class
  strict private
    FUserFileName,
    FProjectFileName,
    FRegSvrIPAddr,
    FRegSvrPort,
    FRegSvrRoot: string;
  public
    [CLPLongName('UF'), CLPDescription('User File Name', '')]
    property UserFileName: string read FUserFileName write FUserFileName;
    [CLPLongName('PF'), CLPDescription('Project File Name', '')]
    property ProjectFileName: string read FProjectFileName write FProjectFileName;
    [CLPLongName('IP'), CLPDescription('Reg Server IP Address', '')]
    property RegSvrIPAddr: string read FRegSvrIPAddr write FRegSvrIPAddr;
    [CLPLongName('PO'), CLPDescription('Reg Server Port', '')]
    property RegSvrPort: string read FRegSvrPort write FRegSvrPort;
    [CLPLongName('RO'), CLPDescription('Reg Server Root', '')]
    property RegSvrRoot: string read FRegSvrRoot write FRegSvrRoot;
  end;

var
  g_HiMECSCommandLine: THiMECSCommandLine;

implementation

initialization
  g_HiMECSCommandLine := nil;
  g_HiMECSCommandLine := THiMECSCommandLine.Create;

//  if Assigned(g_HiMECSCommandLine) then
    CommandLineParser.Parse(g_HiMECSCommandLine);

finalization
  if Assigned(g_HiMECSCommandLine) then
    FreeAndNil(g_HiMECSCommandLine);

end.
