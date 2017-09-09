unit MBBitsClasses;

{$mode objfpc}{$H+}

interface

uses {Windows,} Classes;

resourcestring
 ErrOutOfIndex = 'Выход за пределы массива бит.';

type
 TByteBit = (rb0,rb1,rb2,rb3,rb4,rb5,rb6,rb7);
 TByteBitSet = set of TByteBit;

 TWordBit = (rw0,rw1,rw2,rw3,rw4,rw5,rw6,rw7,rw8,rw9,rw10,rw11,rw12,rw13,rw14,rw15);
 TWordBitSet = set of TWordBit;

 TDWordBit = (rd0,rd1,rd2,rd3,rd4,rd5,rd6,rd7,rd8,rd9,rd10,rd11,rd12,rd13,rd14,rd15,
              rd16,rd17,rd18,rd19,rd20,rd21,rd22,rd23,rd24,rd25,rd26,rd27,rd28,rd29,rd30,rd31);
 TDWordBitSet = set of TDWordBit;

 TBitString = class(TBits) // класс реализующий преобразование состояния бита в строку
  private
   function  GetBitString: String;
   procedure SetBitString(const AValue: String);
  public
   property BitString : String read GetBitString write SetBitString;
 end;

 TBitsAbstract = class
 private
   FOnChange: TNotifyEvent;
   function  GetBitString: String;
   procedure SetBitString(const Value: String);
 protected
   FBits: TBitString;
   procedure OnChangeProc; virtual;
   procedure CheckIndex(Index: Integer); virtual;
   function  GetHEXValue: String; virtual; abstract;
   function  GetBits(Index: Integer): Boolean; virtual;
   procedure SetBits(Index: Integer; const Value: Boolean); virtual; abstract;
 public
   constructor Create; virtual;
   destructor  Destroy; override;
   property Bits[Index: Integer] : Boolean read GetBits write SetBits;
   property BitString: String read GetBitString write SetBitString;
   property HEXValue: String read GetHEXValue;
   property OnChange: TNotifyEvent read FOnChange write FOnChange;
 end;

 TByteBits = class(TBitsAbstract)
 protected
   FValue : Byte;
   procedure SetBits(Index: Integer; const Value: Boolean); override;
   function  GetHEXValue: String; override;
   procedure SetValue(const Value: Byte);
   function  GetByteChange(Value:Byte): TByteBitSet; virtual;
 public
   constructor Create; override;
   procedure Assign(Source : TByteBits); virtual;
   property Value: Byte read FValue write SetValue;
 end;

 TWordBits = class(TBitsAbstract)
 protected
   FValue: Word;
   procedure SetBits(Index: Integer; const Value: Boolean); override;
   function  GetHEXValue: String; override;
   procedure SetValue(const Value: Word);
   function  GetWordChange(Value:Word): TWordBitSet; virtual;
 public
   constructor Create; override;
   procedure Assign(Source : TWordBits); virtual;
   property Value: Word read FValue write SetValue;
 end;

 TDWordBits = class(TBitsAbstract)
 protected
   FValue : DWORD;
   procedure SetBits(index: Integer; const Value: Boolean); override;
   function  GetHEXValue: String; override;
   procedure SetValue(const Value: DWORD);
   function  GetWordChange(Value:DWORD): TDWordBitSet; virtual;
 public
   constructor Create; override;
   procedure Assign(Source: TDWordBits); virtual;
   property Value: DWORD read FValue write SetValue;
 end;

implementation

uses SysUtils,
     MBResourceString;

{ TBitString }

function TBitString.GetBitString: String;
var i,Count : Integer;
begin
  Count := Size-1;
  SetLength(Result, Count+1);
  for i := 0 to Count do
   begin
    if inherited Bits[i] then Result[Size-i]:= '1' else Result[Size-i]:= '0';
   end;
end;

procedure TBitString.SetBitString(const AValue: String);
var i: integer;
begin
  if Length(AValue) <> Size then Size := Length(AValue);
  for i:= Size downto 1 do
   begin
    if not(AValue[i] in ['0', '1']) then raise Exception.Create(ErrOutofChar);
    inherited Bits[Size-i]:= AValue[i] <> '0';
   end;
end;

{ TBitsAbstract }

procedure TBitsAbstract.CheckIndex(Index: Integer);
begin
  if (index < 0) or (index > (FBits.Size-1)) then raise Exception.Create(ErrOutOfIndex);
end;

