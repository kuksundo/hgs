unit UnitCommonWSInterface;

interface

uses
  SysUtils, Classes,
  SynCommons,
  mORMot;

type
  ICommonWSCallback = interface(IInvokable)
    ['{3353F04E-3AFA-4E23-A8C7-64FA51374270}']
    procedure ClientExecute(const command, msg: string);
  end;

  ICommonWSService = interface(IServiceWithCallbackReleased)
    ['{FF0AEF1B-4389-4911-A9D7-233EEB9E0FA6}']
    procedure Join(const pseudo: string; const callback: ICommonWSCallback);
    function ServerExecute(const Acommand: RawUTF8): RawUTF8;
  end;

  TService4CommonWS = class(TInterfacedObject, ICommonWSService)
  private
  protected
    fConnected: array of ICommonWSCallback;
    FClientInfoList: TStringList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Join(const pseudo: string; const callback: ICommonWSCallback); virtual; abstract;
    procedure CallbackReleased(const callback: IInvokable; const interfaceName: RawUTF8); virtual; abstract;
    function ServerExecute(const Acommand: RawUTF8): RawUTF8; virtual; abstract;
  end;

implementation

{ TService4CommonWS }

constructor TService4CommonWS.Create;
begin
  FClientInfoList :=  TStringList.Create;
end;

destructor TService4CommonWS.Destroy;
var
  i: integer;
begin
//  for i := 0 to FClientInfoList.Count - 1 do
//    TClientInfo(FClientInfoList.Objects[i]).Free;

  FClientInfoList.Free;

  inherited;
end;

initialization
  TInterfaceFactory.RegisterInterfaces([
    TypeInfo(ICommonWSCallback),TypeInfo(ICommonWSCallback)]);
end.
