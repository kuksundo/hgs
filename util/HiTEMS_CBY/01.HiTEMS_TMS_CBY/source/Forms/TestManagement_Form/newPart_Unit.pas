unit newPart_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls,
  AdvSmoothTileList, AeroButtons, JvExControls, JvLabel, CurvyControls,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.ExtDlgs, Vcl.ImgList,
  AdvSmoothTileListImageVisualizer,Winapi.ShellAPI, DB, Ora;

type
  TnewPart_Frm = class(TForm)
    imagelist24x24: TImageList;
    ImageList32x32: TImageList;
    ImageList16x16: TImageList;
    OpenPictureDialog1: TOpenPictureDialog;
    Panel8: TPanel;
    Image1: TImage;
    CurvyPanel1: TCurvyPanel;
    JvLabel14: TJvLabel;
    btn_Close: TAeroButton;
    btn_Submit: TAeroButton;
    et_msNumber: TEdit;
    JvLabel7: TJvLabel;
    ImgList: TAdvSmoothTileList;
    JvLabel1: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel8: TJvLabel;
    et_drawno: TEdit;
    et_std: TEdit;
    et_remark: TMemo;
    JvLabel4: TJvLabel;
    Button10: TButton;
    Button1: TButton;
    AdvSmoothTileListImageVisualizer1: TAdvSmoothTileListImageVisualizer;
    Button2: TButton;
    Button3: TButton;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    cb_name: TComboBox;
    cb_maker: TComboBox;
    cb_type: TComboBox;
    et_PartNo: TEdit;
    OpenDialog1: TOpenDialog;
    btn_Del: TAeroButton;
    JvLabel11: TJvLabel;
    JvLabel10: TJvLabel;
    EngTypeLbl: TJvLabel;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fileGridDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_SubmitClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_DelClick(Sender: TObject);
  private
    { Private declarations }
    FDelImageList : TStringList;
    FEngType: string;

    ForiginFileGridWindowProc : TWndMethod;
    procedure FileGridWindowProc(var msg : TMessage);
    procedure FileGridDropFiles(aGrid:TNextGrid;var msg:TWMDropFiles);
  public
    { Public declarations }

    procedure Insert_newPart;
    procedure Update_Part;
    procedure Delete_Part;
    procedure File_Management;
    procedure Get_Part_Info(aPartNo: String);
    function Get_Attfiles_Reg_No(aPartNo:String):Integer;


  end;

var
  newPart_Frm: TnewPart_Frm;
  function Create_newPart_Frm(aPart_No,aMS_No,aMS_Name, aEngType:String) : Boolean;

implementation

uses
  HiTEMS_TMS_CONST,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

function Create_newPart_Frm(aPart_No,aMS_No,aMS_Name, aEngType:String) : Boolean;
begin
  Result := False;
  newPart_Frm := TnewPart_Frm.Create(nil);
  try
    with newPart_Frm do
    begin
      FEngType := aEngType;
      EngTypeLbl.Caption := FEngType;
      et_msNumber.Hint := aMS_No;
      et_msNumber.Text := aMS_Name;
      if aPart_No = '' then
      begin
        //신규 등록
        btn_Submit.Caption := '등록';
        et_PartNo.Text := FormatDateTime('yyyyMMddHHmmsszzz',Now);
      end
      else
      begin
        //부품 편집
        btn_Submit.Caption := '수정';
        btn_Del.Visible := True;
        et_PartNo.Text := aPart_No;
        Get_Part_Info(et_PartNo.Text);

      end;

      ShowModal;

      if ModalResult = mrOk then
        Result := True;

    end;
  finally
    FreeAndNil(newPart_Frm);
  end;
end;

procedure TnewPart_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TnewPart_Frm.btn_DelClick(Sender: TObject);
begin
  with DM1.OraTransaction1 do
  begin
    StartTransaction;
    try
      Delete_Part;
      Commit;
      ShowMessage(btn_Del.Caption+'성공!');
      ModalResult := mrOk;
    except
      Rollback;
    end;
  end;
