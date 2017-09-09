unit XmlSerial;
// MIT License
//
// Copyright (c) 2009 - Robert Love
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//
// ---------------------------------------------------------------------------
// XmlSerial - Written by Robert Love
// ---------------------------------------------------------------------------
//
// Actual HISTORY:
//
// Version 0.1
// -Basic support Classes and Record Properties
// -Attribute Syntax is now supported.
//
// Version 0.2 (on going with each commit!)
//   Changes to Help Support Lists, but not complete and really buggy right now
//   Changes Made to support Float and TDateTime,TTime and TDate in XML File
//   Version 0.2 TODO
//     -Finish Array and Enumeration Support
//     -Check and most likely add support for: Boolean, Decimal, BCD
//     -Add support for Stream - BinHex or Base 64 or something else need to look at .NET
// ---------------------------------------------------------------------------
// Roadmap:  (if you want to help, let me know!)
// ---------------------------------------------------------------------------
//
// Version 0.2
// -Array and Enumerations(LIsts) (Although it will attempt and most likely fail with class that contain these types.
//
// Version 0.3
// -DataTypes such as TDatetime need to match XML Types
// -Testing to see if this produces files compatable with .NET Xml Serialization
// HINT: Don't Depend on the structure produced until this is complete!
//
// Version 0.4 
// -Better Error Handling, when unsupported types, etc... are found.
//
// Version 0.5 
// -Performance Tuning
//
// Version 1.0 - Then after some time, allowing for more testing to make it solid
//
// Some future version if someone finds a need for it, and wants to help.
// -Support XML namespaces???
// -Find or Write a XmlWriter and XmlReader clone for Win32 that would
// speed this up, and reduce the memory clue
//
//
// ---------------------------------------------------------------------------
// Programmers Notes:
// ---------------------------------------------------------------------------
// Although this is designed to have a similar interface to .NET XmlSerializer
// it is far from complete.   The goal in writing this code was two fold.
// 1. Example of how to use Attributes and the new RTTI in Delphi 2010
// 2. Allow classes that used these attributes to be cross compiled
// with Delphi Prism and have the same behavior.
// Specific Reason:
// I have a set of classes I need to be able use in both
// .NET (web service) and Win32 (Client)
// This unit does not need to cross compile, and TXmlSerializer is "T"
// since it does not have the same or simlar interface to XmlSerializer.
//
// Performance: This uses XmlDocument which means that the entire XML Document
// is read into RAM and then placed in your classes.
// I have not benchmarked anythign but I suspect during serialization
// you will need 2-3 times the amount of RAM that you classes
// will require.
//
// My application of this is really small so it not worth
// doing it another way.   But you have been warned!
//
//
// Usage Notes:
//
// Two ways to use:
//
//  The contructor of both classes, creates a MAP of RTTI Member to XML Element
//  The design is done to avoid having to query the RTTI information more than
//  needed. If you have to handle multiple Serialize or DeSerialize
//  calls during the scope of your application.   Performance wise it might
//  make since to cache the serializer, and not recreate each time.
//
//
// Method 1:
//var
// o : TypeIWantToSerailze;
// s : TXmlTypeSerializer;
// x : TXmlDocument;
// v : TValue;
//begin
//  s := TXmlTypeSerializer.create(TypeInfo(o));
//  x := TXmlDocument.Create(Self); // NEVER PASS NIL!!!
//  s.Serialize(x,o);
//  x.SaveToFile('FileName.txt');
//  v := s.Deserialize(x);
//  o := v.AsType<TypeIWantToSerailze>;
//  x.free;
//  s.free;
//end;
// Method 2:
//var
// o : TypeIWantToSerailze;
// s : TXmlSerializer<TypeIWantToSerailze>;
// x : TXmlDocument;
//begin
//  s := TXmlTypeSerializer<TypeIWantToSerailze>.create;
//  x := TXmlDocument.Create(Self); // NEVER PASS NIL!!!
//  s.Serialize(x,o);
//  x.SaveToFile('FileName.txt');
// o := s.Deserialize(x);
//  x.free;
//  s.free;
//end;
interface

