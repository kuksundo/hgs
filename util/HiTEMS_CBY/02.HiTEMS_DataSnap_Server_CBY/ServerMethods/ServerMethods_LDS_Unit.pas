unit ServerMethods_LDS_Unit;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth, Forms,
  Data.DBXJSON, Data.DBXJSONCommon, Ora, Data.DB, DateUtils, System.IOUtils,
  System.strUtils, Graphics, GraphUtil, PngImage, GIFImg, Jpeg;

type
{$METHODINFO ON}
  TServerMethods_LDS = class(TComponent)
  private
    { Private declarations }
    FID : string;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;

    // Local_Data_Sheet
    function Return_Values(aTJSONPair: TJSONPair): String;
    function Check_Engine_Running(aTable,aTime:String) : Boolean;
    function Get_Mon_Engine_List : TJSONArray;
    function Get_Mon_keyMap(aProjNo:String) : TJSONObject;
    function Get_Mon_Values(aTable,aDateTime:String): TJSONObject;


    function Get_LDS_Data(aTestNo:String) : TJSONObject;
    function Get_LDS_Header_Info(aDay: String): TJSONArray;
    function Get_LDS_TEST_TITLE(aDay:String) : TJSONArray;
    function Get_Factory_List : TJSONArray;
    function Get_Engine_Type(aLOC_CODE:String) : TJSONArray;
    function Get_Engtype_from_DB() : TJSONArray;
    procedure HIMSEN_ETH_LDS_Delete(aIndate: String);
    function Insert_Into_HIMSEN_ETH_LDS(aTJSONObj: TJSONObject): Boolean;
    function Update_HIMSEN_ETH_LDS(aIndate: String; aTJSONObj: TJSONObject): Boolean;
  end;
{$METHODINFO OFF}

implementation

uses
  IdCoderMIME,
  GUID_Utils_Unit,
  DataModule_Unit;

function TServerMethods_LDS.Get_Factory_List: TJSONArray;
var
  OraQuery : TOraQuery;
  JSONOBJ : TJSONObject;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TBACS.HITEMS_LOC_CODE ' +
              'WHERE LOC_LV = :param1 ' +
              'ORDER BY LOC_SORT ');

      ParamByName('param1').AsInteger := 0;
      Open;

      if RecordCount <> 0 then
      begin
        Result := TJSONArray.Create;
        while not eof do
        begin
          JSONOBJ := TJSONObject.Create;
          JSONOBJ.AddPair('CODE',FieldByName('LOC_CODE').AsString)
                 .AddPair('CODENAME',FieldByName('LOC_NAME').AsString);

          Result.Add(JSONOBJ);
          Next;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TServerMethods_LDS.Get_LDS_Data(aTestNo: String): TJSONObject;
var
  OraQuery : TOraQuery;
  li : Integer;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT A.*,B.LOC_CODE, C.LOC_NAME FROM ' +
              'TBACS.HIMSEN_ETH_LDS A, TBACS.HIMSEN_INFO B, TBACS.HITEMS_LOC_CODE C ' +
              'WHERE A.TEST_NO = :param1 ' +
              'AND A.PROJNO = B.PROJNO ' +
              'AND B.LOC_CODE = C.LOC_CODE ' +
              'ORDER BY INDATE ');

      ParamByName('param1').AsString := aTestNo;
      Open;

      if RecordCount <> 0 then
      begin
        Result := TJSONObject.Create;
        for li := 0 to Fields.Count-1 do
        begin
          Result.AddPair(Fields[li].FieldName, Fields[li].AsString);

        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TServerMethods_LDS.Get_LDS_Header_Info(aDay: String): TJSONArray;
var
  OraQuery : TOraQuery;
  lJSONObj : TJSONObject;
  lIndate : String;
  OraQuery1 : TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;

  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT A.*,B.LOC_CODE,C.LOC_NAME FROM ' +
              'TBACS.HIMSEN_ETH_LDS A, TBACS.HIMSEN_INFO B, TBACS.HITEMS_LOC_CODE C ' +
              'WHERE SUBSTR(A.INDATE,1,10) = :param1 ' +
              'AND A.PROJNO = B.PROJNO ' +
              'AND B.LOC_CODE = C.LOC_CODE ' +
              'ORDER BY INDATE ');

      ParamByName('param1').AsString := aDay;
      Open;

      if RecordCount <> 0 then
      begin
        Result := TJSONArray.Create;

        while not eof do
        begin
          lJSONObj := TJSONObject.Create;
          Result.Add(lJSONObj.AddPair('TEST_NO',FieldByName('TEST_NO').AsString).
                              AddPair('INDATE',FormatDateTime('YYYY-MM-DD HH:mm:ss',FieldByName('INDATE').AsDateTime)).
                              AddPair('ENGINE_CODE',FieldByName('PROJNO').AsString).
                              AddPair('ENGINE_TYPE',FieldByName('ENGTYPE').AsString).
                              AddPair('TEST_NAME',FieldByName('TITLE').AsString).
                              AddPair('TEST_LOAD',FieldByName('TEST_LOAD').AsString).
                              AddPair('RUNNING_HOUR',FieldByName('RUNHOUR').AsString).
                              AddPair('EVALUATOR',FieldByName('EVALUATER').AsString).
                              AddPair('LOC_CODE',FieldByName('LOC_CODE').AsString).
                              AddPair('LOC_NAME',FieldByName('LOC_NAME').AsString));
          Next;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function TServerMethods_LDS.Get_LDS_TEST_TITLE(aDay: String): TJSONArray;
var
  OraQuery : TOraQuery;
  lJSONObj : TJSONObject;
  lIndate : String;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select ' +
              'Distinct(TITLE) ' +
              'FROM TBACS.HIMSEN_ETH_LDS ' +
              'WHERE INDATE like :param1 ' +
              'order by TITLE ');

      ParamByName('param1').AsString := aDay+'%';
      Open;

      if RecordCount <> 0 then
      begin
        Result := TJSONArray.Create;

        while not eof do
        begin
          lJSONObj := TJSONObject.Create;
          Result.Add(lJSONObj.AddPair('TEST_NAME',FieldByName('TITLE').AsString));
          Next;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TServerMethods_LDS.Get_Mon_Engine_List: TJSONArray;
var
  lprojNo,
  lengType,
  ltable,
  lstate,
  lTime,
  aTime : String;


  lJsonObj : TJSONObject;
