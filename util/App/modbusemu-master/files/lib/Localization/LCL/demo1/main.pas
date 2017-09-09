unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LCLTranslator, ExtCtrls, LocalizedForms;

type
  TForm1 = class(TLocalizedForm)
    Button1  : TButton;
    Label1 : TLabel;
    Label2 : TLabel;
    ListBox1 : TListBox;
    RadioGroup1 : TRadioGroup;
    procedure FormCreate(Sender : TObject);
    procedure RadioGroup1Click(Sender : TObject);
  protected
    procedure UpdateTranslation(ALang: String); override;
    procedure SelectLang(ALang : AnsiString);
  public
    { public declarations }
  end;

var
  Form1 : TForm1;

implementation

uses TranslateResStr;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender : TObject);
var TempDefLang : AnsiString;
begin
  TempDefLang := GetDefaultLang;
  Label1.Caption := TempDefLang;
  SelectLang(TempDefLang);
end;

procedure TForm1.RadioGroup1Click(Sender : TObject);
var TempLang : AnsiString;
begin
  TempLang := RadioGroup1.Items.Strings[RadioGroup1.ItemIndex];
  SelectLang(TempLang);
  Label1.Caption := TempLang;
end;

procedure TForm1.UpdateTranslation(ALang : String);
begin
  inherited;
  ListBox1.Items.Strings[0] := rsListVal1;
  ListBox1.Items.Strings[1] := rsListVal2;
  ListBox1.Items.Strings[2] := rsListVal3;
  Label2.Caption := '1';
end;

procedure TForm1.SelectLang(ALang : AnsiString);
begin
  SetDefaultLang(ALang);
  UpdateFormatSettings(ALang);
  UpdateBiDiMode(ALang);
  UpdateTranslation(ALang);
end;

end.

