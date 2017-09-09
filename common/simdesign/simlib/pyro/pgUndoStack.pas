{ Project: Pyro

  Description:
  Undo Stack (todo)

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Copyright (c) 2006 - 2011 SimDesign BV
}
unit pgUndoStack;

interface

uses
  Classes, SysUtils, Contnrs, pgScene, Pyro, pgDocument, pgStorage;

type

  TpgUndoItem = class(TPersistent)
  private
    FPropId: longword;
    FElement: TpgElement;
    FChange: TpgChangeType;
    FData: string;
  public
    // Change type registered in this undo item
    property Change: TpgChangeType read FChange write FChange;
    // Element the change applies to
    property Element: TpgElement read FElement write FElement;
    // Prop Id the change applies to
    property PropId: longword read FPropId write FPropId;
    // Binary data string containing change
    property Data: string read FData write FData;
  end;

  TpgUndoItemList = class(TObjectList)
  private
    function GetItems(Index: integer): TpgUndoItem;
  public
    property Items[Index: integer]: TpgUndoItem read GetItems; default;
  end;

  // Undo stack that remembers all the changes in the scene it is connected
  // to and allows undoing/redoing them
  TpgUndoStack = class(TComponent)
  private
    FIsUndoing: boolean;
    FScene: TpgScene;
    FUndoItems: TpgUndoItemList;
    FRedoItems: TpgUndoItemList;
    FEnabled: boolean;
    FStorage: TpgBinaryStorage;
    FStream: TMemoryStream;
    FOnMessage: TpgMessageEvent;
    procedure SetScene(const Value: TpgScene);
    procedure SceneChange(Sender: TObject; AElement: TpgElement; APropId: longword; AChange: TpgChangeType);
    function RegisterPropChange(AItem: TpgUndoItem; AElement: TpgElement; APropId: longword): boolean;
    function GetLastItem(AList: TpgUndoItemList): TpgUndoItem;
    procedure DoMessage(const AMessage: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    // Undo last change
    procedure Undo;
    // If a change has been undone, redo this change
    procedure Redo;
    // OnMessage is fired whenever a new item is added to the undo stack
    property OnMessage: TpgMessageEvent read FOnMessage write FOnMessage;
  published
    // Connect the undo stack to a scene
    property Scene: TpgScene read FScene write SetScene;
    property Enabled: boolean read FEnabled write FEnabled;
  end;

implementation

type
  TPropAccess = class(TpgProp);

{ TpgUndoItemList }

function TpgUndoItemList.GetItems(Index: integer): TpgUndoItem;
begin
  Result := Get(Index);
end;

{ TpgUndoStack }

procedure TpgUndoStack.Clear;
begin
  FUndoItems.Clear;
  FRedoItems.Clear;
end;

constructor TpgUndoStack.Create(AOwner: TComponent);
begin
  inherited;
  FUndoItems := TpgUndoItemList.Create;
  FRedoItems := TpgUndoItemList.Create;
  FStream := TMemoryStream.Create;
  FStorage := TpgBinaryStorage.Create(nil, FStream);
  FEnabled := True;
end;

destructor TpgUndoStack.Destroy;
begin
  FreeAndNil(FUndoItems);
  FreeAndNil(FRedoItems);
  FreeAndNil(FStorage);
  FreeAndNil(FStream);
  inherited;
end;

procedure TpgUndoStack.DoMessage(const AMessage: string);
begin
  if assigned(FOnMessage) then FOnMessage(Self, AMessage);
end;

function TpgUndoStack.GetLastItem(AList: TpgUndoItemList): TpgUndoItem;
begin
  Result := nil;
  if not assigned(AList) or (AList.Count = 0) then
    exit;
  Result := AList[AList.Count - 1];
end;

procedure TpgUndoStack.Redo;
begin
//
end;

function TpgUndoStack.RegisterPropChange(AItem: TpgUndoItem; AElement: TpgElement; APropId: longword): boolean;
var
  Prop: TpgProp;
  Count: integer;
begin
  Result := False;
  if (AElement = nil) or (not FScene.ExistsElement(AElement)) or (efTemporary in AElement.Flags) then
    exit;
  Prop := AElement.PropById(APropId);
  if not (Prop is TpgProp) then
    exit;
  // Clear stream, and write
  FStream.Clear;
  //todo TPropAccess(Prop).Write(FStorage);
  // How much bytes written?
  Count := FStream.Size;
  if Count > 0 then
  begin
    // Store information in AItem
    AItem.Change := ctPropUpdate;
    AItem.Element := AElement;
    AItem.PropId := APropId;
    SetLength(AItem.FData, Count);
    // Copy data from stream to binary data string
    Move(FStream.Memory^, AItem.FData[1], Count);
    Result := True;
  end;
end;

procedure TpgUndoStack.SceneChange(Sender: TObject; AElement: TpgElement; APropId: longword; AChange: TpgChangeType);
var
  List: TpgUndoItemList;
  Item, Last: TpgUndoItem;
begin
  if not FEnabled then exit;
  // During Undo command, changes from the scene go into the Redo list instead
  if FIsUndoing then
    List := FRedoItems
  else
    List := FUndoItems;

  // What kind of change?
  case AChange of
{  ctListClear:;
  ctListUpdate:;
  ctElementAdd:;
  ctElementRemove:;
  ctElementListAdd:;
  ctElementListRemove:;
  ctPropAdd:;
  ctPropRemove:;}
  ctPropUpdate:
    begin
      // Same as last change?
      Last := GetLastItem(List);
      if assigned(Last) and
        (Last.Change = ctPropUpdate) and
        (Last.Element = AElement) and
        (Last.PropId = APropId) then
      begin
        // Repeated change, skip
      end else
      begin
        // We register this property change in Item, and add it to the list
        Item := TpgUndoItem.Create;
        if RegisterPropChange(Item, AElement, APropId) then
        begin
          DoMessage(Format('Undo%.4d: PropUpdate Element %s Prop %d', [List.Count, AElement.Name, APropId]));
          List.Add(Item)
        end else
          Item.Free;
      end;
    end;
  end;
end;

procedure TpgUndoStack.SetScene(const Value: TpgScene);
var
  L: TpgSceneListener;
begin
  if FScene <> Value then
  begin
    Clear;
    if assigned(FScene) then
      FScene.Listeners.DeleteRef(Self);
    FScene := Value;
    if assigned(FScene) then
    begin
      L := FScene.Listeners.AddRef(Self);
      L.OnBeforeChange := SceneChange;
    end;
  end;
end;

procedure TpgUndoStack.Undo;
begin
  FIsUndoing := True;
  try
    //
  finally
    FIsUndoing := False;
  end;
end;

end.