end;

procedure TnewPart_Frm.btn_SubmitClick(Sender: TObject);
begin
  with DM1.OraTransaction1 do
  begin
    StartTransaction;
    try
      if btn_Submit.Caption = '등록' then
        Insert_newPart
      else
      begin
        Update_Part
      end;
      //이미지 & 첨부파일 수정 등록
      File_Management;
      Commit;
      ShowMessage(btn_Submit.Caption+'성공!');
      ModalResult := mrOk;
    except
      Rollback;
    end;
  end;
end;

procedure TnewPart_Frm.Button10Click(Sender: TObject);
var
  li : integer;
begin
  with fileGrid do
  begin
    if SelectedRow > -1 then
    begin
      if not(Cells[3,SelectedRow] = '') then
        DeleteRow(SelectedRow)
      else
        for li := 0 to Columns.Count-1 do
          Cell[li,SelectedRow].TextColor := clRed;

    end;
  end;
end;

procedure TnewPart_Frm.Button1Click(Sender: TObject);
var
  li,le : integer;
  lms : TMemoryStream;
  lfilename : String;
  lExt : String;
  lSize : int64;
  lResult : Boolean;

begin
  if OpenDialog1.Execute then
  begin
    with OpenDialog1 do
    begin
      for li := 0 to Files.Count-1 do
      begin
        lfilename := ExtractFileName(Files.Strings[li]);
        with fileGrid do
        begin
          BeginUpdate;
          try
            lResult := True;
            for le := 0 to RowCount-1 do
            begin
              if lfilename = Cells[1,le] then
              begin
                raise Exception.Create(Format('%s : 같은 이름의 파일이 등록되어 있습니다.',[lfilename]));
                lResult := False;
                Break;
              end;
            end;

            if lResult = True then
            begin
              lms := TMemoryStream.Create;
              try
                lms.LoadFromFile(Files.Strings[li]);
                lsize := lms.Size;

                lExt := ExtractFileExt(lfileName);
                Delete(lExt,1,1);
                AddRow;
                Cells[1,RowCount-1] := lfilename;
                Cells[2,RowCount-1] := IntToStr(lsize);
                Cells[3,RowCount-1] := Files.Strings[li];

                for le := 0 to Columns.Count-1 do
                  Cell[le,RowCount-1].TextColor := clBlue;
              finally
                FreeAndNil(lms);
              end;
            end;
          finally
            EndUpdate;
          end;
        end;
      end;
    end;
  end;
end;

procedure TnewPart_Frm.Button2Click(Sender: TObject);
var
  i : Integer;
  Tile : TAdvSmoothTile;

begin
  with ImgList.Tiles do
  begin
    BeginUpdate;
    try
      if OpenPictureDialog1.Execute then
      begin
        for i := 0 to OpenPictureDialog1.Files.Count-1 do
        begin
          Tile := Add;
          with Tile do
          begin
            Content.Hint := OpenPictureDialog1.Files.Strings[i];
            Content.Image.LoadFromFile(Content.Hint);
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewPart_Frm.Button3Click(Sender: TObject);
var
  i : Integer;
  LRegNo : String;
