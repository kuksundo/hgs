{ sdDwgTypesAndConsts

  original author: Nils Haeck M.Sc.
  copyright (c) SimDesign BV (www.simdesign.nl)
}
unit sdDwgTypesAndConsts;

interface

uses

  Windows;

type

  DwgShort    = smallint; // 2 bytes
  DwgLong     = longint;  // 4 bytes
  DwgDouble   = double;   // 8 bytes
  DwgChar     = char;
  DwgByte     = byte;
  Dwg2DPoint  = array[0..1] of DwgDouble;
  Dwg3DPoint  = array[0..2] of DwgDouble;
  DwgSeeker   = dword;
  DwgSentinel = array[0..15] of DwgChar;

  TDwgHeader = packed record
    AcadVer:      array[0..6-1] of char;//'AC1012', 'AC1014', 'AC1015'
    Spacer1:      array[0..5-1] of byte;// should be 0
    AcadMaintVer: byte;
    OneByte:      byte;                 // should be 1
    ImageSeeker:  DwgSeeker;
    Unknown1:     array[0..2-1] of byte;
    DwgCodePage:  DwgShort;
    RecCount:     DwgLong;
    // Directly after are RecCount TDwgSectionLocator records
  end;

  TDwgSectionLocator = packed record
    RecordNumber: DwgByte;
    Seeker:       DwgSeeker;
    Size:         DwgLong;
  end;

  TDwgClassDef = record
    ClassNum:     DwgShort;
    Version:      DwgShort;  // in R14, becomes a flag indicating whether objects can be moved, edited, etc.  We are still examining this.
 	  AppName:      string;
 	  CppClassName: string;
    DxfClassName: string;
    WasaProxy:    boolean;
    ItemClassId:  DwgShort; // 0x1F2 for classes which produce entities, 0x1F3 for classes which produce objects.
  end;
  PDwgClassDef = ^TDwgClassDef;

  TDwgHandleRef = record
    Value: integer;
    Position: integer;
  end;
  PDwgHandleRef = ^TDwgHandleRef;

  TDwgHandle = packed record
    Code: byte;
    Handle: dword;
  end;

  TDwgDateTime = record
    Julian:    DwgLong;
    Millisecs: DwgLong;
  end;


  TDwgItemFamily = (
    ifUnknown,
    ifHeader,
    ifClass,
    ifTable,
    ifBlock,
    ifEntity,
    ifObject
  );

