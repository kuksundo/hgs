unit karsten_TLB;

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
// File generated on 2010-02-20 21:29:17 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Documents and Settings\matthias\My Documents\Borland Studio Projects\sf\karsten\karsten\karsten.tlb (1)
// LIBID: {82B80F40-BAF9-11D3-A7E5-0000B4812410}
// LCID: 0
// Helpfile: 
// HelpString: karsten SlideShow type library
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
  karstenMajorVersion = 1;
  karstenMinorVersion = 1;

  LIBID_karsten: TGUID = '{82B80F40-BAF9-11D3-A7E5-0000B4812410}';

  IID_IKarstenServer: TGUID = '{82B80F48-BAF9-11D3-A7E5-0000B4812410}';
  DIID_IKarstenServerEvents: TGUID = '{82B80F4A-BAF9-11D3-A7E5-0000B4812410}';
  CLASS_KarstenServer: TGUID = '{82B80F4C-BAF9-11D3-A7E5-0000B4812410}';
  IID_IKarstenSchauServer: TGUID = '{6EB7B400-07F2-11D4-A7E5-0000B4812410}';
  DIID_IKarstenSchauServerEvents: TGUID = '{6EB7B402-07F2-11D4-A7E5-0000B4812410}';
  CLASS_KarstenSchauServer: TGUID = '{6EB7B404-07F2-11D4-A7E5-0000B4812410}';
  IID_IKarstenConfigServer: TGUID = '{6EB7B406-07F2-11D4-A7E5-0000B4812410}';
  DIID_IKarstenConfigServerEvents: TGUID = '{6EB7B408-07F2-11D4-A7E5-0000B4812410}';
  CLASS_KarstenConfigServer: TGUID = '{6EB7B40A-07F2-11D4-A7E5-0000B4812410}';
  IID_IKarstenSchonerServer: TGUID = '{6EB7B40C-07F2-11D4-A7E5-0000B4812410}';
  DIID_IKarstenSchonerServerEvents: TGUID = '{6EB7B40E-07F2-11D4-A7E5-0000B4812410}';
  CLASS_KarstenSchonerServer: TGUID = '{6EB7B410-07F2-11D4-A7E5-0000B4812410}';
  IID_IKarstenLauncher: TGUID = '{CF9BEDAC-042C-44AC-B78A-602DA03E4341}';
  CLASS_KarstenLauncher: TGUID = '{7E59BCEE-E8E4-4934-86D4-B08B491D0346}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum tRunMode
type
  tRunMode = TOleEnum;
const
  rm_Hidden = $00000000;
  rm_Application = $00000001;
  rm_Screensaver = $00000002;
  rm_SSPreview = $00000003;
  rm_SSConfigure = $00000004;
  rm_Terminated = $00000005;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IKarstenServer = interface;
  IKarstenServerDisp = dispinterface;
  IKarstenServerEvents = dispinterface;
  IKarstenSchauServer = interface;
  IKarstenSchauServerDisp = dispinterface;
  IKarstenSchauServerEvents = dispinterface;
  IKarstenConfigServer = interface;
  IKarstenConfigServerDisp = dispinterface;
  IKarstenConfigServerEvents = dispinterface;
  IKarstenSchonerServer = interface;
  IKarstenSchonerServerDisp = dispinterface;
  IKarstenSchonerServerEvents = dispinterface;
  IKarstenLauncher = interface;
  IKarstenLauncherDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  KarstenServer = IKarstenServer;
  KarstenSchauServer = IKarstenSchauServer;
  KarstenConfigServer = IKarstenConfigServer;
  KarstenSchonerServer = IKarstenSchonerServer;
  KarstenLauncher = IKarstenLauncher;


// *********************************************************************//
// Interface: IKarstenServer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {82B80F48-BAF9-11D3-A7E5-0000B4812410}
// *********************************************************************//
  IKarstenServer = interface(IDispatch)
    ['{82B80F48-BAF9-11D3-A7E5-0000B4812410}']
    function Get_DocFileName: WideString; safecall;
    procedure Set_DocFileName(const Value: WideString); safecall;
    property DocFileName: WideString read Get_DocFileName write Set_DocFileName;
  end;

// *********************************************************************//
// DispIntf:  IKarstenServerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {82B80F48-BAF9-11D3-A7E5-0000B4812410}
// *********************************************************************//
  IKarstenServerDisp = dispinterface
    ['{82B80F48-BAF9-11D3-A7E5-0000B4812410}']
    property DocFileName: WideString dispid 1;
  end;

// *********************************************************************//
// DispIntf:  IKarstenServerEvents
// Flags:     (4096) Dispatchable
// GUID:      {82B80F4A-BAF9-11D3-A7E5-0000B4812410}
// *********************************************************************//
  IKarstenServerEvents = dispinterface
    ['{82B80F4A-BAF9-11D3-A7E5-0000B4812410}']
    procedure UserTerminate; dispid 1;
  end;

