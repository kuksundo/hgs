unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QProgress, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdFTP, StdCtrls, ShellAPI, jpeg, ExtCtrls;
Const
  WM_ThreadEnd = WM_User+100;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    QProgress1: TQProgress;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure WMThreadEnd(var Msg: TMessage); message WM_ThreadEnd;
    procedure Timer1Timer(Sender: TObject);
 private
    { Private declarations }
  public
    { Public declarations }
    procedure Thread;

  end;

var
  Form1: TForm1;

implementation
uses Unit2;

var
  GetThread : TGetThread;
  LabelCount : Integer;

{$R *.dfm}

procedure TForm1.Thread;
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  QProgress1.Active := True;
  LabelCount := -1;

end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  GetThread := TGetThread.Create(false);


//  shellExecute(self.Handle, 'open', PChar('C:\temp\ETCM_System.exe'), '', '', SW_SHOWNORMAL);
end;

procedure TForm1.WMThreadEnd(var Msg: TMessage);
begin
  if Assigned(GetThread) then
    GetThread.Terminate;

  Close;


end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  with Label2 do
  begin
    if not(LabelCount > 2) then
      LabelCount := LabelCount + 1
    else
      LabelCount := -1;

    Case LabelCount of
     -1 : Caption := 'Start';
      0 : Caption := 'Start.';
      1 : Caption := 'Start..';
      2 : Caption := 'Start...';
    end;//case
  end;
end;

end.
