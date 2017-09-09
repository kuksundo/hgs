unit w_IsAdminTest;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls;

type
  Tf_IsAdminTest = class(TForm)
    l_Result: TLabel;
    b_Exit: TButton;
    procedure b_ExitClick(Sender: TObject);
  private
  public
    constructor Create(_Owner: TComponent); override;
  end;

var
  f_IsAdminTest: Tf_IsAdminTest;

implementation

{$R *.dfm}
uses
  u_dzOsUtils;

{ TForm1 }

procedure Tf_IsAdminTest.b_ExitClick(Sender: TObject);
begin
  Close;
end;

constructor Tf_IsAdminTest.Create(_Owner: TComponent);
begin
  inherited;
  if CurrentUserHasAdminRights then
    l_Result.Caption := 'Current user has administrator rights.'
  else
    l_Result.Caption := 'Current user does NOT have administrator rights.';
end;

end.