begin
  i := ImgList.SelectedTile.Index;
  if i > -1 then
  begin
    LRegNo := ImgList.Tiles[i].Content.Hint;
    try
      ImgList.Tiles.Delete(i);

      if pos(':\',LRegNo) = 0 then
        FDelImageList.Add(LRegNo);
    finally
      ImgList.PreviousPage;
    end;
  end;
end;

procedure TnewPart_Frm.Delete_Part;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('DELETE FROM HIMSEN_MS_PART ' +
            'WHERE PART_NO LIKE :param1 ');

    ParamByName('param1').AsString    := et_PartNo.Text;

    ExecSQL;

    SQL.Clear;
    SQL.Add('DELETE FROM HIMSEN_MS_ATTFILES ' +
            'WHERE PART_NO LIKE :param1 ');
    ParamByName('param1').AsString  := et_PartNo.Text;

    ExecSQL;

  end;
end;

procedure TnewPart_Frm.fileGridDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  DragAcceptFiles(handle,true);
  Accept := True;
end;

procedure TnewPart_Frm.FileGridDropFiles(aGrid: TNextGrid;
  var msg: TWMDropFiles);
var
  i,j,c, numFiles,NameLength : Integer;
  hDrop : THandle;
  tmpFile : array[0..MAX_PATH] of char;
  FileName,
  str,
  lExt : String;
  lms : TMemoryStream;
  lsize : Int64;
  LResult : Boolean;
begin
  with aGrid do
  begin
    BeginUpdate;
    try
      hDrop := Msg.Drop;
      try
        numFiles := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0);
        for i := 0 to numFiles-1 do
        begin
          NameLength := DragQueryFile(hDrop, i, nil, 0);

          DragQueryFile(hDrop, i, tmpFile, NameLength+1);

          FileName := StrPas(tmpFile);

          if FileExists(FileName) then
          begin
            str := ExtractFileName(FileName);

            LResult := True;
            for j := 0 to RowCount-1 do
              if SameText(str, Cells[1,j]) then
              begin
                LResult := False;
                Break;
              end;

            if LResult then
            begin
              lms := TMemoryStream.Create;
              try
                lms.LoadFromFile(FileName);
                lsize := lms.Size;

                lExt := ExtractFileExt(str);
                Delete(lExt,1,1);
                AddRow;
                Cells[1,LastAddedRow] := str;
                Cells[2,LastAddedRow] := IntToStr(lsize);
                Cells[3,LastAddedRow] := FileName;

                for c := 0 to Columns.Count-1 do
                  Cell[c,LastAddedRow].TextColor := clBlue;
              finally
                FreeAndNil(lms);
              end;
            end;
          end;
        end;
      finally
        DragFinish(hDrop);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TnewPart_Frm.FileGridWindowProc(var msg: TMessage);
begin
  if msg.msg = WM_DROPFILES then
    FileGridDropFiles(fileGrid,TWMDROPFILES(Msg))
  else
    ForiginFileGridWindowProc(Msg);
end;

