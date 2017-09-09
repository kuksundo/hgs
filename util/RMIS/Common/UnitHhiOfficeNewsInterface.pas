unit UnitHhiOfficeNewsInterface;

interface

uses SynCommons, mORMot, Sea_Ocean_News_Class;

type
  IHhiOfficeNewsList = interface(IInvokable)
  ['{9D4FFA7F-73D5-43D5-B5DF-F0FA0102C422}']
    function GetHhiOfficeNewsList: TRawUTF8DynArray; //일간 조선 해양 뉴스
    function GetTimeOnHhiOfficeNews: RawUTF8; //일간 조선 해양 뉴스 가져오는 시간(RAlarm 설정 값)
    function GetAttachFileHhiOfficeNews(AFileName: RawUTF8): TServiceCustomAnswer; //일간 조선 해양 뉴스 첨부파일(pdf) 반환
    procedure GetHhiOfficeNewsList2(out ASeaOceanNewsCollect: TSONewsCollect);
//    procedure GetAttachFileHhiOfficeNews(Ctxt: TSQLRestServerURIContext); //일간 조선 해양 뉴스 첨부파일(pdf) 반환
  end;

const
  HHIOFFICE_ROOT_NAME = 'root';
  HHIOFFICE_PORT_NAME = '702';
  HHIOFFICE_APPLICATION_NAME = 'HhiOfficeNews_RestService';
  SHIP_OCEAN_PDF_FILE = 'c:\temp\일간조선해양.pdf';

implementation

end.
