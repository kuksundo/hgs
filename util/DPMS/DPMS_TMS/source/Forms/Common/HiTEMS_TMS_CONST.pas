unit HiTEMS_TMS_CONST;

interface

uses System.Classes, TodoList;

Type
  CODE_TYPE = (ctCategory = 1, ctGroup = 2, ctCode = 3);
  ALIAS_TYPE = (atDepart = 1, atTeam = 2, atPrivate = 3);
  VISIBLE_TYPE = (vtShow = 1, vtHide = 2, vtDisable = 3);
  ALARM_INTERVAL = (aiNone, ai0Min,ai5Min,ai10Min,ai15Min,ai30Min,
                ai1Hour,ai2Hour,ai3Hour,ai4Hour,ai5Hour,ai6Hour,ai7Hour,ai8Hour,
                ai9Hour,ai10Hour,ai11Hour,ai18Hour,ai1Day,ai2Day,ai3Day,
                ai4Day,ai1Week,ai2Week);

  TpjhTodoItem = class(TCollectionItem)
  private
    FImageIndex: Integer;
    FNotes: TStringList;
    FTag: Integer;
    FTotalTime: double;
    FSubject: string;
    FCompletion: TCompletion;
    FDueDate: TDateTime;
    FPriority: TTodoPriority;
    FStatus: TTodoStatus;
    FOnChange: TNotifyEvent;
    FComplete: Boolean;
    FCreationDate: TDateTime;
    FCompletionDate: TDateTime;
    FResource: string;
    FDBKey: string;
    FProject: string;
    FCategory: string;

    FTodoCode,
    FTaskCode,
    FPlanCode,
    FModId: string;

    FAlarmType,
    FAlarmTime2, //AlarmType이 2인 경우(분)
    FAlarmFlag,
    FAlarm2Msg,
    FAlarm2Note,
    FAlarm2Email: integer;

    FAlarmTime1, //AlarmType이 1인 경우 시각
    FModDate: TDateTime;

    FAlarmTime: TDateTime; //Alarm을 발생 시켜야할 시각

    procedure SetNotes(const Value: TStringList);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure AssignTo(Dest: TPersistent); override;

    property AlarmTime: TDateTime read FAlarmTime write FAlarmTime;
  published
    property Category: string read FCategory write FCategory;
    property Complete: Boolean read FComplete write FComplete;
    property Completion: TCompletion read FCompletion write FCompletion;
    property CompletionDate: TDateTime read FCompletionDate write FCompletionDate;
    property CreationDate: TDateTime read FCreationDate write FCreationDate;
    property DueDate: TDateTime read FDueDate write FDueDate;
    property ImageIndex: Integer read FImageIndex write FImageIndex;
    property Notes: TStringList read FNotes write SetNotes;
    property Priority: TTodoPriority read FPriority write FPriority;
    property Project: string read FProject write FProject;
    property Resource: string read FResource write FResource;
    property Status: TTodoStatus read FStatus write FStatus;
    property Subject: string read FSubject write FSubject;
    property Tag: Integer read FTag write FTag;
    property TotalTime: double read FTotalTime write FTotalTime;

    property TodoCode: string read FTodoCode write FTodoCode;
    property TaskCode: string read FTaskCode write FTaskCode;
    property PlanCode: string read FPlanCode write FPlanCode;
    property ModId: string read FModId write FModId;

    property AlarmType: integer read FAlarmType write FAlarmType;
    property AlarmTime2: integer read FAlarmTime2 write FAlarmTime2;
    property AlarmFlag: integer read FAlarmFlag write FAlarmFlag;
    property Alarm2Msg: integer read FAlarm2Msg write FAlarm2Msg;
    property Alarm2Note: integer read FAlarm2Note write FAlarm2Note;
    property Alarm2Email: integer read FAlarm2Email write FAlarm2Email;

    property AlarmTime1: TDateTime read FAlarmTime1 write FAlarmTime1;
    property ModDate: TDateTime read FModDate write FModDate;
  end;

  TpjhToDoItemCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TpjhTodoItem;
    procedure SetItem(Index: Integer; const Value: TpjhTodoItem);
  protected
    function Compare(Item1, Item2 : TpjhTodoItem) : integer; virtual;
    procedure QuickSort(L, R: Integer);
  public
    FCurrentAlarmIndex: integer;

    procedure Sort;
    function  Add: TpjhTodoItem;
    function Insert(Index: Integer): TpjhTodoItem;
    property Items[Index: Integer]: TpjhTodoItem read GetItem  write SetItem; default;
  end;

type
  // Helper class to allow sorting of a TCollection
  {$HINTS OFF}
  TShadowedCollection = class(TPersistent)
  private
    FItemClass: TCollectionItemClass;
    FItems: TList;
  end;
  {$HINTS ON}

  function GetAlarmInterval(AInterval: integer): longint;
  function GetAlarmComboIndex(AAlarmMinute: integer): integer;

