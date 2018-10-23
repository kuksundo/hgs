unit calendar_unit;

interface

uses sysutils;

const
  montharray : array[0..24] of integer =
               (0,21355,42843,64498,86335,108366,130578,152958,
                175471,198077,220728,243370,265955,288432,310767,332928,
                354903,376685,398290,419736,441060,462295,483493,504693,525949);
  { ¿‘√·Ω√¡°ø°º≠ 24¿˝±‚¿« Ω√¡°±Ó¡ˆ¿« ±Ê¿Ã - ∫– }
  {  yearmin := 525948.75 ; - Ω«¡¶ 1≥‚±Ê¿Ã (∫–)
     yearmini := 525949 ; - ±ŸªÁƒ° (ø¿¬˜ 3456≥‚ø° 1¿œ)}

{  solorlat : array[0..24] of smallint =
              (315,330,345,0,15,30,45,60,75,90,105,120,135,150,165,180,195,210,
               225,240,255,270,285,300,315); }

  monthst : array[0..24] of string =
          ('¿‘√·','øÏºˆ','∞Êƒ®','√·∫–','√ª∏Ì','∞ÓøÏ',
           '¿‘«œ','º“∏∏','∏¡¡æ','«œ¡ˆ','º“º≠','¥Îº≠',
           '¿‘√ﬂ','√≥º≠','πÈ∑Œ','√ﬂ∫–','«—∑Œ','ªÛ∞≠',
           '¿‘µø','º“º≥','¥Îº≥','µø¡ˆ','º“«—','¥Î«—','¿‘√·');
  gan : array[0..9] of string =
          ('À£','Î‡','‹∞','ÔÀ','ŸÊ','–˘','Ã“','„Ù','ÏÛ','Õ§');
  ji : array[0..11] of string =
          ('Ì≠','ı‰','ÏŸ','Ÿ÷','Ú„','ﬁ”','ÁÌ','⁄±','„È','Î∑','‚˘','˙§');
  ganji : array[0..59] of string =
       ('À£Ì≠','Î‡ı‰','‹∞ÏŸ','ÔÀŸ÷','ŸÊÚ„',
        '–˘ﬁ”','Ã“ÁÌ','„Ù⁄±','ÏÛ„È','Õ§Î∑',
        'À£‚˘','Î‡˙§','‹∞Ì≠','ÔÀı‰','ŸÊÏŸ',

        '–˘Ÿ÷','Ã“Ú„','„Ùﬁ”','ÏÛÁÌ','Õ§⁄±',
        'À£„È','Î‡Î∑','‹∞‚˘','ÔÀ˙§','ŸÊÌ≠',
        '–˘ı‰','Ã“ÏŸ','„ÙŸ÷','ÏÛÚ„','Õ§ﬁ”',

        'À£ÁÌ','Î‡⁄±','‹∞„È','ÔÀÎ∑','ŸÊ‚˘',
        '–˘˙§','Ã“Ì≠','„Ùı‰','ÏÛÏŸ','Õ§Ÿ÷',
        'À£Ú„','Î‡ﬁ”','‹∞ÁÌ','ÔÀ⁄±','ŸÊ„È',

        '–˘Î∑','Ã“‚˘','„Ù˙§','ÏÛÌ≠','Õ§ı‰',
        'À£ÏŸ','Î‡Ÿ÷','‹∞Ú„','ÔÀﬁ”','ŸÊÁÌ',
        '–˘⁄±','Ã“„È','„ÙÎ∑','ÏÛ‚˘','Õ§˙§');

  weekday : array[0..6] of string =
               ('¿œø‰¿œ','ø˘ø‰¿œ','»≠ø‰¿œ','ºˆø‰¿œ','∏Òø‰¿œ','±›ø‰¿œ','≈‰ø‰¿œ');

  s28day : array[0..27] of string =
             (' «','˘Ò','¿˙','€Æ','„˝','⁄≠','—π',
              '‘‡','È⁄','Â¸','˙»','ÍÀ','„¯','€˙',
              '–•','¥©','Í÷','Ÿ€','˘¥','¿⁄','ﬂ≥',
              'ÔÃ','–°','Í˜','‡¯','ÌÂ','Ïœ','¡¯');

  {∫¥¿⁄≥‚ ∞Ê¿Œø˘ Ω≈πÃ¿œ ±‚«ÿΩ√ - ¿‘√· }
  unityear  : integer = 1996;
  unitmonth : byte = 2;
  unitday   : byte = 4;
  unithour  : byte = 22;
  unitmin   : byte = 8;
  unitsec   : byte = 0;

 {1996≥‚ ¿Ω∑¬ 1ø˘ 1¿œ «’ªË ¿œΩ√ }
  unitmyear : integer =1996;
  unitmmonth : byte=2;
  unitmday : byte=19;
  unitmhour : byte=8;
  unitmmin : byte=30;
  unitmsec : byte=0;
  moonlength : cardinal= 42524 ; { =42524∫– 2.9√  }

