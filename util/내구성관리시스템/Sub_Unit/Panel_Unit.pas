unit Panel_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  NxCollection, CurvyControls, Vcl.ExtCtrls, Main_Unit, JvImage, GraphicUtil, Data.DB, System.StrUtils,
  PictureContainer;

type
  TPanel_Frm = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel32: TPanel;
    CurvyPanel2: TCurvyPanel;
    Panel30: TPanel;
    Pn_Name: TPanel;
    Pn_Image: TNxImage;
    Panel3: TPanel;
    Pn_Location: TPanel;
    Panel4: TPanel;
    Pn_Maker: TPanel;
    Panel5: TPanel;
    Pn_Spec: TPanel;
    Button1: TButton;
    PictureContainer1: TPictureContainer;
    procedure Button1Click(Sender: TObject);
    procedure Pn_SpecClick(Sender: TObject);
  private
    { Private declarations }
    FEquipNo:String;
  public
    { Public declarations }

    procedure Panel_the_edit(aEquipno: string);
  end;

var
  Panel_Frm: TPanel_Frm;
  function Create_Panel_Frm(aEquipNo:String):Boolean;
implementation
USES
DataModule_unit,
Foto_Unit;

{$R *.dfm}
function Create_Panel_Frm(aEquipNo:String):Boolean;
begin
  Result := False;
  Panel_frm := TPanel_frm.Create(nil);
  try
    with Panel_frm do
    begin
      if aEquipNo <> '' then
      begin
        FEquipNo := aEquipNo;
        Panel_the_edit(aEquipno);
      end;

      ShowModal;

      if ModalResult = mrOk then
        Result := True;

    end;
  finally
    FreeAndNil(Panel_frm);
  end;
end;

{ TControlPanel_Frm }

procedure TPanel_Frm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TPanel_Frm.Panel_the_edit(aEquipno: string);
var
  str : String;
  ms : TMemoryStream;
  bmp : TPNGImage;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM HITEMS_EQUIP_LIST '+
            'WHERE EQUIPNO = :param1 ');
    str := LeftStr(aEquipno,6);
    ParamByName('param1').AsString := str;
    Open;



    if RecordCount <> 0 then
    begin
      Pn_Name.Caption := FieldByname('EQNAME').AsString;
      Pn_Maker.Caption := FieldByname('EQMAKER').AsString;
      Pn_Location.Caption := FieldByname('LOC_DETAIL').AsString;
      Pn_Spec.Caption := FieldByName('SPEC').AsString;

      if not FieldByName('EQIMG').IsNull then
      begin
        LoadPictureFromBlobField(TBlobField(FieldByName('EQIMG')), Pn_Image.Picture);
      end else
      begin
        Pn_Image.Picture.Graphic := nil;
        Pn_Image.Invalidate;
      end;

    end;
  end;
end;



procedure TPanel_Frm.Pn_SpecClick(Sender: TObject);
var
  LName : String;
  //aEquipno: string;
begin
  if Sender is TPanel then
  begin
    with TPanel(Sender) do
    begin
      Create_Foto(FEquipNo);
    end;
  end;
end;


end.
