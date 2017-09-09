unit setPartPosition_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  JvExControls, JvLabel, Vcl.ImgList, Vcl.Imaging.jpeg, Data.DBXJSON, NxEdit,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid;

type
  TsetPartPosition_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    ImageList16x16: TImageList;
    JvLabel4: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    cb_bank: TComboBox;
    cb_cycle: TComboBox;
    cb_side: TComboBox;
    JvLabel5: TJvLabel;
    et_serial: TEdit;
    Bevel1: TBevel;
    Button1: TButton;
    et_cyl: TNxNumberEdit;
    Bevel2: TBevel;
    JvLabel6: TJvLabel;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    btn_addPart: TButton;
    btn_delPart: TButton;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure btn_addPartClick(Sender: TObject);
    procedure btn_delPartClick(Sender: TObject);
    procedure et_serialChange(Sender: TObject);
  private
    { Private declarations }
    FReqNo,
    FPartNo : String;
    FDelList : TStringList;
  public
    { Public declarations }
    function Return_Values(aTJSONPair: TJSONPair): String;
  end;

var
  setPartPosition_Frm: TsetPartPosition_Frm;
  procedure Create_PartPosition_Frm(aEngType,aReqNo,aPartNo:String;aData:TJSONObject;aFileList,aDelList:TStringList);

implementation
uses
  DataModule_Unit;

{$R *.dfm}

procedure Create_PartPosition_Frm(aEngType,aReqNo,aPartNo:String;aData:TJSONObject;aFileList,aDelList:TStringList);
var
  i,j,k, LRow : Integer;
  str : String;
begin
  setPartPosition_Frm := TsetPartPosition_Frm.Create(nil);
  try
    with setPartPosition_Frm do
    begin
      if LastDelimiter('V',aEngType) > 0 then
        cb_bank.Enabled := True
      else
        cb_bank.Enabled := False;

      FReqNo := aReqNo;
      FPartNo := aPartNo;
      FDelList := aDelList;

      if aData.Size > 0 then
      begin
        try
          str := Return_Values(aData.Get('BANK'));
          if str <> 'NULL' then
            cb_bank.ItemIndex := cb_bank.Items.IndexOf(str)
          else
            cb_bank.ItemIndex := 0;

          str := Return_Values(aData.Get('CYLNUM'));
          if str <> '' then
            et_cyl.Text := str
          else
            et_cyl.Value := 0;

          str := Return_Values(aData.Get('CYCLE'));
          if str <> 'NULL' then
            cb_cycle.ItemIndex := cb_cycle.Items.IndexOf(str)
          else
            cb_cycle.ItemIndex := 0;

          str := Return_Values(aData.Get('SIDE'));
          if str <> 'NULL' then
            cb_side.ItemIndex := cb_side.Items.IndexOf(str)
          else
            cb_side.ItemIndex := 0;

          et_serial.Text := Return_Values(aData.Get('SERIAL'));
          if et_serial.Text = 'NULL' then
            et_serial.Text := '';

          with DM1.OraQuery1 do
          begin
            Close;
            SQL.Clear;
            SQL.Add('SELECT * FROM TMS_TEST_PART_ATTFILES ' +
                    'WHERE REQ_NO LIKE :param1 ' +
                    'AND PART_NO LIKE :param2 ' +
                    'AND SERIAL LIKE :param3 ');
            ParamByName('param1').AsString := FReqNo;
            ParamByName('param2').AsString := FPartNo;
            ParamByName('param3').AsString := et_serial.Text;
            Open;

            while not eof do
            begin
              LRow := fileGrid.AddRow;
              FileGrid.Cells[1, LRow] := FieldByName('FILE_NAME').AsString;
              Next;
            end;
          end;

          for i := 0 to aFileList.Count - 1 do
          begin
            if FileExists(aFileList.Strings[i]) then
            begin
              LRow := FileGrid.AddRow;
              FileGrid.Cells[1, LRow] := ExtractFileName(aFileList.Strings[i]);

              for j := 0 to fileGrid.Columns.Count-1 do
                fileGrid.Cell[j,LRow].TextColor := clBlue;

            end;
          end;

          if FDelList.Count > 0 then
          begin
            for i := 0 to FDelList.Count-1 do
            begin
              str := FDelList.Strings[i];
              for j := 0 to fileGrid.RowCount-1 do
              begin
                if str = fileGrid.Cells[1,j] then
                begin
                  for k := 0 to fileGrid.Columns.Count-1 do
                  begin
                    fileGrid.Cell[k,j].TextColor := clRed;
                  end;
                end;
              end;
            end;
          end;

        finally
          aData.RemovePair('BANK');
          aData.RemovePair('CYLNUM');
          aData.RemovePair('CYCLE');
          aData.RemovePair('SIDE');
          aData.RemovePair('SERIAL');
        end;
      end;

      ShowModal;

      aFileList.Clear;
      if ModalResult = mrOk then
      begin
        if cb_bank.Text <> '' then
          aData.AddPair('BANK',cb_bank.Text)
        else
          aData.AddPair('BANK','NULL');

        aData.AddPair('CYLNUM',et_cyl.Text);

        if cb_cycle.Text <> '' then
          aData.AddPair('CYCLE',cb_cycle.Text)
        else
          aData.AddPair('CYCLE','NULL');

        if cb_side.Text <> '' then
          aData.AddPair('SIDE',cb_side.Text)
        else
          aData.AddPair('SIDE','NULL');

        if et_serial.Text <> '' then
          aData.AddPair('SERIAL',et_serial.Text)
        else
          aData.AddPair('SERIAL','NULL');

        for i := 0 to fileGrid.RowCount-1 do
        begin
          if (fileGrid.Cell[0,i].TextColor = clBlue) and (fileGrid.Cells[3,i] <> '') then
            afileList.Add(fileGrid.Cells[3,i]);

        end;
      end else
      begin

      end;
    end;
  finally
    FreeAndNil(setPartPosition_Frm);
  end;
end;

procedure TsetPartPosition_Frm.btn_addPartClick(Sender: TObject);
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

procedure TsetPartPosition_Frm.btn_delPartClick(Sender: TObject);
var
  li : integer;
  str : String;
begin
  with fileGrid do
  begin
    if SelectedRow > -1 then
    begin
      if not(Cells[3,SelectedRow] = '') then
      begin
        str := Cells[3,SelectedRow];
        DeleteRow(SelectedRow)
      end
      else
      begin
        for li := 0 to Columns.Count-1 do
          Cell[li,SelectedRow].TextColor := clRed;

        FDelList.Add(Cells[1,SelectedRow]);
      end;
    end;
  end;
end;

procedure TsetPartPosition_Frm.Button1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TsetPartPosition_Frm.et_serialChange(Sender: TObject);
begin
  if et_serial.Text <> '' then
  begin
    btn_addPart.Enabled := True;
    btn_delPart.Enabled := True;
  end else
  begin
    btn_addPart.Enabled := False;
    btn_delPart.Enabled := False;
  end;
end;

function TsetPartPosition_Frm.Return_Values(aTJSONPair: TJSONPair): String;
var
  lstr : String;
  ljsonValue : TJSONValue;
begin
  ljsonValue := aTJSONPair.JsonValue;
  Result := ljsonValue.Value;
end;

end.
