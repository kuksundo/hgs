unit localSheet_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, DateUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.StdCtrls, AeroButtons, JvExControls, JvLabel, Vcl.ImgList,
  AdvSmoothGauge, AdvDateTimePicker, NxEdit, AdvGroupBox, VCLTee.TeEngine,
  VCLTee.Series, VCLTee.TeeProcs, VCLTee.Chart, NxPropertyItemClasses, Ora,
  NxPropertyItems, NxScrollControl, NxInspector, System.Generics.Collections,
  AdvFocusHelper, pjhTouchKeyboard, Vcl.Touch.Keyboard, AdvSmoothTouchKeyBoard;

type
  TGetDataThread = class(TThread)
  private
    FEngProjNo, FDataTable: String;
    FKeyDictionary: TDictionary<String, String>;

    procedure UpdateVCL;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

  end;

type
  TlocalSheet_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    Panel1: TPanel;
    ImageList16x16: TImageList;
    JvLabel1: TJvLabel;
    btn_Close: TAeroButton;
    ImageList32x32: TImageList;
    et_Purpose: TEdit;
    JvLabel3: TJvLabel;
    btn_Save: TAeroButton;
    JvLabel4: TJvLabel;
    et_EngType: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    JvLabel50: TJvLabel;
    JvLabel55: TJvLabel;
    Label68: TLabel;
    JvLabel58: TJvLabel;
    cb_FuelType: TComboBox;
    et_load: TNxNumberEdit;
    et_runhour: TNxNumberEdit;
    AdvFocusHelper1: TAdvFocusHelper;
    AdvGroupBox3: TAdvGroupBox;
    JvLabel12: TJvLabel;
    Label10: TLabel;
    DATA117: TNxNumberEdit;
    AdvGroupBox8: TAdvGroupBox;
    JvLabel33: TJvLabel;
    JvLabel34: TJvLabel;
    JvLabel35: TJvLabel;
    Label26: TLabel;
    Label34: TLabel;
    DATA145: TNxNumberEdit;
    DATA146: TNxNumberEdit;
    DATA147: TNxNumberEdit;
    AdvGroupBox2: TAdvGroupBox;
    JvLabel9: TJvLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    DATA118: TNxNumberEdit;
    DATA119: TNxNumberEdit;
    DATA120: TNxNumberEdit;
    AdvGroupBox1: TAdvGroupBox;
    JvLabel8: TJvLabel;
    JvLabel10: TJvLabel;
    JvLabel11: TJvLabel;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    JvLabel62: TJvLabel;
    AdvGroupBox15: TAdvGroupBox;
    JvLabel56: TJvLabel;
    JvLabel57: TJvLabel;
    JvLabel63: TJvLabel;
    JvLabel64: TJvLabel;
    JvLabel65: TJvLabel;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    DATA148: TNxNumberEdit;
    DATA149: TNxNumberEdit;
    DATA150: TNxNumberEdit;
    DATA151: TNxNumberEdit;
    DATA152: TNxNumberEdit;
    AdvGroupBox4: TAdvGroupBox;
    JvLabel13: TJvLabel;
    JvLabel14: TJvLabel;
    JvLabel15: TJvLabel;
    JvLabel16: TJvLabel;
    JvLabel17: TJvLabel;
    Label11: TLabel;
    DATA133: TNxNumberEdit;
    DATA134: TNxNumberEdit;
    DATA135: TNxNumberEdit;
    DATA136: TNxNumberEdit;
    DATA137: TNxNumberEdit;
    DATA138: TNxNumberEdit;
    DATA139: TNxNumberEdit;
    DATA140: TNxNumberEdit;
    DATA141: TNxNumberEdit;
    DATA142: TNxNumberEdit;
    AdvGroupBox17: TAdvGroupBox;
    JvLabel60: TJvLabel;
    JvLabel61: TJvLabel;
    Label33: TLabel;
    Label101: TLabel;
    DATA143: TNxNumberEdit;
    DATA144: TNxNumberEdit;
    AdvGroupBox13: TAdvGroupBox;
    Bevel4: TBevel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    JvLabel51: TJvLabel;
    JvLabel52: TJvLabel;
    DATA56: TNxNumberEdit;
    DATA57: TNxNumberEdit;
    DATA58: TNxNumberEdit;
    DATA59: TNxNumberEdit;
    DATA60: TNxNumberEdit;
    DATA61: TNxNumberEdit;
    DATA62: TNxNumberEdit;
    DATA63: TNxNumberEdit;
    DATA64: TNxNumberEdit;
    DATA65: TNxNumberEdit;
    DATA66: TNxNumberEdit;
    DATA67: TNxNumberEdit;
    DATA68: TNxNumberEdit;
    DATA69: TNxNumberEdit;
    DATA70: TNxNumberEdit;
    DATA71: TNxNumberEdit;
    DATA72: TNxNumberEdit;
    DATA73: TNxNumberEdit;
    DATA74: TNxNumberEdit;
    DATA75: TNxNumberEdit;
    AdvGroupBox14: TAdvGroupBox;
    Bevel5: TBevel;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    Label88: TLabel;
    Label89: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    JvLabel53: TJvLabel;
    JvLabel54: TJvLabel;
    DATA36: TNxNumberEdit;
    DATA37: TNxNumberEdit;
    DATA38: TNxNumberEdit;
    DATA39: TNxNumberEdit;
    DATA40: TNxNumberEdit;
    DATA41: TNxNumberEdit;
    DATA42: TNxNumberEdit;
    DATA43: TNxNumberEdit;
    DATA44: TNxNumberEdit;
    DATA45: TNxNumberEdit;
    DATA46: TNxNumberEdit;
    DATA47: TNxNumberEdit;
    DATA48: TNxNumberEdit;
    DATA49: TNxNumberEdit;
    DATA50: TNxNumberEdit;
    DATA51: TNxNumberEdit;
    DATA52: TNxNumberEdit;
    DATA53: TNxNumberEdit;
    DATA54: TNxNumberEdit;
    DATA55: TNxNumberEdit;
    AdvGroupBox16: TAdvGroupBox;
    Label69: TLabel;
    Label70: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    Label95: TLabel;
    Label96: TLabel;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    Label100: TLabel;
    JvLabel59: TJvLabel;
    DATA76: TNxNumberEdit;
    DATA77: TNxNumberEdit;
    DATA78: TNxNumberEdit;
    DATA79: TNxNumberEdit;
    DATA80: TNxNumberEdit;
    DATA81: TNxNumberEdit;
    DATA82: TNxNumberEdit;
    DATA83: TNxNumberEdit;
    DATA84: TNxNumberEdit;
    DATA85: TNxNumberEdit;
    Label107: TLabel;
    AdvGroupBox6: TAdvGroupBox;
    JvLabel27: TJvLabel;
    JvLabel28: TJvLabel;
    JvLabel29: TJvLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ASG_ENGINE: TAdvSmoothGauge;
    ASG_TCA: TAdvSmoothGauge;
    ASG_TCB: TAdvSmoothGauge;
    AdvGroupBox7: TAdvGroupBox;
    JvLabel30: TJvLabel;
    JvLabel31: TJvLabel;
    JvLabel32: TJvLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    AdvGroupBox9: TAdvGroupBox;
    JvLabel36: TJvLabel;
    JvLabel37: TJvLabel;
    JvLabel38: TJvLabel;
    JvLabel39: TJvLabel;
    JvLabel40: TJvLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    JvLabel41: TJvLabel;
    JvLabel42: TJvLabel;
    JvLabel43: TJvLabel;
    JvLabel44: TJvLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    JvLabel45: TJvLabel;
    JvLabel46: TJvLabel;
    JvLabel47: TJvLabel;
    JvLabel48: TJvLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    DATA104: TNxNumberEdit;
    DATA105: TNxNumberEdit;
    DATA106: TNxNumberEdit;
    DATA107: TNxNumberEdit;
    DATA108: TNxNumberEdit;
    DATA109: TNxNumberEdit;
    DATA110: TNxNumberEdit;
    DATA111: TNxNumberEdit;
    DATA112: TNxNumberEdit;
    DATA113: TNxNumberEdit;
    DATA114: TNxNumberEdit;
    DATA115: TNxNumberEdit;
    DATA116: TNxNumberEdit;
    AdvGroupBox5: TAdvGroupBox;
    JvLabel18: TJvLabel;
    JvLabel19: TJvLabel;
    JvLabel20: TJvLabel;
    JvLabel21: TJvLabel;
    JvLabel22: TJvLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    JvLabel23: TJvLabel;
    JvLabel24: TJvLabel;
    JvLabel25: TJvLabel;
    JvLabel26: TJvLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label67: TLabel;
    JvLabel49: TJvLabel;
    DATA94: TNxNumberEdit;
    DATA95: TNxNumberEdit;
    DATA96: TNxNumberEdit;
    DATA97: TNxNumberEdit;
    DATA98: TNxNumberEdit;
    DATA99: TNxNumberEdit;
    DATA100: TNxNumberEdit;
    DATA101: TNxNumberEdit;
    DATA102: TNxNumberEdit;
    DATA103: TNxNumberEdit;
    AdvGroupBox11: TAdvGroupBox;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label25: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    JvLabel2: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    Label66: TLabel;
    Label53: TLabel;
    AdvGroupBox10: TAdvGroupBox;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    JvLabel7: TJvLabel;
    DATA86: TNxNumberEdit;
    DATA87: TNxNumberEdit;
    DATA88: TNxNumberEdit;
    DATA89: TNxNumberEdit;
    DATA90: TNxNumberEdit;
    DATA91: TNxNumberEdit;
    DATA92: TNxNumberEdit;
    DATA93: TNxNumberEdit;
    DATA2: TNxNumberEdit;
    DATA3: TNxNumberEdit;
    DATA4: TNxNumberEdit;
    DATA5: TNxNumberEdit;
    DATA6: TNxNumberEdit;
    DATA7: TNxNumberEdit;
    DATA8: TNxNumberEdit;
    DATA9: TNxNumberEdit;
    DATA10: TNxNumberEdit;
    DATA11: TNxNumberEdit;
    DATA1: TNxNumberEdit;
    DATA12: TNxNumberEdit;
    DATA14: TNxNumberEdit;
    DATA15: TNxNumberEdit;
    DATA16: TNxNumberEdit;
    DATA17: TNxNumberEdit;
    DATA18: TNxNumberEdit;
    DATA19: TNxNumberEdit;
    DATA20: TNxNumberEdit;
    DATA21: TNxNumberEdit;
    DATA22: TNxNumberEdit;
    DATA23: TNxNumberEdit;
    DATA13: TNxNumberEdit;
    DATA24: TNxNumberEdit;
    EXH_AVG_CYL1: TNxNumberEdit;
    EXH_AVG_CYL2: TNxNumberEdit;
    EXH_AVG_CYL3: TNxNumberEdit;
    EXH_AVG_CYL4: TNxNumberEdit;
    EXH_AVG_CYL5: TNxNumberEdit;
    EXH_AVG_CYL6: TNxNumberEdit;
    EXH_AVG_CYL7: TNxNumberEdit;
    EXH_AVG_CYL8: TNxNumberEdit;
    EXH_AVG_CYL9: TNxNumberEdit;
    EXH_AVG_CYL10: TNxNumberEdit;
    EXH_AVG_BEFORE: TNxNumberEdit;
    EXH_AVG_AFTER: TNxNumberEdit;
    DATA25: TNxNumberEdit;
    DATA26: TNxNumberEdit;
    DATA27: TNxNumberEdit;
    DATA28: TNxNumberEdit;
    DATA29: TNxNumberEdit;
    DATA30: TNxNumberEdit;
    DATA31: TNxNumberEdit;
    DATA32: TNxNumberEdit;
    DATA33: TNxNumberEdit;
    DATA34: TNxNumberEdit;
    DATA35: TNxNumberEdit;
    DATA121: TNxNumberEdit;
    DATA122: TNxNumberEdit;
    DATA123: TNxNumberEdit;
    DATA124: TNxNumberEdit;
    DATA125: TNxNumberEdit;
    DATA131: TNxNumberEdit;
    DATA126: TNxNumberEdit;
    DATA127: TNxNumberEdit;
    DATA128: TNxNumberEdit;
    DATA129: TNxNumberEdit;
    DATA130: TNxNumberEdit;
    DATA132: TNxNumberEdit;
    procedure btn_CloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_SaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DATA86Change(Sender: TObject);
    procedure DATA56KeyPress(Sender: TObject; var Key: Char);
    procedure DATA2Change(Sender: TObject);
    procedure DATA3Change(Sender: TObject);
    procedure DATA4Change(Sender: TObject);
    procedure DATA5Change(Sender: TObject);
    procedure DATA6Change(Sender: TObject);
    procedure DATA7Change(Sender: TObject);
    procedure DATA8Change(Sender: TObject);
    procedure DATA9Change(Sender: TObject);
    procedure DATA10Change(Sender: TObject);
    procedure DATA11Change(Sender: TObject);
    procedure DATA1Change(Sender: TObject);
    procedure DATA12Change(Sender: TObject);
    procedure cb_FuelTypeDropDown(Sender: TObject);
    procedure et_runhourClick(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure AdvFocusHelper1ShowFocus(Sender: TObject; Control: TWinControl;
      var ShowFocus: Boolean);
  private
    { Private declarations }
    FGetDataThread: TGetDataThread;
    FpjhTouchKeyboard: TpjhPopupTouchKeyBoard;
    FKeyDic: TDictionary<String, String>;
    FOrderNo,
    FEngProjNo: String;
  public
    { Public declarations }
    procedure Get_Saved_Value(aOrderNo:String);

    procedure SetEngProjNo(aProjNo: String);
    function Get_EngineType(aProjNo: String): String;
    function Get_Data_Table(aEngProjNo: String): String;
    procedure Make_Key_Dictionary(aDic: TDictionary<String, String>;
      aEngProjNo: String);
    function Insert_TMS_DATA_LOCAL(aLDS_NO: String): Boolean;
    procedure Insert_TMS_DATA_LOCAL_VALUE(aLDS_NO: String);

    property EngProjNo: String Read FEngProjNo write SetEngProjNo;
  end;

var
  localSheet_Frm: TlocalSheet_Frm;
  procedure Preview_localSheet(aOrderNo,aEngType:String);
  procedure Create_localSheet_Frm(aOrderNo,aPurpose,aEngProjNo: String);


implementation

uses
  DataModule_Unit;

{$R *.dfm}

procedure Preview_localSheet(aOrderNo,aEngType:String);
begin
  localSheet_Frm := TlocalSheet_Frm.Create(nil);
  try
    with localSheet_Frm do
    begin
      //버튼세팅
      btn_Save.Visible := False;

      et_EngType.Text := aEngType;
      FOrderNo := aOrderNo;
      Get_Saved_Value(aOrderNo);
      ShowModal;

    end;
  finally
    FreeAndNil(localSheet_Frm);
  end;
end;

procedure Create_localSheet_Frm(aOrderNo,aPurpose,aEngProjNo: String);
var
  LDataTable: String;
begin
  localSheet_Frm := TlocalSheet_Frm.Create(nil);
  with localSheet_Frm do
  begin
    FOrderNo := aOrderNo;
    if aPurpose = 'A' then
    begin
      et_Purpose.Text := '로컬데이터시트 오픈';
      btn_Save.Visible := False;
    end else
      et_Purpose.Text := aPurpose;

    if aEngProjNo <> '' then
    begin
      SetEngProjNo(aEngProjNo);
      et_EngType.Text := EngProjNo + '-' + Get_EngineType(EngProjNo);
      LDataTable := Get_Data_Table(aEngProjNo);
      if LDataTable = '' then
        Exit;

      FKeyDic := TDictionary<String, String>.Create;
      Make_Key_Dictionary(FKeyDic, aEngProjNo);

      if FKeyDic.Count > 0 then
      begin
        FGetDataThread := TGetDataThread.Create;
        with FGetDataThread do
        begin
          FEngProjNo := aEngProjNo;
          FDataTable := LDataTable;
          FKeyDictionary := FKeyDic;

          Resume;

        end;
      end;
    end;
    Show;
  end;
end;

procedure TlocalSheet_Frm.AdvFocusHelper1ShowFocus(Sender: TObject;
  Control: TWinControl; var ShowFocus: Boolean);
begin
  if Control is TNxNumberEdit then
    ShowFocus := True
  else
    ShowFocus := False;


end;

procedure TlocalSheet_Frm.btn_CloseClick(Sender: TObject);
begin

  Close;

end;

procedure TlocalSheet_Frm.btn_SaveClick(Sender: TObject);
var
  LDS_NO: String;
  i : Integer;
begin
  if Assigned(FGetDataThread) then
    FGetDataThread.Terminate;
  FGetDataThread.WaitFor;

  LDS_NO := 'LDS' + FormatDateTime('yyyyMMddHHmmsszzz', Now);
  if Insert_TMS_DATA_LOCAL(LDS_NO) then
  begin
    Insert_TMS_DATA_LOCAL_VALUE(LDS_NO);
    ShowMessage('등록성공!');
    Close;
  end;
end;

procedure TlocalSheet_Frm.cb_FuelTypeDropDown(Sender: TObject);
var
  OraQuery : TOraQuery;
begin
  FpjhTouchKeyboard.Hide;
  with cb_FuelType.Items do
  begin
    BeginUpdate;
    try
      Clear;
      OraQuery := TOraQuery.Create(nil);
      try
        OraQuery.Session := DM1.OraSession1;
        with OraQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT SUBCODE FROM FUEL_PRICE ' +
                  'GROUP BY SUBCODE ' +
                  'ORDER BY SUBCODE ');
          Open;

          Add('');
          if RecordCount <> 0 then
          begin
            while not eof do
            begin
              Add(FieldByName('SUBCODE').AsString);
              Next;
            end;
          end;
          Add('GAS');
        end;
      finally
        FreeAndNil(OraQuery);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TlocalSheet_Frm.ComboBox1Click(Sender: TObject);
