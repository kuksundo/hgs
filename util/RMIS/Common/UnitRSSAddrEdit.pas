unit UnitRSSAddrEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.ToolWin, Vcl.ImgList,
  Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.ActnMan, Vcl.StdActns, NxColumns, NxColumnClasses, System.RTTI, Generics.Collections,
  UnitRSSAddressClass;

type
  TRSSAddressEditF = class(TForm)
    StatusBar1: TStatusBar;
    OpenDialog1: TOpenDialog;
    ImageList2: TImageList;
    ToolBar2: TToolBar;
    ToolButton7: TToolButton;
    btnAddRow: TToolButton;
    ToolButton13: TToolButton;
    ToolButton12: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton8: TToolButton;
    ToolButton17: TToolButton;
    ToolButton20: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    MainMenu1: TMainMenu;
    Actions1: TMenuItem;
    urnOnAutoSize1: TMenuItem;
    N1: TMenuItem;
    SaveSettingsToINIFile1: TMenuItem;
    LoadSettingsFromINIFile1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Search1: TMenuItem;
    View1: TMenuItem;
    Footer2: TMenuItem;
    Header2: TMenuItem;
    InputLine2: TMenuItem;
    Indicator1: TMenuItem;
    Grid1: TMenuItem;
    N4: TMenuItem;
    ReportView1: TMenuItem;
    SlideView1: TMenuItem;
    Select1: TMenuItem;
    SelectFullRow2: TMenuItem;
    IndicateSelectedCell1: TMenuItem;
    N5: TMenuItem;
    MultiSelect1: TMenuItem;
    ShowSelectedCount1: TMenuItem;
    File1: TMenuItem;
    Open1: TMenuItem;
    ActionList1: TActionList;
    ActionManager1: TActionManager;
    actOpenJSON: TAction;
    actOpenCsv: TAction;
    OpenRSS1: TMenuItem;
    OpenCSV1: TMenuItem;
    FileSaveAs1: TFileSaveAs;
    NextGrid1: TNextGrid;
    procedure FormCreate(Sender: TObject);
    procedure actOpenJSONExecute(Sender: TObject);
    procedure actOpenCsvExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FileSaveAs1Accept(Sender: TObject);
  private
    procedure GetRSSAddressFromJSONFile(AFileName: string);
    procedure MakeColumn4Grid; overload;
    procedure MakeGridFromCsvFile(AFileName: string); overload;
  public
    FRSSAddressInfo: TRSSAddressInfo;
    FRSSAddressFileName: string;
    FNewGubunDic: TDictionary<string,integer>; //<뉴스구분명, NextGrid Row Num>
    procedure InitVar;
    procedure DestroyVar;
  end;

  procedure Create_RSSAddrForm;

var
  RSSAddressEditF: TRSSAddressEditF;

implementation

{$R *.dfm}

//콤마로 분리된 문자를 하나씩 반환한다.
//원본에서는 추출된 문자를 지운다.
function strToken(var S: String; Seperator: Char): String;
var
  I               : Word;
begin
  I:=Pos(Seperator,S);
  if I<>0 then
  begin
    Result:=System.Copy(S,1,I-1);
    System.Delete(S,1,I);
  end else
  begin
    Result:=S;
    S:='';
  end;
end;

procedure Create_RSSAddrForm;
begin
  RSSAddressEditF := TRSSAddressEditF.Create(Application);
  try
    with RSSAddressEditF do
    begin
      ShowModal;
    end;
  finally
    FreeAndNil(RSSAddressEditF);
  end;
end;

procedure TRSSAddressEditF.actOpenCsvExecute(Sender: TObject);
var
  LFileName: string;
begin
  if OpenDialog1.Execute() then
  begin
    LFileName := OpenDialog1.FileName;

    if LFileName <> '' then
    begin
      MakeGridFromCsvFile(LFileName);
    end;
  end;
end;

procedure TRSSAddressEditF.actOpenJSONExecute(Sender: TObject);
var
  LFileName: string;
begin
  if OpenDialog1.Execute() then
  begin
    LFileName := OpenDialog1.FileName;
    if LFileName <> '' then
    begin
      GetRSSAddressFromJSONFile(LFileName);
    end;
  end;
end;

procedure TRSSAddressEditF.DestroyVar;
begin
  FNewGubunDic.Free;
  FRSSAddressInfo.Free;
end;

procedure TRSSAddressEditF.FileSaveAs1Accept(Sender: TObject);
var
  i: integer;
  LRSSAddressItem: TRSSAddressItem;
  LGubun, LPrevGubun: string;
