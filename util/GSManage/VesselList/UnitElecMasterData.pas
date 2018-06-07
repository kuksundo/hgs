unit UnitElecMasterData;

interface

uses System.Classes, UnitEnumHelper;

type
  TElecMasterQueryDateType = (emdtNull, emdtProductDeliveryDate, emdtShipDeliveryDate,
    emdtWarrantyDueDate, emdtFinal);

const
  R_ElecMasterQueryDateType : array[Low(TElecMasterQueryDateType)..High(TElecMasterQueryDateType)] of string =
    ('', 'Product Delivery Date', 'Ship Delivery Date', 'Warranty Due Date', '');

var
  g_ElecMasterQueryDateType: TLabelledEnum<TElecMasterQueryDateType>;

implementation

initialization
  g_ElecMasterQueryDateType.InitArrayRecord(R_ElecMasterQueryDateType);

end.
