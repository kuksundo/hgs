{
  Unit dtpExposedMetafile

  TdtpExposedMetafile is a TdtpEffectShape descendant that can be used to show
  metafiles (either normal or enhanced). It is called "exposed" because it
  can override some of the internal settings of the metafile, like pen widths
  and brushes.

  Project: DTP-Engine

  Creation Date: 12-08-2003 (NH)
  Version: 1.0

  Modifications:

  Copyright (c) 2003 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit dtpExposedMetafile;

{$i simdesign.inc}

interface

uses
  Classes, Windows, Graphics, SysUtils, dtpShape, NativeXmlOld, dtpXmlBitmaps,
  dtpEffectShape, dtpResource, dtpDefaults;

type

  // TdtpExposedMetafile is able to show Windows WMF and EMF metafiles. It is called
  // "exposed" because it exposes the individual elements in the metafile for post-
  // processing. The metafiles are rendered at the internal cache resolution.
  TdtpExposedMetafile = class(TdtpEffectShape)
  private
    FOverrideBrush: boolean; // Override the brushes used in the metafile
    FOverridePen: boolean;   // Override the pens used in the metafile
    FBrush: TBrush;          // The brush to use when overriding
    FPen: TPen;              // The pen to use when overriding
    FImage: TdtpResource;    // The actual metafile is held in this resource
    function DrawMetaRecord(DC: HDC; lpHTable: PHANDLETABLE; lpEMFR: PENHMETARECORD;
      nObj: integer): integer; virtual;
    procedure PropsChanged(Sender: TObject);
    procedure ResourceObjFromStream(Sender: TObject; var AObjectRef: TObject);
    procedure ResourceAfterLoadFromFile(Sender: TObject);
    procedure SetPen(const Value: TPen);
    procedure SetBrush(const Value: TBrush);
    procedure SetOverrideBrush(const Value: boolean);
    procedure SetOverridePen(const Value: boolean);
  protected
    procedure AddArchiveResourceNames(Names: TStrings); override;
    procedure Paint(Canvas: TCanvas; const Device: TDeviceContext); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    class function UseCanvasPainting: boolean; override;
    procedure LoadFromXml(ANode: TXmlNodeOld); override;
    procedure SaveToXml(ANode: TXmlNodeOld); override;
    property Brush: TBrush read FBrush write SetBrush;
    property Image: TdtpResource read FImage write FImage;
    property OverridePen:   boolean read FOverridePen   write SetOverridePen;
    property OverrideBrush: boolean read FOverrideBrush write SetOverrideBrush;
    property Pen: TPen read FPen write SetPen;
  end;

implementation

// This function is called from EnumEnhMetaFile in the Paint procedure
function EnhMetafileProc(DC: HDC; lpHTable: PHANDLETABLE; lpEMFR: PENHMETARECORD;
  nObj: Integer; AShape: TdtpExposedMetafile): Integer; stdcall;
begin
  Result := 0;
  // Use the aux parameter to call the correct shape's DrawMetaRecord
  if assigned(AShape) then
    Result := AShape.DrawMetaRecord(DC, lpHTable, lpEMFR, nObj);
end;

{ TdtpExposedMetafile }

procedure TdtpExposedMetafile.AddArchiveResourceNames(Names: TStrings);
begin
  inherited;
  FImage.AddArchiveResourceNames(Names);
end;

constructor TdtpExposedMetafile.Create;
begin
  inherited;
  FBrush := TBrush.Create;
  FBrush.OnChange := PropsChanged;
  FPen := TPen.Create;
  FPen.OnChange := PropsChanged;
  // Create a resource for our metafile
  FImage := TdtpResource.Create;
  // Make sure that when loading the object it uses the metafile method
  FImage.OnObjectFromStream := ResourceObjFromStream;
  FImage.OnAfterLoadFromFile  := ResourceAfterLoadFromFile;
end;

destructor TdtpExposedMetafile.Destroy;
begin
  FreeAndNil(FImage);
  FreeAndNil(FPen);
  FreeAndNil(FBrush);
  inherited;
end;

function TdtpExposedMetafile.DrawMetaRecord(DC: HDC;
  lpHTable: PHANDLETABLE; lpEMFR: PENHMETARECORD; nObj: integer): integer;
var
  OldPen: HPen;
  OldBrush: HBrush;
begin
  OldPen   := 0;
  OldBrush := 0;
  // We can select a different brush and pen into the DC in order to change the
  // appearance of the metafile
  if OverridePen and assigned(Pen) then
    OldPen := SelectObject(DC, Pen.Handle);
  if OverrideBrush and assigned(Brush) then
    OldBrush := SelectObject(DC, Brush.Handle);

  // Draw the metafile records
  PlayEnhMetaFileRecord(DC, lpHTable^, lpEMFR^, nObj);

  if OverridePen and assigned(Pen) then
    SelectObject(DC, OldPen);
  if OverrideBrush and assigned(Brush) then
    SelectObject(DC, OldBrush);

  // Conclude with non-zero result to continue enumeration
  Result := 1;
end;

procedure TdtpExposedMetafile.LoadFromXml(ANode: TXmlNodeOld);
var
  ABitmap: TBitmap;
begin
  inherited;
  FImage.LoadFromXml(ANode.NodeByName('Image'));
  OverridePen := ANode.ReadBool('OverridePen');
  if OverridePen then
    ANode.ReadPen('Pen', Pen);
  OverrideBrush := ANode.ReadBool('OverrideBrush');
  if OverrideBrush then
  begin
    ANode.ReadBrush('Brush', Brush);
    ABitmap := nil;
    XmlReadBitmap(ANode, 'BrushBitmap', ABitmap);
    Brush.Bitmap := ABitmap;
    ABitmap.Free;
  end;
end;

procedure TdtpExposedMetafile.Paint(Canvas: TCanvas; const Device: TDeviceContext);
var
  ARect: TRect;
  AMetafile: TMetafile;
begin
  // Create a rectangle at our shape's size
  ARect := Rect(CanvasLeft, CanvasTop, CanvasRight, CanvasBottom);

  // Enumerate the metafile records, and draw them to the canvas
  with FImage do
  begin
    AMetafile := TMetafile(ObjectRef);
    if assigned(AMetafile) then
      EnumEnhMetafile(Canvas.Handle, AMetafile.Handle, @EnhMetafileProc, Self, ARect);
  end;
end;

procedure TdtpExposedMetafile.PropsChanged(Sender: TObject);
begin
  Regenerate;
  Changed;
end;

procedure TdtpExposedMetafile.ResourceAfterLoadFromFile(Sender: TObject);
// This procedure is called from the resource after loading
begin
  // If not yet loaded, the document sizes are 0.. so initialize
  if (DocWidth = 0) and (DocHeight = 0) then
  with FImage do
  begin
    if not assigned(ObjectRef) then
      exit;
    // This assignment will let the resource load the metafile from the stream
    DocWidth  := TMetafile(ObjectRef).Width   / cLowPrinterDpm;
    DocHeight := TMetafile(ObjectRef).Height  / cLowPrinterDpm;
    FixAspectRatio;
  end;
end;

procedure TdtpExposedMetafile.ResourceObjFromStream(Sender: TObject; var AObjectRef: TObject);
var
  AMetafile: TMetafile;
begin
  AMetafile := TMetafile.Create;
  AMetafile.LoadFromStream(FImage.Stream);
  AObjectRef := AMetafile;
end;

procedure TdtpExposedMetafile.SaveToXml(ANode: TXmlNodeOld);
begin
  inherited;
  FImage.SaveToXml(ANode.NodeNew('Image'));
  ANode.WriteBool('OverridePen', OverridePen);
  if OverridePen then
    ANode.WritePen('Pen', Pen);
  ANode.WriteBool('OverrideBrush', OverrideBrush);
  if OverrideBrush then
  begin
    ANode.WriteBrush('Brush', Brush);
    //todo XmlWriteBitmap(ANode, 'BrushBitmap', Brush.Bitmap);
  end;
end;

procedure TdtpExposedMetafile.SetBrush(const Value: TBrush);
begin
  FBrush.Assign(Value);
  Regenerate;
  Changed;
end;

procedure TdtpExposedMetafile.SetOverrideBrush(const Value: boolean);
begin
  if FOverrideBrush <> Value then
  begin
    FOverrideBrush := Value;
    Regenerate;
    Changed;
  end;
end;

procedure TdtpExposedMetafile.SetOverridePen(const Value: boolean);
begin
  if FOverridePen <> Value then
  begin
    FOverridePen := Value;
    Regenerate;
    Changed;
  end;
end;

procedure TdtpExposedMetafile.SetPen(const Value: TPen);
begin
  FPen.Assign(Value);
  Regenerate;
  Changed;
end;

class function TdtpExposedMetafile.UseCanvasPainting: boolean;
begin
  // We use GDI painting here for the metafile, so we must set this to true
  Result := True;
end;

initialization

  RegisterShapeClass(TdtpExposedMetafile);

end.
