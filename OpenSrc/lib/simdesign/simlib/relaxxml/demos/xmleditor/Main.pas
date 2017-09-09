{ Unit Main

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

  copyright (c) 2001 - 2008 Nils Haeck  www.simdesign.nl

  This source of this editor may be used in freeware or commercial applications
  provided that:
  - this notice stays intact and that a mention of contribution is made
    in the "about" box. A mention of www.simdesign.nl would be appreciated.
  - A license is purchased for NativeXml.pas

}
unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, ImgList, ComCtrls, ToolWin, ExtCtrls, VirtualTrees, Menus,
  StdCtrls, NativeXml;

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
    acSingleNodeAsAttrib: TAction;
    mnuOptions: TMenuItem;
    ilData: TImageList;
    tsXmlSource: TTabSheet;
    mmXMLSource: TMemo;
    acFileSaveAs: TAction;
    sdFileSave: TSaveDialog;
    tbSave: TToolButton;
    mnuSave: TMenuItem;
    acHideSingleNodes: TAction;
    Singlenodesastags1: TMenuItem;
    Hidesinglenodes1: TMenuItem;
    acReadableNames: TAction;
    Readablenamesfornodes1: TMenuItem;
    Edit1: TMenuItem;
    acAddComment: TAction;
    acAddStyleSheet: TAction;
    AddComment1: TMenuItem;
    AddStylesheet1: TMenuItem;
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
    procedure acFileOpenExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure stXmlTreeInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure stXmlTreeExpanding(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var Allowed: Boolean);
    procedure stXmlTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure acFileSaveAsExecute(Sender: TObject);
    procedure acSingleNodeAsAttribExecute(Sender: TObject);
    procedure acFileNewExecute(Sender: TObject);
    procedure acHideSingleNodesExecute(Sender: TObject);
    procedure acReadableNamesExecute(Sender: TObject);
    procedure pcTreeChange(Sender: TObject);
    procedure acAddCommentExecute(Sender: TObject);
    procedure acAddStyleSheetExecute(Sender: TObject);
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
    procedure acLoadFromURLExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FXmlDoc: TNativeXml;    // Xml document currently displayed
    FFileName: string;      // Last opened filename
    FFocusedNode: TXmlNode; // Focused TXmlNode
    FFocusedAttributeIndex: integer;
    FUpdateCount: integer;   // If 0 we can update otherwise we're in begin/end update block
    procedure GetPropertyInfo(Node: PVirtualNode;
      var IsAttribute: boolean; var Index: integer);
    procedure Regenerate;
    procedure RegenerateFromNode(ANode: TXmlNode);
    procedure RegenerateProperties;
    function ElementTypeToImageIndex(AElementType: TXmlElementType): integer;
    function IsSingleNode(ANode: TXmlNode): boolean;
    function NiceString(const Value: UTF8String): UTF8String;
    function MultiAttrCount(ANode: TXmlNode): integer;
    function MultiNodeCount(ANode: TXmlNode): integer;
    function MultiNodeByIndex(ANode: TXmlNode; AIndex: integer): TXmlNode;
    procedure XmlUnicodeLoss(Sender: TObject);
    procedure UpdateMenu;
  public
    procedure BeginUpdate;
    function IsUpdating: boolean;
    procedure EndUpdate;
  end;

var
  frmMain: TfrmMain;

const

  cAppVersion        = 'v2.1';
  cFormHeader        = 'Xml Editor (c) 2001-2008 SimDesign B.V.';
  cDefaultStyleSheet = 'mystylesheet.xsl';

resourcestring
  sCannotInsertRootElement = 'You cannot insert another root element!';

implementation

uses WinInet;

{$R *.DFM}

type
  // This is the node record that is appended to each node in the virtual treeview
  PNodeRec = ^TNodeRec;
  TNodeRec = record
     FNode: TXmlNode;
  end;

procedure DownloadURLStream(const Url: string; Dest: TStream);
var
  NetHandle: HINTERNET;
  UrlHandle: HINTERNET;
  Buffer: array[0..1024] of Char;
  BytesRead: dWord;
