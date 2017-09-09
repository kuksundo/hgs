unit ajRegPathManager;

interface

uses Windows;

type
  TajRegPathManager = class(TObject)
  private
    fRootHKEY     : HKEY;
    fRootHKEYText : string;
    fFullPath     : string;
    fSubPath      : string;
  protected
    procedure SetfFullPath  (Value : string);
  public
    property  RootHKEY      : HKEY      read fRootHKEY;
    property  RootHKEYText  : string    read fRootHKEYText;
    property  FullPath      : string    read fFullPath  write SetfFullPath;
    property  SubPath       : string    read fSubPath;
  end;

implementation

uses ajRegistry;

{--------------------------------------------------------------------------------------------------}
{                                     TajRegPathManager                                            }
{--------------------------------------------------------------------------------------------------}

procedure TajRegPathManager.SetfFullPath(Value : string);
var
  KeyText   : string;
  DelimPos  : integer;
begin
  if (fFullPath <> Value) then begin
    fFullPath := Value;
    DelimPos  := Pos('\', fFullPath);
    if (DelimPos > 0) then begin
      KeyText   := Copy(fFullPath, 1, pred(DelimPos));
      fSubPath  := Copy(fFullPath, succ(DelimPos), Length(fFullPath) - DelimPos);
    end else begin
      KeyText   := fFullPath;
      fSubPath  := '';
    end; {if}

    if (fRootHKEYText <> KeyText) then begin
      fRootHKEYText := KeyText;
      fRootHKEY     := HKEYTextToHKEY(fRootHKEYText);
    end; {if}

  end; {if}
end; {SetfFullPath}

end.
 