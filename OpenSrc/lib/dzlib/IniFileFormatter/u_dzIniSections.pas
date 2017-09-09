unit u_dzIniSections;

interface

uses
  SysUtils,
  Classes,
  u_dzIniEntryList;

type
  TIniItem = class(TIniEntryAbstract)
  public
    constructor Create(const _Line: string);
    function NameOnly: string; override;
  end;

type
  TIniSection = class(TIniEntryAbstract)
  private
    FItems: TIniEntryList;
  public
    constructor Create(const _Name: string);
    destructor Destroy; override;
    function NameOnly: string; override;
    property Items: TIniEntryList read FItems;
  end;

implementation

uses
  u_dzQuicksort;

{ TIniItem }

constructor TIniItem.Create(const _Line: string);
begin
  Assert(Pos('=', _Line) > 0, 'String does not contain "="');

  inherited Create(_Line);
end;

function TIniItem.NameOnly: string;
var
  p: integer;
begin
  Result := Line;
  p := Pos('=', Result);
  Result := Copy(Result, 1, p - 1);
end;

{ TIniSection }

constructor TIniSection.Create(const _Name: string);
begin
  Assert(Copy(_Name, 1, 1) = '[', 'String "' + _Name + '" does not start with "["');
  Assert(Copy(_Name, Length(_Name), 1) = ']', 'String "' + _Name + '" does not end in "]"');

  inherited Create(_Name);
  FItems := TIniEntryList.Create;
end;

destructor TIniSection.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

function TIniSection.NameOnly: string;
begin
  Result := Line;
  Result := Copy(Result, 2, Length(Result) - 2);
end;

end.

