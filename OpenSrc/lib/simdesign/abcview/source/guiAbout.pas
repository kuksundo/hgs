{ Unitname: Abouts

  Description:
  This unit incorporates an about box.

  See comments in source code for more detailed documentation.

  Created  on: 01-05-1999

  Modifications:
  09-2000: Adapted for ABCVM

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 1999 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, Buttons, ExtCtrls, RXCtrls;

type
  TfrmAbout = class(TForm)
    OKButton: TBitBtn;
    Panel1: TPanel;
    Image1: TImage;
    RxLabel1: TRxLabel;
    lblVersion: TLabel;
    EmailButton: TBitBtn;
    Panel2: TPanel;
    Label4: TLabel;
    RxLabel3: TRxLabel;
    RxLabel2: TRxLabel;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure EmailButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses ShellAPI, guiMain, RxConst, sdAbcTypes;

{$R *.DFM}

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  // Version info
  RxLabel1.Caption:='Version ' + cVersionName + '  ';

  // Clickable image
  RxLabel3.Cursor:=crHand;

  // Version
  lblVersion.Caption := cUnregVersion;
  
end;

procedure TfrmAbout.OKButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.EmailButtonClick(Sender: TObject);
begin
  ShellExecute(Handle,'open',pchar(cMailtoInfo),
  nil,nil,SW_SHOWNORMAL)
end;

procedure TfrmAbout.FormActivate(Sender: TObject);
begin
//  if FRegistered then
    lblVersion.Caption := cRegVersion
//  else
//    lblVersion.Caption := cUnregVersion;
end;

end.
