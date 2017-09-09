{ Unit Columns

  This unit implements the TColumnList object and associated objects.

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!

}
unit Columns;

interface

uses

  Classes, ComCtrls, sdProperties, SysUtils, Contnrs, sdItems, sdAbcTypes;

type

  // The TColumnItem object is used to store a column item's properties
  TColumnItem = class(TsdProperty)
  private
    FAlignment: TAlignment;
    FCaption: string;
    FListColumn: integer; // corresponding list column
    FSortMethod: TSortMethodType;
    FSortDirection: TSortDirectionType;
    FVisible: boolean;
    FWidth: integer;
  protected
    function GetPropID: word; override;
  public
    // Caption is the title of the column.
    property Caption: string read FCaption write FCaption;
    // SortMethod specifies a sort method which will be used when the user
    // clicks on the column.
    property SortMethod: TSortMethodType read FSortMethod write FSortMethod;
    // SortDir specifies a sort direction which will be used when teh user
    // clicks on the column. A second click will reverse SortDir
    property SortDirection: TSortDirectionType read FSortDirection write FSortDirection;
    // Set Visible to False to hide the column in the listview
    property Visible: boolean read FVisible write FVisible;
    // Witdh specifies the width in pixels of the column
    property Width: integer read FWidth write FWidth;
    constructor Create(AVisible: boolean; ACaption: string; AWidth: integer;
      ASortMethod: TSortMethodType; ASortDirection: TSortDirectionType; AAlignment: TAlignment);
  end;

  TColumnList = class(TsdProperty)
  private
    FItems: TObjectList;
    function GetItems(Index: integer): TColumnItem;
  public
    property Items[Index: integer]: TColumnItem read GetItems; default;
    constructor Create;
    destructor Destroy; override;
    procedure Add(AVisible: boolean; ACaption: string; AWidth: integer;
      ASortMethod: TSortMethodType; AAlignment: TAlignment);
    procedure CopyToListView(Sender: TObject; AListView: TListView);
    function FindColumn(AListColumn: integer): TColumnItem;
    procedure LoadSettingsFromINI(AIniFile: string; AType: TItemType);
    procedure SaveSettingsToINI(AIniFile: string; AType: TItemType);
  end;

implementation

uses
  IniFiles, guiItemView;

{ TColumnItem }

constructor TColumnItem.Create(AVisible: boolean; ACaption: string; AWidth: integer;
  ASortMethod: TSortMethodType; ASortDirection: TSortDirectionType; AAlignment: TAlignment);
begin
  inherited Create;
  FCaption := ACaption;
  FSortMethod := ASortMethod;
  FSortDirection := ASortDirection;
  FWidth := AWidth;
  FVisible := AVisible;
  FAlignment := AAlignment;
end;

function TColumnItem.GetPropID: word;
begin
//todo
  Result := 0;
end;

{ TColumnList }

function TColumnList.GetItems(Index: integer): TColumnItem;
begin
  Result := TColumnItem(FItems[Index]);
end;

constructor TColumnList.Create;
begin
  inherited Create;
  FItems := TObjectList.Create;
end;

destructor TColumnList.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TColumnList.Add(AVisible: boolean; ACaption: string; AWidth: integer;
      ASortMethod: TSortMethodType; AAlignment: TAlignment);
begin
  FItems.Add(TColumnItem.Create(AVisible, ACaption, AWidth, ASortMethod,
    sdAscending, AAlignment));
end;

procedure TColumnList.CopyToListView(Sender: TObject; AListView: TListView);
var
  i, Num: integer;
begin
  with AListView do begin
    Columns.BeginUpdate;
    Columns.Clear;

    Num := 0;
    for i:=0 to FItems.Count - 1 do with TColumnItem(FItems[i]) do begin
      FListColumn := -1;
      if Visible then begin
        Columns.Add;
        Columns[Num].Width  := Width;
        Columns[Num].Caption:= Caption;
        // The columns Tag property will be used in TListview to find the
        // correct column information - to do: BUG in TListview! Does not work
        Columns[Num].Tag := i;
        Columns[Num].Alignment := FAlignment;

        // Plus and Minus signs - we do it here to avoid flicker
        if assigned(Sender) and (Sender is TItemView) then
          if TItemView(Sender).SortMethod = SortMethod then begin
            // Add the '+' or '-' in the right spot
            if TItemView(Sender).SortDirection = sdAscending then
              Columns[Num].Caption := Columns[Num].Caption + '+'
            else
              Columns[Num].Caption := Columns[Num].Caption + '-';
          end;

        // Workaround: We will use FindColumn which uses this FListColumn variable
        FListColumn := Num;
        inc(Num)
      end;
    end;
    Columns.EndUpdate;
  end;
end;

function TColumnList.FindColumn(AListColumn: integer): TColumnItem;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FItems.Count - 1 do
    if TColumnItem(FItems[i]).FListColumn = AListColumn then begin
      Result := TColumnItem(FItems[i]);
      exit;
    end;
end;

procedure TColumnList.LoadSettingsFromINI(AIniFile: string; AType: TItemType);
var
  i: integer;
  Ini: TIniFile;
  Section: string;
begin
  Ini := TIniFile.Create(AIniFile);
  try
    case AType of
      itFile: Section := 'FileColumns';
      itFolder: Section := 'FolderColumns';
    else
      exit;
    end;//case
    for i:= 0 to FItems.Count - 1 do with TColumnItem(FItems[i]) do begin
      Visible := Ini.ReadBool(Section, Format('Visible%d', [i]), Visible);
      // Don't forget the Options dialog, it will read the INI too
      Ini.WriteBool(Section, Format('Visible%d', [i]), Visible);
    end;
  finally
    Ini.Free;
  end;
end;

procedure TColumnList.SaveSettingsToINI(AIniFile: string; AType: TItemType);
var
  i: integer;
  Ini: TIniFile;
  Section: string;
begin
  Ini := TIniFile.Create(AIniFile);
  try
    case AType of
      itFile: Section := 'FileColumns';
      itFolder: Section := 'FolderColumns';
    else
      exit;
    end;//case
    for i:= 0 to FItems.Count - 1 do with TColumnItem(FItems[i]) do begin
      Ini.WriteBool(Section, Format('Visible%d', [i]), Visible);
    end;
  finally
    Ini.Free;
  end;
end;

end.
