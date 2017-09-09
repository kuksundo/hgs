unit UnitRSSAddressClass;

interface

uses classes, SysUtils, ExtCtrls, Vcl.Graphics, BaseConfigCollect,
  SortCollections, System.Types;

type
  TNewsCategory = (ncBreakNews, ncEconomy, ncAllNews);
  TNewsCategories = set of TNewsCategory;

  TRSSAddressCollect = class;
  TRSSAddressItem = class;
  TRSSAddressColumnHeaderCollect = class;
  TRSSAddressColumnHeaderItem = class;
  TRSSNewsList = class;
  TRSSNewsItem = class;

  TRSSAddressInfo = class(TpjhBase)
  private
    FRSSAddressCollect: TRSSAddressCollect;
    FRSSAddressColumnHeaderCollect: TRSSAddressColumnHeaderCollect;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
  published
    property RSSAddressCollect: TRSSAddressCollect read FRSSAddressCollect write FRSSAddressCollect;
    property RSSAddressColumnHeaderCollect: TRSSAddressColumnHeaderCollect read FRSSAddressColumnHeaderCollect write FRSSAddressColumnHeaderCollect;
  end;

  TRSSAddressItem = class(TCollectionItem)
  private
    FNewsGubun,
    FRSSAddress,
    FRSSDescription: string;
    FFetchCount: integer; //가져올 건수
    FNewsCategory: TNewsCategory;
    FRSSUsed: Boolean; //주소 사용유무
//    FNewsCategories: TNewsCategories;
  published
    property NewsGubun: string read FNewsGubun write FNewsGubun;
    property RSSAddress: string read FRSSAddress write FRSSAddress;
    property RSSDescription: string read FRSSDescription write FRSSDescription;
    property FetchCount: integer read FFetchCount write FFetchCount;
    property NewsCategory: TNewsCategory read FNewsCategory write FNewsCategory;
    property RSSUsed: Boolean read FRSSUsed write FRSSUsed;
//    property NewsCategories: TNewsCategories read FNewsCategories write FNewsCategories;
  end;

  TRSSAddressCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TRSSAddressItem;
    procedure SetItem(Index: Integer; const Value: TRSSAddressItem);
  public
    function Add: TRSSAddressItem;
    function Insert(Index: Integer): TRSSAddressItem;
    property Items[Index: Integer]: TRSSAddressItem read GetItem  write SetItem; default;
  end;

  TRSSAddressColumnHeaderItem = class(TCollectionItem)
  private
    FColumnHeaderData: string;
  published
    property ColumnHeaderData: string read FColumnHeaderData write FColumnHeaderData;
  end;

  TRSSAddressColumnHeaderCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TRSSAddressColumnHeaderItem;
    procedure SetItem(Index: Integer; const Value: TRSSAddressColumnHeaderItem);
  public
    function  Add: TRSSAddressColumnHeaderItem;
    function Insert(Index: Integer): TRSSAddressColumnHeaderItem;
    property Items[Index: Integer]: TRSSAddressColumnHeaderItem read GetItem  write SetItem; default;
  end;

  TRSSNewsItem = class(TCollectionItem)
  private
    FNewsCompany, //뉴스회사명
    FNewType,     //뉴스종류(전체뉴스,경제뉴스등)
    FNewsLink,    //뉴스 원문 Url Link
    FNewsTitle,   //뉴스 제목
    FNewsContent: string;  //뉴스 내용
    FNewsUpdateDate: TDateTime; //뉴스 갱신 일자
  published
    property NewsCompany: string read FNewsCompany write FNewsCompany;
    property NewType: string read FNewType write FNewType;
    property NewsLink: string read FNewsLink write FNewsLink;
    property NewsTitle: string read FNewsTitle write FNewsTitle;
    property NewsContent: string read FNewsContent write FNewsContent;
    property NewsUpdateDate: TDateTime read FNewsUpdateDate write FNewsUpdateDate;
  end;

  TRSSNewsList = class(TSortableCollection)
  private
    FNewsContentXML: string;

    function GetItem(Index: Integer): TRSSNewsItem;
    procedure SetItem(Index: Integer; const Value: TRSSNewsItem);
  protected
    function Compare(Item1, Item2 : TCollectionItem) : integer; override;
  public
    function  Add: TRSSNewsItem;
    function Insert(Index: Integer): TRSSNewsItem;
    property Items[Index: Integer]: TRSSNewsItem read GetItem  write SetItem; default;
    property NewsContentXML: string read FNewsContentXML write FNewsContentXML;
  end;

