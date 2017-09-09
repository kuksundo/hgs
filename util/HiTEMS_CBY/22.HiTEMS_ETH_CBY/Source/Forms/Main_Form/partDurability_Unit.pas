unit partDurability_Unit;

interface

uses
  Data.DBXJSon,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothPageSlider, AdvSmoothListBox,
  Vcl.StdCtrls, NxCollection, GradientLabel, Vcl.ExtCtrls, AdvSmoothPanel,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, NxColumnClasses,
  NxColumns, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, ThumbnailList, NxEdit,
  Vcl.ComCtrls, AdvDateTimePicker, clisted, Vcl.ImgList, AdvGlowButton,
  Vcl.Menus, AdvMenus, JvBackgrounds, Vcl.Imaging.pngimage, Ora, TreeList,
  AdvSmoothTileList, AdvSmoothTileListImageVisualizer,
  AdvSmoothTileListHTMLVisualizer, AdvGDIPicture, Vcl.Imaging.jpeg,
  GDIPPictureContainer, AdvGroupBox, AdvOfficeButtons, DBAdvGrid, Data.DB,
  MemDS, DBAccess, AdvPageControl, Vcl.ExtDlgs, Bde.DBTables;
type
  TSelectedEngine = Record
    ProjNo,
    EngType,
    AlignType : String;
    NumofCyl : integer;
  end;

type
  TselectedPartInfo = Record
    ROOTNO,
    PCODE : Double;
    PartName : String;
End;


type
  TnewDataInfo = Record
    RECNO,
    PRECNO : DOUBLE;
    PROJNO : STRING;
    ROOTNO : DOUBLE;
    PCODE : DOUBLE;
    HIMSENPARTID : DOUBLE;
    MAKER : STRING;
    PTYPE : STRING;
    PSER : STRING;
    WORKER_HHI_ID : STRING;
    WORKER_HHI_NM : STRING;
    WORKER_GSM_ID : STRING;
    WORKER_GSM_NM : STRING;
    ENGRUNHOUR : DOUBLE;
    MOUNTED : TDATETIME;
    DESCRIPTION : STRING;
    PARTNAME : STRING;
  end;

type
  TpartDurability_Frm = class(TForm)
    ImageList1: TImageList;
    AdvPopupMenu1: TAdvPopupMenu;
    N1: TMenuItem;
    JvBackground1: TJvBackground;
    AdvSmoothPanel1: TAdvSmoothPanel;
    EngineListBox: TAdvSmoothListBox;
    NxHeaderPanel1: TNxHeaderPanel;
    NxSplitter1: TNxSplitter;
    AdvSmoothTileListHTMLVisualizer1: TAdvSmoothTileListHTMLVisualizer;
    Image1: TImage;
    GDIPPictureContainer1: TGDIPPictureContainer;
    Panel2: TPanel;
    Button6: TButton;
    NxHeaderPanel2: TNxHeaderPanel;
    detailGrid: TAdvStringGrid;
    NxHeaderPanel3: TNxHeaderPanel;
    topGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    Panel3: TPanel;
    Button1: TButton;
    NxHeaderPanel4: TNxHeaderPanel;
    childGrid: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    Panel4: TPanel;
    Button2: TButton;
    showType: TAdvOfficeRadioGroup;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    TileList: TAdvSmoothTileList;
    NxTextColumn8: TNxTextColumn;
    AdvMenuStyler1: TAdvMenuStyler;
    N2: TMenuItem;
    SavePictureDialog1: TSavePictureDialog;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button7: TButton;
    procedure FormCreate(Sender: TObject);
    procedure EngineListBoxItemSelected(Sender: TObject; itemindex: Integer);
    procedure topGridDblClick(Sender: TObject);
    procedure topGridSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure Button2Click(Sender: TObject);
    procedure TileListPageChanged(Sender: TObject; PageIndex: Integer);
    procedure childGridDblClick(Sender: TObject);
    procedure TileListTileClick(Sender: TObject; Tile: TAdvSmoothTile;
      State: TTileState);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure detailGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure showTypeClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    FSelectedEngine : TSelectedEngine;
    FselectedPartInfo : TselectedPartInfo;
    FnewDataInfo : TnewDataInfo;
    FCurrentTile : TAdvSmoothTile;
  public
    { Public declarations }

    // 완료된 작업들...
    function Set_Engine_List_Box : Boolean;
    procedure Set_selected_engine_Info(aProjNo:String);

    procedure Show_Top_Durability_Items(aProjNo:String);
    procedure Show_Child_Durability_Items(aRevNo:String);
    procedure Show_Detail_Info(aRevNo:String);
    procedure Get_Image_List(aRevNo:String);
    procedure Set_Images(aImgNo:Integer);

    function Set_Completed(aRevNo:String) : Boolean;
    function Delete_Item(aRevNo:String) : Boolean;
  end;

