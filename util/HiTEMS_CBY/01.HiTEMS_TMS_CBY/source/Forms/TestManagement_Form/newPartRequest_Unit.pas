unit newPartRequest_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, DB,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AeroButtons, JvExControls,
  JvLabel, CurvyControls, Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.ImgList,
  AdvSmoothTileList, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  NxColumnClasses, NxColumns, Ora, Vcl.ExtDlgs,
  AdvSmoothTileListImageVisualizer,shellApi,
  Vcl.ComCtrls, Vcl.Menus, DATA.DBXJSON, AdvMenus, NxEdit, TestReqCollect;

type
  TnewPartRequest_Frm = class(TForm)
    ImageList16x16: TImageList;
    ImageList32x32: TImageList;
    imagelist24x24: TImageList;
    Panel8: TPanel;
    Image1: TImage;
    CurvyPanel1: TCurvyPanel;
    btn_Close: TAeroButton;
    AeroButton1: TAeroButton;
    JvLabel7: TJvLabel;
    JvLabel14: TJvLabel;
    et_msNumber: TEdit;
    Button2: TButton;
    JvLabel4: TJvLabel;
    grid_Part: TNextGrid;
    Bevel1: TBevel;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    JvLabel9: TJvLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    AdvSmoothTileListImageVisualizer1: TAdvSmoothTileListImageVisualizer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    btn_newPart: TAeroButton;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    grid_choose: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn13: TNxTextColumn;
    btn_chooseDel: TButton;
    PopupMenu1: TPopupMenu;
    mi_edit: TMenuItem;
    NxTextColumn18: TNxTextColumn;
    NxTextColumn19: TNxTextColumn;
    NxTextColumn20: TNxTextColumn;
    NxTextColumn21: TNxTextColumn;
    NxTextColumn22: TNxTextColumn;
    PopupMenu2: TPopupMenu;
    mi_editPS: TMenuItem;
    NxNumberColumn1: TNxNumberColumn;
    TabSheet3: TTabSheet;
    grid_serialFiles: TNextGrid;
    NxIncrementColumn4: TNxIncrementColumn;
    NxTextColumn23: TNxTextColumn;
    NxTextColumn25: TNxTextColumn;
    NxTextColumn26: TNxTextColumn;
    NxTextColumn27: TNxTextColumn;
    NxTextColumn29: TNxTextColumn;
    btn_down: TAeroButton;
    pm_gridAttfiles: TAdvPopupMenu;
    mi_msfileOpen: TMenuItem;
    mi_msfileSave: TMenuItem;
    pm_gridSerialFiles: TAdvPopupMenu;
    mi_serialFileOpen: TMenuItem;
    mi_serialFileSave: TMenuItem;
    SaveDialog1: TSaveDialog;
    JvLabel11: TJvLabel;
    JvLabel10: TJvLabel;
    EngTypeLbl: TJvLabel;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    ImgList: TAdvSmoothTileList;
    JvLabel1: TJvLabel;
    et_name: TEdit;
    JvLabel2: TJvLabel;
    et_maker: TEdit;
    JvLabel3: TJvLabel;
    et_type: TEdit;
    JvLabel5: TJvLabel;
    et_std: TEdit;
    JvLabel6: TJvLabel;
    et_draw: TEdit;
    JvLabel8: TJvLabel;
    et_remark: TMemo;
    grid_attfiles: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn14: TNxTextColumn;
    NxTextColumn15: TNxTextColumn;
    NxTextColumn16: TNxTextColumn;
    NxTextColumn17: TNxTextColumn;
    et_serial: TEdit;
    JvLabel12: TJvLabel;
    cb_side: TComboBox;
    JvLabel13: TJvLabel;
    cb_cycle: TComboBox;
    JvLabel15: TJvLabel;
    cb_bank: TComboBox;
    JvLabel16: TJvLabel;
    et_cyl: TNxNumberEdit;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    OpenDialog1: TOpenDialog;
    NxTextColumn24: TNxTextColumn;
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_newPartClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_chooseDelClick(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure grid_PartMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mi_editClick(Sender: TObject);
    procedure grid_chooseMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mi_editPSClick(Sender: TObject);
    procedure grid_PartCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure btn_downClick(Sender: TObject);
    procedure et_msNumberChange(Sender: TObject);
    procedure mi_msfileOpenClick(Sender: TObject);
    procedure mi_msfileSaveClick(Sender: TObject);
    procedure mi_serialFileOpenClick(Sender: TObject);
    procedure mi_serialFileSaveClick(Sender: TObject);
    procedure cb_bankChange(Sender: TObject);
    procedure cb_cycleChange(Sender: TObject);
    procedure cb_sideChange(Sender: TObject);
    procedure et_cylChange(Sender: TObject);
    procedure et_serialChange(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FReqNo,
    FEngType : String;
  public
    FTestReqList: TTestReqList;
    FSerialOnChangeMode: Boolean;
    FLastChooseSelectedRow: integer;

    procedure Get_Part_List(aMS: String);
    procedure Get_Part_Info(aPartNo: String);
    procedure Get_Choose_List(aPartNo:String);
    procedure Init_Info;
    procedure Init_Serial;
    function Return_Values(aTJSONPair: TJSONPair): String;
    procedure Get_Serial_Attfiles(aRow:Integer);
    procedure SelectPart;

    procedure Get_Serial_Attfiles_FromList(aRow: integer);
    procedure GetSerialInfo2GUI(ARow: integer);
    procedure SetPartPosition2GUI(ARow: integer; AData: TJSONObject; AFileList: TStringList);
  end;

var
  newPartRequest_Frm: TnewPartRequest_Frm;

  function Preview_newPartRequest_Frm(aEngType,aReqNo:String;aGrid:TNextGrid;ATestReqList: TTestReqList): String;
  function Create_newPartRequest_Frm(aEngType,aReqNo:String;aGrid:TNextGrid;ATestReqList: TTestReqList): String;

implementation

uses
  setPartPosition_Unit,
  newPart_Unit,
  chooseMS_Unit,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

function Preview_newPartRequest_Frm(aEngType,aReqNo:String;aGrid:TNextGrid;ATestReqList: TTestReqList): String;
var
  i,j,k : Integer;
  LJObj : TJSONObject;
begin
  newPartRequest_Frm := TnewPartRequest_Frm.Create(nil);
  try
    with newPartRequest_Frm do
    begin
      FEngType := aEngType;
      FReqNo := aReqNo;
      FTestReqList.Assign(ATestReqList);

      //set btn=======

      mi_editPS.Visible := False;
      Button2.Visible := False;
      btn_newPart.Visible := False;
      AeroButton1.Visible := False;
      btn_down.Visible    := False;
      btn_chooseDel.Visible := False;

      //==============

      if aGrid.RowCount <> 0 then
      begin
        with grid_choose do
        begin
          BeginUpdate;
          try
            ClearRows;
            for i := 0 to aGrid.RowCount-1 do
            begin
              j := AddRow;
              //Row[j].Data := aGrid.Row[i].Data;
              Cells[1,j] := aGrid.Cells[1,i];
              Cells[2,j] := aGrid.Cells[2,i];
              Cells[3,j] := aGrid.Cells[3,i];
              Cells[4,j] := aGrid.Cells[4,i];
              Cells[5,j] := aGrid.Cells[5,i];
              Cells[6,j] := aGrid.Cells[6,i];
              Cells[7,j] := aGrid.Cells[7,i];
              Cells[8,j] := aGrid.Cells[8,i];
              Cells[9,j] := aGrid.Cells[9,i];
              Cells[10,j] := aGrid.Cells[10,i];
              Cells[11,j] := aGrid.Cells[11,i];

              Cells[12,j] := aGrid.Cells[12,i];

              //if not FTestReqList.IsFetchSerialFileFromDB then
                Get_Serial_Attfiles(i);
            end;
          finally
            EndUpdate;
          end;
        end;
      end;

      ShowModal;

      if ModalResult = mrOk then
      begin
        if grid_choose.RowCount > 0 then
        begin
          with aGrid do
          begin
            BeginUpdate;
            try
              ClearRows;

              for i := 0 to grid_choose.RowCount-1 do
              begin
                j := AddRow;
                Row[j].Data := grid_choose.Row[i].Data;
                Cells[1,j] := grid_choose.Cells[1,i];
                Cells[2,j] := grid_choose.Cells[2,i];
                Cells[3,j] := grid_choose.Cells[3,i];
                Cells[4,j] := grid_choose.Cells[4,i];
                Cells[5,j] := grid_choose.Cells[5,i];
                Cells[6,j] := grid_choose.Cells[6,i];
                Cells[7,j] := grid_choose.Cells[7,i];
                Cells[8,j] := grid_choose.Cells[8,i];
                Cells[9,j] := grid_choose.Cells[9,i];
                Cells[10,j] := grid_choose.Cells[10,i];
                Cells[11,j] := grid_choose.Cells[11,i];
                Cells[12,j] := grid_choose.Cells[12,i];
              end;
            finally
              EndUpdate;
            end;
          end;
        end
        else
          aGrid.ClearRows;

        ATestReqList.Assign(FTestReqList);

      end else
      begin
        //Close

      end;
    end;
  finally
    FreeAndNil(newPartRequest_Frm);
  end;
end;

function Create_newPartRequest_Frm(aEngType,aReqNo:String;aGrid:TNextGrid;ATestReqList: TTestReqList): String;
var
  i,j,k : Integer;
  LJObj : TJSONObject;
begin
  newPartRequest_Frm := TnewPartRequest_Frm.Create(nil);
  try
    with newPartRequest_Frm do
    begin
      FEngType := aEngType;
      FReqNo := aReqNo;
      EngTypeLbl.Caption := FEngType;
      FTestReqList.Assign(ATestReqList);

      if aGrid.RowCount <> 0 then
      begin
        with grid_choose do
        begin
          BeginUpdate;
          try
            ClearRows;

            for i := 0 to aGrid.RowCount-1 do
            begin
              j := AddRow;
              Row[j].Data := aGrid.Row[i].Data;

              Cells[1,j] := aGrid.Cells[1,i];
              Cells[2,j] := aGrid.Cells[2,i];
              Cells[3,j] := aGrid.Cells[3,i];
              Cells[4,j] := aGrid.Cells[4,i];
              Cells[5,j] := aGrid.Cells[5,i];
              Cells[6,j] := aGrid.Cells[6,i];
              Cells[7,j] := aGrid.Cells[7,i];
              Cells[8,j] := aGrid.Cells[8,i];
              Cells[9,j] := aGrid.Cells[9,i];
              Cells[10,j] := aGrid.Cells[10,i];
              Cells[11,j] := aGrid.Cells[11,i];
              Cells[12,j] := aGrid.Cells[12,i];

              //Get_Part_Info(Cells[1,i]);
              //if not FTestReqList.IsFetchSerialFileFromDB then
                Get_Serial_Attfiles(i);
            end;
          finally
            EndUpdate;
          end;
        end;

      end;

      ShowModal;

      if ModalResult = mrOk then
      begin
        if grid_choose.RowCount > 0 then
        begin
          with aGrid do
          begin
            BeginUpdate;
            try
              ClearRows;

              for i := 0 to grid_choose.RowCount-1 do
              begin
                j := AddRow;
                //Row[j].Data := grid_choose.Row[i].Data;
                Cells[1,j] := grid_choose.Cells[1,i];
                Cells[2,j] := grid_choose.Cells[2,i];
                Cells[3,j] := grid_choose.Cells[3,i];
                Cells[4,j] := grid_choose.Cells[4,i];
                Cells[5,j] := grid_choose.Cells[5,i];
                Cells[6,j] := grid_choose.Cells[6,i];
                Cells[7,j] := grid_choose.Cells[7,i];
                Cells[8,j] := grid_choose.Cells[8,i];
                Cells[9,j] := grid_choose.Cells[9,i];
                Cells[10,j] := grid_choose.Cells[10,i];
                Cells[11,j] := grid_choose.Cells[11,i];
                Cells[12,j] := grid_choose.Cells[12,i];
              end;
            finally
              EndUpdate;
            end;
          end;
        end
        else
          aGrid.ClearRows;

        ATestReqList.Assign(FTestReqList);
      end else
      begin
        //Close
      end;
    end;
  finally
    FreeAndNil(newPartRequest_Frm);
  end;
end;

procedure TnewPartRequest_Frm.AeroButton1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TnewPartRequest_Frm.btn_downClick(Sender: TObject);
begin
  SelectPart;
end;

procedure TnewPartRequest_Frm.btn_chooseDelClick(Sender: TObject);
var
  i : Integer;
begin
  with grid_choose do
  begin
    //BeginUpdate;
    try
      if RowCount = 0 then
        exit;

      if FLastChooseSelectedRow = -1 then
        Exit;

      if MessageDlg('부품명 : ' + cells[4,FLastChooseSelectedRow] + ' 을 삭제 하시겠습니까?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        if FLastChooseSelectedRow > -1 then
        begin
          FTestReqList.DeletePart(FLastChooseSelectedRow);
          DeleteRow(FLastChooseSelectedRow);

          if grid_choose.RowCount = 0 then
            Init_Serial;
        end;
      end;
    finally
      //EndUpdate;
    end;
  end;
end;

procedure TnewPartRequest_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TnewPartRequest_Frm.btn_newPartClick(Sender: TObject);
var
  LResult: Boolean;
  LStr: string;
begin
  if et_msNumber.Text <> '' then
  begin
    LStr := EngTypeLbl.Caption;
    LStr := Copy(LStr,Pos('-', LStr)+1, Length(LStr) - Pos('-', LStr));
    if Create_newPart_Frm('', et_msNumber.Hint, et_msNumber.Text, LStr) then
      Get_Part_List(et_msNumber.Hint);
  end
  else
    ShowMessage('먼저 MS-Number를 선택하여 주십시오!');

end;

procedure TnewPartRequest_Frm.Button2Click(Sender: TObject);
var
  OraQuery: TOraQuery;
  idx: Integer;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      FetchAll := True;

      idx := Create_chooseMS_Frm(OraQuery);

      if idx > 0 then
      begin
        RecNo := idx;
        et_msNumber.Text := FieldByName('MS_NAME').AsString;
        et_msNumber.Hint := FieldByName('MS_NO').AsString;
        Get_Part_List(et_msNumber.Hint);
      end
      else
      begin
        et_msNumber.Clear;
        et_msNumber.Hint := '';
        grid_Part.ClearRows;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TnewPartRequest_Frm.Button4Click(Sender: TObject);
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

procedure TnewPartRequest_Frm.cb_bankChange(Sender: TObject);
begin
  if FSerialOnChangeMode then
  begin
    if grid_choose.RowCount = 0 then
      exit;

    grid_choose.Cells[8,FLastChooseSelectedRow] := cb_bank.Text;
    FTestReqList.SetBankPos(FLastChooseSelectedRow, cb_bank.Text);
  end;
end;

procedure TnewPartRequest_Frm.cb_cycleChange(Sender: TObject);
begin
  if FSerialOnChangeMode  then
  begin
    if grid_choose.RowCount = 0 then
      exit;

    grid_choose.Cells[10,FLastChooseSelectedRow] := cb_cycle.Text;
    FTestReqList.SetExh_Intake(FLastChooseSelectedRow, cb_cycle.Text);
  end;
end;

procedure TnewPartRequest_Frm.cb_sideChange(Sender: TObject);
begin
  if FSerialOnChangeMode  then
  begin
    if grid_choose.RowCount = 0 then
      exit;

    grid_choose.Cells[11,FLastChooseSelectedRow] := cb_side.Text;
    FTestReqList.SetSide(FLastChooseSelectedRow, cb_side.Text);
  end;
end;

procedure TnewPartRequest_Frm.et_cylChange(Sender: TObject);
begin
  if FSerialOnChangeMode  then
  begin
    if grid_choose.RowCount = 0 then
      exit;

    grid_choose.Cells[9,FLastChooseSelectedRow] := et_cyl.Text;
    FTestReqList.SetCylNo(FLastChooseSelectedRow, et_cyl.Text);
  end;
end;

procedure TnewPartRequest_Frm.et_msNumberChange(Sender: TObject);
begin
  if et_msNumber.Text <> '' then
    btn_down.Enabled := True
  else
    btn_down.Enabled := False;

end;

procedure TnewPartRequest_Frm.et_serialChange(Sender: TObject);
begin
  if FSerialOnChangeMode  then
  begin
    if grid_choose.RowCount = 0 then
      exit;

    grid_choose.Cells[12,FLastChooseSelectedRow] := et_serial.Text;
    FTestReqList.SetSerialNo(FLastChooseSelectedRow, et_serial.Text);
  end;
end;

procedure TnewPartRequest_Frm.FormCreate(Sender: TObject);
begin
  ImgList.Tiles.Clear;
  PageControl1.ActivePageIndex := 0;
  FTestReqList:= TTestReqList.Create(Self);
end;

procedure TnewPartRequest_Frm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FTestReqList);
end;

procedure TnewPartRequest_Frm.GetSerialInfo2GUI(ARow: integer);
begin
  FSerialOnChangeMode := False;
  try
    cb_bank.Text := FTestReqList.GetBankPos(aRow);
    et_cyl.Text := FTestReqList.GetCylNo(aRow);
    cb_cycle.Text := FTestReqList.GetExh_Intake(aRow);
    cb_side.Text := FTestReqList.GetSide(aRow);
    et_serial.Text := FTestReqList.GetSerialNo(aRow);
  finally
    FSerialOnChangeMode := True;
  end;
end;

procedure TnewPartRequest_Frm.Get_Choose_List(aPartNo: String);
var
  i : Integer;

begin
  with grid_choose do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HIMSEN_MS_PART  ' +
                'WHERE PART_NO LIKE :param1 ');
        ParamByName('param1').AsString := aPartNo;
        Open;

        if RecordCount <> 0 then
        begin
          i := AddRow;
          Cells[1, i] := FieldByName('PART_NO').AsString;
          Cells[2, i] := FieldByName('MS_NO').AsString;
          Cells[3, i] := FieldByName('NAME').AsString;
          Cells[4, i] := FieldByName('MAKER').AsString;
          Cells[5, i] := FieldByName('TYPE').AsString;
          Cells[6, i] := FieldByName('STANDARD').AsString;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewPartRequest_Frm.Get_Part_Info(aPartNo: String);
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

procedure TnewPartRequest_Frm.Get_Part_List(aMS: String);
var
  i: Integer;
  LStr: string;
begin
  with grid_Part do
  begin
    BeginUpdate;
    try
      ClearRows;
      LStr := EngTypeLbl.Caption;
      LStr := Copy(LStr,Pos('-', LStr)+1, Length(LStr) - Pos('-', LStr));

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HIMSEN_MS_PART ' + 'WHERE MS_NO LIKE :param1 '+
                'AND ENGTYPE = :ENGTYPE ');
        ParamByName('param1').AsString := aMS;
        ParamByName('ENGTYPE').AsString := LStr;
        Open;

        while not eof do
        begin
          i := AddRow;

          Cells[1, i] := FieldByName('PART_NO').AsString;
          Cells[2, i] := FieldByName('MS_NO').AsString;
          Cells[3, i] := FieldByName('NAME').AsString;
          Cells[4, i] := FieldByName('MAKER').AsString;
          Cells[5, i] := FieldByName('TYPE').AsString;
          Cells[6, i] := FieldByName('STANDARD').AsString;

          Next;

        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewPartRequest_Frm.Get_Serial_Attfiles(aRow:Integer);
