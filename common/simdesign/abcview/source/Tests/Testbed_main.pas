unit Testbed_main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ImgList, ShellAPI, FileCtrl, Mask, ToolEdit, ComCtrls,
  RXSpin, JPeg, XML, FileTags, dExif, VirtualTrees, OptionsManagers;

type
  TForm1 = class(TForm)
    ilSmall: TImageList;
    ilLarge: TImageList;
    Notebook1: TNotebook;
    Button1: TButton;
    Edit1: TEdit;
    Image2: TImage;
    Label1: TLabel;
    Image1: TImage;
    Edit2: TEdit;
    Button2: TButton;
    Label2: TLabel;
    feCRWFile: TFilenameEdit;
    Label3: TLabel;
    btnOpen: TButton;
    reInfo: TRichEdit;
    imCanon: TImage;
    btnExtractTags: TButton;
    chbSmoothing: TCheckBox;
    seGamma: TRxSpinEdit;
    Label4: TLabel;
    btnSaveJPG: TButton;
    btnSaveBMP: TButton;
    Label5: TLabel;
    seBright: TRxSpinEdit;
    sdCanon: TSaveDialog;
    chbHalfscale: TCheckBox;
    Label6: TLabel;
    feTagFile: TFilenameEdit;
    vstTags: TVirtualStringTree;
    Button3: TButton;
    Button4: TButton;
    btnSaveNoExif: TButton;
    sdJpg: TSaveDialog;
    procedure Button2Click(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnSaveJPGClick(Sender: TObject);
    procedure btnSaveBMPClick(Sender: TObject);
    procedure btnExtractTagsClick(Sender: TObject);
    procedure vstTagsInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstTagsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: Integer; TextType: TVSTTextType; var CellText: WideString);
    procedure vstTagsExpanding(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var Allowed: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnSaveNoExifClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    XML: TXMLObject;
  end;

  PNodeRec = ^TNodeRec;
  TNodeRec = record
     FTag: TXMLObject;
  end;

var
  Form1: TForm1;

implementation

uses
  CanonCRWs, CodecsJPG;

{$R *.DFM}

procedure TForm1.Button2Click(Sender: TObject);
begin
  if DirectoryExists(Edit2.Text) then
    Label2.Caption := 'Directory exists!'
  else
    Label2.Caption := 'Directory does not exist'
end;

procedure TForm1.btnOpenClick(Sender: TObject);
var
  F, S: TStream;
  Bitmap: TBitmap;
  Info: string;
begin
  if FileExists(feCRWFile.Text) then begin
    F := TFileStream.Create(feCRWFile.Text, fmOpenRead or fmShareDenyNone);
    try
      S := TMemoryStream.Create;
      try
        S.CopyFrom(F, F.Size);
        S.Seek(0, soFromBeginning);
        Bitmap := TBitmap.Create;
        try
          imCanon.Picture := nil;
          gamma_val := seGamma.Value;
          bright := seBright.Value;
          additional_smoothing := chbSmoothing.Checked;
          half_scale := chbHalfscale.Checked;
          if ReadCanonRaw(S, ExtractFileName(feCRWFile.Text), reInfo.Lines, Bitmap) then begin
            imCanon.Picture.Assign(Bitmap);
          end;
        finally
          Bitmap.Free;
        end;
      finally
        S.Free;
      end;
    finally
      F.Free;
    end;
  end else begin
    ShowMessage(Format('Unable to open %s', [feCRWFile.Text]))
  end;
end;

procedure TForm1.btnSaveJPGClick(Sender: TObject);
var
  JPG: TJPegImage;
begin
  sdCanon.Filter := 'JPG file (*.jpg)|*.jpg';
  sdCanon.DefaultExt := 'jpg';
  sdCanon.InitialDir := ExtractFileDir(feCRWFile.Text);
  if not sdCanon.Execute then exit;

  if assigned(imCanon.Picture.Bitmap) then begin
    // save as JPG
    JPG := TJPegImage.Create;
    try
      JPG.Assign(imCanon.Picture.Bitmap);
      JPG.SaveToFile(sdCanon.FileName);
    finally
      JPG.Free;
    end;
  end;
end;

procedure TForm1.btnSaveBMPClick(Sender: TObject);
begin
  sdCanon.Filter := 'Windows Bitmap file (*.bmp)|*.bmp';
  sdCanon.DefaultExt := 'bmp';
  sdCanon.InitialDir := ExtractFileDir(feCRWFile.Text);
  if not sdCanon.Execute then exit;

  if assigned(imCanon.Picture.Bitmap) then begin
    // save as BMP
    imCanon.Picture.Bitmap.SaveToFile(sdCanon.FileName);
  end;
end;
{.$DEFINE OLDMETHOD}

procedure TForm1.btnExtractTagsClick(Sender: TObject);
var
  S: TStream;
begin
  if FileExists(feTagFile.Text) then begin
    S := TFileStream.Create(feTagFile.Text, fmOpenRead or fmShareDenyNone);
    XML := TXMLObject.Create;
    XML.Name := 'Tags';
    try
      // Read the tags
{$IFDEF OLDMETHOD}
      ImageInfo.XML := XML.ChildAdd('Exif', '');
      ProcessFile(S, '.tif');
{$ELSE}
      ReadStreamTags(S, XML, True);
{$ENDIF}
      // Redraw XML tree
      vstTags.Clear;
      if assigned(XML) then begin
//        XML.ChildsPurgeEmpty;
        vstTags.RootNodeCount := XML.ChildCount;
      end;

    finally
      S.Free;
    end;
  end;
end;

procedure TForm1.vstTagsInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  FData, FParentData: PNodeRec;
  FParentTag: TXMLObject;
begin
  if ParentNode = nil then begin

    // Root level
    FParentTag := XML;
    InitialStates := [ivsExpanded];

  end else begin

    // We need to use the parent node
    FParentData := Sender.GetNodeData(ParentNode);
    FParentTag := FParentData.FTag;
    InitialStates := [];

  end;

  // Find the new node
  FData := Sender.GetNodeData(Node);
  if Node.Index < FParentTag.ChildCount then begin
    FData^.FTag := FParentTag.Childs[Node.Index];
    if assigned(FData^.FTag) then begin
      FData^.FTag.FNode := Node;
      // initial states
      if FData^.FTag.ChildCount > 0 then
        InitialStates := InitialStates + [ivsHasChildren];
    end;
  end;
  Node.CheckType := ctTristateCheckbox;
  Node.CheckState := csUncheckedNormal;
end;

procedure TForm1.vstTagsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: Integer; TextType: TVSTTextType;
  var CellText: WideString);
