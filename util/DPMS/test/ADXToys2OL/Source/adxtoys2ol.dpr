library adxtoys2ol;

uses
  ComServ,
  adxtoys2ol_TLB in 'adxtoys2ol_TLB.pas',
  adxtoys2ol_IMPL in 'adxtoys2ol_IMPL.pas' {AddInModule: TAddInModule},
  AdxToysForm in '..\Common\AdxToysForm.pas' {frmTemplate},
  adxtAboutFrm in '..\Common\adxtAboutFrm.pas' {frmAbout},
  adxtHeadersFrm in 'adxtHeadersFrm.pas' {frmIHeaders},
  adxtBodyFrm in 'adxtBodyFrm.pas' {frmContent};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
