unit MBEmuXMLConst;

{$mode objfpc}{$H+}

interface

const
  csNodeRoot     = 'ModbusEmu';
  csNodeChannels = 'Channels';
  csNodeChannel  = 'Channel';
  csNodeDevices  = 'Devices';
  csNodeDevice   = 'Device';
  csNodeDefVal   = 'DefValues';
  csNodeCoils    = 'CoilRegs';
  csNodeDiscr    = 'DiscretRegs';
  csNodeHold     = 'HoldingRegs';
  csNodeInp      = 'InputRegs';
  csNodeReg      = 'Register';

  csAttrType     = 'Type';
  csAttrName     = 'Name';
  csAttrDescr    = 'Descr';
  csAttrAddres   = 'Adress';
  csAttrPort     = 'Port';
  csAttrPref     = 'Prefix';
  csAttrPrefOther= 'PrefOther';
  csAttrBauRate  = 'BaudRate';
  csAttrByteSize = 'ByteSize';
  csAttrParity   = 'Parity';
  csAttrStopBit  = 'StopBit';
  csAttrDefCoil  = 'DefCoil';
  csAttrDefDiscr = 'DefDiscret';
  csAttrDefHold  = 'DefHolding';
  csAttrDefInput = 'DefInput';
  csAttrFunction = 'Functions';
  csAttrValue    = 'Value';
  csAttrDescript = 'Description';
  csAttrIntervalTimeout = 'IntervalTimeout';
  csAttrTotalTimeoutMultiplier = 'TotalTimeoutMultiplier';
  csAttrTotalTimeoutConstant = 'TotalTimeoutConstant';

  csTypeRS       = 'RS';
  csTypeTCP      = 'TCP';

implementation

end.

