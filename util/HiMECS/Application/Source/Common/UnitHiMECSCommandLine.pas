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

    [CLPLongName('IP'), CLPDescription('Reg Server IP Address', '')]

    [CLPLongName('PO'), CLPDescription('Reg Server Port', '')]

    [CLPLongName('RO'), CLPDescription('Reg Server Root', '')]

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