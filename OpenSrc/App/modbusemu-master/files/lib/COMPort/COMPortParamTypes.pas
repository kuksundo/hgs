unit COMPortParamTypes;

interface

uses {$IFDEF WINDOWS}
     Windows,
     {$ENDIF}
     Classes, sysutils,
     COMPortResStr;

type
 INPCCommLedInterface = interface
  procedure LedOn;
  procedure LedOff;
 end;

 {$IFNDEF WINDOWS}
  TDCB = record
    DCBlength  : DWORD;
    BaudRate   : DWORD;
    Flags      : Longint;
    wReserved  : Word;
    XonLim     : Word;
    XoffLim    : Word;
    ByteSize   : Byte;
    Parity     : Byte;
    StopBits   : Byte;
    XonChar    : AnsiChar;
    XoffChar   : AnsiChar;
    ErrorChar  : AnsiChar;
    EofChar    : AnsiChar;
    EvtChar    : AnsiChar;
    wReserved1 : Word;
  end;
  PDCB = ^TDCB;
 {$ENDIF}

 TComErrorCategory = (ecWrite, // ошибки операций записи
                      ecRead,  // ошибки операций чтения
                      ecEvent, // ошибки операций отслеживания событий
                      ecLine,  // ошибки линии
                      ecApp,   // программные ошибки
                      ecSys    // ошибки выполнения системных функций
                      );

 TMsgType =( msgDebug   = -1, msgInfo    =  0, msgWarning =  1, msgError   =  2 );
 TEventlogMsgProc = procedure (Message: String; EventType: DWord = 1; Category: Integer = 0; ID: Integer = 0) of object;
 TCOMErrrorEventProc = procedure(Sender : TObject; ErrorCategory : TComErrorCategory; ErrorCode : Cardinal) of object;

 PEventlogMsgRecord = ^TEventlogMsgRecord;
 TEventlogMsgRecord = record
  Message   : PChar;
  EventType : DWord;
  Category  : Integer;
  ID        : Integer;
 end;

 {$IFDEF WINDOWS}
 TComPortBaudRate   = ( br75, br110, br150, br300, br600, br1200, br1800, br2400, br4800,
                      br9600, br14400, br19200, br28800, br38400, br57600, br115200, brNone);
 {$ELSE}
  TComPortBaudRate  = ( br0, br50, br75, br110, br134, br150, br200, br300, br600, br1200, br1800,
                        br2400, br4800, br9600, br19200, br38400, br57600, br115200, br230400, br460800,
                        br500000, br576000, br921600, br1000000, br1152000, br1500000, br2000000, br2500000,
                        br3000000, br3500000, br4000000, brNone);
 {$ENDIF}

 TComPortDataBits   = ( db5BITS, db6BITS, db7BITS, db8BITS, dbNone);
 TComPortStopBits   = ( sb1BITS, sb1HALFBITS, sb2BITS, sbNone );
 TComPortParity     = ( ptNONE, ptODD, ptEVEN, ptMARK, ptSPACE, ptError);
 TComPortPrefixPath = (pptLinux,pptWindows,pptOther);
 TComPortEvFlag     = (flRXCHAR, flRXFLAG, flTXEMPTY, flCTS, flDSR, flRLSD, flBREAK, flERR, flRING);
 TComPortEvFlags = set of TComPortEvFlag;
 TComPortModemLinesStatus = (mlCTS_ON, mlDSR_ON, mlRING_ON, mlRLSD_ON);
 TComPortModemLinesStatuses = set of TComPortModemLinesStatus;

 TComPortBaudRateNames   = array [TComPortBaudRate] of String;
 {$IFNDEF WINDOWS}
 TComPortBaudRateValue   = array [TComPortBaudRate] of Cardinal;
 {$ENDIF}
 TComPortParityNames     = array [TComPortParity] of String;
 TComPortDataBitsNames   = array [TComPortDataBits] of String;
 TComPortDataBitsValue   = array [TComPortDataBits] of Integer;
 TComPortStopBitsNames   = array [TComPortStopBits] of String;
 TComPortPrefixPathNames = array [TComPortPrefixPath] of String;
 TComPortPrefixPathValue = array [TComPortPrefixPath] of String;

