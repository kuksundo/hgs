unit UnitKillProcessList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.CheckLst, Vcl.Menus;

type
  TKillProcessListF = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    Button1: TButton;
    Edit1: TEdit;
    BitBtn2: TBitBtn;
    ProcessLB: TCheckListBox;
    Button2: TButton;
    PopupMenu1: TPopupMenu;
    SelectAll1: TMenuItem;
    CheckedOnlySelected1: TMenuItem;
    DeCheckedAll1: TMenuItem;
    DeCheckedOnlySelected1: TMenuItem;
    N1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure DeCheckedAll1Click(Sender: TObject);
    procedure CheckedOnlySelected1Click(Sender: TObject);
    procedure DeCheckedOnlySelected1Click(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  KillProcessListF: TKillProcessListF;

implementation

{$R *.dfm}

procedure TKillProcessListF.Button1Click(Sender: TObject);
var
  i: integer;
begin
  if Edit1.Text <> '' then
  begin
    if ProcessLB.Items.IndexOf(Edit1.Text) = -1 then
    begin
      i := ProcessLB.Items.Add(Edit1.Text);
      ProcessLB.Checked[i] := True;
    end
    else
      ShowMessage('''' + Edit1.Text + ''' is existed in the list box');
  end;
end;

procedure TKillProcessListF.Button2Click(Sender: TObject);
var
  i: integer;
begin
  for i := ProcessLB.Items.Count - 1 downto 0 do
  begin
    if ProcessLB.Selected[i] then
      ProcessLB.Items.Delete(i);
  end;
end;

procedure TKillProcessListF.CheckedOnlySelected1Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ProcessLB.Items.Count - 1 do
  begin
    if ProcessLB.Selected[i] then
      ProcessLB.Checked[i] := True;
  end;
end;

procedure TKillProcessListF.DeCheckedAll1Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ProcessLB.Items.Count - 1 do
  begin
    ProcessLB.Checked[i] := False;
  end;
end;

procedure TKillProcessListF.DeCheckedOnlySelected1Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ProcessLB.Items.Count - 1 do
  begin
    if ProcessLB.Selected[i] then
      ProcessLB.Checked[i] := False;
  end;
end;

procedure TKillProcessListF.SelectAll1Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ProcessLB.Items.Count - 1 do
  begin
    ProcessLB.Checked[i] := True;
  end;
end;

end.
