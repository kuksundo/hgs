{
  ============== TURBO-PASCAL UNIT DAMEVAL =============

                 versie 2.1 (27-06-96)

  (c) N. Haeck

}
unit DamEval;

{$G+} {$N+} {$X+}

INTERFACE

uses Objects,DamCheck,WBasic;

type

{ TLevels record }

  TLevels=record
    Start: byte;
    Step : byte;
    Stop : byte;
    Flops: integer;
    First:  single;
    Multi: single;
  end;

{ TFactors record }

  PFactors=^TFactors;
  TFactors=record
    fcTot,fcRel,fcDam,fcYps,fcFrc,fcIso,fcFst,fc3DF,fcAfr,fcDch: single;
  end;

{ TController pointer }

  PController=^TController;
  PEvaluator=^TEvaluator;

{ TEvalRec object }

  PEvalRec=^TEvalRec;
  TEvalRec=object
    Move: PTree;
    Evaluator: PEvaluator;
    Value: single;
    constructor Init(AMove: PTree);
    destructor Done;
  end;

  PEvalRecList=^TEvalRecList;
  TEvalRecList=array[0..MaxCollectionSize-1] of PEvalRec;

{ TEvaluator object }

  TEvaluator=object(TField)
    Control: PController;
    Items: PEvalRecList;
    Count,Limit: integer;
    Current: integer;
    Level: byte;
    State: byte;
    Ref:  single;
    Size: single;
    constructor Init(AFields: TFieldRec; AControl: PController; ALevel: byte);
    destructor Done; virtual;
    function CalculateBalance(F: PFactors; S: PStatistics): single;
    procedure CheckReference;
    function CheckUnStable: boolean;
    procedure DecrementFlops;
    procedure DeleteItem(Item: integer);
    procedure Evaluate(var Value: single);
    procedure FreeItemList;
    procedure GetBalance(var Value: single);
    procedure GetBalanceUnstable(var Value: single);
    procedure GetBestValue(var Value: single);
    procedure GetItemField(Item: integer; var F: TField);
    function GetItemMove(Item: integer): PTree;
    function GetItemMoveString(Item: integer; Side: byte): string10;
    function GetItemValue(Item: integer): single;
    function GetState(AState: byte): boolean;
    procedure InitFixedItems(var OutOfMem,Impossible: boolean);
    procedure InitItemEvaluator(Item: integer; var Eval: PEvaluator);
    procedure InitItemList;
    function MustReturn: boolean;
    procedure SetState(AState: byte; Enable: boolean);
    procedure SortFixedItems;
  end;

{ TController object }

  TController=object(TEvaluator)
    FlopsPerRun: integer;
    Flops: integer;
    RunLevel: byte;
    Levels: TLevels;
    Factors: TFactors;
    Running: boolean;
    Finished: boolean;
    MoveFound: boolean;
    EvaluationStop: boolean;
    MemHoldFree: longint;
    constructor Init(AField: TFieldRec);
    function GetBestMove: PTree;
    procedure InitTree; virtual;
    procedure Run;
    procedure SetRunLevel(ARunLevel: byte);
  end;

{ TChooser object }

  PChooseRec=^TChooseRec;
  TChooseRec=object(TObject)
    Value: single;
    Move: PTree;
    Mark: boolean;
    HitMove: boolean;
    constructor Init(EvalRec: PEvalRec);
  end;

  PChooser=^TChooser;
  TChooser=object(TCollection)
    Control: PController;
    constructor Init(AControl: PController);
    function ChooseMove: PTree;
  end;

const

{ Evaluator State flags }

  esHitMove =$01;
  esFixed   =$02;
  esBusy    =$04;
  esUnStable=$08;
  esLowLevel=$10;

{ Minimum/Maximum Balance }

  MinimalBalance=-60;
  MaximalBalance=-MinimalBalance;
  LessThanMinimal=MinimalBalance-1;

