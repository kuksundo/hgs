unit UnitEngineElecPartClass;

interface

uses System.Classes,
  SynCommons, mORMot,
  IniPersist, UnitConfigIniClass,
  UnitEnumHelper, UnitRttiUtil, UnitECUData, HiMECSConst;

type
  TPLCChannelInfoRec = record
    FPanelName,
    FPLCModuleName,
    FTagName,
    FDesc,
    FTerminalName,
    FTerminalNo,
    FPlcChNo: string;
  end;

  TEngElecPartBase = class(TSynPersistent)//TSynAutoCreateFields
  private
    FPartType: TEngElecPartType; //전장품 종류 (센서,밸브,펌프,컨버터,판넬)
    FInstrumentType: TEngInstrumentType;
    FNextConnect,
    FPrevConnect: TEngElecPartBase;

    FTagName,
    FTagDesc,
    FTagDesc_Eng,
    FTagDesc_Kor,
    //공통의 Route를 사용할 경우 SubTagName으로 저장함
    FSubTagName,

    //For PLC -->
    FModuleName,
    FModuleNo,
    FSlotNo,
    FChannelNo,
    //For PLC <--

    FPanelName,
    FTerminalName,
    FTerminalNo,
    FCableNo,
    FCableNote
    : string;

    FSensorType: TSensorType;
    FSignalType: TSignalType;
  public
    property PrevConnect: TEngElecPartBase read FPrevConnect write FPrevConnect;
    property NextConnect: TEngElecPartBase read FNextConnect write FNextConnect;
  published
    [IniValue('PartType','TEngElecPartType','',1)]
    property PartType: TEngElecPartType read FPartType write FPartType;
    [IniValue('InstrumentType','TEngInstrumentType','',2)]
    property InstrumentType: TEngInstrumentType read FInstrumentType write FInstrumentType;
    [IniValue('TagName','TagName','',3)]
    property TagName: string read FTagName write FTagName;
    [IniValue('TagDesc','TagDesc','',4)]
    property TagDesc: string read FTagDesc write FTagDesc;
    [IniValue('TagDesc_Eng','TagDesc_Eng','',5)]
    property TagDesc_Eng: string read FTagDesc_Eng write FTagDesc_Eng;
    [IniValue('TagDesc_Kor','TagDesc_Kor','',6)]
    property TagDesc_Kor: string read FTagDesc_Kor write FTagDesc_Kor;
    [IniValue('PanelName','PanelName','',7)]
    property PanelName: string read FPanelName write FPanelName;
    [IniValue('TerminalName','TerminalName','',8)]
    property TerminalName: string read FTerminalName write FTerminalName;
    [IniValue('TerminalNo','TerminalNo','',9)]
    property TerminalNo: string read FTerminalNo write FTerminalNo;
    [IniValue('ModuleName','ModuleName','',10)]
    property ModuleName: string read FModuleName write FModuleName;
    [IniValue('ModuleNo','ModuleNo','',11)]
    property ModuleNo: string read FModuleNo write FModuleNo;
    [IniValue('SlotNo','SlotNo','',12)]
    property SlotNo: string read FSlotNo write FSlotNo;
    [IniValue('ChannelNo','ChannelNo','',13)]
    property ChannelNo: string read FChannelNo write FChannelNo;
    [IniValue('CableNo','CableNo','',14)]
    property CableNo: string read FCableNo write FCableNo;
    [IniValue('CableNote','CableNote','',15)]
    property CableNote: string read FCableNote write FCableNote;
    [IniValue('SubTagName','SubTagName','',16)]
    property SubTagName: string read FSubTagName write FSubTagName;

    [IniValue('SensorType','TSensorType','',100)]
    property SensorType: TSensorType read FSensorType write FSensorType;
    [IniValue('SignalType','TSignalType','',101)]
    property SignalType: TSignalType read FSignalType write FSignalType;
  end;

//  TEngSensor = class(TEngElecPartBase)
//  private
//  published
//  end;

  TEngModule = class(TEngElecPartBase)
  private
    FModuleType: TSensorType;
  end;

  TEngPanel = class(TEngElecPartBase)
  private
    FModuleType: TSensorType;
  end;

implementation

end.
