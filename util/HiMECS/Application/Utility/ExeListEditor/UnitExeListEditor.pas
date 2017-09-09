unit UnitExeListEditor;

interface

{$include DragDrop.inc}

uses
  DragDrop,
  DropTarget,
  DropSource,
  DragDropFile,
  ImgList,
  ComCtrls, ActiveX, ShlObj, ComObj, Controls, ShellCtrls, Menus, ExtCtrls,
  StdCtrls, Classes, Forms, Graphics, Windows, CheckLst, JvExCheckLst,
  JvCheckListBox, DragDropText, HiMECSExeCollect, Dialogs, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid;

type
  // Hack to avoid having to install the design time shell controls
  TTreeView = class(TShellTreeView);

  TListView = class(TShellListView)
  published
    property Columns stored False;
  end;

  TfrmBPLListeditor = class(TForm)
    StatusBar1: TStatusBar;
    DropSource1: TDropFileSource;
    ImageListMultiFile: TImageList;
    PopupMenu1: TPopupMenu;
    MenuCopy: TMenuItem;
    ImageListSingleFile: TImageList;
    DataFormatAdapterFile: TDataFormatAdapter;
    DropTextTarget1: TDropTextTarget;
    Button1: TButton;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    NextGrid1: TNextGrid;
    NxCheckBoxColumn1: TNxCheckBoxColumn;
    NxTextColumn1: TNxTextColumn;
    Panel1: TPanel;
    ShellTreeView1: TTreeView;
    ListView1: TListView;
    Panel2: TPanel;
    Button4: TButton;
    Button3: TButton;
    Panel3: TPanel;
    btnClose: TButton;
    Splitter1: TSplitter;
    NxNumberColumn1: TNxNumberColumn;
    NxTextColumn2: TNxTextColumn;
    procedure ListView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure DropSource1Feedback(Sender: TObject; Effect: Integer;
      var UseDefaultCursors: Boolean);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure DropSource1Paste(Sender: TObject; Action: TDragResult;
      DeleteOnPaste: Boolean);
    procedure DropSource1AfterDrop(Sender: TObject;
      DragResult: TDragResult; Optimized: Boolean);
    procedure ListView1CustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DropTextTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure MenuCopyClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure NextGrid1Change(Sender: TObject; ACol, ARow: Integer);
  private
    FTargetPath: string;
    FIsEXEfile: boolean;
    FCurrentCount: integer;
    FHiMECSExes: THiMECSExes;
    FItemChanged: boolean;

    function GetSourcePath: string;
  protected
    procedure Loaded; override;

    procedure lvAddFolder(Sender: TObject;
            AFolder: TShellFolder; var CanAdd: Boolean);
    procedure ChangeClick(Sender: TObject);
  public
    property TargetPath: string read FTargetPath;
    property SourcePath: string read GetSourcePath;
    property IsEXEfile: boolean read FIsEXEfile;
  end;

var
  frmBPLListeditor: TfrmBPLListeditor;

implementation

{$R *.DFM}

uses
{$ifdef VER18_PLUS}
  Types, // Required for inlining of ListView_CreateDragImage
{$endif}
  SysUtils,
  CommCtrl, JvgXMLSerializer_Encrypt;

// CUSTOM CURSORS:
// The cursors in DropCursors.res are exactly the same as the default cursors.
// Use DropCursors.res as a template if you wish to customise your own cursors.
// For this demo we've created Cursors.res - some coloured cursors.
{$R Cursors.res}
const
  crCopy = 101;
  crMove = 102;
  crLink = 103;
  crCopyScroll = 104;
  crMoveScroll = 105;
  crLinkScroll = 106;

//----------------------------------------------------------------------------
// Miscellaneous utility functions
//----------------------------------------------------------------------------

procedure CreateLink(SourceFile, ShortCutName: String);
var
  IUnk: IUnknown;
  ShellLink: IShellLink;
  IPFile: IPersistFile;
  tmpShortCutName: string;
  WideStr: WideString;
  i: integer;