var
  OraQuery : TOraQuery;
  LRow,
  i : Integer;
  LReqNo, LPartNo, LSerialNo: string;
  LID: TDateTime;
begin
  with grid_serialFiles do
  begin
    BeginUpdate;
    try
      ClearRows;

      FTestReqList.GetSerialFileInfo(aRow, LReqNo, LPartNo, LSerialNo);

      OraQuery := TOraQuery.Create(nil);
      try
        with OraQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT REQ_NO, PART_NO, SERIAL, FILE_NAME, FILE_SIZE FROM TMS_TEST_PART_ATTFILES ' +
                  'WHERE REQ_NO LIKE :param1 ' +
                  'AND PART_NO LIKE :param2 ' +
                  'AND SERIAL LIKE :param3 ' +
                  'ORDER BY REQ_NO, PART_NO ');

          ParamByName('param1').AsString := FReqNo;
          ParamByName('param2').AsString := LPartNo;
          ParamByName('param3').AsString := LSerialNo;

          Open;

          LID := FTestReqList.GetID(aRow);

          i := 0;

          while not eof do
          begin
            if FTestReqList.IsExistSerialFileFromList(FReqNo,LPartNo,LSerialNo,FieldByName('FILE_NAME').AsString) then
              continue;

            with FTestReqList.TestPartSerialFileCollect.Add do
            begin
              ID := LID;
              RowNo := i;
              FileName := FieldByName('FILE_NAME').AsString;
              ReqNo := FieldByName('REQ_NO').AsString;
              PartNo := FieldByName('PART_NO').AsString;
              SerialNo := FieldByName('SERIAL').AsString;
              FileSize := FieldByName('FILE_SIZE').AsInteger;
              Inc(i);
            end;

            Next;
          end;
        end;

        FTestReqList.IsFetchSerialFileFromDB := True;

      finally
        FreeAndNil(OraQuery);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewPartRequest_Frm.Get_Serial_Attfiles_FromList(aRow: integer);
