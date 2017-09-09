unit ServerMethods_Photorum_Unit;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth, Forms,
  Data.DBXJSON, Data.DBXJSONCommon, Ora, Data.DB, DateUtils, System.IOUtils,
  System.strUtils, Graphics, GraphUtil, PngImage, GIFImg, Jpeg, IdCoderMIME;

type
{$METHODINFO ON}
  TByteArr = array of byte;
  TServerMethods_Photorum = class(TComponent)
  private
    { Private declarations }
    FID : string;

  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;

    function Format_Occur_Time(aOccurTime:String) : String;

    // Login
    function LoginUser(UserName,UserPw,UserMobileSer: string; out ReturnMessage: string): Boolean;

    // 개발시험부 포토름
    function ThumbnailFromImage(aImgPath:String; aImgStream:TMemoryStream; ThumbnailSize:Integer) : String;

    function Get_HiTEMS_MEDIA_STORE(aEmpNo:String) : TJSONArray;
    function Upload_Image2DB(aEmpNo, aFileNm, aFileDesc:String; aImages:TJSONObject):String;

    //Common
    function Return_Values(aTJSONPair: TJSONPair): String;
    function Gen_RegistrationNo(aDateTime:TDateTime) : String;
    function Get_EmpList(aUserId:String) : TJSONArray;
    function Get_DeptNo(aUserId:String) : String;
    function Get_userNameAndPosition(aUserId:String):String;

  end;
{$METHODINFO OFF}

implementation
uses
  soap.EncdDecd,
  Main_Unit,
  GUID_Utils_Unit,
  DataModule_Unit;

function TServerMethods_Photorum.Get_userNameAndPosition(aUserId: String): String;
var
  OraQuery : TOraQuery;
  lResult : String;

begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select A.*, B.DESCR from HiTEMS_USER A, HITEMS_USER_GRADE B ' +
              'where USERID = :param1 ' +
              'AND A.GRADE = B.GRADE ');
      ParamByName('param1').AsString := aUserId;
      Open;

      if not RecordCount <> 0 then
      begin
        lResult := FieldByName('NAME_KOR').AsString + '/'+
                   FieldByName('DESCR').AsString;
      end;

      if lResult <> '' then
        Result := lResult
      else
        Result := '';

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TServerMethods_Photorum.LoginUser(UserName, UserPw,
  UserMobileSer: string; out ReturnMessage: string): Boolean;
var
  LConfirmID : String;
  LCnt : integer;
  LMser : String;
  OraQuery1 : TOraQuery;
begin
  OraQuery1 := TOraQuery.Create(nil);
  OraQuery1.Session := DM1.OraSession1;
  try
  Result := false;
    try
      if not(UserName = '') and not(UserPw = '') then
      begin
        with OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select A.*, B.DESCR from HiTEMS_USER A, HITEMS_USER_GRADE B ' +
                  'WHERE A.USERID LIKE :param1 ' +
                  'AND A.GRADE = B.GRADE ');

          ParamByName('param1').AsString := UserName;
          Open;

          LConfirmID := FieldByName('UserID').AsString;

          if LConfirmID = UserName then
          begin
            if Fieldbyname('PASSWD').AsString = UserPw then
            begin
  //            TDS_Manager.Instance.LoginUser(UserName);
  //            TDSSessionManager.GetThreadSession.PutData('username', UserName);
              ReturnMessage := Fieldbyname('Name_Kor').AsString +' 님 방문을 환영합니다.';
              Result := True;
              LMSer := '0'+UserMobileSer;
            end
            else
            begin
              ReturnMessage := '비밀번호가 일치하지 않습니다.';
              Result := False;
            end;
          end
          else
          begin
            ReturnMessage := '등록된 ID가 없습니다.';
            Result := False;
          end;
        end;
      end
      else
      begin
        ReturnMessage := 'ID 또는 PW를 확인하여 주십시오.';
        Result := False;
      end;
    except
      on E: Exception do
      begin
        ReturnMessage := E.Message;
      end;
    end;
  finally
    FreeAndNil(OraQuery1);
  end;
end;

function TServerMethods_Photorum.Return_Values(aTJSONPair: TJSONPair): String;
var
  lstr : String;
  ljsonValue : TJSONValue;
begin
  ljsonValue := aTJSONPair.JsonValue;
  Result := ljsonValue.Value;
end;