// *********************************************************************//
// Interface: IKarstenSchauServer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6EB7B400-07F2-11D4-A7E5-0000B4812410}
// *********************************************************************//
  IKarstenSchauServer = interface(IKarstenServer)
    ['{6EB7B400-07F2-11D4-A7E5-0000B4812410}']
    function Get_ViewerWindow: LongWord; safecall;
    procedure Set_ViewerWindow(Value: LongWord); safecall;
    procedure SchauStart; safecall;
    procedure SchauStop; safecall;
    function Get_MonitorIndex: Integer; safecall;
    procedure Set_MonitorIndex(Value: Integer); safecall;
    property ViewerWindow: LongWord read Get_ViewerWindow write Set_ViewerWindow;
    property MonitorIndex: Integer read Get_MonitorIndex write Set_MonitorIndex;
  end;

// *********************************************************************//
// DispIntf:  IKarstenSchauServerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6EB7B400-07F2-11D4-A7E5-0000B4812410}
// *********************************************************************//
  IKarstenSchauServerDisp = dispinterface
    ['{6EB7B400-07F2-11D4-A7E5-0000B4812410}']
    property ViewerWindow: LongWord dispid 3;
    procedure SchauStart; dispid 4;
    procedure SchauStop; dispid 5;
    property MonitorIndex: Integer dispid 301;
    property DocFileName: WideString dispid 1;
  end;

// *********************************************************************//
// DispIntf:  IKarstenSchauServerEvents
// Flags:     (4096) Dispatchable
// GUID:      {6EB7B402-07F2-11D4-A7E5-0000B4812410}
// *********************************************************************//
  IKarstenSchauServerEvents = dispinterface
    ['{6EB7B402-07F2-11D4-A7E5-0000B4812410}']
    procedure UserTerminate; dispid 1;
  end;

// *********************************************************************//
// Interface: IKarstenConfigServer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6EB7B406-07F2-11D4-A7E5-0000B4812410}
// *********************************************************************//
  IKarstenConfigServer = interface(IKarstenServer)
    ['{6EB7B406-07F2-11D4-A7E5-0000B4812410}']
  end;

// *********************************************************************//
// DispIntf:  IKarstenConfigServerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6EB7B406-07F2-11D4-A7E5-0000B4812410}
// *********************************************************************//
  IKarstenConfigServerDisp = dispinterface
    ['{6EB7B406-07F2-11D4-A7E5-0000B4812410}']
    property DocFileName: WideString dispid 1;
  end;

// *********************************************************************//
// DispIntf:  IKarstenConfigServerEvents
// Flags:     (4096) Dispatchable
// GUID:      {6EB7B408-07F2-11D4-A7E5-0000B4812410}
// *********************************************************************//
  IKarstenConfigServerEvents = dispinterface
    ['{6EB7B408-07F2-11D4-A7E5-0000B4812410}']
    procedure UserTerminate; dispid 1;
  end;

// *********************************************************************//
// Interface: IKarstenSchonerServer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6EB7B40C-07F2-11D4-A7E5-0000B4812410}
// *********************************************************************//
  IKarstenSchonerServer = interface(IKarstenSchauServer)
    ['{6EB7B40C-07F2-11D4-A7E5-0000B4812410}']
    function Get_PreviewMode: WordBool; safecall;
    procedure Set_PreviewMode(Value: WordBool); safecall;
    property PreviewMode: WordBool read Get_PreviewMode write Set_PreviewMode;
  end;

// *********************************************************************//
// DispIntf:  IKarstenSchonerServerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6EB7B40C-07F2-11D4-A7E5-0000B4812410}
// *********************************************************************//
  IKarstenSchonerServerDisp = dispinterface
    ['{6EB7B40C-07F2-11D4-A7E5-0000B4812410}']
    property PreviewMode: WordBool dispid 6;
    property ViewerWindow: LongWord dispid 3;
    procedure SchauStart; dispid 4;
    procedure SchauStop; dispid 5;
    property MonitorIndex: Integer dispid 301;
    property DocFileName: WideString dispid 1;
  end;

// *********************************************************************//
// DispIntf:  IKarstenSchonerServerEvents
// Flags:     (4096) Dispatchable
// GUID:      {6EB7B40E-07F2-11D4-A7E5-0000B4812410}
// *********************************************************************//
  IKarstenSchonerServerEvents = dispinterface
    ['{6EB7B40E-07F2-11D4-A7E5-0000B4812410}']
    procedure UserTerminate; dispid 1;
  end;

