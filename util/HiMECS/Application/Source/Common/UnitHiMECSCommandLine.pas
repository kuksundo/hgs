unit UnitHiMECSCommandLine;
//Project Source�� UnitHiMECSCommandLine Unit Name�� UnitHiMECS unit���� ���� ���;� ��
//�ֳ��ϸ� UnitHiMECSCommandLine Initialization �� CommandLineParser�Լ� ���� �� UnitHiMECS Initialization�� ���� �Ǿ�� �ϱ� ������
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
