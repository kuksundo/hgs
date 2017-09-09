unit MBByteClasses;

{$mode objfpc}{$H+}

interface

uses MBDefine, MBBitsClasses;

type

  TRegByte         = class;
  TOnRegByteChange = procedure (Sender: TRegByte; ChangeBitSet: TRegBits = [])of object;

  TRegByte = class // класс реализующий представление байта как числа и как набора из 8 бит
  private
    FValue    : Byte;          // значение байта
    FByteBits : TBitString;    // массив флагов состояния бит байта
    FOnChange : TOnRegByteChange;
    function  GetBit(Index: Integer): Boolean;
    procedure SetBit(Index: Integer; const Value: Boolean);
    procedure SetValue(const Value: Byte);
    function  GetByteBitString: String;
    procedure SetByteBitString(const Value: String);
  protected
    function GetByteChange(Value : Byte): TRegBits; virtual;
  public
    constructor Create;
    destructor  Destroy; override;
    property Value: Byte read FValue write SetValue;
    property Bits[Index: Integer]: Boolean read GetBit write SetBit;
    property ByteBitString: String read GetByteBitString write SetByteBitString;
    property OnChange: TOnRegByteChange read FOnChange write FOnChange;
  end;



implementation

uses SysUtils,
     MBResourceString;

{ TRegByte }

constructor TRegByte.Create;
begin
  FValue:= 0;
  FByteBits:= TBitString.Create;
  FByteBits.Size:= 8;
end;

destructor TRegByte.Destroy;
begin
  FByteBits.Free;
  inherited;
end;

function TRegByte.GetBit(Index: Integer): Boolean;
begin
  if (Index < 0) or (Index > 7) then raise Exception.Create(ErrOutOfRange);
  Result:= FByteBits.Bits[Index];
end;

function TRegByte.GetByteBitString: String;
begin
  Result:=FByteBits.BitString;
end;

function TRegByte.GetByteChange(Value: Byte): TRegBits;
begin
  Result:=[];
  if (FValue and $01)<>(Value and $01) then
  begin
   Result:=Result+[rw0];
  end;
  if (FValue and $02)<>(Value and $02) then
  begin
   Result:=Result+[rw1];
  end;
  if (FValue and $04)<>(Value and $04) then
  begin
   Result:=Result+[rw2];
  end;
  if (FValue and $08)<>(Value and $08) then
  begin
   Result:=Result+[rw3];
  end;
  if (FValue and $10)<>(Value and $10) then
  begin
   Result:=Result+[rw4];
  end;
  if (FValue and $20)<>(Value and $20) then
  begin
   Result:=Result+[rw5];
  end;
  if (FValue and $40)<>(Value and $40) then
  begin
   Result:=Result+[rw6];
  end;
  if (FValue and $80)<>(Value and $80) then
  begin
   Result:=Result+[rw7];
  end;
end;

procedure TRegByte.SetBit(Index: Integer; const Value: Boolean);
var TempBits : TRegBits;
begin
 if (Index < 0) or (Index > 7) then raise Exception.Create(ErrOutOfRange);
 if Value = FByteBits.Bits[Index] then Exit;
 TempBits := [];
 FByteBits.Bits[Index]:= Value;
 case Index of
   0: begin if Value then FValue:= FValue or $01 else FValue:= FValue xor $01; TempBits:= [rw0] end;
   1: begin if Value then FValue:= FValue or $02 else FValue:= FValue xor $02; TempBits:= [rw1] end;
   2: begin if Value then FValue:= FValue or $04 else FValue:= FValue xor $04; TempBits:= [rw2] end;
   3: begin if Value then FValue:= FValue or $08 else FValue:= FValue xor $08; TempBits:= [rw3] end;
   4: begin if Value then FValue:= FValue or $10 else FValue:= FValue xor $10; TempBits:= [rw4] end;
   5: begin if Value then FValue:= FValue or $20 else FValue:= FValue xor $20; TempBits:= [rw5] end;
   6: begin if Value then FValue:= FValue or $40 else FValue:= FValue xor $40; TempBits:= [rw6] end;
   7: begin if Value then FValue:= FValue or $80 else FValue:= FValue xor $80; TempBits:= [rw7] end;
 end;
 if Assigned(FOnChange) then FOnChange(Self, TempBits);
end;

procedure TRegByte.SetByteBitString(const Value: String);
var TempBits: TRegBits;
    TempValue: Byte;
begin
 FByteBits.BitString:= Value;
 TempValue:= FValue;
 if FByteBits.Bits[0] then TempValue:= TempValue or $01 else TempValue:= TempValue xor $01;
 if FByteBits.Bits[1] then TempValue:= TempValue or $02 else TempValue:= TempValue xor $02;
 if FByteBits.Bits[2] then TempValue:= TempValue or $04 else TempValue:= TempValue xor $04;
 if FByteBits.Bits[3] then TempValue:= TempValue or $08 else TempValue:= TempValue xor $08;
 if FByteBits.Bits[4] then TempValue:= TempValue or $10 else TempValue:= TempValue xor $10;
 if FByteBits.Bits[5] then TempValue:= TempValue or $20 else TempValue:= TempValue xor $20;
 if FByteBits.Bits[6] then TempValue:= TempValue or $40 else TempValue:= TempValue xor $40;
 if FByteBits.Bits[7] then TempValue:= TempValue or $80 else TempValue:= TempValue xor $80;
 TempBits:= [];
 TempBits:= GetByteChange(TempValue);
 FValue:= TempValue;
 if Assigned(FOnChange) then FOnChange(Self, TempBits);
end;

procedure TRegByte.SetValue(const Value: Byte);
var TempBits : TRegBits;
begin
  if FValue = Value then Exit;
  TempBits:= [];
  TempBits:= GetByteChange(Value);
  if rw0 in TempBits then if ((Value and $01) = $01) then FByteBits.Bits[0]:= True else FByteBits.Bits[0]:= False;
  if rw1 in TempBits then if ((Value and $02) = $02) then FByteBits.Bits[1]:= True else FByteBits.Bits[1]:= False;
  if rw2 in TempBits then if ((Value and $04) = $04) then FByteBits.Bits[2]:= True else FByteBits.Bits[2]:= False;
  if rw3 in TempBits then if ((Value and $08) = $08) then FByteBits.Bits[3]:= True else FByteBits.Bits[3]:= False;
  if rw4 in TempBits then if ((Value and $10) = $10) then FByteBits.Bits[4]:= True else FByteBits.Bits[4]:= False;
  if rw5 in TempBits then if ((Value and $20) = $20) then FByteBits.Bits[5]:= True else FByteBits.Bits[5]:= False;
  if rw6 in TempBits then if ((Value and $40) = $40) then FByteBits.Bits[6]:= True else FByteBits.Bits[6]:= False;
  if rw7 in TempBits then if ((Value and $80) = $80) then FByteBits.Bits[7]:= True else FByteBits.Bits[7]:= False;
  FValue:= Value;
  if Assigned(FOnChange) then FOnChange(Self, TempBits);
end;

end.