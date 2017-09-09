unit uDFMParser;

interface
uses SysUtils, Classes,Contnrs;


type

TDfmPropertyType = (ptIdent, ptString,ptInteger,ptFloat,ptSet,ptList,ptBinary,ptCollection);


TDfmProperty = class;

TDfmCollectionItem = class(Tobject)
  private
    FOrderModifer: Integer;
    function GetItem(index: Integer): TDfmProperty;
    procedure SetItem(index: Integer; const Value: TDfmProperty);
    procedure SetOrderModifer(const Value: Integer);
protected
  FCollection : TObjectList;
public
  constructor Create;
  destructor Destroy; override;

  function ItemCount : Integer;
  function AddItem(aItem : TDfmProperty) : Integer;
  procedure RemoveItem(Index : Integer);

  property Item[index : Integer] :TDfmProperty read GetItem write SetItem;
  property OrderModifer : Integer read FOrderModifer write SetOrderModifer;
end;





TDfmProperty = class(TObject)
  private
    FPropertyName: UnicodeString;
    FPropertyType: TDfmPropertyType;
    FptListList : TObjectList;
    FFloatType: Char;
    FFloatValue: Extended;
    FIntegerValue: Int64;
    FStringValue: String;
    FBinaryValue: TMemoryStream;
    FSetValue: TStrings;
    FCollectionItems : TObjectList;
    procedure SetPropertyName(const Value: UnicodeString);
    procedure SetPropertyType(const Value: TDfmPropertyType);
    function GetListItem(Index: Integer): TDfmProperty;
    function GetListCount: Integer;
    procedure SetListItem(Index: Integer; const Value: TDfmProperty);
    procedure SetFloatValue(const Value: Extended);
    procedure SetIntegerValue(const Value: Int64);
    procedure SetSetValue(const Value: TStrings);
    procedure SetStringValue(const Value: String);

    function GetCollectionItem(Index: Integer): TDfmCollectionItem;
    procedure SetCollectionItem(Index: Integer;
      const Value: TDfmCollectionItem);
    function GetCollectionItemCount: Integer;
public
    constructor Create;
    destructor Destroy; override;
    property PropertyName : UnicodeString read FPropertyName write SetPropertyName;
    property PropertyType : TDfmPropertyType read FPropertyType write SetPropertyType;

    property FloatType : Char read FFloatType write FFloatType;
    property BinaryValue : TMemoryStream read FBinaryValue;
    property FloatValue : Extended read FFloatValue write SetFloatValue;
    property StringValue : String read FStringValue write SetStringValue;
    property IntegerValue : Int64 read FIntegerValue write SetIntegerValue;
    property ListCount : Integer read GetListCount;
    property ListItem[Index : Integer] : TDfmProperty read GetListItem write SetListItem;
    property SetValue : TStrings read FSetValue write SetSetValue;


    property CollectionItem[Index : Integer] : TDfmCollectionItem read GetCollectionItem write SetCollectionItem;
    property CollectionItemCount : Integer read GetCollectionItemCount;


    function AddCollectionItem(value : TDfmCollectionItem) : Integer;
    procedure RemoveCollectionItem(Index : Integer);


    function AddListItem(value : TDfmProperty) : Integer;
    procedure RemoveListItem(index : Integer);

end;


TDfmObject = class(TObject)
  private
    FClassName: UnicodeString;
    FObjectName: UnicodeString;
    FFilerFlags: TFilerFlags;
    FPosition: Integer;
    procedure SetClassName(const Value: UnicodeString);
    procedure SetObjectName(const Value: UnicodeString);
    procedure SetFilerFlags(const Value: TFilerFlags);
    procedure SetPosition(const Value: Integer);
protected
  FOwnedObjects : TObjectList;
  FPropertyList : TObjectList;
  function GetPropertyCount: Integer;
  function GetOwnedObjectCount: Integer;
  function GetDfmProperty(Index: Integer): TDfmProperty;
  function GetOwnedObject(Index: Integer): TDfmObject;
