{ unit ExportCSVs

  Export database in CSV (comma-delimited) format

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit ExportCSVs;

interface

uses
  Windows, Classes, SysUtils, guiFeedback, RxCtrls;

type

  TCSVOptions = record
    FSubFormat: integer;
    FBaseFolder: string;
    FFiles: TRxCheckListBox;
    FDelim: string;
    FUseQuotes: boolean;
  end;

const

  cComma = ',';
  cCRLF = #13#10;

function ExportCSVReportToFile(S: TStream; AList: TList; Options: TCSVOptions; AFeedback: TFeedback): integer;

implementation

uses
  sdItems, guiExportFormat;

function DoHunterCSV(S: TStream; AList: TList; Options: TCSVOptions; AFeedback: TFeedback): integer;
var
  i: integer;
  Line: string;
  CRCStr: string;
  Path: string;
begin
  Result := esInitError;
  if not assigned(AList) or not assigned(AList)then
    exit;

  // Export to Hunter CSV format
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
      Line := '';

      // FileName
      Line := Line + Name;
      // FileSize
      Line := Line + cComma + IntToStr(Size);
      // File CRC
      if not (isCRCDone in States) then
        CalculateCRCValue;
      if isCRCDone in States then
        CRCStr := LowerCase(Format('%.8x', [Crc]))
      else
        CRCStr := '';
      Line := Line + cComma + CRCStr;
      // File path
      try
        Path := '\' + ExtractRelativePath(Options.FBaseFolder, ExtractFilePath(FileName));
        Line := Line + cComma + Path;
      except
        Line := Line + cComma;
      end;
      // "Unknown"
      Line := Line + cComma + 'Unknown';

      // Output line
      S.Write(Line[1], length(Line));
      S.Write(cCRLF[1], length(cCRLF));

    end;
  end;
  Result := esOK;
  if assigned(AFeedback) then
    AFeedback.Status := tsCompleted;
end;

function DoCustomCSV(S: TStream; AList: TList; Options: TCSVOptions; AFeedback: TFeedback): integer;
var
  i: integer;
  Cols: TStringList;
  Line: string;
  function Cell(AItem: string): string;
  begin
    if Options.FUseQuotes then
      Result := AnsiQuotedStr(AItem, '"')
    else
      Result := AItem;
  end;
  function ReportLine(Cols: TStringList): string;
  var
    i: integer;
  begin
    // Create line
    Result := '';
    if Cols.Count > 0 then
    begin
      Result := Cell(Cols[0]);
      for i := 1 to Cols.Count - 1 do
        Result := Result + Options.FDelim + Cell(Cols[i]);
    end;
  end;
begin
  Result := esInitError;
  if not assigned(AList) or not assigned(AList)then
    exit;

  // Loop through the items
  for i := 0 to AList.Count - 1 do
  begin
    if TsdItem(AList[i]).ItemType = itFile then
    with TsdFile(AList[i]) do
    begin
      // Our current line
      Cols := TStringList.Create;
      try
        // Export this item
        if assigned(AFeedback) then
        begin
          AFeedback.Info := Format('Exporting %s',[Name]);
          AFeedback.Progress := i / AList.Count * 100;
        end;
        // Export these fields
        if Options.FFiles.Checked[0]  then Cols.Add(Name);
        if Options.FFiles.Checked[1]  then Cols.Add(SizeAsString);
        if Options.FFiles.Checked[2]  then Cols.Add(TypeAsString);
        if Options.FFiles.Checked[3]  then Cols.Add(ModifiedAsString);
        if Options.FFiles.Checked[4]  then Cols.Add(GuidToString(FolderGuid));
        if Options.FFiles.Checked[5]  then Cols.Add(FolderName);
        if Options.FFiles.Checked[6]  then Cols.Add(StatusString);
        if Options.FFiles.Checked[7]  then Cols.Add(SeriesAsString);
        if Options.FFiles.Checked[8]  then Cols.Add(RatingAsString);
        if Options.FFiles.Checked[9]  then Cols.Add(GroupsAsString);
        if Options.FFiles.Checked[10] then Cols.Add(CRCAsString);
        if Options.FFiles.Checked[11] then Cols.Add(Dimensions);
        if Options.FFiles.Checked[11] then Cols.Add(ComprRatioAsString);
        if Options.FFiles.Checked[12] then Cols.Add(OriginalName);
        if Options.FFiles.Checked[13] then Cols.Add(Description);
        // To do: add user fields
        Line := ReportLine(Cols);
        // Write line
        S.Write(Line[1], Length(Line));
        // Write separator
        S.Write(cCRLF[1], length(cCRLF));
      finally
        Cols.Free;
      end;
      // To do: add folders
    end;
  end;
  Result := esOK;
  if assigned(AFeedback) then
    AFeedback.Status := tsCompleted;
end;

function ExportCSVReportToFile(S: TStream; AList: TList; Options: TCSVOptions; AFeedback: TFeedback): integer;
begin
  case Options.FSubFormat of
  0: Result := DoHunterCSV(S, AList, Options, AFeedback); // Hunter style
  1: Result := DoCustomCSV(S, AList, Options, AFeedback); // Custom style
  else
    Result := esInitError;
  end;//case
end;

end.
