unit newComment_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvExControls, JvLabel;

type
  TnewComment_Frm = class(TForm)
    JvLabel2: TJvLabel;
    Memo1: TMemo;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  newComment_Frm: TnewComment_Frm;
  function Create_modifyCause_Frm(aCaption:String):String;

implementation

{$R *.dfm}

function Create_modifyCause_Frm(aCaption:String):String;
begin
  modifyCause_Frm := TmodifyCause_Frm.Create(nil);
  with modifyCause_Frm do
  begin
    JvLabel2.Caption := aCaption;
    try
      ShowModal;
    finally
      if modifyCause_Frm.ModalResult = mrOk then
        Result := memo1.Text
      else
        Result := '';
    end;
  end;
end;

end.
