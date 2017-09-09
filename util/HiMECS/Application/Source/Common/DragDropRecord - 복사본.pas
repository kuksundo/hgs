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
  TEngineParameter_DragDrop_ = record
    FParameterSource: integer;
    FSharedName,
    FFunctionCode,
    FAddress,
    FDescription: string[100];
  end;

  // TEngineParameterClipboardFormat defines our custom clipboard format.
  TEngineParameterClipboardFormat = class(TCustomSimpleClipboardFormat)
  private
    FEPD: TEngineParameterItemRecord;
    FGotData: boolean;
    FDragDataType: TDragDropDataType; //DragDrop시에 record 가 복수개인지 여부
  protected
    function ReadData(Value: pointer; Size: integer): boolean; override;
    function WriteData(Value: pointer; Size: integer): boolean; override;
    function GetSize: integer; override;
    procedure SetEPD(const Value: TEngineParameterItemRecord);
    procedure SetDDT(const Value: TDragDropDataType);
  public
    function GetClipboardFormat: TClipFormat; override;
    procedure Clear; override;
    function HasData: boolean; override;
    property EPD: TEngineParameterItemRecord read FEPD write SetEPD;
    property DragDataType: TDragDropDataType read FDragDataType write SetDDT;
  end;

  // TEngineParameterDataFormat defines our custom data format.
  // In this case the data format is identical to the clipboard format, but we
  // need a data format class anyway.
  TEngineParameterDataFormat = class(TCustomDataFormat)
  private
    FEPD: TEngineParameterItemRecord;
    FGotData: boolean;
    FDragDataType: TDragDropDataType; //DragDrop시에 record 가 복수개인지 여부
  protected
    class procedure RegisterCompatibleFormats; override;
    procedure SetEPD(const Value: TEngineParameterItemRecord);
    procedure SetDDT(const Value: TDragDropDataType);
  public
    function Assign(Source: TClipboardFormat): boolean; override;
    function AssignTo(Dest: TClipboardFormat): boolean; override;
    procedure Clear; override;
    function HasData: boolean; override;
    function NeedsData: boolean; override;
    property EPD: TEngineParameterItemRecord read FEPD write SetEPD;
    property DragDataType: TDragDropDataType read FDragDataType write SetDDT;
  end;

  (*
  ** For simplicity I have not used the following source and target components
  ** in this demo, but instead use and extend the standard TDropTextSource and
  ** TDropTextTarget components.
  *)
  TDropEngineParameterTarget = class(TCustomDropMultiTarget)
  private
    FEngineParameterDataFormat: TEngineParameterDataFormat;
    FDragDataType: TDragDropDataType; //DragDrop시에 record 가 복수개인지 여부
  protected
    function GetTOD: TEngineParameterItemRecord;
  public
    constructor Create(AOwner: TComponent); override;
    property EPD: TEngineParameterItemRecord read GetTOD;
    property DragDataType: TDragDropDataType read FDragDataType write FDragDataType;
  end;

  TDropTimeOfDaySource = class(TCustomDropMultiSource)
  private
    FEngineParameterDataFormat: TEngineParameterDataFormat;
  protected
    function GetTOD: TEngineParameterItemRecord;
    procedure SetEPD(const Value: TEngineParameterItemRecord);
  public
    constructor Create(aOwner: TComponent); override;
  published
    property EPD: TEngineParameterItemRecord read GetTOD write SetEPD;
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
  Result := SizeOf(TEngineParameterItemRecord);
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

procedure TEngineParameterClipboardFormat.SetDDT(
  const Value: TDragDropDataType);
begin
  FDragDataType := Value;
  FGotData := True;
end;

procedure TEngineParameterClipboardFormat.SetEPD(const Value: TEngineParameterItemRecord);
begin
  FEPD := Value;
  FGotData := True;
end;

function TEngineParameterClipboardFormat.WriteData(Value: pointer;
  Size: integer): boolean;
begin
  Result := (Size = SizeOf(TEngineParameterItemRecord));
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

procedure TEngineParameterDataFormat.SetDDT(const Value: TDragDropDataType);
begin
  Changing;
  FDragDataType := Value;
  FGotData := True;
end;

procedure TEngineParameterDataFormat.SetEPD(const Value: TEngineParameterItemRecord);
begin
  Changing;
  FEPD := Value;
  FGotData := True;
end;

{ TDropEngineParameterTarget }

constructor TDropEngineParameterTarget.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEngineParameterDataFormat := TEngineParameterDataFormat.Create(Self);
end;

function TDropEngineParameterTarget.GetTOD: TEngineParameterItemRecord;
begin
  Result := FEngineParameterDataFormat.EPD;
end;

{ TDropTimeOfDaySource }

constructor TDropTimeOfDaySource.Create(aOwner: TComponent);
begin
  inherited Create(AOwner);
  FEngineParameterDataFormat := TEngineParameterDataFormat.Create(Self);
end;

function TDropTimeOfDaySource.GetTOD: TEngineParameterItemRecord;
begin
  Result := FEngineParameterDataFormat.EPD;
end;

procedure TDropTimeOfDaySource.SetEPD(const Value: TEngineParameterItemRecord);
begin
  FEngineParameterDataFormat.EPD := Value;
end;

initialization
  // Data format registration
  TEngineParameterDataFormat.RegisterDataFormat;
  // Clipboard format registration
  TEngineParameterClipboardFormat.RegisterFormat;

finalization
end.
