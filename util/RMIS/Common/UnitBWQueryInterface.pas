unit UnitBWQueryInterface;

interface

uses SynCommons, BW_Query_Class, mORMot, Sea_Ocean_News_Class;

type
  IBWQuery = interface(IInvokable)
    ['{0E473F1C-416C-412F-BD9F-98A31466EA70}']
    function GetBWQryClass(AQueryName: RawUTF8; out ACount: Integer): TRawUTF8DynArray;
    function GetCellData(AQueryName: RawUTF8; out AEPCollect: TBWQryCellDataCollect): Boolean;
    function GetCellDataAll(out ABWQryCellDataAll: TBWQryCellDataAllCollect): Boolean;
    function GetRowHeaderData(AQueryName: RawUTF8; out AColCountOfRow: integer;  out AEPCollect: TBWQryRowHeaderCollect): Boolean;
    function GetColHeaderData(AQueryName: RawUTF8; out AEPCollect: TBWQryColumnHeaderCollect): Boolean;
    function GetOrderPlanPerProduct(out ACollect: TBWQryCellDataCollect): Boolean; //제품별 월별 수주 경영계획
    function GetSalesPlanPerProduct(out ACollect: TBWQryCellDataCollect): Boolean; //제품별 월별 매출 경영계획
    function GetProfitPlanPerProduct(out ACollect: TBWQryCellDataCollect): Boolean; //제품별 월별 손익 경영계획
    function GetNewsList2: TRawUTF8DynArray; //일간 조선 해양 뉴스
//    function GetAttachFileHhiOfficeNews(AFileName: RawUTF8): TServiceCustomAnswer; //일간 조선 해양 뉴스 첨부파일(pdf) 반환
    procedure GetAttachFileHhiOfficeNews2(AFileName:RawUTF8; out AFile: RawByteString); //일간 조선 해양 뉴스 첨부파일(pdf) 반환
    procedure GetHhiOfficeNewsList2(out ASeaOceanNewsCollect: TSONewsCollect);
    function GetInquiryPerProdPerGrade: TRawUTF8DynArray; //등급별 제품별 Inquiry 금액
  end;

const
  BWQRY_ROOT_NAME = 'root';
//  BWQRY_PORT_NAME = '701';
  BWQRY_PORT_NAME = '704';
  BWQRY_APPLICATION_NAME = 'BWQRY__RestService';
  BWQRY_DEFAULT_IP = '10.14.21.117';

implementation

end.
