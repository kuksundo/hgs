unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, mwPasLex,
  StdCtrls, mwFastTime, ExtCtrls, mwPasLexTypes, mwCustomEdit;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    Time1: TmwFastTime;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    mwCustomEdit1: TmwCustomEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TreminateStream;
  private
    Stream: TMemoryStream;
    Lex: TmwPasLex;
    aChar: Char;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Stream := TMemoryStream.Create;
  Lex := TmwPasLex.Create;
  mwCustomEdit1.ReadOnly:= True;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Lex.Free;
  Stream.Free;
end;

procedure TForm1.TreminateStream;
begin
  Stream.Position := Stream.Size;
  Stream.Write(aChar, 1);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  OpenDialog1.Options := OpenDialog1.Options - [ofAllowMultiSelect];
  if OpenDialog1.Execute then
  begin
    mwCustomEdit1.Text:= '';
    Time1.Start;
    Stream.LoadFromFile(OpenDialog1.FileName);
    TreminateStream;
    Lex.Origin := Stream.Memory;
    mwCustomEdit1.Lines.BeginUpdate;
    while Lex.TokenID in [ptAnsiComment, ptBorComment, ptCRLF, ptCRLFCo,
      ptSlashesComment, ptSpace] do Lex.Next;
    while Lex.TokenId <> ptNull do
    begin
      Case Lex.TokenID of
        ptIdentifier: mwCustomEdit1.Lines.Add(Lex.Token + '               ' +
            ptTokenName(Lex.TokenID) + '               ' + ptTokenName(Lex.ExID));
      else mwCustomEdit1.Lines.Add(Lex.Token + '               ' + ptTokenName(Lex.TokenID));
      end;
      Lex.NextNoJunk;
    end;
    mwCustomEdit1.Lines.Add(Lex.Token + '               ' + ptTokenName(Lex.TokenID));
    mwCustomEdit1.Lines.EndUpdate;
    Time1.Stop;
    Form1.Caption := Time1.ElapsedTime + '  Count: ' + IntToStr(mwCustomEdit1.Lines.Count);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Count: Integer;
  I: Integer;
  FileName: String;
begin
  OpenDialog1.Options := OpenDialog1.Options + [ofAllowMultiSelect];
  if OpenDialog1.Execute then
  begin
    mwCustomEdit1.Text:= '';
    Count := 0;
    Time1.Start;
    I := 0;
    while I < OpenDialog1.Files.Count do
    begin
      Stream.Clear;
      FileName := ExtractFileName(OpenDialog1.Files[I]);
      Stream.LoadFromFile(FileName);
      TreminateStream;
      Lex.Origin := Stream.Memory;
      inc(Count);
      while Lex.TokenId <> ptNull do
      begin
        Lex.Next;
        inc(Count);
      end;
      inc(I);
    end;
    Time1.Stop;
    Form1.Caption := Time1.ElapsedTime + '  TokenCount: ' + IntToStr(Count) +
      '  UnitCount: ' + IntToStr(OpenDialog1.Files.Count);
  end;
end;

end.

  