procedure TnewPart_Frm.File_Management;
var
  i : Integer;
  MS : TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    with DM1.OraQuery1 do
    begin
      //Image 삭제 & 첨부
      if FDelImageList.Count > 0 then
      begin
        try
          for i := 0 to FDelImageList.Count-1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('DELETE FROM HIMSEN_MS_ATTFILES ' +
                    'WHERE PART_NO LIKE :param1 ' +
                    'AND REG_NO LIKE :param2 ');
            ParamByName('param1').AsString  := et_PartNo.Text;
            ParamByName('param2').AsInteger := StrToInt(FDelImageList.Strings[i]);
            ExecSQL;
          end;
        finally
          FDelImageList.Clear;
        end;
      end;

      for i := 0 to ImgList.Tiles.Count-1 do
      begin
        MS.Clear;
        if POS(':\',ImgList.Tiles[i].Content.Hint) > 0 then
        begin
          MS.LoadFromFile(ImgList.Tiles[i].Content.Hint);
          MS.Position := 0;

          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO HIMSEN_MS_ATTFILES ( ' +
                  'PART_NO, REG_NO, FLAG, FILE_NAME, ' +
                  'FILE_SIZE, FILES ) VALUES ( ' +
                  ':PART_NO, :REG_NO, :FLAG, :FILE_NAME, ' +
                  ':FILE_SIZE, :FILES ) ');

          ParamByName('PART_NO').AsString   := et_PartNo.Text;
          ParamByName('REG_NO').AsInteger   := Get_Attfiles_Reg_No(et_PartNo.Text);
          ParamByName('FLAG').AsString      := 'I';
          ParamByName('FILE_NAME').AsString := ExtractFileName(ImgList.Tiles[i].Content.Hint);
          ParamByName('FILE_SIZE').AsFloat := MS.Size;
          ParamByName('FILES').ParamType := ptInput;
          ParamByName('FILES').AsOraBlob.LoadFromStream(MS);
          ExecSQL;
        end;//if
      end;//for Image첨부

      //파일 첨부 & 삭제
      for i := 0 to fileGrid.RowCount-1 do
      begin
        MS.Clear;
        if fileGrid.Cells[3,i] <> '' then
        begin
          MS.LoadFromFile(fileGrid.Cells[3,i]);
          MS.Position := 0;

          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO HIMSEN_MS_ATTFILES ( ' +
                  'PART_NO, REG_NO, FLAG, FILE_NAME, ' +
                  'FILE_SIZE, FILES ) VALUES ( ' +
                  ':PART_NO, :REG_NO, :FLAG, :FILE_NAME, ' +
                  ':FILE_SIZE, :FILES ) ');

          ParamByName('PART_NO').AsString   := et_PartNo.Text;
          ParamByName('REG_NO').AsInteger   := Get_Attfiles_Reg_No(et_PartNo.Text);
          ParamByName('FLAG').AsString      := 'A';
          ParamByName('FILE_NAME').AsString := ExtractFileName(fileGrid.Cells[3,i]);
          ParamByName('FILE_SIZE').AsFloat := MS.Size;
          ParamByName('FILES').ParamType := ptInput;
          ParamByName('FILES').AsOraBlob.LoadFromStream(MS);
          ExecSQL;
        end else
        begin
          if fileGrid.Cell[0,i].TextColor = clRed then
          begin
            Close;
            SQL.Clear;
            SQL.Add('DELETE FROM HIMSEN_MS_ATTFILES ' +
                    'WHERE PART_NO LIKE :param1 ' +
                    'AND REG_NO LIKE :param2 ');
            ParamByName('param1').AsString := et_PartNo.Text;
            ParamByName('param2').AsString := fileGrid.Cells[4,i];
            ExecSQL;

          end;
        end;
      end;//for Image첨부
    end;
  finally
    FreeAndNil(MS);
  end;
end;

procedure TnewPart_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDelImageList.Free;
  Action := caFree;
end;

procedure TnewPart_Frm.FormCreate(Sender: TObject);
begin
  //Drag & Drop Method
  ForiginFileGridWindowProc := fileGrid.WindowProc;
  fileGrid.WindowProc := FileGridWindowProc;

  DragAcceptFiles(fileGrid.Handle,True);

  //Page Setting
  ImgList.Tiles.Clear;
  FDelImageList := TStringList.Create;

end;

function TnewPart_Frm.Get_Attfiles_Reg_No(aPartNo: String): Integer;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT NVL(MAX(REG_NO),0)+1 REG_NO FROM HIMSEN_MS_ATTFILES ' +
              'WHERE PART_NO LIKE :PART_NO ');
      ParamByName('PART_NO').AsString := aPartNo;
      Open;

      Result := FieldByName('REG_NO').AsInteger;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TnewPart_Frm.Get_Part_Info(aPartNo: String);
var
  i: Integer;
  LTile: TAdvSmoothTile;
  LPic: TPicture;
