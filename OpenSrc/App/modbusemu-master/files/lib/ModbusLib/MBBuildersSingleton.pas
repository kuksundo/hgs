unit MBBuildersSingleton;

{$mode objfpc}{$H+}

interface

uses MBRequestParamCalsses,
     MBInterfaces;

type
 // Modbus TCP поддерживаются функции: 1,2,3,4,5,6,15,16,20,21,22,23,24,43,43/13,43/14
 // Modbus RTU поддержифаются функции: все Modbus TCP,7,8,11,12,17
 TMBBuildersSingleton = class
  protected
    constructor Create; reintroduce;
    destructor  Destroy; override;
  public
   class function GetMBRTUBuilder(Params : TMBRTUParams): IBuilderPacket;
   class function GetMBTCPBuilder(Params : TMBTCPParams): IBuilderPacket;
 end;

implementation

uses MBBuilderRTUPacketClasses, MBBuilderTCPPacketClasses,
     MBBuilderPacketClasses, MBRequestTypes, SysUtils;

var RTUF1Builder   : TBuilderMBF1Request;
    RTUF2Builder   : TBuilderMBF2Request;
    RTUF3Builder   : TBuilderMBF3Request;
    RTUF4Builder   : TBuilderMBF4Request;
    RTUF5Builder   : TBuilderMBF5Request;
    RTUF6Builder   : TBuilderMBF6Request;
    RTUF7Builder   : TBuilderMBF7Request;
    RTUF8Builder   : TBuilderMBF8Request;
    RTUF11Builder  : TBuilderMBF11Request;
    RTUF12Builder  : TBuilderMBF12Request;
    RTUF15Builder  : TBuilderMBF15Request;
    RTUF16Builder  : TBuilderMBF16Request;
    RTUF17Builder  : TBuilderMBF17Request;
    RTUF20Builder  : TBuilderMBF20Request;
    RTUF21Builder  : TBuilderMBF21Request;
    RTUF22Builder  : TBuilderMBF22Request;
    RTUF23Builder  : TBuilderMBF23Request;
    RTUF24Builder  : TBuilderMBF24Request;
    RTUF43Builder  : TBuilderMBF43Request;
    RTUF72Builder  : TBuilderMBF72Request;
    RTUF110Builder : TBuilderMBF110Request;

    TCPF1Builder   : TBuilderMBTCPF1Request;
    TCPF2Builder   : TBuilderMBTCPF2Request;
    TCPF3Builder   : TBuilderMBTCPF3Request;
    TCPF4Builder   : TBuilderMBTCPF4Request;
    TCPF5Builder   : TBuilderMBTCPF5Request;
    TCPF6Builder   : TBuilderMBTCPF6Request;
    TCPF15Builder  : TBuilderMBTCPF15Request;
    TCPF16Builder  : TBuilderMBTCPF16Request;
    TCPF20Builder  : TBuilderMBTCPF20Request;
    TCPF21Builder  : TBuilderMBTCPF21Request;
    TCPF22Builder  : TBuilderMBTCPF22Request;
    TCPF23Builder  : TBuilderMBTCPF23Request;
    TCPF24Builder  : TBuilderMBTCPF24Request;
    TCPF43Builder  : TBuilderMBTCPF43Request;
    TCPF72Builder  : TBuilderMBTCPF72Request;
    TCPF110Builder : TBuilderMBTCPF110Request;

procedure InitRTUBuilders;
begin
  RTUF1Builder   := TBuilderMBF1Request.Create(nil);
  RTUF2Builder   := TBuilderMBF2Request.Create(nil);
  RTUF3Builder   := TBuilderMBF3Request.Create(nil);
  RTUF4Builder   := TBuilderMBF4Request.Create(nil);
  RTUF5Builder   := TBuilderMBF5Request.Create(nil);
  RTUF6Builder   := TBuilderMBF6Request.Create(nil);
  RTUF7Builder   := TBuilderMBF7Request.Create(nil);
  RTUF8Builder   := TBuilderMBF8Request.Create(nil);
  RTUF11Builder  := TBuilderMBF11Request.Create(nil);
  RTUF12Builder  := TBuilderMBF12Request.Create(nil);
  RTUF15Builder  := TBuilderMBF15Request.Create(nil);
  RTUF16Builder  := TBuilderMBF16Request.Create(nil);
  RTUF17Builder  := TBuilderMBF17Request.Create(nil);
  RTUF20Builder  := nil;//TBuilderMBF20Request.Create(nil);
  RTUF21Builder  := nil;//TBuilderMBF21Request.Create(nil);
  RTUF22Builder  := TBuilderMBF22Request.Create(nil);
  RTUF23Builder  := TBuilderMBF23Request.Create(nil);
  RTUF24Builder  := TBuilderMBF24Request.Create(nil);
  RTUF43Builder  := TBuilderMBF43Request.Create(nil);
  RTUF72Builder  := TBuilderMBF72Request.Create(nil);
  RTUF110Builder := TBuilderMBF110Request.Create(nil);