const
  ErrPortPathOther    = 15000;
  ErrPortAlreadyOpen  = 15001;
  ErrPortNotOpen      = 15002;
  ErrPortBuff         = 15003;
  ErrPortBuffSmoll    = 15004;
  ErrPortAlreadyClose = 15005;

  CR           = #$0d;
  LF           = #$0a;
  CRLF         = CR + LF;
  cSerialChunk = 8192;
  F_RDLCK = 0;
  F_WRLCK = 1;
  F_UNLCK = 2;

  cCOMPrefixPathWindows = '\\.\COM';
  cCOMPrefixPathLinux   = '/dev/ttyS';
  cCOMPrefixPathLinuxOther   = 'other';

  //CMSPAR= $40000000; { mark or space (stick) parity }

  {$IFNDEF MSWINDOWS}
  INVALID_HANDLE_VALUE = THandle(-1);
  {$ENDIF}

  ComPortParityNames   : TComPortParityNames =('Нет', 'Нечетный', 'Четный', 'Маркер', 'Не маркер', 'Ошибка');
  ComPortParityEngNames: TComPortParityNames =('NONE', 'ODD', 'EVEN', 'MARK', 'SPACE', 'Error');
  {$IFDEF WINDOWS}
  ComPortBaudRateNames : TComPortBaudRateNames = ('75', '110', '150', '300', '600', '1200', '1800',
                                                  '2400', '4800','9600', '14400', '19200', '28800',
                                                  '38400', '57600', '115200', 'None');
  WinBaudRate : array [TComPortBaudRate] of DWORD = ( 75, 110, 150, 300, 600, 1200, 1800, 2400, 4800,  // COM Port Baud Rates
                                                   9600, 14400, 19200, 28800, 38400, 57600, 115200, 0 );
  {$ELSE}
   ComPortBaudRateNames : TComPortBaudRateNames = ('0','50','75','110','134','150','200','300','600',
                                                   '1200','1800','2400','4800','9600','19200','38400',
                                                   '57600','115200','230400','460800','500000','576000',
                                                   '921600','1000000','1152000','1500000','2000000',
                                                   '2500000','3000000','3500000','4000000', 'None');
   ComPortBaudRateValue : TComPortBaudRateValue = ( $0000000, $0000001, $0000002, $0000003, $0000004, $0000005,
                                                    $0000006, $0000007, $0000008, $0000009, $000000A, $000000B,
                                                    $000000C, $000000D, $000000E, $000000F, $0001001, $0001002,
                                                    $0001003, $0001004, $0001005, $0001006, $0001007, $0001008,
                                                    $0001009, $000100A, $000100B, $000100C, $000100D, $000100E,
                                                    $000100F, $FFFFFFF);
  {$ENDIF}
  ComPortDataBitsNames   : TComPortDataBitsNames   = ('5 ','6 ','7 ','8 ','0 ');
  ComPortDataBitsValue   : TComPortDataBitsValue   = (5,6,7,8,0);
  ComPortStopBitsNames   : TComPortStopBitsNames   = ('1 ','1,5 ','2 ','0 ');
  ComPortDataBitsSymbol  : TComPortDataBitsNames   = ('5','6','7','8','0');
  ComPortStopBitsSymbol  : TComPortStopBitsNames   = ('1','1,5','2','0');
  ComPortPrefixPathNames : TComPortPrefixPathNames = (cCOMPrefixPathLinux,cCOMPrefixPathWindows,rsOther);
  ComPortPrefixPathValue : TComPortPrefixPathValue = (cCOMPrefixPathLinux,cCOMPrefixPathWindows,'');

  dcbFlag_Binary              = $00000001;
  dcbFlag_ParityCheck         = $00000002;
  dcbFlag_OutxCtsFlow         = $00000004;
  dcbFlag_OutxDsrFlow         = $00000008;
  dcbFlag_DtrControlMask      = $00000030;
  dcbFlag_DtrControlDisable   = $00000000;
  dcbFlag_DtrControlEnable    = $00000010;
  dcbFlag_DtrControlHandshake = $00000020;
  dcbFlag_DsrSensitvity       = $00000040;
  dcbFlag_TXContinueOnXoff    = $00000080;
  dcbFlag_OutX                = $00000100;
  dcbFlag_InX                 = $00000200;
  dcbFlag_ErrorChar           = $00000400;
  dcbFlag_NullStrip           = $00000800;
  dcbFlag_RtsControlMask      = $00003000;
  dcbFlag_RtsControlDisable   = $00000000;
  dcbFlag_RtsControlEnable    = $00001000;
  dcbFlag_RtsControlHandshake = $00002000;
  dcbFlag_RtsControlToggle    = $00003000;
  dcbFlag_AbortOnError        = $00004000;
  dcbFlag_Reserveds           = $FFFF8000;


  cComDCBDefBaudRate   = br9600;
  cComDCBDefFlags      = dcbFlag_Binary+dcbFlag_ParityCheck;
  cComDCBDefwReserved  = 0;
  cComDCBDefXonLim     = 2048;
  cComDCBDefXoffLim    = 512;
  cComDCBDefByteSize   = db8BITS;
  cComDCBDefParity     = ptEVEN;
  cComDCBDefStopBits   = sb1BITS;
  cComDCBDefXonChar    = #17;
  cComDCBDefXoffChar   = #19;
  cComDCBDefErrorChar  = #0;
  cComDCBDefEofChar    = #0;
  cComDCBDefEvtChar    = #0;
  cComDCBDefwReserved1 = 0;
  cCOMPacketRuptureTime= 50;
  cCOMResponseTimeOut  = 150;
  cCOMSizeRecvBuffer   = 8096;
  cCOMDeadlockTimeout  = 10;

 {$IFDEF WINDOWS}
  CM_ON_READ_ENDED    =  WM_APP+100;
  CM_ON_ERROR         =  WM_APP+101;
  CM_ON_EVENT_MSG     =  WM_APP+102;
  CM_ON_WRITE_ENDED   =  WM_APP+103;
  CM_ON_RXCharEvent   =  WM_APP+104;
  CM_ON_TXEmptyEvent  =  WM_APP+105;
  CM_ON_CtsEvent      =  WM_APP+106;
  CM_ON_DSREvent      =  WM_APP+107;
  CM_ON_RLSDEvent     =  WM_APP+108;
  CM_ON_BreakEvent    =  WM_APP+109;
  CM_ON_ErrEvent      =  WM_APP+110;
  CM_ON_RingEvent     =  WM_APP+111;
  CM_ON_PErrEvent     =  WM_APP+112;
  CM_ON_RX80FullEvent =  WM_APP+113;
  CM_ON_Event1Event   =  WM_APP+114;
  CM_ON_Event2Event   =  WM_APP+115;
 {$ENDIF}

