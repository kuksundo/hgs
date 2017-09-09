unit uConvertDataModule;

interface

uses
  SysUtils, Classes, WideStrings, SqlExpr, DB, DBTables,
  DBXMetaDataProvider, DBXMetaDataReader,
  DBXMetaDataWriter, DBXCommonTable, DBXTypedTableStorage,
  // If you get unable to locate driver error message
  // it is due to the fact that your driver is not loaded
  // make sure it's driver unit is added to list below.
  DBXOracle,
  DbxBlackfishSQL,
  DbxSybaseASE,
  DbxSybaseASA,
  DBXDb2,
  DBXMsSQL,
  DBXMySql, Provider, DBClient, FMTBcd;

type
  TConvertProgress = procedure ( ProgressStatement : String) of Object;
  TdmConvert = class(TDataModule)
    BDEdb: TDatabase;
    dbxConn: TSQLConnection;
    bdeTable: TTable;
    qryImport: TSQLQuery;
    CDS: TClientDataSet;
    dsProvider: TDataSetProvider;
  private
    FOnConvertProgress: TConvertProgress;
    procedure SetOnConvertProgress(const Value: TConvertProgress);
    { Private declarations }
  protected
    procedure MoveRow(Source,Dest : TDataSet);
    procedure UpdateProgress(ProgressStatement : String);
    procedure ConnectDBX(DriverName,ConnName : String);
    procedure ConvertData(TableName : String);
    procedure ConvertMetaData(TableName : String);
    procedure ConvertTableMetaData(TableName : String;DataSet : TDataset; DestConn : TSQLConnection);
    procedure ConvertTableData(TableName : String;DataSet : TDataset; DestConn : TSQLConnection);
  public
    { Public declarations }
    procedure PopulateBDEAliasList(sl : TStrings);
    procedure PopulateTableNames(sl : TStrings);
    procedure PopulateDbxDriverNames(sl : TStrings);
    procedure PopulateDBXConnections(DriverName : String; sl : TStrings);
    procedure ConvertTables(TableList : TStringList;DestDriver,DestConn : String;MetaDataOnly : Boolean);
    property  OnConvertProgress : TConvertProgress read FOnConvertProgress write SetOnConvertProgress;
  end;

var
  dmConvert: TdmConvert;

implementation
{$R *.dfm}

uses dbConnAdmin,
     dbxCommon,
     dbxUtils; {dbxUtils: Found in the DBX Datapump Example and on CodeCentral ID: 26288; }

type
 TDBXMetaDataProviderHack = class(TDBXMetaDataProvider);

const

//Mapping Best Guess in 10 minutes of work, so I suspsect there
//are problems but you could also change this to find tune for your
//specific mapping needs.
  FieldTypeMap : Array[TFieldType] of Integer =
   ( {ftUnknown} TDBXDataTypes.UnknownType, {ftString} TDBXDataTypes.AnsiStringType, {ftSmallint} TDBXDataTypes.Int16Type, {ftInteger} TDBXDataTypes.Int32Type, {ftWord} TDBXDataTypes.UInt16Type, // 0..4
    {ftBoolean} TDBXDataTypes.BooleanType, {ftFloat} TDBXDataTypes.DoubleType, {ftCurrency} TDBXDataTypes.BcdType, {ftBCD} TDBXDataTypes.BcdType, {ftDate}TDBXDataTypes.DateType , {ftTime} TDBXDataTypes.TimeType, {ftDateTime} TDBXDataTypes.DateTimeType, // 5..11
    {ftBytes}TDBXDataTypes.BytesType , {ftVarBytes} TDBXDataTypes.VarBytesType, {ftAutoInc} TDBXDataTypes.AutoIncSubType, {ftBlob} TDBXDataTypes.BlobType, {ftMemo} TDBXDataTypes.MemoSubType, {ftGraphic} TDBXDataTypes.BlobType, {ftFmtMemo} TDBXDataTypes.MemoSubType, // 12..18
    {ftParadoxOle}TDBXDataTypes.UnknownType , {ftDBaseOle}TDBXDataTypes.UnknownType, {ftTypedBinary}TDBXDataTypes.BlobType, {ftCursor}TDBXDataTypes.UnknownType, {ftFixedChar}TDBXDataTypes.CharArrayType, {ftWideString} TDBXDataTypes.WideStringType,  // 19..24
    {ftLargeint}TDBXDataTypes.Int64Type, {ftADT}TDBXDataTypes.AdtType , {ftArray}TDBXDataTypes.ArrayType , {ftReference}TDBXDataTypes.UnknownType, {ftDataSet}TDBXDataTypes.UnknownType, {ftOraBlob}TDBXDataTypes.BlobType, {ftOraClob} TDBXDataTypes.BlobType, // 25..31
    {ftVariant} TDBXDataTypes.UnknownType, {ftInterface}TDBXDataTypes.UnknownType, {ftIDispatch}TDBXDataTypes.UnknownType, {ftGuid}TDBXDataTypes.CharArrayType, {ftTimeStamp} TDBXDataTypes.DateTimeType, {ftFMTBcd} TDBXDataTypes.BcdType, // 32..37
    {ftFixedWideChar} TDBXDataTypes.WideStringType, {ftWideMemo} TDBXDataTypes.UnknownType, {ftOraTimeStamp} TDBXDataTypes.OracleTimeStampSubType, {ftOraInterval}TDBXDataTypes.OracleIntervalSubType, // 38..41
   {ftLongWord} TDBXDataTypes.Uint32Type, {ftShortint} TDBXDataTypes.Int16Type, {ftByte} TDBXDataTypes.Int8Type, {ftExtended} TDBXDataTypes.DoubleType, {ftConnection} TDBXDataTypes.UnknownType, {ftParams}TDBXDataTypes.UnknownType, {ftStream}TDBXDataTypes.UnknownType); //42..48

  ftLongTypes = [ftVarBytes,ftMemo,ftBlob,ftFmtMemo];

