
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
  SOpenFileTitle = 'Ouvrir';
  SCantWriteResourceStreamError = 'Impossible d''écrire dans un flux en lecture seule';
  SDuplicateReference = 'WriteObject appelé deux fois pour la même instance';
  SClassMismatch = 'La ressource %s est d''une classe incorrecte';
  SInvalidTabIndex = 'Indice d''onglet hors limites';
  SInvalidTabPosition = 'Position d''onglet incompatible avec le style d''onglet actuel';
  SInvalidTabStyle = 'Style d''onglet incompatible avec la position d''onglet actuelle';
  SInvalidBitmap = 'Image bitmap incorrecte';
  SInvalidIcon = 'Image icône incorrecte';
  SInvalidMetafile = 'MetaFichier incorrect';
  SInvalidPixelFormat = 'Format de pixel incorrect';
  SInvalidImage = 'Image non valide';
  SBitmapEmpty = 'Bitmap vide';
  SScanLine = 'Indice ligne hors limites';
  SChangeIconSize = 'Impossible de modifier la taille d''une icône';
  SOleGraphic = 'Opération incorrecte sur TOleGraphic';
  SUnknownExtension = 'Extension de fichier image inconnue (.%s)';
  SUnknownClipboardFormat = 'Format de Presse-papiers non supporté';
  SOutOfResources = 'Ressources système insuffisantes';
  SNoCanvasHandle = 'Le canevas ne permet pas de dessiner';
  SInvalidImageSize = 'Taille d''image incorrecte';
  STooManyImages = 'Trop d''images';
  SDimsDoNotMatch = 'Les dimensions de l''image ne correspondent pas à celles de la liste d''images';
  SInvalidImageList = 'ImageList incorrecte';
  SReplaceImage = 'Impossible de remplacer l''image';
  SImageIndexError = 'Indice ImageList incorrect';
  SImageReadFail = 'Erreur à la lecture des données ImageList dans le flux';
  SImageWriteFail = 'Erreur à l''écriture des données ImageList dans le flux';
  SWindowDCError = 'Erreur à la création du contexte périphérique fenêtre';
  SClientNotSet = 'Client de TDrag non initialisé';
  SWindowClass = 'Erreur à la création de la classe fenêtre';
  SWindowCreate = 'Erreur à la création de fenêtre';
  SCannotFocus = 'Impossible de focaliser une fenêtre désactivée ou invisible';
  SParentRequired = 'Le contrôle ''%s'' n''a pas de fenêtre parente';
  SParentGivenNotAParent = 'Le parent donné n''est pas un parent de ''%s''';
  SMDIChildNotVisible = 'Impossible de cacher une fiche enfant MDI';
  SVisibleChanged = 'Impossible de changer Visible dans OnShow ou OnHide';
  SCannotShowModal = 'Impossible de rendre modale une fenêtre visible';
  SScrollBarRange = 'Propriété barre de défilement hors limites';
  SPropertyOutOfRange = 'Propriété %s hors limites';
  SMenuIndexError = 'Indice de menu hors limites';
  SMenuReinserted = 'Menu inséré deux fois';
  SMenuNotFound = 'Sous-menu pas dans le menu';
  SNoTimers = 'Pas assez de timers disponibles';
  SNotPrinting = 'L''imprimante n''imprime pas pour l''instant';
  SPrinting = 'Impression en cours';
  SPrinterIndexError = 'Indice imprimante hors limites';
  SInvalidPrinter = 'Imprimante sélectionnée incorrecte';
  SDeviceOnPort = '%s sur %s';
  SGroupIndexTooLow = 'GroupIndex ne peut être inférieur à celui de l''élément de menu précédent';
  STwoMDIForms = 'Impossible d''avoir plus d''une fiche MDI par application';
  SNoMDIForm = 'Impossible de créer la fiche. Aucune fiche Non MDI active';
  SImageCanvasNeedsBitmap = 'Une image ne peut être modifiée que si elle contient un bitmap';
  SControlParentSetToSelf = 'Un contrôle ne peut être son propre parent';
  SOKButton = 'OK';
  SCancelButton = 'Annuler';
  SYesButton = '&Oui';
  SNoButton = '&Non';
  SHelpButton = '&Aide';
  SCloseButton = '&Fermer';
  SIgnoreButton = '&Ignorer';
  SRetryButton = '&Retenter';
  SAbortButton = 'Abandon';
  SAllButton = '&Tous';

  SCannotDragForm = 'Impossible de glisser une fiche';
  SPutObjectError = 'PutObject à élément indéfini';
  SCardDLLNotLoaded = 'Impossible de charger CARDS.DLL';
  SDuplicateCardId = 'CardID dupliqué';

  SDdeErr = 'Une erreur a été renvoyée par DDE ($0%x)';
  SDdeConvErr = 'Erreur DDE - Conversation non établie ($0%x)';
  SDdeMemErr = 'Erreur apparue suite à un manque de mémoire DDE ($0%x)';
  SDdeNoConnect = 'Impossible de connecter la conversation DDE';

  SFB = 'TF';
  SFG = 'T';
  SBG = 'F';
  SOldTShape = 'Impossible de charger version antérieure de TShape';
  SVMetafiles = 'Métafichiers';
  SVEnhMetafiles = 'Métafichiers évolués';
  SVIcons = 'Icônes';
  SVBitmaps = 'Bitmaps';
  SGridTooLarge = 'Grille trop grande pour l''opération';
  STooManyDeleted = 'Trop de lignes ou colonnes supprimées';
  SIndexOutOfRange = 'Indice de grille hors limites';
  SFixedColTooBig = 'Le nombre de colonnes fixes doit être inférieur au nombre de colonnes';
  SFixedRowTooBig = 'Le nombre de lignes fixes doit être inférieur au nombre de lignes';
  SInvalidStringGridOp = 'Impossible d''insérer ou de supprimer les lignes de la grille';
  SInvalidEnumValue = 'Valeur enum incorrecte';
  SInvalidNumber = 'Valeur numérique incorrecte';
  SOutlineIndexError = 'Indice arborescence non trouvé';
  SOutlineExpandError = 'Le parent doit être développé';
  SInvalidCurrentItem = 'Valeur incorrecte pour l''élément en cours';
  SMaskErr = 'Valeur d''entrée incorrecte';
  SMaskEditErr = 'Valeur d''entrée incorrecte. Utiliser Echap pour abandonner les modifications';
  SOutlineError = 'Indice arborescence incorrect';
  SOutlineBadLevel = 'Affectation de niveau incorrect';
  SOutlineSelection = 'Sélection incorrecte';
  SOutlineFileLoad = 'Erreur chargement de fichier';
  SOutlineLongLine = 'Ligne trop longue';
  SOutlineMaxLevels = 'Profondeur maximum arborescence dépassée';

  SMsgDlgWarning = 'Avertissement';
  SMsgDlgError = 'Erreur';
  SMsgDlgInformation = 'Information';
  SMsgDlgConfirm = 'Confirmation';
  SMsgDlgYes = '&Oui';
  SMsgDlgNo = '&Non';
  SMsgDlgOK = 'OK';
  SMsgDlgCancel = 'Annuler';
  SMsgDlgHelp = '&Aide';
  SMsgDlgHelpNone = 'Aucune aide disponible';
  SMsgDlgHelpHelp = 'Aide';
  SMsgDlgAbort = '&Abandonner';
  SMsgDlgRetry = '&Retenter';
  SMsgDlgIgnore = '&Ignorer';
  SMsgDlgAll = '&Tous';
  SMsgDlgNoToAll = 'Non &pour tout';
  SMsgDlgYesToAll = 'O&ui pour tout';

  SmkcBkSp = 'RetArr';
  SmkcTab = 'Tab';
  SmkcEsc = 'Echap';
  SmkcEnter = 'Entrée';
  SmkcSpace = 'Espace';
  SmkcPgUp = 'PagePréc';
  SmkcPgDn = 'PageSuiv';
  SmkcEnd = 'Fin';
  SmkcHome = 'Origine';
  SmkcLeft = 'Gauche';
  SmkcUp = 'Haut';
  SmkcRight = 'Droite';
  SmkcDown = 'Bas';
  SmkcIns = 'Ins';
  SmkcDel = 'Suppr';
  SmkcShift = 'Maj+';
  SmkcCtrl = 'Ctrl+';
  SmkcAlt = 'Alt+';

  srUnknown = '(inconnu)';
  srNone = '(vide)';
  SOutOfRange = 'La valeur doit être comprise entre %d et %d';

  SDateEncodeError = 'Argument incorrect pour l''encodage de date';
  SDefaultFilter = 'Tous les fichiers (*.*)|*.*';
  sAllFilter = 'Tous';
  SNoVolumeLabel = ': [ Pas de nom de volume ]';
  SInsertLineError = 'Impossible d''insérer une ligne';

  SConfirmCreateDir = 'Le répertoire spécifié n''existe pas. Le créer ?';
  SSelectDirCap = 'Sélection du répertoire';
  SDirNameCap = '&Nom de répertoire :';
  SDrivesCap = '&Lecteurs :';
  SDirsCap = '&Répertoires :';
  SFilesCap = '&Fichiers : (*.*)';
  SNetworkCap = 'Ré&seau...';

  SColorPrefix = 'Couleurs';               //!! obsolete - delete in 5.0
  SColorTags = 'ABCDEFGHIJKLMNOP';      //!! obsolete - delete in 5.0

  SInvalidClipFmt = 'Format de Presse-papiers incorrect';
  SIconToClipboard = 'Le Presse-papiers ne supporte pas les icônes';
  SCannotOpenClipboard = 'Impossible d''ouvrir le Presse-papiers';

  SDefault = 'Default';

  SInvalidMemoSize = 'Le texte dépasse la capacité du mémo';
  SCustomColors = 'Couleurs personnalisées';
  SInvalidPrinterOp = 'Opération non supportée par l''imprimante sélectionnée';
  SNoDefaultPrinter = 'Aucune imprimante par défaut sélectionnée';

  SIniFileWriteError = 'Impossible d''écrire dans %s';

  SBitsIndexError = 'Indice de bits hors limites';

  SUntitled = '(sans titre)';

  SInvalidRegType = 'Type de données incorrect pour ''%s''';

  SUnknownConversion = 'Extension de fichier de conversion RichEdit inconnue (.%s)';
  SDuplicateMenus = 'Le menu ''%s'' est déjà utilisé par une autre fiche';

  SPictureLabel = 'Image :';
  SPictureDesc = ' (%dx%d)';
  SPreviewLabel = 'Prévisualiser';

  SCannotOpenAVI = 'Impossible d''ouvrir l''AVI';

  SNotOpenErr = 'Aucun périphérique MCI ouvert';
  SMPOpenFilter = 'Tous les fichiers (*.*)|*.*|Fichiers wave (*.wav)|*.wav|Fichiers Midi '+