begin
  if not assigned(Dest) then
    exit;
  Dest.Size := 0;
  NetHandle := InternetOpen('Delphi', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);

  if Assigned(NetHandle) then
  begin

    UrlHandle := InternetOpenUrl(NetHandle, PChar(Url), nil, 0, INTERNET_FLAG_RELOAD, 0);

    if Assigned(UrlHandle) then
    begin
      // UrlHandle valid? Proceed with download
      FillChar(Buffer, SizeOf(Buffer), 0);
      repeat
        InternetReadFile(UrlHandle, @Buffer, SizeOf(Buffer), BytesRead);
        if BytesRead > 0 then
          Dest.Write(Buffer, BytesRead);
      until BytesRead = 0;
      InternetCloseHandle(UrlHandle);
    end else
      // UrlHandle is not valid. Raise an exception.
      raise Exception.CreateFmt('Cannot open URL %s', [Url]);

    InternetCloseHandle(NetHandle);
  end else
    // NetHandle is not valid. Raise an exception
    raise Exception.Create('Unable to initialize Wininet');
end;

{ TFrmMain }

procedure TfrmMain.acAddCommentExecute(Sender: TObject);
begin
  FXmlDoc.CommentString := UTF8String(InputBox('Add a comment', 'Comment:', string(FXmlDoc.CommentString)));
end;

procedure TfrmMain.acAddStyleSheetExecute(Sender: TObject);
var
  S: UTF8String;
begin
  S := FXmlDoc.StyleSheetNode.AttributeByName['href'];
  if Length(S) = 0 then
    S := cDefaultStyleSheet;
  FXmlDoc.StyleSheetNode.AttributeByName['href'] := UTF8String(InputBox('Add stylesheet string', 'Stylesheet string:', string(S)));
end;

procedure TfrmMain.acHideSingleNodesExecute(Sender: TObject);
begin
  acHideSingleNodes.Checked := not acHideSingleNodes.Checked;
  Regenerate;
end;

procedure TfrmMain.acFileNewExecute(Sender: TObject);
// Create a blank Xml document with a blank root
begin
  FXmlDoc.Clear;
  // Set to UTF8
  FXmlDoc.EncodingString := 'UTF-8';
  FXmlDoc.ExternalEncoding := seUTF8;
  FXmlDoc.Root.Name := 'root';
  Regenerate;
end;

procedure TfrmMain.acFileOpenExecute(Sender: TObject);
begin
  // Open an new setup
  if odFileOpen.Execute then
  begin
    FFileName := odFileOpen.FileName;
    try
      FXmlDoc.LoadFromFile(FFilename);
      // if you want to resolve all the entity references, then uncomment the next line
      // FXmlDoc.ResolveEntityReferences;
      // Display properties on statusbar
      with FXmlDoc do
      begin
        sbMain.SimpleText := Format('Version="%s"', [VersionString]);
        if Length(EncodingString) > 0 then
          sbMain.SimpleText := sbMain.SimpleText +
            Format(' Encoding="%s"', [EncodingString]);
      end;
    except
      // Show exception on status bar
      on E: Exception do
        sbMain.SimpleText := E.Message;
    end;
    Regenerate;
  end;
end;

procedure TfrmMain.acLoadFromURLExecute(Sender: TObject);
var
  URL: string;
  M: TMemoryStream;
begin
  // Ask user for URL
  URL := InputBox('Which URL to download?', 'URL:', '');
  // Setup memory stream
  M := TMemoryStream.Create;
  try
    // Download URL to memory stream
    DownloadURLStream(URL, M);
    // Load from this stream
    FXmlDoc.LoadFromStream(M);
    // Regenerate views
    Regenerate;
  finally
    M.Free;
  end;
end;

procedure TfrmMain.acFileSaveAsExecute(Sender: TObject);
begin
  // Save a file
  if sdFileSave.Execute then
  begin
    FFileName := sdFileSave.FileName;
    FXmlDoc.SaveToFile(FFilename);
    Regenerate;
  end;
end;

procedure TfrmMain.acOutputReadableExecute(Sender: TObject);
begin
  if IsUpdating then
    exit;
  case FXmlDoc.XmlFormat of
  xfReadable: FXmlDoc.XmlFormat := xfCompact;
  xfCompact:  FXmlDoc.XmlFormat := xfReadable;
  end;
  UpdateMenu;
end;

procedure TfrmMain.acReadableNamesExecute(Sender: TObject);
begin
  acReadableNames.Checked := not acReadableNames.Checked;
  Regenerate;
end;

procedure TfrmMain.acSingleNodeAsAttribExecute(Sender: TObject);
begin
  acSingleNodeAsAttrib.Checked := not acSingleNodeAsAttrib.Checked;
  if acSingleNodeAsAttrib.Checked then
    tsTags.Caption := 'Attributes and child elements'
  else
    tsTags.Caption := 'Attributes';
  RegenerateProperties;
