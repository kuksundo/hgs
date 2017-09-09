unit ServerMethods_HiTEMS_Unit;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth, Forms,
  Data.DBXJSON, Data.DBXJSONCommon, Ora, Data.DB, DateUtils, System.IOUtils,
  System.strUtils, Graphics, GraphUtil, PngImage, GIFImg, Jpeg;

type
{$METHODINFO ON}
  TServerMethods_HiTEMS = class(TComponent)
  private
    { Private declarations }
    FID : string;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    function GetID: string;

    //Mobile_HiTEMS
    // HiTEMS Update 관련
    function Check_for_UpdateApk(aFileName,aLastUpdate: String) : String;
    function Download_NewPackage(aVerNo: String) : TMemoryStream;
    function Send_JsonString(aJsonString:TJSONArray) : Boolean;
    function Get_Mobile_Application_List(aUsed:String):TJSONArray;

  end;
{$METHODINFO OFF}

implementation

uses
  IdCoderMIME,
  GUID_Utils_Unit,
  DataModule_Unit;

function TServerMethods_HiTEMS.Send_JsonString(aJsonString: TJSONArray): Boolean;
var
  mst : TMemoryStream;

begin
  mst := TMemoryStream.Create;
  try
    mst.LoadFromStream(TDBXJSONTools.JSONToStream(aJsonString));
    if mst.Size > 0 then
      mst.SaveToFile('C:\mst.jpg');
  finally
    FreeAndNil(mst);
  end;
end;

function TServerMethods_HiTEMS.Check_for_UpdateApk(aFileName,
  aLastUpdate: String): String;
var
  lFiles : String;
  li : Int64;
  OraQuery1 : TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    if (aFileName <> '') then
    begin
      with OraQuery1 do
      begin

        Close;
        SQL.Clear;
        SQL.Add('SELECT VERNO, FILENAME, LASTWRITETIME FROM ' +
                '( ' +
                '   SELECT MAX(VERNO) VERNO, FILENAME FROM HITEMS.APP_VERSION ' +
                '   WHERE UPPER(FILENAME) LIKE UPPER(:param1) ' +
                '   GROUP BY FILENAME ' +
                ') A, ' +
                '( ' +
                '   SELECT VERNO VN, LASTWRITETIME FROM HITEMS.APP_VERSION ' +
                ') B ' +
                'WHERE A.VERNO = B.VN ');

        ParamByName('param1').AsString := aFileName;
        Open;

        if FieldByName('LASTWRITETIME').AsDateTime > StrToDateTime('aLastUpdate') then
          Result := FieldByName('APPCODE').AsString
        else
          Result := 'null';
      end;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;



constructor TServerMethods_HiTEMS.Create(AOwner: TComponent);
begin
  inherited;
  FID := GetNewGUID;

end;

function TServerMethods_HiTEMS.Download_NewPackage(
  aVerNo: String): TMemoryStream;
var
  lFiles : String;
  li : Int64;
  OraQuery1 : TOraQuery;
  st : TStream;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
    if (aVerNo <> '') then
    begin
      with OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT FILES FROM HITEMS.APP_VERSION ' +
                'WHERE VERNO = :param1 ');
        ParamByName('param1').AsString := aVerNo;
        Open;

        if RecordCount <> 0 then
        begin
          Result := TMemoryStream.Create;
          TBlobField(FieldByName('FILES')).SaveToStream(Result);

        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function TServerMethods_HiTEMS.GetID: string;
begin
  Result := FID;
end;

function TServerMethods_HiTEMS.Get_Mobile_Application_List(
  aUsed: String): TJSONArray;
var
  OraQuery : TOraQuery;
  lJSONObj : TJSONObject;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT  ' +
              '   A.APPCODE, A.APPNAME_K, A.APPNAME_E, ' +
              '   B.VERNO, B.LASTWRITETIME, B.FILENAME ' +
              'FROM ' +
              '   HITEMS.APP_CODE A, ' +
              '   HITEMS.APP_VERSION B ' +
              'WHERE ' +
              '   A.APPCODE = B.APPCODE ' +
              'AND B.VERNO = ( ' +
              '                 SELECT ' +
              '                   MAX(VERNO) VER ' +
              '                 FROM ' +
              '                   HITEMS.APP_VERSION ' +
              '                 WHERE APPCODE = A.APPCODE ' +
              '              ) ' +
              'AND A.APPTYPE = ''Android'' ' +
              'AND A.STATUS = 0 ');

      Open;

      if RecordCount <> 0 then
      begin
        Result := TJSONArray.Create;

        while not eof do
        begin
          lJSONObj := TJSONObject.Create;
          Result.Add(lJSONObj.AddPair('VERNO',FieldByName('VERNO').AsString).
                              AddPair('APPCODE',FieldByName('APPCODE').AsString).
                              AddPair('APPNAME_K',FieldByName('APPNAME_K').AsString).
                              AddPair('APPNAME_E',FieldByName('APPNAME_E').AsString).
                              AddPair('LASTWRITETIME',FieldByName('LASTWRITETIME').AsString).
                              AddPair('FILENAME',FieldByName('FILENAME').AsString));


          Next;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;


end.

