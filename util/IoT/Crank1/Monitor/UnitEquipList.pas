unit UnitEquipList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls, Vcl.Buttons,
  NxColumnClasses, NxColumns, Vcl.ImgList, NxCells, UnitEquipStatusClass;

type
  TEquipListF = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    NextGrid1: TNextGrid;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    EquipName: TNxTextColumn;
    No: TNxIncrementColumn;
    EquipDesc: TNxTextColumn;
    RunStop: TNxImageColumn;
    Updated: TNxTextColumn;
    RunCB: TCheckBox;
    StopCB: TCheckBox;
    CommConnectCB: TCheckBox;
    CommDisConnectCB: TCheckBox;
    ImageList1: TImageList;
    Comm: TNxImageColumn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function Create_EquipList_Frm(AData: TEquipStatusInfo) : Boolean;

var
  EquipListF: TEquipListF;

implementation

{$R *.dfm}

function Create_EquipList_Frm(AData: TEquipStatusInfo) : Boolean;
var
  i: integer;
  LESItem: TEquipStatusItem;
  LRow: integer;
begin
  EquipListF := TEquipListF.Create(nil);

  try
    with EquipListF do
    begin
      for i := 0 to AData.EquipStatusCollect.Count - 1 do
      begin
        LESItem := AData.EquipStatusCollect.Items[i];
        LRow := NextGrid1.AddRow;
        NextGrid1.CellByName['EquipName', LRow].AsString := LESItem.EquipName;
        NextGrid1.CellByName['EquipDesc', LRow].AsString := LESItem.EquipDesc;
        NextGrid1.CellByName['RunStop', LRow].AsInteger := StrToIntDef(LESItem.RunStatus, 0);
        NextGrid1.CellByName['Comm', LRow].AsInteger := Ord(LESItem.CommConnected);
        NextGrid1.CellByName['Updated', LRow].AsString := DateTimeToStr(LESItem.LastUpdatedDate);

      end;//for

      ShowModal
    end;//with
  finally
    FreeAndNil(EquipListF);
  end;
end;

procedure TEquipListF.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TEquipListF.FormCreate(Sender: TObject);
begin
  NextGrid1.DoubleBuffered := False;
end;

end.
