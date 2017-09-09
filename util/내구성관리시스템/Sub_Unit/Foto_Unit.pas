unit Foto_Unit;

interface

uses
  {Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, JvImage, GraphicUtil, Data.DB, System.StrUtils,
  PictureContainer, Vcl.Imaging.jpeg;

type
  TFoto_frm = class(TForm)
    Image1: TImage;
  private
    { Private declarations }
    FEquipNo:String;
  public
    { Public declarations }
    procedure Foto_edit(aEquipno: string);
  end;

var
  Foto_frm: TFoto_frm;
  function Create_Foto(aEquipNo:String):Boolean;
implementation
uses
DataModule_unit;

{$R *.dfm}

function Create_Foto(aEquipNo:String):Boolean;
begin
  Result := False;
  Foto_frm := TFoto_frm.Create(nil);
  try
    with Foto_frm do
    begin
      if aEquipNo <> '' then
      begin
        FEquipNo := aEquipNo;
        Foto_edit(aEquipno);
      end;

      ShowModal;

      if ModalResult = mrOk then
        Result := True;

    end;
  finally
    FreeAndNil(Foto_frm);
  end;
end;

{ TFoto_frm }

procedure TFoto_frm.Foto_edit(aEquipno: string);
var
  str : String;
  ms : TMemoryStream;
  bmp : TJPEGImage;
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

      if not FieldByName('SPEC_IMG').IsNull then
      begin
        LoadPictureFromBlobField(TBlobField(FieldByName('SPEC_IMG')), IMAGE1.Picture);

        Image1.Invalidate;
      end else
      begin
        IMAGE1.Picture.Graphic := nil;
        IMAGE1.Invalidate;
      end;

    end;
  end;
end;

end.
