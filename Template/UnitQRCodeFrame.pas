unit UnitQRCodeFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  DelphiZXingQRCode, Vcl.Menus, Vcl.ExtDlgs, Vcl.ComCtrls, Vcl.Imaging.pngimage;

type
  TQRCodeFrame = class(TFrame)
    splTop: TSplitter;
    pnlTop: TPanel;
    lblText: TLabel;
    mmoText: TMemo;
    pnlDetails: TPanel;
    lblEncoding: TLabel;
    lblQuietZone: TLabel;
    lblErrorCorrectionLevel: TLabel;
    lblCorner: TLabel;
    lblDrawingMode: TLabel;
    cmbEncoding: TComboBox;
    edtQuietZone: TEdit;
    cbbErrorCorrectionLevel: TComboBox;
    edtCornerThickness: TEdit;
    udCornerThickness: TUpDown;
    udQuietZone: TUpDown;
    grpSaveToFile: TGroupBox;
    lblScaleToSave: TLabel;
    edtFileName: TEdit;
    btnSaveToFile: TButton;
    edtScaleToSave: TEdit;
    udScaleToSave: TUpDown;
    btnCopy: TButton;
    cbbDrawingMode: TComboBox;
    pgcQRDetails: TPageControl;
    tsPreview: TTabSheet;
    pbPreview: TPaintBox;
    lblQRMetrics: TLabel;
    pnlColors: TPanel;
    bvlColors: TBevel;
    lblBackground: TLabel;
    lblForeground: TLabel;
    tsEncodedData: TTabSheet;
    mmoEncodedData: TMemo;
    dlgSaveToFile: TSaveDialog;
    clrbxBackground: TColorBox;
    clrbxForeground: TColorBox;
    procedure pbPreviewPaint(Sender: TObject);
    procedure CopyBitmaptoClipboard1Click(Sender: TObject);
    procedure cmbEncodingChange(Sender: TObject);
    procedure cmbEncodingMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure cmbEncodingDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cbbErrorCorrectionLevelChange(Sender: TObject);
    procedure edtQuietZoneChange(Sender: TObject);
    procedure cbbDrawingModeChange(Sender: TObject);
    procedure edtCornerThicknessChange(Sender: TObject);
    procedure btnSaveToFileClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure clrbxBackgroundChange(Sender: TObject);
    procedure clrbxForegroundChange(Sender: TObject);
    procedure mmoEncodedDataChange(Sender: TObject);
    procedure mmoTextChange(Sender: TObject);
  private
    FQRCode: TDelphiZXingQRCode;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure CopyBitmapToClipboard;
    procedure RemakeQR;
    procedure SaveToFile(const AFileName: string; AFileExt: string='');
  end;

implementation

uses
  QRGraphics, QR_Win1251, QR_URL, jpeg, Clipbrd;

{$R *.dfm}

{ TQRCodeFrame }

procedure TQRCodeFrame.btnCopyClick(Sender: TObject);
var
  Bmp: TBitmap;
begin
  Bmp := nil;
  try
    Bmp := TBitmap.Create;
    MakeBmp(Bmp, udScaleToSave.Position, FQRCode, clrbxBackground.Selected,
      clrbxForeground.Selected, udCornerThickness.Position);
    Clipboard.Assign(Bmp);
    Bmp.Free;
  except
    Bmp.Free;
    raise;
  end;
end;

procedure TQRCodeFrame.btnSaveToFileClick(Sender: TObject);
var
  Bmp: TBitmap;
  S: string;
begin
  if dlgSaveToFile.Execute then
  begin
    S := LowerCase(ExtractFileExt(dlgSaveToFile.FileName));
    if S = '' then
    begin
      case dlgSaveToFile.FilterIndex of
        0: S := '.bmp';
        1: S := '.png';
        2: S := '.emf';
        3: S := '.jpg';
      end;
      dlgSaveToFile.FileName := dlgSaveToFile.FileName + S;
    end;

    edtFileName.Text := dlgSaveToFile.FileName;

    Self.SaveToFile(dlgSaveToFile.FileName, S);
  end;
end;

procedure TQRCodeFrame.cbbDrawingModeChange(Sender: TObject);
begin
  dlgSaveToFile.FilterIndex := Ord(TQRDrawingMode(cbbDrawingMode.ItemIndex
    div 2) <> drwBitmap) + 1;
  pbPreview.Repaint