{ TDataModule1 }

procedure TdmConvert.ConnectDBX(DriverName, ConnName: String);
begin
  dbxConn.DriverName := DriverName;
  dbxConn.ConnectionName := ConnName;
  dbxConn.Open;
  UpdateProgress('Connected to ' + ConnName);
end;

procedure TdmConvert.ConvertData(TableName: String);
begin
 UpdateProgress('Converting Data for ' + TableName);
 bdeTable.Close;
 bdeTable.TableName := TableName;
 bdeTable.TableType := ttParadox;
 try
 bdeTable.Open; // if we used a query here it would just be select * from tablename
 except
   try
     bdeTable.TableType := ttDBase;
     bdeTable.Open
   except
     bdeTable.TableType := ttFoxPro;
     bdeTable.Open
   end;
 end;
 ConvertTableData(TableName,bdeTable,dbxConn);
 bdeTable.Close;
 UpdateProgress('Converted Data for ' + TableName);
end;

procedure TdmConvert.ConvertMetaData(TableName: String);
begin
 UpdateProgress('Converting MetaData for ' + TableName);
 bdeTable.Close;
 bdeTable.TableName := TableName;
 bdeTable.TableType := ttParadox;
 try
 bdeTable.Open; // if we used a query here it would just be select * from tablename
 except
   try
     bdeTable.TableType := ttDBase;
     bdeTable.Open
   except
     bdeTable.TableType := ttFoxPro;
     bdeTable.Open
   end;
 end;
 bdeTable.Open; // really not so great for SQL based really should be a select * from table where 0 = 1
 ConvertTableMetaData(TableName,bdeTable,dbxConn);
 bdeTable.Close;
 UpdateProgress('Converted MetaData for ' + TableName);
end;

procedure TdmConvert.ConvertTableData(TableName: String; DataSet: TDataset;
  DestConn: TSQLConnection);
var
 Rows : Integer;
begin
// Yes I could have generated a insert statement here and it
// it would have avoid some memory overhead.
// But, I have never seen a paradox,dbtable that large.
// so this will work for many people... If it don't work for
// you then you can generate the insert statement :-)
    qryImport.Close;
    qryImport.SQLConnection  := DestConn;
    qryImport.SQL.Clear;
    qryImport.SQL.Add('select * from ');
    qryImport.SQL.Add(tablename);
    qryImport.SQL.Add(' where 0  = 1');
    qryImport.Open;
    CDS.Open;
    DataSet.First;
    Rows := 0;
    while not DataSet.Eof do
    begin
      inc(rows);
      MoveRow(DataSet,CDS);
      // Apply Updates Every 100 Rows.
      if Rows > 100 then
      begin
        cds.ApplyUpdates(0);
        qryImport.Close;
        CDS.Close;
        qryImport.Open;
        CDS.Open;
        Rows := 0;
      end;
      DataSet.Next;
    end;
    cds.ApplyUpdates(0);
    qryImport.Close;
    CDS.Close;
