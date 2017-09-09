
{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{  Copyright (c) 1996-2001 Borland Software Corporation }
{                                                       }
{*******************************************************}

unit ComStrs;

interface

resourcestring
  sTabFailClear = 'Register-Element konnte nicht geleert werden';
  sTabFailDelete = 'Registerseite mit Index %d konnte nicht gelöscht werden';
  sTabFailRetrieve = 'Registerseite mit Index %d konnte nicht gelesen werden';
  sTabFailGetObject = 'Objekt mit Index %d konnte nicht gelesen werden';
  sTabFailSet = 'Registerseite ''%s'' mit Index %d konnte nicht gesetzt werden';
  sTabFailSetObject = 'Objekt mit Index %d konnte nicht gesetzt werden';
  sTabMustBeMultiLine = 'Bei TabPosition tpLeft und tpRight muß MultiLine True sein';

  sInvalidLevel = 'Ungültige Zuweisung von Eintragsebenen';
  sInvalidLevelEx = 'Ungültige Ebene (%d) für Eintrag "%s"';
  sInvalidIndex = 'Ungültiger Index';
  sInsertError = 'Eintrag kann nicht eingefügt werden';

  sInvalidOwner = 'Ungültiger Besitzer';
  sUnableToCreateColumn = 'Neue Spalte kann nicht erzeugt werden';
  sUnableToCreateItem = 'Neuer Eintrag kann nicht erzeugt werden';

  sRichEditInsertError = 'Fehler bei Einfügen von RichEdit-Zeile';
  sRichEditLoadFail = 'Laden des Streams ist mißlungen';
  sRichEditSaveFail = 'Speichern des Streams ist mißlungen';

  sTooManyPanels = 'StatusBar darf nicht mehr als 64 Bedienfelder (Panels) haben';

  sHKError = 'Fehler bei der Zuordnung des Tastenkürzels zu %s. %s';
  sHKInvalid = 'Tastenkürzel ist ungültig';
  sHKInvalidWindow = 'Fenster ist ungültig oder ein untergeordnetes Fenster';
  sHKAssigned = 'Tastenkürzel ist einem anderen Fenster zugeordnet';

  sUDAssociated = '%s ist bereits mit %s verknüpft';

  sPageIndexError = '%d ist ein ungültiger Wert für PageIndex. PageIndex muß zwischen 0 und %d liegen';

  sInvalidComCtl32 = 'Dieses Element benötigt COMCTL32.DLL in der Version 4.70 oder höher';

  sDateTimeMax = 'Datum überschreitet das Maximum von %s';
  sDateTimeMin = 'Datum unterschreitet das Minimum von %s';
  sNeedAllowNone = 'Um das Datum zu setzen, muß der Modus ShowCheckbox aktiv sein';
  sFailSetCalDateTime = 'Kalenderzeit oder -datum konnte nicht gesetzt werden';
  sFailSetCalMaxSelRange = 'Max. Auswahlbereich konnte nicht gesetzt werden';
  sFailSetCalMinMaxRange = 'Max./min. Bereich des Kalenders konnte nicht gesetzt werden';
  sCalRangeNeedsMultiSelect = 'Datumsbereich kann nur im Mehrfachauswahl-Modus verwendet werden';
  sFailsetCalSelRange = 'Ausgewählter Bereich des Kalenders kann nicht gesetzt werden';

implementation

end.
