unit Himsen_Communicator_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, NxCollection,
  Vcl.ExtCtrls, NxEdit, AdvSmoothPanel, AdvSplitter, Vcl.Imaging.pngimage,
  Vcl.ComCtrls;

type
  THimsen_Communicator_Frm = class(TForm)
    Panel1: TPanel;
    AdvSmoothPanel3: TAdvSmoothPanel;
    NxSplitter1: TNxSplitter;
    NxButtonEdit1: TNxButtonEdit;
    NxSplitter2: TNxSplitter;
    AdvSmoothPanel1: TAdvSmoothPanel;
    AdvSplitter1: TAdvSplitter;
    Panel2: TPanel;
    Shape2: TShape;
    Label1: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    NxFlipPanel1: TNxFlipPanel;
    NxFlipPanel2: TNxFlipPanel;
    NxFlipPanel3: TNxFlipPanel;
    NxFlipPanel4: TNxFlipPanel;
    NxFlipPanel5: TNxFlipPanel;
    NxFlipPanel6: TNxFlipPanel;
    NxFlipPanel7: TNxFlipPanel;
    NxFlipPanel8: TNxFlipPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Himsen_Communicator_Frm: THimsen_Communicator_Frm;

implementation

uses DataModule_Unit;
{$R *.dfm}

end.
