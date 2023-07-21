unit DragDropMenuItemRecord;

interface

uses
  System.Types,
  DragDrop,
  DragDropFormats,
  DropTarget,
  DropSource,
  Classes,
  ActiveX,
  HiMECSConst,
  MenuBaseClass;

type
  THiMECSMenuItem_DragDrop = record
    FMenuItem: THiMECSMenuRecord;
    FDragDataType: TDragDropDataType; //DragDrop시에 record 가 복수개인지 여부
    //Drag시 누른 키 값은 HiMECS_Watch2(다른 Propcess이므로)에 전달되지 않기 때문에 따로 전해줌
    //Ctrl + MouseDrag 이벤트가 안 잡혀서 실패함
    FShiftState: TShiftState; //DragDrop시에 Ctrl/Shift/Alt 키 상태 여부
    FSourceHandle: integer; //Drag Source Window Handle
  end;

  // THiMECSMenuItemClipboardFormat defines our custom clipboard format.
  THiMECSMenuItemClipboardFormat = class(TCustomSimpleClipboardFormat)
  private
    FGotData: boolean;
    FMenuItemRecord: THiMECSMenuItem_DragDrop;
  protected
    function ReadData(Value: pointer; Size: integer): boolean; override;
    function WriteData(Value: pointer; Size: integer): boolean; override;
    function GetSize: integer; override;
    procedure SetHiMECSMenuItemRecord(const Value: THiMECSMenuItem_DragDrop);
  public
    function GetClipboardFormat: TClipFormat; override;
    procedure Clear; override;
    function HasData: boolean; override;
    property MenuItemRecord: THiMECSMenuItem_DragDrop read FMenuItemRecord write SetHiMECSMenuItemRecord;
  end;

  // THiMECSMenuItemDataFormat defines our custom data format.
  // In this case the data format is identical to the clipboard format, but we
  // need a data format class anyway.
  THiMECSMenuItemDataFormat = class(TCustomDataFormat)
  private
    FMenuItemRecord: THiMECSMenuItem_DragDrop;
    FGotData: boolean;
  protected
    class procedure RegisterCompatibleFormats; override;
    procedure SetHiMECSMenuItemRecord(const Value: THiMECSMenuItem_DragDrop);
  public
    function Assign(Source: TClipboardFormat): boolean; override;
    function AssignTo(Dest: TClipboardFormat): boolean; override;
    procedure Clear; override;
    function HasData: boolean; override;
    function NeedsData: boolean; override;
    property MenuItemRecord: THiMECSMenuItem_DragDrop read FMenuItemRecord write SetHiMECSMenuItemRecord;
  end;

const
  sHiMECSMenuItem_DragDrop = 'THiMECSMenuItemItemRecord';

implementation

uses
  Windows,
  SysUtils;

{ THiMECSMenuItemClipboardFormat }

procedure THiMECSMenuItemClipboardFormat.Clear;
begin
  FillChar(FMenuItemRecord, SizeOf(FMenuItemRecord), 0);
  FGotData := False;
end;

var
  CF_TOD: TClipFormat = 0;

function THiMECSMenuItemClipboardFormat.GetClipboardFormat: TClipFormat;
begin
  if (CF_TOD = 0) then
    CF_TOD := RegisterClipboardFormat(sHiMECSMenuItem_DragDrop);
  Result := CF_TOD;
end;

function THiMECSMenuItemClipboardFormat.GetSize: integer;
begin
  Result := SizeOf(THiMECSMenuItem_DragDrop);
end;

function THiMECSMenuItemClipboardFormat.HasData: boolean;
begin
  Result := FGotData;
end;

function THiMECSMenuItemClipboardFormat.ReadData(Value: pointer;
  Size: integer): boolean;
begin
  // Copy data from buffer into our structure.
  Move(Value^, FMenuItemRecord, Size);

  FGotData := True;
  Result := True;
end;

procedure THiMECSMenuItemClipboardFormat.SetHiMECSMenuItemRecord(const Value: THiMECSMenuItem_DragDrop);
begin
  FMenuItemRecord := Value;
  FGotData := True;
end;

function THiMECSMenuItemClipboardFormat.WriteData(Value: pointer;
  Size: integer): boolean;
begin
  Result := (Size = SizeOf(THiMECSMenuItem_DragDrop));
  if (Result) then
    // Copy data from our structure into buffer.
    Move(FMenuItemRecord, Value^, Size);
end;

{ THiMECSMenuItemDataFormat }

function THiMECSMenuItemDataFormat.Assign(Source: TClipboardFormat): boolean;
begin
  Result := True;

  if (Source is THiMECSMenuItemClipboardFormat) then
    MenuItemRecord := THiMECSMenuItemClipboardFormat(Source).MenuItemRecord
  else
    Result := inherited Assign(Source);

  FGotData := Result;
end;

function THiMECSMenuItemDataFormat.AssignTo(Dest: TClipboardFormat): boolean;
begin
  Result := True;

  if (Dest is THiMECSMenuItemClipboardFormat) then
    THiMECSMenuItemClipboardFormat(Dest).MenuItemRecord := FMenuItemRecord
  else
    Result := inherited AssignTo(Dest);
end;

procedure THiMECSMenuItemDataFormat.Clear;
begin
  Changing;
  FillChar(FMenuItemRecord, SizeOf(FMenuItemRecord), 0);
  FGotData := False;
end;

function THiMECSMenuItemDataFormat.HasData: boolean;
begin
  Result := FGotData;
end;

function THiMECSMenuItemDataFormat.NeedsData: boolean;
begin
  Result := not FGotData;
end;

class procedure THiMECSMenuItemDataFormat.RegisterCompatibleFormats;
begin
  inherited RegisterCompatibleFormats;

  RegisterDataConversion(THiMECSMenuItemClipboardFormat);
end;

procedure THiMECSMenuItemDataFormat.SetHiMECSMenuItemRecord(const Value: THiMECSMenuItem_DragDrop);
begin
  Changing;
  FMenuItemRecord := Value;
  FGotData := True;
end;

initialization
  // Data format registration
  THiMECSMenuItemDataFormat.RegisterDataFormat;
  // Clipboard format registration
  THiMECSMenuItemClipboardFormat.RegisterFormat;

end.
