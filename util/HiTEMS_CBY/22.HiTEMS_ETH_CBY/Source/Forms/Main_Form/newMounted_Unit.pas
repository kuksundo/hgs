unit newMounted_Unit;

interface

uses
  Data.DBXJSon,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothPageSlider, AdvSmoothListBox,
  Vcl.StdCtrls, NxCollection, GradientLabel, Vcl.ExtCtrls, AdvSmoothPanel,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, NxColumnClasses,
  NxColumns, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, ThumbnailList, NxEdit,
  Vcl.ComCtrls, AdvDateTimePicker, clisted, Vcl.ImgList, AdvGlowButton,
  Vcl.Menus, AdvMenus, JvBackgrounds, Vcl.Imaging.pngimage, Ora, TreeList,
  AdvSmoothTileList, AdvSmoothTileListImageVisualizer, ShellAPI,
  AdvSmoothTileListHTMLVisualizer, AdvGDIPicture, Vcl.Imaging.jpeg,
  GDIPPictureContainer, OtlParallel, OtlTask, OtlTaskControl, DBAdvGrid,
  Data.DB,
  DBAccess, MemDS, OraSmart, Vcl.ExtDlgs, JvExStdCtrls, JvEdit;

type
  TnewMounted_Frm = class(TForm)
    ImageList1: TImageList;
    AdvPopupMenu1: TAdvPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    JvBackground1: TJvBackground;
    AdvSmoothPanel1: TAdvSmoothPanel;
    EngineListBox: TAdvSmoothListBox;
    PartList: TAdvSmoothListBox;
    NxHeaderPanel1: TNxHeaderPanel;
    NxSplitter1: TNxSplitter;
    msTree: TTreeList;
    treeImg: TImageList;
    AdvSmoothTileListHTMLVisualizer1: TAdvSmoothTileListHTMLVisualizer;
    Image2: TImage;
    GDIPPictureContainer1: TGDIPPictureContainer;
    NxSplitter2: TNxSplitter;
    AdvSmoothListBox1: TAdvSmoothListBox;
    NxSplitter3: TNxSplitter;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button6: TButton;
    GradientLabel2: TGradientLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ImgList: TAdvSmoothTileList;
    Label5: TLabel;
    Label4: TLabel;
    Button3: TButton;
    Label9: TLabel;
    Label10: TLabel;
    Button4: TButton;
    Label11: TLabel;
    Button5: TButton;
    partGrid: TDBAdvGrid;
    OraTable1: TOraTable;
    OraDataSource1: TOraDataSource;
    OpenPictureDialog1: TOpenPictureDialog;
    Button7: TButton;
    Button8: TButton;
    OpenDialog1: TOpenDialog;
    maker: TNxComboBox;
    ptype: TNxComboBox;
    pser: TNxEdit;
    runhour: TNxNumberEdit;
    mdate: TAdvDateTimePicker;
    aDraw: TNxEdit;
    bDraw: TNxEdit;
    winfo: TListBox;
    reason: TMemo;
    fileGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    filetype: TNxComboBox;
    filename: TJvEdit;
    SaveDialog1: TSaveDialog;
    AdvPopupMenu2: TAdvPopupMenu;
    MenuItem2: TMenuItem;
    AdvPopupMenu3: TAdvPopupMenu;
    MS1: TMenuItem;
    MS2: TMenuItem;
    MS3: TMenuItem;
    delBtn: TButton;
    N3: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure PartListItemSelected(Sender: TObject; itemindex: Integer);
    procedure MGridCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure EngineListBoxItemSelected(Sender: TObject; itemindex: Integer);
    procedure msTreeChange(Sender: TObject; Node: TTreeNode);
    procedure Button1Click(Sender: TObject);
    procedure update_BtnClick(Sender: TObject);
    procedure makerSelect(Sender: TObject);
    procedure msTreeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button4Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure partGridDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure Button2Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MS1Click(Sender: TObject);
    procedure AdvPopupMenu3Popup(Sender: TObject);
    procedure MS2Click(Sender: TObject);
    procedure MS3Click(Sender: TObject);
    procedure delBtnClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
    FCurrentNode: TTreeNode;
    FCurrentKey: Double;
    FCurrentProj, FCurrentMS: String;
    FWorkers: String;
  public
    { Public declarations }

    // 완료된 작업들...
    function Set_Engine_List_Box: Boolean;

    procedure Refresh_TreeView;
    procedure Review_Tree(aParentMs: String; aTreeNode: TTreeNode);
    function Return_REGNO(aPROJNO, aMSNO: String): Integer;
    procedure mod_ATTFILES_FLAG_A_FILES(aMOUNTNO: Double);
    procedure mod_ATTFILES_FLAG_I_IMAGES(aMOUNTNO: Double);
    procedure mod_HIMSEN_MS_WORKER(aMOUNTNO: Double);

    procedure Set_Worker_List(aMOUNTNO: Double);
    procedure Set_ATTFILES_FLAG_A_GRID(aMOUNTNO: Double);
    procedure Set_ATTFILES_FLAG_I_IMAGES(aMOUNTNO: Double);
    procedure Set_Before_DrawNo;

    procedure DownLoad_ATTFILES(aFlag, aMOUNTNO, aFileName: String);
    procedure Delete_Ms_Number(aMs: String);

    procedure Init_;

  end;

  // FillChar(FnewDataInfo,SizeOf(FnewDataInfo),'');

