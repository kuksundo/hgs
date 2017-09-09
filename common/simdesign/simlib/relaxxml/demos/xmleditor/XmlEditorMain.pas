{ Unit XmlEditorMain

  This unit is the main unit for XmlEditor.exe.

  XmlEditor uses the VirtualTreeView component written by Mike Lischke

  Author: Nils Haeck
  email:  n.haeck@simdesign.nl
  Date:   21-07-2001

  Changes:
  20 Feb 2002: Adapted for changed versions of TVirtualStringTree and XML
  29 Jul 2003: Adapted for use with NativeXml.pas
  14 Nov 2003: Cleaned up
  16 Sep 2005: Added editing capabilities

  Properties of TXmlNode
  - AttributeByName -> AttributeValueByName
  - ValueAsWideString -> ValueWide

  Properties/methods of new TNativeXml compared to old TNativeXml
  - StyleSheetNode -> StyleSheet
  - Utf8Encoded no longer exists (is always the case)
  - OnUnicodeLoss no longer exists (but loss from unicode to
    any other encoding with codepages will be logged in a debug log)
  - TNativeXmlEx is now component, so Create has argument AOwner
  - RootNodeList -> RootNodes
  - AttributeExchange removed, use NodeExchange

  Renames
  - TXmlElementType -> TsdElementType
  -   xeNormal -> xeElement
  -   xeElement -> xeDtdElement
  -   xeAttList -> xeDtdAttList
  -   xeEntity -> xeDtdEntity
  -   xeNotation -> xeDtdNotation
  - TXmlFormatType -> TsdFormatType

  The reference compiler: Delphi 7  (ver150)  -> I always use Delphi 7
  Newest compiler:        Delphi XE (ver220)

  copyright (c) 2001 - 2014 Nils Haeck  www.simdesign.nl
}
unit XmlEditorMain;

interface

{$i simdesign.inc}

uses
  // delphi
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, ImgList, ComCtrls, ToolWin, ExtCtrls, VirtualTrees, Menus,
  StdCtrls,

  // relaxxml
  RelaxXml,

  // synedit
  SynEdit, SynMemo, SynEditHighlighter, SynHighlighterXML,

  // xmleditor app
  sdXmlOutputOptionsDlg;

