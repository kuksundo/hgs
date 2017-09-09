unit u_dzNullableInt64;

interface

uses
  SysUtils,
  Math,
  Variants,
  u_dzTranslator,
  u_dzVariantUtils,
  u_dzConvertUtils,
  u_dzNullableTypesUtils;

{$DEFINE __DZ_NULLABLE_NUMBER_TEMPLATE__}
type
  _NULLABLE_TYPE_BASE_ = Int64;
const
  _NULLABLE_TYPE_NAME_ = 'TNullableInt64';
{$INCLUDE 't_NullableNumber.tpl'}

type
  TNullableInt64 = _NULLABLE_NUMBER_;

implementation

{$INCLUDE 't_NullableNumber.tpl'}

end.

