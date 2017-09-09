unit c_dzAdoConnection;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Db,
  ADODB;

type
  TAdoServerType = (asUnknown, asJet, asMsSql, asOracle);

type
  TConnectionInfoRec = record
    ServerType: TAdoServerType;
    ServerName: string;
    Database: string;
    Username: string;
    Parts: array of string;
  end;

type
  ///<summary> This TAdoConnection descendant solves the problem of Connections
  ///          staying open when opened in the designer. The Connected property
  ///          will never be saved to the .DFM file and therefore always be false.
  ///          In addition it allows to detect the database type based on the connection
  ///          string and exposes the ADO dialog for editing a connection string
  TdzAdoConnection = class(TADOConnection)
  public
    function EditConnectionString(_ParentHandle: THandle): boolean; overload;
    class function EditConnectionString(_ParentHandle: THandle; var _ConnectionString: string): boolean; overload;
    function DetermineServerType: TAdoServerType; overload;
    class function DetermineServerType(const _ConnectionString: string): TAdoServerType; overload;
    class function SplitConnectionString(const _ConnectionString: string): TConnectionInfoRec;
  published
    procedure ClearConnectionObject;
    property Connected stored false;
  end;

implementation

uses
  ActiveX,
  ComObj,
  OleDB,
  AdoInt,
  StrUtils;

{ THkAdoConnection }

class function TdzAdoConnection.DetermineServerType(const _ConnectionString: string): TAdoServerType;
begin
  if AnsiContainsText(_ConnectionString, 'Provider=OraOLEDB.Oracle') then
    Result := asOracle
  else if AnsiContainsText(_ConnectionString, 'Provider=SQLOLEDB') then
    Result := asMsSql
  else if AnsiContainsText(_ConnectionString, 'Provider=Microsoft.Jet.OLEDB') then
    Result := asJet
  else
    Result := asUnknown;
end;

function TdzAdoConnection.DetermineServerType: TAdoServerType;
begin
  Result := DetermineServerType(ConnectionString);
end;

class function TdzAdoConnection.EditConnectionString(_ParentHandle: THandle; var _ConnectionString: string): boolean;
var
  DataInit: IDataInitialize;
  DBPrompt: IDBPromptInitialize;
  DataSource: IUnknown;
  InitStr: PWideChar;
  s: WideString;
begin
  DataInit := CreateComObject(CLSID_DataLinks) as IDataInitialize;
  if _ConnectionString <> '' then begin
    s := _ConnectionString;
    DataInit.GetDataSource(nil, CLSCTX_INPROC_SERVER,
      PWideChar(s), IUnknown, DataSource);
  end;
  DBPrompt := CreateComObject(CLSID_DataLinks) as IDBPromptInitialize;
  Result := Succeeded(DBPrompt.PromptDataSource(nil, _ParentHandle,
    DBPROMPTOPTIONS_PROPERTYSHEET, 0, nil, nil, IUnknown, DataSource));
  if Result then begin
    InitStr := nil;
    DataInit.GetInitializationString(DataSource, True, InitStr);
    _ConnectionString := InitStr;
  end;
end;

class function TdzAdoConnection.SplitConnectionString(const _ConnectionString: string): TConnectionInfoRec;
var
  sl: TStringList;
  s: string;
  i: Integer;
begin
  Result.Username := '';
  Result.Database := '';
  Result.ServerName := '';
  Result.ServerType := DetermineServerType(_ConnectionString);
  sl := TStringList.Create;
  try
    sl.Delimiter := ';';
    sl.StrictDelimiter := true;
    sl.DelimitedText := _ConnectionString;
    SetLength(Result.Parts, sl.Count);
    for i := 0 to sl.Count - 1 do begin
      Result.Parts[i] := sl[i];
      s := sl.Names[i];
      if SameText(s, 'User ID') then
        Result.Username := sl.Values[s]
      else if SameText(s, 'Data Source') then
        Result.ServerName := sl.Values[s]
      else if SameText(s, 'Initial Catalog') then
        Result.Database := sl.Values[s];
    end;
  finally
    sl.Free;
  end;
end;

function TdzAdoConnection.EditConnectionString(_ParentHandle: THandle): boolean;
var
  s: string;
begin
  s := ConnectionString;
  Result := EditConnectionString(_ParentHandle, s);
  if Result then
    ConnectionString := s;
end;

procedure TdzAdoConnection.ClearConnectionObject;
var
  DummyConnection: ADOINT._Connection;
begin
  DummyConnection := CoConnection.Create;
  ConnectionObject := DummyConnection;
end;

end.

