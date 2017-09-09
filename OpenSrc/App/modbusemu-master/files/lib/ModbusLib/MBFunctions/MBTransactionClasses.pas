unit MBTransactionClasses;

{$mode objfpc}{$H+}

interface

uses
     MBTransactionBase,
     MBBuilderBase,
     MBReaderPacketClasses,MBBuilderPacketClasses;

type
   TTransactionMB = class(TTransactionBase)
    private
     function GetDeviceNumber: Byte;
     function GetFunctionNum: Byte;
    public
     procedure Init; override;
     property DeviceNumber : Byte read GetDeviceNumber;
     property FunctionNum  : Byte read GetFunctionNum;
   end;

   TTransactionMBF1 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF1Packet;
     function GetBuilder: TBuilderMBF1Request;
    public
     constructor Create(ABuilder : TBuilderMBF1Request; AReader : TReaderMBF1Packet); reintroduce;
     property Reader  : TReaderMBF1Packet read GetReder;
     property Builder : TBuilderMBF1Request read GetBuilder;
   end;

   TTransactionMBF2 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF2Packet;
     function GetBuilder: TBuilderMBF2Request;
    public
     constructor Create(ABuilder : TBuilderMBF2Request; AReader : TReaderMBF2Packet); reintroduce;
     property Reader  : TReaderMBF2Packet read GetReder;
     property Builder : TBuilderMBF2Request read GetBuilder;
   end;

   TTransactionMBF3 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF3Packet;
     function GetBuilder: TBuilderMBF3Request;
    public
     constructor Create(ABuilder : TBuilderMBF3Request; AReader : TReaderMBF3Packet); reintroduce;
     property Reader  : TReaderMBF3Packet read GetReder;
     property Builder : TBuilderMBF3Request read GetBuilder;
   end;

   TTransactionMBF4 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF4Packet;
     function GetBuilder: TBuilderMBF4Request;
    public
     constructor Create(ABuilder : TBuilderMBF4Request; AReader : TReaderMBF4Packet); reintroduce;
     property Reader  : TReaderMBF4Packet read GetReder;
     property Builder : TBuilderMBF4Request read GetBuilder;
   end;

   TTransactionMBF5 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF5Packet;
     function GetBuilder: TBuilderMBF5Request;
    public
     constructor Create(ABuilder : TBuilderMBF5Request; AReader : TReaderMBF5Packet); reintroduce;
     property Reader  : TReaderMBF5Packet read GetReder;
     property Builder : TBuilderMBF5Request read GetBuilder;
   end;

   TTransactionMBF6 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF6Packet;
     function GetBuilder: TBuilderMBF6Request;
    public
     constructor Create(ABuilder : TBuilderMBF6Request; AReader : TReaderMBF6Packet); reintroduce;
     property Reader  : TReaderMBF6Packet read GetReder;
     property Builder : TBuilderMBF6Request read GetBuilder;
   end;

   TTransactionMBF7 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF7Packet;
     function GetBuilder: TBuilderMBF7Request;
    public
     constructor Create(ABuilder : TBuilderMBF7Request; AReader : TReaderMBF7Packet); reintroduce;
     property Reader  : TReaderMBF7Packet read GetReder;
     property Builder : TBuilderMBF7Request read GetBuilder;
   end;

   TTransactionMBF8 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF8Packet;
     function GetBuilder: TBuilderMBF8Request;
    public
     constructor Create(ABuilder : TBuilderMBF8Request; AReader : TReaderMBF8Packet); reintroduce;
     property Reader  : TReaderMBF8Packet read GetReder;
     property Builder : TBuilderMBF8Request read GetBuilder;
   end;

   TTransactionMBF11 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF11Packet;
     function GetBuilder: TBuilderMBF11Request;
    public
     constructor Create(ABuilder : TBuilderMBF11Request; AReader : TReaderMBF11Packet); reintroduce;
     property Reader  : TReaderMBF11Packet read GetReder;
     property Builder : TBuilderMBF11Request read GetBuilder;
   end;

   TTransactionMBF12 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF12Packet;
     function GetBuilder: TBuilderMBF12Request;
    public
     constructor Create(ABuilder : TBuilderMBF12Request; AReader : TReaderMBF12Packet); reintroduce;
     property Reader  : TReaderMBF12Packet read GetReder;
     property Builder : TBuilderMBF12Request read GetBuilder;
   end;

   TTransactionMBF15 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF15Packet;
     function GetBuilder: TBuilderMBF15Request;
    public
     constructor Create(ABuilder : TBuilderMBF15Request; AReader : TReaderMBF15Packet); reintroduce;
     property Reader  : TReaderMBF15Packet read GetReder;
     property Builder : TBuilderMBF15Request read GetBuilder;
   end;

   TTransactionMBF16 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF16Packet;
     function GetBuilder: TBuilderMBF16Request;
    public
     constructor Create(ABuilder : TBuilderMBF16Request; AReader : TReaderMBF16Packet); reintroduce;
     property Reader  : TReaderMBF16Packet read GetReder;
     property Builder : TBuilderMBF16Request read GetBuilder;
   end;

   TTransactionMBF17 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF17Packet;
     function GetBuilder: TBuilderMBF17Request;
    public
     constructor Create(ABuilder : TBuilderMBF17Request; AReader : TReaderMBF17Packet); reintroduce;
     property Reader  : TReaderMBF17Packet read GetReder;
     property Builder : TBuilderMBF17Request read GetBuilder;
   end;

   TTransactionMBF20 = class(TObject)

   end;

   TTransactionMBF21 = class(TObject)

   end;

   TTransactionMBF22 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF22Packet;
     function GetBuilder: TBuilderMBF22Request;
    public
     constructor Create(ABuilder : TBuilderMBF22Request; AReader : TReaderMBF22Packet); reintroduce;
     property Reader  : TReaderMBF22Packet read GetReder;
     property Builder : TBuilderMBF22Request read GetBuilder;
   end;

   TTransactionMBF23 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF23Packet;
     function GetBuilder: TBuilderMBF23Request;
    public
     constructor Create(ABuilder : TBuilderMBF23Request; AReader : TReaderMBF23Packet); reintroduce;
     property Reader  : TReaderMBF23Packet read GetReder;
     property Builder : TBuilderMBF23Request read GetBuilder;
   end;

   TTransactionMBF24 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF24Packet;
     function GetBuilder: TBuilderMBF24Request;
    public
     constructor Create(ABuilder : TBuilderMBF24Request; AReader : TReaderMBF24Packet); reintroduce;
     property Reader  : TReaderMBF24Packet read GetReder;
     property Builder : TBuilderMBF24Request read GetBuilder;
   end;

   TTransactionMBF43 = class(TTransactionMB)
    private
     function GetReder: TReaderMBF43Packet;
     function GetBuilder: TBuilderMBF43Request;
    public
     constructor Create(ABuilder : TBuilderMBF43Request; AReader : TReaderMBF43Packet); reintroduce;
     property Reader  : TReaderMBF43Packet read GetReder;
     property Builder : TBuilderMBF43Request read GetBuilder;
   end;

