unit managementPart_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ExtCtrls,
  Vcl.StdCtrls, GradientLabel, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,
  NxCollection, AdvSmoothPanel, AdvOfficeTabSet, Vcl.ExtDlgs, DB, MemDS,
  DBAccess, Ora, TaskDialog, Vcl.ImgList, AdvSmoothButton, GDIPPictureContainer,
  AdvSmoothPageSlider, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, AdvSmoothListBox,
  PictureContainer, AdvOfficeTabSetStylers, JvBackgrounds, Vcl.ComCtrls,
  TreeList;

type
  TSelectedPartInfo = Record
    PartName,
    PMaker,
    PTYPE : String;
    ROOTNO,
    PartCode : Double;
  end;

type
  TmanagementPart_Frm = class(TForm)
    OpenPictureDialog1: TOpenPictureDialog;
    OraQuery1: TOraQuery;
    DataSource1: TDataSource;
    PictureContainer1: TPictureContainer;
    ImageList1: TImageList;
    AdvOfficeTabSetOfficeStyler1: TAdvOfficeTabSetOfficeStyler;
    JvBackground1: TJvBackground;
    AdvSmoothPanel1: TAdvSmoothPanel;
    Image2: TImage;
    NxHeaderPanel4: TNxHeaderPanel;
    NxHeaderPanel1: TNxHeaderPanel;
    partGrid: TDBAdvGrid;
    NxSplitter1: TNxSplitter;
    NxHeaderPanel2: TNxHeaderPanel;
    GradientLabel1: TGradientLabel;
    GradientLabel2: TGradientLabel;
    NxImage1: TNxImage;
    Panel3: TPanel;
    Button1: TButton;
    Button5: TButton;
    specGrid: TAdvStringGrid;
    Panel2: TPanel;
    Button4: TButton;
    Button2: TButton;
    Panel1: TPanel;
    Button3: TButton;
    partTree: TTreeList;
    treeImg: TImageList;
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AdvInputTaskDialog1DialogInputGetText(Sender: TObject;
      var Text: string);
    procedure specGridCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure specGridGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure partGridDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure partTreeDblClick(Sender: TObject);
    procedure specGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure partTreeChange(Sender: TObject; Node: TTreeNode);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FFirst : Boolean;
    FInputKind : String;
    FxRow, FxCol : integer;
    FSelectedPartInfo : TSelectedPartInfo;

  public
    { Public declarations }
    function Set_the_partTree_Root : Boolean;
    procedure Add_PartCode_to_partTree;
    procedure Data_Save_Routine;

    procedure Set_of_the_Selected_Part_Info(aRootNo,aPcode:String);
    procedure Set_of_the_SpecGrid;

    function Input_of_the_Part_Spec_to_DB : Boolean;
    procedure Update_of_the_Part_Spec_to_DB;

    procedure Show_registered_image(aRow: Integer);
    procedure fill_to_the_specGrid(aRow:Integer);


  end;

var
  managementPart_Frm: TmanagementPart_Frm;

implementation
uses
  imagefunctions_Unit,
  Main_Unit,
  HiTEMS_ETH_CONST,
  newPartList_Unit,
  saveNotification_Unit,
  DataModule_Unit;

{$R *.dfm}

procedure TmanagementPart_Frm.Add_PartCode_to_partTree;
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
    SQL.Add('select * from HIMSEN_PART_DESC_V order by rootno, sortno');
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

procedure TmanagementPart_Frm.AdvInputTaskDialog1DialogInputGetText(
  Sender: TObject; var Text: string);
var
  LRadio : TRadioGroup;
begin
  LRadio := TRadioGroup(FindComponent('LChoose'));
  if Assigned(LRadio) then
    Text := IntToStr(LRadio.ItemIndex);
end;

procedure TmanagementPart_Frm.Button1Click(Sender: TObject);
begin
  NxImage1.Picture.Assign(nil);
  NxImage1.Invalidate;
end;

procedure TmanagementPart_Frm.Button2Click(Sender: TObject);
var
  li : integer;
begin
  with specGrid do
    for li := 1 to RowCount-1 do
      Cells[1,li] := '';

  NxImage1.Picture.Assign(nil);
  NxImage1.Invalidate;

  FInputKind := 'New';
  FSelectedPartInfo.PMaker := '';
  FSelectedPartInfo.PTYPE := '';


end;

procedure TmanagementPart_Frm.Button3Click(Sender: TObject);
begin
  main_Frm.Open_the_new_Part_Form;
