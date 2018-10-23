unit SerializableObjectList;

interface

{$STRONGLINKTYPES ON}

uses System.Classes, System.Generics.Collections, System.Rtti;

type
  TSerializable = class abstract(TObject)
  public
    { Public declarations }
    procedure LoadFromStream(const S: TStream); virtual; abstract;
    procedure SaveToStream(const S: TStream); virtual; abstract;
  end;

  TSerializableList = class(TObjectList<TSerializable>)
  public
    procedure Serialize(const S: TStream);
    procedure UnSerialize(const S: TStream);
  end;

implementation

{ TSerializableList }

procedure TSerializableList.Serialize(const S: TStream);
var
  CurrentObj: TSerializable;
  StrLen, StrSize: Integer;
  ClsName: String;
begin
  S.Write(Self.Count, SizeOf(Integer));
  for CurrentObj in Self do
  begin
    ClsName := CurrentObj.QualifiedClassName();
    StrLen := Length(ClsName);
    StrSize := SizeOf(Char) * StrLen;

    S.Write(StrLen, SizeOf(Integer));
    S.Write(StrSize, SizeOf(Integer));
    S.Write(ClsName[1], StrSize);

    CurrentObj.SaveToStream(S);
  end;
end;

procedure TSerializableList.UnSerialize(const S: TStream);
var
  I, NewIdx, TotalCount, Tmp, Tmp2: Integer;
  ClsName: String;
  Context: TRttiContext;
  RttiType: TRttiInstanceType;
begin
  Context := TRttiContext.Create();
  try
    S.Read(TotalCount, SizeOf(Integer));
    for I := 0 to TotalCount -1 do
    begin
      S.Read(Tmp, SizeOf(Integer));
      S.Read(Tmp2, SizeOf(Integer));

      SetLength(ClsName, Tmp);
      S.Read(ClsName[1], Tmp2);

      RttiType := (Context.FindType(ClsName) as TRttiInstanceType);
      if (RttiType <> nil) then
      begin
        NewIdx := Self.Add(TSerializable(RttiType.MetaclassType.Create()));
        Self[NewIdx].LoadFromStream(S);
      end;
    end;
  finally
    Context.Free();
  end;
end;

end.
