(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is sammelklassen.pas of Karsten Bilderschau, version 3.2.12.
 *
 * The Initial Developer of the Original Code is Matthias Muntwiler.
 * Portions created by the Initial Developer are Copyright (C) 2006
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** *)

{ $Id: sammelklassen.pas 121 2008-10-27 02:51:17Z hiisi $ }

{
@abstract Classes that represent collection items
@author matthias muntwiler <hiisi@users.sourceforge.net>
@cvs $Date: 2008-10-26 21:51:17 -0500 (So, 26 Okt 2008) $

Quick german course: A karsten document is a collection (sammlung)
of collectible items (sammelobjekte). These items can have the classes (klassen)
defined in this unit: @link(TSammelobjekt) is the abstract base class for such
collectible items. Actual objects are @link(TSammelbild) (collectible picture)
and @link(TSammelordner) (collectible folder).
}
unit sammelklassen;
{ pendenzen
 -multimedia-datenstrukturen erstellen
  -BildVerfuegbar soll angeben: datei exisitiert, grafikformat (an dateiendung) erkannt
 -TSammelordner auf verzeichnisinhalt-änderung reagieren
 -relative pfadangaben nur auf benutzerwunsch
}

interface
uses
	Classes, SysUtils, Graphics, Windows, ComCtrls, Math, ComObj, ShlObj, JclStrHashMap,
  Globals, BildKlassen, KarsReg, XMLIntf;

