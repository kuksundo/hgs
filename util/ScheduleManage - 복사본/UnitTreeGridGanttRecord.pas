unit UnitTreeGridGanttRecord;

interface

uses Classes, System.SysUtils, Generics.Legacy, RTTI, SynCommons;

const
  //'Xpos_DynArr array of string Ypos_DynArr array of string Weight_DynArr array of string LastUpdated_DynArr array of TDateTime';
  TG_REG_CODE = 'STGEHFUJXDOAMB';

type
  R_Cfg = packed record
    Code: RawUtf8;
    id: RawUtf8;
    NoVScroll: RawUtf8;
//    SuppressCfg: RawUtf8;
    NumberId: RawUtf8;
    IdChars: RawUtf8;
//    NoFormatEscape: RawUtf8;
//    Sort: RawUtf8;
//    Group: RawUtf8;
//    GroupRestoreSort: RawUtf8;
    MainCol: RawUtf8;
    ResizingMain,
    Undo: RawUtf8;
    ChangesUpdate: integer;
//    ChildParts: RawUtf8;
//    ScrollLeftLap: RawUtf8;
//    DefaultDate: RawUtf8;
//    MenuColumnsCount: RawUtf8;
//    MidWidth: RawUtf8;
//    MinRightWidth: RawUtf8;
//    MinLeftWidth: RawUtf8;
//    Style: RawUtf8;
//    Paging: RawUtf8;
//    PageLength: RawUtf8;
//    MaxHeight: RawUtf8;
//    MinTagHeight: RawUtf8;
//    CalendarsRepeatType: RawUtf8;
//    CalendarsRepeatEnum: RawUtf8;
//    CalendarsRepeatEnumKeys: RawUtf8;
//    CalendarsValueType: RawUtf8;
//    CalendarsValueEnum: RawUtf8;
//    CalendarsValueEnumKeys: RawUtf8;
//    CalendarsValueCaption: RawUtf8;
  end;

  R_Def = packed record
    Name: RawUtf8;
    Def,
    Calculated: RawUtf8;
    CalcOrder: RawUtf8;
    Expanded: RawUtf8;
    EditCols: RawUtf8;
    STARTFormula: RawUtf8;
    ENDDATEFormula: RawUtf8;
    DURFormula: RawUtf8;
    COMPFormula: RawUtf8;
    PARTSFormula: RawUtf8;
//    PARTSCanEdit: RawUtf8;
//    GANTTGanttClass1: RawUtf8;
//    PRICEFormula: RawUtf8;
    START1Formula: RawUtf8;
    ENDDATE1Formula: RawUtf8;
    DUR1Formula: RawUtf8;
    COMP1Formula: RawUtf8;
    PARTS1Formula: RawUtf8;

    START2Formula: RawUtf8;
    ENDDATE2Formula: RawUtf8;
    DUR2Formula: RawUtf8;
    COMP2Formula: RawUtf8;
    PARTS2Formula: RawUtf8;

    CDef: RawUtf8;

    GANTTGanttClass: RawUtf8;
    GANTTGanttIcons: RawUtf8;
    GANTTGanttSummary: RawUtf8;
    GANTTGanttEdit: RawUtf8;

    GANTTGanttClass1: RawUtf8;
    GANTTGanttIcons1: RawUtf8;
    GANTTGanttClass2: RawUtf8;
    GANTTGanttIcons2: RawUtf8;

    STARTCanEdit: RawUtf8;
    GroupMain,
    CanEdit,
    DefEmpty,
    DefParent: RawUtf8;

//    CMaxChars: RawUtf8;
//    ParentCDef: RawUtf8;
//    CanFilter: RawUtf8;
//    idVisible: RawUtf8;
//    CanSelect: RawUtf8;
//    CALENDARVisible: RawUtf8;
//    SECTIONHtmlPostfixFormula: RawUtf8;
  end;

  R_DEF_Arr = array of R_Def;

  R_LeftCols = packed record
    Name,
    F_Type,
    CanEdit,
    CanSort,
    CanEmpty,
    Align,
    Format,
    EditFormat,
    Range,
    Width,
    Visible: RawUtf8;
//    WidthPad: RawUtf8;
  end;

  R_LeftCols_Arr = array of R_LeftCols;

  R_Cols = packed record