end;

procedure InitTCPBuilders;
begin
  TCPF1Builder   := TBuilderMBTCPF1Request.Create(nil);
  TCPF2Builder   := TBuilderMBTCPF2Request.Create(nil);
  TCPF3Builder   := TBuilderMBTCPF3Request.Create(nil);
  TCPF4Builder   := TBuilderMBTCPF4Request.Create(nil);
  TCPF5Builder   := TBuilderMBTCPF5Request.Create(nil);
  TCPF6Builder   := TBuilderMBTCPF6Request.Create(nil);
  TCPF15Builder  := TBuilderMBTCPF15Request.Create(nil);
  TCPF16Builder  := TBuilderMBTCPF16Request.Create(nil);
  TCPF20Builder  := TBuilderMBTCPF20Request.Create(nil);
  TCPF21Builder  := TBuilderMBTCPF21Request.Create(nil);
  TCPF22Builder  := TBuilderMBTCPF22Request.Create(nil);
  TCPF23Builder  := TBuilderMBTCPF23Request.Create(nil);
  TCPF24Builder  := TBuilderMBTCPF24Request.Create(nil);
  TCPF43Builder  := TBuilderMBTCPF43Request.Create(nil);
  TCPF72Builder  := TBuilderMBTCPF72Request.Create(nil);
  TCPF110Builder := TBuilderMBTCPF110Request.Create(nil);
end;

procedure DestroyRTUBuilders;
begin
  FreeAndNil(RTUF1Builder);
  FreeAndNil(RTUF2Builder);
  FreeAndNil(RTUF3Builder);
  FreeAndNil(RTUF4Builder);
  FreeAndNil(RTUF5Builder);
  FreeAndNil(RTUF6Builder);
  FreeAndNil(RTUF7Builder);
  FreeAndNil(RTUF8Builder);
  FreeAndNil(RTUF11Builder);
  FreeAndNil(RTUF12Builder);
  FreeAndNil(RTUF15Builder);
  FreeAndNil(RTUF16Builder);
  FreeAndNil(RTUF17Builder);
  FreeAndNil(RTUF20Builder);
  FreeAndNil(RTUF21Builder);
  FreeAndNil(RTUF22Builder);
  FreeAndNil(RTUF23Builder);
  FreeAndNil(RTUF24Builder);
  FreeAndNil(RTUF43Builder);
  FreeAndNil(RTUF72Builder);
  FreeAndNil(RTUF110Builder);
end;

procedure DestroyTCPBuilders;
begin
  FreeAndNil(TCPF1Builder);
  FreeAndNil(TCPF2Builder);
  FreeAndNil(TCPF3Builder);
  FreeAndNil(TCPF4Builder);
  FreeAndNil(TCPF5Builder);
  FreeAndNil(TCPF6Builder);
  FreeAndNil(TCPF15Builder);
  FreeAndNil(TCPF16Builder);
  FreeAndNil(TCPF20Builder);
  FreeAndNil(TCPF21Builder);
  FreeAndNil(TCPF22Builder);
  FreeAndNil(TCPF23Builder);
  FreeAndNil(TCPF24Builder);
  FreeAndNil(TCPF43Builder);
  FreeAndNil(TCPF72Builder);
  FreeAndNil(TCPF110Builder);
end;

{ TMBBuildersSingleton }

constructor TMBBuildersSingleton.Create;
begin
  // заглушка
end;

destructor TMBBuildersSingleton.Destroy;
begin
  // заглушка
  inherited;
end;

