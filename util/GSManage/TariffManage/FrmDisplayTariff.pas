unit FrmDisplayTariff;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  SynCommons;

type
  TSimpleGraphicCell = class(TInterfacedPersistent, ICellGraphic)
    procedure Draw(Canvas: TCanvas; R: TRect; Col, Row: integer; Selected: boolean; Grid: TAdvStringGrid);
    function CellWidth: integer;
    function CellHeight: integer;
    function IsBackground: boolean;
  end;

  TDisplayTariffF = class(TForm)
    TariffGrid: TAdvStringGrid;
    procedure TariffGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure TariffGridGetWordWrap(Sender: TObject; ACol, ARow: Integer;
      var WordWrap: Boolean);
    procedure TariffGridGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure InitGrid(AGrid: TAdvStringGrid);
  end;

procedure DisplayTariff(ADoc: variant);

var
  DisplayTariffF: TDisplayTariffF;

implementation

uses UnitGSTriffData, UnitStringUtil, CommonData;

{$R *.dfm}

procedure DisplayTariff(ADoc: variant);
var
  LDisplayTariffF: TDisplayTariffF;
  LDocData: TDocVariantData;
  LUtf8: RawUTF8;
  LVar: variant;
  R,C, i: integer;
  LStr: string;
begin
  LDisplayTariffF := TDisplayTariffF.Create(nil);
  try
    LUtf8 := ADoc;
    LDocData.InitJSON(LUtf8, [dvoJSONObjectParseWithinString]);

    with LDisplayTariffF do
    begin
      InitGrid(TariffGrid);

      for i := 0 to LDocData.Count - 1 do
      begin
        LVar := _JSON(LDocData.Value[i]);

        if TGSWorkType(LVar.GSWorkType) = gswtTravelAndWait then
          C := 7
        else
        begin
          if TGSWorkDayType(LVar.GSWorkDayType) = gswdtNormalDay then
          begin
            case TGSWorkHourType(LVar.GSWorkHourType) of
              gswhtFullDay: C := 1;
              gswhtHalfDay: C := 2;
              gswhtOverTime:C := 3;
            end;
          end
          else
          if TGSWorkDayType(LVar.GSWorkDayType) = gswdtHoliDay then
          begin
            case TGSWorkHourType(LVar.GSWorkHourType) of
              gswhtFullDay: C := 4;
              gswhtHalfDay: C := 5;
              gswhtOverTime:C := 6;
            end;
          end;
        end;

        if (TGSEngineerType(LVar.GSEngineerType) <> gsetNull) and
          (TGSEngineerType(LVar.GSEngineerType) <> gsetFinal) then
          R := LVar.GSEngineerType + 1;

        TariffGrid.Cells[C,R] := AddThousandSeparator(IntToStr(LVar.GSServiceRate),',');
      end;

      LStr := CurrencyKind2String(TCurrencyKind(LVar.CurrencyKind));
      Caption := Caption + ' (' + LStr + ')';
      if ShowModal = mrOK then
      begin
      end;
    end;
  finally
    LDisplayTariffF.Free;
  end;
end;

{ TSimpleGraphicCell }

function TSimpleGraphicCell.CellHeight: integer;
begin
  Result := 0; // by returning zero, this graphic cell has no minimum cell width requirement
end;

function TSimpleGraphicCell.CellWidth: integer;
begin
  Result := 0; // by returning zero, this graphic cell has no minimum cell height requirement
end;

procedure TSimpleGraphicCell.Draw(Canvas: TCanvas; R: TRect; Col, Row: integer;
  Selected: boolean; Grid: TAdvStringGrid);
begin
  Canvas.Pen.Color := clBlack;
  Canvas.Pen.Width := 2;
  Canvas.MoveTo(R.Left, R.Top);
  Canvas.LineTo(R.Right, R.Bottom);
end;

function TSimpleGraphicCell.IsBackground: boolean;
begin
  Result := true;
end;

procedure TDisplayTariffF.FormCreate(Sender: TObject);
var
  sg: TSimpleGraphicCell;
begin
  sg := TSimpleGraphicCell.Create;
  TariffGrid.AddInterfacedCell(0, 0, sg);
end;

procedure TDisplayTariffF.InitGrid(AGrid: TAdvStringGrid);
begin
  AGrid.MergeCells(0,0,1,2);
  AGrid.MergeCells(1,0,3,1);
  AGrid.MergeCells(4,0,3,1);
  AGrid.MergeCells(7,0,1,2);
  AGrid.ColWidths[0] := 200;
  AGrid.ColWidths[7] := 120;

  AGrid.Cells[0,2] := 'Technician';
  AGrid.Cells[0,3] := 'Service Engineer';
  AGrid.Cells[0,4] := 'Service Engineer(Elec.)';
  AGrid.Cells[0,5] := 'Service Engineer(AMS, PMS)';
  AGrid.Cells[0,6] := 'Superintendent';

  AGrid.Cells[1,0] := 'Weekdays (Normal Hours)';
  AGrid.Cells[1,1] := 'Full Day' + #13#10 + '(4~8 hrs)';
  AGrid.Cells[2,1] := 'Half a Day' + #13#10 + '(0~4 hrs)';
  AGrid.Cells[3,1] := 'Overtime A' + #13#10 + '(Hourly)';

  AGrid.Cells[4,0] := 'Weekend & Local Holidays';
  AGrid.Cells[4,1] := 'Full Day' + #13#10 + '(4~8 hrs)';
  AGrid.Cells[5,1] := 'Half a Day' + #13#10 + '(0~4 hrs)';
  AGrid.Cells[6,1] := 'Overtime B' + #13#10 + '(Hourly)';

  AGrid.Cells[7,0] := #13#10 + 'Waiting & ' + #13#10 + 'Travelling Time' + #13#10 + '(Hourly Rate)';
end;

procedure TDisplayTariffF.TariffGridGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  VAlign := vtaCenter;
  HAlign := taCenter;
end;

procedure TDisplayTariffF.TariffGridGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  AFont.Size := 10;
end;

procedure TDisplayTariffF.TariffGridGetWordWrap(Sender: TObject; ACol,
  ARow: Integer; var WordWrap: Boolean);
begin
  if ARow = 0 then
  begin
    if ACol = 7 then
      WordWrap := True;
  end
  else
  if ARow = 1 then
  begin
    if (ACol = 1) or (ACol = 2) or (ACol = 3) or (ACol = 4) or (ACol = 5)
      or (ACol = 6) then
    begin
      WordWrap := True;
    end;
  end;
end;

end.
