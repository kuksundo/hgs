unit uMailManager;

interface

uses
  Classes, ComCtrls,
  uPreview, uMailItems,
  IdResourceStringsProtocols, IdMessage, IdComponent;

//type
  //TMailManager = Class (TComponent) //Changed from TObject
  //private
    //FPreview : Boolean;
    //FMsgRead : integer;


  //end;

implementation
  uses
    //Delphi
    SysUtils, Forms, Dialogs,
    //CoolTray
    CoolTrayIcon,
    //Indy
    IdEMailAddress, IdMessageClient,
    //PopTrayU
    uGlobal, uTranslate, uIniSettings;


end.