{ Default levels }

  DefaultLevels: TLevels =
   ( Start: 0; Step: 1; Stop: 2;
     Flops: 50;
     First: 5.0; Multi: 10.0 );

{ Default factors }

  DefaultFactors: TFactors =
    (fcTot: 1.0;    fcRel: 0.8;   fcDam: 0.4;
     fcYps: 0.0005; fcFrc: 0.005; fcIso:-0.0001;
     fcFst: 1.3;    fc3DF: 0.01;  fcAfr: 0{0.0017};
     fcDch: 0.001);

{ Unstable check size }

  UnstableCheckSize: single = 0.005;

IMPLEMENTATION

uses DamConst;

{ TEvalRec object }

constructor TEvalRec.Init(AMove: PTree);
  begin
    Move:=AMove;
    Evaluator:=nil;
    Value:=MinimalBalance;
  end;

destructor TEvalRec.Done;
  begin
    Dispose(Move,done);
    if Evaluator<>nil then Dispose(Evaluator,done);
  end;

{ TEvaluator object }

constructor TEvaluator.Init(AFields: TFieldRec; AControl: PController; ALevel: byte);
  begin
    TField.Init(AFields);
    Control:=AControl;
    Level:=ALevel;
    if MustHit then State:=esHitMove;
  end;

destructor TEvaluator.Done;
  begin
    FreeItemList;
    TField.Done;
  end;

function TEvaluator.CalculateBalance(F: PFactors; S: PStatistics): single;
  var
    wtot,ztot,tot: byte;
    szTot,szDam,szFst,sz3DF: integer;
    szRel: single;
  procedure Calculate3DamFinal;
    var
      d1,d2,i,side: byte;
    begin
      sz3DF:=0;
      if (abs(szDam)>2) and (F^.fc3DF<>0) then
      begin
        if szDam>0 then
        begin
          d1:=wd; d2:=zd;
        end else
        begin
          d1:=zd; d2:=wd;
        end;
        Side:=Level mod 2;
        for i:=1 to 16 do
        begin
          if Fields[DField[Side,i]]=d1 then sz3DF:=sz3DF+DField[2,i];
          if Fields[DField[Side,i]]=d2 then sz3DF:=sz3DF-DField[2,i];
        end;
        if szDam<0 then sz3DF:=-sz3DF;
      end;
    end;
  begin
    With S^ do
    begin
      wtot:=wn+wd; ztot:=zn+zd; tot:=wtot+ztot;
      szTot:=wtot-ztot;
      if Tot>0 then szRel:=szTot/Tot else szRel:=0;
      szDam:=wd-zd;
      szFst:=0;
      if wd>0 then inc(szFst);
      if zd>0 then dec(szFst);
      Calculate3DamFinal;
    end;
    CalculateBalance:=
      szTot*F^.fcTot+
      szRel*F^.fcRel+
      szDam*F^.fcDam+
      S^.Yp*F^.fcYps+
      S^.Fc*F^.fcFrc+
      S^.Is*F^.fcIso+
      szFst*F^.fcFst+
      sz3DF*F^.fc3DF+
      S^.Df*F^.fcDch;
  end;

procedure TEvaluator.CheckReference;
  var i: integer;
  begin
    {check for shortcuts and update current value}
    if Items^[Current]^.Value>Ref then
    begin
      if odd(Level) then
      begin
        {if black, skip rest}
        Current:=Count;
      end else
      begin
        {if white, use new reference}
        Ref:=Items^[Current]^.Value;
        if Ref=MaximalBalance then
        begin
          if Level>0 then Current:=Count else inc(Current);
        end else
          inc(Current);
      end;
    end else
      inc(Current);
  end;

function TEvaluator.CheckUnStable: boolean;
  var
    i: integer;
    UnStable: boolean;
  begin
    UnStable:=true;
    i:=0;
    repeat
      Unstable:=Items^[i]^.Evaluator^.GetState(esHitMove);
      inc(i);
    until (not Unstable) or (i=count);
    CheckUnStable:=UnStable;
  end;