function GetBaudRateIDFromValue(Value : Longint): TComPortBaudRate;
function GetBaudRateIDFromNumValue(Value : Longint): TComPortBaudRate;
function GetBaudRateStrFromValue(Value : Longint): String;

function GetBaudRateStrFromID(Value : TComPortBaudRate): String;
function GetBaudRateIDFromStr(Value : String): TComPortBaudRate;

function GetLinuxBaudRateID(Value : Longint):LongInt;
function GetBaudRateValueFromID(Value : TComPortBaudRate): LongInt;

function GetDataBitsIDFromValue(Value : Longint): TComPortDataBits;
function GetDataBitsValueFromID(Value : TComPortDataBits): LongInt;
function GetDataBitsIDFromStr(Value : String): TComPortDataBits;

function GetStopBitsIDFromValue(Value : Longint): TComPortStopBits;
function GetStopBitsIDStrFromValue(Value : TComPortStopBits): String;
function GetStopBitsIDStrFromValue1(Value : TComPortStopBits): String;
function GetStopBitsIDFromStr(Value : String): TComPortStopBits;

function GetParityIDStrFromValue(Value : TComPortParity): String;
function GetParityIDFromString(Value : String): TComPortParity;

function GetCOMPortErrorMessage(AErrorCode : Integer): String;
function GetMaxWaitTimeFromBaudRate(ABaudRate : TComPortBaudRate): Cardinal;

