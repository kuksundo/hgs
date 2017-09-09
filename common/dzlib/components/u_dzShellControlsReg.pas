unit u_dzShellControlsReg;

interface

procedure Register;

implementation

uses
  Classes,
  c_dzShellControls;

procedure Register;
begin
  RegisterComponents('dzlib', [TdzShellTreeView, TdzShellComboBox, TdzShellListView]);
end;

end.
