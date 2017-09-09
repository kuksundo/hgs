{$G+} {$N+}
unit Wtp;

INTERFACE

uses Dos,Mouse,WBasic,Objects;

procedure EgaVgaDriverProc;
procedure SmallFontProc;

{Mouse}
var GMouse: GraphicMouse;
    TMouse: TextMouse;

{Sound}
const
  UseSound: boolean=true;

{Blocks}
type PBlock = ^TBlock;
     TBlock = object
       SizeX,SizeY: integer;
       MemSize: word;
       Data: pointer;
       constructor Init(ASizeX,ASizeY: integer; var OK: boolean);
       procedure Get(StartX,StartY: integer);
       procedure Put(StartX,StartY: integer);
       destructor Done;
     end;

{string types}
type String30=String[30];
     String10=String[10];

{PullDown Menu}
const CMnuBgr=7;
      CMnuFgr=0;
      CMnuIdl=15;
      CMnuHgl=2;
      CMnuBdr=8;

const TNoType=0;
      TRadOff=1;
      TRadOn =2;
      TBoxOff=3;
      TBoxOn =4;

type TGetFlag=function(Id: byte): boolean;

type PSubItem=^TSubItem;
     TSubItem=object(TObject)
       R: PRect;
       Name: String30;
       ID: integer;
       Typ: integer;
       Hgl: boolean;
       Act: boolean;
       GetFlag: pointer;
       FlagId: byte;
       constructor Init(AName: String30; AnID: integer; ATyp: integer; IsAct: boolean);
       procedure Draw(TypOn: boolean);
       destructor Done; virtual;
     end;

type PMenuItem=^TMenuItem;
     TMenuItem=object(TCollection)
       R: PRect;
       Name: String30;
       ID: integer;
       Hgl: boolean;
       Exp: boolean;
       TypOn: boolean;
       ExpR: PRect;
       Block: PBlock;
       constructor Init(AName: String30; AnId: integer; ax,ay,bx,by: integer);
       procedure AddSubItem(AName: String30; AnID: integer; ATyp: integer; IsAct: boolean);
       procedure Expose;
       procedure Fold;
       procedure Draw;
       function  Scan(var Choice: integer): boolean;
       destructor Done; virtual;
     end;

type PMenu=^TMenu;
     TMenu=object(TCollection)
       R: PRect;
       MaxW: integer;
       constructor Init(ax,ay,bx: integer);
       procedure AddMenuItem(AName: String30; AnId: integer);
       procedure AddSubItem(AName: String30; AnID: integer; ATyp: integer; IsAct: boolean);
       function GetLastSub: PSubItem;
       procedure Draw;
       function  Scan(var Choice: integer): boolean;
       destructor Done; virtual;
     end;

{Buttons}
type PButton=^TButton;
     TButton=object(TObject)
       R: PRect;
       Name: String30;
       constructor Init(ax,ay,bx,by: integer; AName: String30);
       procedure Draw(Default: boolean);
       function Scan: boolean;
       procedure GetSize(var Width,Height: integer);
       destructor Done; virtual;
     end;

{inputline}
type PInputLine=^TInputLine;
     TInputLine=object(TObject)
       R: PRect;
       Data: PString;
       MaxLen, CurPos: integer;
       constructor Init(ax,ay,bx: integer; AMaxLen: integer);
       destructor Done; virtual;
       procedure Draw;
       procedure Scan(var Choice: integer);
     end;

{Klok}
type PClock=^TClock;
     TClock=object
       Timer: real;
       OldT: real;
       Lap: real;
       CountBack: boolean;
       Halted: boolean;
       OldSec: word;
       Changed: boolean;
       constructor Init(hr,mn,sc,sh: word; IsCountBack: boolean);
       procedure Reset(hr,mn,sc,sh: word);
       procedure Update;
       procedure Halt;
       procedure Cont;
       procedure Time(var hour,min,sec,s100: word);
       function  SecChanged: boolean;
       procedure StartLap;
       function  GetLap: real;
     end;

var OldTick: word;
procedure Tc2Time(Tc: real; var hour,min,sec,s100: word);
procedure Time2Tc(hour,min,sec,s100: word; var Tc: real);
function GetTick: word;
procedure WaitForTick;
procedure RealDelay(MSec: word); {delay time in 1/20 seconden}

{Grafische routines}
procedure InitGraphics;
procedure CloseGraphics;

procedure DrawBar(AX,AY,BX,BY: integer);
procedure DrawSymbol(ax,ay,symbol: integer);

{Text}
var Letter,TextHgt,TextVsc: integer;

const ltSmall =0;
      ltMedium=1;
      ltLarge =2;

procedure SetLetter(Size: byte);
procedure WriteText(Text: PString; ax,ay,bx,by: integer;
                    HJustify, VJustify: byte);

procedure GetTextCommand(S: PString; var Pos,Com,Par: byte);
procedure GetTextSize(S: PString; var Width,Height: integer);
procedure WriteXY(S: PString; X,Y: integer);
procedure WriteCXY(S: PString; X,Y: integer; Col: byte);
procedure WriteBox(S: PString; ax,ay,bx,by: integer);
procedure WriteCBox(S: PString; ax,ay,bx,by: integer; col: byte);

type PTextGroup=^TTextGroup;
     TTextGroup=object(TCollection)
       LineDist: byte;
       constructor Init;
       procedure AddLine(S: PString);
       procedure GetSize(var Width,Height: integer);
       procedure WriteGroupBox(ax,ay,bx,by: integer);
       destructor Done; virtual;
     end;

{AlertBox}
type PAlertBox=^TAlertBox;
     TAlertBox=object(TCollection)
       R: PRect;
       G: PTextGroup;
       Mel: PByteArray;
       Default: byte;
       BW,BH: integer;
       constructor Init;
       procedure AddLine(S: String);
       procedure AddButton(Name: String30);
       procedure AddMelody(AMel: PByteArray);
       procedure Draw;
       procedure GetButtonSize;
       procedure PlaceButtons;
       procedure Start; virtual;
       function ScanOnce(var Choice: integer): boolean; virtual;
       procedure Scan(var Choice: integer); virtual;
       destructor Done; virtual;
     end;

type PInputBox=^TInputBox;
     TInputBox=object(TObject)
       R: PRect;
       G: PTextGroup;
       Default: string;
       PixW: integer;
       InputLine: PInputLine;
       constructor Init(ADefault: string; MaxLen,APixW: integer);
       destructor Done; virtual;
       procedure AddLine(S: String);
       procedure Draw;
       procedure Scan(var Choice: integer);
       procedure Start;
     end;

