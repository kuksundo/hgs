unit u_dzStringPool;

interface

uses
  SysUtils,
  Classes;

type
  ///<summary> This class will maintain a sorted list of all string that
  ///          were ever passed to its Intern function and always return
  ///          a string that refers to a single memory area containing the
  ///          string thus resulting it greatly reduced memory requirements
  ///          if an application uses many duplicate strings.
  ///          (see string interning)
  ///          This is a rather trivial implemenation internally using
  ///          sorted TStringList.
  ///          Note: An instance of this class is not thread safe when used by
  ///                several threads but you can create one instance per thread
  ///                which will eliminate duplicates whithin this thread.
  ///          Note: There is also an InternString function that internally
  ///                uses a global instance of this class. As noted above
  ///                this will not be thread safe. </summary>
  TStringPool = class
{$IFDEF DebugStringPool}
  protected
{$ELSE}
  private
{$ENDIF}
    FList: TStringList;
    FMakeStringsUnique: Boolean;
  public
    ///<summary> @param MakeStringsUnique is a boolean determining whether
    ///                                   strings are made unique (by
    ///                                   calling UniqueString) before adding
    ///                                   them to the list. This should not be
    ///                                   necessary in most applications. </summary>
    constructor Create(_MakeStringsUnique: Boolean = False);
    destructor Destroy; override;
    ///<summary> Intern the given string, that is: Consolidate duplicates. </summary>
    procedure Intern(var _s: string);
  end;

procedure InternString(var _s: string);
function InternStr(const _s: string): string;

implementation

var
  StringPool: TStringPool = nil;

procedure InternString(var _s: string);
begin
  if not Assigned(StringPool) then
    StringPool := TStringPool.Create();
  StringPool.Intern(_s);
end;

function InternStr(const _s: string): string;
begin
  Result := _s;
  InternString(Result);
end;

{ TStringPool }

constructor TStringPool.Create(_MakeStringsUnique: Boolean = False);
begin
  inherited Create;
  FList := TStringList.Create;
  FList.CaseSensitive := True;
  FList.Sorted := True;
  FMakeStringsUnique := _MakeStringsUnique;
end;

destructor TStringPool.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

procedure TStringPool.Intern(var _s: string);
var
  idx: Integer;
begin
  if FList.Find(_s, idx) then
    _s := FList[idx]
  else begin
    if FMakeStringsUnique then
      UniqueString(_s);
    FList.Add(_s);
  end;
end;

initialization
finalization
  FreeAndNil(StringPool);
end.

