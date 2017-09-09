unit checkChangePart_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, DB,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AeroButtons, JvExControls,
  JvLabel, CurvyControls, Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.ImgList,
  AdvSmoothTileList, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  NxColumnClasses, NxColumns, Ora, Vcl.ExtDlgs,
  AdvSmoothTileListImageVisualizer,
  Vcl.ComCtrls, Vcl.Menus;

type
  TcheckChangePart_Frm = class(TForm)
    ImageList16x16: TImageList;
    ImageList32x32: TImageList;
    imagelist24x24: TImageList;
    Panel8: TPanel;
    Image1: TImage;
    CurvyPanel1: TCurvyPanel;
    JvLabel11: TJvLabel;
    btn_Close: TAeroButton;
    ImgList: TAdvSmoothTileList;
    JvLabel7: TJvLabel;
    JvLabel4: TJvLabel;
    grid_Part: TNextGrid;
    Bevel1: TBevel;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    OpenPictureDialog1: TOpenPictureDialog;
    AdvSmoothTileListImageVisualizer1: TAdvSmoothTileListImageVisualizer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    JvLabel1: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel8: TJvLabel;
    et_draw: TEdit;
    et_std: TEdit;
    et_type: TEdit;
    et_maker: TEdit;
    et_name: TEdit;
    et_remark: TMemo;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    grid_attfiles: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn14: TNxTextColumn;
    NxTextColumn15: TNxTextColumn;
    NxTextColumn16: TNxTextColumn;
    NxTextColumn17: TNxTextColumn;
    PopupMenu1: TPopupMenu;
    mi_edit: TMenuItem;
    et_PlanNo: TEdit;
    btn_reg: TButton;
    NxTextColumn2: TNxTextColumn;
    btn_newPart: TAeroButton;
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure grid_PartMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btn_regClick(Sender: TObject);
    procedure btn_newPartClick(Sender: TObject);
  private
    FEngType,
    FOrderNo,
    FEngProjNo:String;
  public
    { Public declarations }
    procedure Get_List_of_Result(aOrderNo:String);
    procedure Get_List_of_Changing_part(aOrderNo,aStatus:String);
    procedure Get_Part_Info(aPartNo: String);
    procedure Init_Info;
  end;

var
  checkChangePart_Frm: TcheckChangePart_Frm;
  procedure Preview_checkChangePart_Frm(aORderNo:String);
  function Create_checkChangePart_Frm(aOrderNo,aEngProjNo:String): String;

implementation

uses
  newPart_Unit,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

procedure Preview_checkChangePart_Frm(aORderNo:String);
var
  i : Integer;
begin
  checkChangePart_Frm := TcheckChangePart_Frm.Create(nil);
  try
    with checkChangePart_Frm do
    begin
      btn_reg.Visible := False;
      FOrderNo   := aOrderNo;

      Get_List_of_Result(aOrderNo);

      ShowModal;

    end;
  finally
    FreeAndNil(checkChangePart_Frm);
  end;
end;

function Create_checkChangePart_Frm(aOrderNo,aEngProjNo:String): String;
var
  i : Integer;
begin
  checkChangePart_Frm := TcheckChangePart_Frm.Create(nil);
  try
    with checkChangePart_Frm do
    begin
      FOrderNo   := aOrderNo;
      FEngProjNo := aEngProjNo;

      Get_List_of_Changing_part(aOrderNo,'탑재전');

      ShowModal;

    end;
  finally
    FreeAndNil(checkChangePart_Frm);
  end;
end;

procedure TcheckChangePart_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TcheckChangePart_Frm.btn_newPartClick(Sender: TObject);
begin
  with grid_Part do
  begin
    BeginUpdate;
    try
      if SelectedRow = -1 then
        Exit;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HIMSEN_MS_NUMBER ' +
                'WHERE MS_NO LIKE :MS_NO ');
        ParamByName('MS_NO').AsString := Cells[1,SelectedRow];
        Open;

        if RecordCount <> 0 then
        begin
          Create_newPart_Frm('', Cells[1,SelectedRow], FieldByName('MS_NAME').AsString, FEngType);

        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcheckChangePart_Frm.btn_regClick(Sender: TObject);
