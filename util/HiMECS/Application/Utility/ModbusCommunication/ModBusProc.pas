unit ModBusProc;

interface

const
  COIL = 0;
  INPUT = 1;
  HOLDING_REG = 2;
  INPUT_Reg = 3;
  MY_MODBUS_ADDRESS = $01;

Type
  RMB_DataType = record
    HighByte : Word;
    LowByte: Word;
  end;

  RQuery_0106 = record
    SlaveAddress: Word;
    FunctionCode: Word;
    StartAddress: RMB_DataType;
    PointNo     : RMB_DataType;
  end;

  RQuery_07 = record
    SlaveAddress: Word;
    FunctionCode: Word;
    CRC_16      : Word;
  end;

  RQuery_15 = record
    SlaveAddress: Word;
    FunctionCode: Word;
    StartAddress: RMB_DataType;
    PointNo     : RMB_DataType;
    ByteCounter : Word;
    ForceBit    : array[0..255] of RMB_DataType;
    CRC_16      : Word;
  end;

  RQuery_16 = record
    SlaveAddress: Word;
    FunctionCode: Word;
    StartAddress: RMB_DataType;
    PointNo     : RMB_DataType;
    ByteCounter : Word;
    ForceByte    : array[0..255] of RMB_DataType;
    CRC_16      : Word;
  end;

  RResponse_0104 = record
    SlaveAddress: Word;
    FunctionCode: Word;
    ByteCounter : Word;
    DataByte    : array[0..255] of RMB_DataType;
    CRC_16      : Word;
  end;

  RResponse_0506 = record
    SlaveAddress: Word;
    FunctionCode: Word;
    StartAddress: RMB_DataType;
    PointNo     : RMB_DataType;
    CRC_16      : Word;
  end;

  RResponse_15 = record
    SlaveAddress: Word;
    FunctionCode: Word;
    StartAddress: RMB_DataType;
    PointNo     : RMB_DataType;
    CRC_16      : Word;
  end;

  RResponse_16 = record
    SlaveAddress: Word;
    FunctionCode: Word;
    StartAddress: RMB_DataType;
    PointNo     : RMB_DataType;
    CRC_16      : Word;
  end;

  TModBusProc = Class
	  FQUERY_0106 : RQUERY_0106;
	  FQU1,FQU2,FQU3,FQU4,FQU5,FQU6 : RQUERY_0106;
	  FQU7 : RQUERY_07;
	  FQU15 : RQUERY_15;
	  FQU16 : RQUERY_16;

	  FRES1, FRES2, FRES3, FRES4 : RRESPONSE_0104	;
		FRES5, FRES6 : RRESPONSE_0506;
		FRES15 : RRESPONSE_15;
		FRES16 : RRESPONSE_16;

    function Update_LRC(Data: array of char; size: integer): Byte;
  end;

implementation

{ TModBusProc }

//LRC(Longitudinal Redundancy Check) Calculate
function TModBusProc.Update_LRC(Data: array of char; size: integer): Byte;
var
  i: integer;
  TempResult: Byte;
begin
  TempResult := 0;

  for i := 0 to size - 1 do
    TempResult := TempResult + Ord(Data[i]);

  Result := (not TempResult) + 1; //2's Complement
end;

end.
