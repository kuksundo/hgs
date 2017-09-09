unit uDemo1;
// MIT License
//
// Copyright (c) 2009 - Robert Love
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,ComCtrls, Grids, ValEdit;

type
  TObjectProcedure = procedure of object;
  {$METHODINFO ON}
  TMethodEdit = class(TEdit)
  published
    procedure NeedAnExampleProcedure(aParam1,aParam2 : String);
    function NeedAnExampleFunction(aInteger : Integer;aString : String) : String;
  end;
  {$METHODINFO OFF}


  TForm3 = class(TForm)
    Button1: TButton;
    pcMain: TPageControl;
    tsInteract: TTabSheet;
    tsQuery: TTabSheet;
    pcQuery: TPageControl;
    tsPropListData: TTabSheet;
    ListView1: TListView;
    tsOther: TTabSheet;
    ListView2: TListView;
    tsMethodInfo: TTabSheet;
    ListView3: TListView;
    pcInteract: TPageControl;
    tsSetValues: TTabSheet;
    tsCopy: TTabSheet;
    tsMethodInvoke: TTabSheet;
    Button2: TButton;
    cbxPropListSetValues: TComboBox;
    edtNewValue: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button3: TButton;
    Button4: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    btnInvokeProc: TButton;
    edtMethodName1: TEdit;
    Label3: TLabel;
    edtMethodName2: TEdit;
    btnInvokeNotify: TButton;
    cbxMethodNames: TComboBox;
    Button6: TButton;
    Label4: TLabel;
    Button7: TButton;
    vlParms: TValueListEditor;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure cbxPropListSetValuesChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnInvokeProcClick(Sender: TObject);
    procedure btnInvokeNotifyClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure cbxMethodNamesChange(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DisplayPPropInfo(aObj : TObject;aView : TListView);
    procedure DisplayOtherInfo(aObj : TObject;aView : TListView);
    procedure DisplayMethodInfo(aObj : TObject;aView : TListView);

    procedure FillPropertyList(aObj : TObject;aCombo : TComboBox);
    function CopyObject(aObj : TObject) : TObject;
    procedure CopyProperties(aSource, aDest : TObject);

    procedure PopulateMethodsCombo(aClass : TClass; aCombo : TComboBox);
    procedure ExtractParameters(aObj : TObject;aMethodName : String;aLines : TStrings);
  published
    procedure HelloWorldMessage;
    procedure NotifyEventExample(Sender : TObject);
  end;


var
  Form3: TForm3;

implementation
uses TypInfo,ObjAuto,DetailedRTTI, AnsiStrings;

const
  SHORT_LEN = sizeof(ShortString) - 1;

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
 Comp : TComponent;
begin
 Comp := FindComponent('Edit1');
 DisplayPPropInfo(Comp,ListView1);
 DisplayOtherInfo(Comp,ListView2);
 DisplayMethodInfo(Comp,ListView3);
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  SetPropValue(FindComponent('Edit1'),cbxPropListSetValues.Text,edtNewValue.Text);
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
 // I did this as a Button to make it easier to demo, and explain (less magic)

 // Fill the Combo Box with the list of the properties from Edit1
  FillPropertyList(FindComponent('Edit1'),cbxPropListSetValues);

 // Find the Text Property to Default to and Trigger Event to display Value
  cbxPropListSetValues.ItemIndex := cbxPropListSetValues.Items.IndexOf('Text');
  cbxPropListSetValuesChange(nil);

end;

procedure TForm3.Button4Click(Sender: TObject);
var
 Obj : TObject;
begin
  Obj := CopyObject(FindComponent('Edit1'));
  // Reminder that limitations exist you can't access things that are not
  // published
  TWinControl(Obj).Parent := tsCopy;


end;

procedure TForm3.Button5Click(Sender: TObject);
var
  Edit1: TComponent;
  Header: PMethodInfoHeader;
  lResult: String;
begin
  Edit1 := FindComponent('Edit1');
  Header:= GetMethodInfo(Edit1, 'NeedAnExampleFunction');

  //function TMethodEdit.NeedAnExampleFunction(aInteger: Integer;
  //aString: String): String;
  lResult:= ObjectInvoke(Edit1, Header, [1,2], [23,'Hello World']);
  ShowMessage(lResult);
end;

procedure TForm3.Button6Click(Sender: TObject);
begin
  PopulateMethodsCombo(FindComponent('Edit1').ClassType,cbxMethodNames);
end;

procedure TForm3.Button7Click(Sender: TObject);
var
 Header : PMethodInfoHeader;
 HeaderEnd : Pointer;
 Params : array of Integer;
 I: Integer;
 Values : array of Variant;
 Comp : TComponent;
 lResult : String;
begin
 Comp := FindComponent('Edit1');
 Header := GetMethodInfo(Comp,cbxMethodNames.Text);
 SetLength(Params,vlParms.Strings.Count);
 SetLength(Values,vlParms.Strings.Count);
 for I := Low(Params) to High(Params) do
 begin
   Params[I] := I+1;
   Values[I] := vlParms.Strings.Values[vlParms.Strings.Names[I]];
 end;

 lResult := ObjectInvoke(Comp,Header,Params,Values);
 if Trim(lResult)  <> '' then
   ShowMessage(lResult);
end;

procedure TForm3.btnInvokeProcClick(Sender: TObject);
var
  Method : TMethod;
begin
  Method.Code := Self.MethodAddress(edtMethodName1.text);
  Method.Data := Self;
  TObjectProcedure(Method)();
end;

procedure TForm3.cbxMethodNamesChange(Sender: TObject);
begin
   ExtractParameters(FindComponent('Edit1'),cbxMethodNames.Text,vlParms.Strings);
end;

procedure TForm3.cbxPropListSetValuesChange(Sender: TObject);
var
 Comp : TComponent;
begin
  Comp := FindComponent('Edit1');
  if (cbxPropListSetValues.ItemIndex >= 0) then
     edtNewValue.Text := GetPropValue(Comp,cbxPropListSetValues.Text,True);
end;

function TForm3.CopyObject(aObj: TObject): TObject;
begin
  //Biggest limitition Need to know Constructor Definition to make this work.
  if aObj is TComponent then
  begin
    result := TComponentClass(aObj.ClassType).Create(TComponent(aObj).Owner);
  end
  else // Assume contructor with no params.
  begin
    result := aObj.ClassType.Create;
  end;
  CopyProperties(aObj,Result);
end;

procedure TForm3.CopyProperties(aSource, aDest: TObject);
var
 i : Integer;
 lCount : Integer;
 lPropList : PPropList;
 lClassSource,lClassDest : TObject;
 tk : TTypeKind;
begin
  lCount := GetPropList(aSource,lPropList);
  for I := 0 to lCount - 1 do
  begin
    // Special Name handling if Component as it can't duplicate
    if (lPropList^[I].Name = 'Name') and (aSource is TComponent) then
    begin
      // Just add '1' (it's good enough for a demo <G>)
      SetPropValue(aDest,lPropList^[I].Name,GetPropValue(aSource,lPropList^[I].Name)+'1');
    end
    else
    begin
       case lPropList^[I].PropType^.Kind of
         tkUnknown:; // Do Nothing can't handle
         tkInteger,
         tkInt64: SetOrdProp(aDest,lPropList^[I].Name,GetOrdProp(aSource,lPropList^[I]));
         tkChar: SetStrProp(aDest,lPropList^[I].Name,GetStrProp(aSource,lPropList^[I]));
         tkEnumeration: SetEnumProp(aDest,lPropList^[I].Name,GetEnumProp(aSource,lPropList^[I]));
         tkFloat: SetFloatProp(aDest,lPropList^[I].Name,GetFloatProp(aSource,lPropList^[I]));
         tkString: SetStrProp(aDest,lPropList^[I].Name,GetStrProp(aSource,lPropList^[I]));
         tkSet: SetSetProp(aDest,lPropList^[I].Name,GetSetProp(aSource,lPropList^[I]));
         tkClass:
         begin
           lClassSource := GetObjectProp(aSource,lPropList^[I].Name);
           lClassDest := GetObjectProp(aDest,lPropList^[I].Name);
           // If Object on Source is Created and Dest not then Set it directly
           if Assigned(lClassSource) and not Assigned(lClassDest) then
           begin
             SetObjectProp(aDest,lPropList^[I].Name,lClassSource);
           end
           else
           begin
             // Both Sides assigned copy the properties.
             if Assigned(lClassDest) then
             begin
               CopyProperties(lClassSource,lClassDest);
             end;
           end;
         end;
         tkMethod: SetMethodProp(aDest,lPropList^[I].Name,GetMethodProp(aSource,lPropList^[I])) ;
         tkWChar,
         tkLString,
         tkUString,
         tkWString: SetStrProp(aDest,lPropList^[I].Name,GetStrProp(aSource,lPropList^[I]));
         tkVariant: SetPropValue(aDest,lPropList^[I].Name,GetPropValue(aSource,lPropList^[I]));
         tkArray: SetStrProp(aDest,lPropList^[I].Name,GetStrProp(aSource,lPropList^[I]));
         //Not Needed for Demo, so I have not coded to save myself some time.
         tkRecord: ;
         tkInterface: ;
         tkDynArray: ;
       end;
    end;

  end;
end;

procedure TForm3.DisplayMethodInfo(aObj: TObject; aView: TListView);
var
 LI : TListItem;
 MethodList : TMethodInfoArray;
 I: Integer;
begin
  MethodList := GetMethods(aObj.ClassType);
  for I := Low(MethodList) to High(MethodList) do
  begin
    LI := aView.Items.Add;
    LI.Caption := MethodList[I]^.Name;
    LI.SubItems.Add(DescriptionOfMethod(aObj,MethodList[I]^.Name))
  end;
end;

procedure TForm3.DisplayOtherInfo(aObj: TObject; aView: TListView);
var
 LI : TListItem;
begin
  LI := aView.Items.Add;
  LI.Caption := 'ClassName';
  LI.SubItems.Add(aObj.ClassName);

  LI := aView.Items.Add;
  LI.Caption := 'ClassParent.ClassName';
  LI.SubItems.Add(aObj.ClassParent.ClassName);

  LI := aView.Items.Add;
  LI.Caption := 'ClassParent.ClassParent.ClassName';
  LI.SubItems.Add(aObj.ClassParent.ClassParent.ClassName);

  LI := aView.Items.Add;
  LI.Caption := 'UnitName';
  LI.SubItems.Add(aObj.UnitName);

  LI := aView.Items.Add;
  LI.Caption := 'ClassParent.UnitName';
  LI.SubItems.Add(aObj.ClassParent.UnitName);
end;

procedure TForm3.DisplayPPropInfo(aObj: TObject; aView: TListView);
var
 LI : TListItem;
 lPropList : PPropList;
 lCount : Integer;
 I : Integer;
begin
  lCount := GetPropList(aobj,lPropList);
  for I := 0 to lCount - 1 do
  begin
    LI := aView.Items.Add;
    LI.Caption := lPropList^[I].Name;
    LI.SubItems.Add(lPropList^[I].PropType^.Name);
    LI.SubItems.Add(GetEnumName(TypeInfo(TTypeKind),Integer(lPropList^[I].PropType^.Kind)));
    LI.SubItems.Add(IntToStr(Integer(lPropList^[I].GetProc)));
    LI.SubItems.Add(IntToStr(Integer(lPropList^[I].SetProc)));
    LI.SubItems.Add(IntToStr(Integer(lPropList^[I].StoredProc)));
    LI.SubItems.Add(IntToStr(lPropList^[I].Index));
    LI.SubItems.Add(IntToStr(lPropList^[I].Default));
    LI.SubItems.Add(IntToStr(lPropList^[I].NameIndex));
    LI.SubItems.Add(GetPropValue(aobj,lPropList^[I].Name,true));
  end;

end;

procedure TForm3.ExtractParameters(aObj : TObject; aMethodName: String;
  aLines: TStrings);
var
 Header : PMethodInfoHeader;
 HeaderEnd : Pointer;
 Params, Param: PParamInfo;
begin
 Header := GetMethodInfo(aObj,aMethodName);
 // Check the length is greater than just that of the name
 Assert(Header.Len > SizeOf(TMethodInfoHeader) - SHORT_LEN + Length(Header.Name),'METHODINFO missing for Specified Class');

 headerEnd := Pointer(Integer(header) + header^.Len);
 // Get a pointer to the param info
 Params := PParamInfo(Integer(header) + SizeOf(header^) - SHORT_LEN + SizeOf(TReturnInfo) + Length(header^.Name));
 // Clear Destination StringList
  aLines.Clear;
 // Loop over the parameters
 Param := Params;
 while Integer(Param) < Integer(headerEnd) do
 begin
   // Result will be here with no name for functions.
   if Length(trim(Param.Name))  > 0 then
      aLines.Values[Param.Name] := 'Specify';
   // Find next param
   Param := Param.NextParam;
 end;
// Remove First Parameter (it's needs to always be aObj)
aLines.Delete(0);

end;

procedure TForm3.FillPropertyList(aObj: TObject; aCombo: TComboBox);
var
  PropList : PPropList;
  PropCount : Integer;
  I : Integer;
begin
  aCombo.Items.Clear;
  GetMem(PropList,SizeOf(Pointer) * GetTypeData(aObj.ClassInfo)^.PropCount);
  PropCount := GetPropList(aObj.ClassInfo,tkProperties, PropList,true);
  try
    for I := 0 to PropCount- 1 do
    begin
      aCombo.Items.Add(PropList^[I].Name);
    end;
  finally
    FreeMem(PropList);
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
var
  edt : TMethodEdit;
begin
  edt := TMethodEdit.Create(self);
  edt.Parent := Self;
  edt.Top := 5;
  edt.Left := 5;
  edt.Width := 300;
  edt.Text := 'Working with this edit for RTTI Information';
  edt.Name := 'Edit1';


  // Since I compile with a different active often!
  //  pcMain.ActivePage := tsQuery;
  //  pcQuery.ActivePage := tsPropListData;
  //  pcInteract.ActivePage := tsSetValues;
end;

procedure TForm3.HelloWorldMessage;
begin
  ShowMessage('HelloWorld');
end;

procedure TForm3.btnInvokeNotifyClick(Sender: TObject);
var
  Method : TMethod;
begin
  Method.Code := Self.MethodAddress(edtMethodName2.text);
  Method.Data := Self;
  TnotifyEvent(Method)(self);
end;

procedure TForm3.NotifyEventExample(Sender: TObject);
begin
  ShowMessage('NotifyEventExample');
end;

procedure TForm3.PopulateMethodsCombo(aClass: TClass; aCombo: TComboBox);
var
 MethodList : TMethodInfoArray;
 I: Integer;
begin
  MethodList := GetMethods(aClass);
  aCombo.Items.Clear;
  for I := Low(MethodList) to High(MethodList) do
  begin
    aCombo.Items.Add(MethodList[I]^.Name);
  end;
end;


{ TMethodEdit }

function TMethodEdit.NeedAnExampleFunction(aInteger: Integer;
  aString: String): String;
begin
 result := astring + ' ' + IntToStr(aInteger);
end;

procedure TMethodEdit.NeedAnExampleProcedure(aParam1, aParam2: String);
begin
  Showmessage(AParam1 + aParam2);
end;

end.