constructor TBitsAbstract.Create;
begin
  FBits:=TBitString.Create;
end;

destructor TBitsAbstract.Destroy;
begin
  FBits.Free;
  inherited;
end;

function TBitsAbstract.GetBitString: String;
begin
  Result:= FBits.BitString;
end;

function TBitsAbstract.GetBits(Index: Integer): Boolean;
begin
  CheckIndex(Index);
  Result:= FBits.Bits[Index];
end;

procedure TBitsAbstract.OnChangeProc;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TBitsAbstract.SetBitString(const Value: String);
begin
  if SameText(Value, FBits.BitString) then Exit;
  FBits.BitString:= Value;
end;

{ TByteBits }

procedure TByteBits.Assign(Source: TByteBits);
begin
  Value:= Source.Value;
  FOnChange:= Source.OnChange;
end;

constructor TByteBits.Create;
begin
  inherited;
  FBits.Size:= 8;
  FValue:= 0;
end;

function TByteBits.GetByteChange(Value: Byte): TByteBitSet;
begin
  Result:=[];
  if (FValue and $01)<>(Value and $01) then Result:=Result+[rb0];
  if (FValue and $02)<>(Value and $02) then Result:=Result+[rb1];
  if (FValue and $04)<>(Value and $04) then Result:=Result+[rb2];
  if (FValue and $08)<>(Value and $08) then Result:=Result+[rb3];
  if (FValue and $10)<>(Value and $10) then Result:=Result+[rb4];
  if (FValue and $20)<>(Value and $20) then Result:=Result+[rb5];
  if (FValue and $40)<>(Value and $40) then Result:=Result+[rb6];
  if (FValue and $80)<>(Value and $80) then Result:=Result+[rb7];
end;

function TByteBits.GetHEXValue: String;
begin
  Result:= IntToHex(FValue, 2);
end;

procedure TByteBits.SetBits(index: Integer; const Value: Boolean);
begin
  CheckIndex(index);
  if FBits.Bits[index]=Value then Exit;
  FBits.Bits[index]:=Value;
  case index of
    0: if Value then FValue:= FValue or $01 else FValue:= FValue xor $01;
    1: if Value then FValue:= FValue or $02 else FValue:= FValue xor $02;
    2: if Value then FValue:= FValue or $04 else FValue:= FValue xor $04;
    3: if Value then FValue:= FValue or $08 else FValue:= FValue xor $08;
    4: if Value then FValue:= FValue or $10 else FValue:= FValue xor $10;
    5: if Value then FValue:= FValue or $20 else FValue:= FValue xor $20;
    6: if Value then FValue:= FValue or $40 else FValue:= FValue xor $40;
    7: if Value then FValue:= FValue or $80 else FValue:= FValue xor $80;
  end;
  OnChangeProc;
end;

procedure TByteBits.SetValue(const Value: Byte);
var TempBits : TByteBitSet;
begin
  if FValue = Value then Exit;
  TempBits:=[];
  TempBits:=GetByteChange(Value);
  if rb0 in TempBits then if ((Value and $01)=$01) then FBits.Bits[0]:= True else FBits.Bits[0]:= False;
  if rb1 in TempBits then if ((Value and $02)=$02) then FBits.Bits[1]:= True else FBits.Bits[1]:= False;
  if rb2 in TempBits then if ((Value and $04)=$04) then FBits.Bits[2]:= True else FBits.Bits[2]:= False;
  if rb3 in TempBits then if ((Value and $08)=$08) then FBits.Bits[3]:= True else FBits.Bits[3]:= False;
  if rb4 in TempBits then if ((Value and $10)=$10) then FBits.Bits[4]:= True else FBits.Bits[4]:= False;
  if rb5 in TempBits then if ((Value and $20)=$20) then FBits.Bits[5]:= True else FBits.Bits[5]:= False;
  if rb6 in TempBits then if ((Value and $40)=$40) then FBits.Bits[6]:= True else FBits.Bits[6]:= False;
  if rb7 in TempBits then if ((Value and $80)=$80) then FBits.Bits[7]:= True else FBits.Bits[7]:= False;
  FValue:=Value;
  OnChangeProc;
end;

{ TWordBits }

procedure TWordBits.Assign(Source: TWordBits);
begin
  Value:=Source.Value;
  FOnChange:=Source.OnChange;
end;

constructor TWordBits.Create;
begin
  inherited;
  FBits.Size:= 16;
  FValue:= 0;
end;