var
  newMounted_Frm: TnewMounted_Frm;

implementation

uses
  HiTEMS_ETH_COMMON,
  newMS_Unit,
  progress_Unit,
  CommonUtil_Unit,
  workerList_Unit,
  HiTEMS_ETH_CONST,
  DataModule_Unit;

{$R *.dfm}
{ TnewMounted_Frm }

procedure TnewMounted_Frm.AdvPopupMenu3Popup(Sender: TObject);
begin
  case msTree.Selected.Level of
    0..3:
      AdvPopupMenu3.Items[0].Enabled := True;
    4:
      AdvPopupMenu3.Items[0].Enabled := False;
  end;

  case msTree.Selected.Level of
    0..1: begin
      AdvPopupMenu3.Items[1].Enabled := False;
      AdvPopupMenu3.Items[2].Enabled := False;
    end;

    2..4: begin
      AdvPopupMenu3.Items[1].Enabled := True;
      AdvPopupMenu3.Items[2].Enabled := True;
    end;
  end;
end;

procedure TnewMounted_Frm.Button1Click(Sender: TObject);
var
  li: Integer;
  lItem: String;
  lPageIndex: Integer;
begin
  with OraTable1 do
  begin
    try
      if FCurrentProj = '' then
      begin
        EngineListBox.SetFocus;
        raise Exception.Create('선택된 엔진타입이 없습니다.');
      end;

      if FCurrentMS = '' then
      begin
        msTree.SetFocus;
        raise Exception.Create('선택된 MS번호가 없습니다.');
      end;

      if Button1.Caption = '탑재정보등록' then
      begin
        Insert;
        FCurrentKey := DateTimeToMilliseconds(Now);

        FieldByName('MOUNTNO').AsFloat := FCurrentKey;
        FieldByName('REGNO').AsInteger := Return_REGNO(FCurrentProj,
          FCurrentMS);
        FieldByName('REGID').AsString := CurrentUsers;
        FieldByName('REGDATE').AsDateTime := Now;

      end
      else
      begin
        Edit;
        FieldByName('MODID').AsString := CurrentUsers;
        FieldByName('MODDATE').AsDateTime := Now;
      end;

      FieldByName('PROJNO').AsString := EngineListBox.Items[EngineListBox.SelectedItemIndex].Hint;
      FieldByName('MSNO').AsString := FCurrentMS;
      FieldByName('MAKER').AsString := maker.Text;
      FieldByName('TYPE_').AsString := ptype.Text;
      FieldByName('SERIALNO').AsString := pser.Text;
      FieldByName('ENG_RUN_TIME').AsFloat := runhour.Value;
      FieldByName('MOUNTED').AsDateTime := mdate.DateTime;
      FieldByName('REASON').AsString := reason.Text;
      FieldByName('BDRAWNO').AsString := bDraw.Text;
      FieldByName('ADRAWNO').AsString := aDraw.Text;

      Post;
      ApplyUpdates;

      FCurrentKey := FieldByName('MOUNTNO').AsFloat;
      mod_ATTFILES_FLAG_I_IMAGES(FCurrentKey);
      mod_ATTFILES_FLAG_A_FILES(FCurrentKey);
      mod_HIMSEN_MS_WORKER(FCurrentKey);

      Set_ATTFILES_FLAG_A_GRID(FCurrentKey);

      GradientLabel2.Caption := '탑재정보 수정';
      Button1.Caption := '탑재정보수정';

      ShowMessage(Format('%s 성공!',[Button1.Caption]));

    except
      on e: Exception do
        ShowMessage(e.Message);
    end;
  end;
end;

procedure TnewMounted_Frm.Button2Click(Sender: TObject);
begin
  FWorkers := '';

  maker.Items.Clear;
  maker.Clear;

  ptype.Items.Clear;
  ptype.Clear;

  pser.Clear;
  mdate.DateTime := Now;
  runhour.Value := 0;
  aDraw.Clear;
  bDraw.Clear;

  winfo.Items.Clear;
  reason.Clear;
  ImgList.Tiles.Clear;
  GDIPPictureContainer1.Items.Clear;
  fileGrid.ClearRows;
  filetype.Clear;
  filename.Clear;

  GradientLabel2.Caption := '신규정보 입력';
  Button1.Caption := '탑재정보등록';
  delBtn.Enabled := False;

