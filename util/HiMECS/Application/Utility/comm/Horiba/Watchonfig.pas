unit Watchonfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Spin, Buttons, Mask;

type
  TWatchConfigF = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet3: TTabSheet;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    FilenameEdit: TEdit;
    btnSrc: TButton;
    procedure btnSrcClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WatchConfigF: TWatchConfigF;

implementation

{$R *.dfm}

procedure TWatchConfigF.btnSrcClick(Sender: TObject);
var S:string;
begin
  if FilenameEdit.Text <> '' then
    S := ExtractFilePath(FilenameEdit.Text)
  else
    S := GetCurrentDir;
    
  with TOpenDialog.Create(self) do
  try

    InitialDir := S;
    Title := 'Select xml file';
    Filename := FilenameEdit.Text;
    if Execute then
      FilenameEdit.Text := Filename;
  finally
    Free;
  end;
end;

end.
