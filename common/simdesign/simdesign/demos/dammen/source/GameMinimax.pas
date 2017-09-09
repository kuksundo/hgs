{ original code is:

  ============== TURBO-PASCAL UNIT WDAM =============

                 versie 2.1 (16-04-96)

  copyright (c) N. Haeck, 1996

}
unit GameMinimax;

interface

uses
  Classes,
  guiGamePaint, GameCheck, GameEval, DammenConfig, GameConst, sdPaintHelper, Math;

var
  Schijf: TDosBlock{PBlock};

type

{ Minimax record }

  TMinimaxRec=record
    MaxValue: single;
    NumBest: integer;
    Level: integer;
    Perc: single;
    CurIndex: integer;
    Current,Value: array[0..MinimaxMaxNum-1] of String10;
  end;

{ Minimax Object }

  TMinimax = class
    ax,ay,dx,dy: integer;
    NewD,OldD: TMinimaxRec;
    Cycles,MaxCycles: integer;
    Changed,Redraw: boolean;
    Moves: array[0..MinimaxMaxNum-1] of String;
    Eval: TController;
    constructor Create;
    procedure DrawFrame;
    procedure DrawUpdate;
    procedure NewEval(AnEval: TController; AMaxCycles: integer);
    procedure Update;
  end;

{ Evaluate person object }

  TEvPers = class
    Stelling: TField;
    Side: byte;
    Tree,Pby: TTree;
    Result: boolean;
    Phase,Depth: byte;
    Move: TTree;
    constructor Create(Evaluator: TEvaluator; ASide: byte);
    destructor Destroy; override;
    procedure Scan;
  end;

{ Treelist }

  PTreeList=^TTreeList;
  TTreeList=array[0..$FFFF] of TTree;

{ Registration record }

  TRegRec = class(TTree)
    Time: word;
    constructor Create(AMove: TTree; ATime: word);
    constructor Load(var S: TStream);
    procedure Store(var S: TStream);
  end;

{ TRegister object }

  TRegister = class(TObject)
  public
    Index: PTreeList;
    Count: integer;
    prStart,prEnd,prOld,prCur: integer;
    prChanged: boolean;
    constructor Create;
    constructor Load(var S: TStream);
    destructor Destroy; override;
    procedure AddMove(ATree: TTree; ATime: word);
    procedure DelMove;
    procedure Draw;
    function GetItemMoveString(Item: integer; Side: byte): string;
    procedure GetStelling(ZNew,ZOld: word; StlOld: TField);
    procedure Store(var S: TStream);
  end;

{ Player record }

  TPlayer = record
    Name: string;
    Typ: byte; {1=comp, 2=person}
  end;

{ TGame record }

  TGame = record
    Zet: integer;
    Max: integer;
    Side: integer;
    Phase: byte;
    Winner: byte; {1=partij1 2=partij2 3=remise}
    Descr: string;
  end;

//{ TReplaybox object }
//
//  TReplayBox=object(TAlertBox)
//    constructor Init;
//  end;

//procedure UpdateOverz;
procedure ScanDambord(var Result: boolean; var Field,Btn: byte);
procedure SwitchSides;
//procedure ScanStellingInv;
//procedure TekenScherm;

{ State-altering routines }

function  GetConf(Mask: byte): boolean;
procedure SetConf(Mask: byte; Enable: boolean);
function  GetRefr(Mask: byte): boolean;
procedure SetRefr(Mask: byte; Enable: boolean);
function  GetMode(Mask: byte): boolean;
procedure SetMode(Mask: byte; Enable: boolean);
function  GetPhase(Mask: byte): boolean;
procedure SetPhase(Mask: byte; Enable: boolean);
function  GetNiveau(Mask: byte): boolean;
function  GetPartij(Mask: byte): boolean;

var

{ Screen specs/sound configuration}

  Conf: byte;
  Refr: byte;

  Tijd: array[1..2] of TClock;

{ Menu Variabelen }

//  Menu: TMenu;
//  MP: array[1..2] of TMenu;

{ Analyse Minimax }

  Minimax: TMinimax;

{ program modes }

  Mode: byte;

