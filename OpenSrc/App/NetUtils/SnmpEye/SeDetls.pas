unit SeDetls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TDetailsDialog = class(TForm)
    btnPrev: TButton;
    btnNext: TButton;
    edtOid: TMemo;
    edtValue: TMemo;
    edtType: TMemo;
    lblOid: TLabel;
    lblName: TLabel;
    lblType: TLabel;
    lblValue: TLabel;
    edtName: TMemo;
    btnClose: TButton;
    procedure ButtonClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateControls;
  public
    { Public declarations }
  end;

procedure ShowDetailsDialog(AOwner: TComponent);

var
  DetailsDialog: TDetailsDialog;

implementation

uses SeMain;

{$R *.dfm}

procedure ShowDetailsDialog(AOwner: TComponent);
begin
  with TDetailsDialog.Create(AOwner) do
  try
    UpdateControls;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TDetailsDialog.ButtonClick(Sender: TObject);
begin
  with MainForm.ListView do
  begin
    Selected := Items[Selected.Index + (Sender as TButton).Tag];
    Selected.Focused := True;
    Selected.MakeVisible(True);
  end;
  UpdateControls;
end;

procedure TDetailsDialog.UpdateControls;
begin
  with MainForm.ListView, Selected do
  begin
    btnPrev.Enabled := Index <> 0;
    btnNext.Enabled := Index <> Items.Count - 1;
    edtOid.Text := Caption;
    edtName.Text := SubItems[0];
    edtType.Text := SubItems[1];
    edtValue.Text := SubItems[2];
  end;
end;

end.
