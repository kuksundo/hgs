unit u_dzDbCreatorReadXml;

interface

uses
  Windows,
  SysUtils,
  u_dzDbCreatorDescription,
  xmldom;

type
  EXmlDbReader = class(Exception);
  EXmlEmpty = class(EXmlDbReader);
  EXmlMultiple = class(EXmlDbReader);
  EXmlWrongDocType = class(EXmlDbReader);
  EXmlWrongNodeType = class(EXmlDbReader);
  EHeaderNoAttributes = class(EXmlDbReader);
  EProgNeedsIdName = class(EXmlDbReader);
  EDbNeedsName = class(EXmlDbReader);
  ETableNeedsName = class(EXmlDbReader);
  EUnknownTableAttribute = class(EXmlDbReader);
  EColumnNeedsName = class(EXmlDbReader);
  EIndexNeedsName = class(EXmlDbReader);
  EUnknownTable = class(EXmlDbReader);
  EColDataNeedsName = class(EXmlDbReader);
  EUnknownColDataAttribute = class(EXmlDbReader);
  EColDataNeedsValue = class(EXmlDbReader);
  EUnknownColumnName = class(EXmlDbReader);

type
  TXmlDbReader = class
  private
    class procedure HandleTable(_TableNode: IDOMNode; const _DbDescription: IdzDbDescription; _IncludeData: boolean);
    class procedure HandleDatabase(_DbNode: IDOMNode;
      const _DbDescription: IdzDbDescription; _IncludeData: boolean);
    class procedure HandleDatabaseTypes(_DbTypesNode: IDOMNode;
      const _DbDescription: IdzDbDescription);
    class procedure HandleColumn(_ColumnNode: IDOMNode;
      _Table: IdzDbTableDescription;
      const _DbDescription: IdzDbDescription);
    class procedure HandleIndex(_IndexNode: IDOMNode;
      _Table: IdzDbTableDescription;
      const _DbDescription: IdzDbDescription);
    class procedure ResolveTableLinks(
      const _DbDescription: IdzDbDescription);
    class procedure HandleHeader(_HeaderNode: IDOMNode; const _DbDescription: IdzDbDescription);
    class procedure HandleData(_DataNode: IDOMNode;
      const _Table: IdzDbTableDescription;
      const _DbDescription: IdzDbDescription);
    class procedure HandleRow(_RowNode: IDOMNode;
      const _Table: IdzDbTableDescription;
      const _DbDescription: IdzDbDescription);
    class procedure HandleColData(_ColDataNode: IDOMNode;
      const _Table: IdzDbTableDescription; const _Row: IdzDbTableRow;
      const _DbDescription: IdzDbDescription);
    class procedure HandleDatabaseType(_DbTypeNode: IDOMNode;
      const _DbDescription: IdzDbDescription);
    class procedure HandleVersion(_VersionNode: IDOMNode;
      const _DbType: IdzDbTypeDescription);
    class procedure HandleConfig(_ConfigNode: IDOMNode;
      const _DbDescription: IdzDbDescription);
    class procedure HandleDefaultTypes(_DefaultTypesNode: IDOMNode;
      const _DbVersNType: IdzDbVersionNTypeAncestor);
    class procedure HandleVersions(_VersionsNode: IDOMNode;
      const _DbVersNType: IdzDbVersionNTypeAncestor);
    class procedure HandleVariables(_VariablesNode: IDOMNode;
      const _DbVersNType: IdzDbVersionNTypeAncestor);
    class procedure HandleDefaultType(_DefaultTypeNode: IDOMNode;
      const _DbVersNType: IdzDbVersionNTypeAncestor);
    class procedure HandleDefaultValue(_DefaultValueNode: IDOMNode;
      _DefaultType: IdzDbDefaultTypeDescription);
    class procedure HandleVariable(_VariableNode: IDOMNode;
      _DbType: IdzDbVersionNTypeAncestor);
    class procedure HandleScripts(_ScriptsNode: IDOMNode;
      const _DbVersNType: IdzDbVersionNTypeAncestor);
    class procedure HandleScript(_ScriptNode: IDOMNode;
      _DbType: IdzDbVersionNTypeAncestor);
    class procedure CheckForScriptPlaceholders(
      _DbType: IdzDbVersionNTypeAncestor; const _DbDescription: IdzDbDescription);
  protected
  public
    class procedure ParseXml(const _Document: string; const _DbDescription: IdzDbDescription; _IncludeData: boolean); overload;
    class procedure ParseXml(_DomNode: IDOMNode; const _DbDescription: IdzDbDescription; _IncludeData: boolean); overload;
  end;

implementation

uses
  StrUtils,
  XMLDoc,
  XMLIntf,
  RegExpr,
  u_dzMiscUtils,
  u_dzStringUtils,
  u_dzConvertUtils,
  u_dzXmlUtils,
  Classes;

{ TXmlDbReader }
type
  TRefTableAndColumn = class
  public
    fRefTableName: string;
    fRefColumnName: string;
  end;

