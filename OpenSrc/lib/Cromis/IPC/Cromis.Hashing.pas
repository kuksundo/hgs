(*
 * This software is distributed under BSD license.
 *
 * Copyright (c) 2010-2011 Iztok Kacin, Cromis (iztok.kacin@gmail.com).
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, this
 *   list of conditions and the following disclaimer in the documentation and/or
 *   other materials provided with the distribution.
 * - Neither the name of the Iztok Kacin nor the names of its contributors may be
 *   used to endorse or promote products derived from this software without specific
 *   prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *
 * =============================================================================
 * The unit uses a hashing function originaly written by
 * Paul Hsieh (http://www.azillionmonkeys.com/qed/hash.html)
 * The code was translated by Davy Landman.
 *
 * "Hash_SuperFastHash" is used under MPL 1.1
 * =============================================================================
 *
 ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is SuperFastHash Delphi and BASM translation.
 *
 * The Initial Developer of the Original Code is
 * Davy Landman.
 * Portions created by the Initial Developer are Copyright (C) 2007
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK *****
 *
 * =============================================================================
 * Hash related classes (Tables, hashing functions etc...)
 * =============================================================================
 * 24/08/2010 (1.0.0)
 *  - Initial implementation
 * =============================================================================
 * 19/06/2011 (2.0.0)
 *  - Complete rewrite that uses TAnyValue and very fast hashing functions
 * 06/07/2012 (2.0.1)
 *  - Fixed hash calculation of actual implememented hash tables
 *  - Custom hash is abstract and never implemented
 * 17/07/2012 (2.1.0)
 *  - Added EnumerateKeys overload that uses anonymous function as parameter
 *  - Added EnumerateKeys overload that takes TEnumerateKeyExCallback
 *  - Use Hash_SuperFastHash as string hash function
 * 28/02/2013 (2.2.0)
 *  - Added support for node manager where deleted nodes are not disposed
 *  - Use PAnyValue where appropriate internally to avoid record copies
 * 06/10/2013 (2.2.1)
 *  - Enumeration support for easier enumeration of hash members
 * 06/10/2013 (2.2.2)
 *  - GetRaw added to allow direct access to hash members
 * ============================================================================
*)
unit Cromis.Hashing;

interface

uses
  Windows, SysUtils, IniFiles, Classes,

  // Cromis units
  Cromis.AnyValue;

const
  cDefaultHashSize = 6151;

type
  PPHashItem = ^PHashItem;
  PHashItem = ^THashItem;
  THashItem = record
    Value: TAnyValue;
    Next: PHashItem;
    Key: TAnyValue;
  end;
  TBuckets = array of PHashItem;

  TEnumerateKeyExCallback = procedure(const Key, Value: PAnyValue; const Data: Pointer) of object;
  TEnumerateKeyCallback = procedure(const Key, Value: PAnyValue) of object;
  THashFunction = function(Data: Pointer; const Length: Cardinal): Cardinal;

  {$IF CompilerVersion >= 20}
    TEnumerateKeyAnonProc = reference to procedure(const Key: TAnyValue; const Value: TAnyValue);
  {$IFEND}

  IHashElement = Interface(IInterface)
  ['{94A8F32F-5972-4A9F-BD88-F8677AF1E18F}']
    function GetKey: PAnyValue;
    function GetValue: PAnyValue;
    property Key: PAnyValue read GetKey;
    property Value: PAnyValue read GetValue;
  end;

  IHashEnumerator = Interface(IInterface)
  ['{4D7E00D3-BFA9-4E3B-82F9-E590DAE74DE7}']
    // getters and setters
    function _GetCurrent: IHashElement;
    // iterator function and procedures
    function MoveNext: Boolean;
    property Current: IHashElement read _GetCurrent;
  end;

  TCustomHashTable = class
  private
    FSize: Cardinal;
    FCount: Cardinal;
    FBuckets: TBuckets;
    FDeleted: PHashItem;
    FHashFunction: THashFunction;
    FMaxCountBeforeResize: Cardinal;
    function AcquireNewBucket: PHashItem;
    function GetItem(const Key: TAnyValue): TAnyValue;
    procedure SetItem(const Key: TAnyValue; const Value: TAnyValue);
    procedure CalculateMaxItemsBeforeResize(const CurrentSize: Cardinal); inline;
    procedure InternalAdd(const Key: PAnyValue; const Value: PAnyValue);
    procedure InitializeDeletedItems(const Size: Cardinal);
    procedure ReleaseOldBucket(const Bucket: PHashItem);
    procedure InternalClear(const Buckets: TBuckets);
    procedure Resize(const NewSize: Cardinal);
    procedure ClearDeletedBuckets; inline;
    procedure CheckHashTableSize; inline;
  protected
    function Find(const Key: PAnyValue): PPHashItem;
    function DoCalculateHash(const Key: PAnyValue): Cardinal; virtual; abstract;
  public
    constructor Create(const HasFunction: THashFunction; const Size: Cardinal = cDefaultHashSize);
    destructor Destroy; override;
    function GetEnumerator: IHashEnumerator;
    function ContainsKey(const Key: TAnyValue): Boolean; inline;
    procedure EnumerateKeys(const EnumProc: TEnumerateKeyExCallback; const Data: Pointer); overload;
    procedure EnumerateKeys(const EnumProc: TEnumerateKeyCallback); overload;
  {$IF CompilerVersion >= 20}
    procedure EnumerateKeys(const EnumProc: TEnumerateKeyAnonProc); overload;
  {$IFEND}
    procedure Add(const Key: TAnyValue; const Value: TAnyValue);
    function GetRaw(const Key: TAnyValue): PAnyValue;
    procedure Remove(const Key: TAnyValue);
    procedure Clear;
    property Item[const Key: TAnyValue]: TAnyValue read GetItem write SetItem;
    property Count: Cardinal read FCount;
  end;

  // hash table that uses integers as keys
  TCardinalHashTable = class(TCustomHashTable)
  protected
    function DoCalculateHash(const Key: PAnyValue): Cardinal; override;
  public
    constructor Create(const Size: Cardinal = cDefaultHashSize);
  end;

  // hash table that uses strings as keys
  TStringHashTable = class(TCustomHashTable)
  protected
    function DoCalculateHash(const Key: PAnyValue): Cardinal; override;
  public
    constructor Create(const Size: Cardinal = cDefaultHashSize);
  end;

  // hash functions
  function Hash_SimpleHash(Data: Pointer; const Length: Cardinal): Cardinal;
  function Hash_SuperFastHash(Data: Pointer; const Length: Cardinal): Cardinal;
  function Hash_SimpleCardinalMod(Data: Pointer; const Length: Cardinal): Cardinal;

implementation

const
  // customized version from http://planetmath.org/encyclopedia/GoodHashTablePrimes.html
  CGoodHashTablePrimes: array [3..30] of Cardinal =
    (
     17, 31, 53, 97, 193, 389, 769, 1543, 3079, 6151, 12289, 24593, 49157, 98317, 196613,
     393241, 786433, 1572869, 3145739, 6291469, 12582917, 25165843, 50331653, 100663319,
     201326611, 402653189, 805306457, 1610612741
    );

const
  cM = $5BD1E995;
  cR = 24;

type
  TCardinalArray = array[0..(MaxInt div SizeOf(Cardinal)) - 1] of Cardinal;
  PCardinalArray = ^TCardinalArray;

type
  THashElement = class(TInterfacedObject, IHashElement)
  private
    FKey: PAnyValue;
    FValue: PAnyValue;
    function GetKey: PAnyValue;
    function GetValue: PAnyValue;
  public
    constructor Create(const Key, Value: PAnyValue);
    property Key: PAnyValue read GetKey;
    property Value: PAnyValue read GetValue;
  end;

  THashEnumerator = class(TInterfacedObject, IHashEnumerator)
  private
    FIndex: Integer;
    FElementList: array of IHashElement;
    FCurrentElement: IHashElement;
    function _GetCurrent: IHashElement;
    procedure InitializeEnum(const Key, Value: PAnyValue; const Data: Pointer);
  public
    constructor Create(const HashTable: TCustomHashTable);
    property Current: IHashElement read _GetCurrent;
    function MoveNext: Boolean;
  end;

function GetGoodHashSize(const Size: Cardinal): Cardinal;
var
  UpToSize: Cardinal;
  TableIndex: Integer;
begin
  TableIndex := Low(CGoodHashTablePrimes);
  UpToSize := 1 shl TableIndex;

  while Size > UpToSize do
  begin
    Inc(TableIndex);
    UpToSize := UpToSize shl 1;
  end;

  // set the good hash size
  Result := CGoodHashTablePrimes[TableIndex];
end;

function Hash_SimpleCardinalMod(Data: Pointer; const Length: Cardinal): Cardinal;
begin
  Result := Cardinal(Data^) mod Length;
end;

function Hash_SimpleHash(Data: Pointer; const Length: Cardinal): Cardinal;
var
  I: Integer;
begin
  Result := 0;

  for I := 1 to Length do
  begin
    Result := ((Result shl 2) or (Result shr (SizeOf(Result) * 8 - 2))) xor PByte(Data)^;
    Inc(PByte(Data));
  end;
end;

{$OVERFLOWCHECKS OFF}
function Hash_SuperFastHash(Data: Pointer; const Length: Cardinal): Cardinal;
var
  TempPart: Cardinal;
  RemainingBytes: Integer;
  RemainingDWords: Integer;
begin
  if not Assigned(Data) or (Length <= 0) then
  begin
    Result := 0;
    Exit;
  end;
  Result := Length;
  RemainingBytes := Length and 3; // mod 4
  RemainingDWords := Length shr 2; // div 4

  // main loop
  while RemainingDWords > 0 do
  begin
    Result := Result + PWord(Data)^;
    // splitting the pointer math keeps the amount of registers pushed at 2
    Data := Pointer(Cardinal(Data) + SizeOf(Word));
    TempPart := (PWord(Data)^ shl 11) xor Result;
    Result := (Result shl 16) xor TempPart;
    Data  := Pointer(Cardinal(Data) + SizeOf(Word));
    Result := Result + (Result shr 11);
    Dec(RemainingDWords);
  end;
  // Handle end cases
  if RemainingBytes = 3 then
  begin
    Result := Result + PWord(Data)^;
    Result := Result xor (Result shl 16);
    Data  := Pointer(Cardinal(Data) + SizeOf(Word)); // skip to the last byte
    Result := Result xor ((PByte(Data)^ shl 18));
    Result := Result + (Result shr 11);
  end
  else if RemainingBytes = 2 then
  begin
    Result := Result +  PWord(Data)^;
    Result := Result xor (Result shl 11);
    Result := Result + (Result shr 17);
  end
  else if RemainingBytes = 1 then
  begin
    Result := Result + PByte(Data)^;
    Result := Result xor (Result shl 10);
    Result := Result + (Result shr 1);
  end;
  // Force "avalanching" of final 127 bits
  Result := Result xor (Result shl 3);
  Result := Result +   (Result shr 5);
  Result := Result xor (Result shl 4);
  Result := Result +   (Result shr 17);
  Result := Result xor (Result shl 25);
  Result := Result +   (Result shr 6);
end;
{$OVERFLOWCHECKS ON}


{ TCustomHashTable }

constructor TCustomHashTable.Create(const HasFunction: THashFunction; const Size: Cardinal);
begin
  inherited Create;

  FSize := GetGoodHashSize(Size);
  SetLength(FBuckets, FSize);
  FHashFunction := HasFunction;
  InitializeDeletedItems(FSize div 10);
  CalculateMaxItemsBeforeResize(FSize);
end;

destructor TCustomHashTable.Destroy;
begin
  InternalClear(FBuckets);
  ClearDeletedBuckets;


  inherited;
end;

procedure TCustomHashTable.SetItem(const Key: TAnyValue; const Value: TAnyValue);
var
  HashItem: PHashItem;
begin
  HashItem := Find(@Key)^;

  if HashItem <> nil then
    CopyAnyValue(@HashItem^.Value, @Value)
  else
  begin
    CheckHashTableSize;
    InternalAdd(@Key, @Value);
    Inc(FCount);
  end;
end;

function TCustomHashTable.GetEnumerator: IHashEnumerator;
begin
  Result := THashEnumerator.Create(Self);
end;

function TCustomHashTable.GetItem(const Key: TAnyValue): TAnyValue;
var
  HashItem: PHashItem;
begin
  HashItem := Find(@Key)^;

  if HashItem <> nil then
    CopyAnyValue(@Result, @HashItem^.Value)
  else
    Result.Clear;
end;

function TCustomHashTable.GetRaw(const Key: TAnyValue): PAnyValue;
var
  HashItem: PHashItem;
begin
  HashItem := Find(@Key)^;

  if HashItem <> nil then
    Result := @HashItem^.Value
  else
    Result := nil;
end;

function TCustomHashTable.ContainsKey(const Key: TAnyValue): Boolean;
begin
  Result := Find(@Key)^ <> nil;
end;

procedure TCustomHashTable.EnumerateKeys(const EnumProc: TEnumerateKeyExCallback; const Data: Pointer);
var
  BucketIndex: Integer;
  HashItem: PHashItem;
begin
  for BucketIndex := Low(FBuckets) to High(FBuckets) do
  begin
    HashItem := FBuckets[BucketIndex];

    while HashItem <> nil do
    begin
      EnumProc(@HashItem.Key, @HashItem.Value, Data);
      HashItem := HashItem.Next;
    end;
  end;
end;

procedure TCustomHashTable.EnumerateKeys(const EnumProc: TEnumerateKeyCallback);
var
  BucketIndex: Integer;
  HashItem: PHashItem;
begin
  for BucketIndex := Low(FBuckets) to High(FBuckets) do
  begin
    HashItem := FBuckets[BucketIndex];

    while HashItem <> nil do
    begin
      EnumProc(@HashItem.Key, @HashItem.Value);
      HashItem := HashItem.Next;
    end;
  end;
end;

{$IF CompilerVersion >= 20}
procedure TCustomHashTable.EnumerateKeys(const EnumProc: TEnumerateKeyAnonProc);
var
  BucketIndex: Integer;
  HashItem: PHashItem;
begin
  for BucketIndex := Low(FBuckets) to High(FBuckets) do
  begin
    HashItem := FBuckets[BucketIndex];

    while HashItem <> nil do
    begin
      EnumProc(HashItem.Key, HashItem.Value);
      HashItem := HashItem.Next;
    end;
  end;
end;
{$IFEND}

procedure TCustomHashTable.InitializeDeletedItems(const Size: Cardinal);
var
  I: Integer;
  Bucket: PHashItem;
begin
  for I := 1 to Size do
  begin
    New(Bucket);
    Bucket.Next := FDeleted;
    FDeleted := Bucket;
  end;
end;

procedure TCustomHashTable.InternalAdd(const Key: PAnyValue; const Value: PAnyValue);
var
  KeyHash: Cardinal;
  Bucket: PHashItem;
begin
  KeyHash := DoCalculateHash(Key);

  Bucket := AcquireNewBucket;
  CopyAnyValue(@Bucket^.Key, Key);
  CopyAnyValue(@Bucket^.Value, Value);
  Bucket^.Next := FBuckets[KeyHash];
  FBuckets[KeyHash] := Bucket;
end;

procedure TCustomHashTable.InternalClear(const Buckets: TBuckets);
var
  I: Integer;
  P, N: PHashItem;
begin
  for I := Low(Buckets) to High(Buckets) do
  begin
    P := Buckets[I];

    while P <> nil do
    begin
      N := P^.Next;
      ReleaseOldBucket(P);
      P := N;
    end;

    Buckets[I] := nil;
  end;
end;

procedure TCustomHashTable.CalculateMaxItemsBeforeResize(const CurrentSize: Cardinal);
begin
  FMaxCountBeforeResize := Trunc((CurrentSize / 3) * 2);
end;

procedure TCustomHashTable.CheckHashTableSize;
begin
  if FCount = FMaxCountBeforeResize then
    Resize(2 * FCount);
end;

function TCustomHashTable.Find(const Key: PAnyValue): PPHashItem;
var
  Hash: Cardinal;
begin
  Hash := DoCalculateHash(Key);
  Result := @FBuckets[Hash];

  while Result^ <> nil do
  begin
    if Result^.Key.Equal(Key) then
      Exit
    else
      Result := @Result^.Next;
  end;
end;

procedure TCustomHashTable.Clear;
begin
  InternalClear(FBuckets);
  FCount := 0;
end;

procedure TCustomHashTable.ClearDeletedBuckets;
var
  P, N: PHashItem;
begin
  P := FDeleted;

  while P <> nil do
  begin
    N := P^.Next;
    Dispose(P);
    P := N;
  end;
end;

function TCustomHashTable.AcquireNewBucket: PHashItem;
begin
  if FDeleted <> nil then
  begin
    Result := FDeleted;
    FDeleted := FDeleted^.Next;
    Result^.Next := nil;
  end
  else
  begin
    New(Result);
    Result^.Next := nil;
  end;
end;

procedure TCustomHashTable.Add(const Key: TAnyValue; const Value: TAnyValue);
begin
  CheckHashTableSize;

  InternalAdd(@Key, @Value);
  Inc(FCount);
end;

procedure TCustomHashTable.ReleaseOldBucket(const Bucket: PHashItem);
begin
  Bucket^.Next := FDeleted;
  FDeleted := Bucket;

  // clear value and key
  Bucket^.Value.Clear;
  Bucket^.Key.Clear;
end;

procedure TCustomHashTable.Remove(const Key: TAnyValue);
var
  P: PHashItem;
  Prev: PPHashItem;
begin
  Prev := Find(@Key);
  P := Prev^;

  if P <> nil then
  begin
    Prev^ := P^.Next;
    Dec(FCount);

    // return P to deleted
    ReleaseOldBucket(P);
  end;
end;

procedure TCustomHashTable.Resize(const NewSize: Cardinal);
var
  OldBuckets: TBuckets;
  BucketIndex: Integer;
  HashItem: PHashItem;
begin
  FSize := GetGoodHashSize(NewSize);
  CalculateMaxItemsBeforeResize(FSize);

  OldBuckets := FBuckets;
  FBuckets := nil;
  SetLength(FBuckets, FSize);

  for BucketIndex := Low(OldBuckets) to High(OldBuckets) do
  begin
    HashItem := OldBuckets[BucketIndex];
    while HashItem <> nil do
    begin
      InternalAdd(@HashItem^.Key, @HashItem^.Value);
      HashItem := HashItem^.Next;
    end;
  end;

  InternalClear(OldBuckets);
end;

{ TCardinalHashTable }

constructor TCardinalHashTable.Create(const Size: Cardinal);
begin
  inherited Create(Hash_SimpleCardinalMod, Size);
end;

function TCardinalHashTable.DoCalculateHash(const Key: PAnyValue): Cardinal;
var
  KeyData: Cardinal;
begin
  KeyData := Key.AsCardinal;
  Result := FHashFunction(@KeyData, FSize);
end;

{ TStringHashTable }

constructor TStringHashTable.Create(const Size: Cardinal);
begin
  inherited Create(Hash_SuperFastHash, Size);
end;

function TStringHashTable.DoCalculateHash(const Key: PAnyValue): Cardinal;
var
  KeyData: string;
begin
  KeyData := Key.AsString;

  if KeyData <> '' then
    Result := FHashFunction(@KeyData[1], Length(KeyData) * SizeOf(Char)) mod FSize
  else
    Result := 0;
end;

{ THashElement }

constructor THashElement.Create(const Key, Value: PAnyValue);
begin
  FKey := Key;
  FValue := Value;
end;

function THashElement.GetKey: PAnyValue;
begin
  Result := FKey;
end;

function THashElement.GetValue: PAnyValue;
begin
  Result := FValue;
end;

{ THashEnumerator }

constructor THashEnumerator.Create(const HashTable: TCustomHashTable);
begin
  FIndex := 0;
  try
    SetLength(FElementList, HashTable.Count);
    HashTable.EnumerateKeys(InitializeEnum, nil);
  finally
    FCurrentElement := nil;
    FIndex := 0;
  end;
end;

procedure THashEnumerator.InitializeEnum(const Key, Value: PAnyValue; const Data: Pointer);
begin
  FElementList[FIndex] := IHashElement(THashElement.Create(Key, Value));
  Inc(FIndex);
end;

function THashEnumerator.MoveNext: Boolean;
begin
  Result := False;

  if FIndex < Length(FElementList) then
  begin
    FCurrentElement := IHashElement(FElementList[FIndex]);
    Result := True;
    Inc(FIndex);
  end;
end;

function THashEnumerator._GetCurrent: IHashElement;
begin
  Result := FCurrentElement;
end;

end.

