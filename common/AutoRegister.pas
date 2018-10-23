unit AutoRegister;
{uses AutoRegister;

type
  [TAutoRegister]
  TMyClass = class(TPeristent)
  end;

  [TAutoRegister]
  TMyCoolClass = class(TInterfacedPersistent)
  end;
}
interface

uses
System.Rtti, System.TypInfo, System.Sysutils, System.Classes;

type

// Our fancy shmancy attribute
TAutoRegister = class(TCustomAttribute)
end;

implementation

// This procedure walks through all classtypes and isolates
// those with our TAutoRegister attribute.
// It then locates the actual classtype and registeres it
// with Delphi's persistance layer
procedure ProcessAutoRegisterAttributes;
var
  ctx : TRttiContext;
  typ : TRttiType;
  attr : TCustomAttribute;
  LRealType: TClass;
  LAccess: PTypeData;
begin
  ctx := TRttiContext.Create();
  try
    for typ in ctx.GetTypes() do
    begin
      if typ.TypeKind = tkClass then
      begin
        for attr in typ.GetAttributes() do
        begin
          if attr is TAutoRegister then
          begin
            LAccess := GetTypeData(typ.Handle);
            if LAccess <> nil then
            begin
              LRealType := LAccess^.ClassType;
              if LRealType <> nil then
              begin
                if LRealType.InheritsFrom(TPersistent)
                or LRealType.InheritsFrom(TInterfacedPersistent) then
                begin
                  RegisterClass( TPersistentClass(LRealType) );
                end;
              end;
              break;
            end;
          end;
        end;
      end;
    end;
  finally
    ctx.Free();
  end;
end;

// We want to register all the classes decorated with our little
// attribute when this unit is loaded into memory
Initialization
begin
  ProcessAutoRegisterAttributes;
end;

end.
