{
  Unit frmPermissions

  Implements a dialog where shape permissions can be set.

  Creation Date: 03-10-2004 (NH)
  Version: 1.0

  Modifications:

  Copyright (c) 2004 By Nils Haeck M.Sc. - SimDesign
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This source code may NOT be used or replicated without prior permission
  from the abovementioned author.

}
unit frmPermissions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, dtpShape;

type

  TdlgPermissions = class(TForm)
    chbAllowMove: TCheckBox;
    chbAllowResize: TCheckBox;
    chbAllowRotate: TCheckBox;
    chbAllowSelect: TCheckBox;
    chbPreserveAspect: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    chbAllowDelete: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShapesToDlg(Shapes: TList);
    procedure DlgToShapes(Shapes: TList);
  end;

var
  dlgPermissions: TdlgPermissions;

implementation

{$R *.DFM}

{ TdlgPermissions }

procedure TdlgPermissions.DlgToShapes(Shapes: TList);
var
  i: integer;
begin
  for i := 0 to Shapes.Count - 1 do
    with TdtpShape(Shapes[i]) do begin
      if not (chbAllowMove.State = cbGrayed) then AllowMove := chbAllowMove.Checked;
      if not (chbAllowDelete.State = cbGrayed) then AllowDelete := chbAllowDelete.Checked;
      if not (chbAllowResize.State = cbGrayed) then AllowResize := chbAllowResize.Checked;
      if not (chbAllowRotate.State = cbGrayed) then AllowRotate := chbAllowRotate.Checked;
      if not (chbAllowSelect.State = cbGrayed) then AllowSelect := chbAllowSelect.Checked;
      if not (chbPreserveAspect.State = cbGrayed) then PreserveAspect := chbPreserveAspect.Checked;
    end;
end;

procedure TdlgPermissions.ShapesToDlg(Shapes: TList);
var
  i: integer;
begin
  // Title
  Caption := Format('Edit Permissions: %d Shape(s)', [Shapes.Count]);
  // Checkboxes
  for i := 0 to Shapes.Count - 1 do
    if i = 0 then
      with TdtpShape(Shapes[i]) do begin
        chbAllowMove.Checked      := AllowMove;
        chbAllowDelete.Checked    := AllowDelete;
        chbAllowResize.Checked    := AllowResize;
        chbAllowRotate.Checked    := AllowRotate;
        chbAllowSelect.Checked    := AllowSelect;
        chbPreserveAspect.Checked := PreserveAspect;
      end
    else
      with TdtpShape(Shapes[i]) do begin
        if chbAllowMove.Checked <> AllowMove then chbAllowMove.State := cbGrayed;
        if chbAllowDelete.Checked <> AllowDelete then chbAllowDelete.State := cbGrayed;
        if chbAllowResize.Checked <> AllowResize then chbAllowResize.State := cbGrayed;
        if chbAllowRotate.Checked <> AllowRotate then chbAllowRotate.State := cbGrayed;
        if chbAllowSelect.Checked <> AllowSelect then chbAllowSelect.State := cbGrayed;
        if chbPreserveAspect.Checked <> PreserveAspect then chbPreserveAspect.State := cbGrayed;
      end;
end;

end.
