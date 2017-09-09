unit u_dzDbCreatorReadAccessDb;

{: reads the table structure of an access database }

interface

uses
  SysUtils,
  Variants,
  ADODB_TLB,
  ADOX_TLB,
  ADODB,
  Contnrs,
  u_dzTranslator,
  u_dzDbCreatorDescription,
  u_dzDbCreatorCreateAccess,
  u_dzLogging;

type
  TAccessDbReader = class
  private
    class procedure AddNonForeignKey(const _TableDesc: IdzDbTableDescription; const _Key: TAdoxKey;
      _MakeAutoInc: Boolean; _Logger: ILogger);
    class procedure AddIndex(const _TableDesc: IdzDbTableDescription; const _Index: TAdoxIndex);
    class procedure AddForeignKey(const _TableDesc: IdzDbTableDescription;
      const _Key: TAdoxKey; const _DbDescription: IdzDbDescription);
    class procedure AddColumn(const _TableDesc: IdzDbTableDescription; const _Column: TAdoxColumn;
      _Logger: ILogger);
    class function DataTypeToFieldDataType(_DataType: DataTypeEnum): TFieldDataType;
    class function DataTypeToName(_ColumnType: DataTypeEnum): string;
    class procedure ReadData(const _SrcFile, _DbPassword: string; const _DbDescription: IdzDbDescription;
      _Logger: ILogger);
    class function BuildConnectionString(const _SrcFile, _DbPassword: string): string;
    class procedure ConsolidateIndices(const _TableDesc: IdzDbTableDescription; _Logger: ILogger);
  public
    class procedure ReadAccess(const _SrcFile, _DbPassword: string;
      const _DbDescription: IdzDbDescription; _IncludeData: Boolean;
      _MakeAutoInc, _ConsolidateIndices: Boolean; _Logger: ILogger = nil);
  end;

implementation

uses
  Classes,
  u_dzMiscUtils,
  u_dzConvertUtils,
  u_dzStringUtils;

function _(const _s: string): string; inline;
begin
  Result := dzlibGetText(_s);
end;

function SortOrderEnumToTSortOrder(_SOE: SortOrderEnum): TSortOrder;
begin
  case _SOE of
    adSortAscending: Result := soAscending;
    adSortDescending: Result := soDescending;
  else
    raise EConvertError.CreateFmt(_('Invalid SortOrderEnum value %d'), [Ord(_SOE)]);
  end;
end;

class function TAccessDbReader.DataTypeToName(_ColumnType: DataTypeEnum): string;
begin
  case _ColumnType of
    adEmpty: Result := 'adEmpty';
    adTinyInt: Result := 'adTinyInt';
    adSmallInt: Result := 'adSmallInt';
    adInteger: Result := 'adInteger';
    adBigInt: Result := 'adBigInt';
    adUnsignedTinyInt: Result := 'adUnsignedTinyInt';
    adUnsignedSmallInt: Result := 'adUnsignedSmallInt';
    adUnsignedInt: Result := 'adUnsignedInt';
    adUnsignedBigInt: Result := 'adUnsignedBigInt';
    adSingle: Result := 'adSingle';
    adDouble: Result := 'adDouble';
    adCurrency: Result := 'adCurrency';
    adDecimal: Result := 'adDecimal';
    adNumeric: Result := 'adNumeric';
    adBoolean: Result := 'adBoolean';
    adError: Result := 'adError';
    adUserDefined: Result := 'adUserDefined';
    adVariant: Result := 'adVariant';
    adIDispatch: Result := 'adIDispatch';
    adIUnknown: Result := 'adIUnknown';
    adGUID: Result := 'adGUID';
    adDate: Result := 'adDate';
    adDBDate: Result := 'adDBDate';
    adDBTime: Result := 'adDBTime';
    adDBTimeStamp: Result := 'adDBTimeStamp';
    adBSTR: Result := 'adBSTR';
    adChar: Result := 'adChar';
    adVarChar: Result := 'adVarChar';
    adLongVarChar: Result := 'adLongVarChar';
    adWChar: Result := 'adWChar';
    adVarWChar: Result := 'adVarWChar';
    adLongVarWChar: Result := 'adLongVarWChar';
    adBinary: Result := 'adBinary';
    adVarBinary: Result := 'adVarBinary';
    adLongVarBinary: Result := 'adLongVarBinary';
    adChapter: Result := 'adChapter';
    adFileTime: Result := 'adFileTime';
    adPropVariant: Result := 'adPropVariant';
    adVarNumeric: Result := 'adVarNumeric';
  else
    Result := 'unknown';
  end;
