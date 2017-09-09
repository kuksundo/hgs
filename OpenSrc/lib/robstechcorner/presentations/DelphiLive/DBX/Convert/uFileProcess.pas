unit uFileProcess;
// This is the unit to modify with any custom rules you might have.
// I personally convert the files once, try to compile, if the
// problem reported is common, then I write some additional logic here.

// The version of this that we wrote at the state of utah we had to several
// other rules.   I had to convert some things from TDatabase -> TsqlConnection
// and others from TDatabase -> TAdoConnection   This was because we had
// a database that was not supported by DBX.

// We also converted our Database from Adbase via ODBC to Oracle, so
// we had to process FieldTypes more than you might.   But if your
// switch databases you will want to look at ProcessTField and do mapping
// to handle field type changes.

// Since that version was very specific to our senario and hard coded
// with our database names to know help know how to convert the components
// I offer a version that will be a starting point for you use.

// I hope this helps you convert from BDE to DBX or convert code as
// it could be modifed to do any processing on DFM or PAS files.

interface
uses Sysutils, Classes, Contnrs, mwPasLex, mwPasLexTypes,uPasUnit,uDFMParser;


type
   TFileProcessor = class(TObject)
   private
     FDatabaseNameLookup : TStringList;
     FDFMChangeList : TStringList;
     FMasterLogFile: String;
     FLogFileName : String;
    FWriteToTestFiles: Boolean;
     procedure WriteToLog(aMessage : String);
     procedure WriteCheckOff(AMessage : String);
     procedure WriteMasterLog(aMessage : String);
     function NewStringProp(aString : String) : TDfmProperty;
     procedure ReadDFMToMemoryStream(const FileName: string;
               const MemoryStream: TMemoryStream);
     procedure ProcessPASWithTokenizer(PasFileName : String);
     procedure ProcessPASWithSearchAndReplace(PasFileName : String);
    procedure SetWriteToTestFiles(const Value: Boolean);
   protected
     procedure ProcessDFM(PasFileName : String);
     procedure ProcessPAS(PasFileName : String);


     function ProcessDFMObject(DFMFileName : String;aDfmObj: TdfmObject) : TDfmObject;

     function ProcessTStoredProc(DFMFileName : String;aDfmObj : TdfmObject): TDfmObject;
     function ProcessTQuery(DFMFileName : String;aDfmObj : TdfmObject) : TDfmObject;
     function ProcessTTable(DFMFileName : String;aDfmObj : TdfmObject) : TDfmObject;
     function ProcessTDatabase(DFMFileName : String;aDfmObj : TdfmObject) : TDfmObject;
     function ProcessTField(DFMFileName : String;aDfmObj: TdfmObject): TDfmObject;

   public
     constructor Create;
     destructor Destroy; override;
     procedure ProcessFile(FileName : String);
     property WriteToTestFiles : Boolean read FWriteToTestFiles write SetWriteToTestFiles;

   end;

implementation
const
  QryEventsList = 'AfterApplyUpdates,AfterCancel,AfterClose,AfterDelete,'
             + 'AfterEdit,AfterExecute,AfterGetParams,AfterGetRecords,'
             + 'AfterInsert,AfterOpen,AfterPost,AfterRefresh,AfterRowRequest,'
             + 'AfterScroll,BeforeApplyUpdates,BeforeCancel,BeforeClose,'
             + 'BeforeDelete,BeforeEdit,BeforeExecute,BeforeGetParams,'
             + 'BeforeGetRecords,BeforeInsert,BeforeOpen,BeforePost,'
             + 'BeforeRefresh,BeforeRowRequest,BeforeScroll,OnCalcFields,'
             + 'OnDeleteError,OnEditError,OnFilterRecord,OnNewRecord,'
             + 'OnPostError,OnReconcileError';

{ TFileProcessor }

constructor TFileProcessor.Create;
begin
 // If Set, the DFM is saved as DFM2 and PAS is saved as PAS2
  FWriteToTestFiles := False;

 // Every Component Replaced will be in here with a named/value pair to assist
 // the Conversion of the PAS File
   FDFMChangeList := TStringList.Create;

// I know this could have been dynamic, but the reality is that
// most application have this defined and it's limited
// so I hard code it here. and let each person who runs this app change it.