begin
  IUnk := CreateComObject(CLSID_ShellLink);
  ShellLink := IUnk as IShellLink;
  IPFile  := IUnk as IPersistFile;
  with ShellLink do
  begin
    SetPath(PChar(SourceFile));
    SetWorkingDirectory(PChar(ExtractFilePath(SourceFile)));
  end;
  ShortCutName := ChangeFileExt(ShortCutName,'.lnk');
  if FileExists(ShortCutName) then
  begin
    ShortCutName := copy(ShortCutName, 1, length(ShortCutName)-4);
    i := 1;
    repeat
      tmpShortCutName := ShortCutName +'(' + inttostr(i)+ ').lnk';
      inc(i);
    until not FileExists(tmpShortCutName);
    WideStr := tmpShortCutName;
  end
  else WideStr := ShortCutName;
  IPFile.Save(PWChar(WideStr), False);
end;

//----------------------------------------------------------------------------
// TFormFile methods
//----------------------------------------------------------------------------

procedure TfrmBPLListeditor.Loaded;
begin
  inherited Loaded;

  with ShellTreeView1 do
  begin
    AutoContextMenus := False;
    ObjectTypes := [otFolders];
    Root := 'rfDesktop';
    ShellListView := ListView1;
    UseShellImages := True;
    AutoRefresh := False;
  end;

  with ListView1 do
  begin
    AutoContextMenus := False;
    ObjectTypes := [otNonFolders];
    Root := 'rfDesktop';
    ShellTreeView := ShellTreeView1;
    //OnChange := ChangeClick;
    //OnAddFolder := lvAddFolder;
    Sorted := True;
  end;

  ShellTreeView1.Path := ExtractFilePath(Application.ExeName);
end;

procedure TfrmBPLListeditor.MenuCopyClick(Sender: TObject);
var
  i: integer;
begin
  //JvCheckListBox1.DeleteSelected;
  for i := 0 to NextGrid1.SelectedCount - 1 do
  begin
    if NextGrid1.Selected[i] then
      NextGrid1.DeleteRow(i);
  end;
  //NextGrid1.DeleteRow(NextGrid1.SelectedRow);

  FCurrentCount := NextGrid1.RowCount;
end;

procedure TfrmBPLListeditor.NextGrid1Change(Sender: TObject; ACol,
  ARow: Integer);
begin
  FItemChanged := True;
end;

procedure TfrmBPLListeditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Work around "Control has no parent window" on destroy
  ListView1.Free;
  ShellTreeView1.Free;
  FHiMECSExes.Free;
end;

procedure TfrmBPLListeditor.FormCreate(Sender: TObject);
begin
  // Load custom cursors...
  Screen.cursors[crCopy] := LoadCursor(hinstance, 'CUR_DRAG_COPY');
  Screen.cursors[crMove] := LoadCursor(hinstance, 'CUR_DRAG_MOVE');
  Screen.cursors[crLink] := LoadCursor(hinstance, 'CUR_DRAG_LINK');
  Screen.cursors[crCopyScroll] := LoadCursor(hinstance, 'CUR_DRAG_COPY_SCROLL');
  Screen.cursors[crMoveScroll] := LoadCursor(hinstance, 'CUR_DRAG_MOVE_SCROLL');
  Screen.cursors[crLinkScroll] := LoadCursor(hinstance, 'CUR_DRAG_LINK_SCROLL');

  FCurrentCount := 0;

  FHiMECSExes := THiMECSExes.Create(Self);
end;

function TfrmBPLListeditor.GetSourcePath: string;
begin
  Result := IncludeTrailingBackslash(ShellTreeView1.Path);
end;

procedure TfrmBPLListeditor.ListView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  Filename: string;
  Res: TDragResult;
  p: TPoint;
  First: boolean;
