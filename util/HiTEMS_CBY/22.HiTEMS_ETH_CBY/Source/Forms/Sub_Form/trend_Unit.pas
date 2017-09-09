unit trend_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, iComponent,
  iVCLComponent, iCustomComponent, iPlotComponent, iPlot, AdvOfficeStatusBar,
  Vcl.ExtCtrls, NxCollection, testDetail_Unit, Vcl.Menus, iXYPlot;

type
  Ttrend_Frm = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    NxSplitter1: TNxSplitter;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    CheckListBox1: TCheckListBox;
    PopupMenu1: TPopupMenu;
    AddnewXValue1: TMenuItem;
    AddnewYValue1: TMenuItem;
    iPlot1: TiPlot;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure CheckListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure iPlot1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure iPlot1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure AddnewXValue1Click(Sender: TObject);
    procedure AddnewYValue1Click(Sender: TObject);
  private
    { Private declarations }
    FCurrentYaxis, FCurrentChannel: Integer;

    FXaxisIdx,
    FCurrentIdx : Integer;

  public
    { Public declarations }
    FOwner: TtestDetail_Frm;
    procedure Add_new_Channel(aCheckIdx: Integer);
    procedure Delete_Channel(aCheckIdx: Integer);
    procedure Set_trend_Parameters;
  end;

var
  trend_Frm: Ttrend_Frm;

implementation



{$R *.dfm}

procedure Ttrend_Frm.AddnewXValue1Click(Sender: TObject);
var
  li,le : integer;
  lx,ly : Double;
begin
  if FXaxisIdx > -1 then
    CheckListBox1.Checked[FXaxisIdx] := False;

  FXaxisIdx := FCurrentIdx;

  for li := 0 to CheckListBox1.Items.Count-1 do
    CheckListBox1.Checked[li] := False;

  CheckListBox1.Checked[FXaxisIdx] := True;
  with iPlot1 do
  begin
    BeginUpdate;
    try
      RemoveAllChannels;
      RemoveAllYAxes;
    finally
      XAxis[0].Min := 0;
      XAxis[0].Span := 100;
      RefreshLayoutManager;
      EndUpdate;
    end;
  end;
end;

procedure Ttrend_Frm.AddnewYValue1Click(Sender: TObject);
begin
  try
    Add_new_Channel(FCurrentIdx);
    CheckListBox1.Checked[FCurrentIdx] := True;
  except
    Delete_Channel(FCurrentIdx);
  end;
end;

procedure Ttrend_Frm.Add_new_Channel(aCheckIdx: Integer);
var
  li, le: Integer;
  lx,ly : Double;
  lmax : Double;
begin
  with iPlot1 do
  begin
    BeginUpdate;
    try
      FCurrentChannel := AddChannel;
      Channel[FCurrentChannel].TitleText := CheckListBox1.Items.Strings[aCheckIdx];

      FCurrentYaxis := AddYAxis;
      YAxis[FCurrentYaxis].Name := CheckListBox1.Items.Strings[aCheckIdx];
      YAxis[FCurrentYaxis].LabelsFont.Color := clBlack;
      YAxis[FCurrentYaxis].ScaleLinesColor  := clBlack;
      YAxis[FCurrentYaxis].GridLinesVisible := True;

      Channel[FCurrentChannel].YAxisName := CheckListBox1.Items.Strings[aCheckIdx];

      with FOwner.DBAdvGrid1 do
      begin
        for le := 0 to Columns.Count - 1 do
        begin
          if CheckListBox1.Items.Strings[aCheckIdx] = Cells[le, 0] then
          begin
            for li := 1 to RowCount - 1 do
            begin
              if not(Cells[FXaxisIdx+1,li] = '') then
              begin
                if upperCase(Cells[FxaxisIdx+1,0]) = 'DATASAVEDTIME' then
                  lx := StrToDateTime(Cells[1,li])
                else
                  lx := StrToFloat(Cells[FXaxisIdx+1,li])
              end
              else
                lx := 0;

              if not(Cells[le,li] = '') then
                ly := StrToFloat(Cells[le, li])
              else
                ly := 0;

              if (lx > 0) and (ly > 0) then
                Channel[FCurrentChannel].AddXY(lx,ly);
            end;
            Break;
          end;
        end;
      end;
      Channel[FCurrentChannel].XAxis.ZoomToFit;

      lmax := Channel[FCurrentChannel].GetYMax;
      if lmax > 100 then
        lmax := Round(lmax * 1.1)
      else
        lmax := 100;

      YAxis[FCurrentYaxis].min := 0;
      YAxis[FCurrentYaxis].Span := lmax;
    finally
      Invalidate;
      EndUpdate;
    end;
  end;
end;

procedure Ttrend_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  trend_Frm := nil;
end;

procedure Ttrend_Frm.FormCreate(Sender: TObject);
begin
  iPlot1.RemoveAllChannels;
  iPlot1.RemoveAllYAxes;
  FXaxisIdx := -1;
end;

procedure Ttrend_Frm.iPlot1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  li : integer;
  lCheckBox : TCheckListBox;
begin
  if Source is TCheckListBox then
  begin
    lCheckBox := TCheckListBox(Source);
    FCurrentIdx := lCheckBox.ItemIndex;

    if FXaxisIdx > -1 then
      AddnewYValue1.Enabled := True
    else
      AddnewYValue1.Enabled := False;

    PopupMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
  end;
end;

procedure Ttrend_Frm.iPlot1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Source is TCheckListBox then
    Accept := True
  else
    Accept := False;

end;

procedure Ttrend_Frm.CheckListBox1ClickCheck(Sender: TObject);
var
  li: Integer;
begin
  if (Sender is TCheckListBox) then
  begin
    PopupMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
  end;
end;

procedure Ttrend_Frm.CheckListBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    with Sender as TCheckListBox do
    begin
      if ItemAtPos(Point(X,Y),True) >= 0 then
      begin
        FCurrentIdx := CheckListBox1.ItemIndex;
        BeginDrag(False);

      end;
    end;
  end;
end;

procedure Ttrend_Frm.Delete_Channel(aCheckIdx: Integer);
var
  lkey : String;
  li: Integer;
begin
  lKey := CheckListBox1.Items.Strings[aCheckIdx];

  with iPlot1 do
  begin
    for li := 0 to ChannelCount-1 do
    begin
      if SameText(Channel[li].TitleText,lKey) then
      begin
        DeleteChannel(li);
        DeleteYAxis(li);
        Break;
      end;
    end;
  end;
end;

procedure Ttrend_Frm.Set_trend_Parameters;
var
  li: Integer;
begin
  if Assigned(FOwner) then
  begin
    CheckListBox1.Items.Clear;
    with FOwner do
    begin
      with DBAdvGrid1 do
      begin
        BeginUpdate;
        try
          for li := 1 to Columns.Count - 1 do
            CheckListBox1.Items.Add(Cells[li, 0]);

        finally
          EndUpdate;
        end;
      end;
    end;
  end;
end;

end.
