{�� ���Ͽ��� Item �߰� �ÿ� �ݵ�� EP:Item.inc���� �߰��� �־�� ��}

  private
{$I EngineParameterItem.inc}
  public
    FPCircularArray: Pointer;  //HiMECS_WathSave���� ��հ��� �����ϱ� ���� ����ť�� ������

//    procedure Assign(Source: TPersistent); override;
//    procedure AssignTo(var ARecord: TEngineParameterItemRecord);
//    function IsMatrixData: Boolean;

    FIsUpdate: Boolean;
    FMultiStateItemIndex, //Begin Index
    FMultiStateItemCount,
    FCurrentStateAryIdx //
    : integer;
    FMultiStateValues: string;//Json ������ Values {"TagName":"","Address":""...}
    FModBusMode: integer;
    FDFPageCaption: string;//Design Form Page Caption
    FDFPageIndex: integer; //Design Form Page Index
//    FUseBalloon: Boolean; //True: Design Form�� Balloon Hint�� ǥ����
    FIsHideItem: Boolean;//Treeview�� ǥ������ ����(Param Search �Ҷ� ���)

    property IsUpdate: Boolean read FIsUpdate write FIsUpdate;
    //HiMECS_DF_A2_Sensor_r4.sqlite���� EngineParameter Load�ÿ�
    //EngineParamRecord ���̺��� TagName�� ������ TagName��
    //EngineMultiStateRecord ���̺��� �����ϸ�
    //MultiStateItemIndex�� -1�� �ƴ� Index�� �����ϰ� MultiStateValues �� StateMeaning ����Ʈ�� ������
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
    property NodeIndex: integer read FNodeIndex write FNodeIndex; //Simulate Mode�� Position Index�� ���
    property AbsoluteIndex: integer read FAbsoluteIndex write FAbsoluteIndex;//Project Index�� ���(FCOI)
    property MaxValue: integer read FMaxValue write FMaxValue;
    property BlockNo: integer read FBlockNo write FBlockNo;
    property MaxValue_Real: real read FMaxValue_Real write FMaxValue_Real;
    property Contact: integer read FContact write FContact;
    property Scale: string read FScale write FScale; //������ String�ε� Integer���� ����Ǹ� LoadFromJSONFile�� �ȵ�
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

    //True = ����͸� ���� ��հ����� ���� ��
    property IsAverageValue: Boolean read FIsAverageValue write FIsAverageValue;
    property AlarmLevel: integer read FAlarmLevel write FAlarmLevel;
    //Drag�� FExcelRange := FApplicationPath + FCurrentParaFileName�� �����
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

    property SensorCode: string read FSensorCode write FSensorCode;  //AlarmList������ �ش� Alarm�� ���� �ִ� Sensor TagName�� ������
    property IsSaveItem: Boolean read FIsSaveItem write FIsSaveItem;
    property AlarmEnable: Boolean read FAlarmEnable write FAlarmEnable;//False: inhibit
    property AlarmSuppress: Boolean read FAlarmSuppress write FAlarmSuppress;//True: Suppress

    property MinAlarmDeadBand: double read FMinAlarmDeadBand write FMinAlarmDeadBand;
    property MaxAlarmDeadBand: double read FMaxAlarmDeadBand write FMaxAlarmDeadBand;
    property MinFaultDeadBand: double read FMinFaultDeadBand write FMinFaultDeadBand;
    property MaxFaultDeadBand: double read FMaxFaultDeadBand write FMaxFaultDeadBand;

    property MinAlarmDelay: integer read FMinAlarmDelay write FMinAlarmDelay; //Simulaton Mode������ ModbusMode ������
    property MaxAlarmDelay: integer read FMaxAlarmDelay write FMaxAlarmDelay;
    property MinFaultDelay: integer read FMinFaultDelay write FMinFaultDelay;
    property MaxFaultDelay: integer read FMaxFaultDelay write FMaxFaultDelay;

    property ProjNo: string read FProjNo write FProjNo;    //AMS�� ���� �߰���
    property EngNo: string read FEngNo write FEngNo; //AMS�� ���� �߰���
    property DigitalAlarmValue: Boolean read FDigitalAlarmValue write FDigitalAlarmValue default true;

    property MinAlarmNeedAck: Boolean read FMinAlarmNeedAck write FMinAlarmNeedAck default false;
    property MaxAlarmNeedAck: Boolean read FMaxAlarmNeedAck write FMaxAlarmNeedAck default false;
    property MinFaultNeedAck: Boolean read FMinFaultNeedAck write FMinFaultNeedAck default false;
    property MaxFaultNeedAck: Boolean read FMaxFaultNeedAck write FMaxFaultNeedAck default false; //Simulaton Mode������ UseBalloon ���� ��










    property TBNo: string read FTBNo write FTBNo;
    property DrawingNo: string read FDrawingNo write FDrawingNo; //Simulaton Mode������ Design Form Caption ���� ��
    property ManualNo: string read FManualNo write FManualNo;


