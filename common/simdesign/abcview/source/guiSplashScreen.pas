{ unit SplashScr

  Splash screen at startup

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit guiSplashScreen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RxGrdCpt, StdCtrls, Buttons, ComCtrls, Registry,  ShellAPI, sdAbcTypes,
  sdAbcVars;

type
  TfrmSplash = class(TForm)
    reInfo: TRichEdit;
    btnOK: TBitBtn;
    lblCount: TLabel;
    btnRegister: TBitBtn;
    btnWeb: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnWebClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure reInfoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSplash: TfrmSplash;

implementation

uses

  guiMain, Encrypt;

{$R *.DFM}

procedure TfrmSplash.FormShow(Sender: TObject);
begin
  reInfo.Lines.LoadFromFile(FAppFolder + 'splash.rtf');
end;

procedure TfrmSplash.btnOKClick(Sender: TObject);
begin

{  if FMustRegister then
  begin

    case MessageDlg(
      'You must register your software first before you can'#13+
      'continue using it, because the trial period is over.'#13#13+
      'Please click on the [Register] button for more information or'#13+
      '[Cancel] to quit.',
       mtInformation, [mbOK, mbCancel], 0) of
    mrOK: exit;
    mrCancel: Application.Terminate;
    end;//case
  end;}
  Close;
end;

procedure TfrmSplash.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
{  if FMustRegister then
    Application.Terminate;}
end;

procedure TfrmSplash.btnWebClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', pchar(cWebAddress),
  nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmSplash.btnRegisterClick(Sender: TObject);
begin
{  with TRegDialog.Create(nil) do
    try
      ShowModal;
    finally
      Free;
    end;}
end;

procedure TfrmSplash.reInfoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Mouse down in this edit means to open a link to purchase
  ShellExecute(Handle, 'open', pchar(cBuyLink),
  nil, nil, SW_SHOWNORMAL);
end;

end.