end;

procedure TfrmMain.BeginUpdate;
begin
  inc(FUpdateCount);
end;

function TfrmMain.ElementTypeToImageIndex(
  AElementType: TXmlElementType): integer;
begin
  case AElementType of
  xeNormal:      Result := 1;
  xeComment:     Result := 2;
  xeCData:       Result := 3;
  xeCharData:    Result := 4;
  xeDeclaration: Result := 5;
  xeStylesheet:  Result := 6;
  xeDoctype:     Result := 7;
  xeElement:     Result := 8;
  xeAttList:     Result := 9;
  xeEntity:      Result := 10;
  xeNotation:    Result := 11;
  xeExclam:      Result := 12;
  xeQuestion:    Result := 13;
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
  FXmlDoc := TNativeXml.Create;
  FXmlDoc.OnUnicodeLoss := XmlUnicodeLoss;
  // Open cmdline parameter 1 file (when associated with this tool)
  if length(ParamStr(1)) > 0 then
  begin
    FXmlDoc.LoadFromFile(ParamStr(1));
    Regenerate;
  end else
    acFileNew.Execute;
  FFocusedAttributeIndex := -1;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FXmlDoc.Free;
end;

function TfrmMain.IsSingleNode(ANode: TXmlNode): boolean;
begin
  Result := True;
  if assigned(ANode) then
    if (ANode.NodeCount > 0) or (ANode.AttributeCount > 0) then
      Result := False;
end;

function TfrmMain.IsUpdating: boolean;
begin
  Result := FUpdateCount > 0;
end;

procedure TfrmMain.GetPropertyInfo(Node: PVirtualNode;
  var IsAttribute: boolean; var Index: integer);
var
  AIndex, ANodeIndex: integer;
begin
  IsAttribute := True;
  Index := -1;
  // Get the data of the tag's properties
  if assigned(FFocusedNode) then with FFocusedNode do
  begin
    AIndex := Node.Index;
    // Attributes
    if (AIndex >= 0) and (AIndex < AttributeCount) then
    begin
      Index := AIndex;
      exit;
    end;
    // Special feature: show single nodes as attribute
    AIndex := AIndex - AttributeCount;
    if acSingleNodeAsAttrib.Checked then
    begin
      // Find the single node at AIndex
      ANodeIndex := -1;
      while AIndex >= 0 do
      begin
        inc(ANodeIndex);
        if not assigned(Nodes[ANodeIndex]) then
          exit;
        if IsSingleNode(Nodes[ANodeIndex]) then
          dec(AIndex);
      end;
      if assigned(Nodes[ANodeIndex]) then
      begin
        IsAttribute := False;
        Index := ANodeIndex;
      end;
    end;
  end;
end;

procedure TfrmMain.stAttributesGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  IsAttribute: boolean;
  Index: integer;
  ANode: TXmlNode;
begin
  GetPropertyInfo(Node, IsAttribute, Index);
  if Index < 0 then
    exit;
  if IsAttribute then
  begin
    case Column of
    0: CellText := widestring(NiceString(FFocusedNode.AttributeName[Index]));
    1: CellText := FFocusedNode.ToUnicodeString(FFocusedNode.AttributeValue[Index]);
    end;//case
  end else
  begin
    ANode := FFocusedNode.Nodes[Index];
    case Column of
    0: CellText := widestring(NiceString(ANode.Name));
    1: CellText := ANode.ValueAsUnicodeString;
    end;//case
  end;
end;

procedure TfrmMain.stAttributesGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  IsAttribute: boolean;
  Index: integer;
begin
  ImageIndex := -1;
  if Kind = ikOverlay then
    exit;
  if Column > 0 then
    exit;
  GetPropertyInfo(Node, IsAttribute, Index);
  if Index < 0 then
    exit;
  if IsAttribute then
    ImageIndex := 0
  else
    ImageIndex := ElementTypeToImageIndex(FFocusedNode.Nodes[Index].ElementType);
end;

procedure TfrmMain.stAttributesEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := True;
end;

procedure TfrmMain.stAttributesNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
var
  IsAttribute: boolean;
  Index: integer;
  ANode: TXmlNode;
begin
  GetPropertyInfo(Node, IsAttribute, Index);
  if Index < 0 then
    exit;
  if IsAttribute then
  begin
    case Column of
    0: FFocusedNode.AttributeName[Index] := UTF8String(NewText);
    1: FFocusedNode.AttributeValue[Index] := FFocusedNode.FromUnicodeString(NewText);
    end;//case
  end else
  begin
    ANode := FFocusedNode.Nodes[Index];
    case Column of
    0: ANode.Name := UTF8String(NewText);
    1: ANode.ValueAsUnicodeString := NewText;
    end;//case
  end;
