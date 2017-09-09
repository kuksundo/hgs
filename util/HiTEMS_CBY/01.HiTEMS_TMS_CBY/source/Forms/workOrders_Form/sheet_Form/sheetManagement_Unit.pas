unit sheetManagement_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, AeroButtons, JvExControls, JvLabel, Vcl.ImgList,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid;

type
  TsheetManagement_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    ImageList32x32: TImageList;
    ImageList16x16: TImageList;
    pn_Main: TPanel;
    JvLabel22: TJvLabel;
    btn_Close: TAeroButton;
    JvLabel27: TJvLabel;
    et_codeName: TEdit;
    et_code: TEdit;
    JvLabel5: TJvLabel;
    grid_sheetList: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    grid_codeSheet: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    JvLabel1: TJvLabel;
    Button1: TButton;
    Button2: TButton;
    ImageList24x24: TImageList;
    btn_Ok: TAeroButton;
    NxComboBoxColumn2: TNxComboBoxColumn;
    procedure btn_CloseClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
    procedure NxComboBoxColumn2Select(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Get_sheetList;
    procedure Get_Code_Sheet(aCode:String);
    procedure Insert_Code_Sheet(aRow:Integer);
    function Del_Code_Sheet(aClassName:String):Boolean;
  end;

var
  sheetManagement_Frm: TsheetManagement_Frm;
  procedure Create_sheetManagement_Frm(aCode,aCodeName:String);

implementation
uses
  DataModule_Unit;

{$R *.dfm}

procedure Create_sheetManagement_Frm(aCode,aCodeName:String);
begin
  sheetManagement_Frm := TsheetManagement_Frm.Create(nil);
  try
    with sheetManagement_Frm do
    begin
      et_code.Text := aCode;
      et_codeName.Text := aCodeName;
      Get_sheetList;
      Get_Code_Sheet(et_Code.Text);

      ShowModal;
    end;
  finally
    FreeAndNil(sheetManagement_Frm);
  end;
end;

procedure TsheetManagement_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TsheetManagement_Frm.btn_OkClick(Sender: TObject);
var
  i : Integer;
begin
  with grid_codeSheet do
  begin
    BeginUpdate;
    try
      for i := RowCount-1 DownTo 0 do
      begin
        if Cell[0,i].TextColor = clBlue then
        begin
          if Del_Code_Sheet(Cells[1,i]) then
            Insert_Code_Sheet(i);
        end;
        if Cell[0,i].TextColor = clRed then
        begin
          if Del_Code_Sheet(Cells[1,i]) then
            DeleteRow(i);
        end;
      end;
    finally
      Get_Code_Sheet(et_code.Text);
      EndUpdate;
    end;
  end;
end;

procedure TsheetManagement_Frm.Button1Click(Sender: TObject);
var
  i,
  LRow : Integer;
begin
  with grid_sheetList do
  begin
    BeginUpdate;
    try
      if SelectedRow = -1 then
        Exit
      else
        LRow := SelectedRow;

      with grid_codeSheet do
      begin
        BeginUpdate;
        try
          for i := 0 to RowCount-1 do
          begin
            if SameText(grid_sheetList.Cells[1,LRow],Cells[1,LastAddedRow]) then
              Exit;
          end;

          AddRow;
          Cells[1,LastAddedRow] := grid_sheetList.Cells[1,LRow];
          Cells[2,LastAddedRow] := grid_sheetList.Cells[2,LRow];

          for i := 0 to Columns.Count-1 do
            Cell[i,LastAddedRow].TextColor := clBlue;

        finally
          EndUpdate;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TsheetManagement_Frm.Button2Click(Sender: TObject);
var
  i,
  LRow : Integer;
begin
  with grid_codeSheet do
  begin
    BeginUpdate;
    try
      if SelectedRow = -1 then
        Exit
      else
        LRow := SelectedRow;

      if Cell[0,LRow].TextColor = clBlue then
        DeleteRow(LRow)
      else
        for i := 0 to Columns.Count-1 do
          Cell[i,LRow].TextColor := clRed;

    finally
      EndUpdate;
    end;
  end;
end;

function TsheetManagement_Frm.Del_Code_Sheet(aClassName: String):Boolean;
begin
  Result := False;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('DELETE FROM TMS_WORK_CODE_SHEET ' +
            'WHERE CODE LIKE :param1 ' +
            'AND CLASS_NAME LIKE :param2 ');
    ParamByName('param1').AsString := et_code.Text;
    ParamByName('param2').AsString := aClassName;
    ExecSQL;
    Result := True;
  end;
end;

procedure TsheetManagement_Frm.Get_Code_Sheet(aCode: String);
begin
  with grid_codeSheet do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT A.*, B.SHEET_NAME_K FROM TMS_WORK_CODE_SHEET A, TMS_WORK_SHEET B ' +
                'WHERE CODE LIKE :param1 ' +
                'AND A.CLASS_NAME = B.CLASS_NAME ' +
                'ORDER BY A.SEQ_NO ');
        ParamByName('param1').AsString := aCode;
        Open;

        while not eof do
        begin
          AddRow;
          Cells[1,LastAddedRow] := FieldByName('CLASS_NAME').AsString;
          Cells[2,LastAddedRow] := FieldByName('SHEET_NAME_K').AsString;
          Cells[3,LastAddedRow] := FieldByName('ACTION_TIME').AsString;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TsheetManagement_Frm.Get_sheetList;
begin
  with grid_sheetList do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM TMS_WORK_SHEET ');
        Open;

        while not eof do
        begin
          AddRow;

          Cells[1,LastAddedRow] := FieldByName('CLASS_NAME').AsString;
          Cells[2,LastAddedRow] := FieldByName('SHEET_NAME_K').AsString;
          Cells[3,LastAddedRow] := FieldByName('SHEET_DESC').AsString;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TsheetManagement_Frm.Insert_Code_Sheet(aRow: Integer);
begin
  with grid_codeSheet do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO TMS_WORK_CODE_SHEET ' +
                '(CODE, CLASS_NAME, SEQ_NO, ACTION_TIME) ' +
                'VALUES ' +
                '(:CODE, :CLASS_NAME, :SEQ_NO, :ACTION_TIME) ');

        ParamByName('CODE').AsString        := et_code.Text;
        ParamByName('CLASS_NAME').AsString  := Cells[1,aRow];
        ParamByName('SEQ_NO').AsInteger     := Cell[0,aRow].AsInteger;
        ParamByName('ACTION_TIME').AsString := Cell[3,aRow].AsString;
        ExecSQL;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TsheetManagement_Frm.NxComboBoxColumn2Select(Sender: TObject);
var
  i,
  LRow : Integer;
begin
  with grid_codeSheet do
  begin
    BeginUpdate;
    try
      LRow :=  SelectedRow;
      for i := 0 to Columns.Count-1 do
        Cell[i,LRow].TextColor := clBlue;
    finally
      EndUpdate;
    end;
  end;
end;
end.
