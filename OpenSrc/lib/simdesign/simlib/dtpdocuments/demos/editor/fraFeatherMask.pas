unit fraFeatherMask;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraMaskBase, StdCtrls, ExtCtrls, dtpDefaults, dtpMaskEffects;

type
  TfrFeatherMask = class(TfrMaskBase)
    lbFeather: TLabel;
    edFeather: TEdit;
    procedure edFeatherExit(Sender: TObject);
  private
  protected
    procedure MaskToFrame; override;
  public
  end;

var
  frFeatherMask: TfrFeatherMask;

implementation

{$R *.DFM}

{ TfrFeatherMask }

procedure TfrFeatherMask.MaskToFrame;
begin
  inherited;
  edFeather.Text := Format(cPositionRelativeFormat, [TdtpFeatherMask(Mask).Feather]);
end;

procedure TfrFeatherMask.edFeatherExit(Sender: TObject);
begin
  if FIsUpdating then exit;
  TdtpFeatherMask(Mask).Feather := StrToFloat(edFeather.Text);
end;

end.