function TWordBits.GetHEXValue: String;
begin
  Result:= IntToHex(FValue, 4);
end;

function TWordBits.GetWordChange(Value: Word): TWordBitSet;
begin
  Result:=[];
  if (FValue and $0001)<>(Value and $0001) then Result:=Result+[rw0];
  if (FValue and $0002)<>(Value and $0002) then Result:=Result+[rw1];
  if (FValue and $0004)<>(Value and $0004) then Result:=Result+[rw2];
  if (FValue and $0008)<>(Value and $0008) then Result:=Result+[rw3];
  if (FValue and $0010)<>(Value and $0010) then Result:=Result+[rw4];
  if (FValue and $0020)<>(Value and $0020) then Result:=Result+[rw5];
  if (FValue and $0040)<>(Value and $0040) then Result:=Result+[rw6];
  if (FValue and $0080)<>(Value and $0080) then Result:=Result+[rw7];
  if (FValue and $0100)<>(Value and $0100) then Result:=Result+[rw8];
  if (FValue and $0200)<>(Value and $0200) then Result:=Result+[rw9];
  if (FValue and $0400)<>(Value and $0400) then Result:=Result+[rw10];
  if (FValue and $0800)<>(Value and $0800) then Result:=Result+[rw11];
  if (FValue and $1000)<>(Value and $1000) then Result:=Result+[rw12];
  if (FValue and $2000)<>(Value and $2000) then Result:=Result+[rw13];
  if (FValue and $4000)<>(Value and $4000) then Result:=Result+[rw14];
  if (FValue and $8000)<>(Value and $8000) then Result:=Result+[rw15];
end;

procedure TWordBits.SetBits(Index: Integer; const Value: Boolean);
begin
  CheckIndex(Index);
  if FBits.Bits[index] = Value then Exit;
  FBits.Bits[index]:= Value;
  case Index of
    0:  if Value then FValue:= FValue or $0001 else FValue:= FValue xor $0001;
    1:  if Value then FValue:= FValue or $0002 else FValue:= FValue xor $0002;
    2:  if Value then FValue:= FValue or $0004 else FValue:= FValue xor $0004;
    3:  if Value then FValue:= FValue or $0008 else FValue:= FValue xor $0008;
    4:  if Value then FValue:= FValue or $0010 else FValue:= FValue xor $0010;
    5:  if Value then FValue:= FValue or $0020 else FValue:= FValue xor $0020;
    6:  if Value then FValue:= FValue or $0040 else FValue:= FValue xor $0040;
    7:  if Value then FValue:= FValue or $0080 else FValue:= FValue xor $0080;
    8:  if Value then FValue:= FValue or $0100 else FValue:= FValue xor $0100;
    9:  if Value then FValue:= FValue or $0200 else FValue:= FValue xor $0200;
    10: if Value then FValue:= FValue or $0400 else FValue:= FValue xor $0400;
    11: if Value then FValue:= FValue or $0800 else FValue:= FValue xor $0800;
    12: if Value then FValue:= FValue or $1000 else FValue:= FValue xor $1000;
    13: if Value then FValue:= FValue or $2000 else FValue:= FValue xor $2000;
    14: if Value then FValue:= FValue or $4000 else FValue:= FValue xor $4000;
    15: if Value then FValue:= FValue or $8000 else FValue:= FValue xor $8000;
  end;
  OnChangeProc;
end;

