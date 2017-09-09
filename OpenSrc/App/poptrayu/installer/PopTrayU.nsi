;------------------------------------------------------------
; PopTrayU NSIS install script (NSIS 2.46 Modern UI 2.0)
;------------------------------------------------------------

!define VER_MAJOR "5"
!define VER_MINOR "2"
!define VER_BETA "6"

!define PRODUCT "PopTrayU"
;!define VERSION "${VER_MAJOR}.${VER_MINOR}
!define VERSION "${VER_MAJOR}.${VER_MINOR}.${VER_BETA}"
Name "${PRODUCT} ${VERSION}"
;; Beta Release"

!include "MUI2.nsh"
!include "InstallOptions.nsh"
!include WinVer.nsh

!define Language $1
!define Sounds $2
!define StartMenuIcons $3
!define StartupIcon $4
!define DesktopIcon $5


!define TEMP $R9

;------------------------------------------------------------------[ Configuration1 ]---

;OutFile "Deploy\PopTrayU${VER_MAJOR}${VER_MINOR}.exe"
OutFile "Deploy\PopTrayU ${VER_MAJOR}.${VER_MINOR}.${VER_BETA} Installer.exe"
SetCompressor /SOLID lzma

;------------------------------------------------------------------[ Modern UI Configuration ]---

  ; UI settings
  !define MUI_ICON "images\Setup.ico"
  !define MUI_UNICON "images\Uninstall.ico"
  
  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
  !define MUI_HEADERIMAGE_BITMAP "images\setup_header.bmp"
  !define MUI_WELCOMEFINISHPAGE_BITMAP "images\setup.bmp"

  !define MUI_COMPONENTSPAGE_SMALLDESC
  !define MUI_ABORTWARNING

  !define MUI_CUSTOMFUNCTION_DIRECTORY_PRE DirectoryPre
  !define MUI_CUSTOMFUNCTION_DIRECTORY_SHOW DirectoryShow
  !define MUI_CUSTOMFUNCTION_DIRECTORY_LEAVE DirectoryLeave

  ;!define MUI_UNCUSTOMPAGECOMMANDS

  ; Text
  !define MUI_WELCOMEPAGE_TITLE $(mui_welcomepage_title)
  !define MUI_WELCOMEPAGE_TEXT "$(mui_welcomepage_text1)$\r$\n$\r$\n$(mui_welcomepage_text2)$\r$\n$\r$\n"
  !define MUI_FINISHPAGE_SHOWREADME_TEXT $(mui_finish_dl_ssl_plugin)
    



  ; Pages
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  Page custom fnc_IniDialog_Show fnc_IniDialog_Leave   ;Custom page - Select User Data Folder
  !insertmacro MUI_PAGE_INSTFILES
    
    !define MUI_FINISHPAGE_NOREBOOTSUPPORT
    !define MUI_FINISHPAGE_RUN $INSTDIR\PopTrayU.exe
    !define MUI_FINISHPAGE_SHOWREADME "http://sourceforge.net/projects/poptrayupop3ssl/"
    !define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
  !insertmacro MUI_PAGE_FINISH

; hide Nullsoft installer version info
BrandingText " "

;------------------------------------------------------------------[ Pages ]---

  !define MUI_CUSTOMFUNCTION_UNGUIINIT un.myGuiInit
  UninstPage custom un.SetPage
  !insertmacro MUI_UNPAGE_INSTFILES

  
;------------------------------------------------------------------[ Languages ]---
;; do not hide languages that are outside current codepage
;;!define MUI_LANGDLL_ALLLANGUAGES

  !insertmacro MUI_LANGUAGE "English" ;first language is the default
  !insertmacro MUI_LANGUAGE "Afrikaans"
  !insertmacro MUI_LANGUAGE "Arabic"
  !insertmacro MUI_LANGUAGE "Bulgarian"
  !insertmacro MUI_LANGUAGE "Catalan"
  !insertmacro MUI_LANGUAGE "SimpChinese"