var
  LArray: TJSONArray;
  LObj: TJSONObject;
  LValue: TJSONValue;
  i,j: integer;
begin
  GetSerialInfo2GUI(aRow);

  grid_serialFiles.ClearRows;

  LArray := TJSONArray.Create;
  try
    FTestReqList.GetSerialFiles(aRow, LArray);

    with grid_serialFiles do
    begin
//      for i := 0 to LObj.Size - 1 do
      for LValue in LArray do
      begin
        //LObj := LArray.Get(i) as TJSONObject;
        i := AddRow;
        LObj := TJSONObject(LValue);

        for j := 0 to LObj.Size - 1 do
        begin
          if LObj.Get(j).JsonString.Value = 'FileName' then
            Cells[1,i] := LObj.Get(j).JsonValue.Value
          else
          if LObj.Get(j).JsonString.Value = 'FilePath' then
            Cells[2,i] := LObj.Get(j).JsonValue.Value
          else
          if LObj.Get(j).JsonString.Value = 'ReqNo' then
            Cells[3,i] := LObj.Get(j).JsonValue.Value
          else
          if LObj.Get(j).JsonString.Value = 'PartNo' then
            Cells[4,i] := LObj.Get(j).JsonValue.Value
          else
          if LObj.Get(j).JsonString.Value = 'SerialNo' then
            Cells[5,i] := LObj.Get(j).JsonValue.Value
          else
          if LObj.Get(j).JsonString.Value = 'FileSize' then
            Cells[6,i] := LObj.Get(j).JsonValue.Value;
          //Cells[1,i] := LObj.Get(j).JsonValue.ToString;
          //Cells[1,i] := LObj.Get(j).ToString;//.JsonValue.ToString;
        end;
      end;

    end;
  finally
    LArray.Free;
  end;