type PBrowser=^TBrowser;
     TBrowser=object(TAlertBox)
       BrFile: PDosstream;
       PageStart: array[1..100] of word;
       PageEnd:   array[1..100] of word;
       MaxPage,CurPage: integer;
       FileError: boolean;
       constructor Init(AFileName: string);
       procedure NewPage;
       procedure Start; virtual;
       procedure Scan(var Choice: integer); virtual;
       destructor Done; virtual;
     end;

{Geluid}
const mlDodenMars: array[0..23] of byte=
  (0,11, 12,4, 12,3, 12,1, 12,4, 15,3, 14,1, 14,3, 12,1, 12,3, 11,1,
         12,8);

const mlWoodPecker: array[0..41] of byte=
  (0,20, 12,1, 14,1, 15,1, 19,2, 22,1, 19,2, 15,1, 19,2, 22,1, 19,2,
          0,1, 20,1, 22,1, 20,1, 17,2,  0,1, 19,1, 22,1, 19,1, 15,3);

procedure BeepOK;
procedure BeepError;
procedure Melody(M: PByteArray);

{Input}
const kbNoKey  =$0000;
      kbNoInput=$FFFF;
      kbF10    =$0144;
      kbUp     =$0148; kbDown =$0150; kbLeft =$014B; kbRight=$014D;
      kbEnter  =$000D;
      kbEsc    =$001B;
      kbTab    =$0009;
      kbDel    =$0153;
      kbBacksp =$0008;
      kbHome   =$0147;
      kbEnd    =$014F;

var KeyIn: word;

procedure GetKeyInput;
function  FoundKey(Key: word): boolean;
procedure ResetKey;

{File selection}

const
  fsLoad=$01;
  fsSave=$02;

procedure SelectFile(Title,Message: string; var DefFileName: string; Ext: ExtStr;
           Options: byte; var Choice: integer; var S: TBufStream);

{Errors}
procedure HandleError(ErrNum: integer);

IMPLEMENTATION

uses Crt,Graph;

procedure SmallFontProc; external;
{$L LITT.OBJ }

procedure EgaVgaDriverProc; external;
{$L EGAVGA.OBJ }

{Block}
constructor TBlock.Init;
  begin
    SizeX:=ASizeX; SizeY:=ASizeY;
    MemSize:=ImageSize(0,0,SizeX-1,SizeY-1);
    if MaxAvail>MemSize then
    begin
      GetMem(Data,MemSize);
      OK:=true;
    end else
    begin
      Data:=nil;
      OK:=false;
    end;
  end;

procedure TBlock.Get;
  begin
    if Data<>nil then
      GetImage(StartX,StartY,StartX+SizeX-1,StartY+SizeY-1,Data^);
  end;

procedure TBlock.Put;
  begin
    if Data<>nil then
      PutImage(StartX,StartY,Data^,CopyPut);
  end;

destructor TBlock.Done;
  begin
    if Data<>nil then
      FreeMem(Data,MemSize);
  end;

{Pulldown Menu}

constructor TSubItem.Init;
  begin
    TObject.Init;
    Name:=AName;
    ID:=AnId;
    Typ:=ATyp;
    Hgl:=false;
    Act:=IsAct;
    New(R,init(0,0,0,0));
  end;

procedure TSubItem.Draw;
  var Flag: boolean;
  begin
    if Hgl then
      SetFillStyle(SolidFill,CMnuHgl)
    else
      SetFillStyle(SolidFill,CMnuBgr);
    DrawBar(R^.A.X,R^.A.Y,R^.B.X,R^.B.Y);
    if Act then
      SetColor(CMnuFgr)
    else
      SetColor(CMnuIdl);
    Flag:=false;
    if GetFlag<>nil then
      Flag:=TGetFlag(GetFlag)(FlagId);
    if TypOn then
    begin
      if Flag then
        DrawSymbol(R^.A.X+1,R^.A.Y+1,Typ+1)
      else
        DrawSymbol(R^.A.X+1,R^.A.Y+1,Typ);
      WriteText(addr(Name),R^.A.X+13,R^.A.Y,R^.B.X,R^.B.Y,LeftText,CenterText);
    end else
      WriteText(addr(Name),R^.A.X+1,R^.A.Y,R^.B.X,R^.B.Y,LeftText,CenterText);
  end;

destructor TSubItem.Done;
  begin
    Dispose(R,done);
    TObject.Done;
  end;

constructor TMenuItem.Init;
  begin
    TCollection.Init(3,3);
    Name:=AName;
    ID:=AnId;
    New(R,init(ax,ay,bx,by));
    Hgl:=false;
    New(ExpR,init(0,0,0,0));
    Exp:=false;
  end;

procedure TMenuItem.AddSubItem;
  var S: PSubItem;
  begin
    New(S,init(AName,AnId,ATyp,IsAct));
    Insert(S);
  end;

procedure TMenuItem.Expose;
  var MaxW,SubW,H,dy: integer;
      x: byte;
      OK: boolean;
  begin
    if Count>0 then
    begin
      MaxW:=0;
      H:=0;
      TypOn:=false;
      dy:=TextHgt+2;
      for x:=0 to Count-1 do
      begin
        SubW:=TextWidth(PSubItem(At(x))^.Name)+2;
        if SubW>MaxW then MaxW:=SubW;
        H:=H+dy;
        if PSubItem(At(x))^.Typ<>TNoType then TypOn:=true;
      end;
      ExpR^.A.X:=0; ExpR^.A.Y:=0;
      if TypOn then
        ExpR^.B.X:=MaxW+2+12
      else
        ExpR^.B.X:=MaxW+2;
      ExpR^.B.Y:=H+1;
      ExpR^.Drag(R^.A.X,R^.B.Y+1);
      for x:=0 to Count-1 do
      begin
        PSubItem(At(x))^.R^.A.X:=ExpR^.A.X+1;
        PSubItem(At(x))^.R^.A.Y:=ExpR^.A.Y+x*dy+1;
        PSubItem(At(x))^.R^.B.X:=ExpR^.B.X-1;
        PSubItem(At(x))^.R^.B.Y:=ExpR^.A.Y+(x+1)*dy;
        PSubItem(At(x))^.Hgl:=false;
      end;
      {sla onderl. info op}
      New(Block,Init(ExpR^.B.X-ExpR^.A.X+1,ExpR^.B.Y-ExpR^.A.Y+1,OK));
      if not OK then
        HandleError(1);
      Block^.Get(ExpR^.A.X,ExpR^.A.Y);
      {draw it}
      SetColor(CMnuBdr);
      Rectangle(ExpR^.A.X,ExpR^.A.Y,ExpR^.B.X,ExpR^.B.Y);
      for x:=0 to Count-1 do
        PSubItem(At(x))^.Draw(TypOn);
      Exp:=true;
    end;
  end;

