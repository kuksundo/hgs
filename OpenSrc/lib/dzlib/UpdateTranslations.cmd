@rem This batch will
@rem * call dxgettext to extract all strings to translate
@rem * call msgremove remove any strings stored in the ignore.po file
@rem * call msgmerge to merge the new template with the existing translations into
@rem   - German (full)
@rem   - English (dummy)
@rem   - French (partial)

@rem extract from subdirectories src, forms, adodb, components, dbcreator, dzAdoDb, IniFileFormatter, lockfree
..\..\buildtools\dxgettext *.dfm *.pas *.inc *.dpr -r -b src -b forms -b adodb -b components -b dbcreator -b dzAdoDb -b IniFileFormatter -b lockfree -o .

@rem remove strings given in ignore.po
..\..\buildtools\msgremove default.po -i ignore.po -o filtered.po

@rem merge German translations
..\..\buildtools\msgmerge --no-wrap --update translations\de\dzlib.po filtered.po

@rem merge French translations
..\..\buildtools\msgmerge --no-wrap --update translations\fr\dzlib.po filtered.po

@rem merge English "translations"
..\..\buildtools\msgmerge --no-wrap --update translations\en\dzlib.po filtered.po

pause

..\..\buildtools\gorm.exe translations\de\dzlib.po