uses SysUtils, Classes, TypInfo, XmlDoc, XmlIntf, RTTI, Generics.Defaults,
  Generics.Collections;

type

  TCustomXmlAttribute = class(TCustomAttribute)
  end;

  XmlIgnoreAttribute = class(TCustomXmlAttribute)
  end;

  XmlElementAttribute = class(TCustomXmlAttribute)
  private
    FElementName: string;

  public
    constructor create(const name: string);
    property ElementName: string read FElementName write FElementName;
  end;

  XmlAttributeAttribute = class(TCustomXmlAttribute)
  private
    FAttributeName: string;

  public
    constructor create(const name: string);
    property AttributeName: string read FAttributeName write FAttributeName;
  end;

  XmlRootAttribute = class(TCustomXmlAttribute)
  private
    FElementName: string;

  public
    constructor create(const name: string);
    property ElementName: string read FElementName write FElementName;
  end;

  EXmlSerializationError = class(Exception);

    TMemberNodeType = (ntNone, ntElement, ntAttribute);
    TMemberNodeData = record NodeType: TMemberNodeType;
    NodeName: string;
  end;

  TMemberListType = (ltNone, ltEnum,ltArray);
  TMemberListTypeSet = set of TMemberListType;
const
  ValidMemberList : TMemberListTypeSet = [ltEnum,ltArray];

type
  TMemberMap = record
  public
    Member: TRttiMember;
    NodeName: string;
    NodeType: TMemberNodeType;
    isList : Boolean;
    List: TArray<TMemberMap>;
    class function CreateMap(var aCtx: TRttiContext; aMember: TRttiMember)
      : TMemberMap; static;
  end;

  TTypeMapping = class(TObject)
  public
    Map: TMemberMap;
    function XmlSafeName(const Name : String) : String;
    procedure Populate(var aContext: TRttiContext; aType: PTypeInfo); overload;
    procedure Populate(var aContext: TRttiContext; aRttiType: TRttiType);
      overload;
  end;

  TXmlCustomTypeSerializer = class abstract(TObject)
  protected
    FMemberMap: TTypeMapping;
    FCtx: TRttiContext;
    FRootType: TRttiType;

  protected
    function CreateValue(aTypeInfo: PTypeInfo): TValue; virtual;
    procedure SerializeValue(const Value: TValue; const Map: TMemberMap;
      BaseNode: IXMLNode; Doc: TXmlDocument); virtual;
    function DeSerializeValue(Node: IXMLNode; Map: TMemberMap): TValue; virtual;
    function ValueToString(const Value: TValue): string; virtual;
    function TextToValue(aType: TRttiType; const aText: string): TValue;

    procedure Serialize(var Doc: TXmlDocument; const ValueToSerialize: TValue);
      virtual;
    function Deserialize(Doc: TXmlDocument): TValue; virtual;
    constructor create(aType: PTypeInfo); virtual;

  public
    destructor Destroy; override;
  end;

  TXmlTypeSerializer = class(TXmlCustomTypeSerializer)
  public
    constructor create(aType: PTypeInfo); override;
    procedure Serialize(var Doc: TXmlDocument; const ValueToSerialize: TValue);
      override;
    function Deserialize(Doc: TXmlDocument): TValue; override;
  end;

  TXmlSerializer<T> = class(TXmlCustomTypeSerializer)
  public
    constructor create; reintroduce; virtual;
    procedure Serialize(var Doc: TXmlDocument; ValueToSerialize: T); reintroduce;
    function Deserialize(Doc: TXmlDocument): T; reintroduce;
  end;

  TCustomAttributeClass = class of TCustomAttribute;

  PObject = ^TObject;

implementation

uses  XsBuiltins, RttiUtils;

{ XmlElementAttribute }

constructor XmlElementAttribute.create(const name: string);
begin
  FElementName := name;
end;

{ XmlAttributeAttribute }

constructor XmlAttributeAttribute.create(const name: string);
begin
  FAttributeName := name;
end;

{ XmlRootAttribute }

constructor XmlRootAttribute.create(const name: string);
begin
  FElementName := name;
end;

{ TMemberMap }