begin
  if FileSaveAs1.Dialog.FileName = '' then
    exit;

  if FileExists(FileSaveAs1.Dialog.FileName)  then
    if MessageDlg(FileSaveAs1.Dialog.FileName + ' file already exist!' + #13#10 + 'Overwrite?' ,
      mtCustom, [mbYES, mbNO], 0) <> mrYES then
      exit;

  FRSSAddressInfo.RSSAddressCollect.Clear;

  for i := 0 to NextGrid1.RowCount - 1 do
  begin
    LRSSAddressItem := FRSSAddressInfo.RSSAddressCollect.Add;

    with NextGrid1, LRSSAddressItem do
    begin
      NewsGubun := CellsByName['Col_2',i];

      if NewsGubun = '' then
        NewsGubun := LPrevGubun;

      RSSDescription := CellsByName['Col_3',i];
      RSSAddress := CellsByName['Col_4',i];
      FetchCount := StrToIntDef(CellsByName['Col_5',i], 0);
      RSSUsed := CellByName['Use', i].AsBoolean;
      LPrevGubun := NewsGubun;
    end;
  end;

  FRSSAddressInfo.SaveToJSONFile(FileSaveAs1.Dialog.FileName);
  FRSSAddressFileName := FileSaveAs1.Dialog.FileName;
end;

procedure TRSSAddressEditF.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TRSSAddressEditF.FormDestroy(Sender: TObject);
begin
  DestroyVar;
end;

procedure TRSSAddressEditF.GetRSSAddressFromJSONFile(AFileName: string);
var
  i, LCol, LRow: integer;
  LGubun: string;
begin
  FRSSAddressInfo.LoadFromJSONFile(AFileName);

  if FRSSAddressInfo.RSSAddressCollect.Count > 0 then
  begin
    MakeColumn4Grid;
    FNewGubunDic.Clear;

    for i := 0 to FRSSAddressInfo.RSSAddressCollect.Count - 1 do
    begin
      LGubun := FRSSAddressInfo.RSSAddressCollect.Items[i].NewsGubun;

      if FNewGubunDic.ContainsKey(LGubun) then
      begin
        NextGrid1.AddChildRow(FNewGubunDic.Items[LGubun], crLast);
        LRow := NextGrid1.LastAddedRow;
        LGubun := '';
      end
      else
      begin
        LRow := NextGrid1.AddRow;
        FNewGubunDic.Add(LGubun, LRow);
      end;

      NextGrid1.CellByName['Use',LRow].AsBoolean := FRSSAddressInfo.RSSAddressCollect.Items[i].RSSUsed;
      NextGrid1.CellsByName['Col_2',LRow] := LGubun;
      NextGrid1.CellsByName['Col_3',LRow] := FRSSAddressInfo.RSSAddressCollect.Items[i].RSSDescription;
      NextGrid1.CellsByName['Col_4',LRow] := FRSSAddressInfo.RSSAddressCollect.Items[i].RSSAddress;
      NextGrid1.CellsByName['Col_5',LRow] := IntToStr(FRSSAddressInfo.RSSAddressCollect.Items[i].FetchCount);
//      NextGrid1.CellsByName['Col_6',LRow] := IntToStr(FRSSAddressInfo.RSSAddressCollect.Items[i].NewsCategory);
    end;
  end;
end;

procedure TRSSAddressEditF.InitVar;
begin
  FRSSAddressInfo := TRSSAddressInfo.Create(Self);
  FNewGubunDic := TDictionary<string,integer>.Create;
  NextGrid1.DoubleBuffered := False;
end;

procedure TRSSAddressEditF.MakeGridFromCsvFile(AFileName: string);
var
  LStrList: TStringList;
  LStr: string;
  LnxTextColumn: TnxTextColumn;
  LnxCheckColumn: TnxCheckBoxColumn;
  LnxComboBoxColumn: TnxComboBoxColumn;
  LnxTreeColumn: TnxTreeColumn;
  LRSSAddressColumnHeaderItem: TRSSAddressColumnHeaderItem;
  LColName: string;
  i,j,k,LRow: integer;
