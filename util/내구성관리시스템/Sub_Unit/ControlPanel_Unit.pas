unit ControlPanel_Unit;

interface

uses
  Main_Unit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  NxCollection, CurvyControls, Vcl.ExtCtrls,System.StrUtils, JPEG, JvImage, Data.DB,
  JvExExtCtrls, GraphicUtil;




type
  TControlPanel_Frm = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel32: TPanel;
    CurvyPanel2: TCurvyPanel;
    NAMEPanel: TPanel;
    Panel5: TPanel;
    LOCATION: TPanel;
    Panel6: TPanel;
    MAKER: TPanel;
    Panel8: TPanel;
    SN: TPanel;
    CB_IMAGE: TNxImage;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FOwner : TMain_Frm;

    procedure control_the_edit(aEquipno:String; AEquipName: string);
  end;

var
  ControlPanel_Frm: TControlPanel_Frm;
  function Create_ControlPanel_Frm(aEquipno:String; AEquipName: string):Boolean;

implementation
USES
DataModule_unit;

{$R *.dfm}
//AEquipType= CB: Control Box
//            EG: Engine
//            EQ: Equipment
function Create_ControlPanel_Frm(aEquipno,AEquipName: string):Boolean;
begin
  ControlPanel_Frm := TControlPanel_Frm.Create(nil);
  try
    with ControlPanel_Frm do
    begin
      control_the_edit(aEquipno, AEquipName);

      ShowModal;

      Result := True;
    end;
  finally
    FreeAndNil(ControlPanel_Frm);
  end;
end;

{ TControlPanel_Frm }

procedure TControlPanel_Frm.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TControlPanel_Frm.control_the_edit(aEquipno, AEquipName: string);
var
  str : String;
  ms : TMemoryStream;
  bmp : TPNGImage;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;

    if AEquipName = 'CB' then
    begin
      SQL.Add('SELECT * FROM HITEMS_EQUIP_LIST ' +
              'WHERE EQUIPNO = :param1 ');
      str := LeftStr(aEquipno,6);
      ParamByName('param1').AsString := str;
      Open;

      if RecordCount <> 0 then
      begin
        NAMEPANEL.Caption := FieldByName('EQNAME').AsString;
        LOCATION.Caption  := FieldByName('LOC_DETAIL').AsString;
        MAKER.Caption := FieldByName('EQMAKER').AsString;
        SN.Caption  := FieldByName('SN').AsString;
        //ENGINE  := FieldByName('ENGIN').AsString;

        if not FieldByName('EQIMG').IsNull then
        begin
         { ms := TMemoryStream.Create;//TFileStream.Create('C:\Temp\id_photo.png',fmOpenReadWrite);
          try
            bmp := TPNGImage.Create;
            try
              try
                TBlobField(FieldByName('EQIMG')).SaveToStream(ms);
                ms.Position := 0;
                bmp.LoadFromStream(ms);
                CB_IMAGE.Picture.graphic.Assign(bmp);
                CB_IMAGE.Invalidate;
                CB_IMAGE.Hint := '';
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
          LoadPictureFromBlobField(TBlobField(FieldByName('EQIMG')), CB_IMAGE.Picture);
        end else
        begin
          CB_IMAGE.Picture.Graphic := nil;
          CB_IMAGE.Invalidate;
        end;


      end;
    end;
  end;
end;


end.