class function TMemberMap.CreateMap(var aCtx: TRttiContext;
  aMember: TRttiMember): TMemberMap;
var
  Attr: TCustomAttribute;
  Dupe: Integer;
  ElementType: PTypeInfo;
  TypMp: TTypeMapping;
  MemberType: TRttiType;
begin
  // Default Values
  Result.NodeType := ntElement;
  Result.Member := aMember;
  Result.NodeName := aMember.name;
  Result.isList := false;
  Result.List := nil;
  Dupe := 0;
  if aMember is TRttiProperty then
    MemberType := TRttiProperty(aMember).PropertyType
  else
    MemberType := (aMember as TRttiField).FieldType;
  // Check Attributes for Custom overrides.
  for Attr in aMember.GetAttributes do
  begin
    if Attr is XmlIgnoreAttribute then
    begin
      Result.NodeType := ntNone;
      Result.NodeName := '';
    end;
    if Attr is XmlElementAttribute then
    begin
      Result.NodeType := ntElement;
      Result.NodeName := XmlElementAttribute(Attr).ElementName;
    end;
    if Attr is XmlAttributeAttribute then
    begin
      Result.NodeType := ntAttribute;
      Result.NodeName := XmlAttributeAttribute(Attr).AttributeName;
    end;
    if Attr is TCustomXmlAttribute then
    begin
      inc(Dupe);
    end;
  end;
  if Dupe > 1 then
    raise EXmlSerializationError.CreateFmt(
      'A member can have only one TCustomXmlAttribute: %s.%s',
      [aMember.Parent.QualifiedName, aMember.name]);
  // Check for Special Type

  if (Result.NodeType <> ntNone) then
  begin
    if TEnumerableFactory.IsTypeSupported(aMember.MemberType) and TElementAddFactory.TypeSupported(aMember.MemberType.Handle) then
    begin
      result.isList := true;
      MemberType := aCtx.GetType(TArrayElementAdd.GetAddType(aMember.MemberType.Handle));
      if Result.NodeType = ntAttribute then
      begin
        raise EXmlSerializationError.CreateFmt(
           'TXmlAttributeAttribute not supported for this member: %s.%s',
             [aMember.Parent.QualifiedName, aMember.name]);
      end;
      TypMp := TTypeMapping.create;
      try
        TypMp.Populate(aCtx, MemberType);
        Result.List := TypMp.Map.List;
      finally
        TypMp.Free;
      end;
    end
    else
    begin
      if (aMember is TRttiProperty) and
        not (TRttiProperty(aMember).IsReadable
             and TRttiProperty(aMember).IsWritable) then
      begin
        // property must be readable and writable to be able to be streamed
        Result.NodeType := ntNone;
      end
      else
      begin
        if MemberType.TypeKind in [tkRecord, tkClass] then
        begin
          TypMp := TTypeMapping.create;
          try
            TypMp.Populate(aCtx, MemberType);
            Result.List := TypMp.Map.List;
          finally
            TypMp.Free;
          end;
        end;
      end;

    end;

  end;

end;

{ TMemberMapList }

procedure TTypeMapping.Populate(var aContext: TRttiContext; aType: PTypeInfo);
begin
  Populate(aContext, aContext.GetType(aType));
end;

procedure TTypeMapping.Populate(var aContext: TRttiContext;
  aRttiType: TRttiType);
var
  Prop: TRttiProperty;
  Props: TArray<TRttiProperty>;
  Field: TRttiField;
  Fields: TArray<TRttiField>;
  MemberMap: TMemberMap;
  Cnt: Integer;
  RootAttr: TCustomAttribute;
  TypMp  : TTypeMapping;
