{ sdDwgHeaderVars

  original author: Nils Haeck M.Sc.
  copyright (c) SimDesign BV (www.simdesign.nl)
}
unit sdDwgHeaderVars;

interface

uses
  sdDwgBitReader, sdDwgTypesAndConsts;

type

  // Model and Paper space variables
  TDwgSpaceVars = record
    INSBASE: Dwg3DPoint;
    EXTMIN: Dwg3DPoint;
    EXTMAX: Dwg3DPoint;
    LIMMIN: Dwg2DPoint;
    LIMMAX: Dwg2DPoint;
    ELEVATION: double;
    UCSORG: Dwg3DPoint;
    UCSXDIR: Dwg3DPoint;
    UCSYDIR: Dwg3DPoint;
    UCSNAME: TDwgHandle;
    PUCSBASE: TDwgHandle;       // R2000
    PUCSORTHOVIEW: DwgShort;    // R2000
    PUCSORTHOREF: TDwgHandle;   // R2000
    PUCSORGTOP: Dwg3DPoint;     // R2000
    PUCSORGBOTTOM: Dwg3DPoint;  // R2000
    PUCSORGLEFT: Dwg3DPoint;    // R2000
    PUCSORGRIGHT: Dwg3DPoint;   // R2000
    PUCSORGFRONT: Dwg3DPoint;   // R2000
    PUCSORGBACK: Dwg3DPoint;    // R2000
  end;

  // A HUGE record containing all ACAD header variables
  TDwgHeaderVars = record
    Unknown01: double;  // Unknown, default value 412148564080.0
    Unknown02: double;  // Unknown, default value 1.0
    Unknown03: double;  // Unknown, default value 1.0
    Unknown04: double;  // Unknown, default value 1.0
    Unknown05: string;  // Unknown text string, default ""
    Unknown06: string;  // Unknown text string, default ""
    Unknown07: string;  // Unknown text string, default ""
    Unknown08: string;  // Unknown text string, default ""
    Unknown09: DwgLong; // Unknown long, default value 24L
    Unknown10: DwgLong; // Unknown long, default value 0L;
	  Unknown11: DwgShort; // Unknown short default value 0 (R13-14)
    HandleCurVp: TDwgHandle;
    DIMASO: boolean;
    DIMSHO: boolean;
    DIMSAV: boolean; // R13-14 Undocumented
	  PLINEGEN: boolean;
	  ORTHOMODE: boolean;
	  REGENMODE: boolean;
	  FILLMODE: boolean;
	  QTEXTMODE: boolean;
	  PSLTSCALE: boolean;
	  LIMCHECK: boolean;
    BLIPMODE: boolean; // R13-14
	  UserTimerOnOff: boolean;
    SKPOLY: boolean;
  	ANGDIR: boolean;
    SPLFRAME: boolean;
    ATTREQ: boolean; // R13-14
    ATTDIA: boolean; // R13-14
    MIRRTEXT: boolean;
    WORLDVIEW: boolean;
    WIREFRAME: boolean; // R13-14  Undocumented.
    TILEMODE: boolean;
    PLIMCHECK: boolean;
    VISRETAIN: boolean;
    DELOBJ: boolean; // R13-14
    DISPSILH: boolean;
    PELLIPSE: boolean;
    SAVEIMAGES: DwgShort;    // R13
    PROXYGRAPHICS: DwgShort; // R14-R2000
    DRAGMODE: DwgShort;      // R13-14
    TREEDEPTH: DwgShort;
    LUNITS: DwgShort;
    LUPREC: DwgShort;
    AUNITS: DwgShort;
    AUPREC: DwgShort;
    OSMODE: DwgShort; //R13-R14
    ATTMODE: DwgShort;
    COORDS: DwgShort; // R13-R14
    PDMODE: DwgShort;
    PICKSTYLE: DwgShort; // R13-R14
    USERI1: DwgShort;
    USERI2: DwgShort;
    USERI3: DwgShort;
    USERI4: DwgShort;
    USERI5: DwgShort;
    SPLINESEGS: DwgShort;
    SURFU: DwgShort;
    SURFV: DwgShort;
    SURFTYPE: DwgShort;
    SURFTAB1: DwgShort;
    SURFTAB2: DwgShort;
    SPLINETYPE: DwgShort;
    SHADEDGE: DwgShort;
    SHADEDIF: DwgShort;
    UNITMODE: DwgShort;
    MAXACTVP: DwgShort;
    ISOLINES: DwgShort;
    CMLJUST: DwgShort;
    TEXTQLTY: DwgShort;
    LTSCALE: double;
    TEXTSIZE: double;
    TRACEWID: double;
    SKETCHINC: double;
    FILLETRAD: double;
    THICKNESS: double;
    ANGBASE: double;
    PDSIZE: double;
    PLINEWID: double;
    USERR1: double;
    USERR2: double;
    USERR3: double;
    USERR4: double;
    USERR5: double;
    CHAMFERA: double;
    CHAMFERB: double;
    CHAMFERC: double;
    CHAMFERD: double;
    FACETRES: double;
    CMLSCALE: double;
    CELTSCALE: double;
    MENUNAME: string;
    TDCREATE: TDwgDateTime;
    TDUPDATE: TDwgDateTime;
    TDINDWG: TDwgDateTime;
    TDUSRTIMER: TDwgDateTime;
    CECOLOR: DwgShort;
    HANDSEED: TDwgHandle;
    CLAYER: TDwgHandle;
    TEXTSTYLE: TDwgHandle;
    CELTYPE: TDwgHandle;
    DIMSTYLE: TDwgHandle;
    CMLSTYLE: TDwgHandle;
    PSVPSCALE: double; // R2000

    // Model and Paper space subrecords
    PaperSpace: TDwgSpaceVars;
    ModelSpace: TDwgSpaceVars;

    DIMPOST: string;
    DIMAPOST: string;
    DIMTOL: boolean;
    DIMLIM: boolean;
    DIMTIH: boolean;
    DIMTOH: boolean;
    DIMSE1: boolean;
    DIMSE2: boolean;
    DIMALT: boolean;
    DIMTOFL: boolean;
    DIMSAH: boolean;
    DIMTIX: boolean;
    DIMSOXD: boolean;
    DIMALTD: byte;
    DIMZIN: byte;
    DIMSD1: boolean;
    DIMSD2: boolean;
    DIMTOLJ: byte;
    DIMJUST: byte;
    DIMFIT: byte;
    DIMUPT: boolean;
    DIMTZIN: byte;
    DIMALTZ: byte;
    DIMALTTZ: byte;
    DIMTAD: byte;
    DIMUNIT: DwgShort;
    DIMAUNIT: DwgShort;
    DIMDEC: DwgShort;
    DIMTDEC: DwgShort;
    DIMALTU: DwgShort;
    DIMALTTD: DwgShort;
    DIMTXSTY: TDwgHandle;
    DIMSCALE: double;
    DIMASZ: double;
    DIMEXO: double;
    DIMDLI: double;
    DIMEXE: double;
    DIMRND: double;
    DIMDLE: double;
    DIMTP: double;
    DIMTM: double;
    DIMAZIN: DwgShort; // R2000
    DIMTXT: double;
    DIMCEN: double;
    DIMTSZ: double;
    DIMALTF: double;
    DIMLFAC: double;
    DIMTVP: double;
    DIMTFAC: double;
    DIMGAP: double;
    DIMBLK: string;
    DIMBLK1: string;
    DIMBLK2: string;
    DIMALTRND: double;
    DIMCLRD: DwgShort;
    DIMCLRE: DwgShort;
    DIMCLRT: DwgShort;
    DIMADEC: DwgShort; // R2000
    DIMFRAC: DwgShort; // R2000
    DIMLUNIT: DwgShort; // R2000
    DIMDSEP: DwgShort; // R2000
    DIMTMOVE: DwgShort; // R2000
    DIMTXTSTY: TDwgHandle; // R2000
    DIMLDRBLK: TDwgHandle; // R2000
    DIMBLK_R2000: TDwgHandle; // R2000
    DIMBLK1_R2000: TDwgHandle; // R2000
    DIMBLK2_R2000: TDwgHandle; // R2000
    DIMLWD: DwgShort; // R2000
    DIMLWE: DwgShort; // R2000
    BLOCK_CONTROL_OBJECT: TDwgHandle;
    LAYER_CONTROL_OBJECT: TDwgHandle;
    STYLE_CONTROL_OBJECT: TDwgHandle;
    LINETYPE_CONTROL_OBJECT: TDwgHandle;
    VIEW_CONTROL_OBJECT: TDwgHandle;
    UCS_CONTROL_OBJECT: TDwgHandle;
    VPORT_CONTROL_OBJECT: TDwgHandle;
    APPID_CONTROL_OBJECT: TDwgHandle;
    DIMSTYLE_CONTROL_OBJECT: TDwgHandle;
    VIEWPORT_ENTITY_HEADER_CONTROL_OBJECT: TDwgHandle;
    DICTIONARY_ACAD_GROUP: TDwgHandle;
    DICTIONARY_ACAD_MLINESTYLE: TDwgHandle;
    DICTIONARY_NAMED_OBJECTS: TDwgHandle;
    Unknown12: DwgShort; // R2000
    Unknown13: DwgShort; // R2000
    HYPERLINKBASE: string; // R2000
    STYLESHEET: string; // R2000
    DICTIONARY_LAYOUTS: TDwgHandle; // R2000
    DICTIONARY_PLOTSETTINGS: TDwgHandle; // R2000
    DICTIONARY_PLOTSTYLES: TDwgHandle; // R2000
    CELWEIGHT: byte; // R2000
    ENDCAPS: byte; // R2000
    JOINSTYLE: byte; // R2000
    LWDISPLAY: boolean; // R2000
    XEDIT: boolean; // R2000
    EXTNAMES: boolean; // R2000
    PSTYLEMODE: boolean; // R2000
    OLESTARTUP: boolean; // R2000
    INSUNITS: DwgShort; // R2000
    CEPSNTYPE: DwgShort; // R2000
    CPSNID: TDwgHandle;//	present only if CEPSNTYPE == 3,  R2000
    FINGERPRINTGUID: string; // R2000
    VERSIONGUID: string; // R2000
    BLOCK_RECORD_PAPER_SPACE: TDwgHandle;
    BLOCK_RECORD_MODEL_SPACE: TDwgHandle;
    LTYPE_BYLAYER: TDwgHandle;
    LTYPE_BYBLOCK: TDwgHandle;
    LTYPE_CONTINUOUS: TDwgHandle;
  end;
  PDwgHeaderVars = ^TDwgHeaderVars;