public
  constructor Create;
  destructor Destroy; override;
public
  function AddDfmProperty (aValue : TDfmProperty) : Integer;
  procedure RemoveDfmProperty(Index : Integer); overload;
  procedure RemoveDfmProperty(aValue : TDfmProperty); overload;
  procedure ExtractDfmProperty(aValue : TDfmProperty);
  function IndexOfDfmProperty(aValue : TDfmProperty) : Integer;

  function AddOwnedObject (aValue : TDfmObject) : Integer;
  procedure RemoveOwnedObject(Index : Integer); overload;
  procedure RemoveOwnedObject(aValue : TDfmObject); overload;
  procedure ExtractOwnedObject( aValue : TDfmObject);
  procedure ClearOwnedObjects;
  function IndexOfOwnedObject(aValue : TDfmObject) : Integer;
  function  PropertyByName(aName : String) : TDfmProperty;

  property DfmClassName : UnicodeString read FClassName write SetClassName;
  property ObjectName : UnicodeString read FObjectName write SetObjectName;
  property DfmPropertyCount : Integer read GetPropertyCount;
  property DfmProperty[ Index : Integer] : TDfmProperty read GetDfmProperty;
  property OwnedObjectCount : Integer read GetOwnedObjectCount;
  property OwnedObject[ Index : Integer ] : TDfmObject read GetOwnedObject;
  property FilerFlags : TFilerFlags read FFilerFlags write SetFilerFlags;
  property Position : Integer read FPosition write SetPosition;
end;


TDfmTree = class(TDfmObject);




procedure ObjectTextToTree(Input : TStream;Output : TDfmTree);
procedure ObjectTreeToText(Input : TDfmTree;Output : TStream);



implementation
uses RTLConsts,TypInfo;

procedure ObjectTextToTree(Input : TStream;Output : TDfmTree);
var
  SaveSeparator: Char;
  Parser: TParser;
//  Writer: TWriter;

  function ConvertOrderModifier: Integer;
  begin
    Result := -1;
    if Parser.Token = '[' then
    begin
      Parser.NextToken;
      Parser.CheckToken(toInteger);
      Result := Parser.TokenInt;
      Parser.NextToken;
      Parser.CheckToken(']');
      Parser.NextToken;
    end;
  end;

  procedure ConvertHeader(IsInherited, IsInline: Boolean;aOutput : TDfmObject);
  var
    ClassName, ObjectName: string;
    Flags: TFilerFlags;
    Position: Integer;
  begin
    Parser.CheckToken(toSymbol);
    ClassName := Parser.TokenString;
    ObjectName := '';
    if Parser.NextToken = ':' then
    begin
      Parser.NextToken;
      Parser.CheckToken(toSymbol);
      ObjectName := ClassName;
      ClassName := Parser.TokenString;
      Parser.NextToken;
    end;
    Flags := [];
    Position := ConvertOrderModifier;
    if IsInherited then
      Include(Flags, ffInherited);
    if IsInline then
      Include(Flags, ffInline);
    if Position >= 0 then
      Include(Flags, ffChildPos);


    aOutput.Position := Position;
    aOutput.FilerFlags := Flags;
    aOutput.DfmClassName := ClassName;
    aOutput.ObjectName := ObjectName;
  end;

  procedure ConvertProperty(aProp : TDfmProperty); forward;

  procedure ConvertValue(aProp : TDfmProperty);
  var