begin
  // Clear Old Contents and set Default Values
  SetLength(Map.List, 0);
  Map.NodeType := ntElement;
  Map.isList := false;

  if TAttrUtils.HasAttribute(aContext, aRttiType, XmlRootAttribute, RootAttr)
    then
  begin
    Map.NodeName := (RootAttr as XmlRootAttribute).ElementName;
  end
  else
  begin
    Map.NodeName := XmlSafeName(aRttiType.name);
  end;

  if TEnumerableFactory.IsTypeSupported(aRttiType) and TElementAddFactory.TypeSupported(aRttiType.Handle) then
  begin
    Map.isList := true;

    TypMp := TTypeMapping.create;
    try
      TypMp.Populate(aContext, aContext.GetType(TElementAddFactory.GetAddType(aRttiType.Handle)));
      Map.List := TypMp.Map.List;
    finally
      TypMp.Free;
    end;
  end
  else
  begin
    // Cache lists to avoid having to make Call Twice
    Props := aRttiType.GetProperties;
    Fields := aRttiType.GetFields;
    // Set to Max Possible Length
    SetLength(Map.List, Length(Props) + Length(Fields));
    Cnt := 0;
    for Field in aRttiType.GetFields do
    begin
      if Field.Visibility in [mvPublic, mvPublished] then
      begin
        MemberMap := TMemberMap.CreateMap(aContext, Field);
        if MemberMap.NodeType <> ntNone then
        begin
          Map.List[Cnt] := MemberMap;
          inc(Cnt);
        end;
      end;
    end;

    for Prop in Props do
    begin
      if Prop.Visibility in [mvPublic, mvPublished] then
      begin
        MemberMap := TMemberMap.CreateMap(aContext, Prop);
        if MemberMap.NodeType <> ntNone then
        begin
          Map.List[Cnt] := MemberMap;
          inc(Cnt);
        end;
      end;
    end;

    // Set Length back to size calculated
    SetLength(Map.List, Cnt);
  end;
end;

function TTypeMapping.XmlSafeName(const Name: String): String;
begin
//TODO: Figure out how .NET does it to duplicate
// I think in .NET the it might be done with the System.Xml.XmlConvert class

// This is a temp fix to get Generic Types TList<ASDF> to work
 result := StringReplace(Name,'<','.',[rfReplaceAll]);
 result := StringReplace(result,'>','.',[rfReplaceAll]);
end;

{ TXmlCustomTypeSerializer }

constructor TXmlCustomTypeSerializer.create(aType: PTypeInfo);
begin
  FMemberMap := TTypeMapping.create;
  FCtx := TRttiContext.create;
  FMemberMap.Populate(FCtx, aType);
  FRootType := FCtx.GetType(aType);
end;

function TXmlCustomTypeSerializer.CreateValue(aTypeInfo: PTypeInfo): TValue;
var
  rtType: TRttiStructuredType;
begin
  Result := nil;
  rtType := (FCtx.GetType(aTypeInfo) as TRttiStructuredType);
  if rtType is TRttiRecordType then
  begin
    TValue.Make(nil, aTypeInfo, Result);
  end
  else if rtType is TRttiInstanceType then
  begin
    // TODO: Support for Event to allow creation of classes with parameters on contrcutors
    Result := TRttiInstanceType(rtType).MetaclassType.create;
  end
  else
    raise EXmlSerializationError.CreateFmt
      ('Unsupported type %@', [rtType.QualifiedName]);

end;

function TXmlCustomTypeSerializer.Deserialize(Doc: TXmlDocument): TValue;
begin
  if not Doc.Active then
    Doc.Active := true;
  if Doc.IsEmptyDoc then
    raise EXmlSerializationError.create(
      'Nothing to  deserialize the document is empty.');

  Result := DeSerializeValue(Doc.Node.ChildNodes.First, FMemberMap.Map);

end;

function TXmlCustomTypeSerializer.DeSerializeValue
  (Node: IXMLNode; Map: TMemberMap): TValue;
var
  Children: IXMLNodeList;
  Child: IXMLNode;
  MapItem: TMemberMap;
  ChildValue: TValue;
  ResultType: TRttiType;