'(*.mid)|*.mid|Vidéo pour Windows (*.avi)|*.avi';
  SMCINil = '';
  SMCIAVIVideo = 'Vidéo AVI';
  SMCICDAudio = 'CD Audio';
  SMCIDAT = 'DAT';
  SMCIDigitalVideo = 'Vidéo numérique';
  SMCIMMMovie = 'MMMovie';
  SMCIOther = 'Autre';
  SMCIOverlay = 'Overlay';
  SMCIScanner = 'Scanner';
  SMCISequencer = 'Séquenceur';
  SMCIVCR = 'Magnétoscope';
  SMCIVideodisc = 'Vidéodisque';
  SMCIWaveAudio = 'Audio wav';
  SMCIUnknownError = 'Code d''erreur inconnu';

  SBoldItalicFont = 'Gras Italique';
  SBoldFont = 'Gras';
  SItalicFont = 'Italique';
  SRegularFont = 'Normal';

  SPropertiesVerb = 'Propriétés';

  SServiceFailed = 'Le service a échoué pour %s : %s';
  SExecute = 'exécuter';
  SStart = 'lancer';
  SStop = 'arrêter';
  SPause = 'pause';
  SContinue = 'continuer';
  SInterrogate = 'interroger';
  SShutdown = 'terminer';
  SCustomError = 'Le service a échoué dans le message personnalisée (%d) : %s';
  SServiceInstallOK = 'Service installé avec succès';
  SServiceInstallFailed = 'Le service "%s" a échoué pendant son installation avec l''erreur : "%s"';
  SServiceUninstallOK = 'Service désinstallé avec succès';
  SServiceUninstallFailed = 'Le service "%s" a échoué pendant sa désinstallation avec l''erreur : "%s"';

  SInvalidActionRegistration = 'Enregistrement d''action incorrecte';
  SInvalidActionUnregistration = 'Désenregistrement d''action incorrecte';
  SInvalidActionEnumeration = 'Enumération d''action incorrecte';
  SInvalidActionCreation = 'Création d''action incorrecte';

  SDockedCtlNeedsName = 'Le composant ancré doit avoir un nom';
  SDockTreeRemoveError = 'Erreur à la suppression du contrôle de l''arbre ancré';
  SDockZoneNotFound = ' - Zone d''ancrage non trouvée';
  SDockZoneHasNoCtl = ' - La zone d''ancrage n''a pas de contrôle';

  SAllCommands = 'Toutes les commandes';

  SDuplicateItem = 'La liste n''autorise pas les doublons ($0%x)';

  STextNotFound = 'Texte non trouvé : "%s"';
  SBrowserExecError = 'Aucun navigateur par défaut n''a été spécifié';

  SColorBoxCustomCaption = 'Personnaliser...';

  SMultiSelectRequired = 'Le mode multisélection doit être activé pour cette fonction.';

  SKeyCaption = 'Clé';
  SValueCaption = 'Valeur';
  SKeyConflict = 'Une clé nommée "%s" existe déjà';
  SKeyNotFound = 'Clé "%s" introuvable';
  SNoColumnMoving = 'goColMoving n''est pas une option prise en charge.';
  SNoEqualsInKey = 'La clé ne doit pas contenir de signe égal ("=")';

  SSendError = 'Erreur à l''envoi du courrier';
  SAssignSubItemError = 'Impossible d''affecter un sous-élément à une barre d''actions lorsque l''un de ses parents est déjà affecté à une barre d''actions';
  SDeleteItemWithSubItems = 'L''élément %s comporte des sous-éléments ; le supprimer quand même ?';
  SMoreButtons = 'Boutons supplémentaires';
  SErrorDownloadingURL = 'Erreur de téléchargement de l''URL : %s';
  SUrlMonDllMissing = 'Impossible de charger %s';
  SAllActions = '(Toutes les actions)';
  SNoCategory = '(pas de catégorie)';
  SExpand = 'Etendre';
  SErrorSettingPath = 'Erreur de définition du chemin : "%s"';
  SLBPutError = 'Tentative de placement des éléments dans une zone de liste de styles virtuelle';
  SErrorLoadingFile = 'Erreur lors du chargement du fichier de paramètres précédemment enregistré : %s'#13'Souhaitez-vous le supprimer ?';
  SResetUsageData = 'Réinitialiser toutes les données d''utilisation ?';
  SFileRunDialogTitle = 'Exécuter';
  SNoName = '(pas de nom)';      
  SErrorActionManagerNotAssigned = 'ActionManager doit être affecté en premier lieu.';
  SAddRemoveButtons = '&Ajouter ou supprimer des boutons';
  SResetActionToolBar = 'Réinitialiser la barre d''outils';
  SCustomize = '&Personnaliser';
  SSeparator = 'Séparateur';
  SCirularReferencesNotAllowed = 'Les références circulaires ne sont pas autorisées.';
  SCannotHideActionBand = '%s ne permet pas la dissimulation';
  SErrorSettingCount = 'Erreur lors de la définition de la valeur %s.Count';
  SListBoxMustBeVirtual = 'Le style de la boîte de liste (%s) doit être virtuel afin de pouvoir définir la valeur Count';
  SUnableToSaveSettings = 'Impossible de sauvegarder les paramètres';
  SRestoreDefaultSchedule = 'Voulez-vous réinitialiser au planning de priorité par défaut ?';
      
implementation

end.