//    Name: RawUtf8;
//    Width: RawUtf8;
//    F_Type: RawUtf8;
//    Format: RawUtf8;
//    EditFormat: RawUtf8;
    Name,
    F_Type,
    GanttDataUnits,
    GanttUnits,
    GanttLastUnit,
    GanttWidth,
    GanttStart,
    GanttEnd,
    GanttDuration,
    GanttComplete,
    GanttParts,
    GanttHeader,

    GanttStart1,
    GanttEnd1,
    GanttDuration1,
    GanttComplete1,
    GanttParts1,
    GanttHeader1,
    GanttClass1,
    GanttTop1,
    GanttHeight1,

    GanttStart2,
    GanttEnd2,
    GanttDuration2,
    GanttComplete2,
    GanttParts2,
    GanttHeader2,
    GanttClass2,
    GanttTop2,
    GanttHeight2,

    GanttDescendants,
    GanttAncestors,
    GanttMinStart,
    GanttMaxStart,
    GanttMinEnd,
    GanttMaxEnd,
    GanttCorrectDependencies,
    GanttLeft,
	  GanttRight,
    GanttExclude,
    GanttZoom,
    GanttResources,
    GanttResourcesAssign,
    GanttResourcesExtra,
    //0 - permits placing, 1 - restricts placing, 2 - asks user
    GanttFlags,
    GanttFlagTexts,
    GanttFlagIcons,
    GanttFlagClasses,
    GanttLines, //flags1#date1a~date1b#class1;flagss2#date2a~date2b#class2;
    GanttText: RawUtf8;
    GanttCount,
    GanttCheckExclude,
    GanttZoomFit : integer;
  end;

  R_Cols_Arr = array of R_Cols;

  R_RightCols = packed record
    Name: RawUtf8;
    F_Type: RawUtf8;
    GanttDataUnits: RawUtf8;
    GanttUnits: RawUtf8;
    GanttWidth,
    GanttStart,
    GanttEnd,
    GanttDuration,
    GanttComplete,
    GanttParts,
    GanttHeader1,
    GanttDescendants,
    GanttAncestors,
    GanttMinStart,
    GanttMaxStart,
    GanttMinEnd,
    GanttMaxEnd,
    GanttCorrectDependencies,
    GanttLeft,
	  GanttRight: RawUtf8;
  end;

  R_RightCols_Arr = array of R_RightCols;

  R_Header = packed record
    id,
    Process,
    START,
    ENDDATE,
    START1,
    ENDDATE1,
    START2,
    ENDDATE2,
    COMP,
    PARTS,
    DUR,
    ANC,
    DEC,
    ES,
    LFinish,
    STARTTip,
    ENDTip,
    COMPTip,
    PARTSTip,
    DURTip,
    ANCTip,
    ESTip,
    LFTip,
    SortIcons,
    Test: RawUtf8;
  end;


  R_Calendars = packed record
    Name: RawUtf8;
    Exclude: RawUtf8;
  end;

  R_Solid = packed record
    Kind: RawUtf8;
    id: RawUtf8;
    Space: RawUtf8;
    Panel: RawUtf8;
    Cells: RawUtf8;
    Recalc: RawUtf8;

    ListLeft: RawUtf8;
    ListHtmlPrefix: RawUtf8;
    ListHtmlPostfix: RawUtf8;
    List: RawUtf8;
    Cols: RawUtf8;
    ListWidth: RawUtf8;

    ZoomType: RawUtf8;
    ZoomHtmlPrefix: RawUtf8;
    ZoomHtmlPostfix: RawUtf8;
    ZoomLeft: RawUtf8;
    ZoomWidth: RawUtf8;

    ExLabel: RawUtf8;
    ExWidth: RawUtf8;
    ExLeft: RawUtf8;
    ExType: RawUtf8;
    ExOnClickSideDefaults :  RawUtf8;
    ExFormula: RawUtf8;
    ExOnChange: RawUtf8;
    ExUndo: RawUtf8;
    ExTip: RawUtf8;

    HidExType: RawUtf8;
    HidExNoColor: RawUtf8;
    HidExLeft: RawUtf8;
    HidExCanFocus: RawUtf8;
    HidExLabelRight: RawUtf8;
    HidExFormula: RawUtf8;
    HidExOnChange: RawUtf8;
    HidExCanEditFormula: RawUtf8;
    HidTip: RawUtf8;

    CalType: RawUtf8;
    CalNoColor: RawUtf8;
    CalLeft: RawUtf8;
    CalCanFocus: RawUtf8;
    CalCanEdit: RawUtf8;
    CalLabelRight: RawUtf8;
    CalFormula: RawUtf8;
    CalOnChange: RawUtf8;
    CalTip: RawUtf8;
  end;

  R_Foot = packed record

  end;

  R_Resources = packed record
    Name: RawUtf8;
    Price: RawUtf8;
    F_Type: RawUtf8;
    Availability: RawUtf8;
  end;

  R_Lang = packed record

  end;

  R_Pager = packed record

  end;

  R_Toolbar = packed record

  end;

  R_Body = packed record
    Def,
    id,
    START,
    ENDDATE,
    COMP,
    ES,
    LFinish,
    ANC: RawUtf8;
    Items: array of R_Body;
  end;

  R_Gantt = packed record
    Name: RawUtf8;
    F_Type: RawUtf8;
    GanttDataUnits: RawUtf8;
    GanttUnits: RawUtf8;
    GanttWidth,
//    MenuName: RawUtf8;
//    GanttCount: RawUtf8;
//    GanttTask: RawUtf8;
//    GanttDataModifiers: RawUtf8;
//    GanttLastUnit: RawUtf8;

    //* First main bar plan definition */
    GanttStart: RawUtf8;
    GanttEnd: RawUtf8;
    GanttDuration: RawUtf8;
    GanttComplete: RawUtf8;
    GanttParts: RawUtf8;
//    GanttText: RawUtf8;
//    GanttResources: RawUtf8;
//    GanttHtmlRight: RawUtf8;

    //* Second main bar plan definition */
//    GanttParts1,
//    GanttText1,
//    GanttTop1,
//    GanttHeight1,
//    GanttClass1,
    GanttHeader1,
//    GanttMilestones1: RawUtf8;

    //* Flags definition */
//    GanttFlags,
//    GanttFlagTexts,
//    GanttFlagsMove: RawUtf8;

    //* Vertical lines definition */
    GanttLines,
//    GanttLine0Tip: RawUtf8;

    //* Settings for scheduling */
    GanttDescendants,
    GanttAncestors,
    GanttMinStart,
    GanttMaxStart,
    GanttMinEnd,
    GanttMaxEnd,
