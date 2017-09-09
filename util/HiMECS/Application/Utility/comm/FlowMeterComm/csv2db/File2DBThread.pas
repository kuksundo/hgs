unit File2DBThread;

interface

uses
  Windows, SysUtils, Classes, Forms, MyKernelObject, CommonUtil, janSQL,
  MySqlDBThread, CopyData, CSV2DBConst, FindFile_Pjh;

type
  TDataFile2DBThread = class(TThread)
  private
    FOwner: TForm;

    procedure SetFile2DBEvent(AEvent: TEvent);
    procedure SetFileName(AFileName: string);
  protected
    procedure Execute; override;
  public
    FData2MySQLDBThread: TData2MySQLDBThread;
    FFindFile: TFindFile;// Directory option을 선택 하였을 경우 파일 리스트 작성하는 객체
    FjanDB : TjanSQL; //text 기반 SQL DB
    FFileName: string; //데이타를 읽어들일 File 이름(설정에 따라 변경됨)
    FDataSaveEvent: TEvent;//Data Save Thread에 파일 저장을 알리는 Event Handle
    FSaving: Boolean; //데이타 저장중이면 True
    //FDataSaveEvent2: TEvent;//Data Save Thread에 파일 저장을 알리는 Event Handle
    FRecordCount: integer; //전체 데이타 건수
    FRestart: Boolean; //True이면 처음부터 다시 시작함.
    FSuspendInsert: Boolean; //True이면 Thread가 Suspend됨
    //파일을 처음 생성한 후 데이타를 처음 기록한 경우 True
    FIsFileFirst: Boolean;    //파일 머리에 제목을 기록하기 위함
    FFileList: TStringList;//Insert할 File name list

    constructor Create(AOwner: TForm);
    destructor Destroy; override;

    procedure ReadCSVData;
    procedure InitVar;
    procedure FileMatch(Sender: TObject; const Folder: String;
                                                    const FileInfo: TSearchRec);
  published
    property FullFileName: string read FFileName write SetFileName;
    property SaveEvent: TEvent read FDataSaveEvent write SetFile2DBEvent;
  end;

implementation

uses Main;

{ TDataSaveThread }

constructor TDataFile2DBThread.Create(AOwner: TForm);
begin
  inherited Create(True);
  FOwner := AOwner;
  FDataSaveEvent := TEvent.Create('DataFromFileEvent'+IntToStr(GetCurrentThreadID),False);
  FData2MySQLDBThread := TData2MySQLDBThread.Create(FOwner);
  FData2MySQLDBThread.FDataSaveEvent2 := FDataSaveEvent;
  FFileList := TStringList.Create;
  FFindFile := nil;
end;

destructor TDataFile2DBThread.Destroy;
begin
  InitVar;

  if Assigned(FData2MySQLDBThread) then
  begin
    FData2MySQLDBThread.Terminate;
    FData2MySQLDBThread.FDataSaveEvent.Signal;
    FData2MySQLDBThread.Free;
    FData2MySQLDBThread := nil;
  end;//if

  if Assigned(FFindFile) then
  begin
    FFindFile.Free;
    FFindFile := nil;
  end;

  FDataSaveEvent.Free;
  FDataSaveEvent:= nil;

  FFileList.Free;

  inherited;
end;

procedure TDataFile2DBThread.Execute;
var i: integer;
begin
  while not terminated do
  begin
    FSaving := True;
    TCsv2DBF(FOwner).CurrentState := S_INSERTING;

    for i := 0 to FFileList.Count - 1 do
    begin
      FFileName := FFileList.Strings[i];
      ReadCSVData();
    end;

    TCsv2DBF(FOwner).CurrentState := S_FINISHED_INSERT;
    FSaving := False;

    if not (FRestart or Terminated) then
      Suspend;
  end;//while
end;

procedure TDataFile2DBThread.FileMatch(Sender: TObject;
  const Folder: String; const FileInfo: TSearchRec);