begin
  FpjhTouchKeyboard.Hide;
end;

procedure TlocalSheet_Frm.DATA10Change(Sender: TObject);
begin
  if (DATA10.Value <> 0) AND (DATA22.Value <> 0) then
    EXH_AVG_CYL9.Value := Round((DATA10.Value+DATA22.Value)/2)
  else
    EXH_AVG_CYL9.Value := DATA10.Value;
end;

procedure TlocalSheet_Frm.DATA11Change(Sender: TObject);
begin
  if (DATA11.Value <> 0) AND (DATA23.Value <> 0) then
    EXH_AVG_CYL10.Value := Round((DATA11.Value+DATA23.Value)/2)
  else
    EXH_AVG_CYL10.Value := DATA11.Value;
end;

procedure TlocalSheet_Frm.DATA12Change(Sender: TObject);
begin
  if (DATA12.Value <> 0) AND (DATA24.Value <> 0) then
    EXH_AVG_AFTER.Value := Round((DATA12.Value+DATA24.Value)/2)
  else
    EXH_AVG_AFTER.Value := DATA12.Value;
end;

procedure TlocalSheet_Frm.DATA1Change(Sender: TObject);
begin
  if (DATA1.Value <> 0) AND (DATA13.Value <> 0) then
    EXH_AVG_BEFORE.Value := Round((DATA1.Value+DATA13.Value)/2)
  else
    EXH_AVG_BEFORE.Value := DATA1.Value;
