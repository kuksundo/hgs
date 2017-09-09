{ *************************************************************************** }
{                                                                             }
{ Delphi and Kylix Cross-Platform Visual Component Library                    }
{                                                                             }
{ Copyright (c) 1995, 2001 Borland Software Corporation                       }
{                                                                             }
{ *************************************************************************** }

unit RTLConsts;

interface

resourcestring
  SAncestorNotFound = 'Vorfahr für ''%s'' nicht gefunden';
  SAssignError = '%s kann nicht zu  %s zugewiesen werden';
  SBitsIndexError = 'Bits-Index außerhalb des zulässigen Bereichs';
  SBucketListLocked = 'Liste ist während eines aktiven ForEach gesperrt';
  SCantWriteResourceStreamError = 'In einen schreibgeschützten Ressourcen-Stream kann nicht geschrieben werden';
  SCharExpected = '''''%s'''' erwartet';
  SCheckSynchronizeError = 'CheckSynchronize wurde vom Thread $%x aufgerufen, der NICHT der Haupt-Thread ist.';
  SClassNotFound = 'Klasse %s nicht gefunden';
  SDelimiterQuoteCharError = 'Die Eigenschaften Delimiter und QuoteChar dürfen nicht denselben Wert besitzen';
  SDuplicateClass = 'Klasse mit der Bezeichnung %s existiert bereits';
  SDuplicateItem = 'Liste gestattet keine doppelten Einträge ($0%x)';
  SDuplicateName = 'Komponente mit der Bezeichnung %s existiert bereits';
  SDuplicateString = 'In der Stringliste sind Duplikate nicht erlaubt';
  SFCreateError = 'Datei %s kann nicht erstellt werden';
  SFixedColTooBig = 'Die Anzahl fester Spalten muß kleiner als die Spaltenanzahl sein';
  SFixedRowTooBig = 'Die Anzahl fester Zeilen muß kleiner als die Zeilenanzahl sein';
  SFOpenError = 'Datei %s kann nicht geöffnet werden';
  SGridTooLarge = 'Gitter zu groß für Operation';
  SIdentifierExpected = 'Bezeichner erwartet';
  SIndexOutOfRange = 'Gitterindex außerhalb des zulässigen Bereichs';
  SIniFileWriteError = 'In %s kann nicht geschrieben werden';
  SInvalidActionCreation = 'Ungültige Aktionserstellung';
  SInvalidActionEnumeration = 'Ungültige Aktionsaufzählung';
  SInvalidActionRegistration = 'Ungültige Aktionsregistrierung';
  SInvalidActionUnregistration = 'Ungültige Aufhebung der Aktionsregistrierung';
  SInvalidBinary = 'Ungültiger Binärwert';
  SInvalidDate = '''''%s'''' ist kein gültiges Datum';
  SInvalidDateTime = '''''%s'''' ist kein gültiger Datums- und Zeitwert';
  SInvalidFileName = 'Ungültiger Dateiname - %s';
  SInvalidImage = 'Ungültiges Stream-Format';
  SInvalidInteger = '''''%s'''' ist kein gültiger Integerwert';
  SInvalidMask = '''%s'' ist eine ungültige Maske für (%d)';
  SInvalidName = '''''%s'''' ist kein gültiger Komponentenname';
  SInvalidProperty = 'Ungültiger Eigenschaftswert';
  SInvalidPropertyElement = 'Ungültiges Eigenschaftselement: %s';
  SInvalidPropertyPath = 'Ungültiger Pfad für Eigenschaft';
  SInvalidPropertyType = 'Ungültiger Eigenschaftstyp: %s';
  SInvalidPropertyValue = 'Ungültiger Eigenschaftswert';
  SInvalidRegType = 'Ungültiger Datentyp für ''%s''';
  SInvalidString = 'Ungültige Stringkonstante';
  SInvalidStringGridOp = 'Es können keine Zeilen des Tabellengitters gelöscht oder eingefügt werden';
  SInvalidTime = '''''%s'''' ist keine gültige Zeit';
  SItemNotFound = 'Eintrag nicht gefunden ($0%x)';
  SLineTooLong = 'Zeile zu lang';
  SListCapacityError = 'Kapazität der Liste ist erschöpft (%d)';
  SListCountError = 'Zu viele Einträge in der Liste (%d)';
  SListIndexError = 'Listenindex überschreitet das Maximum (%d)';
  SMaskErr = 'Ungültiger Eingabewert';
  SMaskEditErr = 'Ungültiger Eingabewert. Mit der Taste ESC machen Sie die Änderungen rückgängig.';
  SMemoryStreamError = 'Expandieren des Speicher-Stream wegen Speichermangel nicht möglich';
  SNoComSupport = '%s wurde nicht als COM-Klasse registriert';
  SNotPrinting = 'Der Drucker druckt aktuell nicht';
  SNumberExpected = 'Zahl erwartet';
  SParseError = '%s in Zeile %d';
  SComponentNameTooLong = 'Komponentenname ''%s'' überschreitet 64 Zeichen';
  SPropertyException = 'Fehler beim Lesen von %s%s%s: %s';
  SPrinting = 'Druckvorgang läuft';
  SReadError = 'Stream-Lesefehler';
  SReadOnlyProperty = 'Eigenschaft kann nur gelesen werden';
  SRegCreateFailed = 'Erzeugung von Schlüssel %s mißlungen';
  SRegGetDataFailed = 'Fehler beim Holen der Daten für ''%s''';
  SRegisterError = 'Ungültige Komponentenregistrierung';
  SRegSetDataFailed = 'Fehler beim Setzen der Daten für ''%s''';
  SResNotFound = 'Ressource %s wurde nicht gefunden';
  SSeekNotImplemented = '%s.Seek nicht implementiert';
  SSortedListError = 'Operation für sortierte Listen nicht zulässig';
  SStringExpected = 'String erwartet';
  SSymbolExpected = '%s erwartet';
  STimeEncodeError = 'Ungültiges Argument zum Codieren der Uhrzeit';
  STooManyDeleted = 'Zu viele Zeilen oder Spalten gelöscht';
  SUnknownGroup = '%s befindet sich nicht in einer Gruppe für Klassenregistrierungen';
  SUnknownProperty = 'Eigenschaft %s existiert nicht.';
  SWriteError = 'Stream-Schreibfehler';
  SStreamSetSize = 'Fehler beim Setzen der Größe des Stream';
  SThreadCreateError = 'Fehler beim Erzeugen des Thread: %s';
  SThreadError = 'Thread-Fehler: %s (%d)';

  SInvalidDateDay = '(%d, %d) ist kein gültiger Wert für die Tagesangabe im Datum';
  SInvalidDateWeek = '(%d, %d, %d) ist kein gültiger Wert für die Wochenangabe im Datum';
  SInvalidDateMonthWeek = '(%d, %d, %d, %d) ist kein gültiger Wert für die Monats- und Wochenangabe im Datum';
  SInvalidDayOfWeekInMonth = '(%d, %d, %d, %d) ist kein gültiger Wert für dieTages- und Monatsangabe  im Datum';
  SInvalidJulianDate = '%f Julianischer Wert kann nicht als Datum/Uhrzeitwert dargestellt werden';
  SMissingDateTimeField = '?';

  SConvIncompatibleTypes2 = 'Inkompatible Konvertierungstypen [%s, %s]';
  SConvIncompatibleTypes3 = 'Inkompatible Konvertierungstypen [%s, %s, %s]';
  SConvIncompatibleTypes4 = 'Inkompatible Konvertierungstypen [%s - %s, %s - %s]';
  SConvUnknownType = 'Unkannter Konvertierungstyp %s';
  SConvDuplicateType = 'Konvertierungstyp (%s) bereits registriert in %s';
  SConvUnknownFamily = 'Unbekannte Konvertierungsfamilie %s';
  SConvDuplicateFamily = 'Konvertierungsfamilie (%s) bereits registriert';
  SConvUnknownDescription = '[%.8x]';
  SConvIllegalType = 'Ungültiger Typ';
  SConvIllegalFamily = 'Ungültige Familie';
  SConvFactorZero = '%s hat den Faktor Null';
  SConvStrParseError = '%s konnte nicht analysiert werden';
  SFailedToCallConstructor = 'Der Nachkomme von TStrings %s konnte den geerbten Konstruktor nicht aufrufen';

  sWindowsSocketError = 'Windows-Socket-Fehler: %s (%d), auf API ''%s''';
  sAsyncSocketError = 'Asynchroner Socket-Fehler %d';
  sNoAddress = 'Keine Adresse angegeben';
  sCannotListenOnOpen = 'Offener Socket kann nicht überwacht werden';
  sCannotCreateSocket = 'Es kann kein neuer Socket erzeugt werden';
  sSocketAlreadyOpen = 'Socket ist bereits geöffnet';
  sCantChangeWhileActive = 'Wert kann nicht geändert werden, während der Socket aktiv ist';
  sSocketMustBeBlocking = 'Socket muß sich im Blocking-Modus befinden';
  sSocketIOError = '%s-Fehler %d, %s';
  sSocketRead = 'Lesen';
  sSocketWrite = 'Schreiben';

implementation

end.