class procedure TXmlDbReader.ParseXml(const _Document: string; const _DbDescription: IdzDbDescription; _IncludeData: boolean);
var
  XMLDocument: TXMLDocument;
  st: TStringStream;
begin
  XMLDocument := TXMLDocument.Create(nil);
  try
    XMLDocument.DOMVendor := GetDOMVendor('MSXML');
    st := TStringStream.Create(_Document);
    try
      st.Position := 0;
      XMLDocument.LoadFromStream(st, xetUnknown);
    finally
      st.Free;
    end;
    ParseXml(XMLDocument.DOMDocument, _DbDescription, _IncludeData);
  finally
    XMLDocument.Free;
  end;
end;

function XmlToChar(const _s: string): string;
const
  XML_SEQUENCE: array[0..1] of string = ('&#60;', '&#38;');
  CHAR_EQUIV: array[0..1] of char = ('<', '&');
var
  p: integer;
  i: integer;
begin
  Result := _s;
  for i := low(XML_SEQUENCE) to high(XML_SEQUENCE) do begin
    p := Pos(XML_SEQUENCE[I], Result);
    while p <> 0 do begin
      Result := LeftStr(Result, p - 1) + CHAR_EQUIV[i] + TailStr(Result, p + 5);
      p := Pos(XML_SEQUENCE[I], Result);
    end;
  end;
end;

class procedure TXmlDbReader.HandleColumn(_ColumnNode: IDOMNode; _Table: IdzDbTableDescription; const _DbDescription: IdzDbDescription);

  function StringToIndexType(const _s: string): TIndexType;
  begin
    if AnsiSameText('NoIndex', _s) then
      Result := itNoIndex
    else if AnsiSameText('PrimaryKey', _s) then
      Result := itPrimaryKey
    else if AnsiSameText('ForeignKey', _s) then
      Result := itForeignKey
    else if AnsiSameText('Unique', _s) then
      Result := itUnique
    else if AnsiSameText('nonUnuique', _s) then // war ein bug
      Result := itNotUnique
    else if AnsiSameText('nonUnique', _s) then
      Result := itNotUnique
    else
      raise EConvertError.CreateFmt('%s is not a valid TIndexType name', [_s]);
  end;

var
  Attrib: integer;
  attrName: string;
  attrNode: IDOMNode;
  ColName: string;
  ColType: string;
  ColSize: string;
  ColComment: string;
  ColNull: string;
  ColDefault: string;
  ColDefaultSet: boolean;
  ColIndex: string;
  ColReftable: string;
  ColRefcolumn: string;
  ColAutoinc: string;
  ColSort: string;
  RefTable: IdzDbTableDescription;
  Column: IdzDbColumnDescription;
  RefColumn: IdzDbColumnDescription;
  RefTabNCol: TRefTableAndColumn;
  Index: IdzDbIndexDescription;
begin
  if not assigned(_ColumnNode.attributes) then
    raise EColumnNeedsName.Create('column needs "name" attribute');
  ColDefaultSet := false;
  for Attrib := 0 to _ColumnNode.attributes.length - 1 do begin
    attrNode := _ColumnNode.attributes.item[Attrib];
    attrName := attrNode.nodeName;
    if 'name' = attrName then
      ColName := attrNode.nodeValue
    else if 'type' = attrName then
      ColType := attrNode.nodeValue
    else if 'size' = attrName then
      ColSize := attrNode.nodeValue
    else if 'comment' = attrName then
      ColComment := XmlStringUnEscape(attrNode.nodeValue)
    else if 'null' = attrName then
      ColNull := attrNode.nodeValue
    else if 'default' = attrName then begin
      ColDefaultSet := true;
      ColDefault := attrNode.nodeValue;
      ColDefault := XmlToChar(ColDefault);
    end else if 'index' = attrName then
      ColIndex := attrNode.nodeValue
    else if 'reftable' = attrName then
      ColReftable := attrNode.nodeValue
    else if 'refcolumn' = attrName then
      ColRefcolumn := attrNode.nodeValue
    else if 'autoinc' = attrName then
      ColAutoinc := attrNode.nodeValue
    else if 'sort' = attrName then
      ColSort := attrNode.nodeValue
    else
      raise EUnknownTableAttribute.CreateFmt('unknown column attribute "%s"', [attrName]);
  end;
  Column := _Table.AppendColumn(ColName, StringToDataType(ColType), StrToInt(ColSize), ColComment, YesNoToNullAllowed(ColNull));
  if ColDefaultSet then
    Column.DefaultValue := ColDefault;

  if ColAutoInc = 'yes' then
    Column.AutoInc := True;

  if ColIndex <> '' then begin
    Index := _Table.AppendIndex(StringToIndexType(ColIndex));
    Index.AppendColumn(ColName, StringToSortOrder(ColSort));
  end;

  if (ColReftable <> '') and (ColRefcolumn <> '') then begin
    RefTable := _DbDescription.TableByName(ColReftable);
    if Assigned(RefTable) then begin
      RefColumn := RefTable.ColumnByName(ColRefcolumn);
      if Assigned(RefColumn) then
        Column.SetForeignKey(RefColumn, RefTable)
      else begin
        RefTabNCol := TRefTableAndColumn.Create;
        RefTabNCol.fRefColumnName := ColRefcolumn;
        Column.Data := RefTabNCol;
      end;
    end else begin
      RefTabNCol := TRefTableAndColumn.Create;
      RefTabNCol.fRefTableName := ColReftable;
      RefTabNCol.fRefColumnName := ColRefcolumn;
      Column.Data := RefTabNCol;
    end;
  end;
