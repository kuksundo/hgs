unit HiTEMS_CONST;

interface

const
  defaultPath = 'C:\Temp\DPMS\';
  LastLoginFileName = 'C:\Temp\DPMS\DPMSLastLoginInfo.DPMS';
  AutoLoginFileName = 'C:\Temp\DPMS\DPMSAutoLogIn.Id';

type
  TUSERINFO = Record
    USERNAME,
    USERID,
    PWD,
    DEPT,
    TEAM : String;
  End;

var
  FUSERINFO : TUSERINFO;
  function CurrentUserId : String;
  function CurrentUserPwd : String;
  function CurrentUserName : String;
  function CurrentUserDept : String;
  function CurrentUserTeam : String;


implementation


  function CurrentUserId : String;
  begin
    Result := FUserInfo.UserID;
  end;

  function CurrentUserPwd : String;
  begin
    Result := FUserInfo.PWD;
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
