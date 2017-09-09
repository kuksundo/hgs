
{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{  Copyright (c) 1995-2001 Borland Software Corporation }
{                                                       }
{*******************************************************}

unit Consts;

interface

resourcestring
  SOpenFileTitle = 'Öffnen';
  SCantWriteResourceStreamError = 'In einen zum Lesen geöffneten Ressourcen-Stream kann nicht geschrieben werden';
  SDuplicateReference = 'Zweimaliger Aufruf von WriteObject für die gleiche Instanz';
  SClassMismatch = 'Ressource %s hat die falsche Klasse';
  SInvalidTabIndex = 'Registerindex außerhalb des zulässigen Bereichs';
  SInvalidTabPosition = 'Position des Register ist nicht mit dem aktuellen Register-Stil kompatibel.';
  SInvalidTabStyle = 'Register-Stil ist mit der aktuellen Position nicht kompatibel.';
  SInvalidBitmap = 'Bitmap ist ungültig';
  SInvalidIcon = 'Ungültiges Symbol';
  SInvalidMetafile = 'Metadatei ist ungültig';
  SInvalidPixelFormat = 'Ungültiges Pixel-Format';
  SInvalidImage = 'Ungültiges Bild';
  SBitmapEmpty = 'Bitmap ist leer';
  SScanLine = 'Bereichsüberschreitung bei Zeilenindex';
  SChangeIconSize = 'Die Größe eines Symbols kann nicht geändert werden';
  SOleGraphic = 'Ungültige Operation für TOleGraphic';
  SUnknownExtension = 'Unbekannte Bilddateierweiterung (.%s)';
  SUnknownClipboardFormat = 'Format der Zwischenablage wird nicht unterstützt';
  SOutOfResources = 'Systemressourcen erschöpft.';
  SNoCanvasHandle = 'Leinwand/Bild erlaubt kein Zeichnen';
  SInvalidImageSize = 'Ungültige Bildgröße';
  STooManyImages = 'Zu viele Bilder';
  SDimsDoNotMatch = 'Bildgröße und Bildlistengröße stimmen nicht überein';
  SInvalidImageList = 'Ungültige Bilderliste';
  SReplaceImage = 'Bild kann nicht ersetzt werden';
  SImageIndexError = 'Ungültiger Bilderlistenindex';
  SImageReadFail = 'ImageList-Daten konnten nicht aus dem Stream gelesen werden';
  SImageWriteFail = 'ImageList-Daten konnten nicht in den Stream geschrieben werden';
  SWindowDCError = 'Fehler beim Erstellen des Fenster-Gerätekontexts';
  SClientNotSet = 'Client von TDrag wurde nicht initialisiert';
  SWindowClass = 'Fehler beim Erzeugen einer Fensterklasse';
  SWindowCreate = 'Fehler beim Erzeugen eines Fensters';
  SCannotFocus = 'Deaktiviertes oder unsichtbares Fenster kann den Fokus nicht erhalten';
  SParentRequired = 'Element ''%s'' hat kein übergeordnetes Fenster';
  SParentGivenNotAParent = 'Das angegebene übergeordnete Element ist kein übergeordnetes Element von ''%s''';
  SMDIChildNotVisible = 'Untergeordnetes MDI-Formular kann nicht verborgen werden';
  SVisibleChanged = 'Eigenschaft Visible kann in OnShow oder OnHide nicht verändert werden';
  SCannotShowModal = 'Aus einem sichtbaren Fenster kann kein modales gemacht werden';
  SScrollBarRange = 'Eigenschaft Scrollbar außerhalb des zulässigen Bereichs';
  SPropertyOutOfRange = 'Eigenschaft %s außerhalb des gültigen Bereichs';
  SMenuIndexError = 'Menüindex außerhalb des zulässigen Bereichs';
  SMenuReinserted = 'Menü zweimal eingefügt';
  SMenuNotFound = 'Untermenü ist nicht im Menü';
  SNoTimers = 'Nicht genügend Timer verfügbar';
  SNotPrinting = 'Der Drucker druckt aktuell nicht';
  SPrinting = 'Druckvorgang läuft';
  SPrinterIndexError = 'Druckerindex außerhalb des zulässigen Bereichs';
  SInvalidPrinter = 'Ausgewählter Drucker ist ungültig';
  SDeviceOnPort = '%s an %s';
  SGroupIndexTooLow = 'GroupIndex kann nicht kleiner sein als der GroupIndex eines vorhergehenden Menüelementes';
  STwoMDIForms = 'Es ist nur ein MDI-Formular pro Anwendung möglich';
  SNoMDIForm = 'Formular kann nicht erstellt werden. Zur Zeit sind keine MDI-Formulare aktiv';
  SImageCanvasNeedsBitmap = 'Bild kann nur geändert werden, wenn es ein Bitmap enthält';
  SControlParentSetToSelf = 'Steuerelement kann nicht sich selbst als Vorfahr haben';
  SOKButton = 'OK';
  SCancelButton = 'Abbrechen';
  SYesButton = '&Ja';
  SNoButton = '&Nein';
  SHelpButton = '&Hilfe';
  SCloseButton = 'S&chließen';
  SIgnoreButton = '&Ignorieren';
  SRetryButton = '&Wiederholen';
  SAbortButton = 'Abbrechen';
  SAllButton = '&Alle';

  SCannotDragForm = 'Formulare können nicht gezogen werden';
  SPutObjectError = 'PutObject auf undefiniertes Element';
  SCardDLLNotLoaded = 'CARDS.DLL kann nicht geladen werden';
  SDuplicateCardId = 'Doppelte CardId gefunden';

  SDdeErr = 'Vom DDE wurde ein Fehler zurückgegeben ($0%x)';
  SDdeConvErr = 'DDE-Fehler - Konversation konnte nicht eingerichtet werden ($0%x)';
  SDdeMemErr = 'Wegen Speichermangel bei DDE ist ein Fehler aufgetreten ($0%x).';
  SDdeNoConnect = 'DDE-Konversation konnte nicht verbunden werden.';

  SFB = 'VH';
  SFG = 'VG';
  SBG = 'HG';
  SOldTShape = 'Ältere Version von TShape kann nicht geladen werden';
  SVMetafiles = 'Metadateien';
  SVEnhMetafiles = 'Erweiterte Metadateien';
  SVIcons = 'Symbole';
  SVBitmaps = 'Bitmaps';
  SGridTooLarge = 'Gitter zu groß für Operation';
  STooManyDeleted = 'Zu viele Zeilen oder Spalten gelöscht';
  SIndexOutOfRange = 'Gitterindex außerhalb des zulässigen Bereichs';
  SFixedColTooBig = 'Die Anzahl fester Spalten muß kleiner als die Spaltenanzahl sein';
  SFixedRowTooBig = 'Die Anzahl fester Zeilen muß kleiner als die Zeilenanzahl sein';
  SInvalidStringGridOp = 'Es können keine Zeilen des Tabellengitters gelöscht oder eingefügt werden';
  SInvalidEnumValue = 'Ungültiger Enum-Wert';
  SInvalidNumber = 'Ungültiger numerischer Wert';
  SOutlineIndexError = 'Gliederungsindex nicht gefunden';
  SOutlineExpandError = 'Übergeordneter Knoten muß expandiert sein';
  SInvalidCurrentItem = 'Ungültiger Wert';
  SMaskErr = 'Ungültiger Eingabewert';
  SMaskEditErr = 'Ungültiger Eingabewert. Mit der Taste ESC machen Sie die Änderungen rückgängig.';
  SOutlineError = 'Ungültiger Gliederungsindex';
  SOutlineBadLevel = 'Ungültige Zuweisung von Ebenen';
  SOutlineSelection = 'Ungültige Auswahl';
  SOutlineFileLoad = 'Fehler beim Laden der Datei';
  SOutlineLongLine = 'Zeile zu lang';
  SOutlineMaxLevels = 'Maximale Gliederungstiefe überschritten';

  SMsgDlgWarning = 'Warnung';
  SMsgDlgError = 'Fehler';
  SMsgDlgInformation = 'Information';
  SMsgDlgConfirm = 'Bestätigung';
  SMsgDlgYes = '&Ja';
  SMsgDlgNo = '&Nein';
  SMsgDlgOK = 'OK';
  SMsgDlgCancel = 'Abbrechen';
  SMsgDlgHelp = '&Hilfe';
  SMsgDlgHelpNone = 'Keine Hilfe verfügbar';
  SMsgDlgHelpHelp = 'Hilfe';
  SMsgDlgAbort = '&Abbrechen';
  SMsgDlgRetry = '&Wiederholen';
  SMsgDlgIgnore = '&Ignorieren';
  SMsgDlgAll = '&Alle';
  SMsgDlgNoToAll = '&Alle Nein';
  SMsgDlgYesToAll = 'A&lle Ja';

  SmkcBkSp = 'Rück';
  SmkcTab = 'Tab';
  SmkcEsc = 'Esc';
  SmkcEnter = 'Eingabe';
  SmkcSpace = 'Leertaste';
  SmkcPgUp = 'BildAuf';
  SmkcPgDn = 'BildAb';
  SmkcEnd = 'Ende';
  SmkcHome = 'Pos1';
  SmkcLeft = 'Links';
  SmkcUp = 'Nach oben';
  SmkcRight = 'Rechts';
  SmkcDown = 'Nach unten';
  SmkcIns = 'Einfg';
  SmkcDel = 'Entf';
  SmkcShift = 'Umsch+';
  SmkcCtrl = 'Strg+';
  SmkcAlt = 'Alt+';

  srUnknown = '(Unbekannt)';
  srNone = '(Leer)';
  SOutOfRange = 'Wert muß zwischen %d und %d liegen';

  SDateEncodeError = 'Ungültiges Argument zum Codieren des Datums';
  SDefaultFilter = 'Alle Dateien (*.*)|*.*';
  sAllFilter = 'Alle';
  SNoVolumeLabel = ': [ - Ohne Namen - ]';
  SInsertLineError = 'Zeile kann nicht eingefügt werden';

  SConfirmCreateDir = 'Das angegebene Verzeichnis existiert nicht. Soll es angelegt werden?';
  SSelectDirCap = 'Verzeichnis auswählen';
  SDirNameCap = 'Verzeichnis&name:';
  SDrivesCap = '&Laufwerke:';
  SDirsCap = '&Verzeichnisse:';
  SFilesCap = '&Dateien: (*.*)';
  SNetworkCap = 'Ne&tzwerk...';

  SColorPrefix = 'Farben';               //!! obsolete - delete in 5.0
  SColorTags = 'ABCDEFGHIJKLMNOP';      //!! obsolete - delete in 5.0

  SInvalidClipFmt = 'Ungültiges Format der Zwischenablage';
  SIconToClipboard = 'Zwischenablage unterstützt keine Symbole';
  SCannotOpenClipboard = 'Zwischenablage kann nicht geöffnet werden';

  SDefault = 'Standard';

  SInvalidMemoSize = 'Text überschreitet Memo-Kapazität';
  SCustomColors = 'Selbstdefinierte Farben';
  SInvalidPrinterOp = 'Operation auf ausgewähltem Drucker nicht verfügbar';
  SNoDefaultPrinter = 'Zur Zeit ist kein Standarddrucker gewählt';

  SIniFileWriteError = 'In %s kann nicht geschrieben werden';

  SBitsIndexError = 'Bits-Index außerhalb des zulässigen Bereichs';

  SUntitled = '(Unbenannt)';

  SInvalidRegType = 'Ungültiger Datentyp für ''%s''';

  SUnknownConversion = 'Unbekannte Dateierweiterung für RichEdit-Konvertierung (.%s)';
  SDuplicateMenus = 'Menü ''%s'' wird bereits von einem anderen Formular benutzt';

  SPictureLabel = 'Grafik:';
  SPictureDesc = ' (%dx%d)';
  SPreviewLabel = 'Vorschau';

  SCannotOpenAVI = 'AVI kann nicht geöffnet werden';

  SNotOpenErr = 'Kein MCI-Gerät geöffnet';
  SMPOpenFilter = 'Alle Dateien (*.*)|*.*|Wave-Dateien (*.WAV)|*.WAV|Midi-Dateien (*.MID)|*.MID|Video für Windows (*.avi)|*.avi';
  SMCINil = '';
  SMCIAVIVideo = 'AVIVideo';
  SMCICDAudio = 'CDAudio';
  SMCIDAT = 'DAT';
  SMCIDigitalVideo = 'DigitalVideo';
  SMCIMMMovie = 'MMMovie';
  SMCIOther = 'Andere';
  SMCIOverlay = 'Überlagert';
  SMCIScanner = 'Scanner';
  SMCISequencer = 'Sequencer';
  SMCIVCR = 'VCR';
  SMCIVideodisc = 'Videodisc';
  SMCIWaveAudio = 'WaveAudio';
  SMCIUnknownError = 'Unbekannter Fehler-Code';

  SBoldItalicFont = 'Fett kursiv';
  SBoldFont = 'Fett';
  SItalicFont = 'Kursiv';
  SRegularFont = 'Normal';

  SPropertiesVerb = 'Eigenschaften';

  SServiceFailed = 'Service fehlgeschlagen bei %s:%s';
  SExecute = 'execute';
  SStart = 'start';
  SStop = 'stop';
  SPause = 'Pause';
  SContinue = 'Weiter';
  SInterrogate = 'interrogate';
  SShutdown = 'shutdown';
  SCustomError = 'Service fehlgeschlagen in selbstdef. Meldung (%d): %s';
  SServiceInstallOK = 'Service erfolgreich installiert';
  SServiceInstallFailed = 'Service "%s" konnte nicht installiert werden; Fehler: "%s"';
  SServiceUninstallOK = 'Service erfolgreich deinstalliert';
  SServiceUninstallFailed = 'Service "%s" konnte nicht deinstalliert werden; Fehler: "%s"';

  SInvalidActionRegistration = 'Ungültige Aktionsregistrierung';
  SInvalidActionUnregistration = 'Ungültige Aufhebung der Registrierung der Aktion';
  SInvalidActionEnumeration = 'Ungültige Aktionsaufzählung';
  SInvalidActionCreation = 'Ungültige Aktionserstellung';

  SDockedCtlNeedsName = 'Angedocktes Steuerelement muß einen Namen haben.';
  SDockTreeRemoveError = 'Fehler beim Entfernen des Steuerelements aus der Andock-Hierarchie';
  SDockZoneNotFound = ' - Andockzone nicht gefunden';
  SDockZoneHasNoCtl = ' - Andockzone besitzt kein Steuerelement';

  SAllCommands = 'Alle Befehle';

  SDuplicateItem = 'Liste gestattet keine doppelten Einträge ($0%x)';

  STextNotFound = 'Text nicht gefunden: "%s"';
  SBrowserExecError = 'Es ist kein Standard-Browser eingetragen';

  SColorBoxCustomCaption = 'Individuell...';

  SMultiSelectRequired = 'Mehrfachauswahl muß für diese Funktion aktiviert sein';

  SKeyCaption = 'Schlüssel';
  SValueCaption = 'Wert';
  SKeyConflict = 'Schlüssel mit der Bezeichnung "%s" existiert bereits';
  SKeyNotFound = 'Taste "%s" nicht gefunden';
  SNoColumnMoving = 'goColMoving wird nicht unterstützt';
  SNoEqualsInKey = 'Schlüssel darf keine Gleichheitszeichen ("=") enthalten';

  SSendError = 'Fehler beim Versenden von Mail';
  SAssignSubItemError = 'Unterelement kann nicht zu Aktionsleiste hinzugefügt werden, wenn ein übergeordnetes Element bereits einer Aktionsleiste zugewiesen ist';
  SDeleteItemWithSubItems = 'Element %s hat Unterelemente, trotzdem löschen?';
  SMoreButtons = 'Weitere Schaltflächen';
  SErrorDownloadingURL = 'Fehler beim Download von URL: %s';
  SUrlMonDllMissing = '%s kann nicht geladen werden';
  SAllActions = '(Alle Aktionen)';
  SNoCategory = '(Keine Kategorie)';
  SExpand = 'Einblenden';
  SErrorSettingPath = 'Fehler beim Festlegen des Pfades: "%s"';
  SLBPutError = 'Versuch, Elemente in ein virtuelles Stillistenfeld einzufügen';
  SErrorLoadingFile = 'Fehler beim Laden der zuvor gespeicherten Einstellungsdatei: %s'#13'Soll die Datei gelöscht werden?';
  SResetUsageData = 'Alle verwendeten Daten zurücksetzen';
  SFileRunDialogTitle = 'Start';
  SNoName = '(Kein Name)';      
  SErrorActionManagerNotAssigned = 'ActionManager muß zuerst zugewiesen werden';
  SAddRemoveButtons = '&Schaltflächen hinzufügen oder entfernen';
  SResetActionToolBar = 'Symbolleiste zurücksetzen';
  SCustomize = 'A&npassen';
  SSeparator = 'Separator';
  SCirularReferencesNotAllowed = 'Zirkuläre Verweise sind nicht gestattet';
  SCannotHideActionBand = '%s kann nicht verborgen werden';
  SErrorSettingCount = 'Fehler beim Setzen von %s.Count';
  SListBoxMustBeVirtual = 'Stil des Listenfeldes (%s) muß virtuell sein, damit Count gesetzt werden kann';
  SUnableToSaveSettings = 'Einstellungen konnten nicht gespeichert werden';
  SRestoreDefaultSchedule = 'Wollen Sie auf die Standard-Prioritätenverteilung zurücksetzen?';
      
implementation

end.