type
  TfrmMain = class(TForm)
    ControlBar1: TControlBar;
    tbMain: TToolBar;
    tbNew: TToolButton;
    ilMenu: TImageList;
    alMain: TActionList;
    acFileOpen: TAction;
    acFileNew: TAction;
    tbOpen: TToolButton;
    sbMain: TStatusBar;
    nbMain: TNotebook;
    Splitter1: TSplitter;
    nbData: TNotebook;
    pcData: TPageControl;
    tsTags: TTabSheet;
    odFileOpen: TOpenDialog;
    nbTree: TNotebook;
    pcTree: TPageControl;
    tsXmlTree: TTabSheet;
    stXmlTree: TVirtualStringTree;
    mnuMain: TMainMenu;
    mnuFile: TMenuItem;
    mnuNew: TMenuItem;
    mnuOpen: TMenuItem;
    mnuOptions: TMenuItem;
    ilData: TImageList;
    tsXmlSource: TTabSheet;
    acFileSaveAs: TAction;
    sdFileSave: TSaveDialog;
    tbSave: TToolButton;
    mnuSave: TMenuItem;
    Edit1: TMenuItem;
    acAddComment: TAction;
    acAddStyleSheet: TAction;
    AddComment1: TMenuItem;
    acOutputReadable: TAction;
    Outputinreadableformat1: TMenuItem;
    acElementDelete: TAction;
    acFileExit: TAction;
    N1: TMenuItem;
    acFileExit1: TMenuItem;
    pmTree: TPopupMenu;
    DeleteElement1: TMenuItem;
    InsertElement1: TMenuItem;
    acElementInsertBefore: TAction;
    acElementInsertAfter: TAction;
    acElementInsertSub: TAction;
    BeforeNode1: TMenuItem;
    AfterNode1: TMenuItem;
    Exit1: TMenuItem;
    InsertComment1: TMenuItem;
    acCommentInsert: TAction;
    acElementUp: TAction;
    acElementDown: TAction;
    MoveUp1: TMenuItem;
    MoveDown1: TMenuItem;
    N2: TMenuItem;
    stAttributes: TVirtualStringTree;
    acAttributeAdd: TAction;
    acAttributeDelete: TAction;
    acAttributeUp: TAction;
    acAttributeDown: TAction;
    pmAttributes: TPopupMenu;
    AddAttribute1: TMenuItem;
    DeleteAttribute1: TMenuItem;
    MoveUp2: TMenuItem;
    MoveDown2: TMenuItem;
    acLoadFromURL: TAction;
    acLoadFromURL1: TMenuItem;
    pcDebug: TPageControl;
    tsDebug: TTabSheet;
    reDebug: TRichEdit;
    Splitter2: TSplitter;
    smXmlSource: TSynMemo;
    hlXML: TSynXMLSyn;
    SaveWithEncodingAs1: TMenuItem;
    acSaveAsWithOptions: TAction;
    pmDebug: TPopupMenu;
    mnuSaveDebugInfo: TMenuItem;
    acSaveDebugInfo: TAction;
    sdDebugSave: TSaveDialog;
    acOutputPreserve: TAction;
    Preservewhitespacewhenloading1: TMenuItem;
    ToolButton1: TToolButton;
    pbMain: TProgressBar;
    mnuFixstructuralerrors: TMenuItem;
    acCanonicalXML: TAction;
    mnuCanonicalXML: TMenuItem;
    mnuSaveAsBinary: TMenuItem;
    sdFileSaveBinary: TSaveDialog;
    OutputinCompactformat1: TMenuItem;
    acOutputCompact: TAction;
    procedure acFileOpenExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure stXmlTreeInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure stXmlTreeExpanding(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var Allowed: Boolean);
    procedure stXmlTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure acFileSaveAsExecute(Sender: TObject);
    procedure acFileNewExecute(Sender: TObject);
    procedure pcTreeChange(Sender: TObject);
    procedure acAddCommentExecute(Sender: TObject);
    procedure acOutputReadableExecute(Sender: TObject);
    procedure stXmlTreeEditing(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure stXmlTreeGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure stXmlTreeGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure stXmlTreeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acElementDeleteExecute(Sender: TObject);
    procedure acFileExitExecute(Sender: TObject);
    procedure stXmlTreeNewText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
    procedure acElementInsertBeforeExecute(Sender: TObject);
    procedure acElementInsertAfterExecute(Sender: TObject);
    procedure acElementInsertSubExecute(Sender: TObject);
    procedure acCommentInsertExecute(Sender: TObject);
    procedure acElementUpExecute(Sender: TObject);
    procedure acElementDownExecute(Sender: TObject);
    procedure stAttributesGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure stAttributesGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure stAttributesEditing(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure stAttributesNewText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
    procedure acAttributeAddExecute(Sender: TObject);
    procedure acAttributeDeleteExecute(Sender: TObject);
    procedure acAttributeUpExecute(Sender: TObject);
    procedure acAttributeDownExecute(Sender: TObject);
    procedure stAttributesChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure stAttributesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acSaveAsWithOptionsExecute(Sender: TObject);
    procedure acSaveDebugInfoExecute(Sender: TObject);
    procedure acOutputPreserveExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acCanonicalXMLExecute(Sender: TObject);
    procedure mnuSaveAsBinaryClick(Sender: TObject);
    procedure acOutputCompactExecute(Sender: TObject);
  private
    FXml: TRelaxXml;       // Xml document currently displayed
    FFileName: UTF8String;  // Last opened filename
    FFileSize: int64;
    FFocusedNode: TXmlNode; // Focused TXmlNode
    FFocusedAttributeIndex: integer;
    FUpdateCount: integer;   // If 0 we can update otherwise we're in begin/end update block
    FMakeCanonicalXml: boolean;
    // the raw stream size - must be freed later
    FRawXmlStream: TStringStream;
    function GetPropertyIndex(Node: PVirtualNode): integer;
    procedure Regenerate;
    procedure RegenerateFromNode(ANode: TXmlNode);
    procedure RegenerateProperties;
    function ElementTypeToImageIndex(AElementType: TXmlElementType): integer;
    function MultiAttrCount(ANode: TXmlNode): integer;
    function MultiNodeCount(ANode: TXmlNode): integer;
    function MultiNodeByIndex(ANode: TXmlNode; AIndex: integer): TXmlNode;
    procedure UpdateMenu;
  public
    procedure BeginUpdate;
    function IsUpdating: boolean;
    procedure EndUpdate;
    // show the xml source in readable format
    procedure ShowXmlSource;
    // show progress
    procedure XmlProgress(Sender: TObject; Position: int64);
  end;

var
  frmMain: TfrmMain;

const

  cFormHeader = 'Xml Editor with RelaxXml (c) 2001-2015 SimDesign B.V.';

resourcestring

  sCannotInsertRootElement = 'You cannot insert another root element!';

implementation

{$R *.DFM}

type
  // This is the node record that is appended to each node in the virtual treeview
  PNodeRec = ^TNodeRec;
  TNodeRec = record
     FNode: TXmlNode;
  end;

{ TFrmMain }

procedure TfrmMain.acAddCommentExecute(Sender: TObject);
begin
  FXml.CommentString := InputBox('Add a comment', 'Comment:', FXml.CommentString);
end;

procedure TfrmMain.acFileNewExecute(Sender: TObject);
// Create a blank Xml document with a blank root
begin
  FXml.New;
  Regenerate;
end;

procedure TfrmMain.acFileOpenExecute(Sender: TObject);
var
  F: TFileStream;
begin
  // Open a new setup
  if odFileOpen.Execute then
  begin
    FFileName := odFileOpen.FileName;
    try
      reDebug.Clear;

      // allow progress bar to update
      FXml.OnProgress := XmlProgress;

      // load the file
      F := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyWrite);
      FRawXmlStream := TStringStream.Create('');
      FRawXmlStream.CopyFrom(F, F.Size);
      FRawXmlStream.Position := 0;
      try
        FXml.LoadFromStream(FRawXmlStream);
        FFileSize := FRawXmlStream.Size;
      finally
        F.Free;
      end;
      // now detach
      FXml.OnProgress := nil;

      // create canonical xml
      if FMakeCanonicalXml then
        // class method Canonicalize
        FXml.Canonicalize;

      // Display properties on statusbar
      sbMain.SimpleText := Format('Version="%s"', [FXml.VersionString]);
      if  Length(FXml.Charset) > 0 then
        sbMain.SimpleText := sbMain.SimpleText +
          Format(' Encoding="%s"', [FXml.CharSet]);
    except
      // Show exception on status bar
      on E: Exception do
        sbMain.SimpleText := 'Exception in editor:' + E.Message;
    end;
    Regenerate;
  end;
end;


procedure TfrmMain.acFileSaveAsExecute(Sender: TObject);
begin
  // Save a file
  if sdFileSave.Execute then
  begin
    FFileName := sdFileSave.FileName;
    FXml.SaveToFile(FFilename);
    Regenerate;
  end;
end;

procedure TfrmMain.acSaveAsWithOptionsExecute(Sender: TObject);
var
  Dlg: TXmlOutputOptionsDlg;
  FExternalEncoding: TStringEncodingType;
  FExternalCodepage: integer;
  FUseStoredEncoding: boolean;
begin
  FUseStoredEncoding := True;
  FExternalEncoding := seUTF8;
  FExternalCodepage := CP_UTF8;

  // dialog box
  Dlg := TXmlOutputOptionsDlg.Create(Self);
  try
    if Dlg.lbDefaultEncodings.ItemIndex < 0 then
      Dlg.lbDefaultEncodings.ItemIndex := 0;

    if Dlg.ShowModal = mrOK then
    begin

      if Dlg.rbDefaultEncodings.Checked then
      begin
        FUseStoredEncoding := False;
        case Dlg.lbDefaultEncodings.ItemIndex of
        0:
          begin
            FExternalEncoding := seUTF8;
            FExternalCodepage := CP_UTF8;
          end;
        1:
          begin
            FExternalEncoding := seUTF16LE;
//            FExternalCodepage := CP_UTF16; //to-do
          end;
        2:
          begin
            FExternalEncoding := seAnsi;
//            FExternalCodepage := CP_1252;  //to-do
          end;
        end;
      end;

      if Dlg.rbCodepage.Checked then
      begin
        FUseStoredEncoding := False;
        FExternalEncoding := seAnsi;
//        FExternalCodepage := sdCharsetToCodepage(Dlg.edCodepage.Text);  to-do
      end;

      // Save a file
      if sdFileSave.Execute then
      begin
        // specified encoding used?
        if not FUseStoredEncoding then
        begin
//          FXml.ExternalEncoding := FExternalEncoding;
//          FXml.ExternalCodepage := FExternalCodepage;
        end;

        // Other options
        FXml.XmlFormat :=  TXmlFormatType(Dlg.rgXmlFormat.ItemIndex);

        FFileName := sdFileSave.FileName;
        FXml.SaveToFile(FFilename);
        Regenerate;

      end;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TfrmMain.acSaveDebugInfoExecute(Sender: TObject);
begin
  // Save debug info
  if sdDebugSave.Execute then
  begin
    reDebug.Lines.SaveToFile(sdDebugSave.FileName);
  end;
end;

procedure TfrmMain.mnuSaveAsBinaryClick(Sender: TObject);
begin
  if sdFileSaveBinary.Execute then
  begin
  // not implemented
  end;
end;

procedure TfrmMain.acOutputReadableExecute(Sender: TObject);
begin
  FXml.XmlFormat := xfReadable;
  UpdateMenu;
end;

procedure TfrmMain.acOutputCompactExecute(Sender: TObject);
begin
  FXml.XmlFormat := xfCompact;
  UpdateMenu;
end;

procedure TfrmMain.acOutputPreserveExecute(Sender: TObject);
begin
  FXml.XmlFormat := xfCompact;
  UpdateMenu;
end;

procedure TfrmMain.BeginUpdate;
begin
  inc(FUpdateCount);
end;

function TfrmMain.ElementTypeToImageIndex(AElementType: TXmlElementType): integer;
begin
  case AElementType of
  xeElement:     Result := 1;
  xeComment:     Result := 2;
  xeCData:       Result := 3;
  //xeCondSection: Result := 12;
  xeCharData:    Result := 4;
  //xeWhiteSpace:  Result := 4;
  //xeQuotedText:  Result := 4;
  xeDeclaration: Result := 5;
  xeStylesheet:  Result := 6;
  xeDoctype:     Result := 7;
  //xeDtdElement:  Result := 8;
  //xeDtdAttList:  Result := 9;
  //xeDtdEntity:   Result := 10;
  //xeDtdNotation: Result := 11;
  //xeInstruction: Result := 13;
  //xeAttribute:   Result := 0;
  else
    Result := 13;
  end;//case
end;

procedure TfrmMain.EndUpdate;
begin
  dec(FUpdateCount);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FXml := TRelaxXml.Create;

  // Open cmdline parameter 1 file (when associated with this tool)
  if length(ParamStr(1)) > 0 then
  begin
    FXml.LoadFromFile(ParamStr(1));
    Regenerate;
  end else
    acFileNew.Execute;

  FFocusedAttributeIndex := -1;


end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FXml.Free;
  //free the TNativeXml object
  FRawXmlStream.Free;
  // free the temp mem raw xml stream
end;

function TfrmMain.IsUpdating: boolean;
begin
  Result := FUpdateCount > 0;
end;


function TfrmMain.GetPropertyIndex(Node: PVirtualNode): integer;
var
  Index: integer;
begin
  Result := -1;
  // Get the data of the tag's properties
  if assigned(FFocusedNode) then
  begin
    Index := Node.Index;
    // Attributes
    if (Index >= 0) and (Index < FFocusedNode.AttributeCount) then
    begin
      Result := Index;
      exit;
    end;
  end;
end;

procedure TfrmMain.stAttributesGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Index: integer;
begin
  Index := GetPropertyIndex(Node);
  if Index < 0 then
    exit;
  case Column of
  0: CellText := sdUTF8ToUnicode(FFocusedNode.AttributeName[Index]);
  1: CellText := sdUTF8ToUnicode(FFocusedNode.AttributeValue[Index]);
  end;//case
end;

procedure TfrmMain.stAttributesGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Index: integer;
begin
  ImageIndex := -1;
  if Kind = ikOverlay then
    exit;
  if Column > 0 then
    exit;
  Index := GetPropertyIndex(Node);
  if Index < 0 then
    exit;
  ImageIndex := ElementTypeToImageIndex(FFocusedNode[Index].ElementType);
end;

procedure TfrmMain.stAttributesEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := True;
end;

procedure TfrmMain.stAttributesNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
var
  Index: integer;
begin
  Index := GetPropertyIndex(Node);
  if Index < 0 then
    exit;
  case Column of
  0: FFocusedNode.AttributeName[Index] := NewText;
  1: FFocusedNode.AttributeValue[Index] := sdUnicodeToUtf8(NewText);
  end;//case
end;

function TfrmMain.MultiAttrCount(ANode: TXmlNode): integer;
// Count the attributes, but if acSingleNodeAsAttrib is checked we also add
// the single nodes
begin
  Result := 0;
  if not assigned(ANode) then
    exit;
  Result := ANode.AttributeCount;
end;

function TfrmMain.MultiNodeByIndex(ANode: TXmlNode; AIndex: integer): TXmlNode;
// Return the child container of ANode at AIndex
begin
  Result := nil;
  if assigned(ANode) then
    Result := ANode.Nodes[AIndex]; //must test
end;

function TfrmMain.MultiNodeCount(ANode: TXmlNode): integer;
// Count the number of containers
begin
  Result := 0;
  if assigned(ANode) then
  begin
    Result := ANode.NodeCount;  // must test
  end;
end;

procedure TfrmMain.pcTreeChange(Sender: TObject);
begin
  if (pcTree.ActivePage = tsXmlSource) then
  begin
    ShowXmlSource;
  end;
end;

procedure TfrmMain.stXmlTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
// Use this event to display related info in other panes
var
  FData: PNodeRec;
begin
  // Signal the setup that the current tag changed
  FData := Sender.GetNodeData(Node);
  if assigned(FData) then
    FFocusedNode := FData^.FNode
  else
    FFocusedNode := nil;
  RegenerateProperties;
end;

procedure TfrmMain.stXmlTreeEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := true;
end;

procedure TfrmMain.stXmlTreeNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
var
  FData: PNodeRec;
begin
  FData := Sender.GetNodeData(Node);
  case Column of
  0: FData.FNode.Name := NewText;
  1: FData.FNode.ValueAsString := NewText;
  end;//case
end;

procedure TfrmMain.stXmlTreeExpanding(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var Allowed: Boolean);
var
  FData: PNodeRec;
begin
  with stXMLTree do
  begin
    ChildCount[Node] := 0;
    FData := Sender.GetNodeData(Node);
    if assigned(FData^.FNode) then
      ChildCount[Node] := MultiNodeCount(FData^.FNode);
    InvalidateToBottom(Node);
  end;
end;

procedure TfrmMain.stXmlTreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
// Get the data for this tree node
var
  FData: PNodeRec;
  S, Trimmed: WideString;
begin
  FData := Sender.GetNodeData(Node);
  if assigned(FData^.FNode) then
  begin
    // avoid whitespace values
    S := FData^.FNode.ValueAsUnicodeString;
    Trimmed := Trim(S);
    if length(Trimmed) = 0 then
      S := '';
    // show name and value in unicode
    case Column of
    0: CellText := FData^.FNode.Name; //todo
    1: CellText := S;
    end;
  end;
end;

procedure TfrmMain.stXmlTreeInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
// Initialize the tree node; assign its corresponding Xml node and tell it if it
// has any children yes or no
var
  FData, FParentData: PNodeRec;
  FParentNode: TXmlNode;
begin
  if ParentNode = nil then
  begin
    // Root node
    if assigned(FXml) then
    begin
      FData := Sender.GetNodeData(Node);
      FData^.FNode := FXml.RootNodeList[Node.Index];
      InitialStates := [];
      if assigned(FData^.FNode) then
      begin
//        FData^.FNode.Tag := Node;   to-do
        // initial states
        if MultiNodeCount(FData^.FNode) > 0 then
          InitialStates := [ivsHasChildren];
      end;
    end;

  end else
  begin

    // We need to use the parent node
    FParentData := Sender.GetNodeData(ParentNode);
    FParentNode := FParentData.FNode;

    // Find the new node
    FData := Sender.GetNodeData(Node);
    if integer(Node.Index) < FParentNode.NodeCount then
    begin
      FData^.FNode := MultiNodeByIndex(FParentNode, Node.Index);
      InitialStates := [];
      if assigned(FData^.FNode) then
      begin
        FData^.FNode.Tag := 0;// todo Node;
        // initial states
        if MultiNodeCount(FData^.FNode) > 0 then
          InitialStates := [ivsHasChildren];
      end;
    end;

  end;
end;

procedure TfrmMain.stXmlTreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  FData: PNodeRec;
  ANode: TXmlNode;
begin
  // The image belonging to the treenode
  ImageIndex := -1;
  if Kind in [ikNormal, ikSelected] then
    if Column = 0 then
    begin
      FData := Sender.GetNodeData(Node);
      if assigned(FData) then
      begin
        ANode := FData.FNode;
        if assigned(ANode) then
          ImageIndex := ElementTypeToImageIndex(ANode.ElementType);
      end;
    end;
end;

procedure TfrmMain.Regenerate;
// Regenerate all screen elements, rebuilds the treeview
begin
  // Redraw XML tree
  stXmlTree.Clear;
  stXmlTree.RootNodeCount := 0;// todo FXml.RootContainerCount;

  // Properties pane
   RegenerateProperties;

  // Form caption
  if Length(FFileName) > 0 then
    Caption := Format('%s %s [%s]', [cFormHeader, cRelaxXmlVersion, FFilename])
  else
    Caption := Format('%s %s - No file selected', [cFormHeader, cRelaxXmlVersion]);

  // Update menu enabled/checked states
  UpdateMenu;
end;

procedure TfrmMain.RegenerateFromNode(ANode: TXmlNode);
var
  TreeNode: PVirtualNode;
begin
  if not assigned(ANode) then
  begin
    Regenerate;
    exit;
  end;
  TreeNode := pointer(ANode.Tag);
  if not assigned(TreeNode) then
  begin
    Regenerate;
    exit;
  end;
  stXmlTree.ResetNode(TreeNode);
  stXmlTree.Expanded[TreeNode] := True;
end;

procedure TfrmMain.RegenerateProperties;
// Invalidate the properties listview
begin
  stAttributes.Clear;
  stAttributes.RootNodeCount := MultiAttrCount(FFocusedNode);
end;

procedure TfrmMain.UpdateMenu;
begin
  BeginUpdate;
  try
    acOutputReadable.Checked := FXml.XmlFormat = xfReadable;
    acOutputCompact.Checked := FXml.XmlFormat = xfCompact;
    acOutputPreserve.Checked :=false;// todo FXml.XmlFormat = xfPreserve;
    acCanonicalXml.Checked := FMakeCanonicalXml;
  finally
     EndUpdate;
  end;
end;

procedure TfrmMain.stXmlTreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  VK_DELETE:
    // User pressed DEL
    acElementDeleteExecute(nil);
  end;//case
end;

procedure TfrmMain.acFileExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.acElementDeleteExecute(Sender: TObject);
// Delete the focused element
var
  AParent: TXmlNode;
begin
  if assigned(FFocusedNode) and (FFocusedNode <> FXml.Root) then
  begin
    AParent := FFocusedNode.Parent;
    AParent.NodeRemove(FFocusedNode);
    FFocusedNode := nil;
    RegenerateFromNode(AParent);
  end;
end;

procedure TfrmMain.acElementInsertBeforeExecute(Sender: TObject);
var
  AParent, ANode: TXmlNode;
begin
  if not assigned(FFocusedNode) then
    exit;
  AParent := FFocusedNode.Parent;
  if not assigned(AParent) then
  begin
    ShowMessage(sCannotInsertRootElement);
    exit;
  end;
  ANode := nil; //todo TsdElement.CreateParentNear(FXml, AParent, FFocusedNode, True);
  ANode.Name := 'element';
  RegenerateFromNode(AParent);
end;

procedure TfrmMain.acElementInsertAfterExecute(Sender: TObject);
var
  AParent, ANode: TXmlNode;
begin
  if not assigned(FFocusedNode) then
    exit;
  AParent := FFocusedNode.Parent;
  if AParent = nil then
  begin
    ShowMessage(sCannotInsertRootElement);
    exit;
  end;
  if assigned(AParent) then
  begin
    ANode := nil; // todo TsdElement.CreateParentNear(FXml, AParent, FFocusedNode, False);
    ANode.Name := 'element';
    RegenerateFromNode(AParent);
  end;
end;

procedure TfrmMain.acElementInsertSubExecute(Sender: TObject);
var
  ANode: TXmlNode;
begin
  if not assigned(FFocusedNode) then
    exit;
  ANode := nil; //todo TsdElement.CreateParent(FXml, FFocusedNode);
  ANode.Name := 'element';
  RegenerateFromNode(FFocusedNode);
end;

procedure TfrmMain.acCommentInsertExecute(Sender: TObject);
var
  AParent: TXmlNode;
begin
  if not assigned(FFocusedNode) then
    exit;
  AParent := FFocusedNode.Parent;
  if assigned(AParent) then
  begin
    // todo TsdComment.CreateParentNear(FXml, AParent, FFocusedNode, True);
    RegenerateFromNode(AParent);
  end;
end;

procedure TfrmMain.acElementUpExecute(Sender: TObject);
var
  Idx: integer;
  AParent: TXmlNode;
begin
  if not assigned(FFocusedNode) then
    exit;
  AParent := FFocusedNode.Parent;
  if assigned(AParent) then
  begin
    Idx := AParent.NodeIndexOf(FFocusedNode);
    if Idx > AParent.AttributeCount then
      AParent.NodeExchange(Idx - 1, Idx);
    RegenerateFromNode(AParent);
  end;
end;

procedure TfrmMain.acElementDownExecute(Sender: TObject);
var
  Idx: integer;
  AParent: TXmlNode;
begin
  if not assigned(FFocusedNode) then
    exit;
  AParent := FFocusedNode.Parent;
  if assigned(AParent) then
  begin
    Idx := AParent.NodeIndexOf(FFocusedNode);
    if Idx < AParent.NodeCount - 1 then
      AParent.NodeExchange(Idx, Idx + 1);
    RegenerateFromNode(AParent);
  end;
end;

procedure TfrmMain.stAttributesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  if not assigned(Node) then
  begin
    FFocusedAttributeIndex := -1;
    exit;
  end;
  FFocusedAttributeIndex := GetPropertyIndex(Node);
end;

procedure TfrmMain.stAttributesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  VK_DELETE:
    // User pressed DEL
    acAttributeDeleteExecute(nil);
  end;//case
end;

procedure TfrmMain.acAttributeAddExecute(Sender: TObject);
begin
  if assigned(FFocusedNode) then
    FFocusedNode.AttributeAdd('name', 'value');
  RegenerateProperties;
  RegenerateFromNode(FFocusedNode);
end;

procedure TfrmMain.acAttributeDeleteExecute(Sender: TObject);
//var
// todo   A: TsdAttribute;
begin
  if assigned(FFocusedNode) and (FFocusedAttributeIndex >= 0) then
  begin
// todo    A := FFocusedNode.Attributes[FFocusedAttributeIndex];
// todo    FFocusedNode.NodeRemove(A);
  end;
  RegenerateProperties;
  RegenerateFromNode(FFocusedNode);
end;

procedure TfrmMain.acAttributeUpExecute(Sender: TObject);
begin
  if assigned(FFocusedNode) and (FFocusedAttributeIndex > 0) then
    FFocusedNode.NodeExchange(FFocusedAttributeIndex - 1, FFocusedAttributeIndex);
  RegenerateProperties;
end;

procedure TfrmMain.acAttributeDownExecute(Sender: TObject);
begin
  if assigned(FFocusedNode) and (FFocusedAttributeIndex < FFocusedNode.AttributeCount - 1) then
    FFocusedNode.NodeExchange(FFocusedAttributeIndex, FFocusedAttributeIndex + 1);
  RegenerateProperties;
end;


procedure TfrmMain.acCanonicalXMLExecute(Sender: TObject);
begin
  FMakeCanonicalXml := acCanonicalXML.Checked;
end;

procedure TfrmMain.XmlProgress(Sender: TObject; Position: int64);
begin
  if FFileSize > 0 then
    pbMain.Position := round((Position / FFileSize) * 100);
end;

procedure TfrmMain.ShowXmlSource;
begin
//
end;

end.

