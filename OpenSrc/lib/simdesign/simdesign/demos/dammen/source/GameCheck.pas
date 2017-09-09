{ GameCheck.pas

  adapted from:

  ============== TURBO-PASCAL UNIT DAMCHECK =============

                 versie 2.1 (27-06-96)

  copyright (c) N. Haeck, 1996

}
unit GameCheck;

interface

uses
  Classes, SysUtils, GameConst, Math;

type

{ TTree class }

  TTree = class
    Next: TTree;
    Under: TTree;
    FMove: TMove;
    constructor Create(AMove: TMove);
    constructor Copy(ATree: TTree);
    constructor Load(var S: TStream);
    destructor Destroy; override;
    function Deepest: TTree;
    function Depth: integer;
    function Empty: boolean;
    procedure Insert(T: TTree);
    function InsertMove(AMove: TMove): TTree;
    procedure MakeParallel;
    function MoveType: byte;
    procedure Store(var S: TStream);
    function Width: integer;
  end;

{ TField object }

  TField = class
    Fields: TFieldRec;
    constructor Create(AFields: TFieldRec);
    constructor Load(var S: TStream);
    procedure CheckHitDam(StartField: byte; Tree: TTree; Hits: pointer);
    procedure CheckHitStone(StartField: byte; Tree: TTree; Hits: pointer);
    procedure CheckMoveDam(StartField: byte; Tree: TTree);
    procedure CheckMoveStone(StartField: byte; Tree: TTree);
    procedure CheckMoves(var MoveTree: TTree);
    procedure FindHitDam(StartField: byte; Dir: byte; Hits: pointer;
                           var HitField,EndField: byte);
    procedure FindHitStone(StartField: byte; Dir: byte; Hits: pointer;
                           var HitField,EndField: byte);
    function GetField(Field: byte): byte;
    procedure MoveHit(FieldFrom,FieldTo,FieldHit: byte);
    procedure MoveNorm(FieldFrom,FieldTo: byte);
    function MustHit: boolean;
    procedure PerformBackMove(M: TTree);
    procedure PerformMove(M: TTree);
    procedure Reverse;
    procedure SetField(Field, Value: byte);
    procedure Statistics(var Stats: TStatistics);
    procedure Store(var S: TStream);
    //procedure WriteField; virtual; {NYI: weghalen}
  end;

{ Conversion (linked) Tree->static list }

procedure MakeMoveList(var List: TMoveList; Tree: TTree);
procedure ReverseMoveList(var List: TMoveList);
function MoveToString(List: TMoveList; Side: byte): string10;

{ Preserve longest tree procedure }

procedure PreserveLongestTree(var ATree: TTree);

{ Compare Moves }

function CompareMove(Tree1,Tree2: TTree): boolean;

implementation

{ TTree object }

constructor TTree.Create(AMove: TMove);
begin
  inherited Create;
  FMove:=AMove;
end;

constructor TTree.Copy(ATree: TTree);
begin
  inherited Create;
  FMove:=ATree.FMove;
  if ATree.Next<>nil then
    Next:= TTree.copy(ATree.Next);
  if ATree.Under<>nil then
    Under:=TTree.copy(ATree.Under);
end;

constructor TTree.Load(var S: TStream);
var
  HasNext, HasUnder: boolean;
begin
  inherited Create;
  S.Read(FMove,SizeOf(FMove));
  S.Read(HasNext,SizeOf(HasNext));
  if HasNext then
    Next:=TTree.Load(S);
  S.Read(HasUnder,SizeOf(HasUnder));
  if HasUnder then
    Under:=TTree.Load(S);
end;

destructor TTree.Destroy;
begin
  FreeAndNil(Next);
  FreeAndNil(Under);
  inherited;
end;

function TTree.Deepest: TTree;
begin
  if Under=nil then
    Deepest:=self
  else
    Deepest:=Under.Deepest;
end;

function TTree.Depth: integer;
begin
  if Under=nil then
    Depth:=1
  else
    Depth:=Under.Depth+1;
