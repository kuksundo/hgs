unit FileConfirm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExStdCtrls, JvCheckBox;

type
  TForm3 = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button4: TButton;
    Label1: TLabel;
    SaveDialog1: TSaveDialog;
    DontAskDnLdConfirmCB: TJvCheckBox;
    FileNameLbl: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Turn_Value : integer ;
    Turn_Fname : string ;
    FileName : string ;
    DontAskConfirm: Boolean;
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
   Turn_Value := 1 ;
   close ;
end;


procedure TForm3.Button2Click(Sender: TObject);
var
FileExt : string;
begin
  FileExt := ExtractFileExt(FileName);
  delete(FileExt , 1, 1);
  //ShowMessage(OptionStr + ' ,확장자 : ' + FileExt);
  SaveDialog1.FileName := FileName ;
  SaveDialog1.DefaultExt := FileExt ;
  SaveDialog1.Filter := '저장 확장자 (' + FileExt + ')' + '|*.' + FileExt ;
  SaveDialog1.InitialDir := ExtractFileDir(ParamStr(0)) ;
   if SaveDialog1.Execute then
   begin
      Turn_Fname := SaveDialog1.FileName ;
      Turn_Value := 2 ;
      close ;
   end;

end;


procedure TForm3.Button4Click(Sender: TObject);
begin
   Turn_Value := 3 ;
   close ;
end;

end.
