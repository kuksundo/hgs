{ *********************************************************************** }
{                                                                         }
{ Delphi / Kylix Cross-Platform Runtime Library                           }
{                                                                         }
{ Copyright (c) 1995, 2001 Borland Software Corporation                   }
{                                                                         }
{ *********************************************************************** }

unit SysConst;                                   

interface

resourcestring
  SUnknown = '<unbekannt>';
  SInvalidInteger = '''%s'' ist kein gültiger Integerwert';
  SInvalidFloat = '''%s'' ist kein gültiger Gleitkommawert';
  SInvalidCurrency = '''%s'' ist kein gültiger Währungwert';
  SInvalidDate = '''%s'' ist kein gültiges Datum';
  SInvalidTime = '''%s'' ist keine gültige Uhrzeit';
  SInvalidDateTime = '''%s'' ist keine gültige Datums- und Uhrzeitangabe';
  SInvalidDateTimeFloat = '''%g'' kein gültiger Datums- und Zeitwet';
  SInvalidTimeStamp = '''%d.%d'' ist kein gültiger Zeitstempel';
  SInvalidGUID = '''%s'' kein gültiger Wert für GUID';
  SInvalidBoolean = '''%s'' ist kein gültiger boolescher Wert';
  STimeEncodeError = 'Ungültiges Argument für Codierung der Uhrzeit';
  SDateEncodeError = 'Ungültiges Argument zum Codieren des Datums';
  SOutOfMemory = 'Zu wenig Arbeitsspeicher';
  SInOutError = 'E/A-Fehler %d';
  SFileNotFound = 'Datei nicht gefunden';
  SInvalidFilename = 'Ungültiger Dateiname';
  STooManyOpenFiles = 'Zu viele geöffnete Dateien';
  SAccessDenied = 'Dateizugriff verweigert';
  SEndOfFile = 'Versuch hinter dem Dateiende zu lesen';
  SDiskFull = 'Zu wenig Speicherplatz';
  SInvalidInput = 'Ungültige numerische Eingabe';
  SDivByZero = 'Division durch Null';
  SRangeError = 'Fehler bei Bereichsprüfung';
  SIntOverflow = 'Integerüberlauf';
  SInvalidOp = 'Ungültige Gleitkommaoperation';
  SZeroDivide = 'Gleitkommadivision durch Null';
  SOverflow = 'Gleitkommaüberlauf';
  SUnderflow = 'Gleitkommaunterlauf';
  SInvalidPointer = 'Ungültige Zeigeroperation';
  SInvalidCast = 'Ungültige Typumwandlung';
{$IFDEF MSWINDOWS}
  SAccessViolation = 'Zugriffsverletzung bei Adresse %p. %s von Adresse %p';
{$ENDIF}
{$IFDEF LINUX}
  SAccessViolation = 'Zugriffsverletzung bei Adresse %p beim Zugriff auf Adresse %p';
{$ENDIF}
  SStackOverflow = 'Stack-Überlauf';
  SControlC = 'Strg+C gedrückt';
  SQuit = 'Taste zum Verlassen gedrückt';
  SPrivilege = 'Privilegierte Anweisung';
  SOperationAborted = 'Operation abgebrochen';
  SException = 'Exception %s in Modul %s bei %p.' + sLineBreak + '%s%s' + sLineBreak;
  SExceptTitle = 'Anwendungsfehler';
{$IFDEF LINUX}
  SSigactionFailed = 'sigaction-Aufruf fehlgeschlagen';
{$ENDIF}
  SInvalidFormat = 'Format ''%s'' ungültig oder nicht kompatibel mit Argument';
  SArgumentMissing = 'Kein Argument für Format ''%s''';
  SDispatchError = 'Variant-Methodenaufruf nicht unterstützt';
  SReadAccess = 'Lesen';
  SWriteAccess = 'Schreiben';
  SResultTooLong = 'Formatergebnis länger als 4096 Zeichen';
  SFormatTooLong = 'Format-String zu lang';

  SVarArrayCreate = 'Fehler beim Erstellen des Variant-Arrays';
  SVarArrayBounds = 'Index des Variant-Arrays außerhalb des Bereichs';
  SVarArrayLocked = 'Variant-Array ist gesperrt';

  SInvalidVarCast = 'Ungültige Variant-Typumwandlung';
  SInvalidVarOp = 'Ungültige Variant-Operation';
  SInvalidVarOpWithHResult = 'Ungültige Variant-Operation ($%.8x)';

  SVarNotArray = 'Variant ist kein Array' deprecated; // use SVarInvalid
  SVarTypeUnknown = 'Unbekannter selbstdefinierter Variant-Typ (%.4x)' deprecated; // not used anymore

  SVarTypeOutOfRange = 'Selbstdefinierter Variant-Typ (%.4x) ist nicht im gültigen Bereich';
  SVarTypeAlreadyUsed = 'Selbstdefinierter Variant-Typ (%.4x) wird bereits von %s verwendet';
  SVarTypeNotUsable = 'Selbstdefinierter Variant-Typ (%.4x) ist nicht verwendbar';
  SVarTypeTooManyCustom = 'Es wurden zu viele benutzerdefinierte Variant-Typen registriert';

  SVarTypeCouldNotConvert = 'Variante des Typs (%s) konnte nicht in Typ (%s) konvertiert werden';
  SVarTypeConvertOverflow = 'Überlauf bei der Konvertierung einer Variante vom Typ (%s) in Typ (%s)';
  SVarOverflow = 'Variant-Überlauf';
  SVarInvalid = 'Ungültiges Argument';
  SVarBadType = 'Ungültiger Variant-Typ';
  SVarNotImplemented = 'Operation wird nicht unterstützt';
  SVarOutOfMemory = 'Speichermangel bei Varinat-Operation';
  SVarUnexpected = 'Unerwarteter Variant-Fehler';

  SVarDataClearRecursing = 'Rekursion beim Durchführen eines VarDataClear';
  SVarDataCopyRecursing = 'Rekursion beim Durchführen eines VarDataCopy';
  SVarDataCopyNoIndRecursing = 'Rekursion beim Durchführen eines VarDataCopyNoInd';
  SVarDataInitRecursing = 'Rekursion beim Durchführen eines VarDataInit';
  SVarDataCastToRecursing = 'Rekursion beim Durchführen eines VarDataCastTo';
  SVarIsEmpty = 'Die Variante ist leer';
  sUnknownFromType = 'Konvertierung des angegebenen Typs kann nicht durchgeführt werden';
  sUnknownToType = 'Konvertierung in den angegebenen Typ kann nicht durchgeführt werden';
  SExternalException = 'Externe Exception %x';
  SAssertionFailed = 'Auswertung von assert fehlgeschlagen';
  SIntfCastError = 'Schnittstelle nicht unterstützt';
  SSafecallException = 'Exception in safecall-Methode';
  SAssertError = '%s (%s, Zeile %d)';
  SAbstractError = 'Abstrakter Fehler';
  SModuleAccessViolation = 'Zugriffsverletzung bei Adresse %p in Modul ''%s''. %s von Adresse %p';
  SCannotReadPackageInfo = 'Zugriff auf Package-Informationen von ''%s'' nicht möglich';
  sErrorLoadingPackage = 'Package %s kann nicht geladen werden.'+sLineBreak+'%s';
  SInvalidPackageFile = 'Ungültige Package-Datei ''%s''';
  SInvalidPackageHandle = 'Ungültiges Package-Handle';
  SDuplicatePackageUnit = 'Package ''%s kann nicht geladen werden.''  Es enthält die Unit ''%s,''' +
    'die auch im Package ''%s'' enthalten ist';
  SOSError = 'Systemfehler.  Code: %d.'+sLineBreak+'%s';
  SUnkOSError = 'Ein Aufruf einer Betriebssystemfunktion ist fehlgeschlagen';
{$IFDEF MSWINDOWS}
  SWin32Error = 'Win32 Fehler.  Code: %d.'#10'%s' deprecated; // use SOSError
  SUnkWin32Error = 'Fehler bei einer Win32 API-Funktion' deprecated; // use SUnkOSError
{$ENDIF}
  SNL = 'Die Anwendung ist für diese Funktion nicht lizenziert.';

  SConvIncompatibleTypes2 = 'Inkompatible Konvertierungstypen [%s, %s]';
  SConvIncompatibleTypes3 = 'Inkompatible Konvertierungstypen [%s, %s, %s]';
  SConvIncompatibleTypes4 = 'Inkompatible Konvertierungstypen [%s - %s, %s - %s]';
  SConvUnknownType = 'Unkannter Konvertierungstyp %s';
  SConvDuplicateType = 'Konvertierungstyp (%s) ist bereits registriert';
  SConvUnknownFamily = 'Unbekannte Konvertierungsfamilie %s';
  SConvDuplicateFamily = 'Konvertierungsfamilie (%s) bereits registriert';
  SConvUnknownDescription = '[%.8x]';
  SConvIllegalType = 'Ungültiger Typ';
  SConvIllegalFamily = 'Ungültige Familie';
  SConvFactorZero = '%s hat den Faktor Null';

  SShortMonthNameJan = 'Jan';
  SShortMonthNameFeb = 'Feb';
  SShortMonthNameMar = 'Mär';
  SShortMonthNameApr = 'Apr';
  SShortMonthNameMay = 'Mai';
  SShortMonthNameJun = 'Jun';
  SShortMonthNameJul = 'Jul';
  SShortMonthNameAug = 'Aug';
  SShortMonthNameSep = 'Sep';
  SShortMonthNameOct = 'Okt';
  SShortMonthNameNov = 'Nov';
  SShortMonthNameDec = 'Dez';

  SLongMonthNameJan = 'Januar';
  SLongMonthNameFeb = 'Februar';
  SLongMonthNameMar = 'März';
  SLongMonthNameApr = 'April';
  SLongMonthNameMay = 'Mai';
  SLongMonthNameJun = 'Juni';
  SLongMonthNameJul = 'Juli';
  SLongMonthNameAug = 'August';
  SLongMonthNameSep = 'September';
  SLongMonthNameOct = 'Oktober';
  SLongMonthNameNov = 'November';
  SLongMonthNameDec = 'Dezember';

  SShortDayNameSun = 'So';
  SShortDayNameMon = 'Mo';
  SShortDayNameTue = 'Di';
  SShortDayNameWed = 'Mi';
  SShortDayNameThu = 'Do';
  SShortDayNameFri = 'Fr';
  SShortDayNameSat = 'Sa';

  SLongDayNameSun = 'Sonntag';
  SLongDayNameMon = 'Montag';
  SLongDayNameTue = 'Dienstag';
  SLongDayNameWed = 'Mittwoch';
  SLongDayNameThu = 'Donnerstag';
  SLongDayNameFri = 'Freitag';
  SLongDayNameSat = 'Samstag';

{$IFDEF LINUX}
  SEraEntries = '';
{$ENDIF}

  SCannotCreateDir = 'Das Verzeichnis kann nicht erstellt werden';

implementation

end.