end;

function TTree.Empty: boolean;
begin
  Empty:=(FMove.Mt=mtNone);
end;

procedure TTree.Insert(T: TTree);
begin
  if Next=nil then
    Next:=T
  else
    Next.Insert(T);
end;

function TTree.InsertMove(AMove: TMove): TTree;
var ATree: TTree;
begin
  if AMove.Mt=mtNone then
  begin
    InsertMove:=nil;
    exit;
  end;
  if Empty then
  begin
    FMove:=AMove;
    InsertMove:=@Self;
  end else
  begin
    ATree:=TTree.Create(AMove);
    Insert(ATree);
    InsertMove:=ATree;
  end;
end;

procedure TTree.MakeParallel;
var NewTree: TTree;
begin
  if Under<>nil then
  begin
    Under.MakeParallel;
    if Under.Next<>nil then
    begin
      NewTree := TTree.Create(FMove);
      NewTree.Under:=Under.Next;
      NewTree.Next:=Next;
      Under.Next:=nil;
      Next:=NewTree;
    end;
  end;
  if Next<>nil then
    Next.MakeParallel;
end;

function TTree.MoveType: byte;
begin
  MoveType:=FMove.Mt;
end;

procedure TTree.Store(var S: TStream);
var HasNext,HasUnder: boolean;
begin
  HasNext:=Next<>nil;
  HasUnder:=Under<>nil;
  S.Write(FMove,SizeOf(FMove));
  S.Write(HasNext,SizeOf(HasNext));
  if HasNext then
    Next.Store(S);
  S.Write(HasUnder,SizeOf(HasUnder));
  if HasUnder then
    Under.Store(S);
end;

function TTree.Width: integer;
begin
  if Next=nil then
    Width:=1
  else
    Width:=Next.Width+1;
end;

{ TField object }

type

THitList=array[1..50] of boolean;

constructor TField.Create(AFields: TFieldRec);
begin
  inherited Create;
  Fields:=AFields;
end;

constructor TField.Load(var S: TStream);
begin
  inherited Create;
  S.Read(Fields,SizeOf(Fields));
end;

procedure TField.CheckHitDam(StartField: byte; Tree: TTree; Hits: pointer);
var
  Result,Temp: TTree;
  Move: TMove;
  HitField,EndField,Dir: byte;
begin
  for Dir:=1 to 4 do
  begin
    FindHitDam(StartField,Dir,Hits,HitField,EndField);
    while EndField<>fldError do
    begin
      Move.Assign(StartField,HitField,EndField,wd,Fields[HitField],mtHit);
      Result:=Tree.InsertMove(Move);
      MoveNorm(StartField,EndField);
      THitList(Hits^)[HitField]:=True;
      Temp:=TTree.Create(EmptyMove);
      CheckHitDam(EndField,Temp,Hits);
      if Temp.Empty then
        FreeAndNil(Temp)
      else
        Result.Under:=Temp;
      THitList(Hits^)[HitField]:=False;
      MoveNorm(EndField,StartField);
      EndField:=FDir[Dir,EndField];
      if (EndField<>FldError) and (Fields[EndField]<>NoStone) then
        EndField:=fldError;
    end;
  end;
end;

procedure TField.CheckHitStone(StartField: byte; Tree: TTree; Hits: pointer);
var
  Result,Temp: TTree;
  FMove: TMove;
  HitField,EndField,Dir: byte;
begin
  for Dir:=1 to 4 do
  begin
    FindHitStone(StartField,Dir,Hits,HitField,EndField);
    if EndField<>fldError then
    begin
      FMove.Assign(StartField,HitField,EndField,wn,Fields[HitField],mtHit);
      Result:=Tree.InsertMove(FMove);
      MoveNorm(StartField,EndField);
      THitList(Hits^)[HitField]:=True;
      Temp:=TTree.Create(EmptyMove);
      CheckHitStone(EndField,Temp,Hits);
      if Temp.Empty then
        FreeAndNil(Temp)
      else
        Result.Under:=Temp;
      THitList(Hits^)[HitField]:=False;
      MoveNorm(EndField,StartField);
    end;
  end;