procedure TWordBits.SetValue(const Value: Word);
var TempBits : TWordBitSet;
begin
  if FValue = Value then Exit;
  TempBits:=[];
  TempBits:=GetWordChange(Value);
  if rw0  in TempBits then if ((Value and $0001)=$0001) then FBits.Bits[0]:= True else FBits.Bits[0]:= False;
  if rw1  in TempBits then if ((Value and $0002)=$0002) then FBits.Bits[1]:= True else FBits.Bits[1]:= False;
  if rw2  in TempBits then if ((Value and $0004)=$0004) then FBits.Bits[2]:= True else FBits.Bits[2]:= False;
  if rw3  in TempBits then if ((Value and $0008)=$0008) then FBits.Bits[3]:= True else FBits.Bits[3]:= False;
  if rw4  in TempBits then if ((Value and $0010)=$0010) then FBits.Bits[4]:= True else FBits.Bits[4]:= False;
  if rw5  in TempBits then if ((Value and $0020)=$0020) then FBits.Bits[5]:= True else FBits.Bits[5]:= False;
  if rw6  in TempBits then if ((Value and $0040)=$0040) then FBits.Bits[6]:= True else FBits.Bits[6]:= False;
  if rw7  in TempBits then if ((Value and $0080)=$0080) then FBits.Bits[7]:= True else FBits.Bits[7]:= False;
  if rw8  in TempBits then if ((Value and $0100)=$0100) then FBits.Bits[8]:= True else FBits.Bits[8]:= False;
  if rw9  in TempBits then if ((Value and $0200)=$0200) then FBits.Bits[9]:= True else FBits.Bits[9]:= False;
  if rw10 in TempBits then if ((Value and $0400)=$0400) then FBits.Bits[10]:= True else FBits.Bits[10]:= False;
  if rw11 in TempBits then if ((Value and $0800)=$0800) then FBits.Bits[11]:= True else FBits.Bits[11]:= False;
  if rw12 in TempBits then if ((Value and $1000)=$1000) then FBits.Bits[12]:= True else FBits.Bits[12]:= False;
  if rw13 in TempBits then if ((Value and $2000)=$2000) then FBits.Bits[13]:= True else FBits.Bits[13]:= False;
  if rw14 in TempBits then if ((Value and $4000)=$4000) then FBits.Bits[14]:= True else FBits.Bits[14]:= False;
  if rw15 in TempBits then if ((Value and $8000)=$8000) then FBits.Bits[15]:= True else FBits.Bits[15]:= False;
  FValue:=Value;
  OnChangeProc;
end;

{ TDWordBits }

procedure TDWordBits.Assign(Source: TDWordBits);
begin
  Value:=Source.Value;
  FOnChange:=Source.OnChange;
end;

constructor TDWordBits.Create;
begin
  inherited;
  FBits.Size:=32;
  FValue:=0;
end;

function TDWordBits.GetHEXValue: String;
begin
  Result:= IntToHex(FValue, 8);
end;

function TDWordBits.GetWordChange(Value: DWORD): TDWordBitSet;
begin
  Result:=[];
  if (FValue and $00000001)<>(Value and $00000001) then Result:=Result+[rd0];
  if (FValue and $00000002)<>(Value and $00000002) then Result:=Result+[rd1];
  if (FValue and $00000004)<>(Value and $00000004) then Result:=Result+[rd2];
  if (FValue and $00000008)<>(Value and $00000008) then Result:=Result+[rd3];
  if (FValue and $00000010)<>(Value and $00000010) then Result:=Result+[rd4];
  if (FValue and $00000020)<>(Value and $00000020) then Result:=Result+[rd5];
  if (FValue and $00000040)<>(Value and $00000040) then Result:=Result+[rd6];
  if (FValue and $00000080)<>(Value and $00000080) then Result:=Result+[rd7];
  if (FValue and $00000100)<>(Value and $00000100) then Result:=Result+[rd8];
  if (FValue and $00000200)<>(Value and $00000200) then Result:=Result+[rd9];
  if (FValue and $00000400)<>(Value and $00000400) then Result:=Result+[rd10];
  if (FValue and $00000800)<>(Value and $00000800) then Result:=Result+[rd11];
  if (FValue and $00001000)<>(Value and $00001000) then Result:=Result+[rd12];
  if (FValue and $00002000)<>(Value and $00002000) then Result:=Result+[rd13];
  if (FValue and $00004000)<>(Value and $00004000) then Result:=Result+[rd14];
  if (FValue and $00008000)<>(Value and $00008000) then Result:=Result+[rd15];
  if (FValue and $00010000)<>(Value and $00010000) then Result:=Result+[rd16];
  if (FValue and $00020000)<>(Value and $00020000) then Result:=Result+[rd17];
  if (FValue and $00040000)<>(Value and $00040000) then Result:=Result+[rd18];
  if (FValue and $00080000)<>(Value and $00080000) then Result:=Result+[rd19];
  if (FValue and $00100000)<>(Value and $00100000) then Result:=Result+[rd20];
  if (FValue and $00200000)<>(Value and $00200000) then Result:=Result+[rd21];
  if (FValue and $00400000)<>(Value and $00400000) then Result:=Result+[rd22];
  if (FValue and $00800000)<>(Value and $00800000) then Result:=Result+[rd23];
  if (FValue and $01000000)<>(Value and $01000000) then Result:=Result+[rd24];
  if (FValue and $02000000)<>(Value and $02000000) then Result:=Result+[rd25];
  if (FValue and $04000000)<>(Value and $04000000) then Result:=Result+[rd26];
  if (FValue and $08000000)<>(Value and $08000000) then Result:=Result+[rd27];
  if (FValue and $10000000)<>(Value and $10000000) then Result:=Result+[rd28];
  if (FValue and $20000000)<>(Value and $20000000) then Result:=Result+[rd29];
  if (FValue and $40000000)<>(Value and $40000000) then Result:=Result+[rd30];
  if (FValue and $80000000)<>(Value and $80000000) then Result:=Result+[rd31];
