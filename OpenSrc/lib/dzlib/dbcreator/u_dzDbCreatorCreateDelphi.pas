///<summary> Creates Delphi code to create a database description
///          Note: Not finished yet! </summary>
unit u_dzDbCreatorCreateDelphi;

interface

uses
  SysUtils,
  Classes,
  u_dzDbCreatorBase,
  u_dzDbCreatorDescription;

const
  SECT_HEAD = 0;
  SECT_CONST = 1;
  SECT_VAR = 2;
  SECT_BODY = 3;
  SECT_END = 4;

type
  TDelphiOutput = class
  protected
    FSections: array[SECT_HEAD..SECT_END] of TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(_Section: integer; const _Line: string);
  end;

type
  TDelphiDbCreator = class(TInterfacedObject, IdzDbCreator)
  private
  protected
    FTableIdx: integer;
    FColumnIdx: integer;
    FFilename: string;
    FDescriptions: TInterfaceList;
    function GetNextTableId: string;
    function GetNextColId: string;
    procedure WriteDb(_Output: TDelphiOutput; const _DbDesc: IdzDbDescription);
    procedure WriteTable(_Output: TDelphiOutput; const _TblDesc: IdzDbTableDescription);
    procedure WriteColumn(_Output: TDelphiOutput; const _TableId: string; const _ColDesc: IdzDbColumnDescription);
    procedure CleanupDb(const _DbDesc: IdzDbDescription);
    // implements IdzDbCreator
    procedure Commit;
    procedure AddDbDesc(const _DbDescription: IdzDbDescription);
    procedure WriteDbDesc(const _DbDescription: IdzDbDescription; const _Version: IdzDbVersionNTypeAncestor);
  public
    constructor Create(const _Filename: string);
    destructor Destroy; override;
  end;

implementation

uses
  u_dzMiscUtils;

{ TDelphiOutput }

constructor TDelphiOutput.Create;
var
  i: integer;
begin
  inherited Create;
  for i := low(FSections) to high(FSections) do
    FSections[i] := TStringList.Create;
end;

destructor TDelphiOutput.Destroy;
var
  i: integer;
begin
  for i := high(FSections) downto low(FSections) do
    FSections[i].Free;
  inherited;
end;

procedure TDelphiOutput.Add(_Section: integer; const _Line: string);
begin
  FSections[_Section].Add(_Line);
end;

{ TDelphiDbCreator }

constructor TDelphiDbCreator.Create(const _Filename: string);
begin
  inherited Create;
  FFilename := _Filename;
  FDescriptions := TInterfaceList.Create;
end;

destructor TDelphiDbCreator.Destroy;
begin
  FDescriptions.Free;
  inherited;
end;

procedure TDelphiDbCreator.AddDbDesc(const _DbDescription: IdzDbDescription);
begin
  FDescriptions.Add(_DbDescription);
end;

procedure TDelphiDbCreator.Commit;
var
  i: integer;
  DbDesc: IdzDbDescription;
  Output: TDelphiOutput;
begin
  FTableIdx := 0;
  FColumnIdx := 0;
  Output := TDelphiOutput.Create;
  try
    for i := 0 to FDescriptions.Count - 1 do begin
      DbDesc := FDescriptions[i] as IdzDbDescription;
      WriteDb(Output, DbDesc);
    end;
  finally
    Output.Free;
  end;
end;

procedure TDelphiDbCreator.WriteDb(_Output: TDelphiOutput; const _DbDesc: IdzDbDescription);
var
  i: integer;
  TblDesc: IdzDbTableDescription;
begin
  _Output.Add(SECT_HEAD, Format('procedure CreateNew%sDB(const _DbDesc: IdzDbDescription);', [_DbDesc.Name]));
  _Output.Add(SECT_VAR, {     } 'var');
//  _Output.Add(SECT_VAR, {     }'  Column: IdzDbColumnDescription;');
  _Output.Add(SECT_BODY, {    } 'begin');
  for i := 0 to _DbDesc.TableCount - 1 do begin
    TblDesc := _DbDesc.Tables[i];
    WriteTable(_Output, TblDesc);
  end;
  _Output.Add(SECT_END, {     } 'end;');
  _Output.Add(SECT_END, {     } '');
  CleanupDb(_DbDesc);
end;