function TServerMethods_Photorum.Get_DeptNo(aUserId: String): String;
var
  OraQuery : TOraQuery;
  lapproval,
  lchecker : String;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT DEPT_CD FROM HITEMS_USER ' +
              'WHERE USERID = :param1 ');

      ParamByName('param1').AsString := aUserId;
      Open;

      if RecordCount <> 0 then
        Result := FieldByName('DEPT_CD').AsString
      else
        Result := '';

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;


function TServerMethods_Photorum.ThumbnailFromImage(aImgPath:String; aImgStream:TMemoryStream; ThumbnailSize:Integer) : String;
var
  ImageExt: string;
  graphicSource: TGraphic;
  bmpSource: TBitmap;
  jpgThumbnail: TJPEGImage;
  bmpThumbnail: TBitmap;
  fScale: double;
begin
  ImageExt := LowerCase(ExtractFileExt(aImgPath));
  if ImageExt='.jpg' then
    graphicSource := TJPEGImage.Create
  else if ImageExt='.png' then
    graphicSource := TPngImage.Create
  else if ImageExt='.gif' then
    graphicSource := TGIFImage.Create
  else if ImageExt='.bmp' then
    graphicSource := TBitmap.Create
  else
    exit;

  try
    graphicSource.LoadFromStream(aImgStream);
    if ImageExt='.bmp' then
      bmpSource := TBitmap(graphicSource)
    else
    begin
      bmpSource := TBitmap.Create;
      bmpSource.Assign(graphicSource);
    end;

    bmpThumbnail := TBitmap.Create;
    try
      if bmpSource.Width >= bmpSource.Height then
        fScale := ThumbnailSize / bmpSource.Width
      else
        fScale := ThumbnailSize / bmpSource.Height;

      ScaleImage(bmpSource, bmpThumbnail, fScale);

      jpgThumbnail := TJPEGImage.Create;
      try
        jpgThumbnail.Assign(bmpThumbnail);
        jpgThumbnail.CompressionQuality := 90;
        jpgThumbnail.Compress;

        result := aImgPath;
        try
          jpgThumbnail.SaveToFile(result);
        except
          result := '';
        end;
      finally
        jpgThumbnail.Free;
      end;
    finally
      bmpThumbnail.Free;
      if graphicSource <> bmpSource then
        bmpSource.Free;
    end;
  finally
    graphicSource.Free;
  end;
end;


function TServerMethods_Photorum.Upload_Image2DB(aEmpNo, aFileNm,
  aFileDesc: String; aImages: TJSONObject): String;
var
  EncodedStr : String;
  LStrStream : TStringStream;
  LDecStream : TMemoryStream;

  procedure Upload_Image(aUserId, aFileName, aFileExt, aFileDesc:String;aFileSize:Int64;aFile:TMemoryStream);
  var
    OraQuery : TOraQuery;
  begin
    OraQuery := TOraQuery.Create(nil);
    try
      OraQuery.Session := DM1.OraSession1;
      OraQuery.Options.TemporaryLobUpdate := True;
      with OraQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO HITEMS_MEDIA_STORE ' +
                '(REG_NO, USERID, FILE_NAME, FILE_SIZE, FILE_EXT, FILE_DESC, FILES) ' +
                'VALUES '+
                '(:REG_NO, :USERID, :FILE_NAME, :FILE_SIZE, :FILE_EXT, :FILE_DESC, :FILES) ');

        ParamByName('REG_NO').AsString    := FormatDateTime('yyyyMMddHHmmsszzz',Now);
        ParamByName('USERID').AsString    := aUserId;
        ParamByName('FILE_NAME').AsString := aFileName;
        ParamByName('FILE_SIZE').AsFloat  := aFileSize;
        ParamByName('FILE_EXT').AsString  := aFileExt;
        ParamByName('FILE_DESC').AsString := aFileDesc;

        ParamByName('FILES').ParamType    := ptInput;
        ParamByName('FILES').AsOraBlob.LoadFromStream(aFile);

        ExecSQL;
      end;
    finally
      FreeAndNil(OraQuery);
    end;
  end;
begin
  if aImages.Size > 0 then
  begin
    EncodedStr := UTF8ToString(Return_Values(aImages.Get('IMAGEBASE64')));

    LStrStream := TStringStream.Create(EncodedStr);
    try
      LDecStream := TMemoryStream.Create;
      try
        LStrStream.Position := 0;
        DecodeStream(LStrStream, LDecStream);
