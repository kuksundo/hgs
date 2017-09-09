unit wf_WizardPageAge;

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
  wf_dzWizardFrame,
  StdCtrls;

type
  Tfr_WizardPageAge = class(Tfr_dzWizardFrame)
    l_Age: TLabel;
  private
  public
  end;

implementation

{$R *.dfm}

end.