begin
  ImgList.Tiles.Clear;
  fileGrid.ClearRows;
  LPic := TPicture.Create;
  try
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM HIMSEN_MS_PART ' + 'WHERE PART_NO LIKE :param1 ');
      ParamByName('param1').AsString := aPartNo;
      Open;

      if RecordCount <> 0 then
      begin
        cb_name.Text := FieldByName('NAME').AsString;
        cb_maker.Text := FieldByName('MAKER').AsString;
        cb_type.Text := FieldByName('TYPE').AsString;
        et_std.Text := FieldByName('STANDARD').AsString;
        et_drawno.Text := FieldByName('DRAW_NO').AsString;
        et_remark.Text := FieldByName('REMARK').AsString;

        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM HIMSEN_MS_ATTFILES ' +
          'WHERE PART_NO LIKE :param1 ' + 'ORDER BY REG_NO ');

        ParamByName('param1').AsString := aPartNo;
        Open;

        while not eof do
        begin
          LPic.Assign(nil);
          if FieldByName('FLAG').AsString = 'I' then
          begin
            LTile := ImgList.Tiles.Add;
            with LTile do
            begin
              LoadPictureFromBlobField(TBlobField(FieldByName('FILES')), LPic);
              Content.Image.Assign(LPic);
              Content.Hint := FieldByName('REG_NO').AsString;
            end;
          end
          else if FieldByName('FLAG').AsString = 'A' then
          begin
            with fileGrid do
            begin
              i := AddRow;

              Cells[1, i] := FieldByName('FILE_NAME').AsString;
              Cells[2, i] := FieldByName('FILE_SIZE').AsString;
              Cells[3, i] := '';
              Cells[4, i] := FieldByName('REG_NO').AsString;
              Cells[5, i] := FieldByName('PART_NO').AsString;
            end;
          end;
          Next;
        end;
      end;
    end;
  finally
    FreeAndNil(LPic);
  end;
end;

procedure TnewPart_Frm.Insert_newPart;
var
  i : Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO HIMSEN_MS_PART ' +
            '( ' +
            'PART_NO, MS_NO, NAME, MAKER, TYPE, STANDARD, DRAW_NO, REMARK, ' +
            'REG_ID, REG_DATE, ENGTYPE ) VALUES ( ' +
            ':PART_NO, :MS_NO, :NAME, :MAKER, :TYPE, :STANDARD, :DRAW_NO, :REMARK, ' +
            ':REG_ID, :REG_DATE, :ENGTYPE )');

    ParamByName('PART_NO').AsString    := et_PartNo.Text;

    ParamByName('MS_NO').AsString      := et_msNumber.Hint;
    ParamByName('NAME').AsString       := cb_name.Text;
    ParamByName('MAKER').AsString      := cb_maker.Text;
    ParamByName('TYPE').AsString       := cb_type.Text;
    ParamByName('STANDARD').AsString   := et_std.Text;
    ParamByName('DRAW_NO').AsString    := et_drawno.Text;
    ParamByName('REMARK').AsString     := et_remark.Text;

    ParamByName('REG_ID').AsString     := DM1.FUserInfo.UserID;
    ParamByName('REG_DATE').AsDateTime := Now;
    ParamByName('ENGTYPE').AsString := FEngType;

    ExecSQL;

  end;
end;

procedure TnewPart_Frm.Update_Part;
var
  i : Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE HIMSEN_MS_PART SET ' +
            '   NAME = :NAME, MAKER = :MAKER, TYPE = :TYPE, ' +
            '   STANDARD = :STANDARD, DRAW_NO = :DRAW_NO, REMARK = :REMARK, ' +
            '   REG_ID = :REG_ID, REG_DATE = :REG_DATE ' +
            'WHERE PART_NO LIKE :param1 ');

    ParamByName('param1').AsString    := et_PartNo.Text;

    ParamByName('NAME').AsString       := cb_name.Text;
    ParamByName('MAKER').AsString      := cb_maker.Text;
    ParamByName('TYPE').AsString       := cb_type.Text;
    ParamByName('STANDARD').AsString   := et_std.Text;
    ParamByName('DRAW_NO').AsString    := et_drawno.Text;
    ParamByName('REMARK').AsString     := et_remark.Text;

    ParamByName('REG_ID').AsString     := DM1.FUserInfo.UserID;
    ParamByName('REG_DATE').AsDateTime := Now;

    ExecSQL;

  end;
end;

end.