const
  fStatusCdGrp : Double = (63490488633265);//업무그룹

  //JOBCODE 관련
  fsiteRstCode : Double = (63496011770313);//현장관련 JOBCODE


  //근무구분
  ftimeType : array[0..5] of string = ('기본근무','연장근무','주말근무','야간근무','철야근무','야간연장');
  //근태구분
  fgeuntae : array[0..8] of string = ('출장','교육','파견','훈련(예비군)',
                                      '년/월차','년/월차(오전)',
                                      '년/월차(오후)','휴가','기타');

  fDayofWeek : array[1..7] of string = ('일','월','화','수','목','금','토');


  fK2bSite : String = ('K2B3');

  ALIAS_TYPE_COUNT = integer(High(ALIAS_TYPE));
  R_ALIAS_TYPE : array[1..ALIAS_TYPE_COUNT] of record
    Description : string;
    Value       : ALIAS_TYPE;
  end = ((Description : '부서';       Value : atDepart),
         (Description : '팀';         Value : atTeam),
         (Description : '개인';       Value : atPrivate));

  ALIAS_TEAM_COLOR = $00BD814F;
  ALIAS_PRIVATE_COLOR = $004D50C0;

function ALIAS_TYPE2String(AALIAS_TYPE:ALIAS_TYPE) : string;
function String2ALIAS_TYPE(AALIAS_TYPE:string): ALIAS_TYPE;
function GetStrictAliasType(AAliasType1, AAliasType2: string): string;

implementation

uses
  CommonUtil_Unit,
  DataModule_Unit;

function ALIAS_TYPE2String(AALIAS_TYPE:ALIAS_TYPE) : string;
begin
  Result := '';

  if (AALIAS_TYPE >= Low(ALIAS_TYPE)) and (AALIAS_TYPE <= High(ALIAS_TYPE)) then
    Result := R_ALIAS_TYPE[ord(AALIAS_TYPE)].Description;
end;

function String2ALIAS_TYPE(AALIAS_TYPE:string): ALIAS_TYPE;
var Li: integer;
begin
  for Li := 1 to ALIAS_TYPE_COUNT do
  begin
    if R_ALIAS_TYPE[Li].Description = AALIAS_TYPE then
    begin
      Result := R_ALIAS_TYPE[Li].Value;
      exit;
    end;
  end;
end;

function GetStrictAliasType(AAliasType1, AAliasType2: string): string;
var
  LAt1, LAt2: ALIAS_TYPE;
begin
  Result := '';

  LAt1 := String2ALIAS_TYPE(AAliasType1);
  LAt2 := String2ALIAS_TYPE(AAliasType2);

  if Ord(LAt1) >= Ord(LAt2) then
    Result := AAliasType1
  else
    Result := AAliasType2;
end;

{ TpjhToDoItemCollection }

function TpjhToDoItemCollection.Add: TpjhTodoItem;
begin
  Result := TpjhTodoItem(inherited Add);
end;

function TpjhToDoItemCollection.Compare(Item1, Item2: TpjhTodoItem): integer;
begin
(*Descendant classes would override this method and cast Item1 and Item2 to
  thedecendant class's collection item type perform the field comparisions
  if item1.MyField < item2.MyField
  return -1
  else if item1.MyField > item2.MyField
  return 1
  else return 0
*)
  if Item1.AlarmTime < Item2.AlarmTime then
    Result := -1
  else
  if Item1.AlarmTime > Item2.AlarmTime then
    Result := 1
  else
    Result := 0;
end;

function TpjhToDoItemCollection.GetItem(Index: Integer): TpjhTodoItem;
begin
  Result := TpjhTodoItem(inherited Items[Index]);
end;

function TpjhToDoItemCollection.Insert(Index: Integer): TpjhTodoItem;
begin
  Result := TpjhTodoItem(inherited Insert(Index));
end;

procedure TpjhToDoItemCollection.QuickSort(L, R: Integer);
var
  I, J, p: Integer;
  Save: TCollectionItem;
  SortList: TList;
begin
  //This cast allows us to get at the private elements in the base class
  SortList := TShadowedCollection(Self).FItems;

  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;

    repeat
      while Compare(Items[I], Items[P]) < 0 do
        Inc(I);

      while Compare(Items[J], Items[P]) > 0 do
        Dec(J);

      if I <= J then
      begin
        Save              := SortList.Items[I];
        SortList.Items[I] := SortList.Items[J];
        SortList.Items[J] := Save;

        if P = I then
          P := J
        else
        if P = J then
          P := I;

        Inc(I);
        Dec(J);
      end;
    until I > J;

    if L < J then
      QuickSort(L, J);

    L := I;
  until I >= R;
end;

procedure TpjhToDoItemCollection.SetItem(Index: Integer;
  const Value: TpjhTodoItem);
begin
  Items[Index].Assign(Value);
end;

procedure TpjhToDoItemCollection.Sort;
begin
  if Count > 1 then
    QuickSort(0, pred(Count));
end;

{ TpjhTodoItem }