//    GanttSlack,
//    GanttAssignDependencies,
//    GanttAllDependencies,
//    GanttStrict,
//    GanttDirection,
    GanttCorrectDependencies,
//    GanttCorrectDependenciesFixed,
//    GanttCheckExclude: RawUtf8;

//    GanttBase,
//    GanttFinish,
//    GanttBaseProof,
//    GanttFinishProof,
//    GanttBaseTip,
//    GanttBaseAutoTip,
//    GanttFinishTip,
//    GanttFinishAutoTip,
//    GanttLineTipDateFormat: RawUtf8;

    //* Resources */
//    GanttResourcesAssign: RawUtf8;

    //* Tooltips */
//    GanttTip: RawUtf8;//    GanttMilestoneTip: RawUtf8;
//    GanttTip1: RawUtf8;
//    GanttFlagsTip: RawUtf8;
//    GanttDependencyTip: RawUtf8;//    GanttDependencyTipDateFormat: RawUtf8;
    //* Exclude settings */
//    GanttCalendar,
//    GanttExclude,
//    GanttHideExclude,
//    GanttAvailabilityExclude: RawUtf8;

    //* Horizontal Gantt paging settings */
//    GanttPaging,
//    GanttHeaderPaging2,
//	  GanttHeaderPaging3: RawUtf8;

    //* Basic zoom settings */
//    GanttZoom,
//    GanttChartMinStart,
//	  GanttChartMaxEnd,
    GanttLeft,
	  GanttRight,
//    MinWidth,
    GanttBackground: RawUtf8;
  end;

  TTGGanttConfig = packed record
    Cfg: R_Cfg;
    Def: R_DEF_Arr;
    LeftCols: R_LeftCols_Arr;
    Cols: R_Cols_Arr;
//    RightCols: R_RightCols_Arr;
    Header: R_Header;
//    Calendars: array of RawUtf8;
//    Solid: array of RawUtf8;
//    Foot: RawUtf8;
    Resources: array of R_Resources;
//    Lang: RawUtf8;
//    Pager: RawUtf8;
//    Toolbar: RawUtf8;
    Body: array of RawUtf8;
  end;

  PR_Data = ^R_Data;

  R_Data = packed record
    id,
    Process,
    GANTTGanttHtmlRight,
    START,
    ENDDATE,
    COMPLETE,
    DEC,
    ANC,
    ES,
    LFinish,
    RES,
    BIGO,
    FLAGS,
    ICONS: RawUtf8;
  end;

  R_Data_Arr = array of R_Data;

  TTGGanttChanges = packed record
    Changes: R_Data_Arr;
  end;

  TJSONSerializer4Cfg = class(TObject)
  public
    class function ReadJSON(P: PUTF8Char;
      var aValue; out aValid: Boolean): PUTF8Char;
    class procedure WriteJSON(const aWriter: TTextWriter; const aValue);
  end;

  TpjhGenericWriteJSON = class
  public
    class procedure GenericWriteJSON<T>(const aWriter: TTextWriter; const aValue: T);
  end;

  TJSONSerializer4Def = class(TObject)
  public
    class function ReadJSON(P: PUTF8Char;
      var aValue; out aValid: Boolean): PUTF8Char;
    class procedure WriteJSON(const aWriter: TTextWriter; const aValue);
  end;

  TJSONSerializer4LeftCols = class(TObject)
  public
    class function ReadJSON(P: PUTF8Char;
      var aValue; out aValid: Boolean): PUTF8Char;
    class procedure WriteJSON(const aWriter: TTextWriter; const aValue);
  end;

  TJSONSerializer4Cols = class(TObject)
  public
    class function ReadJSON(P: PUTF8Char;
      var aValue; out aValid: Boolean): PUTF8Char;
    class procedure WriteJSON(const aWriter: TTextWriter; const aValue);
  end;

  TJSONSerializer4Header = class(TObject)
  public
    class function ReadJSON(P: PUTF8Char;
      var aValue; out aValid: Boolean): PUTF8Char;
    class procedure WriteJSON(const aWriter: TTextWriter; const aValue);
  end;

  TJSONSerializer4Data = class(TObject)
  public
    class function ReadJSON(P: PUTF8Char;
      var aValue; out aValid: Boolean): PUTF8Char;
    class procedure WriteJSON(const aWriter: TTextWriter; const aValue);
  end;

const
  __TTGGanttConfig = 'Cfg {Code,id,NoVSCroll,NumberId,IdChars,Undo,MainCol RawUtf8} ' +
    'Def [Name,Def,Calculated,CalcOrder,Expanded,EditCols,STARTFormula,ENDFormula,DURATIONFormula,' +
    'COMPLETEFormula,PARTSFormula,CDef,GANTTGanttClass,GANTTGanttIcons,GANTTGanttSummary,'+
    'GANTTGanttEdit,STARTCanEdit,GroupMain,CanEdit,DefEmpty,DefParent RawUtf8] ' +
    'LeftCols [Name,F_Type,CanEdit,CanSort,Align,Format,EditFormat,Range,Width RawUtf8]' +
    'Cols [Name,F_Type,GanttDataUnits,GanttUnits,GanttWidth,GanttStart,GanttEnd,' +
    'GanttDuration,GanttComplete,GanttParts,GanttHeader1,GanttDescendants,' +
    'GanttAncestors,GanttMinStart,GanttMaxStart,GanttMinEnd,GanttMaxEnd,GanttCorrectDependencies,' +
    'GanttLeft,GanttRight RawUtf8] ' +
    'Header {id,STARTTip,ENDTip,COMPTip,PARTSTip,DURTip,ANCTip,ESTip,LFTip,SortIcons,Test RawUtf8}';