function  GetPacketAsStringHex(Packet : array of Byte; aLen : Integer; Delimeter : String = ':') : String;
function  GetBuffAsStringHex(Buff : Pointer; aLen : Integer; Delimeter : String = ':') : String;
function  GetPacketFromStringHex(AString : string; var aPacket : array of Byte; aLen : Integer; Delimeter : String = ':'): Integer;

implementation

uses strutils;

function GetDataBitsIDFromStr(Value : String): TComPortDataBits;
begin
  Result := dbNone;
  if SameText(ComPortDataBitsSymbol[db5BITS], Value) then Result:=db5BITS;
  if SameText(ComPortDataBitsSymbol[db6BITS], Value) then Result:=db6BITS;
  if SameText(ComPortDataBitsSymbol[db7BITS], Value) then Result:=db7BITS;
  if SameText(ComPortDataBitsSymbol[db8BITS], Value) then Result:=db8BITS;
end;

function GetStopBitsIDFromStr(Value : String): TComPortStopBits;
begin
 Result := sbNone;
 if Value = '' then Exit;
 if SameText(Value,ComPortStopBitsSymbol[sb1BITS]) then Result := sb1BITS
  else if SameText(Value,ComPortStopBitsSymbol[sb1HALFBITS]) then Result := sb1HALFBITS
   else if SameText(Value,ComPortStopBitsSymbol[sb2BITS]) then Result := sb2BITS;
end;

function GetStopBitsIDStrFromValue1(Value : TComPortStopBits): String;
begin
 Result := ComPortStopBitsSymbol[Value];
end;

function GetBaudRateStrFromID(Value : TComPortBaudRate): String;
begin
  Result := ComPortBaudRateNames[Value];
end;

