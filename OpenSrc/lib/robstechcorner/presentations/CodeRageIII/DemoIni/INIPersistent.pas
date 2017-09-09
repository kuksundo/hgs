unit INIPersistent;
interface
uses SysUtils, TypInfo;

type
 // RTTI can be added to a class with $TYPEINFO ON/OFF or $M+/-
 // or descending from a base class that has it defined.
 {$TYPEINFO ON}
  TAbstractINIPersistent = class abstract(TObject)
  protected
    FName : String;
  public
    procedure SaveToFile(const aFilename : String);
    procedure LoadFromFile(const aFilename : String);
  published
     property Name : String read FName write FName;
  end;
 {$TYPEINFO OFF}

implementation
uses
  IniFiles;

{ TAbstractINIPerist }
procedure TAbstractINIPersistent.LoadFromFile(const aFilename: String);
const
  NoValueStr = '~NO~VALUE!~';
var
  INI : TIniFile;
  Plist : PPropList;
  I : Integer;
  Value : String;
begin
  INI := TIniFile.Create(aFileName);
  try
    // Get List of all published properties
    GetPropList(Self,PList);
    // Loop Through each published Property Note: using for loop to demo GetTypedata()
    for I := 0 to GetTypeData(PTypeInfo(Self.ClassInfo))^.PropCount -1 do
    begin
       // Warning: A limitation of this example is that it only supports
       // properties that can be loaded and stored as a single line string
       // otherwise data loss, and strange errors may occur.
       Value := INI.ReadString(FName,PList^[I].Name,NoValueStr);
       if Value <> NoValueStr then
       begin
          SetPropValue(Self,PList^[I].Name,Value);
       end;
    end;
  finally
    INI.Free;
  end;
end;

procedure TAbstractINIPersistent.SaveToFile(const aFilename: String);
var
  INI : TIniFile;
  Plist : PPropList;
  I : Integer;
  Value : String;
  PropName : String;
begin
  INI := TIniFile.Create(aFileName);
  try
    // Get List of all published properties
    GetPropList(Self,PList);
    // Loop Through each published Property
    for I := 0 to GetTypeData(PTypeInfo(Self.ClassInfo))^.PropCount -1 do
    begin
       // Warning: A limitation of this example is that it only supports
       // properties that can be loaded and stored as a single line string
       // otherwise data loss, and strange errors may occur.
       propName := PList^[I].Name;
       Value := GetPropValue(Self,PropName,true);
       INI.WriteString(FName,PropName,Value);
    end;
    INI.UpdateFile;
  finally
    INI.Free;
  end;
end;

end.
