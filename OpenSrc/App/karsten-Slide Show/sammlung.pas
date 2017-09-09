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
 * The Original Code is sammlung.pas of Karsten Bilderschau, version 3.2.12.
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

{ $Id: sammlung.pas 128 2008-11-26 05:25:10Z hiisi $ }

{
@abstract Picture collection container
@author matthias muntwiler <hiisi@users.sourceforge.net>
@cvs $Date: 2008-11-25 23:25:10 -0600 (Di, 25 Nov 2008) $
}
unit sammlung;

interface

uses
  sammelklassen.visitors, Windows, Classes, Graphics, SysUtils, Contnrs, XMLIntf, JclStrHashMap,
  globals, sammelklassen, bildklassen;

type
  TBilderSammlung = class;

  TListSortCompareEx = function (Item1, Item2: TSammelobjekt): Integer of object;

  { Types of change that can occur to a @link(TBilderSammlung) }
  TSammlungChange = (
    scAddObject,             //< An item is added
    scRemoveObject,          //< An item is removed
    scChangeProperty,        //< A property of the collection is changed
    scChangeStatus,          //< The status of the collection is changed
    scChangeObjectProperty,  //< A property of a collection item is changed
    scChangeObjectStatus,    //< The status of a collection item is changed
    scChangeOrder            //< The order of items is changed
    );

  TSammlungChanges = set of TSammlungChange;
  { Notifies of a change to a @link(TBilderSammlung).
    The type of change and affected item is specified.
    Item may refer to an invalid instance
    if the item has been removed.
    It may be @nil if several items or properties of the collection have changed. }
  TSammlungChangeEvent= procedure(Sender: TBilderSammlung;
    changes: TSammlungChanges; Item: TSammelobjekt) of object;

  { @abstract(Picture collection class)
    This class (Bildersammlung = picture collection) is the container for the
    karsten's business objects, the "collected items" (Sammelobjekte).
    }
  TBilderSammlung = class(TPersistent, IBildbearbeitung)
  private
    FList: TObjectList;
    FFileName: string;
    //idx in Items des zuletzt geschalteten sammelobjekts
    FSchauobjektIdx: integer;
    FOnChange: TSammlungChangeEvent;
    FSortierung: TSortierung;
    FRichtung: shortint;
    FAllowDuplicates: boolean;
    FUpdateCount: integer;
    FUpdateChanges: TSammlungChanges;
    FUpdateItem: TSammelobjekt;
    function  GetSammelItem(index: integer): TSammelobjekt;
    // @raises EListError if @link(FSchauobjektIdx) is invalid
    function  GetSchauobjekt: TSammelobjekt;
    function  GetSchaubild: TBildobjekt;
    procedure SetSortierung(const Value: TSortierung);
    procedure SetRichtung(const Value: shortint);
    procedure SetAllowDuplicates(const Value: boolean);
    function  GetPendingFiles: cardinal;
    function  GetCount: integer;
    procedure LoadXMLOptions(const Doc: IXMLDocument);
    procedure LoadXMLCollection(const Doc: IXMLDocument);
    procedure SaveXMLOptions(const Doc: IXMLDocument; selectedOnly: boolean);
    procedure SaveXMLCollection(const Doc: IXMLDocument; selectedOnly: boolean);
  protected
    function  SumFrequencies: integer; virtual;
    procedure SammelobjektChange(Sender: TSammelobjekt; changes: TSammelobjektProperties); virtual;
    function  ObjektVergleich(Obj1, Obj2: TSammelobjekt): Integer; virtual;
    { Loads data from a file in the old binary format (version 3.2.11 and earlier).
      The new items will have their @link(TSammelobjekt.Selected)
      property set to @true, while the existing ones are reset. }
    procedure LoadFromFileOldFormat(const name: string); virtual;
    { Loads data from an XML-formatted data file.
      The new items will have their @link(TSammelobjekt.Selected)
      property set to @true, while the existing ones are reset.
      @raises EDOMParseError if the file is not found or is not well-formed. }
    procedure LoadFromXMLFile(const name: string; ignoreOptions: boolean); virtual;
    procedure LoadFromXMLDoc(const Doc: IXMLDocument; ignoreOptions: boolean); virtual;
    procedure SaveToXMLDoc(const Doc: IXMLDocument; selectedOnly: boolean); virtual;
    { Notifies the owner of a change to the collection.
      This means calling the @link(OnChange) event if the collection is not in update mode.
      If it is (see @link(BeginUpdate)), the change is stored,
      and @link(OnChange) is called when update mode ends in @link(EndUpdate). }
    procedure DoChange(changes: TSammlungChanges; ChangedItem: TSammelobjekt); virtual;
  public
    constructor Create;
    destructor  Destroy; override;
    { Calls @link(AcceptVisitor) on each @link(Items). }
    procedure AcceptItemsVisitor(AVisitor: TSammelobjektVisitor);
    { Number of @link(Items). }
    property  Count: integer read GetCount;
    { The items of the collection.
      Index must be in the range 0..Count-1. }
    property  Items[index: integer]: TSammelobjekt read GetSammelItem; default;
    { Returns the index of Item in the list.
      Returns -1 if no match is found. }
    function  IndexOf(Item: TSammelobjekt): integer;
    { Returns the index of the first Item that matches the given path.
      Returns -1 if no match is found. }
    function  IndexOfFile(const path: string): integer;
    { Returns the index of the item that matches the given ID.
      Returns -1 if no match is found. }
    function  IndexOfID(ID: integer): integer;
    { Resets the @link(TSammelobjekt.Selected) property of all list items. }
    procedure ResetSelection;
    { Number of items with @link(BildStatus)<code> = bsPending</code>. }
    property  PendingFiles: cardinal read GetPendingFiles;

    { Enter update mode during which @link(OnChange) events are suppressed
      and deferred to the @link(EndUpdate) call.
      Each BeginUpdate must be matched by exactly one @link(EndUpdate),
      also in the case of exceptions. }
    procedure BeginUpdate; virtual;
    { Exit update mode and call an @link(OnChange) event. }
    procedure EndUpdate; virtual;
    { Adds a copy of Item to the collection.
      The @link(TSammelobjekt.Selected) property of the new item is set to @true. }
    procedure AddItem(Item: TSammelobjekt); virtual;
    { Inserts a copy of Item at the specified index.
      The @link(TSammelobjekt.Selected) property of the new item is set to @true. }
    procedure InsertItem(index: integer; Item:TSammelobjekt); virtual;
    { Frees the specified item and removes it from the collection }
    procedure FreeItem(Item: TSammelobjekt); virtual;
    { Clears the collection, freeing all contained items }
    procedure FreeAll; virtual;
    { Frees and removes only selected items (@link(TSammelobjekt.Selected))
      from the collection }
    procedure FreeSelected; virtual;
    { Changes the properties of Item that are specified in aenderungen
      to the values of the given prototype. }
    procedure ChangeItem(Item, Prototyp: TSammelobjekt; changes: TSammelobjektProperties); virtual;
    { Sorts the collection according to @link(Sortierung) and @link(Richtung).
      Note that the collection does not sort automatically
      except when @link(Sortierung) or @link(Richtung) is modified. }
    procedure Sort; virtual;
    procedure RenumberSequence; virtual;
    { Notifies of changes of relevant properties. }
    property  OnChange: TSammlungChangeEvent read FOnChange write FOnChange;

    { Saves the collection in an XML-formatted data file.
      if selectedOnly = @true only items that have
      @link(TSammelobjekt.Selected) = @true are saved. }
    procedure SaveToFile(const name: string; selectedOnly: boolean = false); virtual;
    { Loads a collection from a data file.
      The items from the file are added to existing items,
      and only the new items will have their @link(TSammelobjekt.Selected)
      property set to @true.
      The method can load both the older binary format (version 3.2.11 and earlier)
      as well as the newer XML format,
      using one of the @link(LoadFromFileOldFormat) or @link(LoadFromXMLFile) methods. }
    procedure LoadFromFile(const name: string); virtual;
    { Saves the collection to an XML-formatted string.
      if selectedOnly = @true only items that have
      @link(TSammelobjekt.Selected) = @true are saved. }
    procedure SaveToXMLString(var xml: string; selectedOnly: boolean); virtual;
    { Loads data from an XML-formatted string.
      The new items will have their @link(TSammelobjekt.Selected)
      property set to @true, while the existing ones are reset.
      @raises EDOMParseError if the file is not found or is not well-formed. }
    procedure LoadFromXMLString(const xml: string; ignoreOptions: boolean = false); virtual;
    { Writes the collection into a binary stream.
      if selectedOnly = @true only items that have
      @link(TSammelobjekt.Selected) = @true are written.
      The binary format should not be used any more. }
    procedure WriteToStream(const outputStream: TStream; selectedOnly: boolean = false); virtual; deprecated;
    { Adds collection items from a binary stream
      (older binary file format).
      Only the new items will have their @link(TSammelobjekt.Selected)
      property set to @true. }
    procedure ReadFromStream(const inputStream: TStream); virtual;

    procedure SchaubildSchalten; virtual;
    { Currently displaying collection item.
      Its properties may be edited. }
    property  Schauobjekt:TSammelobjekt read GetSchauobjekt implements IBildbearbeitung;
    { Currently displaying picture (= @link(Schauobjekt).@link(Bild)). }
    property  Schaubild:TBildobjekt read GetSchaubild;
  published
    { Determines the key property for sorting the list.
      The list is physically resorted upon change. }
    property  Sortierung: TSortierung read FSortierung write SetSortierung;
    { Determines the sort order of the list.
      The list is physically resorted upon change. }
    property  Richtung: shortint read FRichtung write SetRichtung;
    { Determines whether duplicate items referring to the same file may be added
      to the list.
      This affects the @link(AddItem) and @link(InsertItem) methods only. }
    property  AllowDuplicates: boolean read FAllowDuplicates write SetAllowDuplicates;
  end;

  { Exceptions raised by @link(TBilderSammlung.ReadFromStream). }
  ESammlungReadError = class(EKarstenException);

