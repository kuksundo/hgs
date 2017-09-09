//******************************************************************************
//
// EventSinkImp
//
// Copyright © 1999-2000 Binh Ly
// All Rights Reserved
//
// bly@techvanguards.com
// http://www.techvanguards.com
//******************************************************************************
unit EventSinkParser;

interface

uses
  Windows,
  Classes,
  EventSinkOptions
  ;

const
  ctkInterface = 'INTERFACE';
  ctkDispInterface = 'DISPINTERFACE';
  ctkCoClass = 'CLASS';
  ctkEnum = 'TOLEENUM';

type
  TParamIOType = (ioUnknown, ioConst, ioVar);

  TParamDataType = (
    dtUserDefined,
    dtByte,
    dtSmallint,
    dtLongint,
    dtSingle,
    dtDouble,
    dtWordbool,
    dtHResult,
    dtCurrency,
    dtDateTime,
    dtWidestring,
    dtIUnknown,
    dtIDispatch,
    dtSafeArray,
    dtVariant
  );

  TMethodType = (mtUnknown, mtProcedure, mtFunction);

const
  cParamDataTypes: array [TParamDataType] of string = (
    { UserDefined }
    '',

    { Byte }
    '/Byte/',

    { Smallint }
    '/Smallint/' +
    '/OLE_TRISTATE/'
    ,

    { Longint }
    '/Longint/Integer/' +
    '/OLE_XPOS_PIXELS/OLE_YPOS_PIXELS/OLE_XSIZE_PIXELS/OLE_YSIZE_PIXELS/' +
    '/OLE_XPOS_HIMETRIC/OLE_YPOS_HIMETRIC/OLE_XSIZE_HIMETRIC/OLE_YSIZE_HIMETRIC/' +
    '/SYSINT/SYSUINT/SCODE/'
    ,

    { Single }
    '/Single/' +
    '/OLE_XPOS_CONTAINER/OLE_YPOS_CONTAINER/OLE_XSIZE_CONTAINER/' +
    '/OLE_YSIZE_CONTAINER/'
    ,

    { Double }
    '/Double/',

    { WordBool }
    '/Wordbool/',

    { HResult }
    '/HResult/',

    { Currency }
    '/Currency/',

    { DateTime }
    '/DateTime/',

    { WideString }
    '/Widestring/',

    { IUnknown descendant }
    '/IUnknown/' +
    '/IProvider/IProviderDisp/IStrings/IStringsDisp/IDataBroker/IDataBrokerDisp/'
    ,

    { IDispatch }
    '/IDispatch/',

    { SafeArray }
    '/PSafeArray/',

    { Variant }
    '/OleVariant/'
  );

  cCallConvSafecall = 'safecall';
  cCallConvStdcall = 'stdcall';

type
  TTypeInfosParser = class;

  TTypeInfoKind = (
    tkUnknown,
    tkInterfaceForward, tkInterface,
    tkDispInterfaceForward, tkDispInterface,
    tkCoClass,
    tkEnum,
    tkAlias
  );

  TInterfaceMethodParam = class
  public
    IOType: TParamIOType;
    DataType: TParamDataType;
    DataTypeName: string;
    Name: string;
    Kind: TTypeInfoKind;
    procedure Parse (const sParam: string);
  end;

  TInterfaceMethodParams = class
  protected
    FItems: TList;
    function GetItems (i: integer): TInterfaceMethodParam;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    function Count: integer;
    procedure Parse (const sParams: string);
    property Items [i: integer]: TInterfaceMethodParam read GetItems; default;
  end;

  TInterface = class;

  TInterfaceMethod = class
  protected
    FParams: TInterfaceMethodParams;
    FInfo: string;
    FOrigName: string;
    function GetAsDeclaration: string;
    function GetAsDefinition (const sClassName: string): string;
    function GetAsEventCall: string;
    function GetAsEventDeclaration: string;
    function GetAsEventName: string;
    function GetAsEventType: string;
    function GetAsISinkInterfaceMethod (const sQualifier: string): string;
  public
    CallConv: string;
    DispId: integer;
    Intf: TInterface;
    Name: string;
    MethodType: TMethodType;
    constructor Create; virtual;
    destructor Destroy; override;
    function IsValidSinkMethod: boolean;
    procedure Parse (const sMethod: string);
    property AsDeclaration: string read GetAsDeclaration;
    property AsDefinition [const sClassName: string]: string read GetAsDefinition;
    property AsEventCall: string read GetAsEventCall;
    property AsEventDeclaration: string read GetAsEventDeclaration;
    property AsEventName: string read GetAsEventName;
    property AsEventType: string read GetAsEventType;
    property AsISinkInterfaceMethod [const sQualifier: string]: string read GetAsISinkInterfaceMethod;
    property Info: string read FInfo;
    property Params: TInterfaceMethodParams read FParams;
  end;

  TInterfaceMethods = class
  protected
    FItems: TList;
    function GetItems (i: integer): TInterfaceMethod;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    function Count: integer;
    procedure Parse (pIntf: TInterface; lstMethods: TStrings);
    property Items [i: integer]: TInterfaceMethod read GetItems; default;
  end;

  TInterfaceKind = (ikInterface, ikDispInterface);

  TInterface = class
  protected
    FInfo: TStringList;
    FMethods: TInterfaceMethods;
  public
    Kind: TInterfaceKind;
    Name: string;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Parse (lstData: TStrings);
    procedure ResolveMethodDispIds (tiDisp: TInterface);
    procedure ResolveMethodParamTypes (tisp: TTypeInfosParser);
    property Info: TStringList read FInfo;
    property Methods: TInterfaceMethods read FMethods;
  end;

  TTypeInfoParser = class
  protected
    FInfo: TStringList;
    FKind: TTypeInfoKind;
    function GetAsAliasedName: string;
    function GetAsForwardDeclaration: string;
    function GetName: string;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Parse (lstData: TStrings; var iInfoLine: integer; bAlias: boolean);
    property AsAliasedName: string read GetAsAliasedName;
    property AsForwardDeclaration: string read GetAsForwardDeclaration;
    property Info: TStringList read FInfo;
    property Kind: TTypeInfoKind read FKind;
    property Name: string read GetName;
  end;

  TTypeInfosParseMode = (pmNormal, pmRecursive);
  
  TTypeInfosParser = class
  protected
    FExternalUses: TStringList;
    FItems: TList;
    FItemsIndex: TStringList;
    FForwards: TStringList;
    function GetItemByName (const sName: string): TTypeInfoParser;
    function GetItems (iIndex: integer): TTypeInfoParser;
    function FindNextTypeInfo (
      lstData: TStrings; var iInfoLine: integer; var bIsAlias: boolean): boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Add (tip: TTypeInfoParser): integer;
    procedure Clear;
    function Count: integer;
    procedure Parse (const sSourceFilename: string; lstData: TStrings; pm: TTypeInfosParseMode);
    property ExternalUses: TStringList read FExternalUses;
    property ItemByName [const s: string]: TTypeInfoParser read GetItemByName;
    property Items [i: integer]: TTypeInfoParser read GetItems;
  end;

  TSinkComponentBuilder = class
  protected
    FTemplate: TStringList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure BuildSource (eso: TEventSinkOptions;
      const sLibSourceFile, sUnitName, LibName: string;
      lstSource, lstTypeLibSource, lstSinkInterfaces: TStrings);
    procedure MergeSource (lstSource, lstSinkSource: TStrings);
    property Template: TStringList read FTemplate;
  end;

  TRegTypeLib = class
  protected
    FLibName: string;
    function GetLibName: string;
  public
    Description: string;
    Filename: string;
    procedure FindSourceInterfaces (lstInterfaces: TStrings);
    procedure LoadInfo (const sFilename: string);
    property LibName: string read GetLibName;
  end;

  TRegTypeLibs = class
  protected
    FItems: TList;
    function GetItems (i: integer): TRegTypeLib;
    procedure Sort;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    function Count: integer;
    procedure ReadRegistry;
    property Items [i: integer]: TRegTypeLib read GetItems; default;
  end;

procedure GetTypeLibDescription (
  const sFilename: string; var sName, sDesc: string);

implementation

uses
  ActiveX,
  ComObj,
  Dialogs,
  Registry,
  SysUtils
  ;

const
  cSinkComponentName = 'TSinkComponent';
  cSinkBaseClassName = 'TBaseSink';

{ globals }

type
  TCharset = set of char;

function IsWhitespace (const s: string): boolean;
var
  i: integer;
  ch: char;