end;

procedure TQRCodeFrame.cbbErrorCorrectionLevelChange(Sender: TObject);
begin
  RemakeQR;
end;

procedure TQRCodeFrame.clrbxBackgroundChange(Sender: TObject);
begin
  pbPreview.Repaint
end;

procedure TQRCodeFrame.clrbxForegroundChange(Sender: TObject);
begin
  pbPreview.Repaint
end;

procedure TQRCodeFrame.cmbEncodingChange(Sender: TObject);
begin
  RemakeQR;
  mmoEncodedData.Text := FQRCode.FilteredData;
end;

procedure TQRCodeFrame.cmbEncodingDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  R1, R2: TRect;
  IsSpecialLine: Boolean;
  OldColor, OldFontColor: TColor;
  S: string;
begin
  IsSpecialLine := (Index in [0, ENCODING_UTF8_BOM + 1]) and
    not (odComboBoxEdit in State);
  with Control as TComboBox do
  begin
    if IsSpecialLine then
    begin
      R1 := Rect;
      R2 := R1;
      R1.Bottom := (Rect.Bottom + Rect.Top) div 2;
      R2.Top := R1.Bottom;
    end
    else
      R2 := Rect;
    Canvas.FillRect(R2);
    if Index >= 0 then
    begin
      if IsSpecialLine then
      begin
        OldColor := Canvas.Brush.Color;
        OldFontColor := Canvas.Font.Color;
        Canvas.Brush.Color := clBtnFace;
        Canvas.Font.Style := [fsBold];
        Canvas.Font.Color := clGrayText;
        Canvas.FillRect(R1);
        if Index = 0 then
          S := 'Default'
        else
          S := 'Extended';
        Canvas.TextOut((R1.Left + R1.Right - Canvas.TextWidth(S)) div 2, R1.Top,
          S);
        Canvas.Font.Assign(Font);
        Canvas.Brush.Color := OldColor;
        Canvas.Font.Color := OldFontColor;
      end;
      Canvas.TextOut(R2.Left + 2, R2.Top, Items[Index]);
    end;
    if IsSpecialLine and (odFocused in State) then
      with Canvas do
      begin
        DrawFocusRect(Rect);
        DrawFocusRect(R2);
      end;
  end;
end;

procedure TQRCodeFrame.cmbEncodingMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  Height := cmbEncoding.ItemHeight;
  if Index in [0, ENCODING_UTF8_BOM + 1] then
    Height := Height * 2;
end;

procedure TQRCodeFrame.CopyBitmapToClipboard;
var
  Bmp: TBitmap;
begin
  Bmp := nil;
  try
    Bmp := TBitmap.Create;
//    MakeBmp(Bmp, 10, FQRCode, clWhite, clBlack);
    MakeBmp(Bmp, udScaleToSave.Position, FQRCode, clrbxBackground.Selected,
      clrbxForeground.Selected, udCornerThickness.Position);
    Clipboard.Assign(Bmp);
    Bmp.Free;
  except
    Bmp.Free;
    raise;
  end;
end;

procedure TQRCodeFrame.CopyBitmaptoClipboard1Click(Sender: TObject);
begin
  CopyBitmapToClipboard;
end;

constructor TQRCodeFrame.Create(AOwner: TComponent);
begin
  inherited;
  // create and prepare QRCode component
  FQRCode := TDelphiZXingQRCode.Create;
  FQRCode.RegisterEncoder(ENCODING_WIN1251, TWin1251Encoder);
  FQRCode.RegisterEncoder(ENCODING_URL, TURLEncoder);
end;

destructor TQRCodeFrame.Destroy;
begin
  FQRCode.Free;

  inherited;
end;

procedure TQRCodeFrame.edtCornerThicknessChange(Sender: TObject);
begin
  pbPreview.Repaint
end;

procedure TQRCodeFrame.edtQuietZoneChange(Sender: TObject);
begin
  RemakeQR;
end;

procedure TQRCodeFrame.mmoEncodedDataChange(Sender: TObject);
begin
  RemakeQR;
  mmoEncodedData.Text := FQRCode.FilteredData;
end;