implementation
uses
  Math, Dialogs, XMLDoc, xmldom, oxmldom, comobj, jclFileUtils;

resourcestring
  SEUnknownFileFormat = 'Unknown file format: ' +
    'The file is either not a Karsten Slide Collection or it is corrupt.';
  SEFileFormat = 'Read error: ' +
    'The file is corrupt and cannot be read.';
  SEModernFileFormat = 'Incompatible file format: ' +
    'In order to load this file you need a newer program version.';

{ TBilderSammlung }

constructor TBilderSammlung.Create;
begin
  inherited;
  FList := TObjectList.Create(true);
  FSchauobjektIdx := -1;
  FSortierung := sortKeine;
  FRichtung := 1;
  FAllowDuplicates := true;
end;

destructor TBilderSammlung.Destroy;
begin
  FOnChange := nil;
  FreeAndNil(FList);
  inherited;
end;

procedure TBilderSammlung.BeginUpdate;
begin
  if FUpdateCount = 0 then begin
    FUpdateChanges := [];
    FUpdateItem := nil;
  end;
  Inc(FUpdateCount);
end;

procedure TBilderSammlung.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount = 0 then DoChange([], nil);
end;

procedure TBilderSammlung.DoChange;
begin
  if changes <> [] then begin
    if FUpdateChanges = [] then begin
      FUpdateItem := ChangedItem
    end else begin
      if ChangedItem <> FUpdateItem then FUpdateItem := nil;
    end;
    FUpdateChanges := FUpdateChanges + changes;
  end;
  if FUpdateCount = 0 then begin
    try
      if Assigned(FOnChange) then FOnChange(Self, FUpdateChanges, FUpdateItem);
    finally
      FUpdateChanges := [];
      FUpdateItem := nil;
    end;
  end;