procedure TMenuItem.Fold;
  begin
    if Exp=true then
    begin
      Block^.Put(ExpR^.A.X,ExpR^.A.Y);
      Dispose(Block,done);
    end;
    Exp:=false;
  end;

procedure TMenuItem.Draw;
  begin
    if Hgl then
      SetFillStyle(SolidFill,CMnuHgl)
    else
      SetFillStyle(SolidFill,CMnuBgr);
    DrawBar(R^.A.X,R^.A.Y,R^.B.X,R^.B.Y);
    SetColor(CMnuFgr);
    WriteText(addr(Name),R^.A.X,R^.A.Y,R^.B.X,R^.B.Y,CenterText,CenterText);
  end;

function TMenuItem.Scan;
  var Result,fin,pressed,go: boolean;
      BtnStatus,Cur,x: integer;
      Pos: TPoint;
  begin
    Result:=false;
    Choice:=0;
    fin:=false;
    pressed:=false;
    if Count=0 then
    begin
      repeat
        GMouse.GetPosition(BtnStatus,Pos.X,Pos.Y);
        if not R^.HasPoint(addr(Pos)) then fin:=true;
        if BtnStatus=1 then pressed:=true;
        if (BtnStatus=0) and pressed then
        begin
          Choice:=ID;
          Result:=true;
          fin:=true;
        end;
      until fin;
    end else
    begin
      cur:=-1;
      repeat
        GMouse.GetPosition(BtnStatus,Pos.X,Pos.Y);
        for x:=0 to Count-1 do
        begin
          if PSubItem(At(x))^.R^.HasPoint(addr(Pos)) then
          begin
            if BtnStatus=1 then pressed:=true;
            if Cur<>x then
            begin
              GMouse.Hide;
              if Cur>-1 then
              begin
                PSubItem(At(Cur))^.Hgl:=false;
                PSubItem(At(Cur))^.Draw(TypOn);
              end;
              Cur:=x;
              if PSubItem(At(Cur))^.Act then
              begin
                PSubItem(At(Cur))^.Hgl:=true;
                PSubItem(At(Cur))^.Draw(TypOn);
              end;
              GMouse.Show;
            end;
            if (BtnStatus=0) and pressed then
            begin
              if PSubItem(At(Cur))^.Act then
              begin
                Choice:=PSubItem(At(Cur))^.ID;
                Result:=true;
              end;
              Fin:=true;
            end;
          end;
        end;
        if (not ExpR^.HasPoint(addr(Pos))) and (not R^.HasPoint(addr(Pos))) then
        begin
          if Cur>-1 then
          begin
            GMouse.Hide;
            PSubItem(At(Cur))^.Hgl:=false;
            PSubItem(At(Cur))^.Draw(TypOn);
            GMouse.Show;
          end;
          fin:=true;
        end;
      until fin;
    end;
    Scan:=Result;
  end;

destructor TMenuItem.Done;
  var x: byte;
  begin
    if Exp then Dispose(Block,done);
    Dispose(ExpR,done);
    Dispose(R,done);
    TCollection.Done;
  end;

constructor TMenu.Init;
  begin
    TCollection.Init(3,3);
    New(R,init(ax,ay,bx,ay+TextHgt+1));
    MaxW:=-1;
  end;

procedure TMenu.AddMenuItem;
  var ItemW: integer;
  begin
    ItemW:=TextWidth(AName)+10;
    Insert(New(PMenuItem,init(AName,AnId,R^.A.X+MaxW+1,R^.A.Y,R^.A.X+MaxW+ItemW,R^.B.Y)));
    MaxW:=MaxW+ItemW;
  end;

procedure TMenu.AddSubItem;
  begin
    if Count>0 then
      PMenuItem(At(Count-1))^.AddSubItem(AName,AnID,ATyp,IsAct);
  end;

function TMenu.GetLastSub;
  var LastMI: PMenuItem;
  begin
    LastMI:=At(Count-1);
    GetLastSub:=LastMI^.At(LastMI^.Count-1);
  end;

procedure TMenu.Draw;
  var x: byte;
  begin
    for x:=0 to Count-1 do
      PMenuItem(At(x))^.Draw;
    SetFillStyle(SolidFill,CMnuBgr);
    DrawBar(R^.A.X+MaxW+1,R^.A.Y,R^.B.X,R^.B.Y);
  end;

function TMenu.Scan;
  var Result: boolean;
      BtnStatus,x,cur: integer;
      Pos: TPoint;
      fin: boolean;
  begin
    Choice:=0;
    Result:=false;
    GMouse.GetPosition(BtnStatus,Pos.X,Pos.Y);
    if R^.HasPoint(addr(Pos)) then
    begin
      fin:=false;
      cur:=-1;
      repeat
        GMouse.GetPosition(BtnStatus,Pos.X,Pos.Y);
        for x:=0 to Count-1 do
        begin
          if PMenuItem(At(x))^.R^.HasPoint(addr(Pos)) then
          begin
            if Cur<>x then
            begin
              GMouse.Hide;
              if Cur>-1 then
              begin
                PMenuItem(At(Cur))^.Fold;
                PMenuItem(At(Cur))^.Hgl:=false;
                PMenuItem(At(Cur))^.Draw;
              end;
              Cur:=x;
              PMenuItem(At(Cur))^.Expose;
              PMenuItem(At(Cur))^.Hgl:=true;
              PMenuItem(At(Cur))^.Draw;
              GMouse.Show;
              Result:=PMenuItem(At(Cur))^.Scan(Choice);
              if Result then
              begin
                Fin:=true;
                GMouse.Hide;
                PMenuItem(At(Cur))^.Fold;
                PMenuItem(At(Cur))^.Hgl:=false;
                PMenuItem(At(Cur))^.Draw;
                GMouse.Show;
              end;
            end;
          end;
        end;
        if not R^.HasPoint(addr(Pos)) then
        begin
          if Cur>-1 then
          begin
            GMouse.Hide;
            PMenuItem(At(Cur))^.Fold;
            PMenuItem(At(Cur))^.Hgl:=false;
            PMenuItem(At(Cur))^.Draw;
            GMouse.Show;
          end;
          fin:=true;
        end;
      until fin;
    end;
    Scan:=Result;
  end;

