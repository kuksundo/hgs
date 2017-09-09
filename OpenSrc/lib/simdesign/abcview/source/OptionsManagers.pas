{ Unit OptionsManagers

  Project: ABC-View Manager

  Use this unit to easily handle application options. Give each option
  a unique identifier, e.g. cMustSave = $0001

  Then, add the option once in OnCreate using
  Opt.AddBool(cMustSave, 'Userstats', 'MustSave')
  In this case, 'Userstats' is the section and 'MustSave' the name of the
  option in the Ini file. If you omit them, the standard 'Options' and
  'Option001' is chosen. It then is difficult for the user to analyse the
  .ini file manually

  When you need access, implement like this
  if Opt[cMustSave].Bool then..
  or If userchange then Opt[cMustSave].Bool := True;

  You can save options in one command:
  Opt.SaveToIni('filename.ini');

  And load them with
  Opt.LoadFromIni('filename.ini');

  You can add a complete array of values
  cTableTitles := $0002;
  Opt.AddArray(cTableTitles, odString, 'Tables', 'Titles');

  Fill it with
  Opt[cTableTitles].Arr[0].Str := 'Name';
  Opt[cTableTitles].Arr[1].Str := 'Place'; ...

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit OptionsManagers;

interface

uses
  Contnrs, SysUtils, sdSortedLists, Graphics;

type

  EOptionsError = class(Exception);

  TOptionsDataType =
    (odUnknown, odBoolean, odInteger, odString, odFloat, odDateTime,
     odColor, odArray, odBoolRef);

  TOptionsManager = class;

  TOptionsItem = class
  private
    FDataType: TOptionsDataType;
    FIndex: integer;
    FName: string;
    FSection: string;
    FValue: variant;
    FArr: TOptionsManager;
  protected
    function GetBool: boolean;
    function GetInt: integer;
    function GetFlt: double;
    function GetDtm: TDateTime;
    function GetStr: string;
    function GetCol: TColor;
    function GetArr: TOptionsManager;
    procedure SetBool(AValue: boolean);
    procedure SetInt(AValue: integer);
    procedure SetFlt(AValue: double);
    procedure SetDtm(AValue: TDateTime);
    procedure SetStr(AValue: string);
    procedure SetCol(AValue: TColor);
  public
    destructor Destroy; override;
    property DataType: TOptionsDataType read FDataType write FDataType;
    property Index: integer read FIndex write FIndex;
    property Name: string read FName write FName;
    property Section: string read FSection write FSection;
    property Bool: boolean read GetBool write SetBool;
    property Int: integer read GetInt write SetInt;
    property Flt: double read GetFlt write SetFlt;
    property Dtm: TDateTime read GetDtm write SetDtm;
    property Str: string read GetStr write SetStr;
    property Col: TColor read GetCol write SetCol;
    property Arr: TOptionsManager read GetArr write FArr;
    property Value: variant read FValue write FValue;
    procedure GetFont(AFont: TFont);
    procedure SetFont(AFont: TFont);
  end;

  TOptionsManager = class
  private
    FItems: TSortedList;
    FBasicType: TOptionsDataType;
    FAutoIndex: integer;
  protected
    function GetCount: integer; virtual;
    function GetItems(Index: integer): TOptionsItem;
    function NextAutoIndex: integer;
  public
    constructor Create;
    destructor Destroy; override;
    property BasicType: TOptionsDataType read FBasicType write FBasicType;
    property Count: integer read GetCount;
    property Items[Index: integer]: TOptionsItem read GetItems; default;
    procedure AddType(AIndex: integer; ADataType: TOptionsDataType;
      ADefault: variant; ASection: string = ''; AName: string = '');
    procedure AddBool(AIndex: integer; ADefault: boolean;
      ASection: string = ''; AName: string = ''); virtual;
    procedure AddFloat(AIndex: integer; ADefault: double;
      ASection: string = ''; AName: string = ''); virtual;
    procedure AddInt(AIndex: integer; ADefault: integer;
      ASection: string = ''; AName: string = ''); virtual;
    procedure AddStr(AIndex: integer; ADefault: string;
      ASection: string = ''; AName: string = ''); virtual;
    procedure AddDtm(AIndex: integer; ADefault: TDateTime;
      ASection: string = ''; AName: string = ''); virtual;
    procedure AddArr(AIndex: integer; ABasicType: TOptionsDataType; ASection: string = '';
      AName: string = ''); virtual;
    procedure AddCol(AIndex: integer; ADefault: TColor;
      ASection: string = ''; AName: string = ''); virtual;
    procedure AddFont(AIndex: integer; ADefault: TFont;
      ASection: string = 'Options'; AName: string = ''); virtual;
    procedure AddBoolRef(ARef: pointer; ASection: string = 'Options'; AName: string = ''); virtual;
    function FindByIndex(AIndex: integer): TOptionsItem; virtual;
    function FindBySectionAndName(ASection, AName: string): TOptionsItem; virtual;
    function MaxCount: integer;
    procedure LoadFromIni(AIniFile: string);
    procedure SaveToIni(AIniFile: string);
  end;

var
  Opt: TOptionsManager = nil;

implementation

uses
  IniFiles;

// Compare function for sorted list on index
function CompareIndex(Item1, Item2: TObject; Info: pointer): integer;
begin
  Result := 0;
  if not assigned(Item1) or not assigned(Item2) then exit;
  if TOptionsItem(Item1).Index < TOptionsItem(Item2).Index then
    Result := -1
  else
    if TOptionsItem(Item1).Index > TOptionsItem(Item2).Index then
      Result := 1;
end;

{ TOptionsItem }

function TOptionsItem.GetBool: boolean;
begin
  Result := FValue;
end;

function TOptionsItem.GetInt: integer;
begin
  Result := FValue;
end;

function TOptionsItem.GetFlt: double;
begin
  Result := FValue;
end;

function TOptionsItem.GetDtm: TDateTime;
var
  Str: string;
  Y, M, D, H, N, S: integer;
begin
  case DataType of
  odString:
    begin
      Str := FValue;
      Y := StrToInt(Copy(Str, 1, 4));
      M := StrToInt(Copy(Str, 6, 2));
      D := StrToInt(Copy(Str, 9, 2));
      if length(Str) > 10 then begin
        H := StrToInt(Copy(Str, 12, 2));
        N := StrToInt(Copy(Str, 15, 2));
        S := StrToInt(Copy(Str, 18, 2));
      end else begin
        H := 0;
        N := 0;
        S := 0;
      end;
      Result := EncodeDate(Y, M, D) + EncodeTime(H, N, S, 0);
    end;
  odBoolean:
    raise EOptionsError.Create('Cannot convert boolean value to date/time.');
  else
    Result := double(FValue);
  end;//case
end;

function TOptionsItem.GetStr: string;
var
  D: double;
begin
  case DataType of
  odDateTime:
    begin
      D := FValue;
      if round(D) = D then
        Result := FormatDateTime('YYYY:MM:DD', D)
      else
        Result := FormatDateTime('YYYY:MM:DD HH:NN:SS', D);
    end;
  else
    Result := FValue;
  end;//case
end;

function TOptionsItem.GetCol: TColor;
begin
  Result := TColor(integer(FValue));
end;

function TOptionsItem.GetArr: TOptionsManager;
begin
  if DataType = odArray then
    Result := FArr
  else
    raise EOptionsError.Create('This option is not an array type');
end;

procedure TOptionsItem.SetBool(AValue: boolean);
begin
  FValue := AValue;
end;

procedure TOptionsItem.SetInt(AValue: integer);
begin
  FValue := AValue;
end;

procedure TOptionsItem.SetFlt(AValue: double);
begin
  FValue := AValue;
end;

procedure TOptionsItem.SetDtm(AValue: TDateTime);
begin
  case DataType of
  odString:
    begin
      if round(AValue) = AValue then
        FValue := FormatDateTime('YYYY:MM:DD', AValue)
      else
        FValue := FormatDateTime('YYYY:MM:DD HH:NN:SS', AValue);
    end;
  else
    FValue := AValue;
  end;
end;

procedure TOptionsItem.SetStr(AValue: string);
var
  Y, M, D, H, N, S: integer;
begin
  case DataType of
  odDateTime:
    begin
      Y := StrToInt(Copy(AValue, 1, 4));
      M := StrToInt(Copy(AValue, 6, 2));
      D := StrToInt(Copy(AValue, 9, 2));
      if length(AValue) > 10 then begin
        H := StrToInt(Copy(AValue, 12, 2));
        N := StrToInt(Copy(AValue, 15, 2));
        S := StrToInt(Copy(AValue, 18, 2));
      end else begin
        H := 0;
        N := 0;
        S := 0;
      end;
      FValue := EncodeDate(Y, M, D) + EncodeTime(H, N, S, 0);
    end;
  else
    FValue := AValue;
  end;
end;

procedure TOptionsItem.SetCol(AValue: TColor);
begin
  FValue := integer(AValue);
end;

destructor TOptionsItem.Destroy;
begin
  if assigned(FArr) then FreeAndNil(FArr);
end;

procedure TOptionsItem.GetFont(AFont: TFont);
begin
  if not assigned(AFont) then exit;
  Arr[0].Str := AFont.Name;
  Arr[1].Str := IntToStr(AFont.Size);
  if fsBold in AFont.Style then
    Arr[2].Str := 'Bold'
  else
    Arr[2].Str := '';
  if fsItalic in AFont.Style then
    Arr[2].Str := 'Italic'
  else
    Arr[2].Str := '';
end;

procedure TOptionsItem.SetFont(AFont: TFont);
begin
  if not assigned(AFont) then exit;
  AFont.Name := Arr[0].Str;
  AFont.Size := StrToInt(Arr[1].Str);
  if Arr[2].Str = 'Bold' then
    AFont.Style := AFont.Style + [fsBold]
  else
    AFont.Style := AFont.Style - [fsBold];
  if Arr[2].Str = 'Italic' then
    AFont.Style := AFont.Style + [fsItalic]
  else
    AFont.Style := AFont.Style - [fsItalic];
end;

{ TOptionsManager }

function TOptionsManager.GetCount: integer;
begin
  Result := 0;
  if assigned(FItems) then
    Result := FItems.Count;
end;

function TOptionsManager.GetItems(Index: integer): TOptionsItem;
begin
  Result := FindByIndex(Index);
  if Result = nil then begin
    AddType(Index, BasicType, 0);
    Result := FindByIndex(Index);
  end;
end;

function TOptionsManager.NextAutoIndex: integer;
begin
  if FAutoIndex = 0 then
    // Just a silly start number that is probably not in use
    FAutoIndex := 13142
  else
    inc(FAutoIndex);
  Result := FAutoIndex;
end;

constructor TOptionsManager.Create;
begin
  inherited Create;
  FItems := TSortedList.Create(True);
  FItems.CompareMethod := CompareIndex;
end;

destructor TOptionsManager.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

procedure TOptionsManager.AddType(AIndex: integer; ADataType: TOptionsDataType;
  ADefault: variant; ASection: string = ''; AName: string = '');
var
  Item: TOptionsItem;
begin
  // Section
  if length(ASection) = 0 then
    ASection := 'Options';
  // Name of the option
  if length(AName) = 0 then
    AName := Format('Option%.4d', [AIndex]);

  // Check for duplicate
  if assigned(FindBySectionAndName(ASection, AName)) or
     assigned(FindByIndex(AIndex)) then
    raise EOptionsError.Create('Option name and section already exists! Please choose original name.');

  // Add
  if assigned(FItems) then begin
    Item := TOptionsItem.Create;
    with Item do begin
      Index := AIndex;
      Section := ASection;
      Name := AName;
      DataType := ADataType;
      case DataType of
      odArray:
        Arr := TOptionsManager.Create;
      odString:
        if ADefault = '0' then
          Value := '';
      else
        Value := ADefault;
      end;
    end;
    FItems.Add(Item);
  end;
end;

procedure TOptionsManager.AddBool(AIndex: integer; ADefault: boolean;
  ASection: string = ''; AName: string = '');
begin
  AddType(AIndex, odBoolean, ADefault, ASection, AName);
end;

procedure TOptionsManager.AddFloat(AIndex: integer; ADefault: double;
  ASection: string = ''; AName: string = '');
begin
  AddType(AIndex, odFloat, ADefault, ASection, AName);
end;

procedure TOptionsManager.AddInt(AIndex: integer; ADefault: integer;
  ASection: string = ''; AName: string = '');
begin
  AddType(AIndex, odInteger, ADefault, ASection, AName);
end;

procedure TOptionsManager.AddStr(AIndex: integer; ADefault: string;
  ASection: string = ''; AName: string = '');
begin
  AddType(AIndex, odString, ADefault, ASection, AName);
end;

procedure TOptionsManager.AddDtm(AIndex: integer; ADefault: TDateTime;
  ASection: string = ''; AName: string = '');
begin
  AddType(AIndex, odDateTime, double(ADefault), ASection, AName);
end;

procedure TOptionsManager.AddCol(AIndex: integer; ADefault: TColor;
  ASection: string = ''; AName: string = '');
begin
  AddType(AIndex, odColor, integer(ADefault), ASection, AName);
end;

procedure TOptionsManager.AddFont(AIndex: integer; ADefault: TFont;
  ASection: string = 'Options'; AName: string = '');
begin
  // A font is assigned an array of string values
  AddArr(AIndex, odString, ASection, AName);
  Items[AIndex].GetFont(ADefault);
end;

procedure TOptionsManager.AddArr(AIndex: integer; ABasicType: TOptionsDataType; ASection: string = '';
  AName: string = '');
begin
  AddType(AIndex, odArray, 0, ASection, AName);
  Items[AIndex].Arr.BasicType := ABasicType;
end;

procedure TOptionsManager.AddBoolRef(ARef: pointer;
  ASection: string = 'Options'; AName: string = '');
begin
  AddType(NextAutoIndex, odBoolRef, integer(ARef), ASection, AName);
end;

function TOptionsManager.FindByIndex(AIndex: integer): TOptionsItem;
var
  APos: integer;
  Dummy: TOptionsItem;
begin
  Result := nil;
  // Use built in binary find
  if assigned(FItems) then begin
    Dummy := TOptionsItem.Create;
    try
      Dummy.Index := AIndex;
      if FItems.Find(Dummy, APos) then
        Result := TOptionsItem(FItems[APos]);
    finally
      Dummy.Free;
    end;
  end;
end;

function TOptionsManager.FindBySectionAndName(ASection, AName: string): TOptionsItem;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if assigned(FItems[i]) then with TOptionsItem(FItems[i]) do
      if (Section = ASection) and (Name = AName) then begin
        Result := TOptionsItem(FItems[i]);
        exit;
      end;
end;

function TOptionsManager.MaxCount: integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
    if TOptionsItem(FItems[i]).Index >= Result then
      Result := TOptionsItem(FItems[i]).Index + 1;
end;

procedure TOptionsManager.LoadFromIni(AIniFile: string);
var
  i: integer;
  Ini: TMemIniFile;
// local
procedure DoReadItem(Prefix: string; AItem: TOptionsItem);
var
  i: integer;
  AMaxCount: integer;
  Sub: TOptionsItem;
  ARef: pointer;
begin
  if assigned (AItem) then with AItem do begin
    case DataType of
    odBoolean:
      Bool := Ini.ReadBool(Section, Prefix + Name, Bool);
    odInteger, odColor:
      Int := Ini.ReadInteger(Section, Prefix + Name, Int);
    odFloat:
      Flt := Ini.ReadFloat(Section, Prefix + Name, Flt);
    odArray:
      begin
        AMaxCount := Ini.ReadInteger(Section, Prefix + Name + '_count', 0);
        Arr.BasicType := TOptionsDataType(Ini.ReadInteger(Section, Prefix + Name + '_type', 0));
        // Write the individual items in the array
        for i := 0 to AMaxCount - 1 do begin
          Sub := Arr[i];
          Sub.DataType := Arr.BasicType;
          // Set the Section and Name
          Sub.Section := Section;
          Sub.Name := Format('%.4d', [Sub.Index]);
          // Recursive call
          DoReadItem(Name + '_', Sub);
        end;
      end;
    odBoolRef:
      begin
        ARef := pointer(integer(Value));
        if assigned(ARef) then
          boolean(ARef^) := Ini.ReadBool(Section, Prefix + Name, boolean(ARef^));
      end;
    else
      Str := Ini.ReadString(Section, Prefix + Name, Str);
    end;//case
  end;
end;
// main
begin
  Ini := TMemIniFile.Create(AIniFile);
  try
    for i := 0 to Count - 1 do
      DoReadItem('', TOptionsItem(FItems[i]));
  finally
    Ini.Free;
  end;
end;

procedure TOptionsManager.SaveToIni(AIniFile: string);
var
  i: integer;
  Ini: TMemIniFile;
// local
procedure DoWriteItem(Prefix: string; AItem: TOptionsItem);
var
  i: integer;
  Sub: TOptionsItem;
  ARef: pointer;
begin
  if assigned (AItem) then with AItem do begin
    case DataType of
    odBoolean:
      Ini.WriteBool(Section, Prefix + Name, Bool);
    odInteger, odColor:
      Ini.WriteInteger(Section, Prefix + Name, Int);
    odFloat:
      Ini.WriteFloat(Section, Prefix + Name, Flt);
    odArray:
      begin
        Ini.WriteInteger(Section, Prefix + Name + '_count', Arr.MaxCount);
        Ini.WriteInteger(Section, Prefix + Name + '_type', ord(Arr.BasicType));
        // Write the individual items in the array
        for i := 0 to Arr.MaxCount - 1 do begin
          Sub := Arr.FindByIndex(i);
          if assigned(Sub) then begin
            // Set the Arr's Section and Name
            Sub.Section := Section;
            Sub.Name := Format('%.4d', [Sub.Index]);
            // Recursive call
            DoWriteItem(Name + '_', Sub);
          end;
        end;
      end;
    odBoolRef:
      begin
        ARef := pointer(integer(Value));
        if assigned(ARef) then
          Ini.WriteBool(Section, Prefix + Name, boolean(ARef^));
      end;
    else
      Ini.WriteString(Section, Prefix + Name, Str);
    end;//case
  end;
end;
// main
begin
  Ini := TMemIniFile.Create(AIniFile);
  try
    for i := 0 to Count - 1 do
      DoWriteItem('', TOptionsItem(FItems[i]));
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

// Initialization and Finalization
initialization

  Opt := TOptionsManager.Create;

finalization

  FreeAndNil(Opt);

end.
