unit XMLConsts;

{$mode objfpc}{$H+}

interface

const

  csXMLEncoding                   = 'encoding';
  csXMLEncodingWin                = 'windows-1251';
  csXMLEncodingUTF8               = 'utf-8';

  csDefCodePageName               = 'windows-1251';
  csDefCodePage                   = 1251;

  csXMLYes                        = 'yes';
  csXMLNo                         = 'no';

  csXMLVersion                    = 'version';

  csXMLHeader                     = '<?xml version="1.0" encoding="Windows-1251" standalone="yes"?>';
  csXMLHeaderTemplate             = '<?xml version="%s" encoding="%s" standalone="%s"?>';

  csXMLPDON                       = 'PDON';
  csXMLHost                       = 'Host';
  csXMLAddress                    = 'Address';
  csXMLIDCS                       = 'IDCS';
  csXMLIDCSParam                  = 'IDCSParam';
  csXMLDDAC                       = 'DDAC';

  csXMLProtocolList               = 'ProtocolList';
  csXMLDeviceList                 = 'DeviceList';
  csXMLChannelList                = 'ChannelList';
  csXMLHostList                   = 'HostList';
  csXMLSrvProtocolList            = 'ServerProtocolList';
  csXMLRmtProtocolList            = 'RemoutProtocolList';
  csXMLSrvDeviceList              = 'ServerDeviceList';
  csXMLRmtDeviceList              = 'RemoteDeviceList';
  csXMLSrvChannelList             = 'ServerChannelList';
  csXMLRmtChannelList             = 'RemoteChannelList';

  csXMLModuleList                 = 'ModuleList';
  csXMLModule                     = 'Module';

  csXMLID                         = 'ID';
  csXMLOwnerID                    = 'OwnerID';
  csXMLName                       = 'Name';
  csXMLType                       = 'Type';
  csXMLActive                     = 'Active';
  csXMLDescription                = 'Description';
  csXMLLocation                   = 'Location';
  csXMLPort                       = 'Port';
  csXMLPortParam                  = 'PortParam';
  csXMLValue                      = 'Value';
  csXMLIP                         = 'IP';
  csXMLIPAddress                  = 'IPAddress';
  csXMLTCPPort                    = 'TCPPort';
  csXMLImplemented                = 'Implemented';

  csXMLRangeNameSrvProt           = 'ServerProtocolIDRange';
  csXMLMinIDSrvProt               = 1;
  csXMLMaxIDSrvProt               = 255;

  csXMLRangeNameRemProt           = 'RemoteProtocolIDRange';
  csXMLMinIDRemProt               = 256;
  csXMLMaxIDRemProt               = 511;

  csXMLRangeNameSrvChanTCP        = 'ServerChannelTCPIDRange';
  csXMLMinIDSrvChanTCP            = 512;
  csXMLMaxIDSrvChanTCP            = 66046;

  csXMLRangeNameRemChanTCP        = 'RemoteChannelTCPIDRange';
  csXMLMinIDRemChanTCP            = 66047;
  csXMLMaxIDRemChanTCP            = 131581;

  csXMLRangeNameSrvChanRTU        = 'ServerChannelRTUIDRange';
  csXMLMinIDSrvChanRTU            = 131582;
  csXMLMaxIDSrvChanRTU            = 131836;

  csXMLRangeNameRemChanRTU        = 'RemoteChannelRTUIDRange';
  csXMLMinIDRemChanRTU            = 131837;
  csXMLMaxIDRemChanRTU            = 132091;

  csXMLRangeNameSrvDev            = 'ServerDeviceIDRange';
  csXMLMinIDSrvDev                = 132092;
  csXMLMaxIDSrvDev                = 197626;

  csXMLRangeNameRemDev            = 'RemoteDeviceIDRange';
  csXMLMinIDRemDev                = 197627;
  csXMLMaxIDRemDev                = 263161;

  csXMLRangeNameModules           = 'ModulesIDRange';
  csXMLMinIDModules               = 263162;
  csXMLMaxIDModules               = 328696;

  csXMLRSModbusRTUName            = 'RSModbusRTU';
  csXMLRSModbusRTUID              = 263162;

  csXMLRangeNameHost              = 'HostIDRange';
  csXMLMaxIDHost                  = 394231;
  csXMLMinIDHost                  = 328697;

  csXMLProtocol                   = 'Protocol';
  csXMLServerProtocol             = 'ServerProtocol';
  csXMLServerProtocolID           = 'ServerProtocolID';
  csXMLRemoutProtocol             = 'RemoteProtocol';
  csXMLRemoutProtocolID           = 'RemoteProtocolID';
  csXMLProtocolInternal           = 'Internal';
  csXMLSrvProtocolBaseID          = 1;
  csXMLSrvProtocolModbusRTUID     = 2;
  csXMLSrvProtocolModbusTCPID     = 3;
  csXMLSrvProtocolEssoID          = 4;
  csXMLSrvProtocolBaseName        = 'Base';
  csXMLSrvProtocolModbusTCPName   = 'ModbusTCP';
  csXMLSrvProtocolModbusRTUName   = 'ModbusRTU';
  csXMLSrvProtocolEssoName        = 'Esso';

  csXMLTrasmitter                 = 'Transmitter';
  csXMLTrasmitterSNMP             = 'TransmitterSNMP';

  csXMLDevice                     = 'Device';
  csXMLDeviceID                   = 'DeviceID';
  csXMLDevID                      = 'DevID';
  csXMLObject                     = 'Object';
  csXMLObjectID                   = 'ObjectID';
  csXMLObjectList                 = 'ObjectList';
  csXMLServerDevice               = 'ServerDevice';
  csXMLServerDeviceID             = 'ServerDeviceID';
  csXMLRemoutDevice               = 'RemoteDevice';
  csXMLRemoutDeviceID             = 'RemoteDeviceID';

  csXMLDeviceTypeModbus           = 'Modbus';
  csXMLDeviceTypeModbusRTU        = 'RTU';
  csXMLDeviceTypeModbusTCP        = 'TCP';
  csXMLDeviceInterval             = 'Interval';
  csXMLDeviceTimeout              = 'Timeout';
  csXMLDeviceReconnect            = 'ReconnectInterval';

  csXMLESSOMSectionID             = 'SectionID';
  csXMLESSOSectionID              = 'SECTION_ID';

  // имена атрибутов тега Device - общие для всех устройств
  csXMLDevVirt                    = 'IsVirtual';
  // имена атрибутов тега Device - для Modbus устройств
  csXMLMBDeviceNum                = 'MBDeviceNum';
  csXMLMBDeviceType               = 'MBDeviceType';
  csXMLMBDefValues                = 'MBDefValues';
  csXMLMBDefDiscrete              = 'Discrete';
  csXMLMBDefCoil                  = 'Coil';
  csXMLMBDefInput                 = 'Input';
  csXMLMBDefHolding               = 'Holding';
  csXMLMBFunctions                = 'MBFunctions';
  csXMLMBFunction                 = 'Function';
  csXMLMBDiscreteRenges           = 'MBDiscreteRanges';
  csXMLMBCoilsRenges              = 'MBCoilsRanges';
  csXMLMBInputRenges              = 'MBInputRanges';
  csXMLMBHoldingRenges            = 'MBHoldingRanges';
  csXMLMBRange                    = 'MBRange';
  csXMLMBSectionID                = 'SectionID';
  csXMLMBStartAddress             = 'StartAddress';
  csXMLMBQuantity                 = 'Quantity';
  csXMLMBPolling                  = 'MBPolling';
  csXMLMBIntBetwReqs              = 'IntervalBetweenRequests';
  csXMLMBPerOfPolling             = 'PeriodicityOfPolling';
  csXMLMBRegDefValue              = 'MBRegisterDef';

  csXMLPortPollTimeout            = 'PollTimeout';
  csXMLPortItfPort                = 'ItfPortParam';
  csXMLPortItfPortType            = 'ItfPortType';

  csXMLPortItfPortCOMNum          = 'COMNumber';
  csXMLPortItfPortBaudRate        = 'BaudRate';
  csXMLPortItfPortByteSize        = 'ByteSize';
  csXMLPortItfPortParity          = 'Parity';
  csXMLPortItfPortStopBits        = 'StopBits';
  csXMLPortItfPortPackRuptureTime = 'PackRuptureTime';
  csXMLPortItfPortWriteTimeOut    = 'WriteTimeOut';
  csXMLPortItfPortResponseTimeOut = 'ResponseTimeOut';
  csXMLPortItfPortPortNumber      = 'PortNumber';
  csXMLPortItfPortPrefix          = 'Prefix';


  csXMLChannel                    = 'Channel';
  csXMLServerChannelList          = 'ServerChannelList';
  csXMLServerChannel              = 'ServerChannel';
  csXMLServerChannelID            = 'ServerChannelID';
  csXMLRemoutChannel              = 'RemoteChannel';
  csXMLRemoutChannelID            = 'RemoteChannelID';
  csXMLSrvParam                   = 'SrvParam';

  csXMLSrvThreadCache             = 'ThreadCache';
  csXMLSrvAllowAllCon             = 'AllowAllConnections';
  csXMLSrvIsMsgEndWork            = 'SendMsgEndWork';
  csXMLSrvMsgEndWork              = 'MsgEndWork';
  csXMLSrvService                 = 'ServerService';
  csXMLSrvMaxInBuffSize           = 'MaxInputBuffSize';
  csXMLSrvMaxOutBuffSize          = 'MaxOutBuffSize';

  csXMLAttr                       = '';
  csXMLNode                       = '';

  csXMLAttrIPAddress              = 'IPAddress';
  csXMLAttrAddress                = 'Address';
  csXMLAttrTCPport                = 'TCPport';
  csXMLAttrPort                   = 'Port';
  csXMLAttrApiPath                = 'ApiPath';
  csXMLAttrRetryInterval          = 'RetryInterval';
  csXMLAttrNoopInterval           = 'NoopInterval';
  csXMLAttrMaxRetryCount          = 'MaxRetryCount';
  csXMLAttrType                   = 'Type';
  csXMLAttrName                   = 'Name';
  csXMLAttrObjectID               = 'ObjectID';
  csXMLAttrObjectPlanID           = 'PlanID';
  csXMLAttrSrc                    = 'Src';
  csXMLAttrInterval               = 'Interval';
  csXMLAttrTimeout                = 'Timeout';
  csXMLAttrReconnectInterval      = 'ReconnectInterval';
  csXMLAttrESSOStationName        = 'STATION_NAME';
  csXMLAttrStationMode            = 'IsUseSnapShot';

  csXMLNodePDON                   = 'PDON';
  csXMLNodeDDAC                   = 'DDAC';
  csXMLNodeCollector              = 'Collector';
  csXMLNodeTransmitter            = 'Transmitter';
  csXMLNodeObjectList             = 'ObjectList';
  csXMLNodePlanList               = 'PlanList';
  csXMLNodePlan                   = 'Plan';
  csXMLNodeObject                 = 'Object';

  csXMLNodePanno                  = 'Panno';
  csXMLNodePollParam              = 'PollParam';
  csXMLNodeHostList               = 'HostList';
  csXMLNodeHost                   = 'Host';
  csXMLNodeESSORoot               = 'ESSO_LAYOUT';
  csXMLNodeESSOHeader             = 'LAYOUT_HEADER';
  csXMLNodeESSOSectList           = 'SECTIONS_LIST';
  csXMLNodeESSOSectItem           = 'SECTIONS_ITEM';

  csXMLNodeESSOMIDCSPrm           = 'IDCSParam';

  csXMLTagPDON                    = 'PDON';
  csXMLTagHostList                = 'HostList';
  csXMLTagHost                    = 'Host';
  csXMLTagDDAC                    = 'DDAC';

  csXMLTagTransmitterSNMP         = 'TransmitterSNMP';
  csXMLTagObjectList              = 'ObjectList';
  csXMLTagIDCSParam               = 'IDCSParam';
  csXMLTagUDP                     = 'UDP';
  csXMLTagAutorizedAddress        = 'AutorizedAddress';
  csXMLTagCommunityRead           = 'CommunityRead';
  csXMLTagCommunityReadWrite      = 'CommunityReadWrite';
  csXMLTagCommunityWrite          = 'CommunityWrite';
  csXMLTagMIB                     = 'MIB';
  csXMLTagSequence                = 'Sequence';
  csXMLTagObject                  = 'Object';
  csXMLTagTable                   = 'Table';
  csXMLTagTableEntry              = 'TableEntry';
  csXMLTagTableRows               = 'TableRows';
  csXMLTagTableRow                = 'TableRow';
  csXMLTagTraps                   = 'Traps';
  csXMLTagTrap                    = 'Trap';
  csXMLTagClientList              = 'ClientList';
  csXMLTagClient                  = 'Client';
  csXMLTagWhiteSpace              = 'WhiteSpace';

  csXMLAttrOID                    = 'OID';
  csXMLAttrDescription            = 'Description';
  csXMLAttrAccess                 = 'Access';
  csXMLAttrValue                  = 'Value';
  csXMLAttrMaxSize                = 'MaxSize';
  csXMLAttrMinValue               = 'MinValue';
  csXMLAttrMaxValue               = 'MaxValue';
  csXMLAttrModbus                 = 'Modbus';
  csXMLAttrDeviceID               = 'DeviceID';
  csXMLAttrSectionID              = 'SectionID';
  csXMLAttrIndexValue             = 'IndexValue';
  csXMLAttrIP                     = 'IP';
  csXMLMaxDataSize                = 'MaxDataSize';
  csXMLAttrBindIP                 = 'BindIP';
  csXMLAttrBuffSize               = 'BuffSize';
  csXMLAttrSelectTimeout          = 'SelectTimeout';
  csXMLAttrFilterClients          = 'FilterClients';
  csXMLAttrMask                   = 'Mask';
  csXMLAttrComunity               = 'Community';

  csXMLAttrEventType              = 'EventType';
  csXMLAttrEventOID               = 'EventOID';
  csXMLAttrErrorOID               = 'ErrorOID';

  csEventTypeValueErr             = 'Error';
  csEventTypeValueEvent           = 'Event';

implementation

end.