end;

procedure TBilderSammlung.AcceptItemsVisitor(AVisitor: TSammelobjektVisitor);
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
    TSammelobjekt(FList.Items[i]).AcceptVisitor(AVisitor);
end;

function TBilderSammlung.GetCount: integer;
begin
  result := FList.Count;
end;

procedure TBilderSammlung.AddItem;
var
  NewClass: TSammelobjektKlasse;
  NewObj: TSammelobjekt;
begin
  if AllowDuplicates or (IndexOfFile(Item.Pfad) < 0) then begin
    NewClass := TSammelobjektKlasse(Item.ClassType);
    NewObj := NewClass.Create;
    NewObj.Assign(Item);
    NewObj.Selected := true;
    NewObj.OnChange := SammelobjektChange;
    FList.Add(NewObj);
    DoChange([scAddObject], NewObj);
  end;
end;

procedure TBilderSammlung.InsertItem;
var
  NewClass: TSammelobjektKlasse;
  NewObj: TSammelobjekt;
begin
  if AllowDuplicates or (IndexOfFile(Item.Pfad) < 0) then begin
    NewClass := TSammelobjektKlasse(Item.ClassType);
    NewObj := NewClass.Create;
    NewObj.Assign(Item);
    NewObj.Selected := true;
    NewObj.OnChange := SammelobjektChange;
    FList.Insert(index, NewObj);
    DoChange([scAddObject], NewObj);
  end;
