unit ServerMethods_Monitoring_Unit;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth, Forms,
  Data.DBXJSON, Data.DBXJSONCommon, Ora, Data.DB, DateUtils, System.IOUtils,
  System.strUtils, Graphics, GraphUtil, PngImage, GIFImg, Jpeg,  DateUtils,
  Datasnap.DSService;

type
{$METHODINFO ON}
  TServerMethods_Monitoring = class(TComponent)
  private
    { Private declarations }
    FID: string;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Logout;

    // 힘센 모니터링 시스템
    function Get_Data_Column(aKey, aProjNo: String): String;
    function Get_Mon_Engine_List: TJSONArray;
    function Check_Engine_Running(aTable, aTime: String): Boolean;
    function Check_Engine_Running2(aTable: String; aTime: TDateTime): Boolean;
    function Get_Mon_keyMap(aProjNo: String): TJSONObject;
    function Get_Mon_Values(aTable, aDateTime: String): TJSONObject;

  end;
{$METHODINFO OFF}

implementation

uses
  IdCoderMIME,
  GUID_Utils_Unit,
  DataModule_Unit;


function TServerMethods_Monitoring.Check_Engine_Running(aTable,
  aTime: String): Boolean;
var
  OraQuery: TOraQuery;
  lKeyColumn: String;
  lEngSpeed: String;
  lTime: String;
begin
  Result := False;
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    try
      with OraQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT MAX(DATASAVEDTIME) DATASAVEDTIME FROM ' + aTable);
        Open;

        if RecordCount <> 0 then
        begin
          lTime := FieldByName('DATASAVEDTIME').AsString;
          lTime := Copy(lTime, 1, 13);

          if SameText(lTime, aTime) then
            Result := True
          else
            Result := False;
        end
        else
          Result := False;
      end;
    except
      Result := False;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TServerMethods_Monitoring.Check_Engine_Running2(aTable: String;
  aTime: TDateTime): Boolean;
var
  OraQuery: TOraQuery;
  lTime: String;
  Fmt: TFormatSettings;
  ldt: TDateTime;
begin
  Result := False;
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    try
      with OraQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT MAX(DATASAVEDTIME) DATASAVEDTIME FROM ' + aTable);
        Open;

        if RecordCount <> 0 then
        begin
          fmt.ShortDateFormat:='yyyymmdd';
          fmt.DateSeparator  :='';
          fmt.LongTimeFormat :='hhnnss';
          fmt.TimeSeparator  :='';
          lTime := FieldByName('DATASAVEDTIME').AsString;
          ldt := StrToDateTime(lTime, fmt);
//          lTime := Copy(lTime, 1, 13);

          if SameText(lTime, aTime) then
            Result := True
          else
            Result := False;
        end
        else
          Result := False;
      end;
    except
      Result := False;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

constructor TServerMethods_Monitoring.Create(AOwner: TComponent);
begin
  inherited;
  FID := GetNewGUID;

end;

destructor TServerMethods_Monitoring.Destroy;
begin
  inherited;

end;

function TServerMethods_Monitoring.Get_Data_Column(aKey,
  aProjNo: String): String;
var
  OraQuery: TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT DATA_COLUMN FROM MON_KEY A, MON_MAP B ' +
        'WHERE A.KEY = :param1 ' + 'AND B.DATA_ENGPROJNO = :param2 ' +
        'AND A.KEY = B.KEY ');

      ParamByName('param1').AsString := aKey;
      ParamByName('param2').AsString := aProjNo;
      Open;

      Result := FieldByName('DATA_COLUMN').AsString;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TServerMethods_Monitoring.Get_Mon_Engine_List: TJSONArray;
var
  lprojNo, lengType, ltable, lstate, lTime, aTime: String;

  lJsonObj: TJSONObject;
begin
  Result := TJSONArray.Create;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM MON_TABLES ' + 'ORDER BY ENG_PROJNO ');
    Open;

    if RecordCount <> 0 then
    begin
      while not eof do
      begin
        lprojNo := FieldByName('ENG_PROJNO').AsString; // ProjNo
        lengType := FieldByName('ENG_TYPE').AsString; // EngType
        ltable := FieldByName('OWNER').AsString + '.' +
          FieldByName('TABLE_NAME').AsString;

        lTime := FormatDateTime('YYYYMMDDHHmmss', Now);
        lTime := Copy(lTime, 1, 13);

        if Check_Engine_Running(ltable, lTime) then
          lstate := 'RUN'
        else
          lstate := 'STOP';

        lJsonObj := TJSONObject.Create;
        Result.Add(lJsonObj.AddPair('STATE', lstate).AddPair('ENGPROJ', lprojNo)
          .AddPair('ENGTYPE', lengType).AddPair('DATATABLE', ltable));

        Next;
      end;
    end;
  end;
end;

function TServerMethods_Monitoring.Get_Mon_keyMap(aProjNo: String)
  : TJSONObject;
var
  OraQuery: TOraQuery;
  lStr: String;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM MON_MAP ' +
              'WHERE DATA_ENGPROJNO = :param1 ' + 'ORDER BY SEQ_NO ');
      ParamByName('param1').AsString := aProjNo;
      Open;

      if RecordCount <> 0 then
      begin
        Result := TJSONObject.Create;
        while not eof do
        begin
          if NOT(FieldByName('KEY').IsNull) AND
            NOT(FieldByName('DATA_COLUMN').IsNull) then
          begin
            Result.AddPair(FieldByName('KEY').AsString,
              FieldByName('DATA_COLUMN').AsString);
            Next;
          end;
        end;
        lStr := Result.ToString;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TServerMethods_Monitoring.Get_Mon_Values(aTable,
  aDateTime: String): TJSONObject;
var
  OraQuery: TOraQuery;
  li: Integer;
  lplcTable, lwt500Table, lCurrTime, l5SecAgo, times, query: String;
  lDateTime: TDateTime;

begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    lDateTime := StrToDateTime(aDateTime);
    times := FormatDateTime('YYYYMMDDHHmm', lDateTime);
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM ' + aTable + ' ' + 'WHERE DATASAVEDTIME = ( ' +
        'SELECT MAX(DATASAVEDTIME) FROM ' + aTable + ' ' +
        'WHERE DATASAVEDTIME LIKE :param1 )');
      ParamByName('param1').AsString := times + '%';
      // ParamByName('param1').AsString := '201307151626%';
      Open;

      Result := TJSONObject.Create;
      if RecordCount <> 0 then
      begin
        for li := 0 to Fields.Count - 1 do
          Result.AddPair(Fields[li].FieldName, Fields[li].AsString);
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TServerMethods_Monitoring.Logout;
var
  LSession: TDSSession;
begin
  LSession := TDSSessionManager.GetThreadSession;
  if LSession <> nil then
  begin
//    TctManager.Instance.RemoveUser(LSession.GetData('username'));
    TDSSessionManager.Instance.CloseSession(LSession.SessionName);
  end;
end;

end.
