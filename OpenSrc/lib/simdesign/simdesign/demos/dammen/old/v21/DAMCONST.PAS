unit DamConst;

{$G+} {$N+}

INTERFACE

type

  PFlagField=^TFlagField;
  TFlagField=array[1..50] of boolean;

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

{  F: boolean=False;
  T: boolean=True;}

  ISOPos: TFlagField =
  ( False, False, False, False, False,
   False, True, True, True, True,
    True, True, True, True, False,
   False, True, True, True, True,
    True, True, True, True, False,
   False, True, True, True, True,
    True, True, True, True, False,
   False, True, True, True, True,
    True, True, True, True, False,
   False, False, False, False, False  );

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

IMPLEMENTATION

end.