var
  G_ExcludeNullList: TStringList; //값이 '' 인 경우에도 JSON에 표시할 경우 리스트에 필드명 추가하면 됨

implementation

{ TJSONSerializer4Cfg }

class function TJSONSerializer4Cfg.ReadJSON(P: PUTF8Char; var aValue;
  out aValid: Boolean): PUTF8Char;
begin

end;

class procedure TJSONSerializer4Cfg.WriteJSON(const aWriter: TTextWriter;
  const aValue);
var
  V: R_Cfg absolute aValue;
  LList: TRawUTF8List;
  rtype: TRTTIType;
  fields: TArray<TRttiField>;
  i: integer;
  LUtf8: RawUtf8;
begin
  LList := TRawUTF8List.Create;
  try
    aWriter.AddString('{');
    rtype := TRTTIContext.Create.GetType(TypeInfo(R_Cfg));
    fields := rtype.GetFields;

    for i := 0 to High(fields) do
    begin
      LUtf8 := fields[i].GetValue(@V).ToString;

      if LUtf8 <> '' then
        LList.Add(fields[i].Name + ':' + QuotedStr(LUtf8, '"'));
    end;

    aWriter.AddString(LList.GetText(','));
    aWriter.AddString('}');
    LList := nil;
  finally
    LList.Free;
  end;
end;

{ TJSONSerializer4Header }

class function TJSONSerializer4Header.ReadJSON(P: PUTF8Char; var aValue;
  out aValid: Boolean): PUTF8Char;
begin

end;

class procedure TJSONSerializer4Header.WriteJSON(const aWriter: TTextWriter;
  const aValue);
var
  V: R_Header absolute aValue;
begin
  TpjhGenericWriteJSON.GenericWriteJSON<R_Header>(aWriter,V);
end;

{ TpjhGenericWriteJSON }

class procedure TpjhGenericWriteJSON.GenericWriteJSON<T>(const aWriter: TTextWriter;
  const aValue: T);
var
  LList: TRawUTF8List;
  rtype: TRTTIType;
  fields: TArray<TRttiField>;
  i: integer;
  LUtf8: RawUtf8;
begin
  LList := TRawUTF8List.Create;
  try
    aWriter.AddString('{');
    rtype := TRTTIContext.Create.GetType(TypeInfo(T));
    fields := rtype.GetFields;

    for i := 0 to High(fields) do
    begin
      LUtf8 := fields[i].GetValue(@aValue).ToString;

      if LUtf8 = '' then
        if G_ExcludeNullList.IndexOf(fields[i].Name) = -1 then
          continue;

      LList.Add(fields[i].Name + ':' + QuotedStr(LUtf8, '"'));
    end;

    aWriter.AddString(LList.GetText(','));
    aWriter.AddString('}');
    LList := nil;
  finally
    LList.Free;
  end;

end;

{ TJSONSerializer4LeftCols }

class function TJSONSerializer4LeftCols.ReadJSON(P: PUTF8Char; var aValue;
  out aValid: Boolean): PUTF8Char;
begin

end;

class procedure TJSONSerializer4LeftCols.WriteJSON(const aWriter: TTextWriter;
  const aValue);
var
  V: R_LeftCols absolute aValue;
begin
  TpjhGenericWriteJSON.GenericWriteJSON<R_LeftCols>(aWriter,V);
end;

{ TJSONSerializer4Def }

class function TJSONSerializer4Def.ReadJSON(P: PUTF8Char; var aValue;
  out aValid: Boolean): PUTF8Char;
begin

end;

class procedure TJSONSerializer4Def.WriteJSON(const aWriter: TTextWriter;
  const aValue);
var
  V: R_Def absolute aValue;
begin
  TpjhGenericWriteJSON.GenericWriteJSON<R_Def>(aWriter,V);
end;

{ TJSONSerializer4Cols }

class function TJSONSerializer4Cols.ReadJSON(P: PUTF8Char; var aValue;
  out aValid: Boolean): PUTF8Char;
begin

end;

class procedure TJSONSerializer4Cols.WriteJSON(const aWriter: TTextWriter;
  const aValue);
var
  V: R_Cols absolute aValue;
begin
  TpjhGenericWriteJSON.GenericWriteJSON<R_Cols>(aWriter,V);
end;

{ TJSONSerializer4Data }

class function TJSONSerializer4Data.ReadJSON(P: PUTF8Char; var aValue;
  out aValid: Boolean): PUTF8Char;
begin

end;

class procedure TJSONSerializer4Data.WriteJSON(const aWriter: TTextWriter;
  const aValue);
var
  V: R_Data absolute aValue;
begin
  TpjhGenericWriteJSON.GenericWriteJSON<R_Data>(aWriter,V);
end;

{ TJSONSerializer4R_Data }

initialization
  G_ExcludeNullList := TStringList.Create;

  TTextWriter.RegisterCustomJSONSerializer(TypeInfo(R_Cfg),
    nil, TJSONSerializer4Cfg.WriteJSON);

  TTextWriter.RegisterCustomJSONSerializer(TypeInfo(R_Def),
    nil, TJSONSerializer4Def.WriteJSON);

  TTextWriter.RegisterCustomJSONSerializer(TypeInfo(R_LeftCols),
    nil, TJSONSerializer4LeftCols.WriteJSON);

  TTextWriter.RegisterCustomJSONSerializer(TypeInfo(R_Cols),
    nil, TJSONSerializer4Cols.WriteJSON);

  TTextWriter.RegisterCustomJSONSerializer(TypeInfo(R_Header),
    nil, TJSONSerializer4Header.WriteJSON);

  TTextWriter.RegisterCustomJSONSerializer(TypeInfo(R_Data),
    nil, TJSONSerializer4Data.WriteJSON);

