unit resultDialog_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvExControls, JvLabel,
  Vcl.ImgList, AeroButtons, Vcl.Imaging.jpeg, Vcl.ExtCtrls, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid;

type
  TresultDialog_Frm = class(TForm)
    ImageList24x24: TImageList;
    JvLabel1: TJvLabel;
    Memo1: TMemo;
    AeroButton1: TAeroButton;
    Panel8: TPanel;
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  resultDialog_Frm: TresultDialog_Frm;
  function Create_resultDialog_Frm(aCaption:String) : String;

implementation

{$R *.dfm}

function Create_resultDialog_Frm(aCaption:String) : String;
begin
  resultDialog_Frm := TresultDialog_Frm.Create(nil);
  try
    Result := '';
    with resultDialog_Frm do
    begin
      JvLabel1.Caption := aCaption;

      ShowModal;

      if ModalResult = mrOk then
        Result := Memo1.Text;

    end;
  finally
    FreeAndNil(resultDialog_Frm);
  end;
end;

end.