end;

procedure TBilderSammlung.ChangeItem;
begin
  if changes <> [] then begin
    BeginUpdate;
    try
      if soaName in changes then Item.Name := Prototyp.Name;
      if soaPfad in changes then Item.Pfad := Prototyp.Pfad;
      if soaWartezeit in changes then Item.Wartezeit := Prototyp.Wartezeit;
      if soaHaeufigkeit in changes then Item.Haeufigkeit := Prototyp.Haeufigkeit;
      if soaBitmapModus in changes then Item.BitmapModus := Prototyp.BitmapModus;
      if soaVergroesserung in changes then Item.Vergroesserung := Prototyp.Vergroesserung;
      if soaHintergrundfarbe in changes then Item.Hintergrundfarbe := Prototyp.Hintergrundfarbe;
      if soaAktiv in changes then Item.Aktiv := Prototyp.Aktiv;
      if soaSchluessel in changes then Item.Schluessel := Prototyp.Schluessel;
      DoChange([scChangeObjectProperty], Item);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TBilderSammlung.SammelobjektChange;
var
  sammlungChanges: TSammlungChanges;
begin
  sammlungChanges := [];
  if changes <> [] then begin
    if soaStatus in changes then
      Include(sammlungChanges, scChangeObjectStatus);
    if (changes - [soaStatus]) <> [] then
      Include(sammlungChanges, scChangeObjectProperty);
    DoChange(sammlungChanges, Sender);
  end;
end;

procedure TBilderSammlung.FreeAll;
begin
  FList.Clear;
  DoChange([scRemoveObject], nil);
end;

procedure TBilderSammlung.FreeSelected;
var
  i: integer;
  Obj: TSammelobjekt;
begin
  BeginUpdate;
  try
    for i := FList.Count - 1 downto 0 do begin
      Obj := Items[i];
      if Obj.Selected then begin
        FList.Delete(i);
        DoChange([scRemoveObject], Obj);
      end;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TBilderSammlung.FreeItem(Item: TSammelobjekt);
begin
  FList.Remove(Item);
  DoChange([scRemoveObject], Item);
end;

function TBilderSammlung.GetSammelItem(index: integer): TSammelobjekt;
begin
  Result := FList.Items[index] as TSammelobjekt;
end;

procedure TBilderSammlung.ResetSelection;
var
  i: integer;
begin
  for i := 0 to FList.Count - 1 do
    TSammelobjekt(FList[i]).Selected := false;
end;

function TBilderSammlung.SumFrequencies;
var
  idx: integer;
  overflow: boolean;