begin
  Result := TJSONArray.Create;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM TBACS.HITEMS_MON_STANDARD ' +
            'ORDER BY ENG_PROJNO ');
    Open;

    if RecordCount <> 0 then
    begin
      while not eof do
      begin
        lprojNo  := FieldByName('ENG_PROJNO').AsString;//ProjNo
        lengType := FieldByName('ENG_TYPE').AsString;//EngType
        ltable   := FieldByName('DATABASE').AsString+'.'+
                    FieldByName('TABLE_NAME').AsString;

        lTime := FormatDateTime('YYYYMMDDHHmmss',Now);
        lTime := Copy(lTime,1,13);

        if Check_Engine_Running(ltable,lTime) then
          lstate := 'RUN'
        else
          lstate := 'STOP';

        lJsonObj := TJSONObject.Create;
        Result.Add(lJsonObj.AddPair('STATE',lstate).
                            AddPair('ENGPROJ',lprojNo).
                            AddPair('ENGTYPE',lengType).
                            AddPair('DATATABLE',ltable));

        Next;
      end;
    end;
  end;
end;

function TServerMethods_LDS.Get_Mon_keyMap(aProjNo: String): TJSONObject;
var
  OraQuery : TOraQuery;
  lStr : String;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TBACS.HITEMS_MON_MAP ' +
              'WHERE DATA_ENGPROJNO = :param1 ' +
              'ORDER BY SORTNO ');
      ParamByName('param1').AsString := aProjNo;
      Open;

      if RecordCount <> 0 then
      begin
        Result := TJSONObject.Create;
        while not eof do
        begin
          if NOT(FieldByName('KEY').IsNull) AND NOT(FieldByName('DATA_COLUMN').IsNull) then
          begin
            Result.AddPair(FieldByName('KEY').AsString,FieldByName('DATA_COLUMN').AsString);
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

function TServerMethods_LDS.Get_Mon_Values(aTable,
  aDateTime: String): TJSONObject;
var
  OraQuery : TOraQuery;
  li : Integer;
  lplcTable,
  lwt500Table,
  lCurrTime,
  l5SecAgo,
  times,
  query : String;
  lDateTime : TDateTime;

begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    lDateTime := StrToDateTime(aDateTime);
    times := FormatDateTime('YYYYMMDDHHmm',lDateTime);
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM ' +aTable+' ' +
              'WHERE DATASAVEDTIME = ( ' +
              'SELECT MAX(DATASAVEDTIME) FROM ' + aTable +' '+
              'WHERE DATASAVEDTIME LIKE :param1 )');
      ParamByName('param1').AsString := times+'%';
//      ParamByName('param1').AsString := '201307151626%';
      Open;

      Result := TJSONObject.Create;
      if RecordCount <> 0 then
      begin
        for li := 0 to Fields.Count-1 do
          Result.AddPair(Fields[li].FieldName,Fields[li].AsString);
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TServerMethods_LDS.Get_Engine_Type(aLOC_CODE:String) : TJSONArray;
var
  OraQuery : TOraQuery;
  JSONObj : TJSONObject;
  lState,
  lTable,
  lTime : String;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM ( ' +
              'SELECT STATUS, PROJNO, ENGTYPE, LOC_CODE, TABLE_NAME FROM TBACS.HIMSEN_INFO A ' +
              'LEFT OUTER JOIN TBACS.HITEMS_MON_STANDARD B ' +
              'ON A.PROJNO = B.ENG_PROJNO ORDER BY PROJNO) ' +
              'WHERE STATUS = 0 ' +
              'AND LOC_CODE = :param1 ' +
              'ORDER BY ENGTYPE ');
      ParamByName('param1').AsString := aLOC_CODE;
      Open;

      if RecordCount <> 0 then
      begin
        Result := TJSONArray.Create;
        while not eof do
        begin
          if FieldByName('TABLE_NAME').AsString <> '' then
          begin
            lTime := FormatDateTime('YYYYMMDDHHmmss',Now);
            lTime := Copy(lTime,1,13);

            lTable := FieldByName('TABLE_NAME').AsString;
            if Check_Engine_Running(ltable,lTime) then
              lstate := 'RUN'
            else
              lstate := 'STOP';
          end else
            lstate := 'STOP';

          JSONObj := TJSONObject.Create;
          JSONObj.AddPair('PROJNO',FieldByName('PROJNO').AsString).
                  AddPair('ENGTYPE',FieldByName('ENGTYPE').AsString).
                  AddPair('STATE',lstate);

          Result.Add(JSONObj);

          Next;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TServerMethods_LDS.Get_Engtype_from_DB: TJSONArray;
var
  OraQuery1 : TOraQuery;
  tarr : TJSONArray;
  tobj : TJSONObject;
  eng_projno,eng_have, eng_type, eng_plus, lTable : String;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;

  with OraQuery1 do
  begin
    Close;
    sql.Clear;
    sql.Add('Select * ');
    sql.Add('From himsen_info where status = ''0'' ');
    Open;
    tarr := TJSONArray.Create;
    while not eof do
    begin
      tobj := TJSONObject.Create;
      eng_projno := FieldByName('PROJNO').AsString;
      eng_type := FieldByName('ENGTYPE').AsString;
      eng_plus := eng_projno + '-' + eng_Type;

      eng_have := '1';
      if not(eng_type = '') then
        tarr.Add(tobj.AddPair('ENG_TYPE', eng_type).AddPair('ENG_PROJNO', eng_projno).AddPair('ENG_HAVE', eng_have).AddPair('ENG_PLUS', eng_plus));
      Next;
    end;
    Result := tarr;
    FreeAndNil(OraQuery1);
  end;
end;

function TServerMethods_LDS.Insert_Into_HIMSEN_ETH_LDS(aTJSONObj: TJSONObject): Boolean;
var
  OraQuery : TOraQuery;
  li : Integer;
  lkey, lpairName : String;
  lPair : TJSONPair;
  lJsonObj : TJSONObject;
  OraQuery1 : TOraQuery;

