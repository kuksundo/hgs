unit UnitEmailMsgFileUtil;

interface

implementation

ASMTP   :=   TIdSMTP.Create(nil);
ASMTP.Host   :=   'mail.whatever.org';
ASMTP.Port   :=   25;
ASMTP.AuthenticationType   :=   atNone;
ASMTP.Connect;
try
	ASMTP.Send(AMessage);
except
on E:Exception do
  ShowMessageFmt('Error:   %s',   [E.Message]);
end;
ASMTP.Disconnect;
AMessage.Free;
ASMTP.Free;
end.
