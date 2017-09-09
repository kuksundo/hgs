{ unit RemindClose

  Message upon closing application (trial)

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!
}
unit RemindClose;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, sdAbcTypes;

type
  TfrmRemindClose = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btnTellFriend: TBitBtn;
    Button1: TButton;
    btnBuyNow: TBitBtn;
    procedure btnBuyNowClick(Sender: TObject);
    procedure btnTellFriendClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRemindClose: TfrmRemindClose;

implementation

{$R *.DFM}

uses
  ShellApi{, GlobalVars};

procedure TfrmRemindClose.btnBuyNowClick(Sender: TObject);
begin
  ShellExecute(Handle,'open', pchar(cBuyLink),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmRemindClose.btnTellFriendClick(Sender: TObject);
begin
  ShellExecute(Handle,'open', pchar(cWebTellFriend),
    nil, nil, SW_SHOWNORMAL);
end;

end.
