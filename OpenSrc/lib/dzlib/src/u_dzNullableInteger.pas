unit u_dzNullableInteger;

interface

uses
  SysUtils,
  Math,
  Variants,
  u_dzTranslator,
  u_dzStringUtils,
  u_dzVariantUtils,
  u_dzConvertUtils,
  u_dzNullableTypesUtils;

{$DEFINE __DZ_NULLABLE_NUMBER_TEMPLATE__}
type
  _NULLABLE_TYPE_BASE_ = integer;
const
  _NULLABLE_TYPE_NAME_ = 'TNullableInteger';
{$INCLUDE 't_NullableNumber.tpl'}

type
  TNullableInteger = _NULLABLE_NUMBER_;

implementation

{$INCLUDE 't_NullableNumber.tpl'}

end.

