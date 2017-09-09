unit TMS_codeTree_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  AdvGroupBox, AdvOfficeStatusBar, Vcl.ExtCtrls, NxEdit, Vcl.DBCtrls, AdvEdit,
  NxCollection, Vcl.ComCtrls, Data.DB, MemDS, DBAccess, Ora, OraSmart,
  Vcl.Menus, AdvMenus, GradientLabel, AdvGlowButton, TreeList, System.Generics.Collections,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, JvExControls, JvLabel, Vcl.ImgList, Vcl.Imaging.jpeg;
//  empPerformance_Unit;

type
  TTMS_codeTree_Frm = class(TForm)
    Panel2: TPanel;
    GradientLabel1: TGradientLabel;
    Label1: TLabel;
    Label2: TLabel;
    AdvEdit1: TAdvEdit;
    AdvEdit2: TAdvEdit;
    Label3: TLabel;
    AdvEdit3: TAdvEdit;
    Panel3: TPanel;
    regBtn: TAdvGlowButton;
    AdvGlowButton1: TAdvGlowButton;
    Panel4: TPanel;
    Panel5: TPanel;
    grid_Code: TNextGrid;
    NxTextColumn7: TNxTextColumn;
    JvLabel3: TJvLabel;
    NxTextColumn1: TNxTextColumn;
    NxNumberColumn2: TNxNumberColumn;
    NxTreeColumn1: TNxTreeColumn;
    ImageList16x16: TImageList;
    et_Filter: TEdit;
    Panel8: TPanel;
    Image1: TImage;
    JvLabel1: TJvLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure regBtnClick(Sender: TObject);
    procedure grid_CodeSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure et_FilterChange(Sender: TObject);
    procedure grid_CodeCellDblClick(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
    FCurrentNode : TTreeNode;
    FResultString : String;
    FcodeDic : TDictionary<String,TTreeNode>;
  public
    FDeptNo : String;
    { Public declarations }
    procedure Set_Type_Description(aCode:String);
    procedure Set_CodeTree(aCodeType:String);
  end;

var
  TMS_codeTree_Frm: TTMS_codeTree_Frm;
  function Create_codeTree_frm(aCode,aCodeType:String) : String;

implementation
uses
  HiTEMS_TMS_COMMON,
  HiTEMS_TMS_CONST,
  CommonUtil_Unit,
  DataModule_Unit;




{$R *.dfm}

function Create_codeTree_frm(aCode,aCodeType:String) : String;
var
  li : integer;
begin
  if not Assigned(TMS_codeTree_Frm) then
  begin
    TMS_codeTree_Frm := TTMS_codeTree_Frm.Create(nil);
    try
      with TMS_codeTree_Frm do
      begin
        Set_CodeTree(aCodeType);
        ShowModal;
        if ModalResult = mrOk then
          Result := FResultString;

      end;
    finally
      FreeAndNil(TMS_codeTree_Frm);
    end;
  end;
end;

procedure TTMS_codeTree_Frm.AdvGlowButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TTMS_codeTree_Frm.et_FilterChange(Sender: TObject);
var
  i: Integer;
  s: string;
  RowVisible: Boolean;
begin
  s := UpperCase(et_filter.Text);
  for i := 0 to grid_Code.RowCount - 1 do
  begin
    if grid_Code.GetChildCount(i) = 0 then
    begin
      RowVisible := (s = '') or (Pos(s, UpperCase(grid_Code.Cell[0, i].AsString)) > 0);
      grid_Code.RowVisible[i] := RowVisible;

      if s <> '' then
        grid_Code.Cell[0,i].TextColor := clRed
      else
        grid_Code.Cell[0,i].TextColor := clBlack;

    end;
  end;
end;

procedure TTMS_codeTree_Frm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(FcodeDic) then
    FreeAndNil(FcodeDic);

  Action := caFree;
end;

procedure TTMS_codeTree_Frm.grid_CodeCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  if AdvEdit3.Text <> '' then
  begin
    FResultString := AdvEdit3.Text;
    ModalResult := mrOk;
  end;
end;

procedure TTMS_codeTree_Frm.grid_CodeSelectCell(Sender: TObject; ACol,
  ARow: Integer);
var
  LPath_Code : String;
  LRow, QRow : Integer;
  i: Integer;
begin
  if ARow = -1 then
  begin
    AdvEdit1.Clear;
    AdvEdit2.Clear;
    AdvEdit3.Clear;
    Exit;
  end;

  with grid_Code do
  begin
    BeginUpdate;
    try
      if GetChildCount(ARow) > 0 then
      begin
        LRow := -1;
        QRow := GetFirstChild(ARow);
        for i := 0 to GetChildCount(ARow)-1 do
        begin
          if RowVisible[QRow+i] then
          begin
            LRow := QRow+i;
            Break;
          end;
        end;
        SelectedRow := LRow;
        Exit;
      end;

      Set_Type_Description(grid_Code.Cells[1,ARow]);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TTMS_codeTree_Frm.Set_CodeTree(aCodeType:String);
var
  LRow,
  i : integer;
  typeNo : Double;
  deptNm,
  typeNm : String;

begin
  with grid_Code do
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
                '      PARENT_NO, CAT_NO, CAT_NAME, SEQ_NO ' +
                '   FROM HITEMS_CODE_CATEGORY UNION ALL ' +
                '   SELECT ' +
                '      CAT_NO, GRP_NO, CODE_NAME, SEQ_NO ' +
                '   FROM HITEMS_CODE_GROUP ' +
                ') START WITH CAT_NO = :param1 ' +
                'CONNECT BY PRIOR CAT_NO = PARENT_NO ' +
                'ORDER SIBLINGS BY CAT_NO, SEQ_NO ');
        ParamByName('param1').AsString := aCodeType;//A:계획코드, B:실적코드
        Open;

        while not eof do
        begin
          if RowCount = 0 then
            LRow := AddRow(1)
          else
          begin
            if FieldByName('PARENT_NO').AsString <> '' then
            begin
              for i := 0 to RowCount-1 do
              begin
                if Cells[1,i] = FieldByName('PARENT_NO').AsString then
                begin
                  AddChildRow(i,crLast);
                  LRow := LastAddedRow;
                  Break;
                end;
              end;
            end else
              LRow := AddRow(1);

          end;

          Cells[0,LRow] := FieldByName('CAT_NAME').AsString;
          Cells[1,LRow] := FieldByName('CAT_NO').AsString;
          Cells[2,LRow] := FieldByName('PARENT_NO').AsString;
          Cell[3,LRow].AsInteger := FieldByName('SEQ_NO').AsInteger;

          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TTMS_codeTree_Frm.regBtnClick(Sender: TObject);