end;

procedure TnewPartRequest_Frm.grid_chooseMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i : Integer;
begin
  with Sender as TNextGrid do
  begin
    i := GetRowAtPos(X,Y);

    if i > -1 then
    begin
      FLastChooseSelectedRow := i;
      mi_editPS.Enabled := True;
      Get_Part_Info(Cells[1,i]);
      GetSerialInfo2GUI(i);
      Get_Serial_Attfiles_FromList(i);
    end else
    begin
      mi_editPS.Enabled := False;
      SelectedRow := i;
      Init_Info;
    end;
  end;
end;

procedure TnewPartRequest_Frm.grid_PartCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  SelectPart;
end;

procedure TnewPartRequest_Frm.grid_PartMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LRow : Integer;
begin
  with Sender as TNextGrid do
  begin
    LRow := GetRowAtPos(X,Y);

    //grid_serialFiles.ClearRows;
    if LRow > -1 then
    begin
      mi_edit.Enabled := True;
      Get_Part_Info(Cells[1,LRow]);
    end else
    begin
      SelectedRow := LRow;
      Init_Info;
    end;
  end;
end;

procedure TnewPartRequest_Frm.Init_Info;
begin
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

procedure TnewPartRequest_Frm.Init_Serial;
begin
  //FSerialOnChangeMode := False;
  try
    cb_bank.Text := 'NULL';
    et_cyl.Text := '0';
    cb_cycle.Text := 'NULL';
    cb_side.Text := 'NULL';
    et_serial.Text := '';
  finally
    //FSerialOnChangeMode := True;
  end;

  grid_serialFiles.ClearRows;