{ var }


// solor - ±◊∑π∞Ì∏Æ∑¬ ≥‚ø˘¿œΩ√∫–
// so24 - 60≥‚¿« πËºˆ, so24year
// so24year,so24month,so24day,so24hour - 60∞£¡ˆ¿« π¯»£
// ±◊∑π∞Ì∏Æ∑¬ ≥‚ø˘¿œΩ√∫– --->  60≥‚¿« πËºˆ,ºº¬˜,ø˘∞«(≈¬æÁ∑¬),¿œ¡¯,Ω√¡÷
procedure sydtoso24yd(const soloryear:integer;const solormonth,solorday,solorhour,solormin:smallint;
                      var so24:integer;var so24year,so24month,so24day,so24hour:shortint );

// ±◊∑π∞Ì∏Æ∑¬ ≥‚ø˘¿œΩ√∫–¿Ã µÈæÓ¿÷¥¬ ¿˝±‚¿« ¿Ã∏ßπ¯»£,≥‚ø˘¿œΩ√∫–¿ª æÚ¿Ω
procedure SolortoSo24(const soloryear:integer;const solormonth,solorday,solorhour,solormin : smallint;
                      var inginame:smallint; var ingiyear:integer; var ingimonth,ingiday,ingihour,ingimin : smallint;
                      var midname:smallint;var midyear:integer;var midmonth,midday,midhour,midmin : smallint;
                      var outginame:smallint;var outgiyear:integer;var outgimonth,outgiday,outgihour,outgimin : smallint);


//  ±◊∑π∞Ì∏Æ∑¬ ≥‚ø˘¿œ--> ¿Ω∑¬ ≥‚ø˘¿œ,¿±¥ﬁ,¥Îº“
procedure solortolunar(const solyear:integer;solmon,solday:smallint;
                       var lyear:integer;var lmonth,lday:smallint;
                       var lmoonyun,largemonth:boolean);

//  ¿Ω∑¬ ≥‚ø˘¿œ¿±¥ﬁ-->±◊∑π∞Ì∏Æ∑¬ ≥‚ø˘¿œ
procedure lunartosolar(const lyear:integer;lmonth,lday:smallint;
                       const moonyun:boolean;
                       var syear:integer;var smonth,sday:smallint);


// ±◊∑π∞Ì∏Æ∑¬ ≥‚ø˘¿œ¿Ã µÈæÓ¿÷¥¬ ≈¬¿Ωø˘¿« Ω√¿€«’ªË¿œ¡ˆ,∏¡¿œΩ√,≥°«’ªË¿œΩ√
procedure getlunarfirst(const syear:integer;const smonth,sday:smallint;
                        var year:integer;var month,day,hour,min:smallint;
                        var yearm:integer;var monthm,daym,hourm,minm:smallint;
                        var year1:integer;var month1,day1,hour1,min1:smallint);


// ±◊∑π∞Ì∏Æ∑¬ ≥Ø¬•->ø‰¿œ
function getweekday(const syear:integer; const smonth,sday:smallint):smallint;

// ±◊∑π∞Ì∏Æ∑¬≥Ø¬•->28ºˆ æÚ¿Ω
function get28sday(const syear:integer;const smonth,sday:smallint):smallint;

// uyear,umonth,uday,uhour,umin¿∏∑Œ∫Œ≈Õ tmin(∫–)∂≥¿Ã¡¯ Ω√¡°¿« ≥‚ø˘¿œΩ√∫–(≈¬æÁ∑¬)
procedure getdatebymin(const tmin : int64;
                       const uyear:integer;const umonth,uday,uhour,umin:smallint;
                       var y1:integer;var mo1,d1,h1,mi1 : smallint );


// uy,umm,ud,uh,umin∞˙ y1,mo1,d1,h1,mm1ªÁ¿Ã¿« Ω√∞£(∫–)
function  getminbytime(const uy:integer;const umm,ud,uh,umin:smallint;const y1:integer; const mo1,d1,h1,mm1:smallint):int64 ;

implementation

{ year¿« 1ø˘ 1¿œ∫Œ≈Õ year¿« monthø˘, day¿œ±Ó¡ˆ¿« ≥Øºˆ∞ËªÍ }
function  disptimeday(const year:integer;month,day:smallint):smallint;
var
  i,e : smallint;
begin
  e := 0 ;
  for i := 1 to month - 1 do
  begin
    e := e + 31;
    if (i=2) or (i=4) or (i=6) or (i=9) or (i=11) then e:=e-1;
    if i=2 then
    begin
      e:=e-2 ;
      if year mod 4 = 0 then e := e + 1;
      if year mod 100 = 0 then e := e - 1;
      if year mod 400 = 0 then e := e + 1;
      if year mod 4000 = 0 then e := e - 1
    end
  end;
  disptimeday:=e + day
