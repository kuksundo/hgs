unit u_Int64List;

interface

uses
  SysUtils,
  Classes,
  u_dzTranslator;

type
  TInt64List = class
  private
    FData: array of Int64;
    FCapacity: integer;
    FCount: integer;
    procedure Grow;
    procedure SetCapacity(_NewCapacity: Integer);
    function GetItems(_Idx: integer): Int64;
    procedure SetItems(_Idx: integer; const Value: Int64);
  public
    function Add(_Value: Int64): integer;
    property Items[_Idx: integer]: Int64 read GetItems write SetItems;
    property Count: integer read FCount;
  end;

implementation

uses
  RTLConsts;

{ TInt64List }

function TInt64List.Add(_Value: Int64): integer;
begin
  Result := FCount;
  if Result = FCapacity then
    Grow;
  FData[Result] := _Value;
  Inc(FCount);
end;

procedure TInt64List.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then
    Delta := FCapacity div 4
  else if FCapacity > 8 then
    Delta := 16
  else
    Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

procedure TInt64List.SetCapacity(_NewCapacity: Integer);
begin
  if (_NewCapacity < FCount) or (_NewCapacity > MaxListSize) then
    raise Exception.CreateFmt(_('List capacity out of bounds (%d)'), [_NewCapacity]);
  if _NewCapacity <> FCapacity then begin
    SetLength(FData, _NewCapacity);
    FCapacity := _NewCapacity;
  end;
end;

function TInt64List.GetItems(_Idx: integer): Int64;
begin
  if (_Idx < 0) or (_Idx >= FCount) then
    raise Exception.CreateFmt(_('List index out of bounds (%d)'), [_Idx]);
  Result := FData[_Idx];
end;

procedure TInt64List.SetItems(_Idx: integer; const Value: Int64);
begin

end;

end.

