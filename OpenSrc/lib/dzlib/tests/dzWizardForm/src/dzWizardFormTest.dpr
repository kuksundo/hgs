program dzWizardFormTest;

uses
  Forms,
  w_dzWizardFormTest in 'w_dzWizardFormTest.pas' {f_dzWizardFormTest},
  w_dzWizardForm in '..\..\..\forms\w_dzWizardForm.pas' {f_dzWizardForm},
  wf_dzWizardFrame in '..\..\..\forms\wf_dzWizardFrame.pas' {fr_dzWizardFrame: TFrame},
  wf_WizardPageName in 'wf_WizardPageName.pas' {fr_WizardPageName: TFrame},
  wf_WizardPageBirthday in 'wf_WizardPageBirthday.pas' {fr_WizardPageBirthday: TFrame},
  wf_WizardPageAge in 'wf_WizardPageAge.pas' {fr_WizardPageAge: TFrame},
  w_dzDialog in '..\..\..\forms\w_dzDialog.pas' {f_dzDialog};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tf_dzWizardFormTest, f_dzWizardFormTest);
  Application.Run;
end.