end;

function TfrmMain.MultiAttrCount(ANode: TXmlNode): integer;
// Count the attributes, but if acSingleNodeAsAttrib is checked we also add
// the single nodes
var
  i: integer;
begin
  Result := 0;
  if not assigned(ANode) then
    exit;
  Result := ANode.AttributeCount;
  if acSingleNodeAsAttrib.Checked then
    for i := 0 to ANode.NodeCount - 1 do
      if IsSingleNode(ANode[i]) then
        inc(Result);
end;

function TfrmMain.MultiNodeByIndex(ANode: TXmlNode;
  AIndex: integer): TXmlNode;
// Return the child node of ANode at AIndex, taking into account the setting for
// acHideSingleNodes
var
  i: integer;
begin
  Result := nil;
  if assigned(ANode) then with ANode do
  begin
    if acHideSingleNodes.Checked then
    begin
      for i := 0 to NodeCount - 1 do
        if not IsSingleNode(Nodes[i]) then
        begin
          dec(AIndex);
          if AIndex < 0 then
          begin
            Result := Nodes[i];
            exit;
          end;
        end;
    end else
      Result := Nodes[AIndex];
  end;
end;

function TfrmMain.MultiNodeCount(ANode: TXmlNode): integer;
// Count the number of nodes, taking into account the setting for acHideSingleNodes
var
  i: integer;
begin
  Result := 0;
  if assigned(ANode) then with ANode do
  begin
    if acHideSingleNodes.Checked then
    begin
      for i := 0 to NodeCount - 1 do
        if not IsSingleNode(Nodes[i]) then
          inc(Result)
    end else
      Result := NodeCount;
  end;
end;

function TfrmMain.NiceString(const Value: UTF8String): UTF8String;
begin
  if acReadableNames.Checked then
  begin
    Result := UTF8String(Lowercase(string(Value)));
    if (length(Value) > 0) and (Result[1] in ['a'..'z']) then
      Result[1] := UpCase(Result[1]);
  end else
    Result := Value;
end;

procedure TfrmMain.pcTreeChange(Sender: TObject);
var
  OldFormat: TXmlFormatType;
begin
  if (pcTree.ActivePage = tsXmlSource) then
  begin
    // Show our Xml Document in readable format
    Oldformat := FXmlDoc.XmlFormat;
    try
      FXmlDoc.XmlFormat := xfReadable;
      if FXmlDoc.IsEmpty then
        mmXmlSource.Text := ''
      else
        mmXMLSource.Text := string(FXmlDoc.WriteToString);
    finally
      FXmlDoc.XmlFormat := OldFormat;
    end;
  end;
end;

procedure TfrmMain.stXmlTreeChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
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
  0: FData.FNode.Name := UTF8String(NewText);
  1: FData.FNode.ValueAsUnicodeString := NewText;
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
begin
  FData := Sender.GetNodeData(Node);
  if assigned(FData^.FNode) then
  begin
    Case Column of
    0: CellText := widestring(NiceString(FData^.FNode.Name));
    // As can be seen here, both XmlDocuments as TVirtualTreeview support
    // widestring, so you can view your differently-encoded XML documents correctly
    1: CellText := FData^.FNode.ValueAsUnicodeString;
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
    if assigned(FXmlDoc) then
    begin
      FData := Sender.GetNodeData(Node);
      FData^.FNode := FXmlDoc.RootNodeList.Nodes[Node.Index];
      InitialStates := [];
      if assigned(FData^.FNode) then
      begin
        FData^.FNode.Tag := integer(Node);
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
        FData^.FNode.Tag := integer(Node);
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
  stXmlTree.RootNodeCount := FXmlDoc.RootNodeList.NodeCount;
  // Properties pane
  RegenerateProperties;
  // Form caption
  if Length(FFileName) > 0 then
    Caption := Format('%s %s [%s]', [cFormHeader, cAppVersion, FFilename])
  else
    Caption := Format('%s %s - No file selected', [cFormHeader, cAppVersion]);
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
    acOutputReadable.Checked := FXmlDoc.XmlFormat = xfReadable;
  finally
     EndUpdate;
  end;
end;