//  TTextWriter.RegisterCustomJSONSerializerFromText(
//    TypeInfo(TTGGanttConfig), __TTGGanttConfig);

finalization
  G_ExcludeNullList.Free;
end.
||||||| .r0
=======
unit UnitTreeGridGanttRecord;

interface

uses Classes, System.SysUtils, Generics.Legacy, RTTI, SynCommons;

const
  //'Xpos_DynArr array of string Ypos_DynArr array of string Weight_DynArr array of string LastUpdated_DynArr array of TDateTime';
  TG_REG_CODE = 'STGEHFUJXDOAMB';

type
  R_Cfg = packed record
    Code: RawUtf8;
    id: RawUtf8;
    NoVScroll: RawUtf8;
//    SuppressCfg: RawUtf8;
    NumberId: RawUtf8;
    IdChars: RawUtf8;
//    NoFormatEscape: RawUtf8;
//    Sort: RawUtf8;
//    Group: RawUtf8;
//    GroupRestoreSort: RawUtf8;
    MainCol: RawUtf8;
    ResizingMain,
    Undo: RawUtf8;
//    ChildParts: RawUtf8;
//    ScrollLeftLap: RawUtf8;
//    DefaultDate: RawUtf8;
//    MenuColumnsCount: RawUtf8;
//    MidWidth: RawUtf8;
//    MinRightWidth: RawUtf8;
//    MinLeftWidth: RawUtf8;
//    Style: RawUtf8;
//    Paging: RawUtf8;
//    PageLength: RawUtf8;
//    MaxHeight: RawUtf8;
//    MinTagHeight: RawUtf8;
//    CalendarsRepeatType: RawUtf8;
//    CalendarsRepeatEnum: RawUtf8;
//    CalendarsRepeatEnumKeys: RawUtf8;
//    CalendarsValueType: RawUtf8;
//    CalendarsValueEnum: RawUtf8;
//    CalendarsValueEnumKeys: RawUtf8;
//    CalendarsValueCaption: RawUtf8;
  end;

  R_Def = packed record
    Name: RawUtf8;
    Def,
    Calculated: RawUtf8;
    CalcOrder: RawUtf8;
    Expanded: RawUtf8;
    EditCols: RawUtf8;
    STARTFormula: RawUtf8;
    ENDDATEFormula: RawUtf8;
    DURFormula: RawUtf8;
    COMPFormula: RawUtf8;
    PARTSFormula: RawUtf8;
//    PARTSCanEdit: RawUtf8;
//    GANTTGanttClass1: RawUtf8;
//    PRICEFormula: RawUtf8;
    START1Formula: RawUtf8;
    END1Formula: RawUtf8;
    DURATION1Formula: RawUtf8;
    COMPLETE1Formula: RawUtf8;
    PARTS1Formula: RawUtf8;

    CDef: RawUtf8;
    GANTTGanttClass: RawUtf8;
    GANTTGanttIcons: RawUtf8;
    GANTTGanttSummary: RawUtf8;
    GANTTGanttEdit: RawUtf8;
    STARTCanEdit: RawUtf8;
    GroupMain,
    CanEdit,
    DefEmpty,
    DefParent: RawUtf8;

//    CMaxChars: RawUtf8;
//    ParentCDef: RawUtf8;
//    CanFilter: RawUtf8;
//    idVisible: RawUtf8;
//    CanSelect: RawUtf8;
//    CALENDARVisible: RawUtf8;
//    SECTIONHtmlPostfixFormula: RawUtf8;
  end;

  R_DEF_Arr = array of R_Def;

  R_LeftCols = packed record
    Name,
    F_Type,
    CanEdit,
    CanSort,
    CanEmpty,
    Align,
    Format,
    EditFormat,
    Range,
    Width,
    Visible: RawUtf8;
//    WidthPad: RawUtf8;
  end;

  R_LeftCols_Arr = array of R_LeftCols;

  R_Cols = packed record
