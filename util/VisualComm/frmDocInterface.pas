unit frmDocInterface;

interface

uses
  Windows, Messages, SysUtils, Classes, vcl.Graphics, vcl.Controls, vcl.Forms,
  vcl.Dialogs;

type
  IbplDocInterface = interface ['{25BFA31F-E1B3-4008-81C1-88AF8374689F}']
    procedure Save;
    function SaveAs(AFileName: string): Boolean;
    function ICreateDocument(AOwner: TComponent; AFileName: string): TForm;
    function IGetDocument: TForm;
    procedure Modify;

    function GetMainForm: TForm;
    procedure SetMainForm(const Value: TForm);
    function GetFileName: String;
    procedure SetFileName(AValue: String);
    function GetFormCaption: String;
    procedure SetFormCaption(AValue: String);
    function GetModified: Boolean;
    procedure SetModified(AValue: Boolean);
    function GetIsDesignMode: Boolean;
    procedure SetIsDesignMode(AValue: Boolean);
    function GetOIForm: TForm;
    procedure SetOIForm(AValue: TForm);

    property MainForm: TForm read GetMainForm write SetMainForm;
    property FileName: string read GetFileName write SetFileName;
    property FormCaption: string read GetFormCaption write SetFormCaption;
    property Modified: Boolean read GetModified write SetModified;
    property IsDesignMode: Boolean read GetIsDesignMode write SetIsDesignMode;
    property OIForm: TForm read GetOIForm write SetOIForm; //Create Document 시에 이 변수에 할당해 줘야 함
  end;

implementation

end.