end;

procedure TnewPartRequest_Frm.mi_editClick(Sender: TObject);
var
  LStr,
  LPartNo : String;
begin
  with grid_Part do
  begin
    if SelectedRow <> -1 then
    begin
      LStr := EngTypeLbl.Caption;
      LStr := Copy(LStr,Pos('-', LStr)+1, Length(LStr) - Pos('-', LStr));

      if Create_newPart_Frm(Cells[1,SelectedRow], et_msNumber.Hint, et_msNumber.Text, LStr) then
        Get_Part_List(et_msNumber.Hint);
    end;
  end;
end;

procedure TnewPartRequest_Frm.mi_editPSClick(Sender: TObject);
var
  i,j : Integer;
  LDeleteObj,
  LData : TJSONObject;
  LFileList : TStringList;
  LReqNo, LPartNo, LSerialNo: string;
begin
  with grid_choose do
  begin
    BeginUpdate;
    try
      i := FLastChooseSelectedRow;

      if i = -1 then
        Exit;

      LData := TJSONObject.Create;
      LFileList := TStringList.Create;
      try
        if Cells[8,i] = 'NULL' then
          LData.AddPair('BANK','NULL')
        else
          LData.AddPair('BANK',Cells[8,i]);

        LData.AddPair('CYLNUM',Cells[9,i]);

        if Cells[10,i] = 'NULL' then
          LData.AddPair('CYCLE','NULL')
        else
          LData.AddPair('CYCLE',Cells[10,i]);

        if Cells[11,i] = 'NULL' then
          LData.AddPair('SIDE','NULL')
        else
          LData.AddPair('SIDE',Cells[11,i]);

        if Cells[12,i] = 'NULL' then
          LData.AddPair('SERIAL','NULL')
        else
          LData.AddPair('SERIAL',Cells[12,i]);

        for j := 0 to grid_serialfiles.RowCount - 1 do
          LFileList.Add(grid_serialfiles.Cells[1,j]+';'+grid_serialfiles.Cells[6,j]+';'+grid_serialfiles.Cells[2,j]);

        Create_PartPosition_Frm(FEngType,FReqNo,grid_choose.Cells[1,i], i, LData,LFileList, FTestReqList);
        SetPartPosition2GUI(i, LData, LFileList);

        {if LData.Size > 0 then
        begin
          grid_choose.Cells[8,i]  := Return_Values(LData.Get('BANK'));
          grid_choose.Cells[9,i]  := Return_Values(LData.Get('CYLNUM'));
          grid_choose.Cells[10,i]  := Return_Values(LData.Get('CYCLE'));
          grid_choose.Cells[11,i] := Return_Values(LData.Get('SIDE'));
          grid_choose.Cells[12,i] := Return_Values(LData.Get('SERIAL'));
        end;}
      finally
        LData.Free;
        LFileList.Free;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewPartRequest_Frm.mi_msfileOpenClick(Sender: TObject);
