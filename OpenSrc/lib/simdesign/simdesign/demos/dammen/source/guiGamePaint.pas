{ unit guiGamePaint

  game painting

  copyright (c) N. Haeck, 1996

}
unit guiGamePaint;

interface

uses
  sdPaintHelper, GameCheck, GameConst;

type
  PField = ^TField;

{ painting routines }

procedure InitTeken;
procedure TekenSteen(Field: byte; Stone: byte);
procedure TekenSteenAbs(ax,ay,bx,by: integer; Stone: byte);
procedure TekenVeld(Field: byte);
procedure TekenDambord;
procedure TekenStelling(Stelling: TField; Side: byte);
procedure SlowMove(xs,ys,xe,ye: integer; Stone: byte);
procedure TekenMove(List: TMoveList; Side: byte; Offset: byte);
procedure TekenKlok(Num: byte);
procedure TekenTijd(Num: byte);
procedure StartSchijfSleep(Steen,Field: byte);
procedure StopSchijfSleep;
procedure UpdateOverz;
//procedure ScanDambord(var Result: boolean; var Field,Btn: byte);
//procedure SwitchSides;
//procedure ScanStellingInv;
procedure TekenStellingInv;
procedure TekenScherm;

implementation

uses
  GameMinimax, DammenConfig;

procedure InitTeken;
begin
  ax:=189; ay:=109; bx:=448; by:=368;
  dx:=(bx-ax+1) div 10;
  dy:=(by-ay+1) div 10;
  Xrad:=round(dx/3);
  Yrad:=round((dy/3)*0.8);
  Ymov:=round((dy/3)*0.3);
  kx[1]:=480; ky[1]:=338+53;
  kx[2]:=480; ky[2]:=109-53;
  mpy[1]:=78; mpy[2]:=381;
  ovy[1]:=285; ovy[2]:=110;
end;

procedure TekenSteen(Field: byte; Stone: byte);
var
  x,y: byte;
begin
  if GetConf(cfRev) then
  begin
    x:=F2X(51-Field);
    y:=9-F2Y(51-Field);
  end else
  begin
    x:=F2X(Field);
    y:=9-F2Y(Field);
  end;
  TekenSteenAbs(ax+dx*x,ay+dy*y,ax+dx*(x+1)-1,ay+dy*(y+1)-1,Stone);
end;

procedure TekenSteenAbs(ax,ay,bx,by: integer; Stone: byte);
var
  Side: byte;
begin
  if Stone < 4 then
    Side := 0
  else
    Side := 2;
  if Stone <> noStone then
  begin
    SetFillStyle(SolidFill, Color[0 + Side]);
    SetColor(Color[0 + Side]);
    FillEllipse((ax + bx) div 2, (ay + by) div 2 + Ymov, XRad, YRad);
    SetFillStyle(SolidFill, Color[1 + Side]);
    SetColor(Color[1 + Side]);
    FillEllipse((ax + bx) div 2,(ay + by) div 2, XRad, YRad);
    Case Stone of
      wd, zd:
      begin
        SetFillStyle(SolidFill, Color[0 + Side]);
        SetColor(Color[0 + Side]);
        FillEllipse((ax + bx) div 2, (ay + by) div 2 - 2, XRad, YRad);
        SetFillStyle(SolidFill, Color[1 + Side]);
        SetColor(Color[1 + Side]);
        FillEllipse((ax + bx) div 2,(ay + by) div 2 - 2 - Ymov, XRad, YRad);
      end;
    end;
  end;
end;

procedure TekenVeld;
var
  x,y: byte;
  N: Utf8String;
begin
  if GetConf(cfRev) then
  begin
    x:=F2X(51-Field);
    y:=9-F2Y(51-Field);
  end else
  begin
    x:=F2X(Field);
    y:=9-F2Y(Field);
  end;
  SetFillStyle(Solidfill,Color[5]);
  DrawBar(ax+dx*x,ay+dy*y,ax+dx*(x+1)-1,ay+dy*(y+1)-1);
  if GetConf(cfFNum) then
  begin
    Str(Field:2,N);
    SetColor(1);
    SetLetter(0);
    WriteText(N,ax+dx*x,ay+dy*y,ax+dx*x+15,ay+dy*y+9,CenterText,CenterText);
    SetLetter(1);
  end;
end;

procedure TekenDambord;
var
  x: byte;