end;

procedure TField.CheckMoveDam(StartField: byte; Tree: TTree);
var
  Dir,EndField: byte;
  Move: TMove;
begin
  for Dir:=1 to 4 do
  begin
    EndField:=FDir[Dir,StartField];
    while (EndField<>fldError) and (Fields[EndField]=NoStone) do
    begin
      Move.Assign(StartField,0,EndField,wd,0,mtMove);
      Tree.InsertMove(Move);
      EndField:=FDir[Dir,EndField];
    end;
  end;
end;

procedure TField.CheckMoveStone(StartField: byte; Tree: TTree);
var
  EndField: byte;
  FMove: TMove;
begin
  EndField:=FLU[StartField];
  if (EndField<>fldError) and (Fields[EndField]=NoStone) then
  begin
    FMove.Assign(StartField,0,EndField,wn,0,mtMove);
    Tree.InsertMove(FMove);
  end;
  EndField:=FRU[StartField];
  if (EndField<>fldError) and (Fields[EndField]=NoStone) then
  begin
    FMove.Assign(StartField,0,EndField,wn,0,mtMove);
    Tree.InsertMove(FMove);
  end;
end;

procedure TField.CheckMoves(var MoveTree: TTree);
var
  HitList: THitList;
  F: byte;
  ATree,ADeepest: TTree;
  Move: TMove;
begin
  MoveTree := TTree.Create(EmptyMove);
  FillChar(HitList,SizeOf(HitList),False);
  {check hits}
  for F:=1 to 50 do
    case Fields[F] of
    wn: CheckHitStone(F,MoveTree,@HitList);
    wd: CheckHitDam(F,MoveTree,@HitList);
    end;
  if MoveTree.Empty then
    {check moves}
    for F:=1 to 50 do
      case Fields[F] of
      wn: CheckMoveStone(F,MoveTree);
      wd: CheckMoveDam(F,MoveTree);
    end;
  if MoveTree.Empty then exit;
  MoveTree.MakeParallel;
  {bewaar langste hit(s): verplichting!}
  if MoveTree.MoveType=mtHit then PreserveLongestTree(MoveTree);
  {Worden stenen een dam?}
  ATree:=MoveTree;
  while ATree<>nil do
  begin
    ADeepest:=ATree.Deepest;
    if (ADeepest.FMove.Fe<6) and (ADeepest.FMove.Ts=wn) then
    begin
      Move.Assign(ADeepest.FMove.Fe,0,0,wn,0,mtDam);
      ADeepest.Under:=TTree.Create(Move);
    end;
    ATree:=ATree.Next;
  end;
end;

procedure TField.FindHitStone(StartField: byte; Dir: byte; Hits: pointer;
                         var HitField,EndField: byte);
begin
  EndField:=fldError;
  HitField:=FDir[Dir,StartField];
  if (HitField<>fldError) and ((Fields[HitField] and mskZwt)>noStone) then
  begin
    EndField:=FDir[Dir,HitField];
    if (EndField<>fldError) then
      if (Fields[EndField]<>noStone) or
         ((Hits<>nil) and (THitlist(Hits^)[HitField]=True)) then
        EndField:=fldError;
  end;
end;

procedure TField.FindHitDam(StartField: byte; Dir: byte; Hits: pointer;
                         var HitField,EndField: byte);
begin
  EndField:=fldError;
  HitField:=FDir[Dir,StartField];  {veld in richting}
  While (HitField<>fldError) and (Fields[HitField]=NoStone) do
    HitField:=FDir[Dir,HitField];
  if (HitField=fldError) or ((Fields[HitField] and mskZwt)=0) or
     ((Hits<>nil) and (THitList(Hits^)[HitField]=true)) then exit;
  EndField:=FDir[Dir,HitField];
  if (EndField=fldError) or (Fields[EndField]<>NoStone) then
  begin
    EndField:=fldError;
    exit;
  end;