begin
  result := 0;
  if FList.Count > 0 then begin
    repeat
      overflow := false;
      idx := 0;
      repeat // summe so weit möglich berechnen
        if result <= High(integer) - Items[idx].Haeufigkeit then begin
          result := result + Items[idx].Haeufigkeit;
          Inc(idx);
        end else
          overflow := true;
      until (idx >= FList.Count) or overflow;
      if overflow then
        // normalize frequencies
        for idx := 0 to FList.Count - 1 do
          Items[idx].Haeufigkeit := (Items[idx].Haeufigkeit+9) div 10;
    until not overflow;
    { // the following is implied by changing Haeufigkeit through the OnChange event:
    if bUpdate and Assigned(FViewer) and (FViewer.Items.count>0)
    then with FViewer.Items do begin
      for idx := 0 to count-1 do begin
        TSammelobjekt(Item[idx].Data).UpdateViewItem(Item[idx]);
      end;
      FViewer.UpdateItems(0,FViewer.Items.count-1);
    end;}
  end;
end;

procedure TBilderSammlung.SchaubildSchalten;
var
  range, auswahl, vergleich, idx, pass: integer;
  bGefunden: boolean;
begin
  range := SumFrequencies;
  if range>0 then begin
    pass := 0;
    repeat
      auswahl := random(range);
      idx := 0;
      vergleich := 0;
      bGefunden := false;
      repeat
        vergleich := vergleich + Items[idx].Haeufigkeit;
        if auswahl<vergleich then begin
          Items[idx].BildSchalten;
          if Items[idx].CheckBild=bsOK then begin
            FSchauobjektIdx := idx;
            bGefunden := true;
          end else
            Break;
        end;
        Inc(idx);
      until bGefunden or (idx >= FList.Count);
      Inc(pass);
    until bGefunden or (pass >= FList.Count);
  end else
    FSchauobjektIdx := -1;
end;

procedure TBilderSammlung.ReadFromStream;
  function V0302KlassenRef(const name:string):TSammelobjektKlasse;
  begin
    Result := nil;
    if CompareText(name,'TBild')=0 then Result := TSammelbild
    else
      if CompareText(name,'TBildOrdner')=0 then Result := TSammelordner;
  end;

var
  Decoder: TReader;
  Objekt: TSammelobjekt;
  KlassenRef: TSammelobjektKlasse;
  klassenName: string;
  fileVersion: word;
  intvalue: integer;
begin
  Decoder := TReader.Create(InputStream,2048);
  BeginUpdate;
  try
    ResetSelection;
    // check for compatible file format and version
    if not SameText(Decoder.ReadString, cFileFormatName) then
      raise ESammlungReadError.Create(seUnknownFileFormat);
    fileVersion := Decoder.ReadInteger;
    if fileVersion > cFileVersion then
      raise ESammlungReadError.Create(seModernFileFormat);
    // Sortierung and Richtung
    if fileVersion >= 306 then
      intvalue := Decoder.ReadInteger
    else
      intvalue := Ord(sortKeine);
    if (FList.Count = 0) and (Abs(intvalue) <= Ord(High(TSortierung))) then begin
      Sortierung := TSortierung(Abs(intvalue));
      if intvalue <> 0 then Richtung := Sign(intvalue);
    end;
    if fileVersion >= 308 then
      AllowDuplicates := Decoder.ReadBoolean
    else
      AllowDuplicates := true;
    // number of items to read
    if fileVersion >= 307 then begin
      intvalue := Decoder.ReadInteger;
      FList.Capacity := Max(FList.Capacity, FList.Count + intvalue + 10);
    end;
    // read items
    Decoder.ReadListBegin;
    while not Decoder.EndOfList do begin
      klassenName := Decoder.ReadString;
      if fileVersion < 303 then
        klassenRef := V0302KlassenRef(klassenName)
      else
        klassenRef := TSammelobjektKlasse(FindClass(klassenName));
      if KlassenRef <> nil then begin
        Objekt := KlassenRef.Create;
        try
          Objekt.ReadFromFiler(Decoder, fileVersion);
          AddItem(Objekt);
        finally
          FreeAndNil(Objekt);
        end;
      end else
        raise ESammlungReadError.Create(seFileFormat);
    end;
    Decoder.ReadListEnd;
  finally
    Decoder.Free;
    EndUpdate;
  end;
end;

procedure TBilderSammlung.WriteToStream;
var
  Encoder: TWriter;
  idx: integer;
  selcount: integer;
  Item: TSammelobjekt;
