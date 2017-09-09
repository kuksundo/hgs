unit HimsenPartSet_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxEdit, Vcl.StdCtrls, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, DBAdvGrid, Vcl.ExtCtrls, NxCollection, GradientLabel,
  Vcl.ImgList, Data.DB, MemDS, DBAccess, Ora, Vcl.ExtDlgs, AdvEdit, AdvEdBtn,
  AdvNavBar, Vcl.ComCtrls, NxColumnClasses, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, JvExStdCtrls, JvEdit,
  NxAutoCompletion, AdvSmoothListBox, AdvSmoothPageSlider, TreeList, CommCtrl;
type
  TSelectedEngine = Record
    ProjNo,
    EngType,
    AlignType : String;
    NumofCyl : integer;
  end;
type
  THimsenPartSet_Frm = class(TForm)
    AdvSmoothPageSlider1: TAdvSmoothPageSlider;
    AdvSmoothPageSlider11: TAdvSmoothPage;
    AdvSmoothPageSlider12: TAdvSmoothPage;
    Panel1: TPanel;
    partGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxCheckBoxColumn1: TNxCheckBoxColumn;
    NxTextColumn1: TNxTextColumn;
    NxNumberColumn1: TNxNumberColumn;
    Panel2: TPanel;
    Button1: TButton;
    Panel4: TPanel;
    Panel8: TPanel;
    Button2: TButton;
    NxTextColumn2: TNxTextColumn;
    engineListBox: TAdvSmoothListBox;
    partTree: TTreeList;
    Panel10: TPanel;
    Panel11: TPanel;
    Button7: TButton;
    Button8: TButton;
    GradientLabel2: TGradientLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ptnm: TNxEdit;
    ptcd: TNxEdit;
    ptqty: TNxNumberEdit;
    treeImg: TImageList;
    rtcd: TNxEdit;
    rtnm: TNxEdit;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    ImageList1: TImageList;
    Panel3: TPanel;
    specGrid: TAdvStringGrid;
    Panel9: TPanel;
    Button3: TButton;
    Timer1: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EngineListBoxItemSelected(Sender: TObject; itemindex: Integer);
    procedure FuelListBoxItemSelected(Sender: TObject; itemindex: Integer);
    procedure AdvSmoothPageSlider1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure specGridGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure specGridGetCellBorder(Sender: TObject; ARow, ACol: Integer;
      APen: TPen; var Borders: TCellBorders);
    procedure specGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure Button3Click(Sender: TObject);
    procedure partGridChange(Sender: TObject; ACol, ARow: Integer);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure partGridHeaderClick(Sender: TObject; ACol: Integer);
    procedure Button1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure partTreeChange(Sender: TObject; Node: TTreeNode);
    procedure partTreeDblClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure partGridDblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FFirst,
    FCheckAll : Boolean;
    FSelectedEngine : TSelectedEngine;
  public
    { Public declarations }
    function Set_Engine_List_Box : Boolean;
    function Set_the_partTree_Root : Boolean;
    procedure Add_PartCode_to_partTree;
    procedure Set_selected_engine_Info(aProjNo:String);
    function Check_for_PartCode(aProjNo,aRootNo,aPartCd:String):Boolean;


    procedure Show_the_Available_Parts(aEngProj:String);
    procedure Check_for_Used_Parts(aEngProj:String);

    function Check_for_Parts_Status : Boolean;

    function set_Key_Id : String;
    function set_Part_Position(aNumofpart,aIdx:Integer) : String;
    function set_CylinderNum(aNumofpart,aIdx:Integer) : Integer;

    procedure Mounted_the_Parts;
    procedure reset_the_specGrid;

    procedure Add_new_Part_ID(aCnt,aNumofpart,aStatus:Integer;aPartname, aFlag:String);
    procedure Disable_Part_ID(aCnt:Integer;aPartname:String);

    procedure Get_Registered_Part_Info(aEngProj:String);

    procedure Create_HiMSEN_PART_ID;
  end;

var
  HimsenPartSet_Frm: THimsenPartSet_Frm;

implementation
uses
  HiTEMS_ETH_CONST,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

procedure THimsenPartSet_Frm.Add_new_Part_ID(aCnt,aNumofpart,aStatus: Integer; aPartname,
  aFlag: String);
var
  li: Integer;