end;

procedure TlocalSheet_Frm.DATA2Change(Sender: TObject);
begin
  if (DATA2.Value <> 0) AND (DATA14.Value <> 0) then
    EXH_AVG_CYL1.Value := Round((DATA2.Value + DATA14.Value) / 2)
  else
    EXH_AVG_CYL1.Value := DATA2.Value;

end;

procedure TlocalSheet_Frm.DATA3Change(Sender: TObject);
begin
  if (DATA3.Value <> 0) AND (DATA15.Value <> 0) then
    EXH_AVG_CYL2.Value := Round((DATA3.Value + DATA15.Value) / 2)
  else
    EXH_AVG_CYL2.Value := DATA3.Value;
end;

procedure TlocalSheet_Frm.DATA4Change(Sender: TObject);
begin
  if (DATA4.Value <> 0) AND (DATA16.Value <> 0) then
    EXH_AVG_CYL3.Value := Round((DATA4.Value+DATA16.Value)/2)
  else
    EXH_AVG_CYL3.Value := DATA4.Value;
end;

procedure TlocalSheet_Frm.DATA56KeyPress(Sender: TObject; var Key: Char);
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
      FpjhTouchKeyboard.Hide;
  end
  else
  begin
    if Pos(Key, BadChars) > 0 then
    begin
      Exit;
    end;
  end;