end;

class procedure TXmlDbReader.HandleColData(_ColDataNode: IDOMNode;
  const _Table: IdzDbTableDescription; const _Row: IdzDbTableRow;
  const _DbDescription: IdzDbDescription);
var
  Attrib: integer;
  attrName: string;
  attrNode: IDOMNode;
  ColName: string;
  Value: string;
  NameSet: boolean;
  ValueSet: boolean;
  ColIdx: integer;
begin
  if not assigned(_ColDataNode.attributes) then
    raise EColDataNeedsName.Create('coldata needs "name" and "value" attribute');
  NameSet := false;
  ValueSet := false;
  for Attrib := 0 to _ColDataNode.attributes.length - 1 do begin
    attrNode := _ColDataNode.attributes.item[Attrib];
    attrName := attrNode.nodeName;
    if 'name' = attrName then begin
      NameSet := true;
      ColName := attrNode.nodeValue;
    end else if 'value' = attrName then begin
      ValueSet := true;
      Value := attrNode.nodeValue;
      Value := XmlToChar(Value);
    end else
      raise EUnknownColDataAttribute.CreateFmt('unknown row atribute "%s"', [attrName]);
  end;
  if not NameSet then
    raise EColDataNeedsName.Create('coldata needs "name" attribute');
  if not ValueSet then
    raise EColDataNeedsValue.Create('coldata needs "value" attribute');
  ColIdx := _Table.ColumnIndex(ColName);
  if ColIdx = -1 then
    raise EUnknownColumnName.CreateFmt('unknown column name "%s"', [ColName]);
  _Row[ColIdx] := Value;
  if _Table.Columns[ColIdx].AutoInc then
    _Table.Columns[ColIdx].AdjustStartIdx(Str2Int(Value, 1));
end;

class procedure TXmlDbReader.HandleRow(_RowNode: IDOMNode;
  const _Table: IdzDbTableDescription; const _DbDescription: IdzDbDescription);
var
  Child: integer;
  nodeName: string;
  childNode: IDOMNode;
  Row: IdzDbTableRow;
begin
  if assigned(_RowNode.ChildNodes) then begin
    Row := _Table.AppendRow;
    for Child := 0 to _RowNode.childNodes.length - 1 do begin
      childNode := _RowNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;
      nodeName := ChildNode.nodeName;
      if nodeName = 'coldata' then begin
        HandleColData(childNode, _Table, Row, _DbDescription);
      end else
        raise EXmlWrongNodeType.CreateFmt('invalid node name "%s"', [nodeName]);
    end;
  end;
end;

class procedure TXmlDbReader.HandleData(_DataNode: IDOMNode;
  const _Table: IdzDbTableDescription; const _DbDescription: IdzDbDescription);
var
  Child: integer;
  nodeName: string;
  childNode: IDOMNode;
begin
  if assigned(_DataNode.ChildNodes) then
    for Child := 0 to _DataNode.childNodes.length - 1 do begin
      childNode := _DataNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;
      nodeName := ChildNode.nodeName;
      if nodeName = 'row' then
        HandleRow(childNode, _Table, _DbDescription)
      else
        raise EXmlWrongNodeType.CreateFmt('invalid node name "%s"', [nodeName]);
    end;
end;

class procedure TXmlDbReader.HandleTable(_TableNode: IDOMNode; const _DbDescription: IdzDbDescription; _IncludeData: boolean);
var
  Attrib: integer;
  Child: integer;
  nodeName, attrName: string;
  attrNode: IDOMNode;
  childNode: IDOMNode;
  Table: IdzDbTableDescription;
  DataStarted: boolean;
begin
  if not assigned(_TableNode.attributes) then
    raise ETableNeedsName.Create('table needs "name" attribute');
  for Attrib := 0 to _TableNode.attributes.length - 1 do begin
    attrNode := _TableNode.attributes.item[Attrib];
    attrName := attrNode.nodeName;
    if 'name' = attrName then
      Table := _DbDescription.AppendTable(attrNode.nodeValue)
    else
      raise EUnknownTableAttribute.CreateFmt('unknown table atribute "%s"', [attrName]);
  end;
  DataStarted := false;
  if assigned(_TableNode.ChildNodes) then
    for Child := 0 to _TableNode.childNodes.length - 1 do begin
      childNode := _TableNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;
      nodeName := ChildNode.nodeName;
      if nodeName = 'column' then begin
        if DataStarted then
          raise EXmlWrongNodeType.Create('column definitin after table data');
        HandleColumn(childNode, Table, _DbDescription);
      end else if nodeName = 'index' then begin
        if DataStarted then
          raise EXmlWrongNodeType.Create('column definitin after table data');
        HandleIndex(childNode, Table, _DbDescription);
      end else if nodeName = 'data' then begin
        if DataStarted then
          raise EXmlWrongNodeType.Create('duplicate table data');
        DataStarted := true;
        if _IncludeData then
          HandleData(childNode, Table, _DbDescription);
      end else
        raise EXmlWrongNodeType.CreateFmt('invalid node name "%s"', [nodeName]);
    end;