begin
  Result := FALSE;
  for i := 1 to Length (s) do
  begin
    ch := s [i];
    if not (ch in [' ', #9, #13, #10, #27]) then Exit;
  end;  { for }
  Result := TRUE;
end;

procedure TokenizeLine (const sLine: string; lstTokens: TStrings);
const
  csTokenDelims: TCharset = ['(', ')', ';', ':', '[', ']', ','];

 procedure AddToken (const sToken: string);
 begin
   if (sToken <> '') then lstTokens.Add (sToken);
 end;

var
  i: integer;
  sToken: string;
begin
  Assert (lstTokens <> nil);

  sToken := '';
  for i := 1 to Length (sLine) do
  begin
    { skip whitespace }
    if (IsWhitespace (sLine [i])) then
    begin
      if (sToken <> '') then AddToken (sToken);
      sToken := '';
      Continue;
    end;  { if }

    if (sLine [i] in csTokenDelims) then
    begin
      AddToken (sToken);
      AddToken (sLine [i]);
      sToken := '';
    end
    else begin
      sToken := sToken + sLine [i];
    end;  { else }
  end;  { for }

  if (sToken <> '') then AddToken (sToken);
end;

function GetParamDataType (const sDataType: string): TParamDataType;
begin
  for Result := Low (TParamDataType) to High (TParamDataType) do
    if (Pos ('/' + Uppercase (sDataType) + '/', Uppercase (cParamDataTypes [Result])) > 0) then
      Exit;

  Result := dtUserDefined;
end;

function GetTypeInfoKind (const sLine: string): TTypeInfoKind;
var
  lstTokens: TStringList;
  bIsForwardDecl: boolean;
  sKind: string;
begin
  Result := tkUnknown;
  lstTokens := TStringList.Create;
  try
    TokenizeLine (sLine, lstTokens);

    { must be at least xx = yy }
    if (lstTokens.Count < 3) then Exit;
    if (lstTokens [1] <> '=') then Exit;

    { must not end in ';', otherwise it's a forward declaration }
    bIsForwardDecl := (lstTokens [lstTokens.Count - 1] = ';');

    { case out }
    sKind := Uppercase (lstTokens [2]);
    if (sKind = ctkInterface) then
      Result := tkInterface else
    if (sKind = ctkDispInterface) then
      Result := tkDispInterface else
    if (sKind = ctkCoclass) then
      Result := tkCoClass else
    if (sKind = ctkEnum) then
      Result := tkEnum else
    if (GetParamDataType (sKind) <> dtUserDefined) then
      Result := tkAlias else
    ;

    if (bIsForwardDecl) then
    begin
      case Result of
        tkInterface :
          Result := tkInterfaceForward;
        tkDispInterface :
          Result := tkDispInterfaceForward;
        tkEnum, tkAlias :
          ;
        else
          Result := tkUnknown;
      end;  { case }
    end;  { if }
  finally
    lstTokens.Free;
  end;  { finally }
end;

function ParseUntil (
  lstData: TStrings; var iInfoLine: integer; lstInfo: TStrings;
  const sStopToken: string
): boolean;

 function TokensMatch (lstTokens1, lstTokens2: TStrings): boolean;
 var
   i: integer;
 begin
   Result := FALSE;
   if (lstTokens1.Count <> lstTokens2.Count) then Exit;

   for i := 0 to lstTokens1.Count - 1 do
   begin
     if (CompareText (lstTokens1 [i], lstTokens2 [i]) <> 0) then Exit;
   end;  { if }

   Result := TRUE;
 end;

var
  lstTokens, lstStopTokens: TStringList;
  sLine: string;
begin
  Assert ((lstData <> nil) and (lstInfo <> nil));
  Result := FALSE;
  if (iInfoLine < 0) or (iInfoLine >= lstData.Count) then Exit;

  lstTokens := TStringList.Create;
  lstStopTokens := TStringList.Create;
  try
    TokenizeLine (sStopToken, lstStopTokens);

    while (iInfoLine < lstData.Count) do
    begin
      lstTokens.Clear;
      sLine := lstData [iInfoLine];
      lstInfo.Add (sLine);

      iInfoLine := iInfoLine + 1;

      { see if we should stop }
      TokenizeLine (sLine, lstTokens);
      if (TokensMatch (lstTokens, lstStopTokens)) then
      begin
        Result := TRUE;
        Break;
      end;  { if }
    end;
  finally
    lstStopTokens.Free;
    lstTokens.Free;
  end;  { finally }
end;

function GetParamIOType (const sIOType: string): TParamIOType;
begin
  Result := ioConst;
  if (sIOType = '') then Exit;

  if (CompareText (sIOType, 'CONST') = 0) or (CompareText (sIOType, 'IN') = 0) then
    Result := ioConst else
  if (CompareText (sIOType, 'VAR') = 0) or (CompareText (sIOType, 'OUT') = 0) then
    Result := ioVar else
  Result := ioUnknown;
end;

function GetMethodType (const sMethod: string): TMethodType;
var
  lstTokens: TStringList;
  sMethodType: string;
begin
  Result := mtUnknown;
  lstTokens := TStringList.Create;
  try
    TokenizeLine (sMethod, lstTokens);
    if (lstTokens.Count <= 0) then Exit;

    sMethodType := lstTokens [0];
    if (CompareText (sMethodType, 'Procedure') = 0) then
      Result := mtProcedure else
    if (CompareText (sMethodType, 'Function') = 0) then
      Result := mtFunction
    ;
  finally
    lstTokens.Free;
  end;  { finally }
end;

function IsMethod (const sMethod: string): boolean;
begin
  Result := FALSE;
  if (sMethod = '') then Exit;
  Result := (GetMethodType (sMethod) <> mtUnknown);
end;

function FindLine (const sFindLine: string; lstData: TStrings; var iLine: integer): boolean;
var
  sLine: string;
begin
  Result := FALSE;
  if (iLine < 0) or (iLine >= lstData.Count) then Exit;

  while (iLine < lstData.Count) do
  begin
    sLine := Trim (lstData [iLine]);
    if (CompareText (sFindLine, sLine) = 0) then
    begin
      Result := TRUE;
      Break;
    end;  { if }
    iLine := iLine + 1;
  end;  { while }
end;

function FindPartialLine (const sFindLine: string; lstData: TStrings; var iLine: integer): boolean;
var
  sLine: string;
begin
  Result := FALSE;
  if (iLine < 0) or (iLine >= lstData.Count) then Exit;

  while (iLine < lstData.Count) do
  begin
    sLine := lstData [iLine];
    if (Pos (Uppercase (sFindLine), Uppercase (sLine)) > 0) then
    begin
      Result := TRUE;
      Break;
    end;  { if }
    iLine := iLine + 1;
  end;  { while }
end;

function SearchAndReplace (var sText: string; const sSearch, sReplace: string): integer;
var
  i: integer;
begin
  Result := 0;
  i := Pos (sSearch, sText);
  while (i > 0) do
  begin
    Result := Result + 1;
    Delete (sText, i, Length (sSearch));
    Insert (sReplace, sText, i);
    i := Pos (sSearch, sText);
  end;  { while }
end;

procedure SearchAndReplaceLinesEx (lstLines: TStrings; const sSearch, sReplace: string;
  iLineStart, iLineEnd: integer);
var
  i: integer;
  sLine: string;
begin
  Assert (lstLines <> nil);

  { validate }
  if (iLineStart < 0) or (iLineStart >= lstLines.Count) then iLineStart := 0;
  if (iLineEnd < 0) or (iLineEnd >= lstLines.Count) then iLineEnd := lstLines.Count - 1;

  for i := iLineStart to iLineEnd do
  begin
    sLine := lstLines [i];
    if (SearchAndReplace (sLine, sSearch, sReplace) <= 0) then Continue;
    lstLines [i] := sLine;
  end;  { for }
end;

procedure SearchAndReplaceLines (lstLines: TStrings; const sSearch, sReplace: string);
begin
  Assert (lstLines <> nil);
  SearchAndReplaceLinesEx (lstLines, sSearch, sReplace, 0, lstLines.Count - 1);
end;

procedure IndentLines (lstLines: TStrings; iIndent, iLineStart, iLineEnd: integer);
var
  i: integer;
  sIndent: string;
begin
  Assert (lstLines <> nil);
  if (iIndent <= 0) then Exit;

  { validate }
  if (iLineStart < 0) or (iLineStart >= lstLines.Count) then iLineStart := 0;
  if (iLineEnd < 0) or (iLineEnd >= lstLines.Count) then iLineEnd := lstLines.Count - 1;

  sIndent := StringOfChar (' ', iIndent);
  for i := iLineStart to iLineEnd do
  begin
    lstLines [i] := sIndent + lstLines [i];
  end;  { for }
end;

procedure GetTypeLibDescription (
  const sFilename: string; var sName, sDesc: string);
var
  pTypeLib: ITypeLib;
  wsName, wsDoc: widestring;
begin
  OleCheck (LoadTypeLibEx (PWideChar (widestring (sFilename)), REGKIND_NONE, pTypeLib));
  OleCheck (pTypeLib.GetDocumentation (MEMBERID_NIL, @wsName, @wsDoc, nil, nil));
  sName := wsName;
  sDesc := wsDoc;
end;

procedure InsertStringsEx (lstTarget, lstSource: TStrings;
  iTargetIndex, iSourceIndexStart, iSourceIndexEnd: integer);
var
  i: integer;
begin
  Assert ((lstTarget <> nil) and (lstSource <> nil));
  if (iTargetIndex < 0) or (iTargetIndex >= lstTarget.Count) then Exit;
  if (iSourceIndexStart < 0) or (iSourceIndexStart >= lstSource.Count) then Exit;
  if (iSourceIndexEnd < 0) or (iSourceIndexEnd >= lstSource.Count) then Exit;

  for i := iSourceIndexStart to iSourceIndexEnd do
  begin
    lstTarget.Insert (iTargetIndex, lstSource [i]);
    iTargetIndex := iTargetIndex + 1;
  end;  { for }
end;

procedure InsertStrings (lstTarget, lstSource: TStrings; iTargetIndex: integer);
begin
  InsertStringsEx (lstTarget, lstSource, iTargetIndex, 0, lstSource.Count - 1);
end;

function RemoveComments (const sLine: string): string;
var
  i, j: integer;
begin
  Result := sLine;

  { remove '{'  }
  i := Pos ('{', Result);
  while (i > 0) do
  begin
    j := Pos ('}', Copy (Result, i, Length (Result)));
    if (j > 0) then Delete (Result, i, j);
    i := Pos ('{', Result);
  end;  { while }
end;

function IsUserDefExternalUses (const sUses: string): boolean;
begin
  Result := (Pos ('_TLB', Uppercase (sUses)) > 0);
end;

function IsSystemExternalUses (const sUses: string): boolean;
begin
  Result := (CompareText (sUses, 'StdVCL') = 0);
end;

function GetValidMethodName (const sName: string): string;
const
  // validated list (prepend On). can add more in the future!
  sKeywords = '|Connect|Disconnect|Create|Destroy|Forward|';
begin
  Result := sName;
  if (Pos ('|' + Uppercase (sName) + '|', Uppercase (sKeywords)) > 0) then
    Result := 'On' + sName;  // just prepend 'On'
end;


{ TInterfaceMethodParam }

procedure TInterfaceMethodParam.Parse (const sParam: string);
var
  lstTokens: TStringList;
  sIOType: string;
begin
  lstTokens := TStringList.Create;
  try
    TokenizeLine (sParam, lstTokens);

    { param syntax is: [IOType] <Name>: <DataType> }
    if (lstTokens.Count < 3) or (lstTokens.Count > 4) then
      raise Exception.Create ('Invalid parameter syntax: ' + sParam);

    { parse out constituents }
    sIOType := '';
    if (lstTokens.Count = 4) then
    begin
      sIOType := lstTokens [0];
      lstTokens.Delete (0);
    end;  { if }

    IOType := GetParamIOType (sIOType);
    Name := lstTokens [0];
    DataTypeName := lstTokens [2];
    DataType := GetParamDataType (DataTypeName);
    Kind := tkUnknown;
    case DataType of
      dtIUnknown, dtIDispatch :
        Kind := tkInterface;
    end;  { case }
  finally
    lstTokens.Free;
  end;  { finally }
end;


{ TInterfaceMethodParams }

function TInterfaceMethodParams.GetItems (i: integer): TInterfaceMethodParam;
begin
  Assert ((i >= 0) and (i < Count));
  Result := TInterfaceMethodParam (FItems [i]);
end;

constructor TInterfaceMethodParams.Create;
begin
  inherited Create;
  FItems := TList.Create;
end;

destructor TInterfaceMethodParams.Destroy;
begin
  Clear;
  FItems.Free;
  inherited;
end;

procedure TInterfaceMethodParams.Clear;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    Items [i].Free;
  FItems.Clear;
end;

function TInterfaceMethodParams.Count: integer;
begin
  Result := FItems.Count;
end;

procedure TInterfaceMethodParams.Parse (const sParams: string);

 procedure ParseNextParam (lstTokens, lstParams: TStringList; var iTokenPos: integer);
 var
   sIOType, sDataType, sNextToken: string;
   i: integer;
 begin
   lstParams.Clear;
   if (iTokenPos < 0) or (iTokenPos >= lstTokens.Count) then Exit;

   { extract IOType }
   if (iTokenPos + 1 >= lstTokens.Count) then Exit;
   sNextToken := lstTokens [iTokenPos + 1];
   if (sNextToken <> ',') and (sNextToken <> ':') then
   begin
     sIOType := lstTokens [iTokenPos];
     iTokenPos := iTokenPos + 1;
   end;  { if }

   sDataType := '';
   
   while (iTokenPos < lstTokens.Count) do
   begin
     { find until ';' or end of list }
     if (lstTokens [iTokenPos] = ';') then
     begin
       iTokenPos := iTokenPos + 1;
       Break;
     end;  { if }

     { ',' are same param separators }
     if (lstTokens [iTokenPos] = ',') then
     begin
       iTokenPos := iTokenPos + 1;
       Continue;
     end;  { if }

     { found param data type }
     if (lstTokens [iTokenPos] = ':') then
     begin
       sDataType := lstTokens [iTokenPos + 1];
       iTokenPos := iTokenPos + 2;
       Continue;
     end;  { if }

     { param found, add it to list }
     lstParams.Add (lstTokens [iTokenPos]);

     iTokenPos := iTokenPos + 1;
   end;  { while }

   { loop and add IOType and DataType to each param }
   for i := 0 to lstParams.Count - 1 do
     lstParams [i] := Trim (Format ('%s %s: %s', [sIOType, lstParams [i], sDataType]));
 end;

var
  lstTokens: TStringList;
  lstParams: TStringList;
  i, j: integer;
  mp: TInterfaceMethodParam;
begin
  Clear;
  
  lstTokens := TStringList.Create;
  lstParams := TStringList.Create;
  try
    TokenizeLine (RemoveComments (sParams), lstTokens);
    i := 0;
    while (i < lstTokens.Count) do
    begin
      lstParams.Clear;
      ParseNextParam (lstTokens, lstParams, i);

      for j := 0 to lstParams.Count - 1 do
      begin
        mp := TInterfaceMethodParam.Create;
        mp.Parse (lstParams [j]);
        FItems.Add (mp);
      end;  { for }
    end;  { while }
  finally
    lstParams.Free;
    lstTokens.Free;
  end;  { finally }
end;


{ TInterfaceMethod }

function TInterfaceMethod.GetAsDeclaration: string;
begin
  { format is <procedure decl> <CallConv> }
  Result := Format ('%s %s;', [AsDefinition [''], CallConv]);
end;

function TInterfaceMethod.GetAsDefinition (const sClassName: string): string;
var
  i: integer;
begin
  { format is <procedure decl> }

  { extract "procedure (...);" part }
  i := Pos (')', Info);
  i := i + Pos (';', Copy (Info, i + 1, Length (Info)));
  Result := Copy (Info, 1, i);

  { prepend Do<MethodName> }
  i := Pos (' ' + Name, Result);
  if (i > 0) then
  begin
    Insert ('Do', Result, i + 1);
    if (sClassName <> '') then
      Insert (sClassName + '.', Result, i + 1);
  end;  { if }
end;

function TInterfaceMethod.GetAsEventCall: string;
begin
  Result := 'Do' + Name;
end;

function TInterfaceMethod.GetAsEventDeclaration: string;
var
  i: integer;
  sInfo, sEventDeclName: string;
begin
  sInfo := Trim (AsDefinition ['']);
  sEventDeclName := AsEventCall;

  { remove event decl name }
  i := Pos (sEventDeclName, sInfo);
  if (i > 0) then Delete (sInfo, i, Length (sEventDeclName));
  if (sInfo [Length (sInfo)] = ';') then Delete (sInfo, Length (sInfo), 1);
  sInfo := Trim (sInfo);

  { insert Sender parameter }
  i := Pos ('(', sInfo);
  if (i <= 0) then i := Pos (':', sInfo);
  if (i <= 0) then i := Pos (';', sInfo);
  if (i <= 0) then i := Length (sInfo) + 1;

  if (i > 0) and (i <= Length (sInfo)) then
  begin
    if (sInfo [i] = '(') then
      Insert ('Sender: TObject; ', sInfo, i + 1)
    else
      Insert ('(Sender: TObject)', sInfo, i);
  end
  else begin
    sInfo := sInfo + ' (Sender: TObject)';
  end;  { else }

  { build event forward decl }
  Result := Format ('%s = %s of object;', [AsEventType, sInfo]);
end;

function TInterfaceMethod.GetAsEventName: string;
begin
  Result := Format ('%s', [Name]);
end;

function TInterfaceMethod.GetAsEventType: string;
var
  sIntfName: string;
begin
  sIntfName := '';
  if (Intf <> nil) then sIntfName := Intf.Name;
  Result := Format ('T%s%sEvent', [sIntfName, Name]);
end;

function TInterfaceMethod.GetAsISinkInterfaceMethod (const sQualifier: string): string;
var
  lstTokens: TStringList;
begin
  lstTokens := TStringList.Create;
  try
    TokenizeLine (FInfo, lstTokens);
    Result := Format ('%s %s%s = %s;', [lstTokens [0], sQualifier, FOrigName, AsEventCall]);
  finally
    lstTokens.Free;
  end;  { finally }
end;

constructor TInterfaceMethod.Create;
begin
  inherited Create;
  FParams := TInterfaceMethodParams.Create;
end;

destructor TInterfaceMethod.Destroy;
begin
  FParams.Free;
  inherited;
end;

function TInterfaceMethod.IsValidSinkMethod: boolean;
const
  sIDispatchMethods =
    '|QueryInterface|QueryInterface_|AddRef|AddRef_|Release|Release_' +
    '|GetTypeInfoCount|GetTypeInfoCount_|GetTypeInfo|GetTypeInfo_' +
    '|GetIDsOfNames|GetIDsOfNames_|Invoke|Invoke_|'
  ;
begin
  Result := FALSE;

  { if Name is an IDispatch method, then invalid }
  if (Pos ('|' + Uppercase (Name) + '|', Uppercase (sIDispatchMethods)) > 0) then
    Exit;

  Result := TRUE;
end;

procedure TInterfaceMethod.Parse (const sMethod: string);
const
  cCallConvs: array [1..2] of string = (cCallConvSafecall, cCallConvStdcall);
var
  lstTokens: TStringList;
  s, sParams: string;
  i: integer;
begin
  Params.Clear;
  FOrigName := '';
  Name := '';
  CallConv := 'safecall';
  MethodType := mtUnknown;
  FInfo := '';

  lstTokens := TStringList.Create;
  try
    TokenizeLine (sMethod, lstTokens);

    { method must be at least <Procedure> | <Function> <Name> <;> }
    if (lstTokens.Count < 3) then Exit;

    FInfo := sMethod;

    { make sure we use a valid method name }
    FOrigName := lstTokens [1];  // keep original name. the Name property is a resolved Name!
    s := GetValidMethodName (FOrigName);
    if (s <> lstTokens [1]) then
    begin
      i := Pos (' ' + lstTokens [1], FInfo);
      Assert (i > 0);
      Delete (FInfo, i + 1, Length (lstTokens [1]));
      Insert (s, FInfo, i + 1);
      lstTokens [1] := s;
    end;  { if }

    { method type }
    MethodType := GetMethodType (lstTokens [0]);

    { name }
    Name := lstTokens [1];

    { build params }
    if (lstTokens [2] = '(') then
    begin
      sParams := '';
      for i := 3 to lstTokens.Count - 1 do
      begin
        if (lstTokens [i] = ')') then Break;
        sParams := sParams + ' ' + lstTokens [i];
      end;  { for }

      { parse params }
      Params.Parse (sParams);
    end;  { if }

    { DispId }
    DispId := -1;  // -1 means undefined
    i := lstTokens.IndexOf ('DispId');
    if (i >= 0) then DispId := StrToInt (lstTokens [i + 1]);

    { CallConv }
    for i := Low (cCallConvs) to High (cCallConvs) do
      if (Pos (Uppercase (cCallConvs [i]), Uppercase (FInfo)) > 0) then
      begin
        CallConv := cCallConvs [i];
        Break;
      end;  { if }
  finally
    lstTokens.Free;
  end;  { finally }
end;


{ TInterfaceMethods }

function TInterfaceMethods.GetItems (i: integer): TInterfaceMethod;
begin
  Assert ((i >= 0) and (i < Count));
  Result := TInterfaceMethod (FItems [i]);
end;

constructor TInterfaceMethods.Create;
begin
  inherited Create;
  FItems := TList.Create;
end;

destructor TInterfaceMethods.Destroy;
begin
  Clear;
  FItems.Free;
  inherited;
end;

procedure TInterfaceMethods.Clear;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    Items [i].Free;
  FItems.Clear;
end;

function TInterfaceMethods.Count: integer;
begin
  Result := FItems.Count;
end;

procedure TInterfaceMethods.Parse (pIntf: TInterface; lstMethods: TStrings);
var
  i: integer;
  sMethod, sLine: string;
  im: TInterfaceMethod;
begin
  Assert (lstMethods <> nil);
  Clear;
  sMethod := '';

  for i := 0 to lstMethods.Count - 1 do
  begin
    sLine := Trim (lstMethods [i]);

    { check if valid method }
    if (sMethod = '') and not (IsMethod (sLine)) then Continue;

    { append new method line }
    sMethod := Trim (sMethod + ' ' + sLine);

    if (sLine [Length (sLine)] = ';') then
    begin
      im := TInterfaceMethod.Create;
      im.Intf := pIntf;
      im.Parse (sMethod);
      FItems.Add (im);
      sMethod := '';
    end;  { if }
  end;  { for }
end;


{ TInterface }

constructor TInterface.Create;
begin
  inherited Create;
  FMethods := TInterfaceMethods.Create;
  FInfo := TStringList.Create;
end;

destructor TInterface.Destroy;
begin
  FInfo.Free;
  FMethods.Free;
  inherited;
end;

procedure TInterface.Parse (lstData: TStrings);
var
  lstTokens, lstMethods: TStringList;
  sLine, sMethod: string;
  i: integer;
begin
  Name := '';
  Info.Clear;
  Methods.Clear;

  { interface must be at least:
    <xxx> = <interface (parent interface)> | <dispinterface>
    <end;>
  }
  if (lstData.Count < 2) then Exit;

  { validate }
  if not (GetTypeInfoKind (lstData [0]) in [tkInterface, tkDispInterface]) then
    raise Exception.Create ('Unable to parse interface: '#13 + lstData.Text);

  lstTokens := TStringList.Create;
  lstMethods := TStringList.Create;
  try
    { name }
    TokenizeLine (lstData [0], lstTokens);
    Name := lstTokens [0];

    { build methods }
    sMethod := '';
    for i := 1 to lstData.Count - 1 do
    begin
      sLine := Trim (lstData [i]);
      if (CompareText (sLine, 'end;') = 0) then Break;
      
      if (IsMethod (sLine)) and (sMethod <> '') then
      begin
        lstMethods.Add (sMethod);
        sMethod := sLine;
      end
      else begin
        if (sMethod = '') then
          if not (IsMethod (sLine)) then Continue;
        sMethod := sMethod + ' ' + sLine;
      end;  { else }
    end;  { for }

    if (sMethod <> '') then lstMethods.Add (sMethod);

    { parse methods }
    Methods.Parse (Self, lstMethods);
  finally
    lstMethods.Free;
    lstTokens.Free;
  end;  { finally }
end;

procedure TInterface.ResolveMethodDispIds (tiDisp: TInterface);
var
  i: integer;
begin
  Assert (tiDisp <> nil);
  if Methods.Count <> tiDisp.Methods.Count then
    raise Exception.Create ('You have selected an interface, "' + Name +
      '", that is not a valid sink interface.'#13 +
      'Please unselect this interface and regenerate the sink classes again.');
  Assert (Methods.Count = tiDisp.Methods.Count);
  for i := 0 to Methods.Count - 1 do
    Methods [i].DispId := tiDisp.Methods [i].DispId;
end;

procedure TInterface.ResolveMethodParamTypes (tisp: TTypeInfosParser);
var
  i, j: integer;
  ti, tiTemp: TTypeInfoParser;
  im: TInterfaceMethod;
  mp: TInterfaceMethodParam;
  tk: TTypeInfoKind;
  s: string;
begin
  Assert (tisp <> nil);

  { Enum->Integer, Interface/Dispinterface->IUnknown }
  for i := 0 to Methods.Count - 1 do
  begin
    im := Methods [i];
    for j := 0 to im.Params.Count - 1 do
    begin
      mp := im.Params [j];
      if (mp.DataType <> dtUserDefined) then Continue;

      { search in global typeinfos }
      ti := tisp.ItemByName [mp.DataTypeName];
      if (ti = nil) then Continue;

      { resolve kind }
      tk := ti.Kind;
      while (tk = tkAlias) do
      begin
        s := ti.AsAliasedName;
        tiTemp := tisp.ItemByName [s];
        if (tiTemp <> nil) then
        begin
          ti := tiTemp;
          tk := ti.Kind;
        end
        else begin
          Break;
        end;  { else }
      end;  { while }

      case tk of
        tkEnum :
          mp.DataType := dtLongint;

        tkInterface, tkInterfaceForward,
        tkDispInterface, tkDispInterfaceForward :
          mp.DataType := dtIUnknown;

        tkAlias :
          mp.DataType := GetParamDataType (ti.AsAliasedName);
      end;  { case }

      mp.Kind := tk;
    end;  { for }
  end;  { for }
end;


{ TTypeInfoParser }

function TTypeInfoParser.GetAsAliasedName: string;
var
  lstTokens: TStringList;
begin
  Result := '';
  if (Kind <> tkAlias) then Exit;

  lstTokens := TStringList.Create;
  try
    TokenizeLine (Info [0], lstTokens);
    if (lstTokens.Count >= 3) then
      if (lstTokens [1] = '=') then
        Result := lstTokens [2];
  finally
    lstTokens.Free;
  end;  { finally }
end;

function TTypeInfoParser.GetAsForwardDeclaration: string;
var
  lstTokens: TStringList;
begin
  Result := Info [0];
  case Kind of
    tkCoClass, tkInterface, tkDispInterface, tkEnum, tkAlias :
    begin
      { return <Name> = <Type> part }
      lstTokens := TStringList.Create;
      TokenizeLine (Info [0], lstTokens);
      Result := Format ('%s = %s', [lstTokens [0], lstTokens [2]]);
      lstTokens.Free;
    end;
  end;  { case }
end;

function TTypeInfoParser.GetName: string;
var
  lstTokens: TStringList;
begin
  Result := '';
  case Kind of
    tkCoClass, tkInterface, tkDispInterface, tkEnum, tkAlias :
    begin
      lstTokens := TStringList.Create;
      TokenizeLine (Info [0], lstTokens);
      Result := lstTokens [0];
      lstTokens.Free;
    end;
  end;  { case }
end;

constructor TTypeInfoParser.Create;
begin
  inherited Create;
  FInfo := TStringList.Create;
end;

destructor TTypeInfoParser.Destroy;
begin
  FInfo.Free;
  inherited;
end;

procedure TTypeInfoParser.Parse (lstData: TStrings; var iInfoLine: integer; bAlias: boolean);
begin
  Assert (lstData <> nil);

  FInfo.Clear;
  FKind := tkUnknown;
  if (iInfoLine < 0) or (iInfoLine >= lstData.Count) then Exit;

  { determine Info kind }
  if (bAlias) then FKind := tkAlias else FKind := GetTypeInfoKind (lstData [iInfoLine]);
  FInfo.Add (lstData [iInfoLine]);
  iInfoLine := iInfoLine + 1;

  if (Kind in [tkInterface, tkDispInterface, tkCoClass]) then
    { parse until 'end;' }
    ParseUntil (lstData, iInfoLine, FInfo, 'END;');
end;


{ TTypeInfosParser }

function TTypeInfosParser.GetItemByName (const sName: string): TTypeInfoParser;
var
  i: integer;
begin
  Result := nil;
  i := FItemsIndex.IndexOf (sName);
  if (i < 0) then Exit;
  Result := Items [integer (FItemsIndex.Objects [i])];
  Assert (CompareText (sName, Result.Name) = 0);
end;

function TTypeInfosParser.GetItems (iIndex: integer): TTypeInfoParser;
begin
  Result := FItems [iIndex];
end;

function TTypeInfosParser.FindNextTypeInfo (
  lstData: TStrings; var iInfoLine: integer; var bIsAlias: boolean): boolean;

 function IsTypeInfoAlias (const sLine: string): boolean;
 var
   lstTokens: TStringList;
   sAliasedName: string;
 begin
   { alias has this format: <Name> = <TypeInfoName>; }
   Result := FALSE;
   if (sLine = '') then Exit;

   lstTokens := TStringList.Create;
   try
     TokenizeLine (sLine, lstTokens);
     if (lstTokens.Count <> 4) then Exit;
     if (lstTokens [1] <> '=') or (lstTokens [3] <> ';') then Exit;

     sAliasedName := lstTokens [2];
     if (FForwards.IndexOf (sAliasedName) < 0) and
        (ItemByName [sAliasedName] = nil)
     then Exit;

     Result := TRUE;
   finally
     lstTokens.Free;
   end;  { finally }
 end;

var
  sLine: string;
begin
  Result := FALSE;
  bIsAlias := FALSE;
  if (iInfoLine < 0) then Exit;

  while (iInfoLine < lstData.Count) do
  begin
    sLine := lstData [iInfoLine];
    case GetTypeInfoKind (sLine) of
      tkInterface, tkDispInterface, tkCoClass, tkEnum :
      begin
        Result := TRUE;
        Exit;
      end;

      tkInterfaceForward, tkDispInterfaceForward :
      begin
        { add to forwards list }
        FForwards.Add (Trim (Copy (sLine, 1, Pos ('=', sLine) - 1)));
      end;

      tkAlias :
      begin
        bIsAlias := TRUE;
        Result := TRUE;
        Exit;
      end; 

      else begin
        if (IsTypeInfoAlias (sLine)) then
        begin
          bIsAlias := TRUE;
          Result := TRUE;
          Exit;
        end;
      end;
    end;  { case }

    iInfoLine := iInfoLine + 1;
  end;  { while }
end;

constructor TTypeInfosParser.Create;
begin
  inherited Create;
  FItems := TList.Create;
  FForwards := TStringList.Create;
  FExternalUses := TStringList.Create;
  FExternalUses.Duplicates := dupIgnore;
  { NOTE: FItemsIndex must be maintained properly when adding/changing/deleting items!!! }
  FItemsIndex := TStringList.Create;  
  FItemsIndex.Sorted := TRUE;
end;

destructor TTypeInfosParser.Destroy;
begin
  Clear;
  FItemsIndex.Free;
  FExternalUses.Free;
  FForwards.Free;
  FItems.Free;
  inherited;
end;

function TTypeInfosParser.Add (tip: TTypeInfoParser): integer;
begin
  Assert (tip <> nil);
  Result := -1;

  { reject duplicates!!! this is useful for nested external uses }
  if (ItemByName [tip.Name] <> nil) then Exit;

  { do it baby! }
  Result := FItems.Add (tip);
  if (Result >= 0) then
    FItemsIndex.AddObject (tip.Name, pointer (Result));
end;

procedure TTypeInfosParser.Clear;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    Items [i].Free;
  FItems.Clear;
  FForwards.Clear;
  FExternalUses.Clear;
  FItemsIndex.Clear;
end;

function TTypeInfosParser.Count: integer;
begin
  Result := FItems.Count;
end;

procedure TTypeInfosParser.Parse (
  const sSourceFilename: string; lstData: TStrings; pm: TTypeInfosParseMode);

 procedure ParseNormal (lstData: TStrings);
 var
   iLine: integer;
   bAlias: boolean;
   tip: TTypeInfoParser;
 begin
   iLine := 0;
   while FindNextTypeInfo (lstData, iLine, bAlias) do
   begin
     tip := TTypeInfoParser.Create;
     tip.Parse (lstData, iLine, bAlias);
     if (Add (tip) < 0) then tip.Free;
   end;  { while }
 end;

 procedure BuildExternalUses (const sSourceFilename: string; lstData: TStrings);
 var
   iLine, i: integer;
   lstTemp, lstUsesSource: TStringList;
   sUses, s: string;
   bInspectUses: boolean;
 begin
   { locate uses clause }
   iLine := 0;
   if not (FindPartialLine ('uses', lstData, iLine)) then Exit;

   if (CompareText (Trim (lstData [iLine]), 'uses') = 0) or
      (Pos ('USES', Uppercase (lstData [iLine])) = 1)
   then begin
     { exhaust uses statement }
     lstTemp := TStringList.Create;
     try
       while (iLine < lstData.Count) do
       begin
         sUses := Trim (lstData [iLine]);
         if (Pos (';', sUses) > 0) then sUses := Copy (sUses, 1, Pos (';', sUses));
         lstTemp.Add (sUses);
         if (Pos (';', sUses) > 0) then Break;
         iLine := iLine + 1;
       end;  { while }

       { validate }
       sUses := Trim (lstTemp.Text);
       if (sUses = '') then Exit;
       if (Pos ('USES', Uppercase (sUses)) <> 1) then Exit;
       if (sUses [Length (sUses)] <> ';') then Exit;
       Delete (sUses, 1, Length ('uses'));
       Delete (sUses, Length (sUses), 1);

       { build valid uses list }
       lstTemp.Clear;
       TokenizeLine (sUses, lstTemp);
       for i := lstTemp.Count - 1 downto 0 do
         if (lstTemp [i] = ',') then
           lstTemp.Delete (i);

       { recurse }
       for i := 0 to lstTemp.Count - 1 do
       begin
         sUses := Uppercase (lstTemp [i]);

         { check if we need to inspect }
         bInspectUses := FALSE;
         if (IsUserDefExternalUses (sUses)) then bInspectUses := TRUE;
         if (IsSystemExternalUses (sUses)) then bInspectUses := TRUE; 

         if (bInspectUses) then
         begin
           { no duplicates! }
           if (ExternalUses.IndexOf (sUses) < 0) then
           begin
             { bonafide! recurse boy! }
             s := Format ('%s%s.pas', [ExtractFilePath (sSourceFilename), sUses]);
             if (FileExists (s)) then
             begin
               lstUsesSource := TStringList.Create;
               try
                 lstUsesSource.LoadFromFile (s);
                 BuildExternalUses (sSourceFilename, lstUsesSource);
               finally
                 lstUsesSource.Free;
               end;  { finally }
             end;  { if }
           end;  { if }

           { build ExternalUses }
           if (ExternalUses.IndexOf (sUses) < 0) then
             ExternalUses.Add (lstTemp [i]);
         end;  { if }
       end;  { for }
     finally
       lstTemp.Free;
     end;  { finally }
   end;  { if }
 end;

 procedure ParseRecursive (
   const sSourceFilename: string; lstData: TStrings; pm: TTypeInfosParseMode);
 var
   lstUsesSource: TStringList;
   bParseUses: boolean;
   sUsesFile: string;
   i: integer;
 begin
   { search through each source's uses clause and do a depth-first parse
     for any used XXX_TLB unit.
   }
   BuildExternalUses (sSourceFilename, lstData);
   if (ExternalUses.Count <= 0) then Exit;

   { parse external uses typeinfos and append to ours }
   lstUsesSource := TStringList.Create;
   try
     for i := ExternalUses.Count - 1 downto 0 do
     begin
       bParseUses := TRUE;
       { dont parse if not XXX_TLB }
       if not (IsUserDefExternalUses (ExternalUses [i])) then bParseUses := FALSE;
       if not (bParseUses) then Continue;
       
       sUsesFile := Format ('%s%s.pas', [ExtractFilePath (sSourceFilename), ExternalUses [i]]);
       lstUsesSource.LoadFromFile (sUsesFile);
       ParseNormal (lstUsesSource);
     end;  { for }
   finally
     lstUsesSource.Free;
   end;  { finally }
 end;

begin
  Clear;  { ! }

  { check recursive parse }
  if (pm = pmRecursive) then
    ParseRecursive (sSourceFilename, lstData, pm);

  { parse self normally }
  ParseNormal (lstData);
end;


{ TSinkComponentBuilder }

constructor TSinkComponentBuilder.Create;
begin
  inherited Create;
  FTemplate := TStringList.Create;
end;

destructor TSinkComponentBuilder.Destroy;
begin
  FTemplate.Free;
  inherited;
end;

procedure TSinkComponentBuilder.BuildSource (eso: TEventSinkOptions;
  const sLibSourceFile, sUnitName, LibName: string;
  lstSource, lstTypeLibSource, lstSinkInterfaces: TStrings);
var
  tisp: TTypeInfosParser;

 procedure BuildSinkExtraUses (lstSource: TStrings; bAddExternal: boolean);
 var
   iLine, i: integer;
   sUses, s: string;
 begin
   { SinkUses}
   iLine := 0;
   if not (FindLine ('//SinkUses//', lstSource, iLine)) then Exit;
   iLine := iLine + 1;

   sUses := '';

   { UserDefined }
   if (Trim (eso.UserDefinedUses) <> '') then
     sUses := Trim (eso.UserDefinedUses);

   { External }
   for i := 0 to tisp.ExternalUses.Count - 1 do
   begin
     s := tisp.ExternalUses [i];

     { if we don't want external, make sure we only eliminate user-defined
       externals
     }
     if not (bAddExternal) then
       if (IsUserDefExternalUses (s)) then Continue;

     if (sUses <> '') then sUses := sUses + ', ';
     sUses := sUses + s;
   end;  { for }

   if (sUses <> '') then
     lstSource.Insert (iLine, Format ('  , %s', [sUses]));
 end;

 procedure BuildSinkUses (lstSource: TStrings);
 var
   iLine: integer;
   lstTokens: TStringList;
   sLibUnitName: string;
 begin
   iLine := 0;
   if not (FindPartialLine ('unit ', lstTypeLibSource, iLine)) then Exit;
   lstTokens := TStringList.Create;
   TokenizeLine (lstTypeLibSource [iLine], lstTokens);
   sLibUnitName := lstTokens [1];
   lstTokens.Free;

   { SinkUses}
   iLine := 0;
   if not (FindLine ('//SinkUses//', lstSource, iLine)) then Exit;
   iLine := iLine + 1;
   lstSource.Insert (iLine, Format ('  , %s', [sLibUnitName]));
 end;

 procedure BuildSinkImports (lstSource: TStrings);
 var
   i, j, iLine: integer;
   sLine: string;
 begin
   { SinkImportsForwards }
   iLine := 0;
   if not (FindLine ('//SinkImportsForwards//', lstSource, iLine)) then Exit;

   for i := 0 to tisp.Count - 1 do
   begin
     if not (tisp.Items [i].Kind in [tkInterface, tkDispInterface, tkEnum]) then Continue;
     iLine := iLine + 1;
     sLine := Format ('  %s;', [tisp.Items [i].AsForwardDeclaration]);
     lstSource.Insert (iLine, sLine);
   end;  { for }

   { dump alias forwards last }
   for i := 0 to tisp.Count - 1 do
   begin
     if not (tisp.Items [i].Kind = tkAlias) then Continue;
     iLine := iLine + 1;
     sLine := Format ('  %s;', [tisp.Items [i].AsForwardDeclaration]);
     lstSource.Insert (iLine, sLine);
   end;  { for }

   { SinkImports }
   iLine := 0;
   if not (FindLine ('//SinkImports//', lstSource, iLine)) then Exit;

   for i := 0 to tisp.Count - 1 do
   begin
     if not (tisp.Items [i].Kind in [tkInterface, tkDispInterface]) then Continue;
     for j := 0 to tisp.Items [i].Info.Count - 1 do
     begin
       iLine := iLine + 1;
       sLine := tisp.Items [i].Info [j];
       lstSource.Insert (iLine, sLine);
     end;  { for }
   end;  { for }
 end;

 procedure BuildSinkEvents (lstSource: TStrings; ti: TInterface);
 var
   i, iLine: integer;
   sLine: string;
 begin
   Assert (ti <> nil);
   { SinkEventForwards }
   iLine := 0;
   if not (FindLine ('//SinkEventsForwards//', lstSource, iLine)) then Exit;
   iLine := iLine + 1;

   for i := 0 to ti.Methods.Count - 1 do
   begin
     if not (ti.Methods [i].IsValidSinkMethod) then Continue;
     
     sLine := Format ('  %s', [ti.Methods [i].AsEventDeclaration]);
     lstSource.Insert (iLine, sLine);
     iLine := iLine + 1;
   end;  { for }

   { SinkEvents }
   iLine := 0;
   if not (FindLine ('//SinkEventsProtected//', lstSource, iLine)) then Exit;
   iLine := iLine + 1;

   for i := 0 to ti.Methods.Count - 1 do
   begin
     if not (ti.Methods [i].IsValidSinkMethod) then Continue;
     
     sLine := Format ('    F%s: %s;', [ti.Methods [i].AsEventName, ti.Methods [i].AsEventType]);
     lstSource.Insert (iLine, sLine);
     iLine := iLine + 1;
   end;  { for }

   iLine := 0;
   if not (FindLine ('//SinkEventsPublished//', lstSource, iLine)) then Exit;
   iLine := iLine + 1;

   for i := 0 to ti.Methods.Count - 1 do
   begin
     if not (ti.Methods [i].IsValidSinkMethod) then Continue;
     
     sLine := Format ('    property %s: %s read F%0:s write F%0:s;', [ti.Methods [i].AsEventName, ti.Methods [i].AsEventType]);
     lstSource.Insert (iLine, sLine);
     iLine := iLine + 1;
   end;  { for }
 end;

 procedure BuildSinkInit (lstSource: TStrings; ti: TInterface);
 var
   iLine: integer;
   sLine: string;
 begin
   Assert (ti <> nil);
   { SinkInit }
   iLine := 0;
   if not (FindLine ('//SinkInit//', lstSource, iLine)) then Exit;
   iLine := iLine + 1;

   sLine := Format ('  FSinkIID := %s;', [ti.Name]);
   lstSource.Insert (iLine, sLine);
 end;

 procedure BuildVarInterfaceParams (ti: TInterface; iMethod: integer; lstVarParams: TList);
 var
   im: TInterfaceMethod;
   i: integer;
 begin
   Assert ((ti <> nil) and (lstVarParams <> nil));
   im := ti.Methods [iMethod];

   lstVarParams.Clear;
   for i := 0 to im.Params.Count - 1 do
   begin
     with im.Params [i] do
       if (IOType = ioVar) and (DataType in [dtUserDefined, dtIUnknown, dtIDispatch]) then
         lstVarParams.Add (pointer (i));
   end;  { for }
 end;

 procedure BuildEventInvoke (ti: TInterface; iMethod: integer; lstInvoke: TStrings);
 var
   sParams, sParam, sResultAssign: string;
   lstVarParams: TList;
   im: TInterfaceMethod;
   i, j: integer;
 begin
   Assert (ti <> nil);
   im := ti.Methods [iMethod];

   { event result }
   sResultAssign := '';
   if (im.MethodType = mtFunction) then sResultAssign := 'Result := ';

   lstVarParams := TList.Create;
   try
     BuildVarInterfaceParams (ti, iMethod, lstVarParams);

     { if has var params, build local variables }
     if (lstVarParams.Count > 0) then
     begin
       lstInvoke.Add ('var');
       for j := 0 to lstVarParams.Count - 1 do
         with im.Params [integer (lstVarParams [j])] do
           lstInvoke.Add (Format ('  p%s: %s;', [Name, DataTypeName]));
     end;  { if }

     { begin }
     lstInvoke.Add ('begin');

     { HResult return default for stdcalls }
     if (ti.Kind = ikInterface) and (im.CallConv = cCallConvStdcall) then
       lstInvoke.Add ('  Result := S_OK;');

     { event assigned check }
     lstInvoke.Add (Format (
       '  if not Assigned (%s) then System.Exit;', [im.AsEventName]
     ));

     { build call params string }
     sParams := 'Self';  // Self is always implied
     for i := 0 to im.Params.Count - 1 do
     begin
       if (sParams <> '') then sParams := sParams + ', ';
       sParam := im.Params [i].Name;

       { resolve to local variable if var }
       if (lstVarParams.IndexOf (pointer (i)) >= 0) then
         sParam := Format ('p%s', [sParam]);

       sParams := sParams + sParam;
     end;  { for }

     { if has var params, build parameter to local assignments }
     if (lstVarParams.Count > 0) then
     begin
       for j := 0 to lstVarParams.Count - 1 do
         with im.Params [integer (lstVarParams [j])] do
           lstInvoke.Add (
             Format ('  if (%s <> nil) then p%s := %s as %s else p%s := nil;',
             [Name, Name, Name, DataTypeName, Name]
           ));
     end;  { if }

     { invoke call }
     lstInvoke.Add (Format (
       '  %s%s (%s);', [sResultAssign, im.AsEventName, sParams]
     ));

     { if has var params, build local to parameter assignments }
     if (lstVarParams.Count > 0) then
     begin
       for j := 0 to lstVarParams.Count - 1 do
         with im.Params [integer (lstVarParams [j])] do
           lstInvoke.Add (Format ('  %s := p%s;', [Name, Name]));
     end;  { if }

     { end }
     lstInvoke.Add ('end;'#13#10);
   finally
     lstVarParams.Free;
   end;  { finally }
 end;

 procedure BuildSinkMethods (lstSource: TStrings; ti: TInterface);
 var
   lstInvoke: TStrings;
   iLine, i: integer;
   sLine: string;
 begin
   Assert (ti <> nil);
   { SinkInterface }
   iLine := 0;
   if not (FindLine ('//SinkInterface//', lstSource, iLine)) then Exit;
   iLine := iLine + 1;

   for i := 0 to ti.Methods.Count - 1 do
   begin
     if not (ti.Methods [i].IsValidSinkMethod) then Continue;

     sLine := Format ('    %s', [ti.Methods [i].AsDeclaration]);
     lstSource.Insert (iLine, sLine);
     iLine := iLine + 1;
   end;  { for }

   { SinkImplementation }
   iLine := 0;
   if not (FindLine ('//SinkImplementation//', lstSource, iLine)) then Exit;
   iLine := iLine + 1;

   lstInvoke := TStringList.Create;
   try
     for i := 0 to ti.Methods.Count - 1 do
     begin
       if not (ti.Methods [i].IsValidSinkMethod) then Continue;
       
       sLine := Format ('%s', [ti.Methods [i].AsDefinition [cSinkComponentName]]);
       lstSource.Insert (iLine, sLine);
       iLine := iLine + 1;

       { build event invoke call }
       lstInvoke.Clear;
       BuildEventInvoke (ti, i, lstInvoke);
       InsertStrings (lstSource, lstInvoke, iLine);
       iLine := iLine + lstInvoke.Count;
     end;  { for }
   finally
     lstInvoke.Free;
   end;  { finally }
 end;

 procedure BuildSinkInvoke (lstSource: TStrings; ti: TInterface);

  function GetVariantArgField (imp: TInterfaceMethodParam): string;
  begin
    Assert (imp <> nil);
    Result := '<unknown type>';

    { if unknown, assume IUnknown }
    //if (imp.DataType = dtUserDefined) then
    //  imp.DataType := dtIUnknown;

    case imp.DataType of
      dtByte :
        if (imp.IOType = ioVar) then Result := 'pbval^' else Result := 'bval';
      dtSmallint :
        if (imp.IOType = ioVar) then Result := 'pival^' else Result := 'ival';
      dtLongint :
        if (imp.IOType = ioVar) then Result := 'plval^' else Result := 'lval';
      dtSingle :
        if (imp.IOType = ioVar) then Result := 'pfltval^' else Result := 'fltval';
      dtDouble :
        if (imp.IOType = ioVar) then Result := 'pdblval^' else Result := 'dblval';
      dtWordbool :
        if (imp.IOType = ioVar) then Result := 'pbool^' else Result := 'vbool';
      dtHResult :
        if (imp.IOType = ioVar) then Result := 'pscode^' else Result := 'scode';
      dtCurrency :
        if (imp.IOType = ioVar) then Result := 'pcyval^' else Result := 'cyval';
      dtDateTime :
        if (imp.IOType = ioVar) then Result := 'pdate^' else Result := 'date';
      dtWidestring :
        if (imp.IOType = ioVar) then Result := 'pbstrval^' else Result := 'bstrval';
      dtIUnknown :
        if (imp.IOType = ioVar) then Result := 'punkval^' else Result := 'unkval';
      dtIDispatch :
        if (imp.IOType = ioVar) then Result := 'pdispval^' else Result := 'dispval';
      dtSafeArray :
        if (imp.IOType = ioVar) then Result := 'pparray^' else Result := 'parray';
      dtVariant :
        Result := 'pvarval';
      dtUserDefined :
        { best bet for user-defined param is a castable longint!?
          if not, user can just manually modify the sink file! :)
        }
        if (imp.IOType = ioVar) then Result := 'plval^' else Result := 'lval';
    end;  { case }
  end;

  function FormatInterfaceParam (const sIntfType, sName, sParamType: string): string;
  begin
    Result := Format ('%s (%s)', [sIntfType, sName]);
    if (CompareText (sParamType, sIntfType) <> 0) then
      Result := Result + ' as ' + sParamType;
  end;

  function BuildInvokeCall (ti: TInterface; iMethod: integer): string;
  var
    sParams, sParam, sParamElem, sParamTypeName: string;
    im: TInterfaceMethod;
    i: integer;
  begin
    Assert (ti <> nil);
    Result := '';
    im := ti.Methods [iMethod];

    { build params }
    sParams := '';
    for i := 0 to im.Params.Count - 1 do
    begin
      if (sParams <> '') then sParams := sParams + ', ';
      sParamElem := Format ('dps.rgvarg^ [pDispIds^ [%d]]', [i]);
      sParam := Format ('%s.%s', [sParamElem, GetVariantArgField (im.Params [i])]);

      sParamTypeName := im.Params [i].DataTypeName;

      { special casting here }
      if (im.Params [i].DataType = dtVariant) then
      begin
        case im.Params [i].IOType of
          ioConst :
            sParam := Format ('OleVariant (%s)', [sParamElem]);
          else
            sParam := Format ('POleVariant (%s)^', [sParam])
        end;  { case }
      end
      else
      if (im.Params [i].DataType = dtIDispatch) then
      begin
        { IDispatch casting }
        case im.Params [i].IOType of
          ioConst :
            //sParam := Format ('IDispatch (%s) as %s', [sParam, sParamTypeName]);
            sParam := FormatInterfaceParam ('IDispatch', sParam, sParamTypeName);
          else
            sParam := Format ('%s (%s)', [sParamTypeName, sParam])
        end;  { case }
      end else
      if (im.Params [i].DataType = dtIUnknown) then
      begin
        { IUnknown casting }
        case im.Params [i].IOType of
          ioConst :
            //sParam := Format ('IUnknown (%s) as %s', [sParam, sParamTypeName]);
            sParam := FormatInterfaceParam ('IUnknown', sParam, sParamTypeName);
          else
            sParam := Format ('%s (%s)', [sParamTypeName, sParam])
        end;  { case }
      end else
      if (im.Params [i].DataType = dtUserDefined) or
         (im.Params [i].Kind in [tkEnum, tkAlias])
      then begin
        { enums and user-defines should be direct casted! }
        sParam := Format ('%s (%s)', [sParamTypeName, sParam]);
      end else
      ;

      sParams := sParams + sParam;
    end;  { for }

    { build call }
    Result := Format ('%s (%s);', [im.AsEventCall, sParams]);

    { function result goes into VarResult }
    if (im.MethodType = mtFunction) then
      Result := Format ('OleVariant (VarResult^) := %s', [Result]);
  end;

  function ValidMethodCount (ti: TInterface): integer;
  var
    i: integer;
  begin
    Result := 0;
    for i := 0 to ti.Methods.Count - 1 do
    begin
      if not (ti.Methods [i].IsValidSinkMethod) then Continue;
      Result := Result + 1;
    end;  { for }
  end;

 var
   iLine, i, iStartLine: integer;
   sLine: string;
 begin
   Assert (ti <> nil);

   { bail if no valid event methods }
   if (ValidMethodCount (ti) <= 0) then Exit;

   { SinkInvoke }
   iLine := 0;
   if not (FindLine ('//SinkInvoke//', lstSource, iLine)) then Exit;
   iLine := iLine + 1;
   iStartLine := iLine;

   { case start }
   sLine := 'case DispId of';
   lstSource.Insert (iLine, sLine);
   iLine := iLine + 1;

   for i := 0 to ti.Methods.Count - 1 do
   begin
     if not (ti.Methods [i].IsValidSinkMethod) then Continue;

     { insert cases }
     lstSource.Insert (iLine, Format ('  %d :', [ti.Methods [i].DispId]));
     iLine := iLine + 1;
     lstSource.Insert (iLine,         '  begin');
     iLine := iLine + 1;

     { real implementation here }
     sLine := BuildInvokeCall (ti, i);
     lstSource.Insert (iLine, Format ('    %s', [sLine]));
     iLine := iLine + 1;

     lstSource.Insert (iLine,         '    Result := S_OK;');
     iLine := iLine + 1;
     lstSource.Insert (iLine, Format ('  end;', [ti.Methods [i].DispId]));
     iLine := iLine + 1;
   end;  { for }

   { case end }
   sLine := 'end;  { case }';
   lstSource.Insert (iLine, sLine);

   IndentLines (lstSource, 4, iStartLine, iLine);
   iLine := iLine + 1;
 end;

 procedure BuildISinkInterface (lstSource: TStrings; ti: TInterface);
 var
   iLine, i: integer;
   sResolved: string;
 begin
   Assert (ti <> nil);
   { ISinkInterface}
   iLine := 0;
   if not (FindLine ('//ISinkInterface//', lstSource, iLine)) then Exit;
   lstSource [iLine] := Format ('    , %s', [ti.Name]);

   { ISinkInterfaceMethods }
   if not (FindLine ('//ISinkInterfaceMethods//', lstSource, iLine)) then Exit;
   lstSource [iLine] := Format ('    { %s }', [ti.Name]);
   iLine := iLine + 1;
   for i := 0 to ti.Methods.Count - 1 do
   begin
     if not (ti.Methods [i].IsValidSinkMethod) then Continue;
     sResolved := Format ('    %s', [ti.Methods [i].AsISinkInterfaceMethod [ti.Name + '.']]);
     lstSource.Insert (iLine, sResolved);
     iLine := iLine + 1;
   end;  { for }
 end;

 procedure BuildSinkRegister (lstSource: TStrings; ti: TInterface);
 var
   iSinkRegisterStart, iSinkRegisterEnd: integer;
 begin
   Assert (ti <> nil);

   { ISinkRegister }
   iSinkRegisterStart := 0;
   iSinkRegisterEnd := 0;
   if not (FindLine ('//SinkRegisterStart//', lstSource, iSinkRegisterStart)) then Exit;
   if not (FindLine ('//SinkRegisterEnd//', lstSource, iSinkRegisterEnd)) then Exit;

   SearchAndReplaceLinesEx (lstSource, '''SinkPage''', Format ('''%s''', [eso.SinkPage]),
     iSinkRegisterStart, iSinkRegisterEnd
   );
 end;

 procedure SetUnitName (lstSource: TStrings; const sUnitName: string);
 var
   iLine: integer;
   sLine: string;
 begin
   { SinkInit }
   iLine := 0;
   if not (FindLine ('//SinkUnitName//', lstSource, iLine)) then Exit;
   iLine := iLine + 1;

   sLine := Format ('unit %s;', [sUnitName]);
   lstSource [iLine] := sLine;
 end;

 procedure BuildSinkClassList (lstSource, lstSinkClasses: TStrings);
 var
   iLine, i: integer;
 begin
   Assert ((lstSource <> nil) and (lstSinkClasses <> nil));

   { ISinkRegister }
   iLine := 0;
   if not (FindLine ('//Sink Classes//', lstSource, iLine)) then Exit;
   iLine := iLine + 1;
   for i := 0 to lstSinkClasses.Count - 1 do
   begin
     lstSource.Insert (iLine, Format ('  %s', [lstSinkClasses [i]]));
     iLine := iLine + 1;
   end;  { for }
 end;

 function GetIntfInfo (const sIntfName: string; ti: TInterface): boolean;
 var
   tip: TTypeInfoParser;
 begin
   Assert ((sIntfName <> '') and (ti <> nil));
   Result := FALSE;

   tip := tisp.ItemByName [sIntfName];
   if (tip = nil) then Exit;

   { initialize current type info holder }
   ti.Kind := ikInterface;
   if (tip.Kind = tkDispInterface) then ti.Kind := ikDispInterface;
   ti.Parse (tip.Info);
   ti.ResolveMethodParamTypes (tisp);
   Result := TRUE;
 end;

 function FormatComponentName (const s: string;
   RemoveUnderscores, FullyQualify: boolean): string;
 begin
   Result := s;

   if (RemoveUnderscores) then
     while (Result <> '') do
     begin
       if (Result [1] <> '_') then Break;
       Delete (Result, 1, 1);
     end;

   if (FullyQualify) then
     Result := LibName + Result;
 end;

var
  sInterfaceName, sComponentName: string;
  lstSinkSource, lstSinkClasses: TStringList;
  ti, tiTemp: TInterface;
  i: integer;
  bMasterFile: boolean;
begin
  Assert ((lstSource <> nil) and (lstTypeLibSource <> nil) and
          (lstSinkInterfaces <> nil) and (eso <> nil)
  );
  lstSource.Clear;

  lstSinkSource := TStringList.Create;
  lstSinkClasses := TStringList.Create;
  tisp := TTypeInfosParser.Create;
  ti := TInterface.Create;
  tiTemp := TInterface.Create;
  try
    tisp.Parse (sLibSourceFile, lstTypeLibSource, pmRecursive);

    for i := 0 to lstSinkInterfaces.Count - 1 do
    begin
      bMasterFile := (i = 0);
      sInterfaceName := lstSinkInterfaces [i];
      sComponentName := Format ('T%s', [
        FormatComponentName (sInterfaceName,
          eso.RemoveUnderscores, eso.FullyQualify)]);

      { parse out main interface info }
      if not (GetIntfInfo (sInterfaceName, ti)) then Continue;

      lstSinkSource.Assign (Template);

      { Uses/Imports are once-only }
      if (bMasterFile) then
      begin
        { Uses/Imports }
        case eso.UsesImportMode of
          imUsesTLB :
            { SinkUses }
            BuildSinkUses (lstSinkSource);
          else
            { SinkImports }
            BuildSinkImports (lstSinkSource);
        end;  { case }

        { External and UserDef uses }
        BuildSinkExtraUses (lstSinkSource, (eso.UsesImportMode = imUsesTLB));
      end;  { if }

      { SinkEvents }
      BuildSinkEvents (lstSinkSource, ti);

      { SinkInit }
      BuildSinkInit (lstSinkSource, ti);

      { SinkMethods }
      BuildSinkMethods (lstSinkSource, ti);

      { SinkInvoke/ISinkInterface }
      if (ti.Kind = ikDispInterface) then
        BuildSinkInvoke (lstSinkSource, ti)
      else begin
        BuildISinkInterface (lstSinkSource, ti);
        { if dispinterface is supported then pull it in! }
        if (GetIntfInfo (sInterfaceName + 'Disp', tiTemp)) then
        begin
          { resolve dispids from dispinterface defn }
          ti.ResolveMethodDispIds (tiTemp);
          { build IDispatch.Invoke code }
          BuildSinkInvoke (lstSinkSource, ti);
        end;  { if }
      end;  { if }

      { SinkRegister }
      BuildSinkRegister (lstSinkSource, ti);

      { change component name }
      SearchAndReplaceLines (lstSinkSource, cSinkComponentName, sComponentName);

      { change unit name }
      SetUnitName (lstSinkSource, sUnitName);

      { build source-code lines }
      if (bMasterFile) then
        lstSource.AddStrings (lstSinkSource)
      else
        MergeSource (lstSource, lstSinkSource);

      lstSinkClasses.Add (sComponentName);
    end;  { for }

    BuildSinkClassList (lstSource, lstSinkClasses);
    SearchAndReplaceLines (lstSource, cSinkBaseClassName,
      'T' + sUnitName + Copy (cSinkBaseClassName, 2, Length (cSinkBaseClassName)));
  finally
    tiTemp.Free;
    ti.Free;
    tisp.Free;
    lstSinkClasses.Free;
    lstSinkSource.Free;
  end;  { finally }
end;

procedure TSinkComponentBuilder.MergeSource (lstSource, lstSinkSource: TStrings);
var
  iSinkSourceLine, iSinkSourceLineEnd: integer;
  iSourceLine: integer;
begin
  Assert ((lstSource <> nil) and (lstSinkSource <> nil));

  { merge SinkIntf }
  iSinkSourceLine := 0;
  iSinkSourceLineEnd := 0;
  iSourceLine := 0;
  if not (FindLine ('//SinkIntfStart//', lstSinkSource, iSinkSourceLine)) then Exit;
  if not (FindLine ('//SinkIntfEnd//', lstSinkSource, iSinkSourceLineEnd)) then Exit;
  if not (FindLine ('//SinkIntfEnd//', lstSource, iSourceLine)) then Exit;
  InsertStringsEx (lstSource, lstSinkSource, iSourceLine,
    iSinkSourceLine + 1, iSinkSourceLineEnd - 1
  );

  { merge SinkImpl }
  iSinkSourceLine := 0;
  iSinkSourceLineEnd := 0;
  iSourceLine := 0;
  if not (FindLine ('//SinkImplStart//', lstSinkSource, iSinkSourceLine)) then Exit;
  if not (FindLine ('//SinkImplEnd//', lstSinkSource, iSinkSourceLineEnd)) then Exit;
  if not (FindLine ('//SinkImplEnd//', lstSource, iSourceLine)) then Exit;
  InsertStringsEx (lstSource, lstSinkSource, iSourceLine,
    iSinkSourceLine + 1, iSinkSourceLineEnd - 1
  );

  { merge SinkRegister }
  iSinkSourceLine := 0;
  iSourceLine := 0;
  if not (FindLine ('//SinkRegisterStart//', lstSinkSource, iSinkSourceLine)) then Exit;
  if not (FindLine ('//SinkRegisterEnd//', lstSource, iSourceLine)) then Exit;
  InsertStringsEx (lstSource, lstSinkSource, iSourceLine,
    iSinkSourceLine + 1, iSinkSourceLine + 1
  );
end;


{ TRegTypeLib }

function TRegTypeLib.GetLibName: string;
var
  sDescription: string;
begin
  if (FLibName = '') then
    if (FileExists (Filename)) then
      GetTypeLibDescription (Filename, FLibname, sDescription);

  Result := FLibName;
end;

procedure TRegTypeLib.FindSourceInterfaces (lstInterfaces: TStrings);

 function TypeInfoName (pti: ITypeInfo): string;
 var
   wsName: widestring;
 begin
   Assert (pti <> nil);
   Result := '';
   OleCheck (pti.GetDocumentation (MEMBERID_NIL, @wsName, nil, nil, nil));
   Result := wsName;
 end;

 function IsStdInterface (const sName: string): boolean;
 const
   StdInterfaces = '/IUNKNOWN/IDISPATCH/';
 begin
   Result := (Pos ('/' + Uppercase (sName) + '/', StdInterfaces) > 0);
 end;

var
  pTypeLib: ITypeLib;
  i, j, itf: integer;
  iRefType: HRefType;
  tk: TTypeKind;
  pti, ptiImpl: ITypeInfo;
  pta: PTypeAttr;
  sSourceName, sInterfaceName: string;
  IsSource: boolean;
begin
  Assert (lstInterfaces <> nil);
  try
    OleCheck (LoadTypeLibEx (PWideChar (widestring (Filename)), REGKIND_NONE, pTypeLib));

    //Result := FALSE;
    lstInterfaces.Clear;

    { iterate all type infos }
    for i := 0 to pTypeLib.GetTypeInfoCount - 1 do
    begin
      pTypeLib.GetTypeInfoType (i, tk);

      { only CoClasses support outgoing interfaces }
      if (tk <> TKIND_COCLASS) then Continue;

      { check if CoClass has any outgoing interfaces }
      OleCheck (pTypeLib.GetTypeInfo (i, pti));
      sSourceName := TypeInfoName (pti);

      OleCheck (pti.GetTypeAttr (pta));
      try
        //load all interfaces but only mark the source ones
        for j := 0 to pta^.cImplTypes - 1 do
        begin
          pti.GetImplTypeFlags (j, itf);
          IsSource := (itf AND IMPLTYPEFLAG_FSOURCE <> 0);
          //add interface name to list
          OleCheck (pti.GetRefTypeOfImplType (j, iRefType));
          OleCheck (pti.GetRefTypeInfo (iRefType, ptiImpl));
          sInterfaceName := TypeInfoName (ptiImpl);
          if (lstInterfaces.IndexOf (sInterfaceName) < 0) and
            not IsStdInterface (sInterfaceName)
          then
            if (IsSource) then
              lstInterfaces.AddObject (sInterfaceName, pointer (1){sink marker})
            else
              lstInterfaces.Add (sInterfaceName);
        end;  { for }
      finally
        pti.ReleaseTypeAttr (pta);
      end;  { finally }
    end;  { for }

    //find other interfaces
    for i := 0 to pTypeLib.GetTypeInfoCount - 1 do
    begin
      pTypeLib.GetTypeInfoType (i, tk);
      if (tk <> TKIND_INTERFACE) and (tk <> TKIND_DISPATCH) then continue;
      OleCheck (pTypeLib.GetTypeInfo (i, pti));
      sInterfaceName := TypeInfoName (pti);
      if (lstInterfaces.IndexOf (sInterfaceName) < 0) and
        not IsStdInterface (sInterfaceName)
      then
        lstInterfaces.Add (sInterfaceName);
    end;

    pTypeLib := nil;
  except
    ShowMessage (Exception (ExceptObject).Message);
  end;  { except }
end;

procedure TRegTypeLib.LoadInfo (const sFilename: string);
begin
  if not (FileExists (sFilename)) then
    raise Exception.Create ('Unable to locate: ' + sFilename);

  Filename := sFilename;
  GetTypeLibDescription (sFilename, FLibname, Description);
  if (Description = '') then Description := Libname;
end;


{ TRegTypeLibs }

function TRegTypeLibs.GetItems (i: integer): TRegTypeLib;
begin
  Assert ((i >= 0) and (i < Count));
  Result := FItems [i];
end;

procedure TRegTypeLibs.Sort;
var
  i: integer;
  lstTemp, lstExchange: TList;
  lstSort: TStringList;
begin
  { sort by description }
  lstSort := TStringList.Create;
  lstTemp := TList.Create;
  try
    for i := 0 to Count - 1 do
      lstSort.AddObject (Items [i].Description, pointer (i));
    lstSort.Sort;

    { reorder }
    for i := 0 to lstSort.Count - 1 do
      lstTemp.Add (FItems [integer (lstSort.Objects [i])]);

    { swap lists }
    lstExchange := FItems;
    FItems := lstTemp;
    lstTemp := lstExchange;
  finally
    lstTemp.Free;
    lstSort.Free;
  end;  { finally }
end;

constructor TRegTypeLibs.Create;
begin
  inherited Create;
  FItems := TList.Create;
end;

destructor TRegTypeLibs.Destroy;
begin
  Clear;
  FItems.Free;
  inherited;
end;

procedure TRegTypeLibs.Clear;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    Items [i].Free;
  FItems.Clear;
end;

function TRegTypeLibs.Count: integer;
begin
  Result := FItems.Count;
end;

procedure TRegTypeLibs.ReadRegistry;

 procedure ReadTypeLib (reg: TRegistry; const sLibId, sLibVersion: string);
 var
   sSubkey, sLibDescription, sLibFile: string;
   lstSubkeys: TStringList;
   rtl: TRegTypeLib;
   i: integer;
 begin
   Assert (reg <> nil);
   lstSubKeys := TStringList.Create;
   try
     with reg do
     begin
       if not (OpenKey ('TypeLib\' + sLibId + '\' + sLibVersion, FALSE)) then Exit;

       sLibDescription := ReadString ('');

       { load subkeys and parse out for numeric with a win32 subkey }
       GetKeyNames (lstSubKeys);
       CloseKey;
       for i := 0 to lstSubKeys.Count - 1 do
       begin
         sSubkey := lstSubkeys [i];
         if (sSubKey = '') then Continue;
         if not (sSubkey [1] in ['0'..'9']) then Continue;

         { win32 }
         if not (OpenKey ('TypeLib\' + sLibId + '\' + sLibVersion + '\' + sSubKey + '\win32', FALSE)) then Continue;
         sLibFile := ReadString ('');
         CloseKey;

         //if not (FileExists (sLibFile)) then Continue;

         { add item }
         rtl := TRegTypeLib.Create;
         rtl.Filename := sLibFile;
         rtl.Description := Format ('%s (version %s)', [sLibDescription, sLibVersion]);
         FItems.Add (rtl);

         Break;
       end;  { for }
     end;  { with }
   finally
     lstSubKeys.Free;
   end;  { finally }
 end;

var
  reg: TRegistry;
  i, j: integer;
  lstTypeLibs, lstVersions: TStringList;
begin
  { browse through HKCR\TypeLib }
  Clear;
  reg := TRegistry.Create;
  lstTypeLibs := TStringList.Create;
  lstVersions := TStringList.Create;
  try
    with reg do
    begin
      RootKey := HKEY_CLASSES_ROOT;
      if not (OpenKey ('TypeLib', FALSE)) then Exit;

      { enumerate }
      GetKeyNames (lstTypeLibs);
      CloseKey;

      { each lib is like this:

        LibId
          Version No
            No?
              Win32
      }
      for i := 0 to lstTypeLibs.Count - 1 do
      begin
        if not (OpenKey ('TypeLib\' + lstTypeLibs [i], FALSE)) then Continue;

        { load versions }
        GetKeyNames (lstVersions);
        CloseKey;
        
        for j := 0 to lstVersions.Count - 1 do
          ReadTypeLib (reg, lstTypeLibs [i], lstVersions [j]);
      end;  { for }
    end;  { with }

    Sort;
  finally
    lstVersions.Free;
    lstTypeLibs.Free;
    reg.Free;
  end;  { finally }
end;

end.