implementation

{ TRSSAddressCollect }

function TRSSAddressCollect.Add: TRSSAddressItem;
begin
  Result := TRSSAddressItem(inherited Add);
end;

function TRSSAddressCollect.GetItem(Index: Integer): TRSSAddressItem;
begin
  Result := TRSSAddressItem(inherited Items[Index]);
end;

function TRSSAddressCollect.Insert(Index: Integer): TRSSAddressItem;
begin
  Result := TRSSAddressItem(inherited Insert(Index));
end;

procedure TRSSAddressCollect.SetItem(Index: Integer;
  const Value: TRSSAddressItem);
begin
  Items[Index].Assign(Value);
end;

{ TRSSAddressColumnHeaderCollect }

function TRSSAddressColumnHeaderCollect.Add: TRSSAddressColumnHeaderItem;
begin
  Result := TRSSAddressColumnHeaderItem(inherited Add);
end;

function TRSSAddressColumnHeaderCollect.GetItem(
  Index: Integer): TRSSAddressColumnHeaderItem;
begin
  Result := TRSSAddressColumnHeaderItem(inherited Items[Index]);
end;

function TRSSAddressColumnHeaderCollect.Insert(
  Index: Integer): TRSSAddressColumnHeaderItem;
begin
  Result := TRSSAddressColumnHeaderItem(inherited Insert(Index));
end;

procedure TRSSAddressColumnHeaderCollect.SetItem(Index: Integer;
  const Value: TRSSAddressColumnHeaderItem);
begin
  Items[Index].Assign(Value);
end;

{ TRSSAddressInfo }

procedure TRSSAddressInfo.Clear;
begin
end;

constructor TRSSAddressInfo.Create(AOwner: TComponent);
begin
  FRSSAddressCollect := TRSSAddressCollect.Create(TRSSAddressItem);
  FRSSAddressColumnHeaderCollect := TRSSAddressColumnHeaderCollect.Create(TRSSAddressColumnHeaderItem);
end;

destructor TRSSAddressInfo.Destroy;
begin
  FreeAndNil(FRSSAddressColumnHeaderCollect);
  FreeAndNil(FRSSAddressCollect);

  inherited;
end;

{ TRSSNewsList }

function TRSSNewsList.Add: TRSSNewsItem;
begin
  Result := TRSSNewsItem(inherited Add);
end;

function TRSSNewsList.Compare(Item1, Item2: TCollectionItem): integer;
begin
  if TRSSNewsItem(item1).NewsUpdateDate < TRSSNewsItem(item2).NewsUpdateDate then
    Result := -1
  else if TRSSNewsItem(item1).NewsUpdateDate > TRSSNewsItem(item2).NewsUpdateDate then
    Result := 1
  else
    Result := 0;
end;

function TRSSNewsList.GetItem(Index: Integer): TRSSNewsItem;
begin
  Result := TRSSNewsItem(inherited Items[Index]);
end;

function TRSSNewsList.Insert(Index: Integer): TRSSNewsItem;
begin
  Result := TRSSNewsItem(inherited Insert(Index));
end;

procedure TRSSNewsList.SetItem(Index: Integer; const Value: TRSSNewsItem);
begin
  Items[Index].Assign(Value);
end;

end.
