unit UnitAMSessionInterface;

interface

uses SynCommons;

type
  IAMSessionLog = interface(IInvokable)
    ['{2104104F-92E6-453B-BA6D-6A16C56EA4B2}']
    function LogIn(AUserId, APasswd, AIpAddress, AUserName, ASessionId, AUrl: string): Boolean;
    function LogOut(AUserId, APasswd, AIpAddress, AUserName, ASessionId, AUrl: string): Boolean;
    function GetAMSUserList: RawUTF8;
  end;

implementation

end.
