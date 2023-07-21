    FUserLevel: THiMECSUserLevel;
    FAlarmLevel,
    FLevelIndex,
    FNodeIndex,
    FAbsoluteIndex, //Modbus Map���� �� Request�� ��ġ ����(�����޸𸮻��� Index) : 0���� ������
    FMaxValue,
    FBlockNo,
    FContact, //1: A ����, 2: B ����
    //�Ҽ��� ��ġ = 0�̸� ����, 1�̸� 0.1 ... (Binary Type�� ��� 32Bit �� Position Index ����)
    FRadixPosition
    : integer;

    FMaxValue_Real: real; //avat�� ��� real���� ��.
    FSharedName,
    FTagName,
    //SnapShot File�� UI_TextPool���� key(dds.Par70244_PilotFuelDurationOffsetA5)�� �̿��Ͽ� ������
    //SnapShot File�� process-value-informations���� DisplayName�� ��� key�� ������
    FDescription,  //Matrix Data�� ��� Description(XAxis Desc;YAxis Desc;ZAxis Desc)
    //SnapShot File�� dataStructureDocumentation���� descriptor�� �̿��Ͽ� ������
    //SnapShot File�� process-value-informations���� descriptor�� ������
    FDescription_Eng,
    FDescription_Kor,
    FParamNo,
    FAddress,
    FFCode,
    FFUnit,
    FScale,
    FValue,
    FMinLimitValue,
    FDefaultValue,
    FMaxLimitValue,
    FProjNo, //�����ȣ
    FEngNo,  //��������(1���� ����)
    FDescriptor, //.e2s ������ value-infomation�� value-states�� �������
    FDisplayFormat //FormatFloat�Լ� ���ڷ� ����
    : string;

    FAlarm,//True = Analog, False = Digital
    FDisplayUnit, //���� ǥ�� ����
    FDisplayThousandSeperator,//1000 ���� ������(,) ǥ�� ����
    FAlarmEnable,//inhibit
    FAlarmSuppress,//Suppress
    FDigitalAlarmValue,//Digital Type �˶� ���� ��
    FMinAlarmEnable, //�Ʒ� ������ ��� ����
    FMaxAlarmEnable, //
    FMinFaultEnable,
    FMaxFaultEnable
    : Boolean;

    FMinMaxType: TValueType; //mmtInteger, mmtReal
    FSensorType: TSensorType;
    FParameterCatetory: TParameterCategory;
    FParameterCatetory4AVAT2: TParameterCategory4AVAT2;
    FParameterSubCatetory4AVAT2: TParameterSubCategory4AVAT2;
    FParameterType: TParameterType;
    FParameterSource: TParameterSource;
    FDFAlarmKind: TDFAlarmKind; //�˶� �߻����� ��� � �˶����� ������
    FEngineUsage: TEngineUsage;
    FDFCommissioningItem: TDFCommissioningItem;
    FAlarmKind4AVAT2: TAlarmKind4AVAT2;
    FAlarmLimit4AVAT2: TAlarmLimit4AVAT2;
    //==================================================
    FAlarmPriority: TAlarmPriority;//(apCritical, apWarning, apAdvisory, apLog)

    FMinAlarmValue: double; //Fault���� ���� ����
    FMaxAlarmValue: double; //
    FMinFaultValue: double;
    FMaxFaultValue: double;

    FMinAlarmDeadBand: double;
    FMaxAlarmDeadBand: double;
    FMinFaultDeadBand: double;
    FMaxFaultDeadBand: double;

    FMinAlarmDelay: integer; //mSec Delay time
    FMaxAlarmDelay: integer;
    FMinFaultDelay: integer;
    FMaxFaultDelay: integer; //Digital Type�� ��� FMaxFaultDelay�� �ش� Alarm�� DelayTime���� �����

    FMinAlarmStartTime: TDateTime; //mSec Start time when Alarm on
    FMaxAlarmStartTime: TDateTime;
    FMinFaultStartTime: TDateTime;
    FMaxFaultStartTime: TDateTime; //Digital Type�� ��� FMaxFaultStartTime�� �ش� Alarm�� StartTime���� �����

    FMinAlarmColor: Longint; //Alarm �߻��� ǥ�û�
    FMaxAlarmColor: Longint;
    FMinFaultColor: Longint;
    FMaxFaultColor: Longint;

    FMinAlarmBlink: Boolean; //Alarm �߻��� Blink
    FMaxAlarmBlink: Boolean;
    FMinFaultBlink: Boolean;
    FMaxFaultBlink: Boolean;

    FMinAlarmSoundEnable: Boolean; //Sound�� ��� ����
    FMaxAlarmSoundEnable: Boolean;
    FMinFaultSoundEnable: Boolean;
    FMaxFaultSoundEnable: Boolean;

    FMinAlarmSoundFilename: string; //Sound File Name
    FMaxAlarmSoundFilename: string; //
    FMinFaultSoundFilename: string;
    FMaxFaultSoundFilename: string;

    FMinAlarmNeedAck: Boolean; //�˶� ������ ACK �ʿ� ����
    FMaxAlarmNeedAck: Boolean;
    FMinFaultNeedAck: Boolean;
    FMaxFaultNeedAck: Boolean;

    FFormulaValueList: string; //Item�� ��� ��(=''�̸� Raw Item)
    FNotes: string;
