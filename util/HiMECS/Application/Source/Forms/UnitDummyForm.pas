unit UnitDummyForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Cromis.Comm.IPC, CopyData;

type
  TDummyForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    //FIPCServer: TIPCServer;
    procedure OnExecuteRequest(const Request, Response: IIPCData);
  public
    FMainFormHandle,
    FClientFormHandle: THandle;
  end;

var
  DummyForm: TDummyForm;

implementation

{$R *.dfm}

procedure TDummyForm.FormCreate(Sender: TObject);
begin
  //FIPCServer := TIPCServer.Create;
  //FIPCServer.OnExecuteRequest := OnExecuteRequest;
  //FIPCServer.ServerName := IntToStr(Handle);
  //FIPCServer.Start;
  //Caption := FIPCServer.ServerName;
end;

procedure TDummyForm.FormDestroy(Sender: TObject);
begin
  //FIPCServer.Stop;
  //FreeAndNil(FIPCServer);
end;

procedure TDummyForm.OnExecuteRequest(const Request, Response: IIPCData);
var
  Command: AnsiString;
begin
  Caption := Request.Data.ReadUTF8String('Command');
  SendCopyData2(FMainFormHandle, Caption, Self.Handle);
  //ListBox1.Items.Add(Format('%s Request Recieved (Sent at: %s)', [Command, Request.ID]));

  //Response.Data.WriteDateTime('TDateTime', Now);
  //Response.Data.WriteInteger('Integer', 5);
  //Response.Data.WriteReal('Real', 5.33);
  //Response.Data.WriteUTF8String('String', 'to je testni string');
  //Caption := Format('%d requests processed', [FRequestCount]);
end;

end.
