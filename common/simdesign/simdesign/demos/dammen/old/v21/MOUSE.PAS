{$G+} {$N+}
unit MOUSE;

INTERFACE

type
  position = record
               BtnStatus,
               opCount,
               xPos, yPos : integer;
             end;

  EventRec = record
               Event,
               BtnStatus,
               XPos, YPos : word;
             end;

  GCursor = record
              ScreenMask,
              CursorMask : array[0..15] of word;
              hotX, hotY : integer;
            end;

  var
    mEvent : EventRec;

  const
    ButtonL  = 0;
    ButtonR  = 1;
    ButtonM  = 2;
    Software = 0;
    Hardware = 1;
    OFF      = 0;
    ON       = 1;


    arrow : GCursor =
      (ScreenMask : ($1FFF,$0FFF,$07FF,$03FF,
                     $01FF,$00FF,$007F,$003F,
                     $001F,$003F,$01FF,$01FF,
                     $E0FF,$F0FF,$F8FF,$F8FF);
       CursorMask : ($0000,$4000,$6000,$7000,
                     $7800,$7C00,$7E00,$7F00,
                     $7F80,$7C00,$4C00,$0600,
                     $0600,$0300,$0300,$0000);
       hotX: $0001; hotY: $0001);

    check : GCursor =
      (ScreenMask : ($FFF0,$FFE0,$FFC0,$FF81,
                     $FF03,$0607,$000F,$001F,
                     $803F,$C07F,$E0FF,$F1FF,
                     $FFFF,$FFFF,$FFFF,$FFFF);
       CursorMask : ($0000,$0006,$000C,$0018,
                     $0030,$0060,$70C0,$3980,
                     $1F00,$0E00,$0400,$0000,
                     $0000,$0000,$0000,$0000);
       hotX: $0005; hotY: $0010);

    cross : GCursor =
      (ScreenMask : ($F01F,$E00F,$C007,$8003,
                     $0441,$0C61,$0381,$0381,
                     $0381,$0C61,$0441,$8003,
                     $C007,$E00F,$F01F,$FFFF);
       CursorMask : ($0000,$07C0,$0920,$1110,
                     $2108,$4104,$4004,$7C7C,
                     $4104,$4004,$2108,$1110,
                     $0920,$07C0,$0000,$0000);
       hotX: $0007; hotY: $0007);

    glove : GCursor =
      (ScreenMask : ($F3FF,$E1FF,$E1FF,$E1FF,
                     $E1FF,$E049,$E000,$8000,
                     $0000,$0000,$07FC,$07F8,
                     $9FF9,$8FF1,$C003,$E007);
       CursorMask : ($0C00,$1200,$1200,$1200,
                     $1200,$13B6,$1249,$7249,
                     $9249,$9001,$9001,$8001,
                     $4002,$4002,$2004,$1FF8);
       hotX: $0004; hotY: $0000);
    ibeam : GCursor =
      (ScreenMask : ($E10F,$E00F,$F83F,$FC7F,
                     $FC7F,$FC7F,$FC7F,$FC7F,
                     $FC7F,$FC7F,$FC7F,$FC7F,
                     $FC7F,$F83F,$E00F,$E10F);
       CursorMask : ($0000,$0C60,$0280,$0100,
                     $0100,$0100,$0100,$0100,
                     $0100,$0100,$0100,$0100,
                     $0100,$0280,$0C60,$0000);
       hotX: $0007; hotY: $0007);

  type
    GenMouse = object
      x, y : integer;
      visible : Boolean;
      function TestMouse: boolean;
      procedure SetAccel(threshold: integer);
      procedure Show;
      procedure Hide;
      procedure InstallTask(Mask: word);
      procedure ClearEvent;
      procedure GetPosition(var BtnStatus, XPos, YPos: integer);
      procedure QueryBtnDn(button: integer; var mouse: Position);
      procedure QueryBtnUp(button: integer; var mouse: Position);
      procedure ReadMove(var XMove, YMove: integer);
      procedure Reset(var Status: Boolean; var BtnCount: integer);
      procedure SetRatio(horPix, verPix: integer);
      procedure SetLimits(XPosMin, YPosMin, XPosMax, YPosMax: integer);
      procedure SetPosition(XPos, YPos: integer);
    end;

    GraphicMouse = object(GenMouse)
      procedure Initialize;
      procedure SetCursor(cursor: GCursor);
    end;

    TextMouse = object(GenMouse)
      DblClkTime: integer;
      procedure Initialize;
      procedure SetCursor(ctype, C1, C2: word);
    end;

    GraphicLightPen = object(GraphicMouse)
      procedure LightPen(Option: Boolean);
    end;

    TextLightPen = object(TextMouse)
      procedure LightPen(Option: Boolean);
    end;

  IMPLEMENTATION

  uses Crt, Graph, Dos;

  var
    Regs: registers;

  function Lower(n1, n2: integer): integer;
    begin
      if n1<n2 then Lower := n1
               else Lower := n2;
    end;

  function Upper(n1, n2: integer): integer;
    begin
      if n1>n2 then Upper := n1
               else Upper := n2;
    end;

  procedure MouseHandler(Flags, CS, IP, AX, BX, CX, DX,
                         SI, DI, DS, ES, BP: word);
    INTERRUPT;
    begin
      mEvent.Event     := AX;
      mEvent.BtnStatus := BX;
      mEvent.xPos      := CX;
      mEvent.yPos      := DX;
      { exit processing for far return to driver }
      inline( $8B/$E5/
              $5D/
              $07/
              $1F/
              $5F/
              $5E/
              $5A/
              $59/
              $5B/
              $58/
              $CB );
    end;

  function GenMouse.TestMouse: Boolean;
    const
      iret = 207;
    var
      dOff, dSeg: integer;
    begin
      dOff := MemW[0000:0204];
      dSeg := MemW[0000:0206];
      if( (dSeg = 0) or (dOff = 0))
        then TestMouse := FALSE
        else TestMouse := Mem[dSeg:dOff] <> iret;
    end;

  procedure GenMouse.Reset(var Status: Boolean; var BtnCount: integer);
    begin
      regs.AX := $00;
      intr($33,regs);
      Status   := regs.AX <> 0;
      BtnCount := regs.BX;
    end;

  procedure GenMouse.SetAccel(threshold: integer);
    begin
      regs.AX := $13;
      regs.DX := threshold;
      intr($33,regs);
    end;

  procedure GenMouse.Show;
    begin
      if not Visible then
      begin
        regs.AX := $01;
        Visible := TRUE;
        intr($33,regs);
      end;
    end;

  procedure GenMouse.Hide;
    begin
      if Visible then
      begin
        regs.AX := $02;
        Visible := FALSE;
        intr($33,regs);
      end;
    end;

  procedure GenMouse.GetPosition(var BtnStatus, Xpos, Ypos: integer);
    begin
      regs.AX := $03;
      intr($33,regs);
      BtnStatus := regs.BX;
      XPos      := regs.CX;
      YPos      := regs.DX;
    end;

  procedure GenMouse.SetPosition(XPos, YPos: integer);
    begin
      regs.AX := $04;
      regs.CX := XPos;
      regs.DX := YPos;
      intr($33,regs);
    end;

  procedure GenMouse.SetRatio(horPix, verPix: integer);
    begin
      regs.AX := $0F;
      regs.CX := horPix;
      regs.DX := verPix;
      intr($33,regs);
    end;

  procedure GenMouse.QueryBtnDn(button: integer; var mouse: Position);
    begin
      regs.AX := $05;
      regs.BX := button;
      intr($33,regs);
      mouse.BtnStatus := regs.AX;
      mouse.opCount := regs.BX;
      mouse.xPos    := regs.CX;
      mouse.yPos    := regs.DX;
    end;

  procedure GenMouse.QueryBtnUp(button: integer; var mouse: Position);
    begin
      regs.AX := $06;
      regs.BX := button;
      intr($33,regs);
      mouse.BtnStatus := regs.AX;
      mouse.opCount := regs.BX;
      mouse.xPos    := regs.CX;
      mouse.yPos    := regs.DX;
    end;

  procedure GenMouse.SetLimits(XPosMin, YPosMin, XPosMax, YPosMax: integer);
    begin
      regs.AX := $07;
      regs.CX := Lower(XPosMin,XPosMax);
      regs.DX := Upper(XPosMin,XPosMax);
      intr($33,regs);
      regs.AX := $08;
      regs.CX := Lower(YPosMin,YPosMax);
      regs.DX := Upper(YPosMin,YPosMax);
      intr($33,regs);
    end;

  procedure GenMouse.ReadMove(var XMove, Ymove: integer);
    begin
      regs.AX := $0B;
      intr($33,regs);
      XMove := regs.CX;
      YMove := regs.DX;
    end;

  procedure GenMouse.InstallTask;
    begin
      regs.AX := $0B;
      regs.CX := Mask;
      regs.DX := ofs(MouseHandler);
      regs.ES := seg(MouseHandler);
      intr($33,regs);
    end;

  procedure GenMouse.ClearEvent;
    begin
      mEvent.Event := 0
    end;


  procedure GraphicMouse.SetCursor(cursor: GCursor);
    begin
      regs.AX := $09;
      regs.BX := cursor.hotX;
      regs.CX := cursor.hotY;
      regs.DX := Ofs(cursor.ScreenMask);
      regs.ES := seg(cursor.ScreenMask);
      intr($33,regs);
    end;

  procedure GraphicMouse.Initialize;
    begin
      Visible := FALSE;
      SetLimits(0, 0, GetMaxX, GetMaxY);
      SetCursor(arrow);
      SetPosition(GetMaxX div 2, GetMaxY div 2);
      Show;
    end;

  procedure TextMouse.Initialize;
    begin
      Visible := FALSE;
      DblClkTime:= 700;
      SetLimits(lo(WindMin)*8, hi(WindMin)*8,
                lo(WindMax)*8, hi(WindMax)*8);
      SetCursor(Hardware, 6, 7);
      SetPosition(0, 0);
      Show;
    end;

  procedure TextMouse.SetCursor(cType, c1, c2: word);
    begin
      regs.AX := $0A;
      regs.BX := cType;
      regs.CX := c1;
      regs.DX := c2;
      intr($33,regs);
    end;


  procedure TextLightPen.LightPen(Option: Boolean);
    begin
      if Option then regs.AX := $0D
                else regs.AX := $0E;
      intr($33,regs);
    end;


  procedure GraphicLightPen.LightPen(Option: Boolean);
    begin
      if Option then regs.AX := $0D
                else regs.AX := $0E;
      intr($33,regs);
    end;

  end.