end;

procedure TnewMounted_Frm.Button3Click(Sender: TObject);
var
  li: Integer;
  lms: TMemoryStream;
begin
  if filetype.Text = '' then
  begin
    filetype.SetFocus;
    raise Exception.Create('파일구분을 입력하여 주십시오!');
  end;

  if not(filename.Text = '') then
  begin
    with fileGrid do
    begin
      BeginUpdate;
      lms := TMemoryStream.Create;
      try
        AddRow;
        Cells[1, RowCount - 1] := filetype.Text;
        Cells[2, RowCount - 1] := ExtractFileName(filename.Text);
        Cells[4, RowCount - 1] := filename.Text;
        lms.LoadFromFile(Cells[4, RowCount - 1]);
        Cell[3, RowCount - 1].AsFloat := lms.Size;

        for li := 0 to Columns.Count - 1 do
          Cell[li, RowCount - 1].TextColor := clBlue;

      finally
        OpenPictureDialog1.Files.Clear;
        filetype.Clear;
        filename.Clear;
        FreeAndNil(lms);
        EndUpdate;
      end;
    end;
  end;
end;

procedure TnewMounted_Frm.Button4Click(Sender: TObject);
var
  li, le: Integer;
  lMsg, lFileName: String;
  lResult: Boolean;
  lPicture: TPictureItem;
  Tile: TAdvSmoothTile;
begin
  if OpenPictureDialog1.Execute then
  begin
    for li := 0 to OpenPictureDialog1.Files.Count - 1 do
    begin
      lMsg := '';
      lResult := True;
      lFileName := OpenPictureDialog1.Files.Strings[li];
      if GDIPPictureContainer1.Items.Count > 0 then
      begin
        for le := 0 to GDIPPictureContainer1.Items.Count - 1 do
        begin
          if lFileName = GDIPPictureContainer1.Items[le].Name then
          begin
            lMsg := lMsg + '같은 이름의 파일이 존재 합니다 : ' +
              GDIPPictureContainer1.Items[li].Name;
            lResult := False;
          end;
        end;
      end;

      if lResult = True then
      begin
        lPicture := GDIPPictureContainer1.Items.Add;
        lPicture.Picture.LoadFromFile(lFileName);
        lPicture.Name := ExtractFileName(lFileName);

        Tile := ImgList.Tiles.Add;
        Tile.Content.ImageName := ExtractFileName(lFileName);
      end;
    end;

    if not(lMsg = '') then
      ShowMessage(lMsg);

  end;
end;

procedure TnewMounted_Frm.Button5Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    filename.Text := OpenDialog1.filename;
  end;
end;

procedure TnewMounted_Frm.Button7Click(Sender: TObject);
var
  li: Integer;
  lWorkers: String;
  lItem,lItem1: TStringList;
  lUsers: String;
  name,
  Id : String;
begin
  lWorkers := Return_Employee_List(FWorkers,1);

  winfo.Items.Clear;
  if not(lWorkers = '') then
  begin
    FWorkers := '';
    lItem := TStringList.Create;
    try
      ExtractStrings([','], [], PChar(lWorkers), lItem);

      if lItem.Count > 0 then
      begin
        litem1 := TStringList.Create;
        try
          for li := 0 to lItem.Count - 1 do
          begin
            lItem1.Clear;
            ExtractStrings(['/'], [], PChar(lItem.Strings[li]), lItem1);

            wInfo.Items.Add(lItem1.Strings[0]);
            lUsers := lItem1.Strings[0];
            FWorkers := FWorkers + lItem1.Strings[1]+',';
          end;
        finally
          FreeAndNil(litem1);
        end;
      end;
    finally
      FreeAndNil(lItem);
    end;
  end;
end;

procedure TnewMounted_Frm.Button8Click(Sender: TObject);
var
  li, lRow: Integer;
begin
  lRow := fileGrid.SelectedRow;
  if lRow > -1 then
  begin
    if not(fileGrid.Cells[4, lRow] = '') then
      fileGrid.DeleteRow(lRow)
    else
    begin
      for li := 0 to fileGrid.Columns.Count - 1 do
        fileGrid.Cell[li, lRow].TextColor := clRed;
    end;
  end;
end;

procedure TnewMounted_Frm.delBtnClick(Sender: TObject);
var
  lMountNo : String;
