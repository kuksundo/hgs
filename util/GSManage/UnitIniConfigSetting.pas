unit UnitIniConfigSetting;

interface

uses IniPersist, UnitConfigIniClass2;

type
  TConfigSettings = class (TINIConfigBase)
  private
//    FMQServerEnable,
    FMQServerIP,
    FMQServerPort,
    FMQServerUserId,
    FMQServerPasswd,
    FMQServerTopic,
    FParamFileName,

    FSalesDirectorEmailAddr,
    FMaterialInputEmailAddr,
    FForeignInputEmailAddr,
    FElecHullRegEmailAddr,
    FShippingReqEmailAddr,
    FFieldServiceReqEmailAddr,
    FSubConPaymentEmailAddr,
    FMyNameSig,
    FShippingPICSig,
    FSalesPICSig,
    FFieldServicePICSig,
    FElecHullRegPICSig,
    FSubConPaymentPICSig
    : string;
  public
    //Section Name, Key Name, Default Key Value  (Control.hint = SectionName;KeyName 으로 저장 함)
//    [IniValue('MQ Server','MQ Server Enable', 'False')]
//    property MQServerEnable : string read FMQServerEnable write FMQServerEnable;
    [IniValue('MQ Server','MQ Server IP','10.14.21.117',1)]
    property MQServerIP : string read FMQServerIP write FMQServerIP;
    [IniValue('MQ Server','MQ Server Port','61613',2)]
    property MQServerPort : string read FMQServerPort write FMQServerPort;
    [IniValue('MQ Server','MQ Server UserId','pjh',3)]
    property MQServerUserId : string read FMQServerUserId write FMQServerUserId;
    [IniValue('MQ Server','MQ Server Passwd','pjh',4)]
    property MQServerPasswd : string read FMQServerPasswd write FMQServerPasswd;
    [IniValue('MQ Server','MQ Server Topic','',5)]
    property MQServerTopic : string read FMQServerTopic write FMQServerTopic;
    [IniValue('File','Param File Name','',6)]
    property ParamFileName : string read FParamFileName write FParamFileName;

    [IniValue('EMail','매출처리담당자','seonyunshin@hyundai-gs.com',7)]
    property SalesDirectorEmailAddr : string read FSalesDirectorEmailAddr write FSalesDirectorEmailAddr;
    [IniValue('EMail','자재직투입담당자','geunhyuk.lim@pantos.com',8)]
    property MaterialInputEmailAddr : string read FMaterialInputEmailAddr write FMaterialInputEmailAddr;
    [IniValue('EMail','업체등록담당자','seryeongkim@hyundai-gs.com',9)]
    property ForeignInputEmailAddr : string read FForeignInputEmailAddr write FForeignInputEmailAddr;
    [IniValue('EMail','표준공사등록담당자','seryeongkim@hyundai-gs.com',10)]
    property ElecHullRegEmailAddr : string read FElecHullRegEmailAddr write FElecHullRegEmailAddr;
    [IniValue('EMail','출하요청담당자','yungem.kim@pantos.com',11)]
    property ShippingReqEmailAddr : string read FShippingReqEmailAddr write FShippingReqEmailAddr;
    [IniValue('EMail','필드서비스담당자','yongjunelee@hyundai-gs.com',12)]
    property FieldServiceReqEmailAddr : string read FFieldServiceReqEmailAddr write FFieldServiceReqEmailAddr;
    [IniValue('Signature','내이름서명','부품서비스2팀 박정현 차장',13)]
    property MyNameSig : string read FMyNameSig write FMyNameSig;
    [IniValue('Signature','출하담당자서명','판토스 김윤겸 주임님',14)]
    property ShippingPICSig : string read FShippingPICSig write FShippingPICSig;
    [IniValue('Signature','매출담당자서명','부품서비스2팀 신선윤씨',15)]
    property SalesPICSig : string read FSalesPICSig write FSalesPICSig;
    [IniValue('Signature','필드서비스담당자서명','필드서비스팀 이용준 부장님',16)]
    property FieldServicePICSig : string read FFieldServicePICSig write FFieldServicePICSig;
    [IniValue('Signature','표준공사등록담당자서명','ICT팀 김세령 과장님',17)]
    property ElecHullRegPICSig : string read FElecHullRegPICSig write FElecHullRegPICSig;
    [IniValue('EMail','기성처리담당자','mjsong@hyundai-gs.com',18)]
    property SubConPaymentEmailAddr : string read FSubConPaymentEmailAddr write FSubConPaymentEmailAddr;
    [IniValue('Signature','기성처리담당자서명','필드서비스팀 송민주 사원님',19)]
    property SubConPaymentPICSig : string read FSubConPaymentPICSig write FSubConPaymentPICSig;
  end;

implementation

end.
