unit UnitMSWordUtil;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ComObj,
  Vcl.StdCtrls, Vcl.Mask, JvExMask, JvToolEdit,
  Vcl.ComCtrls, Vcl.ExtCtrls, Word2010, Vcl.Menus, ActiveX;

// Replace Flags
type
   TWordReplaceFlags = set of (wrfReplaceAll, wrfMatchCase, wrfMatchWildcards);

const
   wdFindContinue = 1;
   wdReplaceOne = 1;
   wdReplaceAll = 2;
   wdDoNotSaveChanges = 0;

function GetActiveMSWordOleObject(ADocument: TFileName; AVisible: boolean) : Variant;
function Word_StringReplace(ADocument: TFileName; SearchString, ReplaceString: string;
  Flags: TWordReplaceFlags): Boolean;
function Word_StringReplace2(WordApp: OLEVariant; SearchString, ReplaceString: string;
  Flags: TWordReplaceFlags): Boolean;
function Word_InsertImageFromClipboard(WordApp: OLEVariant;
  ATableIndex: integer=1; ACol: integer=1; ARow: integer=1): string;
procedure Word_InsertImageToCellFromClipboard(ACell: OLEVariant);
function Word_AddHeaderAndFooter(WordApp: OLEVariant; AHeaderText, AFooterText: String): string;
function Word_StringReplaceFooter(WordApp: OLEVariant; SearchString, ReplaceString: string;
  Flags: TWordReplaceFlags): Boolean;

implementation

function GetActiveMSWordOleObject(ADocument: TFileName; AVisible: boolean) : Variant;
//var
//   WordApp: OLEVariant;
begin
   { Check if file exists }
   if not FileExists(ADocument) then
   begin
     ShowMessage('Specified Document not found.');
     Exit;
   end;

   { Create the OLE Object }
   try
     Result := CreateOLEObject('Word.Application');
   except
     on E: Exception do
     begin
       E.Message := 'Word is not available.';
       raise;
     end;
   end;

   { Hide Word }
   Result.Visible := AVisible;
   { Open the document }
   Result.Documents.Open(ADocument);
end;

//¿¹:Word_StringReplace('C:\Test.doc','Old String','New String',[wrfReplaceAll]);
function Word_StringReplace(ADocument: TFileName; SearchString, ReplaceString: string;
  Flags: TWordReplaceFlags): Boolean;
var
   WordApp: OLEVariant;
begin
   Result := False;

   { Check if file exists }
   if not FileExists(ADocument) then
   begin
     ShowMessage('Specified Document not found.');
     Exit;
   end;

   { Create the OLE Object }
   try
     WordApp := CreateOLEObject('Word.Application');
   except
     on E: Exception do
     begin
       E.Message := 'Word is not available.';
       raise;
     end;
   end;

   try
     { Hide Word }
//     WordApp.Visible := False;
     { Open the document }
     WordApp.Documents.Open(ADocument);
     { Initialize parameters}
     WordApp.Selection.Find.ClearFormatting;
     WordApp.Selection.Find.Text := SearchString;
     WordApp.Selection.Find.Replacement.Text := ReplaceString;
     WordApp.Selection.Find.Forward := True;
     WordApp.Selection.Find.Wrap := wdFindContinue;
     WordApp.Selection.Find.Format := False;
     WordApp.Selection.Find.MatchCase := wrfMatchCase in Flags;
     WordApp.Selection.Find.MatchWholeWord := False;
     WordApp.Selection.Find.MatchWildcards := wrfMatchWildcards in Flags;
     WordApp.Selection.Find.MatchSoundsLike := False;
     WordApp.Selection.Find.MatchAllWordForms := False;
     { Perform the search}
     if wrfReplaceAll in Flags then
       WordApp.Selection.Find.Execute(Replace := wdReplaceAll)
     else
       WordApp.Selection.Find.Execute(Replace := wdReplaceOne);
     { Save word }
//     WordApp.ActiveDocument.SaveAs(ADocument);
     { Assume that successful }
     Result := True;
     { Close the document }
//     WordApp.ActiveDocument.Close(wdDoNotSaveChanges);
   finally
     { Quit Word }
//     WordApp.Quit;
//     WordApp := Unassigned;
   end;
end;

function Word_StringReplace2(WordApp: OLEVariant; SearchString, ReplaceString: string;
  Flags: TWordReplaceFlags): Boolean;
begin
  WordApp.Selection.Find.ClearFormatting;
  WordApp.Selection.Find.Text := SearchString;
  WordApp.Selection.Find.Replacement.Text := ReplaceString;
  WordApp.Selection.Find.Forward := True;
  WordApp.Selection.Find.Wrap := wdFindContinue;
  WordApp.Selection.Find.Format := False;
  WordApp.Selection.Find.MatchCase := wrfMatchCase in Flags;
  WordApp.Selection.Find.MatchWholeWord := False;
  WordApp.Selection.Find.MatchWildcards := wrfMatchWildcards in Flags;
  WordApp.Selection.Find.MatchSoundsLike := False;
  WordApp.Selection.Find.MatchAllWordForms := False;

  { Perform the search}
  if wrfReplaceAll in Flags then
   WordApp.Selection.Find.Execute(Replace := wdReplaceAll)
  else
   WordApp.Selection.Find.Execute(Replace := wdReplaceOne);
end;

function Word_InsertImageFromClipboard(WordApp: OLEVariant;
  ATableIndex: integer=1; ACol: integer=1; ARow: integer=1): string;
