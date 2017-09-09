{$G+} {$N+}
unit DamShare;

INTERFACE

uses Crt,Dos,Graph,Drivers,Objects,
     WBasic,Wtp,Wdam,DamEval,BmpIO;

procedure ShareWareMessage;
procedure InitShareWareVars;
procedure RefreshReclame;
procedure DisplayShareInfo(var Choice: integer);
procedure DisplayOrder;
procedure ShareWareRemind(Subject: string);

{Reclame}
const Reclame: array[0..9] of byte=
  (0,4, 36,2, 35,1, 28,2, 31,4);

var rcTimeOut: word;
    rcOldTick: word;
    rcPos: word;
    rcString: string[130];

IMPLEMENTATION

procedure ShareWareMessage; external;
{$L SHAREW.OBJ}

procedure InitShareWareVars;
  begin
    {Reclame}
    rcTimeOut:=4000;
    rcPos:=0;
    rcString[0]:=chr(100);
  end;

procedure RefreshReclame;
  procedure WriteText;
    var xs,i,w: integer;
        ch: char;
        vp: ViewPortType;
    begin
      SetFillStyle(SolidFill,3);
      SetColor(1);
      GMouse.Hide;
      GetViewSettings(vp);
      SetViewPort(2,465,637,477,True);
      xs:=0;
      for i:=1 to 130 do
      begin
        Ch:=rcString[i];
        w:=TextWidth(Ch);
        DrawBar(xs,0,xs+w-1,12);
        OutTextXY(xs,TextVsc,Ch);
        xs:=xs+w;
      end;
      SetViewPort(vp.x1,vp.y1,vp.x2,vp.y2,vp.Clip);
      GMouse.Show;
    end;
  begin
    if GetTick<>rcOldTick then
    begin
      rcOldTick:=GetTick;
      if rcTimeOut>0 then
         dec(rcTimeOut)
      else begin
        Move(PByteArray(@ShareWareMessage)^[rcPos],rcString[1],130);
        if rcPos=0 then if UseSound then Melody(@Reclame);
        WriteText;
        rcTimeOut:=1;
        inc(rcPos);
        if rcPos>1406-130-1 then
        begin
          rcTimeOut:=random(20000);
          rcPos:=0;
        end;
      end;
    end;
  end;

procedure DisplayShareInfo(var Choice: integer);
  var Alert: PAlertBox;
  begin
    New(Alert,init);
    Alert^.AddLine('^hc^c14Welkom bij');
    Alert^.AddLine('^hc^s2^c14^bDAM-PC^b shareware-versie '+Version);
    Alert^.AddLine(' ');
    Alert^.AddLine('Deze shareware-versie wordt verspreid voor');
    Alert^.AddLine('geinteresseerden en dam-liefhebbers. ');
    Alert^.AddLine(' ');
    Alert^.AddLine('U mag dit programma 30 dagen op proef gebruiken.');
    Alert^.AddLine('Als U dit programma na die tijd wilt blijven gebruiken,');
    Alert^.AddLine('moet u zich laten registreren.');
    Alert^.AddLine('Kies knop ^c01[Registreer!]^c00 voor meer informatie.');
    Alert^.AddLine(' ');
    Alert^.AddLine('Als u ^c14^bDAM-PC^b^c00 niet kent, is het verstandig');
    Alert^.AddLine('eerst de gebruiksaanwijzing te lezen: kies de knop');
    Alert^.AddLine('^hc^b[ HELP! ]');
    Alert^.AddLine(' ');
    Alert^.AddLine('Voor reakties en/of opbouwende kritiek kunt u schrijven ');
    Alert^.AddLine('naar de auteur: ');
    Alert^.AddLine(' ');
    Alert^.AddLine('   ^c01N. Haeck ');
    Alert^.AddLine('   ^c01E. Dorusstraat 40 ');
    Alert^.AddLine('   ^c012613 EE DELFT ');
    Alert^.AddLine(' ');
    Alert^.AddLine('(u kunt ook reakties posten op TeleRUN BBS)');
    Alert^.AddLine(' ');
    Alert^.AddButton(' HELP! ');
    Alert^.AddButton('^c01Registreer!');
    Alert^.AddButton('OK');
    Alert^.Start;
    Alert^.Scan(Choice);
    Dispose(Alert,done);
    if Choice=1 then
      DisplayOrder;
    SetRefr(rfScreen,true);
  end;

procedure DisplayOrder;
  var Alert: PAlertBox;
      Choice: integer;
  begin
    New(Alert,init);
    Alert^.AddLine('^hc^s2^c01REGISTREER ^c15DAM-PC '+version+' ^c01NU!');
    Alert^.AddLine('');
    Alert^.AddLine('U kunt zich laten registreren door Ÿ 79,95 over te maken op');
    Alert^.AddLine('  ^c01giro  5183025');
    Alert^.AddLine('  ^c01t.n.v. N. Haeck');
    Alert^.AddLine('  ^c01      E. Dorusstraat 40');
    Alert^.AddLine('  ^c01      2613 EE DELFT');
    Alert^.AddLine('onder vermelding van ^c15''DAMPROGRAMMA''^c00 en Uw ^c15naam^c00 en ^c15adres.');
    Alert^.AddLine('');
    Alert^.AddLine('U ontvangt dan (binnen 10 werkdagen):');
    Alert^.AddLine('- De geregistreerde versie van Dam-PC (op 3.5'''' floppy), met:');
    Alert^.AddLine('  - Menuoptie Spel.. Bewaren');
    Alert^.AddLine('  - Menuoptie Spel.. Export als .TXT');
    Alert^.AddLine('  - Menuoptie Spel.. Export als .BMP');
    Alert^.AddLine('- Tientallen voorbeeldproblemen met oplossing.');
    Alert^.AddLine('- Een handleiding met volledige beschrijving van de mogelijkheden');
    Alert^.AddLine('  van Dam-PC, inclusief een aantal voorbeelden.');
    Alert^.AddLine('- Telefonische support.');
    Alert^.AddLine('');
    Alert^.AddButton('  OK  ');
    Alert^.Start;
    Alert^.Scan(Choice);
    SetRefr(rfScreen,true);
    Dispose(Alert,Done);
  end;

procedure ShareWareRemind(Subject: string);
  var Alert: PAlertBox;
      Choice: integer;
  begin
    New(Alert,init);
    Alert^.AddLine('^hcIn deze shareware-versie is de menuoptie');
    Alert^.AddLine('^hc^c15^s2'+Subject);
    Alert^.AddLine('^hcniet uitvoerbaar.');
    Alert^.AddLine('');
    Alert^.AddLine('Kies voor meer informate de knop ^c01[Registreer!]');
    Alert^.AddButton('OK');
    Alert^.AddButton('^c01Registreer!');
    Alert^.Start;
    Alert^.Scan(Choice);
    Dispose(Alert,Done);
    SetRefr(rfScreen,true);
    if Choice=1 then DisplayOrder;
  end;

end.