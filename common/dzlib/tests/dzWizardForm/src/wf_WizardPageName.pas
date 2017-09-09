unit wf_WizardPageName;

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
  Tfr_WizardPageName = class(Tfr_dzWizardFrame)
    l_Name: TLabel;
    ed_Name: TEdit;
  private
  public
  end;

implementation

{$R *.dfm}

end.

