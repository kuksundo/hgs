unit DataSaveThread;

interface

uses
  Windows, Classes, Forms, MyKernelObject, CommonUtil;

type
  TDataSave2FileThread = class(TThread)
  private
    FOwner: TForm;
  protected
    procedure Execute; override;
  public
    FDataSaveEvent: TEvent;//Data Save Thread에 파일 저장을 알리는 Event Handle
    FStrBuf: array[0..26] of string;
    FStrData: string;
    FSaving: Boolean; //데이타 저장중이면 True

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
  FDataSaveEvent := TEvent.Create('DataSaveEvent',False);
end;

destructor TDataSave2FileThread.Destroy;
begin
  FDataSaveEvent.Free;
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
        if MakeCSVData() then
          SaveData2File('CSVFile','csv', FStrData);
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