function GetBaudRateIDFromStr(Value : String): TComPortBaudRate;
begin
  Result := brNone;
  {$IFDEF UNIX}
  if SameText(ComPortBaudRateNames[br0], Value) then Result := br0;
  if SameText(ComPortBaudRateNames[br50], Value) then Result := br50;
  if SameText(ComPortBaudRateNames[br75], Value) then Result := br75;
  if SameText(ComPortBaudRateNames[br110], Value) then Result := br110;
  if SameText(ComPortBaudRateNames[br134], Value) then Result := br134;
  if SameText(ComPortBaudRateNames[br150], Value) then Result := br150;
  if SameText(ComPortBaudRateNames[br200], Value) then Result := br200;
  if SameText(ComPortBaudRateNames[br300], Value) then Result := br300;
  if SameText(ComPortBaudRateNames[br600], Value) then Result := br600;
  if SameText(ComPortBaudRateNames[br1200], Value) then Result := br1200;
  if SameText(ComPortBaudRateNames[br1800],Value) then Result := br1800;
  if SameText(ComPortBaudRateNames[br2400],Value) then Result := br2400;
  if SameText(ComPortBaudRateNames[br4800],Value) then Result := br4800;
  if SameText(ComPortBaudRateNames[br9600],Value) then Result := br9600;
  if SameText(ComPortBaudRateNames[br19200],Value) then Result := br19200;
  if SameText(ComPortBaudRateNames[br38400],Value) then Result := br38400;
  if SameText(ComPortBaudRateNames[br57600],Value) then Result := br57600;
  if SameText(ComPortBaudRateNames[br115200],Value) then Result := br115200;
  if SameText(ComPortBaudRateNames[br230400],Value) then Result := br230400;
  if SameText(ComPortBaudRateNames[br460800],Value) then Result := br460800;
  if SameText(ComPortBaudRateNames[br500000],Value) then Result := br500000;
  if SameText(ComPortBaudRateNames[br576000],Value) then Result := br576000;
  if SameText(ComPortBaudRateNames[br921600],Value) then Result := br921600;
  if SameText(ComPortBaudRateNames[br1000000],Value) then Result := br1000000;
  if SameText(ComPortBaudRateNames[br1152000],Value) then Result := br1152000;
  if SameText(ComPortBaudRateNames[br1500000],Value) then Result := br1500000;
  if SameText(ComPortBaudRateNames[br2000000],Value) then Result := br2000000;
  if SameText(ComPortBaudRateNames[br2500000],Value) then Result := br2500000;
  if SameText(ComPortBaudRateNames[br3000000],Value) then Result := br3000000;
  if SameText(ComPortBaudRateNames[br3500000],Value) then Result := br3500000;
  if SameText(ComPortBaudRateNames[br4000000],Value) then Result := br4000000;
  {$ELSE}
  if SameText(ComPortBaudRateNames[br75], Value) then Result := br75;
  if SameText(ComPortBaudRateNames[br110], Value) then Result := br110;
  if SameText(ComPortBaudRateNames[br150], Value) then Result := br150;
  if SameText(ComPortBaudRateNames[br300], Value) then Result := br300;
  if SameText(ComPortBaudRateNames[br600], Value) then Result := br600;
  if SameText(ComPortBaudRateNames[br1200], Value) then Result := br1200;
  if SameText(ComPortBaudRateNames[br1800], Value) then Result := br1800;
  if SameText(ComPortBaudRateNames[br2400], Value) then Result := br2400;
  if SameText(ComPortBaudRateNames[br4800], Value) then Result := br4800;
  if SameText(ComPortBaudRateNames[br9600], Value) then Result := br9600;
  if SameText(ComPortBaudRateNames[br14400],Value) then Result := br14400;
  if SameText(ComPortBaudRateNames[br19200],Value) then Result := br19200;
  if SameText(ComPortBaudRateNames[br28800],Value) then Result := br28800;
  if SameText(ComPortBaudRateNames[br38400],Value) then Result := br38400;
  if SameText(ComPortBaudRateNames[br57600],Value) then Result := br57600;
  if SameText(ComPortBaudRateNames[br115200],Value) then Result := br115200;
  {$ENDIF}
end;

function GetPacketAsStringHex(Packet: array of Byte; aLen: Integer; Delimeter : String = ':'): String;
var i : Integer;
begin
 Result := '';
 for i := 0 to aLen-1 do
  begin
   if Result = '' then Result := Result + IntToHex(Packet[i],2)
    else Result :=Format('%s%s%s',[Result,Delimeter,IntToHex(Packet[i],2)]);
  end;
end;

function GetBuffAsStringHex(Buff : Pointer; aLen : Integer; Delimeter : String) : String;
var i : Integer;
    TempByte : PByte;
begin
 Result := '';
 if not Assigned(Buff) then Exit;
 TempByte := Buff;

 Result := Format('%s:',[IntToHex(aLen,4)]);

 for i := 0 to aLen-1 do
  begin
   if Result = '' then Result := Result + IntToHex(TempByte^,2)
    else Result :=Format('%s%s%s',[Result,Delimeter,IntToHex(TempByte^,2)]);
   Inc(TempByte);
  end;
end;

function GetPacketFromStringHex(AString: string; var aPacket: array of Byte; aLen: Integer; Delimeter: String):Integer;
var TempString : String;
    TempList   : TStringList;
    i          : Integer;