end;

{y1,m1,d1¿œ∫Œ≈Õ y2,m2,d2±Ó¡ˆ¿« ¿œºˆ ∞ËªÍ }
function disp2days(const y1:integer;m1,d1:smallint;y2:integer;m2,d2:smallint):integer;
var
  p1,p2,p1n,pp1,pp2,pr,i,dis,ppp1,ppp2 : integer ;
begin
  if y2 > y1 then
  begin
    p2 := disptimeday(y2,m2,d2);
    p1 := disptimeday(y1,m1,d1);
    p1n := disptimeday(y1,12,31);
    pp1 := y1 ; pp2 := y2 ;
    pr := -1
  end
  else
  begin
    p1 := disptimeday(y2,m2,d2);
    p1n := disptimeday(y2,12,31);
    p2 := disptimeday(y1,m1,d1);
    pp1 := y2 ; pp2 := y1;
    pr := +1
  end;
  if y2 = y1 then dis := p2-p1
  else
  begin
    dis := p1n-p1 ;
    ppp1 := pp1 + 1 ;
    ppp2 := pp2 - 1 ;

    i:=dis;
(*  ppp2 := 1990 ;
    i := 0;   *)

(*  for k := ppp1 to ppp2 do  { º”µµ∞≥º±∫Œ∫– }
    begin
      dis := dis + disptimeday(k,12,31);
{     i :=  i + disptimeday(k,12,31); }
    end;  *)

    while ppp1 <= ppp2 do
    begin

      if (ppp1=-9000) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 4014377
      end;
      if (ppp1=-8000) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 3649135
      end;
      if (ppp1=-7000) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 3283893
      end;
      if (ppp1=-6000) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 2918651
      end;
      if (ppp1=-5000) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 2553408
      end;
      if (ppp1=-4000) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 2188166
      end;
      if (ppp1=-3000) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 1822924
      end;


      if (ppp1=-2000) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 1457682
      end;
      if (ppp1=-1750) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 1366371
      end;
      if (ppp1=-1500) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 1275060
      end;
      if (ppp1=-1250) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 1183750
      end;
      if (ppp1=-1000) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 1092439
      end;
      if (ppp1=-750) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 1001128
      end;
      if (ppp1=-500) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 909818
      end;
      if (ppp1=-250) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 818507
      end;
      if (ppp1=0) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 727197
      end;
      if (ppp1=250) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 635887
      end;
      if (ppp1=500) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 544576
      end;
      if (ppp1=750) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 453266
      end;
      if (ppp1=1000) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 361955
      end;
      if (ppp1=1250) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 270644
      end;
      if (ppp1=1500) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 179334
      end;
      if (ppp1=1750) and (ppp2>1990) then
      begin
        ppp1 := 1991 ;
        i := i + 88023
      end;

      i := i + disptimeday(ppp1,12,31);
      ppp1 := ppp1 + 1
    end ;
    dis := i;

    dis := dis + p2 ;
    dis := dis * pr
  end;
  disp2days := dis
end;

{∆Ø¡°Ω√¡°ø°º≠ ∆Ø¡§Ω√¡°±Ó¡ˆ¿« ∫– - ∫Œ»£¡÷¿« }
function  getminbytime(const uy:integer;const umm,ud,uh,umin:smallint;const y1:integer; const mo1,d1,h1,mm1:smallint):int64 ;
var
  dispday,t : int64 ;
begin
  dispday:=disp2days(uy,umm,ud,y1,mo1,d1);
  t := dispday * 24 * 60 + (uh-h1)* 60 + (umin-mm1) ;
  getminbytime :=t
end;


{1996≥‚ 2ø˘ 4¿œ 22Ω√ 8∫–∫Œ≈Õ tmin∫– ∂≥æÓ¡¯ ≥Ø¿⁄øÕ Ω√∞£¿ª ±∏«œ¥¬ «¡∑ŒΩ√¡Æ
 ∆Ø¡§Ω√¡°(udate)¿∏∑Œ∫Œ≈Õ tmin∫– ∂≥æÓ¡¯ ≥Ø¬•∏¶ ±∏«œ¥¬ «¡∑ŒΩ√¡Æ }
procedure getdatebymin(const tmin : int64;
                       const uyear:integer;const umonth,uday,uhour,umin:smallint;
                       var y1:integer;var mo1,d1,h1,mi1 : smallint );
var
  t: int64;