//TODO: Change Mapping of TDatabase.DatabaseName to Component Name.
  FDatabaseNameLookup := TStringList.Create;
  FDatabaseNameLookup.Values['DBDEMOS'] := 'Database';
  FDatabaseNameLookup.Values['MAST'] := 'Database';

end;

destructor TFileProcessor.Destroy;
begin
  FreeAndNil(FDatabaseNameLookup);
  FreeAndNil(FDFMChangeList);
  inherited;
end;

procedure TFileProcessor.ProcessDFM(PasFileName: String);
var
  dfmTree : TDfmTree;
  dfmStream : TMemoryStream;
  dfmFileName : String;
begin
  dfmFileName := ChangeFileExt(PasFileName,'.dfm');
  if FileExists(dfmFileName) then
  begin
    dfmStream := TMemoryStream.Create;
    try
      ReadDFMToMemoryStream(dfmFileName,dfmStream);
      dfmTree := TDfmTree.Create;
      try
        DFMStream.Position := 0;
        ObjectTextToTree(DFMStream,dfmTree);
        DFMStream.Clear;
        dfmTree := TDfmTree(ProcessDFMObject(DFMFileName,dfmTree));
        ObjectTreeToText(dfmTree,DFMStream);
        DFMStream.Position := 0;
        if WriteToTestFiles then
           DFMFileName := ChangeFileExt(dfmFileName,'.dfm2');
        DFMStream.SaveToFile(dfmFileName);
      finally
        dfmTree.Free;
      end;
    finally
     dfmStream.Free;
    end;

  end;
end;


procedure TFileProcessor.ProcessFile(FileName: String);
begin
  FLogFileName := ChangeFileExt(Filename,'.CONVERTLOG');
  FMasterLogFile := ExtractFilePath(FileName) + 'DIR_MASTER.CONVERTLOG';
  WriteToLog('--------------- Conversion Notes ---------------------');
  ProcessDFM(FileName);
  ProcessPAS(FileName);
end;

procedure TFileProcessor.ProcessPAS(PasFileName: String);
begin
  ProcessPASWithTokenizer(PasFileName);
  ProcessPASWithSearchAndReplace(PasFileName);
end;

procedure TFileProcessor.ProcessPASWithSearchAndReplace(PasFileName: String);
begin
 // If you want you could open the file up and do simple or RegEx
 // replaces here, for any patterns you find you have commonly change.
end;

procedure TFileProcessor.ProcessPASWithTokenizer(PasFileName: String);
var
  Stream: TMemoryStream;
  InUses : Boolean;
  InInterface : Boolean;
  InImplementation : Boolean;
  InInitOrFinal : Boolean;
  InVarSection : Boolean;
  lTokenList : TTokenList;
  I : Integer;
  LastIdent : String;
  LastIdentIdx: Integer;
  DelIdx : Integer;
  LineAdj : integer;

