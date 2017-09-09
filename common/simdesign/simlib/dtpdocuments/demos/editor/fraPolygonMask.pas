unit fraPolygonMask;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraPositionMask, dtpMaskEffects, StdCtrls, ExtCtrls;

type
  TfrPolygonMask = class(TfrPositionMask)
    lbStyle: TLabel;
    cbbStyle: TComboBox;
    lbShape: TLabel;
    cbbShape: TComboBox;
    procedure cbbShapeClick(Sender: TObject);
  private
  protected
    procedure MaskToFrame; override;
  public
  end;

var
  frPolygonMask: TfrPolygonMask;

implementation

{$R *.DFM}

{ TfrPolygonMask }

procedure TfrPolygonMask.MaskToFrame;
begin
  inherited;
  cbbStyle.ItemIndex := integer(TdtpPolygonMask(Mask).Style);
  cbbShape.ItemIndex := integer(TdtpPolygonMask(Mask).Shape);
end;

procedure TfrPolygonMask.cbbShapeClick(Sender: TObject);
begin
  if FIsUpdating then exit;
  TdtpPolygonMask(Mask).Shape := TdtpPolygonMaskShape(cbbShape.ItemIndex);
end;

end.
