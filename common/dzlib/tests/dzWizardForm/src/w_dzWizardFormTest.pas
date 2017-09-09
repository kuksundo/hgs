unit w_dzWizardFormTest;

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
  StdCtrls,
  w_dzWizardForm,
  wf_dzWizardFrame,
  wf_WizardPageName,
  wf_WizardPageBirthday,
  wf_WizardPageAge,
  ExtCtrls;

type
  Tf_dzWizardFormTest = class(TForm)
    b_Start: TButton;
    im_dz: TImage;
    procedure b_StartClick(Sender: TObject);
  private
    FName: string;
    FPageName: Tfr_WizardPageName;
    FPageBirthday: Tfr_WizardPageBirthday;
    FPageAge: Tfr_WizardPageAge;
    FPageIdName: integer;
    FPageIdBirthday: integer;
    FPageIdAge: integer;
    procedure HandleNameExit(_Sender: TObject; _Direction: TPrevNext;
      _OldPageId: integer; var _NewPageId: integer; _OldPageData, _NewPageData: Pointer;
      var _CanChange: boolean);
    procedure HandleBirthdayExit(_Sender: TObject; _Direction: TPrevNext;
      _OldPageId: integer; var _NewPageId: integer; _OldPageData, _NewPageData: Pointer;
      var _CanChange: boolean);
  public
  end;

var
  f_dzWizardFormTest: Tf_dzWizardFormTest;

implementation

{$R *.dfm}

uses
  DateUtils,
  w_dzDialog;

procedure Tf_dzWizardFormTest.b_StartClick(Sender: TObject);
var
  frm: Tf_dzWizardForm;
begin
  frm := Tf_dzWizardForm.Create(self);
  try
    frm.Picture := self.im_dz.Picture;
    FPageName := Tfr_WizardPageName.Create(frm);
    FPageName.BeforeExit := HandleNameExit;
    FPageIdName := frm.Pages.AddPage(FPageName, 'What is your name?');
    FPageBirthday := Tfr_WizardPageBirthday.Create(frm);
    FPageBirthday.BeforeExit := HandleBirthdayExit;
    FPageIdBirthday := frm.Pages.AddPage(FPageBirthday, 'When have you been born?');
    FPageAge := Tfr_WizardPageAge.Create(frm);
    FPageIdAge := frm.Pages.AddPage(FPageAge, 'Result');
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure Tf_dzWizardFormTest.HandleBirthdayExit(_Sender: TObject;
  _Direction: TPrevNext; _OldPageId: integer; var _NewPageId: integer;
  _OldPageData, _NewPageData: Pointer; var _CanChange: boolean);
var
  Age: Integer;
  Birthday: TDateTime;
begin
  Assert(_OldPageId = FPageIdBirthday);

  if _Direction = pnPrevious then
    exit;

  Birthday := FPageBirthday.dtp_Birthday.Date;

  if _NewPageId = FPageIdAge then begin
    Age := DateUtils.YearsBetween(Now, Birthday);
    FPageAge.l_Age.Caption := Format('%s, you are now %d years old.', [FName, Age]);
  end;
end;

procedure Tf_dzWizardFormTest.HandleNameExit(_Sender: TObject;
  _Direction: TPrevNext; _OldPageId: integer; var _NewPageId: integer;
  _OldPageData, _NewPageData: Pointer; var _CanChange: boolean);
begin
  Assert(_OldPageId = FPageIdName);

  if _Direction = pnPrevious then
    exit;

  FName := FPageName.ed_Name.Text;
  _CanChange := FName <> '';
  if not _CanChange then
    TF_DZDialog.ShowError('Please enter your name!', '', [dbeRetry]);
end;

end.

