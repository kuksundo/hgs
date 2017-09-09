{   MPUI, an MPlayer frontend for Windows
    Copyright (C) 2008-2010 Visenri
    Original source code (2005) by Martin J. Fiedler <martin.fiedler@gmx.net>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit UfrmHelp;

interface

uses
  Windows, Classes, Graphics, Controls, Forms, FormLocal,
  StdCtrls, Locale;

type
  TfrmHelp = class(TFormLocal)
    HelpText: TMemo;
    BClose: TButton;
    RefLabel: TLabel;
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  protected

  public
    { Public declarations }
    procedure DoLocalize(); override;
  end;

var
  frmHelp: TfrmHelp;

implementation

uses UfrmMain;

{$R *.dfm}

procedure TfrmHelp.BCloseClick(Sender: TObject);
begin
  Close;
end;
procedure TfrmHelp.DoLocalize;
var NeededHeight:integer;
begin
  inherited;
  Font.Charset:=CurrentLocaleCharset;

  Caption:=LOCstr.HelpFormCaption;
  HelpText.Text:=LOCstr.HelpFormHelpText;
  BClose.Caption:=LOCstr.HelpFormClose;

  NeededHeight:=RefLabel.Height*HelpText.Lines.Count;
  Height:=Height-HelpText.Height+NeededHeight;
end;

procedure TfrmHelp.FormHide(Sender: TObject);
begin
  frmMain.MKeyHelp.Checked := false;
end;

procedure TfrmHelp.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_ESCAPE then
    Close;
end;

procedure TfrmHelp.FormShow(Sender: TObject);
begin
  frmMain.MKeyHelp.Checked := true;
end;

end.