end;

function TField.GetField(Field: byte): byte;
begin
  GetField:=Fields[Field];
end;

procedure TField.MoveHit(FieldFrom,FieldTo,FieldHit: byte);
begin
  Fields[FieldTo]:=Fields[FieldFrom];
  Fields[FieldFrom]:=noStone;
  Fields[FieldHit]:=noStone;
end;

procedure TField.MoveNorm(FieldFrom,FieldTo: byte);
begin
  Fields[FieldTo]:=Fields[FieldFrom];
  Fields[FieldFrom]:=noStone;
end;

function TField.MustHit: boolean;
var
  StartField,HitField,EndField,Dir: byte;
begin
  MustHit:=false;
  for StartField:=1 to 50 do
    if (Fields[StartField] and mskWit)>0 then
      for Dir:=1 to 4 do
      begin
        Case Fields[StartField] of
        wn: FindHitStone(StartField,Dir,nil,HitField,EndField);
        wd: FindHitDam(StartField,Dir,nil,HitField,EndField);
        end;
        if EndField<>fldError then
        begin
          MustHit:=true;
          exit;
        end;
      end;
end;

procedure TField.PerformBackMove(M: TTree);
var Top: TTree;
function ABove(M: TTree): TTree;
  var T: TTree;
  begin
    if M=Top then
    begin
      ABove:=nil;
      exit;
    end;
    T:=Top;
    while T.Under<>M do
      T:=T.Under;
    ABove:=T;
  end;
begin
  Top:=M;
  M:=Top.Deepest;
  while M<>nil do
  begin
    with M.FMove do
    begin
      Case Mt of
      mtMove: MoveNorm(Fe,Fs);
      mtHit :
        begin
          MoveNorm(Fe,Fs);
          SetField(Fh,Th);
        end;
      mtDam :
        case GetField(Fs) of
        wd: SetField(Fs,wn);
        zd: SetField(Fs,zn);
        end;
      end;
    end;
    M:=ABove(M);
  end;
end;

procedure TField.PerformMove(M: TTree);
begin
  while M<>nil do
  begin
    with M.FMove do
    begin
      Case Mt of
      mtMove: MoveNorm(Fs,Fe);
      mtHit : MoveHit(Fs,Fe,Fh);
      mtDam :
        case GetField(Fs) of
        wn: SetField(Fs,wd);
        zn: SetField(Fs,zd);
        end;
      end;
    end;
    M:=M.Under;
  end;
end;

procedure TField.SetField(Field, Value: byte);
begin
  Fields[Field]:=Value;
end;

procedure TField.Reverse;
const ReverseSide: array[0..8] of byte =
  (0,zn,zd,0,wn,0,0,0,wd);
var F1,F2,x: byte;
begin
  for x:=1 to 25 do
  begin
    F1:=Fields[x];
    F2:=Fields[51-x];
    Fields[x]:=ReverseSide[F2];
    Fields[51-x]:=ReverseSide[F1];
  end;
end;

procedure TField.Statistics(var Stats: TStatistics);
// local
function CheckIsol(Field: byte): byte;
  var Iso,x: byte;
  begin
    if not ISOpos[Field] then
    begin
      CheckIsol:=0;
      exit;
    end;
    Iso:=0;
    for x:=1 to 4 do
      if Fields[FDir[x,Field]]=NoStone then inc(Iso);
    CheckIsol:=Iso;
  end;
// local
function CheckCone(Field,Dir1,Dir2,Mask: byte): boolean;
  var F: byte;
  begin
    CheckCone:=true;
    F:=FDir[Dir1,Field];
    while F<>fldError do
    begin
      if (Fields[F] and Mask)>0 then
      begin
        CheckCone:=false;
        exit;
      end;
      F:=FDir[Dir1,F];
    end;
    F:=FDir[Dir2,Field];
    while F<>fldError do
    begin
      if (Fields[F] and Mask)>0 then
      begin
        CheckCone:=false;
        exit;
      end;
      F:=FDir[Dir2,F];
    end;
  end;
