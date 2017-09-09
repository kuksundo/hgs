unit shimDataSheet_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AeroButtons, NxEdit,
  JvExControls, JvLabel, Vcl.ExtCtrls, Vcl.Imaging.jpeg, Vcl.ImgList,
  pjhTouchKeyboard, Vcl.Touch.Keyboard, AdvSmoothTouchKeyBoard, AdvFocusHelper;

type
  TshimDataSheet_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    Bevel1: TBevel;
    lb_1: TLabel;
    lb_2: TLabel;
    lb_3: TLabel;
    lb_4: TLabel;
    lb_5: TLabel;
    lb_6: TLabel;
    lb_7: TLabel;
    lb_8: TLabel;
    lb_9: TLabel;
    lb_10: TLabel;
    lb_a_Title: TJvLabel;
    lb_b_Title: TJvLabel;
    et_a_1: TNxNumberEdit;
    et_a_2: TNxNumberEdit;
    et_a_3: TNxNumberEdit;
    et_a_4: TNxNumberEdit;
    et_a_5: TNxNumberEdit;
    et_a_6: TNxNumberEdit;
    et_a_7: TNxNumberEdit;
    et_a_8: TNxNumberEdit;
    et_a_9: TNxNumberEdit;
    et_a_10: TNxNumberEdit;
    et_b_1: TNxNumberEdit;
    et_b_2: TNxNumberEdit;
    et_b_3: TNxNumberEdit;
    et_b_4: TNxNumberEdit;
    et_b_5: TNxNumberEdit;
    et_b_6: TNxNumberEdit;
    et_b_7: TNxNumberEdit;
    et_b_8: TNxNumberEdit;
    et_b_9: TNxNumberEdit;
    et_b_10: TNxNumberEdit;
    ImageList16x16: TImageList;
    ImageList32x32: TImageList;
    Panel1: TPanel;
    JvLabel1: TJvLabel;
    btn_Close: TAeroButton;
    btn_Save: TAeroButton;
    AdvFocusHelper1: TAdvFocusHelper;
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure et_a_1KeyPress(Sender: TObject; var Key: Char);
    procedure AdvFocusHelper1ShowFocus(Sender: TObject; Control: TWinControl;
      var ShowFocus: Boolean);
    procedure et_a_1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FOrderNo,
    FEngType : String;
    FpjhTouchKeyboard: TpjhPopupTouchKeyBoard;
  public
    { Public declarations }
    procedure Get_Exist_Value(aOrderNo:String);
    procedure Set_Edit_Arrangement(aEngType:String);
    procedure Insert_TMS_DATA_SHIM;
  end;

var
  shimDataSheet_Frm: TshimDataSheet_Frm;
  procedure Preview_shimDataSheet_Frm(aOrderNo, aEngType:String);
  procedure Create_shimDataSheet_Frm(aOrderNo, aEngType:String);

implementation
uses
  DataModule_Unit,
  HiTEMS_TMS_CONST;


{$R *.dfm}

procedure Preview_shimDataSheet_Frm(aOrderNo, aEngType:String);
begin
  shimDataSheet_Frm := TshimDataSheet_Frm.Create(nil);
  try
    with shimDataSheet_Frm do
    begin
      FOrderNo := aOrderNo;
      FEngType := aEngType;
      btn_Save.Visible := False;
      Get_Exist_Value(aOrderNo);
      Set_Edit_Arrangement(FEngType);

      ShowModal;

    end;
  finally
    FreeAndNil(shimDataSheet_Frm)
  end;
end;

procedure Create_shimDataSheet_Frm(aOrderNo, aEngType: String);
begin
  shimDataSheet_Frm := TshimDataSheet_Frm.Create(nil);
  try
    with shimDataSheet_Frm do
    begin
      FOrderNo := aOrderNo;
      FEngType := aEngType;

      Set_Edit_Arrangement(FEngType);

      ShowModal;

    end;
  finally
    FreeAndNil(shimDataSheet_Frm)
  end;
end;

{ TcylBaseData_Frm }

procedure TshimDataSheet_Frm.AdvFocusHelper1ShowFocus(Sender: TObject;
  Control: TWinControl; var ShowFocus: Boolean);
begin
  if Control is TNxNumberEdit then
    ShowFocus := True
  else
    ShowFocus := False;

end;

