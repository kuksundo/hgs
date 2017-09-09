TreeGridLoaded ( // JSONP header, to be possible to load from xxx_Jsonp data source

{

Cfg: { TextVersion:"100001" },

Lang : {
      
// ---------------- All alert / confirm non HTML texts -------------------
      
Alert : {
         
// 3.1
	CanReloadStart : "This command ",
	CanReloadChanges : "updates all changes to server",
	CanCancelChanges : "cancels all changes",
	And : " and ",
	CanReloadSelect : "clears all selection",
	CanReloadEnd : "! Do you want to continue?",
// 3.2
	ErrTimeout : "Cannot download data, timeout expired",
	AskTimeout : "Cannot download data, server timeout !\nDo you want to repeat request ?",
	UploadTimeout : "Cannot upload data, timeout expired",
	AskUploadTimeout : "Cannot upload data, server timeout !\nDo you want to send data again ?",
// 3.5
	ErrHide : "You cannot hide all variable columns!",
	ErrHideExt : "Width of all fixed columns is too wide!",
// 4.2
	ErrPrintOpen : "The print window could not be opened\n\n Permit popup windows to let print the grid",
	ErrPrint : "The document was not successfully printed",
// 4.4.3
	ErrCheck : "Synchronizing with server failed!\nDo you want to temporary disable the checking for updates?",
// 4.7
	SearchHelp : "Enter string to search for like in Google\n\nindividual keywords separate by space\nphrases place into double quotes\nvariants separate by uppercase OR keyword\nexceptions precede by \"-\" (minus)\n\nOr enter expression to search by\n\nspecify columns caption to compare\nuse operators < <= > >= = <> ( ) + - * /\nuse AND OR keywords to join expressions\nuse special keywords STARTS ENDS CONTAINS\n   for comparing strings (NOT to negate)\nexample: customer starts martin and date <= 1/1/2006",
	NotFound : "Nothing found",
	SearchStart : "Nothing found\nDo you want to continue from beginning?",
	SearchError : "The search expression is invalid !",
// 5.1
	ErrAdd:"Cannot add new row here!",
// 5.3
	Invalid:"Invalid value",
// 6.0
   DelRow:"Are you sure to delete row '%d' ?",
   DelSelected:"Are you sure to delete %d selected rows ?",
   StyleErr : "Cannot load TreeGrid CSS style !",
   ExportDownload:"Download",
// 7.0
   FoundResults:"Found %d results",
   PrintPrepared:"Grid is ready to print",
// 7.1
   PrintReady:"Grid is ready to print\nChoose Print Preview option in menu to update page size\nOr choose Print option or press Ctrl+P to print directly",
   PrintCloseWindow:"\nAfter print is finished, you can close this page",
   PrintCloseTag:"\nAfter print is finished, you can click to the grid to return",
// 9.2
   PivotReload:"Do you want to re-create the pivot grid?"
	},
    
    
// ---------------- All message HTML texts -------------------
    
Text: {
      
// 2.0
	DelSelected : "Deleting selected rows",
	ExtentErr : "Too small grid size",
	Sort : "Sorting rows ...",
	SelectAll : "Changing selection of all rows",
	DoFilter : "Filtering rows ...",
// 2.3
	UpdateGrid : "Updating view ...",
	CollapseAll : "Collapsing all rows ...",
   ExpandAll : "Expanding all rows ...",
// 2.6
	Render : "Rendering ...",
	Page : "Page",
	NoPages : "Empty",
	UpdateCfg : "Updating settings ...",
	StartErr : "Fatal error ! <br/>TreeGrid cannot render",
// 3.0
	Calculate : "Calculating cells ...",
	UpdateValues : "Updating values ...",
	UpdateTree : "Updating tree ...",
// 3.1
	PageErr:"Cannot download this data part !",
// 3.2
	Layout : "Loading layout ...",
	Load : "Loading data ...",
// 3.5
	ColumnsCaption : "Select columns to display",
	ColUpdate : "Updating columns ...",
// 4.3
	Picture : "Picture"	,
	DefaultsDate : "Select date ...",
	DefaultsButton : "Select ...",
// 4.5
	GroupCustom:"To group by, drag column caption here ...",
	Group:"Grouping rows ...",
	DefaultsFilterOff:"(All)",
	Items:"Items %d - %d",
	Print:"<h2><center>Please wait while generating report for printing ...</center></h2>",
// 4.7
	SearchMethodList:"|Automatic|Search&#160;like&#160;Google|Search&#160;by&#160;expression",
	Contains:"contains,has",
	Starts:"starts,starts with,starts by,begins,begins with,begins by",
	Ends:"ends,ends by, ends with",
	And:"and",
	Or:"or",
	Not:"not",
	SearchSearch:"Search",
	SearchFilter:"Filter",
	SearchSelect:"Select",
	SearchMark:"Mark",
	SearchFind:"Find",
	SearchClear:"Clear",
	SearchHelp:"Help",
	Search:"Searching ...",
// 5.0.1
	Printed:"Please switch to window containing the report to print it",
// 5.6
   DoUndo:"Performing undo ...",
   DoRedo:"Performing redo ...",
// 5.9
   GanttUpdate:"Updating Gantt ...",
// 6.0
   GanttCreate:"Creating Gantt ...",
   LoadStyles:"Loading style ...",
   SetStyle:"Updating style ...",
   LoadPage:"Loading",
   RenderPage:"Rendering",
   ColWidth:"Changing width of column '%d'",
   ColMove:"Moving column '%d'",
   Password:"***",
   DefaultsNone:"Clear all",
   RadioFilterOff:"<i>off</i>",
   DragObjectMove:"moving row <b style='color:green;'>%d</b>",
   DragObjectCopy:"copying row <b style='color:green;'>%d</b>",
   DragObjectMoreMove:"moving <b style='color:blue;'>%d</b> rows",
   DragObjectMoreCopy:"copying <b style='color:blue;'>%d</b> rows",
 	ExportFinished:"<center><b>Report generated</b><br/><br/>Click button for download<br/></center><br/>",
 	RenderProgressText:"Finished %d pages from %d",
 	RenderProgressCancel:"Render on background",
   PrintProgressCaption:"Generating report",
 	PrintProgressText:"Finished %d rows from %d",
 	PrintProgressCancel:"Cancel report",
 	ExportProgressCaption:"Generating report",
 	ExportProgressText:"Finished %d rows from %d",
 	ExportProgressCancel:"Cancel report",
 	ExpandProgressCaption:"Expanding all rows",
 	ExpandProgressText:"Finished %d rows from %d",
 	ExpandProgressCancel:"Stop expanding",
   ExportCaption : "Select columns to export",
   PrintCaption : "Select columns to print",
   DefaultsAll:"Select all",
// 6.1
   DefaultsAlphabet:"%d ...",
// 6.7
   PDFEmbedFonts:"Embed fonts in PDF",
   PDFFitPage:"Fit to one page",
   PDFFitPages:"None,Width,Height,Single page",
   PrintRows:"Maximum rows per page",
   PrintExpanded:"Print all rows expanded",
   PrintFiltered:"Print all rows (unfiltered)",
   PrintOptions:"Print options",
   ExportOptions:"Export options",
   ExportFormat:"File format",
   ExportFormats:"XLS,CSV",
   ExportExpanded:"Export all rows expanded",
   ExportFiltered:"Export all rows (unfiltered)",
   ExportOutline:"Export tree in Excel outline",
   ExportIndent:"Indent tree in main column",
//7.0
   RemoveUnused:"Clearing unused pages",
   ErrorSave:"Saving changes on server failed!",
   DatesRepeat:"Repeat",
   DatesStart:"Start",
   DatesEndTime:"End",
   DatesValue:"Value",
   DatesRepeatEnum:"||Weekly|Daily|Hourly",
   DatesRepeatKeys:"||w|d|h",
 	RenderProgressCaptionRows:"Rendering row pages",
   RenderProgressCaptionCols:"Rendering column pages",
   RenderProgressCaptionChildren:"Rendering tree pages",
// 8.0
   CalendarNone:"<i style='color:gray'>None</i>",
   CalendarEmpty:"<i style='color:gray'>Default</i>",
   CalendarEdit:"<i style='color:blue'>Edit ...</i>",
// 9.0
   PrintPageOptions:"Page size<div style='font-size:10px;color:red;'>Set the same values also<br> in the browser print dialog!</div>",
   PDFPageOptions:"Page size",
   PrintPageRoot:"Start page always by root row",
   PrintVisible:"Print visible Gantt only",
   PrintSelected:"Print selected rows only",
   PrintWidth:"Page width (px)",
   PrintHeight:"Page height (px)",
   PrintPage:"Page size",
   PrintDPI:"DPI (PPI) ratio",
   PrintMarginWidth:"Page margin width (mm)",
   PrintMarginHeight:"Page margin height (mm)",
   PrintPageSize:"Page size",
   PrintPageSizes:"Auto,26000,26000,Letter (8.5x11in),215.9,279.4,Legal (8.5x14in),215.9,355.6,Ledger (11x17in),279.4,431.8,A0 - (841x1189),841,1189,A1 - (594x841),594,841,A2 - (420x594),420,594,A3 - (297x420),297,420,A4 - (210x297),210,297,A5 - (148x210),148,210,A6 - (105x148),105,148,A7 - (74x105),74,105,A8 - (52x74),52,74,A9 - (37x52),37,52,B0 - (1000x1414),1000,1414,B1 - (707x1000),707,1000,B2 - (500x707),500,707,B3 - (353x500),353,500,B4 - (250x353),250,353,B5 - (176x250),176,250",
   PrintPageOrientation:"Page orientation",
   PrintPageOrientations:"Portrait,Landscape",
   PrintResults:"Print size is %d x %d pages",
   PDFText:"",
   PDFTexts:"Image only,Selectable text,Embedded fonts",
// 9.2
   ExpandCols:"Expanding columns",
   CollapseCols:"Collapsing columns",
// 9.3
   PagingUpdate:"Creating pages ...",
   CopySlow:"The copy action took too long time (%d ms), please press the Ctrl+C again to finish the action",
   CopyOk:"The copy action finished successfuly",
// 10.0
   LevelsTip:"Expand rows up to %d level"
 	},



// -------------------------- Gantt texts ----------------------
Gantt: {
// 6.0
   ErrGanttDep:"Cannot connect dependency here",
   ErrGanttPercentEdit:"Wrong input, the value must be in range 0 - 100",
   DelAllGanttDep:"Disconnect all dependency lines",
   DelGanttMilestone:"Delete milestone",
   EditGanttPercent:"Enter completed status",
   DelGanttFlow:"Delete real flow",
   DelGanttFlowPart:"Delete the real flow bar",
   DelGanttFlags:"Delete all flags",
   DelGanttFlag:"Delete the flag",
   EditGanttFlag:"Enter the flag text",
   DelGanttAll:"Clear the gantt cell",
   NewGanttFlag:"Add new flag to selected point",
   EditGanttResource:"Change resources",
   AssignGanttResource:"Assign resources",
   CorrectAllDependencies:"Correct all dependencies in chart",
   CorrectRelatedDependencies:"Correct related dependencies",
   CorrectDep:"Moving %d bars",
   GanttFlagEdit:"Enter text for the flag",
   GanttPercentEdit:"Enter new completed status in percent",
   GanttResourceEdit:"Enter the resource text",
   GanttDepLagEdit:"Enter the lag for the dependency",
// 6.1
   GanttResizeDelete:"Are you sure to delete the item?",
   DelGanttRunPart:"Delete the box",
   EditGanttRun:"Change the box text",
   EditGanttRunTip:"Change the box information",
   ChooseGanttRunType:"Select the box type",
   GanttRunEdit:"Enter the box text",
   GanttRunEditTip:"Enter the box information",
   ChooseGanttFlagIcon:"Select the flag icon",
// 6.3
   GanttCorrectDependencies:"There are also <b>%d</b> dependent tasks that should be updated. <br>Do you want to move them?",
   GanttCorrectDependency:"There is also one dependent task that should be updated. Do you want to move it?",
   GanttCorrectTask:"The task violates its constraints, do you want to move it?",
   GanttDeleteDependencies:"There are %d dependencies, do you want to delete them?",
   GanttCircularDependencies:"It will cause circular dependency relation. Do you want to create it anyway?",
   GanttCircularDependenciesErr:"It is not possible to create circular dependency relation",
   ErrComplete:"The complete value must be in range 0 - 100!",
   ErrDuration:"The duration value is incorrect!",
   ErrEnd:"The end date cannot be less than start date!",
   ErrDependency:"The dependency value is incorrect!",
   ErrCorrect:"It is not possible to correct the dependencies!",
   ErrCorrectSome:"Not all dependencies were corrected due constraints!",
   IncorrectDependencies:"<span style='color:red;'><span style='font-weight:bold;'>%d</span> incorrect dependencies</span>",
   IncorrectDependency:"<span style='color:red;'><span style='font-weight:bold;'>1</span> incorrect dependency</span>",
   CorrectDependencies:"All dependencies are correct",
   DisabledDependencies:"<span style='color:gray'>Dependency checking disabled</span>",
   GanttCheckExclude:"The object starts on holiday, do you want to move it to the right?",
   GanttMinStart:"The task must start after <span style='font-weight:bold;'>%d</span>",
   GanttMaxStart:"The task must start before <span style='font-weight:bold;'>%d</span>",
   GanttMinEnd:"The task must finish after <span style='font-weight:bold;'>%d</span>",
   GanttMaxEnd:"The task must finish before <span style='font-weight:bold;'>%d</span>",
   DelGanttConstraint:"Delete %d constraint",
   DelGanttConstraints:"Delete all constraints",
   ChangeGanttConstraint:"Set the constraint as %d",
   NewGanttConstraint:"Add %d constraint here",
   MinStart:"early start",
   MaxStart:"late start",
   MinEnd:"early end",
   MaxEnd:"late end",
   ExactStart:"mandatory start",
   ExactEnd:"mandatory end",
   SplitGanttConstraint:"Split the %d constraint",
   GanttDepLagChangeEnd:"Change lag of line from <b style='color:blue;'> %d</b>",
// 6.4
   GanttExactStart:"The task must start on <span style='font-weight:bold;'>%d</span>",
   GanttExactEnd:"The task must finish on <span style='font-weight:bold;'>%d</span>",
   ExtraPrice:"Extra price",
   ExtraPrices:"Extra resource units",
   DelGanttPoint:"Delete the point",
   DelGanttPoints:"Delete all points",
   NewGanttPoint:"Add new point to selected point",
// 6.5
   ErrStart:"The start date cannot be higher than end date!",
// 6.6
   GanttCheckExcludeBack:"The object starts on holiday, do you want to move it to the left?",
   DelGanttBase:"Delete project start",
   SetGanttBase:"Set project start here",
   DelGanttFinish:"Delete project finish",
   SetGanttFinish:"Set project finish here",
   NewGanttMilestone:"Add new milestone here",
// 7.0
   ErrDateLow:"The date cannot be before <span style='font-weight:bold;color:red;'>%d</span> due <span style='font-weight:bold;'>%d</span> constraint",
   ErrDateHigh:"The date cannot be after <span style='font-weight:bold;color:red;'>%d</span> due <span style='font-weight:bold;'>%d</span> constraint",
   ErrDateHighEqual:"The date cannot be after or exactly <span style='font-weight:bold;color:red;'>%d</span> due <span style='font-weight:bold;'>%d</span> constraint",
   ErrValueLow:"The value cannot be less than <span style='font-weight:bold;color:red;'>%d</span> due <span style='font-weight:bold;'>%d</span> constraint",
   ErrValueHigh:"The value cannot be higher than <span style='font-weight:bold;color:red;'>%d</span> due <span style='font-weight:bold;'>%d</span> constraint",
   ErrValueHighEqual:"The value cannot be equal or higher than <span style='font-weight:bold;color:red;'>%d</span> due <span style='font-weight:bold;'>%d</span> constraint",
   Baseline:"project start",
   Finishline:"project finish",
   ChartMinStart:"project minimal date",
   ChartMaxEnd:"project maximal date",
   NewGanttEndMilestone:"Add new ending milestone here",
   ErrCorrectDep:"Not all dependencies were corrected due errors!",
   DelGanttRunGroup:"Delete row group (%d boxes)",
   DelGanttRunGroupAll:"Delete group (%d boxes)",
   ChooseGanttRunGroupType:"Select row group type (%d boxes)",
   ChooseGanttRunGroupAllType:"Select group type (%d boxes)",
   ValueChanged:"Value changed due constraints",
   ErrChangeValue:"Entered value is incorrect",
   CompleteChanged:"Value changed to be in range 0 - 100",
   DurationChanged:"Value changed to be not negative",
   EditGanttRunText:"Enter the task information",
   SetGanttMilestoneIncomplete:"Set the milestone incomplete",
   SetGanttMilestoneComplete:"Set the milestone complete",
   ErrMoveChildren:"Cannot move the task due children constraints",
   MoveChildrenChanged:"Value changed due children constraints",
   NewGanttRunStop:"Add new stop here",
   GanttCorrectExclude:"The object starts or ends on holiday, do you want to correct it?",
// 9.2
   SplitGanttFlow:"Split the real flow bar",
// 9.3
   PagingUpdate:"Creating pages ...",
// 10.0
   ZoomMain:"Zoom to the bar",
   ZoomRun:"Zoom to the box",
   ZoomAll:"Zoom to all objects",
   SplitGanttRun:"Split the box",
   SplitGanttMain:"Split the bar",
   DelGanttMainPart:"Delete the bar",
   DelGanttMain:"Delete the task",
   DelGanttMainAll:"Delete all tasks",
   DelGanttMainBar:"Delete task",
   DelGanttRun:"Delete all boxes",
   SelectGanttRunPart:"Select the box",
   UnselectGanttRunPart:"Unselect the box",
   SelectGanttRun:"Select all boxes",
   UnselectGanttRun:"Unselect all boxes",
   DelGanttRunSelected:"Delete selected boxes (%d boxes)",
   ChooseGanttRunSelectedType:"Select type in selected %d boxes",
   Plan0:"0",
   GanttTextEdit:"Enter the task information",
   EditGanttText:"Enter the task information",
   GanttDepLagChange:"Change the dependency lag",
   DelGanttDep:"Delete the dependency",
   DisableGanttMain:"Disable the task",
   EnableGanttMain:"Enable the task",
   LockGanttMain:"Lock the task",
   UnlockGanttMain:"Unlock the task",
   DisableGanttRun:"Disable the task",
   EnableGanttRun:"Enable the task",
   LockGanttRun:"Lock the task",
   UnlockGanttRun:"Unlock the task",
   DisableGanttRunPart:"Disable the box",
   EnableGanttRunPart:"Enable the box",
   LockGanttRunPart:"Lock the box",
   UnlockGanttRunPart:"Unlock the box",
   SetGanttPercent:"Set completed status here",
   ErrLag:"The lag value is incorrect!",
   EmptyManual:"None",
   ErrCorrectNone:"Not all dependencies can be corrected due constraints!",
   ZoomHeader:"Zoom to <b>%d</b> %d - %d",
   ZoomUndo:"Zoom back to <b>%d</b>",
   ZoomIn:"Zoom in to <b>%d</b>",
   ZoomOut:"Zoom out to <b>%d</b>",
   ZoomFit:"Zoom to fit to actual space"
   },

// ------------------- Gantt unit names --------------------
GanttUnits: {

// 10.0
   ms:"millisecond", ms10:"10 milliseconds", ms100:"100 milliseconds",
   s:"second", s2:"2 seconds", s5:"5 seconds", s10:"10 seconds", s15:"15 seconds", s30:"30 seconds",
   m:"minute", m2:"2 minutes", m5:"5 minutes", m10:"10 minutes", m15:"15 minutes", m30:"30 minutes",
   h:"hour", h2:"2 hours", h3:"3 hours", h6:"6 hours", h8:"8 hours", h12:"12 hours",
   d:"day", w:"week", w1:"week",
   M:"month", M2:"2 months", M3:"year quarter", M4:"4 months", M6:"year half",
   y:"year", y2:"2 year", y3:"3 years", y4:"4 years", y5:"5 years", y10:"10 years", y20:"20 years", y50:"50 years"
   },


// ------------------- Popup dialog buttons, non HTML --------------------
MenuButtons : {
      
// 6.0
   Ok:"OK",
   Clear:"Clear",
   Today:"Today",
   All:"All on",
   Cancel:"Cancel",
// 6.7
   Yesterday:"Yesterday",
// 7.0
   EmptyTip:"Empty date",
// 10.0
   Yes:"Yes",
   No:"No",
   Always:"Always",
   Never:"Never"
   },



// ----------------- Popup copy / add menu item names, HTML ---------------

MenuCopy : {
      
// 6.0
  	CopyRow : "Duplicate the row",
   CopyRowBelow : "Duplicate the row",
	CopyTree : "Duplicate the row tree",
	CopyTreeBelow : "Duplicate the row tree",
	CopyEmpty : "Duplicate the row tree structure",
	CopyEmptyBelow : "Duplicate the row tree structure",
	CopySelected : "Copy selected rows above",
	CopySelectedBelow : "Copy selected rows below",
	CopySelectedTree : "Copy selected row trees above",
	CopySelectedTreeBelow : "Copy selected row trees below",
	CopySelectedEmpty : "Copy selected row tree structures above",
	CopySelectedEmptyBelow : "Copy selected row tree structures below",
	CopySelectedChild : "Copy selected rows as the first children",
	CopySelectedTreeChild :"Copy selected row trees as the first children",
	CopySelectedEmptyChild : "Copy selected row tree structures as the first children",
	CopySelectedChildEnd : "Copy selected rows as the last children",
	CopySelectedTreeChildEnd : "Copy selected row trees as the last children",
	CopySelectedEmptyChildEnd : "Copy selected row tree structures as the last children",
	CopySelectedEnd : "Copy selected rows to the end",
	CopySelectedEndPage : "Copy selected rows to the end of page",
	CopySelectedEndGrid : "Copy selected rows to the end of grid",
	CopySelectedTreeEnd : "Copy selected row trees to the end",
 	CopySelectedTreeEndPage : "Copy selected row trees to the end of page",
	CopySelectedTreeEndGrid : "Copy selected row trees to the end of grid",
	CopySelectedEmptyEnd : "Copy selected row tree structures to the end",
	CopySelectedEmptyEndPage : "Copy selected row tree structures to the end of page",
	CopySelectedEmptyEndGrid : "Copy selected row tree structures to the end of grid",

   AddRow : "Add new empty row above",
	AddChild : "Add new empty row as the first child",
	AddChildEnd : "Add new empty row as the last child",
   AddRowBelow : "Add new empty row below",
   AddRowEnd : "Add new empty row to the end",
   AddRowEndPage : "Add new empty row to the end of page",
   AddRowEndGrid : "Add new empty row to the end of grid"
   },
      

// -------------------- Configuration menu item names, HTML ---------------
MenuCfg: {
         
// 2.3
	Caption : "TreeGrid settings",
	ShowDeleted : "Show deleted rows (in red)",
	AutoSort : "Auto sort rows after change",
	AutoUpdate : "Auto update changes to server",
	MouseHover : "Mouse hover",
	Hover1 : "None",
	Hover2 : "Cell only",
	Hover3 : "Row",
   Hover4 : "Row and column",
	ShowDrag : "Show dragged object",
	ShowPanel : "Show row's left panel",
// 2.6
	ShowPager : "Show pager",
	ShowAllPages : "Show all pages",
// 4.4
	CheckUpdates : "Check for updates on server every",
	CheckUpdates0 : "Off",
	CheckUpdates2 : "2 seconds",
	CheckUpdates5 : "5 seconds",
	CheckUpdates10 : "10 seconds",
	CheckUpdates30 : "30 seconds",
	CheckUpdates60 : "1 minute",
	CheckUpdates120 : "2 minutes",
	CheckUpdates300 : "5 minutes",
	CheckUpdates600 : "10 minutes",
// 5.0.20
	SortClick : "Sorting click",
	SortClick1 : "Simple, no icons",
	SortClick2 : "Simple",
	SortClick3 : "Directional, icons only",
	SortClick4 : "Directional",
// 6.0
	Ok : "OK",
	Cancel : "Cancel",
	All : "Show all",
	Clear : "Hide all",
// 6.3
   GanttCorrectDependencies:"Schedule tasks",
   Correct1:"manually",
   Correct2:"auto",
   Correct3:"ask",
   GanttCheckDependencies:"Circular dependencies",
   Check1:"permit",
   Check2:"restrict",
   Check3:"ask",
   GanttStrict:"Correct dependencies strictly",
   GanttHideExclude:"Show holidays in chart",
   GanttCheckExclude:"Starting tasks on holidays",
   GanttCorrectDependenciesFixed:"Auto schedule also the changed task",
// 6.4
   GanttBaseProof:"Can move objects before project start",
   GanttBasePreferred:"Project start is preferred to constraints",
// 6.6
   GanttMinSlack:"Minimal slack for critical task",
   GanttErrSlack:"Minimal slack bound for error task",
   GanttSeparateSlack:"Calculate critical path individually",
// 6.7
   Check4:"alert",
// 7.0
   GanttFixComplete:"Schedule also already started tasks",
   GanttFinishProof:"Can move objects after project finish",
   GanttFinishPreferred:"Project finish is preferred to constraints",
   GanttCheck:"Auto correct values outside constraints",
   Scrollbars:"Scrollbars type",
   Scrollbars1:"None",
   Scrollbars2:"Thin",
   Scrollbars3:"Standard",
   Scrollbars4:"Wide",
   Scroll:"Scroll by",
   Scroll1:"Only scrollbars",
   Scroll2:"One finger (no move)",
   Scroll3:"Two fingers (no zoom)",
   Scroll4:"Three fingers (no drag)",
// 8.0
   Reset:"Defaults",
// 10.0
   GanttCheck:"Incorrect manual inputs",
   GanttCheck1:"permit",
   GanttCheck2:"restrict",
   GanttCheck3:"restrict + alert",
   GanttCheck4:"correct",
   GanttCheck5:"correct + alert",
   ReversedTree:"Reversed tree (like in MS Excel)",
   GanttDirection:"Schedule tasks from",
   GanttDirection1:"project start",
   GanttDirection2:"project finish",
   GanttStrict:"Schedule tasks method",
   GanttStrict1:"minimal move",
   GanttStrict2:"strict move",
   GanttStrict3:"",
   GanttStrict4:"min. strict move"
   },


// ------------- Filter menu operator names, HTML ----------------
MenuFilter: {

	F0 : "Off",
	F1 : "Equal",
	F2 : "Not equal",
	F3 : "Less than",
	F4 : "Less than or equal",
	F5 : "Greater than",
	F6 : "Greater than or equal",
	F7 : "Begins with",
	F8 : "Does not begin with",
	F9 : "Ends with",
	F10 : "Does not end with",
	F11 : "Contains",
	F12 : "Does not contain"
   },
      
// -------------- Language dependent formatting dates and numbers -----------------
Format: {

	LongDayNames : "Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday",
	ShortDayNames : "Sun,Mon,Tue,Wed,Thu,Fri,Sat",
	Day2CharNames : "Su,Mo,Tu,We,Th,Fr,Sa",
	Day1CharNames : "S,M,T,W,T,F,S",
	LongMonthNames : "January,February,March,April,May,June,July,August,September,October,November,December",
	LongMonthNames2 : "January,February,March,April,May,June,July,August,September,October,November,December",
	ShortMonthNames : "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec",
   DayNumbers : "1st,2nd,3rd,4th,5th,6th,7th,8th,9th,10th,11th,12th,13th,14th,15th,16th,17th,18th,19th,20th,21st,22nd,23rd,24th,25th,26th,27th,28th,29th,30th,31st",
   Quarters : "I,II,III,IV",
   Halves : "I,II",
	DateSeparator : "/",
   InputDateSeparators : "/.-",
	TimeSeparator : ":",
	InputTimeSeparators : ":",
	AMDesignator : "AM",
	PMDesignator : "PM",
	FirstWeekDay : "0",
	FirstWeekYearDay:"3",
	NaD : "NaN",

   GMT : "1",

	d : "M/d/yyyy",
	D : "d. MMMM yyyy",
	t : "H:mm",
	T : "H:mm:ss",
	f : "d. MMMM yyyy H:mm",
	F : "d. MMMM yyyy H:mm:ss",
	g : "M/d/yyyy H:mm",
	G : "M/d/yyyy H:mm:ss",
	m : "d. MMMM",
	M : "d. MMMM",
	s : "yyyy-MM-ddTHH:mm:ss",
	u : "yyyy-MM-dd HH:mm:ssZ",
   
   U : "d. MMMM yyyy HH:mm:ss",
   r : "ddd MMM d HH:mm:ss UTCzzzzz yyyy",
   R : "ddd MMM d HH:mm:ss UTCzzzzz yyyy",
   y : "MMMMMMM yyyy",
   Y : "MMMMMMM yyyy",
   a : "dddd, dddddd MMMM yyyy",

   ValueSeparator:";", ValueSeparatorHtml:"; ",
   RangeSeparator:"~", RangeSeparatorHtml:" ~ ",
   RepeatSeparator:"#",
   CountSeparator:"*",
   AddSeparator:"+",
      
	DecimalSeparator : ".",
   InputDecimalSeparators : ".,",
	GroupSeparator : ",",
   GroupCount1 : "3",
   GroupCount : "3",
   InputGroupSeparators : "",
	Percent : "%",
	NaN : "NaN",

	ng : "0.######",
	nf : "0.00",
	nc : "$###########0.00",
	np : "0.00%",
	nr : "0.0000",
	ne : "0.000000 E+000",
	
   Cont : "...",
   ContLeft : "... ",
   ContRight : " ...",

   PivotSeparators : "|,|:|<b style='color:blue;'>,</b> | <b style='color:red;'>+</b> | <b style='color:red;'>=</b> "
   
   }
}, // Lang }
   
   
   
// ------------------ Toolbar button tooltips, HTML ----------------
   
Toolbar: {
      
   SaveTip:"Submit changes to server",
   ReloadTip:"Reload grid, cancel changes",
   RepaintTip:"Render all pages",
   RepaintTip1:"Render pages on demand",
   PrintTip:"Print grid",
   ExportTip:"Export grid data to your spreadsheet program",
   AddTip:"Add new row or move or copy selected rows",
   AddChildTip:"Add new child row or move or copy selected rows to actual cursor position",
   SortTip:"Enable sorting and re-sort rows now",
   SortTip1:"Disable sorting to change sort criteria faster",
   CalcTip:"Enable calculations and re-calculate grid now",
   CalcTip1:"Disable calculations to edit cell values faster",
   ExpandAllTip:"Expand all rows",
   CollapseAllTip:"Collapse all rows",
   ColumnsTip:"Displays menu to choose visible columns",
   CfgTip:"TreeGrid user settings",
   HelpTip:"Show help for TreeGrid control",
   DebugTip:"Shows debug window",
   ResizeTip:"Resize grid",

   UndoTip:"Undo last action",
   RedoTip:"Redo last action",
   CorrectTipFormula:"ganttdependencyerrors(null,1)",
   ZoomInTip:"Zoom in",
   ZoomOutTip:"Zoom out",
   ZoomFitTip:"Zoom to fit into page",

   ExportPDFTip:"Print grid to Adobe PDF",

   JoinTip:"Span selected cells",
   SplitTip:"Split spanned selected or focused cells",
   OutdentTip:"Outdent, move focused row below its parent",
   IndentTip:"Indent, move focused row as child of the row above"
   },

// ----------------- Row displayed when no variable rows are visible -------------
// To hide it define Html:""
Solid: [ { id:"NoData", Html:"No data found"} ],
   
// -------------- Right side pager caption -----------
Pager: { Caption:"Pager" },
   
// -------------- Left side panel button tooltips, HTML -----------------
   
Panel: {
   
   PanelSelectTip:"Select row",
   PanelCopyTip:"Copy row",
   PanelMoveTip:"Drag row",
   PanelDeleteTip:"Delete row"
   },
   
Header: {
   PanelHeaderSelectTip:"Select or unselect all rows",
   PanelHeaderDeleteTip:"Delete all selected rows",
   PanelHeaderCopyTip:"Add new row or move or copy selected rows"
   }
   
} 

) // End of JSONP header