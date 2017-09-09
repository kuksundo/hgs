unit NetWork_Sub2_Unit;

interface

uses
  Main_Unit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, NxCollection,System.StrUtils,
  Vcl.Imaging.pngimage, CurvyControls,Data.DB, JvExExtCtrls, JvImage, JPEG, GraphicUtil;

type
  TNetWork_Sub2_Frm = class(TForm)
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
    Panel6: TPanel;
    MAKER: TPanel;
    Panel8: TPanel;
    MACNO1: TPanel;
    Panel10: TPanel;
    MACNO2: TPanel;
    IMAGE: TNxImage;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    procedure Network_the_edit(aEquipno:String; AEquipName: string);
  end;

var
  NetWork_Sub2_Frm: TNetWork_Sub2_Frm;
  function Create_NetWork_Sub2_Frm(aEquipno:String; AEquipName: string):Boolean;

implementation
USES
DataModule_unit;

{$R *.dfm}
//AEquipType= CB: Control Box
//            EG: Engine
//            EQ: Equipment
function Create_NetWork_Sub2_Frm(aEquipno,AEquipName: string):Boolean;
begin
  Network_sub2_Frm := TNetwork_sub2_Frm.Create(nil);
  try
    with Network_sub2_Frm do
    begin
      Network_the_edit(aEquipno, AEquipName);

      ShowModal;

      Result := True;
    end;
  finally
    FreeAndNil(Network_sub2_Frm);
  end;
end;

{ TControlPanel_Frm }

procedure TNetWork_Sub2_Frm.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TNetWork_Sub2_Frm.Network_the_edit(aEquipno, AEquipName: string);
var
  str : String;
  ms : TMemoryStream;
  bmp : TPNGImage;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;

    if AEquipName = 'EQ' then
    begin
    SQL.Add('SELECT A.*, B.* FROM HITEMS_EQUIP_LIST A, HITEMS_EQUIP_NETWORK B ' +
            'WHERE A.EQUIPNO = B.EQUIPNO ' +
            'AND A.EQUIPNO = :param1 ');
    str := LeftStr(aEquipno,6);
    ParamByName('param1').AsString := str;
    Open;

      if RecordCount <> 0 then
      begin
        NAMEPanel.Caption := FieldByname('EQNAME').AsString;
        MAKER.Caption := FieldByname('EQMAKER').AsString;
        LOCATION.Caption := FieldByname('LOC_DETAIL').AsString;
        //EQUIPNO.Caption := FieldByname('HHI_EQIP_NO').AsString;
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
  end;
end;


end.
