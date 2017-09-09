unit UnitParameterManager;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  EngineParameterClass;

type
  TParameterManager = class
    procedure SendEPCopyData(FromHandle, ToHandle: integer; AEP:TEngineParameterItemRecord);
    procedure SendAlarmCopyData(FromHandle, ToHandle: integer; AEP:TEngineParameterItemRecord);
  end;


implementation

{ TParameterManager }

procedure TParameterManager.SendAlarmCopyData(FromHandle, ToHandle: integer;
  AEP: TEngineParameterItemRecord);
var
  cd : TCopyDataStruct;
begin
  with cd do
  begin
    dwData := FromHandle;
    cbData := sizeof(AEP);
    lpData := @AEP;
  end;//with
                                   //WParam = 0: TEngineParameterItemRecord
  SendMessage(ToHandle, WM_COPYDATA, 0, LongInt(@cd));
end;

procedure TParameterManager.SendEPCopyData(FromHandle, ToHandle: integer;
  AEP: TEngineParameterItemRecord);
var
  cd : TCopyDataStruct;
begin
  with cd do
  begin
    dwData := FromHandle;
    cbData := sizeof(AEP);
    lpData := @AEP;
  end;//with
                                   //WParam = 0: TEngineParameterItemRecord
  SendMessage(ToHandle, WM_COPYDATA, 0, LongInt(@cd));
end;

end.