const

  cHeaderSentinel: DwgSentinel =
    #$95#$A0#$4E#$28#$99#$82#$1A#$E5#$5E#$41#$E0#$5F#$9D#$3A#$4D#$00;
  cClassStartSentinel: DwgSentinel =
    #$8D#$A1#$C4#$B8#$C4#$A9#$F8#$C5#$C0#$DC#$F4#$5F#$E7#$CF#$B6#$8A;
  cClassCloseSentinel: DwgSentinel = // warning! error in spec
    #$72#$5E#$3B#$47#$3B#$56#$07#$3A#$3F#$23#$0B#$A0#$18#$30#$49#$75;
  cHeaderStartSentinel: DwgSentinel =
    #$CF#$7B#$1F#$23#$FD#$DE#$38#$A9#$5F#$7C#$68#$B8#$4E#$6D#$33#$5F;
  cHeaderCloseSentinel: DwgSentinel =
    #$30#$84#$E0#$DC#$02#$21#$C7#$56#$A0#$83#$97#$47#$B1#$92#$CC#$A0;

  DwgCrcTable: array[0..255] of word =
     ($0000,$C0C1,$C181,$0140,$C301,$03C0,$0280,$C241,
      $C601,$06C0,$0780,$C741,$0500,$C5C1,$C481,$0440,
      $CC01,$0CC0,$0D80,$CD41,$0F00,$CFC1,$CE81,$0E40,
      $0A00,$CAC1,$CB81,$0B40,$C901,$09C0,$0880,$C841,
      $D801,$18C0,$1980,$D941,$1B00,$DBC1,$DA81,$1A40,
      $1E00,$DEC1,$DF81,$1F40,$DD01,$1DC0,$1C80,$DC41,
      $1400,$D4C1,$D581,$1540,$D701,$17C0,$1680,$D641,
      $D201,$12C0,$1380,$D341,$1100,$D1C1,$D081,$1040,
      $F001,$30C0,$3180,$F141,$3300,$F3C1,$F281,$3240,
      $3600,$F6C1,$F781,$3740,$F501,$35C0,$3480,$F441,
      $3C00,$FCC1,$FD81,$3D40,$FF01,$3FC0,$3E80,$FE41,
      $FA01,$3AC0,$3B80,$FB41,$3900,$F9C1,$F881,$3840,
      $2800,$E8C1,$E981,$2940,$EB01,$2BC0,$2A80,$EA41,
      $EE01,$2EC0,$2F80,$EF41,$2D00,$EDC1,$EC81,$2C40,
      $E401,$24C0,$2580,$E541,$2700,$E7C1,$E681,$2640,
      $2200,$E2C1,$E381,$2340,$E101,$21C0,$2080,$E041,
      $A001,$60C0,$6180,$A141,$6300,$A3C1,$A281,$6240,
      $6600,$A6C1,$A781,$6740,$A501,$65C0,$6480,$A441,
      $6C00,$ACC1,$AD81,$6D40,$AF01,$6FC0,$6E80,$AE41,
      $AA01,$6AC0,$6B80,$AB41,$6900,$A9C1,$A881,$6840,
      $7800,$B8C1,$B981,$7940,$BB01,$7BC0,$7A80,$BA41,
      $BE01,$7EC0,$7F80,$BF41,$7D00,$BDC1,$BC81,$7C40,
      $B401,$74C0,$7580,$B541,$7700,$B7C1,$B681,$7640,
      $7200,$B2C1,$B381,$7340,$B101,$71C0,$7080,$B041,
      $5000,$90C1,$9181,$5140,$9301,$53C0,$5280,$9241,
      $9601,$56C0,$5780,$9741,$5500,$95C1,$9481,$5440,
      $9C01,$5CC0,$5D80,$9D41,$5F00,$9FC1,$9E81,$5E40,
      $5A00,$9AC1,$9B81,$5B40,$9901,$59C0,$5880,$9841,
      $8801,$48C0,$4980,$8941,$4B00,$8BC1,$8A81,$4A40,
      $4E00,$8EC1,$8F81,$4F40,$8D01,$4DC0,$4C80,$8C41,
      $4400,$84C1,$8581,$4540,$8701,$47C0,$4680,$8641,
      $8201,$42C0,$4380,$8341,$4100,$81C1,$8081,$4040);

  // 74 ($4A) entity types
  cDwgEntityNames: array[0..$4A - 1] of string =
   ('UNUSED',                  // $00
    'TEXT',                    // $01
    'ATTRIB',                  // $02
    'ATTDEF',                  // $03
    'BLOCK',                   // $04
    'ENDBLK',                  // $05
    'SEQEND',                  // $06
    'INSERT',                  // $07
    'MINSERT',                 // $08
    '???',                     // $09
    'VERTEX (2D)',             // $0A
    'VERTEX (3D)',             // $0B
    'VERTEX (MESH)',           // $0C
    'VERTEX (PFACE)',          // $0D
    'VERTEX (PFACE FACE)',     // $0E
    'POLYLINE (2D)',           // $0F
    'POLYLINE (3D)',           // $10
    'ARC',                     // $11
    'CIRCLE',                  // $12
    'LINE',                    // $13
    'DIMENSION (ORDINATE)',    // $14
    'DIMENSION (LINEAR)',      // $15
    'DIMENSION (ALIGNED)',     // $16
    'DIMENSION (ANG 3-Pt)',    // $17
    'DIMENSION (ANG 2-Ln)',    // $18
    'DIMENSION (RADIUS)',      // $19
    'DIMENSION (DIAMETER)',    // $1A
    'POINT',                   // $1B
    '3DFACE',                  // $1C
    'POLYLINE (PFACE)',        // $1D
    'POLYLINE (MESH)',         // $1E
    'SOLID',                   // $1F
    'TRACE',                   // $20
    'SHAPE',                   // $21
    'VIEWPORT',                // $22
    'ELLIPSE',                 // $23
    'SPLINE',                  // $24
    'REGION',                  // $25
    '3DSOLID',                 // $26
    'BODY',                    // $27
    'RAY',                     // $28
    'XLINE',                   // $29
    'DICTIONARY',              // $2A
    '???',                     // $2B
    'MTEXT',                   // $2C
    'LEADER',                  // $2D
    'TOLERANCE',               // $2E
    'MLINE',                   // $2F
    'BLOCK CONTROL OBJ',       // $30
    'BLOCK HEADER',            // $31
    'LAYER CONTROL OBJ',       // $32
    'LAYER',                   // $33
    'STYLE CONTROL OBJ',       // $34
    'STYLE',                   // $35
    '???',                     // $36
    '???',                     // $37
    'LTYPE CONTROL OBJ',       // $38
    'LTYPE',                   // $39
    '???',                     // $3A
    '???',                     // $3B
    'VIEW CONTROL OBJ',        // $3C
    'VIEW',                    // $3D
    'UCS CONTROL OBJ',         // $3E
    'UCS',                     // $3F
    'VPORT CONTROL OBJ',       // $40
    'VPORT',                   // $41
    'APPID CONTROL OBJ',       // $42
    'APPID',                   // $43
    'DIMSTYLE CONTROL OBJ',    // $44
    'DIMSTYLE',                // $45
    'VP ENT HDR CTRL OBJ',     // $46
    'VP ENT HDR',              // $47
    'GROUP',                   // $48
    'MLINESTYLE');             // $49