//        LDecStream.SaveToFile('C:\'+aFileNm);

        Upload_Image(aEmpNo,
                     aFileNm,
                     ReplaceStr(ExtractFileExt(aFileNm),'.',''),
                     aFileDesc,
                     LDecStream.Size,
                     LDecStream);


      finally
        FreeAndNil(LDecStream);
      end;
    finally
      FreeAndNil(LStrStream);
    end;
  end;
end;

function TServerMethods_Photorum.Get_HiTEMS_MEDIA_STORE(aEmpNo:String) : TJSONArray;
var
  JSONObj : TJSONObject;

  MS : TMemoryStream;
  description,
  regNo,
  regName,
  regDate,
  refPath,
  FileName,
  fullpath : String;
  OraQuery : TOraQuery;

begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    Result := TJSONArray.Create;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM HITEMS_MEDIA_STORE ' +
              'WHERE USERID = :param1 ' +
              'ORDER BY REG_NO DESC ');
      ParamByName('param1').AsString := aEmpNo;

      Open;

      if RecordCount <> 0 then
      begin
        while not eof do
        begin
          regNo := FieldByName('REG_NO').AsString;
          regName := Get_userNameAndPosition(FieldByName('USERID').AsString);
          regDate := Format_Occur_Time(regNo);

          fileName := regNo +'.'+ FieldByName('FILE_EXT').AsString;

          if FieldByName('FILE_DESC').IsNull then
            description := 'null'
          else
            description := FieldByName('FILE_DESC').AsString;


          refPath := ExtractFilePath(Application.ExeName);
          refPath := refPath + '\mediastore\thumbnail\';

          if not(DirectoryExists(refPath)) then
            ForceDirectories(refPath);


          fullpath := refPath + fileName;
          if FileExists(fullpath) = false then
          begin
            try
              MS := TMemoryStream.Create;
              TBlobField(FieldByName('FILES')).SaveToStream(MS);
              MS.Position := 0;

              ThumbnailFromImage(fullPath,MS,520);
            finally
              FreeAndNil(MS);
            end;
          end;

          JSONObj := TJSONObject.Create;
          JSONObj.AddPair('REGNO',regNo)
                 .AddPair('REGNM',regName)
                 .AddPair('REGDATE',regDate)
                 .AddPair('DESC',description)
                 .AddPair('FILENAME',fileName);

          Result.Add(JSONObj);

          Next;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;


function TServerMethods_Photorum.Get_EmpList(aUserId: String): TJSONArray;
var
  OraQuery : TOraQuery;
  lJsonObj : TJSONObject;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT USERID, NAME_KOR, DESCR FROM HITEMS_USER A, HITEMS_USER_GRADE B ' +
              'WHERE DEPT_CD LIKE :param1 ' +
              'AND A.USERID = B.USERID ' +
              'AND GUNMU = ''I'' ' +
              'ORDER BY PRIV DESC, CLASS_, USERID ');
      ParamByName('param1').AsString := Get_DeptNo(aUserId);
      Open;

      if RecordCount <> 0 then
      begin
        Result := TJSONArray.Create;
        while not eof do
        begin
          lJsonObj := TJSONObject.Create;

          lJsonObj.AddPair('USERID',FieldByName('USERID').AsString)
                  .AddPair('NAME',FieldByName('NAME_KOR').AsString)
                  .AddPair('DESCR',FieldByName('DESCR').AsString);

          Result.Add(lJsonObj);
          Next;

        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

constructor TServerMethods_Photorum.Create(AOwner: TComponent);
begin
  inherited;
  FID := GetNewGUID;

end;

destructor TServerMethods_Photorum.Destroy;
begin
  inherited;

end;


function TServerMethods_Photorum.Format_Occur_Time(aOccurTime: String): String;
var
  year,
  Month,
  Day,
  Hour,
  Minute,
  Second,
  milsec : String;
begin
  Result := '';
  if aOccurTime <> '' then
  begin
    year   := Copy(aOccurTime,1,4);
    Month  := Copy(aOccurTime,5,2);
    Day    := Copy(aOccurTime,7,2);

    Hour   := Copy(aOccurTime,9,2);
    Minute := Copy(aOccurTime,11,2);
    Second := Copy(aOccurTime,13,2);
    milsec := Copy(aOccurTime,15,3);

    Result := year+'-'+Month+'-'+Day+' '+Hour+':'+Minute+':'+Second+'.'+milsec;
  end;
end;

function TServerMethods_Photorum.Gen_RegistrationNo(aDateTime: TDateTime): String;
begin
  Result := FormatDateTime('YYYYMMDDHHmmsszzz',aDateTime);

