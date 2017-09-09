unit u_dzIniEntryList;

interface

uses
  SysUtils,
  Classes,
  u_dzQuicksort;

type
  TIniEntryAbstract = class
  private
    FLine: string;
    FComment: string;
  public
    constructor Create(const _Line: string);
    function NameOnly: string; virtual; abstract;
    property Line: string read FLine;
    property Comment: string read FComment write FComment;
  end;

type
  ICompareIniEntries = interface ['{B60AFA09-F11C-422F-9BE1-9205018F4183}']
    function Compare(_Idx1, _Idx2: integer): integer;
  end;

{$DEFINE __DZ_OBJECT_LIST_TEMPLATE__}
type
  _LIST_ANCESTOR_ = TObject;
  _ITEM_TYPE_ = TIniEntryAbstract;
{$INCLUDE 't_dzObjectListTemplate.tpl'}

type
  {: List for storing TIniItem items }
  TIniEntryList = class(_DZ_OBJECT_LIST_TEMPLATE_)
    procedure Sort(_DataHandler: IQSDataHandler);
  end;

implementation

{$INCLUDE 't_dzObjectListTemplate.tpl'}

{ TIniEntryAbstract }

constructor TIniEntryAbstract.Create(const _Line: string);
begin
  inherited Create;
  FLine := _Line;
end;

{ TIniEntryList }

procedure TIniEntryList.Sort(_DataHandler: IQSDataHandler);
begin
  QuickSort(0, Count - 1, _DataHandler);
end;

end.