var
  i,j: integer;
  LWordDocument: Variant;//WordDocument;
  LTable, LCell: Variant;//Shapes;//Variant;
//  LParagraphs:Paragraphs;
//  LParagraph: Paragraph;
begin
//  Word_StringReplace2(WordApp, 'QRCode', '', []);
//  WordApp.Selection.Paste;
  LWordDocument := WordApp.ActiveDocument;

  LTable := LWordDocument.Tables.Item(ATableIndex);
  LCell := LTable.Cell(ACol,ARow);
  Word_InsertImageToCellFromClipboard(LCell);
//  LCell.Range.Paste;

//  Result := IntToStr(LCell.Range.InLineShapes.Count);
//  for i := 1 to LWordDocument.InlineShapes.Count do
//  for i := 1 to LWordDocument.Shapes.Count do
//  for i := 1 to LWordDocument.BookMarks.Count do
//;  for i := 1 to LCell.Range.InLineShapes.Count do
//;  begin
//;    LTable := LCell.Range.InLineShapes.Item(i);
//    LShape := LWordDocument.BookMarks.Item(i);
//    LShape := LWordDocument.Tables.Item(1);
//    LCell := LShape.Cell(1,1);
//    LCell.Range.Paste;
//    LCell.Range.Selection.Height := 2;
//    LCell.Range.Selection.Width := 2;

//    if LInlineShape.Title = 'Emblem' then
//    else
//    Result := LShape.Title;
//    if Result <> '' then
//      Continue;

//    if LShape.Name = 'QRCode' then
//    if LShape.Name = 'Picture 3' then
//    begin
//      Result := FLoatToStr(LShape.Width);// := 2;//RelativeHorizontalSize
//      Result := FLoatToStr(LShape.Height);// := 2;//RelativeVerticalSize
//;      LTable.Width := 57;//RelativeHorizontalSize
//;      LTable.Height:= 57;//RelativeVerticalSize
//      LShape.Select;
//      WordApp.Selection.Paste;
//      LShape.Range.Paste;
//      Exit;
//    end;
//;  end;
end;

procedure Word_InsertImageToCellFromClipboard(ACell: OLEVariant);
var
  LShape: Variant;
begin
  ACell.Range.Paste;
  LShape := ACell.Range.InLineShapes.Item(1);
  LShape.Width := 57;
  LShape.Height:= 57;
end;

function Word_AddHeaderAndFooter(WordApp: OLEVariant; AHeaderText, AFooterText: String): string;
begin
  WordApp.ActiveDocument.Sections.Item(1).Headers.Item(1).Range.Select;
  WordApp.Selection.ParagraphFormat.TabStops.ClearAll;
  WordApp.Selection.TypeText(AHeaderText);
  WordApp.ActiveDocument.Sections.Item(1).Footers.Item(1).Range.Select;
  WordApp.Selection.ParagraphFormat.TabStops.ClearAll;
  WordApp.Selection.TypeText(AFooterText);

  Result := '';
end;

function Word_StringReplaceFooter(WordApp: OLEVariant; SearchString, ReplaceString: string;
  Flags: TWordReplaceFlags): Boolean;
begin
  WordApp.ActiveDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).Range.Select;
  WordApp.Selection.Find.ClearFormatting;
  WordApp.Selection.Find.Text := SearchString;
  WordApp.Selection.Find.Replacement.Text := ReplaceString;
  WordApp.Selection.Find.Forward := True;
  WordApp.Selection.Find.Wrap := wdFindContinue;
  WordApp.Selection.Find.Format := False;
  WordApp.Selection.Find.MatchCase := wrfMatchCase in Flags;
  WordApp.Selection.Find.MatchWholeWord := False;
  WordApp.Selection.Find.MatchWildcards := wrfMatchWildcards in Flags;
  WordApp.Selection.Find.MatchSoundsLike := False;
  WordApp.Selection.Find.MatchAllWordForms := False;

  { Perform the search}
  if wrfReplaceAll in Flags then
   WordApp.Selection.Find.Execute(Replace := wdReplaceAll)
  else
   WordApp.Selection.Find.Execute(Replace := wdReplaceOne);

  WordApp.ActiveWindow.View.Type := wdPrintView;
//  WordApp.ActiveDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).Range.Find.ClearFormatting;
//  WordApp.ActiveDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).Range.Find.Text := SearchString;
//  WordApp.ActiveDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).Range.Find.Replacement.Text := ReplaceString;
//  WordApp.ActiveDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).Range.Find.Forward := True;
//  WordApp.ActiveDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).Range.Find.Wrap := wdFindContinue;
//  WordApp.ActiveDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).Range.Find.Format := False;
//  WordApp.ActiveDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).Range.Find.MatchCase := wrfMatchCase in Flags;
//  WordApp.ActiveDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).Range.Find.MatchWholeWord := False;
//  WordApp.ActiveDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).Range.Find.MatchWildcards := wrfMatchWildcards in Flags;
//  WordApp.ActiveDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).Range.Find.MatchSoundsLike := False;
//  WordApp.ActiveDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).Range.Find.MatchAllWordForms := False;

//  if wrfReplaceAll in Flags then
//   WordApp.ActiveDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).Range.Find.Execute(Replace := wdReplaceAll)
//  else
//   WordApp.ActiveDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).Range.Find.Execute(Replace := wdReplaceOne);
end;

end.
