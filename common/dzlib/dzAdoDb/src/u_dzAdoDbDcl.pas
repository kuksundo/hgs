unit u_dzAdoDbDcl;

interface

uses
  Classes;

procedure Register;

implementation

uses
  c_dzAdoConnection,
  c_dzAdoQuery,
  c_dzAdoTable;

procedure Register;
begin
  RegisterComponents('ADO', [TdzAdoConnection]);
  RegisterComponents('ADO', [TdzAdoQuery]);
  RegisterComponents('ADO', [TdzADOTable]);
end;

end.

