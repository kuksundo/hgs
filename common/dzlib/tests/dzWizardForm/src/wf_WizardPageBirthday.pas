unit wf_WizardPageBirthday;

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
  wf_dzWizardFrame, StdCtrls, ComCtrls;

type
  Tfr_WizardPageBirthday = class(Tfr_dzWizardFrame)
    dtp_Birthday: TDateTimePicker;
    l_Birthday: TLabel;
  private
  public
  end;

implementation

{$R *.dfm}

end.

