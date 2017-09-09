unit w_LargeTextViewer;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Grids,
  c_dzVirtualStringGrid,
  u_dzTranslator,
  u_TextFileIndexer,
  u_dzNamedThread,
  u_dzFileStreams,
  ExtCtrls,
  ComCtrls,
  Menus;

type
  TIndexerThread = class(TNamedThread)
  private
    FIndexer: TTextFileIndexer;
  protected
    constructor Create(_Indexer: TTextFileIndexer);
    procedure Execute; override;
  end;

type
  Tf_LargeTextViewer = class(TForm)
    sg_Display: TdzVirtualStringGrid;
    tim_Update: TTimer;
    TheStatusBar: TStatusBar;
    TheMainMenu: TMainMenu;
    mi_File: TMenuItem;
    mi_Open: TMenuItem;
    mi_Exit: TMenuItem;
    TheOpenDialog: TOpenDialog;
    procedure sg_DisplayGetNonfixedCellData(_Sender: TObject; _DataCol, _DataRow: Integer;
      _State: TGridDrawState; var _Text: string; var _HAlign: TAlignment;
      var _VAlign: TdzCellVertAlign; _Font: TFont; var _Color: TColor);
    procedure sg_DisplayResize(Sender: TObject);
    procedure tim_UpdateTimer(Sender: TObject);
    procedure mi_OpenClick(Sender: TObject);
    procedure mi_ExitClick(Sender: TObject);
  private
    FIndexer: TTextFileIndexer;
    FIndexThread: TIndexerThread;
    FFile: TdzFile;
    procedure OpenFile;
  public
    constructor Create(_Owner: TComponent); override;
    destructor Destroy; override;
    procedure LoadFile(const _Filename: string);
  end;

var
  f_LargeTextViewer: Tf_LargeTextViewer;

implementation

{$R *.dfm}

uses
  u_dzClassUtils;

{ TIndexerThread }

constructor TIndexerThread.Create(_Indexer: TTextFileIndexer);
begin
  FIndexer := _Indexer;
  inherited Create(false);
end;

procedure TIndexerThread.Execute;
begin
  inherited;
  try
    FIndexer.Execute;
  except
    on EAbort do
    // itnore;
  else
    raise;
  end;
end;

constructor Tf_LargeTextViewer.Create(_Owner: TComponent);
begin
  inherited;
  OpenFile;
end;

destructor Tf_LargeTextViewer.Destroy;
begin
  FreeAndNil(FFile);
  if Assigned(FIndexer) then
    FIndexer.Abort;
  FreeAndNil(FIndexThread);
  inherited;
end;

procedure Tf_LargeTextViewer.LoadFile(const _Filename: string);
begin
  FIndexer := TTextFileIndexer.Create(_Filename);
  FIndexThread := TIndexerThread.Create(FIndexer);
  tim_Update.Enabled := true;
  FFile := TdzFile.Create(_Filename);
  FFile.OpenReadonly;
end;

procedure Tf_LargeTextViewer.mi_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure Tf_LargeTextViewer.OpenFile;
begin
  TheOpenDialog.Filter := 'all files (*.*)|*.*';
  if not TheOpenDialog.Execute then
    exit;
  LoadFile(TheOpenDialog.FileName);
end;

procedure Tf_LargeTextViewer.mi_OpenClick(Sender: TObject);
begin
  OpenFile;
end;

procedure Tf_LargeTextViewer.sg_DisplayGetNonfixedCellData(_Sender: TObject; _DataCol, _DataRow: Integer;
  _State: TGridDrawState; var _Text: string; var _HAlign: TAlignment; var _VAlign: TdzCellVertAlign;
  _Font: TFont; var _Color: TColor);
var
  SeekIdx: Int64;
  s: string;
begin
  if not Assigned(FIndexer) or (FIndexer.LineIndexCount < _DataRow) then
    exit;
  SeekIdx := FIndexer.LineIndex[_DataRow];
  FFile.Position := SeekIdx;
  TStream_ReadStringLn(FFile, s);
  _Text := s;
end;

procedure Tf_LargeTextViewer.sg_DisplayResize(Sender: TObject);
begin
  sg_Display.ColWidths[0] := sg_Display.ClientWidth;
end;

procedure Tf_LargeTextViewer.tim_UpdateTimer(Sender: TObject);
var
  LineCount: integer;
begin
  LineCount := FIndexer.LineIndexCount;
  sg_Display.RowCount := LineCount;
  if FIndexer.isDone then begin
    tim_Update.Enabled := false;
    TheStatusBar.SimpleText := Format(_('%d lines'), [LineCount]);
  end else
    TheStatusBar.SimpleText := Format(_('Indexing (%d lines)'), [LineCount]);
end;

end.

