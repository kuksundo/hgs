unit MBResponseTypes;

{$mode objfpc}{$H+}

interface

uses MBRequestTypes;

type
  PMBErrorData = ^TMBErrorData;
  TMBErrorData = packed record
   FunctionCode  : Byte;
   ErrorCode     : Byte;
  end;

  PMBErrorHeder = ^TMBErrorHeder;
  TMBErrorHeder = packed record
   DeviceAddress : Byte;
   ErrorData     : TMBErrorData;
  end;

  PMBErrorResponse = ^TMBErrorResponse;
  TMBErrorResponse = packed record
   Heder : TMBErrorHeder;
   CRC   : Word;
  end;

  PMBResponseHeader = ^TMBResponseHeader;
  TMBResponseHeader = packed record
   DeviceAddress : Byte;
   FunctionCode  : Byte;
   ByteCount     : Byte;
  end;

  PWordRegVlueArray = ^TWordRegVlueArray;
  TWordRegVlueArray = array [0..124] of Word;

  PWordRegF3Response = ^TWordRegF3Response;
  TWordRegF3Response = packed record
   ByteCount : Byte;
   RegValues : TWordRegVlueArray;
  end;

  PMBTCPErrorHeder = ^TMBTCPErrorHeder;
  TMBTCPErrorHeder = packed record
   TransactioID : Word;
   ProtocolID   : Word;
   Length       : Word;
   DeviceID     : Byte;
   ErrorData    : TMBErrorData;
  end;

 PEventArray = ^TEventArray;
 TEventArray = packed array [0..63] of Byte;

 PDataArray = ^TDataArray;
 TDataArray = packed array [0..251] of Byte;

 TConformityLevel = (cl01 = 1, cl02 = 2, cl03 = 3,
                     cl81 = $81, cl82 = $82, cl83 = $83);

 PObjectData = ^TObjectData;
 TObjectData = packed record
  ObjectID    : TObjectID;
  ObjectLen   : Byte;
  ObjectValue : array [0..244] of Byte;
 end;

 PObjectList = ^TObjectList;
 TObjectList = array of TObjectData;

 PMBF72ResponceHeader = ^TMBF72ResponceHeader;
 TMBF72ResponceHeader = packed record
   DeviceNum   : Byte;
   FunctionNum : Byte;
   ChkRKey     : Byte;
   StartReg    : Word;
   Quantity    : Byte;
 end;

 PMBF110ResponceHeader = ^TMBF110ResponceHeader;
 TMBF110ResponceHeader = packed record
   DeviceNum   : Byte;
   FunctionNum : Byte;
   ChkWKey     : Byte;
   StartReg    : Word;
   Quantity    : Byte;
 end;

implementation

end.