//    FAlarmSetType: TAlarmSetType; //�˶� �߻����� ��� ��� �˶����� ������

    //=====================//for Graph (Watch ������)
    FIsDisplayTrend,
    FIsDisplayXY,
    FIsDisplaySimple: Boolean;

    FTrendChannelIndex,
    FTrendAlarmIndex,
    FTrendFaultIndex,
    FMinValue,
    FTrendYAxisIndex: integer;

    FPlotXValue: double;
    FMinValue_Real: real;
    FYAxesMinValue: Double;
    FYAxesSpanValue: Double;
    FUseXYGraphConstant: Boolean;
    FIsDisplayTrendAlarm: Boolean;
    FIsDisplayTrendFault: Boolean;

    //=====================//for Graph (Watch Save ������)
    FIsAverageValue: Boolean;
    FFExcelRange: string;

    //====================//for Config Matrix
    FMatrixItemIndex,//Matrix Data�� ��� TMatrixItem Index
    FXAxisSize,      //Matrix Data�� ��� XAxis ArrayLength
    FYAxisSize,      //Matrix Data�� ��� YAxis ArrayLength
    FZAxisSize: integer; //Matrix Data�� ��� ZAxis ArrayLength
    FKbdShiftState: TShiftState;//Watch2 Form�� Ctrl Ű ���� ���� ������ ���� ��� ��
    FParamDragCopyMode: TParamDragCopyMode;//Watch2 Form�� Drag�� Copy Mode ���� ������ ���� ��� ��
    FXAxisDescriptor,
    FXAxisDisplayKey,
    FXAxisDisplayName,
    FXAxisUnit,
    FXAxisData: string; //X�� Data: csv�� �����
    FXAxisDecimal: integer;
    FYAxisDescriptor,
    FYAxisDisplayKey,
    FYAxisDisplayName,
    FYAxisUnit,
    FYAxisData: string; //Y�� Data: csv�� �����
    FYAxisDecimal: integer;
    FMatrixData: string;//�迭 Data: '[[csv],[csv]...]' �������� �����

    FSensorCode: string; //Sensor ���� �� ��ġ�� �����ϱ� ���� ����
    FDescriptionKey: string; //Description�� displayName(dds.xxxxx)�� �����

    //===================//ECU Panel Info
    FPanelName: TPanelKind4AVAT2;
    FTBName: TTBKind4AVAT2;
    FTBNo,
    FDrawingNo,
    FManualNo: string;

    //===================//DataSaveAll���� ���
    FIsSaveItem: Boolean;//False = DB �Ǵ� File�� �������� ����(����͸��� ��-���)

    FIsSimulateMode: Boolean;
    FSimulateValue: string;
    FFormulaValueStringList: TStringList;
    FNextGridRow: Pointer;

    FUpdateDate: TDateTime;