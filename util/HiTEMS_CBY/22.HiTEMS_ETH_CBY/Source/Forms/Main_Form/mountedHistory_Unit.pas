unit mountedHistory_Unit;

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
  MemDS, DBAccess, OtlParallel, OtlTask, OtlTaskControl, JvExStdCtrls,
  JvCombobox, AdvPageControl;

type
  TmountedHistory_Frm = class(TForm)
    ImageList1: TImageList;
    AdvPopupMenu1: TAdvPopupMenu;
    N1: TMenuItem;
    JvBackground1: TJvBackground;
    AdvSmoothPanel1: TAdvSmoothPanel;
    treeImg: TImageList;
    AdvSmoothTileListHTMLVisualizer1: TAdvSmoothTileListHTMLVisualizer;
    Image2: TImage;
    GDIPPictureContainer1: TGDIPPictureContainer;
    OraQuery1: TOraQuery;
    DataSource1: TDataSource;
    N2: TMenuItem;
    AdvPageControl1: TAdvPageControl;
    AdvTabSheet1: TAdvTabSheet;
    AdvSmoothPanel2: TAdvSmoothPanel;
    Label1: TLabel;
    engType: TJvComboBox;
    NxHeaderPanel1: TNxHeaderPanel;
    NxSplitter1: TNxSplitter;
    msTree: TTreeList;
    TileList: TAdvSmoothTileList;
    procedure FormCreate(Sender: TObject);
    procedure engTypeDropDown(Sender: TObject);
    procedure engTypeSelect(Sender: TObject);
    procedure msTreeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TileListResize(Sender: TObject);

  private
    { Private declarations }
    FCurrentProjNo,
    FCurrentEngType,
    FCurrentMSName,
    FCurrentMsNo : String;

  public
    { Public declarations }

    procedure Refresh_TreeView;
    procedure Review_Tree(aParentMs: String; aTreeNode: TTreeNode);
    procedure Set_Mounted_Info(aProjNo,aMsName,aMsNo : String);
    function Get_Flag_I_Picture(aMountNo:String) : String;
    function Get_HIMSEN_MS_WORKER(aMountNo:String) : String;

  end;

var
  mountedHistory_Frm: TmountedHistory_Frm;

implementation
uses
  progress_Unit,
  addDurability_Unit,
  historyList_Unit,
  CommonUtil_Unit,
  workerList_Unit,
  HiTEMS_ETH_CONST,
  DataModule_Unit;

{$R *.dfm}

{ TnewMounted_Frm }


{ TmountedHistory_Frm }

procedure TmountedHistory_Frm.engTypeDropDown(Sender: TObject);
var
  ltype: String;
begin
  with ENGTYPE.Items do
  begin
    BeginUpdate;
    Clear;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select PROJNO, ENGTYPE from HIMSENINFO where STATUS != ''HI02'' order by PROJNO ');
        Open;

        Add('');
        while not eof do
        begin
          ltype := FieldByName('PROJNO').AsString + '-' +FieldByName('ENGTYPE').AsString;
          Add(ltype);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TmountedHistory_Frm.engTypeSelect(Sender: TObject);
var
  litem : TStringList;
begin
  if not(engType.Text = '') then
  begin
    litem := TStringList.Create;
    try
      ExtractStrings(['-'],[' '],PChar(engType.Text),litem);
      FCurrentProjNo := litem.Strings[0];
      FCurrentEngType := litem.Strings[1];
      msTree.Enabled := True;

      NxHeaderPanel1.Caption := FCurrentEngType;

    finally
      FreeAndNil(litem);
    end;
  end
  else
    NxHeaderPanel1.Caption := '';
end;

procedure TmountedHistory_Frm.FormCreate(Sender: TObject);
begin
  AdvPageControl1.ActivePageIndex := 0;
  Refresh_TreeView;


end;