procedure TDelphiDbCreator.CleanupDb(const _DbDesc: IdzDbDescription);
var
  tbl: integer;
  col: integer;
  TblDesc: IdzDbTableDescription;
  ColDesc: IdzDbColumnDescription;
begin
  for tbl := 0 to _DbDesc.TableCount - 1 do begin
    TblDesc := _DbDesc.Tables[tbl];
    StrDispose(PChar(TblDesc.Data));
    for col := 0 to TblDesc.ColumnCount - 1 do begin
      ColDesc := TblDesc.Columns[col];
      StrDispose(PChar(ColDesc.Data));
    end;
  end;
end;

function TDelphiDbCreator.GetNextTableId: string;
begin
  Result := IntToStr(FTableIdx);
  Inc(FTableIdx);
end;

function TDelphiDbCreator.GetNextColId: string;
begin
  Result := IntToStr(FColumnIdx);
  Inc(FColumnIdx);
end;

procedure TDelphiDbCreator.WriteTable(_Output: TDelphiOutput; const _TblDesc: IdzDbTableDescription);
var
  i: integer;
  TableId: string;
  ColDesc: IdzDbColumnDescription;
begin
  TableId := GetNextTableId;
  _TblDesc.Data := StrNew(PChar(TableId));
  _Output.Add(SECT_VAR, Format('  Table%s: IdzDbTableDescription;', [TableId]));
  _Output.Add(SECT_BODY, Format('  Table%s := _DbDesc.AppendTable(%s)', [TableId, _TblDesc.Name]));
  for i := 0 to _TblDesc.ColumnCount - 1 do begin
    ColDesc := _TblDesc.Columns[i];
    WriteColumn(_Output, TableId, ColDesc);
  end;
end;

procedure TDelphiDbCreator.WriteColumn(_Output: TDelphiOutput; const _TableId: string; const _ColDesc: IdzDbColumnDescription);
var
  ColId: string;
begin
  ColId := GetNextColId;
  _Output.Add(SECT_VAR, Format('  Column%s: IdzDbColumnDescription;', [ColId]));
//  _ColDesc.Name;
//  _ColDesc.DataType
//  _ColDesc.Size;
//  _ColDesc.Comment;
//  _ColDesc.AllowNull
  _Output.Add(SECT_BODY, Format('  Column%s := Table%s.AppendColumn(%s, %s, %s, %s, %s);', []));
end;

//  IdxColumn :=
//    Table.AppendColumn(DSBESCHREIBUNG_ID_FIELD, dtLongInt, 0, 'primary key', naNotNull);
//  IdxColumn.AutoInc := true;
//  IdxColumn.Indexed := itPrimaryKey;
//  DatenserieIdxColumn := IdxColumn;
//  IdxColumn := Table.AppendColumn(DSBESCHREIBUNG_NAME_FIELD, dtText, 50, 'Name der Datenserie', naNotNull);
//  IdxColumn.Indexed := itUnique;
//  Table.AppendColumn(DSBESCHREIBUNG_KOMMENTAR_FIELD, dtMemo, 255, 'zusaetzliche Angaben', naNull);
//  Table.AppendColumn(DSBESCHREIBUNG_ANGELEGT_FIELD, dtDate, 0, 'Datum und Uhrzeit der Erstellung', naNotNull);
//  Table.AppendColumn(DSBESCHREIBUNG_GEAENDERT_FIELD, dtDate, 0, 'Datum und Uhrzeit der letzten Aenderung', naNotNull);
//  Table.AppendColumn(DSBESCHREIBUNG_ANGELEGTACCOUNT_FIELD, dtText, 20, 'Account, der sie erstellt hat', naNotNull);
//  Table.AppendColumn(DSBESCHREIBUNG_ANGELEGTUSERNAME_FIELD, dtText, 20, 'Username, der sie erstellt hat', naNull);
//  Table.AppendColumn(DSBESCHREIBUNG_GEAENDERTACCOUNT_FIELD, dtText, 20, 'Account, der sie zuletzt geaendert hat', naNotNull);
//  Table.AppendColumn(DSBESCHREIBUNG_GEAENDERTUSERNAME_FIELD, dtText, 20, 'Username, der sie zuletzt geaendert hat', naNull);
//  DatenserieTable := Table;

procedure TDelphiDbCreator.WriteDbDesc(const _DbDescription: IdzDbDescription;
  const _Version: IdzDbVersionNTypeAncestor);
begin
  raise Exception.Create('Not Implemented');
end;

end.

