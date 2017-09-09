unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvOfficeStatusBar, Menus, ExtCtrls, NxCollection, iComponent,
  iVCLComponent, iCustomComponent, iPlotComponent, iPlot, Grids, AdvObj,
  BaseGrid, AdvGrid, StdCtrls, NxColumnClasses, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, iXYPlot;

type
  TMain_Frm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    NxHeaderPanel1: TNxHeaderPanel;
    NxFlipPanel1: TNxFlipPanel;
    NxSplitter1: TNxSplitter;
    AdvStringGrid1: TAdvStringGrid;
    Timer1: TTimer;
    NxPanel1: TNxPanel;
    NxPanel2: TNxPanel;
    ValuesGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    Button1: TButton;
    NxCheckBoxColumn1: TNxCheckBoxColumn;
    NxNumberColumn1: TNxNumberColumn;
    iPlot1: TiPlot;
    NxTextColumn3: TNxTextColumn;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ValuesGridChange(Sender: TObject; ACol, ARow: Integer);
    procedure iPlot1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CurrentChannel : integer;
    CurrentYaxis : integer;
    FTestCount : integer;
    FZoomFirst : Boolean;

    procedure Initialize_of_Tracker;
    procedure Drawing_Graph_by_Mesuring_Values;
    procedure Masuring_of_Current_Location;

  end;

var
  Main_Frm: TMain_Frm;

implementation

{$R *.dfm}

{ TForm10 }

procedure TMain_Frm.Button1Click(Sender: TObject);
begin
  ValuesGrid.AddRow(1);
  ValuesGRid.Cells[2,ValuesGrid.RowCount-1] := AdvStringGrid1.Cells[ValuesGrid.RowCount+1,0];
  ValuesGRid.Cells[3,ValuesGrid.RowCount-1] := AdvStringGrid1.Cells[ValuesGrid.RowCount+1,0]+' Description';

  CurrentChannel := iPlot1.AddChannel;
  iPlot1.Channel[CurrentChannel].Name      := AdvStringGrid1.Cells[ValuesGrid.RowCount+1,0];
  iPlot1.Channel[CurrentChannel].TitleText := AdvStringGrid1.Cells[ValuesGrid.RowCount+1,0];

  CurrentYaxis := iPlot1.AddYAxis;
  iPlot1.YAxis[CurrentYaxis].Name := AdvStringGrid1.Cells[ValuesGrid.RowCount+1,0];
  iPlot1.Channel[CurrentChannel].YAxisName := AdvStringGrid1.Cells[ValuesGrid.RowCount+1,0];
//  iPlot1.YAxis[CurrentYaxis].TrackingEnabled := True;
//  iPlot1.Channel[CurrentChannel].YAxis.ZoomToFit;

  if iPlot1.ChannelCount = 1 then
  begin
    iPlot1.DataCursor[CurrentChannel].Visible := True;
    iPlot1.DataCursor[CurrentChannel].ChannelName := iPlot1.Channel[CurrentChannel].Name;
//    iPlot1.DataCursor[CurrentChannel].ChannelAllowAll := True;
    iPlot1.DataCursor[CurrentChannel].UseChannelColor := False;
    iPlot1.DataCursor[CurrentChannel].HintShow := false;
  end;

  Timer1.Enabled := True;
  FZoomFirst := True;


end;

procedure TMain_Frm.Drawing_Graph_by_Mesuring_Values;
var
  li,lr : integer;
  LValue : Double;
  LStr : integer;

begin
  for li := 0 to iPlot1.ChannelCount -1 do
  begin
    for lr := 0 to ValuesGrid.RowCount-1 do
    begin
      if ValuesGrid.Cells[2,lr] = iPlot1.Channel[li].Name then
      begin
        LValue := StrToFloat(ValuesGrid.Cells[4,lr]);
        //iPlot1.Channel[li].AddXY(Now,AValue);
//        iPlot1.Channel[li].AddYElapsedTime(LValue);
//        iPlot1.Channel[li].YAxis.ZoomToFit;

      end;
    end;
  end;
end;

procedure TMain_Frm.FormCreate(Sender: TObject);
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  FTestCount := 0;
  iPlot1.RemoveAllChannels;
  iPlot1.RemoveAllYAxes;
  AdvStringGrid1.LoadFromCSV('..\..\..\DATA\sampleCSV.CSV');
end;

procedure TMain_Frm.Initialize_of_Tracker;
begin
  CurrentChannel := -1;
end;

procedure TMain_Frm.iPlot1Click(Sender: TObject);
begin
//  iPlot1.XAxis[0].TrackingEnabled := True;
end;

procedure TMain_Frm.Masuring_of_Current_Location;
var
  li,lr : integer;
  LValue : Double;
  LStr : integer;

begin
  for li := 0 to iPlot1.ChannelCount -1 do
  begin
    for lr := 0 to ValuesGrid.RowCount-1 do
    begin
      if ValuesGrid.Cells[2,lr] = iPlot1.Channel[li].Name then
      begin
        //iPlot1.Refresh;
        //iPlot1.DataCursor[0].ChannelName := iPlot1.Channel[li].Name;
        ValuesGrid.Cells[5,lr] := iPlot1.Channel[li].DataCursorYText;
      end;
    end;
  end;
end;

procedure TMain_Frm.Timer1Timer(Sender: TObject);
var
  li, lr : integer;
  LValue: Double;
begin

  if not(FTestCount > AdvStringGrid1.RowCount) then
    FTestCount := FTestCount+1
  else
    FTestCount := 1;

  for li := 2 to AdvStringGrid1.ColCount-1 do
  begin
    for lr := 0 to ValuesGrid.RowCount-1 do
    begin
      if AdvStringGrid1.Cells[li,0] = ValuesGrid.Cells[2,lr] then
      begin
        ValuesGrid.Cells[4,lr] := AdvStringGrid1.Cells[li,FTestCount];
        LValue := StrToFloat(AdvStringGrid1.Cells[li,FTestCount]);
        //Drawing_Graph_by_Mesuring_Values(LValue);
        Break;
      end;
    end;
  end;
  Masuring_of_Current_Location;
end;

procedure TMain_Frm.ValuesGridChange(Sender: TObject; ACol, ARow: Integer);
begin
  Drawing_Graph_by_Mesuring_Values;
end;

end.