;  !insertmacro MUI_LANGUAGE "TradChinese"
  !insertmacro MUI_LANGUAGE "Croatian"
  !insertmacro MUI_LANGUAGE "Czech"
  !insertmacro MUI_LANGUAGE "Danish"
  !insertmacro MUI_LANGUAGE "Dutch"
  !insertmacro MUI_LANGUAGE "Estonian"
  !insertmacro MUI_LANGUAGE "Finnish"
  !insertmacro MUI_LANGUAGE "French"
  !insertmacro MUI_LANGUAGE "Galician"
  !insertmacro MUI_LANGUAGE "German"
  !insertmacro MUI_LANGUAGE "Greek"
  !insertmacro MUI_LANGUAGE "Hebrew"
  !insertmacro MUI_LANGUAGE "Hungarian"
  !insertmacro MUI_LANGUAGE "Italian"
  !insertmacro MUI_LANGUAGE "Korean"
  !insertmacro MUI_LANGUAGE "Lithuanian"
  !insertmacro MUI_LANGUAGE "Norwegian"
;  !insertmacro MUI_LANGUAGE "NorwegianNynorsk"
  !insertmacro MUI_LANGUAGE "Polish"
  !insertmacro MUI_LANGUAGE "Portuguese"
;  !insertmacro MUI_LANGUAGE "PortugueseBR"
  !insertmacro MUI_LANGUAGE "Romanian"
  !insertmacro MUI_LANGUAGE "Russian"
;  !insertmacro MUI_LANGUAGE "Serbian"
  !insertmacro MUI_LANGUAGE "SerbianLatin"
  !insertmacro MUI_LANGUAGE "Slovak"
  !insertmacro MUI_LANGUAGE "Slovenian"
  !insertmacro MUI_LANGUAGE "Spanish"
;  !insertmacro MUI_LANGUAGE "SpanishInternational"
  !insertmacro MUI_LANGUAGE "Swedish"
  !insertmacro MUI_LANGUAGE "Turkish"
  !insertmacro MUI_LANGUAGE "Ukrainian"



  !define MUI_TEXT_FINISH_SHOWREADME "Show HISTORY.TXT"
  
  
;------------------------------------------------------------------[ Language Strings ]---
; Languages need to be defined AFTER THE PAGES!
!include LangStrings.nsh
!include LangStringsU.nsh

;------------------------------------------------------------------[ Configuration2 ]---

InstType $(full_install) ;"Full"
InstType $(minimum_install) ;"Minimum"

ShowInstDetails show
ShowUninstDetails show

;------------------------------------------------------------------[ Reserve Files ]---
  
  ReserveFile "${MUI_HEADERIMAGE_BITMAP}"
  ReserveFile "${MUI_WELCOMEFINISHPAGE_BITMAP}"
  ReserveFile "uninstaller.ini"
  ReserveFile '${NSISDIR}\Plugins\InstallOptions.dll'

;------------------------------------------------------------------[ Installer Sections ]---