begin
 TempString := StringsReplace(AString,[Delimeter],[','],[rfIgnoreCase,rfReplaceAll]);
 TempList := TStringList.Create;
 try
  TempList.CommaText := TempString;
  Result := TempList.Count;

  if Result > aLen then
   begin
    Result := -1;
    Exit;
   end;

  for i := 0 to Result-1 do
   begin
    if TempList.Strings[i] ='' then Continue;
    aPacket[i] := StrToInt('0x'+TempList.Strings[i]);
   end;
 finally
  FreeAndNil(TempList);
 end;
end;

function GetCOMPortErrorMessage(AErrorCode : Integer): String;
begin
 case AErrorCode of
  ErrPortPathOther   : Result := rsErrPortPathOther;
  ErrPortAlreadyOpen : Result := rsErrPortAlreadyOpen;
  ErrPortAlreadyClose: Result := rsErrPortAlreadyClose;
  ErrPortNotOpen     : Result := rsErrPortNotOpen;
  ErrPortBuff        : Result := rsErrPortBuff;
  ErrPortBuffSmoll   : Result := rsErrPortBuffSmoll;
 else
  Result := Format(rsErrPortUninspected,[AErrorCode,SysErrorMessage(AErrorCode)]);
 end;
end;

function GetMaxWaitTimeFromBaudRate(ABaudRate : TComPortBaudRate) : Cardinal;
begin
 case ABaudRate of
  {$IFDEF LINUX} br0       : Result := 100000;{$ENDIF}
  {$IFDEF LINUX} br50      : Result := 51000;{$ENDIF}
  br75      : Result := 34000;
  br110     : Result := 24000;
  {$IFDEF LINUX} br134     : Result := 20000;{$ENDIF}
  br150     : Result := 17500;
  {$IFDEF LINUX} br200     : Result := 13000;{$ENDIF}
  br300     : Result := 9000;
  br600     : Result := 4750;
  br1200    : Result := 2400;
  br1800    : Result := 1500;
  br2400    : Result := 1200;
  br4800    : Result := 700;
  br9600    : Result := 300;
  {$IFDEF WINDOWS} br14400 : Result := 200; {$ENDIF}
  br19200   : Result := 150;
  {$IFDEF WINDOWS} br28800 : Result := 100; {$ENDIF}
  br38400   : Result := 70;
  br57600   : Result := 50;
  br115200  : Result := 30;
  {$IFDEF LINUX} br230400  : Result := 15;
  br460800  : Result := 7;
  br500000  : Result := 6;
  br576000  : Result := 5;
  br921600  : Result := 3;
  br1000000 : Result := 3;
  br1152000 : Result := 3;
  br1500000 : Result := 2;
  br2000000 : Result := 2;
  br2500000 : Result := 2;
  br3000000 : Result := 2;
  br3500000 : Result := 2;
  br4000000 : Result := 2; {$ENDIF}
 else
  Result := 1000;
 end;
end;

function GetStopBitsIDStrFromValue(Value : TComPortStopBits): String;
begin
  Result := '';
  case Value of
   sb1BITS     : Result := '0';
   sb1HALFBITS : Result := '1';
   sb2BITS     : Result := '2';
  end;
end;

function GetParityIDStrFromValue(Value : TComPortParity): String;
begin
 Result := '';
 case Value of
  ptNONE  : Result := 'n';
  ptODD   : Result := 'o';
  ptEVEN  : Result := 'e';
  ptMARK  : Result := 'm';
  ptSPACE : Result := 's';
 end;
end;

function GetParityIDFromString(Value : String): TComPortParity;
begin
  if SameText(Value,'m') then Result := ptMARK
   else
    if SameText(Value,'n') then Result := ptNONE
     else
      if SameText(Value,'o') then Result := ptODD
       else
        if SameText(Value,'e') then Result := ptEVEN
         else
          if SameText(Value,'s') then Result := ptSPACE
           else
            Result := ptError;

end;

