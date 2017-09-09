{
  Unit fraBase

  This unit implements the frame editor that can be used to as an ancestor
  for other frame editors. Any descendants must implement a descending
  fraXXX unit.

  Project: DTP-Engine

  Creation Date: 07-08-2003 (NH)
  Version: 1.0

  Copyright (c) 2003 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit fraMaskBase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, dtpMaskEffects;

type

  // Width should be 270, Height should be 400
  TfrMaskBase = class(TFrame)
    pnlTitle: TPanel;
    lblTitle: TLabel;
    chbFlipAlphaChannel: TCheckBox;
    cbbOperation: TComboBox;
    lbOperation: TLabel;
    procedure cbbOperationClick(Sender: TObject);
    procedure chbFlipAlphaChannelClick(Sender: TObject);
  private
    FMask: TdtpMask;
    procedure SetMask(const Value: TdtpMask);
  protected
    FIsUpdating: boolean;
    procedure MaskToFrame; virtual;
  public
    property Mask: TdtpMask read FMask write SetMask;
  end;

  TfrMaskFrameClass = class of TfrMaskBase;

implementation

{$R *.DFM}

{ TfrMaskBase }

procedure TfrMaskBase.MaskToFrame;
begin
  lblTitle.Caption := FMask.MaskName;
  chbFlipAlphaChannel.Checked := FMask.FlipAlphaChannel;
  cbbOperation.ItemIndex := integer(FMask.Operation);
end;

procedure TfrMaskBase.SetMask(const Value: TdtpMask);
begin
  FMask := Value;
  FIsUpdating := True;
  try
    if assigned(Mask) then
      MaskToFrame;
  finally
    FIsUpdating := False;
  end;
end;

procedure TfrMaskBase.cbbOperationClick(Sender: TObject);
begin
  if FIsUpdating then exit;
  FMask.Operation := TdtpMaskOperation(cbbOperation.ItemIndex);
end;

procedure TfrMaskBase.chbFlipAlphaChannelClick(Sender: TObject);
begin
  if FIsUpdating then exit;
  FMask.FlipAlphaChannel := chbFlipAlphaChannel.Checked;
end;

end.