end;

class function TAccessDbReader.DataTypeToFieldDataType(_DataType: DataTypeEnum): TFieldDataType;
begin
  case _DataType of
    adSmallInt, adUnsignedTinyInt, adInteger, adBoolean: Result := dtLongInt;
    adSingle, adDouble: Result := dtDouble;
    adDate: Result := dtDate;
    adChar, adVarChar, adWChar, adVarWChar: Result := dtText;
    adLongVarChar, adLongVarWChar: Result := dtMemo;
    adGUID: Result := dtGUID;
  else
    raise Exception.CreateFmt(_('Unsupported data type %s'), [DataTypeToName(_DataType)]);
  end;
end;

class procedure TAccessDbReader.AddForeignKey(const _TableDesc: IdzDbTableDescription;
  const _Key: TAdoxKey; const _DbDescription: IdzDbDescription);
var
  ci: Integer;
  RefTabName: string; // set to the first ref table
  RTabName, RColName: string;
  Column: TAdoxColumn;
  ColumnDesc: IdzDbColumnDescription;
  RefTableDesc: IdzDbTableDescription;
  RefColumnDesc: IdzDbColumnDescription;
  IndexDesc: IdzDbIndexDescription;
begin
  case _Key.Type_ of
    adKeyForeign:
      try
        IndexDesc := _TableDesc.AppendIndex(_Key.Name, False, False, True);
        for ci := 0 to _Key.Columns.Count - 1 do begin
          Column := _Key.Columns[ci];
          ColumnDesc := _TableDesc.ColumnByName(Column.Name);
          Assert(Assigned(ColumnDesc), 'column unknown');

          RTabName := _Key.RelatedTable;
          Assert(RTabName <> '', 'related table can not be an empty string');
          RefTableDesc := _DbDescription.TableByName(RTabName);
          if RefTabName = '' then begin
            RefTabName := RTabName;
            IndexDesc.RefTable := RefTableDesc.Name;
          end else
            Assert((RefTabName = RTabName), 'related tables do not match');

          RColName := Column.Get_RelatedColumn;
          Assert(RColName <> '', 'related column can not be an empty string');

          RefColumnDesc := RefTableDesc.ColumnByName(RColName);

          Assert(Assigned(RefColumnDesc), 'referenced column unknown');

          ColumnDesc.SetForeignKey(RefColumnDesc, RefTableDesc);

          IndexDesc.AppendColumn(Column.Name);
        end;
      except
        on EdzDbIndexAlreadyExisting do
          ;
      end;
  end;
end;

class procedure TAccessDbReader.AddColumn(const _TableDesc: IdzDbTableDescription;
  const _Column: TAdoxColumn; _Logger: ILogger);
var
  Name: string;
  DataType: DataTypeEnum;
  Size: Integer;
  ColumnDesc: IdzDbColumnDescription;
  AllowNull: TNullAllowed;
  Comment: string;
  v: Variant;
begin
  Name := _Column.Name;
  DataType := _Column.Type_;
  Size := _Column.DefinedSize;

  // the idea here is to be on the safe side: Unfortunately neither Properties[Nullable[
  // nor Attributes and adColNullable seem to be reliable to determine whether
  // a column may contain NULL, so we set NotNull only if both say it may
  // not contain NULL.
  // I am still not sure whether this will always work, but there is no
  // other way (at least I could not find anything on Google).
  v := _Column.Properties['Nullable'].Value;
  if v then begin
    AllowNull := naNull;
    if (_Column.Attributes and adColNullable) = 0 then
      _Logger.Warning(Format(
        _('Column %s may not be Nullable, but ADOX does not return a reliable result, assuming Nullable.'),
        [Name]));
  end else if (_Column.Attributes and adColNullable) <> 0 then begin
    AllowNull := naNull;
    _Logger.Warning(Format(
      _('Column %s may not be Nullable, but ADOX does not return a reliable result, assuming Nullable.'),
      [Name]));
  end else
    AllowNull := naNotNull;

  Comment := _Column.Properties['Description'].Value;
  ColumnDesc := _TableDesc.AppendColumn(Name, DataTypeToFieldDataType(DataType), Size, Comment, AllowNull);
  ColumnDesc.AutoInc := _Column.Properties['AutoIncrement'].Value;
  ColumnDesc.DefaultValue := _Column.Properties['Default'].Value;
