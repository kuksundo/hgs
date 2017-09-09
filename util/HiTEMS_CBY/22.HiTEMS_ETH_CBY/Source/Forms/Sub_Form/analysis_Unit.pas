unit analysis_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,Ora,DB,iPlotAxis,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, iComponent,
  iVCLComponent, iCustomComponent, iPlotComponent, iPlot, AdvOfficeStatusBar,
  Vcl.ExtCtrls, NxCollection, testDetail_Unit, Vcl.Menus, iXYPlot;

type
  Tanalysis_Frm = class(TForm)
    NxHeaderPanel1: TNxHeaderPanel;
    NxSplitter1: TNxSplitter;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    CheckListBox1: TCheckListBox;
    PopupMenu1: TPopupMenu;
    AddnewXValue1: TMenuItem;
    AddnewYValue1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    iPlot1: TiXYPlot;
    Addexist1: TMenuItem;
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
    FProjNo : String;

    procedure Add_new_Channel(aCheckIdx: Integer);
    procedure Delete_Channel(aCheckIdx: Integer);
    procedure Set_trend_Parameters;
    function Get_DataType(aFieldName:String):String;
  end;

var
  analysis_Frm: Tanalysis_Frm;

implementation
uses
  DataModule_Unit;



{$R *.dfm}

procedure Tanalysis_Frm.AddnewXValue1Click(Sender: TObject);
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
  label1.Caption := 'X-Axis : '+ CheckListBox1.Items.Strings[FXaxisIdx];
  with iPlot1 do
  begin
    BeginUpdate;
    try
      RemoveAllChannels;
      RemoveAllYAxes;
    finally
      XAxis[0].Min := 0;
      XAxis[0].Span := 100;
      Refresh;
      EndUpdate;
    end;
  end;
end;

procedure Tanalysis_Frm.AddnewYValue1Click(Sender: TObject);
begin
  try
    if CheckListBox1.Checked[FCurrentIdx] = False then
    begin
      Add_new_Channel(FCurrentIdx);
      CheckListBox1.Checked[FCurrentIdx] := True;
    end;
  except
    Delete_Channel(FCurrentIdx);
  end;
end;

procedure Tanalysis_Frm.Add_new_Channel(aCheckIdx: Integer);
var
  li, le: Integer;
  lx,ly : Double;
  lmax : Double;
  lColumnNmX,
  lColumnNmY,
  lDataTypeX,
  lDataTypeY : String;
  lstr : String;
  ltype : TFieldType;
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

      with FOwner.OraDataSource1.DataSet do
      begin
        BeginUpdate;
        try
          // X 축 값
          lColumnNmX := Fields[FXaxisIdx].FieldName;
          ltype := Fields[FXaxisIdx].DataType;

          if ltype = ftDateTime then
            iPlot1.XAxis[0].LabelsFormatStyle := iptfDateTime
          else
            iPlot1.XAxis[0].LabelsFormatStyle := iptfValue;


          // Y 축 값
          lColumnNmY := Fields[aCheckIdx].FieldName;

          First;
          for le := 0 to RecordCount-1 do
          begin
            try
              lx := FieldByName(lColumnNmX).AsFloat;
            except
              lx := 0;
            end;

            try
              ly := FieldByName(lColumnNmY).AsFloat;
            except
              ly := 0;
            end;

            if (lx > 0) and (ly > 0) then
              Channel[FCurrentChannel].AddXY(lx,ly);

            Next;
          end;
        finally
          EndUpdate;
        end;
      end;
    finally
      Channel[FCurrentChannel].XAxis.ZoomToFit;

      lmax := Channel[FCurrentChannel].GetYMax;
      if lmax > 100 then
        lmax := Round(lmax * 1.1)
      else
        lmax := 100;

      YAxis[FCurrentYaxis].min := 0;
      YAxis[FCurrentYaxis].Span := lmax;

      Invalidate;
      EndUpdate;
    end;
  end;
end;

procedure Tanalysis_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  analysis_Frm := nil;
end;

procedure Tanalysis_Frm.FormCreate(Sender: TObject);
begin
  iPlot1.RemoveAllChannels;
  iPlot1.RemoveAllYAxes;
  FXaxisIdx := -1;
end;

function Tanalysis_Frm.Get_DataType(aFieldName: String): String;
var
  OraQuery: TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select Data_Type from HIMSEN_SS_META_V ' +
              'where PROJNO = '''+FProjNo+''' ' +
              'and Column_Name = '''+aFieldName+''' ');
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('DATA_TYPE').AsString
      else
        Result := '';
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure Tanalysis_Frm.iPlot1DragDrop(Sender, Source: TObject; X, Y: Integer);
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

procedure Tanalysis_Frm.iPlot1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Source is TCheckListBox then
    Accept := True
  else
    Accept := False;

end;

procedure Tanalysis_Frm.CheckListBox1ClickCheck(Sender: TObject);
var
  li: Integer;
begin
  if (Sender is TCheckListBox) then
  begin
    if CheckListBox1.Checked[CheckListBox1.ItemIndex] = True then
      PopupMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y)
    else
    begin
      li := Pos(CheckListBox1.Items.Strings[CheckListBox1.ItemIndex],label1.caption);

      if li > 0 then
      begin
        iPlot1.RemoveAllChannels;
        iPlot1.RemoveAllYAxes;
        FXaxisIdx := -1;
        for li := 0 to CheckListBox1.Items.Count-1 do
          CheckListBox1.Checked[li] := False;

        label1.Caption := 'X-Axis : ';
      end
      else
        Delete_Channel(CheckListBox1.ItemIndex);
    end;
  end;
end;

procedure Tanalysis_Frm.CheckListBox1MouseDown(Sender: TObject;
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

procedure Tanalysis_Frm.Delete_Channel(aCheckIdx: Integer);
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

procedure Tanalysis_Frm.Set_trend_Parameters;
var
  li: Integer;
begin
  if Assigned(FOwner) then
  begin
    CheckListBox1.Items.Clear;
    with FOwner do
    begin
    end;
  end;
end;

end.
