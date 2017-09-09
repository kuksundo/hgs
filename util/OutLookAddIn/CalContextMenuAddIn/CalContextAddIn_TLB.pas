unit CalContextAddIn_TLB;

{$TYPEDADDRESS OFF}

interface

uses SysUtils, ComObj, ComServ, ActiveX, Variants;

const
  CalContextAddInMajorVersion = 1;
  CalContextAddInMinorVersion = 0;

  LIBID_CalContextAddIn: TGUID = '{45825421-6F63-4CA6-922B-9B381856AD4C}';

  IID_ICoCalContextAddIn: TGUID = '{4B19CF72-3C09-4EC5-9823-D21350A27E13}';
  CLASS_CoCalContextAddIn: TGUID = '{6081FD92-EC2D-4E70-A183-AF266E016F97}';

type
  ICoCalContextAddIn = interface(IDispatch)
    ['{4B19CF72-3C09-4EC5-9823-D21350A27E13}']
  end;

  ICoCalContextAddInDisp = dispinterface
    ['{4B19CF72-3C09-4EC5-9823-D21350A27E13}']
  end;

implementation

end.
