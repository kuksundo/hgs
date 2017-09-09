{$G+} {$N+} {$X+}

uses DamCheck,DamEval,crt;


const

  FldTest1: TFieldRec =
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

  FldTest2: TFieldRec =
  (  zn, zn, 00, zn, 00,
   zn, zn, zn, zn, zn,
     zn, zn, zn, 00, zn,
   zn, zn, zn, zn, zn,
     00, 00, 00, 00, 00,
   00, 00, zn, 00, 00,
     wn, wn, 00, wn, wn,
   wn, wn, wn, wd, wn,
     wn, wn, wn, wn, wn,
   wn, wn, wn, wn, wn   );

  FldTest3: TFieldRec =
  (  00, 00, 00, 00, 00,
   zd, 00, 00, 00, 00,
     00, wn, 00, 00, 00,
   wn, 00, 00, 00, 00,
     00, 00, 00, 00, wd,
   00, 00, 00, 00, 00,
     00, 00, 00, 00, 00,
   00, 00, zn, 00, 00,
     00, 00, 00, 00, 00,
   00, wn, 00, 00, 00  );

var Control: TController;
    MoveList: TMoveList;
    Value: single;
    a: string;
begin
  Control.Init(fldTest3);
  Control.GetBalance(Value);
  ClrScr;
  repeat
    repeat
      Control.Run
    until not Control.GetState(esBusy);
    if Control.Count>0 then
    begin
      Control.WriteField;
      MakeMoveList(MoveList,Control.GetBestMove);
      Writeln('Run level:',Control.RunLevel);
      Writeln('Best move:',MoveToString(MoveList,1));
      Writeln('Result: ',Control.Items^[0]^.Value:6:4);
      Writeln('Size:',Control.Size:10:2);
      readln(a);
    end;
  until a=' ';
  Control.Done;
end.