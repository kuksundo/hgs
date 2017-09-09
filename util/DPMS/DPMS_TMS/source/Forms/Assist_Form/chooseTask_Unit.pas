unit chooseTask_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlowButton, NxColumnClasses,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Ora,  System.Generics.Collections, Vcl.ImgList;

type
  TchooseTask_Frm = class(TForm)
    Panel5: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    AdvGlowButton1: TAdvGlowButton;
    ImageList16x16: TImageList;
    taskGrid: TNextGrid;
    NxTreeColumn2: TNxTreeColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure taskGridCustomDrawCell(Sender: TObject; ACol, ARow: Integer;
      CellRect: TRect; CellState: TCellState);
    procedure taskGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
    FSelectedType : String;
  public
    { Public declarations }
    function GetButtonRect(ARect:TRect;Level:Integer):TRect;
  end;

var
  chooseTask_Frm: TchooseTask_Frm;
  function Create_chooseTask_Frm(aSelectedType:String;aQuery:TOraQuery) : String;


implementation

{$R *.dfm}

function Create_chooseTask_Frm(aSelectedType:String;aQuery:TOraQuery) : String;
var
  ldic : TDictionary<string,integer>;
  i,
  lrow : Integer;
begin
  chooseTask_Frm := TchooseTask_Frm.Create(nil);
  try
    with chooseTask_Frm do
    begin
      FSelectedType := aSelectedType;
      with taskGrid do
      begin
        BeginUpdate;
        try
          with aQuery do
          begin
            First;
            while not eof do
            begin
              if RowCount = 0 then
                LRow := AddRow(1)
              else
              begin
                if FieldByName('TASK_PRT').AsString <> '' then
                begin
                  for i := 0 to RowCount-1 do
                  begin
                    if Cells[0,i] = FieldByName('TASK_PRT').AsString then
                    begin
                      AddChildRow(i,crLast);
                      LRow := LastAddedRow;
                      Break;
                    end;
                  end;
                end else
                  LRow := AddRow(1);

              end;

              Cells[0,LRow] := FieldByName('TASK_NO').AsString;
              Cells[1,LRow] := FieldByName('TASK_PRT').AsString;
              Cells[2,LRow] := FieldByName('TASK_NAME').AsString;
              Cells[3,LRow] := FieldByName('TYPE').AsString;

              Next;
            end;

            ShowModal;

            if ModalResult = mrOk then
              Result := Cells[0,SelectedRow];

          end;
        finally
          EndUpdate;
        end;
      end;
    end;
  finally
    FreeAndNil(chooseTask_Frm);
  end;
end;

procedure TchooseTask_Frm.AdvGlowButton1Click(Sender: TObject);
begin
  Close;
end;

function TchooseTask_Frm.GetButtonRect(ARect: TRect; Level: Integer): TRect;
var
  m, t: Integer;
begin
  m := ARect.Top + (ARect.Bottom - ARect.Top) div 2;
  t := m - 5;
  with Result do
  begin
    Left := Level * 19;
    Left := ARect.Left + Level * 19;
    Right := Left + 9;
    Top := ARect.Top;
    Bottom := Top + 3;
  end;
  OffsetRect(Result, 15, 3);
end;

procedure TchooseTask_Frm.taskGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  with taskGrid do
  begin
    if (FSelectedType = 'T') AND (GetChildCount(ARow) > 0) then
      SelectedRow := GetFirstChild(ARow);

    ModalResult := mrOk;

  end;
end;

procedure TchooseTask_Frm.taskGridCustomDrawCell(Sender: TObject; ACol,
  ARow: Integer; CellRect: TRect; CellState: TCellState);
var
  s : String;
  LRect : TRect;
  LCanvas : TCanvas;
  bmp : TBitmap;
begin
  with Sender as TNextGrid do
  begin
    if ACol = 2 then
    begin
      LRect := GetButtonRect(CellRect,GetLevel(ARow));
      s := Cells[2,ARow];
      LCanvas := Canvas;
      LCanvas.FillRect(LRect);

      bmp := TBitmap.Create;
      try
        if Cells[3,ARow] = 'T' then
          ImageList16x16.GetBitmap(0,bmp)
        else
          ImageList16x16.GetBitmap(1,bmp);

        if bmp <> nil then
          LCanvas.Draw(LRect.Left, LRect.Top, bmp);

      finally
        bmp.Free;
      end;
    end;
  end;
end;

end.
