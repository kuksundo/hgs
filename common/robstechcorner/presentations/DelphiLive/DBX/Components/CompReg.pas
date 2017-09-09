unit CompReg;

interface
uses Classes, dbxQuery;

procedure Register;

implementation

procedure Register;
begin
 RegisterComponents('dbExpress',[TdbxQuery]);
end;


end.