end;

class procedure TAccessDbReader.AddIndex(const _TableDesc: IdzDbTableDescription; const _Index: TAdoxIndex);
var
  IndexDesc: IdzDbIndexDescription;
  Column: IdzDbColumnDescription;
  i: Integer;
begin
  IndexDesc := _TableDesc.IndexByName(_Index.Name);
  if Assigned(IndexDesc) then
    for i := 0 to _Index.Columns.Count - 1 do
      IndexDesc.AlterColumnSortOrder(_Index.Columns[i].Name,
        SortOrderEnumToTSortOrder(_Index.Columns[i].SortOrder))
  else
    try
      IndexDesc := _TableDesc.AppendIndex(_Index.Name, _Index.PrimaryKey, _Index.Unique, False);

      for i := 0 to _Index.Columns.Count - 1 do begin
        IndexDesc.AppendColumn(_Index.Columns[i].Name,
          SortOrderEnumToTSortOrder(_Index.Columns[i].SortOrder));
        Column := _TableDesc.ColumnByName(_Index.Columns[i].Name);
        if _Index.Unique then
          Column.SetIndexType(itUnique)
        else
          Column.SetIndexType(itNotUnique);
      end;
    except
      on EdzDbIndexAlreadyExisting do
        ;
    end;
end;

class procedure TAccessDbReader.AddNonForeignKey(const _TableDesc: IdzDbTableDescription;
  const _Key: TAdoxKey; _MakeAutoInc: Boolean; _Logger: ILogger);
var
  ColumnDesc: IdzDbColumnDescription;
  IndexDesc: IdzDbIndexDescription;
  ci: Integer;
begin
  case _Key.Type_ of
    adKeyPrimary:
      try
        IndexDesc := _TableDesc.AppendIndex(_Key.Name, True, True, False);
        for ci := 0 to _Key.Columns.Count - 1 do begin
          IndexDesc.AppendColumn(_Key.Columns[ci].Name);
          ColumnDesc := _TableDesc.ColumnByName(_Key.Columns[ci].Name);
          ColumnDesc.SetIndexType(itPrimaryKey);
          if _MakeAutoInc and (ColumnDesc.DataType = dtLongInt) and not ColumnDesc.AutoInc then begin
            _Logger.Info(Format(_('Making field %s autoinc'), [ColumnDesc.Name]));
            ColumnDesc.AutoInc := True;
          end;
        end;
      except
        on EdzDbIndexAlreadyExisting do
          ;
      end;
    adKeyUnique:
      try
        IndexDesc := _TableDesc.AppendIndex(_Key.Name, False, True, False);
        for ci := 0 to _Key.Columns.Count - 1 do begin
          IndexDesc.AppendColumn(_Key.Columns[ci].Name);
          ColumnDesc := _TableDesc.ColumnByName(_Key.Columns[ci].Name);
          ColumnDesc.SetIndexType(itUnique);
        end;
      except
        on EdzDbIndexAlreadyExisting do
          ;
      end else
    Exit;
  end;
end;

const
  DATA_SOURCE_4_SDS = 'Provider=Microsoft.Jet.OLEDB.4.0;'
    + 'Data Source=%s;'
    + 'Jet OLEDB:Engine Type=%d;'
    + 'Jet OLEDB:Database Password="%s";';
  DATA_SOURCE_12_SDS = 'Provider=Microsoft.ACE.OLEDB.12.0;'
    + 'Data Source=%s;'
    + 'Jet OLEDB:Engine Type=%d;'
    + 'Jet OLEDB:Database Password="%s";';

class function TAccessDbReader.BuildConnectionString(const _SrcFile, _DbPassword: string): string;
var
  Ext: string;
begin
  Ext := ExtractFileExt(_SrcFile);
  if SameText(Ext, '.accdb') then
    Result := Format(DATA_SOURCE_12_SDS, [_SrcFile, 4, _DbPassword])
  else
    Result := Format(DATA_SOURCE_4_SDS, [_SrcFile, 4, _DbPassword]);