end;

procedure TlocalSheet_Frm.DATA5Change(Sender: TObject);
begin
  if (DATA5.Value <> 0) AND (DATA17.Value <> 0) then
    EXH_AVG_CYL4.Value := Round((DATA5.Value+DATA17.Value)/2)
  else
    EXH_AVG_CYL4.Value := DATA5.Value;
end;

procedure TlocalSheet_Frm.DATA6Change(Sender: TObject);
begin
  if (DATA6.Value <> 0) AND (DATA18.Value <> 0) then
    EXH_AVG_CYL5.Value := Round((DATA6.Value+DATA18.Value)/2)
  else
    EXH_AVG_CYL5.Value := DATA6.Value;
end;

procedure TlocalSheet_Frm.DATA7Change(Sender: TObject);
begin
  if (DATA7.Value <> 0) AND (DATA19.Value <> 0) then
    EXH_AVG_CYL6.Value := Round((DATA7.Value+DATA19.Value)/2)
  else
    EXH_AVG_CYL6.Value := DATA7.Value;
end;

procedure TlocalSheet_Frm.DATA8Change(Sender: TObject);
begin
  if (DATA8.Value <> 0) AND (DATA20.Value <> 0) then
    EXH_AVG_CYL7.Value := Round((DATA8.Value+DATA20.Value)/2)
  else
    EXH_AVG_CYL7.Value := DATA8.Value;