end;

end.


{
2.function TMyDSServer.PutFile(Stream: TStream): Boolean;
3.const
4.  BufSize = $F000;
5.var
6.  Buffer: TBytes;
7.  ReadCount: Integer;
8.begin
9.  if Stream.Size = -1 then  // 大小未知则一直读取到没有数据为止
10.    begin
11.        SetLength(Buffer, BufSize);
12.        repeat
13.          ReadCount := Stream.Read(Buffer[0], BufSize);
14.            if ReadCount > 0 then
15.              FS.WriteBuffer(Buffer[0], ReadCount);
16.                if ReadCount < BufSize then
17.                  break;
18.        until ReadCount < BufSize;
19.      end  else // 大小已知则直接复制数据
20.    FS.CopyFrom(Stream, 0);
21.  Result := True;
22.end;

function TServerMethods_Photorum.Base64Decode(const EncodedStr : string): TBytes;
var
  i: Integer;
  a: Integer;
  x: Integer;
  b: Integer;
begin
  Result := '';
  a := 0;
  b := 0;
  for i := 1 to Length(EncodedStr) do
  begin
    x := Pos(EncodedStr[i], code64) - 1;
    if x >= 0 then
    begin
      b := b * 64 + x;
      a := a + 6;
      if a >= 8 then
      begin
        a := a - 8;
        x := b shr a;
        b := b mod (1 shl a);
        x := x mod 256;
        Result := Result + chr(x);
      end;
    end
    else
      Exit;
  end;
end;

upload image decode base64
case : 0
  if aImages.Size > 0 then
  begin
    EncodedStr := Return_Values(aImages.Get('IMAGEBASE64'));
    if EncodedStr <> '' then
    begin
      data := Base64Decode(EncodedStr);

      if Length(data) > 0 then
      begin
        mst := TMemoryStream.Create;
        try
          mst.WriteBuffer(data[0], Length(data));
          mst.Position := 0;

          image := TJPEGImage.Create;
          try
            image.LoadFromStream(mst);

          finally
            image.Free;
          end;

        finally
          mst.Free;
        end;
      end;
    end;
  end;

  case : 1
    EncodedStr := Return_Values(aImages.Get('IMAGEBASE64'));
    if EncodedStr <> '' then
    begin
      xByte := strToByte(EncodedStr);
      for i := 0 to Length(xByte)-1 do
        data[i] := xByte[i];

      if Length(data) > 0 then
      begin
        mst := TMemoryStream.Create;
        try
          mst.WriteBuffer(data[0], Length(data));
          mst.Position := 0;
          mst.SaveToFile('c:\mststream.jpg');

          image := TJPEGImage.Create;
          try
            image.LoadFromStream(mst);


          finally
            image.Free;
          end;

        finally
          mst.Free;
        end;
      end;
    end;


    //base64 Decode use MIME
var
  DecodedStm : TBytesStream;
  Decoder : TIdDecoderMIME;
begin
  Decoder := TIdDecoderMIME.Create(nil);
  try
    DecodedStm := TBytesStream.Create;
    try
      Decoder.DecodeBegin(DecodedStm);
      Decoder.Decode(EncodedStr);
      Decoder.DecodeEnd;
      Result := DecodedStm.Bytes;
    finally
      DecodedStm.Free;
    end;
  finally
    Decoder.Free;
  end;
end;


javaAndroid // Base64 //Decode converter version
var
  lend,
  llen,
  ldst,
  lsrc,
  lcode : Integer;

begin
  lend := 0;
  if EndsStr('=',EncodedStr) then
    Inc(lend);

  if EndsStr('==',EncodedStr) then
    Inc(lend);

  llen := (Length(EncodedStr)+3) div 4 * 3 - lend;

  SetLength(Result, llen);

  ldst := 0;
  for lsrc := 0 to Length(EncodedStr) do
  begin
    lcode := ord(EncodedStr[lsrc]);

    if lcode = -1 then
      break;

    case lsrc mod 4 of
      0 :
      begin
        result[ldst] := lcode shl 2;
      end;
      1 :
      begin
        result[Inc(ldst)] := lcode shl 2;
        result[ldst] := lcode shl 4;
      end;
      2 :
      begin
        result[ldst] := lcode shl 6;
      end;
      3 :
      begin
        result[ldst] := lcode shl 6;
      end;
    end;
  end;
end;
}
