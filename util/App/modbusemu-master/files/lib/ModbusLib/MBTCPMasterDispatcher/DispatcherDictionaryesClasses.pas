unit DispatcherDictionaryesClasses ;

{$mode objfpc}{$H+}

interface

uses
  Classes , SysUtils,
  // библиотека MiscLib/Generics/Lazarus
  DictionaryClasses,
  // библиотека ModbusLib
  MBDefine;

type
  TObjectArray = array of TObject;

  { TDictionaryWordObject }

  TDictionaryWordObject = class(TDictionary)
  private
   function GetObjects (Index : integer ) : TObject ;
   function GetObjectsOfKey (AKey : Word ) : TObject ;
   function GetValues : TObjectArray ;
   function GetKeyIndex(AKey : Word):Integer;
  public
   procedure Add(AKey : Word; AObject : TObject);
   procedure AddOrSetValue(AKey : Word; AObject : TObject);
   function  TryGetValue(AKey : Word; out AObject : TObject) : Boolean;
   procedure Remove(AKey : Word);

   property Objects[Index : integer]  : TObject read GetObjects;
   property ObjectsOfKey[AKey : Word] : TObject read GetObjectsOfKey;
   property Values                    : TObjectArray read GetValues;
  end;

  { TDictionaryCardinalObject }

  TDictionaryCardinalObject = class(TDictionary)
  private
   function GetValues : TObjectArray ;
   function GetKeyIndex(AKey : Cardinal):Integer;
  public
   procedure Add(AKey : Cardinal; AObject : TObject);
   procedure AddOrSetValue(AKey : Cardinal; AObject : TObject);
   function  TryGetValue(AKey : Cardinal; out AObject : TObject) : Boolean;
   procedure Remove(AKey : Cardinal);

   property Values                    : TObjectArray read GetValues;
  end;

  { TSlavePollingItem }

  TPollingItem = class
  private
    FIsOwned : Boolean;
    FKey     : TObject;
    FItem    : TObject;
  public
   constructor Create(Akey, AItem : TObject; AIsOwned : Boolean = True) ;
   destructor Destroy; override;
   property IsOwned : Boolean read FIsOwned write FIsOwned;
   property Key     : TObject read FKey;
   property Item    : TObject read FItem;
  end;


  { TDictionaryObjectObject }

  TDictionaryObjectObject = class(TDictionary)
  private
   function GetValues : TObjectArray ;
   function GetObjKeyStr(AKey : TObject): string;
   function GetObjectItem(AIndex : Integer): TObject;
  protected
   procedure SetIsOwnedObject (AValue : Boolean ); override;
  public
   destructor Destroy; override;
   procedure Add(AKey : TObject; AItem : TObject);
   procedure AddOrSetValue(AKey : TObject; AItem : TObject);
   function  TryGetValue(AKey : TObject; out AItem : TObject) : Boolean;
   procedure Remove(AKey : TObject);

   property Values : TObjectArray read GetValues;
  end;

  { TTCPPollingItem }

  TTCPPollingItem = class
  private
    FIsOwned : Boolean;
    FKey     : TMBTCPSlavePollingItem;
    FItem    : TObject;
  public
   constructor Create(Akey : TMBTCPSlavePollingItem; AItem : TObject; AIsOwned : Boolean = True) ;
   destructor Destroy; override;
   property IsOwned : Boolean read FIsOwned write FIsOwned;
   property Key     : TMBTCPSlavePollingItem read FKey;
   property Item    : TObject read FItem;
  end;

  { TDictionaryTCPItemObject }

  TDictionaryTCPItemObject = class(TDictionary)
  private
   function GetValues : TObjectArray ;
   function GetObjKeyStr(AKey : TMBTCPSlavePollingItem): string;
   function GetObjectItem(AIndex : Integer): TObject;
  protected
   procedure SetIsOwnedObject (AValue : Boolean ); override;
  public
   destructor Destroy; override;
   function  Add(AKey : TMBTCPSlavePollingItem; AItem : TObject): Boolean;
   procedure AddOrSetValue(AKey : TMBTCPSlavePollingItem; AItem : TObject);
   function  TryGetValue(AKey : TMBTCPSlavePollingItem; out AItem : TObject) : Boolean;
   procedure Remove(AKey : TMBTCPSlavePollingItem);

   property Values : TObjectArray read GetValues;
  end;

implementation

uses LoggerItf,
     SocketMisc;

{ TDictionaryCardinalObject }

function TDictionaryCardinalObject.GetValues : TObjectArray;
var i, tempCount : Integer;
begin
  tempCount := Count-1;
  SetLength(Result,tempCount+1);
  for i:= 0 to tempCount do Result[i] := DictList.Objects[i];
end;

function TDictionaryCardinalObject.GetKeyIndex(AKey : Cardinal) : Integer;
begin
  Result := DictList.IndexOf(IntToStr(AKey));
end;