end;

procedure TlocalSheet_Frm.DATA9Change(Sender: TObject);
begin
  if (DATA9.Value <> 0) AND (DATA21.Value <> 0) then
    EXH_AVG_CYL8.Value := Round((DATA9.Value+DATA21.Value)/2)
  else
    EXH_AVG_CYL8.Value := DATA9.Value;
end;

procedure TlocalSheet_Frm.et_runhourClick(Sender: TObject);
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

procedure TlocalSheet_Frm.DATA86Change(Sender: TObject);
begin
  if Sender is TNxNumberEdit then
  begin
    with Sender as TNxNumberEdit do
    begin
      if Name = 'DATA86' then
        ASG_ENGINE.Value := Value;
      if Name = 'DATA87' then
        ASG_TCA.Value := Value;
      if Name = 'DATA89' then
        ASG_TCB.Value := Value;
    end;

  end;

end;

procedure TlocalSheet_Frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FGetDataThread) then
  begin
    FGetDataThread.Terminate;
    FGetDataThread.WaitFor;
    FGetDataThread.Free;
  end;

  if Assigned(FpjhTouchKeyboard) then
    FpjhTouchKeyboard.Free;

  FreeAndNil(FKeyDic);
  Action := caFree;
end;

procedure TlocalSheet_Frm.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 1;
  FpjhTouchKeyboard := TpjhPopupTouchKeyBoard.Create(Self);