end;

class procedure TAccessDbReader.ReadData(const _SrcFile, _DbPassword: string;
  const _DbDescription: IdzDbDescription; _Logger: ILogger);
var
  DataTable: TAdoTable;
  DataSource: string;
  TableDesc: IdzDbTableDescription;
  ColDesc: IdzDbColumnDescription;
  TblIdx, ColIdx: Integer;
  Row: IdzDbTableRow;
  s: string;
  DataCount: Integer;
begin
  _Logger.Info(_('Third pass - reading data'));
  DataSource := BuildConnectionString(_SrcFile, _DbPassword);
  DataTable := TAdoTable.Create(nil);
  try
    DataTable.ConnectionString := DataSource;

    for TblIdx := 0 to _DbDescription.TableCount - 1 do begin
      TableDesc := _DbDescription.Tables[TblIdx];
      _Logger.Debug(Format(_('Reading table %s'), [TableDesc.Name]));
      DataTable.TableName := TableDesc.Name;
      DataTable.Open;
      try
        DataCount := 0;
        while (not DataTable.Eof) do begin
          Row := TableDesc.AppendRow;
          for ColIdx := 0 to TableDesc.ColumnCount - 1 do begin
            ColDesc := TableDesc.Columns[ColIdx];
            if ColDesc.FormatData(DataTable[ColDesc.Name], s) then begin
              Row[ColIdx] := s;
              if ColDesc.AutoInc then
                ColDesc.AdjustStartIdx(Str2Int(s, 1));
            end;
          end;
          Inc(DataCount);
          DataTable.Next;
        end;
        _Logger.Debug(Format(_('%d rows read from table %s'), [DataCount, TableDesc.Name]));
      finally
        DataTable.Close;
      end;
    end;
  finally
    DataTable.Free;
  end;
end;

class procedure TAccessDbReader.ConsolidateIndices(const _TableDesc: IdzDbTableDescription;
  _Logger: ILogger);

// compares two indices, returns true, if column names and column sort orders are identical
// Note: Ignores index name and index flags

  function IndicesEqual(const _Idx1, _Idx2: IdzDbIndexDescription): Boolean;
  var
    c: Integer;
  begin
    Result := False;
    if _Idx1.ColumnCount <> _Idx2.ColumnCount then
      Exit;
    for c := 0 to _Idx1.ColumnCount - 1 do begin
      if _Idx1.Column[c].Name <> _Idx2.Column[c].Name then
        Exit;
      if _Idx1.ColumnSortorder[c] <> _Idx2.ColumnSortorder[c] then
        Exit;
    end;
    Result := True;
  end;

  procedure HandleIndex(const _Idx: IdzDbIndexDescription);
  var
    j: Integer;
    CompIdx: IdzDbIndexDescription;
  begin
    for j := _TableDesc.IndiceCount - 1 downto 0 do begin
      CompIdx := _TableDesc.Indices[j];
      if _Idx.Name = CompIdx.Name then
        Continue;

      if IndicesEqual(_Idx, CompIdx) then begin
        if (CompIdx.GetIndexType = itNotUnique)
          or (CompIdx.GetIndexType = _Idx.GetIndexType)
          or ((CompIdx.GetIndexType = itUnique) and (_Idx.GetIndexType = itPrimaryKey)) then begin
          _Logger.Info(Format(_('Removing duplicate index %s'), [CompIdx.Name]));
          _TableDesc.DeleteIndex(j);
        end;
      end;
    end;
  end;

var
  i: Integer;
  CurIdx: IdzDbIndexDescription;
  il: TInterfaceList;
  IndexType: TIndexType;
begin
  i := _TableDesc.IndiceCount - 1;
  while i >= 0 do begin
    CurIdx := _TableDesc.Indices[i];
    if CurIdx.GetIndexType <> itNotUnique then
      HandleIndex(CurIdx);
    Dec(i);
    if i >= _TableDesc.IndiceCount then
      i := _TableDesc.IndiceCount;
  end;

  il := TInterfaceList.Create;
  try
    for i := _TableDesc.IndiceCount - 1 downto 0 do begin
      il.Add(_TableDesc.Indices[i]);
      _TableDesc.DeleteIndex(i);
    end;

    for IndexType := Low(TIndexType) to High(TIndexType) do
      for i := il.Count - 1 downto 0 do begin
        CurIdx := il[i] as IdzDbIndexDescription;
        if CurIdx.GetIndexType = IndexType then begin
          CurIdx.Name := _TableDesc.GenerateIndexName(CurIdx.GetIndexType);
          _TableDesc.AppendIndex(CurIdx);
          il.Delete(i);
        end;
      end;
  finally
    il.Free;
  end;