implementation

uses SysUtils,
     MBResourceString;

{ TTransactionMB }

function TTransactionMB.GetDeviceNumber: Byte;
begin
  if Builder = nil then raise Exception.Create(ERR_TRANS_INIT);
  Result:=TBuilderMBPacket(Builder).DeviceAddress;
end;

function TTransactionMB.GetFunctionNum: Byte;
begin
 if Builder = nil then raise Exception.Create(ERR_TRANS_INIT);
 Result:=TBuilderMBPacket(Builder).FunctionNum;
end;

procedure TTransactionMB.Init;
begin
  if (Builder=nil) or (Reader=nil) then raise Exception.Create(ERR_TRANS_INIT);
  TReaderMBPacket(Reader).SourceDevice:=TBuilderMBPacket(Builder).DeviceAddress;
  //TReaderMBPacket(Reader).SourceFunction:=TBuilderMBPacket(Builder).FunctionNum;
  Builder.Build;
end;

{ TTransactionMBF1 }

constructor TTransactionMBF1.Create(ABuilder: TBuilderMBF1Request; AReader: TReaderMBF1Packet);
begin
  inherited Create(ABuilder,AReader);
end;

function TTransactionMBF1.GetBuilder: TBuilderMBF1Request;
begin
  Result:= TBuilderMBF1Request(inherited Builder);
end;

function TTransactionMBF1.GetReder: TReaderMBF1Packet;
begin
  Result:= TReaderMBF1Packet(inherited Reader);
