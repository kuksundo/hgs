{
  ======================================================================
  HashList.pas
  ------------
  Copyright © 2000, 2001 Barry Kelly
  barry_j_kelly@hotmail.com

  Feel free to do anything you want with this source code, but don't
  distribute modified versions without clearly marking them as such.
  ======================================================================
  A simple string / pointer associative array. Decent performance.
  ======================================================================
  3/8/2000:
    Initial implementation.
  17/2/2001:
    * Upgraded table lookup, now has separate table for case sensitive
      and case insensitive lookups.
    * Now uses traits metaclass for comparison and hashing.
    * Now uses Cardinals (unsigned) instead of integers for several things.
    * Removed Classes from uses list (most programs using HashList would
      probably use Classes as well, so I'd say little gain there).
  3/3/2001:
    * Changed hash code implementation when not using tables.
  13/3/2001:
    * Changed traits from metaclass to ordinary class; using
      functions like the Printer unit, to avoid unnecessary linking;
      gains probably not worth the effort, but hey - I like my principles
      and I won't pull a "Forms" bloat effect.
  ======================================================================

  Usage:

    Creation:
    ---------
    THashList.Create(<traits metaclass>, <hash size>)

    <traits metaclass> should be either TCaseSensitiveTraits, or
    TCaseInsensitiveTraits, or another descendant of THashListTraits that
    you define.

    <hash size> should be the expected size of the filled hash list. Hash
    size cannot be changed after the fact. However, hash buckets are
    implemented as binary trees so performance should not degrade by
    too much for small overflows.

    Addition
    --------
    procedure Add(const s: string; const p);

    s is the string, p is interpreted as a pointer. It should, therefore,
    be 4 bytes long to avoid garbage.

    Property Access
    ---------------
    property Data[const s: string]: Pointer;

    You can also add implicitly by using the Data property:
      myHashList.Data['MyString'] := Pointer($ABCDEF00);
    This property type is default, so above could be
      myHashList['MyString'] := Pointer($ABCDEF00);

    Note that this is explicitly a pointer. Will return nil
    if s isn't in the hash. Will only implicitly add on Set not Get.

    Deletion
    --------
    function Remove(const s: string): Pointer;
    procedure RemoveData(const p);

    Remove returns the data reference, so it can be freed.

    Deletion from hash lists is a strange business. The bucket must
    be adjusted so that it is still a valid binary search tree. Therefore,
    it is fairly slow. Also, random deletion followed by random insertion
    destroys the randomness of the tree, affecting subsequent performance.

    Random insertion with random deletion, then random insertion, will
    mean the tree will have ~88% the performance of a tree using no
    deletion.

    However, if your hash list is big enough, you don't need to worry about
    this.

    Misc
    ----
    function Has(const s: string): Boolean;

    Returns whether hash contains string s.
    ----
    function Find(const s: string; var p): Boolean;

    Returns true if found, p set to value of data corresponding to s.
    P is not set if not found.
    ----
    function FindData(const p; var s: string): Boolean;

    'Opposite' of Find: searches for key given a data value; Returns
    true if found, s not set if not found. Only first key found is
    returned: there may be other keys that have this data.
    The first key found is not in any particular order, and is found
    using the Iterate method.
    ----
    procedure Iterate(AUserData: Pointer; AIterateFunc: TIterateFunc);

    TIterateFunc = function(AUserData: Pointer; const AStr: string;
      var APtr: Pointer): Boolean;

    AIterateFunc is called for each item in the hash in no particular
    order, and will terminate the iteration if the user function
    ever returns false. The value of APtr can be adjusted, but *not*
    AStr since that would involve destroying the iteration order.

    Iterate_FreeObjects is a predefined function that will typecast
    every Data to TObject and call the Free method. This is useful
    to destroy associated objects in a hash before freeing the hash.
    AUserData isn't used by this iterator.

    Iterate_Dispose will call Dispose on each data object. AUserData
    isn't used.

    Iterate_FreeMem will call FreeMem on each data object. AUserData
    isn't used.

    IterateMethod is similar, but works with a method pointer (closure/
    event) rather than a function pointer.
    ----
    property Count: Integer;

    This contains the number of items in the hash list.


  Note:
    You can inherit and override AllocNode and FreeNode to implement a
    different allocation strategy than Delphi's memory manager.
}

{.$DEFINE USE_HASH_TABLE}
unit HashList;

interface
{$IFDEF XE}
uses system.SysUtils,
{$ENDIF XE}
GeneralHashfunctions;


type
  EHashList = class(Exception);
  THashValue = Cardinal;

type
  THashListTraits = class
  public
    function Hash(const s: string): Cardinal; virtual; abstract;
    function Compare(const l, r: string): Integer; virtual; abstract;
  end;

function CaseSensitiveTraits: THashListTraits;
function CaseInsensitiveTraits: THashListTraits;

type
  { iterate func returns false to terminate iteration }
  TIterateFunc = function(AUserData: Pointer; const AStr: string;
    var APtr: Pointer): Boolean;

  TIterateMethod = function(AUserData: Pointer; const AStr: string;
    var APtr: Pointer): Boolean of object;

  PPHashNode = ^PHashNode;
  PHashNode = ^THashNode;
  THashNode = record
    Str: string;
    Ptr: Pointer;
    Left: PHashNode;
    Right: PHashNode;
  end;

  TNodeIterateFunc = procedure(AUserData: Pointer; ANode: PPHashNode);

  PHashArray = ^THashArray;
  THashArray = array[0..MaxInt div SizeOf(PHashNode) - 1] of PHashNode;

{
  ======================================================================
  THashList
  ======================================================================
}
  THashList = class
  public
    constructor Create(ATraits: THashListTraits; AHashSize: Cardinal);
    destructor Destroy; override;
  private
    FHashSize: Cardinal;
    FCount: Cardinal;
    FList: PHashArray;
    FLeftDelete: Boolean;
    FTraits: THashListTraits;

  protected
    {
      helper methods
    }
    { FindNode returns a pointer to a pointer to the node with s,
      or, if s isn't in the hash, a pointer to the location where the
      node will have to be added to be consistent with the structure }
    function FindNode(const s: string): PPHashNode;
    function IterateNode(ANode: PHashNode; AUserData: Pointer;
      AIterateFunc: TIterateFunc): Boolean;
    function IterateMethodNode(ANode: PHashNode; AUserData: Pointer;
      AIterateMethod: TIterateMethod): Boolean;

    // !!! NB: this function iterates NODES NOT DATA !!!
    procedure NodeIterate(ANode: PPHashNode; AUserData: Pointer;
      AIterateFunc: TNodeIterateFunc);

    { !!! note this function will rehash the table }
    procedure SetHashSize(AHashSize: Cardinal);

    procedure DeleteNode(var q: PHashNode);
    procedure DeleteNodes(var q: PHashNode);

    { !!! NB: AllocNode and FreeNode don't inc / dec the count,
      to remove burden from overridden implementations;
      Therefore, EVERY time AllocNode / FreeNode is called,
      FCount MUST be incremented / decremented to keep Count valid. }
    function AllocNode: PHashNode; virtual;
    procedure FreeNode(ANode: PHashNode); virtual;

    { property access }
    function GetData(const s: string): Pointer;
    procedure SetData(const s: string; p: Pointer);
  public
    { public methods }
    procedure Add(const s: string; const p{: Pointer});
    procedure RemoveData(const p{: Pointer});
    function Remove(const s: string): Pointer;
    procedure Iterate(AUserData: Pointer; AIterateFunc: TIterateFunc);
    procedure IterateMethod(AUserData: Pointer; AIterateMethod: TIterateMethod);
    function Has(const s: string): Boolean;
    function Find(const s: string; var p{: Pointer}): Boolean;
    function FindData(const p{: Pointer}; var s: string): Boolean;

    procedure Clear;

    { properties }
    property Count: Cardinal read FCount;
    property Data[const s: string]: Pointer read GetData write SetData; default;
    property Traits: THashListTraits read FTraits;
  end;

{ str=case sensitive, text=case insensitive }

function StrHash(const s: string): THashValue;
function TextHash(const s: string): THashValue;
function DataHash(var AValue; ASize: Cardinal): THashValue;

{ iterators }
function Iterate_FreeObjects(AUserData: Pointer; const AStr: string;
  var AData: Pointer): Boolean;
function Iterate_Dispose(AUserData: Pointer; const AStr: string;
  var AData: Pointer): Boolean;
function Iterate_FreeMem(AUserData: Pointer; const AStr: string;
  var AData: Pointer): Boolean;

{
  ======================================================================
  Case Sensitive & Insensitive Traits - here for specialization
  ======================================================================
}
type
  TCaseSensitiveTraits = class(THashListTraits)
  public
    function Hash(const s: string): Cardinal; override;
    function Compare(const l, r: string): Integer; override;
  end;

type
  TCaseInsensitiveTraits = class(THashListTraits)
  public
    function Hash(const s: string): Cardinal; override;
    function Compare(const l, r: string): Integer; override;
  end;

implementation

{
  ======================================================================
  Case Sensitive & Insensitive Traits
  ======================================================================
}

function TCaseSensitiveTraits.Compare(const l, r: string): Integer;
begin
  Result := CompareStr(l, r);
end;

function TCaseSensitiveTraits.Hash(const s: string): Cardinal;
begin
  Result := DJBHash(s) ;
end;

function TCaseInsensitiveTraits.Compare(const l, r: string): Integer;
begin
  Result := CompareText(l, r);
end;

function TCaseInsensitiveTraits.Hash(const s: string): Cardinal;
begin
  Result := DJBHash(s);
end;

var
  _CaseSensitiveTraits: TCaseSensitiveTraits;

function CaseSensitiveTraits: THashListTraits;
begin

  if _CaseSensitiveTraits = nil then
   _CaseSensitiveTraits := TCaseSensitiveTraits.Create;
	
  Result := _CaseSensitiveTraits;
end;

var
  _CaseInsensitiveTraits: TCaseInsensitiveTraits;

function CaseInsensitiveTraits: THashListTraits;
begin
  if _CaseInsensitiveTraits = nil then
    _CaseInsensitiveTraits := TCaseInsensitiveTraits.Create;
  Result := _CaseInsensitiveTraits;
end;

function Iterate_FreeObjects(AUserData: Pointer; const AStr: string;
  var AData: Pointer): Boolean;
begin
  TObject(AData).Free;
  AData := nil;
  Result := True;
end;

function Iterate_Dispose(AUserData: Pointer; const AStr: string;
  var AData: Pointer): Boolean;
begin
  Dispose(AData);
  AData := nil;
  Result := True;
end;

function Iterate_FreeMem(AUserData: Pointer; const AStr: string;
  var AData: Pointer): Boolean;
begin
  FreeMem(AData);
  AData := nil;
  Result := True;
end;

{$IFDEF USE_HASH_TABLE}
{ many of these numbers are > High(Cardinal) for D3 & D2; don't know if they
  work, but they should really. }
const
  C_CaseSensitiveTable: array[Char] of Cardinal =
  (
    $74E0D94A, $B56CA37D, $57229F8F, $0000DFF2, $419941DA, $BA9748D6, $B0429BF2, $A28E4B2B,
    $808FF0D0, $731958C4, $FD695447, $7D6AD5F1, $AE0C83C8, $60411A0B, $D072C3A1, $B0631FC2,
    $D5F219F1, $20041A07, $BB486A2E, $D9042211, $EF452040, $001F649B, $8DEB2F7D, $0A2DD4DE,
    $D93BBA0C, $11134B6F, $9481C39A, $60E0B87E, $E638E32C, $AD7720BB, $5FBC5B57, $63278890,
    $BEFA583D, $81C98FDF, $07F2AC14, $FC9D6A69, $DC535F6B, $1491CA05, $9670642A, $AED29294,
    $7694CE70, $54828134, $DA88E2B7, $1376ED78, $41F76F4E, $9C9C56CF, $FA12333E, $581436E7,
    $A3F7C0EA, $596ED174, $748B6CD8, $C60EC233, $8EF33886, $5903EE75, $44E1EDE4, $55C0E5D3,
    $9096E1B5, $5084C133, $3C43D28A, $186EB452, $D81679DD, $AA0006D1, $EA8F2CA9, $FD02A8CC,
    $A94AC43F, $BFEEBDDA, $20430508, $266B5B20, $17534EA8, $D6429C74, $830F5133, $18D2DFF2,
    $852D7155, $3DFAEDB9, $046DD85E, $D6E05646, $71AFEEF5, $4513A51B, $F79FB4B8, $8610B433,
    $75889BB1, $CFA0B53F, $71AEBCDB, $A58A5EAA, $1207BB14, $265BAB7D, $5F1B66BD, $0495B60C,
    $76C61BE6, $0B904DC3, $B94FD13F, $D86F8026, $8985FF25, $A0044A5D, $3730CC26, $4B019C25,
    $05F2C557, $F271C6FE, $6D5D1A7E, $A8CAC3D3, $77BD7959, $EB50820C, $4574B142, $712DDFD2,
    $565842C9, $15B9F96C, $F30D42EF, $8755D2C4, $B712C9B3, $124B0E6A, $9517345E, $8EF2D03A,
    $883D9D1B, $8D016D44, $F26CC54B, $3C225703, $07286AFD, $F78B02DC, $B12DD3AD, $0B746234,
    $FA5B2B85, $4685546F, $319CAC79, $0229FB2C, $27344785, $3D1EB52F, $35DD1F8B, $D77C184F,
    $7E371CBE, $AEBB5005, $1FD92272, $08A005E0, $020AFF4F, $C99ACC8C, $65C20CEA, $D8FF8135,
    $8379929F, $80CB22C7, $1C66E657, $F3376AA9, $6EED77D7, $093B89E4, $5BE4C161, $CD15E219,
    $CAC9EE4A, $10C70570, $03533B17, $34B52754, $FEAA13AC, $DC69E9F7, $F5F73AD6, $D2FFFBD1,
    $D5E35BFA, $9C43D927, $9A4C7A1D, $66F19781, $895F9DC1, $99CC888C, $C855A0A5, $D7288927,
    $81F1E295, $F690F6B9, $147F8DED, $43698601, $74B2010F, $3F3AAA6D, $FF319B5E, $77CFCB8B,
    $382F289A, $485E4B49, $77E1A5A2, $C0CCEDC6, $31ED0140, $87D4CA2A, $A430D82B, $D8B1DFBC,
    $C3EEA499, $02C159E2, $AAF08E2A, $EAFC8F89, $C1E25655, $D99F3F1F, $427DD6ED, $7F28B762,
    $8536E912, $83532214, $E6DA6581, $364C79C9, $943B74CE, $36374C48, $D5CF77E6, $A6E50C8B,
    $8C52BE95, $AC20507D, $E336D079, $350C23C7, $12BE79E7, $2996EB66, $E928E2F1, $FA0145CC,
    $096B15D8, $7090176E, $37763C29, $187B5D16, $0BFE73BE, $052EAEA5, $2E5B7A92, $D267145A,
    $DB4EE4F9, $17E8A399, $F4DC8963, $4B58394C, $32688715, $414DFB41, $766ED76B, $3ABD8DE6,
    $64B7B7D8, $10349B29, $C2901681, $2109A16A, $6562B52A, $3F7FB36B, $B1F7B07D, $E031E474,
    $4C22E64E, $61D34C70, $B346FB75, $0502AA4A, $79073A5D, $2D1315B9, $24680877, $DAA3A10B,
    $0E32ED86, $CC527E48, $0F49EDF8, $D3985303, $F1C9BEC8, $4925050E, $59FBDE7A, $E46078D3,
    $A1D1F8C1, $57E2EBE3, $A59613C5, $7C4EE2F7, $784211D0, $89AB377E, $9761019B, $E75191E5,
    $0C42E625, $75DE9B48, $C6353AFF, $DB1420DA, $E2127ADB, $18EDFDC2, $6179E079, $DC58D2AF
  );

const
  C_CaseInsensitiveTable: array[Char] of Cardinal =
  (
    $74E0D94A, $B56CA37D, $57229F8F, $0000DFF2, $419941DA, $BA9748D6, $B0429BF2, $A28E4B2B,
    $808FF0D0, $731958C4, $FD695447, $7D6AD5F1, $AE0C83C8, $60411A0B, $D072C3A1, $B0631FC2,
    $D5F219F1, $20041A07, $BB486A2E, $D9042211, $EF452040, $001F649B, $8DEB2F7D, $0A2DD4DE,
    $D93BBA0C, $11134B6F, $9481C39A, $60E0B87E, $E638E32C, $AD7720BB, $5FBC5B57, $63278890,
    $BEFA583D, $81C98FDF, $07F2AC14, $FC9D6A69, $DC535F6B, $1491CA05, $9670642A, $AED29294,
    $7694CE70, $54828134, $DA88E2B7, $1376ED78, $41F76F4E, $9C9C56CF, $FA12333E, $581436E7,
    $A3F7C0EA, $596ED174, $748B6CD8, $C60EC233, $8EF33886, $5903EE75, $44E1EDE4, $55C0E5D3,
    $9096E1B5, $5084C133, $3C43D28A, $186EB452, $D81679DD, $AA0006D1, $EA8F2CA9, $FD02A8CC,
    $A94AC43F, $F271C6FE, $6D5D1A7E, $A8CAC3D3, $77BD7959, $EB50820C, $4574B142, $712DDFD2,
    $565842C9, $15B9F96C, $F30D42EF, $8755D2C4, $B712C9B3, $124B0E6A, $9517345E, $8EF2D03A,
    $883D9D1B, $8D016D44, $F26CC54B, $3C225703, $07286AFD, $F78B02DC, $B12DD3AD, $0B746234,
    $FA5B2B85, $4685546F, $319CAC79, $D86F8026, $8985FF25, $A0044A5D, $3730CC26, $4B019C25,
    $05F2C557, $F271C6FE, $6D5D1A7E, $A8CAC3D3, $77BD7959, $EB50820C, $4574B142, $712DDFD2,
    $565842C9, $15B9F96C, $F30D42EF, $8755D2C4, $B712C9B3, $124B0E6A, $9517345E, $8EF2D03A,
    $883D9D1B, $8D016D44, $F26CC54B, $3C225703, $07286AFD, $F78B02DC, $B12DD3AD, $0B746234,
    $FA5B2B85, $4685546F, $319CAC79, $0229FB2C, $27344785, $3D1EB52F, $35DD1F8B, $D77C184F,
    $7E371CBE, $AEBB5005, $1FD92272, $08A005E0, $020AFF4F, $C99ACC8C, $65C20CEA, $D8FF8135,
    $8379929F, $80CB22C7, $1C66E657, $F3376AA9, $6EED77D7, $093B89E4, $5BE4C161, $CD15E219,
    $CAC9EE4A, $10C70570, $03533B17, $34B52754, $FEAA13AC, $DC69E9F7, $F5F73AD6, $D2FFFBD1,
    $D5E35BFA, $9C43D927, $9A4C7A1D, $66F19781, $895F9DC1, $99CC888C, $C855A0A5, $D7288927,
    $81F1E295, $F690F6B9, $147F8DED, $43698601, $74B2010F, $3F3AAA6D, $FF319B5E, $77CFCB8B,
    $382F289A, $485E4B49, $77E1A5A2, $C0CCEDC6, $31ED0140, $87D4CA2A, $A430D82B, $D8B1DFBC,
    $C3EEA499, $02C159E2, $AAF08E2A, $EAFC8F89, $C1E25655, $D99F3F1F, $427DD6ED, $7F28B762,
    $8536E912, $83532214, $E6DA6581, $364C79C9, $943B74CE, $36374C48, $D5CF77E6, $A6E50C8B,
    $8C52BE95, $AC20507D, $E336D079, $350C23C7, $12BE79E7, $2996EB66, $E928E2F1, $FA0145CC,
    $096B15D8, $7090176E, $37763C29, $187B5D16, $0BFE73BE, $052EAEA5, $2E5B7A92, $D267145A,
    $DB4EE4F9, $17E8A399, $F4DC8963, $4B58394C, $32688715, $414DFB41, $766ED76B, $3ABD8DE6,
    $64B7B7D8, $10349B29, $C2901681, $2109A16A, $6562B52A, $3F7FB36B, $B1F7B07D, $E031E474,
    $4C22E64E, $61D34C70, $B346FB75, $0502AA4A, $79073A5D, $2D1315B9, $24680877, $DAA3A10B,
    $0E32ED86, $CC527E48, $0F49EDF8, $D3985303, $F1C9BEC8, $4925050E, $59FBDE7A, $E46078D3,
    $A1D1F8C1, $57E2EBE3, $A59613C5, $7C4EE2F7, $784211D0, $89AB377E, $9761019B, $E75191E5,
    $0C42E625, $75DE9B48, $C6353AFF, $DB1420DA, $E2127ADB, $18EDFDC2, $6179E079, $DC58D2AF
  );
{$ENDIF USE_HASH_TABLE}

function StrHash(const s: string): Cardinal;
var
  i: Integer;
  p: PChar;
{$IFNDEF USE_HASH_TABLE}
const
  C_LongBits = 32;
  C_OneEight = 4;
  C_ThreeFourths = 24;
  C_HighBits = $F0000000;
var
  temp: Cardinal;
{$ENDIF USE_HASH_TABLE}
begin
  {$IFDEF USE_HASH_TABLE}
  Result := 0;
  p := PChar(s);

  i := Length(s);
  if i > 0 then
    repeat
      Result := Result xor C_CaseSensitiveTable[p^];
      Inc(Result);
      Inc(p);
      Dec(i);
    until i = 0;
  {$ELSE USE_HASH_TABLE}
  {TODO I should really be processing 4 bytes at once... }
  Result := 0;
  p := PChar(s);

  i := Length(s);
  while i > 0 do
  begin
    Result := (Result shl C_OneEight) + Ord(p^);
    temp := Result and C_HighBits;
    if temp <> 0 then
      Result := (Result xor (temp shr C_ThreeFourths)) and (not C_HighBits);
    Dec(i);
    Inc(p);
  end;
  {$ENDIF USE_HASH_TABLE}
end;

function TextHash(const s: string): Cardinal;
var
  i: Integer;
  p: PChar;
{$IFNDEF USE_HASH_TABLE}
const
  C_LongBits = 32;
  C_OneEight = 4;
  C_ThreeFourths = 24;
  C_HighBits = $F0000000;
var
  temp: Cardinal;
{$ENDIF USE_HASH_TABLE}
begin
  {$IFDEF USE_HASH_TABLE}
  Result := 0;
  p := PChar(s);

  i := Length(s);
  if i > 0 then
    repeat
      Result := Result xor C_CaseInsensitiveTable[p^];
      Inc(Result);
      Inc(p);
      Dec(i);
    until i = 0;
  {$ELSE USE_HASH_TABLE}
  Result := 0;
  p := PChar(s);

  i := Length(s);
  while i > 0 do
  begin
    Result := (Result shl C_OneEight) + Ord(UpCase(p^));
    temp := Result and C_HighBits;
    if temp <> 0 then
      Result := (Result xor (temp shr C_ThreeFourths)) and (not C_HighBits);
    Dec(i);
    Inc(p);
  end;
  {$ENDIF USE_HASH_TABLE}
end;

function DataHash(var AValue; ASize: Cardinal): THashValue;
var
  p: PChar;
{$IFNDEF USE_HASH_TABLE}
const
  C_LongBits = 32;
  C_OneEight = 4;
  C_ThreeFourths = 24;
  C_HighBits = $F0000000;
var
  temp: Cardinal;
{$ENDIF USE_HASH_TABLE}
begin
  {$IFDEF USE_HASH_TABLE}
  Result := 0;
  p := @AValue;

  if ASize > 0 then
    repeat
      Result := Result xor C_CaseSensitiveTable[p^];
      Inc(Result);
      Inc(p);
      Dec(ASize);
    until ASize = 0;
  {$ELSE USE_HASH_TABLE}
  Result := 0;
  p := @AValue;

  while ASize > 0 do
  begin
    Result := (Result shl C_OneEight) + Ord(p^);
    temp := Result and C_HighBits;
    if temp <> 0 then
      Result := (Result xor (temp shr C_ThreeFourths)) and (not C_HighBits);
    Dec(ASize);
    Inc(p);
  end;
  {$ENDIF USE_HASH_TABLE}
end;

function StrCompare(const l, r: string): Integer;
begin
  Result := CompareStr(l, r);
end;

function TextCompare(const l, r: string): Integer;
begin
  Result := CompareText(l, r);
end;

{
  ======================================================================
  THashList
  ======================================================================
}
constructor THashList.Create(ATraits: THashListTraits; AHashSize: Cardinal);
begin
  Assert(ATraits <> nil, 'HashList must have traits');
  SetHashSize(AHashSize);
  FTraits := ATraits;
end;

destructor THashList.Destroy;
begin
  Clear;
  SetHashSize(0);
  inherited Destroy;
end;

{
  protected methods
}
type
  PPCollectNodeNode = ^PCollectNodeNode;
  PCollectNodeNode = ^TCollectNodeNode;
  TCollectNodeNode = record
    next: PCollectNodeNode;
    str: string;
    ptr: Pointer;
  end;

procedure NodeIterate_CollectNodes(AUserData: Pointer; ANode: PPHashNode);
var
  ppcnn: PPCollectNodeNode absolute AUserData;
  pcnn: PCollectNodeNode;
begin
  New(pcnn);
  pcnn^.next := ppcnn^;
  ppcnn^ := pcnn;

  pcnn^.str := ANode^^.Str;
  pcnn^.ptr := ANode^^.Ptr;
end;

procedure THashList.SetHashSize(AHashSize: Cardinal);
var
  collect_list: PCollectNodeNode;

  procedure CollectNodes;
  var
    i: Integer;
  begin
    collect_list := nil;
    for i := 0 to FHashSize - 1 do
      NodeIterate(@FList^[i], @collect_list, NodeIterate_CollectNodes);
  end;

  procedure InsertNodes;
  var
    pcnn, tmp: PCollectNodeNode;
  begin
    pcnn := collect_list;
    while pcnn <> nil do
    begin
      tmp := pcnn^.next;
      Add(pcnn^.str, pcnn^.ptr);
      Dispose(pcnn);
      pcnn := tmp;
    end;
  end;
begin
  { 4 cases:
    we are empty, and AHashSize = 0 --> nothing to do
    we are full, and AHashSize = 0 --> straight empty
    we are empty, and AHashSize > 0 --> straight allocation
    we are full, and AHashSize > 0 --> rehash }

  if FHashSize = 0 then
    if AHashSize > 0 then
    begin
      GetMem(FList, AHashSize * SizeOf(FList^[0]));
      FillChar(FList^, AHashSize * SizeOf(FList^[0]), 0);
      FHashSize := AHashSize;
    end
    else
      { nothing to do }
  else
  begin
    if AHashSize > 0 then
    begin
      { must rehash table }
      CollectNodes;
      Clear;
      ReallocMem(FList, AHashSize * SizeOf(FList^[0]));
      FillChar(FList^, AHashSize * SizeOf(FList^[0]), 0);
      FHashSize := AHashSize;
      InsertNodes;
    end
    else
    begin
      { we are clearing the table - need hash to be empty }
      if FCount > 0 then
        raise EHashList.Create('HashList: must be empty to set size to zero');
      FreeMem(FList);
      FList := nil;
      FHashSize := 0;
    end;
  end;
end;

{
  helper methods
}
function THashList.FindNode(const s: string): PPHashNode;
var
  i: Cardinal;
  r: Integer;
  ppn: PPHashNode;
begin
  { we start at the node offset by s in the hash list }
  i := FTraits.Hash(s) mod FHashSize;

  ppn := @FList^[i];

  if ppn^ <> nil then
    while True do
    begin
      r := FTraits.Compare(s, ppn^^.Str);

      { left, then right, then match }
      if r < 0 then
        ppn := @ppn^^.Left
      else if r > 0 then
        ppn := @ppn^^.Right
      else
        Break;

      { check for empty position after drilling left or right }
      if ppn^ = nil then
        Break;
    end;

  Result := ppn;
end;

function THashList.IterateNode(ANode: PHashNode; AUserData: Pointer;
  AIterateFunc: TIterateFunc): Boolean;
begin
  if ANode <> nil then
  begin
    Result := AIterateFunc(AUserData, ANode^.Str, ANode^.Ptr);
    if not Result then
      Exit;

    Result := IterateNode(ANode^.Left, AUserData, AIterateFunc);
    if not Result then
      Exit;

    Result := IterateNode(ANode^.Right, AUserData, AIterateFunc);
    if not Result then
      Exit;
  end else
    Result := True;
end;

function THashList.IterateMethodNode(ANode: PHashNode; AUserData: Pointer;
  AIterateMethod: TIterateMethod): Boolean;
begin
  if ANode <> nil then
  begin
    Result := AIterateMethod(AUserData, ANode^.Str, ANode^.Ptr);
    if not Result then
      Exit;

    Result := IterateMethodNode(ANode^.Left, AUserData, AIterateMethod);
    if not Result then
      Exit;

    Result := IterateMethodNode(ANode^.Right, AUserData, AIterateMethod);
    if not Result then
      Exit;
  end else
    Result := True;
end;

procedure THashList.NodeIterate(ANode: PPHashNode; AUserData: Pointer;
  AIterateFunc: TNodeIterateFunc);
begin
  if ANode^ <> nil then
  begin
    AIterateFunc(AUserData, ANode);
    NodeIterate(@ANode^.Left, AUserData, AIterateFunc);
    NodeIterate(@ANode^.Right, AUserData, AIterateFunc);
  end;
end;

procedure THashList.DeleteNode(var q: PHashNode);
var
  t, r, s: PHashNode;
begin
  { we must delete node q without destroying binary tree }
  { Knuth 6.2.2 D (pg 432 Vol 3 2nd ed) }

  { alternating between left / right delete to preserve decent
    performance over multiple insertion / deletion }
  FLeftDelete := not FLeftDelete;

  { t will be the node we delete }
  t := q;

  if FLeftDelete then
  begin
    if t^.Right = nil then
      q := t^.Left
    else
    begin
      r := t^.Right;
      if r^.Left = nil then
      begin
        r^.Left := t^.Left;
        q := r;
      end else
      begin
        s := r^.Left;
        if s^.Left <> nil then
          repeat
            r := s;
            s := r^.Left;
          until s^.Left = nil;
        { now, s = symmetric successor of q }
        s^.Left := t^.Left;
        r^.Left :=  s^.Right;
        s^.Right := t^.Right;
        q := s;
      end;
    end;
  end else
  begin
    if t^.Left = nil then
      q := t^.Right
    else
    begin
      r := t^.Left;
      if r^.Right = nil then
      begin
        r^.Right := t^.Right;
        q := r;
      end else
      begin
        s := r^.Right;
        if s^.Right <> nil then
          repeat
            r := s;
            s := r^.Right;
          until s^.Right = nil;
        { now, s = symmetric predecessor of q }
        s^.Right := t^.Right;
        r^.Right := s^.Left;
        s^.Left := t^.Left;
        q := s;
      end;
    end;
  end;

  { we decrement before because the tree is already adjusted
    => any exception in FreeNode MUST be ignored.

    It's unlikely that FreeNode would raise an exception anyway. }
  Dec(FCount);
  FreeNode(t);
end;

procedure THashList.DeleteNodes(var q: PHashNode);
begin
  if q^.Left <> nil then
    DeleteNodes(q^.Left);
  if q^.Right <> nil then
    DeleteNodes(q^.Right);
  FreeNode(q);
  q := nil;
end;

function THashList.AllocNode: PHashNode;
begin
  New(Result);
  Result^.Left := nil;
  Result^.Right := nil;
end;

procedure THashList.FreeNode(ANode: PHashNode);
begin
  Dispose(ANode);
end;

{
  property access
}
function THashList.GetData(const s: string): Pointer;
var
  ppn: PPHashNode;
begin
  ppn := FindNode(s);

  if ppn^ <> nil then
    Result := ppn^^.Ptr
  else
    Result := nil;
end;

procedure THashList.SetData(const s: string; p: Pointer);
var
  ppn: PPHashNode;
begin
  ppn := FindNode(s);

  if ppn^ <> nil then
    ppn^^.Ptr := p
  else
  begin
    { add }
    ppn^ := AllocNode;
    { we increment after in case of exception }
    Inc(FCount);
    ppn^^.Str := s;
    ppn^^.Ptr := p;
  end;
end;

{
  public methods
}
procedure THashList.Add(const s: string; const p{: Pointer});
var
  ppn: PPHashNode;
begin
  ppn := FindNode(s);

  { if reordered from SetData because ppn^ = nil is more common for Add }
  if ppn^ = nil then
  begin
    { add }
    ppn^ := AllocNode;
    { we increment after in case of exception }
    Inc(FCount);
    ppn^^.Str := s;
    ppn^^.Ptr := Pointer(p);
 end else 
begin
 raise EHashList.CreateFmt('Duplicate hash list entry: %s', [s]);
end;
end;
type
  PListNode = ^TListNode;
  TListNode = record
    Next: PListNode;
    NodeLoc: PPHashNode;
  end;

  PDataParam = ^TDataParam;
  TDataParam = record
    Head: PListNode;
    Data: Pointer;
  end;

procedure NodeIterate_BuildDataList(AUserData: Pointer; ANode: PPHashNode);
var
  dp: PDataParam absolute AUserData;
  t: PListNode;
begin
  if dp.Data = ANode^^.Ptr then
  begin
    New(t);
    t^.Next := dp.Head;
    t^.NodeLoc := ANode;
    dp.Head := t;
  end;
end;

procedure THashList.RemoveData(const p{: Pointer});
var
  dp: TDataParam;
  i: Integer;
  n, t: PListNode;
begin
  dp.Data := Pointer(p);
  dp.Head := nil;

  for i := 0 to FHashSize - 1 do
    NodeIterate(@FList^[i], @dp, NodeIterate_BuildDataList);

  n := dp.Head;
  while n <> nil do
  begin
    DeleteNode(n^.NodeLoc^);
    t := n;
    n := n^.Next;
    Dispose(t);
  end;
end;

function THashList.Remove(const s: string): Pointer;
var
  ppn: PPHashNode;
begin
  ppn := FindNode(s);

  if ppn^ <> nil then
  begin
    Result := ppn^^.Ptr;
    DeleteNode(ppn^);
  end
  else
    raise EHashList.CreateFmt('Tried to remove invalid node: %s', [s]);
end;

procedure THashList.IterateMethod(AUserData: Pointer;
  AIterateMethod: TIterateMethod);
var
  i: Integer;
begin
  for i := 0 to FHashSize - 1 do
    if not IterateMethodNode(FList^[i], AUserData, AIterateMethod) then
      Break;
end;

procedure THashList.Iterate(AUserData: Pointer; AIterateFunc: TIterateFunc);
var
  i: Integer;
begin
  for i := 0 to FHashSize - 1 do
    if not IterateNode(FList^[i], AUserData, AIterateFunc) then
      Break;
end;

function THashList.Has(const s: string): Boolean;
var
  ppn: PPHashNode;
begin
  ppn := FindNode(s);
  Result := ppn^ <> nil;
end;

function THashList.Find(const s: string; var p{: Pointer}): Boolean;
var
  ppn: PPHashNode;
begin
  ppn := FindNode(s);
  Result := ppn^ <> nil;
  if Result then
    Pointer(p) := ppn^^.Ptr;
end;

type
  PFindDataResult = ^TFindDataResult;
  TFindDataResult = record
    Found: Boolean;
    ValueToFind: Pointer;
    Key: string;
  end;

function Iterate_FindData(AUserData: Pointer; const AStr: string;
  var APtr: Pointer): Boolean;
var
  pfdr: PFindDataResult absolute AUserData;
begin
  pfdr^.Found := (APtr = pfdr^.ValueToFind);
  Result := not pfdr^.Found;
  if pfdr^.Found then
    pfdr^.Key := AStr;
end;

function THashList.FindData(const p{: Pointer}; var s: string): Boolean;
var
  pfdr: PFindDataResult;
begin
  New(pfdr);
  try
    pfdr^.Found := False;
    pfdr^.ValueToFind := Pointer(p);
    Iterate(pfdr, Iterate_FindData);
    Result := pfdr^.Found;
    if Result then
      s := pfdr^.Key;
  finally
    Dispose(pfdr);
  end;
end;

procedure THashList.Clear;
var
  i: Integer;
  ppn: PPHashNode;
begin
  for i := 0 to FHashSize - 1 do
  begin
    ppn := @FList^[i];
    if ppn^ <> nil then
      DeleteNodes(ppn^);
  end;
  FCount := 0;
end;

begin
_CaseSensitiveTraits:=nil;
_CaseInSensitiveTraits:=nil;
end.