procedure TfrmMain.XmlUnicodeLoss(Sender: TObject);
// The TXmlDocument event OnUnicodeLoss was called. This means some characters in the
// XML document cannot be converted to ANSI and may lead to a loss if saved to the
// same file.
begin
  MessageDlg(
    'WARNING: Some characters in this unicode XML document cannot be converted to the'#13 +
    'internal Ansi representation. Do NOT save the XML document under the same name if you'#13 +
    'want to preserve the original unicode characters.', mtWarning, [mbOK], 0);
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
  if assigned(FFocusedNode) and (FFocusedNode <> FXmlDoc.Root) then
  begin
    AParent := FFocusedNode.Parent;
    FFocusedNode.Delete;
    FFocusedNode := nil;
    RegenerateFromNode(AParent);
  end;
end;

procedure TfrmMain.acElementInsertBeforeExecute(Sender: TObject);
var
  AParent, ANode: TXmlNode;
begin
  if not assigned(FFocusedNode) then exit;
  AParent := FFocusedNode.Parent;
  if AParent = FXmlDoc.RootNodeList then
  begin
    ShowMessage(sCannotInsertRootElement);
    exit;
  end;
  if assigned(AParent) then
  begin
    ANode := TXmlNode.Create(FXmlDoc);
    ANode.Name := 'element';
    AParent.NodeInsert(AParent.NodeIndexOf(FFocusedNode), ANode);
    RegenerateFromNode(AParent);
  end;
end;

procedure TfrmMain.acElementInsertAfterExecute(Sender: TObject);
var
  AParent, ANode: TXmlNode;
begin
  if not assigned(FFocusedNode) then exit;
  AParent := FFocusedNode.Parent;
  if AParent = FXmlDoc.RootNodeList then
  begin
    ShowMessage(sCannotInsertRootElement);
    exit;
  end;
  if assigned(AParent) then
  begin
    ANode := TXmlNode.Create(FXmlDoc);
    ANode.Name := 'element';
    AParent.NodeInsert(AParent.NodeIndexOf(FFocusedNode) + 1, ANode);
    RegenerateFromNode(AParent);
  end;
end;

procedure TfrmMain.acElementInsertSubExecute(Sender: TObject);
var
  ANode: TXmlNode;
begin
  if not assigned(FFocusedNode) then
    exit;
  ANode := TXmlNode.Create(FXmlDoc);
  ANode.Name := 'element';
  FFocusedNode.NodeInsert(0, ANode);
  RegenerateFromNode(FFocusedNode);
end;

procedure TfrmMain.acCommentInsertExecute(Sender: TObject);
var
  AParent, ANode: TXmlNode;
begin
  if not assigned(FFocusedNode) then
    exit;
  AParent := FFocusedNode.Parent;
  if assigned(AParent) then
  begin
    ANode := TXmlNode.Create(FXmlDoc);
    ANode.ElementType := xeComment;
    ANode.Name := 'comment';
    AParent.NodeInsert(AParent.NodeIndexOf(FFocusedNode), ANode);
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
    if Idx > 0 then
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

procedure TfrmMain.stAttributesChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  IsAttribute: boolean;
  Index: integer;
begin
  if not assigned(Node) then
  begin
    FFocusedAttributeIndex := -1;
    exit;
  end;
  GetPropertyInfo(Node, IsAttribute, Index);
  if IsAttribute then
    FFocusedAttributeIndex := Index
  else
    FFocusedAttributeIndex := -1;
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
    FFocusedNode.AttributeAdd('attribute', '');
  RegenerateProperties;
end;

procedure TfrmMain.acAttributeDeleteExecute(Sender: TObject);
begin
  if assigned(FFocusedNode) and (FFocusedAttributeIndex >= 0) then
    FFocusedNode.AttributeDelete(FFocusedAttributeIndex);
  RegenerateProperties;
end;

procedure TfrmMain.acAttributeUpExecute(Sender: TObject);
begin
  if assigned(FFocusedNode) and (FFocusedAttributeIndex > 0) then
    FFocusedNode.AttributeExchange(FFocusedAttributeIndex - 1, FFocusedAttributeIndex);
  RegenerateProperties;
end;

procedure TfrmMain.acAttributeDownExecute(Sender: TObject);
begin
  if assigned(FFocusedNode) and (FFocusedAttributeIndex < FFocusedNode.AttributeCount - 1) then
    FFocusedNode.AttributeExchange(FFocusedAttributeIndex, FFocusedAttributeIndex + 1);
  RegenerateProperties;
end;

end.
