unit COMPortFunction;

interface

uses Classes,
     {$IFDEF WINDOWS} Windows, Registry, CheckLst, StdCtrls,{$ENDIF}
     COMPortParamTypes;

{$IFDEF WINDOWS}
const
  csRegCOMEnumSection = 'HARDWARE\DEVICEMAP\SERIALCOMM';
{$ENDIF}

function  MakeCOMName(COMNumber : Byte): String;
function  MakeDefDCBFlags : DWORD;
{$IFDEF WINDOWS}
function  CheckPossibilityOfUsageCOMPort(PortNumer: Byte;var Error : Cardinal): Boolean;
procedure UpdateCOMPortAccessibleCheckListBox(CheckLst : TCheckListBox);
function  ReadCOMPortList: TStrings;
procedure FillCOMPortCheckListBox(CheckLst : TCheckListBox);
procedure FillCOMPortListBox(LstBox : TListBox);
function  MakeEventFlagsMask(FlagSet : TComPortEvFlags): DWORD;
function  MakeEventFlagsSet(EvFlags:DWORD): TComPortEvFlags;
function  GetCOMErrorString(ErrorCategory : TComErrorCategory; ErrorCode : Cardinal):String;
{$ENDIF}

implementation

uses SysUtils, StrUtils,
     COMPortResStr;

{$IFDEF WINDOWS}
function  GetCOMErrorString(ErrorCategory : TComErrorCategory; ErrorCode : Cardinal):String;
var ErrString    : String;
    ErrCatString : String;
begin
  case ErrorCategory of
    ecWrite  : begin  // ошибка операции записи в порт
                ErrString := 'EcWrite';
                ErrString:=SysErrorMessage(ErrorCode);
               end;
    ecRead   : begin  // ошибка операции получения данных из порта
                ErrString := 'EcRead';
                ErrString:=SysErrorMessage(ErrorCode);
               end;
    ecEvent  : begin  // сообщение об ошибка от порта
                ErrString := 'EcEvent';
                ErrString:=SysErrorMessage(ErrorCode);
               end;
    ecLine   : begin  // ошибки линии
                ErrCatString:='EcLine';
                case ErrorCode of
                 0           : begin
                                ErrString:=rsCOMErrString1;
                               end;
                 CE_BREAK    : begin
                                ErrString:=rsCOMErrString2;
                               end;
                 CE_DNS      : begin
                                ErrString:=rsCOMErrString3;
                               end;
                 CE_FRAME    : begin
                                ErrString:=rsCOMErrString4;
                               end;
                 CE_IOE      : begin
                                ErrString:=rsCOMErrString5;
                               end;
                 CE_MODE     : begin
                                ErrString:=rsCOMErrString6;
                               end;
                 CE_OOP      : begin
                                ErrString:=rsCOMErrString7;
                               end;
                 CE_OVERRUN  : begin
                                ErrString:=rsCOMErrString8;
                               end;
                 CE_PTO      : begin
                                ErrString:=rsCOMErrString9;
                               end;
                 CE_RXOVER   : begin
                                ErrString:=rsCOMErrString10;
                               end;
                 CE_RXPARITY : begin
                                ErrString:=rsCOMErrString11;
                               end;
                 CE_TXFULL   : begin
                                ErrString:=rsCOMErrString12;
                               end;
                else
                 ErrString:=rsCOMErrString13;
                end;
               end;
    ecApp    : begin  // программные ошибки
                ErrString := 'EcApp';
                ErrString:=Format('0х%s',[IntToHex(ErrorCode,8)]);
               end;
    ecSys    : begin  // системные ошибки при операциях с портом
                ErrString := 'EcSys';
                ErrString:=SysErrorMessage(ErrorCode);
               end;
  else
   ErrString := rsCOMErrString14;
   ErrString := Format('0х%s',[IntToHex(ErrorCode,8)]);
  end;
  Result := Format(rsCOMErrString15,[ErrCatString,ErrString]);
end;

{$ENDIF}

function  MakeDefDCBFlags : DWORD;
begin
 Result:=0;
