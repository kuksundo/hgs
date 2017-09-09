unit engView_Unit;

interface

uses
  Main_Unit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, NxCollection,
  CurvyControls, Vcl.Imaging.pngimage,System.StrUtils;

type
  TengView_Frm = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FOwner : TMain_Frm;

    procedure fill_the_edit(aProjNo:String; AEquipType: string);
  end;

var
  engView_Frm: TengView_Frm;
  function Create_engView_Frm(aProjNo:String; AEquipType: string):Boolean;


implementation
USES
DataModule_unit;

{$R *.dfm}

//AEquipType= CB: Control Box
//            EG: Engine
//            EQ: Equipment
function Create_engView_Frm(aProjNo,AEquipType: string):Boolean;
begin
  engView_Frm := TengView_Frm.Create(nil);
  try
    with engView_Frm do
    begin
      fill_the_edit(aProjNo, AEquipType);

      ShowModal;

      Result := True;
    end;
  finally
    FreeAndNil(engView_Frm);
  end;
end;

procedure TengView_Frm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TengView_Frm.fill_the_edit(aProjNo: String; AEquipType: string);
var
  str : String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;

    if AEquipType = 'EG' then
    begin
      SQL.Add('SELECT * FROM HIMSEN_INFO WHERE PROJNO = :param1 ');
      str := LeftStr(aProjNo,6);

      try
        ParamByName('param1').AsString := str;
        Open;

        if RecordCount <> 0 then
        begin
          pn_engType.Caption := FieldByName('ENGTYPE').AsString;
          pn_projno.Caption  := aProjNo;
          pn_projName.Caption := FieldByName('PROJNAME').AsString;
          pn_engIn.Caption  := FieldByName('ENGIN').AsString;

        end;
      except
        on e: exception do
          ShowMessage(e.Message);
      end;
    end;
  end;
end;

procedure TengView_Frm.FormCreate(Sender: TObject);
begin
  {with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_INFO ' +
            'WHERE ENGTYPE = '''+'6H17/28U'+''' ');
    Open;

    ENGTYPE.Caption := FieldByname('ENGTYPE').AsString;
    PROJNO.Caption := FieldByname('PROJNO').AsString;
    PROJNAME.Caption := FieldByname('PROJNAME').AsString;
    ENGINEIN.Caption := FieldByname('ENGIN').AsString;

    ExecSQL;
  end;}
end;

end.
