unit ParserTestU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, mwPascalParser;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
  private
    Parser: TmwPascalParser;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
     Parser:= TmwPascalParser.Create(ExtractFileName(OpenDialog1.FileName), nil);
     Parser.GoIntoUnits:= True;
     Parser.UseSearchPaths:= True;
     Parser.SearchPaths.Add('C:\Program Files\Borland\Delphi7\Source\VCL\');
     Parser.SearchPaths.Add('C:\Program Files\Borland\Delphi7\Source\RTL\SYS\');
     Parser.SearchPaths.Add('C:\Program Files\Borland\Delphi7\Source\RTL\WIN\');
     Parser.Parse;
     Memo1.Lines:= Parser.UnitList;
     Form1.Caption:= 'Parsed ' + IntToStr(Parser.UnitList.Count);
     Parser.Free;
  end;
end;

end.