begin
  If MessageDlg('탑재된 정보를 삭제 하시겠습니까?.'+#10#13+
                '삭제된 정보는 복구할 수 없습니다.', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
  begin
    with OraTable1 do
    begin
      lMountNo := FieldByName('MOUNTNO').AsString;
    end;

    if not(lMountNo = '') then
    begin
      with DM1.OraQuery1 do
      begin
        // 작업자 목록 삭제
        Close;
        SQL.Clear;
        SQL.Add('Delete HIMSEN_MS_WORKER ' +
                'where MOUNTNO = '+lMountNo);
        ExecSQL;

        // 첨부파일 삭제
        Close;
        SQL.Clear;
        SQL.Add('Delete HIMSEN_MS_ATTFILES ' +
                'where MOUNTNO = '+lMountNo);
        ExecSQL;

        // 탑재정보 삭제
        Close;
        SQL.Clear;
        SQL.Add('Delete HIMSEN_MS_MOUNTED ' +
                'where MOUNTNO = '+lMountNo);
        ExecSQL;

      end;
    end;
    OraDataSource1.DataSet.Refresh;
  end;
end;

procedure TnewMounted_Frm.Delete_Ms_Number(aMs: String);
var
  li: Integer;
  lItem: TStringList;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_MS_MOUNTED ' + 'where MSNO = ''' +
      aMs + ''' ');
    Open;

    if RecordCount = 0 then
    begin
      Close;
      SQL.Clear;
      SQL.Add('Delete From HIMSEN_MS_NUMBER ' + 'where MSNO = ''' + aMs
        + ''' ');
      ExecSQL;
    end
    else
    begin
      If MessageDlg('삭제할 MS번호로 탑재된 정보가 존재 합니다.'+#10#13+
                    '전부 삭제 하시겠습니까?', mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
      begin
        lItem := TStringList.Create;
        try
          while not eof do
          begin
            lItem.Add(FieldByName('MOUNTNO').AsString);
            Next;
          end;

          for li := 0 to lItem.Count - 1 do
          begin
            // 작업자 목록 삭제
            Close;
            SQL.Clear;
            SQL.Add('Delete HIMSEN_MS_WORKER ' +
                    'where MOUNTNO = ''' + lItem.Strings[li] + ''' ');
            ExecSQL;

            // 첨부파일 삭제
            Close;
            SQL.Clear;
            SQL.Add('Delete HIMSEN_MS_ATTFILES ' +
                    'where MOUNTNO = ''' + lItem.Strings[li] + ''' ');
            ExecSQL;

            // 탑재정보 삭제
            Close;
            SQL.Clear;
            SQL.Add('Delete HIMSEN_MS_MOUNTED ' +
                    'where MOUNTNO = ''' + lItem.Strings[li] + ''' ');
            ExecSQL;
          end;
          // NS-Number 삭제
          Close;
          SQL.Clear;
          SQL.Add('Delete HIMSEN_MS_NUMBER ' +
                  'where MSNO = ''' + aMs + ''' ');
          ExecSQL;
        finally
          FreeAndNil(lItem);
        end;
      end;
    end;
  end;
end;

procedure TnewMounted_Frm.DownLoad_ATTFILES(aFlag, aMOUNTNO, aFileName: String);
var
  lms: TMemoryStream;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_MS_ATTFILES ' + 'where MOUNTNO = ' + aMOUNTNO +
            ' and FLAG = ''' + aFlag + ''' ' + ' and FILENAME = ''' + ExtractFileName(aFileName) + ''' ');
    Open;

    if not(RecordCount = 0) then
    begin
      lms := TMemoryStream.Create;
      try
        (FieldByName('Files') as TBlobField).SaveToStream(lms);
        lms.SaveToFile(aFileName);
      finally
        FreeAndNil(lms);
      end;
    end;
  end;
end;

procedure TnewMounted_Frm.update_BtnClick(Sender: TObject);
var
  lPageIndex: Integer;
begin
  If MessageDlg('기존 탑재된 부픔 정보를 ' + #13 + '변경된 정보로 수정 하시겠습니까?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes Then
  begin
    try
      // lPageIndex := FCurrentTile.TileList.PageIndex;

    finally
      // partTreeDblClick(sender);
    end;
  end;
end;

procedure TnewMounted_Frm.EngineListBoxItemSelected(Sender: TObject;
  itemindex: Integer);
var
  li: Integer;
  lNode: TTreeNode;

begin
  FCurrentProj := EngineListBox.Items[itemindex].Hint;
  msTree.Select(msTree.TopItem);
  with OraTable1 do
  begin
    Filter := 'PROJNO = ''' + FCurrentProj + '''';
    OraDataSource1.DataSet.Refresh;
  end;
end;

procedure TnewMounted_Frm.FormCreate(Sender: TObject);
var
  li: Integer;
  lNode: TTreeNode;
begin
  if Set_Engine_List_Box = True then
  begin

    FCurrentProj := EngineListBox.Items[0].Hint;
    Refresh_TreeView;
    Init_;

    if OraTable1.Active = False then
      OraTable1.Active := True;

  end;
end;

procedure TnewMounted_Frm.Init_;
begin
  FWorkers := '';

  EngineListBox.SelectedItemIndex := 0;
  FCurrentProj := '';
  msTree.Select(msTree.TopItem);
  FCurrentMS := '';
  partGrid.Clear;
  ImgList.Tiles.Clear;
  GDIPPictureContainer1.Items.Clear;
  fileGrid.DoubleBuffered := False;

  maker.Items.Clear;
  maker.Clear;

  ptype.Items.Clear;
  ptype.Clear;

  pser.Clear;
  mdate.DateTime := Now;
  runhour.Value := 0;
  aDraw.Clear;
  bDraw.Clear;

  winfo.Items.Clear;
  reason.Clear;
  ImgList.Tiles.Clear;
  filetype.Clear;
  filename.Clear;
  delBtn.Enabled := False;
end;

procedure TnewMounted_Frm.makerSelect(Sender: TObject);
begin
  ptype.Items.Clear;
  ptype.Clear;
end;

procedure TnewMounted_Frm.MenuItem2Click(Sender: TObject);
var
  lMountNo: String;
  lFileName: String;
  Tiles: TAdvSmoothTile;
begin
  Tiles := ImgList.SelectedTile;
  SaveDialog1.filename := Tiles.Content.ImageName;
  if SaveDialog1.Execute then
  begin
    lFileName := SaveDialog1.filename;
    DownLoad_ATTFILES('I', FloatToStr(FCurrentKey), lFileName);

  end;
end;

procedure TnewMounted_Frm.MGridCanEditCell(Sender: TObject; ARow, ACol: Integer;
  var CanEdit: Boolean);
begin
  if ACol = 4 then
    CanEdit := True
  else
    CanEdit := False;
end;

procedure TnewMounted_Frm.PartListItemSelected(Sender: TObject;
  itemindex: Integer);
var
  LPartName: String;
  li: Integer;

begin
  LPartName := PartList.Items[itemindex].Caption;

  // 선택된 파트의 기준정보 가져오기!!

end;

procedure TnewMounted_Frm.mod_ATTFILES_FLAG_A_FILES(aMOUNTNO: Double);
var
  li: Integer;
  lms: TMemoryStream;
begin
  with fileGrid do
  begin
    BeginUpdate;
    try
      for li := 0 to RowCount - 1 do
      begin
        if Cell[0, li].TextColor = clBlue then
        begin
          lms := TMemoryStream.Create;
          try
            lms.LoadFromFile(Cells[4, li]);
            with DM1.OraQuery1 do
            begin
              Close;
              SQL.Clear;
              SQL.Add('Insert into HIMSEN_MS_ATTFILES ' +
                'values(:MOUNTNO, :FLAG, :FILETYPE, :FILENAME, :FILESIZE, :FILES)');

              ParamByName('MOUNTNO').AsFloat := aMOUNTNO;
              ParamByName('FLAG').AsString := 'A';
              ParamByName('FILETYPE').AsString := Cells[1, li];
              ParamByName('FILENAME').AsString := Cells[2, li];
              ParamByName('FILESIZE').AsFloat := lms.Size;

              ParamByName('FILES').ParamType := ptInput;
              ParamByName('FILES').AsOraBlob.LoadFromStream(lms);
              ExecSQL;
            end;
          finally
            FreeAndNil(lms);
          end;
        end
        else if Cell[0, li].TextColor = clRed then
        begin
          with DM1.OraQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('Delete From HIMSEN_MS_ATTFILES ' + 'where FLAG = ''A'' ' +
              'and MOUNTNO = ' + FloatToStr(aMOUNTNO) + ' and FileName = ''' +
              Cells[2, li] + ''' ');
            ExecSQL;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewMounted_Frm.mod_ATTFILES_FLAG_I_IMAGES(aMOUNTNO: Double);
var
  li: Integer;
  lPic: TPictureItem;
  lms: TMemoryStream;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete from HIMSEN_MS_ATTFILES ' + 'where FLAG = ''I'' ' +
      'and MOUNTNO = ' + FloatToStr(aMOUNTNO));
    ExecSQL;
  end;

  with GDIPPictureContainer1.Items do
  begin
    for li := 0 to Count - 1 do
    begin
      lms := TMemoryStream.Create;
      try
        lPic := Items[li];
        lPic.Picture.SaveToStream(lms);

        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Insert into HIMSEN_MS_ATTFILES ' +
            'values(:MOUNTNO, :FLAG, :FILETYPE, :FILENAME, :FILESIZE, :FILES)');
          ParamByName('MOUNTNO').AsFloat := aMOUNTNO;
          ParamByName('FLAG').AsString := 'I';
          ParamByName('FILENAME').AsString := lPic.Name;
          ParamByName('FILESIZE').AsFloat := lms.Size;

          ParamByName('FILES').ParamType := ptInput;
          ParamByName('FILES').AsOraBlob.LoadFromStream(lms);
          ExecSQL;
        end;
      finally
        FreeAndNil(lms);
      end;
    end;
  end;
end;

procedure TnewMounted_Frm.mod_HIMSEN_MS_WORKER(aMOUNTNO: Double);
var
  li: Integer;
  litem : TStringList;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete from HIMSEN_MS_WORKER ' + 'where MOUNTNO = ' +
      FloatToStr(aMOUNTNO));
    ExecSQL;
  end;

  litem := TStringList.Create;
  try
    ExtractStrings([','],[],PChar(FWorkers),litem);
    for li := 0 to litem.Count - 1 do
    begin
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Insert into HIMSEN_MS_WORKER ' +
          'values(:MOUNTNO, :USERID, :SORTNO)');
        ParamByName('MOUNTNO').AsFloat := aMOUNTNO;
        ParamByName('USERID').AsString := litem.Strings[li];
        ParamByName('SORTNO').AsInteger := li + 1;
        ExecSQL;
      end;
    end;
  finally
    FreeAndNil(lItem);
  end;
end;

procedure TnewMounted_Frm.MS1Click(Sender: TObject);
var
  lResult: Boolean;
  lstr: String;
  lItem: TStringList;
  lname, lno: String;
  lv: Integer;
begin
  if FCurrentNode <> nil then
  begin
    lItem := TStringList.Create;
    try
      lstr := FCurrentNode.Text;
      ExtractStrings([';'], [' '], PChar(lstr), lItem);
      lname := lItem.Strings[0];
      lno := lItem.Strings[1];
      lv := FCurrentNode.Level + 1;

      lResult := Create_new_Ms(lno, lv);
      if lResult = True then
      begin
        Refresh_TreeView;
      end;
    finally
      FreeAndNil(lItem);
    end;
  end;
end;

procedure TnewMounted_Frm.MS2Click(Sender: TObject);
var
  lResult: Boolean;
  lstr: String;
  lItem: TStringList;
  lname, lno: String;
  lv: Integer;
begin
  if FCurrentNode <> nil then
  begin
    lItem := TStringList.Create;
    try
      lstr := FCurrentNode.Text;
      ExtractStrings([';'], [' '], PChar(lstr), lItem);
      lno := lItem.Strings[1];

      lResult := Create_update_Ms(lno);
      if lResult = True then
      begin
        Refresh_TreeView;
      end;
    finally
      FreeAndNil(lItem);
    end;
  end;
end;

procedure TnewMounted_Frm.MS3Click(Sender: TObject);
begin
  If MessageDlg('MS번호를 삭제 하시겠습니까?', mtConfirmation, [mbYes, mbNo], 0)= mrYes Then
  begin
    Delete_Ms_Number(FCurrentMS);
    Refresh_TreeView;
  end;
end;

procedure TnewMounted_Frm.msTreeChange(Sender: TObject; Node: TTreeNode);
begin
  with msTree.Items do
  begin
    BeginUpdate;
    try
      if Node.Selected = True then
        Node.SelectedIndex := 2;

      Button2Click(Sender);

    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewMounted_Frm.msTreeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  lNode: TTreeNode;
  lstr : String;
  llist: TStringList;
begin
  lNode := msTree.GetNodeAt(X, Y);
  if lNode <> nil then
  begin
    FCurrentNode := lNode;

    llist := TStringList.Create;
    lstr := lNode.Text;
    try
      ExtractStrings([';'], [' '], PChar(lstr), llist);
      FCurrentMS := llist.Strings[1];
      FCurrentProj := EngineListBox.Items[EngineListBox.SelectedItemIndex].Hint;

      if Button = mbLeft then
      begin
        Set_Before_DrawNo;
        if not(FCurrentMS = '') then
        begin
          FCurrentMS := FCurrentMS;
          with OraTable1 do
          begin
            Filter := 'PROJNO = ''' + FCurrentProj + ''' and ' + 'MSNO = ''' +
                      FCurrentMS + ''' ';

            OraDataSource1.DataSet.Refresh;
          end;
        end;
      end
      else if Button = mbRight then
      begin

      end;
    finally
      FreeAndNil(llist);
    end;
  end;
end;

procedure TnewMounted_Frm.N1Click(Sender: TObject);
var
  lMountNo: String;
  lFileName: String;
begin
  if DirectoryExists('C:\Temp') = False then
    CreateDir('C:\Temp');

  lFileName := 'C:\Temp\' + fileGrid.Cells[2, fileGrid.SelectedRow];
  DownLoad_ATTFILES('A', FloatToStr(FCurrentKey), lFileName);
  ShellExecute(0, 'Open', PWideChar(lFileName), '', '', SW_SHOWNORMAL);
end;

procedure TnewMounted_Frm.N2Click(Sender: TObject);
var
  lMountNo: String;
  lFileName: String;
begin
  SaveDialog1.filename := fileGrid.Cells[2, fileGrid.SelectedRow];
  if SaveDialog1.Execute then
  begin
    lFileName := SaveDialog1.filename;
    DownLoad_ATTFILES('A', FloatToStr(FCurrentKey), lFileName);

  end;
end;

procedure TnewMounted_Frm.N3Click(Sender: TObject);
var
  Tile : TAdvSmoothTile;
  imgName : String;
  li : integer;
  idx : integer;
begin
  Tile := imgList.SelectedTile;
  if Assigned(Tile) then
  begin
    idx := Tile.Index;
    imgName := Tile.Content.ImageName;

    with GDIPPictureContainer1.Items do
    begin
      for li := 0 to Count-1 do
      begin
        if SameText(imgName,Items[li].Name) then
        begin
          Delete(li);
          imgList.Tiles.Delete(idx);
          Break;
        end;
      end;
    end;
  end;
end;

procedure TnewMounted_Frm.partGridDblClickCell(Sender: TObject;
  ARow, ACol: Integer);
var
  li,le : integer;
  lNode : TTreeNode;

begin
  if ARow > 0 then
  begin
    ImgList.Tiles.Clear;
    fileGrid.ClearRows;
    with OraTable1 do
    begin
      FCurrentMS := FieldByName('MSNO').AsString;
      FCurrentProj := FieldByName('PROJNO').AsString;

      for li := 0 to EngineListBox.Items.Count-1 do
      begin
        le := POS(FCurrentProj,EngineListBox.Items[li].Caption);
        if le > 0 then
        begin
          EngineListBox.Items[li].Selected := True;
          EngineListBox.SelectedItemIndex := li;
          EngineListBox.Refresh;
          Break;
        end;
      end;

      for li := 0 to msTree.Items.Count-1 do
      begin
        le := POS(FCurrentMS,msTree.Items[li].Text);
        if le > 0 then
        begin
          lNode := msTree.Items[li];
          lNode.Selected := True;
          msTree.Invalidate;
          Break;
        end;
      end;

      FCurrentKey := FieldByName('MOUNTNO').AsFloat;
      maker.Text := FieldByName('MAKER').AsString;
      ptype.Text := FieldByName('TYPE_').AsString;
      pser.Text := FieldByName('SERIALNO').AsString;
      runhour.Text := FieldByName('ENG_RUN_TIME').AsString;
      mdate.DateTime := FieldByName('MOUNTED').AsDateTime;
      reason.Text := FieldByName('reason').AsString;
      bDraw.Text := FieldByName('BDRAWNO').AsString;
      aDraw.Text := FieldByName('ADRAWNO').AsString;

      Set_Worker_List(FCurrentKey);
      Set_ATTFILES_FLAG_A_GRID(FCurrentKey);
      Set_ATTFILES_FLAG_I_IMAGES(FCurrentKey);

      GradientLabel2.Caption := '탑재정보 수정';
      Button1.Caption := '탑재정보수정';

      delBtn.Enabled := True;
      with OraTable1 do
      begin
        Filter := 'PROJNO = ''' + FCurrentProj + ''' and ' + 'MSNO = ''' +
                  FCurrentMS + ''' ';

        OraDataSource1.DataSet.Refresh;
      end;
    end;
  end;
end;

procedure TnewMounted_Frm.Refresh_TreeView;
var
  TreeNode: TTreeNode;
  li: Integer;
  typeNo: Double;
  typeNm: String;

begin
  msTree.Items.Clear;

  TreeNode := msTree.Items.AddChildFirst(msTree.TopItem, 'MS-Number;TOP00');
  TreeNode.ImageIndex := 0;
  try
    Review_Tree('TOP00', msTree.TopItem);
  finally
    with msTree.Items do
    begin
      BeginUpdate;
      try
        for li := 0 to Count - 1 do
          item[li].Expanded := True;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

function TnewMounted_Frm.Return_REGNO(aPROJNO, aMSNO: String): Integer;
var
  li: Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_MS_MOUNTED ' + 'where PROJNO = ''' + aPROJNO +
      ''' ' + 'and MSNO = ''' + aMSNO + ''' ' + 'and rownum = 1 ' +
      'order by MOUNTNO DESC');
    Open;

    if not(RecordCount = 0) then
    begin
      li := FieldByName('REGNO').AsInteger;
      Result := li + 1;
    end
    else
      Result := 1;

  end;
end;

procedure TnewMounted_Frm.Review_Tree(aParentMs: String; aTreeNode: TTreeNode);
var
  lname: String;
  lChildNode: TTreeNode;
  lParentMs: String;
  OraQuery1: TOraQuery;

begin
  OraQuery1 := TOraQuery.Create(Self);
  OraQuery1.Session := DM1.OraSession1;
  try
    with OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HiMSEN_MS_NUMBER where PRTMSNO = ''' +
        aParentMs + ''' ');
      Open;

      if RecordCount > 0 then
      begin
        while not eof do
        begin
          lParentMs := FieldByName('MSNO').AsString;
          lname := FieldByName('MSNAME').AsString;

          lChildNode := msTree.Items.AddChild(aTreeNode,
            lname + ';' + lParentMs);

          Review_Tree(lParentMs, lChildNode);

          Next;
        end;
      end;
    end;
  finally
    OraQuery1.Close;
    FreeAndNil(OraQuery1);
  end;
end;

procedure TnewMounted_Frm.Set_ATTFILES_FLAG_A_GRID(aMOUNTNO: Double);
begin
  with fileGrid do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_MS_ATTFILES ' + 'where FLAG = ''A'' ' +
          'and MOUNTNO = ' + FloatToStr(aMOUNTNO));
        Open;

        if not(RecordCount = 0) then
        begin
          while not eof do
          begin
            AddRow;
            Cells[1, RowCount - 1] := FieldByName('FILETYPE').AsString;
            Cells[2, RowCount - 1] := FieldByName('FILENAME').AsString;
            Cells[3, RowCount - 1] := FieldByName('FILESIZE').AsString;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewMounted_Frm.Set_ATTFILES_FLAG_I_IMAGES(aMOUNTNO: Double);
var
  lPic: TPictureItem;
  lms: TMemoryStream;
  lTiles: TAdvSmoothTile;
begin
  with GDIPPictureContainer1.Items do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_MS_ATTFILES ' + 'where FLAG = ''I'' ' +
          'and MOUNTNO = ' + FloatToStr(aMOUNTNO));
        Open;

        while not eof do
        begin
          lTiles := ImgList.Tiles.Add;
          lms := TMemoryStream.Create;
          try
            (FieldByName('Files') as TBlobField).SaveToStream(lms);
            lPic := Add;
            lPic.Name := FieldByName('FileName').AsString;
            lPic.Picture.LoadFromStream(lms);
            lTiles.Content.ImageName := lPic.Name;
          finally
            FreeAndNil(lms);
          end;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewMounted_Frm.Set_Before_DrawNo;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_MS_MOUNTED ' + 'where PROJNO = ''' +
      FCurrentProj + ''' ' + 'and MSNO = ''' + FCurrentMS + ''' ' +
      'and rownum = 1 ' + 'order by MOUNTNO Desc');
    Open;

    if RecordCount > 0 then
      bDraw.Text := FieldByName('aDrawNo').AsString
    else
      bDraw.Clear;

  end;
end;

function TnewMounted_Frm.Set_Engine_List_Box: Boolean;
var
  LCaption: String;
begin
  Result := False;
  EngineListBox.Items.Clear;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select PROJNO, ENGTYPE from HIMSENINFO where STATUS != ''HI02'' ');
    SQL.Add('order by ProjNo, EngType ');
    Open;

    if not(RecordCount = 0) then
    begin
      try
        EngineListBox.Items.BeginUpdate;
        while not eof do
        begin
          EngineListBox.Items.Add;
          LCaption := FieldByName('PROJNO').AsString + '-' +
            FieldByName('EngType').AsString;
          EngineListBox.Items[EngineListBox.Items.Count - 1].Caption :=
            LCaption;
          EngineListBox.Items[EngineListBox.Items.Count - 1].Hint :=
            FieldByName('PROJNO').AsString;
          Next;
        end;
        Result := True;
      finally
        EngineListBox.Items.EndUpdate;
      end;
    end;
  end;
end;

procedure TnewMounted_Frm.Set_Worker_List(aMOUNTNO: Double);
var
  li: Integer;
  litem : TStringList;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_MS_WORKER ' + 'where MOUNTNO = ' +
      FloatToStr(aMOUNTNO) + ' order by SORTNO');
    Open;

    FWorkers := '';
    while not eof do
    begin
      FWorkers := FWorkers + FieldByName('USERID').AsString+',';
      Next;
    end;
  end;

  winfo.Items.Clear;
  if not(FWorkers = '') then
  begin
    litem := TStringList.Create;
    try
      ExtractStrings([','],[],PChar(FWorkers),litem);
      for li := 0 to litem.Count - 1 do
      begin
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select * from HiTEMS_EMPLOYEE_V ' + 'where USERID = ''' +
            litem.Strings[li] + ''' ');
          Open;

          if not(RecordCount = 0) then
          begin
            with winfo do
            begin
              Items.Add(FieldByName('NAME_KOR').AsString);
              Next;
            end;
          end;
        end;
      end;
    finally
      FreeAndNil(litem);
    end;
  end;
end;

end.