begin
  Encoder := TWriter.Create(OutputStream, 2048);
  try
    Encoder.WriteString(cFileFormatName);
    Encoder.WriteInteger(cFileVersion);
    Encoder.WriteInteger(integer(Ord(Sortierung)) * Richtung);
    Encoder.WriteBoolean(AllowDuplicates);
    if selectedOnly then begin
      selcount := 0;
      for idx := 0 to FList.Count - 1 do
        if Items[idx].Selected then
          Inc(selcount);
      Encoder.WriteInteger(selcount);
    end else begin
      Encoder.WriteInteger(FList.Count);
    end;
    Encoder.WriteListBegin;
    for idx := 0 to FList.count - 1 do begin
      Item := Items[idx];
      try
        if not selectedOnly or Item.Selected then begin
          Encoder.WriteString(Item.ClassName);
          Item.WriteToFiler(Encoder);
        end;
      except
        on EAccessViolation do;
      end;
    end;
    Encoder.WriteListEnd;
  finally
    Encoder.Free;
  end;
end;

procedure TBilderSammlung.LoadFromFileOldFormat;
var
  Stream: TStream;
begin
  SetCurrentDir(ExtractFileDir(name));
  Stream := TFileStream.Create(name, fmOpenRead or fmShareDenyWrite);
  try
    ReadFromStream(Stream);
  finally
    Stream.Free;
  end;
  FFileName := name;
end;

procedure TBilderSammlung.LoadFromFile;
begin
  SetCurrentDir(ExtractFileDir(name));
  try
    LoadFromXMLFile(name, false);
  except
    on EDOMParseError do LoadFromFileOldFormat(name);
  end;
end;

procedure TBilderSammlung.LoadFromXMLFile;
var
  Doc: IXMLDocument;
begin
  SetCurrentDir(ExtractFileDir(name));
  Doc := TXMLDocument.Create(name);
  LoadFromXMLDoc(Doc, ignoreOptions);
  FFileName := name;
end;

procedure TBilderSammlung.SaveToFile;
var
  Doc: IXMLDocument;
begin
  SetCurrentDir(ExtractFileDir(name));
  Doc := TXMLDocument.Create(nil);
  SaveToXMLDoc(Doc, selectedOnly);
  try
    Doc.SaveToFile(name);
  except
    on EOleException do begin
      // the XML parser raises an exception
      // if the existing file has the old binary format.
      // delete the old file and try again:
      FileDelete(name, true);
      Doc.SaveToFile(name);
    end;
  end;
end;

procedure TBilderSammlung.LoadFromXMLString;
var
  Doc: IXMLDocument;
begin
  SetCurrentDir(ExtractFileDir(FFileName));
  Doc := TXMLDocument.Create(nil);
  Doc.LoadFromXML(xml);
  LoadFromXMLDoc(Doc, ignoreOptions);
end;

procedure TBilderSammlung.SaveToXMLString;
var
  Doc: IXMLDocument;
begin
  SetCurrentDir(ExtractFileDir(FFileName));
  Doc := TXMLDocument.Create(nil);
  SaveToXMLDoc(Doc, selectedOnly);
  Doc.SaveToXML(xml);
end;

procedure TBilderSammlung.LoadFromXMLDoc;
begin
  BeginUpdate;
  try
    ResetSelection;
    Doc.Options := [doNodeAutoCreate, doNodeAutoIndent, doAutoPrefix, doNamespaceDecl];
    Doc.ParseOptions := [poPreserveWhiteSpace];
    Doc.Active := true;
    if not Doc.IsEmptyDoc and
      SameStr(Doc.DocumentElement.NodeName, 'karstendata')
    then begin
      if not ignoreOptions then LoadXMLOptions(Doc);
      LoadXMLCollection(Doc);
    end;
  finally
    Doc.Active := false;
    EndUpdate;
  end;
end;

procedure TBilderSammlung.SaveToXMLDoc;
begin
  Doc.Options := [doNodeAutoCreate, doNodeAutoIndent, doAutoPrefix, doNamespaceDecl];
  Doc.ParseOptions := [poPreserveWhiteSpace];
  Doc.Active := true;
  if Doc.IsEmptyDoc then
    Doc.AddChild('karstendata')
  else
    Doc.DocumentElement.ChildNodes.Clear;
  Doc.DocumentElement.Attributes['version'] := IntToStr(cFileVersion);
  SaveXMLOptions(Doc, selectedOnly);
  SaveXMLCollection(Doc, selectedOnly);