begin
  //bord
  SetFillStyle(SolidFill,Color[4]);
  DrawBar(ax,ay,bx,by);
  //rand
  SetColor(9);
  Rectangle(ax-1,ay-1,bx+1,by+1);
  SetColor(1);
  for x:=2 to 4 do
    Rectangle(ax-x,ay-x,bx+x,by+x);
  SetColor(9);
  Rectangle(ax-5,ay-5,bx+5,by+5);
  if GetConf(cfStOv) or GetMode(mdStelling) then
  begin
    TekenSteenAbs(bx+7,ovy[1],bx+7+dx-1,ovy[1]+dy-1,wn);
    TekenSteenAbs(bx+7,ovy[1]+40,bx+7+dx-1,ovy[1]+40+dy-1,wd);
    TekenSteenAbs(bx+7,ovy[2],bx+7+dx-1,ovy[2]+dy-1,zn);
    TekenSteenAbs(bx+7,ovy[2]+40,bx+7+dx-1,ovy[2]+40+dy-1,zd);
  end;
  UpdateOverz;
end;

procedure UpdateOverz;
var
  S: Utf8String{[2]};
begin
  if GetConf(cfStOv) or (Mode=2) then
  begin
    SetColor(0);
    str(wst:2,S);
    WriteCBox(S,bx+14,ovy[1]+24,bx+27,ovy[1]+36,3);
    str(wdm:2,S);
    WriteCBox(S,bx+14,ovy[1]+64,bx+27,ovy[1]+76,3);
    str(zst:2,S);
    WriteCBox(S,bx+14,ovy[2]+24,bx+27,ovy[2]+36,3);
    str(zdm:2,S);
    WriteCBox(S,bx+14,ovy[2]+64,bx+27,ovy[2]+76,3);
  end;
end;

procedure TekenStelling(Stelling: TField; Side: byte);
var field,stone,x,y: byte;
    TempStl: TField;
begin
  if not assigned(Stelling) then
    exit;
  TempStl := TField.Create(Stelling.Fields);
  if Side=2 then TempStl.Reverse;
  for field:=1 to 50 do
  begin
    TekenVeld(field);
    Stone:=TempStl.GetField(field);
    TekenSteen(Field,Stone);
  end;
  TempStl.Free;
end;

procedure SlowMove;
const
  Steps=5;
var
  stepx,stepy: integer;
  x: byte;
  Block: TDosBlock;
  OK: boolean;
begin
  if GetConf(cfRev) then
  begin
    xs:=9-xs; xe:=9-xe; ys:=9-ys; ye:=9-ye;
  end;
  Block := TDosBlock.Init(dx,dy,OK);
  if OK then
  begin
    stepx:=((xe-xs)*dx) div Steps;
    stepy:=((ye-ys)*dy) div Steps;
    for x:=0 to Steps-1 do
    begin
      Block.Get(ax+dx*xs+stepx*x,ay+dy*ys+stepy*x);
      TekenSteenAbs(ax+dx*xs+stepx*x,ay+dy*ys+stepy*x,
                    ax+dx*(xs+1)-1+stepx*x,ay+dy*(ys+1)-1+Stepy*x,Stone);
      RealDelay(1);
      Block.Put(ax+dx*xs+stepx*x,ay+dy*ys+stepy*x);
    end;
    Block.Free;
  end;
end;

procedure TekenMove;
var
  xs,ys,xe,ye: byte;
  x: integer;
begin
  GMouse.Hide;
  if Side=2 then
  begin
    ReverseMoveList(List);
  end;
  for x:=0 to List.Count-1 do
  begin
    with List.Mv[x] do
    begin
      TekenVeld(Fs);
      if (mt=mtMove) or (mt=mtHit) then
      begin
        if x>=Offset then
        begin
          xs:=F2X(Fs);
          ys:=9-F2Y(Fs);
          xe:=F2X(Fe);
          ye:=9-F2Y(Fe);
          SlowMove(xs,ys,xe,ye,Ts);
          TekenSteen(Fe,Ts);
          if GetConf(cfSound) then BeepOK;
        end;
      end;
      if mt=mtHit then
        TekenVeld(Fh);
      if mt=mtDam then
      begin
        TekenSteen(Fs,Ts*2);
      end;
    end;
  end;
  GMouse.Show;
end;

procedure TekenKlok;
var
  dx,dy: integer;
  x: byte;