procedure ReadHeaderVars(R: TDwgBitReader; var AHeader: TDwgHeaderVars);

implementation

procedure ReadHeaderVars(R: TDwgBitReader; var AHeader: TDwgHeaderVars);
  // Local
  procedure ReadSpace(var S: TDwgSpaceVars);
  begin
    S.INSBASE := R.BD3;
    S.EXTMIN := R.BD3;
    S.EXTMAX := R.BD3;
    S.LIMMIN := R.RD2;
    S.LIMMAX := R.RD2;
    S.ELEVATION := R.BD;
    S.UCSORG := R.BD3;
    S.UCSXDIR := R.BD3;
    S.UCSYDIR := R.BD3;
    S.UCSNAME := R.H;
    if R.IsR2000 then begin
      S.PUCSBASE := R.H;
      S.PUCSORTHOVIEW := R.BS;
      S.PUCSORTHOREF := R.H;
      S.PUCSORGTOP := R.BD3;
      S.PUCSORGBOTTOM := R.BD3;
      S.PUCSORGLEFT := R.BD3;
      S.PUCSORGRIGHT := R.BD3;
      S.PUCSORGFRONT := R.BD3;
      S.PUCSORGBACK := R.BD3;
    end;
  end;
var
  H: PDwgHeaderVars;
  Flags: DwgLong;