{ Partijen }

  Player: array[1..2] of TPlayer;
  StdNames: array[1..2] of string;

{ Stelling }

  Stelling,StartStelling: TField;

{ Game }

  Game: TGame;

{ Niveau }

  Niveau: byte;

{ Registratie }

  Reg: TRegister;

{ Stenen }

  wst,wdm,zst,zdm: byte;

{ Naspelen }

//  Replay: TReplayBox;

implementation

const Color: array[0..5] of byte = (7,15,0,8,11,3);

procedure ScanDambord;
  // local
  function FindField(x,y: integer): byte;
  var Field: byte;
  begin
    if (x<ax) or (x>bx) or (y<ay) or (y>by) then
      Field:=FldError
    else
    begin
      x:=(x-ax) div dx; y:=9-((y-ay) div dy);
      if odd(x+y) then
      begin
        Field:=FldNone;
      end else
      begin
        Field:=XY2F(x,y);
        if GetConf(cfRev) then
          Field:=51-Field;
      end;
    end;
    FindField:=Field;
  end;
var
  BtnStatus,X,Y: integer;
  Pos: TPoint;
begin
  BtnStatus := 0;
  Result:=false;
  GMouse.GetPosition(BtnStatus,Pos.X,Pos.Y);
  if SchijfSleep<>nostone then
  begin
    X:=Pos.X-(dx div 2);
    Y:=Pos.Y-(dy div 2);
    if (OldX<>X) or (OldY<>Y) then
    begin
      if (Pos.X<ax-40) or (Pos.X>bx+40) or
         (Pos.Y<ay-40) or (Pos.Y>by+40) then
      begin
        Result:=true;
        Btn:=0;
        Field:=fldError;
      end else
      begin
        GMouse.Hide;
        Schijf.Put(OldX,OldY);
        Schijf.Get(X,Y);
        TekenSteenAbs(X,Y,X+dx-1,Y+dy-1,SchijfSleep);
        GMouse.Show;
        OldX:=X; OldY:=Y;
      end;
    end;
  end;
  if BtnStatus>0 then
  begin
    Result:=true;
    Btn:=BtnStatus;
    Field:=FindField(Pos.X,Pos.Y);
    repeat
      GMouse.GetPosition(BtnStatus,Pos.X,Pos.Y);
    until BtnStatus=0;
  end;
end;

procedure Value2str(Value: single; var S: string10);
  begin
    if Value=MinimalBalance then
      S:='VERLIES'
    else
      if Value=MaximalBalance then
        S:='WINST'
      else
        str(Value:6:3,S);
  end;

constructor TMinimax.Create;
  begin
    inherited Create;
    ax:=480; ay:=104;
    dx:=130; dy:=269;
    Changed:=true;
    Redraw:=true;
  end;

procedure TMinimax.DrawFrame;
  var T: string;
      x: byte;
  begin
    T:='^hc^vtANALYSE';
    Setcolor(0);
    WriteBox(T,ax,ay-13,ax+dx,ay-1);
    SetColor(9);
    Rectangle(ax,ay,ax+dx,ay+dy);
    SetColor(1);
    for x:=1 to 2 do
    begin
      Rectangle(ax+x,ay+x,ax+dx-x,ay+dy-x);
    end;
    SetFillStyle(SolidFill,7);
    DrawBar(ax+3,ay+3,ax+dx-3,ay+dy-3);
    Setcolor(1);
    T:='Waarde:';
    WriteBox(T,ax+4,ay+5,ax+43,ay+20);
    T:='Niveau:';
    WriteBox(T,ax+4,ay+21,ax+43,ay+36);
    Rectangle(ax+62,ay+20,ax+96,ay+35);
    T:='#beste:';
    WriteBox(T,ax+4,ay+37,ax+43,ay+52);
    T:='Analyse Zetten';
    WriteBox(T,ax+4,ay+53,ax+90,ay+68);
  end;

procedure TMinimax.DrawUpdate;
var x: byte;
    S: String10;
    ppos: integer;
    col: byte;