Section $(SEC_PopTrayU) SecPopTrayU
  SectionIn 1 2

  SetOutPath "$INSTDIR"

  !define HWND $R0
  !define Count $R1

  ; try copying EXE.  If it fails try killing the running PopTrayU upto 5 times
  SetOverwrite try
  TryPoptrayU:
 	IntOp ${Count} ${Count} + 1
        ;DetailPrint ${Count}
  	IntCmp ${Count} 5 CantClose
  	ClearErrors
  	File "PopTrayU.exe"
  	IfErrors ClosePopTrayU OtherFiles
  ClosePopTrayU:
  	; find and close running PopTrayU
  	FindWindow ${HWND} "TfrmPopUMain"
  	IntCmp ${Count} 1 PrintClosing
  FindOldPTU:
  	FindWindow ${HWND} "TfrmPopUMain.UnicodeClass"
  	IntCmp ${Count} 1 PrintClosing TryClosePTU TryClosePTU
  PrintClosing:
  	DetailPrint $(msg_closing_poptrayu)
  TryClosePTU:
  	SendMessage ${HWND} 1036 0 0 ; UM_QUIT = 1036
  	;SendMessage ${HWND} ${WM_CLOSE} 0 0
  SleepAndRetry:
  	Sleep 1000
  	Goto TryPopTrayU
  CantClose:
  	DetailPrint $(msg_cant_close_poptrayu)
  	SetOverwrite on
  	File "PopTrayU.exe"
  
  ; rest of the files
  OtherFiles:
  	SetOverwrite on
  	File "PopTrayU.chm"
  	File "Readme.txt"
  	File "History.txt"
  	File "License.txt"
  	${If} ${IsWinXP}
             File "TDEmu.dll"
        ${EndIf}
  	;File "lightskin.bmp"
 	;File "darkskin.bmp"
 	
  ; delete old version of bundled IMAP plugin if present.
  Delete "plugins\ProtocolIMAP4.dll"
 	
  ;MessageBox MB_OK "Debug Wait"

  WriteRegStr HKLM "Software\${PRODUCT}" "" $INSTDIR
  WriteRegStr HKLM "Software\${PRODUCT}" "Language" 0
  WriteRegStr HKLM "Software\${PRODUCT}" "Sounds" 0
  WriteRegStr HKLM "Software\${PRODUCT}" "StartMenuIcons" 0
  WriteRegStr HKLM "Software\${PRODUCT}" "StartupIcon" 0
  WriteRegStr HKLM "Software\${PRODUCT}" "DesktopIcon" 0

  call writeIniDialogRegistrySetting
  
  ; uninstall data
  WriteRegExpandStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegExpandStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "DisplayName" "${PRODUCT} ${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "DisplayIcon" "$INSTDIR\PopTrayU.exe,0"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "DisplayVersion" "${VERSION}"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "VersionMajor" "${VER_MAJOR}"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "VersionMinor" "${VER_MINOR}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "Publisher" "Jessica Brown"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "URLInfoAbout" "http://www.poptray.org"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "NoModify" "1"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "NoRepair" "1"

  ; delete inno setup files
  Delete "$INSTDIR\unins000.dat"
  Delete "$INSTDIR\unins000.exe"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PopTrayU_is1"
  
  ; uninstaller
  Delete "$INSTDIR\Uninstall.exe"
  WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

SubSection $(SEC_Icons) SecIcons

Section $(SEC_StartMenuIcons) SecStartMenu
  SectionIn 1 2
  WriteRegStr HKLM "Software\${PRODUCT}" "StartMenuIcons" 1
  CreateDirectory $SMPROGRAMS\PopTrayU
  CreateShortCut "$SMPROGRAMS\PopTrayU\PopTrayU.lnk" "$INSTDIR\PopTrayU.exe" ""
  CreateShortCut "$SMPROGRAMS\PopTrayU\Uninstall.lnk" "$INSTDIR\Uninstall.exe" ""
  CreateShortCut "$SMPROGRAMS\PopTrayU\PopTrayU Help.lnk" "$INSTDIR\PopTrayU.chm" ""
  CreateShortCut "$SMPROGRAMS\PopTrayU\Read Me.lnk" "$INSTDIR\ReadMe.txt" ""
  CreateShortCut "$SMPROGRAMS\PopTrayU\Version History.lnk" "$INSTDIR\History.txt" ""
SectionEnd

Section $(SEC_StartupIcon) SecStartup
  SectionIn 1
  WriteRegStr HKLM "Software\${PRODUCT}" "StartupIcon" 1
  CreateShortCut "$SMSTARTUP\PopTrayU.lnk" "$INSTDIR\PopTrayU.exe" ""
SectionEnd

Section $(SEC_DesktopIcon) SecDesktop
  SectionIn 1
  WriteRegStr HKLM "Software\${PRODUCT}" "DesktopIcon" 1
  CreateShortCut "$DESKTOP\PopTrayU.lnk" "$INSTDIR\PopTrayU.exe" ""
SectionEnd

SubSectionEnd

