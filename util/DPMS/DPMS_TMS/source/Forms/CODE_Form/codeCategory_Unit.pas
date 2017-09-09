unit codeCategory_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvExControls, JvLabel,
  Vcl.ImgList, Vcl.Imaging.jpeg, Vcl.ExtCtrls, AeroButtons, Ora, AdvGroupBox,
  AdvOfficeButtons, System.StrUtils;

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
    JvLabel1: TJvLabel;
    JvLabel6: TJvLabel;
    VisibleTypeRG: TAdvOfficeRadioGroup;
    AliasCodeTypeRG: TAdvOfficeRadioGroup;
    AeroButton2: TAeroButton;
    procedure AeroButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FCat_LV : Integer;
    FAuthorisation : Boolean;

    function Get_CategoryName(aCatNo:String):String;
    function Get_CategoryInfo(aCatNo:String): boolean;
    function Insert_NewCategory: string;
    procedure Update_Category(aCatNo:String);
    procedure InsertOrUpdate4Cat(aCatNo:String; AAliasType: integer);
//    procedure ApplyCatVisibleChanged2CodeGrp(ACatno: string;AAliasType: integer);
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
      FAuthorisation := False;  //변경 권한

      if aCatNo <> '' then
      begin
        lb_title.Caption := '카테고리 편집';
        FAuthorisation := Get_CategoryInfo(aCatNo);
      end else
      begin
        lb_title.Caption := '새 카테고리';
        FAuthorisation := True;
      end;

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
var
  LCat: string;