begin
  //perc
  if (NewD.Perc<>OldD.Perc) or Redraw then
  begin
    PPos:=round(34*NewD.Perc);
    SetFillStyle(SolidFill,8);
    if PPos>0 then
      DrawBar(ax+63,ay+21,ax+62+Math.Min(PPos,33),ay+34);
    SetFillStyle(SolidFill,7);
    if PPos<34 then
      DrawBar(ax+62+Math.Max(PPos,1),ay+21,ax+95,ay+34);
  end;
  //value
  SetColor(0);
  if (NewD.MaxValue<>OldD.MaxValue) or Redraw then
  begin
    Value2Str(NewD.MaxValue,S);
    WriteCBox(S,ax+45,ay+5,ax+86,ay+19,7);
  end;
  //level
  if (NewD.Level<>OldD.Level) or Redraw then
  begin
    str(NewD.Level:2,S);
    WriteCBox(S,ax+45,ay+21,ax+61,ay+35,7);
    Redraw:=true;
  end;
  //NumBest
  if (NewD.NumBest<>OldD.NumBest) or Redraw then
  begin
    str(NewD.NumBest:2,S);
    WriteCBox(S,ax+45,ay+37,ax+61,ay+51,7);
  end;
  for x:=0 to MinimaxMaxNum-1 do
  begin
    //current moves
    if (NewD.Current[x]<>OldD.Current[x]) or Redraw then
      WriteCBox(NewD.Current[x],
                ax+6,ay+68+x*14,ax+43,ay+67+(x+1)*14,7);
    //value of moves
    if Redraw then
    begin
      if Moves[x]<>'' then S:=Moves[x]+':' else S:='';
      WriteCBox(S,
                ax+44,ay+68+x*14,ax+84,ay+67+(x+1)*14,7);
    end;
    if (NewD.Current[x]<>OldD.Current[x]) or
       (((x=NewD.CurIndex) or (x=OldD.CurIndex)) and (NewD.CurIndex<>OldD.CurIndex))
       or Redraw then
    begin
      if x=NewD.CurIndex then Col:=2 else Col:=7;
      WriteCBox(NewD.Value[x],
                ax+85,ay+68+x*14,ax+126,ay+67+(x+1)*14,Col);
    end;
  end;
  Changed:=false;
  Redraw:=false;
end;

procedure TMinimax.NewEval(AnEval: TController; AMaxCycles: integer);
var x: integer;
begin
  Create;
  MaxCycles:=AMaxCycles;
  Eval:=AnEval;
  for x:=0 to MinimaxMaxNum-1 do
    Moves[x]:='';
end;

procedure TMinimax.Update;
var x,depth,side: integer;
    fin: boolean;
    Temp: TEvaluator;
begin
  dec(Cycles);
  if Cycles<=0 then
  begin
    Changed:=true;
    Cycles:=MaxCycles;
    Move(NewD,OldD,sizeof(NewD));
    FillChar(NewD,sizeof(NewD),0);
    NewD.Level:=Eval.RunLevel;
    if Eval.Count=0 then
      NewD.Perc:=1
    else
    begin
      NewD.Perc :=Eval.Current/Eval.Count;
      Temp:=Eval.Items^[Eval.Current].Evaluator;
      if (Temp<>nil) and (Temp.Count<>0) then
        NewD.Perc:=NewD.Perc+Temp.Current/(Temp.Count*Eval.Count);
    end;
    NewD.MaxValue:=MinimalBalance;
    NewD.CurIndex:=Eval.Current;
    for x:=0 to MinimaxMaxNum-1 do
    begin
      if x<Eval.Count then
        if NewD.MaxValue<Eval.GetItemValue(x) then
          NewD.MaxValue:=Eval.GetItemValue(x);
      if x<Eval.Count then
        Value2Str(Eval.GetItemValue(x),NewD.Value[x]);
      if x<Eval.Count then
        Moves[x]:=Eval.GetItemMoveString(x,Game.Side);
    end;
    for x:=0 to Eval.Count-1 do
      if Eval.GetItemValue(x)=NewD.MaxValue then
        inc(NewD.NumBest);
    fin:=false;
    Depth:=0;
    Temp:=Eval;
    Side:=Game.Side;
    repeat
      inc(Depth);
      if (Temp=nil) or (Depth>MinimaxMaxNum) then
        fin:=true;
      if not fin then
      begin
        NewD.Current[Depth-1]:=Temp.GetItemMoveString(Temp.Current,Side);
        Side:=3-Side;
        if Temp.Items<>nil then
          Temp:=Temp.Items^[Temp.Current].Evaluator
        else
          Temp:=nil;
      end;
    until fin;
    for x:=Depth to MinimaxMaxNum-1 do
      NewD.Current[x]:='';
  end;
