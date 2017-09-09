unit adxtoys2ol_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 6/22/2004 2:17:25 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\_Projects\ADX2.0\Toys\Outlook\adxtoys2ol.tlb (1)
// LIBID: {EEE1DCA4-03C9-4E8A-94BE-930B89B56895}
// LCID: 0
// Helpfile: 
// HelpString: adxtoys2ol Library
// DepndLst: 
//   (1) v1.0 stdole, (D:\WINDOWS\System32\stdole32.tlb)
//   (2) v2.0 StdType, (D:\WINDOWS\System32\olepro32.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  adxtoys2olMajorVersion = 1;
  adxtoys2olMinorVersion = 0;

  LIBID_adxtoys2ol: TGUID = '{EEE1DCA4-03C9-4E8A-94BE-930B89B56895}';

  IID_IadxToysOLAddIn: TGUID = '{1515C319-165F-42D9-8277-AE551A10FCC6}';
  CLASS_adxToysOLAddIn: TGUID = '{868033E6-412A-4025-B023-819936377C4E}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IadxToysOLAddIn = interface;
  IadxToysOLAddInDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  adxToysOLAddIn = IadxToysOLAddIn;


// *********************************************************************//
// Interface: IadxToysOLAddIn
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1515C319-165F-42D9-8277-AE551A10FCC6}
// *********************************************************************//
  IadxToysOLAddIn = interface(IDispatch)
    ['{1515C319-165F-42D9-8277-AE551A10FCC6}']
  end;

// *********************************************************************//
// DispIntf:  IadxToysOLAddInDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1515C319-165F-42D9-8277-AE551A10FCC6}
// *********************************************************************//
  IadxToysOLAddInDisp = dispinterface
    ['{1515C319-165F-42D9-8277-AE551A10FCC6}']
  end;

// *********************************************************************//
// The Class CoadxToysOLAddIn provides a Create and CreateRemote method to          
// create instances of the default interface IadxToysOLAddIn exposed by              
// the CoClass adxToysOLAddIn. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoadxToysOLAddIn = class
    class function Create: IadxToysOLAddIn;
    class function CreateRemote(const MachineName: string): IadxToysOLAddIn;
  end;

implementation

uses ComObj;

class function CoadxToysOLAddIn.Create: IadxToysOLAddIn;
begin
  Result := CreateComObject(CLASS_adxToysOLAddIn) as IadxToysOLAddIn;
end;

class function CoadxToysOLAddIn.CreateRemote(const MachineName: string): IadxToysOLAddIn;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_adxToysOLAddIn) as IadxToysOLAddIn;
end;

end.