var
  lms: TMemoryStream;
  litem : TListItem;
  lFileName : String;
  lRegNo : String;
begin
  lRegNo := grid_attfiles.Cells[4,grid_attfiles.SelectedRow];
  lFileName := grid_attfiles.Cells[1,grid_attfiles.SelectedRow];
  if lRegNo <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM HIMSEN_MS_ATTFILES ' +
              'WHERE PART_NO LIKE :param1 ' +
              'AND REG_NO = :param2 ');

      ParamByName('param1').AsString := grid_choose.Cells[1,FLastChooseSelectedRow];
      ParamByName('param2').AsString := lRegNo;
      Open;

      if not(RecordCount = 0) then
      begin
        lms := TMemoryStream.Create;
        try
          (FieldByName('Files') as TBlobField).SaveToStream(lms);
          lms.SaveToFile('C:\Temp\'+lFileName);

          ShellExecute(handle,'open',PWideChar('C:\Temp\'+lFileName),nil,nil,SW_NORMAL);
        finally
          FreeAndNil(lms);
        end;
      end;
    end;
  end;
end;

procedure TnewPartRequest_Frm.mi_msfileSaveClick(Sender: TObject);
var
  lms: TMemoryStream;
  litem : TListItem;
  lFileName : String;
  lDirectory : String;
  lRegNo : String;
begin
  lRegNo := grid_attfiles.Cells[4,grid_attfiles.SelectedRow];
  lFileName := grid_attfiles.Cells[1,grid_attfiles.SelectedRow];
  if lRegNo <> '' then
  begin
    SaveDialog1.FileName := lFileName;
    if SaveDialog1.Execute then
    begin
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HIMSEN_MS_ATTFILES ' +
                'WHERE PART_NO LIKE :param1 ' +
                'AND REG_NO = :param2 ');

        ParamByName('param1').AsString := grid_choose.Cells[1,FLastChooseSelectedRow];
        ParamByName('param2').AsString := lRegNo;
        Open;

        if not(RecordCount = 0) then
        begin
          lms := TMemoryStream.Create;
          try
            (FieldByName('Files') as TBlobField).SaveToStream(lms);
            lms.SaveToFile(SaveDialog1.FileName);

            lDirectory := ExtractFilePath(ExcludeTrailingBackslash(SaveDialog1.FileName));

            ShowMessage('파일저장 완료!');
            ShellExecute(handle,'open',PWideChar(lDirectory),nil,nil,SW_NORMAL);
          finally
            FreeAndNil(lms);
          end;
        end;
      end;
    end;
  end;
end;

procedure TnewPartRequest_Frm.mi_serialFileOpenClick(Sender: TObject);
var
  lms: TMemoryStream;
  litem : TListItem;
  lFileName : String;
  lRegNo : String;
begin
  lRegNo := grid_serialFiles.Cells[4,grid_serialFiles.SelectedRow];
  lFileName := grid_serialFiles.Cells[1,grid_serialFiles.SelectedRow];
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM TMS_TEST_PART_ATTFILES ' +
            'WHERE FILE_NAME LIKE :param1 ' +
            'AND PART_NO LIKE :param2 ' +
            'AND SERIAL LIKE :param3 ' +
            'AND REQ_NO LIKE :param4 ');

    ParamByName('param1').AsString := grid_serialFiles.Cells[1,grid_serialFiles.SelectedRow];
    ParamByName('param2').AsString := grid_serialFiles.Cells[4,grid_serialFiles.SelectedRow];
    ParamByName('param3').AsString := grid_serialFiles.Cells[5,grid_serialFiles.SelectedRow];
    ParamByName('param4').AsString := grid_serialFiles.Cells[3,grid_serialFiles.SelectedRow];

    Open;

    if not(RecordCount = 0) then
    begin
      lms := TMemoryStream.Create;
      try
        (FieldByName('Files') as TBlobField).SaveToStream(lms);
        lms.SaveToFile('C:\Temp\'+lFileName);

        ShellExecute(handle,'open',PWideChar('C:\Temp\'+lFileName),nil,nil,SW_NORMAL);
      finally
        FreeAndNil(lms);
      end;
    end;
  end;
end;
procedure TnewPartRequest_Frm.mi_serialFileSaveClick(Sender: TObject);
var
  lms: TMemoryStream;
  litem : TListItem;
  lFileName : String;
  lDirectory : String;
  lRegNo : String;
begin
  lRegNo := grid_serialFiles.Cells[4,grid_serialFiles.SelectedRow];
  lFileName := grid_serialFiles.Cells[1,grid_serialFiles.SelectedRow];
  if lRegNo <> '' then
  begin
    SaveDialog1.FileName := lFileName;
    if SaveDialog1.Execute then
    begin
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM TMS_TEST_PART_ATTFILES ' +
                'WHERE FILE_NAME LIKE :param1 ' +
                'AND PART_NO LIKE :param2 ' +
                'AND SERIAL LIKE :param3 ' +
                'AND REQ_NO LIKE :param4 ');

        ParamByName('param1').AsString := grid_serialFiles.Cells[1,grid_serialFiles.SelectedRow];
        ParamByName('param2').AsString := grid_serialFiles.Cells[4,grid_serialFiles.SelectedRow];
        ParamByName('param3').AsString := grid_serialFiles.Cells[5,grid_serialFiles.SelectedRow];
        ParamByName('param4').AsString := grid_serialFiles.Cells[3,grid_serialFiles.SelectedRow];

        Open;

        if not(RecordCount = 0) then
        begin
          lms := TMemoryStream.Create;
          try
            (FieldByName('Files') as TBlobField).SaveToStream(lms);
            lms.SaveToFile(SaveDialog1.FileName);

            lDirectory := ExtractFilePath(ExcludeTrailingBackslash(SaveDialog1.FileName));

            ShowMessage('파일저장 완료!');
            ShellExecute(handle,'open',PWideChar(lDirectory),nil,nil,SW_NORMAL);
          finally
            FreeAndNil(lms);
          end;
        end;
      end;
    end;
  end;
end;

procedure TnewPartRequest_Frm.N1Click(Sender: TObject);
var
  li,le, LRowNo : integer;
  lms : TMemoryStream;
  lfilename : String;
  //lExt : String;
  lSize : int64;
  lResult : Boolean;
  LReqNo, LPartNo, LSerialNo: string;
begin
  if (grid_choose.RowCount = 0) or (FLastChooseSelectedRow = -1) then
    exit;

  if (et_serial.Text = '') or (et_serial.Text = 'NULL') then
    exit;

  if OpenDialog1.Execute then
  begin
    with OpenDialog1 do
    begin
      for li := 0 to Files.Count-1 do
      begin
        lfilename := ExtractFileName(Files.Strings[li]);

        with grid_serialFiles do
        begin
          BeginUpdate;
          try
            lResult := True;

            for le := 0 to RowCount-1 do
            begin
              if lfilename = Cells[1,le] then
              begin
                raise Exception.Create(Format('%s : 같은 이름의 파일이 등록되어 있습니다.',[lfilename]));
                lResult := False;
                Break;
              end;
            end;

            if lResult = True then
            begin
              //lms := TMemoryStream.Create;
              //try
                //lms.LoadFromFile(Files.Strings[li]);
                //lsize := lms.Size;
                lsize := FileSize(Files.Strings[li]);
                //lExt := ExtractFileExt(lfileName);
                //Delete(lExt,1,1);
                LRowNo := AddRow;
                Cells[1,LRowNo] := lfilename;
                Cells[2,LRowNo] := Files.Strings[li];
                Cells[6,LRowNo] := IntToStr(lsize);
                FTestReqList.GetSerialFileInfo(FLastChooseSelectedRow,LReqNo, LPartNo, LSerialNo);
                FTestReqList.AddSerialFile(FLastChooseSelectedRow,LRowNo,
                                          Cells[1,LRowNo],
                                          Cells[2,LRowNo],
                                          Cells[6,LRowNo],
                                          LReqNo, LPartNo, LSerialNo,'');
              //finally
                //FreeAndNil(lms);
              //end;
            end;
          finally
            EndUpdate;
          end;
        end;
      end;
    end;
  end;
end;

procedure TnewPartRequest_Frm.N2Click(Sender: TObject);
begin
  FTestReqList.DeleteSerialFile(FLastChooseSelectedRow, grid_serialFiles.SelectedRow);
  grid_serialFiles.DeleteRow(grid_serialFiles.SelectedRow);
end;

function TnewPartRequest_Frm.Return_Values(aTJSONPair: TJSONPair): String;
var
  lstr : String;
  ljsonValue : TJSONValue;
begin
  ljsonValue := aTJSONPair.JsonValue;
  Result := ljsonValue.Value;
end;

procedure TnewPartRequest_Frm.SelectPart;
var
  i,j,k: Integer;
  LPartNo, LStr: String;
  LTestPartItem: TTestPartItem;
  LData: TJSONObject;
  LFileList: TStringList;
begin
  with grid_Part do
  begin

    if SelectedRow > -1 then
    begin
      i := grid_choose.AddRow;

      grid_choose.Cells[1,i] := Cells[1,SelectedRow];
      grid_choose.Cell[2,i].AsInteger := i;
      grid_choose.Cells[3,i] := Cells[2,SelectedRow];
      grid_choose.Cells[4,i] := Cells[3,SelectedRow];
      grid_choose.Cells[5,i] := Cells[4,SelectedRow];
      grid_choose.Cells[6,i] := Cells[5,SelectedRow];
      grid_choose.Cells[7,i] := Cells[6,SelectedRow];

      LData := TJSONObject.Create;
      LFileList := TStringList.Create;
      try
        Create_PartPosition_Frm(FEngType,FReqNo,Cells[1,SelectedRow],-1,LData,LFileList);
        SetPartPosition2GUI(i,LData,LFileList);

        LTestPartItem := FTestReqList.TestPartCollect.Add;

        //grid_choose.Row[i].Data := LTestPartItem;

        with LTestPartItem do
        begin
          ID := now;
          FileLocation := flDisk;
          RowNo := i;
          Req_No := FReqNo;
          PART_NO := grid_choose.Cells[1,i];
          SEQ_NO := grid_choose.Cells[2,i];

          MS_NO := grid_choose.Cells[3,i];
          PARTNAME := grid_choose.Cells[4,i];
          MAKER := grid_choose.Cells[5,i];
          PARTTYPE := grid_choose.Cells[6,i];
          PARTSPEC := grid_choose.Cells[7,i];
          //STATUS := FieldByName('STATUS').AsString;
        end;

        for j := 0 to grid_serialFiles.RowCount - 1 do
        begin
          with FTestReqList.TestPartSerialFileCollect.Add do
          begin
            ID := LTestPartItem.ID;
            RowNo := j;
            FileLocation := flDisk;
            FileAction := faInsert;
            ReqNo := FReqNo;
            FileName := grid_serialFiles.Cells[1,j];
            FileSize := StrToIntDef(grid_serialFiles.Cells[6,j],0);
            FilePath := grid_serialFiles.Cells[2,j];
          end;
        end;

        with FTestReqList.TestPartSerialCollect.Add do
        begin
          ID := LTestPartItem.ID;
          FileLocation := flDisk;
          FileAction := faInsert;
          BANK := grid_choose.Cells[8,i];
          CYL_NO := grid_choose.Cells[9,i];
          EXH_INTAKE := grid_choose.Cells[10,i];
          EXH_CAMSIDE := grid_choose.Cells[11,i];
          SERIAL_NO := grid_choose.Cells[12,i];
        end;
      finally
        LFileList.Free;
        LData.Free;
      end;
    end;
  end;
end;

procedure TnewPartRequest_Frm.SetPartPosition2GUI(ARow: integer; AData: TJSONObject; AFileList: TStringList);
var
  j,k: integer;
  LStr: string;
begin
  if AData.Size > 0 then
  begin
    grid_choose.Cells[8,ARow]  := Return_Values(AData.Get('BANK'));
    grid_choose.Cells[9,ARow]  := Return_Values(AData.Get('CYLNUM'));
    grid_choose.Cells[10,ARow]  := Return_Values(AData.Get('CYCLE'));
    grid_choose.Cells[11,ARow] := Return_Values(AData.Get('SIDE'));
    grid_choose.Cells[12,ARow] := Return_Values(AData.Get('SERIAL'));

    FSerialOnChangeMode := False;
    try
      cb_bank.Text := grid_choose.Cells[8,ARow];
      et_cyl.Text := grid_choose.Cells[9,ARow];
      cb_cycle.Text := grid_choose.Cells[10,ARow];
      cb_side.Text := grid_choose.Cells[11,ARow];
      et_serial.Text := grid_choose.Cells[12,ARow];
    finally
      FSerialOnChangeMode := True;
    end;

    grid_serialFiles.ClearRows;

    for j := 0 to AFileList.Count - 1 do
    begin
      k := grid_serialFiles.AddRow();
      LStr := AFileList.Strings[j];
      grid_serialFiles.Cells[1,k] := GetToken(LStr, ';');
      grid_serialFiles.Cells[6,k] := GetToken(LStr, ';');
      grid_serialFiles.Cells[2,k] := GetToken(LStr, ';');
    end;
  end;
end;

end.