function GetStopBitsIDFromValue(Value : Longint): TComPortStopBits;
begin
  case Value of
    0 : Result:=sb1BITS;
    1 : Result:=sb1HALFBITS;
    2 : Result:=sb2BITS;
  else
   raise Exception.Create(rsStopBitError);
  end;
end;

function GetBaudRateIDFromNumValue(Value : Longint) : TComPortBaudRate;
begin
 {$IFDEF WINDOWS}
 case Value of
  75     : Result := br75;
  110    : Result := br110;
  150    : Result := br150;
  300    : Result := br300;
  600    : Result := br600;
  1200   : Result := br1200;
  1800   : Result := br1800;
  2400   : Result := br2400;
  4800   : Result := br4800;
  9600   : Result := br9600;
  14400  : Result := br14400;
  19200  : Result := br19200;
  28800  : Result := br28800;
  38400  : Result := br38400;
  57600  : Result := br57600;
  115200 : Result := br115200;
 else
  raise Exception.Create(rsSpeedError);
 end;
 {$ELSE}
 case Value of
  $0000000 : Result := br0;
  $0000001 : Result := br50;
  $0000002 : Result := br75;
  $0000003 : Result := br110;
  $0000004 : Result := br134;
  $0000005 : Result := br150;
  $0000006 : Result := br200;
  $0000007 : Result := br300;
  $0000008 : Result := br600;
  $0000009 : Result := br1200;
  $000000A : Result := br1800;
  $000000B : Result := br2400;
  $000000C : Result := br4800;
  $000000D : Result := br9600;
  $000000E : Result := br19200;
  $000000F : Result := br38400;
  $0001001 : Result := br57600;
  $0001002 : Result := br115200;
  $0001003 : Result := br230400;
  $0001004 : Result := br460800;
  $0001005 : Result := br500000;
  $0001006 : Result := br576000;
  $0001007 : Result := br921600;
  $0001008 : Result := br1000000;
  $0001009 : Result := br1152000;
  $000100A : Result := br1500000;
  $000100B : Result := br2000000;
  $000100C : Result := br2500000;
  $000100D : Result := br3000000;
  $000100E : Result := br3500000;
  $000100F : Result := br4000000;
 else
  raise Exception.Create(rsSpeedError);
 end;
 {$ENDIF}
end;

function GetBaudRateStrFromValue(Value : Longint) : String;
begin
  Result := '';
  case GetBaudRateIDFromValue(Value) of
  {$IFDEF UNIX}br0       : Result := '0';{$ENDIF}
  {$IFDEF UNIX}br50      : Result := '50';{$ENDIF}
  br75      : Result := '75';
  br110     : Result := '110';
  {$IFDEF UNIX}br134     : Result := '134';{$ENDIF}
  br150     : Result := '150';
  {$IFDEF UNIX}br200     : Result := '200';{$ENDIF}
  br300     : Result := '300';
  br600     : Result := '600';
  br1200    : Result := '1200';
  br1800    : Result := '1800';
  br2400    : Result := '2400';
  br4800    : Result := '4800';
  br9600    : Result := '9600';
  br19200   : Result := '19200';
  br38400   : Result := '38400';
  br57600   : Result := '57600';
  br115200  : Result := '115200';
  {$IFDEF UNIX}br230400  : Result := '230400';
  br460800  : Result := '460800';
  br500000  : Result := '500000';
  br576000  : Result := '576000';
  br921600  : Result := '921600';
  br1000000 : Result := '1000000';
  br1152000 : Result := '1152000';
  br1500000 : Result := '1500000';
  br2000000 : Result := '2000000';
  br2500000 : Result := '2500000';
  br3000000 : Result := '3000000';
  br3500000 : Result := '3500000';
  br4000000 : Result := '4000000';{$ENDIF}
  end;
end;