end;

procedure TDWordBits.SetBits(index: Integer; const Value: Boolean);
begin
  CheckIndex(Index);
  if FBits.Bits[index] = Value then Exit;
  FBits.Bits[index]:= Value;
  case Index of
    0:  if Value then FValue:= FValue or $00000001 else FValue:= FValue xor $00000001;
    1:  if Value then FValue:= FValue or $00000002 else FValue:= FValue xor $00000002;
    2:  if Value then FValue:= FValue or $00000004 else FValue:= FValue xor $00000004;
    3:  if Value then FValue:= FValue or $00000008 else FValue:= FValue xor $00000008;
    4:  if Value then FValue:= FValue or $00000010 else FValue:= FValue xor $00000010;
    5:  if Value then FValue:= FValue or $00000020 else FValue:= FValue xor $00000020;
    6:  if Value then FValue:= FValue or $00000040 else FValue:= FValue xor $00000040;
    7:  if Value then FValue:= FValue or $00000080 else FValue:= FValue xor $00000080;
    8:  if Value then FValue:= FValue or $00000100 else FValue:= FValue xor $00000100;
    9:  if Value then FValue:= FValue or $00000200 else FValue:= FValue xor $00000200;
    10: if Value then FValue:= FValue or $00000400 else FValue:= FValue xor $00000400;
    11: if Value then FValue:= FValue or $00000800 else FValue:= FValue xor $00000800;
    12: if Value then FValue:= FValue or $00001000 else FValue:= FValue xor $00001000;
    13: if Value then FValue:= FValue or $00002000 else FValue:= FValue xor $00002000;
    14: if Value then FValue:= FValue or $00004000 else FValue:= FValue xor $00004000;
    15: if Value then FValue:= FValue or $00008000 else FValue:= FValue xor $00008000;
    16: if Value then FValue:= FValue or $00010000 else FValue:= FValue xor $00010000;
    17: if Value then FValue:= FValue or $00020000 else FValue:= FValue xor $00020000;
    18: if Value then FValue:= FValue or $00040000 else FValue:= FValue xor $00040000;
    19: if Value then FValue:= FValue or $00080000 else FValue:= FValue xor $00080000;
    20: if Value then FValue:= FValue or $00100000 else FValue:= FValue xor $00100000;
    21: if Value then FValue:= FValue or $00200000 else FValue:= FValue xor $00200000;
    22: if Value then FValue:= FValue or $00400000 else FValue:= FValue xor $00400000;
    23: if Value then FValue:= FValue or $00800000 else FValue:= FValue xor $00800000;
    24: if Value then FValue:= FValue or $01000000 else FValue:= FValue xor $01000000;
    25: if Value then FValue:= FValue or $02000000 else FValue:= FValue xor $02000000;
    26: if Value then FValue:= FValue or $04000000 else FValue:= FValue xor $04000000;
    27: if Value then FValue:= FValue or $08000000 else FValue:= FValue xor $08000000;
    28: if Value then FValue:= FValue or $10000000 else FValue:= FValue xor $10000000;
    29: if Value then FValue:= FValue or $20000000 else FValue:= FValue xor $20000000;
    30: if Value then FValue:= FValue or $40000000 else FValue:= FValue xor $40000000;
    31: if Value then FValue:= FValue or $80000000 else FValue:= FValue xor $80000000;
  end;
  OnChangeProc;
end;