begin
  y1 := uyear - tmin div 525949 ;
  if tmin >= 0 then
  begin
    y1 := y1 + 2 ;
    repeat
      y1 := y1 - 1 ;
      t := getminbytime(uyear,umonth,uday,uhour,umin,y1,1,1,0,0);
    until t >= tmin ;
    mo1 := 13 ;
    repeat
      mo1 := mo1 - 1 ;
      t := getminbytime(uyear,umonth,uday,uhour,umin,y1,mo1,1,0,0);
    until t >= tmin  ;
    d1 := 32;
    repeat
      d1 := d1 - 1 ;
      t := getminbytime(uyear,umonth,uday,uhour,umin,y1,mo1,d1,0,0);
    until t >= tmin ;
    h1 := 24 ;
    repeat
      h1 := h1 - 1 ;
      t := getminbytime(uyear,umonth,uday,uhour,umin,y1,mo1,d1,h1,0);
    until t >= tmin ;
    t := getminbytime(uyear,umonth,uday,uhour,umin,y1,mo1,d1,h1,0);
    mi1 :=  t - tmin
  end
  else
  begin
    y1 := y1 - 2 ;
    repeat
      y1 := y1 + 1;
      t := getminbytime(uyear,umonth,uday,uhour,umin,y1,1,1,0,0);
    until t < tmin;
    y1 := y1 - 1 ;
    mo1 := 0;
    repeat
      mo1 := mo1 + 1;
      t := getminbytime(uyear,umonth,uday,uhour,umin,y1,mo1,1,0,0);
    until t < tmin ;
    mo1 := mo1 - 1;
    d1 := 0;
    repeat
      d1 := d1 + 1;
      t := getminbytime(uyear,umonth,uday,uhour,umin,y1,mo1,d1,0,0);
    until t < tmin ;
    d1 := d1 - 1 ;
    h1 := -1 ;
    repeat
      h1 := h1 + 1;
      t := getminbytime(uyear,umonth,uday,uhour,umin,y1,mo1,d1,h1,0);
    until t < tmin ;
    h1 := h1 - 1;
    t := getminbytime(uyear,umonth,uday,uhour,umin,y1,mo1,d1,h1,0) ;
    mi1 := t - tmin
  end
end;

// ±◊∑π∞Ì∏Æ∑¬ ≥‚ø˘¿œΩ√∫– --> ∞Ê∞˙≥‚ºˆ,60∞£¡ˆ≥‚¡÷,ø˘¡÷,¿œ¡÷,Ω√¡÷
procedure sydtoso24yd(const soloryear:integer;const solormonth,solorday,solorhour,solormin:smallint;
                      var so24:integer; var so24year,so24month,so24day,so24hour:shortint );
var
  displ2min : int64;
  displ2day,monthmin100,j,t : integer ;
  i : integer;
begin
  displ2min := getminbytime(unityear,unitmonth,unitday,unithour,unitmin,
                            soloryear,solormonth,solorday,solorhour,solormin);
  displ2day := disp2days(unityear,unitmonth,unitday,soloryear,solormonth,solorday) ;
  so24 :=  displ2min div 525949  ; { π´¿Œ≥‚(1996)¿‘√·Ω√¡°∫Œ≈Õ «ÿ¥Á¿œΩ√±Ó¡ˆ ∞Ê∞˙≥‚ºˆ }

  if displ2min >= 0  then so24 := so24 + 1;
  so24year := -1 * (so24 mod 60) ;
  so24year := so24year + 12 ;
  if so24year < 0 then so24year := so24year + 60 ;
  if so24year > 59 then so24year := so24year - 60 ;  { ≥‚¡÷ ±∏«‘ ≥° }

  monthmin100 := displ2min mod 525949 ;
  monthmin100 := 525949 - monthmin100 ;

  if monthmin100 <  0 then monthmin100 := monthmin100 + 525949 ;
  if monthmin100 >= 525949 then monthmin100 := monthmin100 - 525949   ;

  for i := 0 to 11 do
  begin
    j := i * 2 ;
    if  (montharray[j] <= monthmin100) and (monthmin100 < montharray[j+2]) then
    begin
      so24month := i;
    end
  end;

  i := so24month;
  t := so24year mod 10 ;
  t := t mod 5 ;
  t := t * 12 + 2 + i;
  so24month := t ;  { ø˘¡÷ ±∏«‘ ≥° }
  if so24month > 59 then so24month := so24month - 60 ;

  so24day := displ2day mod 60 ;
  so24day := -1 * so24day  ;
  so24day := so24day + 7;

  if so24day < 0 then so24day := so24day + 60 ;
  if so24day > 59 then so24day :=so24day - 60 ; { ¿œ¡÷ ±∏«‘ ≥°}

  if ( solorhour=0 ) or ((solorhour=1) and (solormin < 30)) then i:= 0;

  if ((solorhour=1) and (solormin >= 30 )) or (solorhour=2) or
     ((solorhour=3) and (solormin<30)) then i:=1;

  if (( solorhour=3) and (solormin >= 30 )) or (solorhour=4) or
     ((solorhour=5) and (solormin<30 )) then i:=2;

  if (( solorhour=5) and (solormin >= 30 )) or (solorhour=6) or
     ((solorhour=7) and (solormin<30 )) then i:=3;

  if (( solorhour=7) and (solormin >= 30 )) or (solorhour=8) or
     ((solorhour=9) and (solormin<30)) then i:=4;

  if (( solorhour=9) and (solormin >= 30 )) or (solorhour=10) or
     ((solorhour=11) and (solormin<30 )) then i:=5;

  if (( solorhour=11) and (solormin >= 30 )) or (solorhour=12) or
     ((solorhour=13) and (solormin<30 )) then i:=6;

  if (( solorhour=13) and (solormin >= 30 )) or (solorhour=14) or
     ((solorhour=15) and (solormin<30 )) then i:=7;

  if (( solorhour=15) and (solormin >= 30 )) or (solorhour=16) or
     ((solorhour=17) and (solormin<30 )) then i:=8;

  if (( solorhour=17) and (solormin >= 30 )) or (solorhour=18) or
     ((solorhour=19) and (solormin<30 )) then i:=9;

  if (( solorhour=19) and (solormin >= 30 )) or (solorhour=20) or
     ((solorhour=21) and (solormin<30 )) then i:=10;

  if (( solorhour=21) and (solormin >= 30 )) or (solorhour=22) or
     ((solorhour=23) and (solormin<30 )) then i:=11;

  if ( solorhour=23) and (solormin >= 30 ) then
  begin
    so24day := so24day + 1;
    if so24day = 60 then so24day:=0;
    i := 0
  end;

  t := so24day mod 10 ;
  t := t mod 5 ;
  t := t * 12 + i;
  so24hour := t    {Ω√¡÷ ±∏«‘ ≥° }
