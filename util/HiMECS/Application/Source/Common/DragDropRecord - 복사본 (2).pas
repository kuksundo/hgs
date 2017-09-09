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
  // TEngineParameterClipboardFormat defines our custom clipboard format.
  TEngineParameterClipboardFormat = class(TCustomSimpleClipboardFormat)
  private
    FEPD: TEngineParameter_DynArray;
    FGotData: boolean;
    FDragDataType: TDragDropDataType; //DragDrop시에 record 가 복수개인지 여부
  protected
    function ReadData(Value: pointer; Size: integer): boolean; override;
    function WriteData(Value: pointer; Size: integer): boolean; override;
    function GetSize: integer; override;
    procedure SetEPD(const Value: TEngineParameter_DynArray);
    procedure SetDDT(const Value: TDragDropDataType);
  public
    function GetClipboardFormat: TClipFormat; override;
    procedure Clear; override;
    function HasData: boolean; override;
    property EPD: TEngineParameter_DynArray read FEPD write SetEPD;
    property DragDataType: TDragDropDataType read FDragDataType write SetDDT;
  end;

  // TEngineParameterDataFormat defines our custom data format.
  // In this case the data format is identical to the clipboard format, but we
  // need a data format class anyway.
  TEngineParameterDataFormat = class(TCustomDataFormat)
  private
    FEPD: TEngineParameter_DynArray;
    FGotData: boolean;
    FDragDataType: TDragDropDataType; //DragDrop시에 record 가 복수개인지 여부
  protected
    class procedure RegisterCompatibleFormats; override;
    procedure SetEPD(const Value: TEngineParameter_DynArray);
    procedure SetDDT(const Value: TDragDropDataType);
  public
    function Assign(Source: TClipboardFormat): boolean; override;
    function AssignTo(Dest: TClipboardFormat): boolean; override;
    procedure Clear; override;
    function HasData: boolean; override;
    function NeedsData: boolean; override;
    property EPD: TEngineParameter_DynArray read FEPD write SetEPD;
    property DragDataType: TDragDropDataType read FDragDataType write SetDDT;
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
  Result := SizeOf(TEngineParameter_DynArray);
end;

function TEngineParameterClipboardFormat.HasData: boolean;
begin
  Result := FGotData;
end;

function TEngineParameterClipboardFormat.ReadData(Value: pointer;
  Size: integer): boolean;
begin
  // Copy data from buffer into our structure.
  //Move(Value^, FEPD, Size);
  Move(Value^, FEPD, Length(FEPD)*SizeOf(TEngineParameterItemRecord));

  FGotData := True;
  Result := True;
end;

procedure TEngineParameterClipboardFormat.SetDDT(
  const Value: TDragDropDataType);
begin
  FDragDataType := Value;
  FGotData := True;
end;

procedure TEngineParameterClipboardFormat.SetEPD(const Value: TEngineParameter_DynArray);
begin
  //FEPD := Value;
  SetLength(FEPD, Length(Value));
  Move(Value[0], FEPD[0], Length(FEPD)*SizeOf(TEngineParameterItemRecord));
  //FEPD := Copy(Value);
  FGotData := True;
end;

function TEngineParameterClipboardFormat.WriteData(Value: pointer;
  Size: integer): boolean;
begin
  Result := (Size = SizeOf(TEngineParameter_DynArray));
  if (Result) then
    // Copy data from our structure into buffer.
    Move(FEPD, Value^, Size);
end;

{ TEngineParameterDataFormat }

function TEngineParameterDataFormat.Assign(Source: TClipboardFormat): boolean;
begin
  Result := True;

  if (Source is TEngineParameterClipboardFormat) then
    EPD := TEngineParameterClipboardFormat(Source).EPD
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

procedure TEngineParameterDataFormat.SetDDT(const Value: TDragDropDataType);
begin
  Changing;
  FDragDataType := Value;
  FGotData := True;
end;

procedure TEngineParameterDataFormat.SetEPD(const Value: TEngineParameter_DynArray);
begin
  Changing;
//  FEPD := Value;
  SetLength(FEPD, Length(Value));
  Move(Value[0], FEPD[0], Length(FEPD)*SizeOf(TEngineParameterItemRecord));
  //FEPD := Copy(Value);
  FGotData := True;
end;

initialization
  // Data format registration
  TEngineParameterDataFormat.RegisterDataFormat;
  // Clipboard format registration
  TEngineParameterClipboardFormat.RegisterFormat;

finalization
end.
