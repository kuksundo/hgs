unit UnitComboBoxUtil;

interface

uses Winapi.Windows, Winapi.Messages, Vcl.Controls, Vcl.ExtCtrls, Vcl.StdCtrls;

procedure ComboBox_AutoWidth(const theComboBox: TCombobox);

implementation

procedure ComboBox_AutoWidth(const theComboBox: TCombobox);
//const
//  HORIZONTAL_PADDING = 20;
var
  itemsFullWidth: integer;
  idx: integer;
  itemWidth: integer;
begin
  itemsFullWidth := 0;

  // get the max needed with of the items in dropdown state
  for idx := 0 to -1 + theComboBox.Items.Count do
  begin
    itemWidth := theComboBox.Canvas.TextWidth(theComboBox.Items[idx]);
    Inc(itemWidth, 7 * theComboBox.Font.Size);
    if (itemWidth > itemsFullWidth) then itemsFullWidth := itemWidth;
  end;

  // set the width of drop down if needed
  if (itemsFullWidth > theComboBox.Width) then
  begin
    //check if there would be a scroll bar
    if theComboBox.DropDownCount < theComboBox.Items.Count then
      itemsFullWidth := itemsFullWidth + GetSystemMetrics(SM_CXVSCROLL);

    SendMessage(theComboBox.Handle, CB_SETDROPPEDWIDTH, itemsFullWidth, 0);
  end;
end;

end.
