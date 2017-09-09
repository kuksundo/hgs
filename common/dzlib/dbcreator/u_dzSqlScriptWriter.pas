{.GXFormatter.config=twm}
unit u_dzSqlScriptWriter;

interface

uses
  SysUtils,
  Classes,
  u_dzDbCreatorBase,
  u_dzDbCreatorDescription,
  u_dzScriptPositionList,
  u_dzConfigSettingList;

type
  ESqlScriptWriter = class(Exception);
  EInvalidPosition = class(ESqlScriptWriter);
  EUnknownVariableId = class(ESqlScriptWriter);
  ENoVersionSet = class(ESqlScriptWriter);

type
  TDataTypeMapping = array[TFieldDataType] of string;
  TNullAllowedMapping = array[TNullAllowed] of string;

type
  ISqlScriptWriter = interface ['{5192E472-F41A-4D18-93B0-2E890AE31AAA}']
    procedure WriteLine(_Position: TScriptPosition; const _Line: string = '');
    procedure Write(const _Version: IdzDbVersionNTypeAncestor);
    procedure SetPrefix(const _Prefix: string);
    function GetPrefix: string;
    procedure WriteTermLine(_Position: TScriptPosition; const _Line: string = '');
    function GatDatabaseName: string;
    procedure SetDatabaseName(const _DatabaseName: string);
    procedure Clear;
    procedure SetProgramm(const _Identifier, _Name: string);
    procedure AddSetting(const _Name, _Value: string);
    property Prefix: string read GetPrefix write SetPrefix;
    property DatabaseName: string read GatDatabaseName write SetDatabaseName;
  end;

type
  TdzSqlScriptWriter = class(TInterfacedObject, ISqlScriptWriter)
  private
  protected
    FDbDescription: IdzDbDescription;
    FStatements: TStringList;
    FPrefix: string;
    FScriptSections: TStringList;
    FScriptPositions: TScriptPositionDescList;
    FDatabaseName: string;
    FCurrTable: string;
    FProgIdentifier: string;
    FProgName: string;
    FConfigSettings: TConfigSettingList;

  private // implements ISqlSqriptWriter
    procedure WriteLine(_Position: TScriptPosition; const _Line: string = '');
    procedure WriteTermLine(_Position: TScriptPosition; const _Line: string = '');
    //    function Terminator: string; virtual;
    procedure Write(const _Version: IdzDbVersionNTypeAncestor);
    procedure SetPrefix(const _Prefix: string); virtual;
    function GetPrefix: string; virtual;
    function GatDatabaseName: string; virtual;
    procedure SetDatabaseName(const _DatabaseName: string); virtual;
    procedure AddSetting(const _Name, _Value: string);
    procedure SetProgramm(const _Identifier, _Name: string);
    procedure Clear;
  public
    constructor Create(const _Statements: TStringList);
    destructor Destroy; override;
  end;

type
  IdzSqlTableCreator = interface(IdzTableCreator)['{24DE3259-DAE8-4630-9F05-7EA3F04D80EA}']
    procedure Commit(_ScriptWriter: ISqlScriptWriter);
  end;

type
  ///<summary> Creates a script for an sql based database, e.g. Oracle or MS-SQL </summary>
  TdzSqlDbCreator = class(TInterfacedObject)
  protected
    FNameCounter: integer;
    FScriptWriter: ISqlScriptWriter;
    FNames: TStringList;
    FStatements: TStringList;
    function CreateScriptWriter: ISqlScriptWriter; virtual;

    procedure WriteCreateTables(const _DbDescription: IdzDbDescription); virtual; abstract;
    procedure WriteSqlStatements(const _DbDescription: IdzDbDescription); virtual;
    procedure AdjustTableNames(const _DbDescription: IdzDbDescription; var _Statement: string); virtual;
    procedure AdjustTableName(const _DbDescription: IdzDbDescription; var _Statement: string); virtual;
    procedure WriteSqlDataStatements(const _DbDescription: IdzDbDescription; _ScriptWriter: ISqlScriptWriter); virtual; abstract;

    function GetDatabaseName: string;
    function GetPrefix: string;

    function MaxIdentifierLength: integer; virtual; abstract;
    function MakeName(const _TypePrefix, _First, _Second: string): string;
    function MakeFkName(const _Table, _RefTable: string): string;
    function MakeIndexName(const _Table, _Column: string): string;
    function MakePkName(const _Table, _Column: string): string;

    property Prefix: string read GetPrefix;
    property DatabaseName: string read GetDatabaseName;
    procedure WriteDbDesc(const _DbDescription: IdzDbDescription; const _Version: IdzDbVersionNTypeAncestor);
  public
    constructor Create(const _Statements: TStringList); overload;
    destructor Destroy; override;
  end;

