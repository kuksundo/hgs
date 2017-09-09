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
  SUnknown = '<inconnu>';
  SInvalidInteger = '''%s'' n''est pas une valeur entière correcte';
  SInvalidFloat = '''%s'' n''est pas une valeur en virgule flottante correcte';
  SInvalidCurrency = '''%s'' n''est pas une valeur monétaire correcte';
  SInvalidDate = '''%s'' n''est pas une date correcte';
  SInvalidTime = '''%s'' n''est pas une heure correcte';
  SInvalidDateTime = '''%s'' ne correspond pas à une date et une heure correctes';
  SInvalidDateTimeFloat = '''%g'' ne correspond pas à une date et une heure correctes';
  SInvalidTimeStamp = '''%d.%d'' n''est pas une heure correcte';
  SInvalidGUID = '''%s'' n''est pas une valeur GUID correcte';
  SInvalidBoolean = '''%s'' n''est pas une valeur booléenne';
  STimeEncodeError = 'Argument incorrect pour l''encodage de l''heure';
  SDateEncodeError = 'Argument incorrect pour l''encodage de date';
  SOutOfMemory = 'Mémoire insuffisante';
  SInOutError = 'Erreur E/S %d';
  SFileNotFound = 'Fichier introuvable';
  SInvalidFilename = 'Nom de fichier incorrect';
  STooManyOpenFiles = 'Trop de fichiers ouverts';
  SAccessDenied = 'Accès au fichier refusé';
  SEndOfFile = 'Lecture au-delà de la fin de fichier';
  SDiskFull = 'Disque plein';
  SInvalidInput = 'Saisie numérique incorrecte';
  SDivByZero = 'Division par zéro';
  SRangeError = 'Erreur de vérification d''étendue';
  SIntOverflow = 'Débordement d''entier';
  SInvalidOp = 'Opération en virgule flottante incorrecte';
  SZeroDivide = 'Division par zéro en virgule flottante';
  SOverflow = 'Débordement en virgule flottante';
  SUnderflow = 'Débordement inférieur flottant';
  SInvalidPointer = 'Opération de pointeur incorrecte';
  SInvalidCast = 'Transtypage de classe incorrect';
{$IFDEF MSWINDOWS}
  SAccessViolation = 'Violation d''accès à l''adresse %p. %s de l''adresse %p';
{$ENDIF}
{$IFDEF LINUX}
  SAccessViolation = 'Violation d''accès à l''adresse %p, accès à l''adresse %p en cours';
{$ENDIF}
  SStackOverflow = 'Débordement de pile';
  SControlC = 'Frappe de Contrôle-C';
  SQuit = 'Frappes de la touche de sortie';
  SPrivilege = 'Instruction privilégiée';
  SOperationAborted = 'Opération abandonnée';
  SException = 'Exception %s dans le module %s dans %p.' + sLineBreak + '%s%s' + sLineBreak;
  SExceptTitle = 'Erreur d''application';
{$IFDEF LINUX}
  SSigactionFailed = 'Echec de l''appel sigaction';
{$ENDIF}
  SInvalidFormat = 'Le format ''%s'' est incorrect ou incompatible avec l''argument';
  SArgumentMissing = 'Aucun argument pour le format ''%s''';
  SDispatchError = 'Appels de méthode variante non supportés';
  SReadAccess = 'Lecture';
  SWriteAccess = 'Ecriture';
  SResultTooLong = 'Résultat de format supérieur à 4096 caractères';
  SFormatTooLong = 'Chaîne de format trop longue';

  SVarArrayCreate = 'Erreur lors de la création de tableau de variants';
  SVarArrayBounds = 'Indice de tableau de variants hors limites';
  SVarArrayLocked = 'Le tableau de variant est verrouillé';

  SInvalidVarCast = 'Conversion de type variant incorrecte';
  SInvalidVarOp = 'Opération de variant incorrecte';
  SInvalidVarOpWithHResult = 'Opération variant incorrecte ($%.8x)';

  SVarNotArray = 'Le variant n''est pas un tableau' deprecated; // use SVarInvalid
  SVarTypeUnknown = 'Type de variant personnalisé inconnu (%.4x)' deprecated; // not used anymore

  SVarTypeOutOfRange = 'Type de variant personnalisé (%.4x) hors limites';
  SVarTypeAlreadyUsed = 'Type de variant personnalisé (%.4x) déjà utilisé par %s';
  SVarTypeNotUsable = 'Le type de variant personnalisé (%.4x) n''est pas utilisable';
  SVarTypeTooManyCustom = 'Trop de types de variants personnalisés ont été enregistrés';

  SVarTypeCouldNotConvert = 'Impossible de convertir le variant de type (%s) en type (%s)';
  SVarTypeConvertOverflow = 'Débordement lors de la conversion du variant de type (%s) en type (%s)';
  SVarOverflow = 'Débordement de variant';
  SVarInvalid = 'Argument incorrect';
  SVarBadType = 'Type de variant incorrect';
  SVarNotImplemented = 'Opération non supportée';
  SVarOutOfMemory = 'Mémoire insuffisante pour l''opération variant';
  SVarUnexpected = 'Erreur de variant inattendue';

  SVarDataClearRecursing = 'Récursivité pendant une opération VarDataClear';
  SVarDataCopyRecursing = 'Récursivité pendant une opération VarDataCopy';
  SVarDataCopyNoIndRecursing = 'Récursivité pendant une opération VarDataCopyNoInd';
  SVarDataInitRecursing = 'Récursivité pendant une opération VarDataInit';
  SVarDataCastToRecursing = 'Récursivité pendant une opération VarDataCastTo';
  SVarIsEmpty = 'Le variant est vide';
  sUnknownFromType = 'Conversion impossible à partir du type spécifié';
  sUnknownToType = 'Conversion impossible vers le type spécifié';
  SExternalException = 'Exception externe %x';
  SAssertionFailed = 'Echec de l''assertion';
  SIntfCastError = 'Interface non supportée';
  SSafecallException = 'Exception dans méthode safecall';
  SAssertError = '%s (%s, ligne %d)';
  SAbstractError = 'Erreur abstraite';
  SModuleAccessViolation = 'Violation d''accès à l''adresse %p dans le module ''%s''. %s de l''adresse %p';
  SCannotReadPackageInfo = 'Impossible d''accéder à l''information de paquet pour le paquet ''%s''';
  sErrorLoadingPackage = 'Impossible de charger le paquet %s.'+sLineBreak+'%s';
  SInvalidPackageFile = 'Fichier paquet ''%s'' incorrect';
  SInvalidPackageHandle = 'Handle de paquet incorrect';
  SDuplicatePackageUnit = 'Impossible de charger le paquet ''%s.''  Il contient l''unité ''%s,''' +
    'qui est aussi contenue dans le paquet ''%s''';
  SOSError = 'Erreur système.  Code : %d.'+sLineBreak+'%s';
  SUnkOSError = 'Un appel à une fonction du système d''exploitation a échoué';
{$IFDEF MSWINDOWS}
  SWin32Error = 'Erreur Win32.  Code : %d.'#10'%s' deprecated; // use SOSError
  SUnkWin32Error = 'Une fonction de l''API Win32 a échoué' deprecated; // use SUnkOSError
{$ENDIF}
  SNL = 'L''application n''a pas de licence pour cette fonctionnalité';

  SConvIncompatibleTypes2 = 'Types de conversion incompatibles [%s, %s]';
  SConvIncompatibleTypes3 = 'Types de conversion incompatibles [%s, %s, %s]';
  SConvIncompatibleTypes4 = 'Types de conversion incompatibles [%s - %s, %s - %s]';
  SConvUnknownType = 'Type de conversion %s inconnu';
  SConvDuplicateType = 'Type de conversion (%s) déjà recensé';
  SConvUnknownFamily = 'Famille de conversion %s inconnue';
  SConvDuplicateFamily = 'Famille de conversion (%s) déjà recensée';
  SConvUnknownDescription = '[%.8x]';
  SConvIllegalType = 'Type incorrect';
  SConvIllegalFamily = 'Famille incorrecte';
  SConvFactorZero = '%s a un facteur de zéro';

  SShortMonthNameJan = 'Jan';
  SShortMonthNameFeb = 'Fév';
  SShortMonthNameMar = 'Mar';
  SShortMonthNameApr = 'Avr';
  SShortMonthNameMay = 'Mai';
  SShortMonthNameJun = 'Jun';
  SShortMonthNameJul = 'Jul';
  SShortMonthNameAug = 'Aoû';
  SShortMonthNameSep = 'Sep';
  SShortMonthNameOct = 'Oct';
  SShortMonthNameNov = 'Nov';
  SShortMonthNameDec = 'Déc';

  SLongMonthNameJan = 'Janvier';
  SLongMonthNameFeb = 'Février';
  SLongMonthNameMar = 'Mars';
  SLongMonthNameApr = 'Avril';
  SLongMonthNameMay = 'Mai';
  SLongMonthNameJun = 'Juin';
  SLongMonthNameJul = 'Juillet';
  SLongMonthNameAug = 'Août';
  SLongMonthNameSep = 'Septembre';
  SLongMonthNameOct = 'Octobre';
  SLongMonthNameNov = 'Novembre';
  SLongMonthNameDec = 'Décembre';

  SShortDayNameSun = 'Dim';
  SShortDayNameMon = 'Lun';
  SShortDayNameTue = 'Mar';
  SShortDayNameWed = 'Mer';
  SShortDayNameThu = 'Jeu';
  SShortDayNameFri = 'Ven';
  SShortDayNameSat = 'Sam';

  SLongDayNameSun = 'Dimanche';
  SLongDayNameMon = 'Lundi';
  SLongDayNameTue = 'Mardi';
  SLongDayNameWed = 'Mercredi';
  SLongDayNameThu = 'Jeudi';
  SLongDayNameFri = 'Vendredi';
  SLongDayNameSat = 'Samedi';

{$IFDEF LINUX}
  SEraEntries = '';
{$ENDIF}

  SCannotCreateDir = 'Impossible de créer le répertoire';

implementation

end.