end;

{ TTransactionMBF3 }

constructor TTransactionMBF3.Create(ABuilder: TBuilderMBF3Request; AReader: TReaderMBF3Packet);
begin
  inherited Create(ABuilder,AReader);
end;

function TTransactionMBF3.GetBuilder: TBuilderMBF3Request;
begin
  Result:= TBuilderMBF3Request(inherited Builder);
end;

function TTransactionMBF3.GetReder: TReaderMBF3Packet;
begin
  Result:= TReaderMBF3Packet(inherited Reader);
end;

{ TTransactionMBF5 }

constructor TTransactionMBF5.Create(ABuilder: TBuilderMBF5Request; AReader: TReaderMBF5Packet);
begin
  inherited Create(ABuilder,AReader);
end;

function TTransactionMBF5.GetBuilder: TBuilderMBF5Request;
begin
  Result:= TBuilderMBF5Request(inherited Builder);
end;

function TTransactionMBF5.GetReder: TReaderMBF5Packet;
begin
  Result:= TReaderMBF5Packet(inherited Reader);
end;

{ TTransactionMBF6 }

constructor TTransactionMBF6.Create(ABuilder: TBuilderMBF6Request; AReader: TReaderMBF6Packet);
begin
  inherited Create(ABuilder,AReader);
end;

function TTransactionMBF6.GetBuilder: TBuilderMBF6Request;
begin
  Result:= TBuilderMBF6Request(inherited Builder);
end;

function TTransactionMBF6.GetReder: TReaderMBF6Packet;
begin
  Result:= TReaderMBF6Packet(inherited Reader);
end;

{ TTransactionMBF8 }

constructor TTransactionMBF8.Create(ABuilder: TBuilderMBF8Request; AReader: TReaderMBF8Packet);
begin
  inherited Create(ABuilder,AReader);
end;

function TTransactionMBF8.GetBuilder: TBuilderMBF8Request;
begin
  Result:= TBuilderMBF8Request(inherited Builder);
end;

function TTransactionMBF8.GetReder: TReaderMBF8Packet;
begin
  Result:= TReaderMBF8Packet(inherited Reader);
end;

{ TTransactionMBF7 }

constructor TTransactionMBF7.Create(ABuilder: TBuilderMBF7Request; AReader: TReaderMBF7Packet);
begin
 inherited Create(ABuilder,AReader);
end;

function TTransactionMBF7.GetBuilder: TBuilderMBF7Request;
begin
  Result:= TBuilderMBF7Request(inherited Builder);
end;

function TTransactionMBF7.GetReder: TReaderMBF7Packet;
begin
  Result:= TReaderMBF7Packet(inherited Reader);
end;

{ TTransactionMBF11 }

constructor TTransactionMBF11.Create(ABuilder: TBuilderMBF11Request; AReader: TReaderMBF11Packet);
begin
 inherited Create(ABuilder,AReader);
end;

function TTransactionMBF11.GetBuilder: TBuilderMBF11Request;
begin
  Result:= TBuilderMBF11Request(inherited Builder);
end;

function TTransactionMBF11.GetReder: TReaderMBF11Packet;
begin
  Result:= TReaderMBF11Packet(inherited Reader);
end;

{ TTransactionMBF12 }

constructor TTransactionMBF12.Create(ABuilder: TBuilderMBF12Request; AReader: TReaderMBF12Packet);
begin
 inherited Create(ABuilder,AReader);
end;

function TTransactionMBF12.GetBuilder: TBuilderMBF12Request;
begin
  Result:= TBuilderMBF12Request(inherited Builder);
end;

function TTransactionMBF12.GetReder: TReaderMBF12Packet;
begin
  Result:= TReaderMBF12Packet(inherited Reader);
end;

{ TTransactionMBF15 }

constructor TTransactionMBF15.Create(ABuilder: TBuilderMBF15Request; AReader: TReaderMBF15Packet);
begin
  inherited Create(ABuilder,AReader);
end;

function TTransactionMBF15.GetBuilder: TBuilderMBF15Request;
begin
  Result:= TBuilderMBF15Request(inherited Builder);
end;

function TTransactionMBF15.GetReder: TReaderMBF15Packet;
begin
  Result:= TReaderMBF15Packet(inherited Reader);
