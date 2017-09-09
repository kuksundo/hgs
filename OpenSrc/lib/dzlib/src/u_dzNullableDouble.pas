unit u_dzNullableDouble;

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
  _NULLABLE_TYPE_BASE_ = Double;
const
  _NULLABLE_TYPE_NAME_ = 'TNullableDouble';

{$INCLUDE 't_NullableNumber.tpl'}

type
  TNullableDouble = _NULLABLE_NUMBER_;

implementation

{$INCLUDE 't_NullableNumber.tpl'}

end.