destructor TMenu.Done;
  var x: byte;
  begin
    Dispose(R,done);
    TCollection.Done;
  end;

{buttons}
constructor TButton.Init;
  begin
    TObject.Init;
    New(R,init(ax,ay,bx,by));
    Name:='^hc^vc'+AName;
  end;

procedure TButton.Draw;
  var S: string30;
  begin
    if Default then
      SetColor(0)
    else
      SetColor(8);
    Rectangle(R^.a.x,R^.a.y,R^.b.x,R^.b.y);
    if Default then
      S:='^b'+Name
    else
      S:=Name;
    WriteCBox(addr(S),R^.a.x+1,R^.a.y+1,R^.b.x-1,R^.b.y-1,3);
  end;

function TButton.Scan;
  var Result: boolean;
      BtnStatus: integer;
      Pos: TPoint;
  begin
    Result:=false;
    GMouse.GetPosition(BtnStatus,Pos.X,Pos.Y);
    if R^.HasPoint(addr(Pos)) then
    begin
      if BtnStatus=1 then
      begin
        Result:=true;
        repeat
          GMouse.GetPosition(BtnStatus,Pos.X,Pos.Y);
        until BtnStatus=0;
      end;
    end;
    Scan:=Result;
  end;

procedure TButton.GetSize;
  begin
    GetTextSize(addr(Name),Width,Height);
    Width:=Width+12;
    Height:=Height+3;
  end;

destructor TButton.Done;
  begin
    Dispose(R,done);
    TObject.Done;
  end;

constructor TInputLine.Init;
  begin
    TObject.Init;
    New(R,init(ax,ay,bx,ay+TextHgt+6));
    MaxLen:=AMaxLen;
    GetMem(Data,MaxLen+1);
    Data^[0]:=chr(0);
    CurPos:=1;
  end;

destructor TInputLine.Done;
  begin
    Dispose(R,done);
    FreeMem(Data,MaxLen+1);
    TObject.Done;
  end;

procedure TInputLine.Draw;
  var Pass: string;
      CurX,H: integer;
  begin
    SetFillStyle(SolidFill,3);
    DrawBar(R^.a.x,R^.a.y,R^.b.x,R^.b.y);
    Pass:=copy(Data^,1,CurPos-1);
    GetTextSize(@Pass,CurX,H);
    CurX:=CurX+3+R^.a.x;
    SetColor(9);
    if CurX<=R^.b.x-3 then
      line(CurX,R^.a.y+1,CurX,R^.b.y-3);
    SetColor(0);
    WriteBox(Data,R^.a.x+3,R^.a.y+3,R^.b.x-3,R^.b.y-3);
  end;

procedure TInputLine.Scan;
  procedure Redraw;
    begin
      GMouse.Hide;
      Draw;
      GMouse.Show;
    end;
  var result: boolean;
  begin
    Result:=false;
    repeat
      GetKeyInput;
      if KeyIn<>KbNoInput then
      begin
        Case KeyIn of
        kbRight:
         if CurPos<=Length(Data^) then
         begin
           inc(CurPos);
           Redraw;
         end;
        kbLeft:
         if CurPos>1 then
         begin
           dec(CurPos);
           Redraw;
         end;
        kbDel:
         if CurPos<=Length(Data^) then
         begin
           Delete(Data^,CurPos,1);
           Redraw;
         end;
        kbBacksp:
          if CurPos>1 then
          begin
            Delete(Data^,CurPos-1,1);
            dec(CurPos);
            Redraw;
          end;
        kbHome:
          if CurPos<>1 then
          begin
            CurPos:=1;
            Redraw;
          end;
        kbEnd:
          if CurPos<>Length(Data^)+1 then
          begin
            CurPos:=Length(Data^)+1;
            Redraw;
          end;
        kbEnter:
         begin
           Choice:=0;
           Result:=true;
         end;
        kbEsc:
         begin
           Choice:=1;
           Result:=true;
         end;
        $0020..$00FE:
         if Length(Data^)<MaxLen then
         begin
           insert(chr(lo(KeyIn)),Data^,CurPos);
           inc(CurPos);
           Redraw;
         end;
        end;
        ResetKey;
      end;
    until Result;
  end;

{Alertbox}
constructor TAlertBox.Init;
  begin
    TCollection.Init(3,3);
    New(G,init);
    New(R,init(0,0,0,0));
  end;

procedure TAlertBox.AddLine;
  begin
    G^.AddLine(addr(S));
  end;

procedure TAlertBox.AddButton;
  begin
    Insert(New(PButton,init(0,0,0,0,Name)));
  end;

procedure TAlertBox.AddMelody;
  begin
    Mel:=AMel;
  end;

procedure TAlertBox.Draw;
  var x: integer;
  begin
    GMouse.Hide;
    SetColor(0);
    Rectangle(R^.a.x,R^.a.y,R^.b.x,R^.b.y);
    SetFillStyle(SolidFill,7);
    DrawBar(R^.a.x+1,R^.a.y+1,R^.b.x-1,R^.b.y-1);
    G^.WriteGroupBox(R^.a.x+5,R^.a.y+5,R^.b.x-5,R^.b.y-BH-10);
    for x:=0 to Count-1 do
      if x=default then
        PButton(At(x))^.Draw(True)
      else
        PButton(At(x))^.Draw(False);
    if (Mel<>nil) and UseSound then
      Melody(Mel);
    GMouse.Show;
  end;

procedure TAlertBox.GetButtonSize;
  var W,H,x: integer;
  begin
    for x:=0 to Count-1 do
    begin
      PButton(At(x))^.GetSize(W,H);
      BW:=intmax(W,BW);
      BH:=intmax(H,BH);
    end;
  end;

procedure TAlertBox.PlaceButtons;
  var Width,dBW,x: integer;
  begin
    Width:=R^.b.x-R^.a.x+1;
    dBW:=(Width-Count*BW) div (Count+1);
    for x:=0 to Count-1 do
      PButton(At(x))^.R^.setbounds(R^.A.X+dBW*(x+1)+x*BW,R^.B.Y-BH-5,
                                   R^.A.X+(x+1)*(dBW+BW),R^.B.Y-5);
  end;

