unit statisticsChart_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid;

type
  TstatisticsChart_Frm = class(TForm)
    Panel5: TPanel;
    Image1: TImage;
    Chart1: TChart;
    Series1: TPieSeries;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  statisticsChart_Frm: TstatisticsChart_Frm;
  procedure Create_statsticsChart_Frm(aTitle:String;aGrid:TNextGrid);

implementation

{$R *.dfm}

procedure Create_statsticsChart_Frm(aTitle:String;aGrid:TNextGrid);
var
  i : Integer;
  LStr : String;
begin
  if aGrid <> nil then
  begin
    statisticsChart_Frm := TstatisticsChart_Frm.Create(nil);
    try
      with statisticsChart_Frm do
      begin
        Chart1.Title.Caption := aTitle;
        with Chart1.Series[0] do
        begin
          BeginUpdate;
          try
            Clear;
            with aGrid do
            begin
              for i := 0 to RowCount-1 do
              begin
                LStr := Cells[2,i];
                if LStr = '' then
                  LStr := '±‚≈∏';

                Add(Cell[3,i].AsFloat, LStr);
              end;
            end;
          finally
            EndUpdate;
          end;
        end;
        ShowModal;
      end;
    finally
      FreeAndNil(statisticsChart_Frm);
    end;
  end;
end;

end.
