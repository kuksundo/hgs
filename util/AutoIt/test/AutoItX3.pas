{-----------------------------------------------------------------------------
 Unit Name: AutoItX3
 Author:    Melloware <info@melloware.com>
            http://www.melloware.com
 Purpose:   Delphi Wrapper for AutoItX v3
 Desc:      AutoIt v3 is a freeware BASIC-like scripting language designed
            for automating the Windows GUI.  It uses a combination of
            simulated keystrokes, mouse movement and window/control
            manipulation in order to automate tasks in a way not possible
            or reliable with other languages.
            AutoItX will allow you to add the unique features of AutoIt to
            your Delphi applications! 
 History:   09/29/2007   Initial Version
-----------------------------------------------------------------------------}
unit AutoItX3;

interface
uses
   SysUtils, Messages,
{$IFDEF WIN32}
   Windows;
{$ELSE}
   Wintypes, WinProcs;
{$ENDIF}

{=> AUTOITX3.H <=}

{$IFNDEF __AUTOIT3_H}
{$DEFINE __AUTOIT3_H}

{//////////////////////////////////////////////////////////////////////////////// }
{/// }
{/// AutoItX v3 }
{/// }
{/// Copyright (C)1999-2007: }
{/// - Jonathan Bennett <jon at autoitscript dot com> }
{/// - See "AUTHORS.txt" for contributors. }
{/// }
{/// This file is part of AutoItX. Use of this file and the AutoItX DLL is subject }
{/// to the terms of the AutoItX license details of which can be found in the helpfile. }
{/// }
{/// When using the AutoItX3.dll as a standard DLL this file contains the definitions, }
{/// and function declarations required to use the DLL and AutoItX3.lib file. }
{/// }
{//////////////////////////////////////////////////////////////////////////////// }

{$IFDEF __cplusplus}
const
   extern = 'C';
{$ELSE}
{$DEFINE AU3_API}
{$ENDIF}

{/// Definitions }
const
   AU3_INTDEFAULT = (-2147483647); {// 'Default' value for _some_ int parameters (largest negative number)}
   AU3_DLL = 'AutoItX3.dll'; //DLL FileName
   AU3_DESCRIPTION = 'AutoIt v3 DLL/COM Control'; //DLL Description

{//////////////////////////////////////////////////////////////////////////////// }
{/// Public Helper functions
{//////////////////////////////////////////////////////////////////////////////// }
var
   AutoItXDLLLoaded: Boolean {$IFDEF WIN32} = False; {$ENDIF} { is DLL (dynamically) loaded already? }
   AutoItXDescription: string = AU3_DESCRIPTION;
   function AutoItXVersion(): string;

{//////////////////////////////////////////////////////////////////////////////// }
{/// BEGIN Exported functions }
{//////////////////////////////////////////////////////////////////////////////// }

var
   AU3_Init: procedure{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_error: function: LongInt cdecl{$IFDEF WIN32} stdcall{$ENDIF};

var
   AU3_AutoItSetOption: function(const szOption: LPCWSTR;
      nValue: LongInt): LongInt{$IFDEF WIN32} stdcall{$ENDIF};

var
   AU3_BlockInput: procedure(nFlag: LongInt){$IFDEF WIN32} stdcall{$ENDIF};

var
   AU3_CDTray: procedure(const szDrive: LPCWSTR;
      const szAction: LPCWSTR){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ClipGet: procedure(szClip: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ClipPut: procedure(const szClip: LPCWSTR){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlClick: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR;
      const szButton: LPCWSTR;
      nNumClicks: LongInt;
      nX: LongInt = AU3_INTDEFAULT;
      nY: LongInt = AU3_INTDEFAULT): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlCommand: procedure(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR;
      const szCommand: LPCWSTR;
      const szExtra: LPCWSTR;
      szResult: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlListView: procedure(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR;
      const szCommand: LPCWSTR;
      const szExtra1: LPCWSTR;
      const szExtra2: LPCWSTR;
      szResult: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlDisable: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlEnable: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlFocus: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlGetFocus: procedure(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      szControlWithFocus: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlGetHandle: procedure(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR;
      szRetText: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlGetPosX: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlGetPosY: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlGetPosHeight: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlGetPosWidth: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlGetText: procedure(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR;
      szControlText: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlHide: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlMove: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR;
      nX: LongInt;
      nY: LongInt;
      nWidth: LongInt = -1;
      nHeight: LongInt = -1): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlSend: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR;
      const szSendText: LPCWSTR;
      nMode: LongInt = 0): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlSetText: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR;
      const szControlText: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ControlShow: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szControl: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};

var
   AU3_DriveMapAdd: procedure(const szDevice: LPCWSTR;
      const szShare: LPCWSTR;
      nFlags: LongInt;
      const szUser: LPCWSTR;
      const szPwd: LPCWSTR;
      szResult: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_DriveMapDel: function(const szDevice: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_DriveMapGet: procedure(const szDevice: LPCWSTR;
      szMapping: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};

var
   AU3_IniDelete: function(const szFilename: LPCWSTR;
      const szSection: LPCWSTR;
      const szKey: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_IniRead: procedure(const szFilename: LPCWSTR;
      const szSection: LPCWSTR;
      const szKey: LPCWSTR;
      const szDefault: LPCWSTR;
      szValue: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_IniWrite: function(const szFilename: LPCWSTR;
      const szSection: LPCWSTR;
      const szKey: LPCWSTR;
      const szValue: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_IsAdmin: function: LongInt{$IFDEF WIN32} stdcall{$ENDIF};

var
   AU3_MouseClick: function(const szButton: LPCWSTR;
      nX: LongInt = AU3_INTDEFAULT;
      nY: LongInt = AU3_INTDEFAULT;
      nClicks: LongInt = 1;
      nSpeed: LongInt = -1): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_MouseClickDrag: function(const szButton: LPCWSTR;
      nX1: LongInt;
      nY1: LongInt;
      nX2: LongInt;
      nY2: LongInt;
      nSpeed: LongInt = -1): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_MouseDown: procedure(const szButton: LPCWSTR){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_MouseGetCursor: function: LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_MouseGetPosX: function: LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_MouseGetPosY: function: LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_MouseMove: function(nX: LongInt;
      nY: LongInt;
      nSpeed: LongInt = -1): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_MouseUp: procedure(const szButton: LPCWSTR){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_MouseWheel: procedure(const szDirection: LPCWSTR;
      nClicks: LongInt){$IFDEF WIN32} stdcall{$ENDIF};

var
   AU3_Opt: function(const szOption: LPCWSTR;
      nValue: LongInt): LongInt{$IFDEF WIN32} stdcall{$ENDIF};

var
   AU3_PixelChecksum: function(nLeft: LongInt;
      nTop: LongInt;
      nRight: LongInt;
      nBottom: LongInt;
      nStep: LongInt = 1): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_PixelGetColor: function(nX: LongInt;
      nY: LongInt): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_PixelSearch: procedure(nLeft: LongInt;
      nTop: LongInt;
      nRight: LongInt;
      nBottom: LongInt;
      nCol: LongInt;
      nVar: LongInt;
      nStep: LongInt;
      var pPointResult: TPoint){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ProcessClose: function(const szProcess: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ProcessExists: function(const szProcess: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ProcessSetPriority: function(const szProcess: LPCWSTR;
      nPriority: LongInt): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ProcessWait: function(const szProcess: LPCWSTR;
      nTimeout: LongInt = 0): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_ProcessWaitClose: function(const szProcess: LPCWSTR;
      nTimeout: LongInt = 0): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_RegDeleteKey: function(const szKeyname: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_RegDeleteVal: function(const szKeyname: LPCWSTR;
      const szValuename: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_RegEnumKey: procedure(const szKeyname: LPCWSTR;
      nInstance: LongInt;
      szResult: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_RegEnumVal: procedure(const szKeyname: LPCWSTR;
      nInstance: LongInt;
      szResult: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_RegRead: procedure(const szKeyname: LPCWSTR;
      const szValuename: LPCWSTR;
      szRetText: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_RegWrite: function(const szKeyname: LPCWSTR;
      const szValuename: LPCWSTR;
      const szType: LPCWSTR;
      const szValue: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_Run: function(const szRun: LPCWSTR;
      const szDir: LPCWSTR;
      nShowFlags: LongInt = 1): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_RunAsSet: function(const szUser: LPCWSTR;
      const szDomain: LPCWSTR;
      const szPassword: LPCWSTR;
      nOptions: Integer): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_RunWait: function(const szRun: LPCWSTR;
      const szDir: LPCWSTR;
      nShowFlags: LongInt = 1): LongInt{$IFDEF WIN32} stdcall{$ENDIF};

var
   AU3_Send: procedure(const szSendText: LPCWSTR;
      nMode: LongInt = 0){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_Shutdown: function(nFlags: LongInt): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_Sleep: procedure(nMilliseconds: LongInt){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_StatusbarGetText: procedure(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      nPart: LongInt;
      szStatusText: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};

var
   AU3_ToolTip: procedure(const szTip: LPCWSTR;
      nX: LongInt = AU3_INTDEFAULT;
      nY: LongInt = AU3_INTDEFAULT){$IFDEF WIN32} stdcall{$ENDIF};

var
   AU3_WinActivate: procedure(const szTitle: LPCWSTR;
      const szText: LPCWSTR){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinActive: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinClose: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinExists: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinGetCaretPosX: function: LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinGetCaretPosY: function: LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinGetClassList: procedure(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      szRetText: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinGetClientSizeHeight: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinGetClientSizeWidth: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinGetHandle: procedure(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      szRetText: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinGetPosX: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinGetPosY: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinGetPosHeight: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinGetPosWidth: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinGetProcess: procedure(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      szRetText: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinGetState: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinGetText: procedure(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      szRetText: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinGetTitle: procedure(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      szRetText: LPCWSTR;
      nBufSize: Integer){$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinKill: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinMenuSelectItem: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szItem1: LPCWSTR;
      const szItem2: LPCWSTR;
      const szItem3: LPCWSTR;
      const szItem4: LPCWSTR;
      const szItem5: LPCWSTR;
      const szItem6: LPCWSTR;
      const szItem7: LPCWSTR;
      const szItem8: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinMinimizeAll: procedure{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinMinimizeAllUndo: procedure{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinMove: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      nX: LongInt;
      nY: LongInt;
      nWidth: LongInt = -1;
      nHeight: LongInt = -1): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinSetOnTop: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      nFlag: LongInt): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinSetState: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      nFlags: LongInt): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinSetTitle: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      const szNewTitle: LPCWSTR): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinSetTrans: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      nTrans: LongInt): LongInt{$IFDEF WIN32} stdcall{$ENDIF};

var
   AU3_WinWait: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      nTimeout: LongInt = 0): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinWaitActive: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      nTimeout: LongInt = 0): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinWaitClose: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      nTimeout: LongInt = 0): LongInt{$IFDEF WIN32} stdcall{$ENDIF};
var
   AU3_WinWaitNotActive: function(const szTitle: LPCWSTR;
      const szText: LPCWSTR;
      nTimeout: LongInt = 0): LongInt{$IFDEF WIN32} stdcall{$ENDIF};

{//////////////////////////////////////////////////////////////////////////////// }
{/// FINISHED Exported functions }
{//////////////////////////////////////////////////////////////////////////////// }

{$ENDIF}

implementation

var
   SaveExit: pointer;
   DLLHandle: THandle;
{$IFNDEF MSDOS}
   ErrorMode: Integer;
{$ENDIF}

{===============================================================================
    :Procedure: GetFileVersion
 :Date Created: 09/24/2007
  :Description: GetFileVersion fills the VerBlk with the version information
                from file "filename".
                If no version information is avaible the function returns false,
                otherwise true.
===============================================================================}
function GetFileVersion(filename: string; var VerBlk: VS_FIXEDFILEINFO): boolean;
var InfoSize, puLen: DWord;
   Pt, InfoPtr: Pointer;
begin
   InfoSize := GetFileVersionInfoSize(PChar(filename), puLen);
   fillchar(VerBlk, sizeof(VS_FIXEDFILEINFO), 0);
   if InfoSize > 0 then begin
      GetMem(Pt, InfoSize);
      GetFileVersionInfo(PChar(filename), 0, InfoSize, Pt);
      VerQueryValue(Pt, '\', InfoPtr, puLen);
      move(InfoPtr^, VerBlk, sizeof(VS_FIXEDFILEINFO));
      FreeMem(Pt);
      result := true;
   end else result := false;
end;

{===============================================================================
    :Procedure: AutoItXVersion
 :Date Created: 09/24/2007
  :Description: Gets the DLL's version number string.
===============================================================================}
function AutoItXVersion(): string;
   // DWHi returns the high word in the DWord
   function DWHi(val: DWord): word assembler;
   asm
   mov EAX, val;
   shr EAX,16;
   end;

   // DWHi returns the low word in the DWord
   function DWLo(val: DWord): word assembler;
   asm
   mov EAX, val;
   end;
var
   fileinfo: VS_FIXEDFILEINFO;
begin
   if GetFileVersion(AU3_DLL, fileinfo) then begin
      result := Format('%u.%u.%u.%u',
         [DWHi(fileinfo.dwProductVersionMS),
         DWLo(fileinfo.dwProductVersionMS),
            DWHi(fileinfo.dwProductVersionLS),
            DWLo(fileinfo.dwProductVersionLS)]);
   end else result := '';
end;

procedure NewExit; far;
begin
   ExitProc := SaveExit;
   FreeLibrary(DLLHandle)
end {NewExit};

procedure LoadDLL;
begin
   if AutoItXDLLLoaded then Exit;
{$IFNDEF MSDOS}
   ErrorMode := SetErrorMode($8000 {SEM_NoOpenFileErrorBox});
{$ENDIF}
   DLLHandle := LoadLibrary(AU3_DLL);
   if DLLHandle >= 32 then
   begin
      AutoItXDLLLoaded := True;
      SaveExit := ExitProc;
      ExitProc := @NewExit;
      @AU3_Init := GetProcAddress(DLLHandle, 'AU3_Init');
{$IFDEF WIN32}
      Assert(@AU3_Init <> nil);
{$ENDIF}
      @AU3_error := GetProcAddress(DLLHandle, 'AU3_error');
{$IFDEF WIN32}
      Assert(@AU3_error <> nil);
{$ENDIF}
      @AU3_AutoItSetOption := GetProcAddress(DLLHandle, 'AU3_AutoItSetOption');
{$IFDEF WIN32}
      Assert(@AU3_AutoItSetOption <> nil);
{$ENDIF}
      @AU3_BlockInput := GetProcAddress(DLLHandle, 'AU3_BlockInput');
{$IFDEF WIN32}
      Assert(@AU3_BlockInput <> nil);
{$ENDIF}
      @AU3_CDTray := GetProcAddress(DLLHandle, 'AU3_CDTray');
{$IFDEF WIN32}
      Assert(@AU3_CDTray <> nil);
{$ENDIF}
      @AU3_ClipGet := GetProcAddress(DLLHandle, 'AU3_ClipGet');
{$IFDEF WIN32}
      Assert(@AU3_ClipGet <> nil);
{$ENDIF}
      @AU3_ClipPut := GetProcAddress(DLLHandle, 'AU3_ClipPut');
{$IFDEF WIN32}
      Assert(@AU3_ClipPut <> nil);
{$ENDIF}
      @AU3_ControlClick := GetProcAddress(DLLHandle, 'AU3_ControlClick');
{$IFDEF WIN32}
      Assert(@AU3_ControlClick <> nil);
{$ENDIF}
      @AU3_ControlCommand := GetProcAddress(DLLHandle, 'AU3_ControlCommand');
{$IFDEF WIN32}
      Assert(@AU3_ControlCommand <> nil);
{$ENDIF}
      @AU3_ControlListView := GetProcAddress(DLLHandle, 'AU3_ControlListView');
{$IFDEF WIN32}
      Assert(@AU3_ControlListView <> nil);
{$ENDIF}
      @AU3_ControlDisable := GetProcAddress(DLLHandle, 'AU3_ControlDisable');
{$IFDEF WIN32}
      Assert(@AU3_ControlDisable <> nil);
{$ENDIF}
      @AU3_ControlEnable := GetProcAddress(DLLHandle, 'AU3_ControlEnable');
{$IFDEF WIN32}
      Assert(@AU3_ControlEnable <> nil);
{$ENDIF}
      @AU3_ControlFocus := GetProcAddress(DLLHandle, 'AU3_ControlFocus');
{$IFDEF WIN32}
      Assert(@AU3_ControlFocus <> nil);
{$ENDIF}
      @AU3_ControlGetFocus := GetProcAddress(DLLHandle, 'AU3_ControlGetFocus');
{$IFDEF WIN32}
      Assert(@AU3_ControlGetFocus <> nil);
{$ENDIF}
      @AU3_ControlGetHandle := GetProcAddress(DLLHandle, 'AU3_ControlGetHandle');
{$IFDEF WIN32}
      Assert(@AU3_ControlGetHandle <> nil);
{$ENDIF}
      @AU3_ControlGetPosX := GetProcAddress(DLLHandle, 'AU3_ControlGetPosX');
{$IFDEF WIN32}
      Assert(@AU3_ControlGetPosX <> nil);
{$ENDIF}
      @AU3_ControlGetPosY := GetProcAddress(DLLHandle, 'AU3_ControlGetPosY');
{$IFDEF WIN32}
      Assert(@AU3_ControlGetPosY <> nil);
{$ENDIF}
      @AU3_ControlGetPosHeight := GetProcAddress(DLLHandle, 'AU3_ControlGetPosHeight');
{$IFDEF WIN32}
      Assert(@AU3_ControlGetPosHeight <> nil);
{$ENDIF}
      @AU3_ControlGetPosWidth := GetProcAddress(DLLHandle, 'AU3_ControlGetPosWidth');
{$IFDEF WIN32}
      Assert(@AU3_ControlGetPosWidth <> nil);
{$ENDIF}
      @AU3_ControlGetText := GetProcAddress(DLLHandle, 'AU3_ControlGetText');
{$IFDEF WIN32}
      Assert(@AU3_ControlGetText <> nil);
{$ENDIF}
      @AU3_ControlHide := GetProcAddress(DLLHandle, 'AU3_ControlHide');
{$IFDEF WIN32}
      Assert(@AU3_ControlHide <> nil);
{$ENDIF}
      @AU3_ControlMove := GetProcAddress(DLLHandle, 'AU3_ControlMove');
{$IFDEF WIN32}
      Assert(@AU3_ControlMove <> nil);
{$ENDIF}
      @AU3_ControlSend := GetProcAddress(DLLHandle, 'AU3_ControlSend');
{$IFDEF WIN32}
      Assert(@AU3_ControlSend <> nil);
{$ENDIF}
      @AU3_ControlSetText := GetProcAddress(DLLHandle, 'AU3_ControlSetText');
{$IFDEF WIN32}
      Assert(@AU3_ControlSetText <> nil);
{$ENDIF}
      @AU3_ControlShow := GetProcAddress(DLLHandle, 'AU3_ControlShow');
{$IFDEF WIN32}
      Assert(@AU3_ControlShow <> nil);
{$ENDIF}
      @AU3_DriveMapAdd := GetProcAddress(DLLHandle, 'AU3_DriveMapAdd');
{$IFDEF WIN32}
      Assert(@AU3_DriveMapAdd <> nil);
{$ENDIF}
      @AU3_DriveMapDel := GetProcAddress(DLLHandle, 'AU3_DriveMapDel');
{$IFDEF WIN32}
      Assert(@AU3_DriveMapDel <> nil);
{$ENDIF}
      @AU3_DriveMapGet := GetProcAddress(DLLHandle, 'AU3_DriveMapGet');
{$IFDEF WIN32}
      Assert(@AU3_DriveMapGet <> nil);
{$ENDIF}
      @AU3_IniDelete := GetProcAddress(DLLHandle, 'AU3_IniDelete');
{$IFDEF WIN32}
      Assert(@AU3_IniDelete <> nil);
{$ENDIF}
      @AU3_IniRead := GetProcAddress(DLLHandle, 'AU3_IniRead');
{$IFDEF WIN32}
      Assert(@AU3_IniRead <> nil);
{$ENDIF}
      @AU3_IniWrite := GetProcAddress(DLLHandle, 'AU3_IniWrite');
{$IFDEF WIN32}
      Assert(@AU3_IniWrite <> nil);
{$ENDIF}
      @AU3_IsAdmin := GetProcAddress(DLLHandle, 'AU3_IsAdmin');
{$IFDEF WIN32}
      Assert(@AU3_IsAdmin <> nil);
{$ENDIF}
      @AU3_MouseClick := GetProcAddress(DLLHandle, 'AU3_MouseClick');
{$IFDEF WIN32}
      Assert(@AU3_MouseClick <> nil);
{$ENDIF}
      @AU3_MouseClickDrag := GetProcAddress(DLLHandle, 'AU3_MouseClickDrag');
{$IFDEF WIN32}
      Assert(@AU3_MouseClickDrag <> nil);
{$ENDIF}
      @AU3_MouseDown := GetProcAddress(DLLHandle, 'AU3_MouseDown');
{$IFDEF WIN32}
      Assert(@AU3_MouseDown <> nil);
{$ENDIF}
      @AU3_MouseGetCursor := GetProcAddress(DLLHandle, 'AU3_MouseGetCursor');
{$IFDEF WIN32}
      Assert(@AU3_MouseGetCursor <> nil);
{$ENDIF}
      @AU3_MouseGetPosX := GetProcAddress(DLLHandle, 'AU3_MouseGetPosX');
{$IFDEF WIN32}
      Assert(@AU3_MouseGetPosX <> nil);
{$ENDIF}
      @AU3_MouseGetPosY := GetProcAddress(DLLHandle, 'AU3_MouseGetPosY');
{$IFDEF WIN32}
      Assert(@AU3_MouseGetPosY <> nil);
{$ENDIF}
      @AU3_MouseMove := GetProcAddress(DLLHandle, 'AU3_MouseMove');
{$IFDEF WIN32}
      Assert(@AU3_MouseMove <> nil);
{$ENDIF}
      @AU3_MouseUp := GetProcAddress(DLLHandle, 'AU3_MouseUp');
{$IFDEF WIN32}
      Assert(@AU3_MouseUp <> nil);
{$ENDIF}
      @AU3_MouseWheel := GetProcAddress(DLLHandle, 'AU3_MouseWheel');
{$IFDEF WIN32}
      Assert(@AU3_MouseWheel <> nil);
{$ENDIF}
      @AU3_Opt := GetProcAddress(DLLHandle, 'AU3_Opt');
{$IFDEF WIN32}
      Assert(@AU3_Opt <> nil);
{$ENDIF}
      @AU3_PixelChecksum := GetProcAddress(DLLHandle, 'AU3_PixelChecksum');
{$IFDEF WIN32}
      Assert(@AU3_PixelChecksum <> nil);
{$ENDIF}
      @AU3_PixelGetColor := GetProcAddress(DLLHandle, 'AU3_PixelGetColor');
{$IFDEF WIN32}
      Assert(@AU3_PixelGetColor <> nil);
{$ENDIF}
      @AU3_PixelSearch := GetProcAddress(DLLHandle, 'AU3_PixelSearch');
{$IFDEF WIN32}
      Assert(@AU3_PixelSearch <> nil);
{$ENDIF}
      @AU3_ProcessClose := GetProcAddress(DLLHandle, 'AU3_ProcessClose');
{$IFDEF WIN32}
      Assert(@AU3_ProcessClose <> nil);
{$ENDIF}
      @AU3_ProcessExists := GetProcAddress(DLLHandle, 'AU3_ProcessExists');
{$IFDEF WIN32}
      Assert(@AU3_ProcessExists <> nil);
{$ENDIF}
      @AU3_ProcessSetPriority := GetProcAddress(DLLHandle, 'AU3_ProcessSetPriority');
{$IFDEF WIN32}
      Assert(@AU3_ProcessSetPriority <> nil);
{$ENDIF}
      @AU3_ProcessWait := GetProcAddress(DLLHandle, 'AU3_ProcessWait');
{$IFDEF WIN32}
      Assert(@AU3_ProcessWait <> nil);
{$ENDIF}
      @AU3_ProcessWaitClose := GetProcAddress(DLLHandle, 'AU3_ProcessWaitClose');
{$IFDEF WIN32}
      Assert(@AU3_ProcessWaitClose <> nil);
{$ENDIF}
      @AU3_RegDeleteKey := GetProcAddress(DLLHandle, 'AU3_RegDeleteKey');
{$IFDEF WIN32}
      Assert(@AU3_RegDeleteKey <> nil);
{$ENDIF}
      @AU3_RegDeleteVal := GetProcAddress(DLLHandle, 'AU3_RegDeleteVal');
{$IFDEF WIN32}
      Assert(@AU3_RegDeleteVal <> nil);
{$ENDIF}
      @AU3_RegEnumKey := GetProcAddress(DLLHandle, 'AU3_RegEnumKey');
{$IFDEF WIN32}
      Assert(@AU3_RegEnumKey <> nil);
{$ENDIF}
      @AU3_RegEnumVal := GetProcAddress(DLLHandle, 'AU3_RegEnumVal');
{$IFDEF WIN32}
      Assert(@AU3_RegEnumVal <> nil);
{$ENDIF}
      @AU3_RegRead := GetProcAddress(DLLHandle, 'AU3_RegRead');
{$IFDEF WIN32}
      Assert(@AU3_RegRead <> nil);
{$ENDIF}
      @AU3_RegWrite := GetProcAddress(DLLHandle, 'AU3_RegWrite');
{$IFDEF WIN32}
      Assert(@AU3_RegWrite <> nil);
{$ENDIF}
      @AU3_Run := GetProcAddress(DLLHandle, 'AU3_Run');
{$IFDEF WIN32}
      Assert(@AU3_Run <> nil);
{$ENDIF}
      @AU3_RunAsSet := GetProcAddress(DLLHandle, 'AU3_RunAsSet');
{$IFDEF WIN32}
      Assert(@AU3_RunAsSet <> nil);
{$ENDIF}
      @AU3_RunWait := GetProcAddress(DLLHandle, 'AU3_RunWait');
{$IFDEF WIN32}
      Assert(@AU3_RunWait <> nil);
{$ENDIF}
      @AU3_Send := GetProcAddress(DLLHandle, 'AU3_Send');
{$IFDEF WIN32}
      Assert(@AU3_Send <> nil);
{$ENDIF}
      @AU3_Shutdown := GetProcAddress(DLLHandle, 'AU3_Shutdown');
{$IFDEF WIN32}
      Assert(@AU3_Shutdown <> nil);
{$ENDIF}
      @AU3_Sleep := GetProcAddress(DLLHandle, 'AU3_Sleep');
{$IFDEF WIN32}
      Assert(@AU3_Sleep <> nil);
{$ENDIF}
      @AU3_StatusbarGetText := GetProcAddress(DLLHandle, 'AU3_StatusbarGetText');
{$IFDEF WIN32}
      Assert(@AU3_StatusbarGetText <> nil);
{$ENDIF}
      @AU3_ToolTip := GetProcAddress(DLLHandle, 'AU3_ToolTip');
{$IFDEF WIN32}
      Assert(@AU3_ToolTip <> nil);
{$ENDIF}
      @AU3_WinActivate := GetProcAddress(DLLHandle, 'AU3_WinActivate');
{$IFDEF WIN32}
      Assert(@AU3_WinActivate <> nil);
{$ENDIF}
      @AU3_WinActive := GetProcAddress(DLLHandle, 'AU3_WinActive');
{$IFDEF WIN32}
      Assert(@AU3_WinActive <> nil);
{$ENDIF}
      @AU3_WinClose := GetProcAddress(DLLHandle, 'AU3_WinClose');
{$IFDEF WIN32}
      Assert(@AU3_WinClose <> nil);
{$ENDIF}
      @AU3_WinExists := GetProcAddress(DLLHandle, 'AU3_WinExists');
{$IFDEF WIN32}
      Assert(@AU3_WinExists <> nil);
{$ENDIF}
      @AU3_WinGetCaretPosX := GetProcAddress(DLLHandle, 'AU3_WinGetCaretPosX');
{$IFDEF WIN32}
      Assert(@AU3_WinGetCaretPosX <> nil);
{$ENDIF}
      @AU3_WinGetCaretPosY := GetProcAddress(DLLHandle, 'AU3_WinGetCaretPosY');
{$IFDEF WIN32}
      Assert(@AU3_WinGetCaretPosY <> nil);
{$ENDIF}
      @AU3_WinGetClassList := GetProcAddress(DLLHandle, 'AU3_WinGetClassList');
{$IFDEF WIN32}
      Assert(@AU3_WinGetClassList <> nil);
{$ENDIF}
      @AU3_WinGetClientSizeHeight := GetProcAddress(DLLHandle, 'AU3_WinGetClientSizeHeight');
{$IFDEF WIN32}
      Assert(@AU3_WinGetClientSizeHeight <> nil);
{$ENDIF}
      @AU3_WinGetClientSizeWidth := GetProcAddress(DLLHandle, 'AU3_WinGetClientSizeWidth');
{$IFDEF WIN32}
      Assert(@AU3_WinGetClientSizeWidth <> nil);
{$ENDIF}
      @AU3_WinGetHandle := GetProcAddress(DLLHandle, 'AU3_WinGetHandle');
{$IFDEF WIN32}
      Assert(@AU3_WinGetHandle <> nil);
{$ENDIF}
      @AU3_WinGetPosX := GetProcAddress(DLLHandle, 'AU3_WinGetPosX');
{$IFDEF WIN32}
      Assert(@AU3_WinGetPosX <> nil);
{$ENDIF}
      @AU3_WinGetPosY := GetProcAddress(DLLHandle, 'AU3_WinGetPosY');
{$IFDEF WIN32}
      Assert(@AU3_WinGetPosY <> nil);
{$ENDIF}
      @AU3_WinGetPosHeight := GetProcAddress(DLLHandle, 'AU3_WinGetPosHeight');
{$IFDEF WIN32}
      Assert(@AU3_WinGetPosHeight <> nil);
{$ENDIF}
      @AU3_WinGetPosWidth := GetProcAddress(DLLHandle, 'AU3_WinGetPosWidth');
{$IFDEF WIN32}
      Assert(@AU3_WinGetPosWidth <> nil);
{$ENDIF}
      @AU3_WinGetProcess := GetProcAddress(DLLHandle, 'AU3_WinGetProcess');
{$IFDEF WIN32}
      Assert(@AU3_WinGetProcess <> nil);
{$ENDIF}
      @AU3_WinGetState := GetProcAddress(DLLHandle, 'AU3_WinGetState');
{$IFDEF WIN32}
      Assert(@AU3_WinGetState <> nil);
{$ENDIF}
      @AU3_WinGetText := GetProcAddress(DLLHandle, 'AU3_WinGetText');
{$IFDEF WIN32}
      Assert(@AU3_WinGetText <> nil);
{$ENDIF}
      @AU3_WinGetTitle := GetProcAddress(DLLHandle, 'AU3_WinGetTitle');
{$IFDEF WIN32}
      Assert(@AU3_WinGetTitle <> nil);
{$ENDIF}
      @AU3_WinKill := GetProcAddress(DLLHandle, 'AU3_WinKill');
{$IFDEF WIN32}
      Assert(@AU3_WinKill <> nil);
{$ENDIF}
      @AU3_WinMenuSelectItem := GetProcAddress(DLLHandle, 'AU3_WinMenuSelectItem');
{$IFDEF WIN32}
      Assert(@AU3_WinMenuSelectItem <> nil);
{$ENDIF}
      @AU3_WinMinimizeAll := GetProcAddress(DLLHandle, 'AU3_WinMinimizeAll');
{$IFDEF WIN32}
      Assert(@AU3_WinMinimizeAll <> nil);
{$ENDIF}
      @AU3_WinMinimizeAllUndo := GetProcAddress(DLLHandle, 'AU3_WinMinimizeAllUndo');
{$IFDEF WIN32}
      Assert(@AU3_WinMinimizeAllUndo <> nil);
{$ENDIF}
      @AU3_WinMove := GetProcAddress(DLLHandle, 'AU3_WinMove');
{$IFDEF WIN32}
      Assert(@AU3_WinMove <> nil);
{$ENDIF}
      @AU3_WinSetOnTop := GetProcAddress(DLLHandle, 'AU3_WinSetOnTop');
{$IFDEF WIN32}
      Assert(@AU3_WinSetOnTop <> nil);
{$ENDIF}
      @AU3_WinSetState := GetProcAddress(DLLHandle, 'AU3_WinSetState');
{$IFDEF WIN32}
      Assert(@AU3_WinSetState <> nil);
{$ENDIF}
      @AU3_WinSetTitle := GetProcAddress(DLLHandle, 'AU3_WinSetTitle');
{$IFDEF WIN32}
      Assert(@AU3_WinSetTitle <> nil);
{$ENDIF}
      @AU3_WinSetTrans := GetProcAddress(DLLHandle, 'AU3_WinSetTrans');
{$IFDEF WIN32}
      Assert(@AU3_WinSetTrans <> nil);
{$ENDIF}
      @AU3_WinWait := GetProcAddress(DLLHandle, 'AU3_WinWait');
{$IFDEF WIN32}
      Assert(@AU3_WinWait <> nil);
{$ENDIF}
      @AU3_WinWaitActive := GetProcAddress(DLLHandle, 'AU3_WinWaitActive');
{$IFDEF WIN32}
      Assert(@AU3_WinWaitActive <> nil);
{$ENDIF}
      @AU3_WinWaitClose := GetProcAddress(DLLHandle, 'AU3_WinWaitClose');
{$IFDEF WIN32}
      Assert(@AU3_WinWaitClose <> nil);
{$ENDIF}
      @AU3_WinWaitNotActive := GetProcAddress(DLLHandle, 'AU3_WinWaitNotActive');
{$IFDEF WIN32}
      Assert(@AU3_WinWaitNotActive <> nil);
{$ENDIF}
   end
   else
   begin
      AutoItXDLLLoaded := False;
    { Error: AUTOITX3.DLL could not be loaded !! }
   end;
{$IFNDEF MSDOS}
   SetErrorMode(ErrorMode)
{$ENDIF}
end {LoadDLL};

begin
   LoadDLL;
end.