end;

procedure TdmConvert.ConvertTableMetaData(TableName: String; DataSet: TDataset;
  DestConn: TSQLConnection);

var
 MDP : TDBXMetaDataProvider;
 Tbl : TDBXMetaDataTable;
 Col : TDBXMetaDataColumn;
  I: Integer;
begin
 MDP := DBXGetMetaProvider(DestConn.DBXConnection);
 Tbl := TDBXMetaDataTable.Create;
 try
 for I := 0 to DataSet.FieldDefs.Count - 1 do
 begin
   Col := TDBXMetaDataColumn.Create;
   Col.ColumnName := DataSet.FieldDefs.Items[I].Name;
   Col.Nullable := Not (faRequired in DataSet.FieldDefs.Items[I].Attributes);
   Col.DataType := FieldTypeMap[DataSet.FieldDefs.Items[I].DataType];
   Col.AutoIncrement := (DataSet.FieldDefs.Items[I].DataType = ftAutoInc);
   Col.FixedLength := (DataSet.FieldDefs.Items[I].DataType in ftFixedSizeTypes);
   if col.FixedLength then
   begin
        Col.Precision := DataSet.FieldDefs.Items[I].Precision;
   end
   else
   begin
       Col.Precision := DataSet.FieldDefs.Items[I].Size;
   end;

   Col.Long := (DataSet.FieldDefs.Items[I].DataType in ftLongTypes);
   if Col.DataType > 0 then
      Tbl.AddColumn(Col)
   else
      UpdateProgress('Skipping "' + Col.ColumnName + '" unable determine valid dbx type');
 end;
 Tbl.TableName := uppercase(TableName);
 MDP.CreateTable(Tbl);
 finally
   TBL.Free;
   MDP.Free;
 end;


end;

procedure TdmConvert.ConvertTables(TableList: TStringList; DestDriver,
  DestConn: String; MetaDataOnly: Boolean);
var
 tbl : String;
begin
  ConnectDBX(DestDriver,DestConn);
  // Convert Just Meta Data First
  for tbl in TableList do
  begin
    ConvertMetaData(tbl);
  end;

  if Not MetadataOnly then
  begin
    for tbl in TableList do
    begin
      ConvertData(tbl);
    end;
  end;

end;

procedure TdmConvert.MoveRow(Source, Dest: TDataSet);
var
 I : Integer;
 SourceField : TField;
 DestField : TField;
begin
  Dest.Append;
  for I := 0 to Source.FieldCount - 1 do
  begin
    SourceField := Source.Fields[I];
    DestField := Dest.FindField(SourceField.FieldName);
    if Assigned(DestField) then
    begin
      if SourceField.DataType in  ftNonTextTypes then
      begin
         DestField.AsBytes := SourceField.AsBytes;
      end
      else
      begin
        DestField.AsString := SourceField.AsString;
      end;
    end;
  end;

  Dest.Post;

end;

procedure TdmConvert.PopulateBDEAliasList(sl: TStrings);
begin
  BDEdb.Session.GetAliasNames(sl);
end;

procedure TdmConvert.PopulateDBXConnections(DriverName: String; sl: TStrings);
var
 ca : IConnectionAdmin;
begin
 ca := TConnectionAdmin.Create;
 ca.GetConnectionNames(sl,DriverName)
end;

procedure TdmConvert.PopulateDbxDriverNames(sl: TStrings);
var
 ca : IConnectionAdmin;
begin
 ca := TConnectionAdmin.Create;
 ca.GetDriverNames(sl);
end;

procedure TdmConvert.PopulateTableNames(sl: TStrings);
begin
  BDEdb.GetTableNames(sl,false);
end;

procedure TdmConvert.SetOnConvertProgress(const Value: TConvertProgress);
begin
  FOnConvertProgress := Value;
end;

procedure TdmConvert.UpdateProgress(ProgressStatement : String);
begin
 if Assigned(FOnConvertProgress) then
    FOnConvertProgress(ProgressStatement)
end;

end.