end;

// ±◊∑π∞Ì∏Æ∑¬ ≥‚ø˘¿œΩ√∫– --> «ÿ¥Á¿œ¿⁄∞° µÈæÓ¿÷¥¬ Ω√¿€¿˝±‚,¡ﬂ±‚,¥Ÿ¿Ω¿˝±‚
procedure SolortoSo24(const soloryear:integer;const solormonth,solorday,solorhour,solormin : smallint;
                      var inginame:smallint; var ingiyear:integer; var ingimonth,ingiday,ingihour,ingimin : smallint;
                      var midname:smallint;var midyear:integer;var midmonth,midday,midhour,midmin : smallint;
                      var outginame:smallint;var outgiyear:integer;var outgimonth,outgiday,outgihour,outgimin : smallint);
var
  i,monthmin100,j : integer;
  tmin,displ2min : int64;
  y1:integer;
  mo1,d1,h1,mi1 : smallint;
  so24 : integer;
  so24year,so24month,so24day,so24hour:shortint;
begin
  sydtoso24yd(soloryear,solormonth,solorday,solorhour,solormin,
              so24,so24year,so24month,so24day,so24hour);
  displ2min := getminbytime(unityear,unitmonth,unitday,unithour,unitmin,
                            soloryear,solormonth,solorday,solorhour,solormin);

  monthmin100 := displ2min mod 525949 ;
  monthmin100 := 525949 - monthmin100 ;

  if monthmin100 <  0 then monthmin100 := monthmin100 + 525949 ;
  if monthmin100 >= 525949 then monthmin100 := monthmin100 - 525949   ;

  i := so24month mod 12 - 2 ;
  if i=-2 then i := 10  ;
  if i=-1 then i := 11 ;

  inginame :=i*2;
  midname :=i*2+1;
  outginame :=i*2+2;

  j := i * 2 ;
  tmin :=  displ2min +  ( monthmin100 - montharray[j]);
  getdatebymin(tmin,unityear,unitmonth,unitday,unithour,unitmin,y1,mo1,d1,h1,mi1);

  ingiyear:=y1;
  ingimonth:=mo1;
  ingiday:=d1;
  ingihour:=h1;
  ingimin :=mi1;

  tmin :=  displ2min + monthmin100 - montharray[j+1];
  getdatebymin(tmin,unityear,unitmonth,unitday,unithour,unitmin,y1,mo1,d1,h1,mi1);

  midyear:=y1;
  midmonth:=mo1;
  midday:=d1;
  midhour:=h1;
  midmin :=mi1;

  tmin :=  displ2min + monthmin100 - montharray[j+2];
  getdatebymin(tmin,unityear,unitmonth,unitday,unithour,unitmin,y1,mo1,d1,h1,mi1);

  outgiyear:=y1;
  outgimonth:=mo1;
  outgiday:=d1;
  outgihour:=h1;
  outgimin :=mi1
