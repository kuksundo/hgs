unit HimsenPartIndiSet_Unit;

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
  GDIPPictureContainer;
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
    PCODE : DOUBLE;
    PARTNAME : STRING;
  end;

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
  THimsenPartIndiSet_Frm = class(TForm)
    ImageList1: TImageList;
    AdvPopupMenu1: TAdvPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    JvBackground1: TJvBackground;
    AdvSmoothPanel1: TAdvSmoothPanel;
    EngineListBox: TAdvSmoothListBox;
    PartList: TAdvSmoothListBox;
    NxHeaderPanel1: TNxHeaderPanel;
    GradientLabel1: TGradientLabel;
    NxSplitter1: TNxSplitter;
    partTree: TTreeList;
    treeImg: TImageList;
    Panel1: TPanel;
    AdvSmoothTileListHTMLVisualizer1: TAdvSmoothTileListHTMLVisualizer;
    GradientLabel2: TGradientLabel;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Image2: TImage;
    GDIPPictureContainer1: TGDIPPictureContainer;
    Button6: TButton;
    idGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    partid: TNxEdit;
    Button3: TButton;
    NxTextColumn8: TNxTextColumn;
    Label3: TLabel;
    cylnum: TNxNumberEdit;
    position: TNxComboBox;
    Button4: TButton;
    NxCheckBoxColumn1: TNxCheckBoxColumn;
    procedure PartListItemSelected(Sender: TObject; itemindex: Integer);
    procedure MGridCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure EngineListBoxItemSelected(Sender: TObject; itemindex: Integer);
    procedure partTreeChange(Sender: TObject; Node: TTreeNode);
    procedure partTreeDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
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
    function Set_the_partTree_Root : Boolean;
    procedure Add_PARTCODE_to_partTree;
    procedure Set_selected_engine_Info(aProjNo:String);
    function Set_Part_Location(aNode:TTreeNode):String;

    procedure Get_HIMSEN_PART_ID(aProjNo,aRootNo,aPcode:String);

    function Check_for_new_Id : Boolean;
    procedure Add_new_Id;
    function Check_for_Delete_Id(aHimsenId:String) : Boolean;

  end;

var
  HimsenPartIndiSet_Frm: THimsenPartIndiSet_Frm;

implementation
uses
  CommonUtil_Unit,
  workerList_Unit,
  HiTEMS_ETH_CONST,
  DataModule_Unit;

{$R *.dfm}

{ TnewMounted_Frm }



{ TnewMounted_Frm }

procedure THimsenPartIndiSet_Frm.Add_new_Id;
var
 lKey : Int64;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into HIMSEN_ENGINE_PART_SET ' +
            'Values(:PROJNO, :ROOTNO, :PCODE, :HIMSENPARTID, :QTY, :POSITION,' +
            ':CYLNUM, :REGID, :REGDATE, :MODID, :MODDATE, :STATUS)');

    ParamByName('PROJNO').AsString      := FSelectedEngine.ProjNo;
    ParamByName('ROOTNO').AsFloat       := FselectedPartInfo.ROOTNO;
    ParamByName('PCODE').AsFloat        := FselectedPartInfo.PCODE;
    ParamByName('HIMSENPARTID').AsFloat := StrToFloat(partid.Text);
    ParamByName('QTY').AsInteger        := idGrid.RowCount;

    ParamByName('POSITION').AsString    := position.Text;
    ParamByName('CYLNUM').AsInteger     := cylNum.AsInteger;
    ParamByName('REGID').AsString       := CurrentUsers;
    ParamByName('REGDATE').AsDateTime   := Now;
    ParamByName('STATUS').AsInteger     := 0;

    ExecSQL;
  end;
end;