procedure TAlertBox.Start;
  var Width,Height,W,H,ax,ay: integer;
      x: byte;
  begin
    G^.GetSize(W,H);
    Width:=W;
    Height:=H;
    GetButtonSize;
    if Count>0 then
      W:=Count*BW+(Count-1)*5
    else
      W:=0;
    Width:=intmax(Width,W)+10;
    Height:=Height+BH+10;
    ax:=(GetMaxX-Width) div 2;
    ay:=(GetMaxY-Height) div 2;
    R^.setbounds(ax,ay,ax+Width-1,ay+Height-1);
    PlaceButtons;
    Draw;
  end;

function TAlertBox.ScanOnce(var Choice: integer): boolean;
  var Result,Btn: boolean;
      x: byte;
  begin
    Result:=false;
    for x:=0 to Count-1 do
    begin
      Btn:=PButton(At(x))^.Scan;
      if Btn then
      begin
        Choice:=x;
        Result:=true;
        if UseSound then
          BeepOK;
      end;
    end;
    GetKeyInput;
    if FoundKey(kbEnter) then
    begin
      Choice:=Default;
      Result:=true;
      if UseSound then
        BeepOK;
    end;
    if FoundKey(kbTab) then
    begin
      inc(Default);
      if Default>=Count then Default:=0;
      for x:=0 to Count-1 do
       if x=default then
         PButton(At(x))^.Draw(True)
       else
         PButton(At(x))^.Draw(False);
    end;
    ScanOnce:=Result;
  end;

procedure TAlertBox.Scan;
  var Result,Btn: boolean;
      BtnStatus: integer;
      Pos: TPoint;
  begin
    repeat
      Result:=ScanOnce(Choice);
      GMouse.GetPosition(BtnStatus,Pos.X,Pos.Y);
      if BtnStatus=1 then
        if not R^.HasPoint(addr(Pos)) then
          if UseSound then
          begin
            BeepError;
            repeat
              GMouse.GetPosition(BtnStatus,Pos.X,Pos.Y);
            until BtnStatus=0;
          end;
    until Result=true;
  end;

destructor TAlertBox.Done;
  var x: byte;
  begin
    Dispose(G,done);
    Dispose(R,done);
    TCollection.Done;
  end;

{Inputbox}
constructor TInputBox.Init;
  begin
    TObject.Init;
    New(G,init);
    New(R,init(0,0,0,0));
    Default:=Copy(ADefault,1,MaxLen);
    PixW:=APixW;
    New(InputLine,init(0,0,0,MaxLen));
    InputLine^.Data^:=Default;
  end;

destructor TInputBox.Done;
  begin
    Dispose(G,done);
    Dispose(R,done);
    Dispose(InputLine,done);
    TObject.Done;
  end;

procedure TInputBox.AddLine;
  begin
    G^.AddLine(addr(S));
  end;

procedure TInputBox.Draw;
  begin
    GMouse.Hide;
    SetColor(0);
    Rectangle(R^.a.x,R^.a.y,R^.b.x,R^.b.y);
    SetFillStyle(SolidFill,7);
    DrawBar(R^.a.x+1,R^.a.y+1,R^.b.x-1,R^.b.y-1);
    G^.WriteGroupBox(R^.a.x+5,R^.a.y+5,R^.b.x-5,R^.b.y-TextHgt-14);
    With InputLine^ do
    begin
      SetColor(1);
      Rectangle(R^.a.x-1,R^.a.y-1,R^.b.x+1,R^.b.y+1);
      Draw;
    end;
    GMouse.Show;
  end;

procedure TInputBox.Scan;
  begin
    InputLine^.Scan(Choice);
    if Choice=0 then{Enter}
      Default:=InputLine^.Data^;
  end;

procedure TInputBox.Start;
  var Width,Height,W,H,ax,ay: integer;
  begin
    G^.GetSize(W,H);
    Width:=intmax(W+10,PixW+10);
    Height:=H+TextHgt+16;
    ax:=(GetMaxX-Width) div 2;
    ay:=(GetMaxY-Height) div 2;
    R^.setbounds(ax,ay,ax+Width-1,ay+Height-1);
    InputLine^.R^.Setbounds(ax+4,ay+Height-TextHgt-12,
                            ax+PixW+4,ay+Height-6);
    Draw;
  end;

constructor TBrowser.Init;
  var Pos: longint;
      Size: longint;
  function BeginOfPage: boolean;
    var B1,B2: char;
        result: boolean;
    begin
      Result:=false;
      BrFile^.Read(B1,1);
      if B1='*' then
      begin
        BrFile^.Read(B1,1);
        BrFile^.Read(B2,1);
        if (B1='*') and (B2='*') then
        begin
          Pos:=Pos+3;
          result:=true;
        end else
        begin
          inc(Pos);
          BrFile^.Seek(Pos);
        end;
      end else
        inc(Pos);
      BeginOfPage:=Result;
    end;
  begin
    TAlertBox.Init;
    MaxPage:=0;
    Pos:=0;
    FileError:=true;
    New(BrFile,init(AFileName,stOpenRead));
    if BrFile^.Status=stOK then
    begin
      Size:=BrFile^.GetSize;
      while Pos<Size-3 do
      begin
        if BeginOfPage then
        begin
          inc(MaxPage);
          if MaxPage>1 then
            PageEnd[MaxPage-1]:=Pos-4;
          PageStart[MaxPage]:=Pos+1;
        end;
      end;
      if MaxPage>0 then
      begin
        FileError:=false;
        PageEnd[MaxPage]:=Size-1;
        AddButton(' << ');
        AddButton('<');
        AddButton('>');
        AddButton('>>');
        AddButton('OK');
        Default:=5;
        CurPage:=1;
      end;
    end;
    if FileError then
      AddButton('Annuleer');
  end;

procedure TBrowser.NewPage;
  var Pos: longint;
      Line: string;
      ch: char;
      Pag,Tot: string;
  begin
    Dispose(G,done);
    New(G,init);
    if FileError then
    begin
      AddLine('');
      AddLine('Er is momenteel geen ^bhelppagina^b beschikbaar,');
      AddLine('want het helpbestand kan niet gevonden worden.');
      AddLine('');
      AddLine('- kijk of bestanden ^b*.BTX^b aanwezig zijn;');
      AddLine('- kijk of deze in de werkdirectory staan.');
    end else
    begin
      str(CurPage:2,Pag);
      str(MaxPage,Tot);
      AddLine('^hrpagina '+Pag+'/'+Tot);
      AddLine('^c15-----------------------------------------------------------------');
      BrFile^.Seek(PageStart[CurPage]);
      Line:='';
      repeat
        BrFile^.Read(Ch,1);
        if Ch<>chr(13) then
        begin
          if Ch<>chr(10) then
            Line:=Line+Ch;
        end else
        begin
          AddLine(Line);
          Line:='';
        end;
      until BrFile^.GetPos>=PageEnd[CurPage];
    end;
  end;