implementation

uses
  StrUtils,
  RegExpr, // libs\tregexpr\source
  u_dzMiscUtils,
  u_dzClassUtils,
  u_dzLogging,
  u_dzStringUtils,
  u_dzVariableDescList;

  { TScriptSectionDesc }

type
  TScriptSectionDesc = class
  protected
    FName: string;
  public
    constructor Create(const _Name: string);
  end;

constructor TScriptSectionDesc.Create(const _Name: string);
begin
  inherited Create;
  FName := _Name;
end;

{ TdzSqlScriptWriter }

constructor TdzSqlScriptWriter.Create(const _Statements: TStringList);
begin
  inherited Create;
  FStatements := _Statements;

  FConfigSettings := TConfigSettingList.Create;

  FScriptSections := TStringList.Create;
  FScriptPositions := TScriptPositionDescList.Create;

  // die Reihenfolge der Sections hier entspricht der im Script
  FScriptSections.Append(SCRIPT_NAME_DROPTABLES);
  FScriptPositions.Add(TScriptPositionDesc.Create(spDropSequences, SCRIPT_NAME_DROPTABLES));
  FScriptPositions.Add(TScriptPositionDesc.Create(spDropPrimaryKeys, SCRIPT_NAME_DROPTABLES));
  FScriptPositions.Add(TScriptPositionDesc.Create(spDropIndices, SCRIPT_NAME_DROPTABLES));
  FScriptPositions.Add(TScriptPositionDesc.Create(spDropReferences, SCRIPT_NAME_DROPTABLES));
  FScriptPositions.Add(TScriptPositionDesc.Create(spDropTables, SCRIPT_NAME_DROPTABLES));

  FScriptSections.Append(SCRIPT_NAME_CREATETABLES);
  FScriptPositions.Add(TScriptPositionDesc.Create(spCreateSequences, SCRIPT_NAME_CREATETABLES));
  FScriptPositions.Add(TScriptPositionDesc.Create(spCreateTables, SCRIPT_NAME_CREATETABLES));
  FScriptPositions.Add(TScriptPositionDesc.Create(spCreateIndices, SCRIPT_NAME_CREATETABLES));
  FScriptPositions.Add(TScriptPositionDesc.Create(spCreatePrimaryKeys, SCRIPT_NAME_CREATETABLES));
  FScriptPositions.Add(TScriptPositionDesc.Create(spCreateReferences, SCRIPT_NAME_CREATETABLES));

  FScriptSections.Append(SCRIPT_NAME_INSERTDATA);
  FScriptPositions.Add(TScriptPositionDesc.Create(spInsertData, SCRIPT_NAME_INSERTDATA));
end;

destructor TdzSqlScriptWriter.Destroy;
begin
  FConfigSettings.Free;
  inherited;
end;

function TdzSqlScriptWriter.GatDatabaseName: string;
begin
  Result := FDatabaseName;
end;

procedure TdzSqlScriptWriter.SetDatabaseName(const _DatabaseName: string);
begin
  FDatabaseName := _DatabaseName;
end;

function TdzSqlScriptWriter.GetPrefix: string;
begin
  Result := FPrefix;
end;

procedure TdzSqlScriptWriter.SetPrefix(const _Prefix: string);
begin
  FPrefix := _Prefix;
end;

procedure TdzSqlScriptWriter.WriteLine(_Position: TScriptPosition; const _Line: string);
var
  Idx: integer;
