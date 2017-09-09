unit UnitRMISSessionInterface;

interface

uses SynCommons;

type
  IRMISSessionLog = interface(IInvokable)
    ['{85650095-54E9-4C72-AEEE-D245F8A994F4}']
    function LogIn(AUserId, APasswd, AIpAddress, AUserName: string): Boolean;
    function LogOut(AUserId, APasswd, AIpAddress, AUserName: string): Boolean;
//    function GetRMISUserList(AIsMobile: Boolean): RawUTF8;
    function GetRMISUserList: RawUTF8;
    function IsRMISUser(AID: string): Boolean;
  end;

implementation

end.