end;

//πÃ¡ˆ¿« ∞¢µµ∏¶ 0~360µµ ¿Ã≥ª∑Œ ∏∏µÎ
function degreelow(const d:extended):extended;
var
  i : int64 ;
  di : extended ;
begin
  di := d;
  i := trunc(di);
  i := i div 360 ;
  di := di - ( 360 * i );

  while ((di >= 360) or (di < 0))  do
  begin
    if di > 0 then di:=di-360
              else di:=di+360
  end;
  degreelow := di
end;

// ≈¬æÁ»≤∞Ê∞˙ ¥ﬁ»≤∞Ê¿« ¬˜¿Ã
// = 0 : «’ªË
// =180 : ∏¡
function moonsundegree(day:extended):extended;
var
  sl,smin,sminangle,sd,sreal,ml,mmin,mminangle,msangle,msdangle,md,mreal : extended;
begin { 1996≥‚ ±‚¡ÿ }
  sl:=day*0.98564736+278.956807;  { ∆Ú±’ »≤∞Ê }
  smin:=282.869498+0.00004708*day; {±Ÿ¿œ¡° »≤∞Ê }
  sminangle := Pi*(sl-smin)/180 ; {±Ÿ¡°¿Ã∞¢ }
  sd := 1.919*SIN(sminangle)+0.02*SIN(2*sminangle); { »≤∞Ê¬˜ }
  sreal := degreelow(sl + sd) ; { ¡¯»≤∞Ê }

  ml := 27.836584+13.17639648*day; { ∆Ú±’»≤∞Ê }
  mmin :=280.425774+0.11140356*day; { ±Ÿ¡ˆ¡° »≤∞Ê }
  mminangle :=Pi*(ml-mmin)/180; { ±Ÿ¡°¿Ã∞¢ }
  msangle := 202.489407-0.05295377*day; { ±≥¡°»≤∞Ê }
  msdangle := Pi*(ml-msangle)/180; { ±≥¡°¿Ã∞¢ }
  md := 5.068889*SIN(mminangle)+0.146111*SIN(2*mminangle)+0.01*SIN(3*mminangle)
       -0.238056*SIN(sminangle)-0.087778*SIN(mminangle+sminangle)  { »≤∞Ê¬˜ }
       +0.048889*SIN(mminangle-sminangle)-0.129722*SIN(2*msdangle)
       -0.011111*SIN(2*msdangle-mminangle)-0.012778*SIN(2*msdangle+mminangle);
  mreal := degreelow(ml + md) ; { ¡¯»≤∞Ê }
  moonsundegree := degreelow(mreal-sreal)
end;


{ syear,smonth,sday¿« ¿¸»ƒ «’ªË¿œΩ√,∏¡¿œΩ√ π◊ «’ªË¿œΩ√ }
procedure getlunarfirst(const syear:integer;const smonth,sday:smallint;
                        var year:integer;var month,day,hour,min:smallint;
                        var yearm:integer;var monthm,daym,hourm,minm:smallint;
                        var year1:integer;var month1,day1,hour1,min1:smallint);
var
  dm,dem,
  d,de,pd: extended;
  i : int64;
begin
  dm:=disp2days(syear,smonth,sday,1995,12,31);
  dem :=moonsundegree(dm);

  d:=dm;
  de :=dem;

  while (de>13.5) do
  begin
    d := d - 1;
    de := moonsundegree(d);
  end;

  while (de>1) do
  begin
    d := d - 0.04166666666;
    de := moonsundegree(d);
  end;

  while (de<359.99) do
  begin
    d := d - 0.000694444;
    de := moonsundegree(d);
  end;

  d := d+0.375;

  d := d*1440 ;
  i := -1*trunc(d);
  getdatebymin(i,1995,12,31,0,0,year,month,day,hour,min);

  d:=dm;
  de :=dem;

  while (de<346.5) do
  begin
    d := d + 1;
    de := moonsundegree(d);
  end;

  while (de<359) do
  begin
    d := d + 0.04166666666;
    de := moonsundegree(d);
  end;

  while (de>0.01) do
  begin
    d := d + 0.000694444;
    de := moonsundegree(d);
  end;

  pd := d ;

  d := d+0.375;

  d := d*1440 ;
  i := -1*trunc(d);
  getdatebymin(i,1995,12,31,0,0,year1,month1,day1,hour1,min1);

  if (smonth=month1) and (sday=day1) then
  begin
    year := year1;
    month := month1;
    day :=day1 ;
    hour := hour1;
    min := min1;

    d:=pd;

    while (de<347) do
    begin
      d := d + 1;
      de := moonsundegree(d);
    end;
    while (de<359) do
    begin
      d := d + 0.04166666666;
      de := moonsundegree(d);
    end;
    while (de>0.01) do
    begin
      d := d + 0.000694444;
      de := moonsundegree(d);
    end;

    d := d+0.375;
    d := d*1440 ;
    i := -1*trunc(d);
    getdatebymin(i,1995,12,31,0,0,year1,month1,day1,hour1,min1)
  end;

  d:=disp2days(year,month,day,1995,12,31); // ¿Ω∑¬ √ «œ∑Á
  d:=d+12; //¿Ω∑¬ 12¿œ
  de :=moonsundegree(d);

  while (de<166.5) do
  begin
    d := d + 1;
    de := moonsundegree(d);
  end;

  while (de<179) do
  begin
    d := d + 0.04166666666;
    de := moonsundegree(d);
  end;

  while (de<179.99) do
  begin
    d := d + 0.000694444;
    de := moonsundegree(d);
  end;

  d := d+0.375;

  d := d*1440 ;
  i := -1*trunc(d);
  getdatebymin(i,1995,12,31,0,0,yearm,monthm,daym,hourm,minm);