begin
  if not FScriptPositions.Find(_Position, Idx) then
    raise EInvalidPosition.CreateFmt('Invalid position parameter (%d)', [Ord(_Position)]);
  (FScriptPositions[Idx] as TScriptPositionDesc).AddStatement(_Line);
end;

procedure TdzSqlScriptWriter.WriteTermLine(_Position: TScriptPosition; const _Line: string);
var
  Idx: integer;
begin
  if not FScriptPositions.Find(_Position, Idx) then
    raise EInvalidPosition.CreateFmt('Invalid position parameter (%d)', [Ord(_Position)]);
  // We do not want to append the terminator any more.
  //(fScriptPositions[Idx] as TScriptPositionDesc).AddTermStatement(_Line + Terminator);
  (FScriptPositions[Idx] as TScriptPositionDesc).AddTermStatement(_Line);
end;

procedure TdzSqlScriptWriter.SetProgramm(const _Identifier, _Name: string);
begin
  FProgIdentifier := _Identifier;
  FProgName := _Name;
end;

procedure TdzSqlScriptWriter.Write(const _Version: IdzDbVersionNTypeAncestor);

  procedure ReplaceVariables(const _Version: IdzDbVersionNTypeAncestor; _ToReplace: TStringList);
  var
    i: integer;
    Line: string;
    s: string;
    re: TRegExpr;
    Start: integer;
    Len: integer;
    Placeholder: string;
    Vari: IdzDbVariableDescription;
  begin
    re := TRegExpr.Create;
    try
      re.Expression := '\$\(([a-zA-Z][a-zA-Z0-9_]*?)\)';
      re.Compile;
      i := 0;
      while i < _ToReplace.Count do begin
        Line := _ToReplace[i];
        s := '';
        while re.Exec(Line) do begin
          Start := re.MatchPos[0];
          Len := re.MatchLen[0];
          Placeholder := re.Match[1];
          Vari := _Version.VariableByName(Placeholder);
          if assigned(Vari) then
            s := s + LeftStr(Line, Start - 1) + Vari.Value
          else begin
            LogWarning(Format('unknown placeholder %s', [Placeholder]));
            s := s + LeftStr(Line, Start + Len - 1);
          end;
          Line := TailStr(Line, Start + Len);
        end;
        _ToReplace[i] := s + Line;
        Inc(i);
      end;
    finally
      re.Free;
    end;
  end;

var
  si: integer;
  script: IdzDbScriptDescription;
  sidx: integer;
  j: integer;
  sp: TScriptPositionDesc;
  statements: TStringList;
begin
  statements := TStringList.Create;

  try
    for si := 0 to _Version.ScriptsCount - 1 do begin
      script := _Version.Scripts[si];
      if script.Active then begin
        statements.Clear;
        script.GetStatements(statements);

        sidx := FScriptSections.IndexOf(script.Name);
        if sidx <> -1 then begin
          for j := 0 to FScriptPositions.Count - 1 do begin
            sp := FScriptPositions[j] as TScriptPositionDesc;
            if (sp.ScriptSection = script.Name) then
              statements.AddStrings(sp.Statements);
          end;
        end;
        ReplaceVariables(_Version, statements);
        FStatements.AddStrings(statements);
      end;
    end;
  finally
    statements.Free;
  end;
end;

procedure TdzSqlScriptWriter.AddSetting(const _Name, _Value: string);
begin
  FConfigSettings.Add(TdzConfigSetting.Create(_Name, _Value));
end;

procedure TdzSqlScriptWriter.Clear;
var
  j: integer;
begin
  for j := 0 to FScriptPositions.Count - 1 do
    (FScriptPositions[j] as TScriptPositionDesc).Clear;
end;

{ TdzSqlDbCreator }

constructor TdzSqlDbCreator.Create(const _Statements: TStringList);
begin
  inherited Create;
  FNames := TStringList.Create;
  FNames.Sorted := true;
  FStatements := _Statements;
  FScriptWriter := CreateScriptWriter;
end;

destructor TdzSqlDbCreator.Destroy;
begin
  FNames.Free;
  inherited;
