{ *********************************************************************** }
{                                                                         }
{ NotifyManager                                                           }
{                                                                         }
{ Copyright (c) 2007 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit NotifyManager;

{$B-}

interface

uses
  Classes;

type
  PNotifyType = ^TNotifyType;
  TNotifyType = (ntConnect, ntSuspend, ntDisconnect, ntCompile, ntBeforeFunctionAdd,
    ntAfterFunctionAdd, ntBeforeFunctionDelete, ntAfterFunctionDelete, ntBeforeTypeAdd,
    ntAfterTypeAdd, ntBeforeTypeDelete, ntAfterTypeDelete);

  PNotifyAttribute = ^TNotifyAttribute;
  TNotifyAttribute = record
    Reliable, Permanent: Boolean;
  end;

  TNotifyControl = class(TComponent)
  public
    procedure Notify(NotifyType: TNotifyType; Component: TComponent); virtual; abstract;
  end;
  TNotifyControls = array of TNotifyControl;

  TNotifyManager = class(TComponent)
  private
    FControls: TNotifyControls;
  public
    destructor Destroy; override;
    procedure Notify(NotifyType: TNotifyType; Component: TComponent); virtual;
    function Add(Control: TNotifyControl): Integer; virtual;
    procedure Clear; virtual;
    function Delete(Control: TNotifyControl): Boolean; overload; virtual;
    function Delete(Index: Integer): Boolean; overload; virtual;
    function IndexOf(Control: TNotifyControl): Integer; virtual;
    property Controls: TNotifyControls read FControls write FControls;
  end;

const
  NotifyAttribute: array[TNotifyType] of TNotifyAttribute = (
    (Reliable: True; Permanent: False), (Reliable: True; Permanent: False),
    (Reliable: True; Permanent: False), (Reliable: False; Permanent: False),
    (Reliable: True; Permanent: True), (Reliable: True; Permanent: True),
    (Reliable: True; Permanent: True), (Reliable: True; Permanent: True),
    (Reliable: True; Permanent: True), (Reliable: True; Permanent: True),
    (Reliable: True; Permanent: True), (Reliable: True; Permanent: True));

function Available(const Component: TComponent): Boolean;

implementation

uses
  MemoryUtils;

function Available(const Component: TComponent): Boolean;
begin
  Result := Assigned(Component) and not (csDestroying in Component.ComponentState);
end;

{ TNotifyManager }

function TNotifyManager.Add(Control: TNotifyControl): Integer;
begin
  if IndexOf(Control) < 0 then
  begin
    Result := Length(FControls);
    SetLength(FControls, Result + 1);
    MemoryUtils.Add(FControls, @Control, Result * SizeOf(TNotifyControl),
      SizeOf(TNotifyControl));
  end
  else Result := -1;
end;

procedure TNotifyManager.Clear;
begin
  FControls := nil;
end;

function TNotifyManager.Delete(Control: TNotifyControl): Boolean;
begin
  Result := Delete(IndexOf(Control));
end;

function TNotifyManager.Delete(Index: Integer): Boolean;
var
  I: Integer;
begin
  I := Length(FControls);
  Result := MemoryUtils.Delete(FControls, Index * SizeOf(TNotifyControl),
    SizeOf(TNotifyControl), I * SizeOf(TNotifyControl));
  if Result then SetLength(FControls, I - 1);
end;

destructor TNotifyManager.Destroy;
begin
  Clear;
  inherited;
end;

function TNotifyManager.IndexOf(Control: TNotifyControl): Integer;
begin
  Result := MemoryUtils.IndexOf(FControls, @Control, Length(FControls),
    SizeOf(TNotifyControl));
end;

{$WARNINGS OFF}
procedure TNotifyManager.Notify(NotifyType: TNotifyType; Component: TComponent);
var
  AControls: TNotifyControls;
  I: Integer;
begin
  if Available(Self) then
  begin
    AControls := Copy(FControls);
    try
      for I := Low(AControls) to High(AControls) do
        if Available(AControls[I]) then
          AControls[I].Notify(NotifyType, Component);
    finally
      AControls := nil;
    end;
  end;
end;
{$WARNINGS ON}

end.
