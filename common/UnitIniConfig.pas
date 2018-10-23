unit UnitIniConfig;

interface

uses inifiles, System.TypInfo, System.SysUtils;

type
  TIniConfig = class
  private
//    FIniFile: TMemIniFile;
  protected
    type
      TCustomSaveMethod = function  (Self : TObject; P : Pointer) : String;
      TCustomLoadMethod = procedure (Self : TObject; const Str : String);

  public
    procedure Save (const FileName : String);
    procedure Load (const FileName : String);
  end;

implementation

{ TIniConfig }

procedure TIniConfig.Load(const FileName: String);
const
  PropNotFound = '_PROP_NOT_FOUND_';
var
  IniFile : TMemIniFile;
  i, Count : Integer;
  List : PPropList;
  PropInfo: PPropInfo;
  TypeName, PropName, InputString, MethodName : String;
  LoadMethod : TCustomLoadMethod;
begin
//  FSettings := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  IniFile := TMemIniFile.Create (FileName);
  try
    Count := GetPropList(Self.ClassInfo, tkProperties, nil) ;
    GetMem (List, Count * SizeOf (PPropInfo)) ;
    try
      GetPropList (Self.ClassInfo, tkProperties, List);

      for i := 0 to Count-1 do
      begin
        PropInfo := List^[i];
      //        TypeName  := String (List [i]^.PropType^.Name);
        PropName  := String(PropInfo.Name);
//        InputString := IniFile.ReadInteger ('Options', PropName, 0);
//
//        if (InputString = PropNotFound) then
//          Continue;

        Case PropInfo.PropType^.Kind Of
          tkInteger, tkChar, tkEnumeration, tkSet, tkWChar:begin
            SetOrdProp( Self, propinfo, IniFile.ReadInteger ('Options', PropName, 0));
          end;
          tkFloat:
            SetFloatProp( Self, propinfo, StrToFloatDef(IniFile.ReadString ('Options', PropName, ''), 0.0));
          tkString, tkLString:
            SetStrProp( Self, propinfo, IniFile.ReadString ('Options', PropName, ''));
          tkWString:
            SetWideStrProp( Self, propinfo, IniFile.ReadString ('Options', PropName, ''));
//          tkMethod:
//            SetMethodProp( Result, propinfo,
//                           GetMethodProp( anObj, propinfo ));
          tkInt64:
            SetInt64Prop( Self, propinfo, IniFile.ReadInteger ('Options', PropName, 0));
//          tkVariant:
//            SetVariantProp( Result, propinfo,
//                            GetVariantProp( anObj, propinfo ));
//          tkInterface:
//            SetInterfaceProp( Result, propinfo,
//                              GetInterfaceProp( anObj, propinfo ));
//          tkClass: Begin
//             obj := GetObjectProp( anObj, propinfo );
//             If Assigned( obj ) Then Begin
//               If obj Is TComponent Then
//                 SetObjectProp( Result, propinfo, obj )
//               Else If obj Is TPersistent Then Begin
//                 obj2 := GetObjectProp( result, propinfo, TPersistent);
//                 If Assigned( obj2 ) Then
//                   TPersistent( obj2 ).Assign( TPersistent(obj));
//               End; { If }
//             End; { If }
//           End; { Case tkClass }
//        Else
          // we don't handle these property types:
          // tkArray, tkRecord, tkDynArray
        End; { Case }

//        MethodName := 'Load' + TypeName;
//        LoadMethod := Self.MethodAddress (MethodName);
//        if not Assigned (LoadMethod) then
//          raise EConfigLoadError.Create ('No load method for custom type ' + TypeName);
//        LoadMethod (Self, InputString);
      end;//for
    finally
      FreeMem (List, Count * SizeOf (PPropInfo));
    end;
  finally
    FreeAndNil (IniFile);
  end;
end;

procedure TIniConfig.Save(const FileName: String);
var
  IniFile : TMemIniFile;
  i, Count : Integer;
  List : PPropList;
  PropInfo: PPropInfo;
  TypeName, PropName, InputString, MethodName : String;
  LoadMethod : TCustomLoadMethod;
begin
  IniFile := TMemIniFile.Create (FileName);
  try
    Count := GetPropList(Self.ClassInfo, tkProperties, nil) ;
    GetMem (List, Count * SizeOf (PPropInfo)) ;
    try
      GetPropList (Self.ClassInfo, tkProperties, List);

      for i := 0 to Count-1 do
      begin
        PropInfo := List^[i];
        PropName  := String(PropInfo.Name);

        Case PropInfo.PropType^.Kind Of
          tkInteger, tkChar, tkEnumeration, tkSet, tkWChar:begin
            PropInfo.SetProc
            SetOrdProp( Self, propinfo, IniFile.ReadInteger ('Options', PropName, 0));
          end;
          tkFloat:
            SetFloatProp( Self, propinfo, StrToFloatDef(IniFile.ReadString ('Options', PropName, ''), 0.0));
          tkString, tkLString:
            SetStrProp( Self, propinfo, IniFile.ReadString ('Options', PropName, ''));
          tkWString:
            SetWideStrProp( Self, propinfo, IniFile.ReadString ('Options', PropName, ''));
//          tkMethod:
//            SetMethodProp( Result, propinfo,
//                           GetMethodProp( anObj, propinfo ));
          tkInt64:
            SetInt64Prop( Self, propinfo, IniFile.ReadInteger ('Options', PropName, 0));
//          tkVariant:
//            SetVariantProp( Result, propinfo,
//                            GetVariantProp( anObj, propinfo ));
//          tkInterface:
//            SetInterfaceProp( Result, propinfo,
//                              GetInterfaceProp( anObj, propinfo ));
//          tkClass: Begin
//             obj := GetObjectProp( anObj, propinfo );
//             If Assigned( obj ) Then Begin
//               If obj Is TComponent Then
//                 SetObjectProp( Result, propinfo, obj )
//               Else If obj Is TPersistent Then Begin
//                 obj2 := GetObjectProp( result, propinfo, TPersistent);
//                 If Assigned( obj2 ) Then
//                   TPersistent( obj2 ).Assign( TPersistent(obj));
//               End; { If }
//             End; { If }
//           End; { Case tkClass }
//        Else
          // we don't handle these property types:
          // tkArray, tkRecord, tkDynArray
        End; { Case }

//        MethodName := 'Load' + TypeName;
//        LoadMethod := Self.MethodAddress (MethodName);
//        if not Assigned (LoadMethod) then
//          raise EConfigLoadError.Create ('No load method for custom type ' + TypeName);
//        LoadMethod (Self, InputString);
      end;//for
    finally
      FreeMem (List, Count * SizeOf (PPropInfo));
    end;
  finally
    FreeAndNil (IniFile);
  end;
end;

end.
