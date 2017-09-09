//Written with Delphi XE3 Pro
//Created Oct 12, 2012 by Darian Miller
//for http://stackoverflow.com/questions/12858551/delphi-xe2-indy-10-mutlithread-ping
unit DelphiVault.Examples.Indy10.PingClient.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  DelphiVault.Indy10.PingClient, IdIcmpClient;

type
  TMyPingThread = class(TThreadedPing)
  protected
    procedure SynchronizedResponse(const ReplyStatus:TReplyStatus); override;
  end;


  TfrmThreadedPingSample = class(TForm)
    edtHost: TEdit;
    butPING: TButton;
    Memo1: TMemo;
    butStartPing: TButton;
    procedure butPINGClick(Sender: TObject);
    procedure butStartPingClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure MyPingCallback(const ReplyStatus:TReplyStatus);
  end;

var
  frmThreadedPingSample: TfrmThreadedPingSample;

implementation

{$R *.dfm}

procedure TfrmThreadedPingSample.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
end;

procedure TfrmThreadedPingSample.butPINGClick(Sender: TObject);
begin
   //Example1: Ping with a given CallBack procedure.
  TPingClient.Ping(edtHost.Text, MyPingCallback);
end;

procedure TfrmThreadedPingSample.MyPingCallback(const ReplyStatus:TReplyStatus);
begin
  //Example1: Do something special with ReplyStatus. Here, we're just displaying
  //it in a memo using a utility method to format the response.
  Memo1.Lines.Add(TPingClient.FormatStandardResponse(ReplyStatus));
end;

procedure TfrmThreadedPingSample.butStartPingClick(Sender: TObject);
begin
  //Example2: Start some child threads to perform Pings
  TMyPingThread.Create('www.google.com');
  TMyPingThread.Create('127.0.0.1');
  TMyPingThread.Create('www.shouldnotresolvetoanythingatall.com');
  TMyPingThread.Create('127.0.0.1');
  TMyPingThread.Create('www.microsoft.com');
  TMyPingThread.Create('127.0.0.1');
end;

procedure TMyPingThread.SynchronizedResponse(const ReplyStatus:TReplyStatus);
begin
  //Example2: Do something special with ReplyStatus. Here, we're just displaying
  //it in a memo using a utility method to format the response.
  frmThreadedPingSample.Memo1.Lines.Add(TPingClient.FormatStandardResponse(ReplyStatus));
end;

end.