end;

{$IFDEF WINDOWS}

function MakeEventFlagsMask(FlagSet : TComPortEvFlags): DWORD;
begin
 Result:=0;
 if flRXCHAR  in FlagSet then Result:=Result or EV_RXCHAR;
 if flRXFLAG  in FlagSet then Result:=Result or EV_RXFLAG;
 if flTXEMPTY in FlagSet then Result:=Result or EV_TXEMPTY;
 if flCTS     in FlagSet then Result:=Result or EV_CTS;
 if flDSR     in FlagSet then Result:=Result or EV_DSR;
 if flRLSD    in FlagSet then Result:=Result or EV_RLSD;
 if flBREAK   in FlagSet then Result:=Result or EV_BREAK;
 if flERR     in FlagSet then Result:=Result or EV_ERR;
 if flRING    in FlagSet then Result:=Result or EV_RING;
end;

function MakeEventFlagsSet(EvFlags:DWORD): TComPortEvFlags;
begin
 Result:=[];
 if (EvFlags and EV_RXCHAR)  = EV_RXCHAR  then Result:=Result+[flRXCHAR];
 if (EvFlags and EV_RXFLAG)  = EV_RXFLAG  then Result:=Result+[flRXFLAG];
 if (EvFlags and EV_TXEMPTY) = EV_TXEMPTY then Result:=Result+[flTXEMPTY];
 if (EvFlags and EV_CTS)     = EV_CTS     then Result:=Result+[flCTS];
 if (EvFlags and EV_DSR)     = EV_DSR     then Result:=Result+[flDSR];
 if (EvFlags and EV_RLSD)    = EV_RLSD    then Result:=Result+[flRLSD];
 if (EvFlags and EV_BREAK)   = EV_BREAK   then Result:=Result+[flBREAK];
 if (EvFlags and EV_ERR)     = EV_ERR     then Result:=Result+[flERR];
 if (EvFlags and EV_RING)    = EV_RING    then Result:=Result+[flRING];
end;

{$ENDIF}

function  MakeCOMName(COMNumber : Byte): String;
begin
 Result:=Format('\\.\COM%d',[COMNumber]);
end;

{$IFDEF WINDOWS}

procedure FillCOMPortListBox(LstBox : TListBox);
var TempPortList : TStrings;
    i : Integer;
    Index : Integer;
    Error : Cardinal;
begin
 if not Assigned(LstBox) then Exit;
 TempPortList:=ReadCOMPortList;
 if TempPortList=nil then Exit;
 LstBox.Clear;
 for i := 0 to 255 do
  begin
   LstBox.Items.Add(Format(rsCOMUnknown,[i+1]));
  end;
 for i := 0 to TempPortList.Count-1 do
  begin
   Index:=StrToInt(TempPortList.Values[TempPortList.Names[i]])-1;
   LstBox.Items[Index]:=IfThen(CheckPossibilityOfUsageCOMPort(Index+1,Error),
                               Format(rsCOMAccessible,[Index]),
                               Format(rsCOMUnAccessible,[Index]));
  end;
end;

procedure FillCOMPortCheckListBox(CheckLst : TCheckListBox);
var TempPortList : TStrings;
    i : Integer;
    Index : Integer;
    Error : Cardinal;
begin
 if not Assigned(CheckLst) then Exit;
 TempPortList:=ReadCOMPortList;
 if TempPortList=nil then Exit;
 CheckLst.Clear;
 CheckLst.Items.NameValueSeparator:='-';
 for i := 0 to 255 do
  begin
   CheckLst.Items.Add(Format(rsCOMString1,[i+1]));
   CheckLst.ItemEnabled[i]:=False;
  end;
 for i := 0 to TempPortList.Count-1 do
  begin
   Index:=StrToInt(TempPortList.Values[TempPortList.Names[i]])-1;
   CheckLst.ItemEnabled[Index]:=CheckPossibilityOfUsageCOMPort(Index+1,Error);
   case Error of
    0                    : CheckLst.Items.ValueFromIndex[Index]:=rsCOMString2;
    ERROR_ACCESS_DENIED  : CheckLst.Items.ValueFromIndex[Index]:=rsCOMString3;
    ERROR_FILE_NOT_FOUND : CheckLst.Items.ValueFromIndex[Index]:=rsCOMString4;
    ERROR_BUSY           : CheckLst.Items.ValueFromIndex[Index]:=rsCOMString5;
   else
    CheckLst.Items.ValueFromIndex[Index]:=IntToStr(Error);
   end;
  end;