begin
  Stream := TMemoryStream.Create;
  lTokenList := TTokenList.Create;
  try
    Stream.LoadFromFile(PasFileName);
    lTokenList.Parse(Stream);
    Stream.Clear;
    InUses := false;
    InInterface := false;
    InImplementation := False;
    InInitOrFinal := false;
    InVarSection := false;
    I := 0;
    LastIdent := '';
    LastIdentIdx := -1;
    LineAdj := 0;
    while I < lTokenList.ItemCount do
    begin
      if lTokenList.Item[I].TokenKind = ptInterfaceStart then
      begin
        InInterface := true;
        InImplementation := false;
        InInitOrFinal := false;
      end;

      if lTokenList.Item[I].TokenKind = ptImplementation  then
      begin
        InInterface := false;
        InImplementation := true;
        InInitOrFinal := false;
      end;

      if lTokenList.Item[I].TokenKind in [ptInitialization,ptFinalization] then
      begin
        InInterface := false;
        InImplementation := false;
        InInitOrFinal := true;
      end;

      if lTokenList.Item[I].TokenKind  = ptVar then
      begin
         InVarSection := true;
      end;

      if lTokenList.Item[I].TokenKind in [ptBegin,ptType,ptConst] then
      begin
         InVarSection := false;
      end;

      if InVarSection then
      begin
        if ((lTokenList.Item[I].TokenKind = ptIdentifier) and
            (lowercase(lTokenList.Item[I].TokenValue) = 'tquery')) then
        begin
           lTokenList.Item[I].TokenValue := 'TdbxQuery';
        end;
        if ((lTokenList.Item[I].TokenKind = ptIdentifier) and
            (lowercase(lTokenList.Item[I].TokenValue) = 'tstoredproc')) then
        begin
           lTokenList.Item[I].TokenValue := 'TSQLStoredProc';
        end;
      end;
      if InImplementation or InInitOrFinal then
      begin
        // If you need to do something... I did not need it.
      end;


      if lTokenList.Item[I].TokenKind = ptUses then
      begin
         // Mark in Uses and also format the uses all to have
         // uses
         //   FirstUnit  or
         // uses
         //   {First Comment}
         InUses := True;
         inc(I);
         lTokenList.Insert(I,TTokenItem.Create(ptCRLFCo,#13#10));
         LineAdj := LineAdj + 1;
         inc(I);
         lTokenList.Insert(I,TTokenItem.Create(ptSpace,'  '));
         inc(I);
         while lTokenList.Item[I].IsSpace do
              lTokenList.Delete(I);
      end;

      if lTokenList.Item[I].TokenKind = ptSemiColon then
         inUses := False;
      // Make all Tabs Spaces
      if lTokenList.Item[I].TokenKind = ptSpace then
         lTokenList.Item[I].TokenValue := StringReplace(lTokenList.Item[I].TokenValue,#9,'  ',[rfReplaceAll]);


      if InUses then
        begin
         if (lTokenList.Item[I].TokenKind = ptIdentifier) and (LowerCase(lTokenList.Item[I].TokenValue) = 'dbtables') then
         begin
            lTokenList.Item[I].TokenValue := 'DBXpress';
            inc(I);
            lTokenList.Insert(I,TTokenItem.Create(ptComma,', '));
            inc(I);
            lTokenList.Insert(I,TTokenItem.Create(ptIdentifier,'FMTBcd'));
            inc(I);
            lTokenList.Insert(I,TTokenItem.Create(ptComma,', '));
            inc(I);
            lTokenList.Insert(I,TTokenItem.Create(ptIdentifier,'DBClient'));
            inc(I);
            lTokenList.Insert(I,TTokenItem.Create(ptComma,', '));
            inc(I);
            lTokenList.Insert(I,TTokenItem.Create(ptIdentifier,'SimpleDS'));
            inc(I);
            lTokenList.Insert(I,TTokenItem.Create(ptComma,', '));
            inc(I);
            lTokenList.Insert(I,TTokenItem.Create(ptIdentifier,'SqlExpr'));
            inc(I);
            lTokenList.Insert(I,TTokenItem.Create(ptComma,', '));
            inc(I);
            lTokenList.Insert(I,TTokenItem.Create(ptIdentifier,'dbxQuery'));
// TODO: Add any new units you need to be added automagically
//            inc(I);
//            lTokenList.Insert(I,TTokenItem.Create(ptComma,', '));
//            inc(I);
//            lTokenList.Insert(I,TTokenItem.Create(ptCRLFCo,#13#10));
//            LineAdj := LineAdj + 1;
//            inc(I);
//            lTokenList.Insert(I,TTokenItem.Create(ptSpace,'  '));
//            inc(I);
//            lTokenList.Insert(I,TTokenItem.Create(ptIdentifier,'dbDataModule'));
         end;
      end; // InUses
      if InInterface then
      begin

        if (lTokenList.Item[I].TokenKind = ptIdentifier) and
           ((UpperCase(lTokenList.Item[I].TokenValue) = 'TQUERY') or
            (UpperCase(lTokenList.Item[I].TokenValue) = 'TTABLE')) then
        begin
            lTokenList.Item[I].TokenValue := 'TDbxQuery';
        end;

        if (lTokenList.Item[I].TokenKind = ptIdentifier) and
           ((UpperCase(lTokenList.Item[I].TokenValue) = 'TSTOREDPROC')) then
        begin
            lTokenList.Item[I].TokenValue := 'TSQLStoredProc';
        end;


        if (lTokenList.Item[I].TokenKind = ptIdentifier) and
           ((UpperCase(lTokenList.Item[I].TokenValue) = 'TDATABASE')) then
        begin
            lTokenList.Item[I].TokenValue := 'TSqlConnection';
        end;

// We changed all of our grids from TdbGrid to our own TDWSGrid
// Example Code: If you want to covert something else like.
//        if ((lTokenList.Item[I].TokenKind = ptIdentifier) and
//           (UpperCase(lTokenList.Item[I].TokenValue) = 'TDBGRID')) then
//        begin
//            lTokenList.Item[I].TokenValue := 'TDwsGrid';
//        end;

        if ((lTokenList.Item[I].TokenKind = ptIdentifier) and
           (Pos('FIELD',UpperCase(lTokenList.Item[I].TokenValue)) > 0)) then
           //(UpperCase(lTokenList.Item[I].TokenValue) = 'TDBGRID')) then
        begin
          if Length(FDFMChangeList.Values[LastIdent]) > 0 then
          begin
              lTokenList.Item[I].TokenValue := FDFMChangeList.Values[LastIdent];  //TmpClassName;
          end;
        end;

        //
        if (lTokenList.Item[I].TokenKind = ptIdentifier) and
           ((UpperCase(lTokenList.Item[I].TokenValue) = 'TUPDATESQL')) then
        begin
           DelIdx := I+1;
           // Find to next Ident
           while ((lTokenList.Item[DelIdx].IsJunk) or (lTokenList.Item[DelIdx].TokenKind = ptSemiColon)) do
             inc(DelIdx);
           dec(DelIdx); // don't want to delete that identifier

           while LastIdentIdx <= DelIdx do
           begin
             lTokenList.Delete(DelIdx);
             dec(DelIdx);
           end;
           I := DelIdx;
        end;



      end;

      // Any Section
//        if (lTokenList.Item[I].TokenKind = ptIdentifier) and
//           ((UpperCase(lTokenList.Item[I].TokenValue) = 'TDATABASE') or
//            (UpperCase(lTokenList.Item[I].TokenValue) = 'TDWSDATABASE') or
//            (UpperCase(lTokenList.Item[I].TokenValue) = 'TADAUPDATESQL') ) then
//        begin
//            inc(I);
//            lTokenList.Insert(I,TTokenItem.Create(ptBorComment,'{TODO: Remove Ref}'));
//        end;

      if ((UpperCase(lTokenList.Item[I].TokenValue) = 'TQUERY') or
          (UpperCase(lTokenList.Item[I].TokenValue) = 'TTABLE') or
          (UpperCase(lTokenList.Item[I].TokenValue) = 'TSTOREDPROC')) then
          begin
             WriteCheckOff('(' + IntToStr(LineAdj + lTokenList.Item[I].OrigLineNo) + ') '
                          + LastIdent + ' : ' + lTokenList.Item[I].TokenValue  + ' Not Converted and needs to be converted by Hand.');
            inc(I);
            lTokenList.Insert(I-1,TTokenItem.Create(ptBorComment,'{TODO: Convert}'));
          end;

      if lTokenList.Item[I].TokenKind = ptIdentifier then
      begin
         LastIdent := lTokenList.Item[I].TokenValue;
         LastIdentIdx := I;
      end;
      inc(I);
    end;
    lTokenList.SaveToStream(Stream);
    if WriteToTestFiles then
        PasFileName := ChangeFileExt(PasFileName,'.pas2');

    Stream.SaveToFile(PasFileName);

  finally
    lTokenList.Free;
    Stream.Free;
  end;
end;

function TFileProcessor.ProcessDFMObject(DFMFileName : String;aDfmObj: TdfmObject) : TDfmObject;
var
 I : Integer;
 lObj : TObjectList;
 ldfmObj : TDfmObject;
begin
  result := aDfmObj;
  if lowercase(aDfmObj.DfmClassName) = 'tstoredproc' then
    result := ProcessTStoredProc(DFMFileName,aDfmObj)
  else
  if lowercase(aDfmObj.DfmClassName) = 'ttable' then
    result := ProcessTTable(DFMFileName,aDfmObj)
  else
  if lowercase(aDfmObj.DfmClassName) = 'tquery' then
    result := ProcessTQuery(DFMFileName,aDfmObj)
  else                              //check all Field types
  if (Pos('field',lowercase(aDfmObj.DfmClassName)) > 0) then
  //if lowercase(aDfmObj.DfmClassName) = 'tfloatfield' then
    result := ProcessTField(DFMFileName,aDfmObj)
  else
  if lowercase(aDfmObj.DfmClassName) = 'tdatabase' then
    result := ProcessTDatabase(DFMFileName,aDfmObj);

  if Assigned(Result) then
  begin
  // Take Objects on aDFmObj and extract the used ones
  // and place them in the result the unused can be cleared with aDFMObj
   lObj := TObjectList.Create(false);
   try
    For I := 0 to aDfmObj.OwnedObjectCount -1 do
    begin
      ldfmObj := ProcessDFMObject(DFMFileName,aDFMObj.OwnedObject[I]);
      if Assigned(ldfmObj) then
        lObj.Add(ldfmObj);
    end;

    For I := 0 to lObj.Count -1 do
    begin
      aDfmObj.ExtractOwnedObject((lObj.Items[I] as TDfmObject));
    end;

    aDFMObj.ClearOwnedObjects;

    for I := 0 to lObj.Count -1 do
    begin
      result.AddOwnedObject(lObj.Items[I] as TDfmObject)
    end;

   finally
    lObj.free;
   end;
  end;

end;



function TFileProcessor.ProcessTDatabase(DFMFileName: String;
  aDfmObj: TdfmObject): TDfmObject;
var
 I : Integer;
 lProp : TDfmProperty;
 lTempProp : TDfmProperty;
begin
  WriteMasterLog(DFMFileName + ' TDatabase Named: ' + aDFMObj.ObjectName + ' Replaced.' );
  WriteCheckOff(aDFMObj.ObjectName + ' was a TDatabase Need to set the parameters by hand!' );

  result := TDfmObject.create;
  result.DfmClassName := 'TSqlConnection';
  result.ObjectName := aDFMObj.ObjectName;

    //--------
    lTempProp := aDFmObj.PropertyByName('Left');
    if Assigned(lTempProp) then
    begin
      lProp := TDfmProperty.Create;
      lProp.PropertyName := 'Left';
      lProp.PropertyType := ptInteger;
      lProp.IntegerValue := lTempProp.IntegerValue;
      result.AddDfmProperty(lProp);
    end;
    //--------
    lTempProp := aDFmObj.PropertyByName('Top');
    if Assigned(lTempProp) then
    begin
      lProp := TDfmProperty.Create;
      lProp.PropertyName := 'Top';
      lProp.PropertyType := ptInteger;
      lProp.IntegerValue := lTempProp.IntegerValue;
      result.AddDfmProperty(lProp);
    end;
end;

function TFileProcessor.ProcessTField(DFMFileName : String;aDfmObj: TdfmObject): TDfmObject;
begin
// If changing database or Datatype on specific fields you will want
// to handle the processing of that here.
  result := aDfmObj;
end;


function TFileProcessor.ProcessTQuery(DFMFileName: String;
  aDfmObj: TdfmObject): TDfmObject;
var
 I : Integer;
 lDbName : string;
 lProp : TDfmProperty;
 lTempProp : TDfmProperty;
begin
  WriteMasterLog(DFMFileName + ' TQuery Named: ' + aDFMObj.ObjectName + ' Replaced.' );
  WriteCheckOff(aDFMObj.ObjectName + ' was a TQuery, check to ensure that SQL still works properly.' );
  ldbName :=  aDFmObj.PropertyByName('databasename').StringValue;

(* Default Simple Dataset dropped on to the form
    object SimpleDataSet1: TSimpleDataSet
    Aggregates = <>
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 256
    Top = 216
  end

  TdbxQuery Default Layout
  object dbxQuery1: TdbxQuery
    Params = <>
    Aggregates = <>
    ReadOnly = True
    Left = 216
    Top = 88
  end

  *)
    result := TDfmObject.create;
    result.DfmClassName := 'TdbxQuery';
    result.ObjectName := aDFMObj.ObjectName;

    //--------
    lProp := TDfmProperty.Create;
    lProp.PropertyName := 'Aggregates';
    lProp.PropertyType := ptCollection;
    result.AddDfmProperty(lProp);
    //--------
    lProp := TDfmProperty.Create;
    lProp.PropertyName := 'Connection';
    lProp.PropertyType := ptIdent;
    lProp.StringValue := FDatabaseNameLookup.Values[UpperCase(ldbName)];
    result.AddDfmProperty(lProp);

     lProp :=   aDFmObj.PropertyByName('SQL.Strings');
     if Assigned(lProp) then
     begin
//  We had field and table names changing and we also converted SQL
//  Since it was just a search and replace type thing I have commented
//  it out as it most likely won't apply to all cases.
//       UpdateSQL(lProp,aDFmObj.ObjectName);
       aDfmObj.ExtractDfmProperty(lProp);
       result.AddDfmProperty(lProp);
     end;
    //--------
     lProp :=   aDFmObj.PropertyByName('Params');
     if Assigned(LProp) then
     begin
       aDfmObj.ExtractDfmProperty(lProp);
       result.AddDfmProperty(lProp);
     end;

    lProp :=   aDFmObj.PropertyByName('Params.Data');
    if Assigned(lProp) then
    begin
      aDfmObj.ExtractDfmProperty(lProp);
      result.AddDfmProperty(lProp);
    end;

    //--------
    lTempProp := aDFmObj.PropertyByName('Left');
    if Assigned(lTempProp) then
    begin
      lProp := TDfmProperty.Create;
      lProp.PropertyName := 'Left';
      lProp.PropertyType := ptInteger;
      lProp.IntegerValue := lTempProp.IntegerValue;
      result.AddDfmProperty(lProp);
    end;
    //--------
    lTempProp := aDFmObj.PropertyByName('Top');
    if Assigned(lTempProp) then
    begin
      lProp := TDfmProperty.Create;
      lProp.PropertyName := 'Top';
      lProp.PropertyType := ptInteger;
      lProp.IntegerValue := lTempProp.IntegerValue;
      result.AddDfmProperty(lProp);
    end;
    for I := 0 to (aDFMObj.DfmPropertyCount - 1) do
    begin
      if (Pos(aDFMObj.DfmProperty[I].PropertyName,QryEventsList) > 0) then
      begin
        lTempProp := aDFMObj.DfmProperty[I];
        if Assigned(lTempProp) then
        begin
          lProp := TDfmProperty.Create;
          lProp.PropertyName := lTempProp.PropertyName;
          lProp.PropertyType := lTempProp.PropertyType;
          lProp.StringValue := lTempProp.StringValue;
          result.AddDfmProperty(lProp);
        end;
      end;
    end;
end;

function TFileProcessor.ProcessTStoredProc(DFMFileName : String;aDfmObj: TdfmObject)  : TdfmObject;
var
 ldbName : string;
 lProp  : TDfmProperty;
 I : Integer;
 lTempProp : TDfmProperty;
begin
  WriteMasterLog(DFMFileName + ' TStoredProc Named: ' + aDFMObj.ObjectName + ' Replaced.' );
  WriteCheckOff(aDFMObj.ObjectName + ' was a TStoredProc review code to see that it still runs properly.' );
  ldbName :=  aDFmObj.PropertyByName('databasename').StringValue;

    result := TDfmObject.create;
    result.DfmClassName := 'TSQLStoredProc';
    result.ObjectName := aDFMObj.ObjectName;

    if Assigned(aDFmObj.PropertyByName('StoredProcName')) then
    begin
      //--------
      lProp := TDfmProperty.Create;
      lProp.PropertyName := 'StoredProcName';
      lProp.PropertyType := ptString;
      lProp.StringValue := aDFmObj.PropertyByName('StoredProcName').StringValue;
      result.AddDfmProperty(lProp);
    end;
    //--------
    lProp := TDfmProperty.Create;
    lProp.PropertyName := 'SQLConnection';
    lProp.PropertyType := ptIdent;
    lProp.StringValue := FDatabaseNameLookup.Values[UpperCase(ldbName)];
    result.AddDfmProperty(lProp);

    ////--------
    //lProp := TDfmProperty.Create;
    //lProp.PropertyName := 'Params';
    //lProp.PropertyType := ptCollection;
    //result.AddDfmProperty(lProp);


    lProp :=   aDFmObj.PropertyByName('Params');
    if Assigned(LProp) then
    begin
      aDfmObj.ExtractDfmProperty(lProp);
      result.AddDfmProperty(lProp);
    end;

    lProp :=   aDFmObj.PropertyByName('ParamData');
    if Assigned(lProp) then
    begin
      aDfmObj.ExtractDfmProperty(lProp);
      lProp.PropertyName := 'Params';
      result.AddDfmProperty(lProp);
    end;

    lProp :=   aDFmObj.PropertyByName('Params.Data');
    if Assigned(lProp) then
    begin
      aDfmObj.ExtractDfmProperty(lProp);
      result.AddDfmProperty(lProp);
    end;

    //--------
    lProp := TDfmProperty.Create;
    lProp.PropertyName := 'Left';
    lProp.PropertyType := ptInteger;
    lProp.IntegerValue := aDFmObj.PropertyByName('Left').IntegerValue;
    result.AddDfmProperty(lProp);
    //--------
    lProp := TDfmProperty.Create;
    lProp.PropertyName := 'Top';
    lProp.PropertyType := ptInteger;
    lProp.IntegerValue := aDFmObj.PropertyByName('Top').IntegerValue;
    result.AddDfmProperty(lProp);

    for I := 0 to (aDFMObj.DfmPropertyCount - 1) do
    begin          //if property in query event list then copy to new object
      if (Pos(aDFMObj.DfmProperty[I].PropertyName,QryEventsList) > 0) then
      begin
        lTempProp := aDFMObj.DfmProperty[I];
        if Assigned(lTempProp) then
        begin
          lProp := TDfmProperty.Create;
          lProp.PropertyName := lTempProp.PropertyName;
          lProp.PropertyType := lTempProp.PropertyType;
          lProp.StringValue := lTempProp.StringValue;
          result.AddDfmProperty(lProp);
        end;
      end;
    end;
end;

function TFileProcessor.ProcessTTable(DFMFileName : String;aDfmObj: TdfmObject)  : TdfmObject;
var
 ldbName : string;
 lProp  : TDfmProperty;
 I : Integer;
 lTempProp : TDfmProperty;
begin
  WriteMasterLog(DFMFileName + ' TTtable Named: ' + aDFMObj.ObjectName + ' Replaced.' );
  WriteCheckOff(aDFMObj.ObjectName + ' was a TTable review code to see "select * from tablename" can be handled differently.' );
  ldbName :=  aDFmObj.PropertyByName('databasename').StringValue;

    result := TDfmObject.create;
    result.DfmClassName := 'TdbxQuery';
    result.ObjectName := aDFMObj.ObjectName;

    //--------
    lProp := TDfmProperty.Create;
    lProp.PropertyName := 'Aggregates';
    lProp.PropertyType := ptCollection;
    result.AddDfmProperty(lProp);
    //--------
    lProp := TDfmProperty.Create;
    lProp.PropertyName := 'Connection';
    lProp.PropertyType := ptIdent;
    lProp.StringValue := FDatabaseNameLookup.Values[UpperCase(ldbName)];
    result.AddDfmProperty(lProp);

    lProp := TDfmProperty.Create;
    lProp.PropertyName := 'SQL.Strings';
    lProp.PropertyType := ptList;
    lProp.AddListItem(NewStringProp('SELECT * FROM ' + aDFmObj.PropertyByName('TableName').StringValue));
    result.AddDfmProperty(lProp);
    //--------
    lProp := TDfmProperty.Create;
    lProp.PropertyName := 'Params';
    lProp.PropertyType := ptCollection;
    result.AddDfmProperty(lProp);
    //--------
    lProp := TDfmProperty.Create;
    lProp.PropertyName := 'Left';
    lProp.PropertyType := ptInteger;
    lProp.IntegerValue := aDFmObj.PropertyByName('Left').IntegerValue;
    result.AddDfmProperty(lProp);
    //--------
    lProp := TDfmProperty.Create;
    lProp.PropertyName := 'Top';
    lProp.PropertyType := ptInteger;
    lProp.IntegerValue := aDFmObj.PropertyByName('Top').IntegerValue;
    result.AddDfmProperty(lProp);

    for I := 0 to (aDFMObj.DfmPropertyCount - 1) do
    begin
      if (Pos(aDFMObj.DfmProperty[I].PropertyName,QryEventsList) > 0) then
      begin
        lTempProp := aDFMObj.DfmProperty[I];
        if Assigned(lTempProp) then
        begin
          lProp := TDfmProperty.Create;
          lProp.PropertyName := lTempProp.PropertyName;
          lProp.PropertyType := lTempProp.PropertyType;
          lProp.StringValue := lTempProp.StringValue;
          result.AddDfmProperty(lProp);
        end;
      end;
    end;

end;




procedure TFileProcessor.ReadDFMToMemoryStream(const FileName: string;
  const MemoryStream: TMemoryStream);
// taken from http://www.berryware.com/articles/copernic_search_plugin_delphi_2006.html
var
  FileStream: TFileStream;
  TempMemoryStream: TMemoryStream;
  PrependString: string;
  CharBuffer: array[0..65535] of char;
  ReadCount: integer;
  OriginalFormat: TStreamOriginalFormat;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead);
  try
    TempMemoryStream := TMemoryStream.Create;
    try
      ReadCount := FileStream.Read(CharBuffer, 3);
      FileStream.Seek(0, soFromBeginning);
      if ReadCount = 3 then
      begin
        if (CharBuffer[0] = #255) and (CharBuffer[1] = #10)
          and (CharBuffer[2] = #0) then
        begin
          // Has the binary file signature
          OriginalFormat := sofBinary;
          ObjectResourceToText(FileStream, TempMemoryStream);
        end
        else
        begin
          // Assume text otherwise
          OriginalFormat := sofText;
        end;
      end
      else
      begin
        // Too short to be binary or text, but more likely
        // empty text file so go with that!
        OriginalFormat := sofText;
      end;
      TempMemoryStream.Seek(0, soFromBeginning);
      PrependString := '';
      if OriginalFormat = sofBinary then
      begin
        MemoryStream.Write(PrependString[1], Length(PrependString));
        ReadCount := TempMemoryStream.Read(CharBuffer[0],
          SizeOf(CharBuffer));
        while ReadCount > 0 do
        begin
          MemoryStream.Write(CharBuffer[0], ReadCount);
          ReadCount := TempMemoryStream.Read(CharBuffer[0],
            SizeOf(CharBuffer));
        end;
      end
      else
      begin
        MemoryStream.Write(PrependString[1], Length(PrependString));
        FileStream.Free;
        FileStream := TFileStream.Create(FileName, fmOpenRead);
        ReadCount := FileStream.Read(CharBuffer, SizeOf(CharBuffer));
        while ReadCount > 0 do
        begin
          MemoryStream.Write(CharBuffer, ReadCount);
          ReadCount := FileStream.Read(CharBuffer, SizeOf(CharBuffer));
        end;
      end;

      MemoryStream.Seek(0, soFromBeginning);
    finally
      TempMemoryStream.Free;
    end;
  finally
    FileStream.Free;
  end;
end;

procedure TFileProcessor.SetWriteToTestFiles(const Value: Boolean);
begin
  FWriteToTestFiles := Value;
end;

procedure TFileProcessor.WriteCheckOff(AMessage: String);
begin
 WriteToLog(' [  ] ' + AMessage);
end;

procedure TFileProcessor.WriteMasterLog(aMessage: String);
var
 T : TextFile;
begin
 Assign(T,FMasterLogFile);
 if FileExists(FMasterLogFile) then
    Append(T)
 else
    Rewrite(T);
 Writeln(T,aMessage);
 CloseFile(T);

end;

procedure TFileProcessor.WriteToLog(aMessage: String);
var
 T : TextFile;
begin
 Assign(T,FLogFileName);
 if FileExists(FLogFileName) then
    Append(T)
 else
    Rewrite(T);
 Writeln(T,aMessage);
 CloseFile(T);

end;


function TFileProcessor.NewStringProp(aString: String): TDfmProperty;
begin
 result := TDfmProperty.Create;
 result.PropertyType := ptString;
 result.StringValue := aString;
end;


end.