begin
  LRSSAddressColumnHeaderItem := nil;
  LStrList := TStringList.Create;

  try
    LStrList.LoadFromFile(AFileName, TEncoding.Unicode);
    LStr := LStrList.Strings[0];
    i := 0;

    with NextGrid1 do
    begin
      ClearRows;
      Columns.Clear;
      LnxCheckColumn := TnxCheckBoxColumn(Columns.Add(TnxCheckBoxColumn,'Use'));
      LnxCheckColumn.Name := 'Use';
      Columns.Add(TnxIncrementColumn,'No.');

      if LStr <> '' then
      begin
        FRSSAddressInfo.RSSAddressColumnHeaderCollect.Clear;
        LRSSAddressColumnHeaderItem := FRSSAddressInfo.RSSAddressColumnHeaderCollect.Add;
        LRSSAddressColumnHeaderItem.ColumnHeaderData := 'Use';
        LRSSAddressColumnHeaderItem := FRSSAddressInfo.RSSAddressColumnHeaderCollect.Add;
        LRSSAddressColumnHeaderItem.ColumnHeaderData := 'No.';
      end;

      while LStr <> '' do
      begin
        LColName := strToken(LStr, ',');

        if i = 0 then
        begin
          LnxTreeColumn := TnxTreeColumn(Columns.Add(TnxTreeColumn, LColName));
          LnxTreeColumn.Name := 'Col_' + IntToStr(i+2);
        end
        else
        if LStr = '' then
        begin
          LnxComboBoxColumn := TnxComboBoxColumn(Columns.Add(TnxComboBoxColumn, LColName));
          LnxComboBoxColumn.Name := 'Col_' + IntToStr(i+2);
          LnxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
        end
        else
        begin
          LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn, LColName));
          LnxTextColumn.Name := 'Col_' + IntToStr(i+2);
          LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
        end;

        LRSSAddressColumnHeaderItem := FRSSAddressInfo.RSSAddressColumnHeaderCollect.Add;
        LRSSAddressColumnHeaderItem.ColumnHeaderData := LColName;
        inc(i);
      end;//while

      FNewGubunDic.Clear;

      for k := 1 to LStrList.Count - 1 do
      begin
        LStr := LStrList.Strings[k];
        i := 0;

        while LStr <> '' do
        begin
          LColName := strToken(LStr, ',');

          if i = 0 then //뉴스구분 명
          begin
            if FNewGubunDic.ContainsKey(LColName) then
            begin
              AddChildRow(FNewGubunDic.Items[LColName], crLast);
              LRow := LastAddedRow;
              inc(i);
              Continue;
            end
            else
            begin
              LRow := AddRow;
              FNewGubunDic.Add(LColName, LRow);
            end;
          end;

          Cells[i+2,LRow] := LColName;
          inc(i);
        end;//while
      end;
    end;//with
  finally
    LStrList.Free;
  end;
end;

procedure TRSSAddressEditF.MakeColumn4Grid;
var
  i: integer;
  LnxTextColumn: TnxTextColumn;
  LnxCheckColumn: TnxCheckBoxColumn;
  LnxComboBoxColumn: TnxComboBoxColumn;
  LnxTreeColumn: TnxTreeColumn;
  LColName: string;
begin
  with NextGrid1 do
  begin
    ClearRows;
    Columns.Clear;

    for i := 0 to FRSSAddressInfo.RSSAddressColumnHeaderCollect.Count - 1 do
    begin
      LColName := FRSSAddressInfo.RSSAddressColumnHeaderCollect.Items[i].ColumnHeaderData;

      if LColName = 'Use' then
      begin
        LnxCheckColumn := TnxCheckBoxColumn(Columns.Add(TnxCheckBoxColumn,'Use'));
        LnxCheckColumn.Name := 'Use';
      end
      else
      if LColName = 'No.' then
      begin
        Columns.Add(TnxIncrementColumn,'No.');
      end
      else
      if i = 2 then
      begin
        LnxTreeColumn := TnxTreeColumn(Columns.Add(TnxTreeColumn, LColName));
        LnxTreeColumn.Name := 'Col_' + IntToStr(i);
      end
      else
      if i = (FRSSAddressInfo.RSSAddressColumnHeaderCollect.Count - 1) then
      begin
        LnxComboBoxColumn := TnxComboBoxColumn(Columns.Add(TnxComboBoxColumn, LColName));
        LnxComboBoxColumn.Name := 'Col_' + IntToStr(i);
        LnxComboBoxColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
      end
      else
      begin
        LnxTextColumn := TnxTextColumn(Columns.Add(TnxTextColumn, LColName));
        LnxTextColumn.Name := 'Col_' + IntToStr(i);
        LnxTextColumn.Options := [coCanClick,coCanInput,coEditing,coDisableMoving,coEditorAutoSelect,coPublicUsing,coShowTextFitHint];
      end;
    end;
  end;
end;

end.
