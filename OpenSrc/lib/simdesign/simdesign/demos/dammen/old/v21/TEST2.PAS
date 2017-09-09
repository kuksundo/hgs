{$G+} {$N+} {$X+}

uses DamCheck,DamEval,crt;


const

  FldStandard: TFieldRec =
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

  FldTest3: TFieldRec =
  (  00, 00, 00, 00, 00,
   00, 00, 00, 00, 00,
     00, 00, 00, 00, 00,
   00, 00, zn, 00, 00,
     00, 00, 00, 00, 00,
   00, 00, wn, 00, 00,
     00, 00, 00, 00, 00,
   00, 00, 00, 00, 00,
     00, 00, 00, 00, 00,
   00, 00, 00, 00, 00  );

const Level: TLevels =
   ( Start: 0; Step: 1; Stop: 2;
     Flops: 100;
     First: 5.0; Multi: 10.0 );

   Factor: array[0..1] of TFactors =
  ( (fcTot: 1.0;   fcRel: 1.0;   fcDam: 0.3;
     fcYps: 0.005; fcFwd: 0.005; fcIso:-0.001;
     fcFst: 1.2;   fc3DF: 0.01;  fcAfr: 0.0),
    (fcTot: 1.0;   fcRel: 1.0;   fcDam: 0.3;
     fcYps: 0.005; fcFwd: 0.005; fcIso:-0.001;
     fcFst: 1.2;   fc3DF: 0.01;  fcAfr: 0.017) );

type TMyControl=object(TController)
       procedure InitTree; virtual;
     end;


procedure TMyControl.InitTree;
  begin
    InitItemList;
    SetState(esFixed,true);
  end;

Procedure OneGame(var Dif: integer);
var Control: TMyControl;
    Field: TFieldRec;
    Side: byte;
    MoveCount,samecount: integer;
    AMove: PTree;
    S: Tstatistics;
    stones,oldstones,dams: integer;
    Chooser: TChooser;
begin
  Side:=1;
  MoveCount:=0;
  SameCount:=0;
  Field:=fldStandard;
  Randomize;
  repeat
    Side:=1-Side;
    inc(MoveCount);
    Control.Init(Field);
    Control.Levels:=Level;
    Control.Factors:=Factor[Side];
    if Side=1 then
      Control.Reverse;
    Control.WriteField;
    Control.Statistics(S);
    if Side=1 then
      Control.Reverse;
    Writeln;
    Writeln('Partij ',Side);
    Writeln('Move   ',MoveCount);
    Writeln('wit:',S.wn,' zwt:',S.zn,' wit dam:',S.wd,' zwart dam:',S.zd);
    stones:=s.wn+s.zn+s.wd+s.zd;
    dams:=s.wd+s.zd;
    if OldStones=Stones then
      inc(samecount)
    else
      samecount:=0;
    oldstones:=stones;
    repeat
      Control.Run;
      if Control.Getstate(esBusy)=false then
        writeln('Current level: ',Control.RunLevel);
    until Control.Finished;
    Chooser.Init(@Control);
    AMove:=Chooser.ChooseMove;
    Chooser.Done;
    if AMove<>nil then
    begin
      Control.PerformMove(AMove);
      Control.Reverse;
      Field:=Control.Fields;
    end;
    Control.Done;
  until ((dams>0) and (samecount>15)) or (AMove=nil);
  Writeln('Winner is..');
  dif:=(wn+3*wd)-(zn+3*zd);
  if dif<0 then
  begin
    writeln('side 1 (black)');
    dif:=-1;
  end;
  if dif=0 then writeln('remise');
  if dif>0 then
  begin
    writeln('side 0 (white)');
    dif:=1;
  end;
end;

var Games: integer;
    perc: integer;
    dif: integer;
    a: string;
begin
  Games:=0;
  perc:=0;
  repeat
    OneGame(Dif);
    inc(Games);
    perc:=perc+Dif;
    writeln('Games:',Games);
    writeln('Percentage white win<>black win: ',perc/games:6:3);
    readln(a);
  until a=' ';

end.