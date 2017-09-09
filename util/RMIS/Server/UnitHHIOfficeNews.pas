unit UnitHHIOfficeNews;

interface

uses System.SysUtils, System.StrUtils, System.Classes, SynCommons,
  Sea_Ocean_News_Class, mORMot, RMISConst, UnitHhiOfficeNewsInterface, mORMotHttpClient;

type
  THHIOfficeNews = class
  public
    FClient_HhiOfficeNews: TSQLRestClientURI;
    FModel_HhiOfficeNews: TSQLModel;
    Server_HhiOfficeNews: AnsiString;
    PortNum_HhiOfficeNews: string;
    FClient_Connected: Boolean;
    FSONewsList: TStringList;//일간조선해양 뉴스
    FSeaOceanNewsCollect: TSONewsCollect;//일간조선해양 뉴스(TCollect 에 저장함 )

    constructor Create;
    destructor Destroy;

    procedure ConnectToHhiOfficeNewsServer(AIp,APort: string);
    procedure CreateHTTPClient_HhiOfficeNews(AServerIP,APort: string);
    procedure DestroyHTTPClient_HhiOfficeNews;
    procedure GetHhiOfficeNewsFromServer(AIP,APort: string);
    function GetSONewsFromList: TRawUTF8DynArray;
  end;

implementation

{ THHIOfficeNews }

procedure THHIOfficeNews.ConnectToHhiOfficeNewsServer(AIp,APort: string);
var
  Lip: string;
begin
//  if FSettings.ServerIP_HhiOfficeNews <> '' then
//    Lip := FSettings.ServerIP_HhiOfficeNews
  if AIp <> '' then
    Lip := AIp
  else
    Lip := 'localhost';

  CreateHTTPClient_HhiOfficeNews(Lip,APort);
end;

constructor THHIOfficeNews.Create;
begin
  FSeaOceanNewsCollect := TSONewsCollect.Create(TSONewsItem);
  TJSONSerializer.RegisterCollectionForJSON(TSONewsCollect, TSONewsItem);
  FSONewsList := TStringList.Create;
end;

procedure THHIOfficeNews.CreateHTTPClient_HhiOfficeNews(AServerIP,APort: string);
begin
  if Assigned(FClient_HhiOfficeNews) then
    DestroyHTTPClient_HhiOfficeNews;

  if FClient_HhiOfficeNews = nil then
  begin
    if FModel_HhiOfficeNews = nil then
      FModel_HhiOfficeNews := TSQLModel.Create([],HHIOFFICE_ROOT_NAME);

    FClient_HhiOfficeNews := TSQLHttpClient.Create(AServerIP,APort, FModel_HhiOfficeNews);

    if not FClient_HhiOfficeNews.ServerTimeStampSynchronize then
    begin
      //ShowMessage(UTF8ToString(FClient_News.LastErrorMessage));
      DestroyHTTPClient_HhiOfficeNews;
      exit;
    end;

    //TSQLRestServerAuthenticationNone.ClientSetUser(Client,'User','');
    FClient_HhiOfficeNews.SetUser('User','synopse');//'BWQueryServer','BWQryServer');
    FClient_HhiOfficeNews.ServiceRegister([TypeInfo(IHhiOfficeNewsList)],sicShared);
    FClient_Connected := True;
  end;
end;

destructor THHIOfficeNews.Destroy;
begin
  FSeaOceanNewsCollect.Free;
  FSONewsList.Free;
end;

procedure THHIOfficeNews.DestroyHTTPClient_HhiOfficeNews;
begin
  if Assigned(FClient_HhiOfficeNews) then
    FreeAndNil(FClient_HhiOfficeNews);

  if Assigned(FModel_HhiOfficeNews) then
    FreeAndNil(FModel_HhiOfficeNews);

