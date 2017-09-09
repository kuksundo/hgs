unit Network_Sub_Unit;

interface

uses
  Network_Unit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  NxCollection, CurvyControls, Vcl.ExtCtrls, GraphicUtil,  JPEG, Data.DB;

type
  TNetwork_sub_frm = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel32: TPanel;
    CurvyPanel2: TCurvyPanel;
    NAMEPanel: TPanel;
    Panel3: TPanel;
    IP1: TPanel;
    Panel4: TPanel;
    IP2: TPanel;
    Panel5: TPanel;
    LOCATION: TPanel;
    Button1: TButton;
    Panel6: TPanel;
    MAKER: TPanel;
    Panel8: TPanel;
    MACNO1: TPanel;
    Panel10: TPanel;
    MACNO2: TPanel;
    IMAGE: TNxImage;
    Panel7: TPanel;
    EQUIPNO: TPanel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FEquipNo:String;
  public
    { Public declarations }
    FOwner : TNetwork_Frm;
    procedure Get_EquipInfo(aEquipNo:String);
  end;

var
  Network_sub_frm: TNetwork_sub_frm;
  function Create_Network_Sub_Frm(aEquipNo:String):Boolean;

implementation
USES
DataModule_unit;

{$R *.dfm}
function Create_Network_Sub_Frm(aEquipNo:String):Boolean;
begin
  Result := False;
  Network_sub_frm := TNetwork_sub_frm.Create(nil);
  try
    with Network_sub_frm do
    begin
      if aEquipNo <> '' then
      begin
        FEquipNo := aEquipNo;
        Get_EquipInfo(FEquipNo);
      end;

      ShowModal;

      if ModalResult = mrOk then
        Result := True;

    end;
  finally
    FreeAndNil(Network_sub_frm);
  end;
end;

procedure TNetwork_sub_frm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TNetwork_sub_frm.Get_EquipInfo(aEquipNo: String);
var
  lsql, lsql2 : String;

begin
  lsql := 'select * from HITEMS_EQUIP_LIST WHERE EQUIPNO LIKE :param1 ';

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT A.*, B.* FROM HITEMS_EQUIP_LIST A, HITEMS_EQUIP_NETWORK B ' +
            'WHERE A.EQUIPNO = B.EQUIPNO ' +
            'AND A.EQUIPNO = :param1 ');

    ParamByName('param1').AsString := aEquipNo;
    Open;

    NAMEPanel.Caption := FieldByname('EQNAME').AsString;
    MAKER.Caption := FieldByname('EQMAKER').AsString;
    LOCATION.Caption := FieldByname('LOC_DETAIL').AsString;
    EQUIPNO.Caption := FieldByname('HHI_EQUIP_NO').AsString;
    MACNO1.Caption := FieldByName('MAC1').AsString;
    MACNO2.Caption := FieldByName('MAC2').AsString;
    IP1.Caption := FieldByname('IP').AsString;
    IP2.Caption := FieldByname('IP2').AsString;
            //IMAGE.Picture := FieldByname('EQIMG').AsString;

    if not FieldByName('EQIMG').IsNull then
    begin
      {ms := TMemoryStream.Create;//TFileStream.Create('C:\Temp\id_photo.png',fmOpenReadWrite);
      try
        bmp := TPNGImage.Create;
        try
          try
            TBlobField(FieldByName('EQIMG')).SaveToStream(ms);
            ms.Position := 0;
            bmp.LoadFromStream(ms);
            IMAGE.Picture.graphic.Assign(bmp);
            IMAGE.Invalidate;
            IMAGE.Hint := '';
           // JVimage1.Picture.Graphic.LoadFromStream(ms);

          except
            On E : Exception do
              ShowMessage(E.Message);
          end;
        finally
          FreeAndNil(bmp);
        end;
      finally
        FreeAndNil(ms);
      end;}
      LoadPictureFromBlobField(TBlobField(FieldByName('EQIMG')), IMAGE.Picture);
    end else
    begin
      IMAGE.Picture.Graphic := nil;
      IMAGE.Invalidate;
    end;
  end;
end;

end.