// main
begin
  H := @AHeader;
  H.Unknown01 := R.BD;
  H.Unknown02 := R.BD;
  H.Unknown03 := R.BD;
  H.Unknown04 := R.BD;
  H.Unknown05 := R.Text;
  H.Unknown06 := R.Text;
  H.Unknown07 := R.Text;
  H.Unknown08 := R.Text;
  H.Unknown09 := R.BL;
  H.Unknown10 := R.BL;
  if R.IsR1314 then
    H.Unknown11 := R.BS;
  H.HandleCurVp := R.H;
  H.DIMASO := R.Bit;
  H.DIMSHO := R.Bit;
  if R.IsR1314 then
    H.DIMSAV := R.Bit;
  H.PLINEGEN := R.Bit;
  H.ORTHOMODE := R.Bit;
	H.REGENMODE := R.Bit;
	H.FILLMODE := R.Bit;
	H.QTEXTMODE := R.Bit;
	H.PSLTSCALE := R.Bit;
	H.LIMCHECK := R.Bit;
  if R.IsR1314 then
    H.BLIPMODE := R.Bit;
	H.UserTimerOnOff := R.Bit;
  H.SKPOLY := R.Bit;
  H.ANGDIR := R.Bit;
  H.SPLFRAME := R.Bit;
  if R.IsR1314 then begin
	  H.ATTREQ := R.Bit;
    H.ATTDIA := R.Bit;
  end;
  H.MIRRTEXT := R.Bit;
  H.WORLDVIEW := R.Bit;
  if R.IsR1314 then
    H.WIREFRAME := R.Bit;
  H.TILEMODE := R.Bit;
  H.PLIMCHECK := R.Bit;
  H.VISRETAIN := R.Bit;
  if R.IsR1314 then
    H.DELOBJ := R.Bit;
  H.DISPSILH := R.Bit;
  H.PELLIPSE := R.Bit;
  if R.IsR13 then
    H.SAVEIMAGES := R.BS
  else
    H.PROXYGRAPHICS := R.BS;
  if R.IsR1314 then
    H.DRAGMODE := R.BS;
  H.TREEDEPTH := R.BS;
  H.LUNITS := R.BS;
  H.LUPREC := R.BS;
  H.AUNITS := R.BS;
  H.AUPREC := R.BS;
  if R.IsR1314 then
    H.OSMODE := R.BS;
  H.ATTMODE := R.BS;
  if R.IsR1314 then
    H.COORDS := R.BS;
  H.PDMODE := R.BS;
  if R.IsR1314 then
    H.PICKSTYLE := R.BS;
  H.USERI1 := R.BS;
  H.USERI2 := R.BS;
  H.USERI3 := R.BS;
  H.USERI4 := R.BS;
  H.USERI5 := R.BS;
  H.SPLINESEGS := R.BS;
  H.SURFU := R.BS;
  H.SURFV := R.BS;
  H.SURFTYPE := R.BS;
  H.SURFTAB1 := R.BS;
  H.SURFTAB2 := R.BS;
  H.SPLINETYPE := R.BS;
  H.SHADEDGE := R.BS;
  H.SHADEDIF := R.BS;
  H.UNITMODE := R.BS;
  H.MAXACTVP := R.BS;
  H.ISOLINES := R.BS;
  H.CMLJUST := R.BS;
  H.TEXTQLTY := R.BS;
  H.LTSCALE := R.BD;
  H.TEXTSIZE := R.BD;
  H.TRACEWID := R.BD;
  H.SKETCHINC := R.BD;
  H.FILLETRAD := R.BD;
  H.THICKNESS := R.BD;
  H.ANGBASE := R.BD;
  H.PDSIZE := R.BD;
  H.PLINEWID := R.BD;
  H.USERR1 := R.BD;
  H.USERR2 := R.BD;
  H.USERR3 := R.BD;
  H.USERR4 := R.BD;
  H.USERR5 := R.BD;
  H.CHAMFERA := R.BD;
  H.CHAMFERB := R.BD;
  H.CHAMFERC := R.BD;
  H.CHAMFERD := R.BD;
  H.FACETRES := R.BD;
  H.CMLSCALE := R.BD;
  H.CELTSCALE := R.BD;
  H.MENUNAME := R.Text;
  H.TDCREATE := R.BDT;
  H.TDUPDATE := R.BDT;
  H.TDINDWG := R.BDT;
  H.TDUSRTIMER := R.BDT;
  H.CECOLOR := R.BS;
  H.HANDSEED := R.H;
  H.CLAYER := R.H;
  H.TEXTSTYLE := R.H;
  H.CELTYPE := R.H;
  H.DIMSTYLE := R.H;
  H.CMLSTYLE := R.H;
  if R.IsR2000 then
    H.PSVPSCALE := R.BD;
  ReadSpace(H.PaperSpace);
  ReadSpace(H.ModelSpace);
  if R.IsR2000 then begin
    H.DIMPOST := R.Text;
    H.DIMAPOST := R.Text;
  end;
  if R.IsR1314 then begin
    H.DIMTOL := R.Bit;
    H.DIMLIM := R.Bit;
    H.DIMTIH := R.Bit;
    H.DIMTOH := R.Bit;
    H.DIMSE1 := R.Bit;
    H.DIMSE2 := R.Bit;
    H.DIMALT := R.Bit;
    H.DIMTOFL := R.Bit;
    H.DIMSAH := R.Bit;
    H.DIMTIX := R.Bit;
    H.DIMSOXD := R.Bit;
    H.DIMALTD := R.RC;
    H.DIMZIN := R.RC;
    H.DIMSD1 := R.Bit;
    H.DIMSD2 := R.Bit;
    H.DIMTOLJ := R.RC;
    H.DIMJUST := R.RC;
    H.DIMFIT := R.RC;
    H.DIMUPT := R.Bit;
    H.DIMTZIN := R.RC;
    H.DIMALTZ := R.RC;
    H.DIMALTTZ := R.RC;
    H.DIMTAD := R.RC;
    H.DIMUNIT := R.BS;
    H.DIMAUNIT := R.BS;
    H.DIMDEC := R.BS;
    H.DIMTDEC := R.BS;
    H.DIMALTU := R.BS;
    H.DIMALTTD := R.BS;
    H.DIMTXSTY := R.H;
  end;
  H.DIMSCALE := R.BD;
  H.DIMASZ := R.BD;
  H.DIMEXO := R.BD;
  H.DIMDLI := R.BD;
  H.DIMEXE := R.BD;
  H.DIMRND := R.BD;
  H.DIMDLE := R.BD;
  H.DIMTP := R.BD;
  H.DIMTM := R.BD;
  if R.IsR2000 then begin
    H.DIMTOL := R.Bit;
    H.DIMLIM := R.Bit;
    H.DIMTIH := R.Bit;
    H.DIMTOH := R.Bit;
    H.DIMSE1 := R.Bit;
    H.DIMSE2 := R.Bit;
    H.DIMTAD := R.BS;
    H.DIMZIN := R.BS;
    H.DIMAZIN := R.BS;
  end;
  H.DIMTXT := R.BD;
  H.DIMCEN := R.BD;
  H.DIMTSZ := R.BD;
  H.DIMALTF := R.BD;
  H.DIMLFAC := R.BD;
  H.DIMTVP := R.BD;
  H.DIMTFAC := R.BD;
  H.DIMGAP := R.BD;
  if R.IsR1314 then begin
    H.DIMPOST := R.Text;
    H.DIMAPOST := R.Text;
    H.DIMBLK := R.Text;
    H.DIMBLK1 := R.Text;
    H.DIMBLK2 := R.Text;
  end;
  if R.IsR2000 then begin
    H.DIMALTRND := R.BD;
    H.DIMALT := R.Bit;
    H.DIMALTD := R.BS;
    H.DIMTOFL := R.Bit;
    H.DIMSAH := R.Bit;
    H.DIMTIX := R.Bit;
    H.DIMSOXD := R.Bit;
  end;
  H.DIMCLRD := R.BS;
  H.DIMCLRE := R.BS;
  H.DIMCLRT := R.BS;
  if R.IsR2000 then begin
    H.DIMADEC := R.BS;
    H.DIMDEC := R.BS;
    H.DIMTDEC := R.BS;
    H.DIMALTU := R.BS;
    H.DIMALTTD := R.BS;
    H.DIMAUNIT := R.BS;
    H.DIMFRAC := R.BS;
    H.DIMLUNIT := R.BS;
    H.DIMDSEP := R.BS;
    H.DIMTMOVE := R.BS;
    H.DIMJUST := R.BS;
    H.DIMSD1 := R.Bit;
    H.DIMSD2 := R.Bit;
    H.DIMTOLJ := R.BS;
    H.DIMTZIN := R.BS;
    H.DIMALTZ := R.BS;
    H.DIMALTTZ := R.BS;
    H.DIMUPT := R.Bit;
    H.DIMFIT := R.BS;
    H.DIMTXTSTY := R.H;
    H.DIMLDRBLK := R.H;
    H.DIMBLK_R2000 := R.H;
    H.DIMBLK1_R2000 := R.H;
    H.DIMBLK2_R2000 := R.H;
    H.DIMLWD := R.BS;
    H.DIMLWE := R.BS;
  end;
  H.BLOCK_CONTROL_OBJECT := R.H;
  H.LAYER_CONTROL_OBJECT := R.H;
  H.STYLE_CONTROL_OBJECT := R.H;
  H.LINETYPE_CONTROL_OBJECT := R.H;
  H.VIEW_CONTROL_OBJECT := R.H;
  H.UCS_CONTROL_OBJECT := R.H;
  H.VPORT_CONTROL_OBJECT := R.H;
  H.APPID_CONTROL_OBJECT := R.H;
  H.DIMSTYLE_CONTROL_OBJECT := R.H;
  H.VIEWPORT_ENTITY_HEADER_CONTROL_OBJECT := R.H;
  H.DICTIONARY_ACAD_GROUP := R.H;
  H.DICTIONARY_ACAD_MLINESTYLE := R.H;
  H.DICTIONARY_NAMED_OBJECTS := R.H;
  if R.IsR2000 then begin
    H.Unknown12 := R.BS;
    H.Unknown13 := R.BS;
    H.HYPERLINKBASE := R.Text;
    H.STYLESHEET := R.Text;
    H.DICTIONARY_LAYOUTS := R.H;
    H.DICTIONARY_PLOTSETTINGS := R.H;
    H.DICTIONARY_PLOTSTYLES := R.H;
    Flags := R.BL;
    H.CELWEIGHT	 := (Flags AND $001F);        // bits 00000000 00011111
    H.ENDCAPS	   := (Flags AND $0060) shr 5;  // bits 00000000 01100000
    H.JOINSTYLE	 := (Flags AND $0180) shr 7;  // bits 00000001 10000000
    H.LWDISPLAY  := (Flags AND $0200) = 0;
    H.XEDIT	     := (Flags AND $0400) = 0;
    H.EXTNAMES	 := (Flags AND $0800) > 0;
    H.PSTYLEMODE := (Flags AND $2000) > 0;
    H.OLESTARTUP := (Flags AND $4000) > 0;
    H.INSUNITS := R.BS;
    H.CEPSNTYPE := R.BS;
    if H.CEPSNTYPE = 3 then
      H.CPSNID := R.H; //present only if CEPSNTYPE == 3
    H.FINGERPRINTGUID := R.Text;
    H.VERSIONGUID := R.Text;
  end;
  H.BLOCK_RECORD_PAPER_SPACE := R.H;
  H.BLOCK_RECORD_MODEL_SPACE := R.H;
  H.LTYPE_BYLAYER := R.H;
  H.LTYPE_BYBLOCK := R.H;
  H.LTYPE_CONTINUOUS := R.H;
{	H	:	unknown short (type 5/6 only)  these do not seem to be required,
	H	:	unknown short (type 5/6 only)  even for type 5.
	H	:	unknown short (type 5/6 only)
	H	:	unknown short (type 5/6 only)}
end;

end.
