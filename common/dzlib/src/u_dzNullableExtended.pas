unit u_dzNullableExtended;

interface

uses
  SysUtils,
  Math,
  Variants,
  u_dzTranslator,
  u_dzVariantUtils,
  u_dzConvertUtils,
  u_dzStringUtils,
  u_dzNullableTypesUtils;

{$DEFINE __DZ_NULLABLE_NUMBER_TEMPLATE__}
type
  _NULLABLE_TYPE_BASE_ = Extended;
const
  _NULLABLE_TYPE_NAME_ = 'TNullableExtended';
{$INCLUDE 't_NullableNumber.tpl'}

type
  TNullableExtended = _NULLABLE_NUMBER_;

implementation

{$INCLUDE 't_NullableNumber.tpl'}

end.

