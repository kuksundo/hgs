unit u_MyItemHash;

interface

uses
  Classes,
  u_MyItem;

{$DEFINE __HASH_TEMPLATE__}
type
  _HASH_ANCESTOR_ = TObject; // or TInterfacedObject
  _HASH_ITEM_ = TMyItem;
const
  _HASH_EMPTY_ITEM_ = nil;
{$INCLUDE 't_dzHashTemplate.tpl'}

type
  TMyItemHash = class(_HASH_TEMPLATE_)
  end;

implementation

{$INCLUDE 't_dzHashTemplate.tpl'}

end.