type
  TSammelobjektVisitor = class;
  TSammelobjektVisitorClass = class of TSammelobjektVisitor;
	TSammelobjekt = class;
	TSammelobjektKlasse = class of TSammelobjekt;

  { Interface for methods that change the properties of a collection item }
	IBildbearbeitung=interface
		['{74845A81-69E3-11D3-A7E5-0000B4812410}']
		procedure SetHaeufigkeit(const Value: THaeufigkeit);
		procedure SetPfad(const Value: string);
		procedure SetBitmapModus(const Value: TBitmapModus);
		procedure SetVergroesserung(const value: cardinal);
		procedure SetHintergrundfarbe(const Value: TColor);
		procedure SetName(const Value: string);
		procedure SetWartezeit(const Value: TWartezeit);
		procedure SetSchluessel(const value: integer);
    procedure SetSequenceNumber(const Value: integer);
	end;

	TSammelobjektChangeEvent=
		procedure(Sender: TSammelobjekt; changes: TSammelobjektProperties) of object;

  { Status of the collection item's link to the file }
  TBildStatus = (
    bsUndefined,       //< Path undefined
    bsPending,         //< Path not yet checked
    bsResolvePending,  //< File not found, but @link(ResolveShellLink) still pending
    bsOK,              //< File exists
    bsFileNotFound,    //< File not found, @link(ResolveShellLink) failed
    bsReadError        //< File exists but cannot be displayed (wrong format, corrupt data, etc.)
    );

	{ @abstract(Base class for collection items)
    This class declares and handles the properties of a collection item
    for the collection editor window as well as the slide show.

    The "main" or persistent properties are declared as published. }
	TSammelobjekt = class(TPersistent, IBildbearbeitung)
  private
    class var
      FLastID: integer;
	private
    FID: integer;
		FBild: TBilderrahmen;
		FOnChange: TSammelobjektChangeEvent;
    FIconIndex: integer;
    FSelected: boolean;
    FViewerItem: TObject;
    FPfadHash: THashValue;
    FSequenceNumber: integer;
		function  GetAktiv: boolean; virtual;
		procedure SetAktiv(const Value: boolean); virtual;
		function  GetHaeufigkeit: tHaeufigkeit; virtual;
		function  GetBild: TBildObjekt; virtual;
    procedure SetBildStatus(const Value: TBildStatus);
    procedure SetShellLink(const Value: IShellLink);
    function  GetShellLink: IShellLink;
  protected
		FName: string;
		FPfad: string;
    FShellLink: IShellLink;
    { Creation of the @link(FShellLink) instance is deferred until required.
      This string contains the persistence data. }
    FShellLinkString: string;
		FBitmapModus: TBitmapModus;
		FVergroesserung: cardinal;
		FHintergrundfarbe: TColor;
		FWartezeit: TWartezeit;
		FHaeufigkeit: integer;
		FSchluessel: integer;
    FBildStatus: TBildStatus;
    FTimeModified: TDateTime;
		function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
		function _AddRef: integer; stdcall;
		function _Release: integer; stdcall;

		procedure SetHaeufigkeit(const Value: tHaeufigkeit); virtual;
		procedure SetPfad(const Value: string); virtual;
		procedure SetBitmapModus(const Value: tBitmapModus); virtual;
		procedure SetVergroesserung(const Value: cardinal); virtual;
		procedure SetHintergrundfarbe(const Value: tColor); virtual;
		procedure SetName(const Value: string); virtual;
		procedure SetWartezeit(const Value: tWartezeit); virtual;
		procedure SetSchluessel(const Value: integer); virtual;
    procedure SetSequenceNumber(const Value: integer); virtual;
    procedure DoChange(changes: TSammelobjektProperties); virtual;
	public
		constructor Create; virtual;
		destructor	Destroy; override;
		procedure Assign(Source: TPersistent); override;
		procedure AssignTo(Dest: TPersistent); override;
    { Each instance gets a unique ID upon construction.
      This ID is not persistent,
      i.e. it is used only in memory and doesn't get assigned to copies of the object. }
    property  ID: integer read FID;
    { Hash function that is used to calculate @link(PfadHash).
      Use this function to generate a hash value for lookup.
      The result is calculated by the TextHash function of JclStrHashMap.
      This method should not be overriden in descending classes. }
    class function PfadHashFunc(const path: string): THashValue;
    { Hash value for @link(Pfad) generated using @link(PfadHashFunc). }
    property  PfadHash: THashValue read FPfadHash;
    { Select this item for an operation on @link(TSammlung).
      This temporarily holds the selection status of the corresponding UI item
      for interfacing to certain @link(TSammlung) methods. }
    property  Selected: boolean read FSelected write FSelected;
		property	BildStatus: TBildStatus read FBildStatus write SetBildStatus;
		property	Bild: TBildObjekt read GetBild;
    { informiert über die schaltung als schaubild
			EOrdnerLeer, EDateiFehlt-exceptions möglich }
		procedure	BildSchalten; virtual; abstract;
    { Checks file existence, resolves the shell link if necessary,
      and updates @link(BildStatus).
      Returns the new @link(BildStatus). }
    function  CheckBild: TBildStatus; virtual;

    { informiert über die änderung von dokumentrelevanten eigenschaften }
		property	OnChange: TSammelobjektChangeEvent read FOnChange write FOnChange;
    { Stores the icon index for the collection viewer.
      The property is managed completely by the viewer.
      The initial value is -1. }
    property  IconIndex: integer read FIconIndex write FIconIndex;
    { Stores a reference to the viewer item of the collection form.
      For a TListView this is a TListItem.
      The property is managed completeley by the viewer. }
    property  ViewerItem: TObject read FViewerItem write FViewerItem;

    { Write this object to an old-format file.
      Current code should use the XML format and @link(WriteToXML)
      for all persistence streaming. }
		procedure WriteToFiler(Writer: TWriter); virtual; deprecated;
    { Read this object from an old-format file.
      The preferred streaming format is now XML through @link(ReadFromXML).
      This method is provided for compatibility with older files. }
		procedure ReadFromFiler(Reader: TReader; fileVersion: word); virtual;
    { Writes the object to the specified XML node. }
    procedure WriteToXML(Node: IXMLNode); virtual;
    { Read the object properties from the specified XML node. }
    procedure ReadFromXML(Node: IXMLNode); virtual;
    { Accept method for operations that follow a visitor pattern.
      Calls the corresponding @link(Visit) method of AVisitor. }
    procedure AcceptVisitor(AVisitor: TSammelobjektVisitor); virtual;
  published
    { Display name of the collection item }
		property	Name: string read FName write SetName;
    { Absolute path to the file that this collection item represents.

      Both properties @link(Pfad) and @link(ShellLink) are interdependent,
      and only one of them should be assigned at one time.
      The other is updated automatically. }
		property	Pfad: string read FPfad write SetPfad;
    { Shell link to the file/folder that this collection item represents.
      In addition to the path,
      a shell link contains persistent file system information
      that allows to resolve a file that has been moved or renamed.

      Both properties @link(Pfad) and @link(ShellLink) are interdependent,
      and only one of them should be assigned at one time.
      The other is updated automatically. }
    property  ShellLink: IShellLink read GetShellLink write SetShellLink;
    { Enables (@true) or disables (@true) the item in the slide show }
		property	Aktiv: boolean read GetAktiv write SetAktiv;
    { Stretch mode of the slide }
		property	BitmapModus: TBitmapModus read FBitmapModus write SetBitmapModus;
    { Fixed magnification factor in percent if @link(BitmapModus) is bmIsoSpeziell. }
		property	Vergroesserung: cardinal read FVergroesserung write SetVergroesserung;
    { Background color of the slide }
		property	Hintergrundfarbe: TColor read FHintergrundfarbe write SetHintergrundfarbe;
    { Relative display frequency of the slide }
		property	Haeufigkeit: THaeufigkeit read GetHaeufigkeit write SetHaeufigkeit;
    { Wait time for the slide }
		property	Wartezeit: TWartezeit read FWartezeit write SetWartezeit;
    { Decryption key (reserved) }
		property	Schluessel: integer read FSchluessel write SetSchluessel;
    { User-defined sequence number. Allows for custom sort order.
      Full integer range allowed.

      Introduced in version 3.5. }
    property  SequenceNumber: integer read FSequenceNumber write SetSequenceNumber;
    { Date and time of last modification. }
    property  TimeModified: TDateTime read FTimeModified;
  end;

  { @abstract(Collection item that links to a file) }
	TSammelbild=class(TSammelobjekt)
	public
		procedure SetPfad(const Value: string); override;
    function  CheckBild: TBildStatus; override;
		procedure	BildSchalten; override;
    { Accept method for operations that follow a visitor pattern.
      Calls the corresponding @link(Visit) method of AVisitor. }
    procedure AcceptVisitor(AVisitor: TSammelobjektVisitor); override;
	end;

  { @abstract(Collection item that links to a folder)
    During the slide show, each time the item is displayed,
    another file is randomly picked from the folder. }
	TSammelordner=class(TSammelobjekt)
	private
		FAuswahlIdx: integer;
		FDateiliste: TStringList;
		procedure UpdateDateiliste;
	protected
		property	Dateiliste: TStringList read FDateiliste;
	public
		constructor Create; override;
		destructor Destroy; override;
    { Source may be any @link(TSammelobjekt) descendant.
      (Some actions rely on this option!) }
		procedure Assign(Source: TPersistent); override;
		procedure AssignTo(Dest: TPersistent); override;
		procedure SetPfad(const Value: string); override;
    function  CheckBild: TBildStatus; override;
		procedure	BildSchalten; override;
    { Accept method for operations that follow a visitor pattern.
      Calls the corresponding @link(Visit) method of AVisitor. }
    procedure AcceptVisitor(AVisitor: TSammelobjektVisitor); override;
	end;

  { @abstract Base class for visitors to @link(TSammelobjekt)
    The methods declared in this class do nothing.
    Descendants can decide themselves which methods to override. }
  TSammelobjektVisitor = class
  public
    constructor Create;
    procedure VisitSammelobjekt(ASammelobjekt: TSammelobjekt); virtual;
    procedure VisitSammelbild(ASammelbild: TSammelbild); virtual;
    procedure VisitSammelordner(ASammelordner: TSammelordner); virtual;
  end;


  

implementation
uses
  shelllinks;

{ TSammelobjekt }

constructor TSammelobjekt.Create;
begin
	inherited;
  FID := InterlockedIncrement(FLastID);
  FSequenceNumber := cDefSequenceNumber;
	FWartezeit := cDefWartezeit;
	FHaeufigkeit := cDefHaeufigkeit;
	FBitmapModus := cDefBitmapModus;
	FVergroesserung := cDefVergroesserung;
	FHintergrundfarbe := cDefHintergrundfarbe;
	FSchluessel := cDefSchluessel;
  FBildStatus := bsUndefined;
  FShellLink := nil;
  FShellLinkString := '';
  FTimeModified := Now();
  FIconIndex := -1;
  FPfadHash := PfadHashFunc(FPfad);
end;

destructor TSammelobjekt.Destroy;
begin
	FBild.Free;
	inherited;
end;

procedure TSammelobjekt.DoChange(changes: TSammelobjektProperties);
begin
  if changes - [soaStatus] <> [] then FTimeModified := Now();
  if Assigned(FOnChange) then FOnChange(Self, changes);
end;

function TSammelobjekt.GetAktiv: boolean;
begin
	result := fHaeufigkeit>0;
end;

function TSammelobjekt.GetHaeufigkeit: tHaeufigkeit;
begin
	if fHaeufigkeit>=0 then result := fHaeufigkeit else result := 0;
end;

procedure TSammelobjekt.SetAktiv(const Value: boolean);
begin
	if value<>GetAktiv then begin
		if value then begin
			if fHaeufigkeit<0 then fHaeufigkeit := -fHaeufigkeit
			else if fHaeufigkeit=0 then fHaeufigkeit := cDefHaeufigkeit;
		end else begin
			if fHaeufigkeit>0 then fHaeufigkeit := -fHaeufigkeit;
		end;
    DoChange([soaAktiv]);
	end;
end;

procedure TSammelobjekt.SetHaeufigkeit(const Value: tHaeufigkeit);
begin
	if value <> FHaeufigkeit then begin
		FHaeufigkeit := value;
    DoChange([soaHaeufigkeit]);
	end;
end;

procedure TSammelobjekt.ReadFromFiler;
var
	originalpfad: string;
  shellpfad: string;
  fd: TWin32FindData;
begin
  Name := Reader.ReadString;
  originalpfad := ExpandFileName(Reader.ReadString);
  if fileVersion >= 309 then begin
    try
      FShellLinkString := '';
      FShellLink := CreateShellLink('');
      ReadShellLink(FShellLink, Reader);
      SetLength(shellpfad, MAX_PATH);
      OleCheck(FShellLink.GetPath(PChar(shellpfad), MAX_PATH, fd, 0));
      SetLength(shellpfad, StrLen(PChar(shellpfad)));
      // if the paths are different we must not disturb the shell link
      if
        (shellpfad = '') or SameFileName(originalpfad, shellpfad)
      then
        Pfad := originalpfad
      else
        FPfad := shellpfad;
    except
      on EOleError do Pfad := originalpfad;
    end;
  end else begin
    Pfad := originalpfad;
  end;
  FPfadHash := PfadHashFunc(FPfad);
  if fileVersion >= 311 then
    SequenceNumber := Reader.ReadInteger
  else
    SequenceNumber := cDefSequenceNumber;
  Wartezeit := Reader.ReadInteger;
  Haeufigkeit := Reader.ReadInteger;
  BildStatus := bsPending;
  if fileVersion >= 301 then
    BitmapModus := TBitmapModus(Reader.ReadInteger)
  else
    BitmapModus := cDefBitmapModus;
  if fileVersion >= 305 then
    Vergroesserung := Reader.ReadInteger
  else
    Vergroesserung := cDefVergroesserung;
  if fileVersion >= 302 then
    Hintergrundfarbe := Reader.ReadInteger
  else
    Hintergrundfarbe := cDefHintergrundfarbe;
  if fileVersion >= 310 then
    FTimeModified := Reader.ReadDate
  else
    FTimeModified := Now();
end;

procedure TSammelobjekt.ReadFromXML(Node: IXMLNode);
var
	originalpfad: string;
  PathNode: IXMLNode;
  Subnode: IXMLNode;
  s: string;
  iBitmapModus: TBitmapModus;
begin
  Name := Node.ChildNodes.Nodes[SSammelobjektPropertyTags[soaName]].Text;
  PathNode := Node.ChildNodes.Nodes[SSammelobjektPropertyTags[soaPfad]];
  if PathNode.ChildNodes.Count = 1 then
    originalpfad := PathNode.Text
  else begin
    SubNode := PathNode.ChildNodes.First;
    originalpfad := '';
    while Assigned(SubNode) do begin
      originalpfad := originalpfad + SubNode.Text;
      SubNode := SubNode.NextSibling;
    end;
  end;
	originalpfad := ExpandFileName(originalpfad);
  // note: the order in which the shell link fields and Pfad are set is crucial
  FShellLinkString := '';
  FShellLink := nil;
  Pfad := originalpfad;
  Subnode := Node.ChildNodes.FindNode('shelllink');
  if Assigned(Subnode) then FShellLinkString := Subnode.Text;
  s := Node.ChildNodes.Nodes[SSammelobjektPropertyTags[soaWartezeit]].Text;
  Wartezeit := StrToIntDef(s, Wartezeit);
  s := Node.ChildNodes.Nodes[SSammelobjektPropertyTags[soaHaeufigkeit]].Text;
  Haeufigkeit := StrToIntDef(s, Haeufigkeit);
  s := Node.ChildNodes.Nodes[SSammelobjektPropertyTags[soaBitmapModus]].Text;
  for iBitmapModus := Low(TBitmapModus) to High(TBitmapModus) do
    if SameText(s, SBitmapModusTags[iBitmapModus]) then begin
      BitmapModus := iBitmapModus;
      Break;
    end;
  s := Node.ChildNodes.Nodes[SSammelobjektPropertyTags[soaVergroesserung]].Text;
  Vergroesserung := StrToIntDef(s, Vergroesserung);
  s := Node.ChildNodes.Nodes[SSammelobjektPropertyTags[soaHintergrundfarbe]].Text;
  if s <> '' then
    Hintergrundfarbe := StringToColor(s);
  // the following nodes do not exist in older file versions
  Subnode := Node.ChildNodes.FindNode(SSammelobjektPropertyTags[soaSequenceNumber]);
  if Assigned(Subnode) then
    SequenceNumber := StrToIntDef(Subnode.Text, SequenceNumber)
  else
    SequenceNumber := cDefSequenceNumber;
  Subnode := Node.ChildNodes.FindNode('modtime');
  if Assigned(Subnode) then
    FTimeModified := StrToFloatDef(Subnode.Text, Now())
  else
    FTimeModified := Now();
end;

procedure TSammelobjekt.WriteToFiler;
var
	base, relative: string;
begin
	base := IncludeTrailingPathDelimiter(GetCurrentDir);
	relative := ExtractRelativePath(base, fPfad);
	with Writer do begin
		WriteString(FName);
		WriteString(relative);
    WriteShellLink(GetShellLink, Writer);
    WriteInteger(FSequenceNumber);
		WriteInteger(FWartezeit);
		WriteInteger(FHaeufigkeit);
		WriteInteger(Ord(FBitmapModus));
		WriteInteger(FVergroesserung);
		WriteInteger(FHintergrundfarbe);
    WriteDate(FTimeModified);
	end;
end;

procedure TSammelobjekt.WriteToXML(Node: IXMLNode);
var
	base, relative: string;
begin
	base := IncludeTrailingPathDelimiter(GetCurrentDir);
	relative := ExtractRelativePath(base, fPfad);
	Node.AddChild(SSammelobjektPropertyTags[soaName]).Text := FName;
	Node.AddChild(SSammelobjektPropertyTags[soaPfad]).Text := relative;
  if Assigned(FShellLink) or (FShellLinkString = '') then
    Node.AddChild('shelllink').Text := FormatShellLinkString(GetShellLink)
  else
    Node.AddChild('shelllink').Text := FShellLinkString;
	Node.AddChild(SSammelobjektPropertyTags[soaSequenceNumber]).Text := IntToStr(FSequenceNumber);
	Node.AddChild(SSammelobjektPropertyTags[soaWartezeit]).Text := IntToStr(FWartezeit);
	Node.AddChild(SSammelobjektPropertyTags[soaHaeufigkeit]).Text := IntToStr(FHaeufigkeit);
	Node.AddChild(SSammelobjektPropertyTags[soaBitmapModus]).Text := SBitmapModusTags[FBitmapModus];
	Node.AddChild(SSammelobjektPropertyTags[soaVergroesserung]).Text := IntToStr(FVergroesserung);
	Node.AddChild(SSammelobjektPropertyTags[soaHintergrundfarbe]).Text := ColorToString(FHintergrundfarbe);
  Node.AddChild('modtime').Text := FloatToStr(FTimeModified);
end;

procedure TSammelobjekt.Assign(Source: TPersistent);
var
	SourceObj: TSammelobjekt;
begin
	if Source is TSammelobjekt then begin
  	SourceObj := Source as TSammelobjekt;
    FName             := SourceObj.FName;
    FShellLink        := nil;
    FPfad             := SourceObj.FPfad;
    FPfadHash         := PfadHashFunc(FPfad);
    FBitmapModus      := SourceObj.FBitmapModus;
    FVergroesserung   := SourceObj.FVergroesserung;
    FHintergrundfarbe := SourceObj.FHintergrundfarbe;
    FWartezeit        := SourceObj.FWartezeit;
    FHaeufigkeit      := SourceObj.FHaeufigkeit;
    FSchluessel       := SourceObj.FSchluessel;
    FSequenceNumber   := SourceObj.FSequenceNumber;
    if Assigned(SourceObj.FShellLink) then
      FShellLinkString := FormatShellLinkString(SourceObj.FShellLink)
    else
      FShellLinkString := SourceObj.FShellLinkString;
    if FPfad <> '' then
      FBildStatus := bsPending
    else
      FBildStatus := bsUndefined;
    FTimeModified    := SourceObj.FTimeModified;
    if Assigned(FBild) then FBild.Assign(Self);
		if Assigned(FOnChange) then FOnChange(Self, soaAlle);
	end else
    inherited;
end;

procedure TSammelobjekt.AssignTo(Dest: TPersistent);
begin
	if Dest is TBildobjekt then
		with Dest as TBildobjekt do begin
			Pfad             := Self.Pfad;
			BitmapModus      := Self.BitmapModus;
			Vergroesserung   := Self.Vergroesserung;
			Hintergrundfarbe := Self.Hintergrundfarbe;
			Schluessel       := Self.Schluessel;
      SequenceNumber   := Self.SequenceNumber;
		end
	else
    inherited;
end;

procedure TSammelobjekt.AcceptVisitor(AVisitor: TSammelobjektVisitor);
begin
  AVisitor.VisitSammelobjekt(Self);
end;

class function TSammelobjekt.PfadHashFunc;
begin
  result := TextHash(path);
end;

procedure TSammelobjekt.SetPfad;
var
	fullpath: string;
begin
	fullpath := ExpandFileName(value);
	if not SameFileName(fullpath, FPfad) then begin
		FPfad := fullpath;
    FPfadHash := PfadHashFunc(FPfad);
    if FPfad <> '' then
      FBildStatus := bsPending
    else
      FBildStatus := bsUndefined;
    if Assigned(FShellLink) then
      OleCheck(FShellLink.SetPath(PChar(FPfad)));
    FShellLinkString := '';
    DoChange([soaPfad, soaStatus]);
	end;
end;

function TSammelobjekt.GetShellLink: IShellLink;
begin
  if not Assigned(FShellLink) then begin
    if FShellLinkString <> '' then begin
      FShellLink := CreateShellLink('');
      ParseShellLinkString(FShellLink, FShellLinkString);
      FShellLinkString := '';
    end else begin
      FShellLink := CreateShellLink(FPfad);
    end;
  end;
  result := FShellLink;
end;

procedure TSammelobjekt.SetShellLink;
var
  fullpath: string;
begin
  fullpath := ExpandFileName(GetShellLinkPath(Value));
  if not SameText(fullpath, FPfad) then begin
    FShellLink := Value;
    FPfad := fullpath;
    if FPfad <> '' then
      FBildStatus := bsPending
    else
      FBildStatus := bsUndefined;
    DoChange([soaPfad, soaStatus]);
  end;
end;

procedure TSammelobjekt.SetBitmapModus(const Value: tBitmapModus);
begin
	if value<>fBitmapModus then begin
		fBitmapModus  :=  Value;
		if Assigned(FBild) then FBild.BitmapModus := value;
		DoChange([soaBitmapModus]);
	end;
end;

procedure TSammelobjekt.SetVergroesserung(const Value: cardinal);
begin
	if value<>fVergroesserung then begin
		fVergroesserung  :=  Value;
		if Assigned(FBild) then FBild.Vergroesserung := value;
		DoChange([soaVergroesserung]);
	end;
end;

procedure TSammelobjekt.SetHintergrundfarbe(const Value: tColor);
begin
	if value<>fHintergrundfarbe then begin
		fHintergrundfarbe  :=  Value;
		if Assigned(FBild) then FBild.Hintergrundfarbe := value;
		DoChange([soaHintergrundfarbe]);
	end;
end;

procedure TSammelobjekt.SetName(const Value: string);
begin
	if CompareStr(fName,value)<>0 then begin
		fName  :=  Value;
		DoChange([soaName]);
	end;
end;

procedure TSammelobjekt.SetWartezeit(const Value: tWartezeit);
begin
	if value<>fWartezeit then begin
		fWartezeit  :=  Value;
		DoChange([soaWartezeit]);
	end;
end;

procedure TSammelobjekt.SetSchluessel(const Value: integer);
begin
	if value<>fSchluessel then begin
		fSchluessel  :=  Value;
		if Assigned(FBild) then FBild.Schluessel := value;
		DoChange([soaSchluessel]);
	end;
end;

procedure TSammelobjekt.SetSequenceNumber(const Value: integer);
begin
  if Value <> FSequenceNumber then begin
    FSequenceNumber := Value;
    DoChange([soaSequenceNumber]);
  end;
end;

procedure TSammelobjekt.SetBildStatus(const Value: TBildStatus);
begin
  if Value <> FBildStatus then begin
    FBildStatus := Value;
    DoChange([soaStatus]);
  end;
end;

{IUnknown-schnittstelle}
function TSammelobjekt._AddRef: Integer;
begin
	Result := -1; // keine referenzzählung
end;

function TSammelobjekt._Release: Integer;
begin
	Result := -1; // keine referenzzählung
end;

function TSammelobjekt.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
	if GetInterface(IID, Obj) then Result  :=  0 else Result  :=  E_NOINTERFACE;
end;

function TSammelobjekt.GetBild: TBildObjekt;
begin
	if not Assigned(FBild) and (CheckBild=bsOK) then begin
		FBild := TBilderrahmen.Create;
		FBild.Assign(Self);
	end;
	Result := FBild;
end;

function TSammelobjekt.CheckBild: TBildStatus;
begin
  result := bsUndefined;
end;

{ TSammelbild }

procedure TSammelbild.AcceptVisitor(AVisitor: TSammelobjektVisitor);
begin
  AVisitor.VisitSammelbild(Self);
end;

function TSammelbild.CheckBild: TBildStatus;
var
  s: string;
begin
  if Length(Pfad)=0 then begin
    result := bsUndefined;
  end else if FileExists(Pfad) then begin
    result := bsOK;
  end else if BildStatus < bsFileNotFound then begin
    s := ResolveShellLink(FShellLink, 0);
    if (Length(s) > 0) and FileExists(s) then begin
      Pfad := s;
      result := bsOK;
    end else
      result := bsFileNotFound;
  end else begin
    result := bsFileNotFound;
  end;
  BildStatus := result;
end;

procedure TSammelbild.BildSchalten;
begin end;

procedure TSammelbild.SetPfad(const Value: string);
begin
	inherited;
	if Assigned(FBild) then FBild.Pfad := value;
end;

{ TSammelordner }

constructor TSammelordner.Create;
begin
	inherited;
	FDateiliste := TStringList.Create;
	Dateiliste.Sorted := false;
	Dateiliste.Duplicates := dupIgnore;
end;

destructor TSammelordner.Destroy;
begin
	Dateiliste.Free;
	inherited;
end;

procedure TSammelordner.AcceptVisitor(AVisitor: TSammelobjektVisitor);
begin
  AVisitor.VisitSammelordner(Self);
end;

procedure TSammelordner.UpdateDateiliste;
var
	code: integer;
	search: TSearchRec;
	oldsel: string;
begin
	if (FAuswahlIdx >= 0) and (FAuswahlIdx < Dateiliste.Count) then
		oldsel := Dateiliste.Strings[FAuswahlIdx]
  else
		oldsel := '';
	Dateiliste.Clear;
	FAuswahlIdx := -1;
  // todo -cconfig : make inclusion of hidden files configurable
	code := SysUtils.FindFirst(Pfad + '*.*', faReadOnly or faHidden, search);
	try
		while code = 0 do begin
			if MediaTypes.GetGrafikformat(search.Name) <> gfUnbekannt then
				Dateiliste.Add(search.Name);
			code := SysUtils.FindNext(search);
		end;
		FAuswahlIdx := Dateiliste.IndexOf(oldsel);
		if FAuswahlIdx < 0 then
      FAuswahlIdx := Min(0, Dateiliste.Count - 1);
    if Dateiliste.Count > 0 then
      BildStatus := bsOK
    else
      BildStatus := bsFileNotFound;
	finally
		SysUtils.FindClose(search);
	end;
end;

procedure TSammelordner.SetPfad(const Value: string);
begin
	inherited SetPfad(IncludeTrailingPathDelimiter(Value));
	UpdateDateiliste;
end;

procedure TSammelordner.BildSchalten;
begin
  if (BildStatus=bsUndefined) or (Dateiliste.Count=0) then UpdateDateiliste;
	if Dateiliste.Count>0 then begin
		FAuswahlIdx := Random(Dateiliste.Count);
		Bild.Pfad := Self.Pfad + Dateiliste.Strings[fAuswahlIdx];
	end else begin
    FBildStatus := bsFileNotFound;
		raise EOrdnerLeer.CreateFmt(seOrdnerLeer, [Pfad]);
	end;
end;

procedure TSammelordner.Assign(Source: TPersistent);
begin
	Dateiliste.Clear;
	FAuswahlIdx := -1;
	inherited;
end;

procedure TSammelordner.AssignTo(Dest: TPersistent);
begin
	if Dest is TBildobjekt then
		with Dest as TBildobjekt do begin
			try
				Pfad := Dateiliste.Strings[FAuswahlIdx];
				Bitmapmodus := Self.BitmapModus;
				Vergroesserung := Self.Vergroesserung;
				Hintergrundfarbe := Self.Hintergrundfarbe;
				Schluessel := Self.Schluessel;
			except
				on EStringListError do ;
			end;
		end
	else
		if Dest is TSammelbild then
			with Dest as TSammelbild do begin
				inherited;
				try
					Pfad := Dateiliste.Strings[FAuswahlIdx];
				except
					on EStringListError do Pfad := '';
				end;
			end;
end;

function TSammelordner.CheckBild: TBildStatus;
var
  s: string;
begin
  if Length(Pfad)=0 then begin
    result := bsUndefined;
  end else if DirectoryExists(Pfad) then begin
    result := bsOK;
    UpdateDateiliste;
  end else if BildStatus < bsFileNotFound then begin
    s := ResolveShellLink(FShellLink, 0);
    if (Length(s) > 0) and DirectoryExists(s) then begin
      Pfad := s;
      result := bsOK;
      UpdateDateiliste;
    end else
      result := bsFileNotFound;
  end else begin
    result := bsFileNotFound;
  end;
  if (result = bsOK) and (Dateiliste.Count = 0) then
    result := bsFileNotFound;
  BildStatus := result;
end;

{ TSammelobjektVisitor }

constructor TSammelobjektVisitor.Create;
begin
  inherited;
end;

procedure TSammelobjektVisitor.VisitSammelobjekt(ASammelobjekt: TSammelobjekt);
begin
end;

procedure TSammelobjektVisitor.VisitSammelordner(ASammelordner: TSammelordner);
begin
end;

procedure TSammelobjektVisitor.VisitSammelbild(ASammelbild: TSammelbild);
begin
end;

initialization
	Classes.RegisterClass(TSammelobjekt);
	Classes.RegisterClass(TSammelbild);
	Classes.RegisterClass(TSammelordner);
end.
