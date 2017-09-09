unit frmMainTwo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  {.$METHODINFO ON}
  TfrmPropEvents = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Button1: TButton;
    CheckBox1: TCheckBox;
    cbxObjectList: TComboBox;
    RadioGroup1: TRadioGroup;
    Label1: TLabel;
    Memo1: TMemo;
    edtValue: TEdit;
    cbxProperty: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    btnChangePropValue: TButton;
    cbxEvents: TComboBox;
    Label4: TLabel;
    cbxMethods: TComboBox;
    btnChangeMethod: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblObject: TLabel;
    lblAddress: TLabel;
    Label8: TLabel;
    lblSig: TLabel;
    btnExecute: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cbxObjectListChange(Sender: TObject);
    procedure cbxPropertyChange(Sender: TObject);
    procedure btnChangePropValueClick(Sender: TObject);
    procedure cbxEventsChange(Sender: TObject);
    procedure cbxMethodsChange(Sender: TObject);
    procedure btnChangeMethodClick(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
  private
    { Private declarations }
    procedure FillObjectList;
    procedure FillPropertyList(Comp : TComponent);
    procedure FillEventlist(Comp : TComponent);
    procedure FillMethodList;
  public
    { Public declarations }
  published
    procedure ShowDelphiLive(Sender: TObject);
    procedure ShowHelloWorld(Sender : TObject);
  end;
  {$METHODINFO OFF}

var
  frmPropEvents: TfrmPropEvents;

implementation
uses TypInfo, ObjAuto,DetailedRTTI;

{$R *.dfm}

procedure TfrmPropEvents.btnChangeMethodClick(Sender: TObject);
var
 Comp : TComponent;
 Method : TMethod;
 Obj : TObject;
begin
  Comp := Self.FindComponent(cbxObjectList.Text);
  if Assigned(Comp) and (cbxEvents.ItemIndex >= 0) then
  begin
    Method.Code := Self.MethodAddress(cbxMethods.Text);
    Method.Data := Self;
    SetMethodProp(Comp,cbxEvents.Text,Method);
  end;
end;

procedure TfrmPropEvents.btnChangePropValueClick(Sender: TObject);
var
 Comp : TComponent;
begin
  Comp := Self.FindComponent(cbxObjectList.Text);
  if Assigned(Comp) and (cbxProperty.ItemIndex >= 0) then
     setPropValue(Comp,cbxProperty.Text,edtValue.Text);
end;

procedure TfrmPropEvents.btnExecuteClick(Sender: TObject);
var
 Method : TMethod;
begin
    Method.Code := Self.MethodAddress(cbxMethods.Text);
    Method.Data := Self;
    TNotifyEvent(Method)(self);
end;

procedure TfrmPropEvents.cbxEventsChange(Sender: TObject);
var
 Comp : TComponent;
 Method : TMethod;
 Obj : TObject;
begin
  Comp := Self.FindComponent(cbxObjectList.Text);
  if Assigned(Comp) and (cbxEvents.ItemIndex >= 0) then
  begin
     Method := GetMethodProp(Comp,cbxEvents.Text);
     // Method.Code is the address method
     // Method.Data is the Pointer to the Object that contains the Method
     lblAddress.Caption := IntToStr(Integer(Method.Code));
     Obj := TObject(Method.Data);
     //Get method name if available
     cbxMethods.Text := Obj.MethodName(Method.Code);
     if Obj is TComponent then
     begin
       lblObject.Caption := TComponent(Obj).Name + ':' + Obj.ClassName;
     end
     else
     begin
       lblObject.Caption := IntToStr(Integer(Method.Code)) + ':' + Obj.ClassName;
     end;
  end;
end;

procedure TfrmPropEvents.cbxMethodsChange(Sender: TObject);
begin
  if (cbxMethods.ItemIndex > -1) then
  begin
    lblSig.Caption := DescriptionOfMethod(Self,cbxMethods.Text);
  end;
end;

procedure TfrmPropEvents.cbxObjectListChange(Sender: TObject);
var
 Comp : TComponent;
begin
  Comp := Self.FindComponent(cbxObjectList.Text);
  if Assigned(Comp) then
  begin
     FillPropertyList(Comp);
     FillEventlist(Comp);
  end;
end;

procedure TfrmPropEvents.cbxPropertyChange(Sender: TObject);
var
 Comp : TComponent;
begin
  Comp := Self.FindComponent(cbxObjectList.Text);
  if Assigned(Comp) and (cbxProperty.ItemIndex >= 0) then
     edtValue.Text := GetPropValue(Comp,cbxProperty.Text,True);
end;

procedure TfrmPropEvents.FillEventlist(Comp: TComponent);
var
  PropList : PPropList;
  PropCount : Integer;
  I : Integer;
begin
  cbxEvents.Items.Clear;
  GetMem(PropList,SizeOf(Pointer) * GetTypeData(Comp.ClassInfo)^.PropCount);
  try
    PropCount := GetPropList(Comp.ClassInfo,tkMethods, PropList,true);
    for I := 0 to PropCount- 1 do
    begin
      cbxEvents.Items.Add(PropList^[I].Name);
    end;
  finally
    FreeMem(PropList);
  end;
end;

procedure TfrmPropEvents.FillMethodList;
var
  MethodList : TMethodInfoArray;
  MethodInfo : PMethodInfoHeader;
begin
  MethodList := GetMethods(Self.ClassType);
  for MethodInfo in MethodList do
  begin
     cbxMethods.Items.Add(MethodInfo^.Name);
  end;
end;

procedure TfrmPropEvents.FillObjectList;
var
  I : Integer;
begin
  for I := 0 to Self.ComponentCount -1 do
  begin
    cbxObjectList.Items.Add(Self.Components[I].Name);
  end;
end;

procedure TfrmPropEvents.FillPropertyList(Comp: TComponent);
var
  PropList : PPropList;
  PropCount : Integer;
  I : Integer;
begin
  cbxProperty.Items.Clear;
  GetMem(PropList,SizeOf(Pointer) * GetTypeData(Comp.ClassInfo)^.PropCount);
  try
    PropCount := GetPropList(Comp.ClassInfo,tkProperties, PropList,true);
    for I := 0 to PropCount- 1 do
    begin
      cbxProperty.Items.Add(PropList^[I].Name);
    end;
  finally
    FreeMem(PropList);
  end;
end;

procedure TfrmPropEvents.FormCreate(Sender: TObject);
begin
  FillObjectList;
  FillMethodList;
end;


procedure TfrmPropEvents.ShowDelphiLive(Sender: TObject);
begin
  ShowMessage('Hello to Everyone at DelphiLive!');
end;

procedure TfrmPropEvents.ShowHelloWorld(Sender: TObject);
begin
  ShowMessage('Hello World');
end;

end.
