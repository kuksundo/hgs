unit progress_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvExControls,
  JvAnimatedImage, JvGIFCtrl, Vcl.ExtCtrls, Vcl.Imaging.pngimage;
type
  Tprogress_Frm = class(TForm)
    JvGIFAnimator1: TJvGIFAnimator;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }

  end;



var
  progress_Frm: Tprogress_Frm;
  procedure Create_Progress;


implementation

{$R *.dfm}
procedure Create_Progress;
begin
  progress_Frm := Tprogress_Frm.Create(nil);
  progress_Frm.Show;

end;

procedure Tprogress_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
