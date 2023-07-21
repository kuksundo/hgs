unit UnitHiMECSHttpAsyncServer;

interface

uses
  sysutils,
  classes,
  mormot.core.base,
  mormot.core.os,
  mormot.core.rtti,
  mormot.core.log,
  mormot.core.text,
  mormot.net.http,
  mormot.net.server,
  mormot.net.async;

type
  TSimpleHttpAsyncServer = class
  private
    fHttpServer: THttpServerSocketGeneric;
  protected
    // this is where the process would take place
    function DoOnRequest(Ctxt: THttpServerRequestAbstract): cardinal;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TSimpleHttpAsyncServer }

constructor TSimpleHttpAsyncServer.Create;
begin

end;

destructor TSimpleHttpAsyncServer.Destroy;
begin

  inherited;
end;

function TSimpleHttpAsyncServer.DoOnRequest(
  Ctxt: THttpServerRequestAbstract): cardinal;
begin

end;

end.
