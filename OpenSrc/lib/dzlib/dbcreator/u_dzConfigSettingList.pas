unit u_dzConfigSettingList;

interface

uses
  Classes;

type
  TdzConfigSetting = class
  protected
    FName: string;
    FValue: string;
  public
    constructor Create(const _Name, _Value: string);
  end;

{$DEFINE __DZ_OBJECT_LIST_TEMPLATE__}
type
  _LIST_ANCESTOR_ = TObject;
  _ITEM_TYPE_ = TdzConfigSetting;
{$INCLUDE 't_dzObjectListTemplate.tpl'}

type
  {: List for storing TdzConfigSetting items }
  TConfigSettingList = class(_DZ_OBJECT_LIST_TEMPLATE_)

  end;

implementation

{$INCLUDE 't_dzObjectListTemplate.tpl'}

  { TdzConfigSetting }

constructor TdzConfigSetting.Create(const _Name, _Value: string);
begin
  inherited Create;
  FName := _Name;
  FValue := _Value;
end;

end.

