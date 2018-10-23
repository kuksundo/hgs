unit UnitGSFileOpenConfigOptionClass;

interface

uses classes, GpCommandLineParser, Generics.Legacy;

type
  TGSFileOpenCommandLineOption = class
    FOpenFileName,
    FConfigFileName: string;
    FAutoExecute,
    FAlarmMode,
    FMDIChildMode,
    FIsDisplayTrend,
    FIsDisplaySimple: Boolean;
    FUserLevel: integer;
  public
    [CLPName('f'), CLPLongName('FileName'), CLPDescription('file name for openng'), CLPDefault('')]
    property OpenFileName: string read FOpenFileName write FOpenFileName;
    [CLPName('c'), CLPLongName('ConfigFile'), CLPDescription('Config File Name'), CLPDefault('')]
    property ConfigFileName: string read FConfigFileName write FConfigFileName;
    [CLPName('a'), CLPLongName('AutoExcute', 'Auto'), CLPDescription('Enable autotest mode.')]
    property AutoExecute: boolean read FAutoExecute write FAutoExecute;
    [CLPName('m'), CLPLongName('MDIChildMode', 'MDI'), CLPDescription('Enable MDI Child mode.')]
    property MDIChildMode: boolean read FMDIChildMode write FMDIChildMode;
    [CLPName('r'), CLPLongName('AlarmMode', 'Alarm'), CLPDescription('Enable Alarm Mode.')]
    property AlarmMode: boolean read FAlarmMode write FAlarmMode;
    [CLPLongName('DisplayTrend', 'Trend'), CLPDescription('Display Trend Sheet When Start.')]
    property IsDisplayTrend: boolean read FIsDisplayTrend write FIsDisplayTrend;
    [CLPLongName('DisplaySimple', 'Simple'), CLPDescription('Display Simple Sheet When Start.')]
    property IsDisplaySimple: boolean read FIsDisplaySimple write FIsDisplaySimple;
    [CLPName('u'), CLPDescription('User Level'), CLPDefault('0')]//'<days>'
    property UserLevel: integer read FUserLevel write FUserLevel;
  end;

implementation

end.
