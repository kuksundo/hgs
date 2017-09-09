unit fraBitmapMask;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraPositionMask, StdCtrls, ExtCtrls, ExtDlgs, dtpRasterFormats, dtpMaskEffects;

type
  TfrBitmapMask = class(TfrPositionMask)
    edImageName: TEdit;
    btnChange: TButton;
    btnClear: TButton;
    chbOutsideIsTransparent: TCheckBox;
    lbBitmapFile: TLabel;
    procedure btnChangeClick(Sender: TObject);
  private
  protected
    procedure MaskToFrame; override;
  public
  end;

var
  frBitmapMask: TfrBitmapMask;

implementation

{$R *.DFM}

procedure TfrBitmapMask.btnChangeClick(Sender: TObject);
begin
  if FIsUpdating then exit;
  with TOpenPictureDialog.Create(Application) do begin
    try
      Title := 'Change to another file (choose)';
      Filter := RasterFormatOpenFilter;
      if Execute then
        with TdtpBitmapMask(Mask) do begin
          // Load.. and set to new dimensions
          Image.LoadFromFile(FileName);
        end;
    finally
      Free;
    end;
  end;
end;

procedure TfrBitmapMask.MaskToFrame;
begin
  inherited;
  // Image
  edImageName.Text := TdtpBitmapMask(Mask).Image.FileName;
  chbOutsideIsTransparent.Checked := TdtpBitmapMask(Mask).OutsideIsTransparent;
end;

end.