const
  cEntText                    = $01;
  cEntAttrib                  = $02;
  cEntAttDef                  = $03;
  cEntBlock                   = $04;
  cEntEndBlk                  = $05;
  cEntSeqEnd                  = $06;
  cEntInsert                  = $07;
  cEntMInsert                 = $08;
  cEntVertex2D                = $0A;
  cEntVertex3D                = $0B;
  cEntVertexMesh              = $0C;
  cEntVertexPFace             = $0D;
  cEntVertexPFaceFace         = $0E;
  cEntPolyline2D              = $0F;
  cEntPolyline3D              = $10;
  cEntArc                     = $11;
  cEntCircle                  = $12;
  cEntLine                    = $13;
  cEntDimOrdinate             = $14;
  cEntDimLinear               = $15;
  cEntDimAligned              = $16;
  cEntDimAng3Pt               = $17;
  cEntDimAng2Ln               = $18;
  cEntDimRadius               = $19;
  cEntDimDiameter             = $1A;
  cEntPoint                   = $1B;
  cEnt3DFace                  = $1C;
  cEntPolylinePFace           = $1D;
  cEntPolylineMesh            = $1E;
  cEntSolid                   = $1F;
  cEntTrace                   = $20;
  cEntShape                   = $21;
  cEntViewport                = $22;
  cEntEllipse                 = $23;
  cEntSpline                  = $24;
  cEntRegion                  = $25;
  cEnt3DSolid                 = $26;
  cEntBody                    = $27;
  cEntRay                     = $28;
  cEntXLine                   = $29;
  cEntDictionary              = $2A;
  cEntMText                   = $2C;
  cEntLeader                  = $2D;
  cEntTolerance               = $2E;
  cEntMLine                   = $2F;
  cEntBlockControlObj         = $30;
  cEntBlockHeader             = $31;
  cEntLayerControlObj         = $32;
  cEntLayer                   = $33;
  cEntStyleControlObj         = $34;
  cEntStyle                   = $35;
  cEntLTypeControlObj         = $38;
  cEntLType                   = $39;
  cEntViewControlObj          = $3C;
  cEntView                    = $3D;
  cEntUCSControlObj           = $3E;
  cEntUCS                     = $3F;
  cEntVPortControlObj         = $40;
  cEntVPort                   = $41;
  cEntAppIdControlObj         = $42;
  cEntAppId                   = $43;
  cEntDimStyleControlObj      = $44;
  cEntDimStyle                = $45;
  cEntVPEntHdrCtrlObj         = $46;
  cEntVPEntHdr                = $47;
  cEntGroup                   = $48;
  cEntMLineStyle              = $49;

implementation

end.
