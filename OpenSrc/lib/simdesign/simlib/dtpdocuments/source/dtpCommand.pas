{
  unit dtpCommand

  This unit implements command scripts that can be used for undo functionality,
  as well as scripting (future).

  Creation Date: 22-08-2003 (NH)
  Version: 1.0

  Modifications:

  Copyright (c) 2003 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.
}
unit dtpCommand;

{$i simdesign.inc}

interface

uses
  Classes, SysUtils;

type

  // TdtpCommand command type
  TdtpCommandType = (
    cmdSetProp,         // Set a property of Object
    cmdShapeDelete,     // Delete a shape
    cmdShapeInsert,     // Insert a shape
    cmdEffectDelete,    // Effect was deleted from a shape
    cmdEffectInsert,    // Effect was inserted in a shape
    cmdEffectSetProp    // Effect property was set
  );

  // TdtpCommand implements a single undo command. The Undos[] list of TdtpDocument contains
  // TdtpCommand instances.
  TdtpCommand = class
  private
    FCommand: TdtpCommandType;  // Type of undo command
    FRef: integer;              // Object reference
    FIncludePrev: boolean;      // If true, when undoing, this command includes the previous one
    FProp: string;              // property to be processed
    FStream: TStream;           // if assigned, stream to be used as input
    FValue: string;             // value to be processed
    function GetSize: integer;
  protected
  public
    constructor Create; overload;
    constructor Create(ACommand: TdtpCommandType; ARef: integer); overload;
    constructor Create(ACommand: TdtpCommandType; ARef: integer; const AProp,
      AValue: string); overload;
    constructor Create(ACommand: TdtpCommandType; ARef: integer; const AProp,
      AValue: string; S: TStream); overload;
    destructor Destroy; override;
    property Command: TdtpCommandType read FCommand write FCommand;
    property IncludePrev: boolean read FIncludePrev write FIncludePrev;
    property Prop: string read FProp write FProp;
    property Ref: integer read FRef write FRef;
    property Size: integer read GetSize;
    property Stream: TStream read FStream write FStream;
    property Value: string read FValue write FValue;
  end;

implementation

{ TdtpCommand }

constructor TdtpCommand.Create;
begin
  inherited Create;
end;

constructor TdtpCommand.Create(ACommand: TdtpCommandType; ARef: integer; const AProp,
  AValue: string);
begin
  Create;
  Command := ACommand;
  Ref     := ARef;
  Prop    := AProp;
  Value   := AValue;
end;

constructor TdtpCommand.Create(ACommand: TdtpCommandType; ARef: integer);
begin
  Create;
  Command := ACommand;
  Ref     := ARef;
end;

constructor TdtpCommand.Create(ACommand: TdtpCommandType;
  ARef: integer; const AProp, AValue: string; S: TStream);
begin
  Create(ACommand, ARef, AProp, AValue);
  FStream := S;
  if assigned(FStream) then
    FStream.Seek(0, soFromBeginning);
end;

destructor TdtpCommand.Destroy;
begin
  FreeAndNil(FStream);
  inherited;
end;

function TdtpCommand.GetSize: integer;
// The total size in bytes occupied by this object
begin
  Result := SizeOf(TdtpCommand) + Length(FProp) + Length(FValue);
  if assigned(FStream) then
    inc(Result, FStream.Size);
end;

end.