//  Count: integer;
begin
  // If no files selected then exit...
  if ListView1.SelCount = 0 then
    Exit;

  // Wait for user to move cursor before we start the drag/drop.
  if (DragDetectPlus(TWinControl(Sender))) then
  begin
    Statusbar1.SimpleText := '';
    DropSource1.Files.Clear;
    // DropSource1.MappedNames.Clear;

    // Fill DropSource1.Files with selected files in ListView1 and...
    // ...create drag image
    First := True;
    for i := 0 to Listview1.Items.Count-1 do
      if (Listview1.Items[i].Selected) then
      begin
        Filename := Listview1.Folders[i].PathName;
        DropSource1.Files.Add(Filename);
        // The TDropFileSource.MappedNames list can be used to indicate to the
        // drop target, that the files should be renamed once they have been
        // copied. This is the technique used when dragging files from the
        // recycle bin.
        // DropSource1.MappedNames.Add(ExtractFilePath(Filename)+'Copy of '+ExtractFileName(Filename));

        // Create a drag image.
        if (First) then
        begin
          ImageListSingleFile.Handle := ListView_CreateDragImage(ListView1.Handle,
            Listview1.Items[i].Index, p);
          // Note: ListView_CreateDragImage fails to include the list item text on
          // some versions of Windows. Known problem with no solution according to MS.
          First := False;
        end else
        begin
          ImageListMultiFile.Handle := ListView_CreateDragImage(ListView1.Handle,
            Listview1.Items[i].Index, p);
          try
            ImageListSingleFile.Handle := ImageList_Merge(ImageListSingleFile.Handle, 0, ImageListMultiFile.Handle, 0, 0, ImageListSingleFile.Height);
          finally
            ImageListMultiFile.Handle := 0;
          end;
        end;
      end;

    DropSource1.Images := ImageListSingleFile;
    DropSource1.ImageHotSpotX := X-ListView1.Selected.Left;
    DropSource1.ImageHotSpotY := Y-ListView1.Selected.Top;
    DropSource1.ImageIndex := 0;

    // Temporarily disable the list view as a drop target so we don't drop on
    // ourself.
    //DropFileTarget1.Dragtypes := [];
    try

      // OK, now we are all set to go. Let's start the drag...
      Res := DropSource1.Execute;

    finally
      // Enable the list view as a drop target again.
      //DropFileTarget1.Dragtypes := [dtCopy,dtMove,dtLink];
    end;

    // Note:
    // The target is responsible, from this point on, for the
    // copying/moving/linking of the file but the target feeds
    // back to the source what (should have) happened via the
    // returned value of Execute.

    // Feedback in Statusbar1 what happened...
    case Res of
      drDropCopy: StatusBar1.SimpleText := 'Copied successfully';
      drDropMove: StatusBar1.SimpleText := 'Moved successfully';
      drDropLink: StatusBar1.SimpleText := 'Linked successfully';
      drCancel: StatusBar1.SimpleText := 'Drop was cancelled';
      drOutMemory: StatusBar1.SimpleText := 'Drop cancelled - out of memory';
    else
      StatusBar1.SimpleText := 'Drop cancelled - unknown reason';
    end;

  end;
end;

procedure TfrmBPLListeditor.ListView1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  // Items which have been "cut to clipboard" are drawn differently.
  if boolean(Item.Data) then
    Sender.Canvas.Font.Style := [fsStrikeOut];
end;

procedure TfrmBPLListeditor.PopupMenu1Popup(Sender: TObject);
begin
  MenuCopy.Enabled := (Listview1.SelCount > 0);

  // Enable paste menu if the clipboard contains data in any of
  // the supported formats
  //MenuPaste.Enabled := DropFileTarget1.CanPasteFromClipboard;
end;

//--------------------------
// SOURCE events...
//--------------------------
procedure TfrmBPLListeditor.DropSource1Feedback(Sender: TObject; Effect: Integer;
  var UseDefaultCursors: Boolean);
begin
  UseDefaultCursors := False; // We want to use our own.
  case DWORD(Effect) of
    DROPEFFECT_COPY:
      Windows.SetCursor(Screen.Cursors[crCopy]);
    DROPEFFECT_MOVE:
      Windows.SetCursor(Screen.Cursors[crMove]);
    DROPEFFECT_LINK:
      Windows.SetCursor(Screen.Cursors[crLink]);
    DROPEFFECT_SCROLL OR DROPEFFECT_COPY:
      Windows.SetCursor(Screen.Cursors[crCopyScroll]);
    DROPEFFECT_SCROLL OR DROPEFFECT_MOVE:
      Windows.SetCursor(Screen.Cursors[crMoveScroll]);
    DROPEFFECT_SCROLL OR DROPEFFECT_LINK:
      Windows.SetCursor(Screen.Cursors[crLinkScroll]);
  else
    UseDefaultCursors := True; // Use default NoDrop
  end;
