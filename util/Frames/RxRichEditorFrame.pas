unit RxRichEditorFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RxAppEvent, Vcl.Menus,
  RxMenus, Vcl.ImgList, Vcl.ComCtrls, Vcl.StdCtrls, RxRichEd, Vcl.ExtCtrls,
  RxSpeedBar, Vcl.Mask, RxSpin, RxCombos, RxClipMon, NxCollection;

type
  TFrameRxRichEditor = class(TFrame)
    FormatBar: TSpeedBar;
    FontName: TFontComboBox;
    FontSize: TRxSpinEdit;
    SpeedbarSection3: TSpeedbarSection;
    BoldBtn: TSpeedItem;
    ItalicBtn: TSpeedItem;
    UnderlineBtn: TSpeedItem;
    ColorBtn: TSpeedItem;
    BackgroundBtn: TSpeedItem;
    LeftBtn: TSpeedItem;
    CenterBtn: TSpeedItem;
    RightBtn: TSpeedItem;
    SuperscriptBtn: TSpeedItem;
    SubscriptBtn: TSpeedItem;
    BulletsBtn: TSpeedItem;
    Ruler: TPanel;
    FirstInd: TLabel;
    LeftInd: TLabel;
    RulerLine: TBevel;
    RightInd: TLabel;
    Editor: TRxRichEdit;
    StatusBar: TStatusBar;
    ToolbarImages: TImageList;
    FontDialog: TFontDialog;
    MainMenu: TRxMainMenu;
    FileMenu: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    FileSaveSelItem: TMenuItem;
    N1: TMenuItem;
    FilePrintItem: TMenuItem;
    N4: TMenuItem;
    FileExitItem: TMenuItem;
    EditMenu: TMenuItem;
    EditUndoItem: TMenuItem;
    EditRedoItem: TMenuItem;
    N2: TMenuItem;
    EditCutItem: TMenuItem;
    EditCopyItem: TMenuItem;
    EditPasteItem: TMenuItem;
    EditPasteSpecial: TMenuItem;
    EditSelectAllItem: TMenuItem;
    N3: TMenuItem;
    EditFindItem: TMenuItem;
    EditFindNextItem: TMenuItem;
    EditReplaceItem: TMenuItem;
    N5: TMenuItem;
    EditObjPropsItem: TMenuItem;
    InsertMenu: TMenuItem;
    InsertObjectItem: TMenuItem;
    InsertImageItem: TMenuItem;
    FormatMenu: TMenuItem;
    FormatFontItem: TMenuItem;
    FormatParagraphItem: TMenuItem;
    N6: TMenuItem;
    ProtectedItem: TMenuItem;
    DisabledItem: TMenuItem;
    HiddenItem: TMenuItem;
    HelpMenu: TMenuItem;
    HelpAboutItem: TMenuItem;
    EditPopupMenu: TRxPopupMenu;
    CutItm: TMenuItem;
    CopyItm: TMenuItem;
    PasteItm: TMenuItem;
    BackgroundMenu: TRxPopupMenu;
    ColorMenu: TRxPopupMenu;
    App: TAppEvents;
    SpeedBar: TSpeedBar;
    SpeedbarSection1: TSpeedbarSection;
    SpeedbarSection2: TSpeedbarSection;
    NewBtn: TSpeedItem;
    OpenBtn: TSpeedItem;
    SaveBtn: TSpeedItem;
    PrintBtn: TSpeedItem;
    CutBtn: TSpeedItem;
    CopyBtn: TSpeedItem;
    PasteBtn: TSpeedItem;
    UndoBtn: TSpeedItem;
    RedoBtn: TSpeedItem;
    FindBtn: TSpeedItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PrintDialog: TPrintDialog;
    NxPathControl1: TNxPathControl;
    procedure EditorChange(Sender: TObject);
    procedure EditorProtectChange(Sender: TObject; StartPos, EndPos: Integer;
      var AllowChange: Boolean);
    procedure EditorSelectionChange(Sender: TObject);
    procedure EditorTextNotFound(Sender: TObject; const FindText: string);
    procedure EditorURLClick(Sender: TObject; const URLText: string;
      Button: TMouseButton);
    procedure NewBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure CutBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure PasteBtnClick(Sender: TObject);
    procedure UndoBtnClick(Sender: TObject);
    procedure RedoBtnClick(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure BoldBtnClick(Sender: TObject);
    procedure ItalicBtnClick(Sender: TObject);
    procedure UnderlineBtnClick(Sender: TObject);
    procedure LeftBtnClick(Sender: TObject);
    procedure CenterBtnClick(Sender: TObject);
    procedure RightBtnClick(Sender: TObject);
    procedure SuperscriptBtnClick(Sender: TObject);
    procedure SubscriptBtnClick(Sender: TObject);
    procedure BulletsBtnClick(Sender: TObject);
    procedure RulerResize(Sender: TObject);
    procedure FontNameChange(Sender: TObject);
    procedure FontSizeChange(Sender: TObject);
    procedure AppActivate(Sender: TObject);
    procedure AppHint(Sender: TObject);
    procedure ColorMenuDrawItem(Sender: TMenu; Item: TMenuItem; Rect: TRect;
      State: TMenuOwnerDrawState);
    procedure ColorMenuPopup(Sender: TObject);
    procedure BackgroundMenuPopup(Sender: TObject);
    procedure EditPopupMenuGetImageIndex(Sender: TMenu; Item: TMenuItem;
      State: TMenuOwnerDrawState; var ImageIndex: Integer);
    procedure EditPopupMenuMeasureItem(Sender: TMenu; Item: TMenuItem;
      var Width, Height: Integer);
  private
    FFileName: string;
    FUpdating: Boolean;
    FDragOfs: Integer;
    FLineOfs: Integer;
    FLineDC: HDC;
    FLinePen: HPen;
    FLineVisible: Boolean;
    FDragging: Boolean;
    FProtectChanging: Boolean;
    FClipboardMonitor: TClipboardMonitor;
    FOpenPictureDialog: TOpenDialog;

    function IndentToRuler(Indent: Integer; IsRight: Boolean): Integer;
    function RulerToIndent(RulerPos: Integer; IsRight: Boolean): Integer;
    procedure DrawLine;
    procedure CalcLineOffset(Control: TControl);
    function CurrText: TRxTextAttributes;
    procedure SetFileName(const FileName: String);
    procedure EditFindDialogClose(Sender: TObject; Dialog: TFindDialog);
    procedure ColorItemClick(Sender: TObject);
    procedure BackgroundItemClick(Sender: TObject);
    procedure CheckFileSave;
    procedure SetupRuler;
    procedure SetEditRect;
    procedure UpdateCursorPos;
    procedure FocusEditor;
    procedure ClipboardChanged(Sender: TObject);
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure PerformFileOpen(const AFileName: string);
    procedure SetModified(Value: Boolean);

    procedure AddRootMenuItem;
    procedure AddChildMenuItem;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitVar;
    procedure DestroyVar;
  end;

implementation

uses RxGIF, {$IFDEF RX_D3} ExtDlgs, {$IFNDEF CBUILDER} Jpeg, {$ENDIF}{$ENDIF}
  RxShell, RxMaxMin, RichEdit, ShellAPI, RxVCLUtils, ParaFmt;

{$R *.dfm}

const
  RulerAdj = 4/3;
  GutterWid: Integer = 6;
  UndoNames: array[TUndoName] of string =
    ('', 'typing', 'delete', 'drag and drop', 'cut', 'paste');
  ColorValues: array [0..16] of TColor = (
    clBlack, clMaroon, clGreen, clOlive, clNavy, clPurple, clTeal, clGray,
    clSilver, clRed, clLime, clYellow, clBlue, clFuchsia, clAqua, clWhite,
    clWindowText);
  BackValues: array [0..16] of TColor = (
    clBlack, clMaroon, clGreen, clOlive, clNavy, clPurple, clTeal, clGray,
    clSilver, clRed, clLime, clYellow, clBlue, clFuchsia, clAqua, clWhite,
    clWindow);

function ColorName(Color: TColor): string;
begin
  if (Color = clWindowText) or (Color = clWindow) or (Color = clDefault) then
    Result := 'Automatic'
  else begin
    Result := ColorToString(Color);
    if Pos('cl', Result) = 1 then Delete(Result, 1, 2);
  end;
end;

{ TFrame3 }

procedure TFrameRxRichEditor.AddChildMenuItem;
var
  DecadesItem: TNxPathNode;
begin
// 1. Add new child item inside 1st item inside Items array
  NxPathControl1.Items.AddChild(NxPathControl1.Items[0]).Text := 'Genres';

// 2. Manually create item's object and then add it into array
  DecadesItem := TNxPathNode.Create;
  DecadesItem.Text := 'Decades';

  NxPathControl1.Items.AddItem(NxPathControl1.Items[0], DecadesItem);
end;

procedure TFrameRxRichEditor.AddRootMenuItem;
var
  PicturesItem: TNxPathNode;
begin
// 1. Add root item
  NxPathControl1.Items.AddChild(nil);

// 2. Set properties of 1st item in Items array
  NxPathControl1.Items[0].Text := 'File';
  NxPathControl1.Items[0].ImageIndex := -1;

// 3. Add new root item and assign reference to PicturesItem variable
  PicturesItem := TNxPathNode(NxPathControl1.Items.AddChild(nil));

  PicturesItem.Text := 'Edit';
  PicturesItem.ImageIndex := -1;

  PicturesItem := TNxPathNode(NxPathControl1.Items.AddChild(nil));

  PicturesItem.Text := 'Insert';
  PicturesItem.ImageIndex := -1;

  PicturesItem := TNxPathNode(NxPathControl1.Items.AddChild(nil));

  PicturesItem.Text := 'Format';
  PicturesItem.ImageIndex := -1;

end;

procedure TFrameRxRichEditor.AppActivate(Sender: TObject);
begin
  FocusEditor;
end;

procedure TFrameRxRichEditor.AppHint(Sender: TObject);
begin
  if Length(Application.Hint) > 0 then begin
    StatusBar.SimplePanel := True;
    StatusBar.SimpleText := Application.Hint;
  end
  else StatusBar.SimplePanel := False;
end;

procedure TFrameRxRichEditor.BackgroundItemClick(Sender: TObject);
begin
  with Sender as TMenuItem do begin
    Checked := True;
    CurrText.BackColor := Tag;
  end;
end;

procedure TFrameRxRichEditor.BackgroundMenuPopup(Sender: TObject);
var
  I: Integer;
  C: TColor;
begin
  C := CurrText.BackColor;
  for I := 0 to 16 do
    BackgroundMenu.Items[I].Checked := (C = BackValues[I]);
end;

procedure TFrameRxRichEditor.BoldBtnClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if BoldBtn.Down then
    CurrText.Style := CurrText.Style + [fsBold]
  else
    CurrText.Style := CurrText.Style - [fsBold];
end;

procedure TFrameRxRichEditor.BulletsBtnClick(Sender: TObject);
begin
  if FUpdating then Exit;
  Editor.Paragraph.Numbering := TRxNumbering(BulletsBtn.Down);
end;

procedure TFrameRxRichEditor.CalcLineOffset(Control: TControl);
var
  P: TPoint;
begin
  with Control do P := ClientToScreen(Point(0, 0));
  P := Editor.ScreenToClient(P);
  FLineOfs := P.X + FDragOfs;
end;

procedure TFrameRxRichEditor.CenterBtnClick(Sender: TObject);
begin
  if FUpdating then Exit;
  Editor.Paragraph.Alignment := TParaAlignment(TComponent(Sender).Tag);
end;

procedure TFrameRxRichEditor.CheckFileSave;
var
  SaveResp: Integer;
begin
  if not Editor.Modified then Exit;
  SaveResp := MessageDlg(Format('Save changes to %s?', [FFileName]),
    mtConfirmation, mbYesNoCancel, 0);
  try
    case SaveResp of
      mrYes: FileSave(Self);
      mrNo: {Nothing};
      mrCancel: Abort;
    end;
  finally
    FocusEditor;
  end;
end;

procedure TFrameRxRichEditor.ClipboardChanged(Sender: TObject);
var
  E: Boolean;
begin
  { check to see if we can paste what's on the clipboard }
  E := Editor.CanPaste;
  PasteBtn.Enabled := E;
  EditPasteItem.Enabled := E;
  EditPasteSpecial.Enabled := E;
  PasteItm.Enabled := E;
end;

procedure TFrameRxRichEditor.ColorItemClick(Sender: TObject);
begin
  with Sender as TMenuItem do begin
    Checked := True;
    CurrText.Color := Tag;
  end;
end;

procedure TFrameRxRichEditor.ColorMenuDrawItem(Sender: TMenu; Item: TMenuItem;
  Rect: TRect; State: TMenuOwnerDrawState);
begin
  TRxPopupMenu(Sender).DefaultDrawItem(Item, Rect, State);
  Inc(Rect.Left, LoWord(GetMenuCheckMarkDimensions) + 6);
  Rect.Right := Rect.Left + 20;
  InflateRect(Rect, 0, -3);
  with TRxPopupMenu(Sender).Canvas do begin
    Brush.Color := clMenuText;
    FrameRect(Rect);
    InflateRect(Rect, -1, -1);
    Brush.Color := Item.Tag;
    FillRect(Rect);
  end;
end;

procedure TFrameRxRichEditor.ColorMenuPopup(Sender: TObject);
var
  I: Integer;
  C: TColor;
begin
  C := CurrText.Color;
  for I := 0 to 16 do
    ColorMenu.Items[I].Checked := (C = ColorValues[I]);
end;

procedure TFrameRxRichEditor.CopyBtnClick(Sender: TObject);
begin
  Editor.CopyToClipboard;
end;

constructor TFrameRxRichEditor.Create(AOwner: TComponent);
begin
  inherited;

  InitVar;
  SetupRuler;
  HandleNeeded;
end;

function TFrameRxRichEditor.CurrText: TRxTextAttributes;
begin
  if Editor.SelLength > 0 then Result := Editor.SelAttributes
  else Result := Editor.WordAttributes;
end;

procedure TFrameRxRichEditor.CutBtnClick(Sender: TObject);
begin
  Editor.CutToClipboard;
end;

destructor TFrameRxRichEditor.Destroy;
begin
  DestroyVar;

  inherited;
end;

procedure TFrameRxRichEditor.DestroyVar;
begin

end;

procedure TFrameRxRichEditor.DrawLine;
var
  P: TPoint;
begin
  FLineVisible := not FLineVisible;
  P := Point(0, 0);
  Inc(P.X, FLineOfs);
  with P, Editor do begin
    MoveToEx(FLineDC, X, Y, nil);
    LineTo(FLineDC, X, Y + ClientHeight);
  end;
end;

procedure TFrameRxRichEditor.EditFindDialogClose(Sender: TObject;
  Dialog: TFindDialog);
begin
  FocusEditor;
end;

procedure TFrameRxRichEditor.EditorChange(Sender: TObject);
begin
  SetModified(Editor.Modified);
  { Undo }
  UndoBtn.Enabled := Editor.CanUndo;
  EditUndoItem.Enabled := UndoBtn.Enabled;
  EditUndoItem.Caption := '&Undo ' + UndoNames[Editor.UndoName];
  { Redo }
  EditRedoItem.Enabled := Editor.CanRedo;
  RedoBtn.Enabled := EditRedoItem.Enabled;
  EditRedoItem.Caption := '&Redo ' + UndoNames[Editor.RedoName];
end;

procedure TFrameRxRichEditor.EditorProtectChange(Sender: TObject; StartPos,
  EndPos: Integer; var AllowChange: Boolean);
begin
  AllowChange := FProtectChanging;
end;

procedure TFrameRxRichEditor.EditorSelectionChange(Sender: TObject);
begin
  with Editor.Paragraph do
  try
    FUpdating := True;
    FirstInd.Left := IndentToRuler(FirstIndent, False) - (FirstInd.Width div 2);
    LeftInd.Left := IndentToRuler(LeftIndent + FirstIndent, False) - (LeftInd.Width div 2);
    RightInd.Left := IndentToRuler(RightIndent, True) - (RightInd.Width div 2);
    BoldBtn.Down := fsBold in CurrText.Style;
    ItalicBtn.Down := fsItalic in CurrText.Style;
    UnderlineBtn.Down := fsUnderline in CurrText.Style;
    BulletsBtn.Down := Boolean(Numbering);
    SuperscriptBtn.Down := CurrText.SubscriptStyle = ssSuperscript;
    SubscriptBtn.Down := CurrText.SubscriptStyle = ssSubscript;
    FontSize.AsInteger := CurrText.Size;
    FontName.FontName := CurrText.Name;
    ProtectedItem.Checked := CurrText.Protected;
    DisabledItem.Checked := CurrText.Disabled;
    HiddenItem.Checked := CurrText.Hidden;
    case Ord(Alignment) of
      0: LeftBtn.Down := True;
      1: RightBtn.Down := True;
      2: CenterBtn.Down := True;
    end;
    UpdateCursorPos;
  finally
    FUpdating := False;
  end;
end;

procedure TFrameRxRichEditor.EditorTextNotFound(Sender: TObject;
  const FindText: string);
begin
  MessageDlg(Format('Text "%s" not found.', [FindText]), mtWarning,
    [mbOk], 0);
end;

procedure TFrameRxRichEditor.EditorURLClick(Sender: TObject;
  const URLText: string; Button: TMouseButton);
begin
  if Button = mbLeft then
    ShellExecute(Handle, nil, PChar(URLText), nil, nil, SW_SHOW);
end;

procedure TFrameRxRichEditor.EditPopupMenuGetImageIndex(Sender: TMenu;
  Item: TMenuItem; State: TMenuOwnerDrawState; var ImageIndex: Integer);
begin
  if (Item = CutItm) or (Item = CopyItm) or (Item = PasteItm) then
    ImageIndex := Item.Tag;
end;

procedure TFrameRxRichEditor.EditPopupMenuMeasureItem(Sender: TMenu;
  Item: TMenuItem; var Width, Height: Integer);
begin
  if Item.Caption <> '-' then Height := 19;
end;

procedure TFrameRxRichEditor.FindBtnClick(Sender: TObject);
begin
  with Editor do FindDialog(SelText);
end;

procedure TFrameRxRichEditor.FocusEditor;
begin
  with Editor do if CanFocus then SetFocus;
end;

procedure TFrameRxRichEditor.FontNameChange(Sender: TObject);
begin
  if FUpdating then Exit;
  CurrText.Name := FontName.FontName;
end;

procedure TFrameRxRichEditor.FontSizeChange(Sender: TObject);
begin
  if FUpdating then Exit;
  if FontSize.AsInteger > 0 then CurrText.Size := FontSize.AsInteger;
end;

function TFrameRxRichEditor.IndentToRuler(Indent: Integer;
  IsRight: Boolean): Integer;
var
  R: TRect;
  P: TPoint;
begin
  Indent := Trunc(Indent * RulerAdj);
  with Editor do begin
    SendMessage(Handle, EM_GETRECT, 0, Longint(@R));
    if IsRight then begin
      P := R.BottomRight;
      P.X := P.X - Indent;
    end
    else begin
      P := R.TopLeft;
      P.X := P.X + Indent;
    end;
    P := ClientToScreen(P);
  end;
  with Ruler do P := ScreenToClient(P);
  Result := P.X;
end;

procedure TFrameRxRichEditor.InitVar;
begin
  AddRootMenuItem;
end;

procedure TFrameRxRichEditor.ItalicBtnClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if ItalicBtn.Down then
    CurrText.Style := CurrText.Style + [fsItalic]
  else
    CurrText.Style := CurrText.Style - [fsItalic];
end;

procedure TFrameRxRichEditor.LeftBtnClick(Sender: TObject);
begin
  if FUpdating then Exit;
  Editor.Paragraph.Alignment := TParaAlignment(TComponent(Sender).Tag);
end;

procedure TFrameRxRichEditor.NewBtnClick(Sender: TObject);
begin
  CheckFileSave;
  SetFileName('Untitled');
  FProtectChanging := True;
  try
    Editor.Lines.Clear;
    Editor.Modified := False;
    Editor.ReadOnly := False;
    SetModified(False);
    with Editor do begin
      DefAttributes.Assign(Font);
      SelAttributes.Assign(Font);
    end;
    SelectionChange(nil);
  finally
    FProtectChanging := False;
  end;
end;

procedure TFrameRxRichEditor.OpenBtnClick(Sender: TObject);
begin
  CheckFileSave;
  if OpenDialog.Execute then begin
    PerformFileOpen(OpenDialog.FileName);
    Editor.ReadOnly := ofReadOnly in OpenDialog.Options;
  end;
end;

procedure TFrameRxRichEditor.PasteBtnClick(Sender: TObject);
begin
  Editor.PasteFromClipboard;
end;

procedure TFrameRxRichEditor.PerformFileOpen(const AFileName: string);
begin
  FProtectChanging := True;
  try
    Editor.Lines.LoadFromFile(AFileName);
  finally
    FProtectChanging := False;
  end;
  SetFileName(AFileName);
  Editor.SetFocus;
  Editor.Modified := False;
  SetModified(False);
end;

procedure TFrameRxRichEditor.PrintBtnClick(Sender: TObject);
begin
  if PrintDialog.Execute then Editor.Print(FFileName);
end;

procedure TFrameRxRichEditor.RedoBtnClick(Sender: TObject);
begin
  Editor.Redo;
  RichEditChange(nil);
  SelectionChange(nil);
end;

procedure TFrameRxRichEditor.RightBtnClick(Sender: TObject);
begin
  if FUpdating then Exit;
  Editor.Paragraph.Alignment := TParaAlignment(TComponent(Sender).Tag);
end;

procedure TFrameRxRichEditor.RulerResize(Sender: TObject);
begin
  RulerLine.Width := Ruler.ClientWidth - (RulerLine.Left * 2);
end;

function TFrameRxRichEditor.RulerToIndent(RulerPos: Integer;
  IsRight: Boolean): Integer;
var
  R: TRect;
  P: TPoint;
begin
  P.Y := 0; P.X := RulerPos;
  with Ruler do P := ClientToScreen(P);
  with Editor do begin
    P := ScreenToClient(P);
    SendMessage(Handle, EM_GETRECT, 0, Longint(@R));
    if IsRight then
      Result := R.BottomRight.X - P.X
    else
      Result := P.X - R.TopLeft.X;
  end;
  Result := Trunc(Result / RulerAdj);
end;

procedure TFrameRxRichEditor.SaveBtnClick(Sender: TObject);
begin
  if FFileName = 'Untitled' then
    FileSaveAs(Sender)
  else begin
    Editor.Lines.SaveToFile(FFileName);
    Editor.Modified := False;
    SetModified(False);
    RichEditChange(nil);
  end;
end;

procedure TFrameRxRichEditor.SetEditRect;
var
  R: TRect;
  Offs: Integer;
begin
  with Editor do begin
    if SelectionBar then Offs := 3 else Offs := 0;
    R := Rect(GutterWid + Offs, 0, ClientWidth - GutterWid, ClientHeight);
    SendMessage(Handle, EM_SETRECT, 0, Longint(@R));
  end;
end;

procedure TFrameRxRichEditor.SetFileName(const FileName: String);
begin
  FFileName := FileName;
  Editor.Title := ExtractFileName(FileName);
//  Caption := Format('%s - %s', [ExtractFileName(FileName), Application.Title]);
end;

procedure TFrameRxRichEditor.SetModified(Value: Boolean);
begin
  if Value then StatusBar.Panels[1].Text := 'Modified'
  else StatusBar.Panels[1].Text := '';
end;

procedure TFrameRxRichEditor.SetupRuler;
var
  I: Integer;
  S: String;
begin
  SetLength(S, 201);
  I := 1;
  while I < 200 do begin
    S[I] := #9;
    S[I + 1] := '|';
    Inc(I, 2);
  end;
  Ruler.Caption := S;
end;

procedure TFrameRxRichEditor.SubscriptBtnClick(: );
begin

end;

procedure TFrameRxRichEditor.SubscriptBtnClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if SuperscriptBtn.Down then
    CurrText.SubscriptStyle := ssSuperscript
  else if SubscriptBtn.Down then
    CurrText.SubscriptStyle := ssSubscript
  else
    CurrText.SubscriptStyle := ssNone;
end;

procedure TFrameRxRichEditor.SuperscriptBtnClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if SuperscriptBtn.Down then
    CurrText.SubscriptStyle := ssSuperscript
  else if SubscriptBtn.Down then
    CurrText.SubscriptStyle := ssSubscript
  else
    CurrText.SubscriptStyle := ssNone;
end;

procedure TFrameRxRichEditor.UnderlineBtnClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if UnderlineBtn.Down then
    CurrText.Style := CurrText.Style + [fsUnderline]
  else
    CurrText.Style := CurrText.Style - [fsUnderline];
end;

procedure TFrameRxRichEditor.UndoBtnClick(Sender: TObject);
begin
  Editor.Undo;
  RichEditChange(nil);
  SelectionChange(nil);
end;

procedure TFrameRxRichEditor.UpdateCursorPos;
var
  CharPos: TPoint;
begin
  CharPos := Editor.CaretPos;
  StatusBar.Panels[0].Text := Format('Line: %3d  Col: %3d',
    [CharPos.Y + 1, CharPos.X + 1]);
  { update the status of the cut and copy command }
  CopyBtn.Enabled := Editor.SelLength > 0;
  EditCopyItem.Enabled := CopyBtn.Enabled;
  CopyItm.Enabled := CopyBtn.Enabled;
  CutBtn.Enabled := EditCopyItem.Enabled;
  CutItm.Enabled := CutBtn.Enabled;
  FileSaveSelItem.Enabled := CopyBtn.Enabled;
  EditCutItem.Enabled := EditCopyItem.Enabled;
  EditObjPropsItem.Enabled := Editor.SelectionType = [stObject];
end;

procedure TFrameRxRichEditor.WMDropFiles(var Msg: TWMDropFiles);
var
  CFileName: array[0..MAX_PATH] of Char;
begin
  try
    if DragQueryFile(Msg.Drop, 0, CFileName, MAX_PATH) > 0 then begin
      Application.BringToFront;
      CheckFileSave;
      PerformFileOpen(CFileName);
      Msg.Result := 0;
    end;
  finally
    DragFinish(Msg.Drop);
  end;
end;

end.