procedure TQRCodeFrame.mmoTextChange(Sender: TObject);
begin
  RemakeQR;
  mmoEncodedData.Text := FQRCode.FilteredData;
end;

procedure TQRCodeFrame.pbPreviewPaint(Sender: TObject);
begin
  with pbPreview.Canvas do
  begin
    Pen.Color := clBlack;
    Brush.Color := clWhite;
  end;

  DrawQR(pbPreview.Canvas, pbPreview.ClientRect, FQRCode,
    0, TQRDrawingMode(0 div 2),
    Boolean(1 - 0 mod 2));
end;

procedure TQRCodeFrame.RemakeQR;
begin
  with FQRCode do
  try
    BeginUpdate;
    Data := mmoText.Text;
    Encoding := cmbEncoding.ItemIndex;
    ErrorCorrectionOrdinal := TErrorCorrectionOrdinal(0);//TErrorCorrectionOrdinal(cbbErrorCorrectionLevel.ItemIndex);
    QuietZone := StrToIntDef(edtQuietZone.Text, 4);
    EndUpdate(True);
  finally
    pbPreview.Repaint;
//    pbPreviewPaint(Self);
  end;
end;

procedure TQRCodeFrame.SaveToFile(const AFileName: string; AFileExt: string='');
var
  Bmp: TBitmap;
  M: TMetafile;
  J:TJPEGImage;
  P: TPNGImage;
begin
  Bmp := nil;
  M := nil;
  J := nil;

  if AFileExt = '' then
    AFileExt := '.bmp';

  if AFileExt = '.bmp' then
  try
    Bmp := TBitmap.Create;
    MakeBmp(Bmp, udScaleToSave.Position, FQRCode, clrbxBackground.Selected,
      clrbxForeground.Selected, udCornerThickness.Position);
    Bmp.SaveToFile(AFileName);
    Bmp.Free;
  except
    Bmp.Free;
    raise;
  end
  else if AFileExt = '.png' then
  begin
    try
      Bmp := TBitmap.Create;
      MakeBmp(Bmp, udScaleToSave.Position, FQRCode,
        clrbxBackground.Selected, clrbxForeground.Selected,
        udCornerThickness.Position);
      P := TPNGImage.Create;
      P.Assign(Bmp);
      P.SaveToFile(AFileName);
      P.Free;
      Bmp.Free;
    except
      P.Free;
      Bmp.Free;
      raise;
    end
  end
  else if AFileExt = '.emf' then
  begin
    try
      M := TMetafile.Create;
      MakeMetafile(M, udScaleToSave.Position, FQRCode,
        clrbxBackground.Selected, clrbxForeground.Selected,
        TQRDrawingMode(cbbDrawingMode.ItemIndex div 2),
        udCornerThickness.Position);
      M.SaveToFile(AFileName);
      M.Free;
    except
      M.Free;
      raise;
    end;
  end
  else if AFileExt = '.jpg' then
  begin
    try
      Bmp := TBitmap.Create;
      MakeBmp(Bmp, udScaleToSave.Position, FQRCode,
        clrbxBackground.Selected, clrbxForeground.Selected,
        udCornerThickness.Position);
      J := TJPEGImage.Create;
      J.Assign(Bmp);
      J.SaveToFile(AFileName);
      J.Free;
      Bmp.Free;
    except
      J.Free;
      Bmp.Free;
      raise;
    end
  end;
end;
//var
//  LBitmap: TBitmap;
//  LSource: TRect;
//  LDest: TRect;
//begin
//  LBitmap := TBitmap.Create;
//  try
//    with LBitmap do
//    begin
//      Width := pbPreview.Width;
//      Height := pbPreview.Height;
////      BitBlt(Canvas.Handle, 0,0, Width, Height, pbPreview.Canvas.Handle, 0, 0, SRCCOPY);
//      LDest := Rect(0,0,Width, Height);
//    end;
//
//    with pbPreview do
//    begin
//      LSource := Rect(0,0,Width, Height);
//      LBitmap.Canvas.CopyRect(LDest, pbPreview.Canvas, LSource);
////      Canvas.Draw(0,0, LBitmap);
//      LBitmap.SaveToFile(AFileName);
//    end;
//  finally
//    LBitmap.Free;
//  end;
//end;

end.
