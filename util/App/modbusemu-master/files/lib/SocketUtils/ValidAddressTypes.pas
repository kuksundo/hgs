unit ValidAddressTypes;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils,
     LoggerItf;

type

  TMask = DWord;
  TMaskArray = array [0..32] of TMask;

  TNetAddr = packed record
   Address : DWord;
   Mask    : Byte;
  end;

  TNetAddrArray = array of TNetAddr;

const

 MaskArray : TMaskArray = ($00000000,
                           $80000000,$C0000000,$E0000000,$F0000000,
                           $F8000000,$FC000000,$FE000000,$FF000000,
                           $FF800000,$FFC00000,$FFE00000,$FFF00000,
                           $FFF80000,$FFFC0000,$FFFE0000,$FFFF0000,
                           $FFFF8000,$FFFFC000,$FFFFE000,$FFFFF000,
                           $FFFFF800,$FFFFFC00,$FFFFFE00,$FFFFFF00,
                           $FFFFFF80,$FFFFFFC0,$FFFFFFE0,$FFFFFFF0,
                           $FFFFFFF8,$FFFFFFFC,$FFFFFFFE,$FFFFFFFF);

type

  TListOfValidAddressesIP4 = class(TObjectLogged)
   private
    FNetAddrArray : TNetAddrArray;
    FAddressArray : array of DWord;

    function GetAddresAsNumeric(Index : Integer): DWord;
    function GetAddresAsString(Index : Integer): String;
    function GetCount: Integer;
    function GetCountNet: Integer;
    function GetNetAddr(Index : Integer): TNetAddr;
    function GetNetAddrAsString(Index : Integer): String;
   protected
    function IndexAddrOf(AAddress : DWord): Integer;
    function IndexNetOf(AAddress : DWord; Mask : Byte) : Integer;
    function IndexAddrOfNet(AAddress : DWord): Integer;
   public
    constructor Create; virtual;
    destructor  Destroy; override;

    function  AddAddress(AAddress : String): Integer; overload;
    function  AddAddress(AAddress : DWord): Integer; overload;

    function  IsAddressValid(AAddress : String): Boolean; overload;
    function  IsAddressValid(AAddress : DWord): Boolean; overload;

    function  AddNet(AAddress : String; Mask : Byte): Integer; overload;
    function  AddNet(AAddress : DWord; Mask : Byte): Integer; overload;

{    function  RemoveAddress(AAddress : String): Integer; overload;
    function  RemoveAddress(AAddress : DWord): Integer; overload;
    function  RemoveAddress(AIndex : Integer): Integer; overload;

    function  RemoveNet(AAddress : String; Mask : Byte): Integer; overload;
    function  RemoveNet(AAddress : DWord; Mask : Byte): Integer; overload;
    function  RemoveNet(AIndex : Integer): Integer; overload; }

    procedure Clear;

    property Count    : Integer read GetCount;
    property CountNet : Integer read GetCountNet;

    property AddressAsString[Index : Integer]  : String read GetAddresAsString;
    property AddressAsNumeric[Index : Integer] : DWord read GetAddresAsNumeric;

    property NetAddrAsString[Index : Integer] : String read GetNetAddrAsString;
    property NetAddr[Index : Integer]         : TNetAddr read GetNetAddr;
  end;

implementation

uses SocketMisc;

{ TListOfValidAddressesIP4 }

constructor TListOfValidAddressesIP4.Create;
begin
 //
end;

destructor TListOfValidAddressesIP4.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TListOfValidAddressesIP4.GetAddresAsNumeric(Index : Integer): DWord;
begin
  Result := 0;
  if (Index > High(FAddressArray)) or (Index < Low(FAddressArray)) then Exit;
  Result := FAddressArray[Index];
end;

function TListOfValidAddressesIP4.GetAddresAsString(Index : Integer): String;
begin
  Result := '';
  if (Index > High(FAddressArray)) or (Index < Low(FAddressArray)) then Exit;
  Result := GetIPStr(FAddressArray[Index]);
end;

function TListOfValidAddressesIP4.GetCount: Integer;
begin
  Result := Length(FAddressArray);
end;

function TListOfValidAddressesIP4.GetCountNet: Integer;
begin
  Result := Length(FNetAddrArray);
end;

function TListOfValidAddressesIP4.GetNetAddr(Index : Integer): TNetAddr;
begin
  Result.Address := 0;
  Result.Mask    := 0;
  if (Index > High(FNetAddrArray)) or (Index < Low(FNetAddrArray)) then Exit;
  Result := FNetAddrArray[Index];
end;

function TListOfValidAddressesIP4.GetNetAddrAsString(Index : Integer): String;
begin
  Result := '';
  if (Index > High(FNetAddrArray)) or (Index < Low(FNetAddrArray)) then Exit;
  Result := Format('%s/%d',[GetIPStr(FNetAddrArray[Index].Address),FNetAddrArray[Index].Mask]);
end;

