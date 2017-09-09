{ unit ExportXMLs

  Export the database as XML (partially implemented)

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit ExportXMLs;

interface

uses
  Windows, Classes, SysUtils, guiFeedback, RxCtrls;

type

  TXMLOptions = record
    Files: TRxCheckListBox;
  end;

const

  cComma = ',';
  cCRLF = #13#10;

function ExportXMLReportToFile(S: TStream; AList: TList; Options: TXMLOptions; AFeedback: TFeedback): integer;

implementation

uses
  sdItems, guiExportFormat, sdProperties;

function ExportXMLReportToFile(S: TStream; AList: TList; Options: TXMLOptions; AFeedback: TFeedback): integer;
procedure WriteS(Info: string);
begin
  Info := Info + #13#10;
  S.Write(Info[1], Length(Info));
end;
procedure WriteNV(Indent: integer; AName, AValue: string);
var
  i: integer;
  Info: string;
begin
  Info := '';
  for i := 1 to Indent do
    Info := Info + ' ';
  Info := Format('%s<%s>%s</%s>', [Info, AName, AValue, AName]);
  WriteS(Info);
end;
procedure WriteNVNotEmpty(Indent: integer; AName, AValue: string);
  begin
    if length(AValue)>0 then
      WriteNV(Indent, AName, AValue);
  end;
var
  i: integer;
begin
  Result := esInitError;
  if not assigned(AList) or not assigned(AList)then
    exit;

  // XML descriptor
  WriteS('<?xml version="1.0" ?>');
  WriteS('<COLLECTION>');

  // Loop through the items
  for i := 0 to AList.Count - 1 do
  begin
    if TsdItem(AList[i]).ItemType = itFile then
    with TsdFile(AList[i]) do
    begin
      // Export this item
      if assigned(AFeedback) then
      begin
        AFeedback.Info := Format('Exporting %s',[Name]);
        AFeedback.Progress := i / AList.Count * 100;
      end;
      WriteS(Format('  <FILE REF="%s">', [GuidToString(Guid)]));
      if Options.Files.Checked[0] then WriteNV(4, 'NAME', Name);
      if Options.Files.Checked[1] then WriteNV(4, 'SIZE', SizeAsString);
      if Options.Files.Checked[2] then WriteNV(4, 'TYPE', TypeAsString);
      if Options.Files.Checked[3] then WriteNV(4, 'MODIFIED', ModifiedAsString);
      if Options.Files.Checked[4] then WriteNV(4, 'FOLDERREF', GuidToString(FolderGuid));
      if Options.Files.Checked[5] then WriteNV(4, 'FOLDER', FolderName);
      if Options.Files.Checked[6] then WriteNV(4, 'STATUS', StatusString);
      if Options.Files.Checked[7] then WriteNV(4, 'SERIES', SeriesAsString);
      if Options.Files.Checked[8] then WriteNV(4, 'RATING', RatingAsString);
      if Options.Files.Checked[9] then WriteNV(4, 'GROUPS', GroupsAsString);
      if Options.Files.Checked[10] then WriteNVNotEmpty(4, 'CRC32', CRCAsString);
      if Options.Files.Checked[11] then WriteNVNotEmpty(4, 'DIMENSIONS', Dimensions);
      if Options.Files.Checked[11] then WriteNVNotEmpty(4, 'COMPR_RATIO', ComprRatioAsString);
      if Options.Files.Checked[12] then WriteNV(4, 'ORIGNAME', OriginalName);
      if Options.Files.Checked[13] then WriteNVNotEmpty(4, 'DESCRIPTION', Description);
        // To do: user fields
      WriteS('  </FILE>');
      // To do: add folders
    end;
  end;
  WriteS('</COLLECTION>');
  if assigned(AFeedback) then
    AFeedback.Status := tsCompleted;
end;

end.
