    FUserLevel: THiMECSUserLevel;
    FAlarmLevel,
    FLevelIndex,
    FNodeIndex,
    FAbsoluteIndex, //Modbus Map에서 각 Request별 위치 정보(공유메모리상의 Index) : 0부터 시작함
    FMaxValue,
    FBlockNo,
    FContact, //1: A 접점, 2: B 접점
    //소수점 위치 = 0이면 정수, 1이면 0.1 ... (Binary Type일 경우 32Bit 중 Position Index 저장)
    FRadixPosition
    : integer;

    FMaxValue_Real: real; //avat의 경우 real값이 옴.
    FSharedName,
    FTagName,
    //SnapShot File의 UI_TextPool에서 key(dds.Par70244_PilotFuelDurationOffsetA5)를 이용하여 가져옴
    //SnapShot File의 process-value-informations에서 DisplayName에 상기 key가 존재함
    FDescription,  //Matrix Data일 경우 Description(XAxis Desc;YAxis Desc;ZAxis Desc)
    //SnapShot File의 dataStructureDocumentation에서 descriptor를 이용하여 가져옴
    //SnapShot File의 process-value-informations에서 descriptor가 존재함
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
    FProjNo, //공사번호
    FEngNo,  //엔진순번(1부터 시작)
    FDescriptor, //.e2s 파일의 value-infomation과 value-states의 연결고리
    FDisplayFormat //FormatFloat함수 인자로 사용됨
    : string;

    FAlarm,//True = Analog, False = Digital
    FDisplayUnit, //단위 표시 유무
    FDisplayThousandSeperator,//1000 단위 구분자(,) 표시 유무
    FAlarmEnable,//inhibit
    FAlarmSuppress,//Suppress
    FDigitalAlarmValue,//Digital Type 알람 설정 값
    FMinAlarmEnable, //아래 변수들 사용 여부
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
    FDFAlarmKind: TDFAlarmKind; //알람 발생했을 경우 어떤 알람인지 구분함
    FEngineUsage: TEngineUsage;
    FDFCommissioningItem: TDFCommissioningItem;
    FAlarmKind4AVAT2: TAlarmKind4AVAT2;
    FAlarmLimit4AVAT2: TAlarmLimit4AVAT2;
    //==================================================
    FAlarmPriority: TAlarmPriority;//(apCritical, apWarning, apAdvisory, apLog)

    FMinAlarmValue: double; //Fault보다 낮은 레벨
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
    FMaxFaultDelay: integer; //Digital Type일 경우 FMaxFaultDelay를 해당 Alarm의 DelayTime으로 사용함

    FMinAlarmStartTime: TDateTime; //mSec Start time when Alarm on
    FMaxAlarmStartTime: TDateTime;
    FMinFaultStartTime: TDateTime;
    FMaxFaultStartTime: TDateTime; //Digital Type일 경우 FMaxFaultStartTime을 해당 Alarm의 StartTime으로 사용함

    FMinAlarmColor: Longint; //Alarm 발생시 표시색
    FMaxAlarmColor: Longint;
    FMinFaultColor: Longint;
    FMaxFaultColor: Longint;

    FMinAlarmBlink: Boolean; //Alarm 발생시 Blink
    FMaxAlarmBlink: Boolean;
    FMinFaultBlink: Boolean;
    FMaxFaultBlink: Boolean;

    FMinAlarmSoundEnable: Boolean; //Sound들 사용 여부
    FMaxAlarmSoundEnable: Boolean;
    FMinFaultSoundEnable: Boolean;
    FMaxFaultSoundEnable: Boolean;

    FMinAlarmSoundFilename: string; //Sound File Name
    FMaxAlarmSoundFilename: string; //
    FMinFaultSoundFilename: string;
    FMaxFaultSoundFilename: string;

    FMinAlarmNeedAck: Boolean; //알람 해제시 ACK 필요 여부
    FMaxAlarmNeedAck: Boolean;
    FMinFaultNeedAck: Boolean;
    FMaxFaultNeedAck: Boolean;

    FFormulaValueList: string; //Item간 계산 식(=''이면 Raw Item)
    FNotes: string;
//    FAlarmSetType: TAlarmSetType; //알람 발생했을 경우 어느 알람인지 저장함

    //=====================//for Graph (Watch 폼에서)
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

    //=====================//for Graph (Watch Save 폼에서)
    FIsAverageValue: Boolean;
    FFExcelRange: string;

    //====================//for Config Matrix
    FMatrixItemIndex,//Matrix Data일 경우 TMatrixItem Index
    FXAxisSize,      //Matrix Data일 경우 XAxis ArrayLength
    FYAxisSize,      //Matrix Data일 경우 YAxis ArrayLength
    FZAxisSize: integer; //Matrix Data일 경우 ZAxis ArrayLength
    FKbdShiftState: TShiftState;//Watch2 Form에 Ctrl 키 누름 상태 보내기 위해 사용 됨
    FParamDragCopyMode: TParamDragCopyMode;//Watch2 Form에 Drag시 Copy Mode 상태 보내기 위해 사용 됨
    FXAxisDescriptor,
    FXAxisDisplayKey,
    FXAxisDisplayName,
    FXAxisUnit,
    FXAxisData: string; //X축 Data: csv로 저장됨
    FXAxisDecimal: integer;
    FYAxisDescriptor,
    FYAxisDisplayKey,
    FYAxisDisplayName,
    FYAxisUnit,
    FYAxisData: string; //Y축 Data: csv로 저장됨
    FYAxisDecimal: integer;
    FMatrixData: string;//배열 Data: '[[csv],[csv]...]' 형식으로 저장됨

    FSensorCode: string; //Sensor 정보 및 위치를 추적하기 위해 사용됨
    FDescriptionKey: string; //Description의 displayName(dds.xxxxx)이 저장됨

    //===================//ECU Panel Info
    FPanelName: TPanelKind4AVAT2;
    FTBName: TTBKind4AVAT2;
    FTBNo,
    FDrawingNo,
    FManualNo: string;

    //===================//DataSaveAll에서 사용
    FIsSaveItem: Boolean;//False = DB 또는 File에 저장하지 않음(모니터링만 함-통신)

    FIsSimulateMode: Boolean;
    FSimulateValue: string;
    FFormulaValueStringList: TStringList;
    FNextGridRow: Pointer;

    FUpdateDate: TDateTime;
