unit UnitCopyModeMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvExExtCtrls, JvExtComponent,
  JvItemsPanel, Vcl.ExtCtrls;

type
  TCopyModeMenuF = class(TForm)
    JvItemsPanel1: TJvItemsPanel;
    procedure JvItemsPanel1ItemClick(Sender: TObject; ItemIndex: Integer);
    procedure FormCreate(Sender: TObject);
  protected
  public
    { Public declarations }
  end;

var
  CopyModeMenuF: TCopyModeMenuF;

implementation

{$R *.dfm}

procedure TCopyModeMenuF.FormCreate(Sender: TObject);
begin
  Height := (JvItemsPanel1.ItemHeight * JvItemsPanel1.Items.Count) + 28;
end;

procedure TCopyModeMenuF.JvItemsPanel1ItemClick(Sender: TObject;
  ItemIndex: Integer);
begin
  Tag := ItemIndex+1;
  ModalResult := mrOK;
end;

end.