end;

procedure UpdateCOMPortAccessibleCheckListBox(CheckLst : TCheckListBox);
var TempPortList : TStrings;
    i : Integer;
    Index : Integer;
    Error : Cardinal;
    ResCheck : Boolean;
begin
 if not Assigned(CheckLst) then Exit;
 TempPortList:=ReadCOMPortList;
 if TempPortList=nil then Exit;
 if CheckLst.Count<256 then Exit;
 for i := 0 to TempPortList.Count-1 do
  begin
   Index:=StrToInt(TempPortList.Values[TempPortList.Names[i]])-1;
   ResCheck:=CheckPossibilityOfUsageCOMPort(Index+1,Error);
   CheckLst.ItemEnabled[Index]:=ResCheck;
   case Error of
    0                    : CheckLst.Items.ValueFromIndex[Index]:=rsCOMString2;
    ERROR_ACCESS_DENIED  : CheckLst.Items.ValueFromIndex[Index]:=rsCOMString3;
    ERROR_FILE_NOT_FOUND : begin
                            CheckLst.Items.ValueFromIndex[Index]:=rsCOMString4;
                            CheckLst.ItemEnabled[Index]:=CheckLst.Checked[Index];
                           end;
    ERROR_BUSY           : begin
                            CheckLst.Items.ValueFromIndex[Index]:=rsCOMString5;
                            CheckLst.ItemEnabled[Index]:=CheckLst.Checked[Index];
                           end;
   else
    CheckLst.Items.ValueFromIndex[Index]:=IntToStr(Error);
    CheckLst.ItemEnabled[Index]:=CheckLst.Checked[Index];
   end;
  end;
end;

function CheckPossibilityOfUsageCOMPort(PortNumer: Byte;var Error : Cardinal): Boolean;
var TempName : String;
    TempHandle : THandle;
begin
 Result:=False;
 if PortNumer=0 then Exit;
 Error:=0;
 TempName:='\\.\COM'+IntToStr(PortNumer);
 TempHandle:=CreateFile(PChar(TempName),
                        GENERIC_READ or GENERIC_WRITE,
                        0,
                        nil,
                        OPEN_EXISTING,
                        FILE_ATTRIBUTE_NORMAL,
                        0);
 Result:=TempHandle<>INVALID_HANDLE_VALUE;
 if Result then CloseHandle(TempHandle) else Error:=GetLastError;
end;

function ReadCOMPortList: TStrings;
var Reg     : TRegistry;
    KeyInfo : TRegKeyInfo;
    i       : Integer;
    TempValueList : TStringList;
    TempNum : String;
begin
 Result:=nil;
 Reg:=TRegistry.Create;
 try
  Reg.RootKey:=HKEY_LOCAL_MACHINE;
  if not Reg.OpenKeyReadOnly(csRegCOMEnumSection) then Exit;
  if not Reg.GetKeyInfo(KeyInfo) then Exit;
  if KeyInfo.NumValues=0 then Exit;
  Result:=TStringList.Create;
  TempValueList:=TStringList.Create;
  try
   Reg.GetValueNames(TempValueList);
   for i := 0 to TempValueList.Count-1 do
    begin
     TempNum:=Reg.ReadString(TempValueList.Strings[i]);
     Result.Add(Format('%s=%s',[TempNum,
                                StringReplace(TempNum,
                                              'COM',
                                              '',
                                              [rfReplaceAll, rfIgnoreCase])
                               ]));
    end;
  finally
   TempValueList.Free;
  end;
 finally
  Reg.Free;
 end;
end;

{$ENDIF}

end.