var
  i : Integer;
  LMountNo:String;
begin
  with grid_Part do
  begin
    BeginUpdate;
    try
      if RowCount > 0 then
      begin
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO HIMSEN_MS_MOUNTED_PART ' +
                  '(MOUNT_NO, PART_NO, ENG_PROJNO, ORDER_NO, MOUNT_DATE) VALUES ' +
                  '(:MOUNT_NO, :PART_NO, :ENG_PROJNO, :ORDER_NO, :MOUNT_DATE)');


          LMountNo := FormatDateTime('yyyyMMddHHmmsszzz',Now);

          if SelectedRow > -1 then
          begin
            //탑재등록
            ParamByName('MOUNT_NO').AsString     := LMountNo;
            ParamByName('PART_NO').AsString      := Cells[2,SelectedRow];
            ParamByName('ENG_PROJNO').AsString   := FEngProjNo;
            ParamByName('ORDER_NO').AsString     := FOrderNo;
            ParamByName('MOUNT_DATE').AsDateTime := Now;
            ExecSQL;

            //탑재요청 상태 변경
            Close;
            SQL.Clear;
            SQL.Add('UPDATE TMS_TEST_REQUEST_PART SET ' +
                    'STATUS = ''탑재'' ' +
                    'WHERE REQ_NO LIKE :param1 ' +
                    'AND PART_NO LIKE :param2 ');
            ParamByName('param1').AsString := Cells[1,SelectedRow];
            ParamByName('param2').AsString := Cells[2,SelectedRow];
            ExecSQL;

            //선택된 로우 삭제
            DeleteRow(SelectedRow);

            ShowMessage('변경완료!');
            Init_Info;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcheckChangePart_Frm.Button4Click(Sender: TObject);
var
  i: Integer;
  Tile: TAdvSmoothTile;
begin
  with ImgList.Tiles do
  begin
    BeginUpdate;
    try
      if OpenPictureDialog1.Execute then
      begin
        for i := 0 to OpenPictureDialog1.Files.Count - 1 do
        begin
          Tile := Add;

          with Tile do
          begin
            Content.Hint := OpenPictureDialog1.Files.Strings[i];
            Content.Image.LoadFromFile(Content.Hint);
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcheckChangePart_Frm.FormCreate(Sender: TObject);
begin
  ImgList.Tiles.Clear;
  PageControl1.ActivePageIndex := 0;

end;

procedure TcheckChangePart_Frm.Get_List_of_Changing_part(aOrderNo,aStatus:String);
var
  i: Integer;

begin
  with grid_Part do
  begin
    BeginUpdate;
    try
      ClearRows;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT A.*, B.* FROM TMS_TEST_REQUEST_PART A, HIMSEN_MS_PART B ' +
                'WHERE A.PART_NO = B.PART_NO ' +
                'AND REQ_NO LIKE ( ' +
                '   SELECT REQ_NO FROM TMS_TEST_RECEIVE_INFO ' +
                '   WHERE PLAN_NO LIKE ( ' +
                '     SELECT PLAN_NO FROM TMS_WORK_ORDERS ' +
                '     WHERE ORDER_NO LIKE :param1 ) ' +
                ') ' +
                'AND STATUS LIKE :param2 ' +
                'ORDER BY SEQ_NO ');

        ParamByName('param1').AsString := aOrderNo;
        ParamByName('param2').AsString := aStatus;
        Open;

        while not eof do
        begin
          i := AddRow;
          Cells[1, i] := FieldByName('REQ_NO').AsString;
          Cells[2, i] := FieldByName('PART_NO').AsString;
          Cells[3, i] := FieldByName('MS_NO').AsString;
          Cells[4, i] := FieldByName('NAME').AsString;
          Cells[5, i] := FieldByName('MAKER').AsString;
          Cells[6, i] := FieldByName('TYPE').AsString;
          Cells[7, i] := FieldByName('STANDARD').AsString;

          Next;

        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcheckChangePart_Frm.Get_List_of_Result(aOrderNo: String);