procedure TDictionaryCardinalObject.Add(AKey : Cardinal; AObject : TObject);
begin
  DictList.AddObject(IntToStr(AKey),AObject);
end;

procedure TDictionaryCardinalObject.AddOrSetValue(AKey : Cardinal; AObject : TObject);
var i : Integer;
begin
  i := GetKeyIndex(AKey);
  if i < 0 then
   Add(AKey,AObject)
  else
   begin
    DictList.Strings[i] := IntToStr(AKey);
    if IsOwnedObject then DictList.Objects[i].Free;
    DictList.Objects[i] := AObject;
   end;
end;

function TDictionaryCardinalObject.TryGetValue(AKey : Cardinal; out AObject : TObject) : Boolean;
var i : Integer;
begin
  Result := False;
  i := GetKeyIndex(AKey);
  if i < 0 then Exit;
  AObject := DictList.Objects[i];
  Result := Assigned(AObject);
end;

procedure TDictionaryCardinalObject.Remove(AKey : Cardinal);
var i : Integer;
begin
 i := GetKeyIndex(AKey);
 if i < 0 then Exit;
 DictList.Delete(i);
end;

{ TDictionaryTCPItemObject }

function TDictionaryTCPItemObject.GetValues : TObjectArray;
var i, TempCount : Integer;
begin
  TempCount := Count-1;
  SetLength(Result,TempCount+1);
  for i := 0 to TempCount do Result[i] := GetObjectItem(i);
end;

function TDictionaryTCPItemObject.GetObjKeyStr(AKey : TMBTCPSlavePollingItem) : string;
begin
  Result := {AKey.ID;}
            Format('%s:%d:%d:%d:%d:%d',
                      [GetIPStr(AKey.SlaveParams.SlaveAddr.IP.Addr),
                       AKey.SlaveParams.SlaveAddr.Port,
                       AKey.Item.DevNumber,
                       AKey.Item.FunctNum,
                       AKey.Item.Quantity,
                       AKey.Item.StartAddr
                      ]);
end;

function TDictionaryTCPItemObject.GetObjectItem(AIndex : Integer) : TObject;
begin
  Result := TTCPPollingItem(DictList.Objects[AIndex]).Item;
end;

procedure TDictionaryTCPItemObject.SetIsOwnedObject(AValue : Boolean);
var i,TempCount : Integer;
begin
  inherited SetIsOwnedObject (AValue );
  TempCount := Count-1;
  for i := 0 to TempCount do TTCPPollingItem(DictList.Objects[i]).IsOwned := AValue;
end;

destructor TDictionaryTCPItemObject.Destroy;
begin
  SetIsOwnedObjectOnlyDict(True);
  inherited Destroy;
end;

function TDictionaryTCPItemObject.Add(AKey : TMBTCPSlavePollingItem; AItem : TObject) : Boolean;
var TempKey : string;
    i : Integer;
begin
  Result := False;
  TempKey := GetObjKeyStr(AKey);
  i := DictList.IndexOf(TempKey);
  if i <> -1 then Exit;
  DictList.AddObject(TempKey,TTCPPollingItem.Create(AKey,AItem,IsOwnedObject));
  Result := True;
end;

procedure TDictionaryTCPItemObject.AddOrSetValue(AKey : TMBTCPSlavePollingItem; AItem : TObject);
var i : Integer;
    TempKey : String;
begin
  TempKey := GetObjKeyStr(AKey);
  i := DictList.IndexOf(TempKey);
  if i < 0 then
   Add(AKey,AItem)
  else
   begin
    DictList.Strings[i] := TempKey;
    DictList.Objects[i].Free;
    DictList.Objects[i] := TTCPPollingItem.Create(AKey,AItem,IsOwnedObject);
   end;
end;

function TDictionaryTCPItemObject.TryGetValue(AKey : TMBTCPSlavePollingItem; out AItem : TObject) : Boolean;
var i : Integer;
    TempKey : String;
begin
  Result := False;
  AItem  := nil;
  TempKey := GetObjKeyStr(AKey);
  i := DictList.IndexOf(TempKey);
  if i < 0 then Exit;
  AItem := GetObjectItem(i);
  Result := True;
end;

procedure TDictionaryTCPItemObject.Remove(AKey : TMBTCPSlavePollingItem);
var i : Integer;
    TempKey : String;
begin
  TempKey := GetObjKeyStr(AKey);
  i := DictList.IndexOf(TempKey);
  if i < 0 then Exit;
  if not DictList.OwnsObjects then
   begin
    DictList.Objects[i].Free;
   end;
  DictList.Delete(i);
end;

{ TTCPPollingItem }

constructor TTCPPollingItem.Create(Akey : TMBTCPSlavePollingItem; AItem : TObject; AIsOwned : Boolean);
begin
  FKey     := AKey;
  FItem    := AItem;
  FIsOwned := AIsOwned;
end;

destructor TTCPPollingItem.Destroy;
begin
  if FIsOwned and Assigned(FItem) then FItem.Free;
  inherited Destroy;