procedure TDWordBits.SetValue(const Value: DWORD);
var TempBits : TDWordBitSet;
begin
  if FValue = Value then Exit;
  TempBits:=[];
  TempBits:=GetWordChange(Value);
  if rd0  in TempBits then if ((Value and $00000001)=$00000001) then FBits.Bits[0]:= True else FBits.Bits[0]:= False;
  if rd1  in TempBits then if ((Value and $00000002)=$00000002) then FBits.Bits[1]:= True else FBits.Bits[1]:= False;
  if rd2  in TempBits then if ((Value and $00000004)=$00000004) then FBits.Bits[2]:= True else FBits.Bits[2]:= False;
  if rd3  in TempBits then if ((Value and $00000008)=$00000008) then FBits.Bits[3]:= True else FBits.Bits[3]:= False;
  if rd4  in TempBits then if ((Value and $00000010)=$00000010) then FBits.Bits[4]:= True else FBits.Bits[4]:= False;
  if rd5  in TempBits then if ((Value and $00000020)=$00000020) then FBits.Bits[5]:= True else FBits.Bits[5]:= False;
  if rd6  in TempBits then if ((Value and $00000040)=$00000040) then FBits.Bits[6]:= True else FBits.Bits[6]:= False;
  if rd7  in TempBits then if ((Value and $00000080)=$00000080) then FBits.Bits[7]:= True else FBits.Bits[7]:= False;
  if rd8  in TempBits then if ((Value and $00000100)=$00000100) then FBits.Bits[8]:= True else FBits.Bits[8]:= False;
  if rd9  in TempBits then if ((Value and $00000200)=$00000200) then FBits.Bits[9]:= True else FBits.Bits[9]:= False;
  if rd10 in TempBits then if ((Value and $00000400)=$00000400) then FBits.Bits[10]:= True else FBits.Bits[10]:= False;
  if rd11 in TempBits then if ((Value and $00000800)=$00000800) then FBits.Bits[11]:= True else FBits.Bits[11]:= False;
  if rd12 in TempBits then if ((Value and $00001000)=$00001000) then FBits.Bits[12]:= True else FBits.Bits[12]:= False;
  if rd13 in TempBits then if ((Value and $00002000)=$00002000) then FBits.Bits[13]:= True else FBits.Bits[13]:= False;
  if rd14 in TempBits then if ((Value and $00004000)=$00004000) then FBits.Bits[14]:= True else FBits.Bits[14]:= False;
  if rd15 in TempBits then if ((Value and $00008000)=$00008000) then FBits.Bits[15]:= True else FBits.Bits[15]:= False;
  if rd16 in TempBits then if ((Value and $00010000)=$00010000) then FBits.Bits[16]:= True else FBits.Bits[16]:= False;
  if rd17 in TempBits then if ((Value and $00020000)=$00020000) then FBits.Bits[17]:= True else FBits.Bits[17]:= False;
  if rd18 in TempBits then if ((Value and $00040000)=$00040000) then FBits.Bits[18]:= True else FBits.Bits[18]:= False;
  if rd19 in TempBits then if ((Value and $00080000)=$00080000) then FBits.Bits[19]:= True else FBits.Bits[19]:= False;
  if rd20 in TempBits then if ((Value and $00100000)=$00100000) then FBits.Bits[20]:= True else FBits.Bits[20]:= False;
  if rd21 in TempBits then if ((Value and $00200000)=$00200000) then FBits.Bits[21]:= True else FBits.Bits[21]:= False;
  if rd22 in TempBits then if ((Value and $00400000)=$00400000) then FBits.Bits[22]:= True else FBits.Bits[22]:= False;
  if rd23 in TempBits then if ((Value and $00800000)=$00800000) then FBits.Bits[23]:= True else FBits.Bits[23]:= False;
  if rd24 in TempBits then if ((Value and $01000000)=$01000000) then FBits.Bits[24]:= True else FBits.Bits[24]:= False;
  if rd25 in TempBits then if ((Value and $02000000)=$02000000) then FBits.Bits[25]:= True else FBits.Bits[25]:= False;
  if rd26 in TempBits then if ((Value and $04000000)=$04000000) then FBits.Bits[26]:= True else FBits.Bits[26]:= False;
  if rd27 in TempBits then if ((Value and $08000000)=$08000000) then FBits.Bits[27]:= True else FBits.Bits[27]:= False;
  if rd28 in TempBits then if ((Value and $10000000)=$10000000) then FBits.Bits[28]:= True else FBits.Bits[28]:= False;
  if rd29 in TempBits then if ((Value and $20000000)=$20000000) then FBits.Bits[29]:= True else FBits.Bits[29]:= False;
  if rd30 in TempBits then if ((Value and $40000000)=$40000000) then FBits.Bits[30]:= True else FBits.Bits[30]:= False;
  if rd31 in TempBits then if ((Value and $80000000)=$80000000) then FBits.Bits[31]:= True else FBits.Bits[31]:= False;
  FValue:=Value;
  OnChangeProc;
end;

end.