end;

class procedure TAccessDbReader.ReadAccess(const _SrcFile, _DbPassword: string;
  const _DbDescription: IdzDbDescription; _IncludeData: Boolean;
  _MakeAutoInc, _ConsolidateIndices: Boolean; _Logger: ILogger);
var
  DataSource: string;
  AdoxCatalog: TAdoxCatalog;
  Table: TAdoxTable;
  Column: TAdoxColumn;
  Index: TAdoxIndex;
  Key: TAdoxKey;
  TblIdx, ColIdx: Integer;
  IndexIdx: Integer;
  KeyIdx: Integer;
  s: string;
  TableDesc: IdzDbTableDescription;
  Views: TStringList;
  ViewIdx: Integer;
  View: TAdoxView;
begin
  if not Assigned(_Logger) then
    _Logger := TNoLogging.Create;
  _Logger.Info(Format(_('Reading Accesss DB %s'), [_SrcFile]));
  Views := TStringList.Create;
  try
    Views.Sorted := True;
    DataSource := BuildConnectionString(_SrcFile, _DbPassword);
    AdoxCatalog := CoCatalog.Create;
    AdoxCatalog._Set_ActiveConnection(DataSource);
    _Logger.Info(_('First pass - reading tables'));

    for ViewIdx := 0 to AdoxCatalog.Views.Count - 1 do begin
      View := AdoxCatalog.Views[ViewIdx];
      Views.Add(View.Name);
    end;

    for TblIdx := 0 to AdoxCatalog.Tables.Count - 1 do begin
      Table := AdoxCatalog.Tables.Item[TblIdx];
      s := Table.Name;
      if StartsWith('MSys', s) then
        _Logger.Info(Format(_('Ignoring table %s (System-Table)'), [s]))
      else if Views.Find(s, ViewIdx) then
        _Logger.Info(Format(_('Ignoring table %s (View)'), [s]))
      else begin
        _Logger.Debug(Format(_('Reading table %s'), [s]));
        TableDesc := _DbDescription.AppendTable(s);

        for ColIdx := 0 to Table.Columns.Count - 1 do begin
          Column := Table.Columns.Item[ColIdx];
          AddColumn(TableDesc, Column, _Logger);
        end;

        for KeyIdx := 0 to Table.Keys.Count - 1 do begin
          Key := Table.Keys[KeyIdx];
          AddNonForeignKey(TableDesc, Key, _MakeAutoInc, _Logger);
        end;

      end;
    end;

    _Logger.Info(_('Second pass - adding foreign keys'));
    for TblIdx := 0 to AdoxCatalog.Tables.Count - 1 do begin
      Table := AdoxCatalog.Tables.Item[TblIdx];
      s := Table.Name;
      if StartsWith('MSys', s) then
        _Logger.Info(Format(_('Ignoring table %s (System-Table)'), [s]))
      else if Views.Find(s, ViewIdx) then
        _Logger.Info(Format(_('Ignoring table %s (View)'), [s]))
      else begin
        _Logger.Debug(Format(_('Reading table %s'), [s]));
        TableDesc := _DbDescription.TableByName(s);
        Assert(Assigned(TableDesc));

        for KeyIdx := 0 to Table.Keys.Count - 1 do begin
          Key := Table.Keys[KeyIdx];
          AddForeignKey(TableDesc, Key, _DbDescription);
        end;

        for IndexIdx := 0 to Table.Indexes.Count - 1 do begin
          Index := Table.Indexes[IndexIdx];
          AddIndex(TableDesc, Index);
        end;

        if _ConsolidateIndices then
          ConsolidateIndices(TableDesc, _Logger);

        TableDesc.SortColumns;
      end;
    end;

  finally
    Views.Free;
  end;

  if _IncludeData then
    ReadData(_SrcFile, _DbPassword, _DbDescription, _Logger);
end;

end.
