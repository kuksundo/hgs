{ unit GameConst.pas

  adapted to Delphi,
  original unit: DAMCONST

  copyright (c) N. Haeck, 1996
}

unit GameConst;

interface

{uses
  sdPaintHelper;}

type

  PFlagField=^TFlagField;
  TFlagField=array[1..50] of boolean;

const
  cVersion = '2.2';

{ global } //must be removed
var
  Xrad,Yrad,Ymov,Dx,Dy: integer; {hulpvars vakjes dambord}
  ax,ay,bx,by: integer;          {omhullende dambord}
  kx,ky: array[1..2] of integer; {start klok}
  mpy: array[1..2] of integer;   {y partij-naam}
  ovy: array[1..2] of integer;   {y steenoverz}
  SchijfSleep: byte;
  OldX,OldY: integer;

const

{ Error field }

  fe = $FF;

{ Field in direction }

  FDir: array[1..4,1..50] of byte =
  (( fe, fe, fe, fe, fe, {FRU}
   01, 02, 03, 04, 05,
     07, 08, 09, 10, fe,
   11, 12, 13, 14, 15,
     17, 18, 19, 20, fe,
   21, 22, 23, 24, 25,
     27, 28, 29, 30, fe,
   31, 32, 33, 34, 35,
     37, 38, 39, 40, fe,
   41, 42, 43, 44, 45  ),
  (  fe, fe, fe, fe, fe, {FLU}
   fe, 01, 02, 03, 04,
     06, 07, 08, 09, 10,
   fe, 11, 12, 13, 14,
     16, 17, 18, 19, 20,
   fe, 21, 22, 23, 24,
     26, 27, 28, 29, 30,
   fe, 31, 32, 33, 34,
     36, 37, 38, 39, 40,
   fe, 41, 42, 43, 44   ),
  (  06, 07, 08, 09, 10, {FLD}
   fe, 11, 12, 13, 14,
     16, 17, 18, 19, 20,
   fe, 21, 22, 23, 24,
     26, 27, 28, 29, 30,
   fe, 31, 32, 33, 34,
     36, 37, 38, 39, 40,
   fe, 41, 42, 43, 44,
     46, 47, 48, 49, 50,
   fe, fe, fe, fe, fe   ),
  (  07, 08, 09, 10, fe, {FRD}
   11, 12, 13, 14, 15,
     17, 18, 19, 20, fe,
   21, 22, 23, 24, 25,
     27, 28, 29, 30, fe,
   31, 32, 33, 34, 35,
     37, 38, 39, 40, fe,
   41, 42, 43, 44, 45,
     47, 48, 49, 50, fe,
   fe, fe, fe, fe, fe   ));

{ Field Right Up }

  FRU: Array[1..50] of byte =
  (  fe, fe, fe, fe, fe,
   01, 02, 03, 04, 05,
     07, 08, 09, 10, fe,
   11, 12, 13, 14, 15,
     17, 18, 19, 20, fe,
   21, 22, 23, 24, 25,
     27, 28, 29, 30, fe,
   31, 32, 33, 34, 35,
     37, 38, 39, 40, fe,
   41, 42, 43, 44, 45  );

{ Field Left Up }

  FLU: Array[1..50] of byte =
  (  fe, fe, fe, fe, fe,
   fe, 01, 02, 03, 04,
     06, 07, 08, 09, 10,
   fe, 11, 12, 13, 14,
     16, 17, 18, 19, 20,
   fe, 21, 22, 23, 24,
     26, 27, 28, 29, 30,
   fe, 31, 32, 33, 34,
     36, 37, 38, 39, 40,
   fe, 41, 42, 43, 44   );

  YWPos: Array[1..50] of byte=
  (  9, 9, 9, 9, 9,
    8, 8, 8, 8, 8,
     7, 7, 7, 7, 7,
    6, 6, 6, 6, 6,
     5, 5, 5, 5, 5,
    4, 4, 4, 4, 4,
     3, 3, 3, 3, 3,
    2, 2, 2, 2, 2,
     1, 1, 1, 1, 1,
    0, 0, 0, 0, 0  );

  YZPos: Array[1..50] of byte=
  (  0, 0, 0, 0, 0,
    1, 1, 1, 1, 1,
     2, 2, 2, 2, 2,
    3, 3, 3, 3, 3,
     4, 4, 4, 4, 4,
    5, 5, 5, 5, 5,
     6, 6, 6, 6, 6,
    7, 7, 7, 7, 7,
     8, 8, 8, 8, 8,
    9, 9, 9, 9, 9 );

  F=False;
  T=True;

  ISOPos: TFlagField =
  ( F, F, F, F, F,
   F, T, T, T, T,
    T, T, T, T, F,
   F, T, T, T, T,
    T, T, T, T, F,
   F, T, T, T, T,
    T, T, T, T, F,
   F, T, T, T, T,
    T, T, T, T, F,
   F, F, F, F, F  );

  DfwVAl: array[1..50] of byte=
  (  0, 0, 0, 0, 0,
    0, 0, 0, 0, 0,
     0, 0, 0, 0, 0,
    0, 0, 0, 0, 0,
     1, 1, 1, 1, 1,
    3, 2, 2, 2, 3,
     4, 3, 3, 3, 4,
    5, 2, 2, 2, 2,
     0, 0, 0, 0, 0,
    0, 0, 0, 0, 0 );

  DfzVAl: array[1..50] of byte=
  (  0, 0, 0, 0, 0,
    0, 0, 0, 0, 0,
     2, 2, 2, 2, 5,
    4, 3, 3, 3, 4,
     3, 2, 2, 2, 3,
    1, 1, 1, 1, 1,
     0, 0, 0, 0, 0,
    0, 0, 0, 0, 0,
     0, 0, 0, 0, 0,
    0, 0, 0, 0, 0 );

  DField: array[0..2,1..16] of byte=
    (( 1, 6,12,17,18,22,23,28,29,33,34,39,40,44,45,50),
     (50,45,39,34,33,29,28,23,22,18,17,12,11, 7, 6, 1),
     (10,10,10,10, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1));

