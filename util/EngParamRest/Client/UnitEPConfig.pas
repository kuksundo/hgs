unit UnitEPConfig;

interface

uses IniPersist;

type
  TConfigSettings = class (TObject)
  private
    FSharedName: String;
    FIniFileName: string;
  public
    constructor create(AFileName: string);
    // Use the IniValue attribute on any property or field
    // you want to show up in the INI File.
    [IniValue('Parameter','Shared Name','')]
    property SharedName : String read FSharedName write FSharedName;

    property IniFileName : String read FIniFileName write FIniFileName;

    procedure Save;
    procedure Load;

  end;

implementation
uses SysUtils;

{ TApplicationSettings }

constructor TConfigSettings.create(AFileName: string);
begin
//  FIniFileName := ExtractFilePath(ParamStr(0)) +  'settings.ini';
  FIniFileName := AFileName;
end;

procedure TConfigSettings.Load;
begin
// This loads the INI File Values into the properties.
   TIniPersist.Load(FIniFileName,Self);
end;

procedure TConfigSettings.Save;
begin
// This saves the properties to the INI
   TIniPersist.Save(FIniFileName,Self);
end;

end.