end;

{eval person}
constructor TEvPers.Create;
  var
    i: integer;
    Temp: TTree;
  begin
    inherited Create;
    Stelling:=Evaluator;
    Side:=ASide;
    if Evaluator.Count>0 then
    begin
      Tree := TTree.copy(Evaluator.GetItemMove(0));
      for i:=1 to Evaluator.Count-1 do
      begin
        Temp := TTree.copy(Evaluator.GetItemMove(i));
        Tree.Insert(Temp);
      end;
    end;
    Pby := TTree.Copy(Tree);
  end;

procedure TEvPers.Scan;
  // local
  procedure CheckPby(Field,Deep,Which: byte; SetTo0: boolean; var Count: byte);
  var
    Temp,Under: TTree;
    x: byte;
    i: integer;
  begin
    x := 0;
    Temp:=Pby;
    Count:=0;
    while Temp<>nil do
    begin
      if Temp.FMove.Fs<>0 then
      begin
        Under:=Temp;
        for i:=1 to Deep do
          Under:=Under.Under;
        case Which of
         0: x:=Under.FMove.Fs; {controleer Fs}
         1: x:=Under.FMove.Fe; {controleer Fe}
        end;
        if x=Field then
          inc(Count)
        else
        begin
          if SetTo0 then
            Temp.FMove.Fs:=0;
        end;
      end;
      Temp:=Temp.Next;
    end;
  end;
// main
var
  Found,OK: boolean;
  Field,FieldBord,Stone,Count,x,y,Btn: byte;
  Temp: TTree;
begin
  Case Phase of
  0:
   begin
     SchijfSleep:=NoStone;
     ScanDambord(Found,Field,Btn);
     if Found and (Field<>FldError) then
     begin
       if Field=FldNone then
       begin
         if GetConf(cfSound) then BeepError;
       end else
       begin
         FieldBord:=Field;
         if Side=2 then
           Field:=51-Field;
         CheckPby(Field,0,0,false,Count);
         if Count>0 then
         begin
           if GetConf(cfSound) then BeepOK;
           CheckPby(Field,0,0,true,Count);
           Stone:=Stelling.GetField(Field);
           if Side=2 then Stone:=Stone*4;
           GMouse.Hide;
           TekenVeld(FieldBord);
           StartSchijfSleep(Stone,Field);
           GMouse.Show;
           Phase:=1;
         end else
         begin
           if GetConf(cfSound) then BeepError;
         end;
       end;
     end;
   end;
  1:
   begin
     //ScanDambord(Found,Field,Btn);
     if Found then
     begin
       Case Field of
       FldNone:
          if GetConf(cfSound) then BeepError;
       FldError:
        begin
          //GMouse.Hide;
          //StopSchijfSleep;
          //TekenStelling(Stelling,Side);
          //GMouse.Show;
          Pby.Free;
          Pby := TTree.Copy(Tree);
          Phase:=0; Depth:=0;
          if GetConf(cfSound) then BeepError;
        end;
       1..50:
        begin
          FieldBord:=Field;
          if Side=2 then
            Field:=51-Field;
          CheckPby(Field,Depth,1,false,Count);
          if Count>0 then
          begin
            CheckPby(Field,Depth,1,true,Count);
            if GetConf(cfSound) then BeepOK;
            inc(Depth);
            if Count=1 then
            begin
              Move:=Pby;
              while Move.FMove.Fs=0 do
                Move:=Move.Next;
              Stone:=Stelling.GetField(Move.FMove.Fs);
              if Side=2 then Stone:=Stone*4;
              //GMouse.Hide;
              //StopSchijfSleep;
              //TekenVeld(FieldBord);
              TekenSteen(FieldBord,Stone);
              //GMouse.Show;
              Result:=true;
              Phase:=2;
            end;
          end else
          begin
            if GetConf(cfSound) then BeepError;
          end;
        end;
       end;
     end;
   end;
  end;