procedure TshimDataSheet_Frm.btn_CloseClick(Sender: TObject);
begin
  if MessageDlg('입력창을 닫으시겠습니까?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    Close;

end;

procedure TshimDataSheet_Frm.btn_SaveClick(Sender: TObject);
begin
  Insert_TMS_DATA_SHIM;
  Close;
end;

procedure TshimDataSheet_Frm.et_a_1Click(Sender: TObject);
begin
  with Sender as TNxNumberEdit do
  begin
    if btn_Save.Visible then
    begin
      ReadOnly := False;
      SelectAll;
      FpjhTouchKeyboard.Show;
    end else
    begin
      ReadOnly := True;
      FpjhTouchKeyboard.Hide;
    end;
  end;
end;

procedure TshimDataSheet_Frm.et_a_1KeyPress(Sender: TObject; var Key: Char);
const
  BadChars = '/*';
begin
  if Key = #13 then
  begin
    SelectNext(Sender as TWinControl, True, True);

    if btn_Save.Visible then
    begin
      if Sender is TNxNumberEdit then
        FpjhTouchKeyboard.Show
      else
        FpjhTouchKeyboard.Hide;
    end else
    begin
      TNxNumberEdit(Sender).ReadOnly := True;
      FpjhTouchKeyboard.Hide;
    end;
  end
  else
  begin
    if Pos(Key, BadChars) > 0 then
    begin
      Exit;
    end;
  end;
end;

procedure TshimDataSheet_Frm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(FpjhTouchKeyboard) then
    FpjhTouchKeyboard.Free;

  Action := caFree;
end;

procedure TshimDataSheet_Frm.FormCreate(Sender: TObject);
begin
  FpjhTouchKeyboard := TpjhPopupTouchKeyBoard.Create(Self);
end;

procedure TshimDataSheet_Frm.Get_Exist_Value(aOrderNo: String);
var
  i : Integer;
  LName : String;
  LD : Double;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM TMS_DATA_SHIM ' +
            'WHERE ORDER_NO LIKE :param1 ');
    ParamByName('param1').AsString := aOrderNo;
    Open;

    if RecordCount <> 0 then
    begin
      for i := 1 to 20 do
      begin
        if i > 10 then
          LName := 'et_b_'+IntToStr(i-10)
        else
          LName := 'et_a_'+IntToStr(i);

        try
          with TNxNumberEdit(Self.FindComponent(LName)) do
          begin
            LD := FieldByName('CYL_'+IntToStr(i)).AsFloat;
            Value := LD;
          end;
        except
          on E : Exception do
            ShowMessage(E.Message);
        end;
      end;
    end;
  end;
end;

procedure TshimDataSheet_Frm.Insert_TMS_DATA_SHIM;
var
  i,j : Integer;
  LName : String;

begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO TMS_DATA_SHIM ' +
            '(ORDER_NO, INDATE, REG_ID, CYL_1, CYL_2, CYL_3, CYL_4, CYL_5, ' +
            ' CYL_6, CYL_7, CYL_8, CYL_9, CYL_10, CYL_11, CYL_12, CYL_13, ' +
            ' CYL_14, CYL_15, CYL_16, CYL_17, CYL_18, CYL_19, CYL_20  ' +
            ') VALUES ' +
            '(:ORDER_NO, :INDATE, :REG_ID, :CYL_1, :CYL_2, :CYL_3, :CYL_4, :CYL_5, ' +
            ' :CYL_6, :CYL_7, :CYL_8, :CYL_9, :CYL_10, :CYL_11, :CYL_12, :CYL_13, ' +
            ' :CYL_14, :CYL_15, :CYL_16, :CYL_17, :CYL_18, :CYL_19, :CYL_20 )');
    try

      ParamByName('ORDER_NO').AsString := FOrderNo;
      ParamByName('INDATE').AsDateTime := Now;
      ParamByName('REG_ID').AsString   := DM1.FUserInfo.CurrentUsers;

      for i := 1 to 20 do
      begin
        if i > 10 then
          LName := 'et_b_'+IntToStr(i-10)
        else
          LName := 'et_a_'+IntToStr(i);

        ParamByName('CYL_'+IntToStr(i)).AsFloat := TNxNumberEdit(Self.FindComponent(LName)).Value;

      end;
      ExecSQL;
      ShowMessage('등록성공!');
    except;
      ShowMessage('등록실패!');
    end;
  end;
end;

procedure TshimDataSheet_Frm.Set_Edit_Arrangement(aEngType:String);
var
  LStr : String;
  LCylCnt : Integer;
  LEngArr : String;
  i : Integer;
begin
  LCylCnt := StrToInt(Copy(aEngType,1,POS('H',aEngType)-1));

  if POS('V',aEngType) > 0 then
  begin
    // Vee Type

    LCylCnt := LCylCnt div 2;

    Bevel1.Visible := True;
    with FindComponent('et_a_'+IntToStr(LCylCnt)) as TNxNumberEdit do
      Bevel1.Width := (Left - 15) + Width;

    Width := Bevel1.width + 45;

    lb_a_Title.Caption := 'A-Bank';
    lb_b_Title.Caption := 'B-Bank';
    lb_a_Title.Visible := True;
    lb_b_Title.Visible := True;

    for i := 0 to (10 - LCylCnt) -1 do
    begin
      with FindComponent('lb_'+IntToStr(LCylCnt+i+1)) as TLabel do
        Visible := False;

      with FindComponent('et_a_'+IntToStr(LCylCnt+i+1)) as TNxNumberEdit do
        Visible := False;

      with FindComponent('et_b_'+IntToStr(LCylCnt+i+1)) as TNxNumberEdit do
        Visible := False;
    end;
  end else
  begin
    // In-line
    Bevel1.Visible := False;

    with FindComponent('et_a_'+IntToStr(LCylCnt)) as TNxNumberEdit do
      Bevel1.Width := (Left + Width) + 30;

    Width := Bevel1.Width;


    lb_a_Title.Caption := 'SIDE';
    lb_a_Title.Visible := True;
    lb_b_Title.Visible := False;

    for i := 0 to (10 - LCylCnt) -1 do
    begin
      with FindComponent('lb_'+IntToStr(LCylCnt+i+1)) as TLabel do
        Visible := False;

      with FindComponent('et_a_'+IntToStr(LCylCnt+i+1)) as TNxNumberEdit do
        Visible := False;
    end;

    for i := 0 to 9 do
    begin
      with FindComponent('et_b_'+IntToStr(i+1)) as TNxNumberEdit do
        Visible := False;
    end;
  end;
end;

end.