procedure TEvaluator.DecrementFlops;
  begin
    dec(Control^.Flops);
  end;

procedure TEvaluator.DeleteItem(Item: integer);
  var i: integer;
  begin
    if (Item<0) or (Item>=Count) then exit;
    Dispose(Items^[Item],done);
    for i:=Item to Count-2 do
      Items^[i]:=Items^[i+1];
    dec(Count);
  end;

procedure TEvaluator.Evaluate(var Value: single);
  procedure EvaluateLow;
    begin
      GetBalance(Value);
      SetState(esBusy,False);
    end;
  procedure EvaluateLowUnstable;
    begin
      GetBalanceUnstable(Value);
      SetState(esBusy,False);
    end;
  procedure EvaluateMain;
    var
      Eval: PEvaluator;
      ItemValue: single;
    begin
      repeat
        Eval:=Items^[Current]^.Evaluator;
        if not Eval^.Getstate(esBusy) then
          Eval^.Ref:=-Ref;
        Eval^.Evaluate(ItemValue);
        if not Eval^.GetState(esBusy) then
        begin
          Items^[Current]^.Value:=-ItemValue;
          CheckReference;
          if Current=Count then
          begin
            SetState(esBusy,false);
            Current:=0;
            GetBestValue(Value);
          end;
        end;
      until MustReturn or not GetState(esBusy);
    end;
  procedure FreeEvaluation;
    begin
      if not GetState(esFixed) then FreeItemList;
    end;
  procedure InitEvaluation;
    var
      Eval: PEvaluator;
      ItemSize: single;
      i: integer;
    begin
      if not GetState(esFixed) then
        InitItemList
      else
        {if black: fill values again with minimals,in case check skips them}
        if Odd(Level) then
          for i:=0 to Count-1 do
            Items^[i]^.Value:=MinimalBalance;
      if Count=0 then
      begin
        Value:=MinimalBalance;
        exit;
      end;
      ItemSize:=Size/(Count+1);
      for i:=0 to Count-1 do
      begin
        Eval:=Items^[i]^.Evaluator;
        Eval^.Size:=ItemSize;
        Eval^.SetState(esLowLevel,ItemSize<1);
      end;
      if not GetState(esHitMove) then  SetState(esUnstable,CheckUnstable);
      SetState(esBusy,True);
    end;
  begin
    if GetState(esBusy) then
    begin
      {main evaluation}
      if GetState(esLowLevel) then
      begin
        if GetState(esHitMove) then
          EvaluateMain
        else
        begin
          if GetState(esUnstable) then
          begin
            if (Size<UnstableCheckSize) then
              EvaluateLowUnstable
            else
              EvaluateMain;
          end else
            EvaluateLow
        end;
      end else
        EvaluateMain;
      if not GetState(esBusy) then
        FreeEvaluation;
      exit;
    end;
    InitEvaluation;
  end;

procedure TEvaluator.FreeItemList;
  var i: integer;
  begin
    if Items<>nil then
    begin
      for i:=0 to Count-1 do
        Dispose(Items^[i],done);
      FreeMem(Items,SizeOf(pointer)*Limit);
      Items:=nil;
    end;
  end;

procedure TEvaluator.GetBalance(var Value: single);
  var Stats: TStatistics;
  begin
    Statistics(Stats);
    Value:=CalculateBalance(@Control^.Factors,@Stats);
  end;

procedure TEvaluator.GetBalanceUnstable(var Value: single);
  var Stats: TStatistics;
  begin
    Statistics(Stats);
    if Stats.wn>0 then dec(Stats.wn) else dec(Stats.wd);
    Value:=CalculateBalance(@Control^.Factors,@Stats);
  end;

procedure TEvaluator.GetBestValue(var Value: single);
  var i: integer;
  begin
    Value:=MinimalBalance;
    for i:=0 to Count-1 do
      if Items^[i]^.Value>Value then
        Value:=Items^[i]^.Value;
  end;