begin
  if AdvEdit3.Text <> '' then
  begin
    FResultString := AdvEdit3.Text;
    ModalResult := mrOk;
  end else
    ShowMessage('선택된 코드가 없습니다!');

end;

procedure TTMS_codeTree_Frm.Set_Type_Description(aCode:String);
begin
  if aCode <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM ' +
              '( ' +
              '   SELECT ' +
              '     PARENT_NO, CAT_NO, CAT_NAME, CAT_DESC, SEQ_NO ' +
              '   FROM HITEMS_CODE_CATEGORY UNION ALL ' +
              '   ( ' +
              '     SELECT CAT_NO, GRP_NO, CODE_NAME, CODE_DESC, SEQ_NO ' +
              '     FROM ' +
              '     ( ' +
              '       SELECT A.*, B.CODE_DESC FROM HITEMS_CODE_GROUP A, HITEMS_CODE B ' +
              '       WHERE A.CODE = B.CODE ' +
              '     ) ' +
              '   ) ' +
              ') WHERE CAT_NO = :param1 ');
      ParamByName('param1').AsString := aCode;
      Open;

      if not(RecordCount = 0) then
      begin
        AdvEdit1.Text := FieldByName('CAT_NAME').AsString;
        AdvEdit2.Text := FieldByName('CAT_DESC').AsString;
        AdvEdit3.Text := FieldByName('CAT_NO').AsString;
      end;
    end;
  end;
end;

end.
