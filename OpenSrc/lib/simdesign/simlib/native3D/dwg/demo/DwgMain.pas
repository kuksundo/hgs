unit DwgMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, sdDwgFormat, StdCtrls;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    OpenDWG1: TMenuItem;
    mmStatus: TMemo;
    chbSuppress: TCheckBox;
    Label1: TLabel;
    procedure OpenDWG1Click(Sender: TObject);
  private
    { Private declarations }
    procedure DwgStatus(Sender: TObject; const AMessage: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.DwgStatus(Sender: TObject; const AMessage: string);
begin
  if not chbSuppress.Checked then
    mmStatus.Lines.Add(AMessage);
  Application.ProcessMessages;
end;

procedure TForm1.OpenDWG1Click(Sender: TObject);
var
  ADwg: TDwgFormat;
begin
  ADwg := TDwgFormat.Create(nil);
  try
    with TOpenDialog.Create(nil) do
      try
        Filter := 'DWG files (*.dwg)|*.dwg';
        if Execute then begin
          Label1.Caption := 'Load started';
          ADwg.OnStatus := DwgStatus;
          ADwg.LoadFromFile(FileName);
          Label1.Caption := 'Load finished';
        end;
      finally
        Free;
      end;
  finally
    ADwg.Free;
  end;
end;

end.
