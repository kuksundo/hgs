unit fraPositionMask;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraMaskBase, StdCtrls, ExtCtrls, dtpMaskEffects, dtpDefaults;

type
  TfrPositionMask = class(TfrMaskBase)
    gbPosition: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edLeft: TEdit;
    edTop: TEdit;
    edWidth: TEdit;
    edHeight: TEdit;
    cbbRotation: TComboBox;
  private
  protected
    procedure MaskToFrame; override;
  public
  end;

var
  frPositionMask: TfrPositionMask;

implementation

{$R *.DFM}

{ TfrPositionMask }

procedure TfrPositionMask.MaskToFrame;
begin
  inherited;
  edLeft.Text   := Format(cPositionRelativeFormat, [TdtpPositionMask(Mask).Left]);
  edTop.Text    := Format(cPositionRelativeFormat, [TdtpPositionMask(Mask).Top]);
  edWidth.Text  := Format(cPositionRelativeFormat, [TdtpPositionMask(Mask).Width]);
  edHeight.Text := Format(cPositionRelativeFormat, [TdtpPositionMask(Mask).Height]);
  cbbRotation.ItemIndex := integer(TdtpPositionMask(Mask).Rotation);
end;

end.