// local
function FreeWhiteCone(Field: integer): boolean;
  begin
    FreeWhiteCone:=true;
    repeat
      if not CheckCone(Field,1,2,mskZwt) then
      begin
        FreeWhiteCone:=false;
        exit;
      end;
      Field:=Field-10
    until Field<1;
  end;
// local
function FreeBlackCone(Field: byte): boolean;
  begin
    FreeBlackCone:=true;
    repeat
      if not CheckCone(Field,3,4,mskWit) then
      begin
        FreeBlackCone:=false;
        exit;
      end;
      Field:=Field+10
    until Field>50;
  end;
// local
function CheckDir(Field,Dir1,Dir2: byte; Fl: PFlagField): boolean;
  var F: byte;
  begin
    CheckDir:=False;
    F:=FDir[Dir1,Field];
    if (F<>fldError) and (Fl^[F]=true) then
    begin
      CheckDir:=True;
      exit;
    end;
    F:=FDir[Dir2,Field];
    if (F<>fldError) and (Fl^[F]=true) then
      CheckDir:=True;
  end;
// local
procedure ConstructCross(Field: byte; Fl: PFlagField);
  var Dir,F: byte;
  begin
    Fl^[Field]:=true;
    for Dir:=1 to 4 do
    begin
      F:=FDir[Dir,Field];
      while (F<>fldError) and (Fields[F]=NoStone) do
      begin
        Fl^[F]:=true;
        F:=FDir[Dir,F];
      end;
    end;
  end;
// main
var
  Field,yw,yz,fcw,fcz: byte;
  Flw,Flz: TFlagField;
  UseFlw,UseFlz: boolean;
begin
  FillChar(Stats,SizeOf(Stats),0);
  fcw:=0;
  fcz:=0;
  UseFlw:=false;
  UseFlz:=false;
  for Field:=1 to 50 do
    if Fields[Field]>0 then
    begin
      Case Fields[Field] of
      wn:
      begin
        inc(Stats.wn);
        yw:=YWpos[Field];
        inc(Stats.Yp,yw);
        {free cones}
        if yw>4 then
        begin
          inc(fcw,yw-4);
          case yw of
          6: if FreeWhiteCone(Field) then inc(fcw,2);
          7: if FreeWhiteCone(Field) then inc(fcw,5);
          8: if FreeWhiteCone(Field) then inc(fcw,12);
          end;
        end;
        case CheckIsol(Field) of
        3:inc(Stats.Fis);
        4:inc(Stats.Fis,4);
        end;
      end;
      wd:
      begin
        inc(Stats.wd);
        if not UseFlw then
          FillChar(Flw,SizeOf(Flw),false);
        UseFlw:=true;
        ConstructCross(Field,@Flw);
      end;
      zn:
      begin
        inc(Stats.zn);
        yz:=YZpos[Field];
        dec(Stats.Yp,yz);
        {free cones}
        if yz>4 then
        begin
          inc(fcz,yz-4);
          case yz of
          6: if FreeBlackCone(Field) then inc(fcz,2);
          7: if FreeBlackCone(Field) then inc(fcz,5);
          8: if FreeBlackCone(Field) then inc(fcz,12);
          end;
        end;
        case CheckIsol(Field) of
        3:dec(Stats.Fis);
        4:dec(Stats.Fis,4);
        end;
      end;
      zd:
      begin
        inc(Stats.zd);
        if not UseFlz then
          FillChar(Flz,SizeOf(Flz),false);
        UseFlz:=true;
        ConstructCross(Field,@Flz);
      end;
      end;
    end;
  if fcw>20 then fcw:=20;
  if fcz>20 then fcz:=20;
  Stats.fc:=fcw-fcz;
  if UseFlw or UseFlz then
  begin
    for Field:=1 to 50 do
      if Fields[Field]>0 then
        Case Fields[Field] of
        wn: if UseFlz and (DfzVal[Field]<>0) and CheckDir(Field,1,2,@Flz) then
          dec(Stats.df,DfzVal[Field]);
        zn: if UseFlw and (DfwVal[Field]<>0) and CheckDir(Field,3,4,@Flw) then
          inc(Stats.df,DfwVal[Field]);
        end;
  end;
