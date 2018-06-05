unit UnitQuotationManageCommandLineClass;

interface

uses classes, GpCommandLineParser;

type
  TQuotationManageParameter = class
    FHullNo,
    FEngineModel,
    FAdapt,
    FCylCount,
    FTCModel,
    FTier,
    FRunHour: string;
  public
    [CLPName('n'), CLPLongName('HullNo'), CLPDescription('Hull No'), CLPDefault('')]//HHI1234
    property HullNo: string read FHullNo write FHullNo;
    [CLPName('m'), CLPLongName('EngineModel'), CLPDescription('Engine Model'), CLPDefault('')]//9H21/32
    property EngineModel: string read FEngineModel write FEngineModel;
    [CLPName('i'), CLPLongName('Tier'), CLPDescription('Tier'), CLPDefault('')] //1,2,3
    property Tier: string read FTier write FTier;
    [CLPName('a'), CLPLongName('Adapt'), CLPDescription('Adapt'), CLPDefault('')] //M,S,P = Marine,Stationary, Propulsion
    property Adapt: string read FAdapt write FAdapt;
    [CLPName('c'), CLPLongName('CylCount'), CLPDescription('Cylinder Count'), CLPDefault('')] //9
    property CylCount: string read FCylCount write FCylCount;
    [CLPName('t'), CLPLongName('TCModel'), CLPDescription('TC Model'), CLPDefault('')] //HPR3000
    property TCModel: string read FTCModel write FTCModel;
    [CLPName('r'), CLPLongName('RunHour'), CLPDescription('Run Hour'), CLPDefault('')] //3000
    property RunHour: string read FRunHour write FRunHour;
  end;

implementation

end.
