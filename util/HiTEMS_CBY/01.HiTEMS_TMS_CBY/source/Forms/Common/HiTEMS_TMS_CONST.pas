unit HiTEMS_TMS_CONST;

interface

const
  fStatusCdGrp : Double = (63490488633265);//업무그룹

  //JOBCODE 관련
  fsiteRstCode : Double = (63496011770313);//현장관련 JOBCODE


  //근무구분
  ftimeType : array[0..5] of string = ('기본근무','연장근무','주말근무','야간근무','철야근무','야간연장');
  //근태구분
  fgeuntae : array[0..8] of string = ('출장','교육','파견','훈련(예비군)',
                                      '년/월차','년/월차(오전)',
                                      '년/월차(오후)','휴가','기타');

  fDayofWeek : array[1..7] of string = ('일','월','화','수','목','금','토');


  fK2bSite : String = ('K2B3');

implementation

uses
  CommonUtil_Unit,
  DataModule_Unit;

end.

