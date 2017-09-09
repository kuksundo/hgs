unit fraBitmapShape;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraShape, StdCtrls, ComCtrls, ExtCtrls, dtpBitmapShape, ExtDlgs,
  dtpRasterFormats, dtpEffectShape, dtpResource, dtpWorkshop;

type
  TfrBitmapShape = class(TfrShape)
    Label7: TLabel;
    edImageName: TEdit;
    btnChange: TButton;
    btnSave: TButton;
    btnWorkshop: TButton;
    chbPreserveAspect: TCheckBox;
    btnClear: TButton;
    procedure btnChangeClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnWorkshopClick(Sender: TObject);
    procedure chbPreserveAspectClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
  protected
    procedure ShapesToFrame; override;
  public
  end;

var
  frBitmapShape: TfrBitmapShape;

implementation

uses
  dtpDefaults;

{$R *.DFM}

{ TfrBitmapShape }

procedure TfrBitmapShape.btnChangeClick(Sender: TObject);
// Change the image resource file
var
  i: integer;
begin
  if FIsUpdating then exit;
  with TOpenPictureDialog.Create(Application) do begin
    try
      Title := 'Change to another file (choose)';
      Filter := RasterFormatOpenFilter;
      if Execute then begin
        for i := 0 to ShapeCount - 1 do
          with TdtpBitmapShape(Shapes[i]) do begin
            // Load.. and set to new dimensions
            Image.LoadFromFile(FileName);
          end;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TfrBitmapShape.btnClearClick(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then exit;
  for i := 0 to ShapeCount - 1 do begin
    // Reset
    TdtpBitmapShape(Shapes[i]).Image.Bitmap := nil;
    if Shapes[i] is TdtpSnapBitmap then
      TdtpSnapBitmap(Shapes[i]).PlaceholderVisible := True;
  end;
end;

procedure TfrBitmapShape.btnSaveClick(Sender: TObject);
begin
  if FIsUpdating then exit;
  with TSavePictureDialog.Create(nil) do begin
    try
      Title := 'Save image to another format or name';
      DefaultExt := 'hck';
      Filter := RasterFormatSaveFilter;
      if Execute then begin
        with TdtpBitmapShape(Shapes[0]) do begin
          SaveImageToFile(FileName, Image.Bitmap);
        end;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TfrBitmapShape.btnWorkshopClick(Sender: TObject);
var
  OldStorage: TdtpResourceStorage;
  Workshop: TFrmWorkshop;
begin
  if not (Shapes[0] is TdtpBitmapShape) then
    exit;

  // Create a new workshop for the bitmap shape
  Workshop := TfrmWorkshop.Create(Application);
  try
    // Force storage to be embedded because other documents cannot reference
    // our archive
    OldStorage := Shapes[0].Storage;
    Shapes[0].Storage := rsEmbedded;
    Workshop.Shape := TdtpEffectShape(Shapes[0]);
    if Workshop.ShowModal = mrOK then
    begin
      // Assign the updated shape to the original
      Shapes[0].Assign(Workshop.Shape);
      Shapes[0].OnChange := nil;
      // Set back storage mode
      Shapes[0].Storage := OldStorage;
      // Refresh the screen representation
      Shapes[0].Refresh;
    end;
  finally
    Workshop.Free;
  end;
end;

procedure TfrBitmapShape.chbPreserveAspectClick(Sender: TObject);
var
  i: integer;
begin
  if FIsUpdating then
    exit;
  BeginUpdate;
  for i := 0 to ShapeCount - 1 do
    if (Shapes[i] is TdtpBitmapShape) then
      TdtpBitmapShape(Shapes[i]).PreserveAspect := chbPreserveAspect.Checked;
  EndUpdate;
end;

procedure TfrBitmapShape.ShapesToFrame;
var
  i: integer;
begin
  inherited;
  if ShapeCount = 0 then
    exit;
  // Title
  if ShapeCount = 1 then
    lblTitle.Caption := 'Bitmap Image'
  else
    lblTitle.Caption := Format('Bitmap Images (%d items)', [ShapeCount]);
  // Main shape
  if Shapes[0] is TdtpBitmapShape then with TdtpBitmapShape(Shapes[0]) do begin

    // Image
    edImageName.Text := Image.FileName;

    // Aspect ratio
    chbPreserveAspect.Checked := PreserveAspect;

  end;

  // Workshop
  btnWorkshop.Enabled := ShapeCount = 1;

  // Additional shapes
  for i := 1 to ShapeCount - 1 do
    if Shapes[i] is TdtpBitmapShape then with TdtpBitmapShape(Shapes[i]) do begin
      if edImageName.Text <> Image.FileName then
        edImageName.Text := '';
    end;
end;

end.