end;

procedure TmanagementPart_Frm.Button4Click(Sender: TObject);
var
  lInputType : String;
begin
  if not(FSelectedPartInfo.RootNo = 0) and
     not(FSelectedPartInfo.PartCode = 0) and
     not(specGrid.Cells[1,1] = '') and
     not(specGrid.Cells[1,2] = '') then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add(' select * from HIMSEN_PART_SPECIFICATIONS ' +
              ' where ROOTNO = '+FloatToStr(FSelectedPartInfo.RootNo)+
              ' and PCODE = '+FloatToStr(FSelectedPartInfo.PartCode)+
              ' and MAKER = '''+specGrid.Cells[1,1]+''' '+
              ' and TYPE = '''+specGrid.Cells[1,2]+''' ');
      Open;

      if RecordCount > 0 then
        FInputKind := 'Update'
      else
        FInputKind := 'New';
    end;
    Data_Save_Routine;
  end;
end;

procedure TmanagementPart_Frm.Button5Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
    NxImage1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
end;

procedure TmanagementPart_Frm.Data_Save_Routine;
var
  li : integer;
  LStr : String;
  LSelectIdx : Integer;
  lRootNo,lPCODE : String;
begin
  with specGrid do
  begin
    if not(cells[1,1] = '') then
    begin
      if FInputKind = 'Update' then
      begin
        If MessageDlg('같은 타입으로 등록된 파트가 있습니다. 업데이트 하시겠습니까?'
          , mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
        begin
          Update_of_the_Part_Spec_to_DB;
        end;
      end;

      if FInputKind = 'New' then
      begin
        try
          Input_of_the_Part_Spec_to_DB;
          ShowMessage('파트저장 성공!!');
        except
          ShowMessage('error-line-175 : 알 수 없는 문제로 파트저장에 실패하였습니다.')
        end;
      end;
      lRootNo := FloatToStr(FSelectedPartInfo.ROOTNO);
      lPCODE := FloatToStr(FSelectedPartInfo.PartCode);
      Set_of_the_Selected_Part_Info(lRootNo, lPCODE);
    end
    else
      ShowMessage('TYPE 은 필수 입력 입니다!!');
  end;
end;

procedure TmanagementPart_Frm.fill_to_the_specGrid(aRow:Integer);
var
  li,le : integer;
  lv : String;

begin
  if not(FSelectedPartInfo.RootNo = 0) then
  begin
    with partGrid do
    begin
      for li := 1 to ColCount-1 do
      begin
        lv := Cells[li,aRow];
        for le := 1 to specGrid.RowCount-1 do
        begin
          if partGrid.Cells[li,0] = specGrid.Cells[4,le] then
          begin
            specGrid.Cells[1,le] := lv;
            Break;
          end;
        end;
      end;

      for li := 1 to ColCount-1 do
      begin
        if Cells[li,0] = 'MAKER' then
          FSelectedPartInfo.PMaker := Cells[li,ARow];
        if Cells[li,0] = 'TYPE' then
          FSelectedPartInfo.PTYPE := Cells[li,ARow];
      end;
      Show_registered_image(aRow);
      FInputKind := 'Update';
    end;
  end;
end;

procedure TmanagementPart_Frm.FormActivate(Sender: TObject);
begin
  if FFirst = True then
  begin
    FFirst := False;
  end;

end;

procedure TmanagementPart_Frm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TmanagementPart_Frm.FormCreate(Sender: TObject);
var
  lNode : TTreeNode;
  li : integer;
begin
  specGrid.DoubleBuffered := False;
  FSelectedPartInfo.PartName := '';
  FSelectedPartInfo.PMaker := '';
  FSelectedPartInfo.PTYPE := '';
  FSelectedPartInfo.RootNo := 0;
  FInputKind := 'New';

  if CurrentUsers = 'Y001613' then
    panel1.Visible := True
  else
    panel1.Visible := False;


  NxImage1.Picture.Assign(PictureContainer1.Items[0].Picture);
  NxImage1.Invalidate;

  //트리 구현
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

      with OraQuery1 do
      begin
        SQL.Clear;
        SQL.Add('select Maker, Type, PartNo, DwgNo, Remark from HIMSEN_PART_SPECIFICATIONS' );
        SQL.Add('where RootNo = 1003');
        Open;
      end;
      DataSource1.DataSet.Refresh;
    end;
  end;
end;

function TmanagementPart_Frm.Input_of_the_Part_Spec_to_DB : Boolean;
var
  lTypeNo,
  li,le : integer;
  LSQL : String;
  LSubject : String;
  LMS : TMemoryStream;
  LInBitmap : TBitmap;
  LParam : String;
  LPartNo : Integer;
begin
  with specGrid do
  begin
    try
      LSQL := 'Insert Into HIMSEN_PART_SPECIFICATIONS (ROOTNO, PCODE, IMAGES, STATUS, REGID, REGDATE,';

      for li := 1 to RowCount-1 do
        LSQL := LSQL + Cells[4,li]+',';

      LSQL := Copy(LSQL,0,(Length(LSQL)-1));
      LSQL := LSQL + ')';
      LSQL := LSQL + 'Values(:ROOTNO, :PCODE, :IMAGES, :STATUS, :REGID, :REGDATE,';

      for li := 1 to RowCount-1 do
        LSQL := LSQL +':'+ Cells[4,li]+',';

      LSQL := Copy(LSQL,0,(Length(LSQL)-1));
      LSQL := LSQL + ')';

      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add(LSQL);
        ParamByName('ROOTNO').AsFloat      := FSelectedPartInfo.RootNo;
        ParamByName('PCODE').AsFloat       := FSelectedPartInfo.PartCode;
        ParamByName('STATUS').AsInteger    := 0;
        ParamByName('REGID').AsString      := CurrentUsers;
        ParamByName('REGDATE').AsDateTime  := NOW;

        for li := 1 to RowCount -1 do
        begin
          LParam := Cells[4,li];

          if lParam = 'MAKER' then
            FSelectedPartInfo.PMaker := Cells[1,li];
          if lParam = 'TYPE' then
            FSelectedPartInfo.PTYPE := Cells[1,li];


          if Cells[2,li] = 'VARCHAR2' then
            ParamByName(LParam).AsString  := Cells[1,li];
          if Cells[2,li] = 'NUMBER' then
            ParamByName(LParam).AsFloat   := StrToFloat(Cells[1,li]);
          if Cells[2,li] = 'INTEGER' then
            ParamByName(LParam).AsInteger := StrToInt(Cells[1,li]);
        end;

        LMS := nil;
        LInBitmap  := nil;
        if NxImage1.Picture.Graphic <> nil then
        begin
          LMS := TMemoryStream.Create;
          LInBitmap := TBitmap.Create;
          LInBitmap.Assign(NxImage1.Picture.Graphic);
          LInBitmap.SaveToStream(LMS);

          ParamByName('IMAGES').ParamType := ptInput;
          ParamByName('IMAGES').AsOraBlob.LoadFromStream(LMS);
        end;
        ExecSQL;

        FInputKind := 'Update';
      end;
    finally
      if not(LMS = nil) then
        FreeAndNil(LMS);
      if not(LInBitmap = nil) then
        FreeAndNil(LInBitmap);
    end;
  end;
end;

procedure TmanagementPart_Frm.partGridDblClickCell(Sender: TObject; ARow,
  ACol: Integer);
begin
  if (ACol > 0) and (ARow > 0) then
  begin
    if not(partGrid.Cells[1,ARow] = '') then
      fill_to_the_specGrid(ARow);
  end;
end;

procedure TmanagementPart_Frm.partTreeChange(Sender: TObject; Node: TTreeNode);
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

procedure TmanagementPart_Frm.partTreeDblClick(Sender: TObject);
var
  li : integer;
  lRootno,
  lPartcd,
  lStr : String;


  lNode : TTreeNode;
begin
  NxImage1.Picture.Assign(nil);
  NxImage1.Invalidate;

  lNode := partTree.Selected;
  if lNode <> nil then
  begin
    if lNode.ImageIndex = 1 then
    begin
      lStr := lNode.Parent.Text;
      li := Pos(';',lStr);
      if li > 0 then
      begin
        lRootno := Copy(lStr,li+1,Length(lStr)-li);
        FSelectedPartInfo.RootNo := StrToFloat(lRootno);
      end;

      lStr := lNode.Text;
      li := Pos(';',lStr);
      if li > 0 then
      begin
        FSelectedPartInfo.PartName := Copy(lStr,0,li-1);
        lPartcd := Copy(lStr,li+1,Length(lStr)-li);
        FSelectedPartInfo.PartCode := strToFloat(lPartcd);

        Set_of_the_Selected_Part_Info(lRootno,lPartcd);

        FInputKind := 'New';
        Set_of_the_SpecGrid;
      end;
    end
    else
    begin
      with OraQuery1 do
      begin
        SQL.Clear;
        SQL.Add('select Maker, Type, PartNo, DwgNo, Remark from HIMSEN_PART_SPECIFICATIONS' );
        SQL.Add('where RootNo = 1003');
        Open;
      end;
      DataSource1.DataSet.Refresh;

    end;
  end;
end;

procedure TmanagementPart_Frm.Set_of_the_Selected_Part_Info(aRootNo,aPcode:String);
var
  LStr,
  LSQL : String;
  LSubjList : TStringList;
  li: Integer;
begin
  try
    LSubjList := nil;

    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HIMSEN_PART_GRP_V');
      SQL.Add('where ROOTNO = '+aRootNo);
      SQL.Add('and PCODE = '+aPcode);
      SQL.Add(' order by RootNo, GRPNO');
      Open;

      if not(RecordCount = 0) then
      begin
        LSubjList := TStringList.Create;
        while not eof do
        begin
          LSubjList.Add(FieldByName('SUBJECT_').AsString);
          Next;
        end;
      end;
    end;

    if not(LSubjList = nil) then
    begin
      LSQL := 'select ';
      try
        for li := 0 to LSubjList.Count-1 do
          LSQL := LSQL + LSubjList.Strings[li]+',';
      finally
        Delete(LSQL,Length(LSQL),1);
      end;
      LSQL := LSQL + ' from HIMSEN_PART_SPECIFICATIONS';
      LSQL := LSQL + ' where ROOTNO = '+aRootNo;
      LSQL := LSQL + ' and PCODE = '+aPcode;

      with OraQuery1 do
      begin
        with partGrid do
        begin
          try
            BeginUpdate;
            AutoSize := False;
            Close;
            SQL.Clear;
            SQL.Add(LSQL);
            Open;
            DataSource1.DataSet.Refresh;
          finally
            AutoSize := True;
            EndUpdate;
          end;
        end;
      end;
    end;
  finally
    if not(LSubjList = nil) then
      FreeAndNil(LSubjList);
  end;
end;

procedure TmanagementPart_Frm.Set_of_the_SpecGrid;
var
  li: integer;
begin
  if specGrid.RowCount > 2 then
  begin
    specGrid.RemoveRows(2,specGrid.RowCount-2);
    specGrid.ClearRows(1,1);
  end;

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from HIMSEN_PART_GRP_V ');
    SQL.Add('where ROOTNO = :param1 ');
    SQL.Add('and PCODE = :param2 ');
    SQL.Add('order by ROOTNO, GRPNO');

    ParamByName('param1').AsFloat := FSelectedPartInfo.RootNo;
    ParamByName('param2').AsFloat := FSelectedPartInfo.PartCode;
    Open;

    if RecordCount > 0 then
    begin
      with specGrid do
      begin
        try
          BeginUpdate;
          AutoSize := False;

          while not eof do
          begin
            AddRow;
            Cells[0,RowCount-1] := FieldByName('SUBJECT_ENG').AsString;
    //      Cells[1,RowCount-1] := 입력란
            Cells[2,RowCount-1] := FieldByName('PDATATYPE').AsString;
            Cells[3,RowCount-1] := FieldByName('PSIZE').AsString;
            Cells[4,RowCount-1] := FieldByName('SUBJECT_').AsString;
            Next;
          end;
        finally
          for li := 0 to RowCount-1 do
            if Cells[0,1] = '' then
              RemoveRows(1,1);

          ColumnSize.StretchColumn := 1;
          ColumnSize.Stretch := True;
          AutoSize := True;

          for li := 2 to ColCount-1 do
            ColWidths[li] := 0;

          EndUpdate;
        end;
      end;
    end;
  end;
end;

function TmanagementPart_Frm.Set_the_partTree_Root: Boolean;
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

procedure TmanagementPart_Frm.Show_registered_image(aRow: Integer);
begin
  with partGrid do
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HIMSEN_PART_SPECIFICATIONS');
      SQL.Add('where ROOTNO = :param1 ');
      SQL.Add('and PCODE = :param2 ');
      SQL.Add('and Maker = :param3 ');
      SQL.Add('and Type = :param4 ');
      ParamByName('param1').AsFloat := FSelectedPartInfo.RootNo;
      ParamByName('param2').AsFloat := FSelectedPartInfo.PartCode;
      ParamByName('param3').AsString := FSelectedPartInfo.PMaker;
      ParamByName('param4').AsString := FSelectedPartInfo.PTYPE;
      Open;

      if not(FieldByName('IMAGES').IsNull = True) then
      begin
        NxImage1.Picture.Assign(FieldByName('IMAGES'));
        NxImage1.Invalidate;
      end
      else
      begin
        NxImage1.Picture.Assign(PictureContainer1.Items[0].Picture);
        NxImage1.Invalidate;
      end;
    end;
  end;
end;

procedure TmanagementPart_Frm.specGridCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  CanEdit := False;
  if ARow > 0 then
  begin
    if ACol = 1 then
    begin
      if not(FSelectedPartInfo.RootNo = 0) then
        CanEdit := True
      else
        CanEdit := False;
    end;
  end;
end;

procedure TmanagementPart_Frm.specGridGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  case ARow of
    0 : HAlign := taCenter;
  end;

end;

procedure TmanagementPart_Frm.specGridGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
var
  LDataType : String;
  LType : Integer;

begin
  with specGrid do
  begin
    if ARow > 0 then
    begin
      if ACol = 1 then
      begin
        LDataType := Cells[2,ARow];

        if LDataType = 'VARCHAR2' then
          AEditor := edNormal;
        if LDataType = 'NUMBER' then
          AEditor := edFloat;
        if LDataType = 'INTEGER' then
          AEditor := edNumeric;

      end;
    end;
  end;
end;

procedure TmanagementPart_Frm.Update_of_the_Part_Spec_to_DB;
var
  lTypeNo,
  li,le : integer;
  LSQL : String;
  LSubject : String;
  LMS : TMemoryStream;
  LInBitmap : TBitmap;
  LParam : String;
  LPartNo : Integer;
begin
  with specGrid do
  begin
    try
      LSQL := 'Update HIMSEN_PART_SPECIFICATIONS set ';

      for li := 1 to RowCount-1 do
        LSQL := LSQL + Cells[4,li]+' = :'+Cells[4,li]+', ';

      LSQL := LSQL + 'IMAGES = :IMAGES,';
      LSQL := LSQL + 'MODID = :MODID,';
      LSQL := LSQL + 'MODDATE = :MODDATE';

      LSQL := LSQL + ' where ROOTNO = '+FloatToStr(FSelectedPartInfo.RootNo);
      LSQL := LSQL + ' and PCODE = '+FloatToStr(FSelectedPartInfo.PartCode);
      LSQL := LSQL + ' and MAKER  = '''+FSelectedPartInfo.PMaker+'''';
      LSQL := LSQL + ' and TYPE = '''+FSelectedPartInfo.PTYPE+'''';


      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add(LSQL);

        ParamByName('MODID').AsString := CurrentUsers;
        ParamByName('MODDATE').AsDateTime := Now;

        for li := 1 to RowCount -1 do
        begin
          LParam := Cells[4,li];
          if Cells[2,li] = 'VARCHAR2' then
            ParamByName(LParam).AsString  := Cells[1,li];
          if Cells[2,li] = 'NUMBER' then
            ParamByName(LParam).AsFloat   := StrToFloat(Cells[1,li]);
          if Cells[2,li] = 'INTEGER' then
            ParamByName(LParam).AsInteger := StrToInt(Cells[1,li]);
        end;

        LMS := nil;
        LInBitmap  := nil;
        if NxImage1.Picture.Graphic <> nil then
        begin
          LMS := TMemoryStream.Create;
          LInBitmap := TBitmap.Create;
          LInBitmap.Assign(NxImage1.Picture.Graphic);
          LInBitmap.SaveToStream(LMS);

          ParamByName('IMAGES').ParamType := ptInput;
          ParamByName('IMAGES').AsOraBlob.LoadFromStream(LMS);
        end;
        ExecSQL;

        FInputKind := 'Update';
      end;
    finally
      if not(LMS = nil) then
        FreeAndNil(LMS);
      if not(LInBitmap = nil) then
        FreeAndNil(LInBitmap);
    end;
  end;
end;

end.


{
  에디트가 사이즈 크기를 벗어날 경우
var
  LEditLen, LRefLen : integer;
  LStr : String;
begin
  LEditLen := ByteLength(specGrid.Cells[2,FxRow]);
  LRefLen := StrToInt(specGrid.Cells[3,FxRow]);

  if LEditLen > LRefLen then
  begin
    LRefLen := LRefLen div 2;
    LStr := Copy(specGrid.Cells[2,FxRow],0,LRefLen);
    specGrid.Cells[2,FxRow] := LStr;
  end;
end;
}