end;

procedure TfrmBPLListeditor.Button1Click(Sender: TObject);
var
  i,j: integer;
begin
  for i := 0 to ListView1.items.Count - 1 do
  begin
    if ListView1.Items.Item[i].Selected then
    begin
      j := NextGrid1.AddRow;
      NextGrid1.Cell[1,j].AsString := ExtractFileName(ListView1.Folders[i].DisplayName);
      NextGrid1.Cell[2,j].AsString := ExtractFilePath(ListView1.Folders[i].PathName);
      NextGrid1.Cell[3,j].AsInteger := 0;
      FCurrentCount := NextGrid1.RowCount - 1;
      NextGrid1.Cell[0,FCurrentCount].AsBoolean := true;
    end;
  end;
end;

procedure TfrmBPLListeditor.Button2Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to NextGrid1.SelectedCount - 1 do
  begin
    if NextGrid1.Selected[i] then
      NextGrid1.DeleteRow(i);
  end;
  //NextGrid1.DeleteRow(NextGrid1.SelectedRow);

  FCurrentCount := NextGrid1.RowCount;
end;

procedure TfrmBPLListeditor.Button3Click(Sender: TObject);
var
  i: integer;
  LStr: string;
begin
  if SaveDialog1.Execute then
  begin
    if SaveDialog1.FileName <> '' then
    begin
      FHiMECSExes.ExeCollect.Clear;

      for i := 0 to NextGrid1.RowCount - 1 do
      begin
        if NextGrid1.Cell[0,i].AsBoolean then
        begin
          with FHiMECSExes.ExeCollect.Add do
          begin
            AllowLevel := NextGrid1.Cell[3,i].AsInteger;
            ExeName := NextGrid1.Cell[1,i].AsString;
            FilePath := NextGrid1.Cell[2,i].AsString;
          end;
        end;
      end;

      LStr := ExtractFileName(SaveDialog1.FileName);
      FHiMECSExes.SaveToFile(SaveDialog1.FileName,LStr,True);
      FItemChanged := False;
    end
  end;
end;

procedure TfrmBPLListeditor.Button4Click(Sender: TObject);
var
  i: integer;
  LStr: string;
begin
  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName <> '' then
    begin
      FHiMECSExes.ExeCollect.Clear;
      LStr := ExtractFileName(OpenDialog1.FileName);
      FHiMECSExes.LoadFromFile(OpenDialog1.FileName,LStr,True);
      NextGrid1.ClearRows;
      for i := 0 to FHiMECSExes.ExeCollect.Count - 1 do
      begin
        NextGrid1.AddRow;
        NextGrid1.Cell[0, i].AsBoolean := True;
        NextGrid1.Cell[1, i].AsString := FHiMECSExes.ExeCollect.Items[i].ExeName;
        NextGrid1.Cell[2, i].AsString := FHiMECSExes.ExeCollect.Items[i].FilePath;
        NextGrid1.Cell[3, i].AsInteger := FHiMECSExes.ExeCollect.Items[i].AllowLevel;
      end;

      if FHiMECSExes.ExeCollect.Count > 0 then
        FItemChanged := False;
    end;
  end;
end;

procedure TfrmBPLListeditor.DropSource1AfterDrop(Sender: TObject;
  DragResult: TDragResult; Optimized: Boolean);
var
  i: integer;
begin
  // Delete source files if target performed an unoptimized drag/move
  // operation (target copies files, source deletes them).
  if (DragResult = drDropMove) and (not Optimized) then
    for i := 0 to DropSource1.Files.Count-1 do
      DeleteFile(DropSource1.Files[i]);
end;

procedure TfrmBPLListeditor.DropSource1Paste(Sender: TObject; Action: TDragResult;
  DeleteOnPaste: Boolean);
