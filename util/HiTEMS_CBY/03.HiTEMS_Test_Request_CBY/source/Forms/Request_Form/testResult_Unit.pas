unit testResult_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxCollection, Vcl.StdCtrls, AeroButtons,
  JvExControls, JvLabel, CurvyControls, Vcl.ImgList, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, AdvOfficeTabSet, NxColumnClasses, NxColumns, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ComCtrls, Ora, DB,
  ComObj, Vcl.Menus;

type
  TtestResult_Frm = class(TForm)
    Panel8: TPanel;
    Image1: TImage;
    ImageList16x16: TImageList;
    ImageList32x32: TImageList;
    ImgList24x24: TImageList;
    CurvyPanel1: TCurvyPanel;
    JvLabel11: TJvLabel;
    btn_Close: TAeroButton;
    JvLabel15: TJvLabel;
    et_reqName: TEdit;
    Button1: TButton;
    et_DelEdit: TButton;
    NxHeaderPanel2: TNxHeaderPanel;
    JvLabel10: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel7: TJvLabel;
    et_testPurpose: TEdit;
    et_EngLoc: TEdit;
    et_reqDept: TEdit;
    et_reqIncharge: TEdit;
    et_engType: TEdit;
    et_begin: TEdit;
    et_end: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    JvLabel8: TJvLabel;
    JvLabel12: TJvLabel;
    et_method: TMemo;
    fileGrid: TNextGrid;
    NxIncrementColumn3: TNxIncrementColumn;
    NxTextColumn8: TNxTextColumn;
    NxTextColumn11: TNxTextColumn;
    NxTextColumn12: TNxTextColumn;
    NxTextColumn19: TNxTextColumn;
    NxTextColumn20: TNxTextColumn;
    TabSheet2: TTabSheet;
    JvLabel9: TJvLabel;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    AdvOfficeTabSet1: TAdvOfficeTabSet;
    grid_orders: TNextGrid;
    NxTreeColumn2: TNxTreeColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    NxTextColumn14: TNxTextColumn;
    NxTextColumn15: TNxTextColumn;
    NxTextColumn16: TNxTextColumn;
    NxTextColumn17: TNxTextColumn;
    NxImageColumn1: TNxImageColumn;
    NxImageColumn2: TNxImageColumn;
    grid_buss: TNextGrid;
    NxTextColumn18: TNxTextColumn;
    NxTextColumn21: TNxTextColumn;
    NxTextColumn22: TNxTextColumn;
    NxNumberColumn1: TNxNumberColumn;
    NxIncrementColumn1: TNxIncrementColumn;
    NxTextColumn23: TNxTextColumn;
    NxTextColumn24: TNxTextColumn;
    TabSheet5: TTabSheet;
    grid_part: TNextGrid;
    NxIncrementColumn2: TNxIncrementColumn;
    NxTextColumn2: TNxTextColumn;
    NxNumberColumn2: TNxNumberColumn;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn10: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn9: TNxTextColumn;
    NxTextColumn13: TNxTextColumn;
    NxTextColumn25: TNxTextColumn;
    NxTextColumn26: TNxTextColumn;
    NxTextColumn27: TNxTextColumn;
    NxTextColumn28: TNxTextColumn;
    NxTextColumn29: TNxTextColumn;
    grid_Result: TNextGrid;
    NxIncrementColumn4: TNxIncrementColumn;
    NxTextColumn30: TNxTextColumn;
    NxTextColumn31: TNxTextColumn;
    NxImageColumn3: TNxImageColumn;
    SaveDialog1: TSaveDialog;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure et_DelEditClick(Sender: TObject);
    procedure AdvOfficeTabSet1Change(Sender: TObject);
    procedure grid_OrdersCustomDrawCell(Sender: TObject; ACol, ARow: Integer;
      CellRect: TRect; CellState: TCellState);
    procedure grid_ordersCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure FormCreate(Sender: TObject);
    procedure grid_bussCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure grid_partCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure grid_ResultCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure N1Click(Sender: TObject);
    procedure grid_partMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FPlanNo:String;
  public
    FLastSelectedRow_PartGrid: integer;

    function GetButtonRect(ARect:TRect;Level:Integer):TRect;
    function Get_Order_Msg(aOrderNo:String):String;

    procedure Init_Request_Info;
    procedure Get_Work_Days(aReqNo:String);
    procedure Get_Work_Orders(aReqNo,aPerform:String);
    procedure Get_Attfiles(aGrid:TNextGrid;aOwner:String);
    procedure Get_Choose_List(aIdx:Integer;aPartNo: String);
    procedure Get_Request_Resource(aReqNo:String);
    procedure Open_the_Work_sheet(aOrderNo,aCode:String);
    procedure Get_Buss_Log_Info(aReqNo:String);
    procedure Init_Result_Tab;

    procedure Gen_Measurement_Report;



  end;

var
  testResult_Frm: TtestResult_Frm;
  procedure View_Test_Result(aReqName,aReqNo:String);

implementation
uses
  detailPartInfo_Unit,
  resultDialog_Unit,
  checkChangePart_Unit,
  shimDataSheet_Unit,
  localSheet_Unit,
  CommonUtil_Unit,
  DataModule_Unit;

{$R *.dfm}

