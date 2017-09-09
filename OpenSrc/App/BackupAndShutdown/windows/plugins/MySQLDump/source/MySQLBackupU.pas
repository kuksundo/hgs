{ -----------------------------------------------------------------------------
  Unit Name: MySQLBackup
  Author: Tristan Marlow
  Purpose: MySQL Backup

  ----------------------------------------------------------------------------
  Copyright (c) 2009 Tristan David Marlow
  Copyright (c) 2009 ABit Consulting
  All Rights Reserved

  This product is protected by copyright and distributed under
  licenses restricting copying, distribution and decompilation

  The backup idea and EscapeString functions have been
  taken from HeidiSQL. (http://www.heidisql.com/)

  ----------------------------------------------------------------------------

  History: 03/05/2007 - First Release.
  22/03/2011 - Escapestring is now used to allow MySQL "/" escaping.

  ----------------------------------------------------------------------------- }
unit MySQLBackupU;

interface

uses
  ZConnection, ZDbcIntfs, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  SysUtils, Variants, Classes, DB, Windows;

const
  BACKUP_MAX_ROW_COUNT = 1000;
  BACKUP_MAX_CHAR_LINE_COUNT = 0; // 10MB
  BACKUP_TABLE_SELECT_LIMIT = 1000;
  BACKUP_TABLE_SELECT_LIMIT_LARGE_TABLE = 50;
  BACKUP_MAX_READ_MB = 20;

type
  TOnLog = procedure(ASender: TObject; AMessage: string) of object;
  TOnDebug = procedure(ASender: TObject; AProcedure, AMessage: string)
    of object;
  TOnProgress = procedure(ASender: TObject; AProgress: integer;
    AMessage: string; var ACancel: boolean) of object;

type
  TMySQLBackupType = (btDataOnly, btFullBackup);

type
  TMySQLBackupDataHelper = class(TZQuery)
  public
    function GetTableRecordCount(ATableName: string): integer;
    function GetTableSize(ATableName: string): double;
    function GetTableCreate(ATableName: string;
      AIncludeNotExists: boolean = True): string;
    procedure GetIndexColumns(ATableName: string; AIndexColumns: TStrings);
    // procedure GetIndexColumnsDataTypes(ATableName: string;
    // AIndexColumns: TStrings; ADataTypes: TIntegerList);
    procedure GetTableNames(AList: TStrings);
  end;

type
  TMySQLBackupData = class(TZQuery)
  private
    FTableName: string;
    FTotalRecordCount: integer;
    FRecordLimit: integer;
    FRecordLimitLargeTable: integer;
    FTopRecord: integer;
    FTableSize: double;
    // Use data helper as EOF method is modified.
    FMySQLBackupDataHelper: TMySQLBackupDataHelper;
    FOnLog: TOnLog;
  protected
    function GetRecordCount: integer; override;
    function GetRecNo: integer; override;
    procedure OpenTableRecords;
    procedure Log(AMessage: string);
    procedure Error(AMessage: string);
    procedure Warning(AMessage: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function EOF: boolean;
    procedure GetTableRecords(ATableName: string; ARecordLimit: integer = -1;
      ARecordLimitLargeTable: integer = BACKUP_TABLE_SELECT_LIMIT_LARGE_TABLE);
    function GetTableCreate(ATableName: string;
      AIncludeNotExists: boolean = True): string;
    procedure GetTableNames(AList: TStrings; AAppend: boolean = False);

    function LoadFromBlob(const AField: TField; const Stream: TStream): boolean;
  published
  end;

type
  TMySQLBackup = class(TComponent)
  private
    FInProgress: boolean;
    FCancel: boolean;
    FOnTotalProgress: TOnProgress;
    FOnDatabaseProgress: TOnProgress;
    FOnItemProgress: TOnProgress;
    FScript: TextFile;
    FMySQLDataBackupData: TMySQLBackupData;
    FFileName: TFileName;
    FZConnection: TZConnection;
    FMaxRowCount: integer;
    FMaxCharLineCount: integer;
    FMySQLBackupType: TMySQLBackupType;
    FExcludedDatabases: TStringList;
    FOnLog: TOnLog;
    FOnDebug: TOnDebug;
  protected
    procedure SetZConnectionHostname(AValue: string);
    function GetZConnectionHostname: string;
    procedure SetZConnectionUsername(AValue: string);
    function GetZConnectionUsername: string;
    procedure SetZConnectionPassword(AValue: string);
    function GetZConnectionPassword: string;
    procedure SetZConnectionPort(AValue: integer);
    function GetZConnectionPort: integer;
    procedure AddScriptHeader;
    procedure AddScriptFooter;
    procedure AddLine(ALine: string);
    function escChars(const Text: string; EscChar, Char1, Char2, Char3,
      Char4: char): string;
    function EscapeString(AText: string;
      AProcessJokerChars: boolean = False): string;
    procedure Log(AMessage: string);
    procedure Debug(AProcedure: string; AMessage: string);
    function CalculatePercentage(AValue: integer; ATotal: integer): integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: boolean;
    procedure Cancel;
    function InProgress: boolean;
    procedure GetDatabaseList(AList: TStrings);
  published
    property Hostname: string Read GetZConnectionHostname
      Write SetZConnectionHostname;
    property Port: integer Read GetZConnectionPort Write SetZConnectionPort;
    property Username: string Read GetZConnectionUsername
      Write SetZConnectionUsername;
    property Password: string Read GetZConnectionPassword
      Write SetZConnectionPassword;
    property ExcludedDatabases: TStringList read FExcludedDatabases;
    property FileName: TFileName Read FFileName Write FFileName;
    property OnTotalProgress: TOnProgress Read FOnTotalProgress
      Write FOnTotalProgress;
    property OnDatabaseProgress: TOnProgress Read FOnDatabaseProgress
      Write FOnDatabaseProgress;
    property OnItemProgress: TOnProgress Read FOnItemProgress
      Write FOnItemProgress;
    property MaxRowCount: integer Read FMaxRowCount Write FMaxRowCount;
    property MaxCharLineCount: integer Read FMaxCharLineCount
      Write FMaxCharLineCount;
    property BackupType: TMySQLBackupType Read FMySQLBackupType
      Write FMySQLBackupType;
    property OnLog: TOnLog Read FOnLog Write FOnLog;
    property OnDebug: TOnDebug Read FOnDebug Write FOnDebug;
  end;

implementation

uses
  CommonU,
  System.DateUtils, System.StrUtils;


// TMySQLBackupDataHelper

function TMySQLBackupDataHelper.GetTableRecordCount(ATableName: string)
  : integer;
begin
  Close;
  try
    SQL.Clear;
    SQL.Add('SELECT COUNT(*) as total FROM `' + ATableName + '`');
    Open;
    Result := FieldByName('total').AsInteger;
  finally
    Close;
  end;
end;

function TMySQLBackupDataHelper.GetTableSize(ATableName: string): double;
begin
  Result := 0;
  Close;
  try
    SQL.Clear;
    SQL.Add('SELECT table_name,');
    SQL.Add('round(((data_length + index_length) / 1024 / 1024), 2) as table_size');
    SQL.Add('FROM information_schema.TABLES');
    SQL.Add('WHERE table_schema = ' + AnsiQuotedStr(Connection.Database, '"'));
    SQL.Add('AND table_name = ' + AnsiQuotedStr(ATableName, '"'));
    Open;
    if not IsEmpty then
    begin
      Result := FieldByName('table_size').AsFloat;
    end;
  finally
    Close;
  end;
end;

procedure TMySQLBackupDataHelper.GetIndexColumns(ATableName: string;
  AIndexColumns: TStrings);
begin
  Close;
  if Assigned(AIndexColumns) then
  begin
    AIndexColumns.Clear;
    try
      SQL.Clear;
      SQL.Add('SHOW INDEX FROM `' + ATableName + '`');
      SQL.Add('WHERE Key_name = "PRIMARY"');
      Open;
      while not EOF do
      begin
        if FindField('Column_name') <> nil then
        begin
          AIndexColumns.Add(FieldByName('Column_name').AsString);
        end
        else
        begin
          // Error('Column_name not found in Query: ' + SQL.Text);
        end;
        Next;
      end;
    finally
      Close;
    end;
  end;
end;

// procedure TMySQLBackupDataHelper.GetIndexColumnsDataTypes(ATableName: string;
// AIndexColumns: TStrings; ADataTypes: TIntegerList);
// var
// TokenIdx: integer;
// begin
// ADataTypes.Clear;
// Close;
// try
// SQL.Clear;
// SQL.Add('SELECT ');
// for TokenIdx := 0 to Pred(AIndexColumns.Count) do
// begin
// if TokenIdx = 0 then
// begin
// SQL.Add(DeQuotedString(AIndexColumns[TokenIdx]));
// end
// else
// begin
// SQL.Add(',' + DeQuotedString(AIndexColumns[TokenIdx]));
// end;
// end;
// SQL.Add('FROM ' + ATableName + ' LIMIT 1');
// Open;
// if not IsEmpty then
// begin
// for TokenIdx := 0 to Pred(AIndexColumns.Count) do
// begin
//
// if FindField(DeQuotedString(AIndexColumns[TokenIdx])) <> nil then
// begin
// ADataTypes.Add
// (integer(FieldByName(DeQuotedString(AIndexColumns[TokenIdx]))
// .DataType));
// end
// else
// begin
// ADataTypes.Add(-1);
// end;
// end;
// end;
// finally
// Close;
// end;
// end;

procedure TMySQLBackupDataHelper.GetTableNames(AList: TStrings);
begin

  Close;
  if Assigned(AList) then
  begin
    try
      SQL.Clear;
      SQL.Add('SHOW TABLE STATUS FROM `' + Connection.Database +
        '` WHERE Engine <> ""');
      Open;
      while not EOF do
      begin
        try
          AList.Add(FieldByName('Name').AsString);
        finally
          Next;
        end;
      end;
    finally
      Close;
    end;
  end;

end;

function TMySQLBackupDataHelper.GetTableCreate(ATableName: string;
  AIncludeNotExists: boolean = True): string;
begin
  Close;
  try
    SQL.Clear;
    SQL.Add('SHOW CREATE TABLE `' + ATableName + '`');
    Open;
    Result := FieldByName('Create Table').AsString + ';';
    if AIncludeNotExists then
    begin
      Result := StringReplace(Result, 'CREATE TABLE',
        'CREATE TABLE IF NOT EXISTS', []);
    end;
  finally
    Close;
  end;
end;

// TMySQLBackupData

constructor TMySQLBackupData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTableName := '';
  FTotalRecordCount := 0;
  FTopRecord := 0;
  FRecordLimit := BACKUP_TABLE_SELECT_LIMIT;
  FRecordLimitLargeTable := BACKUP_TABLE_SELECT_LIMIT_LARGE_TABLE;
  FMySQLBackupDataHelper := TMySQLBackupDataHelper.Create(nil);
end;

destructor TMySQLBackupData.Destroy;
begin
  FreeAndNil(FMySQLBackupDataHelper);
  inherited Destroy;
end;

function TMySQLBackupData.GetRecordCount: integer;
begin
  if FRecordLimit = -1 then
  begin
    Result := inherited GetRecordCount;
  end
  else
  begin
    Result := FTotalRecordCount;
  end;
end;

function TMySQLBackupData.GetRecNo: integer;
begin
  if FRecordLimit = -1 then
  begin
    Result := inherited GetRecNo;
  end
  else
  begin
    Result := inherited GetRecNo + FTopRecord;
  end;
end;

procedure TMySQLBackupData.OpenTableRecords;
var
  IndexColumns: TStringList;
  Idx: integer;
  Columns: string;
begin
  if FTableName <> '' then
  begin
    IndexColumns := TStringList.Create;
    try
      FMySQLBackupDataHelper.Connection := Connection;
      FMySQLBackupDataHelper.GetIndexColumns(FTableName, IndexColumns);
      Close;
      SQL.Clear;
      // Attempt to improve performance
      // http://explainextended.com/2009/10/23/mysql-order-by-limit-performance-late-row-lookups/
      if (FRecordLimit <> -1) and (IndexColumns.Count > 0) then
      begin
        SQL.Add('SELECT ' + FTableName + '.* FROM');
        SQL.Add('(');
        SQL.Add('SELECT');
        Columns := '';
        for Idx := 0 to Pred(IndexColumns.Count) do
        begin
          if Idx = 0 then
          begin
            Columns := IndexColumns[Idx];
          end
          else
          begin
            Columns := Columns + ', ' + IndexColumns[Idx];
          end;
        end;
        SQL.Add(Columns);
        SQL.Add('FROM ' + FTableName);
        if FRecordLimit <> -1 then
        begin
          SQL.Add('LIMIT ' + IntToStr(FTopRecord) + ',' +
            IntToStr(FRecordLimit));
          // Debug('OpenTableRecords',
          // Format('Selecting "%s", top record: %d, record limit: %d, total: %d ',
          // [FTableName, FTopRecord, FRecordLimit, FTotalRecordCount]));
        end;
        SQL.Add(') as backup_data');
        SQL.Add('JOIN ' + FTableName + ' ON');
        Columns := '';
        for Idx := 0 to Pred(IndexColumns.Count) do
        begin
          if Idx = 0 then
          begin
            Columns := FTableName + '.' + IndexColumns[Idx] + ' = backup_data.'
              + IndexColumns[Idx];
          end
          else
          begin
            Columns := Columns + ' AND ' + FTableName + '.' + IndexColumns[Idx]
              + ' = backup_data.' + IndexColumns[Idx];
          end;
        end;
        SQL.Add(Columns);
        SQL.Add('ORDER BY');
        for Idx := 0 to Pred(IndexColumns.Count) do
        begin
          if Idx = 0 then
          begin
            Columns := FTableName + '.' + IndexColumns[Idx];
          end
          else
          begin
            Columns := Columns + ', ' + FTableName + '.' + IndexColumns[Idx];
          end;
        end;
        SQL.Add(Columns);
      end
      else
      begin
        SQL.Add('SELECT * FROM ' + FTableName);
        if FRecordLimit <> -1 then
        begin
          SQL.Add('LIMIT ' + IntToStr(FTopRecord) + ',' +
            IntToStr(FRecordLimit));
          // Debug('OpenTableRecords',
          // Format('Selecting "%s", top record: %d, record limit: %d, total: %d ',
          // [FTableName, FTopRecord, FRecordLimit, FTotalRecordCount]));
          Warning('Record limiting is not using INDEX fields, this may result in slow performance');
        end;
      end;
      try
        Open;
      except
        on E: Exception do
        begin
          Error(E.Message);
        end;
      end;
    finally
      FreeAndNil(IndexColumns);
    end;
  end;
end;

procedure TMySQLBackupData.Log(AMessage: string);
begin
  if Assigned(FOnLog) then
    FOnLog(Self, AMessage);
end;

procedure TMySQLBackupData.Error(AMessage: string);
begin
  Log('ERROR: ' + AMessage);
end;

procedure TMySQLBackupData.Warning(AMessage: string);
begin
  Log('WARNING: ' + AMessage);
end;

function TMySQLBackupData.EOF: boolean;
begin
  Result := inherited EOF;
  if (FRecordLimit <> -1) and (Result) then
  begin
    FTopRecord := FTopRecord + FRecordLimit;
    if (FTopRecord > FTotalRecordCount) then
    begin
      Result := True;
    end
    else
    begin
      OpenTableRecords;
      Result := False;
    end;
  end;
end;

procedure TMySQLBackupData.GetTableRecords(ATableName: string;
  ARecordLimit: integer = -1;
  ARecordLimitLargeTable: integer = BACKUP_TABLE_SELECT_LIMIT_LARGE_TABLE);
begin
  FTopRecord := 0;
  FTableName := ATableName;
  FRecordLimit := ARecordLimit;
  FRecordLimitLargeTable := ARecordLimitLargeTable;
  FMySQLBackupDataHelper.Connection := Connection;
  FTotalRecordCount := FMySQLBackupDataHelper.GetTableRecordCount(FTableName);
  FTableSize := FMySQLBackupDataHelper.GetTableSize(FTableName);

  Log(Format('Table: %s, %d record(s), %f MB', [FTableName, FTotalRecordCount,
    FTableSize]));

  if FTableSize > 1000 then
  begin
    FRecordLimit := FRecordLimitLargeTable;
    Log(Format('Large table "%s" (%f MB), forcing record limit %d',
      [FTableName, FTableSize, FRecordLimit]));
  end;

  OpenTableRecords;
end;

function TMySQLBackupData.GetTableCreate(ATableName: string;
  AIncludeNotExists: boolean = True): string;
begin
  FMySQLBackupDataHelper.Connection := Connection;
  Result := FMySQLBackupDataHelper.GetTableCreate(ATableName,
    AIncludeNotExists);
end;

procedure TMySQLBackupData.GetTableNames(AList: TStrings;
  AAppend: boolean = False);
begin
  if not AAppend then
    AList.Clear;
  FMySQLBackupDataHelper.Connection := Connection;
  FMySQLBackupDataHelper.GetTableNames(AList);
end;

function TMySQLBackupData.LoadFromBlob(const AField: TField;
  const Stream: TStream): boolean;
var
  Blob: TStream;
begin
  Blob := CreateBlobStream(AField, bmRead);
  try
    Blob.Seek(0, soFromBeginning);
    Stream.CopyFrom(Blob, Blob.Size);
    Result := True;
  finally
    Blob.Free
  end;
end;

// TMySQLBackup

constructor TMySQLBackup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FZConnection := TZConnection.Create(Self);
  FMySQLDataBackupData := TMySQLBackupData.Create(Self);
  FMaxRowCount := BACKUP_MAX_ROW_COUNT;
  FMaxCharLineCount := BACKUP_MAX_CHAR_LINE_COUNT;
  FInProgress := False;
  FMySQLBackupType := btFullBackup;
  FZConnection.Protocol := 'mysql';
  FZConnection.Hostname := 'localhost';
  FExcludedDatabases := TStringList.Create;
end;

procedure TMySQLBackup.Log(AMessage: string);
begin
  if Assigned(FOnLog) then
  begin
    FOnLog(Self, AMessage);
  end;
end;

procedure TMySQLBackup.Debug(AProcedure: string; AMessage: string);
begin
  if Assigned(FOnDebug) then
  begin
    FOnDebug(Self, AProcedure, AMessage);
  end;
end;

function TMySQLBackup.CalculatePercentage(AValue: integer;
  ATotal: integer): integer;
begin
  Result := 0;
  if ATotal > 0 then
  begin
    Result := Round((AValue / ATotal) * 100);
  end;
end;

destructor TMySQLBackup.Destroy;
begin
  FreeAndNil(FMySQLDataBackupData);
  FreeAndNil(FZConnection);
  FreeAndNil(FExcludedDatabases);
  inherited Destroy;
end;

procedure TMySQLBackup.SetZConnectionHostname(AValue: string);
begin
  FZConnection.Hostname := AValue;
end;

function TMySQLBackup.GetZConnectionHostname: string;
begin
  Result := FZConnection.Hostname;
end;

procedure TMySQLBackup.SetZConnectionUsername(AValue: string);
begin
  FZConnection.User := AValue;
end;

function TMySQLBackup.GetZConnectionUsername: string;
begin
  Result := FZConnection.User;
end;

procedure TMySQLBackup.SetZConnectionPassword(AValue: string);
begin
  FZConnection.Password := AValue;
end;

function TMySQLBackup.GetZConnectionPassword: string;
begin
  Result := FZConnection.Password;
end;

procedure TMySQLBackup.SetZConnectionPort(AValue: integer);
begin
  FZConnection.Port := AValue;
end;

function TMySQLBackup.GetZConnectionPort: integer;
begin
  Result := FZConnection.Port;
end;

function TMySQLBackup.escChars(const Text: string; EscChar, Char1, Char2, Char3,
  Char4: char): string;
const
  // Attempt to match whatever the CPU cache will hold.
  block: cardinal = 65536;
var
  bstart, bend, matches, i: cardinal;
  // These could be bumped to uint64 if necessary.
  len, respos: cardinal;
  Next: char;
begin
  len := Length(Text);
  Result := '';
  bend := 0;
  respos := 0;
  repeat
    bstart := bend + 1;
    bend := bstart + block - 1;
    if bend > len then
      bend := len;
    matches := 0;
    for i := bstart to bend do
      if (Text[i] = Char1) or (Text[i] = Char2) or (Text[i] = Char3) or
        (Text[i] = Char4) then
        Inc(matches);
    SetLength(Result, bend + 1 - bstart + matches + respos);
    for i := bstart to bend do
    begin
      Next := Text[i];
      if (Next = Char1) or (Next = Char2) or (Next = Char3) or (Next = Char4)
      then
      begin
        Inc(respos);
        Result[respos] := EscChar;
        // Special values for MySQL escape.
        if Next = #13 then
          Next := 'r';
        if Next = #10 then
          Next := 'n';
        if Next = #0 then
          Next := '0';
      end;
      Inc(respos);
      Result[respos] := Next;
    end;
  until bend = len;
end;

function TMySQLBackup.EscapeString(AText: string;
  AProcessJokerChars: boolean = False): string;
var
  c1, c2, c3, c4, EscChar: char;
begin
  c1 := '''';
  c2 := '\';
  c3 := '%';
  c4 := '_';
  EscChar := '\';
  if not AProcessJokerChars then
  begin
    // Do not escape joker-chars which are used in a LIKE-clause
    c4 := '''';
    c3 := '''';
  end;
  Result := escChars(AText, EscChar, c1, c2, c3, c4);
  // Remove characters that SynEdit chokes on, so that
  // the SQL file can be non-corruptedly loaded again.
  c1 := #13;
  c2 := #10;
  c3 := #0;
  c4 := #0;
  // TODO: SynEdit also chokes on Char($2028) and possibly Char($2029).
  Result := escChars(Result, EscChar, c1, c2, c3, c4);
  if not AProcessJokerChars then
  begin
    // Add surrounding single quotes only for non-LIKE-values
    // because in all cases we're using ProcessLIKEChars we
    // need to add leading and/or trailing joker-chars by hand
    // without being escaped
    Result := char(#39) + Result + char(#39);
  end;
end;

procedure TMySQLBackup.AddLine(ALine: string);
begin
  try
    Writeln(FScript, ALine);
  except
    on E: Exception do
    begin
      Log('Error: ' + E.Message);
    end;
  end;
end;

procedure TMySQLBackup.AddScriptHeader;
begin
  AddLine('--');
  AddLine('-- Hostname: ' + FZConnection.Hostname);
  AddLine('-- Database: ' + FZConnection.Database);
  AddLine('-- Date: ' + DateTimeToStr(Now));
  AddLine('--');
  AddLine('/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;');
  AddLine('/*!40101 SET NAMES utf8 */;');
  AddLine('/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;');
  AddLine('/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE="NO_AUTO_VALUE_ON_ZERO" */;');
end;

procedure TMySQLBackup.AddScriptFooter;
begin
  AddLine('/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;');
  AddLine('/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;');
  AddLine('/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;');
  AddLine('--');
  AddLine('-- Hostname: ' + FZConnection.Hostname);
  AddLine('-- Database: ' + FZConnection.Database);
  AddLine('-- Date: ' + DateTimeToStr(Now));
  AddLine('--');
end;

procedure TMySQLBackup.Cancel;
begin
  FCancel := True;
end;

function TMySQLBackup.InProgress: boolean;
begin
  Result := FInProgress;
end;

procedure TMySQLBackup.GetDatabaseList(AList: TStrings);
var
  Idx: integer;
  ExcludedIdx: integer;

  function FindMatchText(Strings: TStrings; const SubStr: string): integer;
  begin
    for Result := 0 to Strings.Count - 1 do
      if ContainsText(Strings[Result], SubStr) then
        exit;
    Result := -1;
  end;

  function FindText(Strings: TStrings; const AText: string): integer;
  begin
    Result := Strings.IndexOf(AText);
  end;

begin
  FZConnection.Disconnect;
  FZConnection.Connect;
  try
    try
      FZConnection.Database := 'mysql';

      FZConnection.GetCatalogNames(AList);
      for Idx := 0 to Pred(FExcludedDatabases.Count) do
      begin
        repeat
          if Pos('*', FExcludedDatabases[Idx]) > 0 then
          begin
            ExcludedIdx := FindMatchText(AList,
              StringReplace(FExcludedDatabases[Idx], '*', '',
              [rfReplaceAll, rfIgnoreCase]));
          end
          else
          begin
            ExcludedIdx := FindText(AList, FExcludedDatabases[Idx]);
          end;
          if ExcludedIdx <> -1 then
          begin
            AList.Delete(ExcludedIdx);
          end;
        until ExcludedIdx = -1;
      end;
    except
      on E: Exception do
      begin
        Log(E.Message);
      end;
    end;
  finally
    FZConnection.Disconnect;
  end;

end;

function TMySQLBackup.Execute: boolean;
var
  Tables: TStringList;
  Databases: TStringList;
  TableIdx: integer;
  DatabaseIdx: integer;
  FieldIdx: integer;
  ScriptLine: string;
  DateFormatStr: string;
  BlobStream: TMemoryStream;
  BlobHexStr: string;
  BlobByte: byte;
  Timer: TDateTime;
  NewScriptLine: boolean;
  ScriptLineCount: integer;
  ForceNewScriptLine: boolean;
begin
  Timer := Now;
  FCancel := False;
  Result := False;
  Log('Initializing data backup...');
  if Assigned(FOnTotalProgress) then
  begin
    FOnTotalProgress(Self, 0, 'Initializing data backup...', FCancel);
  end;
  Tables := TStringList.Create;
  Databases := TStringList.Create;
  BlobStream := TMemoryStream.Create;
  FInProgress := True;
  Log(Format('SQL Filename "%s"', [FFileName]));
  try
    try
      Log('Gathering Database List...');
      GetDatabaseList(Databases);

      Log('Database: ' + Databases.Text);
      AssignFile(FScript, FFileName);
{$I-}
      ReWrite(FScript);
{$I+}
      if IOResult = 0 then
      begin
        AddScriptHeader;
        DatabaseIdx := 0;
        while (DatabaseIdx <= Pred(Databases.Count)) and (not FCancel) do
        begin

          if Assigned(FOnTotalProgress) then
          begin
            FOnTotalProgress(Self, CalculatePercentage(DatabaseIdx + 1,
              Databases.Count), 'Database: ' + Databases[DatabaseIdx], FCancel);
          end;

          FZConnection.Disconnect;
          FZConnection.Database := Databases[DatabaseIdx];
          Log('Connecting to: ' + FZConnection.Database);
          FZConnection.Connect;
          AddLine('--');
          AddLine('-- Database: ' + FZConnection.Database);
          AddLine('--');
          AddLine('USE ' + FZConnection.Database + ';');
          AddLine('--');

          // FZConnection.GetTableNames('', Tables);
          FMySQLDataBackupData.Connection := FZConnection;
          FMySQLDataBackupData.GetTableNames(Tables, False);
          TableIdx := 0;
          while (TableIdx <= Pred(Tables.Count)) and (not FCancel) do
          begin
            try

              try

                Log(Format('Gathering table "%s" data, please wait...',
                  [Tables[TableIdx]]));

                if Assigned(FOnDatabaseProgress) then
                begin
                  FOnDatabaseProgress(Self, CalculatePercentage(TableIdx + 1,
                    Tables.Count), 'Table: ' + Tables[TableIdx], FCancel);
                end;
                if Assigned(FOnTotalProgress) then
                begin
                  FOnTotalProgress(Self,
                    CalculatePercentage(CalculatePercentage(TableIdx + 1,
                    Tables.Count) + (DatabaseIdx * 100), (Databases.Count - 1) *
                    100), 'Database: ' + Databases[DatabaseIdx], FCancel);
                end;
                if Assigned(FOnItemProgress) then
                begin
                  FOnItemProgress(Self, 0, 'Opening...', FCancel);
                end;
                if FMySQLBackupType = btFullBackup then
                begin
                  AddLine('--');
                  AddLine('-- Table Structure: ' + Tables[TableIdx]);
                  AddLine('--');
                  AddLine('DROP TABLE IF EXISTS `' + Tables[TableIdx] + '`;');
                  AddLine(FMySQLDataBackupData.GetTableCreate
                    (Tables[TableIdx]));
                  AddLine('--');
                end;
                FMySQLDataBackupData.GetTableRecords(Tables[TableIdx]);
                if not FMySQLDataBackupData.IsEmpty then
                begin
                  Log(Format('Dumping %d record(s)',
                    [FMySQLDataBackupData.RecordCount]));
                  AddLine('--');
                  AddLine('-- Table Data: ' + Tables[TableIdx]);
                  AddLine('-- Records: ' +
                    IntToStr(FMySQLDataBackupData.RecordCount));
                  AddLine('--');

                  AddLine('/*!40000 ALTER TABLE `' + Tables[TableIdx] +
                    '` DISABLE KEYS */;');
                  ScriptLineCount := 1;
                  NewScriptLine := True;
                  ForceNewScriptLine := False;
                  while (not FMySQLDataBackupData.EOF) and (not FCancel) do
                  begin
                    if (NewScriptLine) then
                    begin
                      ScriptLine := 'INSERT IGNORE `' +
                        Tables[TableIdx] + '` (';
                      for FieldIdx :=
                        0 to Pred(FMySQLDataBackupData.FieldCount) do
                      begin
                        if FieldIdx <> 0 then
                        begin
                          ScriptLine := ScriptLine + ',';
                        end;
                        ScriptLine := ScriptLine + '`' +
                          FMySQLDataBackupData.Fields[FieldIdx].FieldName + '`';
                      end;
                      ScriptLine := ScriptLine + ') VALUES ';
                    end;

                    if Assigned(FOnItemProgress) then
                    begin
                      FOnItemProgress(Self,
                        CalculatePercentage(FMySQLDataBackupData.RecNo,
                        FMySQLDataBackupData.RecordCount),
                        Format('Record %d / %d', [FMySQLDataBackupData.RecNo,
                        FMySQLDataBackupData.RecordCount]), FCancel);
                    end;
                    ScriptLine := ScriptLine + '(';
                    for FieldIdx :=
                      0 to Pred(FMySQLDataBackupData.FieldCount) do
                    begin
                      if FieldIdx <> 0 then
                      begin
                        ScriptLine := ScriptLine + ',';
                      end;
                      if FMySQLDataBackupData.Fields[FieldIdx].IsNull then
                      begin
                        ScriptLine := ScriptLine + 'NULL';
                      end
                      else
                      begin
                        case FMySQLDataBackupData.Fields[FieldIdx].DataType of
                          ftInteger, ftLargeint, ftSmallint, ftAutoInc,
                            ftCurrency, ftFloat:
                            begin
                              ScriptLine := ScriptLine +
                                VarToStrDef
                                (FMySQLDataBackupData.Fields[FieldIdx]
                                .AsVariant, 'NULL');
                            end;
                          ftDate, ftTime, ftDateTime:
                            begin
                              DateFormatStr := 'yyyy-mm-dd hh:nn:ss';
                              if FMySQLDataBackupData.Fields[FieldIdx]
                                .DataType = ftDate then
                              begin
                                DateFormatStr := 'yyyy-mm-dd';
                              end;
                              if FMySQLDataBackupData.Fields[FieldIdx]
                                .DataType = ftTime then
                              begin
                                DateFormatStr := 'hh:nn:ss';
                              end;

                              ScriptLine := ScriptLine +
                                QuotedStr(FormatDateTime(DateFormatStr,
                                FMySQLDataBackupData.Fields[FieldIdx]
                                .AsDateTime));
                            end;

                          ftBlob:
                            begin
                              Debug('Execute',
                                'Blob field: ' + FMySQLDataBackupData.Fields
                                [FieldIdx].FieldName);
                              BlobStream.Clear;
                              BlobHexStr := '';
                              FMySQLDataBackupData.LoadFromBlob
                                (FMySQLDataBackupData.Fields[FieldIdx],
                                BlobStream);
                              BlobStream.Seek(0, soFromBeginning);
                              while BlobStream.Position < BlobStream.Size do
                              begin
                                BlobStream.Read(BlobByte, 1);
                                BlobHexStr := BlobHexStr +
                                  (IntToHex(BlobByte, 2));
                              end;
                              if BlobHexStr <> '' then
                              begin
                                ScriptLine := ScriptLine + '_binary 0x' +
                                  BlobHexStr;
                                // Debug('Execute', 'Blob field: ' + BlobHexStr);
                                // ScriptLineCount := FMaxRowCount;
                                ForceNewScriptLine := True;
                                Debug('Execute',
                                  'Blob field: Forcing new script line.');
                              end
                              else
                              begin
                                ScriptLine := ScriptLine + 'NULL';
                                Debug('Execute', 'Blob field: Empty');
                              end;
                            end;
                          ftString, ftWideString, ftMemo, ftFmtMemo, ftWideMemo:
                            begin
                              ScriptLine := ScriptLine +
                                EscapeString
                                (VarToStrDef(FMySQLDataBackupData.Fields
                                [FieldIdx].AsVariant, ''));

                            end;
                        else
                          begin
                            ScriptLine := ScriptLine + 'NULL';
                          end;
                        end;
                      end;
                    end;
                    ScriptLine := ScriptLine + ')';
                    FMySQLDataBackupData.Next;

                    if FMaxCharLineCount > 0 then
                    begin
                      if (Length(ScriptLine) >= FMaxCharLineCount) then
                      begin
                        Debug('Execute',
                          Format('Script line is greater than %d, forcing new script line.',
                          [FMaxCharLineCount]));
                        ForceNewScriptLine := True;
                      end;
                    end;

                    NewScriptLine := (ScriptLineCount >= FMaxRowCount) or
                      (FMySQLDataBackupData.EOF) or (ForceNewScriptLine);

                    if (NewScriptLine) then
                    begin
                      ScriptLine := ScriptLine + ';';
                      if ForceNewScriptLine then
                      begin
                        Debug('Execute',
                          Format('Script Line %d, New line forced.',
                          [ScriptLineCount]));
                      end;
                      if FMySQLDataBackupData.EOF then
                      begin
                        Debug('Execute', Format('Script Line %d, Last record.',
                          [ScriptLineCount]));
                      end;
                      if ScriptLineCount >= FMaxRowCount then
                      begin
                        Debug('Execute',
                          Format('Script Line %d, Maximum row count reached %d.',
                          [ScriptLineCount, FMaxRowCount]));
                      end;
                      AddLine(ScriptLine);
                      ScriptLineCount := 1;
                    end
                    else
                    begin
                      ScriptLine := ScriptLine + ',';
                      // Debug('Execute', Format('Script Line %d', [ScriptLineCount]));
                      Inc(ScriptLineCount);
                    end;
                  end;
                  AddLine('/*!40000 ALTER TABLE `' + Tables[TableIdx] +
                    '` ENABLE KEYS */;');
                end;
                if Assigned(FOnItemProgress) then
                begin
                  FOnItemProgress(Self, 100, 'Complete', FCancel);
                end;

              except
                on E: Exception do
                begin
                  Log(Format('Error: %s (SQL: %s)',
                    [E.Message, FMySQLDataBackupData.SQL.Text]));
                  AddLine('');
                  AddLine('-- Error: ' + E.Message);
                  AddLine('-- Table: ' + Tables[TableIdx]);
                  AddLine('');
                end;
              end;
            finally
              Inc(TableIdx);
            end;
          end;
          if Assigned(FOnDatabaseProgress) then
          begin
            if not FCancel then
            begin
              FOnDatabaseProgress(Self, 100, 'Complete', FCancel);
            end
            else
            begin
              FOnDatabaseProgress(Self, 100, 'Cancelled', FCancel);
            end;
          end;
          Inc(DatabaseIdx);
        end;
        if not FCancel then
        begin
          AddScriptFooter;
          Result := True;
        end;
        if Result then
        begin
          Log('Backup completed in ' + IntToStr(SecondsBetween(Now, Timer)) +
            ' second(s)');
        end
        else
        begin
          Log('Backup failed');
        end;
      end
      else
      begin
        Log('Backup failed: Failed to create SQL backup file.');
      end;
    except
      on E: Exception do
      begin
        Log('Backup failed: ' + E.Message);
        Log('Error: ' + E.Message);
        Result := False;
      end;
    end;
{$I-}
    CloseFile(FScript);
{$I+}
  finally
    FreeAndNil(Tables);
    FreeAndNil(Databases);
    FreeAndNil(BlobStream);
    FInProgress := False;
  end;
end;

end.
