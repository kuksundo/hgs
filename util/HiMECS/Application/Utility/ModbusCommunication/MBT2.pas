unit MBT2;

interface

uses
  Windows;
  
//'-----------------------------------------------------------------------------
//'                                                                            |
//'                              WAGO Kontakttechnik GmbH                      |
//'                              Hansastr. 27                                  |
//'                              32423 Minden  Germany                         |
//'                                                                            |
//'                      Copyright (C) WAGO 2001                               |
//'                           All Rights Reserved                              |
//'                                                                            |
//'-----------------------------------------------------------------------------
//'-----------------------------------------------------------------------------
//'                  OPC TOOLBOX Project - WAGO MODBUS/TCP                     |
//'                                                                            |
//'  Filename    : MBT.pas                                                     |
//'  Version     : 1.00.release                                                |
//'  Date        : 15-10-2005                                             |    |
//'                                                                            |
//'  Description : Interface of MODBUS/TCP DLL                                 |
//'                                                                            |
//'  Name        : Kwon Oh Sung (e-mail: ohsungk@korea.com)                    |
//'                                                                            |
//'-----------------------------------------------------------------------------

Const dllPath = 'MBT.dll'; 
Const MODBUSTCP_TABLE_OUTPUT_REGISTER = 4;
Const MODBUSTCP_TABLE_INPUT_REGISTER = 3;
Const MODBUSTCP_TABLE_OUTPUT_COIL = 0;
Const MODBUSTCP_TABLE_INPUT_COIL = 1;
Const MODBUSTCP_TABLE_EXCEPTION_STATUS = 7;

var
MBTInit : Function : LONGINT; stdcall;
MBTExit : Function : LONGINT; stdcall;
MBTConnect : Function (
                szHostAddress: String;
                port: Integer;
                useTCPorUDP: Boolean;
                requestTimeout: LONGINT;
                hSocket: PHandle): LONGINT; stdcall;
MBTDisconnect : Function (hSocket: THandle): LONGINT; stdcall;
MBTReadRegisters : Function (
                hSocket: THandle;
                tableType: Byte;
                dataStartAddress: Integer;
                numWords: Integer;
                pReadBuffer: PByte;
                fpReadCompletedCallback: LONGINT;
                callbackContext: LONGINT): LONGINT; stdcall;
MBTReadCoils : Function (
                hSocket: THandle;
                tableType: Byte;
                dataStartAddress: Integer;
                numBits: Integer;
                pReadBuffer: PByte;
                fpReadCompletedCallback: LONGINT;
                callbackContext: LONGINT): LONGINT; stdcall;
MBTReadExceptionStatus : Function (
                hSocket: THandle;
                pExceptionStatus: PByte;
                fpReadCompletedCallback: LONGINT;
                callbackContext: LONGINT): LONGINT; stdcall;
MBTWriteRegisters : Function (
                hSocket: THandle;
                dataStartAddress: Integer;
                numWords: Integer;
                pWriteBuffer: PByte;
                fpWriteCompletedCallback: LONGINT;
                callbackContext: LONGINT): LONGINT; stdcall;
MBTWriteCoils : Function (
                hSocket: THandle;
                dataStartAddress: Integer;
                numBits: Integer;
                pWriteBuffer: PByte;
                fpWriteCompletedCallback: LONGINT;
                callbackContext: LONGINT): LONGINT; stdcall;
MBTSwapWord : Function (wData: Integer): Integer; stdcall;
MBTSwapDWord : Function (dwData: LONGINT): LONGINT; stdcall;

implementation

end.
