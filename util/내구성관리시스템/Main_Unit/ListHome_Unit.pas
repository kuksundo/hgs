unit ListHome_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, NxEdit, AdvSmoothPanel,
  WebImage, Vcl.Imaging.jpeg, Vcl.ExtCtrls, CurvyControls, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  NxCollection, JvExControls, JvNavigationPane, Vcl.Imaging.pngimage;

type
  TListHome_Frm = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    JvNavPanelHeader1: TJvNavPanelHeader;
    Label1: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ListHome_Frm: TListHome_Frm;

implementation

{$R *.dfm}

procedure TListHome_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TListHome_Frm.Timer1Timer(Sender: TObject);
begin
  Label1.Caption := FormatDateTime('yyyy-MM-dd HH:mm:ss',Now);
end;

end.
