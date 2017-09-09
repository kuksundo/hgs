{
  Inlay frame for Sepia effect

  Creation date: 08Oct2005

  Copyright (c) 2005 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

}
unit fraSepiaInlay;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fraInlay, ExtCtrls, ComCtrls, StdCtrls;

type
  TfrSepiaInlay = class(TfrInlay)
    Label1: TLabel;
    lbDepth: TLabel;
    trbDepth: TTrackBar;
    procedure trbDepthChange(Sender: TObject);
  private
  protected
    procedure EffectToFrame; override;
  public
  end;

var
  frSepiaInlay: TfrSepiaInlay;

implementation

{$R *.DFM}

uses
  dtpColorEffects;

procedure TfrSepiaInlay.EffectToFrame;
// Use the effect props to set the control values
begin
  inherited;
  if Effect is TdtpSepiaEffect then with TdtpSepiaEffect(Effect) do begin
    // Label
    lbDepth.Caption := Format('%d', [Depth]);
    // Trackbar
    trbDepth.Position := Depth;
  end;
end;

procedure TfrSepiaInlay.trbDepthChange(Sender: TObject);
begin
  if FUpdating then exit;
  with TdtpSepiaEffect(Effect) do begin
    NextUndoNoRepeatedPropertyChange;
    Depth := trbDepth.Position;
  end;
end;

end.