Section $(SEC_Lang) SecLang
  SectionIn 1
  WriteRegStr HKLM "Software\${PRODUCT}" "Language" 1
  
  SetOutPath "$INSTDIR\Languages"
  
  ; copy new
  ;;File "languages\blank.ptlang"
  File "languages\language.ptlang"
  File "languages\Afrikaans.ptlang"
  File "languages\Arabic.ptlang"
  File "languages\Bulgarian.ptlang"
  File "languages\Catalan.ptlang"
  File "languages\Chinese.ptlang"
  File "languages\Croatian.ptlang"
  File "languages\Czech.ptlang"
  File "languages\Danish.ptlang"
  File "languages\Dutch.ptlang"
  File "languages\Estonian.ptlang"
  File "languages\Finnish.ptlang"
  File "languages\French.ptlang"
  File "languages\French (Canada).ptlang"
  File "languages\Frisian.ptlang"
  File "languages\Galician.ptlang"
  File "languages\German.ptlang"
  File "languages\Greek.ptlang"
  File "languages\Hebrew.ptlang"
  File "languages\Hungarian.ptlang"
  File "languages\Italian.ptlang"
  File "languages\Lithuanian.ptlang"
  File "languages\Korean.ptlang"
  File "languages\Norwegian.ptlang"
  File "languages\Polish.ptlang"
  File "languages\Portuguese.ptlang"
  File "languages\Portuguese (Brazil).ptlang"
  File "languages\Romanian.ptlang"
  File "languages\Russian.ptlang"
  File "languages\Serbian.ptlang"
  File "languages\Slovak.ptlang"
  File "languages\Slovene.ptlang"
  File "languages\Spanish.ptlang"
  File "languages\Spanish (Chile).ptlang"
  File "languages\Spanish (Hispanic America).ptlang"
  File "languages\Swedish.ptlang"
  File "languages\Taiwan.ptlang"
  File "languages\Turkish.ptlang"
  File "languages\Ukranian.ptlang"
  File "languages\Valencian.ptlang"
SectionEnd

Section $(SEC_SoundFiles) SecSound
  SectionIn 1
  WriteRegStr HKLM "Software\${PRODUCT}" "Sounds" 1
  
  SetOutPath "$INSTDIR\Sounds"
  
  File "sounds\poptray_newmail_lo.wav"
  File "sounds\poptray_urgent_lo.wav"
  File "sounds\poptray_friend_lo.wav"
  File "sounds\poptray_business_lo.wav"
  File "sounds\poptray_junkmail_lo.wav"
  File "sounds\poptray_spam_lo.wav"
SectionEnd

;;SubSection $(SEC_OptionalPlugins) SecPlugins

;;Section $(SEC_KeyboardLights) SecKeyboardLights
  ;;SectionIn 1
  ;;WriteRegStr HKLM "Software\${PRODUCT}" "keyboardlights" 1

  ;;SetOutPath "$INSTDIR\plugins"

  ;;File "plugins\NotifyKeyboardLights.dll"
  ;;File "plugins\NotifyKeyboardLights.txt"
;;SectionEnd

;;SubSectionEnd

;!insertmacro MUI_SECTIONS_FINISHHEADER

;------------------------------------------------------------------[ Descriptions ]---

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPopTrayU} $(DESC_SecPopTrayU)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecLang} $(DESC_SecLang)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecSound} $(DESC_SecSound)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecIcons} $(DESC_SecIcons)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecStartMenu} $(DESC_SecStartMenu)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecStartup} $(DESC_SecStartup)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktop} $(DESC_SecDesktop)
  ;;!insertmacro MUI_DESCRIPTION_TEXT ${SecKeyboardLights} $(DESC_SecKeyboardLights)
!insertmacro MUI_FUNCTION_DESCRIPTION_END
 
;------------------------------------------------------------------[ Uninstaller Section ]---