//    Name: RawUtf8;
//    Width: RawUtf8;
//    F_Type: RawUtf8;
//    Format: RawUtf8;
//    EditFormat: RawUtf8;
    Name,
    F_Type,
    GanttDataUnits,
    GanttUnits,
    GanttLastUnit,
    GanttWidth,
    GanttStart,
    GanttEnd,
    GanttDuration,
    GanttComplete,
    GanttParts,
    GanttHeader1,
    GanttHeader2,
    GanttHeader3,
    GanttDescendants,
    GanttAncestors,
    GanttMinStart,
    GanttMaxStart,
    GanttMinEnd,
    GanttMaxEnd,
    GanttCorrectDependencies,
    GanttLeft,
	  GanttRight,
    GanttExclude,
    GanttZoom,
    GanttResources,
    GanttResourcesAssign,
    GanttResourcesExtra,
    //0 - permits placing, 1 - restricts placing, 2 - asks user
    GanttFlags,
    GanttFlagTexts,
    GanttFlagIcons,
    GanttFlagClasses,
    GanttLines, //flags1#date1a~date1b#class1;flagss2#date2a~date2b#class2;
    GanttText: RawUtf8;
    GanttCheckExclude,
    GanttZoomFit : integer;
  end;

  R_Cols_Arr = array of R_Cols;

  R_RightCols = packed record
    Name: RawUtf8;
    F_Type: RawUtf8;
    GanttDataUnits: RawUtf8;
    GanttUnits: RawUtf8;
    GanttWidth,
    GanttStart,
    GanttEnd,
    GanttDuration,
    GanttComplete,
    GanttParts,
    GanttHeader1,
    GanttDescendants,
    GanttAncestors,
    GanttMinStart,
    GanttMaxStart,
    GanttMinEnd,
    GanttMaxEnd,
    GanttCorrectDependencies,
    GanttLeft,
	  GanttRight: RawUtf8;
  end;

  R_RightCols_Arr = array of R_RightCols;

  R_Header = packed record
    id,
    Process,
    START,
    ENDDATE,
    COMP,
    PARTS,
    DUR,
    ANC,
    DEC,
    ES,
    LFinish,
    STARTTip,
    ENDTip,
    COMPTip,
    PARTSTip,
    DURTip,
    ANCTip,
    ESTip,
    LFTip,
    SortIcons,
    Test: RawUtf8;
  end;


  R_Calendars = packed record
    Name: RawUtf8;
    Exclude: RawUtf8;
  end;

  R_Solid = packed record
    Kind: RawUtf8;
    id: RawUtf8;
    Space: RawUtf8;
    Panel: RawUtf8;
    Cells: RawUtf8;
    Recalc: RawUtf8;

    ListLeft: RawUtf8;
    ListHtmlPrefix: RawUtf8;
    ListHtmlPostfix: RawUtf8;
    List: RawUtf8;
    Cols: RawUtf8;
    ListWidth: RawUtf8;

    ZoomType: RawUtf8;
    ZoomHtmlPrefix: RawUtf8;
    ZoomHtmlPostfix: RawUtf8;
    ZoomLeft: RawUtf8;
    ZoomWidth: RawUtf8;

    ExLabel: RawUtf8;
    ExWidth: RawUtf8;
    ExLeft: RawUtf8;
    ExType: RawUtf8;
    ExOnClickSideDefaults :  RawUtf8;
    ExFormula: RawUtf8;
    ExOnChange: RawUtf8;
    ExUndo: RawUtf8;
    ExTip: RawUtf8;

    HidExType: RawUtf8;
    HidExNoColor: RawUtf8;
    HidExLeft: RawUtf8;
    HidExCanFocus: RawUtf8;
    HidExLabelRight: RawUtf8;
    HidExFormula: RawUtf8;
    HidExOnChange: RawUtf8;
    HidExCanEditFormula: RawUtf8;
    HidTip: RawUtf8;

    CalType: RawUtf8;
    CalNoColor: RawUtf8;
    CalLeft: RawUtf8;
    CalCanFocus: RawUtf8;
    CalCanEdit: RawUtf8;
    CalLabelRight: RawUtf8;
    CalFormula: RawUtf8;
    CalOnChange: RawUtf8;
    CalTip: RawUtf8;
  end;

  R_Foot = packed record

  end;

  R_Resources = packed record
    Name: RawUtf8;
    Price: RawUtf8;
    F_Type: RawUtf8;
    Availability: RawUtf8;
  end;

  R_Lang = packed record

  end;

  R_Pager = packed record

  end;

  R_Toolbar = packed record

  end;

  R_Body = packed record
    Def,
    id,
    START,
    ENDDATE,
    COMP,
    ES,
    LFinish,
    ANC: RawUtf8;
    Items: array of R_Body;
  end;

  R_Gantt = packed record
    Name: RawUtf8;
    F_Type: RawUtf8;
    GanttDataUnits: RawUtf8;
    GanttUnits: RawUtf8;
    GanttWidth,
//    MenuName: RawUtf8;
//    GanttCount: RawUtf8;
//    GanttTask: RawUtf8;
//    GanttDataModifiers: RawUtf8;
//    GanttLastUnit: RawUtf8;

    //* First main bar plan definition */
    GanttStart: RawUtf8;
    GanttEnd: RawUtf8;
    GanttDuration: RawUtf8;
    GanttComplete: RawUtf8;
    GanttParts: RawUtf8;
//    GanttText: RawUtf8;
//    GanttResources: RawUtf8;
//    GanttHtmlRight: RawUtf8;

    //* Second main bar plan definition */
//    GanttParts1,
//    GanttText1,
//    GanttTop1,
//    GanttHeight1,
//    GanttClass1,
    GanttHeader1,
//    GanttMilestones1: RawUtf8;

    //* Flags definition */
//    GanttFlags,
//    GanttFlagTexts,
//    GanttFlagsMove: RawUtf8;

    //* Vertical lines definition */
    GanttLines,
//    GanttLine0Tip: RawUtf8;

    //* Settings for scheduling */
    GanttDescendants,
    GanttAncestors,
    GanttMinStart,
    GanttMaxStart,
    GanttMinEnd,
    GanttMaxEnd,
//    GanttSlack,
//    GanttAssignDependencies,
//    GanttAllDependencies,
//    GanttStrict,
//    GanttDirection,
    GanttCorrectDependencies,
//    GanttCorrectDependenciesFixed,
//    GanttCheckExclude: RawUtf8;