end;

class procedure TXmlDbReader.HandleHeader(_HeaderNode: IDOMNode; const _DbDescription: IdzDbDescription);
var
  attrNode: IDOMNode;
  Child: integer;
  childNode: IDOMNode;
  nodeName: string;
  ProgId: string;
  ProgName: string;
begin
  if (_HeaderNode.attributes.length <> 0) then
    raise EHeaderNoAttributes.Create('header node must not have any attributes');

  if assigned(_HeaderNode.ChildNodes) then begin
    for Child := 0 to _HeaderNode.childNodes.length - 1 do begin
      childNode := _HeaderNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;
      nodeName := ChildNode.nodeName;
      if nodeName = 'program' then begin
        if childNode.attributes.length <> 2 then
          raise EProgNeedsIdName.Create('program must have identifier and name attribute');
        attrNode := childNode.attributes.item[0];
        if attrNode.nodeName <> 'identifier' then
          raise EProgNeedsIdName.Create('program must have identifier and name attribute');
        ProgId := attrNode.nodeValue;
        attrNode := childNode.attributes.item[1];
        if attrNode.nodeName <> 'name' then
          raise EProgNeedsIdName.Create('program must have identifier and name attribute');
        ProgName := attrNode.nodeValue;
        _DbDescription.SetProgramm(ProgId, ProgName);
      end;
    end;
  end;
end;

class procedure TXmlDbReader.HandleDatabase(_DbNode: IDOMNode; const _DbDescription: IdzDbDescription; _IncludeData: boolean);
var
  attrNode: IDOMNode;
  Child: integer;
  childNode: IDOMNode;
  nodeName: string;
begin
  if (_DbNode.attributes.length <> 1) then
    raise EDbNeedsName.Create('database must have a "name" attribute');
  attrNode := _DbNode.attributes.item[0];
  if attrNode.nodeName <> 'name' then
    raise EDbNeedsName.Create('database must have a "name" attribute');
  _DbDescription.Name := attrNode.nodeValue;

  if assigned(_DbNode.ChildNodes) then
    for Child := 0 to _DbNode.childNodes.length - 1 do begin
      childNode := _DbNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;
      nodeName := ChildNode.nodeName;
      if nodeName <> 'table' then
        raise EXmlWrongNodeType.CreateFmt('invalid node name "%s"', [nodeName]);
      HandleTable(childNode, _DbDescription, _IncludeData);
    end;
end;

class procedure TXmlDbReader.ResolveTableLinks(const _DbDescription: IdzDbDescription);
var
  tbl, col: integer;
  TableDesc: IdzDbTableDescription;
  ColumnDesc: IdzDbColumnDescription;
  RefTable: IdzDbTableDescription;
  RefColumn: IdzDbColumnDescription;
  TableName: string;
  ColumnName: string;
  RefTabNCol: TRefTableAndColumn;
begin
  for tbl := 0 to _DbDescription.TableCount - 1 do begin
    TableDesc := _DbDescription.Tables[tbl];
    for col := 0 to TableDesc.ColumnCount - 1 do begin
      ColumnDesc := TableDesc.Columns[col];
      if Assigned(ColumnDesc.Data) then begin
        RefTabNCol := TRefTableAndColumn(ColumnDesc.Data);
        ColumnDesc.Data := nil;
        TableName := RefTabNCol.fRefTableName;
        ColumnName := RefTabNCol.fRefColumnName;
        RefTabNCol.Free;

        RefTable := _DbDescription.TableByName(TableName);
        if not Assigned(RefTable) then
          raise EUnknownTable.CreateFmt('could not find table %s referenced by column %s', [TableName, ColumnDesc.Name]);

        RefColumn := RefTable.ColumnByName(ColumnName);
        if not Assigned(RefColumn) then
          raise EUnknownTable.CreateFmt('could not find column %s referenced by column %s', [Columnname, ColumnDesc.Name]);

        Columndesc.SetForeignKey(RefColumn, RefTable);
      end;
    end;
  end;
end;

class procedure TXmlDbReader.ParseXml(_DomNode: IDOMNode; const _DbDescription: IdzDbDescription; _IncludeData: boolean);
var
  Child: integer;
  childNode: IDOMNode;
  Name: string;
  i: integer;