//  FCS.DisplayMessage(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + UTF8ToString(FClient_HhiOfficeNews.LastErrorMessage), dtSystemLog);
  g_DisplayMessage2FCS(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : CreateHTTPClient_HhiOfficeNews', 0);
  FClient_Connected := False;
end;

procedure THHIOfficeNews.GetHhiOfficeNewsFromServer(AIP,APort: string);
var
  I: IHhiOfficeNewsList;
  LDynArr: TRawUTF8DynArray;
  Li,LRow: integer;
  LStr: string;
  LSCA: TServiceCustomAnswer;
begin
  LDynArr := nil;

  if not Assigned(FClient_HhiOfficeNews) then
  begin
    try
      ConnectToHhiOfficeNewsServer(AIP,APort);
    except
      on E: Exception do
      begin
        DestroyHTTPClient_HhiOfficeNews;
        g_DisplayMessage2FCS(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message, 0);//dtSystemLog
        g_DisplayMessage2FCS(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : DestroyHTTPClient_News', 0);//dtSystemLog
        exit;
      end;
    end;
  end;

  if not Assigned(FClient_HhiOfficeNews) then
  begin
    g_DisplayMessage2FCS(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : GetNewsFromServer Error => not Assigned(FClient_HhiOfficeNews)', 0);//dtSystemLog
    exit;
  end;

  I := FClient_HhiOfficeNews.Service<IHhiOfficeNewsList>;

  try
    if I <> nil then
      I.GetHhiOfficeNewsList2(FSeaOceanNewsCollect);
//      LDynArr := I.GetHhiOfficeNewsList;

  except
    on E: Exception do
    begin
      DestroyHTTPClient_HhiOfficeNews;
      g_DisplayMessage2FCS(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message, 0);
      g_DisplayMessage2FCS(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : DestroyHTTPClient_News', 0);
      exit;
    end;
  end;

//  FNewsList2.Clear;

  g_DisplayMessage2FCS(DateTimeToStr(Now) + ' : GetHhiOfficeNewsFromServer [ ' + IntToStr(FSeaOceanNewsCollect.Count) + ' 개 뉴스 수신 ]', 2);
//  for Li := 0 to High(LDynArr) - 1 do
  for Li := 0 to FSeaOceanNewsCollect.Count - 1 do
  begin
    g_DisplayMessage2FCS(DateTimeToStr(Now) + ' : 일간조선해양뉴스: ' + FSeaOceanNewsCollect.Items[Li].NewsContent, 2);//dtCommLog
//    if LDynArr[Li] <> '' then
//    begin
//      LStr := Utf8ToString(LDynArr[Li]);
//      LStr := StringReplace(LStr, '- ', '', [rfReplaceAll, rfIgnoreCase]);
//      FNewsList2.Add(LStr);
//    end;
  end;

//  g_DisplayMessage2FCS(DateTimeToStr(Now) + ' : GetHhiOfficeNewsFromServer [ ' + IntToStr(FNewsList2.Count) + ' 개 뉴스 수신 ]', dtCommLog);

//  for Li := 0 to FNewsList2.Count - 1 do
//    g_DisplayMessage2FCS(DateTimeToStr(Now) + ' : 일간조선해양뉴스: ' + FNewsList2.Strings[Li], dtCommLog);

  try
    if I <> nil then
    begin
      LSCA := I.GetAttachFileHhiOfficeNews('');
      FileFromString(LSCA.Content, SHIP_OCEAN_PDF_FILE);
    end;
  except
    on E: Exception do
    begin
      DestroyHTTPClient_HhiOfficeNews;
      g_DisplayMessage2FCS(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : ' + E.Message, 0);
      g_DisplayMessage2FCS(FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' : DestroyHTTPClient_News', 0);
      exit;
    end;
  end;

  I := nil;
  DestroyHTTPClient_HhiOfficeNews;
end;

function THHIOfficeNews.GetSONewsFromList: TRawUTF8DynArray;
var
  LCount: integer;
  LDynArr: TDynArray;
  LValue: RawUTF8;
  i: integer;
begin
  LDynArr.Init(TypeInfo(TRawUTF8DynArray),Result,@LCount);

  LValue := '일간조선해양 ( Updated:  ' + FormatDateTime('mm월 dd일, hh:nn:ss', now) + ' )';
  LDynArr.Add(LValue);

  for i := 0 to FSONewsList.Count - 1 do
  begin
    LValue := StringToUTF8(FSONewsList.Strings[i]);
    LDynArr.Add(LValue);
  end;

  g_DisplayMessage2FCS(DateTimeToStr(Now) + ' : GetNewsService2 [ ' + IntToStr(FSONewsList.Count) + ' 개 뉴스 전송 ]', 2);
end;

end.