end;

// ±◊∑π∞Ì∏Æ∑¬ ≥‚ø˘¿œ --> ≈¬¿Ω≈¬æÁ∑¬ ≥‚,ø˘,¿œ, ∆Ú/¿±, ¥Î/º“
procedure solortolunar(const solyear:integer;solmon,solday:smallint;
                       var lyear:integer;var lmonth,lday:smallint;
                       var lmoonyun,largemonth:boolean);
var
  s0:int64 ;
  i : shortint;
  lnp,lnp2 : boolean;
  ingiyear,midyear1,midyear2,outgiyear:integer;
  inginame,ingimonth,ingiday,ingihour,ingimin,
  midname1,midmonth1,midday1,midhour1,midmin1,
  midname2,midmonth2,midday2,midhour2,midmin2,
  outginame,outgimonth,outgiday,outgihour,outgimin : smallint;
  smomonth,smoday,smohour,smomin :smallint;
  smoyear,y0,y1:integer;
  mo0,d0,h0,mi0,
  mo1,d1,h1,mi1 : smallint;

begin;

  getlunarfirst(solyear,solmon,solday,
                smoyear,smomonth,smoday,smohour,smomin,
                y0,mo0,d0,h0,mi0,
                y1,mo1,d1,h1,mi1);

  lday:=disp2days(solyear,solmon,solday,smoyear,smomonth,smoday) + 1;

  i := abs(disp2days(smoyear,smomonth,smoday,y1,mo1,d1));
  if i=30 then largemonth := true ;
  if i=29 then largemonth := false ;

  SolortoSo24(smoyear,smomonth,smoday,smohour,smomin, {true,i,lnp, }
              inginame,ingiyear,ingimonth,ingiday,ingihour,ingimin,
              midname1,midyear1,midmonth1,midday1,midhour1,midmin1,
              outginame,outgiyear,outgimonth,outgiday,outgihour,outgimin);

  midname2:=midname1+2;
  if midname2 > 24 then midname2 := 1;
  s0 := montharray[midname2]-montharray[midname1];
  if s0 < 0 then s0:=s0 + 525949 ;
  s0 := -1 * s0 ;

  getdatebymin(s0, midyear1,midmonth1,midday1,midhour1,midmin1,
                   midyear2,midmonth2,midday2,midhour2,midmin2 ) ;

  if ( (midmonth1=smomonth) and (midday1>=smoday) ) or
     ( (midmonth1=mo1) and (midday1<d1)) then
  begin
    lmonth:=(midname1-1) div 2+1;
    lmoonyun:=false
  end
  else
    if ((midmonth2=mo1) and (midday2<d1)) or ((midmonth2=smomonth) and (midday2>=smoday)) then
    begin
      lmonth:=(midname2-1) div 2 + 1;
      lmoonyun:=false
    end
    else
    begin
      if (smomonth<midmonth2) and (midmonth2<mo1) then
      begin
        lmonth :=(midname2-1) div 2 + 1;
        lmoonyun := false
      end
      else
      begin
        lmonth:=(midname1-1) div 2 + 1;
        lmoonyun:=true
      end
    end;

  lyear := smoyear;
  if (lmonth=12) and (smomonth=1) then lyear:=lyear-1;

  if ((lmonth=11) and lmoonyun) or (lmonth=12) or (lmonth<6) then
  begin
    getdatebymin(2880, smoyear,smomonth,smoday,smohour,smomin,
                       midyear1,midmonth1,midday1,midhour1,midmin1 ) ;

    solortolunar(midyear1,midmonth1,midday1,
                 outgiyear,outgimonth,outgiday,
                 lnp,lnp2);
    outgiday := lmonth-1;
    if outgiday=0 then outgiday:=12;

    if outgiday=outgimonth then
    begin
      if lmoonyun then lmoonyun:=false
    end
    else
    begin
      if lmoonyun then
      begin
        if lmonth<>outgimonth then
        begin
          lmonth := lmonth-1;
          if lmonth=0 then lyear := lyear-1;
          if lmonth=0 then lmonth:=12;
          lmoonyun := false
        end
      end
      else
      begin
        if lmonth=outgimonth then
        begin
          lmoonyun := true;
        end
        else
        begin
          lmonth:=lmonth-1;
          if lmonth=0 then lyear := lyear-1;
          if lmonth=0 then lmonth:=12
        end
      end
    end
  end
