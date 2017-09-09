unit codeCategory_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvExControls, JvLabel,
  Vcl.ImgList, Vcl.Imaging.jpeg, Vcl.ExtCtrls, AeroButtons, Ora;

type
  TcodeCategory_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    lb_title: TJvLabel;
    JvLabel3: TJvLabel;
    et_ParentNo: TEdit;
    JvLabel2: TJvLabel;
    et_CatName: TEdit;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    Panel1: TPanel;
    rb_Yes: TRadioButton;
    rb_No: TRadioButton;
    AeroButton1: TAeroButton;
    ImageList16x16: TImageList;
    mm_CateDesc: TMemo;
    procedure AeroButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FCat_LV : Integer;
    function Get_CategoryName(aCatNo:String):String;
    procedure Get_CategoryInfo(aCatNo:String);
    procedure Insert_NewCategory;
    procedure Update_Category(aCatNo:String);
  public
    { Public declarations }
  end;

var
  codeCategory_Frm: TcodeCategory_Frm;
  function Create_codeCategory_Frm(aParentNo,aCatNo:String;aCat_LV:Integer):Boolean;


implementation
uses
  HITEMS_TMS_CONST,
  HITEMS_TMS_COMMON,
  DataModule_Unit;

{$R *.dfm}

function Create_codeCategory_Frm(aParentNo,aCatNo:String;aCat_LV:Integer):Boolean;
begin
  Result := False;
  codeCategory_Frm := TcodeCategory_Frm.Create(nil);
  try
    with codeCategory_Frm do
    begin
      if aCatNo <> '' then
      begin
        lb_title.Caption := '카테고리 편집';
        Get_CategoryInfo(aCatNo);

      end else
        lb_title.Caption := '새 카테고리';

      if aParentNo <> '' then
      begin
        FCat_LV := aCat_LV+1;
        et_ParentNo.Hint := aParentNo;
        et_ParentNo.Text := Get_CategoryName(et_ParentNo.Hint);
      end else
        FCat_LV := 0;

      Position := poOwnerFormCenter;
      ShowModal;

      if ModalResult = mrOk then
        Result := True;
    end;
  finally
    FreeAndNil(codeCategory_Frm);
  end;
end;

{ TnewCategory_Frm }

procedure TcodeCategory_Frm.AeroButton1Click(Sender: TObject);
begin
  if et_CatName.Text = '' then
  begin
    et_CatName.SetFocus;
    raise Exception.Create('카테고리 명을 입력하여 주십시오!');
  end;

  if lb_title.Caption = '새 카테고리' then
  begin
    Insert_NewCategory;
  end else
  begin
    Update_Category(et_CatName.Hint);
  end;
end;

procedure TcodeCategory_Frm.FormShow(Sender: TObject);
begin
  et_CatName.SetFocus;
end;

procedure TcodeCategory_Frm.Get_CategoryInfo(aCatNo: String);
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
      SQL.Add('SELECT * FROM HITEMS_CODE_CATEGORY ' +
              'WHERE CAT_NO LIKE :param1 ');
      ParamByName('param1').AsString := aCatNo;
      Open;

      et_CatName.Hint := FieldByName('CAT_NO').AsString;
      et_CatName.Text := FieldByName('CAT_NAME').AsString;
      mm_CateDesc.Text := FieldByName('CAT_DESC').AsString;

      if FieldByName('USE_YN').AsString = 'Y' then
        rb_Yes.Checked := True
      else
        rb_No.Checked := True;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

function TcodeCategory_Frm.Get_CategoryName(aCatNo: String): String;
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
      SQL.Add('SELECT CAT_NAME FROM HITEMS_CODE_CATEGORY ' +
              'WHERE CAT_NO LIKE :param1 ');
      ParamByName('param1').AsString := aCatNo;
      Open;

      Result := FieldByName('CAT_NAME').AsString;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TcodeCategory_Frm.Insert_NewCategory;
var
  LCat_No : String;
begin
  LCat_No := 'CAT'+FormatDateTime('YYYYMMDDHHMMSSZZZ',Now);
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO HITEMS_CODE_CATEGORY ' +
            '(' +
            '   CAT_NO, PARENT_NO, CAT_LV, CAT_NAME, CAT_DESC, SEQ_NO, USE_YN, REG_ID, REG_DATE ' +
            ') VALUES ' +
            '( ' +
            '   :CAT_NO, :PARENT_NO, :CAT_LV, :CAT_NAME, :CAT_DESC, :SEQ_NO, :USE_YN, :REG_ID, :REG_DATE ' +
            ') ');

    ParamByName('CAT_NO').AsString    := LCat_No;
    ParamByName('PARENT_NO').AsString := et_ParentNo.Hint;
    ParamByName('CAT_LV').AsInteger   := FCat_LV;
    ParamByName('CAT_NAME').AsString  := et_CatName.Text;
    ParamByName('CAT_DESC').AsString  := mm_CateDesc.Text;

    if rb_Yes.Checked then
      ParamByName('USE_YN').AsString  := 'Y'
    else
      ParamByName('USE_YN').AsString  := 'N';

    ParamByName('REG_ID').AsString     := DM1.FUserInfo.CurrentUsers;
    ParamByName('REG_DATE').AsDateTime := Now;

    ExecSQL;

  end;
end;

procedure TcodeCategory_Frm.Update_Category(aCatNo: String);
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE HITEMS_CODE_CATEGORY SET ' +
            '   CAT_NAME = :CAT_NAME, CAT_DESC = :CAT_DESC, ' +
            '   USE_YN = :USE_YN, MOD_ID = :MOD_ID, MOD_DATE = :MOD_DATE ' +
            'WHERE CAT_NO LIKE :param1 ');
    ParamByName('param1').AsString := aCatNo;

    ParamByName('CAT_NAME').AsString  := et_CatName.Text;
    ParamByName('CAT_DESC').AsString  := mm_CateDesc.Text;

    if rb_Yes.Checked then
      ParamByName('USE_YN').AsString  := 'Y'
    else
      ParamByName('USE_YN').AsString  := 'N';

    ParamByName('MOD_ID').AsString     := DM1.FUserInfo.CurrentUsers;
    ParamByName('MOD_DATE').AsDateTime := Now;

    ExecSQL;

  end;
end;

end.