procedure View_Test_Result(aReqName,aReqNo:String);
begin
  testResult_Frm := TtestResult_Frm.Create(nil);
  try
    with testResult_Frm do
    begin
      Init_Request_Info;

      et_reqName.Text := aReqName;
      et_reqName.Hint := aReqNo;

      PageControl2.Pages[0].TabVisible := False;
      PageControl2.Pages[1].TabVisible := False;

      if et_reqName.Hint <> '' then
      begin
        with DM1.OraQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM TMS_TEST_RECEIVE_INFO ' +
                  'WHERE REQ_NO LIKE :param1 ');
          ParamByName('param1').AsString := et_reqName.Hint;

          Open;

          if RecordCount > 0 then
            FPlanNo := FieldByName('PLAN_NO').AsString;
        end;

        Get_Request_Resource(et_reqName.Hint);
        Get_Work_Days(et_reqName.Hint);
        Get_Buss_Log_Info(et_reqName.Hint);
      end;

      ShowModal;
    end;
  finally
    FreeAndNil(testResult_Frm);
  end;
end;

procedure TtestResult_Frm.AdvOfficeTabSet1Change(Sender: TObject);
var
  i : Integer;
begin
  i := AdvOfficeTabSet1.ActiveTabIndex;
  Get_Work_Orders(et_reqName.Hint, AdvOfficeTabSet1.AdvOfficeTabs[i].Caption);
end;

procedure TtestResult_Frm.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TtestResult_Frm.Button1Click(Sender: TObject);
var
  LReqNo:String;
begin
  Init_Request_Info;
//  et_reqName.Hint := Get_selected_Test(et_reqName.Text);
  if et_reqName.Hint <> '' then
  begin
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TMS_TEST_RECEIVE_INFO ' +
              'WHERE REQ_NO LIKE :param1 ');
      ParamByName('param1').AsString := et_reqName.Hint;
      Open;

      if RecordCount <> 0 then
        FPlanNo := FieldByName('PLAN_NO').AsString;

    end;

    Get_Request_Resource(et_reqName.Hint);
    Get_Work_Days(et_reqName.Hint);
    Get_Buss_Log_Info(et_reqName.Hint);

  end;
end;

procedure TtestResult_Frm.et_DelEditClick(Sender: TObject);
begin

  Init_Request_Info;

end;

procedure TtestResult_Frm.FormCreate(Sender: TObject);
begin
  Init_Result_Tab;
  AdvOfficeTabSet1.AdvOfficeTabs.Clear;
  PageControl1.ActivePageIndex := 0;
  PageControl2.ActivePageIndex := 0;

end;

procedure TtestResult_Frm.Gen_Measurement_Report;
const
  ldec = 7;