procedure TpjhTodoItem.Assign(Source: TPersistent);
begin
  if Source is TpjhTodoItem then
  begin
    TodoCode := TpjhTodoItem(Source).TodoCode;
    TaskCode := TpjhTodoItem(Source).TaskCode;
    PlanCode := TpjhTodoItem(Source).PlanCode;
    ModId := TpjhTodoItem(Source).ModId;
    AlarmType := TpjhTodoItem(Source).AlarmType;
    AlarmTime2 := TpjhTodoItem(Source).AlarmTime2;
    AlarmFlag := TpjhTodoItem(Source).AlarmFlag;
    Alarm2Msg := TpjhTodoItem(Source).Alarm2Msg;
    Alarm2Note := TpjhTodoItem(Source).Alarm2Note;
    Alarm2Email := TpjhTodoItem(Source).Alarm2Email;
    AlarmTime1 := TpjhTodoItem(Source).AlarmTime1;
    ModDate := TpjhTodoItem(Source).ModDate;
  end;
end;

procedure TpjhTodoItem.AssignTo(Dest: TPersistent);
begin
  if Dest is TTodoItem then
  begin
    TTodoItem(Dest).Subject := Subject;
    TTodoItem(Dest).Category := Category;
    TTodoItem(Dest).Complete := Complete;
    TTodoItem(Dest).Completion := Completion;
    TTodoItem(Dest).CompletionDate := CompletionDate;
    TTodoItem(Dest).CreationDate := CreationDate;
    TTodoItem(Dest).DueDate := DueDate;
    TTodoItem(Dest).Priority := Priority;
    TTodoItem(Dest).Project := Project;
    TTodoItem(Dest).Resource := Resource;
    TTodoItem(Dest).Status := Status;
    TTodoItem(Dest).Tag := Tag;
    TTodoItem(Dest).TotalTime := TotalTime;
  end;

  if Dest is TpjhTodoItem then
  begin
    TpjhTodoItem(Dest).TodoCode := TodoCode;
    TpjhTodoItem(Dest).TaskCode := TaskCode;
    TpjhTodoItem(Dest).PlanCode := PlanCode;
    TpjhTodoItem(Dest).ModId := ModId;
    TpjhTodoItem(Dest).AlarmType := AlarmType;
    TpjhTodoItem(Dest).AlarmTime2 := AlarmTime2;
    TpjhTodoItem(Dest).AlarmFlag := AlarmFlag;
    TpjhTodoItem(Dest).Alarm2Msg := Alarm2Msg;
    TpjhTodoItem(Dest).Alarm2Note := Alarm2Note;
    TpjhTodoItem(Dest).Alarm2Email := Alarm2Email;
    TpjhTodoItem(Dest).AlarmTime1 := AlarmTime1;
    TpjhTodoItem(Dest).ModDate := ModDate;
  end;
end;

constructor TpjhTodoItem.Create(Collection: TCollection);
begin
  inherited;

  FNotes := TStringList.Create;
end;

destructor TpjhTodoItem.Destroy;
begin
  FNotes.Free;

  inherited;
end;

procedure TpjhTodoItem.SetNotes(const Value: TStringList);
begin
  FNotes.Assign(Value);
end;

//분단위 숫자 반환
function GetAlarmInterval(AInterval: integer): longint;
begin
  case ALARM_INTERVAL(AInterval) of
    aiNone: Result := -1;
    ai0Min: Result := 0;
    ai5Min: Result := 5;
    ai10Min: Result := 10;
    ai15Min: Result := 15;
    ai30Min: Result := 30;
    ai1Hour: Result := 60;
    ai2Hour: Result := 120;
    ai3Hour: Result := 180;
    ai4Hour: Result := 240;
    ai5Hour: Result := 300;
    ai6Hour: Result := 360;
    ai7Hour: Result := 420;
    ai8Hour: Result := 480;
    ai9Hour: Result := 540;
    ai10Hour: Result := 600;
    ai11Hour: Result := 660;
    ai18Hour: Result := 1080;
    ai1Day: Result := 1440;
    ai2Day: Result := 2880;
    ai3Day: Result := 4320;
    ai4Day: Result := 5760;
    ai1Week: Result := 10080;
    ai2Week: Result := 20160;
  end;
end;

function GetAlarmComboIndex(AAlarmMinute: integer): integer;
begin
  case AAlarmMinute of
    -1 : Result := ord(aiNone);
    0: Result := ord(ai0Min);
    5: Result := ord(ai5Min);
    10: Result := ord(ai10Min);
    15: Result := ord(ai15Min);
    30: Result := ord(ai30Min);
    60: Result := ord(ai1Hour);
    120: Result := ord(ai2Hour);
    180: Result := ord(ai3Hour);
    240: Result := ord(ai4Hour);
    300: Result := ord(ai5Hour);
    360: Result := ord(ai6Hour);
    420: Result := ord(ai7Hour);
    480: Result := ord(ai8Hour);
    540: Result := ord(ai9Hour);
    600: Result := ord(ai10Hour);
    660: Result := ord(ai11Hour);
    1080: Result := ord(ai18Hour);
    1440: Result := ord(ai1Day);
    2880: Result := ord(ai2Day);
    4320: Result := ord(ai3Day);
    5760: Result := ord(ai4Day);
    10080: Result := ord(ai1Week);
    20160: Result := ord(ai2Week);
  end;
end;

end.