end;

procedure TField.Store(var S: TStream);
begin
  S.Write(Fields,SizeOf(Fields));
end;

{ Conversion (linked) Tree->static list }

procedure MakeMoveList(var List: TMoveList; Tree: TTree);
var i: integer;
begin
  With List do
  begin
    Count:=Tree.Depth;
    for i:=0 to Count-1 do
    begin
      Move(Tree.FMove,Mv[i],SizeOf(Mv[i]));
      Tree:=Tree.Under;
    end;
  end;
end;

procedure ReverseMoveList;
var x: integer;
procedure ReverseField(var Fld: byte);
  begin
    if (Fld>0) and (Fld<51) then
      Fld:=51-Fld;
  end;
procedure ReverseType(var Typ: byte);
  begin
    Case Typ of
      wn: Typ:=zn;
      wd: Typ:=zd;
      zn: Typ:=wn;
      zd: Typ:=wd;
    end;
  end;
begin
  With List do
  begin
    for x:=0 to Count-1 do
    begin
      ReverseField(Mv[x].Fs);
      ReverseField(Mv[x].Fh);
      ReverseField(Mv[x].Fe);
      ReverseType(Mv[x].Ts);
      ReverseType(Mv[x].Th);
    end;
  end;
end;

function MoveToString(List: TMoveList; Side: byte): string10;
procedure fieldToString(Field: byte; var Temp: String10);
  begin
    if Side=2 then Field:=51-Field;
    str(Field:2,Temp);
  end;
var Res,Temp: String10;
    Last: integer;
begin
  MoveToString:='';
  Last:=List.Count-1;
  if Last<0 then exit;
  if List.Mv[Last].mt=mtDam then dec(Last);
  Res:='';
  FieldtoString(List.Mv[0].Fs,Res);
  Case List.Mv[Last].mt of
  mtMove:
  begin
    Res:=Res+'-';
    FieldToString(List.Mv[Last].Fe,Temp);
    Res:=Res+Temp;
  end;
  mtHit:
  begin
    Result:=Result+'x';
    FieldToString(List.Mv[Last].Fe,Temp);
    Result:=Result+Temp;
  end;
  end;
  if List.Mv[List.Count-1].mt=mtDam then
    Result:=Result+'d'
  else
    Result:=Result+' ';
  MoveToString:=Result;
end;

{ Preserve Longest Tree }

procedure PreserveLongestTree(var ATree: TTree);
var MaxDepth: integer;
    Where,Last,Next: TTree;
begin
  MaxDepth:=1;
  Where:=ATree;
  while Where<>nil do
  begin
    MaxDepth:=Max(MaxDepth,Where.Depth);
    Where:=Where.Next;
  end;
  Where:=ATree;
  Last:=nil;
  while Where<>nil do
  begin
    Next:=Where.Next;
    if Where.Depth<MaxDepth then
    begin
      if ATree=Where then
        ATree:=Next;
      Where.Next:=nil;
      FreeAndNil(Where);
      if Last<>nil then
        Last.Next:=Next;
    end else
    begin
      Last:=Where;
    end;
    Where:=Next;
  end;
end;

{ Compare Moves }

function CompareMove(Tree1,Tree2: TTree): boolean;
var Res: boolean;
    b1,b2: PByteArray;
    x: byte;
begin
  Res:=true;
  b1:=addr(Tree1.FMove);
  b2:=addr(Tree2.FMove);
  for x:=0 to Sizeof(TMove)-1 do
    if b1^[x]<>b2^[x] then Res:=false;
  CompareMove:=Res;
end;

end.
