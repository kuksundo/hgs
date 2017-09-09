unit HiTEMS_CONST;

interface
type
  TUSERINFO = Record
    USERNAME,
    USERID,
    DEPT,
    TEAM : String;
  End;

var
  FUSERINFO : TUSERINFO;
  function CurrentUserId : String;
  function CurrentUserName : String;
  function CurrentUserDept : String;
  function CurrentUserTeam : String;


implementation


  function CurrentUserId : String;
  begin
    Result := FUserInfo.UserID;
  end;

  function CurrentUserName : String;
  begin
    Result := FUserInfo.USERNAME;
  end;

  function CurrentUserDept : String;
  begin
    Result := FUserInfo.DEPT;
  end;

  function CurrentUserTeam : String;
  begin
    Result := FUserInfo.TEAM;
  end;

end.
