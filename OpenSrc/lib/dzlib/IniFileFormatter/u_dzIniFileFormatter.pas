unit u_dzIniFileFormatter;

interface

uses
  SysUtils,
  Classes,
  u_dzIniSections,
  u_dzIniEntryList;

type
  TIniFileFormatter = class
  private
    FSections: TIniEntryList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFrom(const _Filename: string);
    procedure Assign(_Lines: TStrings);
    procedure AssignSectionsTo(_Names: TStrings);
    procedure AssignItemsTo(const _Section: string; _Names: TStrings);
    procedure SortSections(_Template: TStrings = nil);
    procedure SortItems(const _Section: string; _Template: TStrings = nil);
    procedure AssignTo(_Lines: TStrings);
    procedure SaveTo(const _Filename: string);
  end;

implementation

uses
  u_dzQuicksort;

type
  TComparer = class(TInterfacedObject, IQSDataHandler)
  private
    FList: TIniEntryList;
    FTemplate: TStrings;
  private
    function Compare(_Idx1, _Idx2: integer): integer;
    procedure Swap(_Idx1, _Idx2: integer);
  public
    constructor Create(_List: TIniEntryList; _Template: TStrings = nil);
    destructor Destroy; override;
  end;

{ TComparer }

constructor TComparer.Create(_List: TIniEntryList; _Template: TStrings = nil);
var
  i: Integer;
begin
  Assert(Assigned(_List));

  inherited Create;
  FList := _List;
  FTemplate := TStringList.Create;
  if Assigned(_Template) then begin
    for i := 0 to _Template.Count - 1 do
      FTemplate.Add(LowerCase(_Template[i]));
  end;
end;

destructor TComparer.Destroy;
begin
  FreeAndNil(FTemplate);
  inherited;
end;

procedure TComparer.Swap(_Idx1, _Idx2: integer);
begin
  FList.Exchange(_Idx1, _Idx2);
end;

function TComparer.Compare(_Idx1, _Idx2: integer): integer;
var
  Key1: string;
  Key2: string;
  Idx1: integer;
  Idx2: integer;
begin
  Key1 := LowerCase(FList[_Idx1].NameOnly);
  Idx1 := FTemplate.IndexOf(Key1);

  Key2 := LowerCase(FList[_Idx2].NameOnly);
  Idx2 := FTemplate.IndexOf(Key2);

  if (Idx1 = -1) and (Idx2 <> -1) then
    Result := 1
  else if (Idx1 <> -1) and (Idx2 = -1) then
    Result := -1
  else begin
    Result := Idx1 - Idx2;
    if Result = 0 then
      Result := CompareStr(Key1, Key2);
  end;
end;

{ TIniFileSorter }

constructor TIniFileFormatter.Create;
begin
  inherited Create;
  FSections := TIniEntryList.Create;
end;

destructor TIniFileFormatter.Destroy;
begin
  FreeAndNil(FSections);
  inherited;
end;

procedure TIniFileFormatter.LoadFrom(const _Filename: string);
var
  Lines: TStringList;
begin
  Lines := TStringList.Create;
  try
    Lines.LoadFromFile(_Filename);
    Assign(Lines);

  finally
    FreeAndNil(Lines);
  end;
end;

procedure TIniFileFormatter.Assign(_Lines: TStrings);
var
  Comment: TStringList;
  Section: TIniSection;
  Item: TIniEntryAbstract;
  s: string;
begin
  FSections.Clear;

  Section := nil;
  Comment := TStringList.Create;
  for s in _Lines do begin
    if Copy(s, 1, 1) = '[' then begin
      Section := TIniSection.Create(s);
      Section.Comment := Trim(Comment.Text);
      Comment.Clear;
      FSections.Add(Section);
    end else begin
      if (s <> '') then begin
        if (Copy(s, 1, 2) = '//') or (Copy(s, 1, 1) = ';')
          or (Copy(s, 1, 1) = '#') or (Section = nil)
          or (Pos('=', s) = 0) then begin
          Comment.Add(s);
        end else begin
          Item := TIniItem.Create(s);
          Item.Comment := Trim(Comment.Text);
          Comment.Clear;
          Section.Items.Add(Item);
        end;
      end;
    end;
  end;
end;

procedure TIniFileFormatter.SortSections(_Template: TStrings = nil);
begin
  FSections.Sort(TComparer.Create(FSections, _Template));
end;

procedure TIniFileFormatter.SortItems(const _Section: string; _Template: TStrings = nil);
var
  Entry: TIniEntryAbstract;
  Section: TIniSection;
begin
  for Entry in FSections do begin
    Section := Entry as TIniSection;
    if SameText(Section.NameOnly, _Section) then
      Section.Items.Sort(TComparer.Create(Section.Items, _Template));
  end;
end;

procedure TIniFileFormatter.AssignSectionsTo(_Names: TStrings);
var
  Section: TIniEntryAbstract;
begin
  _Names.Clear;
  for Section in FSections do begin
    _Names.Add(Section.NameOnly)
  end;
end;

procedure TIniFileFormatter.AssignItemsTo(const _Section: string; _Names: TStrings);
var
  Section: TIniEntryAbstract;
  Item: TIniEntryAbstract;
begin
  _Names.Clear;
  for Section in FSections do begin
    if SameText(Section.NameOnly, _Section) then
      for Item in (Section as TIniSection).Items do begin
        _Names.Add(Item.NameOnly);
      end;
  end;
end;

procedure TIniFileFormatter.AssignTo(_Lines: TStrings);
var
  Section: TIniEntryAbstract;
  Item: TIniEntryAbstract;
begin
  _Lines.Clear;
  for Section in FSections do begin
    if Section.Comment <> '' then
      _Lines.Add(Section.Comment);
    _Lines.Add(Section.Line);
    for Item in (Section as TIniSection).Items do begin
      if Item.Comment <> '' then
        _Lines.Add(Item.Comment);
      _Lines.Add(Item.Line);
    end;
    _Lines.Add('');
  end;
end;

procedure TIniFileFormatter.SaveTo(const _Filename: string);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    AssignTo(sl);
    sl.SaveToFile(_Filename);
  finally
    FreeAndNil(sl);
  end;
end;

end.