begin
  if Map.isList then
  begin
    Children := Node.ChildNodes;
    Result := TValue.Empty; // TODO
  end
  else
  begin

      begin
        if (Length(Map.List) > 0) then // Must be Structured Type
        begin
          if Assigned(Map.Member) then
            ResultType := Map.Member.MemberType
          else
            ResultType := FRootType;

          if not(ResultType is TRttiStructuredType) then
            raise EXmlSerializationError.create(
              'Expecting a structured type to Deserialize');
          // Create Result TValue
          if ResultType.IsInstance then
          begin
            Result := ResultType.AsInstance.MetaclassType.create;
          end
          else
          begin
            TValue.Make(nil, ResultType.Handle, Result);
          end;

          Children := Node.ChildNodes;
          for MapItem in Map.List do
          begin
            case MapItem.NodeType of
              ntElement: Child := Children.FindNode(MapItem.NodeName);
              ntAttribute: begin
                             if Node.HasAttribute(MapItem.NodeName) then
                               Child := Node.AttributeNodes.FindNode(MapItem.NodeName)
                             else
                               Child :=nil;
                            end;
            end; { Case }
            if Assigned(Child) then
            begin
              ChildValue := DeSerializeValue(Child, MapItem);
              if not ChildValue.isEmpty then
                MapItem.Member.SetValue(Result, ChildValue);
            end;
          end;

        end
        else
        begin // Not a structure Type, convert from String to Value
          Result := TextToValue(Map.Member.MemberType, Node.Text);
        end;
      end;
  end;
end;

destructor TXmlCustomTypeSerializer.Destroy;
begin
  FMemberMap.Free;
  FCtx.Free;
  inherited;
end;

procedure TXmlCustomTypeSerializer.Serialize(var Doc: TXmlDocument;
  const ValueToSerialize: TValue);
begin
  if not Doc.IsEmptyDoc then
    raise EXmlSerializationError.create(
      'Document must be empty to serialize to it.');
  if not Doc.Active then
    Doc.Active := true;

  SerializeValue(ValueToSerialize, FMemberMap.Map, nil, Doc);
end;

procedure TXmlCustomTypeSerializer.SerializeValue
  (const Value: TValue; const Map: TMemberMap; BaseNode: IXMLNode;
  Doc: TXmlDocument);
var
  NewNode: IXMLNode;
  CurrentProp: TRttiProperty;
  MoveNextMethod: TRttiMethod;
  EnumNode: IXMLNode;
  EnumNodeData: TMemberMap;
  CurrentValue: TValue;
  MapItem: TMemberMap;
  I: Integer;
  EnumFactory :  TEnumerableFactory;
  Enumerator : TEnumerator<TValue>;
begin
  case Map.NodeType of
    ntNone:
      exit; // Do Nothing, but then really should have not been the list to begin with!
    ntElement:
      begin
        if not Assigned(BaseNode) then
          NewNode := Doc.AddChild(Map.NodeName)
        else
          NewNode := BaseNode.AddChild(Map.NodeName);
        // if Record or Object
        if Length(Map.List) > 0 then
        begin
          if Not (Map.isList) then
          begin
            for MapItem in Map.List do
            begin
              Assert(Assigned(MapItem.Member));
              CurrentValue := MapItem.Member.GetValue(Value);
              SerializeValue(CurrentValue, MapItem, NewNode, Doc);
            end;
          end;
        end
        else
        begin
          if Not (Map.isList) then
            NewNode.Text := ValueToString(Value);
        end;
      end;
    ntAttribute:
      begin
        // This should have already been done, so just assert instead of exception.
        Assert(not Map.isList, 'XmlAtttribute applied to an List Type');
        Assert(Length(Map.List) = 0,
          'XmlAtttribute applied to a Map.List that is not Zero.');
        BaseNode.Attributes[Map.NodeName] := ValueToString(Value);
      end;
  end;

  if Map.isList then
  begin
    EnumNodeData := Map;
    EnumNodeData.NodeName := 'item';
    EnumNodeData.isList := false;
  
    EnumFactory := TEnumerableFactory.Create(Value);
    Enumerator := EnumFactory.GetEnumerator;
    while Enumerator.MoveNext do
    begin
      CurrentValue := Enumerator.Current;
      EnumNode := NewNode.AddChild(TElementAddFactory.GetAddType(Value.TypeInfo).Name , '');
      SerializeValue(CurrentValue, EnumNodeData, NewNode, Doc);
    end;
  end;
end;

function TXmlCustomTypeSerializer.TextToValue
  (aType: TRttiType; const aText: string): TValue;