// *********************************************************************//
// Interface: IKarstenLauncher
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CF9BEDAC-042C-44AC-B78A-602DA03E4341}
// *********************************************************************//
  IKarstenLauncher = interface(IDispatch)
    ['{CF9BEDAC-042C-44AC-B78A-602DA03E4341}']
    procedure SammlungOeffnen(const filename: WideString; monitor: Integer); safecall;
    procedure DesktopWechseln(const filename: WideString; once: Integer); safecall;
    procedure SchauStarten(const filename: WideString; modus: Integer; monitor: Integer; 
                           autoupdate: Integer); safecall;
    procedure DebugShowMainWin; safecall;
  end;

// *********************************************************************//
// DispIntf:  IKarstenLauncherDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CF9BEDAC-042C-44AC-B78A-602DA03E4341}
// *********************************************************************//
  IKarstenLauncherDisp = dispinterface
    ['{CF9BEDAC-042C-44AC-B78A-602DA03E4341}']
    procedure SammlungOeffnen(const filename: WideString; monitor: Integer); dispid 1;
    procedure DesktopWechseln(const filename: WideString; once: Integer); dispid 2;
    procedure SchauStarten(const filename: WideString; modus: Integer; monitor: Integer; 
                           autoupdate: Integer); dispid 3;
    procedure DebugShowMainWin; dispid 4;
  end;

// *********************************************************************//
// The Class CoKarstenServer provides a Create and CreateRemote method to          
// create instances of the default interface IKarstenServer exposed by              
// the CoClass KarstenServer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoKarstenServer = class
    class function Create: IKarstenServer;
    class function CreateRemote(const MachineName: string): IKarstenServer;
  end;

// *********************************************************************//
// The Class CoKarstenSchauServer provides a Create and CreateRemote method to          
// create instances of the default interface IKarstenSchauServer exposed by              
// the CoClass KarstenSchauServer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoKarstenSchauServer = class
    class function Create: IKarstenSchauServer;
    class function CreateRemote(const MachineName: string): IKarstenSchauServer;
  end;

// *********************************************************************//
// The Class CoKarstenConfigServer provides a Create and CreateRemote method to          
// create instances of the default interface IKarstenConfigServer exposed by              
// the CoClass KarstenConfigServer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoKarstenConfigServer = class
    class function Create: IKarstenConfigServer;
    class function CreateRemote(const MachineName: string): IKarstenConfigServer;
  end;

// *********************************************************************//
// The Class CoKarstenSchonerServer provides a Create and CreateRemote method to          
// create instances of the default interface IKarstenSchonerServer exposed by              
// the CoClass KarstenSchonerServer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoKarstenSchonerServer = class
    class function Create: IKarstenSchonerServer;
    class function CreateRemote(const MachineName: string): IKarstenSchonerServer;
  end;

// *********************************************************************//
// The Class CoKarstenLauncher provides a Create and CreateRemote method to          
// create instances of the default interface IKarstenLauncher exposed by              
// the CoClass KarstenLauncher. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoKarstenLauncher = class
    class function Create: IKarstenLauncher;
    class function CreateRemote(const MachineName: string): IKarstenLauncher;
  end;

implementation

uses ComObj;

class function CoKarstenServer.Create: IKarstenServer;
begin
  Result := CreateComObject(CLASS_KarstenServer) as IKarstenServer;
end;

class function CoKarstenServer.CreateRemote(const MachineName: string): IKarstenServer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_KarstenServer) as IKarstenServer;
end;

class function CoKarstenSchauServer.Create: IKarstenSchauServer;
begin
  Result := CreateComObject(CLASS_KarstenSchauServer) as IKarstenSchauServer;
end;

class function CoKarstenSchauServer.CreateRemote(const MachineName: string): IKarstenSchauServer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_KarstenSchauServer) as IKarstenSchauServer;
end;

class function CoKarstenConfigServer.Create: IKarstenConfigServer;
begin
  Result := CreateComObject(CLASS_KarstenConfigServer) as IKarstenConfigServer;
end;

class function CoKarstenConfigServer.CreateRemote(const MachineName: string): IKarstenConfigServer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_KarstenConfigServer) as IKarstenConfigServer;
end;

class function CoKarstenSchonerServer.Create: IKarstenSchonerServer;
begin
  Result := CreateComObject(CLASS_KarstenSchonerServer) as IKarstenSchonerServer;
end;

class function CoKarstenSchonerServer.CreateRemote(const MachineName: string): IKarstenSchonerServer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_KarstenSchonerServer) as IKarstenSchonerServer;
end;

class function CoKarstenLauncher.Create: IKarstenLauncher;
begin
  Result := CreateComObject(CLASS_KarstenLauncher) as IKarstenLauncher;
end;

class function CoKarstenLauncher.CreateRemote(const MachineName: string): IKarstenLauncher;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_KarstenLauncher) as IKarstenLauncher;
end;

end.