begin
  dx:=60; dy:=30;
  SetColor(9);
  Rectangle(kx[num],ky[Num],kx[num]+dx,ky[num]+dy);
  SetColor(1);
  for x:=1 to 2 do
  begin
    Rectangle(kx[num]+x,ky[num]+x,kx[num]+dx-x,ky[num]+dy-x);
  end;
  SetFillStyle(SolidFill,0);
  DrawBar(kx[num]+3,ky[num]+3,kx[num]+dx-3,ky[num]+dy-3);
end;

procedure TekenTijd;
var
  T,S: String;
  hr,mn,sc,sh: word;
  dx,dy: integer;
  // local
  procedure dig2(w: word; var S: string);
  begin
    Str(w,S);
    if length(S)=1 then
      S:='0'+S;
  end;
// main
begin
  dx:=60; dy:=30;
  Tijd[num].Time(hr,mn,sc,sh);
  SetFillStyle(SolidFill,0);
  DrawBar(kx[num]+9,ky[num]+9,kx[num]+dx-9,ky[num]+dy-9);
  dig2(Hr,S);
  T:=S+':';
  dig2(Mn,S);
  T:=T+S+':';
  dig2(Sc,S);
  T:=T+S;
  if Tijd[Num].Halted then
    SetColor(2)
  else
    Setcolor(7);
  WriteText(T,kx[num]+3,ky[num]+3,kx[num]+dx-3,ky[num]+dy-3,
            CenterText,CenterText);
end;

procedure StartSchijfSleep(Steen,Field: byte);
var
  OK: boolean;
  X,Y: integer;
begin
  SchijfSleep:=Steen;
  Schijf := TDosBlock.Init(dx,dy,OK);
  X:=F2X(Field);
  Y:=9-F2Y(Field);
  OldX:=ax+x*dx;
  OldY:=ay+y*dy;
  Schijf.Get(OldX,OldY);
end;

procedure StopSchijfSleep;
begin
  SchijfSleep:=NoStone;
  Schijf.Put(OldX,OldY);
  Schijf.Free;
end;

procedure TekenStellingInv;
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
  end;

procedure TekenScherm;
var MaxX,MaxY: integer;
    S: String;
    x: byte;
begin
  MaxX:=640{GetMaxX}; MaxY:=480{GetMaxY};
  GMouse.Hide;
  setfillstyle(solidfill,3);
  DrawBar(0,0,MaxX,MaxY);
  SetColor(1);
  Rectangle(0,0,MaxX,MaxY);
  Line(0,19,MaxX,19);
  Line(0,35,MaxX,35);
  S:='^hc^vb^b^s2^c15DAM-PC versie '+cVersion;
  WriteCBox(S,1,1,MaxX-1,18,9);
{  Menu.Draw;
  MP[1].Draw;
  MP[2].Draw;}
  if GetMode(mdReplay) then
  begin
    GMouse.Show;
    //Replay.Draw;
    GMouse.Hide;
  end;
{  if Game.Descr<>'' then
  begin
    SetColor(15);
    S:='Spelbeschrijving:';
    WriteCXY(addr(S),6,44,3);
    SetColor(1);
    WriteCXY(addr(Game.Descr),6,62,3);
  end;}
  if GetMode(mdStelling) then
  begin
    S:='^hc^c11^s2^bSTELLING INVOEREN';
    WriteCbox(S,219,50,419,65,3);
    TekenStellingInv;
  end;
  if GetMode(mdPause) then
  begin
    S:='^c11^s2^bPAUZE';
    WriteCbox(S,585,40,635,55,3);
  end;
  SetColor(1);
  Rectangle(183,79,240,95);
  Rectangle(183,382,240,398);
  S:='^vb^b^s2^c00'+Player[2].Name;
  WriteBox(S,250,mpy[1],476,mpy[1]+18);
  S:='^vb^b^s2^c00'+Player[1].Name;
  WriteBox(S,250,mpy[2],476,mpy[2]+18);
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
    S:=Player[1].Name;
    writebox(S,27,81,101,98);
    SetColor(0);
    S:=Player[2].Name;
    writebox(S,102,81,176,98);
{    if Reg<>nil then
    begin
      Reg^.prChanged:=true;
      Reg^.Draw;
    end;}
  end;
  if GetConf(cfAnal) and (not GetMode(mdStelling)) then
  begin
    Minimax.Redraw:=true;
    Minimax.DrawFrame;
  end;
  GMouse.Show;
end;

end.