end;

// ≈¬¿Ω≈¬æÁ∑¬ ≥‚ø˘¿œ,∆Ú/¿± --> ±◊∑π∞Ì∏Æ∑¬ ≥‚ø˘¿œ
procedure lunartosolar(const lyear:integer;lmonth,lday:smallint;
                       const moonyun:boolean;
                       var syear:integer;var smonth,sday:smallint);
var
  lnp,lnp2 : boolean;
  inginame,ingimonth,ingiday,ingihour,ingimin : smallint;
  midname,midmonth,midday,midhour,midmin : smallint;
  outginame,outgimonth,outgiday,outgihour,outgimin : smallint   ;
  tmin : int64 ;
  year0,year1,lyear2,ingiyear,midyear,outgiyear:integer;
  month0,day0,hour0,min0 :smallint;
  month1,day1,hour1,min1 :smallint;
  lmonth2,lday2,hour,min:smallint;
begin
  SolortoSo24(lyear,2,15,0,0,
              inginame,ingiyear,ingimonth,ingiday,ingihour,ingimin,
              midname,midyear,midmonth,midday,midhour,midmin,
              outginame,outgiyear,outgimonth,outgiday,outgihour,outgimin);
  midname := lmonth * 2 - 1 ;
  tmin := -1*montharray[midname];
  getdatebymin(tmin,ingiyear,ingimonth,ingiday,ingihour,ingimin,
               midyear,midmonth,midday,midhour,midmin ) ;

  getlunarfirst(midyear,midmonth,midday,
                outgiyear,outgimonth,outgiday,hour,min,
                year0,month0,day0,hour0,min0,
                year1,month1,day1,hour1,min1);

  solortolunar(outgiyear,outgimonth,outgiday,
               lyear2,lmonth2,lday2,
               lnp,lnp2);

  if (lyear=lyear2) and (lmonth=lmonth2) then
  begin  { ∆Ú¥ﬁ,¿±¥ﬁ }
    tmin := -1440 * lday+10 ;
    getdatebymin(tmin,outgiyear,outgimonth,outgiday,0,0,
                 syear,smonth,sday,hour,min);

    if moonyun then
    begin
      solortolunar(year1,month1,day1,
                   lyear2,lmonth2,lday2,
                   lnp,lnp2);
      if (lyear2=lyear) and (lmonth=lmonth2) then
      begin
        tmin := -1440 * lday + 10;
        getdatebymin(tmin,year1,month1,day1,0,0,
                     syear,smonth,sday,hour,min);
      end
    end
  end
  else
  begin   {¡ﬂ±‚∞° µŒπ¯µÁ ¥ﬁ¿« ¿¸»ƒ }
    solortolunar(year1,month1,day1,
                 lyear2,lmonth2,lday2,
                 lnp,lnp2);
    if (lyear2=lyear) and (lmonth=lmonth2) then
    begin
      tmin := -1440 * lday + 10;
      getdatebymin(tmin,year1,month1,day1,0,0,
                   syear,smonth,sday,hour,min);
    end
  end
end;

// ø‰¿œ±∏«œ±‚
function getweekday(const syear:integer; const smonth,sday:smallint):smallint;
var
  d,i : integer ;
begin
  d := disp2days(syear,smonth,sday,unityear,unitmonth,unitday);
  i := d div 7 ;
  d := d - ( i * 7 );

  while ((d > 6) or (d < 0))  do
  begin
    if d > 6 then d:=d-7
             else d:=d+7;
  end;
  if d < 0  then d:= d+7;
  result := d
end;

// 28ºˆ ±∏«œ±‚
function get28sday(const syear:integer;const smonth,sday:smallint):smallint;
var
  d,i : integer ;
begin
  d := disp2days(syear,smonth,sday,unityear,unitmonth,unitday);
  i := d div 28 ;
  d := d - ( i * 28 );

  while ((d > 27) or (d < 0))  do
  begin
    if d > 27 then d:=d-28
              else d:=d+28
  end;
  d := d - 11;
  if d < 0  then d:= d+28;
  result := d
end;

end.