Section "Uninstall"
  ; application files
  Delete "$INSTDIR\PopTrayU.exe"
  Delete "$INSTDIR\Uninstall.exe"
  Delete "$INSTDIR\PopTrayU.chm"
  Delete "$INSTDIR\Readme.txt"
  Delete "$INSTDIR\History.txt"
  Delete "$INSTDIR\Beta.txt"
  Delete "$INSTDIR\TDEmu.dll"
  
  ; start menu icons
  Delete "$SMPROGRAMS\PopTrayU\PopTrayU.lnk"
  Delete "$SMPROGRAMS\PopTrayU\Uninstall.lnk"
  Delete "$SMPROGRAMS\PopTrayU\PopTrayU Help.lnk"
  Delete "$SMPROGRAMS\PopTrayU\PopTrayU Help.lnk"
  Delete "$SMPROGRAMS\PopTrayU\Read Me.lnk"
  Delete "$SMPROGRAMS\PopTrayU\Version History.lnk"
  Delete "$SMPROGRAMS\PopTrayU\Read Me (beta info).lnk"
  
  ; other icons
  Delete "$SMSTARTUP\PopTrayU.lnk"
  Delete "$DESKTOP\PopTrayU.lnk"
  
  ; sounds
  Delete "$INSTDIR\Sounds\poptray_newmail_lo.wav"
  Delete "$INSTDIR\Sounds\poptray_urgent_lo.wav"
  Delete "$INSTDIR\Sounds\poptray_family_lo.wav"
  Delete "$INSTDIR\Sounds\poptray_friend_lo.wav"
  Delete "$INSTDIR\Sounds\poptray_business_lo.wav"
  Delete "$INSTDIR\Sounds\poptray_junkmail_lo.wav"
  Delete "$INSTDIR\Sounds\poptray_spam_lo.wav"

  ; language
  Delete "$INSTDIR\Languages\blank.ptlang"
  Delete "$INSTDIR\Languages\language.ptlang"
  Delete "$INSTDIR\Languages\Afrikaans.ptlang"
  Delete "$INSTDIR\Languages\Arabic.ptlang"
  Delete "$INSTDIR\Languages\Bulgarian.ptlang"
  Delete "$INSTDIR\Languages\Catalan.ptlang"
  Delete "$INSTDIR\Languages\Chinese.ptlang"
  Delete "$INSTDIR\Languages\Croatian.ptlang"
  Delete "$INSTDIR\Languages\Czech.ptlang"
  Delete "$INSTDIR\Languages\Danish.ptlang"
  Delete "$INSTDIR\Languages\Dutch.ptlang"
  Delete "$INSTDIR\Languages\Estonian.ptlang"
  Delete "$INSTDIR\Languages\Finnish.ptlang"
  Delete "$INSTDIR\Languages\French.ptlang"
  Delete "$INSTDIR\Languages\French (Canada).ptlang"
  Delete "$INSTDIR\Languages\Frisian.ptlang"
  Delete "$INSTDIR\Languages\Galician.ptlang"
  Delete "$INSTDIR\Languages\German.ptlang"
  Delete "$INSTDIR\Languages\Greek.ptlang"
  Delete "$INSTDIR\Languages\Hebrew.ptlang"
  Delete "$INSTDIR\Languages\Hungarian.ptlang"
  Delete "$INSTDIR\Languages\Italian.ptlang"
  Delete "$INSTDIR\Languages\Lithuanian.ptlang"
  Delete "$INSTDIR\Languages\Korean.ptlang"
  Delete "$INSTDIR\Languages\Norwegian.ptlang"
  Delete "$INSTDIR\Languages\Polish.ptlang"
  Delete "$INSTDIR\Languages\Portuguese.ptlang"
  Delete "$INSTDIR\Languages\Portuguese (Brazil).ptlang"
  Delete "$INSTDIR\Languages\Romanian.ptlang"
  Delete "$INSTDIR\Languages\Russian.ptlang"
  Delete "$INSTDIR\Languages\Serbian.ptlang"
  Delete "$INSTDIR\Languages\Slovak.ptlang"
  Delete "$INSTDIR\Languages\Slovene.ptlang"
  Delete "$INSTDIR\Languages\Spanish.ptlang"
  Delete "$INSTDIR\Languages\Spanish (Hispanic America).ptlang"
  Delete "$INSTDIR\Languages\Spanish (Chile).ptlang"
  Delete "$INSTDIR\Languages\Swedish.ptlang"
  Delete "$INSTDIR\Languages\Taiwan.ptlang"
  Delete "$INSTDIR\Languages\Turkish.ptlang"
  Delete "$INSTDIR\Languages\Ukranian.ptlang"
  Delete "$INSTDIR\Languages\Valencian.ptlang"
  
  Delete "plugins\NotifyKeyboardLights.dll"
  Delete "plugins\NotifyKeyboardLights.txt"
  Delete "plugins\ProtocolIMAP4.dll" ;uninstall OLD imap plugin if needed
    
  ; configuration files
  !insertmacro INSTALLOPTIONS_READ ${TEMP} "uninstaller.ini" "Field 4" "State"
  StrCmp ${TEMP} "1" "" NoConfig
    Delete "$INSTDIR\PopTray.ini"
    Delete "$INSTDIR\Rules.ini"
    Delete "$INSTDIR\PopTray.customize"
    Delete "$INSTDIR\Preview.customize"
    Delete "$INSTDIR\WhiteList.ptdat"
    Delete "$INSTDIR\BlackList.ptdat"
    Delete "$INSTDIR\Rules.log"
    Delete "$INSTDIR\Account_*.ids"
    Delete "$INSTDIR\lightskin.bmp"
    Delete "$INSTDIR\darkskin.bmp"

    SetShellVarContext current
    Delete "$APPDATA\PopTrayU\PopTray.ini"
    Delete "$APPDATA\PopTrayU\Rules.ini"
    Delete "$APPDATA\PopTrayU\PopTray.customize"
    Delete "$APPDATA\PopTrayU\Preview.customize"
    Delete "$APPDATA\PopTrayU\WhiteList.ptdat"
    Delete "$APPDATA\PopTrayU\BlackList.ptdat"
    Delete "$APPDATA\PopTrayU\Rules.log"
    Delete "$APPDATA\PopTrayU\Account_*.ids"

    SetShellVarContext all
    Delete "$APPDATA\PopTrayU\PopTray.ini"
    Delete "$APPDATA\PopTrayU\Rules.ini"
    Delete "$APPDATA\PopTrayU\PopTray.customize"
    Delete "$APPDATA\PopTrayU\Preview.customize"
    Delete "$APPDATA\PopTrayU\WhiteList.ptdat"
    Delete "$APPDATA\PopTrayU\BlackList.ptdat"
    Delete "$APPDATA\PopTrayU\Rules.log"
    Delete "$APPDATA\PopTrayU\Account_*.ids"

	RMDir "$APPDATA\PopTrayU"

  NoConfig:

  ; directories
  RMDir "$INSTDIR\Languages"
  RMDir "$INSTDIR\Sounds"
  RMDir "$INSTDIR"
  RMDir "$SMPROGRAMS\PopTrayU"

  ; registry
  DeleteRegKey HKCU "Software\${PRODUCT}"
  DeleteRegKey HKLM "Software\${PRODUCT}"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}"
  
