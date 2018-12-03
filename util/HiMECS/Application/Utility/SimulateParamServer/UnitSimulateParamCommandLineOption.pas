unit UnitSimulateParamCommandLineOption;

interface

uses classes, GpCommandLineParser;

type
  TSimulateParamCLO = class//CLO: CommandLineOption
    FConfigFileName,
    FJsonParamCollect,
    FCSVValues: string;
  public
    [CLPName('c'), CLPLongName('ConfigFile'), CLPDescription('Config File Name'), CLPDefault('')]
    property ConfigFileName: string read FConfigFileName write FConfigFileName;
    [CLPName('j'), CLPLongName('JsonParam', 'ParamList'), CLPDescription('Json Param Collect.')]
    property JsonParamCollect: string read FJsonParamCollect write FJsonParamCollect;
    [CLPName('v'), CLPLongName('CSVValues', 'CSV'), CLPDescription('CSV Values.')]
    property CSVValues: string read FCSVValues write FCSVValues;
  end;

implementation

end.
