{ *********************************************************************** }
{                                                                         }
{ Delphi Runtime Library                                                  }
{                                                                         }
{ Copyright (c) 1999-2001 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit ComConst;

interface

resourcestring
  SCreateRegKeyError = 'Erreur à la création de l''entrée de registre système';
  SOleError = 'Erreur OLE %.8x';
  SObjectFactoryMissing = 'Fabrique d''objets manquante pour la classe %s';
  STypeInfoMissing = 'Informations de type manquantes pour la classe %s';
  SBadTypeInfo = 'Informations de type incorrectes pour la classe %s';
  SDispIntfMissing = 'Interface dispatch manquante dans la classe %s';
  SNoMethod = 'Méthode ''%s'' non supportée par l''objet Automation';
  SVarNotObject = 'Le variant ne référence pas un objet Automation';
  STooManyParams = 'Les méthodes Dispatch ne gèrent pas plus de 64 paramètres';
  SDCOMNotInstalled = 'DCOM non installé';
  SDAXError = 'Erreur DAX';

  SAutomationWarning = 'Avertissement du serveur COM';
  SNoCloseActiveServer1 = 'Il y a encore des serveurs COM actifs dans cette ' +
    'application.  Un ou plusieurs clients ont peut-être des références à ces objets. ' +
    'La fermeture manuelle de ';
  SNoCloseActiveServer2 = 'cette application peut donc provoquer des erreurs ' +
    'dans les clients.'#13#10#13#10'Etes-vous sûr de vouloir fermer cette ' +
    'application ?';

implementation

end.