begin
  if aTJSONObj.Size > 0 then
  begin
    OraQuery1 := TOraQuery.Create(nil);
    OraQuery1.Session := DM1.OraSession1;
    try
      with OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Insert Into HIMSEN_ETH_LDS ' +
                'Values(:PROJNO, :TEST_NO, :TITLE,:ENGTYPE,:INDATE, ' +
                ':ENDDATE,:EVALUATER,:RUNHOUR, :TEST_LOAD, :GETDATATIME, ' +
                ':DATA_1,:DATA_2,:DATA_3,:DATA_4,:DATA_5,:DATA_6, ' +
                ':DATA_7,:DATA_8,:DATA_9,:DATA_10,:DATA_11, ' +
                ':DATA_12,:DATA_13,:DATA_14,:DATA_15,:DATA_16, ' +
                ':DATA_17,:DATA_18,:DATA_19,:DATA_20,:DATA_21, ' +
                ':DATA_22,:DATA_23,:DATA_24,:DATA_25,:DATA_26, ' +
                ':DATA_27,:DATA_28,:DATA_29,:DATA_30,:DATA_31, ' +
                ':DATA_32,:DATA_33,:DATA_34,:DATA_35,:DATA_36, ' +
                ':DATA_37,:DATA_38,:DATA_39,:DATA_40,:DATA_41, ' +
                ':DATA_42,:DATA_43,:DATA_44,:DATA_45,:DATA_46, ' +
                ':DATA_47,:DATA_48,:DATA_49,:DATA_50,:DATA_51, ' +
                ':DATA_52,:DATA_53,:DATA_54,:DATA_55,:DATA_56, ' +
                ':DATA_57,:DATA_58,:DATA_59,:DATA_60,:DATA_61, ' +
                ':DATA_62,:DATA_63,:DATA_64,:DATA_65,:DATA_66, ' +
                ':DATA_67,:DATA_68,:DATA_69,:DATA_70,:DATA_71, ' +
                ':DATA_72,:DATA_73,:DATA_74,:DATA_75,:DATA_76, ' +
                ':DATA_77,:DATA_78,:DATA_79,:DATA_80,:DATA_81, ' +
                ':DATA_82,:DATA_83,:DATA_84,:DATA_85,:DATA_86, ' +
                ':DATA_87,:DATA_88,:DATA_89,:DATA_90,:DATA_91, ' +
                ':DATA_92,:DATA_93,:DATA_94,:DATA_95,:DATA_96, ' +
                ':DATA_97,:DATA_98,:DATA_99,:DATA_100,:DATA_101, ' +
                ':DATA_102,:DATA_103,:DATA_104,:DATA_105,:DATA_106, ' +
                ':DATA_107,:DATA_108,:DATA_109,:DATA_110,:DATA_111, ' +
                ':DATA_112,:DATA_113,:DATA_114,:DATA_115,:DATA_116, ' +
                ':DATA_117,:DATA_118,:DATA_119,:DATA_120,:DATA_121, ' +
                ':DATA_122,:DATA_123,:DATA_124,:DATA_125,:DATA_126) ');

        with aTJSONObj do
        begin
          li := size;
          lpairName := aTJSONObj.ToString;


          ParamByName('PROJNO').AsString       := Return_Values(get('PROJNO'));
          ParamByName('TEST_NO').AsString      := Return_Values(get('TEST_NO'));
          ParamByName('TITLE').AsString        := Return_Values(get('TITLE'));
          ParamByName('ENGTYPE').AsString      := Return_Values(get('ENGTYPE'));
          ParamByName('INDATE').AsString       := Return_Values(get('INDATE'));
          ParamByName('ENDDATE').AsString      := Return_Values(get('ENDDATE'));
          ParamByName('EVALUATER').AsString    := Return_Values(get('EVALUATER'));
          ParamByName('RUNHOUR').AsString      := Return_Values(get('RUNHOUR'));
          ParamByName('TEST_LOAD').AsString    := Return_Values(get('TEST_LOAD'));
          ParamByName('GETDATATIME').AsString  := Return_Values(get('GETDATATIME'));

          ParamByName('DATA_1').AsFloat        := StrToFloat(Return_Values(get('DATA_1')));
          ParamByName('DATA_2').AsFloat        := StrToFloat(Return_Values(get('DATA_2')));
          ParamByName('DATA_3').AsFloat        := StrToFloat(Return_Values(get('DATA_3')));
          ParamByName('DATA_4').AsFloat        := StrToFloat(Return_Values(get('DATA_4')));
          ParamByName('DATA_5').AsFloat        := StrToFloat(Return_Values(get('DATA_5')));
          ParamByName('DATA_6').AsFloat        := StrToFloat(Return_Values(get('DATA_6')));
          ParamByName('DATA_7').AsFloat        := StrToFloat(Return_Values(get('DATA_7')));
          ParamByName('DATA_8').AsFloat        := StrToFloat(Return_Values(get('DATA_8')));
          ParamByName('DATA_9').AsFloat        := StrToFloat(Return_Values(get('DATA_9')));
          ParamByName('DATA_10').AsFloat       := StrToFloat(Return_Values(get('DATA_10')));
          ParamByName('DATA_11').AsFloat       := StrToFloat(Return_Values(get('DATA_11')));
          ParamByName('DATA_12').AsFloat       := StrToFloat(Return_Values(get('DATA_12')));
          ParamByName('DATA_13').AsFloat       := StrToFloat(Return_Values(get('DATA_13')));
          ParamByName('DATA_14').AsFloat       := StrToFloat(Return_Values(get('DATA_14')));
          ParamByName('DATA_15').AsFloat       := StrToFloat(Return_Values(get('DATA_15')));
          ParamByName('DATA_16').AsFloat       := StrToFloat(Return_Values(get('DATA_16')));
          ParamByName('DATA_17').AsFloat       := StrToFloat(Return_Values(get('DATA_17')));
          ParamByName('DATA_18').AsFloat       := StrToFloat(Return_Values(get('DATA_18')));
          ParamByName('DATA_19').AsFloat       := StrToFloat(Return_Values(get('DATA_19')));
          ParamByName('DATA_20').AsFloat       := StrToFloat(Return_Values(get('DATA_20')));
          ParamByName('DATA_21').AsFloat       := StrToFloat(Return_Values(get('DATA_21')));
          ParamByName('DATA_22').AsFloat       := StrToFloat(Return_Values(get('DATA_22')));
          ParamByName('DATA_23').AsFloat       := StrToFloat(Return_Values(get('DATA_23')));
          ParamByName('DATA_24').AsFloat       := StrToFloat(Return_Values(get('DATA_24')));
          ParamByName('DATA_25').AsFloat       := StrToFloat(Return_Values(get('DATA_25')));
          ParamByName('DATA_26').AsFloat       := StrToFloat(Return_Values(get('DATA_26')));
          ParamByName('DATA_27').AsFloat       := StrToFloat(Return_Values(get('DATA_27')));
          ParamByName('DATA_28').AsFloat       := StrToFloat(Return_Values(get('DATA_28')));
          ParamByName('DATA_29').AsFloat       := StrToFloat(Return_Values(get('DATA_29')));
          ParamByName('DATA_30').AsFloat       := StrToFloat(Return_Values(get('DATA_30')));
          ParamByName('DATA_31').AsFloat       := StrToFloat(Return_Values(get('DATA_31')));
          ParamByName('DATA_32').AsFloat       := StrToFloat(Return_Values(get('DATA_32')));
          ParamByName('DATA_33').AsFloat       := StrToFloat(Return_Values(get('DATA_33')));
          ParamByName('DATA_34').AsFloat       := StrToFloat(Return_Values(get('DATA_34')));
          ParamByName('DATA_35').AsFloat       := StrToFloat(Return_Values(get('DATA_35')));
          ParamByName('DATA_36').AsFloat       := StrToFloat(Return_Values(get('DATA_36')));
          ParamByName('DATA_37').AsFloat       := StrToFloat(Return_Values(get('DATA_37')));
          ParamByName('DATA_38').AsFloat       := StrToFloat(Return_Values(get('DATA_38')));
          ParamByName('DATA_39').AsFloat       := StrToFloat(Return_Values(get('DATA_39')));
          ParamByName('DATA_40').AsFloat       := StrToFloat(Return_Values(get('DATA_40')));
          ParamByName('DATA_41').AsFloat       := StrToFloat(Return_Values(get('DATA_41')));
          ParamByName('DATA_42').AsFloat       := StrToFloat(Return_Values(get('DATA_42')));
          ParamByName('DATA_43').AsFloat       := StrToFloat(Return_Values(get('DATA_43')));
          ParamByName('DATA_44').AsFloat       := StrToFloat(Return_Values(get('DATA_44')));
          ParamByName('DATA_45').AsFloat       := StrToFloat(Return_Values(get('DATA_45')));
          ParamByName('DATA_46').AsFloat       := StrToFloat(Return_Values(get('DATA_46')));
          ParamByName('DATA_47').AsFloat       := StrToFloat(Return_Values(get('DATA_47')));
          ParamByName('DATA_48').AsFloat       := StrToFloat(Return_Values(get('DATA_48')));
          ParamByName('DATA_49').AsFloat       := StrToFloat(Return_Values(get('DATA_49')));
          ParamByName('DATA_50').AsFloat       := StrToFloat(Return_Values(get('DATA_50')));
          ParamByName('DATA_51').AsFloat       := StrToFloat(Return_Values(get('DATA_51')));
          ParamByName('DATA_52').AsFloat       := StrToFloat(Return_Values(get('DATA_52')));
          ParamByName('DATA_53').AsFloat       := StrToFloat(Return_Values(get('DATA_53')));
          ParamByName('DATA_54').AsFloat       := StrToFloat(Return_Values(get('DATA_54')));
          ParamByName('DATA_55').AsFloat       := StrToFloat(Return_Values(get('DATA_55')));
          ParamByName('DATA_56').AsFloat       := StrToFloat(Return_Values(get('DATA_56')));
          ParamByName('DATA_57').AsFloat       := StrToFloat(Return_Values(get('DATA_57')));
          ParamByName('DATA_58').AsFloat       := StrToFloat(Return_Values(get('DATA_58')));
          ParamByName('DATA_59').AsFloat       := StrToFloat(Return_Values(get('DATA_59')));
          ParamByName('DATA_60').AsFloat       := StrToFloat(Return_Values(get('DATA_60')));
          ParamByName('DATA_61').AsFloat       := StrToFloat(Return_Values(get('DATA_61')));
          ParamByName('DATA_62').AsFloat       := StrToFloat(Return_Values(get('DATA_62')));
          ParamByName('DATA_63').AsFloat       := StrToFloat(Return_Values(get('DATA_63')));
          ParamByName('DATA_64').AsFloat       := StrToFloat(Return_Values(get('DATA_64')));
          ParamByName('DATA_65').AsFloat       := StrToFloat(Return_Values(get('DATA_65')));
          ParamByName('DATA_66').AsFloat       := StrToFloat(Return_Values(get('DATA_66')));
          ParamByName('DATA_67').AsFloat       := StrToFloat(Return_Values(get('DATA_67')));
          ParamByName('DATA_68').AsFloat       := StrToFloat(Return_Values(get('DATA_68')));
          ParamByName('DATA_69').AsFloat       := StrToFloat(Return_Values(get('DATA_69')));
          ParamByName('DATA_70').AsFloat       := StrToFloat(Return_Values(get('DATA_70')));
          ParamByName('DATA_71').AsFloat       := StrToFloat(Return_Values(get('DATA_71')));
          ParamByName('DATA_72').AsFloat       := StrToFloat(Return_Values(get('DATA_72')));
          ParamByName('DATA_73').AsFloat       := StrToFloat(Return_Values(get('DATA_73')));
          ParamByName('DATA_74').AsFloat       := StrToFloat(Return_Values(get('DATA_74')));
          ParamByName('DATA_75').AsFloat       := StrToFloat(Return_Values(get('DATA_75')));
          ParamByName('DATA_76').AsFloat       := StrToFloat(Return_Values(get('DATA_76')));
          ParamByName('DATA_77').AsFloat       := StrToFloat(Return_Values(get('DATA_77')));
          ParamByName('DATA_78').AsFloat       := StrToFloat(Return_Values(get('DATA_78')));
          ParamByName('DATA_79').AsFloat       := StrToFloat(Return_Values(get('DATA_79')));
          ParamByName('DATA_80').AsFloat       := StrToFloat(Return_Values(get('DATA_80')));
          ParamByName('DATA_81').AsFloat       := StrToFloat(Return_Values(get('DATA_81')));
          ParamByName('DATA_82').AsFloat       := StrToFloat(Return_Values(get('DATA_82')));
          ParamByName('DATA_83').AsFloat       := StrToFloat(Return_Values(get('DATA_83')));
          ParamByName('DATA_84').AsFloat       := StrToFloat(Return_Values(get('DATA_84')));
          ParamByName('DATA_85').AsFloat       := StrToFloat(Return_Values(get('DATA_85')));
          ParamByName('DATA_86').AsFloat       := StrToFloat(Return_Values(get('DATA_86')));
          ParamByName('DATA_87').AsFloat       := StrToFloat(Return_Values(get('DATA_87')));
          ParamByName('DATA_88').AsFloat       := StrToFloat(Return_Values(get('DATA_88')));
          ParamByName('DATA_89').AsFloat       := StrToFloat(Return_Values(get('DATA_89')));
          ParamByName('DATA_90').AsFloat       := StrToFloat(Return_Values(get('DATA_90')));
          ParamByName('DATA_91').AsFloat       := StrToFloat(Return_Values(get('DATA_91')));
          ParamByName('DATA_92').AsFloat       := StrToFloat(Return_Values(get('DATA_92')));
          ParamByName('DATA_93').AsFloat       := StrToFloat(Return_Values(get('DATA_93')));
          ParamByName('DATA_94').AsFloat       := StrToFloat(Return_Values(get('DATA_94')));
          ParamByName('DATA_95').AsFloat       := StrToFloat(Return_Values(get('DATA_95')));
          ParamByName('DATA_96').AsFloat       := StrToFloat(Return_Values(get('DATA_96')));
          ParamByName('DATA_97').AsFloat       := StrToFloat(Return_Values(get('DATA_97')));
          ParamByName('DATA_98').AsFloat       := StrToFloat(Return_Values(get('DATA_98')));
          ParamByName('DATA_99').AsFloat       := StrToFloat(Return_Values(get('DATA_99')));
          ParamByName('DATA_100').AsFloat      := StrToFloat(Return_Values(get('DATA_100')));
          ParamByName('DATA_101').AsFloat      := StrToFloat(Return_Values(get('DATA_101')));
          ParamByName('DATA_102').AsFloat      := StrToFloat(Return_Values(get('DATA_102')));
          ParamByName('DATA_103').AsFloat      := StrToFloat(Return_Values(get('DATA_103')));
          ParamByName('DATA_104').AsFloat      := StrToFloat(Return_Values(get('DATA_104')));
          ParamByName('DATA_105').AsFloat      := StrToFloat(Return_Values(get('DATA_105')));
          ParamByName('DATA_106').AsFloat      := StrToFloat(Return_Values(get('DATA_106')));
          ParamByName('DATA_107').AsFloat      := StrToFloat(Return_Values(get('DATA_107')));
          ParamByName('DATA_108').AsFloat      := StrToFloat(Return_Values(get('DATA_108')));
          ParamByName('DATA_109').AsFloat      := StrToFloat(Return_Values(get('DATA_109')));
          ParamByName('DATA_110').AsFloat      := StrToFloat(Return_Values(get('DATA_110')));
          ParamByName('DATA_111').AsFloat      := StrToFloat(Return_Values(get('DATA_111')));
          ParamByName('DATA_112').AsFloat      := StrToFloat(Return_Values(get('DATA_112')));
          ParamByName('DATA_113').AsFloat      := StrToFloat(Return_Values(get('DATA_113')));
          ParamByName('DATA_114').AsFloat      := StrToFloat(Return_Values(get('DATA_114')));
          ParamByName('DATA_115').AsFloat      := StrToFloat(Return_Values(get('DATA_115')));
          ParamByName('DATA_116').AsFloat      := StrToFloat(Return_Values(get('DATA_116')));
          ParamByName('DATA_117').AsFloat      := StrToFloat(Return_Values(get('DATA_117')));
          ParamByName('DATA_118').AsFloat      := StrToFloat(Return_Values(get('DATA_118')));
          ParamByName('DATA_119').AsFloat      := StrToFloat(Return_Values(get('DATA_119')));
          ParamByName('DATA_120').AsFloat      := StrToFloat(Return_Values(get('DATA_120')));
          ParamByName('DATA_121').AsFloat      := StrToFloat(Return_Values(get('DATA_121')));
          ParamByName('DATA_122').AsFloat      := StrToFloat(Return_Values(get('DATA_122')));
          ParamByName('DATA_123').AsFloat      := StrToFloat(Return_Values(get('DATA_123')));
          ParamByName('DATA_124').AsFloat      := StrToFloat(Return_Values(get('DATA_124')));
          ParamByName('DATA_125').AsFloat      := StrToFloat(Return_Values(get('DATA_125')));
          ParamByName('DATA_126').AsFloat      := StrToFloat(Return_Values(get('DATA_126')));

          ExecSQL;

        end;
      end;
    finally
      FreeAndNil(OraQuery1);
    end;
  end;