procedure TEvaluator.GetItemField(Item: integer; var F: TField);
  begin
    F.Init(Self.Fields);
    F.PerformMove(Items^[Item]^.Move);
    F.Reverse;
  end;

function TEvaluator.GetItemMove(Item: integer): PTree;
  begin
    if (Item<Count) and (Item>=0) and (Items<>nil) then
      GetItemMove:=Items^[Item]^.Move
    else
      GetItemMove:=nil;
  end;

function TEvaluator.GetItemMoveString(Item: integer; Side: byte): string10;
  var List: TMoveList;
  begin
    if (Item<Count) and (Item>=0) and (Items<>nil) then
    begin
      MakeMoveList(List,Items^[Item]^.Move);
      GetItemMoveString:=MoveToString(List,Side);
    end else
      GetItemMoveString:='';
  end;

function TEvaluator.GetItemValue(Item: integer): single;
  begin
    if (Item<Count) and (Item>=0) and (Items<>nil) then
      GetItemValue:=Items^[Item]^.Value
    else
      GetItemValue:=0;
  end;

function TEvaluator.GetState(AState: byte): boolean;
  begin
    Getstate:=(State and AState)>0;
  end;

procedure TEvaluator.InitFixedItems(var OutOfMem,Impossible: boolean);
  var
    ItemOutofMem,ItemImpossible: boolean;
    i: integer;
  begin
    if Control^.MemHoldFree>MemAvail then
    begin
      OutOfMem:=true;
      exit;
    end;
    if GetState(esFixed) then
    begin
      OutOfMem:=false;
      Impossible:=true;
      if Count=0 then exit;
      i:=0;
      repeat
        Items^[i]^.Evaluator^.InitFixedItems(ItemOutofMem,ItemImpossible);
        if ItemOutOfMem then OutOfMem:=true;
        if not ItemImpossible then Impossible:=false;
        inc(i);
      until (i=count) or OutOfMem or Impossible;
    end else
    begin
      OutOfMem:=false;
      Impossible:=false;
      InitItemList;
      SetState(esFixed,true);
    end;
  end;

procedure TEvaluator.InitItemEvaluator(Item: integer; var Eval: PEvaluator);
  var F: TField;
  begin
    GetItemField(Item,F);
    New(Eval,init(F.Fields,Control,Level+1));
  end;

procedure TEvaluator.InitItemList;
  var Moves,ANext: PTree;
      i: integer;
  begin
    CheckMoves(Moves);
    if not Moves^.Empty then
    begin
      Limit:=Moves^.Width;
      GetMem(Items,SizeOf(pointer)*Limit);
      Count:=Limit;
      i:=0;
      while Moves<>nil do
      begin
        ANext:=Moves^.Next;
        Moves^.Next:=nil;
        New(Items^[i],Init(Moves));
        InitItemEvaluator(i,Items^[i]^.Evaluator);
        inc(i);
        Moves:=ANext;
      end;
    end else
      Dispose(Moves,done);
    DecrementFlops;
  end;

function TEvaluator.MustReturn: boolean;
  begin
    MustReturn:=Control^.Flops<0;
  end;

procedure TEvaluator.SetState(AState: byte; Enable: boolean);
  begin
    if Enable then
      State:=State or AState
    else
      State:=State and ($FF-AState);
  end;

procedure TEvaluator.SortFixedItems;
  var i,j: integer;
      Temp: PEvalRec;
  begin
    if (Count=0) or not GetState(esFixed) then exit;
    if Count>1 then
      for i:=0 to Count-2 do
        for j:=i+1 to Count-1 do
          if Items^[j]^.Value>Items^[i]^.Value then
          begin
            Temp:=Items^[j];
            Items^[j]:=Items^[i];
            Items^[i]:=Temp;
          end;
    for i:=0 to Count-1 do
      Items^[i]^.Evaluator^.SortFixedItems;
  end;

{ TController object }

