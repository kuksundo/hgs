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
  SAncestorNotFound = 'Ancêtre de ''%s'' non trouvé';
  SAssignError = 'Impossible d''affecter %s à %s';
  SBitsIndexError = 'Indice de bits hors limites';
  SBucketListLocked = 'Liste verrouillée lors d''une opération ForEach active';
  SCantWriteResourceStreamError = 'Impossible d''écrire dans un flux en lecture seule';
  SCharExpected = '''''%s'''' attendu';
  SCheckSynchronizeError = 'CheckSynchronize a été appelée depuis le thread $%x, qui n''est PAS le thread principal';
  SClassNotFound = 'Classe %s non trouvée';
  SDelimiterQuoteCharError = 'Les propriétés Delimiter et QuoteChar ne peuvent avoir la même valeur';
  SDuplicateClass = 'Une classe nommée %s existe déjà';
  SDuplicateItem = 'La liste n''autorise pas les doublons ($0%x)';
  SDuplicateName = 'Un composant nommé %s existe déjà';
  SDuplicateString = 'La liste de chaînes n''autorise pas les doublons';
  SFCreateError = 'Impossible de créer le fichier %s';
  SFixedColTooBig = 'Le nombre de colonnes fixes doit être inférieur au nombre de colonnes';
  SFixedRowTooBig = 'Le nombre de lignes fixes doit être inférieur au nombre de lignes';
  SFOpenError = 'Impossible d''ouvrir le fichier %s';
  SGridTooLarge = 'Grille trop grande pour l''opération';
  SIdentifierExpected = 'Identificateur attendu';
  SIndexOutOfRange = 'Indice de grille hors limites';
  SIniFileWriteError = 'Impossible d''écrire dans %s';
  SInvalidActionCreation = 'Création d''action incorrecte';
  SInvalidActionEnumeration = 'Enumération d''action incorrecte';
  SInvalidActionRegistration = 'Enregistrement d''action incorrecte';
  SInvalidActionUnregistration = 'Désenregistrement d''action incorrecte';
  SInvalidBinary = 'Valeur binaire incorrecte';
  SInvalidDate = '''''%s'''' n''est pas une date correcte';
  SInvalidDateTime = '''''%s'''' ne correspond pas à une date et une heure correctes';
  SInvalidFileName = 'Nom de fichier incorrect - %s';
  SInvalidImage = 'Format de flux incorrect';
  SInvalidInteger = '''''%s'''' n''est pas une valeur entière correcte';
  SInvalidMask = '''%s'' est un masque incorrect à (%d)';
  SInvalidName = '''''%s'''' n''est pas un nom de composant correct';
  SInvalidProperty = 'Valeur de propriété incorrecte';
  SInvalidPropertyElement = 'Elément de propriété incorrect : %s';
  SInvalidPropertyPath = 'Chemin de propriété incorrect';
  SInvalidPropertyType = 'Type de propriété incorrect : %s';
  SInvalidPropertyValue = 'Valeur de propriété incorrecte';
  SInvalidRegType = 'Type de données incorrect pour ''%s''';
  SInvalidString = 'Constante chaîne incorrecte';
  SInvalidStringGridOp = 'Impossible d''insérer ou de supprimer les lignes de la grille';
  SInvalidTime = '''''%s'''' n''est pas une heure correcte';
  SItemNotFound = 'Elément non trouvé ($0%x)';
  SLineTooLong = 'Ligne trop longue';
  SListCapacityError = 'Capacité de liste hors limites (%d)';
  SListCountError = 'Compte de liste hors limites (%d)';
  SListIndexError = 'Indice de liste hors limites (%d)';
  SMaskErr = 'Valeur d''entrée incorrecte';
  SMaskEditErr = 'Valeur d''entrée incorrecte. Utiliser Echap pour abandonner les modifications';
  SMemoryStreamError = 'Mémoire insuffisante lors de l''extension du flux mémoire';
  SNoComSupport = '%s n''a pas été recensé comme classe COM';
  SNotPrinting = 'L''imprimante n''imprime pas actuellement';
  SNumberExpected = 'Nombre attendu';
  SParseError = '%s à la ligne %d';
  SComponentNameTooLong = 'Le nom de composant ''%s'' dépasse la limite des 64 caractères';
  SPropertyException = 'Erreur lors de la lecture de %s%s%s: %s';
  SPrinting = 'Impression en cours';
  SReadError = 'Erreur de lecture du flux';
  SReadOnlyProperty = 'Propriété en lecture seule';
  SRegCreateFailed = 'Echec à la création de la clé %s';
  SRegGetDataFailed = 'Echec à l''obtention des données pour ''%s''';
  SRegisterError = 'Recensement de composant incorrect';
  SRegSetDataFailed = 'Echec à la définition des données pour ''%s''';
  SResNotFound = 'Ressource %s non trouvée';
  SSeekNotImplemented = '%s.Positionnement non implémenté';
  SSortedListError = 'Opération non autorisée dans une liste ordonnée';
  SStringExpected = 'Chaîne attendue';
  SSymbolExpected = '%s attendu';
  STimeEncodeError = 'Argument incorrect pour l''encodage de l''heure';
  STooManyDeleted = 'Trop de lignes ou colonnes supprimées';
  SUnknownGroup = '%s n''est pas dans un groupe de recensement de classes';
  SUnknownProperty = 'La propriété %s n''existe pas';
  SWriteError = 'Erreur d''écriture dans le flux';
  SStreamSetSize = 'Erreur lors de la définition de la taille du flux';
  SThreadCreateError = 'Erreur de création de thread : %s';
  SThreadError = 'Erreur de thread : %s (%d)';

  SInvalidDateDay = '(%d, %d) n''est pas une paire DateDay correcte.';
  SInvalidDateWeek = '(%d, %d, %d) n''est pas un triplet DateWeek correct.';
  SInvalidDateMonthWeek = '(%d, %d, %d, %d) n''est pas un quad DateMonthWeek correct.';
  SInvalidDayOfWeekInMonth = '(%d, %d, %d, %d) n''est pas un quad DayOfWeekInMonth correct.';
  SInvalidJulianDate = '%f Julien ne peut pas être représenté en tant que DateTime.';
  SMissingDateTimeField = ' ?';

  SConvIncompatibleTypes2 = 'Types de conversion incompatibles [%s, %s]';
  SConvIncompatibleTypes3 = 'Types de conversion incompatibles [%s, %s, %s]';
  SConvIncompatibleTypes4 = 'Types de conversion incompatibles [%s - %s, %s - %s]';
  SConvUnknownType = 'Type de conversion %s inconnu';
  SConvDuplicateType = 'Le type de conversion (%s) est déjà recensé dans %s.';
  SConvUnknownFamily = 'Famille de conversion %s inconnue';
  SConvDuplicateFamily = 'Famille de conversion (%s) déjà recensée';
  SConvUnknownDescription = '[%.8x]';
  SConvIllegalType = 'Type incorrect';
  SConvIllegalFamily = 'Famille incorrecte';
  SConvFactorZero = '%s a un facteur de zéro.';
  SConvStrParseError = 'Impossible d''analyser %s';
  SFailedToCallConstructor = 'Le %s décroissant de TStrings n''a pas réussi à appeler le constructeur hérité.';

  sWindowsSocketError = 'Erreur socket Windows : %s (%d), avec l''API ''%s''';
  sAsyncSocketError = 'Erreur socket asynchrone %d';
  sNoAddress = 'Aucune adresse spécifiée';
  sCannotListenOnOpen = 'Ecoute impossible sur un socket ouvert';
  sCannotCreateSocket = 'Impossible de créer le nouveau socket';
  sSocketAlreadyOpen = 'Socket déjà ouvert';
  sCantChangeWhileActive = 'Modification de valeur impossible lorsque le socket est actif';
  sSocketMustBeBlocking = 'Le socket doit être en mode bloquant';
  sSocketIOError = '%s erreur %d, %s';
  sSocketRead = 'Lecture';
  sSocketWrite = 'Ecriture';

implementation

end.
