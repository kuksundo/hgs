unit UnitHiMECSHttpApiServer;

interface

uses
  SysUtils,
  SynCommons,
  SynZip,
  SynCrtSock;

type
  THiMECSHttpApiServer = class
  protected
    fPath: TFileName;
    fServer: THttpApiServer;
    function OnRequest(Ctxt: THttpServerRequest): cardinal;
  public
    constructor Create(const Path: TFileName);
    destructor Destroy; override;
  end;

implementation

{ THiMECSHttpApiServer }

//http://localhost:8888/root 에서 실행중
constructor THiMECSHttpApiServer.Create(const Path: TFileName);
begin
  fPath := IncludeTrailingPathDelimiter(Path);

  fServer := THttpApiServer.Create(false);
  fServer.AddUrl('root','8888',false,'+',true);
  fServer.RegisterCompress(CompressDeflate); // our server will deflate html :)
  fServer.OnRequest := OnRequest;
  fServer.Clone(31); // will use a thread pool of 32 threads in total
end;

destructor THiMECSHttpApiServer.Destroy;
begin
  fServer.Free;

  inherited;
end;

function THiMECSHttpApiServer.OnRequest(Ctxt: THttpServerRequest): cardinal;
var W: TTextWriter;
    FileName: TFileName;
    FN, SRName, href, LJson: RawUTF8;
    i: integer;
    SR: TSearchRec;

  procedure hrefCompute;
  begin
    SRName := StringToUTF8(SR.Name);
    href := FN+StringReplaceChars(SRName,'\','/');
  end;

begin
//  writeln(Ctxt.Method,' ',Ctxt.URL);

  if not IdemPChar(pointer(Ctxt.URL),'/ROOT')  then begin
    result := 404;
    exit;
  end;

  FN := StringReplaceChars(UrlDecode(copy(Ctxt.URL,7,maxInt)),'/','\');

  if PosEx('..',FN)>0 then begin
    result := 404; // circumvent obvious potential security leak
    exit;
  end;

  while (FN<>'') and (FN[1]='\') do
    delete(FN,1,1);

  while (FN<>'') and (FN[length(FN)]='\') do
    delete(FN,length(FN),1);

  FileName := fPath+UTF8ToString(FN);

  if FileExists(FileName) then
  begin
    LJson := StringFromFile(FileName);

    Ctxt.OutContent := StringToUTF8(LJson);
    Ctxt.OutCustomHeaders := 'Access-Control-Allow-Origin: *';
    Ctxt.OutContentType := JSON_CONTENT_TYPE;//TEXT_CONTENT_TYPE;//JSON_CONTENT_TYPE;

    result := 200;
  end
  else
  begin
    // http.sys will send the specified file from kernel mode
    Ctxt.OutContent := StringToUTF8(FileName);
    Ctxt.OutContentType := HTTP_RESP_STATICFILE;
    result := 200; // THttpApiServer.Execute will return 404 if not found
  end;
end;

end.