procedure THimsenPartIndiSet_Frm.Add_PARTCODE_to_partTree;
var
  lp,
  li: Integer;
  lnew, lNode : TTreeNode;
  lstr,
  litem,
  lroot : String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_PART_DESC_V order by rootno,sortno');
    Open;

    while not eof do
    begin
      lroot := FieldByName('ROOTNO').AsString;
      litem := FieldByName('PCODENM').AsString+';'+FieldByName('PCODE').AsString;
      with partTree.Items do
      begin
        BeginUpdate;
        try
          for li := 0 to Count-1 do
          begin
            lNode := Item[li];
            lp := pos(';',lNode.Text);

            if lp > 0 then
            begin
              lstr := Copy(lNode.Text,lp+1,Length(lNode.Text));

              if lstr = lroot  then
              begin
                lnew := AddChild(lNode,litem);
                lnew.ImageIndex := 1;
                lnew.Expanded := True;
                Break;
              end;
            end;
          end;
        finally
          EndUpdate;
        end;
      end;
      Next;
    end;
  end;
end;

procedure THimsenPartIndiSet_Frm.Button1Click(Sender: TObject);
var
  lResult : Boolean;
begin
  lResult := False;
  try
    if Check_for_new_Id = True then
    begin
      Add_new_Id;
      lResult := True;
    end;
  finally
    if lResult = True then
      partTreeDblClick(sender);

  end;
end;

procedure THimsenPartIndiSet_Frm.Button2Click(Sender: TObject);
begin
  partid.Clear;
  cylnum.Clear;
  position.Clear;
end;

procedure THimsenPartIndiSet_Frm.Button3Click(Sender: TObject);
var
  lKey : Int64;
begin
  lKey := DateTimeToMilliseconds(Now);
  partid.Text := FloatToStr(lKey);
end;

procedure THimsenPartIndiSet_Frm.Button4Click(Sender: TObject);
var
  li : integer;