SectionEnd


;------------------------------------------------------------------[ Functions ]---


Function un.myGuiInit

  !insertmacro INSTALLOPTIONS_WRITE "uninstaller.ini" "Field 1" "Text" $(uninstaller_desc)
  !insertmacro INSTALLOPTIONS_WRITE "uninstaller.ini" "Field 2" "Text" $(uninstall_from)
  !insertmacro INSTALLOPTIONS_WRITE "uninstaller.ini" "Field 4" "Text" $(uninstall_remove_config_files)

FunctionEnd

Function un.SetPage
  !insertmacro MUI_HEADER_TEXT $(mui_header_uninstall) $(mui_subhead_uninstall)
  !insertmacro INSTALLOPTIONS_DISPLAY "uninstaller.ini"
FunctionEnd

Function un.onInit
  !insertmacro MUI_UNGETLANGUAGE

  !insertmacro INSTALLOPTIONS_EXTRACT "uninstaller.ini"
  !insertmacro INSTALLOPTIONS_WRITE "uninstaller.ini" "Field 3" "State" "$INSTDIR"

FunctionEnd

;------------------------------------------------------------------[ Events ]---

Function .onInit

  !include LangSelectDlg.nsh
		

  ; get install dir
  ReadRegStr ${TEMP} HKLM "Software\${PRODUCT}" ""
  StrCmp ${TEMP} "" +2
    Goto DirFound
    
  ReadRegStr ${TEMP} HKCU "Software\${PRODUCT}" ""
  StrCmp ${TEMP} "" +2
    Goto DirFound
  
  ReadRegStr ${TEMP} HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PopTrayU_is1" "Inno Setup: App Path"
  StrCmp ${TEMP} "" +2
    Goto DirFound
  
  ;Else:
    StrCpy ${TEMP} "$PROGRAMFILES\${PRODUCT}"
  DirFound:
    StrCpy $INSTDIR ${TEMP}

  ; read selections from registry
  ReadRegStr ${StartMenuIcons} HKLM "Software\${PRODUCT}" "StartMenuIcons"
  ReadRegStr ${StartupIcon} HKLM "Software\${PRODUCT}" "StartupIcon"
  ReadRegStr ${DesktopIcon} HKLM "Software\${PRODUCT}" "DesktopIcon"
  ReadRegStr ${Language} HKLM "Software\${PRODUCT}" "Language"
  ReadRegStr ${Sounds} HKLM "Software\${PRODUCT}" "Sounds" 

  ; set icons from registry values
  StrCmp ${StartMenuIcons} "0" "" +2
    SectionSetFlags ${SecStartMenu} 0
  StrCmp ${StartupIcon} "0" "" +2
    SectionSetFlags ${SecStartup} 0
  StrCmp ${DesktopIcon} "0" "" +2
    SectionSetFlags ${SecDesktop} 0
  StrCmp ${Language} "0" "" +2
    SectionSetFlags ${SecLang} 0
  StrCmp ${Sounds} "0" "" +2
    SectionSetFlags ${SecSound} 0