begin
  if _DomNode.nodeType = Word(ntDocument) then begin
    if not Assigned(_DomNode.ChildNodes) then
      raise EXmlEmpty.Create('document is empty');
    i := 0;
    while (i < _DomNode.childNodes.length) and (_DomNode.childNodes.item[i].nodeType = Word(ntProcessingInstr)) do
      inc(i);
    if _DomNode.childNodes.length <> i + 1 then
      raise EXmlMultiple.Create('document may only contain a single database');
    _DomNode := _DomNode.ChildNodes.Item[i];
  end;

  if _DomNode.nodeType = Word(ntElement) then begin
    Name := _DomNode.nodeName;
    if Name <> 'dzxmldb' then
      raise EXmlWrongDocType.CreateFmt('invalid document name "%s"', [Name]);
  end else
    raise EXmlWrongNodeType.Create('wrong node type');

  if Assigned(_DomNode.ChildNodes) then begin
    for Child := 0 to _DomNode.childNodes.length - 1 do begin
      childNode := _DomNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;

      Name := ChildNode.nodeName;
      if Name = 'database' then begin
        HandleDatabase(childNode, _DbDescription, _IncludeData);
      end;
    end;
  end;
  if assigned(_DomNode.ChildNodes) then begin
    for Child := 0 to _DomNode.childNodes.length - 1 do begin
      childNode := _DomNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;
      Name := ChildNode.nodeName;
      if Name = 'header' then begin
        HandleHeader(childNode, _DbDescription);
      end else if Name = 'database' then begin
              // already handled
      end else if Name = 'databasetypes' then begin
        HandleDatabaseTypes(childNode, _DbDescription);
      end else if Name = 'config' then
        HandleConfig(childNode, _DbDescription)
      else
        raise EXmlWrongNodeType.CreateFmt('invalid node name "%s"', [Name]);
    end;
  end;

  ResolveTableLinks(_DbDescription);
end;

class procedure TXmlDbReader.HandleIndex(_IndexNode: IDOMNode;
  _Table: IdzDbTableDescription; const _DbDescription: IdzDbDescription);

  procedure HandleIdxesColumn(_ColumnNode: IDOMNode;
    _Index: IdzDbIndexDescription);
  var
    Attrib: integer;
    attrName: string;
    sortorder: string;
    attrNode: IDOMNode;
    ColumnName: string;
  begin
    if not assigned(_ColumnNode.attributes) then
      raise EColumnNeedsName.Create('column of an index needs "name" attribute');

    for Attrib := 0 to _ColumnNode.attributes.length - 1 do begin
      attrNode := _ColumnNode.attributes.item[Attrib];
      attrName := attrNode.nodeName;
      if 'name' = attrName then
        ColumnName := attrNode.nodeValue
      else if 'sortorder' = attrName then
        sortorder := attrNode.nodeValue
      else
        raise EUnknownTableAttribute.CreateFmt('unknown Index attribute "%s"', [attrName]);
    end;
    _Index.AppendColumn(ColumnName, StringToSortOrder(sortorder))
  end;

var
  Attrib: integer;
  Child: integer;
  attrName: string;
  attrNode: IDOMNode;
  IndexName: string;
  IndexIsPrimaryKey: string;
  IndexIsForeignKey: string;
  IndexIsUnique: string;
  RefTableName: string;
  Index: IdzDbIndexDescription;
  ChildNode: IDOMNode;
  nodeName: string;
begin
  if not assigned(_IndexNode.attributes) then
    raise EIndexNeedsName.Create('index needs "name" attribute');

  for Attrib := 0 to _IndexNode.attributes.length - 1 do begin
    attrNode := _IndexNode.attributes.item[Attrib];
    attrName := attrNode.nodeName;
    if 'name' = attrName then
      IndexName := attrNode.nodeValue
    else if 'unique' = attrName then
      IndexIsUnique := attrNode.nodeValue
    else if 'primarykey' = attrName then
      IndexIsPrimaryKey := attrNode.nodeValue
    else if 'foreignkey' = attrName then
      IndexIsForeignKey := attrNode.nodeValue
    else if 'referencetable' = attrName then
      RefTableName := attrNode.nodeValue
    else
      raise EUnknownTableAttribute.CreateFmt('unknown Index attribute "%s"', [attrName]);
  end;

  Index := _Table.AppendIndex(IndexName, StringToBool(IndexIsPrimaryKey), StringToBool(IndexIsUnique), StringToBool(IndexIsForeignKey));
  Index.RefTable := RefTableName;

  if assigned(_IndexNode.ChildNodes) then
    for Child := 0 to _IndexNode.childNodes.length - 1 do begin
      childNode := _IndexNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;
      nodeName := ChildNode.nodeName;
      if nodeName = 'column' then
        HandleIdxesColumn(childNode, Index)
      else
        raise EXmlWrongNodeType.CreateFmt('invalid node name "%s"', [nodeName]);
    end;
end;

class procedure TXmlDbReader.HandleDatabaseTypes(_DbTypesNode: IDOMNode;
  const _DbDescription: IdzDbDescription);
var
  Child: integer;
  ChildNode: IDOMNode;
  nodeName: string;
begin
  if assigned(_DbTypesNode.ChildNodes) then
    for Child := 0 to _DbTypesNode.childNodes.length - 1 do begin
      childNode := _DbTypesNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;
      nodeName := ChildNode.nodeName;
      if nodeName = 'databasetype' then
        HandleDatabaseType(childNode, _DbDescription)
      else
        raise EXmlWrongNodeType.CreateFmt('invalid node name "%s"', [nodeName]);
    end;
