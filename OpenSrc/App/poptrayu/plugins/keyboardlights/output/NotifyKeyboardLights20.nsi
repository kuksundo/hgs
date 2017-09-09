; Keyboard Lights Install Script

NAME "Keyboard Lights 2.0"
!define PRODUCT_NAME "Keyboard Lights"
!define PRODUCT_VERSION "2.0"
!define PRODUCT_PUBLISHER "Jessica Brown"
!define PRODUCT_WEB_SITE "http://poptrayu.sourceforge.net/"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME} ${PRODUCT_VERSION}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; Use Modern UI 2 wizard
!include "MUI2.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "..\lights.ico"
!define MUI_UNICON "..\lights.ico"

;-----------------------------------------------------------------
; MUI2 Installer pages
;-----------------------------------------------------------------

; Welcome page
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of Keyboard Lights 2.0, a notification plugin for PopTrayU.$\r$\n$\r$\nPopTrayU will be automatically closed if running."
!insertmacro MUI_PAGE_WELCOME

; Readme page
!define MUI_PAGE_HEADER_TEXT "Review Readme File"
!define MUI_PAGE_HEADER_SUBTEXT  "General information about this software"
!define MUI_LICENSEPAGE_TEXT_TOP "Please review:"
!define MUI_LICENSEPAGE_TEXT_BOTTOM "This is FREE software. It is released under the GPLv2 (or later) license."
!define MUI_LICENSEPAGE_BUTTON "Next >"
!insertmacro MUI_PAGE_LICENSE "NotifyKeyboardLights.txt"

; Install Directory page
!define MUI_PAGE_HEADER_TEXT "Locate Your PopTrayU Installation Directory"
!define MUI_TEXT_DIRECTORY_SUBTITLE "Where is PopTrayU Installed?"
!define MUI_DIRECTORYPAGE_TEXT_TOP "Keyboard Lights 2.0 will be installed into the Plugins subdirectory of your PopTrayU installation directory."
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "PopTrayU Installation Directory"
!insertmacro MUI_PAGE_DIRECTORY

; Install files page
!insertmacro MUI_PAGE_INSTFILES

; Finish page
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_FINISHPAGE_RUN "$INSTDIR\PopTrayU.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Start PopTrayU"
!insertmacro MUI_PAGE_FINISH

;-----------------------------------------------------------------
; MUI2 Uninstaller pages
;-----------------------------------------------------------------

; uninstaller welcome page
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the uninstall of Keyboard Lights 2.0$\r$\n$\r$\nPopTrayU will be shut down automatically if necessary."
!insertmacro MUI_UNPAGE_WELCOME

; uninstaller confirmation page
!insertmacro MUI_UNPAGE_CONFIRM

; uninstaller progress page
!insertmacro MUI_UNPAGE_INSTFILES
;-----------------------------------------------------------------

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------



OutFile "KeyboardLights20Setup.exe"
InstallDir "$PROGRAMFILES\PopTrayU"
ShowInstDetails show
ShowUnInstDetails show

Section "Keyboard Lights 2.0" SEC01


  !define HWND $R0
  !define Count $R1
  TryPoptrayU:
    ; count+=1
    IntOp ${Count} ${Count} + 1
    ; if count >= 5 goto cantclose
    IntCmp  ${Count} 5 CantClose
    ClearErrors
  ;ClosePopTrayU:
    ; close running PopTrayU
    FindWindow ${HWND} "TfrmPopUMain.UnicodeClass"
    StrCmp ${HWND} 0 NotRunning
    ; skip printing shutting down... if count > 1
    IntCmp ${Count} 1 Print SendCloseMsg SendCloseMsg
  Print:
    DetailPrint "Shutting down PopTrayU"
  SendCloseMsg:
    SendMessage ${HWND} 1036 0 0 ; UM_QUIT = 1036
    Sleep 1000
    Goto TryPopTrayU
  CantClose:
    DetailPrint "Can't close PopTrayU"
  NotRunning:

  ; Copy the actual files for this install
  SetOutPath "$INSTDIR\Plugins"
  SetOverwrite on
  File "NotifyKeyboardLights.dll"
  File "NotifyKeyboardLights.txt"
  