var
  FData: PNodeRec;
begin
  FData := Sender.GetNodeData(Node);
  if assigned(FData^.FTag) then with FData^.FTag do begin
    Case Column of
    0: CellText := Name;
    1:
      begin
        SetLength(CellText, length(Value));
        CellText := Widestring(Value);
      end;
    end;
  end;
end;

procedure TForm1.vstTagsExpanding(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var Allowed: Boolean);
var
  FData: PNodeRec;
begin
  with Sender do begin
    ChildCount[Node] := 0;
    FData := Sender.GetNodeData(Node);
    if assigned(FData^.FTag) then
      ChildCount[Node] := FData^.FTag.ChildCount;
    InvalidateToBottom(Node);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Opt.AddInt(3, 15, 'test', 'firstopt');
  Opt.AddArr(5, odString, 'strings', 'secondopt');

  Opt[3].Int := 16;
  Opt[5].Arr[13].Str := 'Second string!';
  Opt[5].Arr[10].Str := 'First string!';
  Opt[5].Arr[4].Str := 'grinny!';

  Opt.SaveToIni('test.ini');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Opt.AddInt(3, 15, 'test', 'firstopt');
  Opt.AddArr(5, odString, 'strings', 'secondopt');
  Opt.LoadFromIni('test.ini');
  Opt.SaveToIni('test2.ini');
end;

procedure TForm1.btnSaveNoExifClick(Sender: TObject);
var
  S, M, D: TStream;
  Jpg: TJpgCodec;
begin
  if FileExists(feTagFile.Text) then begin
    S := TFileStream.Create(feTagFile.Text, fmOpenRead or fmShareDenyNone);
    try
      Jpg := TJpgCodec.Create;
      M := TMemoryStream.Create;
      try
        Jpg.LoadFromStream(S);
        if Jpg.HasError then begin
          ShowMessage(Jpg.Error);
          Jpg.Error := '';
        end;
        Jpg.StripMarkers([mtEXIF, mtFPXR, mtIPTC, mtCOM, mtUnknown]);
        Jpg.SaveToStream(M);
        if length(Jpg.Error) = 0 then begin
          if sdJpg.Execute then begin
            D := TFileStream.Create(sdJpg.FileName, fmCreate or fmShareExclusive);
            try
              M.Position := 0;
              D.CopyFrom(M, M.Size);
            finally
              D.Free;
            end;
          end;
        end else begin
          ShowMessage(Jpg.Error);
        end;
      finally
        Jpg.Free;
        M.Free;
      end;
    finally
      S.Free;
    end;
  end;
end;

end.
