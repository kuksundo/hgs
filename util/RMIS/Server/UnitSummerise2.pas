unit UnitSummerise2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, AdvPanel,
  VclTee.TeeGDIPlus, VCLTee.TeeSurfa, VCLTee.TeeMapSeries,
  VCLTee.TeeWorldSeries, VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeDonut,
  VCLTee.TeeProcs, VCLTee.Chart, VCLTee.GanttCh;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    AdvPanelGroup1: TAdvPanelGroup;
    Panel2: TPanel;
    AdvPanelGroup2: TAdvPanelGroup;
    Splitter1: TSplitter;
    Panel3: TPanel;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    AdvPanelGroup3: TAdvPanelGroup;
    AdvPanelGroup4: TAdvPanelGroup;
    Chart1: TChart;
    Series1: TDonutSeries;
    Chart2: TChart;
    Series2: TWorldSeries;
    Chart3: TChart;
    Chart4: TChart;
    Series3: THorizAreaSeries;
    Series4: TGanttSeries;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
