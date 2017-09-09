unit Info_Unit;

interface

uses
  Main_Unit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothListBox, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  Vcl.StdCtrls, Vcl.ComCtrls, NxCollection, Vcl.ExtCtrls;

type
  TInfo_Frm = class(TForm)
    Panel1: TPanel;
    NxSplitter1: TNxSplitter;
    NxPanel4: TNxPanel;
    Panel36: TPanel;
    DateTimePicker1: TDateTimePicker;
    NxPanel2: TNxPanel;
    NxPanel3: TNxPanel;
    Panel4: TPanel;
    Panel31: TPanel;
    Panel6: TPanel;
    NxPanel5: TNxPanel;
    NxPanel8: TNxPanel;
    Panel34: TPanel;
    Panel5: TPanel;
    NxPanel10: TNxPanel;
    Button7: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    empgrid: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn18: TNxCheckBoxColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn17: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    AdvSmoothListBox1: TAdvSmoothListBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    NxImage1: TNxImage;
    Panel7: TPanel;
    Panel8: TPanel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Info_Frm: TInfo_Frm;

implementation
uses
DataModule_Unit;

{$R *.dfm}

procedure TInfo_Frm.FormCreate(Sender: TObject);
var
  li : integer;
begin
  DateTimePicker1.Date := now;

  with DM1.OraQuery3 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HITEMS.HITEMS_USER ' );
    Open;

    AdvSmoothListBox1.Items.Clear;

    {for li := 0 to recordCount-1 do
    begin
      with AdvSmoothListBox1 do
      items.Add.Caption := FieldByname('ENGINE_NAME').AsString;
      Next;
    end;}

    ExecSQL;
  end;

end;

end.