begin
  with specGrid do
  begin
    try
    BeginUpdate;
    AutoSize := False;
      for li := 0 to aCnt-1 do
      begin
        AddRow;
        Cells[1,RowCount-1] := aPartname;
        Cells[2,RowCount-1] := set_Key_Id;
        Cells[3,RowCount-1] := aFlag;
        Cells[4,RowCount-1] := IntToStr(aNumofpart);
        Cells[5,RowCount-1] := set_Part_Position(aNumofpart,aNumofpart-1);

//        Cells[6,RowCount-1] := IntToStr(FSelectedEngine.NumofCyl);
//        Cells[7,RowCount-1] := FSelectedEngine.FuelType;
//        Cells[8,RowCount-1] := FSelectedEngine.ProjNo;
//        Cells[9,RowCount-1] := FSelectedEngine.EngType;
        Cells[10,RowCount-1] := IntToStr(aStatus);
        sleep(50);
      end;
    finally
      if Cells[1,1] = '' then
        RemoveRows(1,1);

      AutoSize := True;
      EndUpdate;
    end;
  end;
end;

procedure THimsenPartSet_Frm.Add_PartCode_to_partTree;
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

procedure THimsenPartSet_Frm.AdvSmoothPageSlider1Change(Sender: TObject);
begin
  if AdvSmoothPageSlider1.ActivePageIndex = 1 then
    Panel8.Visible := True
  else
    Panel8.Visible := False;
end;

procedure THimsenPartSet_Frm.Button1Click(Sender: TObject);
var
  le : integer;
  li : integer;