begin
  If MessageDlg('한번 삭제된 정보는 복구할 수 없습니다. 계속 진행 하시겠습니까?'
    , mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
  begin
    with idGrid do
    begin
      BeginUpdate;
      try
        for li := 0 to RowCount-1 do
        begin
          if Cell[1,li].AsBoolean = True then
          begin
            if Check_for_Delete_Id(Cells[4,li]) = True then
            begin
              with DM1.OraQuery1 do
              begin
                Close;
                SQL.Clear;
                SQL.Add('Delete From HIMSEN_ENGINE_PART_SET ' +
                        'where HIMSENPARTID = '+Cells[4,li]);
                ExecSQL;
              end;
            end;
          end;
        end;
      finally
        partTreeDblClick(sender);
        EndUpdate;
      end;
    end;
  end;
end;

procedure THimsenPartIndiSet_Frm.Button6Click(Sender: TObject);
begin
  Close;
end;

function THimsenPartIndiSet_Frm.Check_for_Delete_Id(aHimsenId: String): Boolean;
var
  lResult : Boolean;
begin
  Result := True;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * from HIMSEN_MOUNTED_GROUP where HIMSENPARTID = '+aHimsenId);
    Open;

    if RecordCount > 0 then
    begin
      ShowMessage('현재 아이디로 탑재된 파트 정보가 존재합니다.'+#10#13+'삭제할 수 없습니다!');
      Exit;
      Result := False;
    end;
  end;
end;

function THimsenPartIndiSet_Frm.Check_for_new_Id: Boolean;
var
  li : integer;
begin
  Result := True;
  try
    if partid.Text = '' then
    begin
      Result := False;
      ShowMessage('파트고유번호를 생성하여 주십시오!');
      Exit;
    end;

    with idGrid do
    begin
      BeginUpdate;
      try
        for li := 0 to RowCount-1 do
        begin
          if cylnum.AsInteger > 0 then
          begin
            if Cells[4,li] = partid.Text then
            begin
              Result := False;
              ShowMessage('같은 파트고유번호가 존재 합니다.');
              Exit;
            end;

            if Cells[6,li] = cylnum.Text then
            begin
              Result := False;
              ShowMessage('같은 실린더 번호가 존재 합니다.');
              Exit;
            end;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  except
    Result := False;
  end;
end;

procedure THimsenPartIndiSet_Frm.EngineListBoxItemSelected(Sender: TObject;
  itemindex: Integer);
var
  lProjNo : String;
begin
  lProjNo := EngineListBox.Items[itemindex].Hint;
  Set_selected_engine_Info(lProjNo);
  idGrid.ClearRows;
//  Show_the_Available_Parts(lProjNo);
end;

procedure THimsenPartIndiSet_Frm.FormCreate(Sender: TObject);
var
  li : integer;
  lNode : TTreeNode;
begin
  idGrid.DoubleBuffered := False;
  //엔진 리스트박스 채우기
  if Set_Engine_List_Box = True then
  begin

    engineListBox.SelectedItemIndex := 0;
    Set_selected_engine_Info(EngineListBox.Items[0].Hint);
    //트리 구현
    partTree.Items.BeginUpdate;
    if Set_the_partTree_Root = True then
    begin
      try
        Add_PartCode_to_partTree;
      finally
        for li := 0 to partTree.Items.Count-1 do
        begin
          lNode := partTree.Items.Item[li];
          lNode.Expanded := True;
        end;
        partTree.Items.EndUpdate;
      end;
    end;
  end;
end;

procedure THimsenPartIndiSet_Frm.Get_HIMSEN_PART_ID(aProjNo, aRootNo,aPcode: String);
begin
  with idGrid do
  begin
    BeginUpdate;
    ClearRows;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_ENGINE_PART_V ' +
                ' where PROJNO = '''+aProjNo+''' ' +
                ' and ROOTNO = '+aRootNo+
                ' and PCODE = '+aPcode+
                ' order by HIMSENPARTID, CYLNUM');
        Open;

        if not(RecordCount = 0) then
        begin
          while not eof do
          begin
            AddRow;
            Cell[1,RowCount-1].AsBoolean := False;
            Cells[2,RowCount-1] := FieldByName('PROJNO').AsString;
            Cells[3,RowCount-1] := FieldByName('ENGTYPE').AsString;
            Cells[4,RowCount-1] := FieldByName('HIMSENPARTID').AsString;
            Cells[5,RowCount-1] := FieldByName('PCODENM').AsString;
            Cells[6,RowCount-1] := FieldByName('CYLNUM').AsString;

            Cells[7,RowCount-1] := FieldByName('POSITION').AsString;
            Cells[8,RowCount-1] := FieldByName('ROOTNO').AsString;
            Cells[9,RowCount-1] := FieldByName('PCODE').AsString;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure THimsenPartIndiSet_Frm.MGridCanEditCell(Sender: TObject; ARow, ACol: Integer;
  var CanEdit: Boolean);
begin
  if ACol = 4 then
    CanEdit := True
  else
    CanEdit := False;
end;

procedure THimsenPartIndiSet_Frm.PartListItemSelected(Sender: TObject;
  itemindex: Integer);
var
  LPartName : String;
  li : integer;

begin
  LPartName := PartList.Items[itemindex].Caption;
  GradientLabel1.Caption := '';
  GradientLabel1.Caption := FSelectedEngine.EngType +'-' + LPartName;


  //선택된 파트의 기준정보 가져오기!!

end;

procedure THimsenPartIndiSet_Frm.partTreeChange(Sender: TObject; Node: TTreeNode);
begin
  with partTree.Items do
  begin
    BeginUpdate;
    try
      if Node.Selected = True then
        Node.SelectedIndex := 2;

    finally
      EndUpdate;
    end;
  end;
end;

procedure THimsenPartIndiSet_Frm.partTreeDblClick(Sender: TObject);
var
  li : integer;
  lRootno,
  lPartcd,
  lStr : String;
  lNode : TTreeNode;
begin
  lNode := partTree.Selected;
  if lNode <> nil then
  begin
    Set_Part_Location(lNode);
    if lNode.ImageIndex = 1 then
    begin
      lStr := lNode.Parent.Text;
      li := Pos(';',lStr);
      if li > 0 then
      begin
        lRootno := Copy(lStr,li+1,Length(lStr)-li);
        FselectedPartInfo.ROOTNO := StrToFloat(lRootNo);
      end;

      lStr := lNode.Text;
      li := Pos(';',lStr);
      if li > 0 then
      begin
        FselectedPartInfo.PartName := Copy(lStr,0,li-1);
        lPartcd                    := Copy(lStr,li+1,Length(lStr)-li);
        FselectedPartInfo.PCODE    := StrToFloat(lPartcd);
      end;
    end;

    if not(lRootNo = '') and not(lPartcd = '') then
    begin
      Get_HIMSEN_PART_ID(FSelectedEngine.ProjNo,lRootno,lPartcd);
    end;
  end;
end;


function THimsenPartIndiSet_Frm.Set_Engine_List_Box: Boolean;
var
  LCaption : String;
begin
  Result := False;
  EngineListBox.Items.Clear;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HiMSENINFO ');
    SQL.Add('order by ProjNo, EngType');
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

function THimsenPartIndiSet_Frm.Set_Part_Location(aNode: TTreeNode): String;
var
  lNode : TTreeNode;
  lstr : String;
  li : integer;
  list : TStringList;

begin
  list := TStringList.Create;
  try
    lNode := aNode;
    lstr := lNode.Text;
    li := pos(';',lstr);
    list.Add(Copy(lstr,0,li-1));
    while not(lNode.Level = 0) do
    begin
      lNode := lNode.Parent;
      lstr := lNode.Text;
      li := pos(';',lstr);
      list.Add(Copy(lstr,0,li-1));
    end;

    lstr := '';
    try
      for li := list.Count-1 DownTo 0 do
        lstr := lstr + list.Strings[li] + '→';
    finally
      Delete(lstr,Length(lstr),1);
      GradientLabel1.Caption := lstr;
    end;
  finally
    FreeAndNil(list);
  end;
end;

procedure THimsenPartIndiSet_Frm.Set_selected_engine_Info(aProjNo: String);
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

function THimsenPartIndiSet_Frm.Set_the_partTree_Root: Boolean;
var
  nNode,
  lNode: TTreeNode;
  lstr,lstr1: String;
  li,le: integer;
  lQuery : TOraQuery;
  lPrtNo : String;
begin
  Result := False;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_PART_ROOT START WITH LV = 0 '+
            'connect by prior ROOTNO = PRTROOT order siblings by rootno');
    Open;

    if not(RecordCount = 0) then
    begin
      with partTree.Items do
      begin
        BeginUpdate;
        Clear;
        lQuery := TOraQuery.Create(nil);
        lQuery.Session := DM1.OraSession1;
        try
          try
            for li := 0 to RecordCount-1 do
            begin
              lstr := FieldByName('ROOTNAME').AsString+';'+FieldByName('ROOTNO').AsString;
              if li = 0 then
              begin
                lNode := Add(nil,lstr);
              end
              else
              begin
                lprtNo := FieldByName('PRTROOT').AsString;
                with lQuery do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Add('select * from HIMSEN_PART_ROOT where ROOTNO = '+lprtNo);
                  Open;

                  if not(RecordCount = 0) then
                  begin
                    lstr1 := FieldByName('ROOTNAME').AsString+';'+FieldByName('ROOTNO').AsString;
                    for le := 0 to Count-1 do
                    begin
                      if Item[le].Text = lstr1 then
                      begin
                        lNode := Item[le];
                        Break;
                      end;
                    end;
                    addChild(lNode,lstr);
                  end;
                end;
              end;
              Next;
            end;
            partTree.Columns[1].Font.Color := clWhite;
            Result := True;
          except
            Result := False;
          end;
        finally
          EndUpdate;
          FreeAndNil(lQuery);
        end;
      end;
    end;
  end;
end;


end.