function GetLinuxBaudRateID(Value : Longint):LongInt;
begin
 case Value of
  0       : Result := $0000000;
  50      : Result := $0000001;
  75      : Result := $0000002;
  110     : Result := $0000003;
  134     : Result := $0000004;
  150     : Result := $0000005;
  200     : Result := $0000006;
  300     : Result := $0000007;
  600     : Result := $0000008;
  1200    : Result := $0000009;
  1800    : Result := $000000A;
  2400    : Result := $000000B;
  4800    : Result := $000000C;
  9600    : Result := $000000D;
  19200   : Result := $000000E;
  38400   : Result := $000000F;
  57600   : Result := $0001001;
  115200  : Result := $0001002;
  230400  : Result := $0001003;
  460800  : Result := $0001004;
  500000  : Result := $0001005;
  576000  : Result := $0001006;
  921600  : Result := $0001007;
  1000000 : Result := $0001008;
  1152000 : Result := $0001009;
  1500000 : Result := $000100A;
  2000000 : Result := $000100B;
  2500000 : Result := $000100C;
  3000000 : Result := $000100D;
  3500000 : Result := $000100E;
  4000000 : Result := $000100F;
 else
  raise Exception.Create(rsSpeedError);
 end;
end;

function GetBaudRateIDFromValue(Value : Longint): TComPortBaudRate;
begin
 {$IFDEF WINDOWS}
 case Value of
  75     : Result := br75;
  110    : Result := br110;
  150    : Result := br150;
  300    : Result := br300;
  600    : Result := br600;
  1200   : Result := br1200;
  1800   : Result := br1800;
  2400   : Result := br2400;
  4800   : Result := br4800;
  9600   : Result := br9600;
  14400  : Result := br14400;
  19200  : Result := br19200;
  28800  : Result := br28800;
  38400  : Result := br38400;
  57600  : Result := br57600;
  115200 : Result := br115200;
 else
  raise Exception.Create(rsSpeedError);
 end;
 {$ELSE}
 case GetLinuxBaudRateID(Value) of
  $0000000 : Result := br0;
  $0000001 : Result := br50;
  $0000002 : Result := br75;
  $0000003 : Result := br110;
  $0000004 : Result := br134;
  $0000005 : Result := br150;
  $0000006 : Result := br200;
  $0000007 : Result := br300;
  $0000008 : Result := br600;
  $0000009 : Result := br1200;
  $000000A : Result := br1800;
  $000000B : Result := br2400;
  $000000C : Result := br4800;
  $000000D : Result := br9600;
  $000000E : Result := br19200;
  $000000F : Result := br38400;
  $0001001 : Result := br57600;
  $0001002 : Result := br115200;
  $0001003 : Result := br230400;
  $0001004 : Result := br460800;
  $0001005 : Result := br500000;
  $0001006 : Result := br576000;
  $0001007 : Result := br921600;
  $0001008 : Result := br1000000;
  $0001009 : Result := br1152000;
  $000100A : Result := br1500000;
  $000100B : Result := br2000000;
  $000100C : Result := br2500000;
  $000100D : Result := br3000000;
  $000100E : Result := br3500000;
  $000100F : Result := br4000000;
 else
  raise Exception.Create(rsSpeedError);
 end;
 {$ENDIF}
end;

function GetBaudRateValueFromID(Value : TComPortBaudRate): LongInt;
begin
 {$IFDEF WINDOWS}
 Result := WinBaudRate[Value];
 {$ELSE}
 Result := ComPortBaudRateValue[Value];
 {$ENDIF}
end;

function GetDataBitsIDFromValue(Value : Longint): TComPortDataBits;
begin
 case Value of
  5 : Result:=db5BITS;
  6 : Result:=db6BITS;
  7 : Result:=db7BITS;
  8 : Result:=db8BITS;
 else
  raise Exception.Create(rsBiteSizeError);
 end;
end;

function GetDataBitsValueFromID(Value : TComPortDataBits): LongInt;
begin
 case Value of
  db5BITS : Result := 5;
  db6BITS : Result := 6;
  db7BITS : Result := 7;
  db8BITS : Result := 8;
 else
  raise Exception.Create(rsBiteSizeError);
 end;
end;

end.
