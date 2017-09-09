//******************************************************************************
//
// EventSinkImp
//
// Copyright © 1999-2000 Binh Ly
// All Rights Reserved
//
// bly@techvanguards.com
// http://www.techvanguards.com
//******************************************************************************
unit EventSinkOptions;

interface

uses
  Classes
  ;

type
  TUsesImportMode = (imMergeIntoSink, imUsesTLB);

  TEventSinkOptions = class
  protected
    FSinkPage : string;
    FSinkTemplate : integer;
    FSinkTemplates : TStringList;
    FTLibImpAutoFind : boolean;
    FTLibImpFile : string;
    FUserDefinedUses : string;
    FUsesImportMode : TUsesImportMode;
    FRemoveUnderscores : boolean;
    FFullyQualify : boolean;
    function GetSinkTemplateName : string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile (const sIniFile : string);
    procedure SaveToFile (const sIniFile : string);
    property UserDefinedUses : string read FUserDefinedUses write FUserDefinedUses;
    property UsesImportMode : TUsesImportMode read FUsesImportMode write FUsesImportMode;
    property SinkPage : string read FSinkPage write FSinkPage;
    property SinkTemplate : integer read FSinkTemplate write FSinkTemplate;
    property SinkTemplateName : string read GetSinkTemplateName;
    property SinkTemplates : TStringList read FSinkTemplates;
    property TLibImpAutoFind : boolean read FTLibImpAutoFind write FTLibImpAutoFind;
    property TLibImpFile : string read FTLibImpFile write FTLibImpFile;
    property RemoveUnderscores : boolean read FRemoveUnderscores
      write FRemoveUnderscores;
    property FullyQualify : boolean read FFullyQualify
      write FFullyQualify;
  end;

implementation

uses
  IniFiles
  ;

{ TEventSinkOptions }

function TEventSinkOptions.GetSinkTemplateName : string;
begin
  Result := '';
  if (SinkTemplates.Count > 0) then Result := SinkTemplates [0];
  if (SinkTemplate < 0) or (SinkTemplate >= SinkTemplates.Count) then Exit;
  Result := SinkTemplates.Names [SinkTemplate];
end;

constructor TEventSinkOptions.Create;
begin
  inherited Create;
  FSinkTemplates := TStringList.Create;
end;

destructor TEventSinkOptions.Destroy;
begin
  FSinkTemplates.Free;
  inherited;
end;

procedure TEventSinkOptions.LoadFromFile (const sIniFile : string);
var
  ini : TIniFile;
begin
  ini := TIniFile.Create (sIniFile);
  try
    UsesImportMode := TUsesImportMode (
      ini.ReadInteger ('General', 'UsesImportMode', 0) MOD (Ord (High (TUsesImportMode)) + 1)
    );

    SinkTemplate := ini.ReadInteger ('General', 'SinkTemplate', 0);
    ini.ReadSectionValues ('SinkTemplates', SinkTemplates);
    if (SinkTemplates.Count <= 0) then
      SinkTemplates.Values ['SinkComponent.pas'] := 'TComponent-derived Sink';

    SinkPage := ini.ReadString ('General', 'SinkPage', 'ActiveX');
    UserDefinedUses := ini.ReadString ('General', 'UserDefinedUses', '');
    TLibImpAutoFind := ini.ReadBool ('General', 'TLibImpAutoFind', TRUE);
    TLibImpFile := ini.ReadString ('General', 'TLibImpFile', '');
    RemoveUnderscores := ini.ReadBool ('General', 'RemoveUnderscores', True);
    FullyQualify := ini.ReadBool ('General', 'FullyQualify', False);
  finally
    ini.Free;
  end;  { finally }
end;

procedure TEventSinkOptions.SaveToFile (const sIniFile : string);
var
  ini : TIniFile;
begin
  ini := TIniFile.Create (sIniFile);
  try
    ini.WriteInteger ('General', 'UsesImportMode', Ord (UsesImportMode));
    ini.WriteInteger ('General', 'SinkTemplate', SinkTemplate);
    ini.WriteString ('General', 'SinkPage', SinkPage);
    ini.WriteString ('General', 'UserDefinedUses', UserDefinedUses);
    ini.WriteBool ('General', 'TLibImpAutoFind', TLibImpAutoFind);
    ini.WriteString ('General', 'TLibImpFile', TLibImpFile);
    ini.WriteBool ('General', 'RemoveUnderscores', RemoveUnderscores);
    ini.WriteBool ('General', 'FullyQualify', FullyQualify);
  finally
    ini.Free;
  end;  { finally }
end;

end.
