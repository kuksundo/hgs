unit UnitSummerise;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, NxCollection,
  Vcl.ExtCtrls, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, Vcl.StdCtrls, VCLTee.Series, VCLTee.TeeBezie,
  VCLTee.TeeURL, VCLTee.TeeExcelSource, IdHttp, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient;

type
  TForm2 = class(TForm)
    Chart1: TChart;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Chart3: TChart;
    NxExpandPanel1: TNxExpandPanel;
    AdvStringGrid1: TAdvStringGrid;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    Series1: TBarSeries;
    Series2: TBarSeries;
    Series3: TBezierSeries;
    TeeExcelSource1: TTeeExcelSource;
    Timer1: TTimer;
    Chart2: TChart;
    BarSeries1: TBarSeries;
    BarSeries2: TBarSeries;
    BezierSeries1: TBezierSeries;
    Series4: TLineSeries;
    Button3: TButton;
    IdHTTP1: TIdHTTP;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure IdHTTP1Redirect(Sender: TObject; var dest: string;
      var NumRedirect: Integer; var Handled: Boolean; var VMethod: string);
  private
    { Private declarations }
  public
    procedure CreateChart(AChart: TChart);
    function getContent(url: String): String;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

//function getContent(url: String): String;
//var
//http : TIdHTTP;
//begin
// http := TIdHTTP.Create(nil);
//   try
//     Result := http.Get(url);
//   finally
//     http.Free;
//   end;
//end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    AdvStringGrid1.LoadFromXLS( OpenDialog1.FileName );
  end;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  i: integer;
begin
  CreateChart(Chart1);
  CreateChart(Chart2);
  CreateChart(Chart3);

  Chart1.Series[0].LegendTitle := '수주 실적 A등급';
  Chart1.Series[1].LegendTitle := '수주 실적 B등급';
  Chart1.Series[2].LegendTitle := '수주 계획';

  Chart2.Series[0].LegendTitle := '매출 확정';
  Chart2.Series[1].LegendTitle := '매출 미확정';
  Chart2.Series[2].LegendTitle := '매출 계획';

  Chart3.Series[0].LegendTitle := '손익 누계';
  Chart3.Series[1].LegendTitle := '손익 실적';
  Chart3.Series[2].LegendTitle := '손익 계획';

  for i := 1 to 12 do
  begin
    Chart1.Series[2].Add(Random(1000));
    Chart2.Series[2].Add(Random(1000));
    Chart3.Series[2].Add(Random(1000));
  end;

  Timer1Timer(nil);
  Timer1.Enabled := True;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  ShowMessage(getContent('http://hhibwp.hhi.co.kr:8000/sap/bc/bsp/sap/zbwxa_bsp/data.xml?infocube=ZKSDSOM01&sap-user=KEAASC0&sap-password=keaasc00&query=ZKA_ZKSDSOM02_D_T_Q206&VAR_NAME_1=ZCALDAY01&VAR_VALUE_EXT_1=20150224'));
end;

procedure TForm2.CreateChart(AChart: TChart);
var
  tmp : TChartSeries;
begin
  AChart.RemoveAllSeries;
//  AChart.Legend.LegendStyle

  tmp := AChart.AddSeries(TBarSeries);
  tmp.Name := AChart.Name + '_S1';
  TBarSeries(tmp).MultiBar := mbStacked;

  tmp := AChart.AddSeries(TBarSeries);
  tmp.Name := AChart.Name + '_S2';
  TBarSeries(tmp).MultiBar := mbStacked;

  tmp := AChart.AddSeries(TLineSeries);
  tmp.Name := AChart.Name + '_S3';
  TLineSeries(tmp).Pointer.Style := psCircle;
  TLineSeries(tmp).Pointer.Visible := True;

end;

function TForm2.getContent(url: String): String;
begin
  Result := IdHTTP1.Get(url);
end;

procedure TForm2.IdHTTP1Redirect(Sender: TObject; var dest: string;
  var NumRedirect: Integer; var Handled: Boolean; var VMethod: string);
begin
  ShowMessage(IdHTTP1.Get(dest));
end;

procedure TForm2.Timer1Timer(Sender: TObject);
var
  i: integer;
begin
  Chart1.Series[0].Clear;
  Chart1.Series[1].Clear;
//  Chart1.Series[2].Clear;
  Chart2.Series[0].Clear;
  Chart2.Series[1].Clear;
//  Chart2.Series[2].Clear;
  Chart3.Series[0].Clear;
  Chart3.Series[1].Clear;
//  Chart3.Series[2].Clear;

  for i := 1 to 12 do
  begin
    Chart1.Series[0].Add( Random(1000), LongMonthNames[i]);
    Chart2.Series[0].Add( Random(1000), LongMonthNames[i]);
    Chart3.Series[0].Add( Random(1000), LongMonthNames[i]);
  end;

  for i := 1 to 12 do
  begin
    Chart1.Series[1].Add( Random(1000));
    Chart2.Series[1].Add( Random(1000));
    Chart3.Series[1].Add( Random(1000));
  end;
end;

end.
