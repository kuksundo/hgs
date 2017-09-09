program translate;

uses sysutils, LazUTF8, Translations, TranslateResStr;

var Lang, FallbackLang : String;

begin
  Lang := '';
  FallbackLang := '';
  LazGetLanguageIDs(Lang,FallbackLang);
  WriteLn(StdOut,Lang);
  WriteLn(StdOut,FallbackLang);
  Translations.TranslateResourceStrings(Format('locale/translate.%s.po',[FallbackLang]));
  WriteLn(StdOut,rsResStr1);
end.