class function TMBBuildersSingleton.GetMBRTUBuilder(Params: TMBRTUParams): IBuilderPacket;
var TempByteArray : TMBRTUDataArray;
begin
  Result := nil;
  case Params.MBFunction of
   1   : begin
           if (Params.MBDevID<>RTUF1Builder.DeviceAddress) or
              (Params.MBStartReg<>RTUF1Builder.StartingAddress) or
              (Params.MBRegcount<>RTUF1Builder.Quantity) or
              (RTUF1Builder.LenPacket = 0) then
            begin
             RTUF1Builder.DeviceAddress   := Params.MBDevID;
             RTUF1Builder.StartingAddress := Params.MBStartReg;
             RTUF1Builder.Quantity        := Params.MBRegcount;
             RTUF1Builder.Build;
            end;
           Result := RTUF1Builder as IBuilderPacket;
         end;
   2   : begin
           if (Params.MBDevID<>RTUF2Builder.DeviceAddress) or
              (Params.MBStartReg<>RTUF2Builder.StartingAddress) or
              (Params.MBRegcount<>RTUF2Builder.Quantity) or
              (RTUF2Builder.LenPacket = 0) then
            begin
             RTUF2Builder.DeviceAddress   := Params.MBDevID;
             RTUF2Builder.StartingAddress := Params.MBStartReg;
             RTUF2Builder.Quantity        := Params.MBRegcount;
             RTUF2Builder.Build;
            end;
           Result := RTUF2Builder as IBuilderPacket;
         end;
   3   : begin
           if (Params.MBDevID<>RTUF3Builder.DeviceAddress) or
              (Params.MBStartReg<>RTUF3Builder.StartingAddress) or
              (Params.MBRegcount<>RTUF3Builder.Quantity) or
              (RTUF3Builder.LenPacket = 0) then
            begin
             RTUF3Builder.DeviceAddress   := Params.MBDevID;
             RTUF3Builder.StartingAddress := Params.MBStartReg;
             RTUF3Builder.Quantity        := Params.MBRegcount;
             RTUF3Builder.Build;
            end;
           Result := RTUF3Builder as IBuilderPacket;
         end;
   4   : begin
           if (Params.MBDevID<>RTUF4Builder.DeviceAddress) or
              (Params.MBStartReg<>RTUF4Builder.StartingAddress) or
              (Params.MBRegcount<>RTUF4Builder.Quantity) or
              (RTUF4Builder.LenPacket = 0) then
            begin
             RTUF4Builder.DeviceAddress   := Params.MBDevID;
             RTUF4Builder.StartingAddress := Params.MBStartReg;
             RTUF4Builder.Quantity        := Params.MBRegcount;
             RTUF4Builder.Build;
            end;
           Result := RTUF4Builder as IBuilderPacket;
         end;
   5   : begin
           if (Params.MBDevID<>RTUF5Builder.DeviceAddress) or
              (Params.MBStartReg<>RTUF5Builder.OutputAddress) or
              (Boolean(Params.MBRegcount)<>RTUF5Builder.OutputValue) or
              (RTUF5Builder.LenPacket = 0) then
            begin
             RTUF5Builder.DeviceAddress := Params.MBDevID;
             RTUF5Builder.OutputAddress := Params.MBStartReg;
             RTUF5Builder.OutputValue   := Boolean(Params.MBRegcount);
             RTUF5Builder.Build;
            end;
           Result := RTUF5Builder as IBuilderPacket;
         end;
   6   : begin
           if (Params.MBDevID<>RTUF6Builder.DeviceAddress) or
              (Params.MBStartReg<>RTUF6Builder.RegisterAddress) or
              (Params.MBRegcount<>RTUF6Builder.RegisterValue) or
              (RTUF6Builder.LenPacket = 0) then
            begin
             RTUF6Builder.DeviceAddress   := Params.MBDevID;
             RTUF6Builder.RegisterAddress := Params.MBStartReg;
             RTUF6Builder.RegisterValue   := Params.MBRegcount;
             RTUF6Builder.Build;
            end;
           Result := RTUF6Builder as IBuilderPacket;
         end;
   7   : begin
           if (Params.MBDevID<>RTUF7Builder.DeviceAddress) or
              (RTUF7Builder.LenPacket = 0) then
            begin
             RTUF7Builder.DeviceAddress   := Params.MBDevID;
             RTUF7Builder.Build;
            end;
           Result := RTUF7Builder as IBuilderPacket;
         end;
   8   : begin
           if (Params.MBDevID<>RTUF8Builder.DeviceAddress) or
              (Params.SubFunction<>Byte(RTUF8Builder.SubFunctionNum)) or
              (RTUF8Builder.LenPacket = 0) then
            begin
             RTUF8Builder.DeviceAddress   := Params.MBDevID;
             RTUF8Builder.SubFunctionNum  := TMBF8SubfunctionType(Params.SubFunction);
             case Params.SubFunction of
              0 : RTUF8Builder.Sub_00_LoopBackData := Params.Sub00F8;
              1 : RTUF8Builder.Sub_01_RestartData  := Params.Sub01F8;
              3 : RTUF8Builder.Sub_03_Char         := Params.Sub03F8;
             end;
             RTUF8Builder.Build;
            end;
           Result := RTUF8Builder as IBuilderPacket;
         end;
   11  : begin
           if (Params.MBDevID<>RTUF11Builder.DeviceAddress) or
              (RTUF11Builder.LenPacket = 0) then
            begin
             RTUF11Builder.DeviceAddress   := Params.MBDevID;
             RTUF11Builder.Build;
            end;
           Result := RTUF11Builder as IBuilderPacket;
         end;
   12  : begin
           if (Params.MBDevID<>RTUF12Builder.DeviceAddress) or
              (RTUF12Builder.LenPacket = 0) then
            begin
             RTUF12Builder.DeviceAddress   := Params.MBDevID;
             RTUF12Builder.Build;
            end;
           Result := RTUF12Builder as IBuilderPacket;
         end;
   15  : begin
           if (Params.MBDevID<>RTUF15Builder.DeviceAddress) or
              (not RTUF15Builder.AreEquivalent(Params.DataBits)) or
              (RTUF15Builder.LenPacket = 0) then
            begin
             RTUF15Builder.DeviceAddress   := Params.MBDevID;
             RTUF15Builder.StartingAddress := Params.MBStartReg;
             RTUF15Builder.Assign(Params.DataBits);
             RTUF15Builder.Build;
            end;
           Result := RTUF15Builder as IBuilderPacket;
         end;
   16  : begin
           TempByteArray := Params.GetDataArray;
           if Length(TempByteArray) = 0 then Exit;
           if (RTUF16Builder.DeviceAddress   <> Params.MBDevID) or
              (RTUF16Builder.StartingAddress <> Params.MBStartReg) or
              (RTUF16Builder.Quantity        <> Params.MBRegcount) or
              (not RTUF16Builder.AreEquivalent(Params.GetDataArray)) or
              (RTUF16Builder.LenPacket = 0) then
            begin
             RTUF16Builder.DeviceAddress   := Params.MBDevID;
             RTUF16Builder.StartingAddress := Params.MBStartReg;
             RTUF16Builder.Quantity        := Params.MBRegcount;
             RTUF16Builder.Assign(TempByteArray);
             RTUF16Builder.Build;
             SetLength(TempByteArray,0);
            end;
           Result := RTUF16Builder as IBuilderPacket;
         end;
   17  : begin
           if (Params.MBDevID<>RTUF17Builder.DeviceAddress) or
              (RTUF17Builder.LenPacket = 0) then
            begin
             RTUF17Builder.DeviceAddress   := Params.MBDevID;
             RTUF17Builder.Build;
            end;
           Result := RTUF17Builder as IBuilderPacket;
         end;
   20  : begin

           Result := nil;
         end;
   21  : begin

           Result := nil;
         end;
   22  : begin
           if (RTUF22Builder.DeviceAddress <> Params.MBDevID) or
              (RTUF22Builder.ReferenceAddress <> Params.MBStartReg) or
              (RTUF22Builder.AndMask <> Params.MBRegcount) or
              (RTUF22Builder.OrMask <> Params.MBORMask) or
              (RTUF22Builder.LenPacket = 0) then
            begin
             RTUF22Builder.DeviceAddress    := Params.MBDevID;
             RTUF22Builder.ReferenceAddress := Params.MBStartReg;
             RTUF22Builder.AndMask          := Params.MBRegcount;
             RTUF22Builder.OrMask           := Params.MBORMask;
             RTUF22Builder.Build;
            end;

           Result := RTUF22Builder as IBuilderPacket;
         end;
   23  : begin
           TempByteArray := Params.GetDataArray;
           if (RTUF23Builder.DeviceAddress <> Params.MBDevID) or
              (RTUF23Builder.ReadStartAddress <> Params.MBStartReg) or
              (RTUF23Builder.ReadQuantity <> Params.MBRegcount) or
              (RTUF23Builder.WriteStartAddress <> Params.MBORMask) or
              (RTUF23Builder.WriteQuantity <> Params.MBQuantityWr) or
              (not RTUF23Builder.AreEquivalent(TempByteArray)) or
              (RTUF23Builder.LenPacket = 0) then
            begin
             RTUF23Builder.DeviceAddress     := Params.MBDevID;
             RTUF23Builder.ReadStartAddress  := Params.MBStartReg;
             RTUF23Builder.ReadQuantity      := Params.MBRegcount;
             RTUF23Builder.WriteStartAddress := Params.MBORMask;
             RTUF23Builder.WriteQuantity     := Params.MBQuantityWr;
             RTUF23Builder.Assign(TempByteArray);
             RTUF23Builder.Build;
             SetLength(TempByteArray,0);
            end;

           Result := RTUF23Builder as IBuilderPacket;
         end;
   24  : begin
           if (RTUF24Builder.DeviceAddress <> Params.MBDevID) or
              (RTUF24Builder.FIFOPointerAddress <> Params.MBStartReg) or
              (RTUF24Builder.LenPacket = 0) then
            begin
             RTUF24Builder.DeviceAddress      := Params.MBDevID;
             RTUF24Builder.FIFOPointerAddress := Params.MBStartReg;
             RTUF24Builder.Build;
            end;

           Result := RTUF24Builder as IBuilderPacket;
         end;
   43  : begin
           case Params.MBMEIType of
           mei13 : begin
                    Result := nil;
                   end;
           mei14 : begin
                    if (RTUF43Builder.DeviceAddress <> Params.MBDevID) or
                       (RTUF43Builder.ReadDeviceIDCode <> Params.MBReadDevID) or
                       (RTUF43Builder.ObjectID <> Params.MBObjectID) or
                       (RTUF43Builder.LenPacket = 0) then
                     begin
                      RTUF43Builder.DeviceAddress    := Params.MBDevID;
                      RTUF43Builder.MEIType          := Params.MBMEIType;
                      RTUF43Builder.ReadDeviceIDCode := Params.MBReadDevID;
                      RTUF43Builder.ObjectID         := Params.MBObjectID;
                      RTUF43Builder.Build;
                     end;

                    Result := RTUF43Builder as IBuilderPacket;
                   end;
           end;
         end;
   72  : begin
           if (RTUF72Builder.DeviceAddress <> Params.MBDevID) or
              (RTUF72Builder.StartingAddress <> Params.MBStartReg) or
              (RTUF72Builder.Quantity <> Params.MBRegcount) or
              (RTUF72Builder.LenPacket = 0) then
            begin
             RTUF72Builder.DeviceAddress   := Params.MBDevID;
             RTUF72Builder.StartingAddress := Params.MBStartReg;
             RTUF72Builder.Quantity        := Params.MBRegcount;

             RTUF72Builder.Build;
            end;

           Result := RTUF72Builder as IBuilderPacket;
         end;
   110 : begin
           TempByteArray := Params.GetDataArray;
           if (RTUF110Builder.DeviceAddress <> Params.MBDevID) or
              (RTUF110Builder.StartingAddress <> Params.MBStartReg) or
              (RTUF110Builder.Quantity <> Params.MBRegcount) or
              (not RTUF110Builder.AreEquivalent(TempByteArray)) or
              (RTUF110Builder.LenPacket = 0) then
            begin
             RTUF110Builder.DeviceAddress   := Params.MBDevID;
             RTUF110Builder.StartingAddress := Params.MBStartReg;
             RTUF110Builder.Quantity        := Params.MBRegcount;
             RTUF110Builder.Assign(TempByteArray);

             RTUF110Builder.Build;
            end;

           Result := RTUF110Builder as IBuilderPacket;
         end;
  end;
