unit DragDropRecord;

interface

uses
  DragDrop,
  DragDropFormats,
  DropTarget,
  DropSource,
  Classes,
  ActiveX,
  EngineParameterClass,
  HiMECSConst;

type
  TEngineParameter_DragDrop = record
    FEPItem: TEngineParameterItemRecord;
    FDragDataType: TDragDropDataType; //DragDrop시에 record 가 복수개인지 여부
    //Drag시 누른 키 값은 HiMECS_Watch2(다른 Propcess이므로)에 전달되지 않기 때문에 따로 전해줌
    //Ctrl + MouseDrag 이벤트가 안 잡혀서 실패함
    FShiftState: TShiftState; //DragDrop시에 Ctrl/Shift/Alt 키 상태 여부
    FSourceHandle: integer; //Drag Source Window Handle
  end;

  // TEngineParameterClipboardFormat defines our custom clipboard format.
  TEngineParameterClipboardFormat = class(TCustomSimpleClipboardFormat)
  private
    FGotData: boolean;
    FEPD: TEngineParameter_DragDrop;
  protected
    function ReadData(Value: pointer; Size: integer): boolean; override;
    function WriteData(Value: pointer; Size: integer): boolean; override;
    function GetSize: integer; override;
    procedure SetEPD(const Value: TEngineParameter_DragDrop);
  public
    function GetClipboardFormat: TClipFormat; override;
    procedure Clear; override;
    function HasData: boolean; override;
    property EPD: TEngineParameter_DragDrop read FEPD write SetEPD;
  end;

  // TEngineParameterDataFormat defines our custom data format.
  // In this case the data format is identical to the clipboard format, but we
  // need a data format class anyway.
  TEngineParameterDataFormat = class(TCustomDataFormat)
  private
    FEPD: TEngineParameter_DragDrop;
    FGotData: boolean;
  protected
    class procedure RegisterCompatibleFormats; override;
    procedure SetEPD(const Value: TEngineParameter_DragDrop);
  public
    function Assign(Source: TClipboardFormat): boolean; override;
    function AssignTo(Dest: TClipboardFormat): boolean; override;
    procedure Clear; override;
    function HasData: boolean; override;
    function NeedsData: boolean; override;
    property EPD: TEngineParameter_DragDrop read FEPD write SetEPD;
  end;

const
  sEngineParameter_DragDrop = 'TEngineParameterItemRecord';

implementation

uses
  Windows,
  SysUtils;

{ TEngineParameterClipboardFormat }

procedure TEngineParameterClipboardFormat.Clear;
begin
  FillChar(FEPD, SizeOf(FEPD), 0);
  FGotData := False;
end;

var
  CF_TOD: TClipFormat = 0;

function TEngineParameterClipboardFormat.GetClipboardFormat: TClipFormat;
begin
  if (CF_TOD = 0) then
    CF_TOD := RegisterClipboardFormat(sEngineParameter_DragDrop);
  Result := CF_TOD;
end;

function TEngineParameterClipboardFormat.GetSize: integer;
begin
  Result := SizeOf(TEngineParameter_DragDrop);
end;

function TEngineParameterClipboardFormat.HasData: boolean;
begin
  Result := FGotData;
end;

function TEngineParameterClipboardFormat.ReadData(Value: pointer;
  Size: integer): boolean;
begin
  // Copy data from buffer into our structure.
  Move(Value^, FEPD, Size);

  FGotData := True;
  Result := True;
end;

procedure TEngineParameterClipboardFormat.SetEPD(const Value: TEngineParameter_DragDrop);
begin
  FEPD := Value;
  FGotData := True;
end;

function TEngineParameterClipboardFormat.WriteData(Value: pointer;
  Size: integer): boolean;
begin
  Result := (Size = SizeOf(TEngineParameter_DragDrop));
  if (Result) then
    // Copy data from our structure into buffer.
    Move(FEPD, Value^, Size);
end;

{ TEngineParameterDataFormat }

function TEngineParameterDataFormat.Assign(Source: TClipboardFormat): boolean;
begin
  Result := True;

  if (Source is TEngineParameterClipboardFormat) then
    FEPD := TEngineParameterClipboardFormat(Source).EPD
  else
    Result := inherited Assign(Source);

  FGotData := Result;
end;

function TEngineParameterDataFormat.AssignTo(Dest: TClipboardFormat): boolean;
begin
  Result := True;

  if (Dest is TEngineParameterClipboardFormat) then
    TEngineParameterClipboardFormat(Dest).EPD := FEPD
  else
    Result := inherited AssignTo(Dest);
end;

procedure TEngineParameterDataFormat.Clear;
begin
  Changing;
  FillChar(FEPD, SizeOf(FEPD), 0);
  FGotData := False;
end;

function TEngineParameterDataFormat.HasData: boolean;
begin
  Result := FGotData;
end;

function TEngineParameterDataFormat.NeedsData: boolean;
begin
  Result := not FGotData;
end;

class procedure TEngineParameterDataFormat.RegisterCompatibleFormats;
begin
  inherited RegisterCompatibleFormats;

  RegisterDataConversion(TEngineParameterClipboardFormat);
end;

procedure TEngineParameterDataFormat.SetEPD(const Value: TEngineParameter_DragDrop);
begin
  Changing;
  FEPD := Value;
  FGotData := True;
end;

initialization
  // Data format registration
  TEngineParameterDataFormat.RegisterDataFormat;
  // Clipboard format registration
  TEngineParameterClipboardFormat.RegisterFormat;

finalization
end.
