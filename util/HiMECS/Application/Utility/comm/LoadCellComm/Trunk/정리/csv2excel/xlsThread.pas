unit xlsThread;

interface

uses
  Windows, Classes, SysUtils, Forms, Dialogs, Excel2000, OleServer, ActiveX,
  Grids, janSQL, MyKernelObject, CommonUtil, CSV2XLSConst;

type
  TData2xlsThread = class(TThread)
  private
    FOwner: TForm;
  protected                                                
    procedure Execute; override;
  public
    FjanRecord: TjanRecord; //한 레코드를 입력받기 위한 변수
    FExcelApplication : TExcelApplication;
    FExcelWorkbook : TExcelWorkbook;
    FExcelWorksheet : TExcelWorksheet;
    FGrid: TStringGrid;
    LCID : Integer;

    FDataSaveEvent: TEvent;//Data Save Thread에 파일 저장을 알리는 Event Handle
    FDataSaveEvent2: TEvent;//TDataFile2DBThread에 DB 저장 완료를 알리는 Event Handle
    FStarted: Boolean;//Execute를 한번이상 실행 했으면 True
    FSaving: Boolean; //데이타 저장중이면 True

    constructor Create(AOwner: TForm);
    destructor Destroy; override;

    function ConnectExcel: Boolean;
    procedure DisConnectExcel;
    procedure InsertData2Grid(var AGrid: TStringGrid);
  end;

implementation

{ TDataSaveThread }

constructor TData2xlsThread.Create(AOwner: TForm);
begin
  inherited Create(True);
  FOwner := AOwner;
  //FExcelApplication := TExcelApplication.Create(nil);
  //FExcelWorkbook := TExcelWorkbook.Create(nil);
  //FExcelWorksheet := TExcelWorksheet.Create(nil);

  FDataSaveEvent := TEvent.Create('Data2ExcelEvent'+IntToStr(GetCurrentThreadID),False);

  FStarted := False;
  FSaving := False;
end;

destructor TData2xlsThread.Destroy;
begin
  FreeAndNil(FExcelApplication);
  FreeAndNil(FExcelWorkbook);
  FreeAndNil(FExcelWorksheet);
  FreeAndNil(FDataSaveEvent);
  inherited;
end;

function TData2xlsThread.ConnectExcel: Boolean;
begin
  Result := False;

  LCID := LOCALE_USER_DEFAULT; //GetUserDefaultLCID;
  //FExcelApplication.ConnectKind := ckRunningOrNew;
  //FExcelApplication.Connect;
  //FExcelWorkbook.ConnectTo(FExcelApplication.Workbooks.Open(XLS_FILE_NAME), LCID);// .Add(TOleEnum(xlWBATWorksheet), LCID));
  //FExcelWorksheet.ConnectTo(FExcelWorkbook.Worksheets[3] as _Worksheet);

end;

procedure TData2xlsThread.DisConnectExcel;
begin
  FExcelApplication.DisConnect;
end;

procedure TData2xlsThread.Execute;
begin
  FStarted := True;

  while not terminated do
  begin
    if FDataSaveEvent.Wait(INFINITE) then
    begin
      if not terminated then
      begin
        try
          FSaving := True;

          InsertData2Grid(FGrid);

        finally
          FDataSaveEvent2.Signal;
          FSaving := False;
        end;//try
      end;//if
    end;//if
  end;//while

  FStarted := False;
end;

procedure TData2xlsThread.InsertData2Grid(var AGrid: TStringGrid);
const BaseRowIndex = 1;
begin
  AGrid.Cells[1,BaseRowIndex + 0] := FjanRecord.fields[SE42_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 1] := FjanRecord.fields[TE62_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 2] := FjanRecord.fields[TE71_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 3] := FjanRecord.fields[TE76_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 4] := FjanRecord.fields[TE51_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 5] := FjanRecord.fields[TE21_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 6] := FjanRecord.fields[PT62_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 7] := FjanRecord.fields[PT63_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 8] := FjanRecord.fields[PT71_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 9] := FjanRecord.fields[PT75_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 10] := FjanRecord.fields[PT51_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 11] := FjanRecord.fields[PT21_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 12] := FjanRecord.fields[TE25_1_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 13] := FjanRecord.fields[TE25_2_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 14] := FjanRecord.fields[TE25_3_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 15] := FjanRecord.fields[TE25_4_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 16] := FjanRecord.fields[TE25_5_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 17] := FjanRecord.fields[TE25_6_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 18] := FjanRecord.fields[TE26_1_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 19] := FjanRecord.fields[TE26_2_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 20] := FjanRecord.fields[TE27_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 21] := FjanRecord.fields[TE69_1_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 22] := FjanRecord.fields[TE69_3_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 23] := FjanRecord.fields[TE69_4_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 24] := FjanRecord.fields[TE69_5_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 25] := FjanRecord.fields[TE69_6_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 26] := FjanRecord.fields[TE69_7_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 27] := FjanRecord.fields[TE69_8_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 28] := FjanRecord.fields[TE98_1_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 29] := FjanRecord.fields[TE98_2_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 30] := FjanRecord.fields[TE98_3_CSVIDX].value;
  AGrid.Cells[1,BaseRowIndex + 31] := FjanRecord.fields[TE67_1_CSVIDX].value;
end;

end.