end;

procedure TBilderSammlung.LoadXMLOptions;
var
  OptionsNode: IXMLNode;
  s: string;
  iSortierung: TSortierung;
begin
  OptionsNode := Doc.DocumentElement.ChildNodes.Nodes['options'];
  if Assigned(OptionsNode) then begin
    s := OptionsNode.ChildNodes.Nodes['sortfield'].Text;
    for iSortierung := Low(TSortierung) to High(TSortierung) do begin
      if SameText(s, SSortierungTags[iSortierung]) then begin
        Sortierung := iSortierung;
        Break;
      end;
    end;
    s := OptionsNode.ChildNodes.Nodes['sortdir'].Text;
    if SameText(s, SRichtungTags[-1]) then
      Richtung := -1
    else
      Richtung := +1;
    s := OptionsNode.ChildNodes.Nodes['duplicates'].Text;
    AllowDuplicates := SameText(s, SBooleanTags[true]);
  end;
end;

procedure TBilderSammlung.SaveXMLOptions;
var
  OptionsNode: IXMLNode;
begin
  if not selectedOnly then
  begin
    OptionsNode := Doc.DocumentElement.AddChild('options');
    OptionsNode.AddChild('sortfield').Text := SSortierungTags[Sortierung];
    OptionsNode.AddChild('sortdir').Text := SRichtungTags[Richtung];
    OptionsNode.AddChild('duplicates').Text := SBooleanTags[AllowDuplicates];
  end;
end;

procedure TBilderSammlung.LoadXMLCollection;
var
  idx: Integer;
  CollectionNode: IXMLNode;
  Item: TSammelobjekt;
  ClassRef: TSammelobjektKlasse;
  ItemNode: IXMLNode;
begin
  CollectionNode := Doc.DocumentElement.ChildNodes.Nodes['collection'];
  if Assigned(CollectionNode) then begin
    FList.Capacity := Max(FList.Capacity, FList.Count + CollectionNode.ChildNodes.Count + 10);
    for idx := 0 to CollectionNode.ChildNodes.Count - 1 do begin
      ItemNode := CollectionNode.ChildNodes.Nodes[idx];
      if ItemNode.LocalName = 'collectionitem' then begin
        ClassRef := TSammelobjektKlasse(GetClass(ItemNode.Attributes['class']));
        if ClassRef <> nil then begin
          Item := ClassRef.Create;
          try
            Item.ReadFromXML(ItemNode);
            AddItem(Item);
          finally
            FreeAndNil(Item);
          end;
        end;
      end;
    end;
  end;
end;

procedure TBilderSammlung.SaveXMLCollection;
var
  ItemNode: IXMLNode;
  Item: TSammelobjekt;
  idx: Integer;
  CollectionNode: IXMLNode;
begin
  CollectionNode := Doc.DocumentElement.AddChild('collection');
  for idx := 0 to FList.Count - 1 do
  begin
    Item := Items[idx];
    if not selectedOnly or Item.Selected then
    begin
      ItemNode := CollectionNode.AddChild('collectionitem');
      ItemNode.Attributes['class'] := Item.ClassName;
      Item.WriteToXML(ItemNode);
    end;
  end;
end;

function TBilderSammlung.GetSchauobjekt: TSammelobjekt;
begin
  Result := Items[fSchauobjektIdx];
end;

function TBilderSammlung.GetSchaubild: TBildobjekt;
begin
  Result := Schauobjekt.Bild;
end;

procedure QuickSort(SortList: PPointerList; L, R: Integer;
  SCompare: TListSortCompareEx);
var
  I, J: Integer;
  P, T: Pointer;
