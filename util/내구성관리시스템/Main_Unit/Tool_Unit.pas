unit Tool_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  Vcl.ComCtrls, Vcl.StdCtrls, CurvyControls, AdvGlowButton, Vcl.ExtCtrls,
  AdvPanel, NxCollection;

type
  TTool_Frm = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    AdvPanel1: TAdvPanel;
    CurvyPanel1: TCurvyPanel;
    Panel2: TPanel;
    Button2: TButton;
    CurvyPanel2: TCurvyPanel;
    AdvGlowButton3: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    AdvGlowButton1: TAdvGlowButton;
    toolstock: TCurvyCombo;
    toolsize: TCurvyEdit;
    toolname: TCurvyEdit;
    toolno: TCurvyEdit;
    CurvyPanel3: TCurvyPanel;
    CurvyPanel4: TCurvyPanel;
    Panel36: TPanel;
    value: TEdit;
    Panel35: TPanel;
    Edit1: TEdit;
    DateTimePicker1: TDateTimePicker;
    ToolGrid: TAdvStringGrid;
    Panel32: TPanel;
    Button14: TButton;
    Button1: TButton;
    Button4: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Tool_Frm: TTool_Frm;

implementation

{$R *.dfm}

end.