function TListOfValidAddressesIP4.AddAddress(AAddress: String): Integer;
var TempAddr : DWord;
begin
  Result := -1;
  if AAddress = '' then Exit;
  TempAddr := GetIPFromStr(AAddress);
  if TempAddr = 0 then Exit;
  Result := AddAddress(TempAddr);
end;

function TListOfValidAddressesIP4.AddAddress(AAddress: DWord): Integer;
var TempIndex : Integer;
begin
  Result := -1;
  if AAddress = 0 then Exit;
  Result := IndexAddrOf(AAddress);
  if Result <> -1 then Exit;
  SetLength(FAddressArray,Length(FAddressArray)+1);
  TempIndex := Length(FAddressArray)-1;
  FAddressArray[TempIndex] := AAddress;
  Result := TempIndex;
end;

function TListOfValidAddressesIP4.AddNet(AAddress: String; Mask: Byte): Integer;
var TempAddr : DWord;
begin
  Result := -1;
  if (AAddress = '') or (Mask = 0) or (Mask > 32) then Exit;
  TempAddr := GetIPFromStr(AAddress);
  if TempAddr = 0 then Exit;
  Result := AddNet(TempAddr,Mask);
end;

function TListOfValidAddressesIP4.AddNet(AAddress: DWord; Mask: Byte): Integer;
var TempIndex : Integer;
begin
  Result := -1;
  if (AAddress = 0) or (Mask = 0) or (Mask > 32) then Exit;
  Result := IndexNetOf(AAddress,Mask);
  if Result <> -1 then Exit;
  SetLength(FNetAddrArray,Length(FNetAddrArray)+1);
  TempIndex := Length(FNetAddrArray)-1;
  FNetAddrArray[TempIndex].Address := AAddress;
  FNetAddrArray[TempIndex].Mask    := Mask;
  Result := TempIndex;
end;
{
function TListOfValidAddressesIP4.RemoveAddress(AAddress: String): Integer;
begin
  Result := -1;

end;

function TListOfValidAddressesIP4.RemoveAddress(AAddress: DWord): Integer;
begin
  Result := -1;

end;

function TListOfValidAddressesIP4.RemoveAddress(AIndex: Integer): Integer;
begin
  Result := -1;

end;

function TListOfValidAddressesIP4.RemoveNet(AAddress: String; Mask: Byte): Integer;
begin
  Result := -1;

end;

function TListOfValidAddressesIP4.RemoveNet(AAddress: DWord; Mask: Byte): Integer;
begin
  Result := -1;

end;

function TListOfValidAddressesIP4.RemoveNet(AIndex: Integer): Integer;
begin
  Result := -1;

end;
}
procedure TListOfValidAddressesIP4.Clear;
begin
  SetLength(FAddressArray,0);
  SetLength(FNetAddrArray,0);
end;

function TListOfValidAddressesIP4.IndexAddrOf(AAddress: DWord): Integer;
var i,TempCount : Integer;
begin
  Result := -1;
  TempCount := Length(FAddressArray)-1;
  for i := 0 to TempCount do
   begin
    if FAddressArray[i] = AAddress then
     begin
      Result := i;
      Break;
     end;
   end;
end;

function TListOfValidAddressesIP4.IndexNetOf(AAddress: DWord; Mask: Byte): Integer;
var i,TempCount : Integer;
begin
  Result := -1;
  TempCount := Length(FNetAddrArray)-1;
  for i := 0 to TempCount do
   begin
    if (FNetAddrArray[i].Address = AAddress) and (FNetAddrArray[i].Mask = Mask) then
     begin
      Result := i;
      Break;
     end;
   end;
end;

function TListOfValidAddressesIP4.IndexAddrOfNet(AAddress: DWord): Integer;
var i,TempCount : Integer;
    TempMask : Byte;
begin
  Result := -1;
  TempCount := Length(FNetAddrArray)-1;
  for i := 0 to TempCount do
   begin
    TempMask := FNetAddrArray[i].Mask;
    if (AAddress and MaskArray[TempMask]) = (FNetAddrArray[i].Address and MaskArray[TempMask]) then
     begin
      Result := i;
      Break;
     end;
   end;
end;

function TListOfValidAddressesIP4.IsAddressValid(AAddress: String): Boolean;
var TempAddr : DWord;
begin
  Result := False;
  if (Length(FNetAddrArray) = 0) and (Length(FNetAddrArray) = 0) then
   begin
    Result := True;
    Exit;
   end;

  if AAddress = '' then Exit;
  TempAddr := GetIPFromStr(AAddress);
  if TempAddr = 0 then Exit;

  Result := IsAddressValid(TempAddr);
end;

function TListOfValidAddressesIP4.IsAddressValid(AAddress: DWord): Boolean;
var TempIndex : Integer;
begin
  Result := False;
  if (Length(FAddressArray) = 0) and (Length(FNetAddrArray) = 0) then
   begin
    Result := True;
    Exit;
   end;

  TempIndex := IndexAddrOf(AAddress);
  if TempIndex <> -1 then
   begin
    Result := True;
    Exit;
   end;

  TempIndex := IndexAddrOfNet(AAddress);
  if TempIndex <> -1 then Result := True;
end;

end.

