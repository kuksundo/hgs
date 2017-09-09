unit workerDialog_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ImgList, JvExControls, JvLabel, StrUtils,
  AdvOfficeTabSet, AeroButtons, Vcl.ComCtrls;

type
  TworkerDialog_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    ImageList1: TImageList;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    grid_Worker: TNextGrid;
    ImageList32x32: TImageList;
    Panel1: TPanel;
    JvLabel2: TJvLabel;
    AeroButton1: TAeroButton;
    NxIncrementColumn1: TNxIncrementColumn;
    NxImageColumn1: TNxImageColumn;
    Panel3: TPanel;
    Panel4: TPanel;
    JvLabel1: TJvLabel;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    AeroButton2: TAeroButton;
    AeroButton3: TAeroButton;
    grid_Result: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    AeroButton4: TAeroButton;
    procedure grid_workerSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure AeroButton2Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure AeroButton3Click(Sender: TObject);
    procedure AeroButton1Click(Sender: TObject);
    procedure AeroButton4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Get_Users(aDept_CD:String);
  end;

var
  workerDialog_Frm: TworkerDialog_Frm;
  function Create_workerDialog_Frm(aDept_CD:String):String;

implementation
uses
  DataModule_Unit;

{$R *.dfm}

function Create_workerDialog_Frm(aDept_CD:String):String;
var
  i : Integer;
  str : String;
begin
  workerDialog_Frm := TworkerDialog_Frm.Create(nil);
  try
    Result := '';
    with workerDialog_Frm do
    begin
      PageControl1.ActivePageIndex := StrToInt(RightStr(aDept_CD,1))-1;
      Get_Users(aDept_CD);
      ShowModal;

      if ModalResult = mrOk then
      begin
        with grid_Result do
        begin
          BeginUpdate;
          try
            for i := 0 to RowCount-1 do
              Result := Result + Cells[2,i]+',';

            if Result <> '' then
              Result := Copy(Result,1,Length(Result)-1);

          finally
            EndUpdate;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(workerDialog_Frm);
  end;
end;

{ Tworker_Frm }

procedure TworkerDialog_Frm.AeroButton1Click(Sender: TObject);
begin
  if grid_Result.RowCount > 0 then
    ModalResult := mrOk
  else
    ShowMessage('담당자를 선택하여 주십시오!');
end;

procedure TworkerDialog_Frm.AeroButton2Click(Sender: TObject);
var
  i,j : Integer;
  LRow : Integer;
  LBoolean : Boolean;
begin
  with grid_Worker do
  begin
    for i := 0 to RowCount-1 do
    begin
      if Cell[1,i].AsInteger = 1 then
      begin
        with grid_Result do
        begin
          LBoolean := True;
          for j := 0 to RowCount-1 do
          begin
            if Cells[2,j] = grid_Worker.Cells[3,i] then
            begin
              LBoolean := False;
              Break;
            end;
          end;

          if LBoolean then
          begin
            LRow := AddRow;
            Cells[1,LRow] := grid_Worker.Cells[2,i];
            Cells[2,LRow] := grid_Worker.Cells[3,i];
          end;
          //선택해제
          grid_Worker.Cell[1,i].AsInteger := 0;
        end;
      end;
    end;
  end;
end;

procedure TworkerDialog_Frm.AeroButton3Click(Sender: TObject);
begin
  with grid_Result do
  begin
    BeginUpdate;
    try
      DeleteRow(SelectedRow);
      Refresh;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TworkerDialog_Frm.AeroButton4Click(Sender: TObject);
begin
  Close;
end;

procedure TworkerDialog_Frm.Get_Users(aDept_CD: String);
var
  lrow : Integer;
begin
  with grid_worker do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT A.*, B.DESCR FROM DPMS_USER A, DPMS_USER_GRADE B ' +
                'WHERE A.GRADE = B.GRADE ' +
                'AND A.GUNMU LIKE ''I'' ' +
                'AND A.DEPT_CD LIKE :param1 ' +
                'ORDER BY PRIV DESC, POSITION, A.GRADE, USERID ');
        ParamByName('param1').AsString := aDept_CD;
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            lrow := AddRow;
            Cell[1,lrow].AsInteger := 0;
            Cells[2,lrow] := FieldByName('NAME_KOR').AsString+'/'+FieldByName('DESCR').AsString;
            Cells[3,lrow] := FieldByName('USERID').AsString;

            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TworkerDialog_Frm.grid_workerSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  with grid_worker do
  begin
    if ARow = -1 then
      Exit;

    if Cell[1,ARow].AsInteger = 0 then
      Cell[1,ARow].AsInteger := 1
    else
      Cell[1,ARow].AsInteger := 0;

  end;
end;

procedure TworkerDialog_Frm.PageControl1Change(Sender: TObject);
var
  LTeam : String;
begin
  LTeam := 'K2B3-'+IntToStr(PageControl1.ActivePageIndex+1);
  Get_Users(LTeam);
end;

end.

