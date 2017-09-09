unit karstenScrSav_TLB;

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
// File generated on 2010-02-20 21:29:16 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Documents and Settings\matthias\My Documents\Borland Studio Projects\sf\karsten\karsten\karstenScrSav.tlb (1)
// LIBID: {8DD3C960-BCA1-11D3-A7E5-0000B4812410}
// LCID: 0
// Helpfile: 
// HelpString: Karsten Bildschirmschoner Typenbibliothek
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\STDOLE2.TLB)
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
  karstenScrSavMajorVersion = 1;
  karstenScrSavMinorVersion = 0;

  LIBID_karstenScrSav: TGUID = '{8DD3C960-BCA1-11D3-A7E5-0000B4812410}';

  IID_IAutoNotify: TGUID = '{8DD3C961-BCA1-11D3-A7E5-0000B4812410}';
  CLASS_AutoNotify: TGUID = '{8DD3C963-BCA1-11D3-A7E5-0000B4812410}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IAutoNotify = interface;
  IAutoNotifyDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  AutoNotify = IAutoNotify;


// *********************************************************************//
// Interface: IAutoNotify
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8DD3C961-BCA1-11D3-A7E5-0000B4812410}
// *********************************************************************//
  IAutoNotify = interface(IDispatch)
    ['{8DD3C961-BCA1-11D3-A7E5-0000B4812410}']
    procedure UserTerminate; safecall;
  end;

// *********************************************************************//
// DispIntf:  IAutoNotifyDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8DD3C961-BCA1-11D3-A7E5-0000B4812410}
// *********************************************************************//
  IAutoNotifyDisp = dispinterface
    ['{8DD3C961-BCA1-11D3-A7E5-0000B4812410}']
    procedure UserTerminate; dispid 1;
  end;

// *********************************************************************//
// The Class CoAutoNotify provides a Create and CreateRemote method to          
// create instances of the default interface IAutoNotify exposed by              
// the CoClass AutoNotify. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAutoNotify = class
    class function Create: IAutoNotify;
    class function CreateRemote(const MachineName: string): IAutoNotify;
  end;

implementation

uses ComObj;

class function CoAutoNotify.Create: IAutoNotify;
begin
  Result := CreateComObject(CLASS_AutoNotify) as IAutoNotify;
end;

class function CoAutoNotify.CreateRemote(const MachineName: string): IAutoNotify;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AutoNotify) as IAutoNotify;
end;

end.
