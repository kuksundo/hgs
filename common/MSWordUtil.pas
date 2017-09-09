UNIT MSWordUtil;

interface

uses SysUtils, StdCtrls,Classes, Graphics, Db, Grids, DBGrids, ComObj, ActiveX,
      AxCtrls;

procedure DBGridToWord (Grid :TDBGrid ; FormatNum :integer);
function FindTextInFile(const FileName, TextToFind: WideString): boolean;
function GetInstalledWordVersion: Integer;

implementation

//DBGrid의 내용을 MSWord의 테이블에 넣어주는 함수
procedure DBGridToWord (Grid :TDBGrid ; FormatNum :integer);
var
  x :integer ;
  y: integer ;
  Word : Olevariant ;
  GColCount : integer ;
  GRowCount : integer;
begin
  Word := CreateOLEobject('Word.Application') ;
  Word.Visible := True ;
  Word.Documents.Add ;
  GColCount := Grid.Columns.Count ;
  GRowCount := Grid.DataSource.DataSet.RecordCount ;
  Word.ActiveDocument.Range.Font.Size := Grid.Font.Size;
  Word.ActiveDocument.PageSetup.Orientation := 1 ;
  Word.ActiveDocument.Tables.Add( Word.ActiveDocument.Range,GRowCount+1,GColCount);
  Word.ActiveDocument.Range.InsertAfter('Date ' + Datetimetostr(Now));
  Word.ActiveDocument.Range.Tables.Item(1).AutoFormat(FormatNum,1,1,1,1,1,0,0,0,1);

  for y := 1 to GColCount do
    Word.ActiveDocument.Tables.Item(1).Cell(1,y).Range.InsertAfter(Grid.Columns[y-1].Title.Caption) ;

  x :=1 ;

  with Grid.DataSource.DataSet do
  begin
    First ;
    while not Eof do
    begin
      x := x + 1 ;
      for y := 1 to GColCount do
        Word.ActiveDocument.Tables.Item(1).Cell(x,y).Range.InsertAfter(FieldByName(Grid.Columns[y-1].FieldName).Asstring);
      Next ;
    end;
  end;

  Word.ActiveDocument.Range.Tables.Item(1).UpdateAutoFormat ;
end;

//COM의 Automation을 이용한 DOC 파일을 TXT 파일로
// 단, 노턴 안티바이러스 프로그램이 깔렸을 경우 불가능하다.
procedure ConvertDocToTxt(AFileName: string);
var
  MSWord: Variant;
const
  wdDoNotSaveChanges = $00;
  wdFormatText = $02;
begin
  Screen.Cursor := crHourGlass;

  MSWord := CreateOleObject('Word.Application');
  MSWord.Documents.Open(AFileName);
  MSWord.Documents.Item(1).SaveAs(ChangeFileExt
                               (AFileName, '.txt'), wdFormatText);
  MSWord.Documents.Item(1).Close(wdPromptToSaveChanges);
  MSWord.Quit;
  MSWord := VarNull;

  Screen.Cursor := crDefault;
end;

function FindTextInFile(const FileName, TextToFind: WideString): boolean; 
var Root: IStorage; 
    EnumStat: IEnumStatStg; 
    Stat: TStatStg; 
    iStm: IStream; 
    Stream: TOleStream; 
    DocTextString: WideString; 
begin 
  Result:=False;

  if not FileExists(FileName) then Exit;

  // Check to see if it's a structured storage file
  if StgIsStorageFile(PWideChar(FileName)) <> S_OK then Exit;

  // Open the file
  OleCheck(StgOpenStorage(PWideChar(FileName), nil,
            STGM_READ or STGM_SHARE_EXCLUSIVE, nil, 0, Root));

  // Enumerate the storage and stream objects contained within this file
  OleCheck(Root.EnumElements(0, nil, 0, EnumStat));

  // Check all objects in the storage
  while EnumStat.Next(1, Stat, nil) = S_OK do

    // Is it a stream with Word data
    if Stat.pwcsName = 'WordDocument' then

      // Try to get the stream "WordDocument"
      if Succeeded(Root.OpenStream(Stat.pwcsName, nil,
                    STGM_READ or STGM_SHARE_EXCLUSIVE, 0, iStm)) then
      begin
        Stream:=TOleStream.Create(iStm);
        try
          if Stream.Size > 0 then
          begin
            // Move text data to string variable
            SetLength(DocTextString, Stream.Size);
            Stream.Position:=0;
            Stream.Read(pChar(DocTextString)^, Stream.Size);

            // Find a necessary text
            Result:=(Pos(TextToFind, DocTextString) > 0);
          end;
        finally
          Stream.Free;
        end;
        Exit;
      end;
end;

procedure StringGrid2MSWordTable;
var
  WordApp, NewDoc, WordTable: OLEVariant;
  iRows, iCols, iGridRows, jGridCols: Integer;
begin
  try
    // Create a Word Instance
    // Word Instanz erzeugen
    WordApp := CreateOleObject('Word.Application');
  except
    // Error...
    // Fehler....
    Exit;
  end;

  // Show Word
  // Word anzeigen
  WordApp.Visible := True;

  // Add a new Doc
  // Neues Dok einfugen
  NewDoc := WordApp.Documents.Add;

  // Get number of columns, rows
  // Spalten, Reihen ermitteln
  iCols := StringGrid1.ColCount;
  iRows := StringGrid1.RowCount;

  // Add a Table
  // Tabelle einfugen
  WordTable := NewDoc.Tables.Add(WordApp.Selection.Range, iCols, iRows);

  // Fill up the word table with the Stringgrid contents
  // Tabelle ausfullen mit Stringgrid Daten
  for iGridRows := 1 to iRows do
    for jGridCols := 1 to iCols do
      WordTable.Cell(iGridRows, jGridCols).Range.Text :=
        StringGrid1.Cells[jGridCols - 1, iGridRows - 1];

  // Here you might want to Save the Doc, quit Word...
  // Hier evtl Word Doc speichern, beenden...

  // ...
  
  // Cleanup...
  WordApp := Unassigned;
  NewDoc := Unassigned;
  WordTable := Unassigned;
end;

{
const
  Wordversion97 = 8;
  Wordversion2000 = 9;
  WordversionXP = 10;
  Wordversion2003 = 11;
}

function GetInstalledWordVersion: Integer;
var
  word: OLEVariant;
begin
  word := CreateOLEObject('Word.Application');
  result := word.version;
  word.Quit;
  word := UnAssigned;
end;

end.