end;

destructor TEvPers.Destroy;
  begin
    Tree.Free;
    Pby.Free;
    inherited;
  end;

{Registratie}

constructor TRegRec.Create(AMove: TTree; ATime: word);
  begin
    TTree.Copy(AMove);
    Time:=ATime;
  end;

constructor TRegRec.Load(var S: TStream);
  begin
    TTree.Load(S);
    S.Read(Time,SizeOf(Time));
  end;

procedure TRegRec.Store(var S: TStream);
  begin
    inherited;
    S.Write(Time,SizeOf(Time));
  end;

constructor TRegister.Create;
  begin
    GetMem(Index,SizeOf(Pointer)*500);
    Count:=0;
    prStart:=0; prEnd:=39;
    prCur:=0;
    prChanged:=true;
  end;

constructor TRegister.Load;
  var x: integer;
  begin
    GetMem(Index,SizeOf(Pointer)*500);
    S.Read(Count,SizeOf(Count));
    S.Read(PrStart,SizeOf(PrStart));
    S.Read(PrEnd,SizeOf(PrEnd));
    S.Read(PrCur,SizeOf(PrCur));
    prChanged:=true;
    for x:=0 to Count-1 do
      Index^[x]:=TRegRec.Load(S);
  end;

procedure TRegister.AddMove(ATree: TTree; ATime: word);
  var CRec: TRegRec;
  begin
    if Count<500 then
    begin
      CRec := TRegRec.Create(ATree,ATime);
      Index^[Count]:=CRec;
      inc(Count);
    end;
    prCur:=Count;
  end;

procedure TRegister.DelMove;
  var TempStl: TField;
  begin
    if Count>0 then
    begin
      TRegRec(Index^[Count-1]).Free;
      dec(Count);
      prCur:=Count;
    end;
  end;

function TRegister.GetItemMoveString(Item: integer; Side: byte): string;
  var List: TMoveList;
      m,s: byte;
      t: string10;
  function TwoChar(b: byte): string10;
    var s: string10;
    begin
      str(b,s);
      s:='0'+s;
      TwoChar:=copy(s,length(s)-1,2);
    end;
  begin
    if (Item<Count) and (Item>=0) then
    begin
      MakeMoveList(List,Index^[Item]);
      s:=(TRegRec(Index^[Item]).Time) mod 60;
      m:=(TRegRec(Index^[Item]).Time) div 60;
      if GetConf(cfTNot) then
        T:='^c15 '+TwoChar(m)+':'+TwoChar(s)
      else
        T:='';
      GetItemMoveString:=MoveToString(List,Side)+T;
    end else
      GetItemMoveString:='';
  end;

procedure TRegister.GetStelling;
  var incr,Z: integer;
  begin
    if ZNew>ZOld then
    begin
      Z:=ZOld;
      while (Z<ZNew) do
      begin
        StlOld.PerformMove(index^[Z]);
        StlOld.Reverse;
        inc(Z);
      end;
    end;
    if ZNew<ZOld then
    begin
      Z:=ZOld;
      while (Z>ZNew) do
      begin
        dec(Z);
        StlOld.Reverse;
        StlOld.PerformBackMove(index^[Z]);
      end;
    end;
  end;

