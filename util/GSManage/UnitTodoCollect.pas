unit UnitTodoCollect;

interface

uses System.Classes, DateUtils, TodoList, SynCommons;

Type
  CODE_TYPE = (ctCategory = 1, ctGroup = 2, ctCode = 3);
  ALIAS_TYPE = (atDepart = 1, atTeam = 2, atPrivate = 3);
  VISIBLE_TYPE = (vtShow = 1, vtHide = 2, vtDisable = 3);

  TpjhTodoItem = class;

  TCompareFunction = function (Item1, Item2 : TpjhTodoItem) : integer of object;

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
    function ToJson: string;

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
//    function Compare(Item1, Item2: TpjhTodoItem): integer;
  protected
    function CompareAlarmTime(Item1, Item2 : TpjhTodoItem) : integer;
    function CompareCreationDate(Item1, Item2 : TpjhTodoItem) : integer; virtual;
    function CompareDueDateDate(Item1, Item2 : TpjhTodoItem) : integer; virtual;
    procedure QuickSort(L, R: Integer; ACompareFunction: TCompareFunction);
    //AlarmTime을 계산함(실제 Alarm이 발생할 시각을 미리 계산 함)
    procedure CalcAlarmTime;
  public
    FCurrentAlarmIndex: integer;
    FCompareFunction: TCompareFunction;

    function ToJson: string;
    procedure Assign(Source: TPersistent); override;
    procedure Sort(ACompareItem: integer);
    function  Add: TpjhTodoItem;
    function Insert(Index: Integer): TpjhTodoItem;
    property Items[Index: Integer]: TpjhTodoItem read GetItem  write SetItem; default;
  end;

  TDeleteToDoListFromDB = procedure(ApjhTodoItem: TpjhTodoItem);
  TInsertOrUpdateToDoList2DB = procedure (ApjhTodoItem: TpjhTodoItem; AIdAdd: Boolean);

type
  // Helper class to allow sorting of a TCollection
  {$HINTS OFF}
  TShadowedCollection = class(TPersistent)
  private
    FItemClass: TCollectionItemClass;
    FItems: TList;
  end;
  {$HINTS ON}


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

uses UnitDateUtil;

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

procedure TpjhToDoItemCollection.Assign(Source: TPersistent);
var
  i: integer;
  LpjhTodoItem: TpjhTodoItem;
begin
  if not Assigned(Source) then
    exit;

  Clear;

  for i := 0 to TpjhToDoItemCollection(Source).Count - 1 do
  begin
    LpjhTodoItem := Add;
    LpjhTodoItem.Assign(TpjhToDoItemCollection(Source).Items[i]);
  end;
end;

procedure TpjhToDoItemCollection.CalcAlarmTime;
var
  i: integer;
  myHour, myMin, mySec, myMilli : Word;
  myYear, myMonth, myDay : Word;
  Ldt: TDateTime;
begin
  for i := 0 to Count - 1 do
  begin
    if Items[i].AlarmType = 2 then //미리알람 모드인 경우(분단위)
    begin
      DecodeDateTime(Items[i].CreationDate, myYear, myMonth, myDay, myHour, myMin, mySec, myMilli);
      Ldt := EncodeDateTime(myYear, myMonth, myDay, myHour, myMin, mySec, myMilli);
      Ldt := DateTimeMinusInteger(Ldt, Items[i].AlarmTime2, 2, '-');
      Items[i].AlarmTime := Ldt;
    end
    else
      Items[i].AlarmTime := Items[i].AlarmTime1;
  end;
end;

//function TpjhToDoItemCollection.Compare(Item1, Item2: TpjhTodoItem): integer;
//begin
//(*Descendant classes would override this method and cast Item1 and Item2 to
//  thedecendant class's collection item type perform the field comparisions
//  if item1.MyField < item2.MyField
//  return -1
//  else if item1.MyField > item2.MyField
//  return 1
//  else return 0
//*)
//  if Item1.AlarmTime < Item2.AlarmTime then
//    Result := -1
//  else
//  if Item1.AlarmTime > Item2.AlarmTime then
//    Result := 1
//  else
//    Result := 0;
//end;

function TpjhToDoItemCollection.CompareAlarmTime(Item1,
  Item2: TpjhTodoItem): integer;
begin
  if Item1.AlarmTime < Item2.AlarmTime then
    Result := -1
  else
  if Item1.AlarmTime > Item2.AlarmTime then
    Result := 1
  else
    Result := 0;
end;

function TpjhToDoItemCollection.CompareCreationDate(Item1,
  Item2: TpjhTodoItem): integer;
begin
  if Item1.CreationDate < Item2.CreationDate then
    Result := -1
  else
  if Item1.CreationDate > Item2.CreationDate then
    Result := 1
  else
    Result := 0;
