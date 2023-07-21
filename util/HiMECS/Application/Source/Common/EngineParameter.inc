{이 파일에서 Item 추가 시에 반드시 EP:Item.inc에도 추가해 주어야 함}

  private
{$I EngineParameterItem.inc}
  public
    FPCircularArray: Pointer;  //HiMECS_WathSave에서 평균값을 저장하기 위한 원형큐를 저장함

//    procedure Assign(Source: TPersistent); override;
//    procedure AssignTo(var ARecord: TEngineParameterItemRecord);
//    function IsMatrixData: Boolean;

    FIsUpdate: Boolean;
    FMultiStateItemIndex, //Begin Index
    FMultiStateItemCount,
    FCurrentStateAryIdx //
    : integer;
    FMultiStateValues: string;//Json 형식의 Values {"TagName":"","Address":""...}
    FModBusMode: integer;
    FDFPageCaption: string;//Design Form Page Caption
    FDFPageIndex: integer; //Design Form Page Index
//    FUseBalloon: Boolean; //True: Design Form에 Balloon Hint를 표시함
    FIsHideItem: Boolean;//Treeview에 표시하지 않음(Param Search 할때 사용)

    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
    //HiMECS_DF_A2_Sensor_r4.sqlite에서 EngineParameter Load시에
    //EngineParamRecord 테이블의 TagName과 동일한 TagName이
    //EngineMultiStateRecord 테이블에 존재하면
    //MultiStateItemIndex에 -1이 아닌 Index를 저장하고 MultiStateValues 에 StateMeaning 리스트를 저장함
    property MultiStateItemIndex: integer read FMultiStateItemIndex write FMultiStateItemIndex;
    property MultiStateItemCount: integer read FMultiStateItemCount write FMultiStateItemCount;
    property MultiStateValues: string read FMultiStateValues write FMultiStateValues;

    property MinAlarmStartTime: TDateTime read FMinAlarmStartTime write FMinAlarmStartTime;
    property MaxAlarmStartTime: TDateTime read FMaxAlarmStartTime write FMaxAlarmStartTime;
    property MinFaultStartTime: TDateTime read FMinFaultStartTime write FMinFaultStartTime;
    property MaxFaultStartTime: TDateTime read FMaxFaultStartTime write FMaxFaultStartTime;
    property IsSimulateMode: Boolean read FIsSimulateMode write FIsSimulateMode;
    property SimulateValue: string read FSimulateValue write FSimulateValue;
    property FormulaValueStringList: TStringList read FFormulaValueStringList write FFormulaValueStringList;
    property NextGridRow: Pointer read FNextGridRow write FNextGridRow;
  published
    property SharedName: string read FSharedName write FSharedName;
    property UserLevel: THiMECSUserLevel read FUserLevel write FUserLevel;
    property LevelIndex: integer read FLevelIndex write FLevelIndex;
    property NodeIndex: integer read FNodeIndex write FNodeIndex; //Simulate Mode시 Position Index로 사용
    property AbsoluteIndex: integer read FAbsoluteIndex write FAbsoluteIndex;//Project Index로 사용(FCOI)
    property MaxValue: integer read FMaxValue write FMaxValue;
    property BlockNo: integer read FBlockNo write FBlockNo;
    property MaxValue_Real: real read FMaxValue_Real write FMaxValue_Real;
    property Contact: integer read FContact write FContact;
    property Scale: string read FScale write FScale; //단위가 String인데 Integer으로 저장되면 LoadFromJSONFile이 안됨
    property TagName: string read FTagName write FTagName;
    property Description: string read FDescription write FDescription;
    property Description_Eng: string read FDescription_Eng write FDescription_Eng; //add for df
    property Description_Kor: string read FDescription_Kor write FDescription_Kor; //add for df
    property ParamNo: string read FParamNo write FParamNo;                         //add for df
    property Address: string read FAddress write FAddress;
    property Alarm: Boolean read FAlarm write FAlarm;
    property FCode: string read FFCode write FFCode;
    property FUnit: string read FFUnit write FFUnit;
    property Value: string read FValue write FValue;
    property MinLimitValue: string read FMinLimitValue write FMinLimitValue;
    property DefaultValue: string read FDefaultValue write FDefaultValue;
    property MaxLimitValue: string read FMaxLimitValue write FMaxLimitValue;
    property RadixPosition: integer read FRadixPosition write FRadixPosition;
    property MinMaxType: TValueType read FMinMaxType write FMinMaxType;
    property DisplayUnit: Boolean read FDisplayUnit write FDisplayUnit;
    property DisplayThousandSeperator: Boolean read FDisplayThousandSeperator write FDisplayThousandSeperator;
    property DisplayFormat: string read FDisplayFormat write FDisplayFormat;

    property SensorType: TSensorType read FSensorType write FSensorType;
    property ParameterCatetory: TParameterCategory read FParameterCatetory write FParameterCatetory;
    property ParameterCatetory4AVAT2: TParameterCategory4AVAT2 read FParameterCatetory4AVAT2 write FParameterCatetory4AVAT2;//add for df
    property ParameterSubCatetory4AVAT2: TParameterSubCategory4AVAT2 read FParameterSubCatetory4AVAT2 write FParameterSubCatetory4AVAT2;//add for df
    property ParameterType: TParameterType read FParameterType write FParameterType;
    property ParameterSource: TParameterSource read FParameterSource write FParameterSource;
    property DFAlarmKind: TDFAlarmKind read FDFAlarmKind write FDFAlarmKind;//add for df
    property EngineUsage: TEngineUsage read FEngineUsage write FEngineUsage;//add for df
    property DFCommissioningItem: TDFCommissioningItem read FDFCommissioningItem write FDFCommissioningItem;//add for df
    property AlarmKind4AVAT2: TAlarmKind4AVAT2 read FAlarmKind4AVAT2 write FAlarmKind4AVAT2;//add for df
    property AlarmLimit4AVAT2: TAlarmLimit4AVAT2 read FAlarmLimit4AVAT2 write FAlarmLimit4AVAT2;//add for df
    //==========================================================================
    property AlarmPriority: TAlarmPriority read FAlarmPriority write FAlarmPriority;
    property MinAlarmEnable: Boolean read FMinAlarmEnable write FMinAlarmEnable default false;
    property MaxAlarmEnable: Boolean read FMaxAlarmEnable write FMaxAlarmEnable default false;
    property MinFaultEnable: Boolean read FMinFaultEnable write FMinFaultEnable default false;
    property MaxFaultEnable: Boolean read FMaxFaultEnable write FMaxFaultEnable default false;
    property MinAlarmValue: double read FMinAlarmValue write FMinAlarmValue;
    property MinFaultValue: double read FMinFaultValue write FMinFaultValue;
    property MaxAlarmValue: double read FMaxAlarmValue write FMaxAlarmValue;
    property MaxFaultValue: double read FMaxFaultValue write FMaxFaultValue;
    property MinAlarmColor: Longint read FMinAlarmColor write FMinAlarmColor default $0000FFFF;
    property MaxAlarmColor: Longint read FMaxAlarmColor write FMaxAlarmColor default $000000FF;
    property MinFaultColor: Longint read FMinFaultColor write FMinFaultColor default $00FFFF99;
    property MaxFaultColor: Longint read FMaxFaultColor write FMaxFaultColor default $00FF0000;
    property MinAlarmBlink: Boolean read FMinAlarmBlink write FMinAlarmBlink default false;
    property MaxAlarmBlink: Boolean read FMaxAlarmBlink write FMaxAlarmBlink default false;
    property MinFaultBlink: Boolean read FMinFaultBlink write FMinFaultBlink default false;
    property MaxFaultBlink: Boolean read FMaxFaultBlink write FMaxFaultBlink default false;
    property MinAlarmSoundEnable: Boolean read FMinAlarmSoundEnable write FMinAlarmSoundEnable default false;
    property MaxAlarmSoundEnable: Boolean read FMaxAlarmSoundEnable write FMaxAlarmSoundEnable default false;
    property MinFaultSoundEnable: Boolean read FMinFaultSoundEnable write FMinFaultSoundEnable default false;
    property MaxFaultSoundEnable: Boolean read FMaxFaultSoundEnable write FMaxFaultSoundEnable default false;
    property MinAlarmSoundFilename: string read FMinAlarmSoundFilename write FMinAlarmSoundFilename;
    property MaxAlarmSoundFilename: string read FMaxAlarmSoundFilename write FMaxAlarmSoundFilename;
    property MinFaultSoundFilename: string read FMinFaultSoundFilename write FMinFaultSoundFilename;
    property MaxFaultSoundFilename: string read FMaxFaultSoundFilename write FMaxFaultSoundFilename;
    property FormulaValueList: string read FFormulaValueList write FFormulaValueList;

    property IsDisplayTrend: Boolean read FIsDisplayTrend write FIsDisplayTrend default false;
    property IsDisplayXY: Boolean read FIsDisplayXY write FIsDisplayXY default false;
    property TrendChannelIndex: integer read FTrendChannelIndex write FTrendChannelIndex;
    property TrendAlarmIndex: integer read FTrendAlarmIndex write FTrendAlarmIndex;
    property TrendFaultIndex: integer read FTrendFaultIndex write FTrendFaultIndex;
    property TrendYAxisIndex: integer read FTrendYAxisIndex write FTrendYAxisIndex;
    property PlotXValue: double read FPlotXValue write FPlotXValue;
    property MinValue: integer read FMinValue write FMinValue;
    property MinValue_Real: real read FMinValue_Real write FMinValue_Real;
    property IsDisplaySimple: Boolean read FIsDisplaySimple write FIsDisplaySimple default false;
    property YAxesMinValue: double read FYAxesMinValue write FYAxesMinValue;
    property YAxesSpanValue: double read FYAxesSpanValue write FYAxesSpanValue;
    property UseXYGraphConstant: Boolean read FUseXYGraphConstant write FUseXYGraphConstant default false;
    property IsDisplayTrendAlarm: Boolean read FIsDisplayTrendAlarm write FIsDisplayTrendAlarm default false;
    property IsDisplayTrendFault: Boolean read FIsDisplayTrendFault write FIsDisplayTrendFault default false;

    //True = 모니터링 값을 평균값으로 보여 줌
    property IsAverageValue: Boolean read FIsAverageValue write FIsAverageValue;
    property AlarmLevel: integer read FAlarmLevel write FAlarmLevel;
    //Drag시 FExcelRange := FApplicationPath + FCurrentParaFileName이 저장됨
    property FExcelRange: string read FFExcelRange write FFExcelRange;

    property MatrixItemIndex: integer read FMatrixItemIndex write FMatrixItemIndex;
    property XAxisSize: integer read FXAxisSize write FXAxisSize;
    property YAxisSize: integer read FYAxisSize write FYAxisSize;
    property ZAxisSize: integer read FZAxisSize write FZAxisSize;

    property XAxisDescriptor: string read FXAxisDescriptor write FXAxisDescriptor;
    property XAxisDisplayKey: string read FXAxisDisplayKey write FXAxisDisplayKey;
    property XAxisDisplayName: string read FXAxisDisplayName write FXAxisDisplayName;
    property XAxisUnit: string read FXAxisUnit write FXAxisUnit;
    property XAxisDecimal: integer read FXAxisDecimal write FXAxisDecimal;
    property YAxisDescriptor: string read FYAxisDescriptor write FYAxisDescriptor;
    property YAxisDisplayKey: string read FYAxisDisplayKey write FYAxisDisplayKey;
    property YAxisDisplayName: string read FYAxisDisplayName write FYAxisDisplayName;
    property YAxisUnit: string read FYAxisUnit write FYAxisUnit;
    property YAxisDecimal: integer read FYAxisDecimal write FYAxisDecimal;

    property SensorCode: string read FSensorCode write FSensorCode;  //AlarmList에서는 해당 Alarm과 연관 있는 Sensor TagName을 저장함
    property IsSaveItem: Boolean read FIsSaveItem write FIsSaveItem;
    property AlarmEnable: Boolean read FAlarmEnable write FAlarmEnable;//False: inhibit
    property AlarmSuppress: Boolean read FAlarmSuppress write FAlarmSuppress;//True: Suppress

    property MinAlarmDeadBand: double read FMinAlarmDeadBand write FMinAlarmDeadBand;
    property MaxAlarmDeadBand: double read FMaxAlarmDeadBand write FMaxAlarmDeadBand;
    property MinFaultDeadBand: double read FMinFaultDeadBand write FMinFaultDeadBand;
    property MaxFaultDeadBand: double read FMaxFaultDeadBand write FMaxFaultDeadBand;

    property MinAlarmDelay: integer read FMinAlarmDelay write FMinAlarmDelay; //Simulaton Mode에서는 ModbusMode 저장함
    property MaxAlarmDelay: integer read FMaxAlarmDelay write FMaxAlarmDelay;
    property MinFaultDelay: integer read FMinFaultDelay write FMinFaultDelay;
    property MaxFaultDelay: integer read FMaxFaultDelay write FMaxFaultDelay;

    property ProjNo: string read FProjNo write FProjNo;    //AMS를 위해 추가함
    property EngNo: string read FEngNo write FEngNo; //AMS를 위해 추가함
    property DigitalAlarmValue: Boolean read FDigitalAlarmValue write FDigitalAlarmValue default true;

    property MinAlarmNeedAck: Boolean read FMinAlarmNeedAck write FMinAlarmNeedAck default false;
    property MaxAlarmNeedAck: Boolean read FMaxAlarmNeedAck write FMaxAlarmNeedAck default false;
    property MinFaultNeedAck: Boolean read FMinFaultNeedAck write FMinFaultNeedAck default false;
    property MaxFaultNeedAck: Boolean read FMaxFaultNeedAck write FMaxFaultNeedAck default false; //Simulaton Mode에서는 UseBalloon 저장 함

    property Notes: string read FNotes write FNotes; //Parameter 추가 설명
    property descriptor: string read FDescriptor write FDescriptor; //.e2s 파일의 value-infomation과 value-states의 연결고리
    property XAxisData: string read FXAxisData write FXAxisData; //X축 Data: csv로 저장됨
    property YAxisData: string read FYAxisData write FYAxisData; //Y축 Data: csv로 저장됨
    property MatrixData: string read FMatrixData write FMatrixData; //배열 Data: '[[csv],[csv]...]' 형식으로 저장됨
    property DescriptionKey: string read FDescriptionKey write FDescriptionKey;

    property PanelName: TPanelKind4AVAT2 read FPanelName write FPanelName;
    property TBName: TTBKind4AVAT2 read FTBName write FTBName;
    property TBNo: string read FTBNo write FTBNo;
    property DrawingNo: string read FDrawingNo write FDrawingNo; //Simulaton Mode에서는 Design Form Caption 저장 함
    property ManualNo: string read FManualNo write FManualNo;

    property UpdateDate: TDateTime read FUpdateDate write FUpdateDate;