//    Order: Integer;
    lProp : TDfmProperty;
    lCollectionItem : TdfmCollectionItem;

    function CombineUnicodeString: UnicodeString;
    begin
      Result := Parser.TokenWideString;
      while Parser.NextToken = '+' do
      begin
        Parser.NextToken;
        if not CharInSet(Parser.Token,[toString, toWString]) then
          Parser.CheckToken(toString);
        Result := Result + Parser.TokenWideString;
      end;
    end;

  begin
    if CharInSet(Parser.Token,[toString, toWString]) then
    begin
      aProp.PropertyType := ptString;
      aProp.StringValue := CombineUnicodeString;
    end
    else
    begin
      case Parser.Token of
        toSymbol:
        begin
          aProp.PropertyType := ptIdent;
          aProp.StringValue := Parser.TokenComponentIdent;
        end;
        toInteger:
        begin
          aProp.PropertyType := ptInteger;
          aProp.IntegerValue := Parser.TokenInt;
        end;
        toFloat:
          begin
            aProp.PropertyType := ptFloat;
            aProp.FloatType := Parser.FloatType;
            aProp.FloatValue := Parser.TokenFloat;
          end;
        '[':
          begin
            aProp.PropertyType := ptSet;
            Parser.NextToken;
            if Parser.Token <> ']' then
              while True do
              begin
                if Parser.Token <> toInteger then
                  Parser.CheckToken(toSymbol);
                aProp.SetValue.Add(Parser.TokenString);
                if Parser.NextToken = ']' then Break;
                Parser.CheckToken(',');
                Parser.NextToken;
              end;
          end;
        '(':
          begin
            aProp.PropertyType := ptList;
            Parser.NextToken;
            while Parser.Token <> ')' do
            begin
              lProp := TDfmProperty.Create;
              aProp.AddListItem(lProp);
              ConvertValue(lProp);
            end;
          end;
        '{':
          begin
            aProp.PropertyType := ptBinary;
            Parser.HexToBinary(aProp.BinaryValue);
          end;
        '<':
          begin
            Parser.NextToken;
            aProp.PropertyType := ptCollection;
            while Parser.Token <> '>' do
            begin
              Parser.CheckTokenSymbol('item');
              Parser.NextToken;

              lCollectionItem := TdfmCollectionItem.Create();
              lCollectionItem.OrderModifer := ConvertOrderModifier;
              while not Parser.TokenSymbolIs('end') do
              begin
                lProp := TDfmProperty.Create;
                ConvertProperty(lProp);
                lCollectionItem.AddItem(lProp);
              end;

              aProp.AddCollectionItem(lCollectionItem);
//              Writer.WriteListEnd;
              Parser.NextToken;
            end;
//            Writer.WriteListEnd;
          end;


      else
        Parser.Error(SInvalidProperty);
      end;
      Parser.NextToken;
    end;
  end;

  procedure ConvertProperty(aProp : TDfmProperty);
  var
    PropName: string;
  begin
    Parser.CheckToken(toSymbol);
    PropName := Parser.TokenString;
    Parser.NextToken;
    while Parser.Token = '.' do
    begin
      Parser.NextToken;
      Parser.CheckToken(toSymbol);
      PropName := PropName + '.' + Parser.TokenString;
      Parser.NextToken;
    end;
    aProp.PropertyName := PropName;
      Parser.CheckToken('=');
      Parser.NextToken;
    ConvertValue(aProp);
  end;

  procedure ConvertObject(aOutput : TDfmObject);
  var
    InheritedObject: Boolean;
    InlineObject: Boolean;
    aChildObject : TDfmObject;
    lProp : TDfmProperty;
  begin
    InheritedObject := False;
    InlineObject := False;
    if Parser.TokenSymbolIs('INHERITED') then
      InheritedObject := True
    else if Parser.TokenSymbolIs('INLINE') then
      InlineObject := True
    else
      Parser.CheckTokenSymbol('OBJECT');
    Parser.NextToken;
    ConvertHeader(InheritedObject, InlineObject,aOutput);
    while not Parser.TokenSymbolIs('END') and
      not Parser.TokenSymbolIs('OBJECT') and
      not Parser.TokenSymbolIs('INHERITED') and
      not Parser.TokenSymbolIs('INLINE') do
    begin
      lProp := TDfmProperty.Create;
      ConvertProperty(lProp);
      aOutPut.AddDfmProperty(lProp);
    end;

    while not Parser.TokenSymbolIs('END') do
    begin
      aChildObject := TDfmObject.create;
      aOutput.AddOwnedObject(aChildObject);
      ConvertObject(aChildObject);
    end;

    Parser.NextToken;
  end;