procedure TBrowser.Start;
  var Width,Height,ax,ay,dBW: integer;
      x: byte;
  begin
    GetButtonSize;
    Width:=400;
    Height:=400;
    ax:=(GetMaxX-Width) div 2;
    ay:=(GetMaxY-Height) div 2;
    R^.setbounds(ax,ay,ax+Width-1,ay+Height-1);
    PlaceButtons;
    NewPage;
    Draw;
  end;

procedure TBrowser.Scan;
  begin
    TAlertBox.Scan(Choice);
    if not FileError then
      while Choice<>4 do
      begin
        Case Choice of
        0: CurPage:=CurPage-5;
        1: dec(CurPage);
        2: inc(CurPage);
        3: CurPage:=CurPage+5;
        end;
        if CurPage<1 then CurPage:=1;
        if CurPage>MaxPage then CurPage:=MaxPage;
        NewPage;
        TAlertBox.Draw;
        TAlertBox.Scan(Choice);
      end;
  end;

destructor TBrowser.Done;
  begin
    Dispose(BrFile,done);
    TAlertBox.Done;
  end;

{Klok}
constructor TClock.Init;
  begin
    CountBack:=IsCountBack;
    Halted:=false;
    Reset(hr,mn,sc,sh);
  end;

procedure TClock.Reset;
  begin
    Time2Tc(hr,mn,sc,sh,Timer);
    GetTime(hr,mn,sc,sh);
    Time2Tc(hr,mn,sc,sh,OldT);
    OldSec:=sc;
    Changed:=false;
  end;

procedure TClock.Update;
  var hr,mn,sc,sh: word;
      NewT,Dif: real;
  begin
    if Not Halted then
    begin
      GetTime(hr,mn,sc,sh);
      if sc<>OldSec then
      begin
        Changed:=true;
        OldSec:=Sc;
      end;
      Time2Tc(hr,mn,sc,sh,NewT);
      Dif:=NewT-OldT;
      OldT:=NewT;
      if Dif<=360000 then {minder als uur verschil-> geen dagwisseling}
      begin
        if CountBack then
          Timer:=Timer-Dif
        else
          Timer:=Timer+Dif;
      end;
    end;
  end;

procedure TClock.Halt;
  begin
    Update;
    Halted:=true;
  end;

procedure TClock.Cont;
  var hr,mn,sc,sh: word;
  begin
    GetTime(hr,mn,sc,sh);
    Time2Tc(hr,mn,sc,sh,OldT);
    Halted:=false;
  end;

procedure TClock.Time;
  begin
    Tc2Time(Timer,Hour,Min,Sec,S100);
  end;

function TClock.SecChanged;
  begin
    if Changed then
    begin
      Changed:=false;
      SecChanged:=true;
    end else
      SecChanged:=false;
  end;

procedure TClock.StartLap;
  begin
    Update;
    Lap:=Timer;
  end;

function TClock.GetLap;
  begin
    if CountBack then
      GetLap:=Lap-Timer
    else
      GetLap:=Timer-Lap;
  end;

procedure Tc2Time;
  var Rtc: real;
  begin
    Hour:=trunc(Tc/360000.0);
    Rtc:=Tc-Hour*360000.0;
    Min:=trunc(Rtc/6000.0);
    Rtc:=Rtc-Min*6000.0;
    Sec:=trunc(Rtc/100.0);
    Rtc:=Rtc-Sec*100.0;
    S100:=trunc(Rtc);
  end;

procedure Time2Tc;
  begin
    Tc:=Hour*360000.0+Min*6000.0+Sec*100.0+S100;
  end;

function GetTick: word;
  var Where: pointer;
      Seg,Ofs: word;
  begin
    Seg:=$006C; Ofs:=$0040;
    Move(Seg,PByteArray(@Where)^[0],2);
    Move(Ofs,PByteArray(@Where)^[2],2);
    GetTick:=word(Where^);
  end;

procedure WaitForTick;
  var Tick: word;
  begin
    repeat
      Tick:=GetTick;
    until Tick<>OldTick;
    OldTick:=Tick;
  end;

procedure RealDelay;
  var x: word;
  begin
    for x:=1 to MSec do
      WaitForTick;
  end;

{Grafische Routines}

procedure InitGraphics;
  var GraphDriver,GraphMode,ErrorCode: integer;
      Status: boolean;
      BtnCount: integer;
  begin
    ErrorCode:=RegisterBGIdriver(@EGAVGADriverProc);
    ErrorCode:=RegisterBGIfont(@SmallFontProc);
    GraphDriver:=VGA;
    GraphMode:=VGAHI;
    InitGraph(GraphDriver, GraphMode, '');
    ErrorCode := GraphResult;
    If ErrorCode <> grOK then
    begin
      writeln(' Graphics System Error: ',GraphErrorMsg(ErrorCode));
      writeln(' Dit programma vereist een VGA schermdriver (640x480x16).');
      writeln(' Zie de handleiding of bestand README.TXT voor meer informatie.');
      halt(1);
    end;
    GMouse.Reset(Status,BtnCount);
    if Status then
    begin
      ClearDevice;
      GMouse.Initialize;
    end else
    begin
      CloseGraph;
      writeln(' Dit programma vereist een muis en de aanwezigheid van een muisdriver.');
      writeln(' Zie de handleiding of bestand README.TXT voor meer informatie.');
      halt(1);
    end;
    SetTextStyle(SmallFont,Horizdir,0);
    SetLetter(ltMedium); {medium}
  end;

procedure CloseGraphics;
  begin
    CloseGraph;
    TMouse.Initialize;
  end;

procedure DrawBar(AX,AY,BX,BY: integer);
  var VP: ViewPortType;
      FillInfo: FillSettingsType;
  begin
    GetViewSettings(VP);
    if AX<0 then
      AX:= AX+8*((-AX) div 8);
    if AY<0 then
      AY:= AY+8*((-AY) div 8);
    if BX>(VP.X2-VP.X1) then
      BX:= BX-8*((BX-VP.X2+VP.X1) div 8);
    if BY>(VP.Y2-VP.Y1) then
      BY:= BY-8*((BY-VP.Y2+VP.Y1) div 8);

    if (AX<BX) and (AY<BY) then
      Bar(AX,AY,BX,BY)
    else
      if (AX=BX) or (AY=BY) then
      begin
        GetFillSettings(FillInfo);
        SetColor(FillInfo.Color);
        if AX=BX then
          if AY<=BY then
            line(AX,AY,BX,BY);
        if AY=BY then
          if AX<=BX then
            line(AX,AY,BX,BY);
      end;
  end;

