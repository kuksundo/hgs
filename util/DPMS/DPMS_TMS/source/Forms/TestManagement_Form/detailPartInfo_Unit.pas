unit detailPartInfo_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxEdit, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls,
  AdvSmoothTileList, AeroButtons, JvExControls, JvLabel, CurvyControls,
  Vcl.ImgList, Vcl.Imaging.jpeg, Vcl.ExtCtrls, DB,
  AdvSmoothTileListImageVisualizer;

type
  TdetailPartInfo_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    imagelist24x24: TImageList;
    ImageList32x32: TImageList;
    ImageList16x16: TImageList;
    CurvyPanel1: TCurvyPanel;
    JvLabel11: TJvLabel;
    btn_Close: TAeroButton;
    JvLabel7: TJvLabel;
    ImgList: TAdvSmoothTileList;
    et_remark: TMemo;
    et_drawno: TEdit;
    et_std: TEdit;
    JvLabel4: TJvLabel;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    JvLabel9: TJvLabel;
    JvLabel10: TJvLabel;
    JvLabel12: TJvLabel;
    JvLabel13: TJvLabel;
    et_side: TEdit;
    et_cyl: TNxNumberEdit;
    JvLabel14: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    et_bank: TEdit;
    et_cycle: TEdit;
    et_serial: TEdit;
    et_name: TEdit;
    et_maker: TEdit;
    et_type: TEdit;
    AdvSmoothTileListImageVisualizer1: TAdvSmoothTileListImageVisualizer;
    procedure btn_CloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Get_Detail_Part_Info(aReqNo,aPartNo:String;aIdx:Integer);
  end;

var
  detailPartInfo_Frm: TdetailPartInfo_Frm;
  procedure Preview_Detail_Part(aReqNo,aPartNo:String;aIdx:Integer);

implementation
uses
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

procedure Preview_Detail_Part(aReqNo,aPartNo:String;aIdx:Integer);
begin
  detailPartInfo_Frm := TdetailPartInfo_Frm.Create(nil);
  try
    with detailPartInfo_Frm do
    begin
      with DM1.OraQuery1 do
      begin

        Get_Detail_Part_Info(aReqNo, aPartNo, aIdx);

      end;

      ShowModal;

    end;
  finally
    FreeAndNil(detailPartInfo_Frm);
  end;
end;

{ TdetailPartInfo_Frm }

procedure TdetailPartInfo_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TdetailPartInfo_Frm.Get_Detail_Part_Info(aReqNo, aPartNo: String;
  aIdx: Integer);
var
  i: Integer;
  LTile: TAdvSmoothTile;
  LPic: TPicture;
begin
  ImgList.Tiles.Clear;
  fileGrid.ClearRows;
  LPic := TPicture.Create;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM DPMS_TMS_TEST_REQUEST_PART A, DPMS_HIMSEN_MS_PART B ' +
              'WHERE A.PART_NO = B.PART_NO ' +
              'AND A.REQ_NO LIKE :param1 ' +
              'AND A.PART_NO LIKE :param2 ' +
              'AND A.SEQ_NO LIKE :param3 ');

      ParamByName('param1').AsString  := aReqNo;
      ParamByName('param2').AsString  := aPartNo;
      ParamByName('param3').AsInteger := aIdx;
      Open;

      if RecordCount <> 0 then
      begin
        et_name.Text   := FieldByName('NAME').AsString;
        et_maker.Text  := FieldByName('MAKER').AsString;
        et_type.Text   := FieldByName('TYPE').AsString;
        et_std.Text    := FieldByName('STANDARD').AsString;
        et_drawno.Text := FieldByName('DRAW_NO').AsString;
        et_remark.Text := FieldByName('REMARK').AsString;

        et_bank.Text     := FieldByName('BANK').AsString;
        et_cyl.AsInteger := FieldByName('CYLNUM').AsInteger;
        et_cycle.Text    := FieldByName('CYCLE').AsString;
        et_side.Text     := FieldByName('SIDE').AsString;
        et_serial.Text   := FieldByName('SERIAL').AsString;

        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM DPMS_HIMSEN_MS_ATTFILES ' +
                'WHERE PART_NO LIKE :param1 ' +
                'ORDER BY REG_NO ');

        ParamByName('param1').AsString := aPartNo;
        Open;

        while not eof do
        begin
          LPic.Assign(nil);
          if FieldByName('FLAG').AsString = 'I' then
          begin
            LTile := ImgList.Tiles.Add;
            with LTile do
            begin
              LoadPictureFromBlobField(TBlobField(FieldByName('FILES')), LPic);
              Content.Image.Assign(LPic);
              Content.Hint := FieldByName('FILE_NAME').AsString;
            end;
          end
          else if FieldByName('FLAG').AsString = 'A' then
          begin
            with fileGrid do
            begin
              i := AddRow;

              Cells[1, i] := FieldByName('FILE_NAME').AsString;
              Cells[2, i] := FieldByName('FILE_SIZE').AsString;
              Cells[3, i] := '';
              Cells[4, i] := FieldByName('REG_NO').AsString;
              Cells[5, i] := FieldByName('PART_NO').AsString;
            end;
          end;
          Next;
        end;
      end;
    end;
  finally
    FreeAndNil(LPic);
  end;
end;

end.
