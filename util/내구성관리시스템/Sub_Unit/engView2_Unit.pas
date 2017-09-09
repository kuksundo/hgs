unit engView2_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  NxCollection, CurvyControls, Vcl.ExtCtrls, Main_Unit, JvImage, GraphicUtil, Data.DB, System.StrUtils;

type
  Tengview2_Frm = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel32: TPanel;
    CurvyPanel2: TCurvyPanel;
    Panel30: TPanel;
    pn_engType: TPanel;
    NxImage1: TNxImage;
    Panel3: TPanel;
    pn_projno: TPanel;
    Panel4: TPanel;
    pn_projName: TPanel;
    Panel5: TPanel;
    pn_engIn: TPanel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FEquipNo:String;
  public
    { Public declarations }
    procedure engview2_the_edit(aProjNo:String);
  end;

var
  engview2_Frm: Tengview2_Frm;
  function Create_engview2_Frm(aProjNo:String):Boolean;

implementation
USES
DataModule_unit;

{$R *.dfm}
function Create_engview2_Frm(aProjNo:String):Boolean;
begin
  Result := False;
  engview2_frm := Tengview2_frm.Create(nil);
  try
    with engview2_frm do
    begin
      if aProjNo <> '' then
      begin
        FEquipNo := aProjNo;
        engview2_the_edit(aProjNo);
      end;

      ShowModal;

      if ModalResult = mrOk then
        Result := True;

    end;
  finally
    FreeAndNil(engview2_frm);
  end;
end;

{ TControlPanel_Frm }

procedure Tengview2_Frm.Button1Click(Sender: TObject);
begin
  close;
end;

procedure Tengview2_Frm.engview2_the_edit(aProjNo:String);
var
  str : String;
  ms : TMemoryStream;
  bmp : TPNGImage;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM HIMSEN_INFO WHERE PROJNO = :param1 ');
    str := LeftStr(aProjNo,6);
    ParamByName('param1').AsString := str;
    Open;

    if RecordCount <> 0 then
    begin
      pn_engType.Caption := FieldByName('ENGTYPE').AsString;
      pn_projno.Caption  := aProjNo;
      pn_projName.Caption := FieldByName('PROJNAME').AsString;
      pn_engIn.Caption  := FieldByName('ENGIN').AsString;

      {if not FieldByName('EQIMG').IsNull then
      begin
        LoadPictureFromBlobField(TBlobField(FieldByName('EQIMG')), NXIMAGE1.Picture);
      end else
      begin
        NXIMAGE1.Picture.Graphic := nil;
        NXIMAGE1.Invalidate;
      end;}

    end;
  end;
end;

end.