end;

class procedure TXmlDbReader.HandleDatabaseType(_DbTypeNode: IDOMNode;
  const _DbDescription: IdzDbDescription);
var
  Attrib: integer;
  Child: integer;
  attrName: string;
  DbTypeName: string;
  Deutsch: string;
  English: string;
  attrNode: IDOMNode;
  ChildNode: IDOMNode;
  nodeName: string;
  dbtype: IdzDbTypeDescription;
begin
  if not assigned(_DbTypeNode.attributes) then
    raise EIndexNeedsName.Create('database type needs "name" attribute');

  for Attrib := 0 to _DbTypeNode.attributes.length - 1 do begin
    attrNode := _DbTypeNode.attributes.item[Attrib];
    attrName := attrNode.nodeName;
    if 'name' = attrName then
      DbTypeName := attrNode.nodeValue
    else if 'deutsch' = attrName then
      Deutsch := attrNode.nodeValue
    else if 'english' = attrName then
      English := attrNode.nodeValue
    else
      raise EUnknownTableAttribute.CreateFmt('unknown database type attribute "%s"', [attrName]);
  end;

  dbtype := _DbDescription.AppendDbType(DbTypeName, English, Deutsch);

  if assigned(_DbTypeNode.ChildNodes) then begin
    for Child := 0 to _DbTypeNode.childNodes.length - 1 do begin
      childNode := _DbTypeNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;
      nodeName := ChildNode.nodeName;
      if nodeName = 'variables' then
        HandleVariables(childNode, dbtype)
      else if nodeName = 'defaults' then
        HandleDefaultTypes(childNode, dbtype)
      else if nodeName = 'scripts' then
        HandleScripts(childNode, dbtype)
      else if nodeName = 'versions' then begin
              // handle later
      end else
        raise EXmlWrongNodeType.CreateFmt('invalid node name "%s"', [nodeName]);
    end;

    CheckForScriptPlaceholders(dbtype, _DbDescription);

    for Child := 0 to _DbTypeNode.childNodes.length - 1 do begin
      childNode := _DbTypeNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;
      if ChildNode.nodeName = 'versions' then
        HandleVersions(childNode, dbtype);
    end;
  end;
end;

class procedure TXmlDbReader.HandleConfig(_ConfigNode: IDOMNode;
  const _DbDescription: IdzDbDescription);
begin
  //TODO -ouwe: not implemented
end;

class procedure TXmlDbReader.HandleDefaultTypes(_DefaultTypesNode: IDOMNode;
  const _DbVersNType: IdzDbVersionNTypeAncestor);
var
  Child: integer;
  ChildNode: IDOMNode;
  nodeName: string;
begin
  if assigned(_DefaultTypesNode.ChildNodes) then
    for Child := 0 to _DefaultTypesNode.childNodes.length - 1 do begin
      childNode := _DefaultTypesNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;
      nodeName := ChildNode.nodeName;
      if nodeName = 'default' then
        HandleDefaultType(childNode, _DbVersNType)
      else
        raise EXmlWrongNodeType.CreateFmt('invalid node name "%s"', [nodeName]);
    end;
end;

class procedure TXmlDbReader.HandleDefaultType(_DefaultTypeNode: IDOMNode;
  const _DbVersNType: IdzDbVersionNTypeAncestor);
var
  Attrib: integer;
  Child: integer;
  attrName: string;
  DefaultTypeName: string;
  attrNode: IDOMNode;
  ChildNode: IDOMNode;
  nodeName: string;
  defaulttype: IdzDbDefaultTypeDescription;
begin
  if not assigned(_DefaultTypeNode.attributes) then
    raise EIndexNeedsName.Create('default type needs "name" attribute');

  for Attrib := 0 to _DefaultTypeNode.attributes.length - 1 do begin
    attrNode := _DefaultTypeNode.attributes.item[Attrib];
    attrName := attrNode.nodeName;
    if 'name' = attrName then
      DefaultTypeName := attrNode.nodeValue
    else
      raise EUnknownTableAttribute.CreateFmt('unknown default type attribute "%s"', [attrName]);
  end;

  defaulttype := _DbVersNType.AppendDefault(DefaultTypeName);

  if assigned(_DefaultTypeNode.ChildNodes) then
    for Child := 0 to _DefaultTypeNode.childNodes.length - 1 do begin
      childNode := _DefaultTypeNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;
      nodeName := ChildNode.nodeName;
      if nodeName = 'defaultvalue' then
        HandleDefaultValue(childNode, defaulttype)
      else
        raise EXmlWrongNodeType.CreateFmt('invalid node name "%s"', [nodeName]);
    end;
end;

class procedure TXmlDbReader.HandleVariables(_VariablesNode: IDOMNode;
  const _DbVersNType: IdzDbVersionNTypeAncestor);
var
  Child: integer;
  ChildNode: IDOMNode;
  nodeName: string;
