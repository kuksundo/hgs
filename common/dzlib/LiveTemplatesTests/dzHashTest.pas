unit dzHashTest;

interface

uses
  Classes;

type
  TMyObject = class

  end;

{$DEFINE __HASH_TEMPLATE__}
type
  _HASH_ANCESTOR_ = TObject;
  _HASH_ITEM_ = TMyObject;
const
  _HASH_EMPTY_ITEM_ = nil;
{$INCLUDE 't_dzHashTemplate.tpl'}

type
  {: Hash for storing TMyObject items }
  TMyList = class(_HASH_TEMPLATE_)
  end;

implementation

{$INCLUDE 't_dzHashTemplate.tpl'}

end.