begin
  Parser := TParser.Create(Input);
  SaveSeparator := DecimalSeparator;
  DecimalSeparator := '.';
  try
    ConvertObject(Output);
  finally
    DecimalSeparator := SaveSeparator;
    Parser.Free;
  end;
end;

procedure ObjectTreeToText(Input : TDfmTree;Output : TStream);
var
  NestingLevel: Integer;
  SaveSeparator: Char;
//  Reader: TReader;
  Writer: TWriter;
  ObjectName, PropName: string;

  procedure WriteIndent;
  const
    Blanks: array[0..1] of AnsiChar = '  ';
  var
    I: Integer;
  begin
    for I := 1 to NestingLevel do Writer.Write(Blanks, Length(Blanks));
  end;

  procedure WriteStr(const S: UTF8string);
  begin
    Writer.Write(S[1], Length(S));
  end;

  procedure NewLine;
  begin
    WriteStr(sLineBreak);
    WriteIndent;
  end;

  procedure ConvertValue(aProp : TDfmProperty); forward;

  procedure ConvertHeader(aObject : TDfmObject);
  var
    ClassName: string;
    Flags: TFilerFlags;
    Position: Integer;
  begin
    ClassName := aObject.DfmClassName;
    Flags := aObject.FilerFlags;
    ObjectName := aObject.ObjectName;
    Position := aObject.Position;

    WriteIndent;
    if ffInherited in Flags then
      WriteStr('inherited ')
    else if ffInline in Flags then
      WriteStr('inline ')
    else
      WriteStr('object ');
    if ObjectName <> '' then
    begin
      WriteStr(ObjectName);
      WriteStr(': ');
    end;
    WriteStr(ClassName);
    if ffChildPos in Flags then
    begin
      WriteStr(' [');
      WriteStr(IntToStr(Position));
      WriteStr(']');
    end;

    if ObjectName = '' then
      ObjectName := ClassName;  // save for error reporting

    WriteStr(sLineBreak);
  end;

  procedure ConvertBinary(aProp : TDfmProperty);
  const
    BytesPerLine = 32;
  var
    MultiLine: Boolean;
    I: Integer;
    Count: Longint;
    Buffer: array[0..BytesPerLine - 1] of AnsiChar;
    Text: array[0..BytesPerLine * 2 - 1] of AnsiChar;
    lReader : TReader;
  begin
    WriteStr('{');
    Inc(NestingLevel);
    aProp.BinaryValue.Position := 0;
    lReader := TReader.Create(aProp.BinaryValue,4096);
    Count := aProp.BinaryValue.Size;
    MultiLine := Count >= BytesPerLine;
    while Count > 0 do
    begin
      if MultiLine then NewLine;
      if Count >= 32 then I := 32 else I := Count;
      lReader.Read(Buffer, I);
      BinToHex(Buffer, Text, I);
      Writer.Write(Text, I * 2);
      Dec(Count, I);
    end;
    Dec(NestingLevel);
    WriteStr('}');
  end;

  procedure ConvertProperty(aProp : TDfmProperty); forward;

  procedure ConvertValue(aProp : TDfmProperty);
  const
    LineLength = 64;
  var
    I, J, K, L: Integer;