begin
  if assigned(_VariablesNode.ChildNodes) then
    for Child := 0 to _VariablesNode.childNodes.length - 1 do begin
      childNode := _VariablesNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;
      nodeName := ChildNode.nodeName;
      if nodeName = 'variable' then
        HandleVariable(childNode, _DbVersNType)
      else
        raise EXmlWrongNodeType.CreateFmt('invalid node name "%s"', [nodeName]);
    end;
end;

class procedure TXmlDbReader.HandleScripts(_ScriptsNode: IDOMNode;
  const _DbVersNType: IdzDbVersionNTypeAncestor);
var
  Child: integer;
  ChildNode: IDOMNode;
  nodeName: string;
begin
  if assigned(_ScriptsNode.ChildNodes) then
    for Child := 0 to _ScriptsNode.childNodes.length - 1 do begin
      childNode := _ScriptsNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;
      nodeName := ChildNode.nodeName;
      if nodeName = 'script' then
        HandleScript(childNode, _DbVersNType)
      else
        raise EXmlWrongNodeType.CreateFmt('invalid node name "%s"', [nodeName]);
    end;
end;

class procedure TXmlDbReader.HandleDefaultValue(_DefaultValueNode: IDOMNode;
  _DefaultType: IdzDbDefaultTypeDescription);
var
  Attrib: integer;
  attrName: string;
  attrNode: IDOMNode;
  VariableName: string;
  VariableValue: string;
begin
  if not assigned(_DefaultValueNode.attributes) then
    raise EColumnNeedsName.Create('Default value needs "name" attribute');

  for Attrib := 0 to _DefaultValueNode.attributes.length - 1 do begin
    attrNode := _DefaultValueNode.attributes.item[Attrib];
    attrName := attrNode.nodeName;
    if 'name' = attrName then
      VariableName := attrNode.nodeValue
    else if 'value' = attrName then
      VariableValue := attrNode.nodeValue
    else
      raise EUnknownTableAttribute.CreateFmt('unknown default value attribute "%s"', [attrName]);
  end;
  _DefaultType.AppendVariableDefault(VariableName, VariableValue)
end;

class procedure TXmlDbReader.HandleVariable(_VariableNode: IDOMNode;
  _DbType: IdzDbVersionNTypeAncestor);
var
  Attrib: integer;
  attrName: string;
  attrNode: IDOMNode;
  VariableName: string;
  DefaultValue: string;
  English: string;
  Deutsch: string;
  Tag: string;
  Advanced: boolean;
  ValType: string;
  Editable: boolean;
begin
  if not assigned(_VariableNode.attributes) then
    raise EColumnNeedsName.Create('Default value needs "name" attribute');

  Advanced := false;
  Editable := false;

  for Attrib := 0 to _VariableNode.attributes.length - 1 do begin
    attrNode := _VariableNode.attributes.item[Attrib];
    attrName := attrNode.nodeName;

    if 'name' = attrName then
      VariableName := attrNode.nodeValue
    else if 'deutsch' = attrName then
      Deutsch := attrNode.nodeValue
    else if 'english' = attrName then
      English := attrNode.nodeValue
    else if 'tag' = attrName then
      Tag := attrNode.nodeValue
    else if 'default' = attrName then
      DefaultValue := attrNode.nodeValue
    else if 'editable' = attrName then
      Editable := StringToBool(attrNode.nodeValue)
    else if 'advanced' = attrName then
      Advanced := StringToBool(attrNode.nodeValue)
    else if 'type' = attrName then
      ValType := attrNode.nodeValue
    else
      raise EUnknownTableAttribute.CreateFmt('unknown default value attribute "%s"', [attrName]);
  end;

  _DbType.AppendVariable(VariableName, DefaultValue, Deutsch, English, Tag, ValType, Editable, Advanced);
end;

class procedure TXmlDbReader.HandleScript(_ScriptNode: IDOMNode;
  _DbType: IdzDbVersionNTypeAncestor);

  procedure SplitScript(const _ScriptDesc: IdzDbScriptDescription; const _ScriptText: string);
  var
    re: TRegExpr;
    b: boolean;
  begin
    re := TRegExpr.Create;
    try
      //  We dont care for the terminator any more.
      //re.Expression := '(\s)*((.*?)(;|((\s)+[Gg][Oo])))(\s)+';
      re.Expression := '(\s)*(.*?)(;|((\s)+[Gg][Oo]))(\s)+';
      b := re.Exec(_ScriptText);
      while b do begin
        _ScriptDesc.AppendStatement(Trim(re.Match[2]));
        b := re.ExecNext;
      end;
    finally
      re.Free;
    end;
  end;

var
  Attrib: integer;
  attrName: string;
  attrNode: IDOMNode;
  Child: integer;
  ChildNode: IDOMNode;
  Name: string;
  ScriptText: string;
  English: string;
  Deutsch: string;
  Active: boolean;
  Mandatory: boolean;
  script: IdzDbScriptDescription;
