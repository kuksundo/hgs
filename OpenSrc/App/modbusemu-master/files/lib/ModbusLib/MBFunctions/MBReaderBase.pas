unit MBReaderBase;

{$mode objfpc}{$H+}

interface

uses Classes,
     MBInterfaces, MBDefine;

type
   
   TReaderBase = class(TComponent, IReaderPacket)
    protected
     FErrorCode      : Cardinal;
     FMessage        : String;
     FReaderType     : TReaderTypeEnum;
     FOnError        : TNotifyEvent;
     FOnReadEnd      : TNotifyEvent;
     FOnReadStart    : TNotifyEvent;
     procedure Notify(EventType : TReadPacketEventType ;AMessage : String = ''); virtual; abstract;
     function  GetRegisterCount: Word; virtual; abstract;
     function  GetReaderType : TReaderTypeEnum;
    public
     constructor Create(AOwner : TComponent); override;
     procedure Response(Buff : Pointer; BuffSize : Cardinal); virtual; abstract;
     function  GetLastErrorCode : Cardinal; virtual;
     property ReadderType            : TReaderTypeEnum read GetReaderType;
     property ErrorCode              : Cardinal read FErrorCode;
     property EventMessage           : String read FMessage;
     property OnResponseError        : TNotifyEvent read FOnError write FOnError;
     property OnResponseReadEnd      : TNotifyEvent read FOnReadEnd write FOnReadEnd;
     property OnResponseReadStart    : TNotifyEvent read FOnReadStart write FOnReadStart;
   end;

   TReaderClass = class of TReaderBase;

implementation

{ TReaderBase }

constructor TReaderBase.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FErrorCode  := 0;
  FMessage    := '';
  FReaderType := rtUnknown;
  FOnError    := nil;
  FOnReadEnd  := nil;
  FOnReadStart:= nil;
end;

function TReaderBase.GetLastErrorCode: Cardinal;
begin
  Result:=FErrorCode;
end;

function TReaderBase.GetReaderType: TReaderTypeEnum;
begin
  Result := FReaderType;
end;

end.