end;

function TdzSqlDbCreator.GetDatabaseName: string;
begin
  Result := ReplaceChars(FScriptWriter.DatabaseName, '-', '_');
end;

function TdzSqlDbCreator.GetPrefix: string;
begin
  Result := FScriptWriter.Prefix;
end;

procedure TdzSqlDbCreator.WriteSqlStatements(const _DbDescription: IdzDbDescription);
var
  i: integer;
  s: string;
  Statements: TStrings;
begin
  Statements := _DbDescription.SqlStatements;
  for i := 0 to Statements.Count - 1 do begin
    s := Statements[i];
    AdjustTableNames(_DbDescription, s);
    FScriptWriter.WriteTermLine(spInsertData, s);
  end;
end;

procedure TdzSqlDbCreator.AdjustTableName(const _DbDescription: IdzDbDescription;
  var _Statement: string);
begin
  // do nothing
end;

procedure TdzSqlDbCreator.AdjustTableNames(const _DbDescription: IdzDbDescription;
  var _Statement: string);
var
  Start: integer;
  Ende: integer;
  TableName: string;
begin
  Start := Pos('$(', _Statement);
  while Start > 0 do begin
    Ende := Start + 2;
    while (Ende <= Length(_Statement)) and (_Statement[Ende] <> ')') do
      Inc(Ende);
    if Ende > Length(_Statement) then
      exit;
    TableName := Copy(_Statement, Start + 2, Ende - Start - 2);
    AdjustTableName(_DbDescription, TableName);
    _Statement := LeftStr(_Statement, Start - 1) + TableName + TailStr(_Statement, Ende + 1);
    Start := Pos('$(', _Statement);
  end;
end;

function TdzSqlDbCreator.MakeName(const _TypePrefix, _First, _Second: string): string;
var
  First: string;
  Second: string;
  MaxLen: integer;
  Idx: integer;
begin
  // maximum length is 30, minus the database prefix minus the type prefix minus 2 underscores
  // minus the length of the current name counter value
  MaxLen := (MaxIdentifierLength - Length(Prefix) - Length(_TypePrefix) - 2 - Length(IntToStr(FNameCounter))) div 2;
  First := _First;
  if Length(First) > MaxLen then
    First := LeftStr(First, MaxLen);
  Second := _Second;
  if Length(Second) > MaxLen then
    Second := LeftStr(Second, MaxLen);
  Result := Format('%s_%s%s_%s', [_TypePrefix, Prefix, First, Second]);
  if FNames.Find(Result, Idx) then begin
    Result := Format('%s_%s%s_%s%d', [_TypePrefix, Prefix, First, Second, FNameCounter]);
    Inc(FNameCounter);
  end;
  FNames.Add(Result);
end;

function TdzSqlDbCreator.MakeIndexName(const _Table, _Column: string): string;
begin
  Result := MakeName('IX', _Table, _Column);
end;

function TdzSqlDbCreator.MakeFkName(const _Table, _RefTable: string): string;
begin
  Result := MakeName('FK', _Table, _RefTable);
end;

function TdzSqlDbCreator.MakePkName(const _Table, _Column: string): string;
begin
  Result := MakeName('PK', _Table, _Column);
end;

procedure TdzSqlDbCreator.WriteDbDesc(const _DbDescription: IdzDbDescription;
  const _Version: IdzDbVersionNTypeAncestor);
begin
  FScriptWriter.Clear;
  FScriptWriter.SetProgramm(_DbDescription.ProgIdentifier, _DbDescription.ProgName);
  FScriptWriter.Prefix := _DbDescription.Prefix;
  FScriptWriter.DatabaseName := _DbDescription.Name;
  WriteCreateTables(_DbDescription);
  WriteSqlDataStatements(_DbDescription, FScriptWriter);
  WriteSqlStatements(_DbDescription);
  FScriptWriter.Write(_Version);
end;

function TdzSqlDbCreator.CreateScriptWriter: ISqlScriptWriter;
begin
  Result := TdzSqlScriptWriter.Create(FStatements);
end;

end.

