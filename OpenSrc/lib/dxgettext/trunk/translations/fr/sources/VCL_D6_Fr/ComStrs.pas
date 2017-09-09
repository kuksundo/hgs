
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
  sTabFailClear = 'Echec à l''effacement du contrôle onglet';
  sTabFailDelete = 'Echec à la suppression de l''onglet d''indice %d';
  sTabFailRetrieve = 'Echec à la récupération de l''onglet d''indice %d';
  sTabFailGetObject = 'Echec à l''obtention de l''objet à l''indice %d';
  sTabFailSet = 'Echec pour mettre l''onglet "%s" à l''indice %d';
  sTabFailSetObject = 'Echec pour mettre l''objet à l''indice %d';
  sTabMustBeMultiLine = 'MultiLine doit être vrai lorsque TabPosition est tpLeft ou tpRight';

  sInvalidLevel = 'Affectation de niveau d''élément incorrecte';
  sInvalidLevelEx = 'Niveau incorrect (%d) pour l''élément "%s"';
  sInvalidIndex = 'Index incorrect';
  sInsertError = 'Impossible d''insérer un élément';

  sInvalidOwner = 'Propriétaire incorrect';
  sUnableToCreateColumn = 'Impossible de créer une nouvelle colonne';
  sUnableToCreateItem = 'Impossible de créer un nouvel élément';

  sRichEditInsertError = 'Erreur d''insertion de ligne RichEdit';
  sRichEditLoadFail = 'Erreur au chargement du flux';
  sRichEditSaveFail = 'Erreur à l''enregistrement du flux';

  sTooManyPanels = 'StatusBar ne peut avoir plus de 64 volets';

  sHKError = 'Erreur d''affectation de raccourci clavier à %s. %s';
  sHKInvalid = 'Raccourci clavier incorrect';
  sHKInvalidWindow = 'Fenêtre incorrecte ou fenêtre enfant';
  sHKAssigned = 'Raccourci clavier affecté à une autre fenêtre';

  sUDAssociated = '%s est déjà associé avec %s';

  sPageIndexError = '%d est une valeur de PageIndex incorrecte.  PageIndex doit être ' +
   'compris entre 0 et %d';

  sInvalidComCtl32 = 'Ce contrôle nécessite COMCTL32.DLL version 4.70 ou supérieure';

  sDateTimeMax = 'La date dépasse le maximum de %s';
  sDateTimeMin = 'La date est inférieure au minimum de %s';
  sNeedAllowNone = 'Vous devez être en mode ShowCheckBox pour définir cette date';
  sFailSetCalDateTime = 'Echec lors du paramétrage de l''heure ou de la date du calendrier';
  sFailSetCalMaxSelRange = 'Echec lors du paramétrage de l''étendue de sélection maximum';
  sFailSetCalMinMaxRange = 'Echec lors du paramétrage de l''étendue minimum/maximum du calendrier';
  sCalRangeNeedsMultiSelect = 'Une étendue de date ne peut être utilisée qu''en mode multisélection';
  sFailsetCalSelRange = 'Echec lors du paramétrage de l''étendue sélectionnée du calendrier';

implementation

end.