begin
  LCat := '';

  if et_CatName.Text = '' then
  begin
    et_CatName.SetFocus;
    raise Exception.Create('카테고리 명을 입력하여 주십시오!');
  end;

  if lb_title.Caption = '새 카테고리' then
  begin
    LCat := Insert_NewCategory;
  end else
  begin
    if FAuthorisation then
    begin
      Update_Category(et_CatName.Hint);
      LCat := et_CatName.Hint;
    end;
  end;

  if FAuthorisation then
  begin
    InsertOrUpdate4Cat(LCat, AliasCodeTypeRG.ItemIndex+1);
  end
  else
    ShowMessage('변경 권한이 없습니다!' + #13#10 + '변경 권한은 기안자 및 기안자의 팀장 또는 부서장에게만 있습니다');
end;

//procedure TcodeCategory_Frm.ApplyCatVisibleChanged2CodeGrp(ACatno: string;
//  AAliasType: integer);
//var
//  LCode, LGroup: string;
//  LCodeVisible, LGroupVisible: integer;
//  OraQuery : TOraQuery;
//  LExec: Boolean;
//begin
//  OraQuery := TOraQuery.Create(nil);
//  try
//    OraQuery.Session := DM1.OraSession1;
//
//    with OraQuery do
//    begin
//      Close;
//      SQL.Clear;
//      SQL.Add('SELECT GRP_NO, CODE FROM DPMS_CODE_GROUP ' +
//                       'WHERE CAT_NO = :param1 ');
//      ParamByName('param1').AsString := aCatNo;
//      Open;
//
//      while not Eof do
//      begin
//        LGroup := FieldByName('GRP_NO').AsString;
//        LCode := FieldByName('CODE').AsString;
//
//        with DM1.OraQuery1 do
//        begin
////          if AliasType = Ord(atDepart) then
//          LCodeVisible := -1;
//          LGroupVisible := -1;
//
//          Close;
//          SQL.Clear;
//          SQL.Add('SELECT ALIAS_CODE_TYPE FROM DPMS_CODE_VISIBLE ' +
//                  'WHERE CODE_ID = :CODE_ID ');
//          ParamByName('CODE_ID').AsString    := LCode;
//          Open;
//
//          if RecordCount > 0 then
//            LCodeVisible := FieldByName('ALIAS_CODE_TYPE').AsInteger;
//
//          if AAliasType > LCodeVisible then
//          begin
////            if LCodeVisible = -1 then  //Group Type이 부서인 경우(DPMS_CODE_VISIBLE에 데이터 없음)
////            begin
////              데이터가 없다는 것은 Code의 Alias Type이 부서란 뜻이므로 AAliasType으로 Update해야 함
////            end
////            else  //데이터가 존재하고 변경해야 할 경우
////            begin
//            if AAliasType <> Ord(atDepart) then //변경할 Type이 부서가 아닌 경우
//            begin
//              Close;
//              SQL.Clear;
//              SQL.Add('SELECT ALIAS_CODE_TYPE FROM DPMS_CODE_VISIBLE ' +
//                      'WHERE CODE_ID = :CODE_ID ');
//              ParamByName('CODE_ID').AsString    := LGroup;
//              Open;
//
//              if RecordCount > 0 then
//              begin
//                Close;
//                SQL.Clear;
//                SQL.Add('UPDATE DPMS_CODE_VISIBLE SET ' +
//                        '   CODE_TYPE = :CODE_TYPE, ' +
//                        '   ALIAS_CODE = :ALIAS_CODE, ALIAS_CODE_TYPE = :ALIAS_CODE_TYPE, ' +
//                        '   VISIBLE_TYPE = : VISIBLE_TYPE, MODID = :MODID, MODDATE = :MODDATE ' +
//                        'WHERE CODE_ID = :CODE_ID ');
//              end
//              else
//              begin
//                Close;
//                SQL.Clear;
//                SQL.Add('INSERT INTO DPMS_CODE_VISIBLE ' +
//                        'VALUES ' +
//                        '( ' +
//                        '   :CODE_ID, :CODE_TYPE, :ALIAS_CODE, :ALIAS_CODE_TYPE, :VISIBLE_TYPE, :MODID, :MODDATE ' +
//                        ') ')
//              end;
//
//              ParamByName('CODE_ID').AsString := LGroup;
//              ParamByName('CODE_TYPE').AsInteger := Ord(ctGroup);  //2: Group
//              ParamByName('ALIAS_CODE').AsInteger := DM1.FUserInfo.AliasCode;
//              ParamByName('ALIAS_CODE_TYPE').AsInteger := AAliasType;
//              ParamByName('VISIBLE_TYPE').AsInteger := VisibleTypeRG.ItemIndex + 1;
//              ParamByName('MODID').AsString := DM1.FUserInfo.CurrentUsers;
//              ParamByName('MODDATE').AsDateTime := Now;
//
//              ExecSQL;
//            end
//            else  //변경할 Type이 부서 인 경우에는 삭제함
//            begin
//              Close;
//              SQL.Clear;
//              SQL.Add('DELETE FROM DPMS_CODE_VISIBLE ' +
//                      'WHERE CODE_ID = :CODE_ID AND CODE_TYPE = :CODE_TYPE ');
//              ParamByName('CODE_ID').AsString := LGroup;
//              ParamByName('CODE_TYPE').AsInteger := Ord(ctGroup);
//
//              ExecSQL;
//            end;
////            end;
//          end;
//        end;
//
//        OraQuery.Next;
//      end;
//    end;
//  finally
//    FreeAndNil(OraQuery);
//  end;
//end;

procedure TcodeCategory_Frm.FormShow(Sender: TObject);
begin
  et_CatName.SetFocus;
end;

//Result: 속성 변경 권한 보유 여부, 속성 변경은 생성자 또는 직책자 에게만 권한이 있음
function TcodeCategory_Frm.Get_CategoryInfo(aCatNo: String): boolean;
var
  OraQuery : TOraQuery;
  i: integer;
  Lid: string;
  LUser: TUserInfo;
begin
  Result := False;

  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM DPMS_CODE_CATEGORY ' +
              'WHERE CAT_NO = :param1 ');
      ParamByName('param1').AsString := aCatNo;
      Open;

      et_CatName.Hint := FieldByName('CAT_NO').AsString;
      et_CatName.Text := FieldByName('CAT_NAME').AsString;
      mm_CateDesc.Text := FieldByName('CAT_DESC').AsString;

      if FieldByName('USE_YN').AsString = 'Y' then
        rb_Yes.Checked := True
      else
        rb_No.Checked := True;

      Lid := FieldByName('REG_ID').AsString;
      LUser := DM1.Get_User_Info(Lid);
      Result := (Lid = DM1.FUserInfo.UserID) or
                ((LUser.AliasCode_Team = DM1.FUserInfo.AliasCode_Team) and (DM1.FUserInfo.JobPosition = '직책과장')) or
                ((LUser.AliasCode_Dept = DM1.FUserInfo.AliasCode_Dept) and (DM1.FUserInfo.JobPosition = '부서장'));

      //===========================
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM DPMS_CODE_VISIBLE ' +
              'WHERE CODE_ID = :param1 AND CODE_TYPE = 1');
      ParamByName('param1').AsString := aCatNo;
      Open;

      for i := 0 to RecordCount - 1 do
      begin
        VisibleTypeRG.ItemIndex := FieldByName('VISIBLE_TYPE').AsInteger - 1;
        AliasCodeTypeRG.ItemIndex := FieldByName('ALIAS_CODE_TYPE').AsInteger - 1;
      end;
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
      SQL.Add('SELECT CAT_NAME FROM DPMS_CODE_CATEGORY ' +
              'WHERE CAT_NO LIKE :param1 ');
      ParamByName('param1').AsString := aCatNo;
      Open;

      Result := FieldByName('CAT_NAME').AsString;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TcodeCategory_Frm.InsertOrUpdate4Cat(aCatNo: String; AAliasType: integer);