procedure TRegister.Draw;
  var
   x,xs,ys: word;
   Move: string;
   List: TMoveList;
  procedure GetMove(Num: integer);
    begin
      Move:=GetItemMoveString(Num,(Num mod 2)+1);
      xs:=(Num-prStart) mod 2;
      ys:=(Num-prStart) div 2;
    end;
  procedure WriteMove(bkCol: byte);
    begin
      //WriteCBox(addr(Move),27+xs*75,100+ys*14,101+xs*75,113+ys*14,bkCol);
    end;
  begin
    while (prCur>prEnd) or (prCur<prStart) do
    begin {change printscale}
      if prCur>prEnd then
      begin
        prStart:=prStart+8;
        prEnd:=prEnd+8;
      end;
      if prCur<prStart then
      begin
        prStart:=prStart-8;
        prEnd:=prEnd-8;
      end;
      prChanged:=true;
    end;
    //setcolor(0);
    if prChanged then
    begin
      for x:=prStart to prEnd do
      begin
        //setcolor(0);
        GetMove(x);
        WriteMove(7);
        if ((x-prStart) mod 2)=0 then
        begin
          //setcolor(1);
          str((x div 2)+1:2,Move);
          Move:='^hr'+Move+':';
          ys:=(x-prStart) div 2;
          //WriteCBox(addr(Move),3,100+ys*14,26,113+ys*14,7);
        end;
      end;
      prChanged:=false;
    end else
    begin
      GetMove(prOld);
      WriteMove(7);
    end;
    //Setcolor(0);
    GetMove(prCur);
    WriteMove(2);
    prOld:=prCur;
  end;

procedure TRegister.Store;
  var x: integer;
  begin
    S.Write(Count,SizeOf(Count));
    S.Write(PrStart,SizeOf(PrStart));
    S.Write(PrEnd,SizeOf(PrEnd));
    S.Write(PrCur,SizeOf(PrCur));
    for x:=0 to Count-1 do
    begin
      TRegRec(Index^[x]).Store(S);
    end;
  end;

destructor TRegister.Destroy;
  var x: integer;
  begin
    for x:=0 to Count-1 do
      TTree(Index^[x]).Free;
    FreeMem(Index,SizeOf(Word)*500);
    Count:=0;
  end;

procedure SwitchSides;
  var Temp: integer;
      TempR: TRect;
  begin
    Temp:=Ky[1] ; Ky[1] :=Ky[2] ; Ky[2] :=Temp; {klok}
    Temp:=Mpy[1]; Mpy[1]:=Mpy[2]; Mpy[2]:=Temp; {partij-naam}
    Temp:=Ovy[1]; Ovy[1]:=Ovy[2]; Ovy[2]:=Temp; {steenoverz}
    //TempR.SameAs(PMenuItem(Mp[1].At(0))^.R);    {partij-pulldown}
    //PMenuItem(Mp[1].At(0))^.R^.SameAs(PMenuItem(Mp[2].At(0))^.R);
    //PMenuItem(Mp[2].At(0))^.R^.SameAs(addr(TempR));
    //TempR.SameAs(Mp[1].R);
    //Mp[1].R^.SameAs(Mp[2].R);
    //Mp[2].R^.SameAs(addr(TempR));
  end;

{procedure TekenStellingInv;
  procedure KleinDambord(ax,ay: integer);
    var x,y: byte;
    begin
      SetColor(1);
      Rectangle(ax,ay,ax+41,ay+41);
      SetFillStyle(SolidFill,Color[4]);
      DrawBar(ax+1,ay+1,ax+40,ay+40);
      SetFillStyle(Solidfill,Color[5]);
      for x:=0 to 9 do
        for y:=0 to 9 do
          if odd(x+y) then
            DrawBar(ax+1+x*4,ay+1+y*4,ax+4+x*4,ay+4+y*4);
    end;
  var x,y,f: byte;
  begin
    KleinDambord(458,192);
    SetFillStyle(Solidfill,Color[2]);
    for f:=1 to 20 do
    begin
      x:=f2x(f); y:=9-f2y(f);
      DrawBar(460+x*4,194+y*4,461+x*4,195+y*4);
    end;
    SetFillStyle(Solidfill,Color[1]);
    for f:=31 to 50 do
    begin
      x:=f2x(f); y:=9-f2y(f);
      DrawBar(460+x*4,194+y*4,461+x*4,195+y*4);
    end;
    KleinDambord(458,244);
  end;}

