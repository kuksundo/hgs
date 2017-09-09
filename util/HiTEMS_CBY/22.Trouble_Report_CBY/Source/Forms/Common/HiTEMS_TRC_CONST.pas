unit HiTEMS_TRC_CONST;

interface

const
  fRpType : array[0..1] of String = ('QR','ER');

  //진행상태코드
  freportStatusNm : array[0..1] of String = ('작성중','제보완료');
  freportStatus : array[0..1] of Integer = (0,1);

type
  TUserInfo = Record
    UserID,
    UserName,
    TeamNo,
    DeptNo,
    Position,
    Manager : String;
  End;

implementation


end.