begin
  FFileList.Add(Folder + FileInfo.Name);
end;

procedure TDataFile2DBThread.InitVar;
begin
  if Assigned(FjanDB) then
  begin
    FjanDB.Free;
    FjanDB := nil;
  end;

  FRestart := False;
  FSuspendInsert := False;

  if not Assigned(FFindFile) then
  begin
    FFindFile := TFindFile.Create(nil);
    FFindFile.Threaded := False;
    FFindFile.OnFileMatch := FileMatch;
  end;
    FFindFile.Criteria.Files.Location := FullFileName;
    FFindFile.Criteria.Files.FileName := '*.csv';
    FFindFile.Execute;
end;

procedure TDataFile2DBThread.ReadCSVData;
var
  sqltext: string;
  sqlresult, fldcnt: integer;
  i: integer;
  Filename, Filepath: string;
begin
  if fileexists(FullFileName) then
  begin
    Filename := ExtractFileName(FullFileName);
    Filepath := ExtractFilePath(FullFileName);
    FileName := Copy(Filename,1, Pos('.',Filename) - 1);
    FjanDB :=TjanSQL.create(',');
    sqltext := 'connect to ''' + FilePath + '''';

    sqlresult := FjanDB.SQLDirect(sqltext);
    //Connect 성공
    if sqlresult <> 0 then
    begin
      with FjanDB do
      begin
        FileExt := '.csv';//파일 확장자 변경 (Default = '.txt')
        sqltext := 'select * from ' + FileName;
        sqlresult := SQLDirect(sqltext);
        //Query 정상
        if sqlresult <> 0 then
        begin
          //데이타 건수가 1개 이상 있으면
          if sqlresult>0 then
          begin
            fldcnt := RecordSets[sqlresult].FieldCount;
            //Field Count가 0 이면
            if fldcnt = 0 then exit;

            FRecordCount := RecordSets[sqlresult].RecordCount;
            //Record Count가 0 이면
            if FRecordCount = 0 then exit;

            SendCopyData2(FOwner.Handle, ExtractFileName(FullFileName)+' 처리중...', Ord(SB_LED));

            for i := 0 to FRecordCount - 1 do
            begin
              if Terminated or FRestart then
                exit;

              if FSuspendInsert then
              begin
                Suspend;
                FSuspendInsert := False;
              end;

              FData2MySQLDBThread.FjanRecord := RecordSets[SqlResult].Records[i];
              FData2MySQLDBThread.FDataSaveEvent.Signal;
              SendCopyData2(FOwner.Handle, IntToStr(Round((i / FRecordCount) * 100)), Ord(SB_PROGRESS));
              SendCopyData2(FOwner.Handle, IntToStr(i+1), Ord(SB_RECORDCOUNT));
              FDataSaveEvent.Wait(INFINITE);
            end;//for

            SendCopyData2(FOwner.Handle, '100', Ord(SB_PROGRESS));
            SendCopyData2(FOwner.Handle, ExtractFileName(FullFileName)+' 처리 완료', Ord(SB_LED));
          end;

        end
        else
          SendCopyData2(FOwner.Handle, FjanDB.Error, Ord(SB_SIMPLE));
      end;//with
    end
    else
      Application.MessageBox('Connect 실패',
          PChar('폴더 ' + FilePath + ' 를 만든 후 다시 하시오'),MB_ICONSTOP+MB_OK);
  end
  else
  begin
    Application.MessageBox('Data file does not exist!' + #13#10,
            PChar(FullFileName +' 파일을 만든 후에 다시 하시오'),MB_ICONSTOP+MB_OK);
  end;
end;

procedure TDataFile2DBThread.SetFile2DBEvent(AEvent: TEvent);
begin
  if FDataSaveEvent = nil then
    FDataSaveEvent := AEvent;
end;

procedure TDataFile2DBThread.SetFileName(AFileName: string);
begin
  if FFileName <> AFileName then
    FFileName := AFileName;
end;

end.
