unit UnitSessionInterface;

interface

uses classes;

type
  ISessionLog = interface(IInvokable)
    ['{85650095-54E9-4C72-AEEE-D245F8A994F4}']
    function LogIn(AUserId, APasswd, AIpAddress, AUserName, ASessionID: string): Boolean;
    function LogOut(AUserId, APasswd, AIpAddress, AUserName, ASessionID: string): Boolean;
//    function GetUserList(
  end;

implementation

end.