end;

{ TDictionaryObjectObject }

function TDictionaryObjectObject .GetObjKeyStr (AKey : TObject ) : string ;
begin
  Result := IntToStr(PtrUInt(Pointer(AKey)));
end;

function TDictionaryObjectObject .GetObjectItem (AIndex : Integer) : TObject ;
begin
  Result := TPollingItem(DictList.Objects[AIndex]).Item;
end;

procedure TDictionaryObjectObject .SetIsOwnedObject (AValue : Boolean );
var i,TempCount : Integer;
begin
  inherited SetIsOwnedObject (AValue );
  TempCount := Count-1;
  for i := 0 to TempCount do TPollingItem(DictList.Objects[i]).IsOwned := AValue;
end;

destructor TDictionaryObjectObject .Destroy ;
begin
 SetIsOwnedObjectOnlyDict(True);
 inherited Destroy ;
end;

function TDictionaryObjectObject .GetValues : TObjectArray ;
var i, TempCount : Integer;
begin
  TempCount := Count-1;
  SetLength(Result,TempCount+1);
  for i := 0 to TempCount do Result[i] := GetObjectItem(i);
end;

procedure TDictionaryObjectObject .Add(AKey : TObject ; AItem : TObject);
begin
 DictList.AddObject(GetObjKeyStr(AKey),TPollingItem.Create(AKey,AItem,IsOwnedObject));
end;

procedure TDictionaryObjectObject .AddOrSetValue (AKey : TObject ; AItem : TObject );
var i : Integer;
    TempKey : String;
begin
  TempKey := GetObjKeyStr(AKey);
  i := DictList.IndexOf(TempKey);
  if i < 0 then
   Add(AKey,AItem)
  else
   begin
    DictList.Strings[i] := TempKey;
    DictList.Objects[i].Free;
    DictList.Objects[i] := TPollingItem.Create(AKey,AItem,IsOwnedObject);
   end;
end;

function TDictionaryObjectObject .TryGetValue(AKey : TObject ; out AItem : TObject) : Boolean ;
var i : Integer;
    TempKey : String;
begin
  Result := False;
  TempKey := GetObjKeyStr(AKey);
  i := DictList.IndexOf(TempKey);
  if i < 0 then Exit;
  AItem := GetObjectItem(i);
end;

procedure TDictionaryObjectObject .Remove (AKey : TObject);
var i : Integer;
    TempKey : String;
begin
  TempKey := GetObjKeyStr(AKey);
  i := DictList.IndexOf(TempKey);
  if i < 0 then Exit;
  DictList.Objects[i].Free;
  DictList.Delete(i);
end;

{ TSlavePollingItem }

constructor TPollingItem .Create(AKey, AItem : TObject; AIsOwned : Boolean = True);
begin
  FKey     := AKey;
  FItem    := AItem;
  FIsOwned := AIsOwned;
end;

destructor TPollingItem.Destroy;
begin
  if FIsOwned and Assigned(FItem) then FItem.Free;
  inherited Destroy;
end;

{ TDictionaryWordObject }

function TDictionaryWordObject .GetObjects (Index : integer) : TObject ;
begin
  Result := DictList.Objects[Index];
end;

function TDictionaryWordObject .GetObjectsOfKey (AKey : Word) : TObject ;
var i : Integer;
begin
  Result := Nil;
  i := GetKeyIndex(AKey);
  if i < 0 then Exit;
  Result := GetObjects(i);
end;

function TDictionaryWordObject .GetValues : TObjectArray;
var i, tempCount : Integer;
begin
  tempCount := Count-1;
  SetLength(Result,tempCount+1);
  for i:= 0 to tempCount do Result[i] := GetObjects(i);
end;

function TDictionaryWordObject .GetKeyIndex (AKey : Word ) : Integer ;
begin
  Result := DictList.IndexOf(IntToStr(AKey));
end;

procedure TDictionaryWordObject .Add(AKey : Word ; AObject : TObject );
begin
  DictList.AddObject(IntToStr(AKey),AObject);
end;

procedure TDictionaryWordObject .AddOrSetValue (AKey : Word ;AObject : TObject );
var i : Integer;
begin
  i := GetKeyIndex(AKey);
  if i < 0 then
   Add(AKey,AObject)
  else
   begin
    DictList.Strings[i] := IntToStr(AKey);
    if IsOwnedObject then DictList.Objects[i].Free;
    DictList.Objects[i] := AObject;
   end;
end;

function TDictionaryWordObject .TryGetValue (AKey : Word ; out AObject : TObject ) : Boolean ;
begin
  Result := False;
  AObject := GetObjectsOfKey(AKey);
  Result := Assigned(AObject);
end;

procedure TDictionaryWordObject .Remove (AKey : Word);
var i : Integer;
begin
 i := GetKeyIndex(AKey);
 if i < 0 then Exit;
 DictList.Delete(i);
end;

end.