{procedure ScanStellingInv;
  var found,Ok: boolean;
      Phase,stone,cmd,Field,Btn: byte;
      BtnStatus,x,y: integer;
      Stat: TStatistics;
  procedure UpdateStOv;
    begin
      Stelling^.Statistics(Stat);
      wst:=Stat.wn; wdm:=Stat.wd; zst:=Stat.zn; zdm:=Stat.zd;
      UpdateOverz;
    end;
  procedure ScanSide;
    begin
      //check small boards/stones
      if (X>457) and (X<500)
        and (Y>=ovy[2]) and (Y<ovy[1]+40+dy) then
      begin
        if GetConf(cfSound) then BeepOK;
        stone:=zn; cmd:=1;
        if Y>=ovy[2]+40 then  stone:=zd;
        if Y>=ovy[1] then stone:=wn;
        if Y>=ovy[1]+40 then stone:=wd;
        if (Y>191) and (Y<286) then
        begin
          cmd:=2;
          if Y>243 then cmd:=3;
        end;
        if cmd=1 then
        begin
          GMouse.Hide;
          if Phase=1 then StopSchijfSleep;
          phase:=1;
          SchijfSleep:=Stone;
          New(Schijf,init(dx,dy,OK));
          OldX:=X-(dx div 2);
          OldY:=Y-(dy div 2);
          Schijf^.Get(OldX,OldY);
          GMouse.Show;
        end else
        begin
          Case cmd of
          2: Stelling^.Fields:=fldStandard;
          3: Stelling^.Fields:=fldBlank;
          end;
          GMouse.Hide;
          TekenStelling(Stelling,1);
          UpdateStOv;
          GMouse.Show;
        end;
        repeat
          GMouse.GetPosition(BtnStatus,X,Y);
        until BtnStatus=0;
      end;
    end;
  begin
    SchijfSleep:=nostone;
    Phase:=0;
    repeat
      GMouse.GetPosition(BtnStatus,X,Y);
      if BtnStatus=1 then
        ScanSide;
      ScanDambord(Found,Field,Btn);
      if Found and (Phase=1) then
      begin
        Case Field of
        FldError:
        begin
          GMouse.Hide;
          StopSchijfSleep;
          GMouse.Show;
          Phase:=0;
        end;
        FldNone: if GetConf(cfSound) then BeepError;
        1..50:
         if Btn=1 then
         begin
          if GetConf(cfSound) then BeepOK;
          GMouse.Hide;
          StopSchijfSleep;
          TekenVeld(Field);
          TekenSteen(Field,Stone);
          Stelling^.SetField(Field,Stone);
          UpdateStOv;
          StartSchijfSleep(Stone,Field);
          GMouse.Show;
         end;
        end;
      end;
      if Found and (Field>1) and (Field<50) and (Btn=2) then
      begin
        GMouse.Hide;
        if Phase=1 then StopSchijfSleep;
        TekenVeld(Field);
        if Stelling^.GetField(Field)<>NoStone then
          if GetConf(cfSound) then BeepOK;
        Stelling^.SetField(Field,NoStone);
        UpdateStOv;
        if Phase=1 then StartSchijfSleep(Stone,Field);
        GMouse.Show;
      end;
    until Phase=0;
  end;}

{constructor TReplayBox.Init;
  begin
    TAlertBox.Init;
    AddLine('^s2^c15^hc^bNASPELEN^b');
    AddLine('^hcGebruik deze knoppen om door de partij te lopen');
    AddButton('  |<  ');
    AddButton('<<');
    AddButton('<');
    AddButton('>');
    AddButton('>>');
    AddButton('>|');
    Default:=3;
    GetButtonSize;
    R^.setbounds(135,405,504,475);
    PlaceButtons;
  end;}

