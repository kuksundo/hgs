unit dtpRegister;

{$i simdesign.inc}

interface

uses
  Classes, dtpDocument, dtpRsRuler;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SimDesign', [TdtpDocument]);
  RegisterComponents('SimDesign', [TdtpRsRuler, TdtpRsRulerCorner]);
end;


end.
