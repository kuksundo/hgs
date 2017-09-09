unit MBAddressActions;

{$mode objfpc}{$H+}

interface

uses MBDefine, MBResourceString;

type
  TMBAddressActions = class
   protected
    constructor Create; virtual;
   public
    class function  GetRegNumber(Address: DWORD): Word;
    class function  GetStringAddress(Address: DWORD): String;
    class function  GetAddressType(Address: DWORD): TRegMBTypes;
    class function  GetAddressOffset(AddressType: TRegMBTypes): DWORD;
    class function  MakeAddress(AddressType: TRegMBTypes; RegNumber: Word): DWORD;
    class function  MakeStringAddress(AddressType: TRegMBTypes; RegNumber: Word): String;

    class procedure CheckAllDiapasonAddress(Address: DWORD);
    class function  CheckAllDiapasonAddr(Address: DWORD): boolean;
    class procedure CheckDeskretAddress(Address: DWORD);
    class function  CheckDeskretAddr(Address: DWORD): boolean;
    class procedure CheckCoilAddress(Address: DWORD);
    class function  CheckCoilAddr(Address: DWORD): boolean;
    class procedure CheckInputAddress(Address: DWORD);
    class function  CheckInputAddr(Address: DWORD): boolean;
    class procedure CheckHoldingAddress(Address: DWORD);
    class function  CheckHoldingAddr(Address: DWORD): boolean;
  end;

implementation

uses SysUtils;

{ TMBAddressActions }

constructor TMBAddressActions.Create;
begin
 // скрыт из публичных методов
end;

class procedure TMBAddressActions.CheckAllDiapasonAddress(Address: DWORD);
begin
 if ((Address<1) and (Address>65535)) or
    ((Address<100001) and (Address>165535)) or
    ((Address<300001) and (Address>365535)) or
    ((Address<400001) and (Address>465535)) then raise Exception.Create(ErrOutOfRange);
end;

class function TMBAddressActions.CheckAllDiapasonAddr(Address: DWORD): boolean;
begin
 Result:= ((Address>=1) and (Address<65536)) or
          ((Address>=10001) and (Address<165536)) or
          ((Address>=30001) and (Address<365536)) or
          ((Address>=40001) and (Address<465536));
end;

class procedure TMBAddressActions.CheckCoilAddress(Address: DWORD);
begin
 if (Address<100001) or (Address>165535) then raise Exception.Create(ErrOutOfRange);
end;

class function TMBAddressActions.CheckCoilAddr(Address: DWORD): boolean;
begin
 Result:= (Address>=100001) or (Address<165536);
end;

class procedure TMBAddressActions.CheckDeskretAddress(Address: DWORD);
begin
 if (Address<1) or (Address>65535) then raise Exception.Create(ErrOutOfRange);
end;

class function TMBAddressActions.CheckDeskretAddr(Address: DWORD): boolean;
begin
 Result:= (Address>=1) or (Address<65536);
end;

class procedure TMBAddressActions.CheckHoldingAddress(Address: DWORD);
begin
 if (Address<400001) or (Address>465535) then raise Exception.Create(ErrOutOfRange);
end;

class function TMBAddressActions.CheckHoldingAddr(Address: DWORD): boolean;
begin
 Result:= (Address>=400001) or (Address<465536);
end;

class procedure TMBAddressActions.CheckInputAddress(Address: DWORD);
begin
 if (Address<300001) or (Address>365535) then raise Exception.Create(ErrOutOfRange);
end;

class function TMBAddressActions.CheckInputAddr(Address: DWORD): boolean;
begin
 Result:= (Address>=300001) or (Address<365536);
end;

class function TMBAddressActions.GetAddressType(Address: DWORD): TRegMBTypes;
begin
  CheckAllDiapasonAddress(Address);
  if (Address>=1) and (Address<65535) then Result:=rgDiscrete
  else
  if (Address>=100001) and (Address<165536) then Result:=rgCoils
  else
  if (Address>=300001) and (Address<365536) then Result:=rgInput
  else
  if (Address>=400001) and (Address<465536) then Result:=rgHolding
  else Result:=rgNone;
end;

class function TMBAddressActions.GetAddressOffset(AddressType: TRegMBTypes): DWORD;
begin
  case AddressType of
     rgDiscrete : Result:= 1;
     rgCoils    : Result:= 100001;
     rgInput    : Result:= 300001;
     rgHolding  : Result:= 400001;
     else Result:= 0;
  end;
end;

class function TMBAddressActions.GetRegNumber(Address: DWORD): Word;
begin
  Result:= 0;
  CheckAllDiapasonAddress(Address);
  case GetAddressType(Address) of
     rgDiscrete : Result:= Address-1;
     rgCoils    : Result:= Address-100001;
     rgInput    : Result:= Address-300001;
     rgHolding  : Result:= Address-400001;
  end;
end;

class function TMBAddressActions.GetStringAddress(Address: DWORD): String;
var str : String;
begin
  Result := '';
  CheckAllDiapasonAddress(Address);
  str:=IntToStr(Address);
  if (Address>=1) and (Address<65536) then
  begin
    case Length(str) of
      1: Result:= '00000'+str;
      2: Result:= '0000'+str;
      3: Result:= '000'+str;
      4: Result:= '00'+str;
      5: Result:= '0'+str;
    end;
  end
  else Result:= str;
end;

class function TMBAddressActions.MakeAddress(AddressType: TRegMBTypes; RegNumber: Word): DWORD;
begin
  case AddressType of
    rgDiscrete : Result:= RegNumber+1;
    rgCoils    : Result:= RegNumber+100001;
    rgInput    : Result:= RegNumber+300001;
    rgHolding  : Result:= RegNumber+400001;
    else raise Exception.Create(ErrOutOfRange);
  end;
end;

class function TMBAddressActions.MakeStringAddress(AddressType: TRegMBTypes; RegNumber: Word): String;
begin
  Result:= GetStringAddress(MakeAddress(AddressType,RegNumber));
end;

end.