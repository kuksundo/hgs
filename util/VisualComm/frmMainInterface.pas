unit frmMainInterface;

interface

uses
  Windows, Messages, SysUtils, Classes, vcl.Graphics, vcl.Controls, vcl.Forms,
  vcl.Dialogs,
  Vcl.ActnList, pjhFormDesigner;//, JvComponentBase, JvDockControlForm;

type
  IbplMainInterface = interface ['{E8CE52C6-143B-413C-9179-A234116D7155}']
    function GetBplOwner: TWinControl;
    procedure SetBplOwner(Value: TWinControl);
    function GetELDesigner: TELDesigner;
    //function GetActionList: TActionList;
    function GetMainHandle: THandle;
    function GetSaveDialog: TSaveDialog;
    procedure AdjustChangeSelection;
    procedure PrepareOIInterface(LControl: TWinControl);
    procedure DestroyOIInterface;
    procedure GetTagNames(ATagNameList, ADescriptList: TStringList);
    procedure InitializePackage;
    //procedure SetDockStyle(ADockStyle: TJvDockBasicStyle);

    property BplOwner: TWinControl read GetBplOwner write SetBplOwner;
    property Designer: TELDesigner read GetELDesigner;
    //property ActionList: TActionList read GetActionList;
    property MainHandle: THandle read GetMainHandle;
    property SaveDialog: TSaveDialog read GetSaveDialog;
  end;

implementation

end.
