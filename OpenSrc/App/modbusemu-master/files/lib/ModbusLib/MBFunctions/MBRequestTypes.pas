unit MBRequestTypes;

{$mode objfpc}{$H+}

interface

type
  PMBDeviceInfo = ^TMBDeviceInfo;   // 2 байта
  TMBDeviceInfo = packed record
   DeviceAddress : Byte;
   FunctionCode  : Byte;
  end;

  PMBTCPHeaderFull = ^TMBTCPHeaderFull;   // 7 байт
  TMBTCPHeaderFull = packed record
   TransactioID : Word;
   ProtocolID   : Word;
   Length       : Word;
   DeviceID     : Byte;
  end;

  PMBTCPHeaderFullFName = ^TMBTCPHeaderFullFName;
  TMBTCPHeaderFullFName = packed record
   TCPHeaderFull : TMBTCPHeaderFull;
   FunctionNum   : Byte;
  end;

  PMBTCPAnswerHeader = ^TMBTCPAnswerHeader;
  TMBTCPAnswerHeader = packed record
   HeaderFullFName : TMBTCPHeaderFullFName;
   ByteCount       : Byte;
  end;

  PMBTCPHeader = ^TMBTCPHeader;  // 6 байт
  TMBTCPHeader = packed record
   TransactioID : Word;
   ProtocolID   : Word;
   Length       : Word;
  end;

  PMBF1_6FRequestData = ^TMBF1_6FRequestData; // 4 байта
  TMBF1_6FRequestData = packed record
   StartingAddress : Word;
   Quantity        : Word;
  end;

  PMBF1_6FRequestHeader = ^TMBF1_6FRequestHeader; // 6 байт
  TMBF1_6FRequestHeader = packed record
   DeviceAddress   : Byte;
   FunctionCode    : Byte;
   StartingAddress : Word;
   Quantity        : Word;
  end;

  PMBF1_6FRequestHeaderNew = ^TMBF1_6FRequestHeaderNew; // 6 байт
  TMBF1_6FRequestHeaderNew = packed record
   DeviceInfo  : TMBDeviceInfo;
   RequestData : TMBF1_6FRequestData;
  end;

  PMBF1Request = ^TMBF1Request; // 8 байт
  TMBF1Request = packed record
   Header : TMBF1_6FRequestHeader;
   CRC    : Word;
  end;

  PMBF1RequestNew = ^TMBF1RequestNew; // 8 байт
  TMBF1RequestNew = packed record
   Header : TMBF1_6FRequestHeaderNew;
   CRC    : Word;
  end;

  PMBTCPF1Request = ^TMBTCPF1Request;  // 12 байт
  TMBTCPF1Request = packed record
   TCPHeader : TMBTCPHeader;
   Header    : TMBF1_6FRequestHeader;
  end;

  PMBTCPF1RequestNew = ^TMBTCPF1RequestNew;  // 12 байт
  TMBTCPF1RequestNew = packed record
   TCPHeader : TMBTCPHeader;
   Header    : TMBF1_6FRequestHeaderNew;
  end;

  PMBF7RequestHeader = ^TMBF7RequestHeader;  // 2 байта
  TMBF7RequestHeader = packed record
   DeviceAddress : Byte;
   FunctionCode  : Byte;
  end;

  PMBF7Request = ^TMBF7Request;  // 4 байта
  TMBF7Request = packed record
   Header : TMBF7RequestHeader;
   CRC    : Word;
  end;

  PMBTCPF7Request = ^TMBTCPF7Request; // 8 байт
  TMBTCPF7Request = packed record
   TCPHeader : TMBTCPHeader;
   Header    : TMBF7RequestHeader;
  end;

  PMBF8RequestData = ^TMBF8RequestData;  // 6 байт
  TMBF8RequestData = packed record
   SubFunctionCode : Word;
   Data            : Word;
  end;

  PMBF8RequestHeader = ^TMBF8RequestHeader;  // 6 байт
  TMBF8RequestHeader = packed record
   DeviceAddress   : Byte;
   FunctionCode    : Byte;
   SubFunctionCode : Word;
   Data            : Word;
  end;

  PMBF8Request = ^TMBF8Request;    // 8 байт
  TMBF8Request = packed record
   Header : TMBF8RequestHeader;
   CRC    : Word;
  end;

  PMBTCPF8Request = ^TMBTCPF8Request;  // 12 байт
  TMBTCPF8Request = packed record
   TCPHeader : TMBTCPHeader;
   Header    : TMBF8RequestHeader;
  end;

  TMBF8SubfunctionType = (Sub_00,Sub_01,Sub_02,Sub_03,Sub_04,
                          Sub_0A = $0A, Sub_0B = $0B, Sub_0C = $0C, Sub_0D = $0D,
                          Sub_0E = $0E, Sub_0F = $0F, Sub_10 = $10, Sub_11 = $11,
                          Sub_12 = $12, Sub_14 = $14);

  PMBF15Request = ^TMBF15Request;
  TMBF15Request = packed record        // 7 байта
   Header    : TMBF1_6FRequestHeader;
   ByteCount : Byte;
  end;

  TMBF15ReguestPacketData = packed record
   StartingAddress : Word;
   Quantity        : Word;
   ByteCount       : Byte;
  end;
  PMBF15ReguestPacketData = ^TMBF15ReguestPacketData;

  PMBTCPF15Request = ^TMBTCPF15Request;   // 13 байт
  TMBTCPF15Request = packed record
   TCPHeader : TMBTCPHeader;
   Header    : TMBF15Request;
  end;

  PWordValueArray = ^TWordValueArray;
  TWordValueArray = array [0..122] of Word;

  PMBF16Request = ^TMBF16Request;       // 7 байт
  TMBF16Request = TMBF15Request;

  PMBTCPF16Request = ^TMBTCPF16Request;  // 13 байт
  TMBTCPF16Request = TMBTCPF15Request;

  PMBF22RequestData = ^TMBF22RequestData; // 6 байт
  TMBF22RequestData = packed record
   ReferenceAddress : Word;
   AndMask          : Word;
   OrMask           : Word;
  end;

  PMBF22RequestHeader = ^TMBF22RequestHeader; // 8 байт
  TMBF22RequestHeader = packed record
   DeviceAddress    : Byte;
   FunctionCode     : Byte;
   ReferenceAddress : Word;
   AndMask          : Word;
   OrMask           : Word;
  end;

  PMBF22Request = ^TMBF22Request;  // 10 байт
  TMBF22Request = packed record
   Header : TMBF22RequestHeader;
   CRC    : Word;
  end;

  PMBTCPF22Request = ^TMBTCPF22Request;  // 14 байт
  TMBTCPF22Request = packed record
   TCPHeader : TMBTCPHeader;
   Header    : TMBF22RequestHeader;
  end;

  PMBF23RequestData = ^TMBF23RequestData;  // 9 байт
  TMBF23RequestData = packed record
   ReadStartAddress  : Word;
   ReadQuantity      : Word;
   WriteStartAddress : Word;
   WriteQuantity     : Word;
   WriteByteCount    : Byte;
  end;

  PMBF23RequestHeader = ^TMBF23RequestHeader;  // 11 байт
  TMBF23RequestHeader = packed record
   DeviceAddress     : Byte;
   FunctionCode      : Byte;
   RequestData       : TMBF23RequestData;
  end;

  PMBTCPF23RequestHeader = ^TMBTCPF23RequestHeader;
  TMBTCPF23RequestHeader = packed record
    TCPHeader : TMBTCPHeader;
    Header    : TMBF23RequestHeader;
  end;

  PMBF24RequestData = ^TMBF24RequestData; // 2 байта
  TMBF24RequestData = packed record
   FIFOPointerAddress  : Word;
  end;

  PMBF24RequestHeader = ^TMBF24RequestHeader; // 4 байта
  TMBF24RequestHeader = packed record
   DeviceAddress       : Byte;
   FunctionCode        : Byte;
   FIFOPointerAddress  : Word;
  end;

  PMBF24Request = ^TMBF24Request; // 6 байт
  TMBF24Request = packed record
   Header : TMBF24RequestHeader;
   CRC    : Word;
  end;

  PMBTCPF24Request = ^TMBTCPF24Request;  // 10 байт
  TMBTCPF24Request = packed record
   TCPHeader : TMBTCPHeader;
   Header    : TMBF24RequestHeader;
  end;

  TMEIType = (mei13 = $0D, mei14 = $0E);
  TReadDeviceIDCode = (rdic_01 = 1,rdic_02 = 2,rdic_03 = 3,rdic_04 = 4);
  TObjectID = (oiVendorName,oiProductCode,oiMajorMinorRevision,oiVendorURL,oiProductName,
               oiModelName,oiUserApplicationName);

  PMBF43_14RequestData = ^TMBF43_14RequestData; // 5 байт
  TMBF43_14RequestData = packed record
   MEIType             : Byte;
   ReadDeviceIDCode    : Byte;
   ObjectID            : Byte;
  end;

  PMBF43_14RequestHeader = ^TMBF43_14RequestHeader; // 5 байт
  TMBF43_14RequestHeader = packed record
   DeviceAddress       : Byte;
   FunctionCode        : Byte;
   RequestData         : TMBF43_14RequestData;
  end;

  PMBF43_14Request = ^TMBF43_14Request;  // 7 байт
  TMBF43_14Request = packed record
   Header : TMBF43_14RequestHeader;
   CRC    : Word;
  end;

  PMBTCPF43_14Request = ^TMBTCPF43_14Request; // 11 байт
  TMBTCPF43_14Request = packed record
   TCPHeader : TMBTCPHeader;
   Header    : TMBF43_14RequestHeader;
  end;

  PMBF72RequestHeader = ^TMBF72RequestHeader;
  TMBF72RequestHeader = packed record
   DeviceAddress   : Byte;
   FunctionCode    : Byte;
   StartingAddress : Word;
   ChkRKey         : Byte;
   Quantity        : Byte;
  end;

  PMBF72Request = ^TMBF72Request;
  TMBF72Request = packed record
   Header : TMBF72RequestHeader;
   CRC    : Word;
  end;

  PMBTCPF72Request = ^TMBTCPF72Request;
  TMBTCPF72Request = packed record
   TCPHeader : TMBTCPHeader;
   Header    : TMBF72RequestHeader;
  end;

  PSafeWordValueArray = ^TSafeWordValueArray;
  TSafeWordValueArray = array [0..7] of Word;

  PMBF110RequestHeader = ^TMBF110RequestHeader;
  TMBF110RequestHeader = packed record
   DeviceAddress   : Byte;
   FunctionCode    : Byte;
   ChkWKey         : Byte;
  end;

  PMBTCPF110RequestHeader = ^TMBTCPF110RequestHeader;
  TMBTCPF110RequestHeader = packed record
   TCPHeader : TMBTCPHeader;
   Header    : TMBF110RequestHeader;
  end;

implementation

end.