end;

{ TTransactionMBF16 }

constructor TTransactionMBF16.Create(ABuilder: TBuilderMBF16Request; AReader: TReaderMBF16Packet);
begin
 inherited Create(ABuilder,AReader);
end;

function TTransactionMBF16.GetBuilder: TBuilderMBF16Request;
begin
  Result:= TBuilderMBF16Request(inherited Builder);
end;

function TTransactionMBF16.GetReder: TReaderMBF16Packet;
begin
  Result:= TReaderMBF16Packet(inherited Reader);
end;

{ TTransactionMBF17 }

constructor TTransactionMBF17.Create(ABuilder: TBuilderMBF17Request; AReader: TReaderMBF17Packet);
begin
  inherited Create(ABuilder,GetReder);
end;

function TTransactionMBF17.GetBuilder: TBuilderMBF17Request;
begin
  Result:= TBuilderMBF17Request(inherited Builder);
end;

function TTransactionMBF17.GetReder: TReaderMBF17Packet;
begin
  Result:= TReaderMBF17Packet(inherited Reader);
end;

{ TTransactionMBF22 }

constructor TTransactionMBF22.Create(ABuilder: TBuilderMBF22Request; AReader: TReaderMBF22Packet);
begin
  inherited Create(ABuilder,AReader);
end;

function TTransactionMBF22.GetBuilder: TBuilderMBF22Request;
begin
  Result:= TBuilderMBF22Request(inherited Builder);
end;

function TTransactionMBF22.GetReder: TReaderMBF22Packet;
begin
  Result:= TReaderMBF22Packet(inherited Reader);
end;

{ TTransactionMBF23 }

constructor TTransactionMBF23.Create(ABuilder: TBuilderMBF23Request; AReader: TReaderMBF23Packet);
begin
  inherited Create(ABuilder,AReader);
end;

function TTransactionMBF23.GetBuilder: TBuilderMBF23Request;
begin
  Result:= TBuilderMBF23Request(inherited Builder);
end;

function TTransactionMBF23.GetReder: TReaderMBF23Packet;
begin
  Result:= TReaderMBF23Packet(inherited Reader);
end;

{ TTransactionMBF24 }

constructor TTransactionMBF24.Create(ABuilder: TBuilderMBF24Request; AReader: TReaderMBF24Packet);
begin
 inherited Create(ABuilder,AReader);
end;

function TTransactionMBF24.GetBuilder: TBuilderMBF24Request;
begin
  Result:= TBuilderMBF24Request(inherited Builder);
end;

function TTransactionMBF24.GetReder: TReaderMBF24Packet;
begin
  Result:= TReaderMBF24Packet(inherited Reader);
end;

{ TTransactionMBF43 }

constructor TTransactionMBF43.Create(ABuilder: TBuilderMBF43Request; AReader: TReaderMBF43Packet);
begin
  inherited Create(ABuilder,AReader);
end;

function TTransactionMBF43.GetBuilder: TBuilderMBF43Request;
begin
  Result:= TBuilderMBF43Request(inherited Builder);
end;

function TTransactionMBF43.GetReder: TReaderMBF43Packet;
begin
  Result:= TReaderMBF43Packet(inherited Reader);
end;

{ TTransactionMBF2 }

constructor TTransactionMBF2.Create(ABuilder: TBuilderMBF2Request; AReader: TReaderMBF2Packet);
begin
  inherited Create(ABuilder,AReader);
end;

function TTransactionMBF2.GetBuilder: TBuilderMBF2Request;
begin
  Result:= TBuilderMBF2Request(inherited Builder);
end;

function TTransactionMBF2.GetReder: TReaderMBF2Packet;
begin
  Result:= TReaderMBF2Packet(inherited Reader);
end;

{ TTransactionMBF4 }

constructor TTransactionMBF4.Create(ABuilder: TBuilderMBF4Request; AReader: TReaderMBF4Packet);
begin
  inherited Create(ABuilder,AReader);
end;

function TTransactionMBF4.GetBuilder: TBuilderMBF4Request;
begin
  Result:= TBuilderMBF4Request(inherited Builder);
end;

function TTransactionMBF4.GetReder: TReaderMBF4Packet;
begin
  Result:= TReaderMBF4Packet(inherited Reader);
end;

end.
