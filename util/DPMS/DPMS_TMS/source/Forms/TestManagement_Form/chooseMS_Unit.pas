unit chooseMS_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, AdvGlowButton,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.ImgList, Ora, Vcl.StdCtrls, JvExControls,
  JvLabel;

type
  TchooseMS_Frm = class(TForm)
    Panel5: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    AdvGlowButton1: TAdvGlowButton;
    ImageList16x16: TImageList;
    AdvGlowButton2: TAdvGlowButton;
    Panel1: TPanel;
    JvLabel3: TJvLabel;
    et_Filter: TEdit;
    grid_MS: TNextGrid;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTreeColumn1: TNxTreeColumn;
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure et_FilterChange(Sender: TObject);
    procedure grid_MSCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure AdvGlowButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  chooseMS_Frm: TchooseMS_Frm;
  function Create_chooseMS_Frm(aQuery:TOraQuery) : Integer;

implementation

{$R *.dfm}

function Create_chooseMS_Frm(aQuery:TOraQuery) : Integer;
var
  i,
  LRow : Integer;
begin
  Result := -1;
  chooseMS_Frm := TchooseMS_Frm.Create(nil);
  try
    with chooseMS_Frm do
    begin
      with grid_MS do
      begin
        BeginUpdate;
        try
          ClearRows;

          LRow := AddRow;
          Cells[0,LRow] := '1';
          Cells[1,LRow] := '';
          Cells[2,LRow] := 'MS_NUMBER';

          with aQuery do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT MS_NO, NVL(PARENT_NO,1) PARENT_NO, UPPER(MS_NAME) MS_NAME FROM DPMS_HIMSEN_MS_NUMBER ' +
                    'START WITH PARENT_NO IS NULL ' +
                    'CONNECT BY PRIOR MS_NO = PARENT_NO ' +
                    'ORDER SIBLINGS BY MS_NO ');
            Open;

            while not eof do
            begin
              if RowCount = 0 then
                LRow := AddRow
              else
              begin
                if FieldByName('PARENT_NO').AsString <> '' then
                begin
                  for i := 0 to RowCount-1 do
                  begin
                    if Cells[0,i] = FieldByName('PARENT_NO').AsString then
                    begin
                      AddChildRow(i,crLast);
                      LRow := LastAddedRow;
                      Break;
                    end;
                  end;
                end else
                  LRow := AddRow;

              end;

              Cells[0,LRow] := FieldByName('MS_NO').AsString;
              Cells[1,LRow] := FieldByName('PARENT_NO').AsString;
              Cells[2,LRow] := FieldByName('MS_NAME').AsString;
              Next;
            end;

            ShowModal;

            if ModalResult = mrOk then
            begin
              if RowCount <> 0 then
                Result := SelectedRow
              else
                Result := 0;
            end
            else
              Result := 0;

          end;
        finally
          EndUpdate;
        end;
      end;
    end;

  finally
    FreeAndNil(chooseMS_Frm);
  end;
end;

procedure TchooseMS_Frm.AdvGlowButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TchooseMS_Frm.AdvGlowButton2Click(Sender: TObject);
begin
  if grid_MS.SelectedRow = -1 then
  begin
    ShowMessage('MS 번호를 선택하여 주십시오!');
    Exit;
  end;

  ModalResult := mrOk;

end;

procedure TchooseMS_Frm.et_FilterChange(Sender: TObject);
var
  i: Integer;
  s: string;
  rv: Boolean;
begin
  with grid_MS do
  begin
    BeginUpdate;
    try
      s := UpperCase(et_filter.Text);
      for i := 0 to RowCount - 1 do
      begin
        if GetChildCount(i) = 0 then
        begin
          rv := (s = '') or (Pos(s, UpperCase(Cell[2, i].AsString)) > 0);
          RowVisible[i] := rv;

          if s <> '' then
            Cell[2,i].TextColor := clRed
          else
            Cell[2,i].TextColor := clBlack;

        end;
      end;
    finally
      Refresh;
      EndUpdate;
    end;
  end;
end;

procedure TchooseMS_Frm.grid_MSCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  ModalResult := mrOk;
end;

end.