end;

function TpjhToDoItemCollection.CompareDueDateDate(Item1,
  Item2: TpjhTodoItem): integer;
begin
  if Item1.DueDate < Item2.DueDate then
    Result := -1
  else
  if Item1.DueDate > Item2.DueDate then
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

procedure TpjhToDoItemCollection.QuickSort(L, R: Integer;
  ACompareFunction: TCompareFunction);
var
  I, J, p: Integer;
  SortList: TList;
begin
  //This cast allows us to get at the private elements in the base class
  SortList := TShadowedCollection(Self).FItems;

  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;

    repeat
      while ACompareFunction(Items[I], Items[P]) < 0 do
        Inc(I);

      while ACompareFunction(Items[J], Items[P]) > 0 do
        Dec(J);

      if I <= J then
      begin
        SortList.Exchange(I,J);

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
      QuickSort(L, J, ACompareFunction);

    L := I;
  until I >= R;
end;

procedure TpjhToDoItemCollection.SetItem(Index: Integer;
  const Value: TpjhTodoItem);
begin
  Items[Index].Assign(Value);
end;

procedure TpjhToDoItemCollection.Sort(ACompareItem: integer);
begin
  if Count > 1 then
  begin
    case ACompareItem of
      1: begin
        FCompareFunction := CompareAlarmTime;
        QuickSort(0, pred(Count),FCompareFunction);
      end;
      2: QuickSort(0, pred(Count),CompareCreationDate);
      3: QuickSort(0, pred(Count),CompareDueDateDate);
    end;

  end;
end;

function TpjhToDoItemCollection.ToJson: string;
var
  Docs: TVariantDynArray;
  DocsDA: TDynArray;
  LCount: integer;
  i: integer;
  LpjhTodoItem: TpjhTodoItem;
begin
  DocsDA.Init(TypeInfo(TVariantDynArray), Docs, @LCount);
  LCount := Self.Count;
  SetLength(Docs,LCount);

  for i := 0 to LCount - 1 do
  begin
    LpjhTodoItem := Items[i];
    TDocVariant.New(Docs[i]);

    Docs[i] := _JSON(LpjhTodoItem.ToJson);
  end;

  Result := Utf8ToString(DocsDA.SaveToJson);
end;

{ TpjhTodoItem }

procedure TpjhTodoItem.Assign(Source: TPersistent);
begin
  if Source is TpjhTodoItem then
  begin
    Category := TpjhTodoItem(Source).Category;
    Complete := TpjhTodoItem(Source).Complete;
    Completion := TpjhTodoItem(Source).Completion;
    CompletionDate := TpjhTodoItem(Source).CompletionDate;
    CreationDate := TpjhTodoItem(Source).CreationDate;
    DueDate := TpjhTodoItem(Source).DueDate;
    ImageIndex := TpjhTodoItem(Source).ImageIndex;
    Notes.Assign(TpjhTodoItem(Source).Notes);
    Priority := TpjhTodoItem(Source).Priority;
    Project := TpjhTodoItem(Source).Project;
    Resource := TpjhTodoItem(Source).Resource;
    Status := TpjhTodoItem(Source).Status;
    Subject := TpjhTodoItem(Source).Subject;
    Tag := TpjhTodoItem(Source).Tag;
    TotalTime := TpjhTodoItem(Source).TotalTime;

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

function TpjhTodoItem.ToJson: string;
var
  Lvar: variant;
begin
  TDocVariant.New(Lvar);

  LVar.Category := Category;
  LVar.Complete := Complete;
  LVar.Completion := Completion;
  LVar.CompletionDate := CompletionDate;
  LVar.CreationDate := CreationDate;
  LVar.DueDate := DueDate;
  LVar.ImageIndex := ImageIndex;
  LVar.Notes := Notes.Text;
  LVar.Priority := Priority;
  LVar.Project := Project;
  LVar.Resource := Resource;
  LVar.Status := Status;
  LVar.Subject := Subject;
  LVar.Tag := Tag;
  LVar.TotalTime := TotalTime;

  LVar.TodoCode := TodoCode;
  LVar.TaskCode := TaskCode;
  LVar.PlanCode := PlanCode;
  LVar.ModId := ModId;

  LVar.AlarmType := AlarmType;
  LVar.AlarmTime2 := AlarmTime2;
  LVar.AlarmFlag := AlarmFlag;
  LVar.Alarm2Msg := Alarm2Msg;
  LVar.Alarm2Note := Alarm2Note;
  LVar.Alarm2Email := Alarm2Email;

  LVar.AlarmTime1 := AlarmTime1;
  LVar.ModDate := ModDate;

  Result := Utf8ToString(VariantSaveJson(LVar));
end;

end.

