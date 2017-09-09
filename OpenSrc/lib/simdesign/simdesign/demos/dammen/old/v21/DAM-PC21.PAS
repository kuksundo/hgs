{$F+} {$G+} {$N+}
{$DEFINE Regis} {Regis switch: registered version}
(*{$DEFINE Check}*) {Check switch: check volume id}

{
  ============== TURBO-PASCAL PROGRAMMA DAM-PC =============

                 versie 2.1 (27-06-96)

  (c) N. Haeck

}

uses Crt,Dos,Graph,Drivers,Objects,
     WBasic,Wtp,Wdam,BmpIO,DamCheck,DamEval
     {$IFDEF Regis}
      ,Protect
     {$ELSE}
      ,DamShare
     {$ENDIF};

{$IFDEF Regis}
procedure RegInfo; external;
{$L Reginfo.obj}

{$ENDIF}

const

{ Commando's }

  cmNiv    = 1;
  cmSpLoad =11;
  cmSpSave =12;
  cmSpNew  =13;
  cmSpNewSt=14;
  cmSpDescr=15;
  cmSpSvTXT=16;
  cmStSvBMP=17;
  cmMoveNow=31;
  cmHint   =32;
  cmBack   =33;
  cmPause  =34;
  cmAnal   =41;
  cmReg    =42;
  cmFNum   =43;
  cmSound  =44;
  cmClock  =45;
  cmStOv   =46;
  cmRev    =47;
  cmTNot   =48;
  cmMode   =61;
  cmHelp   =71;
  cmInfo   =75;
  cmEinde  =255;


{ Wegingsfactoren }

  Factors: array[0..2] of TFactors =
   ((fcTot: 1.0;    fcRel: 0.8;    fcDam: 0.4;
     fcYps: 0.0005; fcFrc: 0;      fcIso:-0.0001;
     fcFst: 1.3;    fc3DF: 0;      fcAfr: 0.0017; fcDch: 0.001),
    (fcTot: 1.0;    fcRel: 0.8;    fcDam: 0.4;
     fcYps: 0.0008; fcFrc: 0.0035; fcIso:-0.0001;
     fcFst: 1.3;    fc3DF: 0.0;    fcAfr: 0.0006; fcDch: 0.001),
    (fcTot: 1.0;    fcRel: 0.8;    fcDam: 0.3;
     fcYps: 0.0010; fcFrc: 0.0035; fcIso:-0.00005;
     fcFst: 1.3;    fc3DF: 0.01;   fcAfr: 0;      fcDch: 0.001) );

var

{ Evaluatie }

  Eval: PController;
  OldLevel,Level,Cycles: word;
  Perc: single;
  RemCount: word;
  MoveList: TMoveList;
  Best: PTree;
  EvPers: PEvPers;
  DrawDepth: byte;
  AMove: PTree;
  LapTime: real;
  Stat: TStatistics;
  Stones,OldStones: byte;
  Phase: byte;

{ Pause }

  PauseSec: byte;

{ Default filename }

  DefFileName: string;

{ Registration }

{$IFDEF Regis}
  DskNr,RegNr,DskCd: word;
  RegName: string[40];
{$ENDIF}

{ Algemeen }

  x: byte;

procedure HandleMenuCommand(Choice: integer); forward;

procedure NewGame;
  begin
    if Stelling<>nil then
      Dispose(Stelling,done);
    New(Stelling,Init(StartStelling^.Fields));
    Stelling^.Statistics(Stat);
    Game.Zet:=0;
    Game.Max:=0;
    Game.Side:=1;
    Game.Phase:=phInit;
    Game.Winner:=0;
    Game.Descr:='';
    if Reg<>nil then
      Dispose(Reg,done);
    New(Reg,init);
    for x:=1 to 2 do
    begin
      Tijd[x].Init(0,0,0,0,false);
    end;
    Tijd[2].Halt;
    Anal.Init;
  end;

procedure InitVars;
  var x,y: integer;
      h,m,s,sh: word;
      T1,T2: real;
  begin
    New(StartStelling,Init(fldStandard));
    New(Stelling,Init(StartStelling^.Fields));
    Eval:=nil;
    EvPers:=nil;
    Reg:=nil;
    StdNames[1]:='Computer';
    StdNames[2]:='Persoon';
    Partij[1].Typ:=2;
    Partij[1].Name:=StdNames[2];
    Partij[2].Typ:=1;
    Partij[2].Name:=StdNames[1];
    Niveau:=2;
    Randomize;
    InitTeken;
    Conf:=cfInit;
    UseSound:=GetConf(cfSound);
    Refr:=rfInit;
    Mode:=mdInit;
    Game.Phase:=phInit;
    Game.Descr:='';
    for x:=1 to 2 do
    begin
      Tijd[x].Init(0,0,0,0,false);
      Tijd[x].Halt;
    end;
    Replay.Init;
    DefFileName:='SPEL01';
    {$IFNDEF Regis}
    InitShareWareVars;
    {$ENDIF}
  end;

procedure MakeMenu;
  var x,y: byte;
      LastSub: PSubItem;
  procedure SetFlagFuncForMenu(Menu: PMenu; Func: pointer; Id: word);
    var LastSub: PSubItem;
    begin
      LastSub:=Menu^.GetLastSub;
      LastSub^.GetFlag:=Func;
      LastSub^.FlagId:=Id;
    end;
  procedure SetFlagFunc(Func: pointer; Id: word);
    begin
      SetFlagFuncForMenu(@Menu,Func,Id);
    end;
  begin
    with Menu do
    begin
      Init(1,20,GetMaxX-1);
      AddMenuItem('Niveau',0);
      AddSubItem('Beginner',cmNiv,TRadOff,true);
      SetFlagFunc(@GetNiveau,1);
      AddSubItem('2',cmNiv+1,TRadOff,true);
      SetFlagFunc(@GetNiveau,2);
      AddSubItem('3',cmNiv+2,TRadOff,true);
      SetFlagFunc(@GetNiveau,3);
      AddSubItem('4',cmNiv+3,TRadOff,true);
      SetFlagFunc(@GetNiveau,4);
      AddSubItem('5',cmNiv+4,TRadOff,true);
      SetFlagFunc(@GetNiveau,5);
      AddSubItem('6',cmNiv+5,TRadOff,true);
      SetFlagFunc(@GetNiveau,6);
      AddSubItem('Onbeperkt',cmNiv+6,TRadOff,true);
      SetFlagFunc(@GetNiveau,7);
      AddMenuItem('Spel',0);
      AddSubItem('Ophalen',cmSpLoad,0,true);
      AddSubItem('Bewaren',cmSpSave,0,true);
      AddSubItem('Nieuw',cmSpNew,0,true);
      AddSubItem('Nieuw Standaard',cmSpNewSt,0,true);
      AddSubItem('-------',0,0,false);
      AddSubItem('Beschrijving',cmSpDescr,0,true);
      AddSubItem('-------',0,0,false);
      AddSubItem('Export als .TXT',cmSpSvTXT,0,true);
      AddSubItem('Export als .BMP',cmStSvBMP,0,true);
      AddMenuItem('Voortgang',0);
      AddSubItem('Nu zetten',cmMoveNow,0,true);
      AddSubItem('Hint',cmHint,0,true);
      AddSubItem('Terug',cmBack,0,true);
      AddSubItem('-------',0,0,false);
      AddSubItem('Pauze',cmPause,TBoxOff,true);
      SetFlagFunc(@GetMode,mdPause);
      AddMenuItem('Instellingen',0);
      AddSubItem('Analyse',cmAnal,TBoxOff,true);
      SetFlagFunc(@GetConf,cfAnal);
      AddSubItem('Notatie',cmReg,TBoxOff,true);
      SetFlagFunc(@GetConf,cfReg);
      AddSubItem('Velden',cmFNum,TBoxOff,true);
      SetFlagFunc(@GetConf,cfFNum);
      AddSubItem('Geluid',cmSound,TBoxOff,true);
      SetFlagFunc(@GetConf,cfSound);
      AddSubItem('Klok',cmClock,TBoxOff,true);
      SetFlagFunc(@GetConf,cfClock);
      AddSubItem('Steen-overzicht',cmStOv,TBoxOff,true);
      SetFlagFunc(@GetConf,cfStOv);
      AddSubItem('Omgedraaid',cmRev,TBoxOff,true);
      SetFlagFunc(@GetConf,cfRev);
      AddSubItem('Tijdnotatie',cmTNot,TBoxOff,true);
      SetFlagFunc(@GetConf,cfTNot);
{      AddMenuItem('Variant',0);
      AddSubItem('Fries dammen',0,TBoxOff,false);
      AddSubItem('Weggevertje',0,TBoxOff,false);}
      AddMenuItem('Mode',0);
      AddSubItem('Normaal',cmMode,TRadOff,true);
      SetFlagFunc(@GetMode,mdNormal);
      AddSubItem('Naspelen',cmMode+1,TRadOff,true);
      SetFlagFunc(@GetMode,mdReplay);
      AddSubItem('Stelling invoeren',cmMode+2,TRadOff,true);
      SetFlagFunc(@GetMode,mdStelling);
      AddMenuItem('Help',0);
      AddSubItem('Gebruiksaanwijzing',cmHelp,0,true);
      AddSubItem('Spelregels',cmHelp+1,0,true);
      AddSubItem('-------',0,0,false);
      AddSubItem('Info',cmInfo,0,true);
      AddMenuItem('Einde',cmEinde);
    end;
    with MP[1] do
    begin
      Init(184,383,239);
      AddMenuItem('Partij 1',0);
      AddSubItem('Computer',1,TRadOff,true);
      SetFlagFuncForMenu(@Mp[1],@GetPartij,1);
      AddSubItem('Persoon',2,TRadOff,true);
      SetFlagFuncForMenu(@Mp[1],@GetPartij,2);
      AddSubItem('----',0,0,false);
      AddSubItem('Naam ingeven',3,0,true);
    end;
    with MP[2] do
    begin
      Init(184,80,239);
      AddMenuItem('Partij 2',0);
      AddSubItem('Computer',1,TRadOff,true);
      SetFlagFuncForMenu(@Mp[2],@GetPartij,3);
      AddSubItem('Persoon',2,TRadOff,true);
      SetFlagFuncForMenu(@Mp[2],@GetPartij,4);
      AddSubItem('----',0,0,false);
      AddSubItem('Naam ingeven',3,0,true);
    end;
  end;

function CheckRemise: boolean;
  var Result: boolean;
  begin
    Result:=false;
    if not Eval^.GetState(esHitMove) then
      if Stones<7 then
        if Stones=OldStones then
        begin
          if (abs(wst+wdm-zst-zdm)<3) and (wdm>0) and (zdm>0) then
          begin
            inc(RemCount);
            if RemCount>20 then
            begin
              RemCount:=0;
              Result:=true;
            end;
          end;
        end else
        begin
          OldStones:=Stones;
          RemCount:=0;
        end;
    CheckRemise:=Result;
  end;

procedure StartEval;
  var
    i: word;
    choice: integer;
    Alert: PAlertBox;
    CompareResult: boolean;
  begin
    Stelling^.Statistics(Stat);
    case Game.Side of
    1: begin
         wst:=Stat.wn; wdm:=Stat.wd; zst:=Stat.zn; zdm:=Stat.zd;
       end;
    2: begin
         wst:=Stat.zn; wdm:=Stat.zd; zst:=Stat.wn; zdm:=Stat.wd;
       end;
    end;
    GMouse.Hide;
    UpdateOverz;
    GMouse.Show;
    Stones:=Stat.wn+Stat.zn+Stat.wd+Stat.zd;
    Phase:=0;
    case Stones of
      19..35: Phase:=1;
      0 ..18: Phase:=2;
    end;
    {start tijd}
    Tijd[Game.Side].Cont;
    Tijd[Game.Side].StartLap;
    New(Eval,init(Stelling^.Fields));
    if Niveau=7 then
      Eval^.Levels.Stop:=100
    else
      Eval^.Levels.Stop:=Niveau;
    {wegingsfactoren}
    Eval^.Factors:=Factors[Phase];
    {controleer 3 gelijke zetten}
    if Game.Zet>=8 then
    begin
      CompareResult:=true;
      for i:=0 to 3 do
        if Not(CompareMove(Reg^.Index^[Game.Zet-8+i],
                           Reg^.Index^[Game.Zet-4+i])) then
          CompareResult:=false;
      if CompareResult then
        for i:=0 to Eval^.Count-1 do
          if CompareMove(Reg^.Index^[Game.Zet-4],Eval^.GetItemMove(i)) then
            Eval^.DeleteItem(i);
    end;
    if Eval^.Count=0 then
    begin
      SetPhase(phEnded,true);
      Game.Winner:=3-Game.Side;
    end else
    begin
      case Partij[Game.Side].Typ of
      1: {computer} Cycles:=100;
      2: {person}
       begin
         Cycles:=50;
         New(EvPers,init(Eval,Game.Side));
       end;
      end;
      Anal.NewEval(Eval,round(300/Cycles));
      Eval^.Levels.Flops:=Cycles div 2;
      OldLevel:=Level;
      SetPhase(phBusy,true);
      SetPhase(phMoveNow,Eval^.Count=1);
    end;
    if CheckRemise then
    begin
      if (Partij[1].typ=2) or (Partij[2].typ=2) then
      begin
        New(Alert,init);
        Alert^.AddLine('^s2^c15^hc^bREMISE?');
        Alert^.AddLine('');
        Alert^.AddButton('Ja, Akkoord');
        Alert^.AddButton('Nee, Doorgaan');
        Alert^.Start;
        Alert^.Scan(Choice);
        Case Choice of
        0: begin
             Game.Winner:=3;
             SetPhase(phEnded,true);
           end;
        1: Remcount:=0;
        end;
        Dispose(Alert,done);
        SetRefr(rfScreen,true);
      end else
      begin
        Game.Winner:=3;
        SetPhase(phEnded,true)
      end;
    end;
  end;

procedure DoEval;
  var Chooser: PChooser;
  begin
    SetPhase(phEvalEnded,false);
    LapTime:=Tijd[Game.Side].GetLap;
    Eval^.Run;
    if GetMode(mdNormal) then Case Partij[Game.Side].Typ of
    1: {computer}
     begin
      {bekijk criteria}
      if Eval^.Finished then SetPhase(phMoveNow,true);
      if GetPhase(phMoveNow) then
      begin
        New(Chooser,init(Eval));
        AMove:=Chooser^.ChooseMove;
        Dispose(Chooser,done);
{        AMove:=Eval^.GetBestMove;}
        SetPhase(phEvalEnded,true);
        DrawDepth:=0;
      end;
     end;
    2: {person}
     begin
      EvPers^.Scan;
      if EvPers^.Result then
      begin
        AMove:=EvPers^.Move;
        SetPhase(phEvalEnded,true);
        DrawDepth:=EvPers^.Depth;
      end;
     end;
    end;
  end;

procedure DoneEval;
  begin
    if Eval<>nil then
    begin
      Dispose(Eval,done);
      Eval:=nil;
    end;
    if EvPers<>nil then
    begin
      Dispose(EvPers,done);
      EvPers:=nil;
    end;
    {tijd}
    Tijd[Game.Side].Halt;
    SetRefr(rfClock,true);
    SetPhase(phBusy,false);
  end;

procedure HandleBack(N: integer);
  var i: byte;
  begin
    if Game.Max>0 then
    begin
      if N>Game.Max then N:=Game.Max;
      Reg^.GetStelling(Game.Max-N,Game.Max,Stelling);
      Game.Max:=Game.Max-N;
      Game.Zet:=Game.Max;
      Game.Side:=(Game.Zet mod 2)+1;
      DoneEval;
      StartEval;
      GMouse.Hide;
      for i:=1 to N do
      begin
        Reg^.DelMove;
        if GetConf(cfReg) then
          Reg^.Draw;
      end;
      TekenStelling(Stelling,Game.Side);
      GMouse.Show;
    end else
    begin
      if GetConf(cfSound) then BeepError;
    end;
  end;

procedure SetNewMode(NewMode: byte);
  var OK: boolean;
      Choice: integer;
      Alert: PAlertBox;
  begin
    OK:=true;
    if GetMode(mdNormal+mdReplay) and (NewMode=mdStelling)
       and (Game.Max>1) then
    begin
      New(Alert,init);
      Alert^.AddLine('^s2^c15^hc^bSTELLING INVOEREN^b');
      Alert^.AddLine('^hc^c14^blet op!^b^c00 Hierdoor wordt het huidige');
      Alert^.AddLine('^hcspel gewist.');
      Alert^.AddLine('');
      Alert^.AddButton('Doorgaan');
      Alert^.AddButton('Spel bewaren');
      Alert^.AddButton('Annuleer');
      Alert^.Start;
      Alert^.Scan(Choice);
      Dispose(Alert,done);
      SetRefr(rfScreen,true);
      Case Choice of
      1: HandleMenuCommand(cmSpSave);
      2: OK:=false;
      end;
    end;
    if (NewMode=mdReplay) and (Game.Max=1) then
    begin
      New(Alert,init);
      Alert^.AddLine('^s2^c15^hc^bNASPELEN^b');
      Alert^.AddLine('Er is geen spel geladen/gespeeld');
      Alert^.AddLine('dat kan worden nagespeeld.');
      Alert^.AddLine('');
      Alert^.AddButton('Spel Laden');
      Alert^.AddButton('Annuleer');
      Alert^.Start;
      Alert^.Scan(Choice);
      Dispose(Alert,done);
      SetRefr(rfScreen,true);
      Case Choice of
      0: HandleMenuCommand(cmSpLoad);
      1: OK:=false;
      end;
    end;
    if (NewMode=mdNormal) and GetMode(mdReplay) and (Game.Zet<Game.Max) then
    begin
      New(Alert,init);
      Alert^.AddLine('^hc^c14^bLet op!^b^c00 Vanaf hier weer verder');
      Alert^.AddLine('^hcspelen betekent dat de rest');
      Alert^.AddLine('^hcvan de partij verloren gaat!');
      Alert^.AddLine('');
      Alert^.AddButton('Doorgaan');
      Alert^.AddButton('Annuleer');
      Alert^.Start;
      Alert^.Scan(Choice);
      Dispose(Alert,done);
      SetRefr(rfScreen,true);
      Case Choice of
      0: begin
          OK:=true;
          Reg^.GetStelling(Game.Max,Game.Zet,Stelling);
          HandleBack(Game.Max-Game.Zet);
         end;
      1: OK:=false;
      end;
    end;
    if OK then
    begin
      if GetMode(mdNormal) and GetPhase(phBusy) then
        Tijd[Game.Side].Halt;
      if (NewMode=mdNormal) and GetPhase(phBusy) then
        if (not GetMode(mdPause)) then
          Tijd[Game.Side].Cont;
      if GetMode(mdStelling) then
      begin
        Dispose(StartStelling,done);
        New(StartStelling,Init(Stelling^.Fields));
        SetPhase(PhStart,true);
      end;
      SetMode(mdNormal+mdReplay+mdStelling,false);
      SetMode(NewMode,true);
      SetPhase(phEnded,false);
      if (NewMode=mdStelling) and GetConf(cfRev) then
      begin
        SetConf(cfRev,false);
        SwitchSides;
      end;
      if OK then SetRefr(rfScreen,true);
    end;
  end;

procedure DisplayHelp(HelpNum: word);
  var Choice: integer;
      Browser: PBrowser;
  begin
    Case HelpNum of
    0: New(Browser,init('GEBRAANW.BTX'));
    1: New(Browser,init('SPELREGS.BTX'));
    end;
    Browser^.Start;
    Browser^.Scan(Choice);
    Dispose(Browser,done);
    SetRefr(rfScreen,true);
  end;

procedure DisplayInfo;
  var Choice: integer;
      Alert: PAlertBox;
  begin
    {$IFDEF Regis}
    New(Alert,init);
    Alert^.AddLine('^hc^c14Welkom bij');
    Alert^.AddLine('^hc^s2^c14^bDAM-PC^b versie '+Version);
    Alert^.AddLine('');
    Alert^.AddLine('^hcDit is de ^c15geregistreerde^c00 versie van DAM-PC '+version);
    Alert^.AddLine('^hcCopyright (c) 1996 N. Haeck');
    Alert^.AddLine(' ');
    Alert^.AddLine('  Gebruiker:        ^c01'+RegName);
    Alert^.AddLine('  Registratienummer: ^c01'+Word2Hex(RegNr));
    Alert^.AddLine(' ');
    Alert^.AddLine('^s0^c14Waarschuwing^c00: Dit computerprogramma is auteursrechtelijk beschermd.');
    Alert^.AddLine('^s0Onrechtmatige verveelvoudiging of distributie van dit programma');
    Alert^.AddLine('^s0of een gedeelte ervan is verboden en strafbaar, en zal met alle');
    Alert^.AddLine('^s0beschikbare juridische middelen worden bestreden.');
    Alert^.AddLine(' ');
    Alert^.AddButton(' OK ');
    Alert^.Start;
    Alert^.Scan(Choice);
    Dispose(Alert,done);
    SetRefr(rfScreen,true);
    {$ELSE}
    DisplayShareInfo(Choice);
    if Choice=0 then
      DisplayHelp(0);
    SetRefr(rfScreen,true);
    {$ENDIF}
  end;

procedure ChangeName(party: byte);
  var I: PInputBox;
      p: string;
      Choice: integer;
  begin
    New(I,init(Partij[party].Name,30,200));
    I^.AddLine('^s2^c15^hc^bNAAM INGEVEN^b');
    I^.AddLine('');
    str(party,p);
    I^.AddLine('Nieuwe naam voor partij '+p+':');
    I^.Start;
    I^.Scan(Choice);
    if Choice=0 then Partij[party].Name:=I^.Default;
    Dispose(I,done);
    SetRefr(rfScreen,true);
  end;

procedure LoadGame(var S: TDosStream);
  var Id: PString;
      Alert: PAlertBox;
      Choice: integer;
  begin
    Id:=S.ReadStr;
    if Id^<>'DAM-PC 2.1 SPEL' then
    begin
      New(Alert,Init);
      Alert^.AddLine('Dit is een ongeldig spelbestand!');
      Alert^.AddLine('(waarschijnlijk van een oudere versie)');
      Alert^.AddButton(' OK ');
      Alert^.Start;
      Alert^.Scan(Choice);
      Dispose(Alert,Done);
    end else
    begin
      if StartStelling<>nil then
        Dispose(StartStelling,done);
      New(StartStelling,Load(S));
      if Stelling<>nil then
        Dispose(Stelling,done);
      New(Stelling,Load(S));
      S.Read(Game,SizeOf(Game));
      Dispose(Reg,done);
      New(Reg,Load(S));
      S.Read(Partij,SizeOf(Partij));
      for x:=1 to 2 do
      begin
        Tijd[x].Init(0,0,0,0,false);
      end;
      Tijd[2].Halt;
      StartEval;
    end;
    DisposeStr(Id);
    S.Done;
    SetNewMode(mdReplay);
  end;

{$IFDEF Regis}
procedure SaveGame(var S: TDosStream);
  var Id: string;
  begin
    Id:='DAM-PC 2.1 SPEL';
    S.WriteStr(@Id);
    StartStelling^.Store(S);
    Stelling^.Store(S);
    S.Write(Game,SizeOf(Game));
    Reg^.Store(S);
    S.Write(Partij,SizeOf(Partij));
    S.Done;
  end;

procedure SaveTXT(var S: TStream);
  var x: integer;
      Params: array[0..3] of Longint;
      zetnum,zetw,zetz: string10;
      Result: string;
  const Format='%3s: %-6s %-6s';
  procedure WL(l: string);
    const Ret: word=$0A0D;
    begin
      S.Write(l[1],Length(l));
      S.Write(Ret,2);
    end;
  begin
    WL('DAM-PC TEXTBESTAND');
    WL('');
    WL('Wit  : '+Partij[1].Name);
    WL('Zwart: '+Partij[2].Name);
    WL('------------------');
    if Game.Descr<>'' then
    begin
      WL('Spelbeschrijving:');
      WL(Game.Descr);
      WL('------------------');
    end;
    WL('Zet: Wit:   Zwart:');
    WL('------------------');
    x:=0;
    while x<Reg^.Count do
    begin
      str((x div 2)+1,zetnum);
      Pointer(Params[0]):=@zetnum;
      zetw:=Reg^.GetItemMoveString(x,1);
      Pointer(Params[1]):=@zetw;
      inc(x);
      zetz:=Reg^.GetItemMoveString(x,2);
      Pointer(Params[2]):=@zetz;
      inc(x);
      FormatStr(Result,Format,Params);
      WL(Result);
    end;
    S.Done;
  end;

procedure SaveBMP(var S: TStream);
  var Bmp: PBmp16;
  begin
    New(Bmp,Init(270,270));
    if Bmp^.Error=0 then
    begin
      Bmp^.SetStart(184,104);
      TekenScherm;
      GMouse.Hide;
      Bmp^.Store(S);
      GMouse.Show;
    end;
    Dispose(Bmp,Done);
    S.Done;
  end;
{$ENDIF}

procedure FinishAlert;
  var Alert: PAlertBox;
      Choice: integer;
  begin
    New(Alert,Init);
    Alert^.AddLine('^hc^s2^c15^bEINDE');
    Alert^.AddLine('');
    Alert^.AddLine('Hiermee be‰indigt U ^c01DAM-PC^c00.');
    Alert^.AddLine('');
    Alert^.AddButton('OK');
    Alert^.AddButton('Annuleren');
    Alert^.Start;
    Alert^.Scan(Choice);
    if Choice=0 then SetPhase(phFinish,true);
    Dispose(Alert,Done);
    SetRefr(rfScreen,true);
  end;

procedure AddGameDescr;
  var I: PInputBox;
      Choice: integer;
  begin
    New(I,init(Game.Descr,60,400));
    I^.AddLine('^s2^hc^c15BESCHRIJVING TOEVOEGEN');
    I^.AddLine('');
    I^.AddLine('Spelbeschrijving:');
    I^.Start;
    I^.Scan(Choice);
    if Choice=0 then
    begin
      Game.Descr:=I^.Default;
    end;
    dispose(I,done);
    SetRefr(rfScreen,true);
  end;

procedure HandleMenuCommand(Choice: integer);
  var
    S: TBufStream;
  begin
    Case Choice of
    cmNiv..cmNiv+6: {stel niveau in}
    begin
      Niveau:=Choice-CmNiv+1;
      if Niveau=7 then Niveau:=100;
      if Eval<>nil then Eval^.Levels.Stop:=Niveau;
    end;
    cmSpLoad:
     begin
       SelectFile('SPEL OPHALEN','Bestandsnaam:',DefFileName,'.SPL',fsLoad,
                  Choice,S);
       If Choice=0 then LoadGame(S);
       SetRefr(rfScreen,true);
     end;
    cmSpSave:
     begin
       {$IFDEF Regis}
       SelectFile('SPEL BEWAREN','Bestandsnaam:',DefFileName,'.SPL',fsSave,
                  Choice,S);
       If Choice=0 then SaveGame(S);
       SetRefr(rfScreen,true);
       {$ELSE}
       ShareWareRemind('Spel Bewaren');
       {$ENDIF}
     end;
    cmSpSvTXT:
     begin
       {$IFDEF Regis}
       SelectFile('SPEL EXPORTEREN','Textbestand:',DefFileName,'.TXT',fsSave,
                  Choice,S);
       If Choice=0 then SaveTXT(S);
       SetRefr(rfScreen,true);
       {$ELSE}
       ShareWareRemind('Spel Exporteren als .TXT');
       {$ENDIF}
     end;
    cmStSvBMP:
     begin
       {$IFDEF Regis}
       SelectFile('STELLING EXPORTEREN','Bitmap-bestand:',DefFileName,'.BMP',fsSave,
                  Choice,S);
       If Choice=0 then SaveBMP(S);
       SetRefr(rfScreen,true);
       {$ELSE}
       ShareWareRemind('Spel Exporteren als .BMP');
       {$ENDIF}
     end;
    cmSpNew:
       SetPhase(phStart,true);
    cmSpNewSt:
     begin
       Dispose(StartStelling,done);
       New(StartStelling,Init(fldStandard));
       SetPhase(phStart,true);
     end;
    cmSpDescr:
     begin
       AddGameDescr;
     end;
    cmMoveNow:
     if (Eval<>nil) and Eval^.MoveFound then
       SetPhase(phMoveNow,true); {nu zetten}
    cmBack: {Zet terug}
     if (Partij[Game.Side].typ=2) and (Game.Max>2) then
       HandleBack(2)
     else
       HandleBack(1);
    cmHint:
       if Eval<>nil then
       begin
         Best:=Eval^.GetBestMove;
         if Best<>nil then
         begin
           MakeMoveList(MoveList,Best);
           TekenMove(MoveList,Game.Side,0);
           RealDelay(1);
           GMouse.Hide;
           TekenStelling(Stelling,Game.Side);
           GMouse.Show;
         end;
       end;
    cmPause:
     begin
       SetMode(mdPause,not GetMode(mdPause));
       SetRefr(rfClock,true);
       if GetMode(mdPause) then
         Tijd[Game.Side].Halt
       else
       begin
         SetRefr(rfScreen,true);
         if GetMode(mdNormal) then
           Tijd[Game.Side].Cont;
       end;
     end;
    cmAnal: {Analyse on/off}
     begin
       SetConf(cfAnal,not GetConf(cfAnal));
       SetRefr(rfScreen,true);
     end;
    cmReg: {Registratie on/off}
     begin
       SetConf(cfReg,not GetConf(cfReg));
       SetRefr(rfScreen,true);
     end;
    cmFNum: {Velden on/off}
     begin
       SetConf(cfFNum,not GetConf(cfFNum));
       SetRefr(rfScreen,true);
     end;
    cmSound: {Geluid on/off}
       SetConf(cfSound,not GetConf(cfSound));
    cmClock: {Klok on/off}
     begin
       SetConf(cfClock,not GetConf(cfClock));
       SetRefr(rfScreen,true);
     end;
    cmStOv: {Steenoverzicht on/off}
     begin
       SetConf(cfStOv,not GetConf(cfStOv));
       SetRefr(rfScreen,true);
     end;
    cmRev: {Omgedraaid on/off}
     if not GetMode(mdStelling) then
     begin
       SetConf(cfRev,not GetConf(cfRev));
       SwitchSides;
       SetRefr(rfScreen,true);
     end;
    cmTNot: {Tijdnotatie on/off}
     begin
       SetConf(cfTNot,not GetConf(cfTNot));
       SetRefr(rfScreen,true);
     end;
    cmMode..cmMode+2:
       Case Choice-cmMode of
       0: SetNewMode(mdNormal);
       1: SetNewMode(mdReplay);
       2: SetNewMode(mdStelling);
       end;
    cmHelp..cmHelp+1:
       DisplayHelp(Choice-cmHelp);
    cmInfo:
       DisplayInfo;
    cmEinde:
       FinishAlert;
    end;
  end;

procedure HandleMenus;
  var OK: boolean;
      Choice: integer;
      x: byte;
  begin
    for x:=1 to 2 do
    begin
      OK:=MP[x].Scan(Choice);
      if OK then
      begin
        Case Choice of
        1,2:
         begin
           if Partij[x].Typ<>Choice then
           begin
             Partij[x].Typ:=Choice;
             Partij[x].Name:=StdNames[Choice];
             if GetPhase(phBusy) then
             begin
               DoneEval;
               StartEval;
             end;
             SetRefr(rfScreen,true);
           end;
         end;
        3: ChangeName(x);
        end;
      end;
    end;
    OK:=Menu.Scan(Choice);
    if OK then
      HandleMenuCommand(Choice);
  end;

procedure AlertGameEnd;
  var Alert: PAlertBox;
      Choice: integer;
      S: String;
  begin
    New(Alert,init);
    Alert^.AddLine('^s2^c15^hc^bSPEL AFGELOPEN ');
    if Game.Winner=3 then
    begin
      Alert^.AddLine('^bPartij 1^b ('+Partij[1].Name+') en ^bPartij 2^b ('+
                     Partij[2].Name+')');
      Alert^.AddLine('zijn ^bremise^b overeengekomen.');
    end else
    begin
      str(Game.winner:1,S);
      Alert^.AddLine('^bPartij '+S+'^b ('+Partij[3-Game.Side].Name+
                     ') heeft gewonnen.');
    end;
    Alert^.AddLine('');
    Alert^.AddLine('^hcWat is Uw Keuze?');
    Alert^.AddButton('Nieuw Spel');
    Alert^.AddButton('Stoppen');
    Alert^.AddButton('Annuleer');
    if GetConf(cfSound) then
      if Game.Winner=3 then
        Alert^.AddMelody(addr(mlWoodPecker))
      else begin
        case Partij[Game.Side].typ of
        1: {computer} Alert^.AddMelody(addr(mlWoodPecker));
        2: {person}   Alert^.AddMelody(addr(mlDodenMars));
        end;
      end;
    Alert^.Start;
    Alert^.Scan(Choice);
    Case Choice of
    0: SetPhase(phStart,true);
    1: HandleMenuCommand(cmEinde);
    end;
    Dispose(Alert,done);
    SetRefr(rfScreen,true);
  end;

procedure DoneVars;
  begin
    Dispose(StartStelling,done);
    if Stelling<>nil then
      Dispose(Stelling,done);
    DoneEval;
    Dispose(Reg,done);
    Reg:=nil;
    Menu.Done;
    MP[1].Done;
    MP[2].Done;
    Replay.Done;
  end;

procedure RefreshScreen;
  begin
    TekenScherm;
    SetRefr(rfScreen,false);
  end;

procedure RefreshClock;
  var x: byte;
  begin
    for x:=1 to 2 do
      Tijd[x].Update;
    if GetConf(cfClock) then
    begin
      for x:=1 to 2 do
      begin
        if Tijd[x].SecChanged or GetRefr(rfClock) then
        begin
          GMouse.Hide;
          TekenTijd(x);
          GMouse.Show;
        end;
      end;
      SetRefr(rfClock,false);
    end;
  end;

procedure RefreshAnal;
  begin
    if GetConf(cfAnal) then
    begin
      Anal.Update;
      if Anal.Changed then
      begin
        GMouse.Hide;
        Anal.DrawUpdate;
        GMouse.Show;
      end;
    end;
  end;

procedure RefreshReg;
  begin
    if GetConf(cfReg) then
    begin
      GMouse.Hide;
      if Reg<>nil then
        Reg^.Draw;
      GMouse.Show;
    end;
  end;

procedure RefreshPause;
  var T: string;
      h,m,s,sh: word;
  begin
    GetTime(h,m,s,sh);
    if s<>PauseSec then
    begin
      PauseSec:=s;
      if odd(PauseSec mod 2) then
        T:=''
      else
        T:='^c11^s2^bPAUZE';
      WriteCbox(@T,585,40,635,55,3);
    end;
  end;

procedure ScanReplay;
  var Result: boolean;
      Choice: integer;
      OldCur: integer;
  begin
    Result:=Replay.ScanOnce(Choice);
    if Result then
    begin
      OldCur:=Reg^.prcur;
      Case Choice of
      0: Reg^.prcur:=0;
      1: Reg^.prcur:=Reg^.prcur-8;
      2: dec(Reg^.prcur);
      3: inc(Reg^.prcur);
      4: Reg^.prcur:=Reg^.prcur+8;
      5: Reg^.prcur:=Reg^.Count;
      end;
      if Reg^.prcur<0 then Reg^.prcur:=0;
      if Reg^.prcur>Reg^.Count then Reg^.prcur:=Reg^.Count;
      if Reg^.prcur<>OldCur then
      begin
        if Choice=3 then
        begin
          MakeMoveList(MoveList,Reg^.Index^[Reg^.PrOld]);
          TekenMove(MoveList,Game.Side,0);
        end;
        Reg^.GetStelling(Reg^.prCur,Game.Zet,Stelling);
        Game.Zet:=Reg^.prCur;
        Game.Side:=(Game.Zet mod 2)+1;
        DoneEval;
        StartEval;
        GMouse.Hide;
        if GetConf(cfReg) then
          Reg^.Draw;
        if Choice<>3 then
          TekenStelling(Stelling,Game.Side);
        GMouse.Show;
      end else
        if UseSound then BeepError;
    end;
  end;

var s: string;
    Tick: word;
    OK: boolean;

begin
  {$IFDEF Regis}
  clrscr;
  DskNr:=PByteArray(@RegInfo)^[40]+$100*PByteArray(@RegInfo)^[41];
  RegNr:=(PByteArray(@RegInfo)^[42]+$100*PByteArray(@RegInfo)^[43]) xor $FFFF;
  RegName:='';
  for x:=0 to 39 do
    RegName:=RegName+chr((PByteArray(@RegInfo)^[x] xor (x+$81)));
  CreateDiskCode(0,DskCd,OK);
  {$ENDIF}
  {$IFDEF Check}
  if not OK or (RegNr<>(DskNr xor DskCd)) then
  begin
    Writeln('Dam-PC is niet juist ge‹nstalleerd.');
    Writeln;
    Writeln('Zie voor meer informatie het hoofdstuk Installatie in de handleiding.');
    Writeln;
    Writeln('Druk op een toets om het programma te stoppen.');
    repeat
    until keypressed;
    Halt(1);
  end;
  {$ENDIF}
  InitGraphics;
  InitVars;
  MakeMenu;
  {$IFNDEF Regis}
  RefreshScreen;
  DisplayInfo;
  {$ENDIF}
  repeat
    ResetKey;
    if GetMode(mdNormal) then
    begin
      if GetMode(mdPause) then RefreshPause;
      if GetPhase(phStart) then
      begin
        DoneEval;
        NewGame;
        StartEval;
        SetPhase(phStart,false);
        SetRefr(rfScreen,true);
      end;
      if GetPhase(phEnded) then
      begin
        DoneEval;
        AlertGameEnd;
        SetPhase(phEnded,false);
      end;
      RefreshClock;
    end;
    if GetRefr(rfScreen) then RefreshScreen;
    if GetPhase(phBusy) and GetMode(mdNormal+mdReplay) and not GetMode(mdPause) then
    begin
      {evaluatie}
      DoEval;
      RefreshAnal;
      if GetPhase(phEvalEnded) and GetMode(mdNormal) then
      begin
        {evaluatie geeindigd}
        MakeMoveList(MoveList,AMove);
        TekenMove(MoveList,Game.Side,DrawDepth);
        Reg^.AddMove(AMove,round(Laptime/100));
        RefreshReg;
        Stelling^.PerformMove(AMove);
        DoneEval;
        RefreshClock;
        {switch}
        inc(Game.Zet);
        Game.Max:=Game.Zet;
        Game.Side:=3-Game.Side;
        Stelling^.Reverse;
        StartEval;
      end;
    end;
    if GetMode(mdStelling) then
      ScanStellingInv;
    if GetMode(mdReplay) then
      ScanReplay;
    {$IFNDEF Regis}
    RefreshReclame;
    {$ENDIF}
    {Menus}
    HandleMenus;
  until GetPhase(phFinish);
  DoneVars;
  CloseGraphics;
end.