begin
  with partGrid do
  begin
    le := 0;
    for li := 0 to RowCount-1 do
    begin
      if Cell[0,li].TextColor = clBlue then
        inc(le);
    end;
  end;

  if le > 0 then
  begin
    If MessageDlg('한번 저장된 파트정보는 수정할 수 없습니다. 계속 진행 하시겠습니까?'
      , mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
    begin
      with specGrid do
      begin
        try
          BeginUpdate;
          Create_HiMSEN_PART_ID;
        finally
          if Cells[1,1] = '' then
            RemoveRows(1,1);
          if RowCount > 2 then
          begin
            Group(1);
            for le := 1 to RowCount-1 do
              if IsNode(le) then
                MergeCells(1,le,ColCount,1);
          end;
          EndUpdate;
        end;
      end;
    end;
  end
  else
    ShowMessage('생성할 아이템이 없습니다.');
end;

procedure THimsenPartSet_Frm.Button2Click(Sender: TObject);
begin
  AdvSmoothPageSlider1.ActivePageIndex := 0;  

end;

procedure THimsenPartSet_Frm.Button3Click(Sender: TObject);
begin
  if specGrid.RowCount > 2 then
  begin
      Mounted_the_Parts;
  end;
end;

procedure THimsenPartSet_Frm.Button5Click(Sender: TObject);
var
  li,
  le,
  lc,
  lcnt,
  LNumOfPart,
  LnewCnt : Integer;
  LPARTNAME,
  LFLAG,
  LSTATUS : String;
  lSTATUSCOLOR,
  LTextColor : TColor;

begin
  specGrid.UnGroup;
  with partGrid do
  begin
    for li := 0 to RowCount-1 do
    begin
      LFLAG     := Cells[2,li];
      LPARTNAME := Cells[3,li];
      LNumOfPart := StrToInt(Cells[4,li]);
      lSTATUSCOLOR := Cell[2,li].TextColor;

      if Cell[1,li].AsBoolean = True then
        LSTATUS := '0'
      else
        LSTATUS := '1';

      if lSTATUSCOLOR = 255 then
      begin
        for le := 1 to specGrid.RowCount-1 do
        begin
          if (LPARTNAME = specGrid.Cells[1,le]) then
          begin

            if (LSTATUS <> specGrid.Cells[10,le]) then
            begin
              case StrToInt(LSTATUS) of
                0 : LTextColor := clBlue;
                1 : LTextColor := clSilver;
              end;
              specGrid.Cells[10,le] := LSTATUS;

              for lc := 0 to specGrid.ColCount-1 do
                specGrid.FontColors[lc,le] := LTextColor;
            end;

            lcnt := StrToInt(specGrid.Cells[4,le]);
            if (LNumOfPart <>  lcnt)then
            begin
              if LNumOfPart > lcnt then
              begin
                //Add new Part
                LnewCnt := (LNumOfPart - lcnt);
                Add_new_Part_ID(LnewCnt,LNumOfPart,0,LPARTNAME,LFLAG);
              end
              else
              begin


                //change status
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure THimsenPartSet_Frm.Button6Click(Sender: TObject);
begin
  reset_the_specGrid;
end;

procedure THimsenPartSet_Frm.Button7Click(Sender: TObject);
var
  lRow,
  li : integer;
  lChk : Boolean;

begin
  if ptqty.Value > 0 then
  begin
    with partGrid do
    begin
      BeginUpdate;
      try
        lChk := True;
        for li := 0 to RowCount-1 do
        begin
          if (Cells[5,li] = rtCd.Text) and (Cells[6,li] = ptcd.Text) then
          begin
            if not(Cell[5,li].TextColor = clRed) then
            begin
              lRow := li;
              lChk := True;
              Break;
            end
            else
            begin
              lChk := False;
            end;
          end;
        end;

        if lChk = True then
        begin
          Cell[4,lRow].AsInteger := StrToInt(ptqty.Text);

          for li := 0 to Columns.Count-1 do
            Cell[li,lRow].TextColor := clBlue;
        end
        else
        begin
          ShowMessage('이미 같은 아이템이 등록되어 있습니다.');
          Exit;
        end;
      finally
        EndUpdate;

      end;
    end;
  end
  else
    ShowMessage('탑재수량을 확인하여 주십시오!');
end;

function THimsenPartSet_Frm.Check_for_PartCode(aProjNo,aRootNo,
  aPartCd: String): Boolean;
begin
  Result := False;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_ENGINE_PART_SET ' +
            'where PROJNO = '''+aProjNo+'''' +
            'and ROOTNO = '''+aRootNo+'''' +
            'and PCODE = '''+aPartCd+'''');
    Open;

    if not(RecordCount = 0) then
      Result := False
    else
      Result := True;
  end;
end;

function THimsenPartSet_Frm.Check_for_Parts_Status: Boolean;
var
  li : integer;
begin
  Result := True;
  with partGrid do
  begin
    for li := 0 to RowCount-1 do
    begin
      if (Cell[1,li].AsBoolean = True) and (Cell[4,li].AsInteger <= 0) then
        Result := False;
      
    end;
  end;
end;

procedure THimsenPartSet_Frm.Check_for_Used_Parts(aEngProj: String);
var
  li,le : integer;
  LStatus : Integer;
  lQty,
  lRootno,
  lPcode : String;
begin
  with partGrid do
  begin
    BeginUpdate;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_ENGINE_PART_V ');
        SQL.Add('where PROJNO = '''+aEngProj+'''');
        Open;

        if not(RecordCount = 0) then
        begin
          while not eof do
          begin
            lRootno := FieldByName('ROOTNO').AsString;
            lPcode  := FieldByName('PCODE').AsString;
            lQty    := FieldByName('QTY').AsString;
            LStatus := FieldByName('STATUS').AsInteger;

            for li := 0 to partGrid.RowCount-1 do
            begin
              if (lROOTNO = partGrid.Cells[5,li]) and
                 (lPCODE = partGrid.Cells[6,li])then
              begin
                for le := 0 to Columns.Count-1 do
                  partGrid.Cell[le,li].TextColor := clRed;

                partGrid.Cells[4,li] := lQty;
                case LStatus of
                  0 : partGrid.Cell[1,li].AsBoolean := True;
                  1 : partGrid.Cell[1,li].AsBoolean := False;
                end;
                Break;
              end;
            end;
            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure THimsenPartSet_Frm.Create_HiMSEN_PART_ID;
var
  li,
  le,
  lno,
  lQty,
  lStatus : Integer;

  lCheck : Boolean;

  lProjNo,
  lRootNo,
  lPartCd,
  lPartName : String;

  lTextColor : TColor;
begin
  if Check_for_Parts_Status then
  begin
    lProjNo := FSelectedEngine.ProjNo;
    with specGrid do
    begin
      try
        BeginUpdate;

        for li := 0 to partGrid.RowCount-1 do
        begin
          lTextColor := partGrid.Cell[0,li].TextColor;
          if not(lTextColor = 255) then //255 = clRed
          begin
            lno        := partGrid.Cell[0,li].AsInteger;
            lCheck     := partGrid.Cell[1,li].AsBoolean;
            lPartName  := partGrid.Cells[3,li];
            lQty       := StrToInt(partGrid.Cells[4,li]);
            lRootNo    := partGrid.Cells[5,li];
            lPartCd    := partGrid.Cells[6,li];

            if partGrid.Cell[1,li].AsBoolean = True then
              lStatus := 0
            else
              lStatus := 1;

            if lCheck = True then
            begin
              for le := 0 to lQty-1 do
              begin
                AddRow;
//                Cells[1,RowCount-1]  := Char(67+lno)+'.'+lPartName;
                Cells[1,RowCount-1]  := lPartName;
                Cells[2,RowCount-1]  := set_Key_Id;
                Cells[3,RowCount-1]  := lRootNo;
                Cells[4,RowCount-1]  := lPartCd;
                Cells[5,RowCount-1]  := IntToStr(lQty);
                Cells[6,RowCount-1]  := set_Part_Position(lQty,le);

                Cells[7,RowCount-1]  := IntToStr(set_CylinderNum(lQty,le));
                Cells[8,RowCount-1]  := FSelectedEngine.ProjNo;
                Cells[9,RowCount-1]  := FSelectedEngine.EngType;
                Cells[10,RowCount-1] := IntToStr(lStatus);
                sleep(50);
              end;
            end;
          end;
        end;
      finally
        AutoSize := True;
        EndUpdate;
      end;
    end;
    AdvSmoothPageSlider1.ActivePageIndex := 1;
  end
  else
    ShowMessage('파트 선택 또는 탑재수량을 확인하십시오');

end;

procedure THimsenPartSet_Frm.Disable_Part_ID(aCnt: Integer; aPartname: String);
var
  li,
  le,
  lc : Integer;
  LSTATUS,
  LPartID : String;
  LTextColor : TColor;
begin
  for li := 0 to aCnt do
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HiMSEN_ENGINE_PART_ID_VIEW ' +
              'where PartName = '''+aPartName+''' and ' +
              'STATUS != 1 order by PARTID DESC');
      Open;

      LPartID := Fieldbyname('PARTID').AsString;
    end;

    if not(LPartID = '') then
    begin
      for le := 0 to SpecGrid.RowCount-1 do
      begin
        if LPartID = specGrid.Cells[2,li] then
        begin
          LSTATUS := '1';
          case StrToInt(LSTATUS) of
            0 : LTextColor := clBlue;
            1 : LTextColor := clSilver;
          end;
          specGrid.Cells[10,le] := LSTATUS;

          for lc := 0 to specGrid.ColCount-1 do
            specGrid.FontColors[lc,le] := LTextColor;

        end;
      end;
    end;
  end;
end;

procedure THimsenPartSet_Frm.EngineListBoxItemSelected(Sender: TObject;
  itemindex: Integer);
var
  lProjNo : String;
begin
  lProjNo := EngineListBox.Items[itemindex].Hint;
  Set_selected_engine_Info(lProjNo);
  Show_the_Available_Parts(lProjNo);
  AdvSmoothPageSlider1.ActivePageIndex := 0;

end;

procedure THimsenPartSet_Frm.FormActivate(Sender: TObject);
var
  li : integer;
  lNode : TTreeNode;
begin
  if FFirst = True then
  begin
    FFirst := False;
    Timer1.Enabled := True;
  end;
end;

procedure THimsenPartSet_Frm.FormCreate(Sender: TObject);
begin
  FFirst := True;
  FCheckAll := False;
  partGrid.DoubleBuffered := False;
  AdvSmoothPageSlider1.ActivePageIndex := 0;

end;

procedure THimsenPartSet_Frm.FormResize(Sender: TObject);
begin
  Invalidate;
end;

procedure THimsenPartSet_Frm.FuelListBoxItemSelected(Sender: TObject;
  itemindex: Integer);
var
  LFuel : String;
begin
//  FSelectedEngine.FuelType := LFuel;
  AdvSmoothPageSlider1.ActivePageIndex := 0;
  partGrid.ClearRows;

//  reset_the_specGrid;
end;

procedure THimsenPartSet_Frm.Get_Registered_Part_Info(aEngProj: String);
var
  li : integer;
  LStr : String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select A.*, B.FLAGNO from HIMSEN_ENGINE_PART_ID A, HIMSEN_PART_FLAG B '+
            'where PROJNO = '''+aEngProj+'''  and A.FLAG = B.FLAG order by FLAGNO, HIMSENPARTID');
    Open;

    if not(RecordCount = 0) then
    begin
      with specGrid do
      begin
        try
          BeginUpdate;
          AutoSize := False;
          UnGroup;

          for li := 0 to RecordCount-1 do
          begin
            LStr := Char(96+FieldByName('FLAGNO').AsInteger)+'.'+
                             FieldByName('PARTNAME').AsString;
            Cells[1,RowCount-1]   := LStr;
            Cells[2,RowCount-1]   := FieldByName('HIMSENPARTID').AsString;
            Cells[3,RowCount-1]   := FieldByName('FLAG').AsString;
            Cells[4,RowCount-1]   := IntToStr(FieldByName('NUMOFPART').AsInteger);
            Cells[5,RowCount-1]   := FieldByName('POSITION').AsString;

            Cells[6,RowCount-1]   := IntToStr(FieldByName('CYLNUM').AsInteger);
            Cells[7,RowCount-1]   := FieldByName('FUELTYPE').AsString;
            Cells[8,RowCount-1]   := FieldByName('PROJNO').AsString;
            Cells[9,RowCount-1]   := FieldByName('ENGTYPE').AsString;
            Cells[10,RowCount-1]  := IntToStr(FieldByName('STATUS').AsInteger);

            AddRow;
            Next;
          end;
          RemoveRows(RowCount,1);
        finally
          if RowCount > 2 then
          begin
            Group(1);
            for li := 1 to RowCount-1 do
            begin
              if IsNode(li) then
                MergeCells(1,li,ColCount,1);
            end;
          end;
          AutoSize := True;
          EndUpdate;
        end;
      end;
    end;
  end;
end;

procedure THimsenPartSet_Frm.Mounted_the_Parts;
var
  li : integer;
  lPartname : String;
  lPos : integer;
begin
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Insert Into HIMSEN_ENGINE_PART_SET');
      SQL.Add('values(:PROJNO, :ROOTNO, :PCODE, :HIMSENPARTID, :QTY,' +
              ':POSITION, :CYLNUM, :REGID, :REGDATE, :MODID, :MODDATE, :STATUS)');

      with specGrid do
      begin
        try
          BeginUpdate;
          unGroup;
          for li := 1 to RowCount-1 do
          begin
            ParamByName('PROJNO').AsString      := Cells[8,li];
            ParamByName('ROOTNO').AsFloat       := StrToFloat(Cells[3,li]);
            ParamByName('PCODE').AsFloat        := StrToFloat(Cells[4,li]);
            ParamByName('HIMSENPARTID').AsFloat := StrToFloat(Cells[2,li]);
            ParamByName('QTY').AsInteger        := StrToInt(Cells[5,li]);

            ParamByName('POSITION').AsString    := Cells[6,li];
            ParamByName('CYLNUM').AsInteger     := StrToInt(Cells[7,li]);
            ParamByName('REGID').AsString       := CurrentUsers;
            ParamByName('REGDATE').AsDateTime   := Now;

  //          ParamByName('MODID').AsString     := Cells[2,li];
  //          ParamByName('MODDATE').AsDateTime := Cells[2,li];
            ParamByName('STATUS').AsInteger   := 0;
            ExecSQL;
          end;
        finally
          if RowCount > 2 then
          begin
            Group(1);
            for li := 1 to RowCount-1 do
            begin
              if IsNode(li) then
                MergeCells(1,li,ColCount,1);
            end;
          end;
          EndUpdate;
        end;
      end;
    end;
    ShowMessage('파트등록 성공!!');
  except
    ShowMessage('파트등록 실패!!');
  end;
end;

procedure THimsenPartSet_Frm.partGridChange(Sender: TObject; ACol, ARow: Integer);
var
  li : integer;
begin
  with partGrid do
  begin
    BeginUpdate;
    try
      if ACol = 4 then
      begin
        if Cell[4,ARow].AsInteger > 0 then
        begin
          Cell[1,ARow].AsBoolean := True;
          for li := 0 to Columns.Count-1 do
            Cell[li,ARow].TextColor := clBlue;

        end
        else
        begin
          Cell[1,ARow].AsBoolean := False;
          for li := 0 to Columns.Count-1 do
            Cell[li,ARow].TextColor := clBlack;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure THimsenPartSet_Frm.partGridDblClick(Sender: TObject);
var
  lRow : Integer;
  lroot,
  lfStr : String;
  li : integer;
  lNode : TTreeNode;

begin
  with partGrid do
  begin
    lRow := SelectedRow;
    if not(Cell[2,lRow].TextColor = clRed) then
    begin
      rtnm.Text := Cells[2,lRow];
      rtcd.Text := Cells[5,lRow];
      ptnm.Text := Cells[3,lRow];
      ptcd.Text := Cells[6,lRow];

      ptQty.Text := Cells[4,lRow];

      lfStr := ptnm.Text+';'+ptcd.Text;
      lroot := rtnm.Text+';'+rtcd.Text;
    end;

    with partTree.Items do
    begin
      BeginUpdate;
      try
        for li := 0 to Count-1 do
        begin
          lNode := Item[li];
          if lNode.Text = lfStr then
          begin
            if lNode.Parent.Text = lroot then
            begin
              Item[li].Selected := True;
              Break;
            end;
          end;
        end;
      finally
        SetFocus;
        EndUpdate;
      end;
    end;
  end;
end;

procedure THimsenPartSet_Frm.partGridHeaderClick(Sender: TObject; ACol: Integer);
var
  li : integer;
  LCheckAll : Boolean;
begin
  if ACol = 1 then
  begin
    if FCheckAll = True then
      FCheckAll := False
    else
      FCheckAll := True;

    for li := 0 to partGrid.RowCount-1 do
      partGrid.Cell[1,li].AsBoolean := FCheckAll;


  end;
end;

procedure THimsenPartSet_Frm.partTreeChange(Sender: TObject; Node: TTreeNode);
const
  LastZone = 30;
var
  TreeView: TTreeView absolute Sender;
  NodeRect: TRect;
  DownUp: Integer;
  procedure Scroll(IsDown: Boolean);
  const
    SB: array[Boolean] of Integer = (SB_LINEUP, SB_LINEDOWN);
  begin
    SendMessage( TreeView.Handle, WM_VSCROLL, MakeLong( SB[ IsDown ], 1 ), 0 );
  end;
begin
  if Node <> nil then
  begin
    if TreeView.Selected <> nil then
    begin
      Node.SelectedIndex := 2;
      if TreeView.Selected.AbsoluteIndex < Node.AbsoluteIndex then DownUp := 1
     else
      if TreeView.Selected.AbsoluteIndex > Node.AbsoluteIndex then DownUp := 2
                                                              else DownUp := 0;
    end
    else
    DownUp := 0;

    TreeView_GetItemRect( TreeView.Handle, Node.ItemId, NodeRect, False );

    if ( NodeRect.Bottom > TreeView.ClientHeight - LastZone ) and
       ( DownUp = 1 ) then Scroll( True )
    else
    if ( NodeRect.Top < LastZone ) and ( DownUp = 2 ) then Scroll( False );
   end;
end;


procedure THimsenPartSet_Frm.partTreeDblClick(Sender: TObject);
var
  li : integer;
  lRootNm,
  lRootNo,
  lPartnm,
  lPartcd,
  lStr : String;

  lNode : TTreeNode;
begin
  lNode := partTree.Selected;
  if lNode <> nil then
  begin
    if lNode.ImageIndex = 1 then
    begin
      lStr := lNode.Parent.Text;
      li := Pos(';',lStr);
      if li > 0 then
      begin
        lRootNm := Copy(lStr,0,li-1);
        lRootNo := Copy(lStr,li+1,Length(lStr)-li);
      end;

      lStr := lNode.Text;
      li := Pos(';',lStr);
      if li > 0 then
      begin
        lPartnm := Copy(lStr,0,li-1);
        lPartcd := Copy(lStr,li+1,Length(lStr)-li);
      end;

      if not(lRootNo = '') and not(lPartcd = '') then
      begin
        with partGrid do
        begin
          BeginUpdate;
          try
            for li := 0 to partGrid.RowCount-1 do
            begin
              if (Cells[5,li] = lRootNo) and (Cells[6,li] = lPartCd) then
              begin
                partGrid.SelectedRow := li;
                SetFocus;
                Break;
              end;
            end;
          finally
            EndUpdate;
          end;
        end;



        if Check_for_PartCode(FSelectedEngine.ProjNo, lRootNo, lPartCd) = True then
        begin
          ptnm.Text := lPartnm;
          ptcd.Text := lPartcd;
          rtcd.Text := lRootNo;
          rtnm.Text := lRootNm;
        end
        else
        begin
          ShowMessage('이미 등록된 코드가 있습니다.');
        end;
      end;
    end;
  end;
end;

procedure THimsenPartSet_Frm.reset_the_specGrid;
begin
  with specGrid do
  begin
    if RowCount > 2 then
    begin
      UnGroup;
      RemoveRows(2,RowCount-2);
      ClearRows(1,1);
    end;
  end;
end;

function THimsenPartSet_Frm.set_CylinderNum(aNumofpart,aIdx: Integer): Integer;
var
  lnum : integer;
begin
  lnum := Round(aNumofpart / 2);

  if lnum > 2 then
    Result := aIdx+1
  else
    Result := 0;
end;

function THimsenPartSet_Frm.Set_Engine_List_Box : Boolean;
var
  LCaption : String;
begin
  Result := False;
  EngineListBox.Items.Clear;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSENINFO ');
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

function THimsenPartSet_Frm.set_Key_Id : String;
var
  Key : Int64;
begin
  Key := DateTimeToMilliseconds(Now);
  Result := IntToStr(Key);
end;

function THimsenPartSet_Frm.set_Part_Position(aNumofpart,aIdx:Integer): String;
var
  lnum : integer;
begin
  lnum := Round(aNumofpart / 2)-1;

  if aNumofpart = 1 then
    Result := 'None';
  if aNumofpart = 2 then
    case aIdx of
      0 : Result := 'A-BANK';
      1 : Result := 'B-BANK';
    end;
  if aNumofpart > 2 then
  begin
    with FSelectedEngine do
    begin
      if AlignType = 'Vee-Type' then
      begin
        if lnum > 6 then
        begin
          if not(lnum < aIdx) then
            Result := 'A-BANK'
          else
            Result := 'B-BANK';
        end
        else
          Result := 'None';
      end;

      if AlignType = 'In-line Type' then
      begin
        Result := 'None';

      end;
    end;
  end;
end;

procedure THimsenPartSet_Frm.Set_selected_engine_Info(aProjNo: String);
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

function THimsenPartSet_Frm.Set_the_partTree_Root: Boolean;
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

procedure THimsenPartSet_Frm.Show_the_Available_Parts(aEngProj: String);
var
  li : integer;
begin
  with partGrid do
  begin
    try
      ClearRows;
      BeginUpdate;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HIMSEN_PART_DESC_V ' +
                'order by RootNo, PCODE');

        Open;

        if not(RecordCount = 0) then
        begin
          while not eof do
          begin
            AddRow(1);
            Cells[2,RowCount-1] := FieldByName('ROOTNAME').AsString;
            Cells[3,RowCount-1] := Fieldbyname('PCODENM').AsString;
//            Cells[4,RowCount-1] := Fieldbyname('QTY').AsString;
            Cells[5,RowCount-1] := Fieldbyname('ROOTNO').AsString;
            Cells[6,RowCount-1] := Fieldbyname('PCODE').AsString;
            Next;
          end;
        end;
      end;
    finally
      Check_for_Used_Parts(aEngProj);
      EndUpdate;
    end;
  end;
end;

procedure THimsenPartSet_Frm.specGridGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if not specGrid.IsNode(ARow) then
    HAlign := taCenter;

end;

procedure THimsenPartSet_Frm.specGridGetCellBorder(Sender: TObject; ARow,
  ACol: Integer; APen: TPen; var Borders: TCellBorders);
begin
  if not specGrid.IsNode(ARow) and (ARow > 0) then
    Borders := [cbLeft];
    APen.Color := clSilver;
end;

procedure THimsenPartSet_Frm.specGridGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  if specGrid.IsNode(aRow) then
  begin
    ABrush.Color := clGray;
    aFont.Color  := clWhite;
  end;
end;

procedure THimsenPartSet_Frm.Timer1Timer(Sender: TObject);
var
  li : integer;
  lNode : TTreeNode;
begin
  Timer1.Enabled := False;
  //엔진 리스트박스 채우기
  if Set_Engine_List_Box = True then
  begin

    engineListBox.SelectedItemIndex := 0;
    Set_selected_engine_Info(EngineListBox.Items[0].Hint);
    Show_the_Available_Parts(EngineListBox.Items[0].Hint);
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

end.