FunctionEnd




;--------------------------------------- [ Custom Registry Settings Dialog ] ---


; Registry values for the storage locations
!define INILOC_APPDATA 0x0000001A
!define INILOC_ALLUSER 0x00000023
!define INILOC_APP_DIR 0x00000026

; handle variables
Var IniDialog_HWND
Var RadioLocalAppdata_HWND
Var RadioLocalAppdata_State
Var IniDialog_HWND_Label3
Var RadioAllUserAppdata_HWND
Var RadioAllUserAppdata_State
Var IniDialog_HWND_Label2
Var RadioProgramFiles_HWND
Var RadioProgramFiles_State
Var IniDialog_HWND_Label4
Var IniDialog_HWND_Font1
;Var iniStorageLocation

; dialog create function
Function fnc_IniDialog_Create
  
  ; custom font definitions
  CreateFont $IniDialog_HWND_Font1 "Microsoft Sans Serif" "8.25" "700"
  
  ; === IniDialog (type: Dialog) ===
  nsDialogs::Create 1018
  Pop $IniDialog_HWND
  ${If} $IniDialog_HWND == error
    Abort
  ${EndIf}

	GetFunctionAddress $0 fnc_IniDialog_Leave
	nsDialogs::OnBack $0


  !insertmacro MUI_HEADER_TEXT $(title_user_storage_dir) $(desc_user_storage_dir)
  ;"User Settings Storage Location" "Where should PopTrayU store settings like email accounts and rules?"
  
  ; === RadioLocalAppdata (type: RadioButton) ===
  ${NSD_CreateRadioButton} 8u 7u 257u 14u $(ini_storage_appdata)
  Pop $RadioLocalAppdata_HWND
  ${NSD_SetState} RadioLocalAppdata_HWND ${BST_CHECKED} 
  SendMessage $RadioLocalAppdata_HWND ${WM_SETFONT} $IniDialog_HWND_Font1 0
  
  ; === Label3 (type: Label) ===
  ${NSD_CreateLabel} 8u 22u 271u 16u $(ini_storage_appdata_desc)
  Pop $IniDialog_HWND_Label3
  
  ; === RadioAllUserAppdata (type: RadioButton) ===
  ${NSD_CreateRadioButton} 8u 47u 257u 14u $(ini_alluser_appdata)
  Pop $RadioAllUserAppdata_HWND
  
  ; === Label2 (type: Label) ===
  ${NSD_CreateLabel} 8u 62u 271u 24u $(ini_alluser_appdata_desc)
  Pop $IniDialog_HWND_Label2
  
  ; === RadioProgramFiles (type: RadioButton) ===
  ${NSD_CreateRadioButton} 8u 95u 257u 14u $(ini_progfiles)
  Pop $RadioProgramFiles_HWND
  
  ; === Label4 (type: Label) ===
  ${NSD_CreateLabel} 8u 108u 271u 16u $(ini_progfiles_desc)
  Pop $IniDialog_HWND_Label4
  
