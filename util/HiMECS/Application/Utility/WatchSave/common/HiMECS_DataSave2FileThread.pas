unit HiMECS_DataSave2FileThread;

interface

uses
  Windows, Classes, Forms, MyKernelObject, CommonUtil, SysUtils;

type
  TSaveMedia = set of (SM_DB, SM_FILE);
  TFileName_Convetion = (FC_YMD, FC_FIXED);

  TDataSave2FileThread = class(TThread)
  private
    FOwner: TForm;
  protected
    procedure Execute; override;
  public
    FName_Convention: TFileName_Convetion;//파일에 저장시에 파일이름부여 방법
    FFileName: string; //데이타를 저장할 File 이름(설정에 따라 변경됨)
    FDataSaveEvent: TEvent;//Data Save Thread에 파일 저장을 알리는 Event Handle
    FStrBuf: array[0..26] of string;
    FStrData: string;
    FDataList: TStringList;
    FTagData: string; //Tag이름을 저장함
    FSaving: Boolean; //데이타 저장중이면 True
    FUseInterval: Boolean;
    FInterval: integer;

    //파일을 처음 생성한 후 데이타를 처음 기록한 경우 True
    FIsFileFirst: Boolean;    //파일 머리에 제목을 기록하기 위함

    FAppendString2FileName: string;
    constructor Create(AOwner: TForm);
    destructor Destroy; override;
    function MakeCSVData: Boolean;
  end;

implementation

{ TDataSaveThread }

constructor TDataSave2FileThread.Create(AOwner: TForm);
begin
  inherited Create(True);
  FOwner := AOwner;
  FDataSaveEvent := TEvent.Create('ECSDataSaveEvent'+IntToStr(GetCurrentThreadID),False);
end;

destructor TDataSave2FileThread.Destroy;
begin
  FDataSaveEvent.Free;

  if Assigned(FDataList) then
    FreeAndNil(FDataList);

  inherited;
end;

procedure TDataSave2FileThread.Execute;
begin
  while not terminated do
  begin
    if FDataSaveEvent.Wait(INFINITE) then
    begin
      if not terminated then
      begin
        FSaving := True;
        case FName_Convention of
          FC_YMD:
          begin
            if Assigned(FDataList) then //Bulk Data인 경우 100건당 한번씩 파일에 저장함
            begin
              //파일이 처음 생성된 경우 파일 머리에 헤더를 삽입함
              if SaveData2DateFile('CSVFile',FAppendString2FileName, FDataList, soFromEnd) then
                SaveData2DateFile('CSVFile',FAppendString2FileName, FTagData, soFromBeginning);

              FDataList.Clear;
            end
            else
            begin
              //파일이 처음 생성된 경우 파일 머리에 헤더를 삽입함
              if SaveData2DateFile('CSVFile',FAppendString2FileName, FStrData, soFromEnd) then
                SaveData2DateFile('CSVFile',FAppendString2FileName, FTagData, soFromBeginning);
            end;
          end;
          FC_FIXED:
          begin
            if SaveData2FixedFile('CSVFile',FFileName, FStrData, soFromEnd)then
              SaveData2FixedFile('CSVFile',FFileName, FTagData, soFromBeginning)
          end;
        end;//case

        //인터벌로 데이터를 저장할 경우 해당 시간동안 쓰레드를 sleep 시킴
        //if DataSaveMain.RB_byinterval.Checked then
        if FUseInterval then
        begin
          //sleep(StrToInt(DataSaveMain.Ed_interval.Text));
          sleep(FInterval);
        end;

        FSaving := False;
      end;//if
    end;//if
 end;//while
end;

//데이타를 만드는데 성공하면 True를 반환함
function TDataSave2FileThread.MakeCSVData: Boolean;
var
  i: integer;
begin
  Result := False;

  FStrData := '';

  FStrData := FStrBuf[0];

  for i := 1 to 26 do
    FStrData := FStrData + ',' + FStrBuf[i];

  if Pos(',,',FStrData) = 0 then
    Result := True;
end;

end.