end;

function TServerMethods_LDS.Update_HIMSEN_ETH_LDS(aIndate: String; aTJSONObj: TJSONObject): Boolean;
var
  OraQuery : TOraQuery;
  li : Integer;
  lkey,
  lpairName : String;
  lPair : TJSONPair;
  lJsonObj : TJSONObject;
  Oraquery1 : TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;

  with OraQuery1 do
  begin
    Close;
    Sql.Add('update HIMSEN_ETH_LDS Set ' +
      'INDATE = :INDATE, ENGINE_CODE = :ENGINE_CODE, ENGINE_TYPE = :ENGINE_TYPE, TEST_NAME = :TESTNAME' +
      'TEST_LOAD = :TEST_LOAD, EVALUATOR = :EVALUATOR, RUNNING_HOUR = :RUNNING_HOUR ' +
      'DATA_1 = :DATA_1, DATA_2 = :DATA_2, DATA_3 = :DATA_3, DATA_4 = :DATA_4, DATA_5 = :DATA_5, ' +
      'DATA_6 = :DATA_6, DATA_7 = :DATA_7, DATA_8 = :DATA_8, DATA_9 = :DATA_9, DATA_10 = :DATA_10, ' +
      'DATA_11 = :DATA_11, DATA_12 = :DATA_12, DATA_13 = :DATA_13, DATA_14 = :DATA_14, DATA_15 = :DATA_15, ' +
      'DATA_16 = :DATA_16, DATA_17 = :DATA_17, DATA_18 = :DATA_18, DATA_19 = :DATA_19, DATA_20 = :DATA_20, ' +
      'DATA_21 = :DATA_21, DATA_22 = :DATA_22, DATA_23 = :DATA_23, DATA_24 = :DATA_24, DATA_25 = :DATA_25, ' +
      'DATA_26 = :DATA_26, DATA_27 = :DATA_27, DATA_28 = :DATA_28, DATA_29 = :DATA_29, DATA_30 = :DATA_30, ' +
      'DATA_31 = :DATA_31, DATA_32 = :DATA_32, DATA_33 = :DATA_33, DATA_34 = :DATA_34, DATA_35 = :DATA_35, ' +
      'DATA_36 = :DATA_36, DATA_37 = :DATA_37, DATA_38 = :DATA_38, DATA_39 = :DATA_39, DATA_40 = :DATA_40, ' +
      'DATA_41 = :DATA_41, DATA_42 = :DATA_42, DATA_43 = :DATA_43, DATA_44 = :DATA_44, DATA_45 = :DATA_45, ' +
      'DATA_46 = :DATA_46, DATA_47 = :DATA_47, DATA_48 = :DATA_48, DATA_49 = :DATA_49, DATA_50 = :DATA_50, ' +
      'DATA_51 = :DATA_51, DATA_52 = :DATA_52, DATA_53 = :DATA_53, DATA_54 = :DATA_54, DATA_55 = :DATA_55, ' +
      'DATA_56 = :DATA_56, DATA_57 = :DATA_57, DATA_58 = :DATA_58, DATA_59 = :DATA_59, DATA_60 = :DATA_60, ' +
      'DATA_61 = :DATA_61, DATA_62 = :DATA_62, DATA_63 = :DATA_63, DATA_64 = :DATA_64, DATA_65 = :DATA_65, ' +
      'DATA_66 = :DATA_66, DATA_67 = :DATA_67, DATA_68 = :DATA_68, DATA_69 = :DATA_69, DATA_70 = :DATA_70, ' +
      'DATA_71 = :DATA_71, DATA_72 = :DATA_72, DATA_73 = :DATA_73, DATA_74 = :DATA_74, DATA_75 = :DATA_75, ' +
      'DATA_76 = :DATA_76, DATA_77 = :DATA_77, DATA_78 = :DATA_78, DATA_79 = :DATA_79, DATA_80 = :DATA_80, ' +
      'DATA_81 = :DATA_81, DATA_82 = :DATA_82, DATA_83 = :DATA_83, DATA_84 = :DATA_84, DATA_85 = :DATA_85, ' +
      'DATA_86 = :DATA_86, DATA_87 = :DATA_87, DATA_88 = :DATA_88, DATA_89 = :DATA_89, DATA_90 = :DATA_90, ' +
      'DATA_91 = :DATA_91, DATA_92 = :DATA_92, DATA_93 = :DATA_93, DATA_94 = :DATA_94, DATA_95 = :DATA_95, ' +
      'DATA_96 = :DATA_96, DATA_97 = :DATA_97, DATA_98 = :DATA_98, DATA_99 = :DATA_99, DATA_100 = :DATA_100, ' +
      'DATA_101 = :DATA_101, DATA_102 = :DATA_102, DATA_103 = :DATA_103, DATA_104 = :DATA_104, DATA_105 = :DATA_105, ' +
      'DATA_106 = :DATA_106, DATA_107 = :DATA_107, DATA_108 = :DATA_108, DATA_109 = :DATA_109, DATA_110 = :DATA_110, ' +
      'DATA_111 = :DATA_111, DATA_112 = :DATA_112, DATA_113 = :DATA_113, DATA_114 = :DATA_114, DATA_115 = :DATA_115, ' +
      'DATA_116 = :DATA_116, DATA_117 = :DATA_117, DATA_118 = :DATA_118, DATA_119 = :DATA_119, DATA_120 = :DATA_120, ' +
      'DATA_121 = :DATA_121, DATA_122 = :DATA_122, DATA_123 = :DATA_123, DATA_124 = :DATA_124, DATA_125 = :DATA_125, ' +
      'DATA_126 = :DATA_126 WHERE INDATE = '''+aIndate+''' ');

       with aTJSONObj do
       begin
         lpairName := aTJSONObj.toString;

          ParamByName('PROJNO').AsString       := Return_Values(get('PROJNO'));
          ParamByName('TEST_NO').AsString      := Return_Values(get('TEST_NO'));
          ParamByName('TITLE').AsString        := Return_Values(get('TITLE'));
          ParamByName('ENGTYPE').AsString      := Return_Values(get('ENGTYPE'));
          ParamByName('INDATE').AsString       := Return_Values(get('INDATE'));
          ParamByName('ENDDATE').AsString      := Return_Values(get('ENDDATE'));
          ParamByName('EVALUATER').AsString    := Return_Values(get('EVALUATER'));
          ParamByName('RUNHOUR').AsString      := Return_Values(get('RUNHOUR'));
          ParamByName('TEST_LOAD').AsString    := Return_Values(get('TEST_LOAD'));
          ParamByName('GETDATATIME').AsString  := Return_Values(get('GETDATATIME'));

          ParamByName('DATA_1').AsFloat        := StrToFloat(Return_Values(get('DATA_1')));
          ParamByName('DATA_2').AsFloat        := StrToFloat(Return_Values(get('DATA_2')));
          ParamByName('DATA_3').AsFloat        := StrToFloat(Return_Values(get('DATA_3')));
          ParamByName('DATA_4').AsFloat        := StrToFloat(Return_Values(get('DATA_4')));
          ParamByName('DATA_5').AsFloat        := StrToFloat(Return_Values(get('DATA_5')));
          ParamByName('DATA_6').AsFloat        := StrToFloat(Return_Values(get('DATA_6')));
          ParamByName('DATA_7').AsFloat        := StrToFloat(Return_Values(get('DATA_7')));
          ParamByName('DATA_8').AsFloat        := StrToFloat(Return_Values(get('DATA_8')));
          ParamByName('DATA_9').AsFloat        := StrToFloat(Return_Values(get('DATA_9')));
          ParamByName('DATA_10').AsFloat       := StrToFloat(Return_Values(get('DATA_10')));
          ParamByName('DATA_11').AsFloat       := StrToFloat(Return_Values(get('DATA_11')));
          ParamByName('DATA_12').AsFloat       := StrToFloat(Return_Values(get('DATA_12')));
          ParamByName('DATA_13').AsFloat       := StrToFloat(Return_Values(get('DATA_13')));
          ParamByName('DATA_14').AsFloat       := StrToFloat(Return_Values(get('DATA_14')));
          ParamByName('DATA_15').AsFloat       := StrToFloat(Return_Values(get('DATA_15')));
          ParamByName('DATA_16').AsFloat       := StrToFloat(Return_Values(get('DATA_16')));
          ParamByName('DATA_17').AsFloat       := StrToFloat(Return_Values(get('DATA_17')));
          ParamByName('DATA_18').AsFloat       := StrToFloat(Return_Values(get('DATA_18')));
          ParamByName('DATA_19').AsFloat       := StrToFloat(Return_Values(get('DATA_19')));
          ParamByName('DATA_20').AsFloat       := StrToFloat(Return_Values(get('DATA_20')));
          ParamByName('DATA_21').AsFloat       := StrToFloat(Return_Values(get('DATA_21')));
          ParamByName('DATA_22').AsFloat       := StrToFloat(Return_Values(get('DATA_22')));
          ParamByName('DATA_23').AsFloat       := StrToFloat(Return_Values(get('DATA_23')));
          ParamByName('DATA_24').AsFloat       := StrToFloat(Return_Values(get('DATA_24')));
          ParamByName('DATA_25').AsFloat       := StrToFloat(Return_Values(get('DATA_25')));
          ParamByName('DATA_26').AsFloat       := StrToFloat(Return_Values(get('DATA_26')));
          ParamByName('DATA_27').AsFloat       := StrToFloat(Return_Values(get('DATA_27')));
          ParamByName('DATA_28').AsFloat       := StrToFloat(Return_Values(get('DATA_28')));
          ParamByName('DATA_29').AsFloat       := StrToFloat(Return_Values(get('DATA_29')));
          ParamByName('DATA_30').AsFloat       := StrToFloat(Return_Values(get('DATA_30')));
          ParamByName('DATA_31').AsFloat       := StrToFloat(Return_Values(get('DATA_31')));
          ParamByName('DATA_32').AsFloat       := StrToFloat(Return_Values(get('DATA_32')));
          ParamByName('DATA_33').AsFloat       := StrToFloat(Return_Values(get('DATA_33')));
          ParamByName('DATA_34').AsFloat       := StrToFloat(Return_Values(get('DATA_34')));
          ParamByName('DATA_35').AsFloat       := StrToFloat(Return_Values(get('DATA_35')));
          ParamByName('DATA_36').AsFloat       := StrToFloat(Return_Values(get('DATA_36')));
          ParamByName('DATA_37').AsFloat       := StrToFloat(Return_Values(get('DATA_37')));
          ParamByName('DATA_38').AsFloat       := StrToFloat(Return_Values(get('DATA_38')));
          ParamByName('DATA_39').AsFloat       := StrToFloat(Return_Values(get('DATA_39')));
          ParamByName('DATA_40').AsFloat       := StrToFloat(Return_Values(get('DATA_40')));
          ParamByName('DATA_41').AsFloat       := StrToFloat(Return_Values(get('DATA_41')));
          ParamByName('DATA_42').AsFloat       := StrToFloat(Return_Values(get('DATA_42')));
          ParamByName('DATA_43').AsFloat       := StrToFloat(Return_Values(get('DATA_43')));
          ParamByName('DATA_44').AsFloat       := StrToFloat(Return_Values(get('DATA_44')));
          ParamByName('DATA_45').AsFloat       := StrToFloat(Return_Values(get('DATA_45')));
          ParamByName('DATA_46').AsFloat       := StrToFloat(Return_Values(get('DATA_46')));
          ParamByName('DATA_47').AsFloat       := StrToFloat(Return_Values(get('DATA_47')));
          ParamByName('DATA_48').AsFloat       := StrToFloat(Return_Values(get('DATA_48')));
          ParamByName('DATA_49').AsFloat       := StrToFloat(Return_Values(get('DATA_49')));
          ParamByName('DATA_50').AsFloat       := StrToFloat(Return_Values(get('DATA_50')));
          ParamByName('DATA_51').AsFloat       := StrToFloat(Return_Values(get('DATA_51')));
          ParamByName('DATA_52').AsFloat       := StrToFloat(Return_Values(get('DATA_52')));
          ParamByName('DATA_53').AsFloat       := StrToFloat(Return_Values(get('DATA_53')));
          ParamByName('DATA_54').AsFloat       := StrToFloat(Return_Values(get('DATA_54')));
          ParamByName('DATA_55').AsFloat       := StrToFloat(Return_Values(get('DATA_55')));
          ParamByName('DATA_56').AsFloat       := StrToFloat(Return_Values(get('DATA_56')));
          ParamByName('DATA_57').AsFloat       := StrToFloat(Return_Values(get('DATA_57')));
          ParamByName('DATA_58').AsFloat       := StrToFloat(Return_Values(get('DATA_58')));
          ParamByName('DATA_59').AsFloat       := StrToFloat(Return_Values(get('DATA_59')));
          ParamByName('DATA_60').AsFloat       := StrToFloat(Return_Values(get('DATA_60')));
          ParamByName('DATA_61').AsFloat       := StrToFloat(Return_Values(get('DATA_61')));
          ParamByName('DATA_62').AsFloat       := StrToFloat(Return_Values(get('DATA_62')));
          ParamByName('DATA_63').AsFloat       := StrToFloat(Return_Values(get('DATA_63')));
          ParamByName('DATA_64').AsFloat       := StrToFloat(Return_Values(get('DATA_64')));
          ParamByName('DATA_65').AsFloat       := StrToFloat(Return_Values(get('DATA_65')));
          ParamByName('DATA_66').AsFloat       := StrToFloat(Return_Values(get('DATA_66')));
          ParamByName('DATA_67').AsFloat       := StrToFloat(Return_Values(get('DATA_67')));
          ParamByName('DATA_68').AsFloat       := StrToFloat(Return_Values(get('DATA_68')));
          ParamByName('DATA_69').AsFloat       := StrToFloat(Return_Values(get('DATA_69')));
          ParamByName('DATA_70').AsFloat       := StrToFloat(Return_Values(get('DATA_70')));
          ParamByName('DATA_71').AsFloat       := StrToFloat(Return_Values(get('DATA_71')));
          ParamByName('DATA_72').AsFloat       := StrToFloat(Return_Values(get('DATA_72')));
          ParamByName('DATA_73').AsFloat       := StrToFloat(Return_Values(get('DATA_73')));
          ParamByName('DATA_74').AsFloat       := StrToFloat(Return_Values(get('DATA_74')));
          ParamByName('DATA_75').AsFloat       := StrToFloat(Return_Values(get('DATA_75')));
          ParamByName('DATA_76').AsFloat       := StrToFloat(Return_Values(get('DATA_76')));
          ParamByName('DATA_77').AsFloat       := StrToFloat(Return_Values(get('DATA_77')));
          ParamByName('DATA_78').AsFloat       := StrToFloat(Return_Values(get('DATA_78')));
          ParamByName('DATA_79').AsFloat       := StrToFloat(Return_Values(get('DATA_79')));
          ParamByName('DATA_80').AsFloat       := StrToFloat(Return_Values(get('DATA_80')));
          ParamByName('DATA_81').AsFloat       := StrToFloat(Return_Values(get('DATA_81')));
          ParamByName('DATA_82').AsFloat       := StrToFloat(Return_Values(get('DATA_82')));
          ParamByName('DATA_83').AsFloat       := StrToFloat(Return_Values(get('DATA_83')));
          ParamByName('DATA_84').AsFloat       := StrToFloat(Return_Values(get('DATA_84')));
          ParamByName('DATA_85').AsFloat       := StrToFloat(Return_Values(get('DATA_85')));
          ParamByName('DATA_86').AsFloat       := StrToFloat(Return_Values(get('DATA_86')));
          ParamByName('DATA_87').AsFloat       := StrToFloat(Return_Values(get('DATA_87')));
          ParamByName('DATA_88').AsFloat       := StrToFloat(Return_Values(get('DATA_88')));
          ParamByName('DATA_89').AsFloat       := StrToFloat(Return_Values(get('DATA_89')));
          ParamByName('DATA_90').AsFloat       := StrToFloat(Return_Values(get('DATA_90')));
          ParamByName('DATA_91').AsFloat       := StrToFloat(Return_Values(get('DATA_91')));
          ParamByName('DATA_92').AsFloat       := StrToFloat(Return_Values(get('DATA_92')));
          ParamByName('DATA_93').AsFloat       := StrToFloat(Return_Values(get('DATA_93')));
          ParamByName('DATA_94').AsFloat       := StrToFloat(Return_Values(get('DATA_94')));
          ParamByName('DATA_95').AsFloat       := StrToFloat(Return_Values(get('DATA_95')));
          ParamByName('DATA_96').AsFloat       := StrToFloat(Return_Values(get('DATA_96')));
          ParamByName('DATA_97').AsFloat       := StrToFloat(Return_Values(get('DATA_97')));
          ParamByName('DATA_98').AsFloat       := StrToFloat(Return_Values(get('DATA_98')));
          ParamByName('DATA_99').AsFloat       := StrToFloat(Return_Values(get('DATA_99')));
          ParamByName('DATA_100').AsFloat      := StrToFloat(Return_Values(get('DATA_100')));
          ParamByName('DATA_101').AsFloat      := StrToFloat(Return_Values(get('DATA_101')));
          ParamByName('DATA_102').AsFloat      := StrToFloat(Return_Values(get('DATA_102')));
          ParamByName('DATA_103').AsFloat      := StrToFloat(Return_Values(get('DATA_103')));
          ParamByName('DATA_104').AsFloat      := StrToFloat(Return_Values(get('DATA_104')));
          ParamByName('DATA_105').AsFloat      := StrToFloat(Return_Values(get('DATA_105')));
          ParamByName('DATA_106').AsFloat      := StrToFloat(Return_Values(get('DATA_106')));
          ParamByName('DATA_107').AsFloat      := StrToFloat(Return_Values(get('DATA_107')));
          ParamByName('DATA_108').AsFloat      := StrToFloat(Return_Values(get('DATA_108')));
          ParamByName('DATA_109').AsFloat      := StrToFloat(Return_Values(get('DATA_109')));
          ParamByName('DATA_110').AsFloat      := StrToFloat(Return_Values(get('DATA_110')));
          ParamByName('DATA_111').AsFloat      := StrToFloat(Return_Values(get('DATA_111')));
          ParamByName('DATA_112').AsFloat      := StrToFloat(Return_Values(get('DATA_112')));
          ParamByName('DATA_113').AsFloat      := StrToFloat(Return_Values(get('DATA_113')));
          ParamByName('DATA_114').AsFloat      := StrToFloat(Return_Values(get('DATA_114')));
          ParamByName('DATA_115').AsFloat      := StrToFloat(Return_Values(get('DATA_115')));
          ParamByName('DATA_116').AsFloat      := StrToFloat(Return_Values(get('DATA_116')));
          ParamByName('DATA_117').AsFloat      := StrToFloat(Return_Values(get('DATA_117')));
          ParamByName('DATA_118').AsFloat      := StrToFloat(Return_Values(get('DATA_118')));
          ParamByName('DATA_119').AsFloat      := StrToFloat(Return_Values(get('DATA_119')));
          ParamByName('DATA_120').AsFloat      := StrToFloat(Return_Values(get('DATA_120')));
          ParamByName('DATA_121').AsFloat      := StrToFloat(Return_Values(get('DATA_121')));
          ParamByName('DATA_122').AsFloat      := StrToFloat(Return_Values(get('DATA_122')));
          ParamByName('DATA_123').AsFloat      := StrToFloat(Return_Values(get('DATA_123')));
          ParamByName('DATA_124').AsFloat      := StrToFloat(Return_Values(get('DATA_124')));
          ParamByName('DATA_125').AsFloat      := StrToFloat(Return_Values(get('DATA_125')));
          ParamByName('DATA_126').AsFloat      := StrToFloat(Return_Values(get('DATA_126')));
       end;
   end;

   FreeAndNil(OraQuery1);
end;




function TServerMethods_LDS.Check_Engine_Running(aTable,
  aTime: String): Boolean;
var
  OraQuery : TOraQuery;
  lKeyColumn : String;
  lEngSpeed : String;
  lTime : String;
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
        SQL.Add('SELECT MAX(DATASAVEDTIME) DATASAVEDTIME FROM '+aTable);
        Open;

        if RecordCount <> 0 then
        begin
          lTime := FieldByName('DATASAVEDTIME').AsString;
          lTime := Copy(lTime,1,13);

          if SameText(lTime, aTime) then
            Result := True
          else
            Result := False;
        end else
          Result := False;
      end;
    except
      Result := False;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

constructor TServerMethods_LDS.Create(AOwner: TComponent);
begin
  inherited;
  FID := GetNewGUID;

end;

destructor TServerMethods_LDS.Destroy;
begin
  inherited;

end;

function TServerMethods_LDS.Return_Values(aTJSONPair: TJSONPair): String;
var
  lstr : String;
  ljsonValue : TJSONValue;
begin
  ljsonValue := aTJSONPair.JsonValue;
  Result := ljsonValue.Value;
end;

procedure TServerMethods_LDS.HIMSEN_ETH_LDS_Delete(aIndate: String);
var
  OraQuery1 : TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;

  with OraQuery1 do
  begin
    Close;
    sql.Clear;
    sql.Add('Delete From HIMSEN_ETH_LDS ');
    sql.Add('Where INDATE = '''+aIndate+''' ');

    ExecSQL;
  end;

  FreeAndNil(OraQuery1);
end;

end.


