unit MBTransactionBase;

{$mode objfpc}{$H+}

interface

uses Classes,
     MBInterfaces, MBBuilderBase, MBReaderBase;

type
  TTransactionState = (tsCreated, tsInit, tsStart, tsReadResponse, tsEnd, tsError);

  TTransactionBase = class(TInterfacedObject,IBuilderPacket,IReaderPacket,IMBTransactions)
   private
    FNumber     : Cardinal;            // номер тразакции
    FCreateTime : TDateTime;           // время создания
    FBuilder    : TBuilderPacketBase;  // построитель пакета
    FReader     : TReaderBase;         // читатель результатов
    FStartTime  : TDateTime;           // время запуска тразакции
    FEndTime    : TDateTime;           // время окончания тразакции
    FState      : TTransactionState;   // состояние тразакции
    FOnStart    : TNotifyEvent;        // обработчик события старта тразакции
    FOnEnd      : TNotifyEvent;        // обработчик события окончания тразакции
    procedure SetNumber(const Value: Cardinal);
    function  GetErrorCode: Cardinal;
    function  GetEventMessage: String;
   protected
    procedure SetState(State : TTransactionState); virtual;
    function  GetReaderItf  : IReaderPacket; virtual;
    function  GetBuilderItf : IBuilderPacket; virtual;
    procedure OnBuildPacketProc(Sender : TObject); virtual;
    procedure OnReadPacketProc(Sender : TObject); virtual;
    procedure OnErrorProc(Sender : TObject); virtual;
    procedure OnReadResponseEndProc(Sender : TObject); virtual;
    procedure OnReadResponseStartProc(Sender : TObject); virtual;
    property  Builder : TBuilderPacketBase read FBuilder implements IBuilderPacket;
    property  Reader  : TReaderBase read FReader implements IReaderPacket;
   public
    constructor Create(ABuilder : TBuilderPacketBase; AReader : TReaderBase); virtual;
    destructor  Destroy; override;
    procedure Init; virtual;
    property Number       : Cardinal read FNumber write SetNumber;
    property CreateTime   : TDateTime read FCreateTime;
    property StartTime    : TDateTime read FStartTime;
    property EndTime      : TDateTime read FEndTime;
    property State        : TTransactionState read FState;
    property ErrorCode    : Cardinal read GetErrorCode;
    property EventMessage : String read GetEventMessage;
    property OnStart      : TNotifyEvent read FOnStart write FOnStart;
    property OnEnd        : TNotifyEvent read FOnEnd write FOnEnd;
   end;

   TTransactionClass = class of TTransactionBase;

implementation

uses SysUtils,
     MBResourceString;

{ TTRansactionBase }

constructor TTRansactionBase.Create(ABuilder : TBuilderPacketBase; AReader : TReaderBase);
begin
  if (ABuilder=nil) or (AReader=nil) then raise Exception.Create(ERR_TRANS_INIT);
  FNumber:=0;
  FCreateTime:=Now;
  FStartTime:=0;
  FEndTime:=0;
  FState :=tsCreated;
  FBuilder:=ABuilder;
  FBuilder.OnPacketBuild:=OnBuildPacketProc;
  FBuilder.OnPacketRead:=OnReadPacketProc;
  if FBuilder.Packet<>nil then FState:=tsInit;
  FReader:=AReader;
  FReader.OnResponseError:=OnErrorProc;
  FReader.OnResponseReadEnd:=OnReadResponseEndProc;
  FReader.OnResponseReadStart:=OnReadResponseStartProc;
end;

destructor TTransactionBase.Destroy;
begin
  FReader:=nil;
  FBuilder:=nil;
  inherited;
end;

procedure TTransactionBase.OnBuildPacketProc(Sender: TObject);
begin
  SetState(tsInit);
end;

procedure TTransactionBase.OnReadPacketProc(Sender: TObject);
begin
  FStartTime:=Now;
  SetState(tsStart);
end;

procedure TTransactionBase.OnErrorProc(Sender: TObject);
begin
  FEndTime:=Now;
  SetState(tsError);
end;

procedure TTransactionBase.OnReadResponseEndProc(Sender: TObject);
begin
  FEndTime:=Now;
  SetState(tsEnd);
end;

procedure TTransactionBase.OnReadResponseStartProc(Sender: TObject);
begin
  SetState(tsReadResponse);
end;

procedure TTRansactionBase.SetNumber(const Value: Cardinal);
begin
  FNumber := Value;
end;

procedure TTransactionBase.Init;
begin
  if FBuilder = nil then raise Exception.Create(ERR_TRANS_INIT);
  if FState < tsInit then FBuilder.Build;
end;

procedure TTransactionBase.SetState(State: TTransactionState);
begin
 if FState=State then Exit;
 FState:=State;
 case FState of
  tsStart : begin // старт тразакции
             if Assigned(FOnStart) then FOnStart(Self);
            end;
  tsError,
  tsEnd   : begin // окончание выполнения тразакции
             if Assigned(FOnEnd) then FOnEnd(Self);
             if FState=tsError then FState:=tsEnd;
            end;
 end;
end;

function TTransactionBase.GetErrorCode: Cardinal;
begin
  if FReader=nil then raise Exception.Create(ERR_TRANS_INIT);
  Result:=FReader.ErrorCode;
end;

function TTransactionBase.GetEventMessage: String;
begin
 if FReader=nil then raise Exception.Create(ERR_TRANS_INIT);
 Result:=FReader.EventMessage;
end;

function TTransactionBase.GetBuilderItf: IBuilderPacket;
begin
 Result:=FBuilder;
end;

function TTransactionBase.GetReaderItf: IReaderPacket;
begin
 Result:=FReader;
end;

end.