var
  i: Integer;

begin
  with grid_Part do
  begin
    BeginUpdate;
    try
      ClearRows;

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM ' +
                '( ' +
                '   SELECT ' +
                '     A.*, ' +
                '     B.REQ_NO, RECEIVE_DATE ' +
                '   FROM ' +
                '   ( ' +
                '       SELECT ' +
                '         A.*, ' +
                '         B.PLAN_NO, CODE, CODE_TYPE, STATUS ' +
                '       FROM HIMSEN_MS_MOUNTED_PART A, TMS_WORK_ORDERS B ' +
                '       WHERE A.ORDER_NO LIKE :param1 ' +
                '       AND A.ORDER_NO = B.ORDER_NO ' +
                '   ) A JOIN ' +
                '   ( ' +
                '       SELECT * FROM TMS_TEST_RECEIVE_INFO ' +
                '   )B ON A.PLAN_NO = B.PLAN_NO ' +
                ') A JOIN ' +
                '( ' +
                '   SELECT * FROM HIMSEN_MS_PART ' +
                ') B ' +
                'ON A.PART_NO = B.PART_NO ');

        ParamByName('param1').AsString := aOrderNo;
        Open;

        while not eof do
        begin
          i := AddRow;
          Cells[1, i] := FieldByName('REQ_NO').AsString;
          Cells[2, i] := FieldByName('PART_NO').AsString;
          Cells[3, i] := FieldByName('MS_NO').AsString;
          Cells[4, i] := FieldByName('NAME').AsString;
          Cells[5, i] := FieldByName('MAKER').AsString;
          Cells[6, i] := FieldByName('TYPE').AsString;
          Cells[7, i] := FieldByName('STANDARD').AsString;

          Next;

        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TcheckChangePart_Frm.Get_Part_Info(aPartNo: String);
var
  i: Integer;
  LTile: TAdvSmoothTile;
  LPic: TPicture;
begin
  ImgList.Tiles.Clear;
  grid_attfiles.ClearRows;
  LPic := TPicture.Create;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM HIMSEN_MS_PART ' + 'WHERE PART_NO LIKE :param1 ');
      ParamByName('param1').AsString := aPartNo;
      Open;

      if RecordCount <> 0 then
      begin
        et_name.Text := FieldByName('NAME').AsString;
        et_maker.Text := FieldByName('MAKER').AsString;
        et_type.Text := FieldByName('TYPE').AsString;
        et_std.Text := FieldByName('STANDARD').AsString;
        et_draw.Text := FieldByName('DRAW_NO').AsString;
        et_remark.Text := FieldByName('REMARK').AsString;

        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HIMSEN_MS_ATTFILES ' +
          'WHERE PART_NO LIKE :param1 ' + 'ORDER BY REG_NO ');

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
            with grid_attfiles do
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

procedure TcheckChangePart_Frm.grid_PartMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LRow : Integer;
begin
  with Sender as TNextGrid do
  begin
    LRow := GetRowAtPos(X,Y);

    if LRow > -1 then
    begin
      Get_Part_Info(Cells[2,LRow]);
      mi_edit.Enabled := True;
      btn_reg.Enabled := True;
      if Cell[1,LRow].AsFloat <> 1 then
        btn_newPart.Enabled := True;


    end else
    begin
      SelectedRow := LRow;
      btn_newPart.Enabled := False;
      btn_reg.Enabled := False;
      Init_Info;

    end;
  end;
end;

procedure TcheckChangePart_Frm.Init_Info;
begin
  btn_reg.Enabled := False;
  grid_Part.SelectedRow := -1;
  PageControl1.ActivePageIndex := 0;
  mi_edit.Enabled := False;
  ImgList.Tiles.Clear;
  et_name.Clear;
  et_maker.Clear;
  et_type.Clear;
  et_std.Clear;
  et_draw.Clear;
  et_remark.Clear;
  grid_attfiles.ClearRows;

end;

end.
