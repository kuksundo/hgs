unit dtpWorkshop;

{$i simdesign.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ActnList, ExtCtrls, ComCtrls, dtpBitmapShape, dtpDocument, dtpPage,
  dtpGraphics,  dtpPolygonShape, dtpShape, dtpFloodFill, dtpUtil,
  dtpEffectShape, dtpDefaults, StdCtrls, CheckLst,
  dtpMaskEffects, fraMaskBase, fraBitmapMask, fraPolygonMask, fraFeatherMask,
  dtpCropBitmap;

type
  TfrmWorkshop = class(TForm)
    alWorkshop: TActionList;
    mmWorkshop: TMainMenu;
    File1: TMenuItem;
    acReturnAccept: TAction;
    acReturnCancel: TAction;
    acReturnAccept1: TMenuItem;
    acReturnCancel1: TMenuItem;
    sbWorkshop: TStatusBar;
    pnlLeft: TPanel;
    pnlExample: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    pnlTitle: TPanel;
    pnlControls: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    clbInstalled: TCheckListBox;
    btnAddMask: TButton;
    btnRemoveMask: TButton;
    btnMaskUp: TButton;
    btnMaskDn: TButton;
    lbAvailable: TListBox;
    pnlMask: TPanel;
    tiUpdateExample: TTimer;
    procedure acReturnAcceptExecute(Sender: TObject);
    procedure acReturnCancelExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddMaskClick(Sender: TObject);
    procedure btnRemoveMaskClick(Sender: TObject);
    procedure btnMaskUpClick(Sender: TObject);
    procedure clbInstalledClick(Sender: TObject);
    procedure btnMaskDnClick(Sender: TObject);
    procedure tiUpdateExampleTimer(Sender: TObject);
  private
    FBitmap: TdtpBitmap;    // Bitmap image of the shape
    FDocument: TdtpDocument;  // Editor document
    FExample: TdtpDocument; // Example document
    FBackground: TdtpBitmapShape; // Background shape (without masks)
    FShape: TdtpEffectShape;
    FIsUpdating: boolean;
    FIsUpdatingExample: boolean;
    FMaskEffect: TdtpMaskEffect;
    FMaskIndex: integer;
    FMaskFrame: TfrMaskBase;
    FExampleNeedsUpdate: boolean; // If true, the timer must update the example
    procedure MaskEffectToExample;
    procedure SetShape(const Value: TdtpEffectShape);
    procedure UpdateControls;
    procedure UpdateEditor;
    procedure UpdateExample;
    procedure UpdateAvailableList;
    procedure UpdateInstalledList;
    procedure UpdateFrame;
    function GetMaskCount: integer;
    function GetMasks(Index: integer): TdtpMask;
    procedure ShapeChange(Sender: TObject);
    function GetMask: TdtpMask;
    function GetMaskFrameClassForMask(AMask: TdtpMask): TfrMaskFrameClass;
  protected
    property Mask: TdtpMask read GetMask;
  public
    property Masks[Index: integer]: TdtpMask read GetMasks;
    property MaskCount: integer read GetMaskCount;
    property Shape: TdtpEffectShape read FShape write SetShape;
  end;

var
  frmWorkshop: TfrmWorkshop;

implementation

uses
  dtpEditorMain;

{$R *.DFM}

{ TfrmWorkshop }

procedure TfrmWorkshop.acReturnAcceptExecute(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfrmWorkshop.acReturnCancelExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmWorkshop.btnAddMaskClick(Sender: TObject);
// Add the selected mask from available list to the maskeffect
var
  AClass: TdtpMaskClass;
begin
  if lbAvailable.ItemIndex < 0 then
  begin
    ShowMessage('Select a mask in available list first');
    exit;
  end;
  // Get effect class
  AClass := TdtpMaskClass(lbAvailable.Items.Objects[lbAvailable.ItemIndex]);
  if not assigned(AClass) then
    exit;
  // Insert this effect
  if assigned(FMaskEffect) then
    FMaskEffect.MaskAddClass(AClass);
end;

procedure TfrmWorkshop.btnMaskDnClick(Sender: TObject);
begin
  if assigned(FMaskEffect) then
    if clbInstalled.ItemIndex < clbInstalled.Items.Count - 1 then
    begin
      FMaskEffect.MaskExchange(clbInstalled.ItemIndex, clbInstalled.ItemIndex + 1);
      clbInstalled.ItemIndex := clbInstalled.ItemIndex + 1;
      clbInstalledClick(nil);
    end;
end;

procedure TfrmWorkshop.btnMaskUpClick(Sender: TObject);
begin
  if assigned(FMaskEffect) then
    if clbInstalled.ItemIndex > 0 then
    begin
      FMaskEffect.MaskExchange(clbInstalled.ItemIndex, clbInstalled.ItemIndex - 1);
      clbInstalled.ItemIndex := clbInstalled.ItemIndex - 1;
      clbInstalledClick(nil);
    end;
end;

procedure TfrmWorkshop.btnRemoveMaskClick(Sender: TObject);
begin
  if assigned(FMaskEffect) then
    FMaskEffect.MaskDelete(clbInstalled.ItemIndex);
end;

procedure TfrmWorkshop.clbInstalledClick(Sender: TObject);
begin
  if FIsUpdating then
    exit;
  // Store effect index
  FMaskIndex := clbInstalled.ItemIndex;
  // And update frame
  UpdateFrame;
end;

procedure TfrmWorkshop.FormCreate(Sender: TObject);
begin
  // Almost fullscreen
  SetBounds(10, 10, Screen.Width - 20, Screen.Height - 20);
  // Editor document
  FDocument := TdtpDocument.Create(Self);
  FDocument.Parent := Self;
  FDocument.Align := alClient;
  // Example document
  FExample := TdtpDocument.Create(Self);
  FExample.Parent := pnlExample;
  FExample.Align := alClient;
  FExample.ViewStyle := vsNormal;
  FExample.Color := clWhite;

  UpdateAvailableList;
end;

procedure TfrmWorkshop.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FBitmap);
  FreeAndNil(FShape);
end;

function TfrmWorkshop.GetMask: TdtpMask;
begin
  Result := nil;
  if assigned(FMaskEffect) then
    Result := FMaskEffect.Masks[clbInstalled.ItemIndex];
end;

function TfrmWorkshop.GetMaskCount: integer;
begin
  if assigned(FMaskEffect) then
    Result := FMaskEffect.MaskCount
  else
    Result := 0;
end;

function TfrmWorkshop.GetMaskFrameClassForMask(
  AMask: TdtpMask): TfrMaskFrameClass;
begin
  Result := nil;
  if AMask is TdtpFeatherMask then
  begin
    Result := TfrFeatherMask;
    exit;
  end;
  if AMask is TdtpBitmapMask then
  begin
    Result := TfrBitmapMask;
    exit;
  end;
  if AMask is TdtpPolygonMask then
  begin
    Result := TfrPolygonMask;
    exit;
  end;
end;

function TfrmWorkshop.GetMasks(Index: integer): TdtpMask;
begin
  if (Index >= 0) and (Index < MaskCount) then
    Result := FMaskEffect.Masks[Index]
  else
    Result := nil;
end;

procedure TfrmWorkshop.MaskEffectToExample;
var
  Effect: TdtpEffect;
begin
  if assigned(FExample) and assigned(FExample.Shapes[0]) then
  begin
    Effect := TdtpEffectShape(FExample.Shapes[0]).EffectByClass(TdtpMaskEffect);
    if not assigned(Effect) then
      exit; // this should not happen
    Effect.Assign(FMaskEffect);
    Effect.Refresh;
  end;
end;

procedure TfrmWorkshop.SetShape(const Value: TdtpEffectShape);
var
  AWidth, AHeight: integer;
begin
  // Free old data
  FreeAndNil(FBitmap);
  if assigned(FShape) then
    FreeAndNil(FShape);

  if assigned(Value) then
    FShape := TdtpEffectShape(Value.CreateCopy);

  // Determine bitmap size
  AWidth  := round(FShape.DocWidth  * cNormalPrinterDPM);
  AHeight := round(FShape.DocHeight * cNormalPrinterDPM);
  if FShape is TdtpBitmapShape then
  begin
    AWidth  := TdtpBitmapShape(FShape).Image.Bitmap.Width;
    AHeight := TdtpBitmapShape(FShape).Image.Bitmap.Height;
    if FShape is TdtpCropBitmap then
      with TdtpCropBitmap(FShape) do
      begin
        AWidth  := CropRect.Right - CropRect.Left;
        AHeight := CropRect.Bottom - CropRect.Top;;
      end;
  end;

  // Make sure the shape has a mask effect
  if not assigned(FShape.EffectByClass(TdtpMaskEffect)) then
    FShape.EffectInsertClass(0, TdtpMaskEffect);
  FMaskEffect := TdtpMaskEffect(FShape.EffectByClass(TdtpMaskEffect));

  // turn off masks temporarily in order to get bitmap without masks
  FMaskEffect.Enabled := False;

  // Create bitmap for background
  FBitmap := FShape.ExportToBitmap(AWidth, AHeight);
{$ifdef useTestData}
  FBitmap.SaveToFile('testdata.bmp');
{$endif}
  FMaskEffect.Enabled := True;

  FShape.OnChange := ShapeChange;

  UpdateExample;
  UpdateControls;
  UpdateEditor;
end;

procedure TfrmWorkshop.ShapeChange(Sender: TObject);
begin
  UpdateControls;
end;

procedure TfrmWorkshop.tiUpdateExampleTimer(Sender: TObject);
var
  OldCursor: TCursor;
begin
  if not FExampleNeedsUpdate or FIsUpdatingExample then
    exit;
  FIsUpdatingExample := True;
  OldCursor := Screen.Cursor;
  try
    Screen.Cursor := crHourglass;
    MaskEffectToExample;
    FExampleNeedsUpdate := False;
  finally
    FIsUpdatingExample := False;
    Screen.Cursor := OldCursor;
  end;
end;

procedure TfrmWorkshop.UpdateAvailableList;
// Create a list of available effects
var
  AList: TStringList;
begin
  AList := TStringList.Create;
  try
    GetAvailableMaskNames(AList);
    lbAvailable.Items.Assign(AList);
  finally
    AList.Free;
  end;
end;

procedure TfrmWorkshop.UpdateControls;
begin
  FIsUpdating := True;
  try
    FExampleNeedsUpdate := True;
    UpdateInstalledList;
    UpdateFrame;
  finally
    FIsUpdating := False;
  end;
end;

procedure TfrmWorkshop.UpdateEditor;
begin
  // Adapt Editor to this
  FDocument.Clear;
  FDocument.ScreenDpm := 1;
  if not assigned(FBitmap) then
    exit;
  FDocument.PageAdd(nil);
  FDocument.PageWidth  := FBitmap.Width;
  FDocument.PageHeight := FBitmap.Height;
  FDocument.ShowMargins := False;
  FDocument.HelperMethod := hmPattern;
  // Create a shape that holds a copy
  FBackground := TdtpBitmapShape.Create;
  FBackground.Image.Bitmap := FBitmap;
  FBackground.DocWidth  := FBitmap.Width;
  FBackground.DocHeight := FBitmap.Height;
  FBackground.AllowSelect := False;
  FDocument.ShapeAdd(FBackground);
  FDocument.ZoomPage;
end;

procedure TfrmWorkshop.UpdateExample;
var
  ACopy: TdtpShape;
begin
  // Adapt Example to this shape
  if not assigned(FShape) then
    exit;
  ACopy := FShape.CreateCopy;
  ACopy.DocAngle := 0;
  ACopy.DocLeft := 5;
  ACopy.DocTop := 5;
  ACopy.AllowSelect := False;
  FExample.CurrentPage.Clear;
  FExample.PageWidth  := ACopy.DocWidth + 10;
  FExample.PageHeight := ACopy.DocHeight + 10;
  FExample.ShapeAdd(ACopy);
  FExample.ShowMargins := False;
  FExample.ZoomPage;
end;

procedure TfrmWorkshop.UpdateFrame;
var
  AMaskFrameClass: TfrMaskFrameClass;
begin
  AMaskFrameClass := GetMaskFrameClassForMask(Mask);
  if not assigned(FMaskFrame) or (AMaskFrameClass <> FMaskFrame.ClassType) then
  begin
    // Remove old and insert new frame
    FreeAndNil(FMaskFrame);
    if assigned(AMaskFrameClass) then
      FMaskFrame := AMaskFrameClass.Create(Self);
  end;
  if assigned(FMaskFrame) then
  begin
    // This calls "MaskToFrame" through setter
    FMaskFrame.Mask := Mask;
    FMaskFrame.Parent := pnlMask;
  end;
end;

procedure TfrmWorkshop.UpdateInstalledList;
var
  i: integer;
begin
  // Copy to checklistbox
  for i := 0 to MaskCount - 1 do
  begin
    if clbInstalled.Items.Count <= i then
      clbInstalled.Items.Add(' ');
    // Set the name, and associated effect class
    clbInstalled.Items[i] := Masks[i].MaskName;
    clbInstalled.Items.Objects[i] := TObject(Masks[i]);
    clbInstalled.Checked[i] := Masks[i].Enabled;
  end;
  // Remove excess items
  while clbInstalled.Items.Count > MaskCount do
    clbInstalled.Items.Delete(clbInstalled.Items.Count - 1);
  // Set to last index
  if (FMaskIndex >= 0) and (FMaskIndex < MaskCount) then
    clbInstalled.ItemIndex := FMaskIndex;
end;

end.