var
  partDurability_Frm: TpartDurability_Frm;

implementation
uses
  imgViewer_Unit,
  addDurability_Unit,
  CommonUtil_Unit,
  HiTEMS_ETH_CONST,
  DataModule_Unit;

{$R *.dfm}

{ TnewMounted_Frm }



{ TnewMounted_Frm }


procedure TpartDurability_Frm.Button1Click(Sender: TObject);
var
  lRevNo : String;
  lPartName : String;
begin
  with topGrid do
  begin
    BeginUpdate;
    try
      if SelectedRow > -1 then
      begin
        lPartName := Cells[1,SelectedRow];

        If MessageDlg('['+lPartName +']에 대한 내구성 관리를 종료 하시겠습니까?'+#13+
                      '종료된 시험은 복구할 수 없습니다'
          , mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
        begin
          lRevNo := Cells[2,SelectedRow];
          if Set_Completed(lRevNo) = True then
            ShowMessage('완료처리 성공!')
          else
            ShowMessage('완료처리 실패!')
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TpartDurability_Frm.Button2Click(Sender: TObject);
var
  lPartName,
  lRecNo,
  lRevNo : String;
  li : integer;
begin
  showType.ItemIndex := 0;

  if topGrid.SelectedRow > -1 then
  begin
    lRecNo := topGrid.Cells[3,topGrid.SelectedRow];
    lRevNo := topGrid.Cells[2,topGrid.SelectedRow];
    lPartName := topGrid.Cells[1,topGrid.SelectedRow];

    li := POS('/',lPartName);
    lPartName := Copy(lPartName,li+2,Length(lPartName)-li);

    if Create_child_durability_Item(lRecNo,lRevNo,lPartName) = True then // 0 : 최초등록
    begin
      Show_Child_Durability_Items(lRevNo);

    end;
  end;
end;

procedure TpartDurability_Frm.Button3Click(Sender: TObject);
begin
  if childGrid.SelectedRow > -1 then
  begin
    If MessageDlg('한번 삭제된 정보는 복구할 수 없습니다. 계속 진행 하시겠습니까?'
      , mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
    begin
      Delete_Item(childGrid.Cells[5,childGrid.SelectedRow]);
      childGrid.DeleteRow(childGrid.SelectedRow);
    end;
  end;
end;

procedure TpartDurability_Frm.Button4Click(Sender: TObject);
var
  lRevNo : String;
  lIdx : Integer;
  li : integer;
begin
  with childGrid do
  begin
    if SelectedRow > -1 then
    begin
      lRevNo := Cells[5,SelectedRow];
      if Update_Durability_Items(lRevNo) = True then
      begin
        lidx := EngineListBox.SelectedItemIndex;

        Show_Top_Durability_Items(EngineListBox.Items[lidx].Hint);
        if topGrid.RowCount > 0 then
        begin
          TopGrid.SelectedRow := 0;
          Show_Child_Durability_Items(topGrid.Cells[2,topGrid.SelectedRow]);
        end
        else
        begin
          TileList.Tiles.Clear;
          childGrid.ClearRows;
          for li := 0 to detailGrid.RowCount-1 do
            detailGrid.Cells[1,li+1] := '';
        end;
      end;
    end
    else
      ShowMessage('선택된 행이 없습니다.');
  end;
end;

procedure TpartDurability_Frm.Button5Click(Sender: TObject);
begin
  if not(childGrid.RowCount > 0) then
  begin
    if topGrid.SelectedRow > -1 then
    begin
      If MessageDlg('한번 삭제된 정보는 복구할 수 없습니다. 계속 진행 하시겠습니까?'
        , mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
      begin
        Delete_Item(topGrid.Cells[2,topGrid.SelectedRow]);
        topGrid.DeleteRow(topGrid.SelectedRow);
      end;
    end;
  end
  else
    ShowMessage('하위 아이템이 존재 합니다!');
end;

procedure TpartDurability_Frm.Button6Click(Sender: TObject);
begin
  Close;
end;

procedure TpartDurability_Frm.Button7Click(Sender: TObject);
var
  lRevNo : String;
  lIdx : Integer;
  li : integer;
begin
  with topGrid do
  begin
    if SelectedRow > -1 then
    begin
      lRevNo := topGrid.Cells[2,SelectedRow];
      if Update_Durability_Items(lRevNo) = True then
      begin
        lidx := EngineListBox.SelectedItemIndex;

        Show_Top_Durability_Items(EngineListBox.Items[lidx].Hint);
        if topGrid.RowCount > 0 then
        begin
          TopGrid.SelectedRow := 0;
          Show_Child_Durability_Items(topGrid.Cells[2,topGrid.SelectedRow]);
        end
        else
        begin
          TileList.Tiles.Clear;
          childGrid.ClearRows;
          for li := 0 to detailGrid.RowCount-1 do
            detailGrid.Cells[1,li+1] := '';
        end;
      end;
    end
    else
      ShowMessage('선택된 행이 없습니다.');
  end;
end;

procedure TpartDurability_Frm.childGridDblClick(Sender: TObject);
var
  lRevNo : String;
begin
  lRevNo := childGrid.Cells[5,childGrid.SelectedRow];
  detailGrid.Cells[0,7] := '경과시간';
  if not(lRevNo = '') then
  begin
    Show_Detail_Info(lRevNo);
  end;
end;

function TpartDurability_Frm.Delete_Item(aRevNo: String): Boolean;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete From HIMSEN_DURABILITY_IMAGES ' +
            'where REVNO = '+aRevNo);
    ExecSQL;
  end;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.clear;
    SQL.Add('Delete From HIMSEN_DURABILITY_DESC ' +
            'where REVNO = '+aRevNo);
    ExecSQL;
  end;
end;

procedure TpartDurability_Frm.detailGridGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ACol = 0 then
    HAlign := taCenter;
  if ARow = 0 then
    HAlign := taCenter;



end;

procedure TpartDurability_Frm.EngineListBoxItemSelected(Sender: TObject;
  itemindex: Integer);
var
  li : integer;
  lNode : TTreeNode;
begin
  Set_selected_engine_Info(EngineListBox.Items[itemindex].Hint);

  Show_Top_Durability_Items(EngineListBox.Items[itemindex].Hint);

  if topGrid.RowCount > 0 then
  begin
    TopGrid.SelectedRow := 0;
    Show_Child_Durability_Items(topGrid.Cells[2,topGrid.SelectedRow]);
  end
  else
  begin
    TileList.Tiles.Clear;
    childGrid.ClearRows;
    for li := 0 to detailGrid.RowCount-1 do
      detailGrid.Cells[1,li+1] := '';
  end;
end;

procedure TpartDurability_Frm.FormCreate(Sender: TObject);
var
  li : integer;
  lNode : TTreeNode;
begin
  topGrid.DoubleBuffered := False;
  childGrid.DoubleBuffered := False;

  //엔진 리스트박스 채우기
  if Set_Engine_List_Box = True then
  begin
    engineListBox.SelectedItemIndex := 0;
    Set_selected_engine_Info(EngineListBox.Items[0].Hint);
    Show_Top_Durability_Items(EngineListBox.Items[0].Hint);

    if topGrid.RowCount > 0 then
    begin
      TopGrid.SelectedRow := 0;
      Show_Child_Durability_Items(topGrid.Cells[2,topGrid.SelectedRow]);
    end;
  end;
end;


procedure TpartDurability_Frm.FormResize(Sender: TObject);
begin
  Image1.Invalidate;
end;

procedure TpartDurability_Frm.Get_Image_List(aRevNo: String);
var
  li: Integer;
  tmpBlob : TBlobStream;
  LMS : TMemoryStream;
begin
  with GDIPPictureContainer1.Items do
  begin
    BeginUpdate;
    Clear;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_DURABILITY_IMAGES ' +
                'where REVNO = '+aRevNo+' order by IMGNO');
        Open;

        if not(RecordCount = 0) then
        begin
          for li := 0 to RecordCount-1 do
          begin
            if FieldByName('IMAGES').IsBlob then
            begin
              LMS := TMemoryStream.Create;
              try
                (FieldByName('IMAGES') as TBlobField).SaveToStream(LMS);
                add;
                Items[Count-1].Name := FieldByName('IMGNAME').AsString;
                Items[Count-1].Picture.LoadFromStream(LMS);
              finally
                FreeAndNil(LMS);
              end;
            end;
            Next;
          end;
        end;
      end;
    finally
      if Count > 0 then
      begin
        with TileList.Tiles do
        begin
          BeginUpdate;
          try
            Clear;
            for li := 0 to GDIPPictureContainer1.Items.Count-1 do
              Add;

            Set_Images(0);
            TileList.PageIndex := 0;
          finally
            EndUpdate;
          end;
        end;
      end
      else
        TileList.Tiles.Clear;

      EndUpdate;
    end;
  end;
end;

procedure TpartDurability_Frm.N1Click(Sender: TObject);
var
  LForm : TimgViewer_Frm;
begin
  Create_Image_Browser(GDIPPictureContainer1,FCurrentTile.TileList.PageIndex);
end;

procedure TpartDurability_Frm.N2Click(Sender: TObject);
var
  lIndex : Integer;
  ImgName : String;
begin
  if FCurrentTile.Content.Image <> nil then
  begin
    lIndex := FcurrentTile.Index;
    ImgName := GDIPPictureContainer1.Items[lIndex].Name;
    SavePictureDialog1.FileName := ImgName;
    if SavePictureDialog1.Execute then
    begin
      GDIPPictureContainer1.Items[lIndex].Picture.SaveToFile(SavePictureDialog1.FileName);
    end;
  end;
end;

function TpartDurability_Frm.Set_Completed(aRevNo: String) : Boolean;
begin
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Update HIMSEN_DURABILITY_DESC SET ' +
              'STATUS = 1, MODID = :param1, MODDATE = :param2 ' +
              'where REVNO = '+aRevNo+' '+
              'or PARENTREV = '+aRevNo);
      ParamByName('param1').AsString := CurrentUsers;
      ParamByName('param2').AsDateTime := Now;
      ExecSQL;
      Result := True;
    end;
  except
    Result := False;
  end;