end;

class function TMBBuildersSingleton.GetMBTCPBuilder(Params: TMBTCPParams): IBuilderPacket;
begin
  Result := nil;
  case Params.MBFunction of
   1   : begin

          Result:=TCPF1Builder as IBuilderPacket;
         end;
   2   : begin

          Result:=TCPF2Builder as IBuilderPacket;
         end;
   3   : begin

          Result:=TCPF3Builder as IBuilderPacket;
         end;
   4   : begin

          Result:=TCPF4Builder as IBuilderPacket;
         end;
   5   : begin

          Result:=TCPF5Builder as IBuilderPacket;
         end;
   6   : begin

          Result:=TCPF6Builder as IBuilderPacket;
         end;
   15  : begin

          Result:=TCPF15Builder as IBuilderPacket;
         end;
   16  : begin

          Result:=TCPF16Builder as IBuilderPacket;
         end;
   20  : begin

          Result:=TCPF20Builder as IBuilderPacket;
         end;
   21  : begin

          Result:=TCPF21Builder as IBuilderPacket;
         end;
   22  : begin

          Result:=TCPF22Builder as IBuilderPacket;
         end;
   23  : begin

          Result:=TCPF23Builder as IBuilderPacket;
         end;
   24  : begin

          Result:=TCPF24Builder as IBuilderPacket;
         end;
   43  : begin

          Result:=TCPF43Builder as IBuilderPacket;
         end;
   72  : begin

          Result:=TCPF72Builder as IBuilderPacket;
         end;
   110 : begin

          Result:=TCPF110Builder as IBuilderPacket;
         end;
  else
   Result := nil;
  end;
end;

initialization
  InitRTUBuilders;
  InitTCPBuilders;

finalization
  DestroyRTUBuilders;
  DestroyTCPBuilders;

end.