constructor TController.Init(AField: TFieldRec);
  begin
    TEvaluator.Init(AField,@Self,0);
    Levels:=DefaultLevels;
    Factors:=DefaultFactors;
    MemHoldFree:=round(2.0*(MemAvail/3.0));
    InitTree;
  end;

procedure TController.InitTree;
  var OutOfMem,Impossible: boolean;
  begin
    repeat
      InitFixedItems(OutOfMem,Impossible);
    until OutOfMem or Impossible;
  end;

function TController.GetBestMove: PTree;
  var
    AValue: single;
    i: integer;
  begin
    if Count=0 then
    begin
      GetBestMove:=nil;
      exit;
    end;
    AValue:=LessThanMinimal;
    for i:=0 to Count-1 do
      if Items^[i]^.Value>AValue then
      begin
        GetBestMove:=Items^[i]^.Move;
        AValue:=Items^[i]^.Value;
      end;
  end;

procedure TController.Run;
  var
    AValue: single;
    OldRunLevel: byte;
  procedure InitRun;
    begin
      SetRunLevel(Levels.Start);
      Ref:=MinimalBalance;
      Evaluate(AValue);
      Running:=true;
    end;
  begin
    if EvaluationStop then exit;
    Flops:=Levels.Flops;
    if Running then
    begin
      if GetState(esBusy) then
      begin
        Evaluate(AValue);
        exit;
      end;
      SortFixedItems;
      MoveFound:=true;
      if RunLevel>=Levels.Stop then Finished:=true;
      OldRunLevel:=RunLevel;
      SetRunLevel(RunLevel+Levels.Step);
      if RunLevel=OldRunLevel then
      begin
        EvaluationStop:=true;
        exit;
      end;
      Ref:=MinimalBalance;
      Evaluate(AValue);
      exit;
    end;
    InitRun;
  end;

procedure TController.SetRunLevel(ARunLevel: byte);
  begin
    Size:=Levels.First;
    RunLevel:=0;
    while (RunLevel<ARunLevel) and (Size<1e36) do
    begin
      Size:=Size*Levels.Multi;
      inc(RunLevel);
    end;
  end;

{ TChooseRec object }

constructor TChooseRec.Init(EvalRec: PEvalRec);
  begin
    TObject.Init;
    Value:=EvalRec^.Value;
    Move:=EvalRec^.Move;
    HitMove:=EvalRec^.Evaluator^.GetState(esHitMove);
  end;

{ TChooser object }

constructor TChooser.Init(AControl: PController);
  var i: integer;
      ARec: PChooseRec;
  begin
    TCollection.Init(10,10);
    Control:=AControl;
    for i:=0 to Control^.Count-1 do
    begin
      New(ARec,init(Control^.Items^[i]));
      Insert(ARec);
    end;
  end;

function TChooser.ChooseMove: PTree;
  var BestValue: single;
      i: integer;
      BestCount,BestNum: integer;
  begin
    if Count=0 then
    begin
      ChooseMove:=nil;
      exit;
    end;
    {afruilen voorkomen}
    if not Control^.GetState(esHitMove) then
      for i:=0 to Count-1 do
        if PChooseRec(At(i))^.HitMove then
          PChooseRec(At(i))^.Value:=
          PChooseRec(At(i))^.Value-Control^.Factors.fcAfr;
    BestValue:=LessThanMinimal;
    for i:=0 to Count-1 do
      if PChooseRec(At(i))^.Value>BestValue then
        BestValue:=PChooseRec(At(i))^.Value;
    BestCount:=0;
    for i:=0 to Count-1 do
    begin
      PChooseRec(At(i))^.Mark:=(PChooseRec(At(i))^.Value=BestValue);
      if PChooseRec(At(i))^.Mark then inc(BestCount);
    end;
    BestNum:=Random(BestCount);
    BestCount:=0;
    for i:=0 to Count-1 do
      if PChooseRec(At(i))^.Mark then
        if BestNum=BestCount then
        begin
          ChooseMove:=PChooseRec(At(i))^.Move;
          exit;
        end else
          inc(BestCount);
  end;

end.