end;

function TpartDurability_Frm.Set_Engine_List_Box: Boolean;
var
  LCaption : String;
begin
  Result := False;
  EngineListBox.Items.Clear;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSENINFO where STATUS != ''HI02'' ');
    SQL.Add('order by ProjNo, EngType ');
    Open;

    if not(RecordCount = 0) then
    begin
      try
        EngineListBox.Items.BeginUpdate;
        while not eof do
        begin
          EngineListBox.Items.Add;
          LCaption := Fieldbyname('PROJNO').AsString+'-'+Fieldbyname('EngType').AsString;
          EngineListBox.Items[EngineListBox.Items.Count-1].Caption := LCaption;
          EngineListBox.Items[EngineListBox.Items.Count-1].Hint := Fieldbyname('PROJNO').AsString;
          Next;
        end;
        Result := True;
      finally
        EngineListBox.Items.EndUpdate;
      end;
    end;
  end;
end;

procedure TpartDurability_Frm.Set_Images(aImgNo:Integer);
var
  li : integer;
begin
  with TileList.Tiles do
  begin
    BeginUpdate;
    try
      Items[aImgNo].Content.Image.Assign(GDIPPictureContainer1.Items[aImgNo].Picture);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TpartDurability_Frm.Set_selected_engine_Info(aProjNo: String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from himseninfo where ProjNo = '''+aProjNo+'''');
    Open;

    if not(RecordCount = 0) then
    begin
      with FSelectedEngine do
      begin
        ProjNo    := aProjNo;
        EngType   := FieldByName('ENGTYPE').AsString;
        AlignType := FieldByName('ENGARR').AsString;
        NumofCyl  := FieldByName('CYLNUM').AsInteger;
      end;
    end;
  end;
end;


procedure TpartDurability_Frm.showTypeClick(Sender: TObject);
var
  lIdx : Integer;
  li : integer;
begin
  lIdx := EngineListBox.SelectedItemIndex;

  case showType.ItemIndex of
    0 : begin
          //Top
          button5.Enabled := True;
          button7.Enabled := True;
          button1.Enabled := True;

          //Child
          button3.Enabled := True;
          button4.Enabled := True;
          button2.Enabled := True;
        end;

    1 : begin
          //Top
          button5.Enabled := False;
          button7.Enabled := False;
          button1.Enabled := False;
          //Child
          button3.Enabled := False;
          button4.Enabled := False;
          button2.Enabled := False;
        end;
  end;



  Show_Top_Durability_Items(EngineListBox.Items[lIdx].Hint);

  if topGrid.RowCount > 0 then
  begin
    TopGrid.SelectedRow := 0;
    Show_Child_Durability_Items(topGrid.Cells[2,topGrid.SelectedRow]);
  end
  else
  begin
    TileList.Tiles.Clear;
    childGrid.ClearRows;
    for li := 0 to detailGrid.RowCount-1 do
      detailGrid.Cells[1,li+1] := '';
  end;
end;


procedure TpartDurability_Frm.Show_Child_Durability_Items(aRevNo: String);
begin
  with childGrid do
  begin
    BeginUpdate;
    try
      AutoSize := False;
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_DURABILITY_DESC_V ' +
                'where PARENTREV = '+aRevNo+ ' '+
                'order by REGDATE');
        Open;

        while not eof do
        begin
          AddRow;
          Cells[1,RowCount-1] := FieldByName('PARTNAME').AsString;
          Cells[2,RowCount-1] := FieldByName('PURPOSE').AsString;
          Cells[3,RowCount-1] := FieldByName('TARGETTIME').AsString;
          Cells[4,RowCount-1] := FormatDateTime('YYYY-MM-DD HH:mm',FieldByName('REGDATE').AsDateTime);
          Cells[5,RowCount-1] := FieldByName('REVNO').AsString;
          Next;
        end;
      end;
    finally
      AutoSize := True;
      EndUpdate;
    end;
  end;