begin
  repeat
    I  :=  L;
    J  :=  R;
    P  :=  SortList^[(L + R) shr 1];
    repeat
      while SCompare(SortList^[I], P) < 0 do Inc(I);
      while SCompare(SortList^[J], P) > 0 do Dec(J);
      if I <= J then
      begin
        T  :=  SortList^[I];
        SortList^[I]  :=  SortList^[J];
        SortList^[J]  :=  T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(SortList, L, J, SCompare);
    L  :=  I;
  until I >= R;
end;

procedure TBilderSammlung.Sort;
begin
  if (FList.Count > 0) and (Sortierung <> sortKeine) then begin
    BeginUpdate;
    try
      FList.Pack;
      QuickSort(FList.List, 0, FList.Count - 1, ObjektVergleich);
      DoChange([scChangeOrder], nil);
    finally
      EndUpdate;
    end;
  end;
end;

function TBildersammlung.ObjektVergleich(Obj1, Obj2: TSammelobjekt): integer;
begin
  case Sortierung of
    sortKeine:       result := FList.IndexOf(Obj1) - FList.IndexOf(Obj2);
    sortName:        result := CompareText(Obj1.Name, Obj2.Name);
    sortDateiname:   result := CompareText(ExtractFileName(Obj1.Pfad), ExtractFileName(Obj2.Pfad));
    sortDateipfad:   result := CompareText(Obj1.Pfad, Obj2.Pfad);
    sortWartezeit:   result := integer(Obj1.Wartezeit) - integer(Obj2.Wartezeit);
    sortHaeufigkeit: result := integer(Obj1.Haeufigkeit) - integer(Obj2.Haeufigkeit);
    sortSequence:    result := Obj1.SequenceNumber - Obj2.SequenceNumber;
    else             result := 0;
  end;
  result := result * fRichtung;
end;

procedure TBilderSammlung.RenumberSequence;
var
  RSS: TRenumberSammelobjektSequence;
  FirstPos: integer;
begin
  BeginUpdate;
  try
    if FRichtung >= 0 then
      FirstPos := 0
    else
      FirstPos := Count - 1;
    RSS := TRenumberSammelobjektSequence.Create(FirstPos, FRichtung);
    try
      AcceptItemsVisitor(RSS);
    finally
      RSS.Free;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TBilderSammlung.SetSortierung(const Value: TSortierung);
begin
  if FSortierung <> value then begin
    BeginUpdate;
    try
      FSortierung := Value;
      DoChange([scChangeProperty], nil);
      if FSortierung <> sortKeine then begin
        Sort;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TBilderSammlung.SetRichtung(const Value: shortint);
begin
  if FRichtung * value < 0 then begin
    BeginUpdate;
    try
      FRichtung := Value;
      DoChange([scChangeProperty], nil);
      if FSortierung <> sortKeine then begin
        Sort;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TBilderSammlung.SetAllowDuplicates(const Value: boolean);
begin
  if Value xor FAllowDuplicates then begin
    FAllowDuplicates := Value;
    DoChange([scChangeProperty], nil);
  end;
end;

function TBilderSammlung.IndexOf(Item: TSammelobjekt): integer;
begin
  result := FList.IndexOf(Item);
end;

function TBilderSammlung.IndexOfFile(const path: string): integer;
var
  hash: THashValue;
  i: integer;
  Item: TSammelobjekt;
begin
  hash := TextHash(path);
  result := -1;
  for i := 0 to FList.Count - 1 do begin
    Item := Items[i];
    if (Item.PfadHash = hash) and (SameFileName(Item.Pfad, path)) then begin
      result := i;
      Break;
    end;
  end;
end;

function TBilderSammlung.IndexOfID(ID: integer): integer;
var
  i: integer;
begin
  { TODO 3 -cperformance : what about using a lookup table or binary search for sammelobjekt IDs? }
  result := -1;
  for i := 0 to FList.Count - 1 do
    if Items[i].ID = ID then begin
      result := i;
      Break;
    end;
end;

function TBilderSammlung.GetPendingFiles: cardinal;
var
  i: integer;
begin
  result := 0;
  for i := 0 to FList.Count - 1 do
    if Items[i].BildStatus = bsPending then Inc(result);
end;

initialization
  DefaultDOMVendor := OpenXMLFactory.Description;
end.

