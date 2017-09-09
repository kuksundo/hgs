unit u_dzDbCreatorCreateGraphViz;

interface

uses
  Windows,
  SysUtils,
  Classes,
  u_dzDbCreatorBase,
  u_dzDbCreatorDescription;

type
  TGraphVizDbCreator = class(TInterfacedObject, IdzDbCreator)
  private
    procedure WriteTable(const _Table: IdzDbTableDescription);
    procedure WriteFmt(const _Format: string; _Args: array of const);
    procedure WriteLn(const _s: string = '');
    procedure Write(const _s: string);
    procedure WriteLnFmt(const _Format: string; _Args: array of const);
    procedure Prepare(const _DbDescription: IdzDbDescription);
  protected
    fFilename: string;
    fLines: TStrings;
    fLine: string;
    fReferencedTablesOnly: boolean;
    fReferencedColumnsOnly: boolean;
    procedure WriteDbDesc(const _DbDescription: IdzDbDescription; const _Version: IdzDbVersionNTypeAncestor);
  public
    constructor Create(const _Filename: string; _ReferencedTablesOnly, _ReferencedColumnsOnly: boolean);
  end;

implementation

{ TGraphVizDbCreator }

constructor TGraphVizDbCreator.Create(const _Filename: string; _ReferencedTablesOnly, _ReferencedColumnsOnly: boolean);
begin
  inherited Create;
  fFilename := _Filename;
  fReferencedTablesOnly := _ReferencedTablesOnly;
  fReferencedColumnsOnly := _ReferencedColumnsOnly;
end;

procedure TGraphVizDbCreator.WriteFmt(const _Format: string; _Args: array of const);
begin
  Write(Format(_Format, _Args));
end;

procedure TGraphVizDbCreator.WriteLnFmt(const _Format: string; _Args: array of const);
begin
  WriteLn(Format(_Format, _Args));
end;

procedure TGraphVizDbCreator.Write(const _s: string);
begin
  fLine := fLine + _s;
end;

procedure TGraphVizDbCreator.WriteLn(const _s: string = '');
var
  i: integer;
  s: string;
begin
  s := fLine + _s;
  fLine := '';

  for i := 0 to fLines.Count - 1 do begin
    if AnsiSameStr(s, fLines[i]) then
      exit;
  end;
  fLines.Add(s);
end;

procedure TGraphVizDbCreator.WriteTable(const _Table: IdzDbTableDescription);
var
  ColIdx: integer;
  Column: IdzDbColumnDescription;
  PrimaryKeyColumn: string;
  pk: IdzDbIndexDescription;
  IndexIdx: integer;
  Index: IdzDbIndexDescription;
begin
  if fReferencedTablesOnly and not longBool(_Table.Data) then
    exit;

  // write node entry
  WriteFmt('  %0:s [label="%0:s', [_Table.Name]);
  pk := _Table.PrimaryKey;
  if Assigned(pk) then
    PrimaryKeyColumn := pk.Column[0].Name
  else
    PrimaryKeyColumn := '';
  for ColIdx := 0 to _Table.ColumnCount - 1 do begin
    Column := _Table.Columns[ColIdx];
    if LongBool(Column.Data) then begin
      if Column.Name = PrimaryKeyColumn then
        WriteFmt('|{<PK>PK|<%0:s>%0:s}', [Column.Name])
      else
        WriteFmt('|<%0:s>%0:s', [Column.Name]);
    end;
  end;
  Writeln('"]');

  // write edge entries
  for ColIdx := 0 to _Table.ColumnCount - 1 do begin
    Column := _Table.Columns[ColIdx];
    if Column.IsForeignKey then begin
      WriteLnFmt('  %0:s:%1:s -> %2:s:%3:s', [_Table.Name, Column.Name,
        Column.ForeignKeyTable.Name, 'PK' {Column.ForeignKeyColumn.Name}]);
    end;
  end;

  // write more edge entries (duplicates will be filtered out
  for IndexIdx := 0 to _Table.IndiceCount - 1 do begin
    Index := _Table.Indices[IndexIdx];
    if Index.IsForeignKey then begin
      Column := Index.Column[0];
      WriteLnFmt('  %0:s:%1:s -> %2:s:%3:s', [_Table.Name, Column.Name,
        Column.ForeignKeyTable.Name, 'PK']);
    end;
  end;
end;

procedure TGraphVizDbCreator.Prepare(const _DbDescription: IdzDbDescription);
var
  TblIdx: integer;
  Table: IdzDbTableDescription;
  ColIdx: integer;
  Column: IdzDbColumnDescription;
  IndexIdx: integer;
  Index: IdzDbIndexDescription;
  ColumnWanted: LongBool;
begin
  // exclude all tables and all columns (that is, if fReferencedTablesOnly or fReferencedColumnsOnly is true)
  for TblIdx := 0 to _DbDescription.TableCount - 1 do begin
    Table := _DbDescription.Tables[TblIdx];
    Table.Data := pointer(longbool(not fReferencedTablesOnly));
    for ColIdx := 0 to Table.ColumnCount - 1 do begin
      Column := Table.Columns[ColIdx];
      Column.Data := Pointer(LongBool(not fReferencedColumnsOnly));
    end;
  end;

  if fReferencedColumnsOnly or fReferencedTablesOnly then begin
    for TblIdx := 0 to _DbDescription.TableCount - 1 do begin
      Table := _DbDescription.Tables[TblIdx];

          // add a table's primary key
      Index := Table.PrimaryKey;
      if Assigned(Index) then
        Index.Column[0].Data := pointer(longbool(true));

          // add all tables a foreign key points to and of course the column and table itself
      for ColIdx := 0 to Table.ColumnCount - 1 do begin
        Column := Table.Columns[ColIdx];
        if Column.IsForeignKey then begin
          Table.Data := pointer(longbool(true));
          Column.Data := pointer(longbool(true));
          Column.ForeignKeyTable.Data := pointer(longbool(true));
          Column.ForeignKeyColumn.Data := pointer(longbool(true));
        end;
      end;

          // add all tables a foreign key index points to and of course the column and table itself
      for IndexIdx := 0 to Table.IndiceCount - 1 do begin
        Index := Table.Indices[IndexIdx];
        ColumnWanted := (Index.IsPrimaryKey) or (Index.IsForeignKey);
        if ColumnWanted then begin
          for ColIdx := 0 to Index.ColumnCount - 1 do begin
            Index.Column[ColIdx].Data := pointer(longbool(true));
          end;
          if Index.IsForeignKey then begin
            Table.Data := pointer(longbool(true));
            with Index.Column[0] do begin
              ForeignKeyColumn.Data := pointer(longbool(true));
              ForeignKeyTable.Data := pointer(longbool(true));
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TGraphVizDbCreator.WriteDbDesc(const _DbDescription: IdzDbDescription;
  const _Version: IdzDbVersionNTypeAncestor);
var
  i: integer;
  Table: IdzDbTableDescription;
begin
  Prepare(_DbDescription);
  fLines := TStringList.Create;
  try
    WriteLnFmt('DiGraph %s {', [_DbDescription.Name]);
    WriteLn('  rankdir = LR');
    WriteLn('  node[shape = "record"]');
    for i := 0 to _DbDescription.TableCount - 1 do begin
      Table := _DbDescription.Tables[i];
      WriteTable(Table);
    end;
    WriteLn('}');
    fLines.SaveToFile(fFilename);
  finally
    fLines.Free;
  end;
end;

end.

