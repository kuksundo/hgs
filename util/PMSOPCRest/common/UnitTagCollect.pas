unit UnitTagCollect;

interface

uses System.Classes, mORMot, SynCommons;

type
  TTagItem = class(TCollectionItem)
  private
    FTagName: RawUTF8;
    FTagDesc: RawUTF8;
    FTagType: RawUTF8;
    FTagValue: RawUTF8;
    FUnitID: RawUTF8;
  published
    property TagName: RawUTF8 read FTagName write FTagName;
    property TagDesc: RawUTF8 read FTagDesc write FTagDesc;
    property TagType: RawUTF8 read FTagType write FTagType;
    property TagValue: RawUTF8 read FTagValue write FTagValue;
    property UnitID: RawUTF8 read FUnitID write FUnitID;
  end;

  TTagCollect = class(TInterfacedCollection)
  private
    function GetCollItem(aIndex: Integer): TTagItem;
  protected
    class function GetClass: TCollectionItemClass; override;
  public
    function Add: TTagItem;
    property Item[Index: Integer]: TTagItem read GetCollItem; default;
  end;

  TTagItem4OPCAddItem = class(TCollectionItem)
  private
    FTagName: string;
    FTagDesc: string;
    FTagType: string;
  published
    property TagName: string read FTagName write FTagName;
    property TagDesc: string read FTagDesc write FTagDesc;
    property TagType: string read FTagType write FTagType;
  end;

  TTagCollect4OPCAddItem = class(TInterfacedCollection)
  private
    function GetCollItem(aIndex: Integer): TTagItem4OPCAddItem;
  protected
    class function GetClass: TCollectionItemClass; override;
  public
    function Add: TTagItem4OPCAddItem;
    property Item[Index: Integer]: TTagItem4OPCAddItem read GetCollItem; default;
  end;

var
  FTagName4AddItem: array of string;

implementation

{ TTagItems }

function TTagCollect.Add: TTagItem;
begin
  result := TTagItem(inherited Add);
end;

class function TTagCollect.GetClass: TCollectionItemClass;
begin
  result := TTagItem;
end;

function TTagCollect.GetCollItem(aIndex: Integer): TTagItem;
begin
  result := TTagItem(GetItem(aIndex));
end;

{ TTagCollect4OPCAddItem }

function TTagCollect4OPCAddItem.Add: TTagItem4OPCAddItem;
begin
  result := TTagItem4OPCAddItem(inherited Add);
end;

class function TTagCollect4OPCAddItem.GetClass: TCollectionItemClass;
begin
  result := TTagItem4OPCAddItem;
end;

function TTagCollect4OPCAddItem.GetCollItem(
  aIndex: Integer): TTagItem4OPCAddItem;
begin
  result := TTagItem4OPCAddItem(GetItem(aIndex));
end;

end.
