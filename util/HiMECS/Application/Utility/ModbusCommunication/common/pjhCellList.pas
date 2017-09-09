unit pjhCellList;

interface

uses classes,SysUtils;

type
  TpjhCellList = class( TObject )
  private
    FList : TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add( Col , Row : Longint );
    function Contains( Col , Row : Longint ) : Boolean;
    function Remove( Col ,Row : Longint ) : Boolean;
    function GetIndex( Col ,Row : Longint ) : Integer;
  end;

implementation

constructor TpjhCellList.Create;
begin
  FList := nil;
  FList := TStringList.Create;
end;

destructor TpjhCellList.Destroy;
begin
  FList.Free;
end;

procedure TpjhCellList.Add( Col , Row : Longint );
begin
  FList.Add(IntToStr(Col)+','+IntToStr(Row));
end;

function TpjhCellList.Contains( Col , Row : Longint ) : Boolean;
begin
  if FList.Indexof(IntToStr(Col)+','+IntToStr(Row)) > -1 then
    Result := True
  else
    Result := False;
end;

function TpjhCellList.Remove( Col ,Row : Longint ) : Boolean;
var i: integer;
begin
  Result := False;
  i := FList.Indexof(IntToStr(Col)+','+IntToStr(Row));

  if i > -1 then
  begin
    FList.Delete(i);
    Result := True;
  end;
end;

function TpjhCellList.GetIndex( Col ,Row : Longint ) : Integer;
begin
  //행열이 -1이면 전체 갯수를 반환함
  if (Col = -1) and (Row = -1) then
    Result := FList.Count
  else
    Result := FList.Indexof(IntToStr(Col)+','+IntToStr(Row));
end;

end.