//    GanttBase,
//    GanttFinish,
//    GanttBaseProof,
//    GanttFinishProof,
//    GanttBaseTip,
//    GanttBaseAutoTip,
//    GanttFinishTip,
//    GanttFinishAutoTip,
//    GanttLineTipDateFormat: RawUtf8;

    //* Resources */
//    GanttResourcesAssign: RawUtf8;

    //* Tooltips */
//    GanttTip: RawUtf8;//    GanttMilestoneTip: RawUtf8;
//    GanttTip1: RawUtf8;
//    GanttFlagsTip: RawUtf8;
//    GanttDependencyTip: RawUtf8;//    GanttDependencyTipDateFormat: RawUtf8;
    //* Exclude settings */
//    GanttCalendar,
//    GanttExclude,
//    GanttHideExclude,
//    GanttAvailabilityExclude: RawUtf8;

    //* Horizontal Gantt paging settings */
//    GanttPaging,
//    GanttHeaderPaging2,
//	  GanttHeaderPaging3: RawUtf8;

    //* Basic zoom settings */
//    GanttZoom,
//    GanttChartMinStart,
//	  GanttChartMaxEnd,
    GanttLeft,
	  GanttRight,
//    MinWidth,
    GanttBackground: RawUtf8;
  end;

  TTGGanttConfig = packed record
    Cfg: R_Cfg;
    Def: R_DEF_Arr;
    LeftCols: R_LeftCols_Arr;
    Cols: R_Cols_Arr;
//    RightCols: R_RightCols_Arr;
    Header: R_Header;
//    Calendars: array of RawUtf8;
//    Solid: array of RawUtf8;
//    Foot: RawUtf8;
    Resources: array of R_Resources;
//    Lang: RawUtf8;
//    Pager: RawUtf8;
//    Toolbar: RawUtf8;
    Body: array of RawUtf8;
  end;

  PR_Data = ^R_Data;

  R_Data = packed record
    id,
    Process,
    GANTTGanttHtmlRight,
    START,
    ENDDATE,
    COMPLETE,
    DEC,
    ANC,
    ES,
    LFinish,
    RES,
    BIGO,
    FLAGS,
    ICONS: RawUtf8;
  end;

  R_Data_Arr = array of R_Data;

  TTGGanttChanges = packed record
    Changes: R_Data_Arr;
  end;

  TJSONSerializer4Cfg = class(TObject)
  public
    class function ReadJSON(P: PUTF8Char;
      var aValue; out aValid: Boolean): PUTF8Char;
    class procedure WriteJSON(const aWriter: TTextWriter; const aValue);
  end;

  TpjhGenericWriteJSON = class
  public
    class procedure GenericWriteJSON<T>(const aWriter: TTextWriter; const aValue: T);
  end;

  TJSONSerializer4Def = class(TObject)
  public
    class function ReadJSON(P: PUTF8Char;
      var aValue; out aValid: Boolean): PUTF8Char;
    class procedure WriteJSON(const aWriter: TTextWriter; const aValue);
  end;

  TJSONSerializer4LeftCols = class(TObject)
  public
    class function ReadJSON(P: PUTF8Char;
      var aValue; out aValid: Boolean): PUTF8Char;
    class procedure WriteJSON(const aWriter: TTextWriter; const aValue);
  end;

  TJSONSerializer4Cols = class(TObject)
  public
    class function ReadJSON(P: PUTF8Char;
      var aValue; out aValid: Boolean): PUTF8Char;
    class procedure WriteJSON(const aWriter: TTextWriter; const aValue);
  end;

  TJSONSerializer4Header = class(TObject)
  public
    class function ReadJSON(P: PUTF8Char;
      var aValue; out aValid: Boolean): PUTF8Char;
    class procedure WriteJSON(const aWriter: TTextWriter; const aValue);
  end;

  TJSONSerializer4Data = class(TObject)
  public
    class function ReadJSON(P: PUTF8Char;
      var aValue; out aValid: Boolean): PUTF8Char;
    class procedure WriteJSON(const aWriter: TTextWriter; const aValue);
  end;

const
  __TTGGanttConfig = 'Cfg {Code,id,NoVSCroll,NumberId,IdChars,Undo,MainCol RawUtf8} ' +
    'Def [Name,Def,Calculated,CalcOrder,Expanded,EditCols,STARTFormula,ENDFormula,DURATIONFormula,' +
    'COMPLETEFormula,PARTSFormula,CDef,GANTTGanttClass,GANTTGanttIcons,GANTTGanttSummary,'+
    'GANTTGanttEdit,STARTCanEdit,GroupMain,CanEdit,DefEmpty,DefParent RawUtf8] ' +
    'LeftCols [Name,F_Type,CanEdit,CanSort,Align,Format,EditFormat,Range,Width RawUtf8]' +
    'Cols [Name,F_Type,GanttDataUnits,GanttUnits,GanttWidth,GanttStart,GanttEnd,' +
    'GanttDuration,GanttComplete,GanttParts,GanttHeader1,GanttDescendants,' +
    'GanttAncestors,GanttMinStart,GanttMaxStart,GanttMinEnd,GanttMaxEnd,GanttCorrectDependencies,' +
    'GanttLeft,GanttRight RawUtf8] ' +
    'Header {id,STARTTip,ENDTip,COMPTip,PARTSTip,DURTip,ANCTip,ESTip,LFTip,SortIcons,Test RawUtf8}';

implementation

{ TJSONSerializer4Cfg }