procedure DrawSymbol;
  begin
    if Symbol=TRadOff then
      Circle(ax+4,ay+4,4);
    if Symbol=TRadOn then
    begin
      Circle(ax+4,ay+4,4);
      SetFillStyle(SolidFill,0);
      DrawBar(ax+3,ay+3,ax+5,Ay+5);
    end;
    if Symbol=TBoxOff then
      Rectangle(ax,ay,ax+8,ay+8);
    if Symbol=TBoxOn then
    begin
      Rectangle(ax,ay,ax+8,ay+8);
      Line(ax,ay,ax+8,ay+8);
      Line(ax,ay+8,ax+8,ay);
    end;
  end;

{Text}
procedure SetLetter;
  begin
    SetTextStyle(SmallFont,Horizdir,0);
    Letter:=Size;
    if Size=0 then
    begin
      SetUserCharSize(1,1,1,1);
      TextHgt:=9;
      TextVsc:=-3;
    end;
    if Size=1 then
    begin
      SetUserCharSize(1,1,3,2);
      TextHgt:=13;
      TextVsc:=-4;
    end;
    if Size=2 then
    begin
      SetUserCharSize(3,2,2,1);
      TextHgt:=17;
      TextVsc:=-6;
    end;
  end;

Procedure WriteText;
  var DeltaX, DeltaY: integer;
  begin
    Case HJustify of
      LeftText  :
        DeltaX:=0;
      CenterText:
        DeltaX:=(bx-ax+1-TextWidth(Text^)) div 2;
      RightText :
        DeltaX:=bx-ax+1-TextWidth(Text^);
    end;
    Case VJustify of
      TopText   :
        DeltaY:=0;
      CenterText:
        DeltaY:=(by-ay+1-TextHgt) div 2;
      BottomText:
        DeltaY:=by-ay+1-TextHgt;
    end;
    OutTextXY(ax+DeltaX,
              ay+DeltaY+TextVSc, Text^);
  end;

const tcBold  =1;
      tcUnder =2;
      tcColor =3;
      tcSize  =4;
      tcHscale=5;
      tcVscale=6;

procedure GetTextCommand;
  var code: integer;
  begin
    Com:=0;
    Par:=0;
    if S^[Pos]='^' then
    begin
      Inc(Pos);
      Case S^[Pos] of
      'b':
       begin
        Com:=tcBold;
        inc(Pos);
       end;
      'u':
       begin
        Com:=tcUnder;
        inc(Pos);
       end;
      'c':
       begin
        Com:=tcColor;
        Val(copy(S^,Pos+1,2),Par,Code);
        Pos:=Pos+3;
       end;
      's':
       begin
        Com:=tcSize;
        Val(copy(S^,Pos+1,1),Par,Code);
        Pos:=Pos+2;
       end;
      'h':
       begin
        Com:=tcHscale;
        Case S^[Pos+1] of
        'l': Par:=LeftText;
        'c': Par:=CenterText;
        'r': Par:=RightText;
        end;
        Pos:=Pos+2;
       end;
      'v':
       begin
        Com:=tcVscale;
        Case S^[Pos+1] of
        't': Par:=TopText;
        'c': Par:=CenterText;
        'b': Par:=BottomText;
        end;
        Pos:=Pos+2;
       end;
      end;
    end;
  end;

procedure GetTextSize;
  var L,i,Com,Par: byte;
      Xc,Yc,W,Size: integer;
      Ch: Char;
      Bold: boolean;
  begin
    {init}
    Xc:=0; Yc:=TextHgt;
    L:=ord(S^[0]);
    i:=1;
    Bold:=false;
    Size:=Letter;
    {loop}
    repeat
      repeat
        GetTextCommand(S,i,Com,Par);
        Case Com of
        tcBold : Bold:=not Bold;
        tcSize :
         begin
          SetLetter(Par);
          if TextHgt>Yc then Yc:=TextHgt;
         end;
        end;
      until (Com=0) or (i>L);
      if i<=L then
      begin
        Ch:=S^[i];
        W:=TextWidth(Ch);
        if Bold then inc(W);
        Xc:=Xc+W;
        inc(i);
      end;
    until i>L;
    if Letter<>Size then
      SetLetter(Size);
    Width :=Xc;
    Height:=Yc;
  end;

procedure WriteXY;
  var L,i,Com,Par: byte;
      Xc,Yc,W,Col,Size: integer;
      Ch: Char;
      Bold,Under: boolean;
  begin
    {init}
    Xc:=X; Yc:=Y;
    L:=ord(S^[0]);
    i:=1;
    Bold:=false; Under:=false;
    Col:=GetColor;
    Size:=Letter;
    {loop}
    repeat
      repeat
        GetTextCommand(S,i,Com,Par);
        Case Com of
        tcBold : Bold:=not Bold;
        tcUnder: Under:=not Under;
        tcColor: SetColor(Par);
        tcSize : SetLetter(Par);
        end;
      until (Com=0) or (i>L);
      if i<=L then
      begin
        Ch:=S^[i];
        W:=TextWidth(Ch);
        if Bold then inc(W);
        OutTextXY(Xc,Yc+TextVsc,Ch);
        if Bold then
          OutTextXY(Xc+1,Yc+TextVsc,Ch);
        if Under then
          line(Xc,Yc+TextHgt-1,Xc+W-1,Yc+TextHgt-1);
        Xc:=Xc+W;
        inc(i);
      end;
    until i>L;
    SetColor(Col);
    if Letter<>Size then
      SetLetter(Size);
  end;

procedure WriteCXY;
  var W,H: integer;
  begin
    GetTextSize(S,W,H);
    SetFillStyle(SolidFill,Col);
    DrawBar(X,Y,X+W-1,Y+H-1);
    WriteXY(S,X,Y);
  end;