{procedure TekenScherm;
  var MaxX,MaxY: integer;
      S: String;
      x: byte;
  begin
    MaxX:=GetMaxX; MaxY:=GetMaxY;
    GMouse.Hide;
    setfillstyle(solidfill,3);
    DrawBar(0,0,MaxX,MaxY);
    SetColor(1);
    Rectangle(0,0,MaxX,MaxY);
    Line(0,19,MaxX,19);
    Line(0,35,MaxX,35);
    S:='^hc^vb^b^s2^c15DAM-PC versie '+Version;
    WriteCBox(addr(S),1,1,MaxX-1,18,9);
    Menu.Draw;
    MP[1].Draw;
    MP[2].Draw;
    if GetMode(mdReplay) then
    begin
      GMouse.Show;
      Replay.Draw;
      GMouse.Hide;
    end;
    if Game.Descr<>'' then
    begin
      SetColor(15);
      S:='Spelbeschrijving:';
      WriteCXY(addr(S),6,44,3);
      SetColor(1);
      WriteCXY(addr(Game.Descr),6,62,3);
    end;
    if GetMode(mdStelling) then
    begin
      S:='^hc^c11^s2^bSTELLING INVOEREN';
      WriteCbox(addr(S),219,50,419,65,3);
      TekenStellingInv;
    end;
    if GetMode(mdPause) then
    begin
      S:='^c11^s2^bPAUZE';
      WriteCbox(@S,585,40,635,55,3);
    end;
    SetColor(1);
    Rectangle(183,79,240,95);
    Rectangle(183,382,240,398);
    S:='^vb^b^s2^c00'+Partij[2].Name;
    WriteBox(addr(S),250,mpy[1],476,mpy[1]+18);
    S:='^vb^b^s2^c00'+Partij[1].Name;
    WriteBox(addr(S),250,mpy[2],476,mpy[2]+18);
    TekenDambord;
    TekenStelling(Stelling,Game.Side);
    if GetConf(cfClock) and GetMode(mdNormal) then
      for x:=1 to 2 do
      begin
        TekenKlok(x);
        TekenTijd(x);
      end;
    if (GetConf(cfReg) and (not GetMode(mdStelling))) or GetMode(mdReplay) then
    begin
      setFillStyle(SolidFill,7);
      DrawBar(3,80,176,99);
      setcolor(1);
      Rectangle(2,79,177,380);
      Line(3,95,176,95);
      SetColor(15);
      S:=Partij[1].Name;
      writebox(addr(S),27,81,101,98);
      SetColor(0);
      S:=Partij[2].Name;
      writebox(addr(S),102,81,176,98);
      if Reg<>nil then
      begin
        Reg^.prChanged:=true;
        Reg^.Draw;
      end;
    end;
    if GetConf(cfAnal) and (not GetMode(mdStelling)) then
    begin
      Anal.Redraw:=true;
      Anal.DrawFrame;
    end;
    GMouse.Show;
  end;}

function GetConf(Mask: byte): boolean;
  begin
    GetConf:=(Conf and Mask)>0;
  end;

procedure SetConf(Mask: byte; Enable: boolean);
  begin
    if Enable then
      Conf:=Conf or Mask
    else
      Conf:=Conf and ($FF-Mask);
    //UseSound:=GetConf(cfSound);
  end;

function GetRefr(Mask: byte): boolean;
  begin
    GetRefr:=(Refr and Mask)>0;
  end;

procedure SetRefr(Mask: byte; Enable: boolean);
  begin
    if Enable then
      Refr:=Refr or Mask
    else
      Refr:=Refr and ($FF-Mask);
  end;

function GetMode(Mask: byte): boolean;
  begin
    GetMode:=(Mode and Mask)>0;
  end;

procedure SetMode(Mask: byte; Enable: boolean);
  begin
    if Enable then
      Mode:=Mode or Mask
    else
      Mode:=Mode and ($FF-Mask);
  end;

function GetPhase(Mask: byte): boolean;
  begin
    GetPhase:=(Game.Phase and Mask)>0;
  end;

procedure SetPhase(Mask: byte; Enable: boolean);
  begin
    if Enable then
      Game.Phase:=Game.Phase or Mask
    else
      Game.Phase:=Game.Phase and ($FF-Mask);
  end;

function GetNiveau(Mask: byte): boolean;
  begin
    GetNiveau:=Mask=Niveau;
  end;

function GetPartij(Mask: byte): boolean;
  begin
    if Mask<3 then
      GetPartij:=(Mask=Player[1].Typ)
    else
      GetPartij:=(Mask-2=Player[2].Typ);
  end;

end.