type

{ String10 type }

  String10=string[10];

{ TStatistics object }

  PStatistics=^TStatistics;
  TStatistics=record
    wn,zn,wd,zd: byte;
    yp,Fis,fc,df: integer;
  end;

{ TMove object }

  PMove=^TMove;
  TMove=object
    Fs: byte; {starting field}
    Fh: byte; {hit      field}
    Fe: byte; {ending   field}
    Ts: byte; {starting type}
    Th: byte; {hitfield type}
    Mt: byte; {zet type}
    procedure Assign(AFs,AFh,AFe,ATs,ATh,AMt: byte);
  end;

{ TMoveList record }

  TMoveList=record
    Mv: array[0..19] of TMove;
    Count: integer;
  end;


const

{ Move types }

  mtNone=0;
  mtMove=1;
  mtHit =2;
  mtDam =3;

{ Field values }

  wn=$01;      {Wit Normaal}
  wd=$02;      {Wit Dam}
  zn=$04;      {Zwart Normaal}
  zd=$08;      {Zwart Dam}
  mskWit=$03;  {mask Wit}
  mskZwt=$0C;  {mask Zwart}
  NoStone=$00; {Geen Stenen}

{ Field Types }

  fldError=$FF;
  fldNone =$00;

{ Empty move record }

  EmptyMove: TMove = (Fs:0; Fh:0; Fe:0; Ts:0; Th:0; Mt:0);

type

{ TFiedRec Record }

  PFieldRec=^TFieldRec;
  TFieldRec=array[1..50] of byte;

const

{ Standaard opstelling }

  fldStandard: TFieldRec =
  (  zn, zn, zn, zn, zn,
   zn, zn, zn, zn, zn,
     zn, zn, zn, zn, zn,
   zn, zn, zn, zn, zn,
     00, 00, 00, 00, 00,
   00, 00, 00, 00, 00,
     wn, wn, wn, wn, wn,
   wn, wn, wn, wn, wn,
     wn, wn, wn, wn, wn,
   wn, wn, wn, wn, wn   );

  FldBlank: TFieldRec =
  (  00, 00, 00, 00, 00,
   00, 00, 00, 00, 00,
     00, 00, 00, 00, 00,
   00, 00, 00, 00, 00,
     00, 00, 00, 00, 00,
   00, 00, 00, 00, 00,
     00, 00, 00, 00, 00,
   00, 00, 00, 00, 00,
     00, 00, 00, 00, 00,
   00, 00, 00, 00, 00  );

  FldTest: TFieldRec =
  (  00, 00, 00, 00, 00,
   00, 00, 00, 00, 00,
     00, 00, 00, 00, 00,
   00, 00, 00, 00, 00,
     zn, 00, 00, 00, 00,
   00, 00, 00, 00, 00,
     00, wn, zn, zn, 00,
   00, wn, 00, 00, 00,
     wn, 00, 00, 00, 00,
   00, 00, 00, 00, 00  );

{ Configuration Flags }

  cfFNum =$01; {field numbers}
  cfReg  =$02; {registration - notatie}
  cfSound=$04; {sound}
  cfAnal =$08; {analysis}
  cfClock=$10; {clocks}
  cfStOv =$20; {steenoverzicht}
  cfRev  =$40; {reversed board}
  cfTNot =$80; {time notation}

  cfInit =cfReg+cfSound+cfAnal+cfClock+cfStOv+cfTNot;

{ Refresh Flags }

  rfScreen=$01;
  rfClock =$02;
  rfInit=rfScreen+rfClock;

{ Gamephase Flags }

  phStart    =$01;
  phEnded    =$02;
  phBusy     =$04;
  phEvalEnded=$10;
  phFinish   =$20;
  phMoveNow  =$40;

  phInit=phStart;

{ Program modes }

  mdNormal  =$01;
  mdReplay  =$02;
  mdStelling=$04;
  mdPause   =$80;

  mdInit=mdNormal;

{ Maximum number of minimax lines }

  MinimaxMaxNum=14;

{ lowlevel functions }

{ Conversion Field<->X,Y coords }

function F2X(Field: byte): byte;
function F2Y(Field: byte): byte;
function XY2F(X,Y: byte): byte;

implementation

{ TMove object }

procedure TMove.Assign(AFs,AFh,AFe,ATs,ATh,AMt: byte);
begin
  Fs:=AFs;
  Fh:=AFh;
  Fe:=AFe;
  Ts:=ATs;
  Th:=ATh;
  Mt:= AMt;
end;

{ Conversion Field<->X,Y coords }

function F2X(Field: byte): byte;
begin
  F2X:=((Field-1) mod 5)*2 + F2Y(Field) Mod 2;
end;

function F2Y(Field: byte): byte;
begin
  F2Y:=(50-Field) div 5;
end;

function XY2F(X,Y: byte): byte;
begin
  X:=X div 2;
  XY2F:=X+(9-Y)*5+1;
end;

end.