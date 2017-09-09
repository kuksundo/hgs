unit w_AddUser;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  JvFormPlacement, JvComponentBase;

type
  Tf_AddUser = class(TForm)
    grp_User: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    chk_AddUser: TCheckBox;
    ed_Username: TEdit;
    ed_Password: TEdit;
    TheFormStorage: TJvFormStorage;
    ed_DatabaseName: TEdit;
    Label1: TLabel;
    chk_DbEquUser: TCheckBox;
    procedure chk_AddUserClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure chk_DbEquUserClick(Sender: TObject);
    procedure ed_UsernameChange(Sender: TObject);
  private
  public
  end;

implementation

{$R *.DFM}

procedure Tf_AddUser.chk_AddUserClick(Sender: TObject);
var
  b: boolean;
begin
  b := chk_AddUser.Checked;
  ed_Username.Enabled := b;
  ed_Password.Enabled := b;
end;

procedure Tf_AddUser.FormResize(Sender: TObject);
begin
  grp_User.Width := self.ClientWidth;
end;

procedure Tf_AddUser.chk_DbEquUserClick(Sender: TObject);
var
  b: boolean;
begin
  b := chk_DbEquUser.Checked;
  ed_DatabaseName.Enabled := not b;
  if b then
    ed_DatabaseName.Text := ed_Username.Text;
end;

procedure Tf_AddUser.ed_UsernameChange(Sender: TObject);
begin
  if chk_DbEquUser.Checked then
    ed_DatabaseName.Text := ed_Username.Text;
end;

end.

