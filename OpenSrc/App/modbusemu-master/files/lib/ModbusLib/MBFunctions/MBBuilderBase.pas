unit MBBuilderBase;

{$mode objfpc}{$H+}

interface

uses Classes,
     MBInterfaces, MBDefine;

type
  TBuilderEventType = (betBuild, betRead);

  TBuilderPacketBase = class(TComponent, IBuilderPacket)
   protected
    FLenPacket     : WORD;
    FPacket        : Pointer;
    FBuilderType   : TBuilderTypeEnum;
    FOnPacketBuild : TNotifyEvent;
    FOnPacketRead  : TNotifyEvent;
    function  GetPacket       : Pointer; virtual; abstract;
    function  GetPacketLen    : WORD; virtual; abstract;
    function  GetResponseSize : WORD; virtual; abstract;
    function  GetBuilderType  : TBuilderTypeEnum;
   public
    constructor Create(AOwner : TComponent); override;
    procedure Build; virtual; abstract;
    property BuilderType   : TBuilderTypeEnum read GetBuilderType;
    property LenPacket     : WORD read GetPacketLen;
    property Packet        : Pointer read GetPacket;
    property OnPacketBuild : TNotifyEvent read FOnPacketBuild write FOnPacketBuild;
    property OnPacketRead  : TNotifyEvent read FOnPacketRead write FOnPacketRead;
  end;

  TBuilderPacketClass = class of TBuilderPacketBase;

implementation

{ TBuilderPacketBase }

constructor TBuilderPacketBase.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FLenPacket := 0;
  FPacket    := nil;
  FBuilderType   := btUnknown;
  FOnPacketBuild := nil;
  FOnPacketRead  := nil;
end;

function TBuilderPacketBase.GetBuilderType: TBuilderTypeEnum;
begin
  Result := FBuilderType;
end;

end.
