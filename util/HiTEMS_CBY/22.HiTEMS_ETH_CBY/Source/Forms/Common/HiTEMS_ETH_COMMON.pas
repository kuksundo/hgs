unit HiTEMS_ETH_COMMON;

interface
uses
  System.SysUtils,
  Ora,
  DB,
  Vcl.Forms,
  DateUtils,
  HiTEMS_ETH_CONST;

var
  FUserInfo : TUserInfo;
  function CurrentUsers : String;
  function CurrentUsersDept : String;
  function CurrentUsersTeam : String;

  function make_ETH_Key:String;

implementation

function CurrentUsers : String;
begin
  Result := FUserInfo.UserID;
end;

function CurrentUsersDept : String;
begin
  Result := FUserInfo.DeptNo;
end;

function CurrentUsersTeam : String;
begin
  Result := FUserInfo.TeamNo;
end;

function make_ETH_Key:String;
begin
  Result := FormatDateTime('YYYYMMDDHHmmsszzz',Now);

end;


end.