//  S: string;
    W: UnicodeString;
    LineBreak: Boolean;
    lp,lp2 : Integer;

  begin
    case aProp.PropertyType of
     ptList:
       begin
          WriteStr('(');
          Inc(NestingLevel);
          For lp := 0 to aProp.ListCount -1 do
          begin
            NewLine;
            ConvertValue(aProp.ListItem[lp] );
          end;
          Dec(NestingLevel);
          WriteStr(')');
       end;
     ptInteger:
       begin
         WriteStr(IntToStr(aProp.IntegerValue));
       end;
     ptFloat:
      begin

        case aProp.FloatType of
            's', 'S': WriteStr(FloatToStr(aProp.FloatValue) + 's');
            'c', 'C': WriteStr(FloatToStr(aProp.FloatValue) + 'c');
            'd', 'D': WriteStr(FloatToStr(aProp.FloatValue) + 'd');
          else
            WriteStr(FloatToStrF(aProp.FloatValue, ffFixed, 16, 18));
        end;
      end;
      ptString:
        begin
          W := aProp.StringValue;
          L := Length(W);
          if L = 0 then WriteStr('''''') else
          begin
            I := 1;
            Inc(NestingLevel);
            try
              if L > LineLength then NewLine;
              K := I;
              repeat
                LineBreak := False;
                if (W[I] >= ' ') and (W[I] <> '''') and (Ord(W[i]) <= 127) then
                begin
                  J := I;
                  repeat
                    Inc(I)
                  until (I > L) or (W[I] < ' ') or (W[I] = '''') or
                    ((I - K) >= LineLength) or (Ord(W[i]) > 127);
                  if ((I - K) >= LineLength) then LineBreak := True;
                  WriteStr('''');
                  while J < I do
                  begin
                    WriteStr(Char(W[J]));
                    Inc(J);
                  end;
                  WriteStr('''');
                end else
                begin
                  WriteStr('#');
                  WriteStr(IntToStr(Ord(W[I])));
                  Inc(I);
                  if ((I - K) >= LineLength) then LineBreak := True;
                end;
                if LineBreak and (I <= L) then
                begin
                  WriteStr(' +');
                  NewLine;
                  K := I;
                end;
              until I > L;
            finally
              Dec(NestingLevel);
            end;
          end;
        end;
      ptIdent :
        WriteStr(aProp.StringValue);
      ptBinary:
        ConvertBinary(aProp);
      ptSet:
        begin
          WriteStr('[');
          for lp := 0 to aProp.SetValue.Count -1 do
          begin
             WriteStr(aProp.SetValue[lp]);
             if Lp < aProp.SetValue.Count -1  then
                WriteStr(', ');

          end;
          WriteStr(']');
        end;
      ptCollection:
        begin
          WriteStr('<');
          Inc(NestingLevel);
          for lp := 0 to aProp.CollectionItemCount -1 do
          begin
            NewLine;
            WriteStr('item');
            if aProp.CollectionItem[lp].OrderModifer <> -1 then
            begin
              WriteStr(' [');
              WriteStr(IntToStr(aProp.CollectionItem[lp].OrderModifer));
              WriteStr(']');
            end;
            WriteStr(sLineBreak);
            Inc(NestingLevel);
            for LP2 := 0 to aProp.CollectionItem[lp].ItemCount -1 do
            begin
              ConvertProperty(aProp.CollectionItem[lp].Item[lp2]);
            end;
            Dec(NestingLevel);
            WriteIndent;
            WriteStr('end');
          end;
          Dec(NestingLevel);
          WriteStr('>');
        end;
    else
      raise EReadError.CreateResFmt(@sPropertyException,
        [ObjectName, DotSep, PropName, '']);
    end;
  end;

  procedure ConvertProperty(aProp : TDfmProperty);
  begin
    WriteIndent;
    PropName := aProp.PropertyName;  // save for error reporting
    WriteStr(PropName);
    WriteStr(' = ');
    ConvertValue(aProp);
    WriteStr(sLineBreak);
  end;

  procedure ConvertObject(aObject : TDfmObject);
  var
   lp : Integer;
  begin
    ConvertHeader(AObject);
    Inc(NestingLevel);

    for lp := 0 to aObject.DfmPropertyCount -1 do
    begin
      ConvertProperty(aObject.DfmProperty[lp]);
    end;

    for lp := 0 to aObject.OwnedObjectCount -1 do
    begin
      ConvertObject(aObject.OwnedObject[lp])
    end;

    Dec(NestingLevel);
    WriteIndent;
    WriteStr('end' + sLineBreak);
  end;

begin
  NestingLevel := 0;
  SaveSeparator := DecimalSeparator;
  DecimalSeparator := '.';
  try
    Writer := TWriter.Create(Output, 4096);
    try
      ConvertObject(Input);
    finally
      Writer.Free;
    end;
  finally
    DecimalSeparator := SaveSeparator;
  end;
end;


{ TDfmObject }

function TDfmObject.AddDfmProperty(aValue: TDfmProperty): Integer;
begin
  result := FPropertyList.Add(aValue);
end;

function TDfmObject.AddOwnedObject(aValue: TDfmObject): Integer;
begin
  result := FOwnedObjects.Add(aValue);
end;

constructor TDfmObject.Create;
begin
  FOwnedObjects := TObjectList.Create(true);
  FPropertyList := TObjectList.Create(true);
end;

destructor TDfmObject.Destroy;
begin
  FOwnedObjects.Free;
  FPropertyList.Free;
  inherited;
end;

function TDfmObject.GetDfmProperty(Index: Integer): TDfmProperty;
begin
  result := (FPropertyList.Items[Index] as TDfmProperty);
end;

function TDfmObject.GetOwnedObject(Index: Integer): TDfmObject;
begin
  result := (FOwnedObjects.Items[Index] as TDfmObject);
end;

function TDfmObject.GetOwnedObjectCount: Integer;
begin
  result := FOwnedObjects.count;
end;

function TDfmObject.GetPropertyCount: Integer;
begin
  result := FPropertyList.Count;
end;

function TDfmObject.IndexOfDfmProperty(aValue: TDfmProperty): Integer;
begin
  result := FPropertyList.IndexOf(aValue);
end;

function TDfmObject.IndexOfOwnedObject(aValue: TDfmObject): Integer;
begin
  result := FOwnedObjects.IndexOf(aValue);
end;

procedure TDfmObject.RemoveDfmProperty(Index: Integer);
begin
   FPropertyList.Delete(index);
end;

function TDfmObject.PropertyByName(aName: String): TDfmProperty;
var
 I : Integer;
begin
  result := nil;
  for I := 0 to DfmPropertyCount -1 do
  begin
    if lowercase(DfmProperty[I].PropertyName) = lowercase(aName) then
    begin
       result := DfmProperty[I];
       break;
    end;
  end;

end;

procedure TDfmObject.RemoveDfmProperty(aValue: TDfmProperty);
begin
   FPropertyList.Remove(AValue)
end;

procedure TDfmObject.RemoveOwnedObject(aValue: TDfmObject);
begin
  FOwnedObjects.Remove(AValue);
end;

procedure TDfmObject.RemoveOwnedObject(Index: Integer);
begin
  FOwnedObjects.Delete(Index);
end;


procedure TDfmObject.SetClassName(const Value: UnicodeString);
begin
  FClassName := Value;
end;

procedure TDfmObject.SetFilerFlags(const Value: TFilerFlags);
begin
  FFilerFlags := Value;
end;



procedure TDfmObject.SetObjectName(const Value: UnicodeString);
begin
  FObjectName := Value;
end;

procedure TDfmObject.SetPosition(const Value: Integer);
begin
  FPosition := Value;
end;

procedure TDfmObject.ClearOwnedObjects;
begin
  FOwnedObjects.Clear;
end;

procedure TDfmObject.ExtractDfmProperty(aValue: TDfmProperty);
begin
     FPropertyList.Extract(aValue);
end;

procedure TDfmObject.ExtractOwnedObject(aValue: TDfmObject);
begin
  FOwnedObjects.Extract(aValue);
end;

{ TDfmProperty }


constructor TDfmProperty.Create;
begin
  FCollectionItems := TObjectList.Create(true);
  FptListList := TObjectLIst.Create(true);
  FBinaryValue := TMemoryStream.Create;
  FSetValue:= TStringLIst.Create;
end;

destructor TDfmProperty.Destroy;
begin
  FSetValue.free;
  FBinaryValue.Free;
  FCollectionItems.free;
  FptListList.free;
  inherited;
end;



function TDfmProperty.GetListCount: Integer;
begin
  result := FptListList.Count;
end;

procedure TDfmProperty.RemoveCollectionItem(Index : Integer);
begin
  FCollectionItems.Delete(Index);
end;


procedure TDfmProperty.SetFloatValue(const Value: Extended);
begin
  FFloatValue := Value;
end;

procedure TDfmProperty.SetIntegerValue(const Value: Int64);
begin
  FIntegerValue := Value;
end;

procedure TDfmProperty.SetSetValue(const Value: TStrings);
begin
  FSetValue := Value;
end;

procedure TDfmProperty.SetPropertyName(const Value: UnicodeString);
begin
  FPropertyName := Value;
end;

procedure TDfmProperty.SetPropertyType(const Value: TDfmPropertyType);
begin
  FPropertyType := Value;
end;

procedure TDfmProperty.SetStringValue(const Value: String);
begin
  FStringValue := Value;
end;


function TDfmProperty.AddListItem(value: TDfmProperty): Integer;
begin
  result :=  FptListList.Add(value);
end;

function TDfmProperty.GetCollectionItem(
  Index: Integer): TDfmCollectionItem;
begin

  result := (  FCollectionItems.Items[Index] as TDfmCollectionItem);
end;

function TDfmProperty.GetListItem(Index: Integer): TDfmProperty;
begin
  result := (FptListList.Items[Index] as TDfmProperty);
end;

procedure TDfmProperty.RemoveListItem(index: Integer);
begin
  FptListList.Delete(Index);
end;

procedure TDfmProperty.SetCollectionItem(Index: Integer;
  const Value: TDfmCollectionItem);
begin
  FCollectionItems.Items[Index] := Value;
end;

procedure TDfmProperty.SetListItem(Index: Integer;
  const Value: TDfmProperty);
begin
  FptListList.Items[Index] := Value;
end;


function TDfmProperty.GetCollectionItemCount: Integer;
begin
 result := FCollectionItems.Count;
end;

function TDfmProperty.AddCollectionItem(
  value: TDfmCollectionItem): Integer;
begin
 result := FCollectionItems.Add(value);
end;

{ TDfmCollectionItem }

function TDfmCollectionItem.AddItem(aItem: TDfmProperty): Integer;
begin
  result := FCollection.Add(aItem);
end;

constructor TDfmCollectionItem.Create;
begin
  FCollection := TObjectList.Create(true);
end;

destructor TDfmCollectionItem.Destroy;
begin
  FCollection.Free; // Owns Objects so there are freed too.
  inherited;
end;

function TDfmCollectionItem.GetItem(index: Integer): TDfmProperty;
begin
  result := (FCollection.Items[Index]  as TDfmProperty);
end;

function TDfmCollectionItem.ItemCount: Integer;
begin
 result := FCollection.Count;
end;

procedure TDfmCollectionItem.RemoveItem(Index: Integer);
begin
  FCollection.Delete(Index);
end;

procedure TDfmCollectionItem.SetItem(index: Integer;
  const Value: TDfmProperty);
begin
  FCollection.Items[Index] := Value;
end;

procedure TDfmCollectionItem.SetOrderModifer(const Value: Integer);
begin
  FOrderModifer := Value;
end;

end.