var
  XL, oWB, oSheet, oRng : variant;
  xlRowCount, xlColCount,
  MyResourceStream: TResourceStream;
  i : Integer;
  LSheetName : String;
  LColPos : String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ' +
            '  A.*, ' +
            '  (SELECT ENGTYPE FROM HIMSEN_INFO WHERE PROJNO LIKE A.LDS_ENGPROJ) ENG_TYPE, ' +
            '  (SELECT RPM FROM HIMSEN_INFO WHERE PROJNO LIKE A.LDS_ENGPROJ) ENG_CYLNUM, ' +
            '  (SELECT BORE FROM HIMSEN_INFO WHERE PROJNO LIKE A.LDS_ENGPROJ) ENG_BORE, ' +
            '  (SELECT STROKE FROM HIMSEN_INFO WHERE PROJNO LIKE A.LDS_ENGPROJ) ENG_STROKE, ' +
            '  (SELECT RPM FROM HIMSEN_INFO WHERE PROJNO LIKE A.LDS_ENGPROJ) ENG_RPM, ' +
            '  B.* ' +
            'FROM TMS_DATA_LOCAL A, TMS_DATA_LOCAL_VALUE B ' +
            'WHERE A.LDS_NO = B.LDS_NO ' +
            'AND ORDER_NO IN ( ' +
            '   SELECT ORDER_NO FROM TMS_WORK_ORDERS ' +
            '   WHERE PLAN_NO LIKE ( ' +
            '       SELECT PLAN_NO FROM TMS_TEST_RECEIVE_INFO ' +
            '       WHERE REQ_NO LIKE :param1 ' +
            '   )' +
            ') ' +
            'ORDER BY LDS_DATE ');
    ParamByName('param1').AsString := et_reqName.Hint;
    Open;

    if RecordCount <> 0 then
    begin
      SaveDialog1.FileName := et_reqName.Text+'_LDS_Report.xls';
      if SaveDialog1.Execute then
      begin
        MyResourceStream := TResourceStream.Create(hInstance, 'Resource_1', RT_RCDATA);
        try
          MyResourceStream.SaveToFile(SaveDialog1.FileName);

          XL := CreateOleObject('Excel.Application');
          try
            XL.DisplayAlerts := False;
            XL.visible := False;
            try
              oWB := XL.WorkBooks.Open(SaveDialog1.FileName);
              oSheet := oWB.Sheets['Summary'].Select;

              XL.Range['P1'].Select;
              XL.ActiveCell.FormulaR1C1 := 'Page : 1 of '+IntToStr(RecordCount+1);

              XL.Range['D3'].Select;
              XL.ActiveCell.FormulaR1C1 := FieldByName('LDS_ENGPROJ').AsString;

              XL.Range['D4'].Select;
              XL.ActiveCell.FormulaR1C1 := FieldByName('ENG_TYPE').AsString;

              XL.Range['I4'].Select;
              XL.ActiveCell.FormulaR1C1 := FieldByName('ENG_CYLNUM').AsString;

              XL.Range['L4'].Select;
              XL.ActiveCell.FormulaR1C1 := IntToStr(FieldByName('ENG_BORE').AsInteger*10);

              XL.Range['P4'].Select;
              XL.ActiveCell.FormulaR1C1 := IntToStr(FieldByName('ENG_STROKE').AsInteger*10);

              LSheetName := 'LP';
              for i := 0 to RecordCount-1 do
              begin
                oWB.Sheets['LP'].Copy(After := oWB.Sheets[LSheetName]);
                oSheet := oWB.ActiveSheet;

                XL.Range['P1'].Select;
                XL.ActiveCell.FormulaR1C1 := 'Page : '+IntToStr(2+i)+' of '+IntToStr(RecordCount+1);

                LSheetName  := 'LP'+IntToStr(1+i)+'_'+FieldByName('LDS_LOAD').AsString;
                oSheet.Name := LSheetName;

                XL.Range['D3'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('LDS_ENGPROJ').AsString;

                XL.Range['D4'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('ENG_TYPE').AsString;

                XL.Range['D5'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('ENG_CYLNUM').AsString;

                XL.Range['D6'].Select;
                XL.ActiveCell.FormulaR1C1 := IntToStr(FieldByName('ENG_BORE').AsInteger*10);

                XL.Range['D7'].Select;
                XL.ActiveCell.FormulaR1C1 := IntToStr(FieldByName('ENG_STROKE').AsInteger*10);

                XL.Range['G3'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('LDS_LOAD').AsString;

                XL.Range['G4'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA86').AsString;

                XL.Range['G7'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA117').AsString;

                XL.Range['J4'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA91').AsString;

                XL.Range['J6'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA92').AsString;

                XL.Range['J7'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA93').AsString;

                XL.Range['N3'].Select;
                XL.ActiveCell.FormulaR1C1 := FormatDateTime('YYYY-MM-DD',FieldByName('LDS_DATE').AsDateTime);

                XL.Range['N4'].Select;
                XL.ActiveCell.FormulaR1C1 := FormatDateTime('HH:mm',FieldByName('LDS_DATE').AsDateTime);

                XL.Range['N5'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA145').AsString;

                XL.Range['N6'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA146').AsString;

                XL.Range['N7'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA147').AsString;

                //SYSTEM PRESSURE
                XL.Range['C10'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA97').AsString;

                XL.Range['D10'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA98').AsString;

                XL.Range['E10'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA99').AsString;

                XL.Range['G10'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA96').AsString;

                XL.Range['K10'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA95').AsString;

                //SYSTEM TEMP.
                XL.Range['D11'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA116').AsString;

                XL.Range['G11'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA112').AsString;

                XL.Range['H11'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA113').AsString;

                XL.Range['I11'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA114').AsString;

                XL.Range['K11'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA109').AsString;

                XL.Range['L11'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA110').AsString;

                XL.Range['M11'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA111').AsString;

                //P-Max@PMI
                XL.Range['F22'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA56').AsString;

                XL.Range['G22'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA57').AsString;

                XL.Range['H22'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA58').AsString;

                XL.Range['I22'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA59').AsString;

                XL.Range['J22'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA60').AsString;

                XL.Range['K22'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA61').AsString;

                XL.Range['L22'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA62').AsString;

                XL.Range['M22'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA63').AsString;

                XL.Range['N22'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA64').AsString;

                XL.Range['O22'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA65').AsString;

                XL.Range['F23'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA66').AsString;

                XL.Range['G23'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA67').AsString;

                XL.Range['H23'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA68').AsString;

                XL.Range['I23'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA69').AsString;

                XL.Range['J23'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA70').AsString;

                XL.Range['K23'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA71').AsString;

                XL.Range['L23'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA72').AsString;

                XL.Range['M23'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA73').AsString;

                XL.Range['N23'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA74').AsString;

                XL.Range['O23'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA75').AsString;


                //FIP-INDEX
                XL.Range['F24'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA36').AsString;

                XL.Range['G24'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA37').AsString;

                XL.Range['H24'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA38').AsString;

                XL.Range['I24'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA39').AsString;

                XL.Range['J24'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA40').AsString;

                XL.Range['K24'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA41').AsString;

                XL.Range['L24'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA42').AsString;

                XL.Range['M24'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA43').AsString;

                XL.Range['N24'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA44').AsString;

                XL.Range['O24'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA45').AsString;

                //B
                XL.Range['F25'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA46').AsString;

                XL.Range['G25'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA47').AsString;

                XL.Range['H25'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA48').AsString;

                XL.Range['I25'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA49').AsString;

                XL.Range['J25'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA50').AsString;

                XL.Range['K25'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA51').AsString;

                XL.Range['L25'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA52').AsString;

                XL.Range['M25'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA53').AsString;

                XL.Range['N25'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA54').AsString;

                XL.Range['O25'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA55').AsString;


                //Texh
                XL.Range['F32'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA2').AsString;

                XL.Range['G32'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA3').AsString;

                XL.Range['H32'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA4').AsString;

                XL.Range['I32'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA5').AsString;

                XL.Range['J32'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA6').AsString;

                XL.Range['K32'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA7').AsString;

                XL.Range['L32'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA8').AsString;

                XL.Range['M32'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA9').AsString;

                XL.Range['N32'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA10').AsString;

                XL.Range['O32'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA11').AsString;

                //B
                XL.Range['F33'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA14').AsString;

                XL.Range['G33'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA15').AsString;

                XL.Range['H33'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA16').AsString;

                XL.Range['I33'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA17').AsString;

                XL.Range['J33'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA18').AsString;

                XL.Range['K33'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA19').AsString;

                XL.Range['L33'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA20').AsString;

                XL.Range['M33'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA21').AsString;

                XL.Range['N33'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA22').AsString;

                XL.Range['O33'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA23').AsString;

                //OMD
                XL.Range['F36'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA76').AsString;

                XL.Range['G36'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA77').AsString;

                XL.Range['H36'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA78').AsString;

                XL.Range['I36'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA79').AsString;

                XL.Range['J36'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA80').AsString;

                XL.Range['K36'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA81').AsString;

                XL.Range['L36'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA82').AsString;

                XL.Range['M36'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA83').AsString;

                XL.Range['N36'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA84').AsString;

                XL.Range['O36'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA85').AsString;

                //Main-Bearing Temp
                XL.Range['F37'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA25').AsString;

                XL.Range['G37'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA26').AsString;

                XL.Range['H37'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA27').AsString;

                XL.Range['I37'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA28').AsString;

                XL.Range['J37'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA29').AsString;

                XL.Range['K37'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA30').AsString;

                XL.Range['L37'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA31').AsString;

                XL.Range['M37'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA32').AsString;

                XL.Range['N37'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA33').AsString;

                XL.Range['O37'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA34').AsString;

                XL.Range['P37'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA35').AsString;

                // T/C TEMP.
                XL.Range['C42'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA104').AsString;

                XL.Range['E42'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA105').AsString;

                XL.Range['G42'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA106').AsString;

                XL.Range['F42'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA107').AsString;

                XL.Range['K42'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA108').AsString;

                XL.Range['M42'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA1').AsString;

                XL.Range['O42'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA12').AsString;

                XL.Range['M43'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA13').AsString;

                XL.Range['O43'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA24').AsString;

                // T/C PRESSURE.
                XL.Range['C46'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA133').AsString;

                XL.Range['E46'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA135').AsString;

                XL.Range['G46'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA137').AsString;

                XL.Range['K46'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA139').AsString;

                XL.Range['O46'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA141').AsString;

                // T/C SPEED
                XL.Range['E48'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA87').AsString;

                XL.Range['G48'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA89').AsString;

                // F.O
                XL.Range['E50'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA115').AsString;

                XL.Range['E52'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA101').AsString;

                // NOx
                XL.Range['E58'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA148').AsString;

                XL.Range['G58'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA149').AsString;

                XL.Range['F58'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA150').AsString;

                XL.Range['K58'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA151').AsString;

                XL.Range['M58'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA152').AsString;

                XL.Range['O58'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA118').AsString;

                XL.Range['P58'].Select;
                XL.ActiveCell.FormulaR1C1 := FieldByName('DATA119').AsString;

                //Summary 입력
                oSheet := oWB.Sheets['Summary'].Select;
//                LColPos := Chr(ldec+i);
                LColPos := ColNumToName(ldec+i);

                XL.Range[LColPos+'21'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!G3';

                XL.Range[LColPos+'23'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!N4';

                XL.Range[LColPos+'24'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!N5';

                XL.Range[LColPos+'25'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!N6';

                XL.Range[LColPos+'26'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!N7';

                XL.Range[LColPos+'27'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!G4';

                XL.Range[LColPos+'28'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!J4';

                XL.Range[LColPos+'29'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!G6';

                XL.Range[LColPos+'30'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!G7';

                XL.Range[LColPos+'31'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!G10';

                XL.Range[LColPos+'32'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!H11';

                XL.Range[LColPos+'33'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!I11';

                XL.Range[LColPos+'34'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!K10';

                XL.Range[LColPos+'35'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!L11';

                XL.Range[LColPos+'36'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!O11';

                XL.Range[LColPos+'37'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!C10';

                XL.Range[LColPos+'38'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!D10';

                XL.Range[LColPos+'39'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!E10';

                XL.Range[LColPos+'40'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!D11';

                XL.Range[LColPos+'41'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!E51';

                XL.Range[LColPos+'42'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!E50';

                XL.Range[LColPos+'43'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!E37';

                XL.Range[LColPos+'44'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!E16';

                XL.Range[LColPos+'46'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!E22';

                XL.Range[LColPos+'48'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!E24';

                XL.Range[LColPos+'49'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!E46';

                XL.Range[LColPos+'50'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!E42';

                XL.Range[LColPos+'51'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!G42';

                XL.Range[LColPos+'52'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!I42';

                XL.Range[LColPos+'53'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!K42';

                XL.Range[LColPos+'60'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!E32';

                XL.Range[LColPos+'62'].Select;
                XL.ActiveCell.Value := '=AVERAGE('+LSheetName+'!M42:N43)';

                XL.Range[LColPos+'63'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!O46';

                XL.Range[LColPos+'64'].Select;
                XL.ActiveCell.Value := '=AVERAGE('+LSheetName+'!O42:P43)';

                XL.Range[LColPos+'65'].Select;
                XL.ActiveCell.Value := '=AVERAGE('+LSheetName+'!E48:H48)';

                XL.Range[LColPos+'66'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!E24';

                XL.Range[LColPos+'76'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!O58';

                XL.Range[LColPos+'77'].Select;
                XL.ActiveCell.Value := '='+LSheetName+'!P58';

                Next;
              end;
            finally
              oWB.Sheets['LP'].Delete;
              XL.visible := True;
            end;
          except
            MessageDlg('Excel이 설치되어 있지 않습니다.'+#13+
              '이 기능을 이용하시려면 반드시 MS오피스 엑셀이 설치되어 있어야 합니다.- ' ,
              MtWarning, [mbok], 0);
            XL.quit;
            XL := Unassigned;
            XL.Visible := True;
          end;
        finally
          FreeAndNil(MyResourceStream);
        end;
      end;
    end else
      ShowMessage('출력할 데이터가 없습니다');
  end;
end;

function TtestResult_Frm.GetButtonRect(ARect: TRect; Level: Integer): TRect;
var
  m, t: Integer;
begin
  m := ARect.Top + (ARect.Bottom - ARect.Top) div 2;
  t := m - 5;
  with Result do
  begin
    Left := Level * 19;
    Left := ARect.Left + Level * 19;
    Right := Left + 9;
    Top := ARect.Top;
    Bottom := Top + 3;
  end;
  OffsetRect(Result, 15, 3);
end;

procedure TtestResult_Frm.Get_Attfiles(aGrid: TNextGrid; aOwner: String);
begin
  with aGrid do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT FILENAME, FILESIZE, REGNO, OWNER from TMS_ATTFILES ' +
                'WHERE OWNER IN ( ' +
                '   SELECT REQ_NO FROM TMS_TEST_REQUEST  ' +
                '   START WITH REQ_NO LIKE :param1 ' +
                '   CONNECT BY PRIOR PARENT_NO = REQ_NO ) ');

        ParamByName('param1').AsString := aOwner;
        Open;

        while not eof do
        begin
          AddRow;
          Cells[1,RowCount-1] := FieldByName('FILENAME').AsString;
          Cells[2,RowCount-1] := FieldByName('FILESIZE').AsString;
          Cells[4,RowCount-1] := FieldByName('REGNO').AsString;
          Cells[5,RowCount-1] := FieldByName('OWNER').AsString;
          Next;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestResult_Frm.Get_Buss_Log_Info(aReqNo: String);
var
  i : Integer;
begin
  with grid_buss do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT  ' +
                ' A.*, ' +
                ' RST_BY, ' +
                ' RST_MH, ' +
                ' (SELECT NAME_KOR FROM HITEMS_USER WHERE USERID LIKE RST_BY) RST_BY_NAME ' +
                'FROM TMS_RESULT A, TMS_RESULT_MH B ' +
                'WHERE PLAN_NO LIKE ( ' +
                '   SELECT PLAN_NO FROM TMS_TEST_RECEIVE_INFO ' +
                '   WHERE PLAN_NO IS NOT NULL AND REQ_NO LIKE :param1 ' +
                ') ' +
                'AND A.RST_NO = B.RST_NO ' +
                'ORDER BY RST_PERFORM ');

        ParamByName('param1').AsString := aReqNo;
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            i := AddRow;
            Cells[1,i] := FieldByName('RST_NO').AsString;
            Cells[2,i] := FieldByName('RST_TITLE').AsString;
            Cells[3,i] := FormatDateTime('YYYY-MM-DD',FieldByName('RST_PERFORM').AsDateTime);
            Cells[4,i] := FieldByName('RST_BY_NAME').AsString;
            Cell[5,i].AsFloat := FieldByName('RST_MH').AsFloat;
            Cells[6,i] := FieldByName('RST_BY').AsString;
            Next;
          end;

          CalculateFooter;

        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestResult_Frm.Get_Choose_List(aIdx:Integer;aPartNo: String);
var
  i: Integer;
  OraQuery: TOraQuery;
begin
  with grid_part do
  begin
    BeginUpdate;
    try
      OraQuery := TOraQuery.Create(nil);
      try
        OraQuery.Session := DM1.OraSession1;
        OraQuery.FetchAll := True;

        with OraQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM HIMSEN_MS_PART  ' +
                  'WHERE PART_NO LIKE :param1 ');

          ParamByName('param1').AsString := aPartNo;
          Open;

          if RecordCount <> 0 then
          begin
            Cells[3, aIdx] := FieldByName('MS_NO').AsString;
            Cells[4, aIdx] := FieldByName('NAME').AsString;
            Cells[5, aIdx] := FieldByName('MAKER').AsString;
            Cells[6, aIdx] := FieldByName('TYPE').AsString;
            Cells[7, aIdx] := FieldByName('STANDARD').AsString;
          end;
        end;
      finally
        FreeAndNil(OraQuery);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

function TtestResult_Frm.Get_Order_Msg(aOrderNo: String): String;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT REMARK FROM ' +
            '( ' +
            '   SELECT ORDER_NO, MAX(SEQ_NO) SEQ_NO FROM TMS_WORK_RESULT ' +
            '   WHERE ORDER_NO LIKE :PARAM1 ' +
            '   GROUP BY ORDER_NO ' +
            ') A LEFT OUTER JOIN ' +
            '( ' +
            '   SELECT * FROM TMS_WORK_RESULT ' +
            ') B ' +
            'ON A.ORDER_NO = B.ORDER_NO ' +
            'AND A.SEQ_NO = B.SEQ_NO ');

    ParamByName('param1').AsString := aOrderNo;
    Open;

    Result := FieldByName('REMARK').AsString;

  end;
end;

procedure TtestResult_Frm.Get_Request_Resource(aReqNo: String);
var
  i : Integer;
begin
  with DM1.OraQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM ' +
            '( ' +
            '   SELECT ' +
            '     A.*, ' +
            '     B.ENGTYPE, LOC_CODE, ' +
            '     (SELECT NAME_KOR FROM HITEMS_USER WHERE USERID LIKE A.REQ_ID) REQ_ID_NAME, ' +
            '     (SELECT DEPT_NAME FROM HITEMS_DEPT WHERE DEPT_CD LIKE A.REQ_DEPT) REQ_DEPT_NAME, ' +
            '     (SELECT CODE_NAME FROM HITEMS_LOCATION_CODE WHERE CODE LIKE B.LOC_CODE) LOC_CODE_NAME ' +
            '   FROM TMS_TEST_REQUEST A LEFT OUTER JOIN ( ' +
            '     SELECT PROJNO, ENGTYPE, LOC_CODE FROM HIMSEN_INFO ' +
            '   ) B ON A.TEST_ENGINE = B.PROJNO ' +
            ') WHERE REQ_NO LIKE :param1 ');

    ParamByName('param1').AsString := aReqNo;
    Open;

    if RecordCount <> 0 then
    begin
      et_reqDept.Text      := FieldByName('REQ_DEPT_NAME').AsString;
      et_reqDept.Hint      := FieldByName('REQ_DEPT').AsString;

      et_EngType.Text      := FieldByName('TEST_ENGINE').AsString+'-'+FieldByName('ENGTYPE').AsString;
      et_engType.Hint      := FieldByName('TEST_ENGINE').AsString;
      et_EngLoc.Text       := FieldByName('LOC_CODE_NAME').AsString;

      et_reqIncharge.Text  := FieldByName('REQ_ID_NAME').AsString;
      et_reqIncharge.Hint  := FieldByName('REQ_ID').AsString;

      et_reqName.Text      := FieldByName('TEST_NAME').AsString;
      et_testPurpose.Text  := FieldByName('TEST_PURPOSE').AsString;
      et_begin.Text        := FormatDateTime('yyyy-MM-dd', FieldByName('TEST_BEGIN').AsDateTime);
      et_end.Text          := FormatDateTime('yyyy-MM-dd', FieldByName('TEST_END').AsDateTime);
      et_method.Text       := FieldByName('TEST_METHOD').AsString;

      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TMS_TEST_REQUEST_PART ' +
              'WHERE REQ_NO LIKE :param1 ');
      ParamByName('param1').AsString := aReqNo;

      Open;

      First;
      with grid_part do
      begin
        BeginUpdate;
        try
          while not eof do
          begin
            i := AddRow;

            Cells[1,i] := FieldByName('PART_NO').AsString;
            Cell[2,i].AsInteger := FieldByName('SEQ_NO').AsInteger;
            Cells[8,i] := FieldByName('BANK').AsString;
            Cells[9,i] := FieldByName('CYLNUM').AsString;
            Cells[10,i] := FieldByName('CYCLE').AsString;
            Cells[11,i] := FieldByName('SIDE').AsString;
            Cells[12,i] := FieldByName('SERIAL').AsString;
            Get_Choose_List(i, Cells[1,i]);
            Next;
          end;
        finally
          EndUpdate;
        end;
      end;

      Get_Attfiles(fileGrid,aReqNo);

    end;
  end;
end;

procedure TtestResult_Frm.Get_Work_Days(aReqNo: String);
var
  Tab : TAdvOfficeTabSet;
begin
  with AdvOfficeTabSet1 do
  begin
    AdvOfficeTabs.Clear;
    with DM1.OraQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT PERFORM FROM TMS_WORK_ORDERS ' +
              'WHERE PLAN_NO IN ( ' +
              '   SELECT PLAN_NO FROM TMS_TEST_RECEIVE_INFO ' +
              '   WHERE REQ_NO LIKE :param1 ' +
              ') ' +
              'GROUP BY PERFORM ORDER BY PERFORM');
      ParamByName('param1').AsString := aReqNo;
      Open;

      if RecordCount <> 0 then
      begin
        while not eof do
        begin
          AddTab(FormatDateTime('yyyy-MM-dd', FieldByName('PERFORM').AsDateTime));
          Next;
        end;
        ActiveTabIndex := 0;
        Get_Work_Orders(aReqNo, AdvOfficeTabs[ActiveTabIndex].Caption);
      end;
    end;
  end;
end;

procedure TtestResult_Frm.Get_Work_Orders(aReqNo, aPerform: String);
var
 LRow,
 i,j : Integer;
begin
  with grid_Orders do
  begin
    BeginUpdate;
    try
      ClearRows;
      with DM1.OraQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM ' +
                '( ' +
                '   SELECT  ' +
                '     A.*, B.NAME_K, ' +
                '     ( ' +
                '       SELECT NVL(COUNT(*),0) RESULT_CNT FROM  ' +
                '       ( ' +
                '         SELECT ORDER_NO FROM HIMSEN_MS_MOUNTED_PART UNION ' +
                '         SELECT ORDER_NO FROM TMS_DATA_LOCAL UNION ' +
                '         SELECT ORDER_NO FROM TMS_DATA_SHIM ' +
                '       ) WHERE ORDER_NO LIKE A.ORDER_NO     ' +
                '     ) RESULT_CNT, ' +
                '     ( ' +
                '       SELECT CODE_NAME FROM ' +
                '       ( ' +
                '         SELECT CAT_NO CODE, CAT_NAME CODE_NAME FROM TMS_WORK_CATEGORY UNION ' +
                '         SELECT GRP_NO CODE, CODE_NAME FROM TMS_WORK_CODEGRP  ' +
                '       ) WHERE CODE LIKE A.CODE ' +
                '     ) CODE_NAME ' +
                '   FROM ' +
                '   ( ' +
                '     SELECT  ' +
                '       A.*, B.ACT_START, ACT_STOP, LIST_OF_WORKERS, REMARK ' +
                '     FROM ' +
                '     ( ' +
                '       SELECT * FROM TMS_WORK_ORDERS ' +
                '       WHERE PLAN_NO IN (   ' +
                '         SELECT PLAN_NO FROM TMS_TEST_RECEIVE_INFO   ' +
                '         WHERE REQ_NO LIKE :REQ_NO   ' +
                '       )  ' +
                '       AND PERFORM = :PERFORM ' +
                '     ) A LEFT OUTER JOIN  ' +
                '     ( ' +
                '       SELECT * FROM TMS_WORK_RESULT ' +
                '     ) B ' +
                '     ON A.ORDER_NO = B.ORDER_NO ' +
                '     START WITH PARENT_NO IS NULL ' +
                '     CONNECT  BY PRIOR A.ORDER_NO = PARENT_NO ' +
                '     ORDER SIBLINGS BY A.SEQ_NO ' +
                '   ) A LEFT OUTER JOIN  ' +
                '   ( ' +
                '     SELECT ORDER_NO, STATUS, WM_CONCAT(NAMEK) NAME_K FROM ' +
                '     ( ' +
                '       SELECT  ' +
                '         A.*, ' +
                '         (SELECT NAME_KOR FROM HITEMS_USER WHERE USERID LIKE WORKERID) NAMEK ' +
                '       FROM ' +
                '       ( ' +
                '         SELECT  ' +
                '           ORDER_NO,  ' +
                '           STATUS,  ' +
                '           REGEXP_SUBSTR(LIST_OF_WORKERS,''[^M,]+'', 1, LEVEL) WORKERID ' +
                '         FROM ' +
                '         ( ' +
                '           SELECT ORDER_NO, STATUS, LIST_OF_WORKERS FROM TMS_WORK_RESULT ' +
                '           WHERE ORDER_NO IN ( ' +
                '             SELECT ORDER_NO FROM TMS_WORK_ORDERS ' +
                '             WHERE PERFORM = :PERFORM ' +
                '             AND PLAN_NO IN (  ' +
                '               SELECT PLAN_NO FROM TMS_TEST_RECEIVE_INFO  ' +
                '               WHERE REQ_NO LIKE :REQ_NO) ' +
                '             )     ' +
                '         )CONNECT BY LEVEL <= LENGTH(REGEXP_REPLACE(LIST_OF_WORKERS,''[^_,]+'', ''''))+1 ' +
                '         GROUP BY ORDER_NO, STATUS, LIST_OF_WORKERS, LEVEL ' +
                '       ) A ORDER BY NAMEK ' +
                '     )GROUP BY ORDER_NO, STATUS     ' +
                '   ) B ' +
                '   ON A.ORDER_NO = B.ORDER_NO ' +
                '   AND A.STATUS = B.STATUS ' +
                ') START WITH PARENT_NO IS NULL ' +
                'CONNECT BY PRIOR ORDER_NO = PARENT_NO ' +
                'ORDER SIBLINGS BY SEQ_NO ');


        ParamByName('REQ_NO').AsString := aReqNo;
        ParamByName('PERFORM').AsDate   := StrToDateTime(aPerform);
        Open;

        if RecordCount <> 0 then
        begin
          while not eof do
          begin
            if RowCount = 0 then
              LRow := AddRow(1)
            else
            begin
              if FieldByName('PARENT_NO').AsString <> '' then
              begin
                for i := 0 to RowCount-1 do
                begin
                  if Cells[2,i] = FieldByName('PARENT_NO').AsString then
                  begin
                    AddChildRow(i,crLast);
                    LRow := LastAddedRow;
                    Break;
                  end;
                end;
              end else
                LRow := AddRow(1);

            end;

            Cells[0,LRow] := FieldByName('CODE_NAME').AsString;
            Cells[1,LRow] := FieldByName('STATUS').AsString;
            Cells[2,LRow] := FieldByName('ORDER_NO').AsString;
            Cells[3,LRow] := FieldByName('PARENT_NO').AsString;
            Cells[4,LRow] := FieldByName('CODE_TYPE').AsString;

            if Cells[4,LRow] = 'C' then
            begin
              Cells[5,LRow] := FormatDateTime('HH:mm', FieldByName('ACT_START').AsDateTime);
              Cells[6,LRow] := FormatDateTime('HH:mm', FieldByName('ACT_STOP').AsDateTime);
            end;

            Cells[7,LRow] := FieldByName('NAME_K').AsString;
            Cells[8,LRow] := FieldByName('CODE').AsString;

            if FieldByName('RESULT_CNT').AsInteger > 0 then
              Cell[9,LRow].AsInteger := 8
            else
              Cell[9,LRow].AsInteger := -1;

            if FieldByName('REMARK').AsString <> '' then
              Cell[10,LRow].AsInteger := 9
            else
              Cell[10,LRow].AsInteger := -1;

            Next;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestResult_Frm.grid_bussCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

end;

procedure TtestResult_Frm.grid_ordersCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  with grid_orders do
  begin
    case ACol of
      9 :
      begin
        if Cell[9,ARow].AsInteger = -1 then
          Exit;

        Open_the_Work_sheet(Cells[2,ARow],//ORDER_NO
                            Cells[8,ARow]);//CODE
      end;

      10 :
      begin
        if Cell[10,ARow].AsInteger = -1 then
          Exit;

        Create_resultDialog_Frm('작업결과메세지',Get_Order_Msg(Cells[2,ARow]));
      end;
    end;
  end;
end;

procedure TtestResult_Frm.grid_OrdersCustomDrawCell(Sender: TObject; ACol,
  ARow: Integer; CellRect: TRect; CellState: TCellState);
var
  s : String;
  LRect : TRect;
  LCanvas : TCanvas;
  bmp : TBitmap;
begin
  if ARow = -1 then
    Exit;

  with Sender as TNextGrid do
  begin
    LRect := GetButtonRect(CellRect,GetLevel(ARow));
    s := Cells[0,ARow];
    LCanvas := Canvas;
    LCanvas.FillRect(LRect);

    bmp := TBitmap.Create;
    try
      if Cells[4,ARow] = 'C' then
      begin
        if Cells[1,ARow] = '대기' then
          ImageList16x16.GetBitmap(4,bmp);
        if Cells[1,ARow] = '진행' then
          ImageList16x16.GetBitmap(5,bmp);
        if Cells[1,ARow] = '완료' then
          ImageList16x16.GetBitmap(6,bmp);
        if Cells[1,ARow] = '중지' then
          ImageList16x16.GetBitmap(7,bmp);

      end else
        ImageList16x16.GetBitmap(3,bmp);

      if bmp <> nil then
        LCanvas.Draw(LRect.Left, LRect.Top, bmp);

    finally
      bmp.Free;
    end;
  end;
end;

procedure TtestResult_Frm.grid_partCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  with grid_part do
  begin
    Preview_Detail_Part(et_reqName.Hint,
                        Cells[1,ARow],
                        Cell[2,Arow].AsInteger);
  end;
end;

procedure TtestResult_Frm.grid_partMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FLastSelectedRow_PartGrid := grid_part.GetRowAtPos(X,Y);
end;

procedure TtestResult_Frm.grid_ResultCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if ARow = -1 then
    Exit;

  with grid_Result do
  begin
    if et_reqName.Text = '' then
      Exit;

    case ARow of
      0 :
      begin
        Gen_Measurement_Report;
      end;
    end;
  end;
end;

procedure TtestResult_Frm.Init_Request_Info;
begin
  PageControl1.ActivePageIndex := 0;
  PageControl2.ActivePageIndex := 0;

  et_reqName.Clear;
  et_reqName.Hint := '';

  et_reqDept.Clear;
  et_reqDept.Hint := '';

  et_reqIncharge.Clear;
  et_reqIncharge.Hint := '';

  et_engType.Clear;
  et_engType.Hint := '';

  et_EngLoc.Clear;
  et_EngLoc.Hint := '';

  et_testPurpose.Clear;
  et_begin.Clear;
  et_end.Clear;
  et_method.Text := '';
  fileGrid.ClearRows;
  grid_part.ClearRows;
  grid_buss.ClearRows;
  AdvOfficeTabSet1.AdvOfficeTabs.Clear;

end;

procedure TtestResult_Frm.Init_Result_Tab;
var
  i : Integer;
begin
  with grid_Result do
  begin
    BeginUpdate;
    try
      i := AddRow;
      Cells[2,i] := 'ENGINE TEST & MEASUREMENT REPORT';
      Cell[3,i].AsInteger := 2;

    finally
      EndUpdate;
    end;
  end;
end;

procedure TtestResult_Frm.N1Click(Sender: TObject);
begin
  if FLastSelectedRow_PartGrid = -1 then
    exit;

  with grid_part do
  begin
    Preview_Detail_Part(et_reqName.Hint,
                        Cells[1,FLastSelectedRow_PartGrid],
                        Cell[2,FLastSelectedRow_PartGrid].AsInteger);
  end;
end;

procedure TtestResult_Frm.Open_the_Work_sheet(aOrderNo,aCode:String);
var
  str : String;
  OraQuery: TOraQuery;
begin
  OraQuery := TOraQuery.Create(nil);
  try
    OraQuery.Session := DM1.OraSession1;

    with OraQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT  ' +
              '  A.*, ' +
              '  B.CLASS_NAME ' +
              'FROM ' +
              '( ' +
              '   SELECT * FROM TMS_WORK_CODEGRP WHERE GRP_NO LIKE :CODE ' +
              ') A LEFT OUTER JOIN ' +
              '( ' +
              '   SELECT * FROM TMS_WORK_CODE_SHEET ' +
              ') B ON A.CODE = B.CODE ');

      ParamByName('CODE').AsString := aCode;
      Open;

      if RecordCount <> 0 then
      begin
        while not eof do
        begin
          if SameText(FieldByName('CLASS_NAME').AsString, 'localSheet_Frm') then
            Preview_localSheet(aOrderNo,et_engType.Text);

          if SameText(FieldByName('CLASS_NAME').AsString, 'checkChangePart_Frm') then
            Preview_checkChangePart_Frm(aOrderNo);

          if SameText(FieldByName('CLASS_NAME').AsString, 'shimDataSheet_Frm') then
          begin
            str := Copy(et_engType.Text,POS('-',et_engType.Text)+1,
                          Length(et_engType.Text)-POS('-',et_engType.Text));

            Preview_shimDataSheet_Frm(aOrderNo, str );
          end;

          Next;
        end;
      end;
    end;
  finally
    FreeAndNil(OraQuery);
  end;
end;

end.
