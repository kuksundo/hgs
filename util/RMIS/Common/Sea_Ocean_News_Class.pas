unit Sea_Ocean_News_Class;

interface

uses classes, SysUtils, ExtCtrls, SynCommons;

type
  TSONewsCollect = class;
  TSONewsItem = class;

  TSONewsItem = class(TCollectionItem)
  private
    FPdfPageNo: integer;
    FNewsContent: string;
  published
    property NewsContent: string read FNewsContent write FNewsContent;
    property PdfPageNo: integer read FPdfPageNo write FPdfPageNo;
  end;

  TSONewsCollect = class(TCollection)
  private
    function GetItem(Index: Integer): TSONewsItem;
    procedure SetItem(Index: Integer; const Value: TSONewsItem);
  public
    function  Add: TSONewsItem;
    function Insert(Index: Integer): TSONewsItem;
    property Items[Index: Integer]: TSONewsItem read GetItem  write SetItem; default;
  end;

implementation

{ TSONewsCollect }

function TSONewsCollect.Add: TSONewsItem;
begin
  Result := TSONewsItem(inherited Add);
end;

function TSONewsCollect.GetItem(Index: Integer): TSONewsItem;
begin
  Result := TSONewsItem(inherited Items[Index]);
end;

function TSONewsCollect.Insert(Index: Integer): TSONewsItem;
begin
  Result := TSONewsItem(inherited Insert(Index));
end;

procedure TSONewsCollect.SetItem(Index: Integer; const Value: TSONewsItem);
begin
  Items[Index].Assign(Value);
end;

end.
