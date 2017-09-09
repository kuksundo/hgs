unit u_dzVirtualStringGridReg;

interface

procedure Register;

implementation

uses
  Classes,
  c_dzVirtualStringGrid;

{$R 'c_dzVirtualStringGrid.dcr'}

procedure Register;
begin
  RegisterComponents('dzlib', [TdzVirtualStringGrid]);
end;

end.
