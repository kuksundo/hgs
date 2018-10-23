unit UnitRegistryUtil;

interface

uses System.SysUtils, Winapi.Windows, Registry;

//Win32 또는 Win64일때 레지스트리 접근 방법이 다름
function CreateRegistryWin32orWin64: TRegistry;

implementation

function CreateRegistryWin32orWin64: TRegistry;
Type TTypWin32Or64 = (Bit32,Bit64);
var TypWin32Or64 :TTypWin32Or64;
  Procedure TypeOS(var TypWin32Or64:TTypWin32Or64 ) ;
  begin
    if DirectoryExists('c:\Windows\SysWOW64') then
      TypWin32Or64:=Bit64
    else
      TypWin32Or64:=Bit32;
  end;
begin
  TypeOS(TypWin32Or64);

  case TypWin32Or64 of
    Bit32: Result := TRegistry.Create;
    Bit64: Result := TRegistry.Create(KEY_READ OR KEY_WOW64_64KEY);
    //use if if 64 bit enviroment Windows
  end;
end;

end.