end;

procedure TpartDurability_Frm.Show_Detail_Info(aRevNo: String);
var
  lResult : Boolean;
begin
  with detailGrid do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_DURABILITY_DESC_V ' +
                'where REVNO = '+aRevNo);
        Open;

        if RecordCount > 0 then
        begin
          Cells[1,1] := FieldByName('PARTNAME').AsString;
          Cells[1,2] := FieldByName('MAKER').AsString;
          Cells[1,3] := FieldByName('TYPE').AsString;
          Cells[1,4] := FieldByName('SERIALNO').AsString;
          Cells[1,5] := FormatDateTime('YYYY-MM-DD HH:mm',FieldByName('REGDATE').AsDateTime);
          Cells[1,6] := FieldByName('PURPOSE').AsString;
          Cells[1,7] := FieldByName('TARGETTIME').AsString;
          Cells[1,8] := FieldByName('REMARK').AsString;
          lResult := True;
        end;
        if lResult = True then
          Get_Image_List(aRevNo);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TpartDurability_Frm.Show_Top_Durability_Items(aProjNo: String);
var
  lPath : String;
begin
  with topGrid do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_DURABILITY_DESC_V ' +
                'where ProjNo = '''+aProjNo+''' ' +
                ' and STATUS = '+IntToStr(showType.ItemIndex) +
                ' and lv = 0 '+
                ' order by REGDATE ');
        Open;

        while not eof do
        begin
          AddRow;
          lPath := FieldByName('ROOTNAME').AsString+' / '+FieldByName('PARTNAME').AsString;
          Cells[1,RowCount-1] := lPath;
          Cells[2,RowCount-1] := FieldByName('REVNO').AsString;
          Cells[3,RowCount-1] := FieldByName('RECNO').AsString;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TpartDurability_Frm.TileListPageChanged(Sender: TObject;
  PageIndex: Integer);
var
  li : integer;
begin
  with TileList.Tiles do
  begin
    BeginUpdate;
    try
      for li := 0 to Count-1 do
        Items[li].Content.Image.Assign(nil);

      Set_Images(PageIndex);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TpartDurability_Frm.TileListTileClick(Sender: TObject;
  Tile: TAdvSmoothTile; State: TTileState);
var
  li : integer;

begin
  FCurrentTile := Tile;
  if FCurrentTile <> nil then
    if GetAsyncKeyState(VK_RBUTTON) = 1 then
    begin
      if Tile.Content.Image <> nil then
      begin
        AdvPopupMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
      end;
    end;
end;

procedure TpartDurability_Frm.topGridDblClick(Sender: TObject);
var
  lRevNo : String;
begin
  lRevNo := topGrid.Cells[2,topGrid.SelectedRow];
  detailGrid.Cells[0,7] := '목표시간';
  if not(lRevNo = '') then
  begin
    Show_Detail_Info(lRevNo);
  end;
end;

procedure TpartDurability_Frm.topGridSelectCell(Sender: TObject; ACol,
  ARow: Integer);
var
  lRevNo : String;
begin
  lRevNo := topGrid.Cells[2,ARow];
  if not(lRevNo = '') then
    Show_Child_Durability_Items(lRevNo);



end;

end.


