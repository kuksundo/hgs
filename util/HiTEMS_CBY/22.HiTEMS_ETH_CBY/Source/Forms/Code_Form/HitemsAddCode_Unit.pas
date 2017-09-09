unit HitemsAddCode_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvBackgrounds, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.ComCtrls, TreeList, Vcl.StdCtrls, NxCollection,
  AdvSmoothPanel, Ora, NxEdit, Vcl.ImgList, NxColumnClasses, NxColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid;

type
  THitemsAddCode_Frm = class(TForm)
    AdvSmoothPanel1: TAdvSmoothPanel;
    NxHeaderPanel1: TNxHeaderPanel;
    Panel2: TPanel;
    Button6: TButton;
    Button1: TButton;
    Image2: TImage;
    JvBackground1: TJvBackground;
    Panel1: TPanel;
    treeImg: TImageList;
    codeGrid: TNextGrid;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    Panel3: TPanel;
    Button2: TButton;
    Panel4: TPanel;
    codetype: TComboBox;
    Panel5: TPanel;
    Panel6: TPanel;
    code: TNxEdit;
    Button3: TButton;
    codenm: TNxEdit;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    NxTextColumn3: TNxTextColumn;
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure codeGridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure Button1Click(Sender: TObject);
    procedure codeGridSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure codetypeDropDown(Sender: TObject);
    procedure codetypeSelect(Sender: TObject);
  private
    { Private declarations }
    FxRow : Integer;
    FResult : String;
  public
    { Public declarations }
    procedure Show_the_HiTEMS_CODE(aCodeType:String);
    function Check_for_Avaliability_of_the_Code(var aMsg:String) : Boolean;
    procedure Add_new_Code_2_DB;

    function Return_to_CodeType(aTypeName:String) : Integer;

  end;

var
  HitemsAddCode_Frm: THitemsAddCode_Frm;
  function add_new_HiTEMS_CODE : String;

implementation
uses
  HiTEMS_ETH_COMMON,
  HiTEMS_ETH_CONST,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

function add_new_HiTEMS_CODE : String;
var
  li : integer;
  lNode : TTreeNode;
begin
  with THitemsAddCode_Frm.Create(Application) do
  begin
    Show_the_HiTEMS_CODE('0');
    if ShowModal = mrOk then
    begin
      Result := FResult;
    end;
  end;
end;


procedure THitemsAddCode_Frm.Add_new_Code_2_DB;
var
  lcodetype : Integer;
begin
  if not(code.Text = '') and not(codenm.Text = '') then
  begin
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Insert Into HITEMS_CODE ' +
                'Values(:CODETYPE, :CODE, :SUBCODE, :CODENAME, :REGID, :REGDATE, :MODID, :MODDATE)');

        lcodetype := Return_to_CodeType(codetype.Text);

        if lcodeType > 0 then
        begin
          ParamByName('CODETYPE').AsInteger := lcodetype;
          ParamByName('CODE').AsFloat       := StrToFloat(CODE.Text);
          ParamByName('CODENAME').AsString  := CODENM.Text;
          ParamByName('REGID').AsString     := CurrentUsers;
          ParamByName('REGDATE').AsDateTime := Now;
          ExecSQL;
          ShowMessage('코드등록 성공!');
        end;
      end;
    except
      ShowMessage('코드등록 실패!');
    end;
  end
  else
    ShowMessage('코드 또는 코드명이 입력되지 않았습니다.');
end;

procedure THitemsAddCode_Frm.Button1Click(Sender: TObject);
var
  lResult : String;
begin
  with codeGrid do
  begin
    try
      lResult := Cells[2,FxRow];
      lResult := lResult + ';' + Cells[3,FxRow];
      FResult := lResult;
    finally
      ModalResult := mrOk;
    end;
  end;
end;

procedure THitemsAddCode_Frm.Button2Click(Sender: TObject);
var
  lMsg : String;
  lcodeType : String;
begin
  if Check_for_Avaliability_of_the_Code(lMsg)=True then
  begin
    try
      Add_new_Code_2_DB;
    finally
      lcodeType := IntToStr(Return_to_CodeType(codeType.Text));
      Show_the_HiTEMS_CODE(lcodeType);
    end;
  end
  else
  begin
    ShowMessage(lMsg);
  end;
end;

procedure THitemsAddCode_Frm.Button3Click(Sender: TObject);
var
  lKey : Int64;
begin
  lKey := DateTimeToMilliseconds(Now);
  code.Text := IntToStr(lKey);
end;

procedure THitemsAddCode_Frm.Button6Click(Sender: TObject);
begin
  Close;
end;

function THitemsAddCode_Frm.Check_for_Avaliability_of_the_Code(
var aMsg:String) : Boolean;

begin
  Result := False;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQl.Add('select * from HITEMS_CODE where CODE = '''+CODE.Text+''' ');
    Open;

    if RecordCount = 0 then
    begin
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HITEMS_CODE where CODENAME = '''+CODENM.Text+''' ');
        Open;

        if RecordCount = 0 then
          Result := True
        else
          aMsg := '사용중인 코드명 입니다.';
      end;
    end
    else
      aMsg := '사용중인 코드 입니다.';
  end;
end;


procedure THitemsAddCode_Frm.codeGridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
var
  lResult : String;
begin
  with codeGrid do
  begin
    try
      lResult := Cells[1,FxRow];
      lResult := lResult + ';' + Cells[2,FxRow];
      FResult := lResult;
    finally
      ModalResult := mrOk;
    end;
  end;
end;

procedure THitemsAddCode_Frm.codeGridSelectCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  FxRow := ARow;

end;

procedure THitemsAddCode_Frm.codetypeDropDown(Sender: TObject);
begin
  with codetype.Items do
  begin
    BeginUpdate;
    try
      Clear;
      Add('');
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from HITEMS_CODE_TYPE ');
        Open;

        while not eof do
        begin
          Add(FieldByName('TYPENAME').AsString);
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure THitemsAddCode_Frm.codetypeSelect(Sender: TObject);
var
  li : integer;
  lcodeType : String;
begin
  lcodeType := IntToStr(Return_to_CodeType(codetype.Text));
  Show_the_HiTEMS_CODE(lcodeType);
end;

procedure THitemsAddCode_Frm.FormCreate(Sender: TObject);
begin
  codeGrid.DoubleBuffered := False;
end;

function THitemsAddCode_Frm.Return_to_CodeType(aTypeName: String): Integer;
var
  OraQuery : TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  OraQuery.Session := DM1.OraSession1;
  try
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from HITEMS_CODE_TYPE ' +
              'where TYPENAME = '''+aTypeName+''' ');
      Open;

      if not(RecordCount = 0) then
        Result := FieldByName('CODETYPE').AsInteger
      else
        Result := 0;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure THitemsAddCode_Frm.Show_the_HiTEMS_CODE(aCodeType:String);
begin
  with codeGrid do
  begin
    BeginUpdate;
    ClearRows;
    try
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        if aCodeType = '0' then
          SQL.Add('select * from HITEMS_CODE ')
        else
          SQL.Add('select * from HITEMS_CODE ' +
                  'where CODETYPE = '+aCodeType+' order by CODE');
        Open;

        while not eof do
        begin
          AddRow;
          Cells[1,RowCount-1] := FieldByName('CODETYPE').AsString;
          Cells[2,RowCount-1] := FieldByName('CODE').AsString;
          Cells[3,RowCount-1] := FieldByName('CODENAME').AsString;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

end.