function TmountedHistory_Frm.Get_Flag_I_Picture(aMountNo: String): String;
var
  OraQuery: TOraQuery;
  lPic : TPictureItem;
  lms : TMemoryStream;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HIMSEN_MS_ATTFILES ' +
              ' where MOUNTNO = '+aMountNo +
              ' and FLAG = ''I'' ' +
              ' and rownum = 1 ');
      Open;

      if not(RecordCount = 0) then
      begin
        with GDIPPictureContainer1.Items do
        begin
          lms := TMemoryStream.Create;
          lPic := Add;
          try
            (FieldByName('Files') as TBlobField).SaveToStream(lms);
            lPic.Name := FieldByName('FILENAME').AsString;
            lPic.Picture.LoadFromStream(lms);
            Result := lPic.Name;
          finally
            FreeAndNil(lms);
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TmountedHistory_Frm.Get_HIMSEN_MS_WORKER(aMountNo: String): String;
var
  OraQuery: TOraQuery;
  lUser : String;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select A.*, B.NAME_KOR from HIMSEN_MS_WORKER A, HITEMS_EMPLOYEE B '+
              'where A.MOUNTNO = '+aMountNo +
              'and A.USERID = B.USERID '+
              'order by SORTNO');
      Open;

      if not(RecordCount = 0) then
      begin
        while not eof do
        begin
          lUser := lUser + FieldByName('NAME_KOR').AsString + ',';
          Next;
        end;
      end;
      lUser := Copy(lUser,0,LastDelimiter(',',lUser)-1);
      Result := lUser;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TmountedHistory_Frm.msTreeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lNode : TTreeNode;
  lstr : String;
  litem : TStringList;
begin
  lNode := msTree.GetNodeAt(X,Y);
  if not(engType.Text = '') then
  begin
    if Assigned(lNode) then
    begin
      litem := TStringList.Create;
      GDIPPictureContainer1.Items.Clear;
      try
        lstr := lNode.Text;
        ExtractStrings([';'],[],PChar(lstr),litem);

        FCurrentMSName := litem.Strings[0];
        FCurrentMsNo := litem.Strings[1];

        Set_Mounted_Info(FCurrentProjNo,FCurrentMSName,FCurrentMsNo);
      finally
        FreeAndNil(litem);
      end;
    end;
  end
  else
    raise Exception.Create('엔진타입을 선택하여 주십시오!');
end;

procedure TmountedHistory_Frm.Refresh_TreeView;
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

procedure TmountedHistory_Frm.Review_Tree(aParentMs: String;
  aTreeNode: TTreeNode);
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

procedure TmountedHistory_Frm.Set_Mounted_Info(aProjNo, aMsName, aMsNo: String);
var
  Tile : TAdvSmoothTile;
  lContent,
  lMountNo : String;
begin
  with TileList do
  begin
    BeginUpdate;
    Tiles.Clear;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_MS_MOUNTED ' +
                'where PROJNO = '''+aProjNo+''' ' +
                'and MSNO = '''+aMsNo+''' ' +
                'order by MOUNTNO');
        Open;

        if not(RecordCount = 0) then
        begin
          while not eof do
          begin
            lMountNo := FieldByName('MOUNTNO').AsString;

            Tile := Tiles.Add;
            Tile.Content.TextPosition := tpTopLeft;
            lContent := '';
            lContent := lContent +'부품사진        : ' + '<br/>';
            lContent := lContent + '<IMG src="'+Get_Flag_I_Picture(lMountNo)+'" width="200" height="120" style="float:right"/><br/>';
            lContent := lContent +'MS-Number       : ' + '<b>'+aMsNo+'</b><br/>';
            lContent := lContent +'MS 명           : ' + '<b>'+aMsName+'</b><br/>';
            lContent := lContent +'제 조 사        : ' + '<b>'+FieldByName('MAKER').AsString+'</b><br/>';
            lContent := lContent +'부품타입        : ' + '<b>'+FieldByName('Type_').AsString+'</b><br/>';
            lContent := lContent +'고유번호        : ' + '<b>'+FieldByName('SERIALNO').AsString+'</b><br/>';
            lContent := lContent +'엔진운전시간    : ' + '<b>'+FieldByName('ENG_RUN_TIME').AsString+'</b><br/>';
            lContent := lContent +'탑 재 일        : ' + '<b>'+FieldByName('MOUNTED').AsString+'</b><br/>';
            lContent := lContent +'작업자(HHI)     : ' + '<b>'+Get_HIMSEN_MS_WORKER(lMountNo)+'</b><br/>';
            lContent := lContent +'탑재 전 도면번호: ' + '<b>'+FieldByName('BDRAWNO').AsString+'</b><br/>';
            lContent := lContent +'탑재 후 도면번호: ' + '<b>'+FieldByName('ADRAWNO').AsString+'</b><br/>';
            lContent := lContent +'교체사유        : ' + '<b>'+FieldByName('REASON').AsString+'</b><br/>';
            Tile.Content.Text := lContent;

            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TmountedHistory_Frm.TileListResize(Sender: TObject);
Const
  lw = 345;
var
  lWidth : Integer;
  lResult : Double;
begin
  lWidth := TileList.Width;
  lResult := lWidth / lw;
  TileList.Columns := Round(lResult);
end;

end.