end;

function TlocalSheet_Frm.Get_Data_Table(aEngProjNo: String): String;
begin
  Result := '';
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT OWNER, TABLE_NAME FROM MON_TABLES ' +
            'WHERE ENG_PROJNO LIKE :param1 ');

    ParamByName('param1').AsString := aEngProjNo;
    Open;

    if RecordCount <> 0 then
      Result := FieldByName('OWNER').AsString + '.' +
        FieldByName('TABLE_NAME').AsString;

  end;
end;

function TlocalSheet_Frm.Get_EngineType(aProjNo: String): String;
var
  OraQuery: TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;
    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT ENGTYPE FROM HIMSEN_INFO ' +
        'WHERE PROJNO LIKE :param1 ');
      ParamByName('param1').AsString := aProjNo;
      Open;

      if RecordCount <> 0 then
        Result := FieldByName('ENGTYPE').AsString;

    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

procedure TlocalSheet_Frm.Get_Saved_Value(aOrderNo: String);
var
  LColumn : String;
  i : Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM TMS_DATA_LOCAL ' +
            'WHERE ORDER_NO LIKE :param1 ');
    ParamByName('param1').AsString := aOrderNo;
    Open;

    if RecordCount <> 0 then
    begin
      et_Purpose.Text := FieldByName('LDS_PURPOSE').AsString;
      cb_FuelType.Items.Clear;
      cb_FuelType.Items.Add(FieldByName('LDS_FUEL_TYPE').AsString);
      cb_FuelType.ItemIndex := 0;
      et_load.Value := FieldByName('LDS_LOAD').AsInteger;
      et_runhour.Value := FieldByName('LDS_RUNHOUR').AsFloat;

      Close;
      SQL.Clear;
      SQL.Add('SELECT B.* FROM TMS_DATA_LOCAL A, TMS_DATA_LOCAL_VALUE B ' +
              'WHERE A.LDS_NO = B.LDS_NO ' +
              'AND A.ORDER_NO LIKE :param1 ');

      ParamByName('param1').AsString := aOrderNo;
      Open;

      for i := 1 to Fields.Count-1 do
      begin
        LColumn := 'DATA'+IntToStr(i);
        try
          with TNxNumberEdit(Self.FindComponent(LColumn)) do
          begin
            Value := Fields[i].AsFloat;
          end;
        except
          on E : Exception do
            ShowMessage(E.Message);
        end;
      end;
    end;
  end;
