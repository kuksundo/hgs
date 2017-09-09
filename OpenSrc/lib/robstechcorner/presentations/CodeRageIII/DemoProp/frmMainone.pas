unit frmMainone;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmProperties = class(TForm)
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
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cbxObjectListChange(Sender: TObject);
    procedure cbxPropertyChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    procedure FillObjectList;
    procedure FillPropertyList(Comp : TComponent);
  public
    { Public declarations }
  end;

var
  frmProperties: TfrmProperties;

implementation
uses TypInfo;

{$R *.dfm}

procedure TfrmProperties.Button2Click(Sender: TObject);
var
 Comp : TComponent;
begin
  Comp := Self.FindComponent(cbxObjectList.Text);
  if Assigned(Comp) and (cbxProperty.ItemIndex >= 0) then
     setPropValue(Comp,cbxProperty.Text,edtValue.Text);
end;

procedure TfrmProperties.cbxObjectListChange(Sender: TObject);
var
 Comp : TComponent;
begin
  Comp := Self.FindComponent(cbxObjectList.Text);
  if Assigned(Comp) then
     FillPropertyList(Comp);
end;

procedure TfrmProperties.cbxPropertyChange(Sender: TObject);
var
 Comp : TComponent;
begin
  Comp := Self.FindComponent(cbxObjectList.Text);
  if Assigned(Comp) and (cbxProperty.ItemIndex >= 0) then
     edtValue.Text := GetPropValue(Comp,cbxProperty.Text,True);
end;

procedure TfrmProperties.FillObjectList;
var
  I : Integer;
begin
  for I := 0 to Self.ComponentCount -1 do
  begin
    cbxObjectList.Items.Add(Self.Components[I].Name);
  end;
end;

procedure TfrmProperties.FillPropertyList(Comp: TComponent);
var
  PropList : PPropList;
  PropCount : Integer;
  I : Integer;
begin
  cbxProperty.Items.Clear;
  GetMem(PropList,SizeOf(Pointer) * GetTypeData(Comp.ClassInfo)^.PropCount);
  PropCount := GetPropList(Comp.ClassInfo,tkProperties, PropList,true);
  try
    for I := 0 to PropCount- 1 do
    begin
      cbxProperty.Items.Add(PropList^[I].Name);
    end;
  finally
    FreeMem(PropList);
  end;
end;

procedure TfrmProperties.FormCreate(Sender: TObject);
begin
  FillObjectList;

end;

end.
