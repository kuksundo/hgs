unit SFTStruct;

interface

Type
  PTransferRecord = ^TransferRecord;
  TransferRecord = Packed Record
    Msg : string[30] ;
    FileSize : Integer;
    FileName : String[100] ;
    Append : Boolean;
  end;

implementation

end.