class function TJSONSerializer4Cfg.ReadJSON(P: PUTF8Char; var aValue;
  out aValid: Boolean): PUTF8Char;
begin

end;

class procedure TJSONSerializer4Cfg.WriteJSON(const aWriter: TTextWriter;
  const aValue);
var
  V: R_Cfg absolute aValue;
  LList: TRawUTF8List;
  rtype: TRTTIType;
  fields: TArray<TRttiField>;
  i: integer;
  LUtf8: RawUtf8;
begin
  LList := TRawUTF8List.Create;
  try
    aWriter.AddString('{');
    rtype := TRTTIContext.Create.GetType(TypeInfo(R_Cfg));
    fields := rtype.GetFields;

    for i := 0 to High(fields) do
    begin
      LUtf8 := fields[i].GetValue(@V).ToString;

      if LUtf8 <> '' then
        LList.Add(fields[i].Name + ':' + QuotedStr(LUtf8, '"'));
    end;

    aWriter.AddString(LList.GetText(','));
    aWriter.AddString('}');
    LList := nil;
  finally
    LList.Free;
  end;
end;

{ TJSONSerializer4Header }

class function TJSONSerializer4Header.ReadJSON(P: PUTF8Char; var aValue;
  out aValid: Boolean): PUTF8Char;
begin

end;

class procedure TJSONSerializer4Header.WriteJSON(const aWriter: TTextWriter;
  const aValue);
var
  V: R_Header absolute aValue;
begin
  TpjhGenericWriteJSON.GenericWriteJSON<R_Header>(aWriter,V);
end;

{ TpjhGenericWriteJSON }

class procedure TpjhGenericWriteJSON.GenericWriteJSON<T>(const aWriter: TTextWriter;
  const aValue: T);
var
  LList: TRawUTF8List;
  rtype: TRTTIType;
  fields: TArray<TRttiField>;
  i: integer;
  LUtf8: RawUtf8;
begin
  LList := TRawUTF8List.Create;
  try
    aWriter.AddString('{');
    rtype := TRTTIContext.Create.GetType(TypeInfo(T));
    fields := rtype.GetFields;

    for i := 0 to High(fields) do
    begin
      LUtf8 := fields[i].GetValue(@aValue).ToString;

      if LUtf8 <> '' then
        LList.Add(fields[i].Name + ':' + QuotedStr(LUtf8, '"'));
    end;

    aWriter.AddString(LList.GetText(','));
    aWriter.AddString('}');
    LList := nil;
  finally
    LList.Free;
  end;

end;

{ TJSONSerializer4LeftCols }

class function TJSONSerializer4LeftCols.ReadJSON(P: PUTF8Char; var aValue;
  out aValid: Boolean): PUTF8Char;
begin

end;

class procedure TJSONSerializer4LeftCols.WriteJSON(const aWriter: TTextWriter;
  const aValue);
var
  V: R_LeftCols absolute aValue;
begin
  TpjhGenericWriteJSON.GenericWriteJSON<R_LeftCols>(aWriter,V);
end;

{ TJSONSerializer4Def }

class function TJSONSerializer4Def.ReadJSON(P: PUTF8Char; var aValue;
  out aValid: Boolean): PUTF8Char;
begin

end;

class procedure TJSONSerializer4Def.WriteJSON(const aWriter: TTextWriter;
  const aValue);
var
  V: R_Def absolute aValue;
begin
  TpjhGenericWriteJSON.GenericWriteJSON<R_Def>(aWriter,V);
end;

{ TJSONSerializer4Cols }

class function TJSONSerializer4Cols.ReadJSON(P: PUTF8Char; var aValue;
  out aValid: Boolean): PUTF8Char;
begin

end;

class procedure TJSONSerializer4Cols.WriteJSON(const aWriter: TTextWriter;
  const aValue);
var
  V: R_Cols absolute aValue;
begin
  TpjhGenericWriteJSON.GenericWriteJSON<R_Cols>(aWriter,V);
end;

{ TJSONSerializer4Data }

class function TJSONSerializer4Data.ReadJSON(P: PUTF8Char; var aValue;
  out aValid: Boolean): PUTF8Char;
begin

end;

class procedure TJSONSerializer4Data.WriteJSON(const aWriter: TTextWriter;
  const aValue);
var
  V: R_Data absolute aValue;
begin
  TpjhGenericWriteJSON.GenericWriteJSON<R_Data>(aWriter,V);
end;

initialization

  TTextWriter.RegisterCustomJSONSerializer(TypeInfo(R_Cfg),
    nil, TJSONSerializer4Cfg.WriteJSON);

  TTextWriter.RegisterCustomJSONSerializer(TypeInfo(R_Def),
    nil, TJSONSerializer4Def.WriteJSON);

  TTextWriter.RegisterCustomJSONSerializer(TypeInfo(R_LeftCols),
    nil, TJSONSerializer4LeftCols.WriteJSON);

  TTextWriter.RegisterCustomJSONSerializer(TypeInfo(R_Cols),
    nil, TJSONSerializer4Cols.WriteJSON);

  TTextWriter.RegisterCustomJSONSerializer(TypeInfo(R_Header),
    nil, TJSONSerializer4Header.WriteJSON);

  TTextWriter.RegisterCustomJSONSerializer(TypeInfo(R_Data),
    nil, TJSONSerializer4Data.WriteJSON);

//  TTextWriter.RegisterCustomJSONSerializerFromText(
//    TypeInfo(TTGGanttConfig), __TTGGanttConfig);
end.
>>>>>>> .r2045
