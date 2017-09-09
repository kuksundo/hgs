unit Unit2;

interface

uses
  Classes, SysUtils, ShellAPI, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdFTP, Windows;

type
  TGetThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;

  end;

implementation
uses
  Unit1;


{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TGetThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TGetThread }

procedure TGetThread.Execute;
var
  LMS : TMemoryStream;
  IDFTP : TIDFTP;
begin
  if not Terminated then
  begin
    IDFTP := TidFTP.Create(nil);

    if idftp.Connected then exit;
    with IdFTP do
    begin
      host := '10.100.23.115';
      UserName := 'Anonymous';
      Connect;

      ChangeDir('HiTEMS/');

      LMS := TMemoryStream.Create;

      if not DirectoryExists('c:\temp') then
        if not CreateDir('C:\temp') then
        raise Exception.Create('Cannot create c:\temp');

      Get('HiTEMS.exe',LMS);
      LMS.SaveToFile('C:\temp\HiTEMS.exe');
      shellExecute(self.Handle, 'open', PChar('C:\temp\HiTEMS.exe'), '', '', SW_SHOWNORMAL);
    end;//with
    idftp.Disconnect;
    idftp.Free;
    LMS.Free;
    FreeOnTerminate := True;
    SendMessage(Form1.Handle, WM_ThreadEnd, 0, 0);
  end;
end;
end.
