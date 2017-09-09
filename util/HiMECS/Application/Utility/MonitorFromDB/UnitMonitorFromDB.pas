unit UnitMonitorFromDB;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, UnitFrameMonitorFromDB,
  Vcl.ExtCtrls, Vcl.StdCtrls, UnitStrMsg.EventThreads;

type
  TMonitorFromDBF = class(TForm)
    PopupMenu1: TPopupMenu;
    Config1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    TMDFromDBFrame: TTFrameIPCClientFromDB;
    Button1: TButton;
    Splitter1: TSplitter;
    Memo1: TMemo;
    procedure Config1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  public
    procedure DisplayMessage(msg: string; ADspNo: integer);
  end;

var
  MonitorFromDBF: TMonitorFromDBF;

implementation

{$R *.dfm}

procedure TMonitorFromDBF.Button1Click(Sender: TObject);
begin
  StrMsgEventThread.FDisplayMsgProc := DisplayMessage;
  TMDFromDBFrame.Timer1.Enabled := True;
end;

procedure TMonitorFromDBF.Config1Click(Sender: TObject);
begin
  TMDFromDBFrame.MFDBConfig;
end;

procedure TMonitorFromDBF.DisplayMessage(msg: string; ADspNo: integer);
begin
  if msg = ' ' then
    exit;

  case ADspNo of
    0: Memo1.Lines.Add(msg);
    1: Memo1.Lines.Add(msg);
  end;
end;

end.