var
  i: integer;
begin
  StatusBar1.SimpleText := 'Target pasted file(s)';

  // Delete source files if target performed a paste/move operation and
  // requested the source to "Delete on paste".
  if (DeleteOnPaste) then
    for i := 0 to DropSource1.Files.Count-1 do
      DeleteFile(DropSource1.Files[i]);
end;


procedure TfrmBPLListeditor.DropTextTarget1Drop(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
var i,j: integer;
begin
  if (DataFormatAdapterFile.DataFormat <> nil) and // Check if we have a data format and if so...
     ((DataFormatAdapterFile.DataFormat as TFileDataFormat).Files.Count > 0) then
  begin
    // ...Extract the dropped data from it.
    for i := 0 to (DataFormatAdapterFile.DataFormat as TFileDataFormat).Files.Count - 1 do
    begin
      j := NextGrid1.AddRow;
      NextGrid1.Cell[1,j].AsString := ( ExtractFileName(
          (DataFormatAdapterFile.DataFormat as TFileDataFormat).Files.Strings[i]));
      NextGrid1.Cell[1,j].AsBoolean := true; //[i+FCurrentCount]
    end;

    FCurrentCount := FCurrentCount + (DataFormatAdapterFile.DataFormat as TFileDataFormat).Files.Count;
  end;
end;

//--------------------------
// TARGET events...
//--------------------------
procedure TfrmBPLListeditor.btnCloseClick(Sender: TObject);
begin
  if FItemChanged then
    Button3Click(nil);

  Close;
end;

procedure TfrmBPLListeditor.lvAddFolder(Sender: TObject;
  AFolder: TShellFolder; var CanAdd: Boolean);
//
// This procedure is triggered by the TShellListView OnAddFolder event for every
// file or folder encountered.
// The AFolder parameter can represent either a folder or a file. Only file
// names are checked.
//
// The CanAdd var parameter is set to False if current file is not to be added
// to the list.
//
//var
//  mp : TMatchPosition; // to satisfy the call to CheckString

begin
{  CanAdd := True;
  if (AFolder.IsFolder) or rbNone.Checked then
    Exit; // don't check if folder, or matching turned off


// now see if this is what we want
  if rexMain.MatchPattern.Count > 0 then
  try
    CanAdd := rexMain.CheckString(AFolder.DisplayName, mp);
  except
    CanAdd := False;  // in case of invalid match pattern
  end;
}
end;

procedure TfrmBPLListeditor.ChangeClick(Sender: TObject);
//
// This OnChange event handler procedure is called to update the TShellListView
// whenever a control state is changed.
// It sets some TShellListView properties, sets up the RegEx for the match,
// and then calls its Refresh procedure.
//
var
  mp : string;  // match pattern

begin
{
  rexMain.MatchPattern.Clear;
  if Length(Trim(edtFilter.Text)) > 0 then
  begin
// load the RegEx filter pattern
    if rbDOS.Checked then
// DOS style filter
    begin
      if (not rexMain.FileMasksToRegEx(edtFilter.Text)) then
      begin
        Exit; // invalid DOS match pattern, perhaps some error msg in order here
      end;
    end
    else
// RegEx filter
    begin
      if edtFilter.Text[1] <> '^' then
        mp := '^' + edtFilter.Text // make sure pattern is anchored to start of name
      else
        mp := edtFilter.Text;
      rexMain.MatchPattern.Add(mp);
    end;
  end;

// see if the user wants hidden files and/or folders displayed.
  if cbHidden.Checked then
    lvMain.ObjectTypes := lvMain.ObjectTypes + [otHidden]
  else
    lvMain.ObjectTypes := lvMain.ObjectTypes - [otHidden];

  if cbFolders.Checked then
    lvMain.ObjectTypes := lvMain.ObjectTypes + [otFolders]
  else
    lvMain.ObjectTypes := lvMain.ObjectTypes - [otFolders];

// refresh the list. This will trigger TfrmMain.lvMainAddFolder for each
// file and folder encountered.
  lvMain.Refresh;
}
end;
end.