var
  LPrevAlias, LAlias: integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ALIAS_CODE_TYPE FROM DPMS_CODE_VISIBLE ' +
            'WHERE CODE_ID = :CODE_ID AND ALIAS_CODE = :ALIAS_CODE AND CODE_TYPE = 1');
    ParamByName('CODE_ID').AsString := aCatNo;
    ParamByName('ALIAS_CODE').AsInteger := DM1.FUserInfo.AliasCode_Team;
    Open;

    if RecordCount <= 0 then
    begin
      if ALIAS_TYPE(AAliasType) > atDepart then
      begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO DPMS_CODE_VISIBLE ' +
                'VALUES ' +
                '( ' +
                '   :CODE_ID, :CODE_TYPE, :ALIAS_CODE, :ALIAS_CODE_TYPE, :VISIBLE_TYPE, :MODID, :MODDATE ' +
                ') ');

        ParamByName('CODE_ID').AsString    := aCatNo;
        ParamByName('CODE_TYPE').AsInteger    := 1;  //1: Category
        ParamByName('ALIAS_CODE').AsInteger    := DM1.FUserInfo.AliasCode_Team;
        ParamByName('ALIAS_CODE_TYPE').AsInteger := AAliasType;
        ParamByName('VISIBLE_TYPE').AsInteger    := VisibleTypeRG.ItemIndex + 1;
        ParamByName('MODID').AsString    := DM1.FUserInfo.CurrentUsers;
        ParamByName('MODDATE').AsDateTime    := Now;

        ExecSQL;
      end;
    end
    else
    begin
      LPrevAlias := FieldByName('ALIAS_CODE_TYPE').AsInteger;

      if AAliasType = ord(atDepart) then
      begin
        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM DPMS_CODE_VISIBLE ' +
                'WHERE CODE_ID = :CODE_ID AND ALIAS_CODE = :ALIAS_CODE AND MODID = :MODID');
        ParamByName('CODE_ID').AsString := aCatNo;
        ParamByName('ALIAS_CODE').AsInteger := DM1.FUserInfo.AliasCode_Team;

        if ALIAS_TYPE(LPrevAlias) = atPrivate then
          ParamByName('MODID').AsString := DM1.FUserInfo.UserID
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND MODID = :MODID', '');

        ExecSQL;

        exit;
      end
      else
      begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE DPMS_CODE_VISIBLE SET ' +
                '   CODE_TYPE = :CODE_TYPE, ' +
                '   ALIAS_CODE = :ALIAS_CODE, ALIAS_CODE_TYPE = :ALIAS_CODE_TYPE, ' +
                '   VISIBLE_TYPE = : VISIBLE_TYPE, MODID = :MODID, MODDATE = :MODDATE ' +
                'WHERE CODE_ID = :CODE_ID AND ALIAS_CODE = :ALIAS_CODE AND MODID = :MODID2');

        ParamByName('CODE_ID').AsString    := aCatNo;
        ParamByName('CODE_TYPE').AsInteger    := 1;  //1: Category
        ParamByName('ALIAS_CODE').AsInteger    := DM1.FUserInfo.AliasCode_Team;
        ParamByName('ALIAS_CODE_TYPE').AsInteger := AAliasType;
        ParamByName('VISIBLE_TYPE').AsInteger    := VisibleTypeRG.ItemIndex + 1;
        ParamByName('MODID').AsString    := DM1.FUserInfo.CurrentUsers;
        ParamByName('MODDATE').AsDateTime    := Now;

        if ALIAS_TYPE(LPrevAlias) = atPrivate then
          ParamByName('MODID').AsString := DM1.FUserInfo.UserID
        else
          SQL.Text := ReplaceStr(SQL.Text, 'AND MODID = :MODID2', '');

        ExecSQL;
      end;
    end;

//    if MessageDlg('선택된 작업 카테고리 보이기가 변경 완료 되었습니다' + #13#10 + '기존 코드 그룹에도 반영 할까요?',
//                   mtConfirmation, [mbYes, mbNo], 0) = mrYes then
//    begin
//      ApplyCatVisibleChanged2CodeGrp(aCatNo, AAliasType);
//    end;

  end;
end;

function TcodeCategory_Frm.Insert_NewCategory: string;
begin
  Result := 'CAT'+FormatDateTime('YYYYMMDDHHMMSSZZZ',Now);

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO DPMS_CODE_CATEGORY ' +
            '(' +
            '   CAT_NO, PARENT_NO, CAT_LV, CAT_NAME, CAT_DESC, SEQ_NO, USE_YN, REG_ID, REG_DATE ' +
            ') VALUES ' +
            '( ' +
            '   :CAT_NO, :PARENT_NO, :CAT_LV, :CAT_NAME, :CAT_DESC, :SEQ_NO, :USE_YN, :REG_ID, :REG_DATE ' +
            ') ');

    ParamByName('CAT_NO').AsString    := Result;
    ParamByName('PARENT_NO').AsString := et_ParentNo.Hint;
    ParamByName('CAT_LV').AsInteger   := FCat_LV;
    ParamByName('CAT_NAME').AsString  := et_CatName.Text;
    ParamByName('CAT_DESC').AsString  := mm_CateDesc.Text;
//    ParamByName('SEQ_NO').AsInteger   := FCat_LV;

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
    SQL.Add('UPDATE DPMS_CODE_CATEGORY SET ' +
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
