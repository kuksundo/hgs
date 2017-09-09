{ unit PropDialogs

  Implements a property dialog for files.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiPropertyDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, VirtualTrees, sdItems, sdMetadata,
  NativeXml, ImgList, sdAbcVars, sdAbcFunctions, sdProcessThread;

type

  TItemChanges = (icDescription, icAttributes, icExif, icId3, icCiff, icIptc);

  TfrmProps = class(TForm)
    btnOK: TBitBtn;
    BitBtn2: TBitBtn;
    btnApply: TBitBtn;
    BitBtn4: TBitBtn;
    pcTabs: TPageControl;
    tsGeneral: TTabSheet;
    tsTags: TTabSheet;
    Label1: TLabel;
    imIcon: TImage;
    lbFilename: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    lbFileType: TLabel;
    Label3: TLabel;
    lbLocation: TLabel;
    Label4: TLabel;
    lbSize: TLabel;
    Bevel2: TBevel;
    Label5: TLabel;
    lbModified: TLabel;
    Label6: TLabel;
    reDescription: TRichEdit;
    Bevel3: TBevel;
    Label7: TLabel;
    chbReadOnly: TCheckBox;
    chbArchive: TCheckBox;
    chbHidden: TCheckBox;
    chbSysFile: TCheckBox;
    Button1: TButton;
    vstTags: TVirtualStringTree;
    ilTags: TImageList;
    lbDimensions: TLabel;
    imPixRef: TImage;
    lblPixref: TLabel;
    Label8: TLabel;
    lbCRC32: TLabel;
    tsDecodingInfo: TTabSheet;
    chbShowDecodingInfo: TCheckBox;
    mmDecodingInfo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure vstTagsInitNode(Sender: TBaseVirtualTree;
      ParentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates);
    procedure vstTagsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstTagsExpanding(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var Allowed: Boolean);
    procedure vstTagsGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure reDescriptionChange(Sender: TObject);
    procedure chbReadOnlyClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure chbShowDecodingInfoClick(Sender: TObject);
  private
    FChanges: set of TItemChanges;
    FFile: TsdFile;
    FXml: TNativeXml;
    FRoot: TXmlNode;
    procedure ApplyChanges;
    procedure AddChange(AChange: TItemChanges);
    procedure GetDecodingInfo;
  public
    procedure FilePropsToDialog(AFile: TsdFile);
  end;

  PNodeRec = ^TNodeRec;
  TNodeRec = record
     FTag: TXmlNode;
  end;



var
  frmProps: TfrmProps;


implementation

uses
  {sdItems,} sdProperties, PixRefs, sdJpegImage;

{$R *.DFM}

procedure TfrmProps.ApplyChanges;
var
  Attr: integer;
begin
  if not assigned(FFile) then
    exit;

  // Item description
  if icDescription in FChanges then
  begin
    // Write the changed description to
    FFile.Description := reDescription.Text;
  end;

  // Attributes
  if icAttributes in FChanges then
  begin
{$warnings off}
    Attr := FileGetAttr(FFile.FileName);
    Attr := Attr and ($FFFF - (faReadonly + faArchive + faHidden + faSysFile));
    if chbReadOnly.Checked then Attr := Attr + faReadOnly;
    if chbArchive.Checked then  Attr := Attr + faArchive;
    if chbHidden.Checked then   Attr := Attr + faHidden;
    if chbSysFile.Checked then  Attr := Attr + faSysFile;
    FileSetAttr(FFile.Filename, Attr);
  end;
{$warnings on}
  // Update
  FFile.Update([ufListing]);

  FChanges := [];
  BtnApply.Enabled := False;
end;

procedure TfrmProps.AddChange(AChange: TItemChanges);
begin
  FChanges := FChanges + [AChange];
  btnApply.Enabled := True;
end;

procedure TfrmProps.FilePropsToDialog(AFile: TsdFile);
var
  Bitmap: TBitmap;
  S: TSearchRec;
  FS: TStream;
  AIcon: integer;
  AFileType: string;
  PixRef: TprPixRef;
begin
  FFile := AFile;
  if assigned(FFile) then
    with FFile do
    begin

      // Fill in the dialog's data
      lbFilename.Caption := Name;
      frmProps.Caption := Name + ' properties';
      GetIconAndType(AIcon, AFileType);
      lbFiletype.Caption := Format('%s (*%s)', [AFileType, ExtractFileExt(Name)]);
      lbLocation.Caption := ExcludeTrailingPathDelimiter(FolderName);
      lbSize.Caption :=
        Format('%3.1fMb / %3.1fKb / %s bytes',
          [Size / (1024*1024), Size / 1024, FormatFloat('#,##0', FFile.Size)]);
      if isDeleted in States then
        lbModified.Caption := 'Deleted'
      else
        lbModified.Caption := DateTimeToStr(Modified);
      if isCRCDone in States then
        lbCRC32.Caption := lowercase(IntToHex(CRC, 8))
      else
        lbCRC32.Caption := 'Not calculated';
      reDescription.Text := Description;
      // Dimensions
      if FFile.HasProperty(prDimensions) then
        lbDimensions.Caption := FFile.GetProperty(prDimensions).Value
      else
        lbDimensions.Caption := '';

      // Bitmap
      Application.ProcessMessages;
      Bitmap := TBitmap.Create;
      try
        RetrieveThumbnail(Bitmap, nil);
        if HasContent(Bitmap) then
        begin
          imIcon.Picture.Bitmap := TBitmap.Create;
          RescaleImage(Bitmap, imIcon.Picture.Bitmap, imIcon.Width, imIcon.Height,
            True, False, True);
        end else
        begin
          if (AIcon >= 0) and assigned(FLargeIcons) then
          begin
            FLargeIcons.GetBitmap(AIcon, Bitmap);
            imIcon.Picture.Assign(Bitmap);
          end;
        end;
      finally
        Bitmap.Free;
      end;

      // Pixel reference
      PixRef := TprPixRef(GetProperty(prPixRef));
      if assigned(PixRef) then
      begin
        lblPixRef.Caption := 'Image Metrics calculated';
      end else
      begin
        imPixRef.Picture.Bitmap := nil;
        lblPixRef.Caption := '';
      end;

      if FindFirst(FileName, faAnyFile, S) = 0 then
      begin
        // Attributes
{$warnings off}
        chbReadOnly.Visible := True;
        chbArchive.Visible := True;
        chbHidden.Visible := True;
        chbSysFile.Visible := True;
        chbReadOnly.Checked := (S.Attr and faReadOnly) > 0;
        chbArchive.Checked := (S.Attr and faArchive) > 0;
        chbHidden.Checked := (S.Attr and faHidden) > 0;
        chbSysFile.Checked := (S.Attr and faSysFile) > 0;
{$warnings on}

        // The tags
        FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
        try
          FRoot.Clear;
          // Tags? read them with Verbose = False
          sdReadMetadata(FS, 0, FRoot, False);
          FRoot.Name := 'Tags';
          FRoot.DeleteEmptyNodes;
          tsTags.TabVisible := FRoot.NodeCount > 0;

          // Redraw XML tree
          vstTags.Clear;
          if assigned(FRoot) then
            vstTags.RootNodeCount := FRoot.NodeCount;

        finally
          FS.Free;
        end;

        // Decoding info
        if chbShowDecodingInfo.Checked then
          GetDecodingInfo;

      end else
      begin
        // File not found
        chbReadOnly.Visible := False;
        chbArchive.Visible := False;
        chbHidden.Visible := False;
        chbSysFile.Visible := False;
      end;
      FindClose(S);

      // Control States
      btnApply.Enabled := False;
    end;
end;

procedure TfrmProps.FormCreate(Sender: TObject);
begin
  FXml := TNativeXml.CreateName('root');
  FRoot := FXml.Root;
  pcTabs.ActivePage := tsGeneral;
end;

procedure TfrmProps.vstTagsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var
  FData, FParentData: PNodeRec;
  FParentTag: TXmlNode;
begin
  if ParentNode = nil then
  begin

    // Root level
    FParentTag := FRoot;
    InitialStates := [ivsExpanded];

  end else
  begin

    // We need to use the parent node
    FParentData := Sender.GetNodeData(ParentNode);
    FParentTag := FParentData.FTag;
    InitialStates := [];

  end;

  // Find the new node
  FData := Sender.GetNodeData(Node);
  if integer(Node.Index) < FParentTag.NodeCount then
  begin
    FData^.FTag := FParentTag.Nodes[Node.Index];
    if assigned(FData^.FTag) then
    begin
      FData^.FTag := pointer(Node);
      // initial states
      if FData^.FTag.NodeCount > 0 then
        InitialStates := InitialStates + [ivsHasChildren];
    end;
  end;

end;

procedure TfrmProps.vstTagsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  FData: PNodeRec;
begin
  FData := Sender.GetNodeData(Node);
  if assigned(FData^.FTag) then
  begin
    Case Column of
    0: CellText := FData^.FTag.Name;
    1: CellText := FData^.FTag.Value;
    end;
  end;
end;

procedure TfrmProps.vstTagsExpanding(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var Allowed: Boolean);
var
  FData: PNodeRec;
begin
  with Sender do
  begin
    ChildCount[Node] := 0;
    FData := Sender.GetNodeData(Node);
    if assigned(FData^.FTag) then
      ChildCount[Node] := FData^.FTag.NodeCount;
    InvalidateToBottom(Node);
  end;
end;

procedure TfrmProps.vstTagsGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  // The image belonging to the treenode
  ImageIndex := -1;
  if Kind in [ikNormal, ikSelected] then
    case Column of
    0: begin
         ImageIndex := 0;
       end;
    end;//case
end;

procedure TfrmProps.FormDestroy(Sender: TObject);
begin
  FXml.Free;
end;

procedure TfrmProps.btnApplyClick(Sender: TObject);
begin
  ApplyChanges;
end;

procedure TfrmProps.reDescriptionChange(Sender: TObject);
begin
  AddChange(icDescription);
end;

procedure TfrmProps.chbReadOnlyClick(Sender: TObject);
begin
  AddChange(icAttributes);
end;

procedure TfrmProps.btnOKClick(Sender: TObject);
begin
  ApplyChanges;
end;

procedure TfrmProps.GetDecodingInfo;
//todo: what is the purpose when directly freed?
var
  Ext: string;
  Jpg: TsdJpegImage;
begin
  mmDecodingInfo.Clear;
  if not assigned(FFile) then
    exit;
  Ext := LowerCase(ExtractFileExt(FFile.FileName));
  if Ext = '.jpg' then
  begin
    Jpg := TsdJpegImage.Create(nil);
    try
      //Jpg.OnDebugOut := DoDebugOut;
      Jpg.LoadFromFile(FFile.FileName);
    finally
      Jpg.Free;
    end;
  end;
end;

procedure TfrmProps.chbShowDecodingInfoClick(Sender: TObject);
begin
  mmDecodingInfo.Visible := chbShowDecodingInfo.Checked;
  if chbShowDecodingInfo.Checked then
    GetDecodingInfo;
end;

{procedure TfrmProps.DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  glDebugComponent.DoDebugOut(Sender, WarnStyle, AMessage);
end;}

end.