SectionEnd

Section -AdditionalIcons
  IfFileExists $SMPROGRAMS\PopTrayU\*.* SMDirExists
  CreateDirectory "$SMPROGRAMS\PopTrayU"
  SMDirExists:
  CreateShortCut "$SMPROGRAMS\PopTrayU\Keyboard Lights 2.0 Readme.lnk" "$INSTDIR\Plugins\NotifyKeyboardLights.txt"
  CreateShortCut "$SMPROGRAMS\PopTrayU\Uninstall Keyboard Lights 2.0.lnk" "$INSTDIR\Plugins\UninstallKeyboardLights20.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\Plugins\UninstallKeyboardLights20.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\Plugins\UninstallKeyboardLights20.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  DetailPrint "Added uninstaller information to the Registry"
SectionEnd

Function .onInit
  ; Change the installation directory to match the PopTrayU's install location if possible
  ReadRegStr $INSTDIR HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PopTrayU" "InstallLocation"
FunctionEnd

Function .onVerifyInstDir
  IfFileExists $INSTDIR\PopTrayU.exe PathGood
    Abort ; in this fxn abort tells installer path is invalid
  PathGood:
FunctionEnd



  Var IniPathDword
  Var IniPathString
  
Section Uninstall


;; Close PopTrayU if it is running.
;  !define HWND $R0
;  !define Count $R1
  TryPoptrayU:
    ; count+=1
    IntOp ${Count} ${Count} + 1
    ; if count >= 5 goto cantclose
    IntCmp  ${Count} 5 CantClose
    ClearErrors
  ;ClosePopTrayU:
    ; close running PopTrayU
    FindWindow ${HWND} "TfrmPopUMain.UnicodeClass"
    StrCmp ${HWND} 0 NotRunning
    ; skip printing shutting down... if count > 1
    IntCmp ${Count} 1 Print SendCloseMsg SendCloseMsg
  Print:
    DetailPrint "Shutting down PopTrayU"
  SendCloseMsg:
    SendMessage ${HWND} 1036 0 0 ; UM_QUIT = 1036
    Sleep 1000
    Goto TryPopTrayU
  CantClose:
    DetailPrint "Can't close PopTrayU"
  NotRunning:


  # Remove start menu shortcut to uninstaller
  Delete /REBOOTOK  "$SMPROGRAMS\PopTrayU\Uninstall Keyboard Lights 2.0.lnk"
  # Try to remove the Start Menu folder - this will only happen if it is empty
  ;;rmDir "$SMPROGRAMS\PopTrayU"

  # remove program files
  Delete /REBOOTOK "$INSTDIR\NotifyKeyboardLights.txt"
  Delete /REBOOTOK "$INSTDIR\NotifyKeyboardLights.dll"

  # remove poptray.ini section

    ; Check if Registry key exists for IniPath
    ReadRegDWORD $IniPathDword HKLM "Software\PopTrayU" "IniPath"

    IntCmp $IniPathDword 0x0000001A localappdata
    IntCmp $IniPathDword 0x00000023 alluserappdata
    IntCmp $IniPathDword 0x00000026 progfiles

    ; if not found, presume program files
    Goto progfiles

  localappdata:
    SetShellVarContext current
    StrCpy $IniPathString "$APPDATA\PopTrayU\PopTray.ini"
    Goto donechecking
  alluserappdata:
    SetShellVarContext all
    StrCpy $IniPathString  "$APPDATA\PopTrayU\PopTray.ini"
    Goto donechecking
  progfiles:
    StrCpy $IniPathString "$INSTDIR\..\PopTray.ini"
    Goto donechecking
  donechecking:
    ; remove KeyboardLights section from PopTray.ini
    DeleteINISec $IniPathString "KeyboardLights"

  # remove uninstaller
  Delete /REBOOTOK "$INSTDIR\UninstallKeyboardLights20.exe"
  
  # Try to remove the install directory - this will only happen if it is empty
  ;;rmDir $INSTDIR

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose false
SectionEnd