var
  I: Integer;
  xsDate : TXSDate;
  xsTime : TXSTime;
  xsDateTime : TXSDateTime;
begin
  case aType.TypeKind of
    tkWChar, tkLString, tkWString, tkString, tkChar, tkUString:
      Result := aText;
    tkInteger, tkInt64:
      Result := StrToInt(aText);
    tkFloat:
    begin
      if aType.Name = 'TDate' then
      begin
        xsDate := TXSDate.Create;
        try
        xsDate.XSToNative(aText);
        result := xsDate.AsDate;
        finally
           xsDate.Free;
        end;
      end
      else if aType.Name = 'TTime' then
      begin
        xsTime := TXSTime.Create;
        try
        xsTime.XSToNative(aText);
        result := xsTime.AsTime;
        finally
           xsTime.Free;
        end;

      end
      else if aType.Name = 'TDateTime' then
      begin
        xsDateTime := TXSDateTime.Create;
        try
        xsDateTime.XSToNative(aText);
        result := xsDateTime.AsDateTime;
        finally
           xsDateTime.Free;
        end;
      end
      else   Result :=  SoapStrToFloat(aText);

    end;
    tkEnumeration:
      Result := TValue.FromOrdinal
        (aType.Handle, GetEnumValue(aType.Handle, aText));
    tkSet:
      begin
        I := StringToSet(aType.Handle, aText);
        TValue.Make(@I, aType.Handle, Result);
      end;
  else
    raise EXmlSerializationError.create('Type not Supported, yet...');
  end;

end;

function TXmlCustomTypeSerializer.ValueToString(const Value: TValue): string;
var
  xsDate : TXSDate;
  xsTime : TXSTime;
  xsDateTime : TXSDateTime;
begin

  case Value.Kind of
    tkWChar, tkLString, tkWString, tkString, tkChar, tkUString:
      Result := Value.ToString;
    tkInteger, tkInt64:
      Result := Value.ToString;
    tkFloat:
    begin
      if Value.TypeInfo.Name = 'TDate' then
      begin
        xsDate := TXSDate.Create;
        try
        xsDate.AsDate := Value.AsExtended;
        result :=  xsDate.NativeToXS;
        finally
           xsDate.Free;
        end;
      end
      else if Value.TypeInfo.Name = 'TTime' then
      begin
        xsTime := TXSTime.Create;
        try
        xsTime.AsTime := Value.AsExtended;
        result :=  xsTime.NativeToXS;
        finally
           xsTime.Free;
        end;
      end
      else if Value.TypeInfo.Name = 'TDateTime' then
      begin
        xsDateTime := TXSDateTime.Create;
        try
          xsDateTime.AsDateTime := Value.AsExtended;
          result :=  xsDateTime.NativeToXS;
        finally
           xsDateTime.Free;
        end;
      end
      else
         Result :=  SoapFloatToStr(Value.AsExtended);
    end;
    tkEnumeration:
      Result := Value.ToString;
    tkSet:
      Result := Value.ToString;
  else
    raise EXmlSerializationError.create('Type not Supported, yet...');
  end;
end;

{ TXmlTypeSerializer }

constructor TXmlTypeSerializer.create(aType: PTypeInfo);
begin
  inherited create(aType);
end;

function TXmlTypeSerializer.Deserialize(Doc: TXmlDocument): TValue;
begin
  Result := inherited Deserialize(Doc);
end;

procedure TXmlTypeSerializer.Serialize(var Doc: TXmlDocument;
  const ValueToSerialize: TValue);
begin
  inherited Serialize(Doc, ValueToSerialize);

end;

{ TXmlSerializer<T> }

constructor TXmlSerializer<T>.create;
begin
  inherited create(TypeInfo(T));
end;

function TXmlSerializer<T>.Deserialize(Doc: TXmlDocument): T;
var
  V: TValue;
begin
  V := inherited Deserialize(Doc);
  Result := V.AsType<T>;
end;

procedure TXmlSerializer<T>.Serialize(var Doc: TXmlDocument;
  ValueToSerialize: T);
var
  V: TValue;
begin
  V := TValue.From<T>(ValueToSerialize);
  inherited Serialize(Doc, V);
end;

end.
