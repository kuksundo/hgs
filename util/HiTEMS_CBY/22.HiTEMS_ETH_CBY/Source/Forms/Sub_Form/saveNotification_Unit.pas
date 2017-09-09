unit saveNotification_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvGroupBox,
  AdvOfficeButtons, Vcl.ImgList, Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TsaveNotification_Frm = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Image1: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    AdvOfficeRadioGroup1: TAdvOfficeRadioGroup;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  saveNotification_Frm: TsaveNotification_Frm;
  function Create_Notification(aIdx:integer) : Integer;

implementation

{$R *.dfm}

{ TForm1 }

function Create_Notification(aIdx: integer): Integer;
begin
  with TsaveNotification_Frm.Create(Application) do
  begin
    try
      AdvOfficeRadioGroup1.ItemIndex := aIdx;
      if ShowModal = mrOk then
        Result := AdvOfficeRadioGroup1.ItemIndex;
    finally
      Free;
    end;
  end;
end;

end.