FunctionEnd


var IniPath

; dialog show function
Function fnc_IniDialog_Show

 	Call fnc_IniDialog_Create
	
	; Restore values of checkboxes
	${NSD_SetState} $RadioLocalAppdata_HWND $RadioLocalAppdata_State
	${NSD_SetState} $RadioAllUserAppdata_HWND $RadioAllUserAppdata_State
	${NSD_SetState} $RadioProgramFiles_HWND $RadioProgramFiles_State

	; on first run, no checkbox will be selected, pick a default.
	${If} $RadioAllUserAppdata_State != ${BST_CHECKED}
	${AndIf} $RadioProgramFiles_State != ${BST_CHECKED}
		${NSD_Check} $RadioLocalAppdata_HWND
		
		
		; Check if Registry key exists for IniPath, if so, pick
                ; same setting that was used previously.
		ReadRegDWORD $IniPath HKLM "Software\${PRODUCT}" "IniPath"

		IntCmp $IniPath 0x0000001A localappdata
		IntCmp $IniPath 0x00000023 alluserappdata
		IntCmp $IniPath 0x00000026 progfiles

		; if not found or not equal to any of these skip assignment
		Goto donechecking

		localappdata:	
			${NSD_Check} $RadioLocalAppdata_HWND
			${NSD_Uncheck} $RadioAllUserAppdata_HWND
			${NSD_Uncheck} $RadioProgramFiles_HWND
			Goto donechecking
		alluserappdata:
			${NSD_Uncheck} $RadioLocalAppdata_HWND
			${NSD_Check} $RadioAllUserAppdata_HWND
			${NSD_Uncheck} $RadioProgramFiles_HWND
			Goto donechecking
		progfiles:
			${NSD_Uncheck} $RadioLocalAppdata_HWND
			${NSD_Uncheck} $RadioAllUserAppdata_HWND
			${NSD_Check} $RadioProgramFiles_HWND
			Goto donechecking		
		
		donechecking:

	${EndIf}
	


	
	
	

	nsDialogs::Show $IniDialog_HWND

FunctionEnd

Function fnc_IniDialog_Leave
	${NSD_GetState} $RadioLocalAppdata_HWND $RadioLocalAppdata_State
	${NSD_GetState} $RadioAllUserAppdata_HWND $RadioAllUserAppdata_State
	${NSD_GetState} $RadioProgramFiles_HWND $RadioProgramFiles_State

        ;don't think this code block works right. debug later?
	;${If} $RadioLocalAppdata_State == ${BST_CHECKED}
	;	IntFmt $iniStorageLocation "0x%08X" INILOC_APPDATA
	;${ElseIf} $RadioAllUserAppdata_State == ${BST_CHECKED}
	;	IntFmt $iniStorageLocation "0x%08X" INILOC_ALLUSER
	;${ElseIf} $RadioProgramFiles_State == ${BST_CHECKED}
	;	IntFmt $iniStorageLocation "0x%08X" INILOC_APP_DIR
	;${EndIf}
FunctionEnd


Function writeIniDialogRegistrySetting
  ; this would be better, but relies on broken code above


	${If} $RadioLocalAppdata_State == ${BST_CHECKED}
		WriteRegDWORD HKLM "Software\${PRODUCT}" "IniPath" 0x0000001A
		SetShellVarContext current
		CreateDirectory "$APPDATA\PopTrayU"
	${ElseIf} $RadioAllUserAppdata_State == ${BST_CHECKED}
		WriteRegDWORD HKLM "Software\${PRODUCT}" "IniPath" 0x00000023
		SetShellVarContext all
		CreateDirectory "$APPDATA\PopTrayU"
	${ElseIf} $RadioProgramFiles_State == ${BST_CHECKED}
		WriteRegDWORD HKLM "Software\${PRODUCT}" "IniPath" 0x00000026
	${EndIf}

FunctionEnd