end;

function TlocalSheet_Frm.Insert_TMS_DATA_LOCAL(aLDS_NO: String): Boolean;
begin
  Result := False;
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO TMS_DATA_LOCAL ' +
      '(ORDER_NO, LDS_NO, LDS_DATE, LDS_ENGPROJ, LDS_PURPOSE, LDS_FUEL_TYPE, ' +
      ' LDS_LOAD, LDS_RUNHOUR, LDS_ID) VALUES ' +
      '(:ORDER_NO, :LDS_NO, :LDS_DATE, :LDS_ENGPROJ, :LDS_PURPOSE, :LDS_FUEL_TYPE, ' +
      ' :LDS_LOAD, :LDS_RUNHOUR, :LDS_ID) ');

    ParamByName('ORDER_NO').AsString       := FOrderNo;

    ParamByName('LDS_NO').AsString        := aLDS_NO;
    ParamByName('LDS_DATE').AsDateTime    := Now;
    ParamByName('LDS_ENGPROJ').AsString   := EngProjNo;
    ParamByName('LDS_PURPOSE').AsString   := et_Purpose.Text;
    ParamByName('LDS_FUEL_TYPE').AsString := cb_FuelType.Text;
    ParamByName('LDS_LOAD').AsInteger     := et_load.AsInteger;
    ParamByName('LDS_RUNHOUR').AsFloat    := et_runhour.AsFloat;
