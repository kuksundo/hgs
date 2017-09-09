unit NetWork_Sub_Ip_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, NxCollection,
  CurvyControls, Vcl.ExtCtrls, Vcl.Mask, iComponent, iVCLComponent,
  iCustomComponent, iPlotComponent, iPlot, NxEdit, System.StrUtils,
  NetWork_Unit, AdvFocusHelper;

type
  TNetWork_Sub_Ip_Frm = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel32: TPanel;
    CurvyPanel2: TCurvyPanel;
    NAMEPanel1: TPanel;
    Panel5: TPanel;
    LOCATION1: TPanel;
    Panel6: TPanel;
    MAKER1: TPanel;
    Button1: TButton;
    Panel10: TPanel;
    Panel3: TPanel;
    Button2: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure NAMEPanel1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FEquipNo:String;
    FNetWork_Frm : TNetWork_Frm;
  public
    { Public declarations }
  end;

var
  NetWork_Sub_Ip_Frm: TNetWork_Sub_Ip_Frm;

implementation

uses
  DataModule_unit, List_Unit;

{$R *.dfm}

procedure TNetWork_Sub_Ip_Frm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TNetWork_Sub_Ip_Frm.Button2Click(Sender: TObject);
var
  LNForm: TNetWork_Frm;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT A.*, B.* FROM HITEMS_EQUIP_LIST A, HITEMS_EQUIP_NETWORK B   ' +
            'WHERE A.EQUIPNO = B.EQUIPNO ' +
            'AND (IP = :PARAM1 or IP2 = :PARAM1)');

    if Edit1.Text <> '' then
      ParamByName('PARAM1').AsString := edit1.Text;

    Open;

    if RecordCount <> 0 then
    begin
      NAMEPanel1.Caption := FieldByname('EQNAME').AsString;
      NAMEPanel1.Hint := FieldByname('EQUIPNO').AsString;
      MAKER1.Caption := FieldByname('EQMAKER').AsString;
      LOCATION1.Caption := FieldByname('LOC_DETAIL').AsString;
      FEquipNo := FieldByname('EQUIPNO').AsString;

      begin
        if Caption <> '' then
        begin
          if not Assigned(FNetWork_Frm) then
  //          FNetWork_Frm := TNetWork_Frm.Create(Self);
            LNForm := TNetWork_Frm(List_Frm.ISCreateForm(TNetwork_Frm,'Network_Frm','[내구성 시험장 계통도]'));
            LNForm.FindIPComponent(FEquipNo);

          Show;
        end;
      end;
    end;
  end;
end;

procedure TNetWork_Sub_Ip_Frm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(FNetWork_Frm) then
    FreeAndNil(FNetWork_Frm);
end;

procedure TNetWork_Sub_Ip_Frm.NAMEPanel1Click(Sender: TObject);
var
  LNForm: TNetWork_Frm;
begin
  if Sender is TPanel then
  begin
    with TPanel(Sender) do
    begin

      if Caption <> '' then
      begin
        if not Assigned(FNetWork_Frm) then
//          FNetWork_Frm := TNetWork_Frm.Create(Self);
          LNForm := TNetWork_Frm(List_Frm.ISCreateForm(TNetwork_Frm,'Network_Frm','[내구성 시험장 계통도]'));
          LNForm.FindIPComponent(FEquipNo);
        Show;

      end;
    end;
  end;
end;

end.