procedure WriteBox;
  var vp: ViewPortType;
      L,i,Hsc,Vsc,Com,Par: byte;
      W,H,dx,dy: integer;
  begin
    Hsc:=LeftText; Vsc:=TopText;
    GetTextSize(S,W,H);
    L:=ord(S^[0]);
    i:=1;
    repeat
      GetTextCommand(S,i,Com,Par);
      Case Com of
      tcHscale: Hsc:=Par;
      tcVscale: Vsc:=Par;
      end;
    until (Com=0) or (i>L);
    GetViewSettings(vp);
    SetViewPort(ax,ay,bx,by,True);
    Case HSc of
      LeftText  :
        dx:=0;
      CenterText:
        dx:=(bx-ax+1-W) div 2;
      RightText :
        dx:=bx-ax+1-W;
    end;
    Case VSc of
      TopText   :
        dy:=0;
      CenterText:
        dy:=(by-ay+1-H) div 2;
      BottomText:
        dy:=by-ay+1-H;
    end;
    WriteXY(S,dx,dy);
    SetViewPort(vp.x1,vp.y1,vp.x2,vp.y2,vp.Clip);
  end;

procedure WriteCBox;
  begin
    SetFillStyle(SolidFill,Col);
    DrawBar(ax,ay,bx,by);
    WriteBox(S,ax,ay,bx,by);
  end;

constructor TTextGroup.Init;
  begin
    TCollection.Init(5,5);
    LineDist:=5;
  end;

procedure TTextGroup.AddLine;
  var L: PString;
  begin
    GetMem(L,length(S^)+1);
    Move(S^,L^,length(S^)+1);
    Insert(L);
  end;

procedure TTextGroup.GetSize;
  var i: integer;
      W,H: integer;
  begin
    Width:=0; Height:=0;
    for i:=0 to Count-1 do
    begin
      GetTextSize(At(i),W,H);
      Width:=IntMax(Width,W);
      Height:=Height+H+LineDist;
    end;
  end;

procedure TTextGroup.WriteGroupBox;
  var i: integer;
      W,H,Yc: integer;
  begin
    Yc:=ay;
    for i:=0 to Count-1 do
    begin
      GetTextSize(At(i),W,H);
      WriteBox(At(i),ax,yc,bx,yc+H-1);
      Yc:=Yc+H+LineDist;
    end;
  end;

destructor TTextGroup.Done;
  var x: integer;
  begin
    for x:=0 to Count-1 do
      freemem(At(x),length(PString(At(x))^)+1);
    DeleteAll;
    TCollection.Done;
  end;

{Sound}
procedure BeepOK;
  begin
    OldTick:=GetTick;
    WaitForTick;
    Sound(700);
    RealDelay(1);
    NoSound;
  end;

procedure BeepError;
  begin
    OldTick:=GetTick;
    WaitForTick;
    Sound(70);
    RealDelay(3);
    NoSound;
  end;

procedure Melody;
  var Length,x,dur: word;
      frq,base: real;
  begin
    Length:=M^[0]*$100+M^[1];
    Base:=1.059463094;
    OldTick:=GetTick;
    WaitForTick;
    for x:=1 to Length do
    begin
      frq:=110*exp(M^[x*2]*ln(Base));
      dur:=M^[x*2+1]*2;
      if not (M^[x*2]=0) then
        Sound(round(frq));
      RealDelay(dur);
      NoSound;
    end;
  end;

procedure GetKeyInput;
  var ch: char;
  begin
    if KeyIn=kbNoInput then
    begin
      if keypressed then
      begin
        ch:=readkey;
        if ord(ch)=0 then
        begin
          ch:=readkey;
          KeyIn:=$100+ord(ch);
        end else
          KeyIn:=ord(ch);
      end;
    end;
  end;

function FoundKey;
  begin
    if Key=KeyIn then
    begin
      FoundKey:=true;
      ResetKey;
    end else
      FoundKey:=false;
  end;

procedure ResetKey;
  begin
    KeyIn:=kbNoInput;
  end;

procedure SelectFile(Title,Message: string; var DefFileName: string; Ext: ExtStr;
           Options: byte; var Choice: integer; var S: TBufStream);
  var I: PInputBox;
      Alert: PAlertBox;
      ADir: DirStr;
      AName: NameStr;
      AnExt: ExtStr;
      FileName: string;
      Exist,Syntax: boolean;
  begin
    New(I,init(DefFileName+Ext,30,190));
    I^.AddLine('^hc^s2^c15^b'+Title+'^b');
    I^.AddLine('');
    I^.AddLine(Message);
    I^.Start;
    I^.Scan(Choice);
    if Choice=0 then
    begin
      FileName:=I^.Default;
      FSplit(FileName,ADir,AName,AnExt);
      if AnExt='' then AnExt:=Ext;
      if AName='' then Choice:=1;
    end;
    Dispose(I,done);
    if Choice=0 then
    begin
      Exist:=true;
      FileName:=ADir+AName+AnExt;
      S.Init(FileName,stOpenRead,1024);
      if S.Status<>stOK then
        Exist:=false;
      S.Done;
    end;
    if Choice=0 then
      Case Options of
      fsLoad:
       begin
         if Exist then
         begin
           S.Init(FileName,stOpenRead,1024);
           DefFileName:=ADir+AName;
         end else
         begin
           New(Alert,init);
           Alert^.AddLine('^s2^c15^hc^bDOS FOUT');
           Alert^.AddLine('Kan bestand ^c01'+FileName+'^c00 niet openen.');
           Alert^.AddButton('Annuleren');
           Alert^.Start;
           Alert^.Scan(Choice);
           Dispose(Alert,done);
           Choice:=1;
         end;
       end;
      fsSave:
       begin
         if Exist then
         begin
           New(Alert,init);
           Alert^.AddLine('^s2^c15^hc^bWAARSCHUWING');
           Alert^.AddLine('Bestand ^c01'+FileName+'^c00 bestaat al.');
           Alert^.AddButton(' Overschrijven ');
           Alert^.AddButton('Annuleren');
           Alert^.Start;
           Alert^.Scan(Choice);
           Dispose(Alert,done);
         end;
         if Choice=0 then
         begin
           S.Init(FileName,stCreate,1024);
           if S.Status<>stOK then
           begin
             S.Done;
             New(Alert,init);
             Alert^.AddLine('^s2^c15^hc^bDOS FOUT');
             Alert^.AddLine('Bestandsnaam ^c01'+FileName+'^c00 is ongeldig.');
             Alert^.AddButton('Annuleren');
             Alert^.Start;
             Alert^.Scan(Choice);
             Dispose(Alert,done);
             Choice:=1;
           end else
             DefFileName:=ADir+AName;
         end;
       end;
      end;
  end;

const Errors:array[1..1] of String=
      ('Niet genoeg conventioneel geheugen');

procedure HandleError;
  begin
    CloseGraphics;
    ClrScr;
    Writeln('Er is een fout opgetreden: ',Errors[ErrNum]);
    Writeln;
    Writeln('Programma wordt gestopt.');
    Halt(1);
  end;

end.