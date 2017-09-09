unit u_dzVariableDescList;

interface

uses
  Windows,
  SysUtils,
  Classes,
  u_dzTranslator;

type
  IdzDbVariableDescription = interface ['{75F3907F-8D92-439E-AE08-3B2A9F7C0CAE}']
    function GetName: string;
    function GetValue: string;
    procedure SetValue(const _Value: string);
    function GetEnglish: string;
    function GetDeutsch: string;
    function GetTag: string;
    function GetValType: string;
    function GetEditable: boolean;
    function GetAdvanced: boolean;

    property Editable: boolean read GetEditable;
    property Advanced: boolean read GetAdvanced;
    property ValType: string read GetValType;
    property Deutsch: string read GetDeutsch;
    property English: string read GetEnglish;
    property Value: string read GetValue write SetValue;
    property Name: string read GetName;
    property Tag: string read GetTag;
  end;

{$DEFINE __DZ_SORTED_INTERFACE_LIST_TEMPLATE__}
type
  _LIST_ANCESTOR_ = TObject;
  _ITEM_TYPE_ = IdzDbVariableDescription;
  _KEY_TYPE_ = string;

{$INCLUDE 't_dzSortedInterfaceListTemplate.tpl'}

type
  TdzDbVariableDescriptionList = class(_DZ_SORTED_INTERFACE_LIST_TEMPLATE_)
  protected
    function Compare(const _Key1, _Key2: string): integer; override;
    function KeyOf(const _Item: IdzDbVariableDescription): string; override;
  public
    {: Frees a IHkDbVariableDescription }
    procedure FreeItem(_Item: IdzDbVariableDescription); override;
  end;

implementation

uses
  u_dzQuicksort;

{$INCLUDE 't_dzSortedInterfaceListTemplate.tpl'}

function TdzDbVariableDescriptionList.Compare(const _Key1, _Key2: string): integer;
begin
  Result := AnsiCompareText(_Key1, _Key2);
end;

function TdzDbVariableDescriptionList.KeyOf(const _Item: IdzDbVariableDescription): string;
begin
  Result := _Item.Name;
end;

procedure TdzDbVariableDescriptionList.FreeItem(_Item: IdzDbVariableDescription);
begin
  // Do nothing, Items are interfaces and therefore automatically
  // freed.
end;

end.

