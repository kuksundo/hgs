unit dbxQuery;

interface
{ The purpose of this Component is to make it easy to convert from
  TQuery to dbExpress,  It really is very similar to TSimpleDataset
  But it adds properties that match directly to TQuery.}
uses
  SysUtils, Variants, Classes, DB, DBCommon,  DBClient, Provider,
  SqlExpr, SqlTimSt, SQLConst;

type
  EDbxQuery = class(Exception);
  EParamDisparity = class(Exception);

  TdbxInternalSQLDataSet = class(TSQLQuery)    //TCustomSQLDataSet)
  protected
    procedure DoAfterScroll; override;
    procedure InternalClose; override;
  published
    property CommandText;
    property CommandType;
    property DataSource;
    property GetMetadata default false;
    property MaxBlobSize default 0;
    property ParamCheck;
    property Params;
    property SortFieldNames;
  end;

  TDWSParam = class helper for TParam
  private

  protected
    procedure SetAsOraDateTime(const Value: TDateTime);
    function GetAsOraDateTime: TDateTime;
    procedure SetAsOraFMTBCD(const Value: Extended);
    function GetAsOraFMTBCD: Extended;
  public
    property AsOraDateTime: TDateTime read GetAsOraDateTime write SetAsOraDateTime;
    property AsOraFMTBCD: Extended read GetAsOraFMTBCD write SetAsOraFMTBCD;
  end;

  TdbxCustomQuery = class(TCustomClientDataSet)
  private
    FRequestLive : Boolean;
    FSQL : TStringList;
    FAutoMaskCurrency:Boolean;
    FConnection: TSQLConnection;
    FDataSet: TdbxInternalSQLDataSet;
    FProvider: TDataSetProvider;
    FAutoApplyUpdates: Boolean;
    FUpdateMode: TUpdateMode;
    FKeyFields: string;
    FAutoMaskExcludeFields : TStringList;
    FOnRecError: TReconcileErrorEvent;    
    function InFmtExcludeList(FldName: String): boolean;
    procedure GetTextFormatBCDField(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure SetBCDFieldGetText(aDataSet: TDataSet;
      aMethod: TFieldGetTextEvent);
    function GetConnection: TSQLConnection;
    procedure SetAutoApplyUpdates(const Value: Boolean);
    //function GetParams: TParams;
    //procedure SetParams(const Value: TParams);
    function GetRequestLive: Boolean;
    procedure SetRequestLive(const Value: Boolean);
    function GetSQL: TStrings;
    procedure SetSQL(const Value: TStrings);

    procedure InternalReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError;
    UpdateKind: TUpdateKind; var Action: TReconcileAction);

  protected
    procedure CheckConnection;
    //procedure SetActive(Value: Boolean); override;
    procedure InternalInitFieldDefs; override;
    procedure CreateFields; override;
    procedure AllocDataSet; virtual;
    procedure AllocProvider; virtual;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure OpenCursor(InfoQuery: Boolean); override;
    //procedure CloseCursor; override;
    procedure SetConnection(Value: TSQLConnection); virtual;
    procedure DoAfterPost; override;
    procedure DoAfterDelete; override;
    { IProviderSupport }
    function PSGetCommandText: string; override;
    property DataSet: TdbxInternalSQLDataSet read FDataSet;
    procedure DoBeforeGetParams(var OwnerData: OleVariant); override;
    procedure OnProviderUpdate(Sender: TObject; DataSet: TCustomClientDataSet);
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    procedure WriteLog(value : String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property AutoMaskCurrency:boolean read FAutoMaskCurrency write FAutoMaskCurrency;
    property Connection: TSQLConnection read GetConnection write SetConnection;
    property SQL : TStrings read GetSQL write SetSQL;
    property RequestLive : Boolean read GetRequestLive write SetRequestLive default false;
    //property Params : TParams read GetParams write SetParams;
    property AutoApplyUpdates : Boolean read FAutoApplyUpdates write SetAutoApplyUpdates default true;
    procedure Prepare;
    function ExecSQL : Integer;
    function ParamByName(Name : String) : TParam;
    property UpdateMode: TUpdateMode read FUpdateMode write FUpdateMode default upWhereKeyOnly;
    property KeyFields: string read FKeyFields write FKeyFields;
    function FieldModified(FieldName : WideString):boolean;
    procedure RevertFieldValue(FieldName : WideString);
    procedure LogQueryDetails(E : Exception);
    property AutoMaskExcludeFields : TStringList read FAutoMaskExcludeFields;
  published
    //published properties here
    property OnReconcileError : TReconcileErrorEvent read FOnRecError write FOnRecError;
  end;

  TdbxQuery = class(TdbxCustomQuery)
  private
  public
    property Dataset;
  published
    property Connection;
    property SQL;
    property RequestLive;
    property Params;
    property AutoApplyUpdates;
    property Active;
    property Aggregates;
    property AggregatesActive;
    property AutoCalcFields;
    property Constraints;
    property DisableStringTrim;
    property FileName;
    property Filter;
    property Filtered;
    property FilterOptions;
    property FieldDefs;
    property IndexDefs;
    property IndexFieldNames;
    property IndexName;
    property FetchOnDemand;
    property MasterFields;
    property MasterSource;
    property ObjectView;
    property PacketRecords;
    property ReadOnly;
    property StoreDefs;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnFilterRecord;
    property OnNewRecord;
    property OnPostError;
    property BeforeApplyUpdates;
    property AfterApplyUpdates;
    property BeforeGetRecords;
    property AfterGetRecords;
    property BeforeRowRequest;
    property AfterRowRequest;
    property BeforeExecute;
    property AfterExecute;
    property BeforeGetParams;
    property AfterGetParams;
    property AutoMaskCurrency;
    property UpdateMode;
    property KeyFields;
    //property AutoMaskExcludeFields;     //un-comment this to allow entry at design-time
  end;


 implementation

uses FmtBcd, TypInfo;

{ TdbxQuery }

function TdbxCustomQuery.InFmtExcludeList(FldName : String):boolean;
begin
  Result := False;
  if (AutoMaskExcludeFields.IndexOf(FldName) >= 0) then
    Result := True;
end;

procedure TdbxCustomQuery.SetBCDFieldGetText(aDataSet:TDataSet;aMethod:TFieldGetTextEvent);
var x:integer;
    TmpStr:string;
begin
  for x := 0 to (aDataSet.Fields.Count - 1) do
  begin
    TmpStr := UpperCase(aDataSet.Fields[x].ClassName);
    if (((TmpStr = 'TBCDFIELD') or (TmpStr = 'TFMTBCDFIELD'))
      and ((aDataSet.Fields[x].Size = 2) or (aDataSet.Fields[x].Size = 8))
      and (not InFmtExcludeList(aDataSet.Fields[x].FieldName)))  then
         aDataSet.Fields[x].OnGetText := aMethod;
  end;
end;

procedure TdbxCustomQuery.GetTextFormatBCDField(Sender: TField; var Text: String; DisplayText: Boolean);
var TmpStr:string;
begin
  TmpStr := UpperCase(Sender.ClassName);
  if (((TmpStr = 'TBCDFIELD') or (TmpStr = 'TFMTBCDFIELD'))
     and ((Sender.Size = 2) or (Sender.Size = 8))) then
  begin
    if (Sender.DataSet.RecordCount < 1) then
      Text := ''
    else if (Sender.IsNull) then
      Text := '0.00'
    else
      Text := FormatFloat('#,0.00',Sender.AsFloat);
  end
  else
    Text := Sender.AsString;
end;

procedure TdbxCustomQuery.InternalInitFieldDefs;
begin
  inherited;
  if AutoMaskCurrency then
    SetBCDFieldGetText(Self,GetTextFormatBCDField);
end;

procedure TdbxCustomQuery.CreateFields;
begin
  inherited;
  if AutoMaskCurrency then
    SetBCDFieldGetText(Self,GetTextFormatBCDField);
end;

procedure TdbxCustomQuery.CheckConnection;
begin
  if not Assigned(FConnection) then
    raise EDbxQuery.Create('Required Connection Not Specified (' + self.Name + ')');
end;

constructor TdbxCustomQuery.Create(AOwner: TComponent);
begin
  inherited;
  FAutoMaskCurrency := True;
  FAutoApplyUpdates := true;
  FRequestLive := false;
  ReadOnly := True;
  FUpdateMode := upWhereKeyOnly;
  FSQL := TStringList.Create;
  FAutoMaskExcludeFields := TStringList.Create;
  AllocProvider;
  AllocDataSet;
  inherited OnReconcileError := InternalReconcileError;
end;

destructor TdbxCustomQuery.Destroy;
begin
  FSQL.Free;
  FAutoMaskExcludeFields.Clear;
  FAutoMaskExcludeFields.Free;
  inherited; { Reserved }
end;

procedure TdbxCustomQuery.DoAfterDelete;
begin
  if FAutoApplyUpdates then
     Self.ApplyUpdates(0);
  inherited;
end;

procedure TdbxCustomQuery.DoAfterPost;
begin
  if FAutoApplyUpdates then
     Self.ApplyUpdates(0);
  inherited;
end;

procedure TdbxCustomQuery.DoBeforeGetParams(var OwnerData: OleVariant);
begin
  if ((CommandText + #13#10) <> FSQL.Text) then
    CommandText := FSQL.Text;
  inherited;
end;

function TdbxCustomQuery.ExecSQL : Integer;
var x:integer;
    P: TParam;
begin
  CheckConnection;
  FDataSet.CommandText := FSQL.Text;
  try
    for x := 0 to (FDataSet.Params.Count - 1) do
    begin
      P := FDataSet.Params.FindParam(Params[X].Name);
      if P <> nil then
        P.Assign(Params[x]);
      FDataSet.Params[x].ParamType := Params[x].ParamType;
      FDataSet.Params[x].Size := Params[x].Size;
    end;
  except
    on E:exception do
      Raise EParamDisparity.Create('Parameter disparity found, parameters declared but not all parameters have a value.' + #13#10 + E.Message);
  end;
  try
  result := FDataSet.ExecSQL; //(false);
  except
    on e : Exception do
    begin
      LogQueryDetails(e);
      raise;
    end;
  end;
  if (FDataSet.Params.Count > 0) then
    Params.AssignValues(FDataSet.Params);
end;

function TdbxCustomQuery.FieldModified(FieldName: WideString): boolean;
begin
  Result := False;
  if (FieldByName(FieldName).OldValue <> FieldByName(FieldName).NewValue) then
    Result := True;
end;

function TdbxCustomQuery.GetConnection: TSQLConnection;
begin
  result := FConnection;
end;

function TdbxCustomQuery.GetRequestLive: Boolean;
begin
  result := FRequestLive;
end;

function TdbxCustomQuery.GetSQL: TStrings;
begin
  result := FSQL;
end;

procedure TdbxCustomQuery.Loaded;
begin
  inherited;
end;


procedure TdbxCustomQuery.LogQueryDetails(E : Exception);
var
 I : Integer;
 lParamStr : String;
begin
  try
  WriteLog(E.ClassName + ':' + E.Message);
  WriteLog(Name + '.SQL.Text :=');
  WriteLog(FSQL.Text);
  WriteLog('Params: ( ' + IntToStr(FDataSet.Params.Count) + ' ) ');
  for I := 0 to (FDataSet.Params.Count - 1) do
  begin
    lParamStr := IntToStr(I) + ' ' + FDataSet.Params[I].Name + ' : ' +
    GetEnumName(Typeinfo(TFieldType),Integer(FDataSet.Params[I].DataType)) + ' ' +
    GetEnumName(Typeinfo(TParamType),Integer(FDataSet.Params[I].ParamType)) + ' = ' +
    FDataset.Params[I].AsString;
    WriteLog(lParamStr);
  end;
  except
    // avoid this from ever producing errors as the error we are logging is more valuable than info on log failure
  end;
end;

procedure TdbxCustomQuery.AllocDataSet;
begin
  FDataSet := TdbxInternalSQLDataSet.Create(Self);
  FDataSet.Name := 'InternalDataSet';			{ Do not localize }
  FDataSet.SQLConnection := FConnection;
  //FDataSet.GetMetadata := True;  //don't do this, it makes the query take 20 times longer to run
  FDataSet.SetSubComponent(True);
  FProvider.DataSet := FDataSet;
end;

procedure TdbxCustomQuery.AllocProvider;
begin
  FProvider := TDataSetProvider.Create(Self);
  FProvider.Options := [poAllowCommandText];
  FProvider.DataSet := FDataSet;
  FProvider.Name := 'InternalProvider';			{ Do not localize }
  FProvider.SetSubComponent(True);
  FProvider.OnUpdateData := OnProviderUpdate;
  SetProvider(FProvider);
end;

procedure TdbxCustomQuery.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if ((aComponent = FConnection) and (Operation = opRemove)) then
  begin
    FConnection := nil;
    FDataSet.SQLConnection := nil;
  end;
end;

procedure TdbxCustomQuery.OnProviderUpdate(Sender: TObject;
  DataSet: TCustomClientDataSet);
var FldList : TStringList;
    x : integer;
begin
    if (FUpdateMode = upWhereKeyOnly) then
    begin
      FldList := TStringList.Create;
      try
        FldList.Delimiter := ';';
        FldList.DelimitedText := FKeyFields;
        for x := 0 to (FldList.Count - 1) do
        begin
          DataSet.FieldByName(FldList[x]).ProviderFlags := [pfInUpdate, pfInWhere, pfInKey];
        end;
      finally
        FldList.Free;
      end;
    end;
end;

procedure TdbxCustomQuery.OpenCursor(InfoQuery: Boolean);
var
  lInternalTrans : Boolean;
  lTransDesc : TTransactionDesc;
begin
  CheckConnection;
  if Assigned(FProvider) then
  begin
    if (FKeyFields = '') then
      FProvider.UpdateMode := upWhereKeyOnly
    else
      FProvider.UpdateMode := FUpdateMode;
    SetProvider(FProvider);
  end;
  if FProvider.DataSet = Self then
    raise Exception.Create(SCircularProvider);
  if ((CommandText + #13#10) <> FSQL.Text) then
    CommandText := FSQL.Text;
// This transaction management is due to a bug in Oracle
// when crossing db links.   If you don't declare a transaction
// it will start one on the remote link then, you get Ora-@#$@#$ Errors
// Ensuring that everyting is in a tranaction solves this problem.

 // Are we in a Transaction.
  lInternalTrans := FConnection.InTransaction;
// We are not in a Transaction Start One
  if not lInternalTrans then
  begin
    lTransDesc.TransactionID := 1;
    lTransDesc.GlobalID := 0;
    lTransDesc.IsolationLevel := xilREADCOMMITTED;
    lTransDesc.CustomIsolation := 0;
    FConnection.StartTransaction(lTransDesc);
  end;
  try
  try
  inherited;
  except
     on e: exception do
     begin
       LogQueryDetails(e);
       raise;
     end;
  end;
  finally
   // We started a transaction we better commit it
    if not lInternalTrans then
    begin
       FConnection.Commit(lTransDesc);
    end;
  end;
end;

procedure TdbxCustomQuery.SetAutoApplyUpdates(const Value: Boolean);
begin
  FAutoApplyUpdates := Value;
end;

procedure TdbxCustomQuery.SetConnection(Value: TSQLConnection);
begin
  FConnection := Value;
  FDataSet.SQLConnection := FConnection;
end;

//procedure TdbxCustomQuery.SetParams(const Value: TParams);
//begin
//  if ((CommandText + #13#10) <> FSQL.Text) then
//    CommandText := FSQL.Text;
//  Params.AssignValues(Value);
//  //if ((FDataSet.CommandText + #13#10) <> FSQL.Text) then
//  //  FDataSet.CommandText := FSQL.Text;
//  //FDataSet.Params.AssignValues(Value);
//end;

procedure TdbxCustomQuery.SetRequestLive(const Value: Boolean);
begin
  FRequestLive := Value;
  ReadOnly := not Value;
end;

procedure TdbxCustomQuery.SetSQL(const Value: TStrings);
begin
  FSQL.Clear;
  FSQL.Text := Value.Text;
  CommandText := FSQL.Text;
end;

procedure TdbxCustomQuery.WriteLog(value: String);
var
 lLogFile : TextFile;
 AppPath  : String;
 LogPath  : String;
 TodayLogName : String;
 AppName :  String;
 Error : Boolean;
 ErrorCnt : Integer;
begin
  // Check to see if log sub directory exists
  // \AppPath\Log
  AppPath := ExtractFilePath(ParamStr(0));
  LogPath := AppPath + 'LOG\';
  AppName := ExtractFileName(ParamStr(0));

  If Not DirectoryExists(LogPath) then
  begin
    ForceDirectories(LogPath);
  end;
  // LogFile Naming format 'YYYYMMDD.LOG'
  TodayLogName := LogPath + FormatDateTime('YYYYMMDD',DATE) + '.LOG';

  // This loops through trying to write multiple times, until sucessful.
  ErrorCnt := 0;
  repeat
    Error := False;
    try
    AssignFile(lLogFile,TodayLogName);
    try
    if Not FileExists(TodayLogName) then
    begin
       // Write the file
       Rewrite(lLogFile);
    end
    else
    begin
       System.Append(lLogFile);
    end;
    writeln(lLogFile,Value);
    finally
      CloseFile(lLogFile);
    end;
    except
       Error := True;
       inc(ErrorCnt);
    end;
  until (Error = false) or (ErrorCnt > 5);
end;



function TdbxCustomQuery.ParamByName(Name: String): TParam;
begin
  if ((CommandText + #13#10) <> FSQL.Text) then
    CommandText := FSQL.Text;
  Result := Params.ParamByName(Name);
end;

procedure TdbxCustomQuery.Prepare;
begin
end;

function TdbxCustomQuery.PSGetCommandText: string;
var
  IP: IProviderSupport;
begin
  if Supports(FDataSet, IProviderSupport, IP) then
    Result := IP.PSGetCommandText
  else
    Result := CommandText;
end;


procedure TdbxCustomQuery.RevertFieldValue(FieldName: WideString);
begin
  FieldByName(FieldName).AsVariant := FieldByName(FieldName).OldValue;
end;

{ TDWSParam }

function TDWSParam.GetAsOraDateTime: TDateTime;
begin
  if IsNull then
    Result := 0 else
    Result := VarToDateTime(Self.Value);  //FData);
end;

function TDWSParam.GetAsOraFMTBCD: Extended;
begin
  if IsNull then
    Result := 0.0 else
    Result := Self.AsFloat;
    //Result := VarToBCD(Self.Value);  //FData);
end;

procedure TDWSParam.SetAsOraDateTime(const Value: TDateTime);
var TmpVal : TDateTime;
begin
  TmpVal := Value;
  Self.DataType := ftTimeStamp;  //ftDateTime;
  Self.Value := TmpVal;
end;

procedure TDWSParam.SetAsOraFMTBCD(const Value: Extended);
var
  S : String;
  B : TBcd;
begin
 // Fix for: Exception Message: 6.24517650265965E-289 is not a valid BCD value
  S:= FormatFloat('###############################.###############################',Value);
  B := StrToBcd(S);
  Self.DataType := ftFMTBCD;  //ftDateTime;
  Self.AsFMTBCD := B;
end;

{ TdbxInternalSQLDataSet }

procedure TdbxInternalSQLDataSet.DoAfterScroll;
begin
  inherited;
  if ((Self.Eof) and (TdbxCustomQuery(Self.Owner).RequestLive = False)) then
  begin
    TdbxCustomQuery(Self.Owner).SetProvider(nil);  //ProviderName := '';
    Self.Active := False;
  end;
end;

procedure TdbxInternalSQLDataSet.InternalClose;
begin
  inherited;
  // This fixes a cursor leak in TsqlQuery
  FreeReader;
  FreeCommand;
end;

{ TdbxQuery }

procedure TdbxCustomQuery.InternalReconcileError(DataSet: TCustomClientDataSet;
  E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
//Done in such a hack manner as the default behavior is Action = raSkip
// Which was ignoring errors.
 Action := raCancel;
 if Assigned(FOnRecError) then
    FOnRecError(Dataset,e,UpdateKind,Action);
 if Action = raCancel then
 begin
//   raise exception.create(e.message);
  WriteLog(Name+ ' - ' +E.ClassName + ':' + E.Message);
  if IsConsole then
     raise Exception.Create(e.message)
  else
     ApplicationShowException(E);
 end;
end;

end.
