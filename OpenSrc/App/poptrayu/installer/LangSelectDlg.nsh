    ;; Show a language-select dialog when the installer is launched
    Push ""
    ;
    Push 0
    Push ${LANG_ENGLISH}
    Push English
    ;
    Push 1252
    Push ${LANG_AFRIKAANS}
    Push Afrikaans
    ;
    ;Push 1250
    ;Push ${LANG_ALBANIAN}
    ;Push "shqip (Albanian)"
    ;
    Push 1256
    Push ${LANG_ARABIC}
    Push "العربية (Arabic)"
    ;
    Push 1251
    Push ${LANG_BULGARIAN}
    Push "български (Bulgarian)"
    ;
    Push 1252
    Push ${LANG_CATALAN}
    Push "Català (Catalon)"
    ;
    Push 1250
    Push ${LANG_CZECH}
    Push "Cesky (Czech)"
    ;
    Push 936
    Push ${LANG_SIMPCHINESE}
    Push "中文简体 (Chinese, Simplified)"
    ;
    ;Push 950
    ;Push ${LANG_TRADCHINESE}
    ;Push "Chinese (Traditional)"
    ;
    Push 1252
    Push ${LANG_DANISH}
    Push "Dansk (Danish)"
    ;
    Push 1252
    Push ${LANG_GERMAN}
    Push "Deutsch (German)"
    ;
    Push 1257
    Push ${LANG_ESTONIAN}
    Push "Eesti keel (Estonian)"
    ;
    Push 1252
    Push ${LANG_SPANISH}
    Push "Español (Spanish)"
    ;
    ;Push 1252
    ;Push ${LANG_SPANISHINTERNATIONAL}
    ;Push "Español (Alfabetización Internacional)"
    ;
    Push 1252
    Push ${LANG_FRENCH}
    Push "Français (French)"
    ;
    Push 1252
    Push ${LANG_GALICIAN}
    Push "Galego (Galician)"
    ;
    Push 1253
    Push ${LANG_GREEK}
    Push "ελληνικά (Greek)"
    ;
    Push 1255
    Push ${LANG_HEBREW}
    Push "עברית (Hebrew)"
    ;
    Push 1250
    Push ${LANG_CROATIAN}
    Push "Hrvatski (Croatian)"
    ;
    Push 1252
    Push ${LANG_ITALIAN}
    Push "Italiano (Italian)"
    ;
    Push 949
    Push ${LANG_KOREAN}
    Push "한국어(Korean)"
    ;
    Push 1257
    Push ${LANG_LITHUANIAN}
    Push "lietuvių kalba (Lithuanian)"
    ;
    Push 1250
    Push ${LANG_HUNGARIAN}
    Push "Magyar (Hungarian)"
    ;
    Push 1252
    Push ${LANG_DUTCH}
    Push "Nederlands (Dutch)"
    ;
    Push 1252
    Push ${LANG_NORWEGIAN}
    Push Norwegian
    ;
    ;Push 1252
    ;Push ${LANG_NORWEGIANNYNORSK}
    ;Push "Norwegian nynorsk"
    ;
    Push 1250
    Push ${LANG_POLISH}
    Push "Polski (Polish)"
    ;
    Push 1252
    Push ${LANG_PORTUGUESE}
    Push "Português (Portuguese)"
    ;
;    Push 1252
;    Push ${LANG_PORTUGUESEBR}
;    Push "Português Brasileiro (Brazil)"
    ;
    Push 1250
    Push ${LANG_ROMANIAN}
    Push "Romana (Romanian)"
    ;
    Push 1251
    Push ${LANG_RUSSIAN}
    Push "Русский язык (Russian)"
    ;
    ;Push 1251
    ;Push ${LANG_SERBIAN}
    ;Push "српски (Serbian Cyrillic)"
    ;
    Push 1250
    Push ${LANG_SERBIANLATIN}
    Push "srpski (Serbian Latin)"
    ;
    Push 1250
    Push ${LANG_SLOVENIAN}
    Push "Slovenski jezik (Slovenian)"
    ;
    Push 1250
    Push ${LANG_SLOVAK}
    Push "Slovensky (Slovak)"
    ;
    Push 1252
    Push ${LANG_FINNISH}
    Push "Suomi (Finnish)"
    ;
    Push 1252
    Push ${LANG_SWEDISH}
    Push "Svenska (Swedish)"
    ;
    ;Push 874
    ;Push ${LANG_THAI}
    ;Push "ภาษาไทย (Thai)"
    ;
    Push 1254
    Push ${LANG_TURKISH}
    Push "Türkçe (Turkish)"
    ;
    Push 1251
    Push ${LANG_UKRAINIAN}
    Push "Українська (Ukrainian)"
    ;

    Push CA
    LangDLL::LangDialog "Installer Language" "Please select the language of the installer"
    Pop $LANGUAGE
    StrCmp $LANGUAGE "cancel" 0 +2
    Abort