//    ParamByName('LDS_ID').AsString        := CurrentUsers;
    ExecSQL;
    Result := True;
  end;
end;

procedure TlocalSheet_Frm.Insert_TMS_DATA_LOCAL_VALUE(aLDS_NO: String);
var
  i: Integer;
  Column, Value: String;
  LSQL: String;
begin
  LSQL := 'Values( ''' + aLDS_NO + ''',';

  for i := 1 to 152 do
  begin
    Column := 'DATA' + IntToStr(i);
    Value := TNxNumberEdit(FindComponent(Column)).AsString;
    LSQL := LSQL + Value +',';
  end;

  LSQL := Copy(LSQL, 1, Length(LSQL) - 1);
  LSQL := LSQL + ')';

  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO TMS_DATA_LOCAL_VALUE ');
    SQL.Add(LSQL);
    ExecSQL;
  end;
end;

procedure TlocalSheet_Frm.Make_Key_Dictionary(aDic: TDictionary<String, String>;
  aEngProjNo: String);
begin
  with aDic do
  begin
    Clear;
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM MON_MAP ' + 'WHERE DATA_ENGPROJNO LIKE :param1 ' +
        'ORDER BY SEQ_NO ');
      ParamByName('param1').AsString := aEngProjNo;
      Open;

      if RecordCount <> 0 then
      begin
        while not eof do
        begin
          Add(FieldByName('KEY').AsString, FieldByName('DATA_COLUMN').AsString);
          Next;
        end;
      end;
    end;
  end;
end;

procedure TlocalSheet_Frm.SetEngProjNo(aProjNo: String);
begin
  FEngProjNo := aProjNo;
end;

{ TGetDataThread }

constructor TGetDataThread.Create;
begin
  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TGetDataThread.Destroy;
begin

  inherited;
end;

procedure TGetDataThread.UpdateVCL;
var
  i, j: Integer;
  LKeyName, LDataColumn: String;
  LValue: Double;

begin
  with localSheet_Frm do
  begin
    Caption := FormatDateTime('yyyy-MM-dd HH:mm:ss', Now);

    for LKeyName in FKeyDictionary.Keys do
    begin
      if FKeyDictionary.TryGetValue(LKeyName, LDataColumn) then
      begin
        with DM1.OraQuery1 do
        begin
          LValue := FieldByName(LDataColumn).AsFloat;
        end;

        for i := 0 to ComponentCount - 1 do
        begin
          if Components[i] is TNxNumberEdit then
          begin
            if (Components[i] as TNxNumberEdit).Hint = LKeyName then
            begin
              (Components[i] as TNxNumberEdit).Value := LValue;
              Break;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TGetDataThread.Execute;
begin
  while not Terminated do
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM ' + FDataTable +
              ' WHERE DATASAVEDTIME LIKE ' +
              ' ( ' +
              '    SELECT MAX(DATASAVEDTIME) FROM ' + FDataTable +
              '    WHERE DATASAVEDTIME LIKE :param1 ' + ' ) ');

      ParamByName('param1').AsString := FormatDateTime('yyyyMMddHHmm',Now) + '%';
      try
        Open;
        if RecordCount <> 0 then
        begin

          Synchronize(UpdateVCL);

        end;
      except
        Terminate;
      end;
    end;
    Application.ProcessMessages;
  end;
end;

end.
