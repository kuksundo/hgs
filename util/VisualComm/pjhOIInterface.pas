unit pjhOIInterface;

interface

uses
  Windows, Messages, SysUtils, Classes, vcl.Graphics, vcl.Controls, vcl.Forms,
  vcl.Dialogs
  ,pjhPropInsp;

type
  IbplOIInterface = interface ['{2A28C983-25E3-408A-82C1-659714DB7340}']
    function GetMainForm: TForm;
    procedure SetMainForm(const Value: TForm);
    function GetDoc: TWincontrol;
    procedure SetDoc(const Value: TWincontrol);
    function GetOIVisible: Boolean;
    procedure SetOIVisible(const Value: Boolean);
    function GetDeleteControlName: string;
    procedure SetDeleteControlName(const Value: string);
    function GetIsOnDelete: Boolean;
    procedure SetIsOnDelete(const Value: Boolean);
    function GetPropInspComp: TpjhPropertyInspector;
    function GetIsNormalWork: Boolean;
    procedure SetIsNormalWork(const Value: Boolean);

    procedure ClearObjOfCombo;
    procedure FillObjList2Combo;
		procedure RefreshObjListOfCombo(SelectedObj: TControl = nil);
    procedure FillDisplayPropName(DisplayCompList, DisplayPropList: TStrings);
    procedure OI_AssignObjects(AObjects: TList);
    procedure OI_Modified;
    procedure SetDesigner4PropInsp(ADesigner: Pointer);

    property MainForm: TForm read GetMainForm write SetMainForm;
    property Doc: TWincontrol read GetDoc write SetDoc;
    property OIVisible: Boolean read GetOIVisible write SetOIVisible;
    property DeleteControlName: string read GetDeleteControlName write SetDeleteControlName;
    property IsOnDelete: Boolean read GetIsOnDelete write SetIsOnDelete;
    property PropInspComp: TpjhPropertyInspector read GetPropInspComp;
    property IsNormalWork: Boolean read GetIsNormalWork write SetIsNormalWork;
  end;

implementation

end.
