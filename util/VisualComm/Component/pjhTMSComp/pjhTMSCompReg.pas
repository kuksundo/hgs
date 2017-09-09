{***************************************************************************}
{ Delphi IDE에 등록하기 위함                                         }
{***************************************************************************}

unit pjhTMSCompReg;

interface

uses
  pjhAdvCircularProgress, Classes;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('pjhTMS',[TpjhAdvCircularProgress]);
end;

end.