begin
  if not assigned(_ScriptNode.attributes) then
    raise EColumnNeedsName.Create('Script needs "name" attribute');

  Active := false;
  Mandatory := false;

  for Attrib := 0 to _ScriptNode.attributes.length - 1 do begin
    attrNode := _ScriptNode.attributes.item[Attrib];
    attrName := attrNode.nodeName;

    if 'name' = attrName then
      Name := attrNode.nodeValue
    else if 'deutsch' = attrName then
      Deutsch := attrNode.nodeValue
    else if 'english' = attrName then
      English := attrNode.nodeValue
    else if 'default' = attrName then
      Active := StringToBool(attrNode.nodeValue)
    else if 'mandatory' = attrName then
      Mandatory := StringToBool(attrNode.nodeValue)
    else
      raise EUnknownTableAttribute.CreateFmt('unknown default value attribute "%s"', [attrName]);
  end;

  script := _DbType.AppendScript(Name, Deutsch, English, Active, Mandatory);

  for Child := 0 to _ScriptNode.childNodes.length - 1 do begin
    ChildNode := _ScriptNode.childNodes.item[Child];
    if ChildNode.nodeType = Word(ntCData) then begin
      ScriptText := ChildNode.nodeValue;
      break;
    end;
  end;
  SplitScript(script, ScriptText);
end;

class procedure TXmlDbReader.CheckForScriptPlaceholders(_DbType: IdzDbVersionNTypeAncestor;
  const _DbDescription: IdzDbDescription);
var
  script: IdzDbScriptDescription;
begin

  script := _DbType.ScriptByName(SCRIPT_NAME_DROPTABLES);
  if not assigned(script) and _DbDescription.HasTables then
    _DbType.PrependScript(SCRIPT_NAME_DROPTABLES,
      'Platzhalter für automatisch generiertes Script um existierende Datenbank-Tabellen zu löschen',
      'Placeholder for automatic generated script to delete existing database tables', false, false);

  script := _DbType.ScriptByName(SCRIPT_NAME_CREATETABLES);
  if not assigned(script) and _DbDescription.HasTables then
    _DbType.AppendScript(SCRIPT_NAME_CREATETABLES,
      'Platzhalter für automatisch generiertes Script um neue Datenbank-Tabellen anzulegen',
      'Placeholder for automatic generated script to create database tables', true, true);

  script := _DbType.ScriptByName(SCRIPT_NAME_INSERTDATA);
  if not assigned(script) and _DbDescription.HasData then
    _DbType.AppendScript(SCRIPT_NAME_INSERTDATA,
      'Platzhalter für automatisch generiertes Script um Default-Daten einzufügen.',
      'Placeholder for automatic generated script to insert default data.', true, false);
end;

class procedure TXmlDbReader.HandleVersions(_VersionsNode: IDOMNode;
  const _DbVersNType: IdzDbVersionNTypeAncestor);
var
  Child: integer;
  ChildNode: IDOMNode;
  nodeName: string;
begin
  if assigned(_VersionsNode.ChildNodes) then
    for Child := 0 to _VersionsNode.childNodes.length - 1 do begin
      childNode := _VersionsNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;
      nodeName := ChildNode.nodeName;
      if nodeName = 'version' then
        HandleVersion(childNode, _DbVersNType as IdzDbTypeDescription)
      else
        raise EXmlWrongNodeType.CreateFmt('invalid node name "%s"', [nodeName]);
    end;
end;

class procedure TXmlDbReader.HandleVersion(_VersionNode: IDOMNode;
  const _DbType: IdzDbTypeDescription);
var
  Attrib: integer;
  Child: integer;
  attrName: string;
  VersionName: string;
  Deutsch: string;
  English: string;
  attrNode: IDOMNode;
  ChildNode: IDOMNode;
  nodeName: string;
  version: IdzDbVersionDescription;
begin
  if not assigned(_VersionNode.attributes) then
    raise EIndexNeedsName.Create('database type needs "name" attribute');

  for Attrib := 0 to _VersionNode.attributes.length - 1 do begin
    attrNode := _VersionNode.attributes.item[Attrib];
    attrName := attrNode.nodeName;
    if 'name' = attrName then
      VersionName := attrNode.nodeValue
    else if 'deutsch' = attrName then
      Deutsch := attrNode.nodeValue
    else if 'english' = attrName then
      English := attrNode.nodeValue
    else
      raise EUnknownTableAttribute.CreateFmt('unknown database type attribute "%s"', [attrName]);
  end;

  Version := _DbType.AppendVersion(VersionName, English, Deutsch);

  if assigned(_VersionNode.ChildNodes) then
    for Child := 0 to _VersionNode.childNodes.length - 1 do begin
      childNode := _VersionNode.childNodes.Item[Child];
      if childNode.nodeType <> Word(ntElement) then
        continue;
      nodeName := ChildNode.nodeName;
      if nodeName = 'variables' then
        HandleVariables(childNode, Version)
      else if nodeName = 'defaults' then
        HandleDefaultTypes(childNode, Version)
      else if nodeName = 'scripts' then
        HandleScripts(childNode, Version)
      else
        raise EXmlWrongNodeType.CreateFmt('invalid node name "%s"', [nodeName]);
    end;
end;

end.

