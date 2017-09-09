unit UnitDAQMX;

interface

uses
  Winapi.Windows, Winapi.MessageS;
//Attribute VB_Name = "DAQMX"
// DAQMX.bas
// -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
//
// Copyright (c) 2003-2007 Yokogawa Electric Corporation. All rights reserved.
//
// This is defined export DAQMX.dll.
//
// -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
// 2007/09/30 Ver.3 Rev.1
// 2007/05/30 Ver.3 Rev.0
// 2004/11/01 Ver.2 Rev.1
// 2003/05/30 Ver.1 Rev.1
// -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    // communication
    const DAQMX_COMMPORT = 34316;

    // total number
    const DAQMX_NUMMODULE = 6;
    const DAQMX_NUMCHANNEL = 60;
    const DAQMX_NUMDO = DAQMX_NUMCHANNEL;
    const DAQMX_NUMFIFO = 3;
    const DAQMX_NUMALARM = 4;
    const DAQMX_NUMSEGMENT = 2;
    const DAQMX_NUMMACADDR = 6;
    const DAQMX_NUMAOPWM = DAQMX_NUMCHANNEL;
    const DAQMX_NUMBALANCE = DAQMX_NUMCHANNEL;
    const DAQMX_NUMOUTPUT = DAQMX_NUMCHANNEL;

    // string length without NULL
    const DAQMX_MAXHOSTNAMELEN = 64;
    const DAQMX_MAXUNITLEN = 6;
    const DAQMX_MAXTAGLEN = 15;
    const DAQMX_MAXCOMMENTLEN = 30;
    const DAQMX_MAXSERIALLEN = 9;
    const DAQMX_MAXPARTNOLEN = 7;

    // maximum number
    const DAQMX_MAXDECIMALPOINT = 4;
    const DAQMX_MAXDISPTIME = 120000;
    const DAQMX_MAXPULSETIME = 30000;

    // constant value
    const DAQMX_INSTANTANEOUS = -1;
    const DAQMX_REFCHNO_NONE = 0;
    const DAQMX_REFCHNO_ALL = -1;
    const DAQMX_LEVELNO_ALL = -1;
    const DAQMX_DONO_ALL = -1;
    const DAQMX_SEGMENTNO_ALL = -1;
    const DAQMX_CHNO_ALL = -1;
    const DAQMX_MODULENO_ALL = -1;
    const DAQMX_FIFONO_ALL = -1;
    const DAQMX_AOPWMNO_ALL = -1;
    const DAQMX_BALANCENO_ALL = -1;
    const DAQMX_OUTPUTNO_ALL = -1;

    // valid
    const DAQMX_VALID_OFF = 0;
    const DAQMX_VALID_ON = 1;

    // flag
    const DAQMX_FLAG_OFF = $0000;
    const DAQMX_FLAG_ENDDATA = $0001;

    // data status
    const DAQMX_DATA_UNKNOWN = $00000000;
    const DAQMX_DATA_NORMAL = $00000001;
    const DAQMX_DATA_PLUSOVER = $00007FFF;
    const DAQMX_DATA_MINUSOVER = $00008001;
    const DAQMX_DATA_SKIP = $00008002;
    const DAQMX_DATA_ILLEGAL = $00008003;
    const DAQMX_DATA_NODATA = $00008005;
    const DAQMX_DATA_LACK = $00008400;
    const DAQMX_DATA_INVALID = $00008700;

    // alarm type
    const DAQMX_ALARM_NONE = 0;
    const DAQMX_ALARM_UPPER = 1;
    const DAQMX_ALARM_LOWER = 2;
    const DAQMX_ALARM_UPDIFF = 3;
    const DAQMX_ALARM_LOWDIFF = 4;

    // system control
    const DAQMX_SYSTEM_RECONSTRUCT = 1;
    const DAQMX_SYSTEM_INITOPE = 2;
    const DAQMX_SYSTEM_RESETALARM = 3;

    // channel kind
    const DAQMX_CHKIND_NONE = $0000;
    const DAQMX_CHKIND_AI = $0010;
    const DAQMX_CHKIND_AIDIFF = $0011;
    const DAQMX_CHKIND_AIRJC = $0012;
    const DAQMX_CHKIND_DI = $0030;
    const DAQMX_CHKIND_DIDIFF = $0031;
    const DAQMX_CHKIND_DO = $0040;
    const DAQMX_CHKIND_DOCOM = $0041;
    const DAQMX_CHKIND_DOFAIL = $0042;
    const DAQMX_CHKIND_DOERR = $0043;
    const DAQMX_CHKIND_AO = $0020;
    const DAQMX_CHKIND_AOCOM = $0021;
    const DAQMX_CHKIND_PWM = $0060;
    const DAQMX_CHKIND_PWMCOM = $0061;
    const DAQMX_CHKIND_PI = $0050;
    const DAQMX_CHKIND_PIDIFF = $0051;
    const DAQMX_CHKIND_CI = $0070;
    const DAQMX_CHKIND_CIDIFF = $0071;

    // scale type
    const DAQMX_SCALE_NONE = 0;
    const DAQMX_SCALE_LINER = 1;

    // module type
    // 0xF0000010 -> -268435440
    // 0xF0001C10 -> -268428272
    // 0xB0101F10 -> -1341120752
    // 0xD0001130 -> -805301968
    // 0x0000FF00 -> 65280
    const DAQMX_MODULE_NONE = $0;
    const DAQMX_MODULE_MX110UNVH04 = -268435440;
    const DAQMX_MODULE_MX110UNVM10 = -268428272;
    const DAQMX_MODULE_MX115D05H10 = $10003010;
    const DAQMX_MODULE_MX125MKCM10 = $00402010;
    const DAQMX_MODULE_MX110V4RM06 = -1341120752;
    const DAQMX_MODULE_MX112NDIM04 = $01004010;
    const DAQMX_MODULE_MX112B35M04 = $01004110;
    const DAQMX_MODULE_MX112B12M04 = $01004210;
    const DAQMX_MODULE_MX115D24H10 = $10003210;
    const DAQMX_MODULE_MX120VAOM08 = $0080C010;
    const DAQMX_MODULE_MX120PWMM08 = $0020C810;
    const DAQMX_MODULE_HIDDEN      = 65280;
    const DAQMX_MODULE_MX114PLSM10 = $0400B010;
    const DAQMX_MODULE_MX110VTDL30 = -805301968;
    const DAQMX_MODULE_MX118CANM10 = $00085110;
    const DAQMX_MODULE_MX118CANM20 = $00085220;
    const DAQMX_MODULE_MX118CANM30 = $00085330;
    const DAQMX_MODULE_MX118CANSUB = $00085000;
    const DAQMX_MODULE_MX118CANMERR = $00005A10;
    const DAQMX_MODULE_MX118CANSERR = $00005B10;

    // how many channels by each module
    const DAQMX_CHNUM_0 = 0;
    const DAQMX_CHNUM_4 = 4;
    const DAQMX_CHNUM_6 = 6;
    const DAQMX_CHNUM_8 = 8;
    const DAQMX_CHNUM_10 = 10;
    const DAQMX_CHNUM_30 = 30;

    // interval (msec)
    const DAQMX_INTERVAL_10 = 10;
    const DAQMX_INTERVAL_50 = 50;
    const DAQMX_INTERVAL_100 = 100;
    const DAQMX_INTERVAL_200 = 200;
    const DAQMX_INTERVAL_500 = 500;
    const DAQMX_INTERVAL_1000 = 1000;
    const DAQMX_INTERVAL_2000 = 2000;
    const DAQMX_INTERVAL_5000 = 5000;
    const DAQMX_INTERVAL_10000 = 10000;
    const DAQMX_INTERVAL_20000 = 20000;
    const DAQMX_INTERVAL_30000 = 30000;
    const DAQMX_INTERVAL_60000 = 60000;

    // filter
    const DAQMX_FILTER_0 = 0;
    const DAQMX_FILTER_5 = 1;
    const DAQMX_FILTER_10 = 2;
    const DAQMX_FILTER_20 = 3;
    const DAQMX_FILTER_25 = 4;
    const DAQMX_FILTER_40 = 5;
    const DAQMX_FILTER_50 = 6;
    const DAQMX_FILTER_100 = 7;

    // RJC Type
    const DAQMX_RJC_INTERNAL = 0;
    const DAQMX_RJC_EXTERNAL = 1;

    // burnout
    const DAQMX_BURNOUT_OFF = 0;
    const DAQMX_BURNOUT_UP = 1;
    const DAQMX_BURNOUT_DOWN = 2;

    // unit type
    const DAQMX_UNITTYPE_NONE = $00000000;
    const DAQMX_UNITTYPE_MX100 = $00010000;

    // terminal type
    const DAQMX_TERMINAL_SCREW = 0;
    const DAQMX_TERMINAL_CLAMP = 1;
    const DAQMX_TERMINAL_NDIS = 2;
    const DAQMX_TERMINAL_DSUB = 3;

    // AD
    const DAQMX_INTEGRAL_AUTO = 0;
    const DAQMX_INTEGRAL_50HZ = 1;
    const DAQMX_INTEGRAL_60HZ = 2;

    // temparature unit
    const DAQMX_TEMPUNIT_C = 0;
    const DAQMX_TEMPUNIT_F = 1;

    // CF write mode
    const DAQMX_CFWRITEMODE_ONCE = 0;
    const DAQMX_CFWRITEMODE_FIFO = 1;

    // CF status
    const DAQMX_CFSTATUS_NONE = $0000;
    const DAQMX_CFSTATUS_EXIST = $0001;
    const DAQMX_CFSTATUS_USE = $0002;
    const DAQMX_CFSTATUS_FORMAT = $0004;

    // UNIT status
    const DAQMX_UNITSTAT_NONE = $0000;
    const DAQMX_UNITSTAT_INIT = $0001;
    const DAQMX_UNITSTAT_STOP = $0002;
    const DAQMX_UNITSTAT_RUN = $0003;
    const DAQMX_UNITSTAT_BACKUP = $0004;

    // FIFO status
    const DAQMX_FIFOSTAT_NONE = DAQMX_UNITSTAT_NONE;
    const DAQMX_FIFOSTAT_INIT = DAQMX_UNITSTAT_INIT;
    const DAQMX_FIFOSTAT_STOP = DAQMX_UNITSTAT_STOP;
    const DAQMX_FIFOSTAT_RUN = DAQMX_UNITSTAT_RUN;
    const DAQMX_FIFOSTAT_BACKUP = DAQMX_UNITSTAT_BACKUP;

    // segment display type
    const DAQMX_DISPTYPE_NONE = 0;
    const DAQMX_DISPTYPE_ON = 1;
    const DAQMX_DISPTYPE_BLINK = 2;

    // choice
    const DAQMX_CHOICE_PREV = 0;
    const DAQMX_CHOICE_PRESET = 1;

    // transmit
    const DAQMX_TRANSMIT_NONE = 0;
    const DAQMX_TRANSMIT_RUN = 1;
    const DAQMX_TRANSMIT_STOP = 2;

    // balance
    const DAQMX_BALANCE_NONE = 0;
    const DAQMX_BALANCE_DONE = 1;
    const DAQMX_BALANCE_NG = 2;
    const DAQMX_BALANCE_ERROR = 3;

    // option
    const DAQMX_OPTION_NONE = $0000;
    const DAQMX_OPTION_DS = $0001;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // range
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    // Reference
    const DAQMX_RANGE_REFERENCE = -1;

    // Volt
    const DAQMX_RANGE_VOLT_20MV = $0000;
    const DAQMX_RANGE_VOLT_60MV = $0001;
    const DAQMX_RANGE_VOLT_200MV = $0002;
    const DAQMX_RANGE_VOLT_2V = $0003;
    const DAQMX_RANGE_VOLT_6V = $0004;
    const DAQMX_RANGE_VOLT_20V = $0005;
    const DAQMX_RANGE_VOLT_100V = $0006;
    const DAQMX_RANGE_VOLT_60MVH = $0007;
    const DAQMX_RANGE_VOLT_1V = $0008;
    const DAQMX_RANGE_VOLT_6VH = $0009;

    // TC
    const DAQMX_RANGE_TC_R = $0200;
    const DAQMX_RANGE_TC_S = $0201;
    const DAQMX_RANGE_TC_B = $0202;
    const DAQMX_RANGE_TC_K = $0203;
    const DAQMX_RANGE_TC_E = $0204;
    const DAQMX_RANGE_TC_J = $0205;
    const DAQMX_RANGE_TC_T = $0206;
    const DAQMX_RANGE_TC_N = $0207;
    const DAQMX_RANGE_TC_W = $0208;
    const DAQMX_RANGE_TC_L = $0209;
    const DAQMX_RANGE_TC_U = $020A;
    const DAQMX_RANGE_TC_KP = $020B;
    const DAQMX_RANGE_TC_PL = $020C;
    const DAQMX_RANGE_TC_PR = $020D;
    const DAQMX_RANGE_TC_NNM = $020E;
    const DAQMX_RANGE_TC_WR = $020F;
    const DAQMX_RANGE_TC_WWR = $0210;
    const DAQMX_RANGE_TC_AWG = $0211;
    const DAQMX_RANGE_TC_XK = $0212;

    // RTD 1mA
    const DAQMX_RANGE_RTD_1MAPT = $0300;
    const DAQMX_RANGE_RTD_1MAJPT = $0301;
    const DAQMX_RANGE_RTD_1MAPTH = $0302;
    const DAQMX_RANGE_RTD_1MAJPTH = $0303;
    const DAQMX_RANGE_RTD_1MANIS = $0304;
    const DAQMX_RANGE_RTD_1MANID = $0305;
    const DAQMX_RANGE_RTD_1MANI120 = $0306;
    const DAQMX_RANGE_RTD_1MAPT50 = $0307;
    const DAQMX_RANGE_RTD_1MACU10GE = $0308;
    const DAQMX_RANGE_RTD_1MACU10LN = $0309;
    const DAQMX_RANGE_RTD_1MACU10WEED = $030A;
    const DAQMX_RANGE_RTD_1MACU10BAILEY = $030B;
    const DAQMX_RANGE_RTD_1MAJ263B = $030C;
    const DAQMX_RANGE_RTD_1MACU10A392 = $030D;
    const DAQMX_RANGE_RTD_1MACU10A393 = $030E;
    const DAQMX_RANGE_RTD_1MACU25 = $030F;
    const DAQMX_RANGE_RTD_1MACU53 = $0310;
    const DAQMX_RANGE_RTD_1MACU100 = $0311;
    const DAQMX_RANGE_RTD_1MAPT25 = $0312;
    const DAQMX_RANGE_RTD_1MACU10GEH = $0313;
    const DAQMX_RANGE_RTD_1MACU10LNH = $0314;
    const DAQMX_RANGE_RTD_1MACU10WEEDH = $0315;
    const DAQMX_RANGE_RTD_1MACU10BAILEYH = $0316;
    const DAQMX_RANGE_RTD_1MAPTN = $0317;
    const DAQMX_RANGE_RTD_1MAJPTN = $0318;
    const DAQMX_RANGE_RTD_1MAPTG = $0319;
    const DAQMX_RANGE_RTD_1MACU100G = $031A;
    const DAQMX_RANGE_RTD_1MACU50G = $031B;
    const DAQMX_RANGE_RTD_1MACU10G = $031C;

    // RTD 2mA
    const DAQMX_RANGE_RTD_2MAPT = $0400;
    const DAQMX_RANGE_RTD_2MAJPT = $0401;
    const DAQMX_RANGE_RTD_2MAPTH = $0402;
    const DAQMX_RANGE_RTD_2MAJPTH = $0403;
    const DAQMX_RANGE_RTD_2MAPT50 = $0404;
    const DAQMX_RANGE_RTD_2MACU10GE = $0405;
    const DAQMX_RANGE_RTD_2MACU10LN = $0406;
    const DAQMX_RANGE_RTD_2MACU10WEED = $0407;
    const DAQMX_RANGE_RTD_2MACU10BAILEY = $0408;
    const DAQMX_RANGE_RTD_2MAJ263B = $0409;
    const DAQMX_RANGE_RTD_2MACU10A392 = $040A;
    const DAQMX_RANGE_RTD_2MACU10A393 = $040B;
    const DAQMX_RANGE_RTD_2MACU25 = $040C;
    const DAQMX_RANGE_RTD_2MACU53 = $040D;
    const DAQMX_RANGE_RTD_2MACU100 = $040E;
    const DAQMX_RANGE_RTD_2MAPT25 = $040F;
    const DAQMX_RANGE_RTD_2MACU10GEH = $0410;
    const DAQMX_RANGE_RTD_2MACU10LNH = $0411;
    const DAQMX_RANGE_RTD_2MACU10WEEDH = $0412;
    const DAQMX_RANGE_RTD_2MACU10BAILEYH = $0413;
    const DAQMX_RANGE_RTD_2MAPTN = $0414;
    const DAQMX_RANGE_RTD_2MAJPTN = $0415;
    const DAQMX_RANGE_RTD_2MACU100G = $0416;
    const DAQMX_RANGE_RTD_2MACU50G = $0417;
    const DAQMX_RANGE_RTD_2MACU10G = $0418;

    // DI
    const DAQMX_RANGE_DI_LEVEL = 1;
    const DAQMX_RANGE_DI_CONTACT = 2;

    // DI : detail
    const DAQMX_RANGE_DI_LEVEL_AI = $0100;
    const DAQMX_RANGE_DI_CONTACT_AI4 = $0101;
    const DAQMX_RANGE_DI_CONTACT_AI10 = $0102;
    const DAQMX_RANGE_DI_LEVEL_DI = $0103;
    const DAQMX_RANGE_DI_CONTACT_DI = $0104;
    const DAQMX_RANGE_DI_LEVEL_DI5V = DAQMX_RANGE_DI_LEVEL_DI;
    const DAQMX_RANGE_DI_LEVEL_DI24V = $0105;
    const DAQMX_RANGE_DI_CONTACT_AI30 = DAQMX_RANGE_DI_CONTACT_AI10;

    // RTD 0.25mA
    const DAQMX_RANGE_RTD_025MAPT500 = $0500;
    const DAQMX_RANGE_RTD_025MAPT1K = $0501;

    // RES
    const DAQMX_RANGE_RES_20 = $0600;
    const DAQMX_RANGE_RES_200 = $0601;
    const DAQMX_RANGE_RES_2K = $0602;

    // STR
    const DAQMX_RANGE_STRAIN_2K = $0700;
    const DAQMX_RANGE_STRAIN_20K = $0701;
    const DAQMX_RANGE_STRAIN_200K = $0702;

    // AO
    const DAQMX_RANGE_AO_10V = $1000;
    const DAQMX_RANGE_AO_20MA = $1001;

    // PWM
    const DAQMX_RANGE_PWM_1MS = $1100;
    const DAQMX_RANGE_PWM_10MS = $1101;

    // CAN
    const DAQMX_RANGE_COM_CAN = $0800;

    // PI
    const DAQMX_RANGE_PI_LEVEL = $0900;
    const DAQMX_RANGE_PI_CONTACT = $0901;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Output
    const DAQMX_OUTPUT_NONE = 0;
    const DAQMX_OUTPUT_AO_10V = DAQMX_RANGE_AO_10V;
    const DAQMX_OUTPUT_AO_20MA = DAQMX_RANGE_AO_20MA;
    const DAQMX_OUTPUT_PWM_1MS = DAQMX_RANGE_PWM_1MS;
    const DAQMX_OUTPUT_PWM_10MS = DAQMX_RANGE_PWM_10MS;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Structures
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    // 64bit data
    type MXDataNo = record
      aLow		: LongInt;
      aHigh		: LongInt;
    end;

    type MXUserTime = record
      aLow		: LongInt;
      aHigh		: LongInt;
    end;

    // Date Time
    type MXDateTime = record
      aTime		: LongInt;
      aMilliSecond	: LongInt;
    end;

    // Alarm
    type MXAlarm = record
      aType		: LongInt;
      aReserve	: LongInt;
      aON		: LongInt;
      aOFF		: LongInt;
    end;

    // Measured Data
    type MXDataInfo = record
      aValue		: LongInt;
      aStatus		: LongInt;
      aAlarm    : array[1..4]	of LongInt;
    end;

    // Channel
    type MXChConfigAIDI = record
      aSpanMin	: LongInt;
      aSpanMax	: LongInt;
      aScaleMin	: LongInt;
      aScaleMax	: LongInt;
      aRefChNo	: LongInt;
      aChatFilter	: LongInt;
    end;

    type MXChConfigAI = record
      aFilter		: LongInt;
      aRJCType	: LongInt;
      aRJCVolt	: LongInt;
      aBurnout	: LongInt;
    end;

    type MXChConfigDO = record
      aDeenergize	: LongInt;
      aHold		: LongInt;
      aRefAlarm:array[1..4, 1..60] of Byte;
    end;

    type MXChID = record
      aChNo		: LongInt;
      aPoint		: LongInt;
      aValid		: LongInt;
      aKind		: LongInt;
      aRange		: LongInt;
      aScaleType	: LongInt;
      aUnit		: string; //	aUnit		As String * DAQMX_MAXUNITLEN
      align1: array[1..4] of Byte;
      aTag		: String;//	aTag		As String * DAQMX_MAXTAGLEN
      aNULL		: Byte;
      aComment	: String; //	aComment	As String * DAQMX_MAXCOMMENTLEN
      align2: array[0..1] of Byte;
      aAlarm: array[1..4] of MXAlarm;
    end;

    type MXChConfig = record
      aChID	: MXChID;
      aAIDI	: MXChConfigAIDI;
      aAI	: MXChConfigAI;
      aDO	: MXChConfigDO;
    end;

    type MXChInfo = record
      aChID		: MXChID;
      aFIFONo		: LongInt;
      aFIFOIndex	: LongInt;
      aOrigMin	: Double;
      aOrigMax	: Double;
      aDispMin	: Double;
      aDispMax	: Double;
      aRealMin	: Double;
      aRealMax	: Double;
    end;

    // System
    type MXProductInfo = record
      aOption		: LongInt;
      aCheck		: LongInt;
      aSerial		: String;//	aSerial		As String * DAQMX_MAXSERIALLEN
      aNULL		: Byte;
      aMAC : array[0..5] of Byte;
    end;

    type MXUnitData = record
      aType		: LongInt;
      aStyle		: LongInt;
      aNo		: LongInt;
      aTempUnit	: LongInt;
      aCFTimeout	: LongInt;
      aCFWriteMode    : LongInt;
      aFrequency	: LongInt;
      aReserve        : LongInt;
      aPartNo		: String;//	aPartNo		As String * DAQMX_MAXPARTNOLEN
      aNULL		: Byte;
      aProduct	: MXProductInfo;
    end;

    type MXModuleData = record
      aType		: LongInt;
      aChNum		: LongInt;
      aInterval	: LongInt;
      aIntegralTime	: LongInt;
      aStandbyType	: LongInt;
      aRealType	: LongInt;
      aStatus		: LongInt;
      aVersion	: LongInt;
      aTerminalType	: LongInt;
      aFIFONo		: LongInt;
      aProduct	: MXProductInfo;
    end;

    type MXSystemInfo = record
      aUnit           : MXUnitData;
      aModule: array[0..5] of MXModuleData;
    end;

    // Status
    type MXCFInfo = record
      aStatus		: LongInt;
      aSize		: LongInt;
      aRemain		: LongInt;
      aReserve	: LongInt;
    end;

    type MXFIFOInfo = record
      aNo		: LongInt;
      aStatus		: LongInt;
      aInterval	: LongInt;
      aReserve	: LongInt;
      aOldNo		: MXDataNo;
      aNewNo		: MXDataNo;
    end;

    type MXStatus = record
      aUnitStatus		: LongInt;
      aConfigCnt		: LongInt;
      aTimeCnt		: LongInt;
      aFIFONum		: LongInt;
      aBackup			: LongInt;
      aReserve		: LongInt;
      aCFInfo			: MXCFInfo;
      aFIFOInfo: array[0..2] of MXFIFOInfo;
      aDateTime		: MXDateTime;
    end;

    // Network
    type MXNetInfo = record
      aAddress	: LongInt;
      aPort		: LongInt;
      aSubMask	: LongInt;
      aGateway	: LongInt;
      aHost		: String;//	aHost		As String * DAQMX_MAXHOSTNAMELEN
      align: array[0..7] of Byte;
    end;

    // DO
    type MXDO = record
      aValid	: LongInt;
      aONOFF	: LongInt;
    end;

    type MXDOData = record
      aDO: array[1..60] of  MXDO;
    end;

    // Segment
    type MXSegment = record
      aPattern: array[0..1] of LongInt;
    end;

    // Balance
    type MXBalance = record
      aValid : LongInt;
      aValue : LongInt;
    end;
    type MXBalanceData = record
      aBalance: array[1..60] of MXBalance;
    end;
    type MXBalanceResult = record
      aResult: array[1..60] of LongInt;
    end;

    // Output
    type MXOutput = record
      aType		: LongInt;
      aIdleChoice     : LongInt;
      aErrorChoice    : LongInt;
      aPresetValue    : LongInt;
      aPulseTime      : LongInt;
      aReserve	: LongInt;
    end;

    type MXOutputData = record
      aOutput: array[1..60] of MXOutput;
    end;

    // AO/PWM
    type MXAOPWM = record
      aValid  : LongInt;
      aValue  : LongInt;
    end;

    type MXAOPWMData  = record
      aAOPWM: array[1..60] of MXAOPWM;
    end;

    type MXTransmit = record
      aTransmit: array[1..60] of LongInt;
    end;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Low level communications
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function openMX(strAddress : Ansistring; var errorCode : LongInt) : LongInt; stdcall;
    function closeMX(daqmx : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Middle level communications
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // FIFO control commands
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function startFIFOMX(daqmx : LongInt) : LongInt; stdcall;
    function stopFIFOMX(daqmx : LongInt) : LongInt; stdcall;
    function autoFIFOMX(daqmx : LongInt; bAuto : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Date time commands
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setDateTimeMX(daqmx : LongInt; var pMXDateTime : MXDateTime) : LongInt; stdcall;
    function setDateTimeNowMX(daqmx : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Control Commands
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setBackupMX(daqmx : LongInt; bBakcup : LongInt; iCFWriteMode : LongInt) : LongInt; stdcall;
    function formatCFMX(daqmx : LongInt) : LongInt; stdcall;
    function initSystemMX(daqmx : LongInt; iCtrl : LongInt) : LongInt; stdcall;
    function setSegmentMX(daqmx : LongInt; iDispType : LongInt; dispTime : LongInt; var newSegment : MXSegment; var oldSegment :MXSegment) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Get status
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function getStatusDataMX(daqmx : LongInt; var pMXStatus : MXStatus) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Get system
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function getSystemConfigMX(daqmx : LongInt; var pMXSystemInfo : MXSystemInfo) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Configurature -> @see for Visual B:ic
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // DO
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function getDODataMX(daqmx : LongInt; var pMXDOData : MXDOData) : LongInt; stdcall;
    function setDODataMX(daqmx : LongInt; var pMXDOData : MXDOData) : LongInt; stdcall;
    function changeDODataMX(var pMXDOData : MXDOData; doNo : LongInt; bValid : LongInt; bONOFF : LongInt) : LongInt; stdcall;
    function setDOTypeMX(daqmx : LongInt; doNo : LongInt; iKind : LongInt; bDeenergize : LongInt; bHold : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Get channel information
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function talkChInfoMX(daqmx : LongInt; startChNo : LongInt; endChNo : LongInt) : LongInt; stdcall;
    function getChInfoMX(daqmx : LongInt; var pMXChInfo : MXChInfo; var pFlag : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Talker me:ured data by each channels
    // talkChDataMX -> talkChDataVBMX @see for Visual B:ic
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function getChDataNoMX(daqmx : LongInt; chNo : LongInt; var startDataNo : MXDataNo; var endDataNo : MXDataNo) : LongInt; stdcall;
    function talkChDataInstMX(daqmx : LongInt; chNo : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Talker me:ured data by each FIFO
    // talkFIFODataMX -> talkFIFODataVBMX @see for Visual B:ic
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function getFIFODataNoMX(daqmx : LongInt; fifoNo : LongInt; var startDataNo : MXDataNo; var endDataNo : MXDataNo) : LongInt; stdcall;
    function talkFIFODataInstMX(daqmx : LongInt; fifoNo : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Get me:ured data after talker
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function getTimeDataMX(daqmx : LongInt; var pMXDataNo : MXDataNo; var pMXDateTime : MXDateTime; var userTime : MXUserTime; var pFlag : LongInt) : LongInt; stdcall;
    function getChDataMX(daqmx : LongInt; var pMXDataNo : MXDataNo; var pMXChInfo : MXChInfo; var pMXDataInfo : MXDataInfo; var pFlag : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Misc
    // setUserTimeMX ->setUserTimeVBMX @see for Visual Basic
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function getLastErrorMX(daqmx : LongInt; var lastErr : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Set range
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setSKIPMX(daqmx : LongInt; startChNo : LongInt; endChNo : LongInt) : LongInt; stdcall;
    function setVOLTMX(daqmx : LongInt; iRangeVOLT : LongInt; startChNo : LongInt; endChNo : LongInt; spanMin : LongInt; spanMax : LongInt; scaleMin : LongInt; scaleMax : LongInt; scalePoint : LongInt) : LongInt; stdcall;
    function setTCMX(daqmx : LongInt; iRangeTC : LongInt; startChNo : LongInt; endChNo : LongInt; spanMin : LongInt; spanMax : LongInt; scaleMin : LongInt; scaleMax : LongInt; scalePoint : LongInt) : LongInt; stdcall;
    function setRTDMX(daqmx : LongInt; iRangeRTD : LongInt; startChNo : LongInt; endChNo : LongInt; spanMin : LongInt; spanMax : LongInt; scaleMin : LongInt; scaleMax : LongInt; scalePoint : LongInt) : LongInt; stdcall;
    function setDIMX(daqmx : LongInt; iRangeDI : LongInt; startChNo : LongInt; endChNo : LongInt; spanMin : LongInt; spanMax : LongInt; scaleMin : LongInt; scaleMax : LongInt; scalePoint : LongInt) : LongInt; stdcall;
    function setDELTAMX(daqmx : LongInt; refChNo : LongInt; startChNo : LongInt; endChNo : LongInt; spanMin : LongInt; spanMax : LongInt; scaleMin : LongInt; scaleMax : LongInt; scalePoint : LongInt; iRange : LongInt) : LongInt; stdcall;
    function setRRJCMX(daqmx : LongInt; refChNo : LongInt; startChNo : LongInt; endChNo : LongInt; spanMin : LongInt; spanMax : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Scalling
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setScallingUnitMX(daqmx : LongInt; strUnit : String; startChNo : LongInt; endChNo : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Alarm
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setAlarmMX(daqmx : LongInt; levelNo : LongInt; startChNo : LongInt; endChNo : LongInt; iAlarmType : LongInt; value : LongInt; histerisys : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Channel configure
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setTagMX(daqmx : LongInt; strTag : String; startChNo : LongInt; endChNo : LongInt) : LongInt; stdcall;
    function setCommentMX(daqmx : LongInt; strComment : String; startChNo : LongInt; endChNo : LongInt) : LongInt; stdcall;
    function setRJCTypeMX(daqmx : LongInt; iRJCType : LongInt; startChNo : LongInt; endChNo : LongInt; volt : LongInt) : LongInt; stdcall;
    function setFilterMX(daqmx : LongInt; iFilter : LongInt; startChNo : LongInt; endChNo : LongInt) : LongInt; stdcall;
    function setBurnoutMX(daqmx : LongInt; iBurnout : LongInt; startChNo : LongInt; endChNo : LongInt) : LongInt; stdcall;
    function setRefAlarmMX(daqmx : LongInt; refChNo : LongInt; startChNo : LongInt; endChNo : LongInt; levelNo : LongInt; bValid : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Unit configure
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setIntervalMX(daqmx : LongInt; moduleNo : LongInt; iInterval : LongInt; iHz : LongInt) : LongInt; stdcall;
    function setTempUnitMX(daqmx : LongInt; iTempUnit : LongInt) : LongInt; stdcall;
    function setUnitNoMX(daqmx : LongInt; unitNo : LongInt) : LongInt; stdcall;
    function setSystemTimeoutMX(daqmx : LongInt; timeout : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Utilities
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function toDoubleValueMX(dataValue : LongInt; point : LongInt) : Double; stdcall;
    function toStringValueMX(dataValue : LongInt; point : LongInt; strValue : String; lenValue : LongInt) : LongInt; stdcall;
    function toAlarmNameMX(iAlarmType : LongInt; strAlarm : String; lenAlarm : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Messages
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function getVersionAPIMX() : LongInt; stdcall;
    function getRevisionAPIMX () : LongInt; stdcall;
    function toErrorMessageMX(errCode : LongInt; errStr : String; errLen : LongInt) : LongInt; stdcall;
    function getMaxLenErrorMessageMX() : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Deprecated command
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setTimeOutMX(daqmx : LongInt; seconds : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // for Visual B:ic
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function talkConfigMX(daqmx : LongInt; var pMXSystemInfo : MXSystemInfo; var pMXStatus : MXStatus; var pMXNetInfo : MXNetInfo) : LongInt; stdcall;
    function getChConfigMX(daqmx : LongInt; var pMXChConfig : MXChConfig; var pFlag : LongInt) : LongInt; stdcall;
    function setSystemConfigMX(daqmx : LongInt; var pMXSystemInfo : MXSystemInfo) : LongInt; stdcall;
    function setChConfigMX(daqmx : LongInt; var pMXChConfig : MXChConfig) : LongInt; stdcall;
    function talkChDataVBMX(daqmx : LongInt; chNo : LongInt; var startDataNo : MXDataNo; var endDataNo : MXDataNo) : LongInt; stdcall;
    function talkFIFODataVBMX(daqmx : LongInt; fifoNo : LongInt; var startDataNo : MXDataNo; var endDataNo : MXDataNo) : LongInt; stdcall;
    function setUserTimeVBMX(daqmx : LongInt; var userTime : MXUserTime) : LongInt; stdcall;
    procedure incrementDataNoMX(var dataNo : MXDataNo; increment : LongInt); stdcall;
    procedure decrementDataNoMX(var dataNo : MXDataNo; decrement : LongInt); stdcall;
    function compareDataNoMX(var prevDataNo : MXDataNo; var nextDataNo : MXDataNo) : LongInt; stdcall;
    procedure toDateTimeMX(var pMXDateTime : MXDateTime; var pYear : LongInt; var pMonth : LongInt; var pDay : LongInt; var pHour : LongInt; var pMinute : LongInt; var pSecond : LongInt); stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // since R2.01
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setAOPWMDataMX(daqmx : LongInt; var pMXAOPWMData : MXAOPWMData) : LongInt; stdcall;
    function setTransmitMX(daqmx : LongInt; var pMXTransmit : MXTransmit) : LongInt; stdcall;
    function runBalanceMX(daqmx : LongInt; var pMXBalanceData : MXBalanceData; var pMXBalanceResult : MXBalanceResult) : LongInt; stdcall;
    function resetBalanceMX(daqmx : LongInt; var pMXBalanceData : MXBalanceData; var pMXBalanceResult : MXBalanceResult) : LongInt; stdcall;
    function setBalanceMX(daqmx : LongInt; var pMXBalanceData : MXBalanceData) : LongInt; stdcall;
    function getBalanceMX(daqmx : LongInt; var pMXBalanceData : MXBalanceData) : LongInt; stdcall;
    function getAOPWMDataMX(daqmx : LongInt; var pMXAOPWMData : MXAOPWMData; var pMXTransmit : MXTransmit) : LongInt; stdcall;
    function setRESMX(daqmx : LongInt; iRangeRES : LongInt; startChNo : LongInt; endChNo : LongInt; spanMin : LongInt; spanMax : LongInt; scaleMin : LongInt; scaleMax : LongInt; scalePoint : LongInt) : LongInt; stdcall;
    function setSTRAINMX(daqmx : LongInt; iRangeSTRAIN : LongInt; startChNo : LongInt; endChNo : LongInt; spanMin : LongInt; spanMax : LongInt; scaleMin : LongInt; scaleMax : LongInt; scalePoint : LongInt) : LongInt; stdcall;
    function setAOMX(daqmx : LongInt; iRangeAO : LongInt; startChNo : LongInt; endChNo : LongInt; spanMin : LongInt; spanMax : LongInt) : LongInt; stdcall;
    function setPWMMX(daqmx : LongInt; iRangePWM : LongInt; startChNo : LongInt; endChNo : LongInt; spanMin : LongInt; spanMax : LongInt) : LongInt; stdcall;
    function setOutputTypeMX(daqmx : LongInt; iOutput : LongInt; startChNo : LongInt; endChNo : LongInt) : LongInt; stdcall;
    function setChoiceMX(daqmx : LongInt; startChNo : LongInt; endChNo : LongInt; idleChoice : LongInt; errorChoice : LongInt; presetValue : LongInt) : LongInt; stdcall;
    function setPulseTimeMX(daqmx : LongInt; pulseTime : LongInt; startChNo : LongInt; endChNo : LongInt) : LongInt; stdcall;
    function setAOTypeMX(daqmx : LongInt; aoNo : LongInt; iKind : LongInt; refChNo : LongInt) : LongInt; stdcall;
    function setPWMTypeMX(daqmx : LongInt; pwmNo : LongInt; iKind : LongInt; refChNo : LongInt) : LongInt; stdcall;
    function getOutputMX(daqmx : LongInt; var pMXOutputData : MXOutputData) : LongInt; stdcall;
    function setOutputMX(daqmx : LongInt; var pMXOutputData : MXOutputData) : LongInt; stdcall;
    function changeAOPWMDataMX(var pMXAOPWMData : MXAOPWMData; aopwmNo : LongInt; bValid : LongInt; iAOPWMValue : LongInt) : LongInt; stdcall;
    function changeBalanceMX(var pMXBalanceData : MXBalanceData; balanceNo : LongInt; bValid : LongInt; iValue : LongInt) : LongInt; stdcall;
    function changeTransmitMX(var pMXTransmit : MXTransmit; pwmNo : LongInt; iTrans : LongInt) : LongInt; stdcall;
    function getMaxLenAlarmNameMX() : LongInt; stdcall;
    function toAOPWMValueMX(realValue : Double; iRangeAOPWM : LongInt) : LongInt; stdcall;
    function toRealValueMX(iAOPWMValue : LongInt; iRangeAOPWM : LongInt) : Double; stdcall;
    function getItemErrorMX(daqmx : LongInt; var itemErr : LongInt) : LongInt; stdcall;
    function isDataNoVBMX(var dataNo : MXDataNo) : LongInt;
    function toStyleVersionMX(style : LongInt) : LongInt;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // since R3.01
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setCOMMX(daqmx : LongInt; iRangeCOM : LongInt; startChNo : LongInt; endChNo : LongInt; spanMin : LongInt; spanMax : LongInt; scaleMin : LongInt; scaleMax : LongInt; scalePoint : LongInt) : LongInt; stdcall;
    function setPULSEMX(daqmx : LongInt; iRangePULSE : LongInt; startChNo : LongInt; endChNo : LongInt; spanMin : LongInt; spanMax : LongInt; scaleMin : LongInt; scaleMax : LongInt; scalePoint : LongInt) : LongInt; stdcall;
    function setChatFilterMX(daqmx : LongInt; bChatFilter : LongInt; startChNo : LongInt; endChNo : LongInt) : LongInt; stdcall;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --


implementation

const DAQ_MX = 'DAQMX.dll';


    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Low level communications
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function openMX ; external DAQ_MX;
    function closeMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Middle level communications
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // FIFO control commands
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function startFIFOMX ; external DAQ_MX;
    function stopFIFOMX ; external DAQ_MX;
    function autoFIFOMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Date time commands
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setDateTimeMX ; external DAQ_MX;
    function setDateTimeNowMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Control Commands
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setBackupMX ; external DAQ_MX;
    function formatCFMX ; external DAQ_MX;
    function initSystemMX ; external DAQ_MX;
    function setSegmentMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Get status
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function getStatusDataMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Get system
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function getSystemConfigMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Configurature -> @see for Visual Basic
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // DO
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function getDODataMX ; external DAQ_MX;
    function setDODataMX ; external DAQ_MX;
    function changeDODataMX ; external DAQ_MX;
    function setDOTypeMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Get channel information
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function talkChInfoMX ; external DAQ_MX;
    function getChInfoMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Talker measured data by each channels
    // talkChDataMX -> talkChDataVBMX @see for Visual Basic
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function getChDataNoMX ; external DAQ_MX;
    function talkChDataInstMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Talker measured data by each FIFO
    // talkFIFODataMX -> talkFIFODataVBMX @see for Visual Basic
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function getFIFODataNoMX ; external DAQ_MX;
    function talkFIFODataInstMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Get measured data after talker
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function getTimeDataMX ; external DAQ_MX;
    function getChDataMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Misc
    // setUserTimeMX ->setUserTimeVBMX @see for Visual Basic
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function getLastErrorMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Set range
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setSKIPMX ; external DAQ_MX;
    function setVOLTMX ; external DAQ_MX;
    function setTCMX ; external DAQ_MX;
    function setRTDMX ; external DAQ_MX;
    function setDIMX ; external DAQ_MX;
    function setDELTAMX ; external DAQ_MX;
    function setRRJCMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Scalling
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setScallingUnitMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Alarm
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setAlarmMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Channel configure
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setTagMX ; external DAQ_MX;
    function setCommentMX ; external DAQ_MX;
    function setRJCTypeMX ; external DAQ_MX;
    function setFilterMX ; external DAQ_MX;
    function setBurnoutMX ; external DAQ_MX;
    function setRefAlarmMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Unit configure
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setIntervalMX ;      external DAQ_MX;
    function setTempUnitMX ;      external DAQ_MX;
    function setUnitNoMX ;        external DAQ_MX;
    function setSystemTimeoutMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Utilities
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function toDoubleValueMX ; external DAQ_MX;
    function toStringValueMX ; external DAQ_MX;
    function toAlarmNameMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Messages
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function getVersionAPIMX ;         external DAQ_MX;
    function getRevisionAPIMX  ;       external DAQ_MX;
    function toErrorMessageMX ;        external DAQ_MX;
    function getMaxLenErrorMessageMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // Deprecated command
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setTimeOutMX ; external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // for Visual Basic
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function talkConfigMX ;       external DAQ_MX;
    function getChConfigMX ;      external DAQ_MX;
    function setSystemConfigMX ;  external DAQ_MX;
    function setChConfigMX ;      external DAQ_MX;
    function talkChDataVBMX ;     external DAQ_MX;
    function talkFIFODataVBMX ;   external DAQ_MX;
    function setUserTimeVBMX ;    external DAQ_MX;
    procedure incrementDataNoMX ; external DAQ_MX;
    procedure decrementDataNoMX ; external DAQ_MX;
    function compareDataNoMX ;    external DAQ_MX;
    procedure toDateTimeMX ;      external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // since R2.01
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setAOPWMDataMX ;       external DAQ_MX;
    function setTransmitMX ;        external DAQ_MX;
    function runBalanceMX ;         external DAQ_MX;
    function resetBalanceMX ;       external DAQ_MX;
    function setBalanceMX ;         external DAQ_MX;
    function getBalanceMX ;         external DAQ_MX;
    function getAOPWMDataMX ;       external DAQ_MX;
    function setRESMX ;             external DAQ_MX;
    function setSTRAINMX ;          external DAQ_MX;
    function setAOMX ;              external DAQ_MX;
    function setPWMMX ;             external DAQ_MX;
    function setOutputTypeMX ;      external DAQ_MX;
    function setChoiceMX ;          external DAQ_MX;
    function setPulseTimeMX ;       external DAQ_MX;
    function setAOTypeMX ;          external DAQ_MX;
    function setPWMTypeMX ;         external DAQ_MX;
    function getOutputMX ;          external DAQ_MX;
    function setOutputMX ;          external DAQ_MX;
    function changeAOPWMDataMX ;    external DAQ_MX;
    function changeBalanceMX ;      external DAQ_MX;
    function changeTransmitMX ;     external DAQ_MX;
    function getMaxLenAlarmNameMX ; external DAQ_MX;
    function toAOPWMValueMX ;       external DAQ_MX;
    function toRealValueMX ;        external DAQ_MX;
    function getItemErrorMX ;       external DAQ_MX;
    function isDataNoVBMX ;         external DAQ_MX;
    function toStyleVersionMX ;     external DAQ_MX;

    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
    // since R3.01
    // -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

    function setCOMMX ;        external DAQ_MX;
    function setPULSEMX ;      external DAQ_MX;
    function setChatFilterMX ; external DAQ_MX;


end.
