
// It is NOT recommended to use this example as framework for your application. This example is too complex, use some tutorial example instead

TreeGridLoaded ( // JSONP header, to be possible to load from xxx_Jsonp data source

{
Cfg: {
   id:"Gantt", SuppressCfg:"1", // Base settings, suppresses saving configuration to cookies
   NumberId:"1", IdChars:"0123456789", // Controls generation of new row ids
   NoFormatEscape:"1", // You can use HTML code in formatting, set here because ValueSeparator and RangeSeparator contain HTML code
   Sort:"id", // Default sort is by ID column
   Group:"TASK", // The grid is grouped by Task column by default
   GroupIdValue:"4", GroupIdPrefix:"", // Specifies automatic ids for Group rows, to identify them on export to PDF
   GroupRestoreSort:"1", // Restores original sorting after ungroup
   Undo:"1", // Permits undo / redo changes by Ctrl+Z / Ctrl + Y and shows Undo / Redo toolbar buttons
   ChildParts:"0", // Switches off child parts, here it is not needed
   DefaultDate:"5/1/2008", // Default date in calendar for empty date
   MenuColumnsCount:"2", // Displays column names in menu in two columns
   MidWidth:"200", MinRightWidth:"200", MinLeftWidth:"200", // Sizes and scrolls for column sections
   ResizingMain:"3", // Users can resize grid by right bottom edge in both directions
   ConstWidth:"900", // Minimal grid width if hidden too many columns
   CalendarsRepeatType:"Enum", CalendarsRepeatEnum:"||Weekly|Daily", CalendarsRepeatEnumKeys:"||w|d", // Settings for Calendar list dialog, the Repeat column
   CalendarsValueType:"Enum", CalendarsValueEnum:"|Not work|Exception|Lunch|Weekend|Holiday|Reserved1|Reserved2", CalendarsValueEnumKeys:"||0|1|2|3|4|5", CalendarsValueCaption:"Type", // Settings for Calendar list dialog, the Value column
   PrintPagePrefix:"<center style='width:%7px'>Page %1H / %4 , %2V / %5</center>", PrintPagePostfix:"<center style='width:%7px'>Printed page %3 / %6</center>", // Sample page header and footer for printing
   PrintPaddingHeight:"60", PrintPaddingWidth:"36", // Reserved space for PrintPagePrefix / Postfix and for default body margin and padding when printing
   PrintPaddingHeightFirst:"90", // Reserved space for sample header printed only to the first page
   TouchClearFocused:"2000", // Clears the focused cell or Gantt object on tablet after 2 seconds after focus
   FastPanel:"0", // Switches off fast panel because it is good for rows up to 100 pixels high and Network diagram produces higher rows
   MaxHeight:"1", MaxHeightReserved:"10" // Maximizes main tag height to utilize the whole page vertically. Set the MaxHeight='0' if you face 'Too small grid size' error message!
   },

Actions: {
   OnRightDragGantt:"DragGanttDependency", // Dependencies can be created by dragging with right mouse button
   OnShiftDragGantt:"SelectGanttRunRect", // The run boxes can be selected by dragging with Shift key
   OnClick1GanttHeader:"GanttMenu" // On tablet shows the zoom menu on click to header instead of direct zooming
   },
Def: [

   // The standard rows cannot have children
   {  Name:"R", CDef:"" }, 

   // Group row shows summary of the main bars
   {  Name:"Sum",         
      Def:"Group", Group:"1", // By default can be used for grouping, changed by JavaScript code when clicking to "Network diagram" tab
      Calculated:"1", CalcOrder:"SECTIONHtmlPostfix,START,END,DURATION,COMPLETE,PARTS1,START1,END1,DURATION1,GANTT,PRICE,PROGRESS", // Grouping row is calculated to show summary for its children
      Expanded:"1", // Grouping row shows its children by default
      EditCols:"Main", // When user changes value in main column (TASK), the value is copied also to the children
      STARTFormula:"ganttstart()", // Gets the first start date from its children, including milestones
      ENDFormula:"ganttend()", // Gets the last end date from its children, including milestones
      DURATIONFormula:"END&&START?Grid.DiffGanttDate(END,START):''", // Gets the last end date from its children, including milestones
      COMPLETEFormula:"ganttpercent()", COMPLETEFormat:"0.0\\%", // Calculates average task completion from its children
      PARTS1Formula:"sumparts()", // Merges all date ranges for the second main bar from its children
      START1Formula:"ganttstart()", END1Formula:"ganttend()", DURATIONFormula:"END&&START?Grid.DiffGanttDate(END,START):''", // Calculates other columns for second main bar
      PRICEFormula:"sum()", // Sums prices
      PROGRESSFormula:"ganttprogressline(Grid.Rows.Project.Progress,0,0)", // Calculates progress line as just stright line to be continuous
      GANTTGanttClass:"Group", GANTTGanttIcons:"1", // Group color and icons for the first main bar
      GANTTGanttClass1:"Black", // Color for the second main bar
      GANTTGanttSummary:"0", // The first main bar plan works as Gantt Summary for the child first main bars, when moved, it moves its child tasks too
      GANTTGanttSummary1:"1", // The second main bar plan works as Gantt Summary for the child second main bars, when moved, it moves its child tasks too
      GANTTGanttEdit:"MainMove,Main1Move", // Only the main bars can be edited to move all the summary children
      STARTCanEdit:"1", START1CanEdit:"1", // Lets users to edit start date to move the Gantt Summary and its children
      GroupMain:"TASK", // Tree will be shown in Task column
      COMPLETEMaxChars:"100", // Ensures setting returned value when grouped by Complete column
      CALENDARVisible:"-1", // Hides the calendar cell value and button
      CDef:"R", // Grouping rows can contain standard rows as children
      ParentCDef:"Sum", // When grouped by any column, new rows added to root will be these groups
      ParentAcceptDef:"", // It is not possible to move rows to the root between groups
      CanFilter:"2", // Hides the group when all its tasks are hidden by filter
      idVisible:"0", // Hides the automatically generated id
      CanSelect:"0", // Hides the panel Select icon
      AggChildren:"1", // Aggregates children of task instead of itself, used when calculating the summary fixed row
      SECTIONHtmlPostfixFormula:"' <span style=\";color:green;\";>('+count(4)+')</span>'" // Shows the count of children as green suffix
      },

   // Extending Sum default for grouping by TASK
   {  Name:"SumTask", GroupCols:"|TASK|COMPLETE,TASK", Def:"Sum", GroupMain:"SECTION", ParentCDef:"SumTask" }, // When grouping by Task, shows tree in Section column

   // Network diagram row shows summary of the first main bar plan as run bars with dependencies
   {  Name:"Diagram",
      Def:"Group", Group:"0", // By default cannot be used for grouping, changed by JavaScript code when clicking to "Network diagram",tab
      Calculated:"1", CalcOrder:"PARTS1,START,END,DURATION,DESCENDANTS,ANCESTORS,CLASS,PRICE,RESOURCES,PROGRESS", // All the formulas will be calculated in this order. Not listed formulas will not be calculated!
      Expanded:"0", // Hides its children by default, you can set also CanExpand='0' to restrict showing them
      Height:"72", // Default row height without boxes
      GANTTGanttRun:"PARTS1", // Assigns PARTS1 column as main GanttRun definition column-->
      PARTS1Type:"Text", PARTS1Format:"", PARTS1Formula:"ganttrunsum()", // Main definition, calculates the GanttRun from the child main bars
      GANTTGanttRunSummary:"0", // Links the run bars with the source main bars -> changes in run boxes will be mirrored to source main bars
      DESCENDANTSFormula:"ganttrundescendants()", ANCESTORSFormula:"ganttrunancestors()", // Calculates dependencies from child main bars
      DESCENDANTSFormat:"||||\;|g|&lt;br>", ANCESTORSFormat:"||||\;|g|&lt;br>", // Changes descendants and ancestors cell format just for better display
      GANTTGanttRunSummaryDependencies:"0", // Links the run dependencies with the source dependencies between main bars -> changes in run dependencies will be mirrored to source dependencies
      GANTTGanttRunStart:"START", GANTTGanttRunEnd:"END", GANTTGanttRunDuration:"DURATION", // Assigns given columns to Run summary attributes
      STARTFormula:"ganttrunstart()", ENDFormula:"ganttrunend()", DURATIONFormula:"ganttrunduration()", // Calculates the Run summary attributes
      PROGRESSFormula:"ganttprogressline(Grid.Rows.Project.Progress,0,0)", // Calculates progress line as just stright line to be continuous
      GANTTGanttRunErrorsShift:"73", // The overlaid boxes will be shifted by 70 pixels down
      GANTTGanttRunErrors:"0", // The overlaid boxes will not be marked red as error boxes
      GANTTGanttRunAdjust:"Error", // The boxes can be moved freely
      GANTTGanttRunHeight:"60", // Height of all the run boxes in pixels
      GANTTGanttSummaryCols:"START,END,DURATION,,SECTION,CLASS,,,,,,,,COMPLETE,RESOURCES,,", // Links these columns with Run box attributes in GanttRun
      GANTTGanttStart:"", GANTTGanttEnd:"", GANTTGanttDuration:"", GANTTGanttHtmlRight:"", // Clears the first main bar assignment for this row
      GANTTGanttStart1:"", GANTTGanttEnd1:"", GANTTGanttDuration1:"", GANTTGanttParts1:"", // Clears the second main bar assignment for this row
      GANTTGanttEdit:"Run,DependencyNew", // Only the run bars and dependencies can be edited here. Dependencies are not corrected for the run, because they are corrected for the source main bars
      GANTTGanttRunClass:"Yellow", // Predefined color for all the run boxes
      CLASSFormula:"Get(Row,'GANTTGanttRunClass') ? Get(Row,'GANTTGanttRunClass') : ''", CLASSCanEdit:"1", CLASSOnChange:"Row.GANTTGanttRunClass=Value;", // Color column for all the boxes in one row
      RESOURCESFormula:"Grid.GetGanttRunResourcesString(Row)", // Shows list of all used resources
      COMPLETEVisible:"0", COMPLETECanEdit:"0", SLACKVisible:"0", PARTS1Visible:"0", CALENDARVisible:"-1", CLASS1Visible:"0", // Hides the unused cell values
      GroupMain:"TASK", // Tree will be shown in Task column
      CDef:"R", // Grouping rows can contain standard rows as children
      ParentCDef:"Diagram", // When grouped by any column, new rows added to root will be these groups
      ParentAcceptDef:"", // It is not possible to move rows to the root between groups
      CanFilter:"2", // Hides the group when all its tasks are hidden by filter
      idType:"Text", // The automatically generated id is string
      CanSelect:"0" // Hides the panel Select icon
      },

   // Extending Diagram default for grouping by TASK
   {  Name:"DiagramTask", GroupCols:"|TASK|COMPLETE,TASK", Def:"Diagram", GroupMain:"SECTION", ParentCDef:"DiagramTask" }, // When grouping by Task, shows tree in Section column


   // Default row for resources
   // Redefines the columns for resource rows to have completely different meaning than in the Gantt chart
   {  Name:'Resource', CanEdit:'0', CanDelete:"0",  CanSelect:"0",  Calculated:"1",  // The resource row cannot be deleted and selected and the cells are not editable by default

      GANTTGanttAvailability:"id#3#R,id#1#R,id#8#R", GANTTGanttAvailabilityFormat:"0.#",  // Defines the Resource chart 
      GANTTGanttStart:"", GANTTGanttEnd:"", GANTTGanttEdit:"", GANTTGanttComplete:"", GANTTGanttAncestors:"", GANTTGanttDescendants:"",  // Clears the standard Gantt assignments done in GANTT column 

      idType:"Text", idSpan:"3", Spanned:"1",  // Shows the Resource name in id column and spans it through TASK and SECTION 

      STARTType:"Float", STARTFormat:"0.00", STARTEditMask:"^\d*[\d\.\ }?\d*$", STARTEditFormat:"",  // START shows resource Unit price 
      STARTCanEdit:"1",  // The Unit price is editable cell, though it is calculated - the source value is set in OnChange event 
      STARTFormula:"Grid.Resources[Row.id]?Grid.Resources[Row.id].Price:0",  // Reads the unit price from resource Price 
      STARTOnChange:"Grid.Resources[Row.id].Price = Value; Grid.Calculate(1)",  // Saves the change to resource Price 

      ENDType:"Text", ENDFormat:"",  // END shows resource Availability 
      ENDFormula:"Grid.Resources[Row.id]?Grid.Resources[Row.id].Availability:0",  // Reads the availability from resource Availability 
      ENDOnChange:"Grid.Resources[Row.id].Availability = Value;",  // Saves the change to resource Availability 
      ENDButton:"Dates",  // The Availability can be changed by Dates dialog shown on the Dates button click 
      ENDDatesRepeatType:"Enum", ENDDatesRepeatEnum:"||Weekly|Daily", ENDDatesRepeatEnumKeys:"||w|d",  // Sets the Repeat column of Dates dialog to provide Weekly and Daily repeats 
      ENDDatesValueType:"Float", ENDDatesValueFormat:"0.00", ENDDatesValueCaption:"Count",  // Sets the Value column of Dates dialog to number as count of resource units 

      DURATIONType:"Float", DURATIONFormat:"0.##", DURATIONFormula:"ganttresourcepeak(Row.id)",  // DURATION shows resource Peak, it is calculated and read only 

      COMPLETEType:"Enum", COMPLETEEnum:"|wrk|mat", COMPLETEEnumKeys:"|1|2",  // COMPLETE shows resource Type as enum with two items work and material 
      COMPLETECanEdit:"1",  // The Type is editable cell, though it is calculated - the source value is set in OnChange event 
      COMPLETEFormula:"Grid.Resources[Row.id] ? Grid.Resources[Row.id].Type : 1",  // Reads the Type from resource Type 
      COMPLETEOnChange:"Grid.Resources[Row.id].Type = Value; Grid.Calculate(1)",  // Saves the change to resource Type 

      DESCENDANTSType:"Float", DESCENDANTSFormat:"0.00", DESCENDANTSFormula:"ganttresourceunits(Row.id,'R')",  // DESCENDANTS shows resource Total usage, it is calculated and read only 

      ANCESTORSType:"Float", ANCESTORSFormat:"0.00", ANCESTORSFormula:"DESCENDANTS * START",  // ANCESTORS shows resource Total price, it is calculated and read only 
      
      PRICEVisible:"0", CALENDARButton:"", CLASS1Visible:"0" // Overrides other cells to be empty without side buttons 
      }

   ],

LeftCols: [
   {  Name:"id", Type:"Int", Width:"23", WidthPad:"17", CanEdit:"0" }, // id / row number column
   {  Name:"TASK", Width:"40", Type:"Text", GroupWidth:"1" }, // Task name column
   {  Name:"SECTION", Width:"40", GroupWidth:"1", Type:"Text" } // Section name column
   ],

Cols: [
   {  Name:"START", Width:"80", DefaultDate:"5/1/2008 9:00", Type:"Date", Format:"MMM dd, '<span style=\";color:blue\";>'HH'</span>'", EditFormat:"MM/dd/yy HH" }, // First main bar Start date column
   {  Name:"END", Width:"80", DefaultDate:"5/1/2008 18:00", Type:"Date", Format:"MMM dd, '<span style=\";color:blue\";>'HH'</span>'", EditFormat:"MM/dd/yy HH", CanEmpty:"1" }, // First main bar End date column
   {  Name:"DURATION", Width:"33", Type:"Text", Align:"Right", MenuName:"Duration" }, // First main bar Duration column
   {  Name:"COMPLETE", Width:"37", Type:"Float", EditMask:"^\\d*[\\d\\.\\ }?\\d*$", Format:"##.##\\%;;0\\%", MenuName:"Complete" }, // First main bar Complete column
   {  Name:"TEXT", Visible:"0", Width:"120" },  // First main bar info column
   {  Name:"DISABLED", Visible:"0", Type:"Int" }, // Hidden column to store disabled state and save or export it
      
   {  Name:"DESCENDANTS", Width:"50", Type:"Text", Range:"1", MenuName:"Descendants" },// Descendants, ids of next tasks
   {  Name:"ANCESTORS", Width:"50", Type:"Text", Range:"1", MenuName:"Ancestors" },// Ancestors, ids of previous tasks
   {  Name:"CALENDAR", Width:"70", Type:"Select", OnClickSideDefaults: "Grid.ShowGanttCalendars(Row,Col)", OnEnter: "Grid.ShowGanttCalendars(Row,Col)" }, // Custom calendar / excluded dates
   {  Name:"CLASS", Width:"60", Type:"Enum", Enum:",,Aqua,Black,Blue,Fuchsia,Gray,Green,Lime,Maroon,Navy,Olive,Orange,Purple,Red,Silver,Teal,White,Yellow",
         OnChange:"Row.GANTTGanttClass=Value;", Formula:"Get(Row,'GANTTGanttClass') ? Get(Row,'GANTTGanttClass') : Grid.Cols.GANTT.GanttClass", CanEdit:"1" }, // Color of the first main bar-->

   {  Name:"START1", Visible:"0", Width:"80", DefaultDate:"5/1/2008 9:00", Type:"Date", Format:"MMM dd, '<span style=\";color:blue\";>'HH'</span>'", EditFormat:"MM/dd/yy HH" }, // Second main bar Start date column
   {  Name:"END1", Visible:"0", Width:"80", DefaultDate:"5/1/2008 18:00", Type:"Date", Format:"MMM dd, '<span style=\";color:blue\";>'HH'</span>'", EditFormat:"MM/dd/yy HH", CanEmpty:"1" }, // Second main bar End date column
   {  Name:"DURATION1", Visible:"0", Width:"31", Type:"Text", Align:"Right", MenuName:"Duration" }, // Second main bar Duration column
   {  Name:"PARTS1", Visible:"0", Width:"150", Type:"Date", DefaultDate:"5/1/2008 9:00~5/1/2008 18:00", Range:"1", Button:"", Format:"MMM dd, '<span style=\";color:blue\";>'HH'</span>'" }, // Second main bar Parts column for discrete bar
   {  Name:"TEXT1", Visible:"0", Width:"120" }, // Second main bar info column
   {  Name:"CLASS1", Visible:"0", Width:"60", Type:"Enum", Enum:",,Aqua,Black,Blue,Fuchsia,Gray,Green,Lime,Maroon,Navy,Olive,Orange,Purple,Red,Silver,Teal,White,Yellow",
         OnChange:"Row.GANTTGanttClass1=Value;", Formula:"Get(Row,'GANTTGanttClass1') ? Get(Row,'GANTTGanttClass1') : Grid.Cols.GANTT.GanttClass1", CanEdit:"1" }, // Color of the second main bar-->

   {  Name:"SLACK", Visible:"0", Width:"40", Type:"Float", CanEmpty:"1", CanEdit:"0", MenuName:"Slack" }, // Slack for critical path, automatically filled
   {  Name:"RESOURCES", Visible:"0", Width:"110", Type:"Text" }, // Resources column
   {  Name:"PRICE", Visible:"0", Width:"55", Type:"Float", Format:",0.00", Formula:"Grid.GetGanttPrice(Row,'GANTT')" }, // Task price column
   {  Name:"FLAGS", Visible:"0", Width:"75", Type:"Date", Range:"1", Button:"", Format:"MMM dd, '<span style=\";color:blue\";>'HH'</span>'" }, // Flags column
   {  Name:"FLAGSTEXT", Visible:"0", Width:"60", Type:"Text", Range:"1" }, // Flags info column
   {  Name:"PROGRESS", Visible:"0", Width:"100", Formula:"ganttprogressline(Grid.Rows.Project.Progress)" }, // Hidden column to calculate progress line as GanttMark

   {  Name:"MINSTART", Visible:"0", Width:"80", Type:"Date", Format:"MMM dd, '<span style=\";color:blue\";>'HH'</span>'", EditFormat:"MM/dd/yy HH" }, // Min Start date column
   {  Name:"MAXSTART", Visible:"0", Width:"80", Type:"Date", Format:"MMM dd, '<span style=\";color:blue\";>'HH'</span>'", EditFormat:"MM/dd/yy HH" }, // Max Start date column
   {  Name:"MINEND", Visible:"0", Width:"80", Type:"Date", Format:"MMM dd, '<span style=\";color:blue\";>'HH'</span>'", EditFormat:"MM/dd/yy HH" }, // Min End date column
   {  Name:"MAXEND", Visible:"0", Width:"80", Type:"Date", Format:"MMM dd, '<span style=\";color:blue\";>'HH'</span>'", EditFormat:"MM/dd/yy HH" } // Max End date column
   ],

// Column captions and header tooltips
Header: {
   id:"ID", idTip:"id - Task unique idenfication<br>Not used for automatically created grouped tasks<br>Used especially to assign dependencies to tasks and to identify tasks when saving changes to server",
   TASK:"Task", TASKTip:"Task name, the same for more rows, any custom string",
   SECTION:"Section", SECTIONTip:"Name of individual task part, any custom string<br>When grouped, it shows task name in parent and the section name in child row",
   START:"Start", STARTTip:"Start date (and time) of the task, first plan",
   END:"End", ENDTip:"End date (and time) of the task, first plan",
   COMPLETE:"Com<br>plete", COMPLETETip:"Percentage completion of the task, first plan<br>By default only not started tasks (0%) can be scheduled",
   DURATION:"Dura<br>tion", DURATIONTip:"Duration in hours of the task, first plan",
   TEXT:"Information", TEXTTip:"Task custom information, here shown in task tip, first plan",
   DISABLED:"Disabled", DISABLEDTip:"If the task is disabled or locked",
   CLASS:"Color", CLASSTip:"Task background color, first plan",
   START1:"Start 1", START1Tip:"Start date (and time) of the task, second plan",
   END1:"End 1", END1Tip:"End date (and time) of the task, second plan",
   DURATION1:"Dura<br>tion 1", DURATION1Tip:"Duration in hours of the task, second plan",
   PARTS1:"Parts 1", PARTS1Tip:"Start and End dates of individual parts, if the task is discrete, second plan",
   TEXT1:"Information 1", TEXT1Tip:"Task custom information, here shown in task tip, second plan",
   CLASS1:"Color 1", CLASS1Tip:"Task background color, second plan",
   DESCENDANTS:"Descen<br>dants", DESCENDANTSTip:"(Successors) Dependencies to next tasks, their ids, optionally with lag, span and color, here used for task first plan",
   ANCESTORS:"Ances<br>tors", ANCESTORSTip:"(Predecessors) Dependencies from previous tasks, their ids, optionally with lag, span and color, here used for task first plan",
   SLACK:"Slack<br>(critical path)", SLACKTip:"Calculated value for task first plan, in hours<br>How much the task can be delayed to not affect the project end date (or start date)<br>If it is 0, the task is on critical path<br>If it is negative, the task is incorrect",
   CALENDAR:"Calendar", CALENDARTip:"Custom calendar for all task plans and other Gantt objects.<br>Defines excluded dates ingored in Gantt calculations",
   RESOURCES:"Resources", RESOURCESTip:"Resources assigned to task, first plan<br>Used to calculate task price and to show project resources usage in the grid bottom",
   PRICE:"Price", PRICETip:"Price of the task, first plan. Calculated from the resources assigned to task and the task duration",
   PROGRESS:"Progress", PROGRESSTip:"Results of internal calculations to show progress line for the task",
   MINSTART:"Min start", MINSTARTTip:"Early start constraint, here used for the task first plan",
   MAXSTART:"Max start", MAXSTARTTip:"Late start constraint, here used for the task first plan",
   MINEND:"Min end", MINENDTip:"Early end constraint, here used for the task first plan",
   MAXEND:"Max end", MAXENDTip:"Late end constraint, here used for the task first plan",
   FLAGS:"Flags", FLAGSTip:"Icon on the selected date, for custom information for the date",
   FLAGSTEXT:"Flag Info", FLAGSTEXTTip:"Custom information for the flag date",
   GANTT:"Gantt",
   SortIcons:"2", // Hides unused sort icons   
   NoEscape:"1" // The header cells contain HTML code   
   },

RightCols: [

// Gantt chart column
   {  Name:"GANTT",

      // Basic settings
      Type:"Gantt", MenuName:"Gantt chart", // Basic setting, type and name in columns menu
      GanttTask:"Main,Box", // The dependencies and resources are assigned the first main bar plan and also to run box in Network diagram
      GanttCount:"2", // Defines two main bar plans
      GanttBottom:"2", // Sets smaller GanttBottom because the second main bar does not have dependencies-->

      // Data settings
      GanttDataUnits:"h", // All lengths in input data XML (like Dependency lags) are in hours
      GanttDataModifiers:"m:1/60,h:1,d:8,w:40", // Modifiers that can be used in Dependency lag values to multiply the value to get hour count
      GanttLastUnit:"", // All the end dates are set exactly and not as the last unit
      
      // First main bar plan definition
      GanttStart:"START", GanttEnd:"END", GanttDuration:"DURATION", GanttComplete:"COMPLETE", GanttText:"TEXT", // Defines source columns for Main tasks - first main bar plan
      GanttDisabled:"DISABLED", // Stores the disabled state in column to export it to PDF
      GanttResources:"RESOURCES", // Resources assigned to the first main bar plan
      GanttHeight:"4", // Height of the first main bar plan
      GanttHtmlRight:"&nbsp;&nbsp;$<span style='color:#77F'>*PRICE*</span> *RESOURCES*", // Formats the text next to main task
      GanttHtmlRightEdge:"5", // Shows the text next to the last bar, including the second plan
      GanttShowHtml:"3", // Resize Gantt also according to the side texts
      GanttClass:"", // The first main bar plan uses default style background

      // Second main bar plan definition
      GanttStart1:"START1", GanttEnd1:"END1", GanttDuration1:"DURATION1", GanttParts1:"PARTS1", GanttText1:"TEXT1", // Defined source columns for the second main bar plan
      GanttTop1:"9", GanttHeight1:"2", // Vertical position and height of the second main bar plan
      GanttClass1:"Maroon", // The second main bar plan has set blue background
      GanttMilestones1:"0", // Restricts milestones for the second main bar plan

      // Flags definition
      GanttFlags:"FLAGS", GanttFlagTexts:"FLAGSTEXT", GanttFlagsMove:"2", // Defined source columns for Flags, can move flags between rows

      // Vertical lines definition
      GanttLines:"3#5/27/2008#Navy2;5#5/23/2008 18:00#Hidden", // Defines two vertical lines, one for simulated actual date and one hidden to change progress line
      GanttLine0Tip:"Actual date for this project is at *Start*", // Tip for the simulated actual date
      GanttMark:"PROGRESS", // Defines source column for progress line
      GanttLine1Tip:"Progress line is set at *Start*", // Tip for the progress line

      // Settings for scheduling
      GanttDescendants:"DESCENDANTS", GanttAncestors:"ANCESTORS", // Defines source columns for Dependencies
      GanttMinStart:"MINSTART", GanttMaxStart:"MAXSTART", GanttMinEnd:"MINEND", GanttMaxEnd:"MAXEND", // Start and end date constraints
      GanttSlack:"SLACK", // Where will be filled information for critical path
      GanttAssignDependencies:"3", // Assigns different colors to dependencies to the same box and its edge
      GanttAllDependencies:"5", // Removes dependency lines between collapsed children, can slow down collapsing / expanding
      GanttStrict:"1", // Forces first tasks to start on base date and all other to start immediately when possible
      GanttDirection:"0", // Schedules tasks from start
      GanttCorrectDependencies:"2", // Ask to correct dependencies after main task move or resize or dependency change
      GanttCorrectDependenciesFixed:"1", // Cannot move the changed task when automatically correcting dependencies
      GanttCheckExclude:"2", // Ask to move task if it starts on holiday after resize or move
      GanttBase:"5/14/2008 9:00", // Project start date, all the tasks should start after this date
      GanttFinish:"", // Project end date, all the tasks should end before this date. Not defined by default here
      GanttBaseProof:"1", // The tasks cannot be moved or created before GanttBase, if defined
      GanttFinishProof:"1", // The tasks cannot be moved or created after GanttFinish, if defined
      GanttBaseTip:"Project start set at *Start*", GanttBaseAutoTip:"Project starts at *Start*", // Tip for GanttBase line, if defined and if not defined
      GanttFinishTip:"Project finish set at *Start*", GanttFinishAutoTip:"Project finishes at *Start*", // Tip for GanttFinish line, if defined and if not defined
      GanttLineTipDateFormat:"<b>dddddd MMMM H:mm</b>", // Sets date format for all lines tips, for GanttLinesTip and for GanttBase and GanttFinish
      
      // Resources
      GanttResourcesAssign:"4", // Shows resources menu with float number inputs
      GanttResourcesExtra:"3", // Both extra price per task and per resource are permitted

      // Tooltips
      GanttTip:"*id*. *TASK*, *SECTION* <span style='color:#F77'>(first bar)</span><div style='padding-top:5px;padding-bottom:5px;font-weight:bold;'>*Start* - *End*</div>*Duration* hours, *COMPLETE* completed<div style='padding-top:5px;'><b>*SLACK*</b> hours reserve</div><div style='padding-top:5px;'>*Text*</div>", // Specifies tooltip shown for first main bar
      GanttMilestoneTip:"*id*. *TASK*, *SECTION* <span style='color:#F77'>(milestone)</span><div style='padding-top:5px;font-weight:bold;'>*Start*</div><div style='padding-top:5px;'><b>*SLACK*</b> hours reserve</div><div style='padding-top:5px;'>*Text*</div>", // Specifies tooltip shown for first main plan milestone-->
      GanttTip1:"*id*. *TASK*, *SECTION* <span style='color:#F77'>(*Index*. second bar)</span><div style='padding-top:5px;padding-bottom:5px;font-weight:bold;'>*Start* - *End*</div>*Duration* hours<div style='padding-top:5px;'>*Text*</div>", // Specifies tooltip shown for second main bar
      GanttFlagsTip:"*Start* - *Text*", // Specifies tooltip shown for flags
      GanttDependencyTip:"From: <b>*From*</b>. *Start*<br>To: <b>*To*</b>. *End*<br>Type: <b>*Type*</b><br>Lag: <b>*Lag*</b><br>Float: <b>*Float*</b>", GanttDependencyTipDateFormat:"MMM dd, '<span style=\";color:blue\";>'HH'</span>'", // Specifies tooltip shown for dependency line

      // Basic setting for Network diagram, the Run boxes
      GanttRunMinWidth:"0", // Shows all boxes in all zoom levels
      GanttRunBoxMinWidth:"90", // Sets minimal box width in pixels, to display its content
      GanttRunBoxMinAlign:"left", // The boxes start on their start dates and the end dates can be ignored
      GanttRunBoxMinType:"7", // The minimal width is used for display, error shift and dependencies
      GanttAdjacentDependencies:"2", // The straight dependencies are rendered straight even for adjacent boxes when there is not enough room for them
      GanttRunMilestones:"2", // Shows milestones as boxes
      GanttRunSelect:"5", // Permits selecting more boxes in grid
      GanttRunStates:"0", // Does not store the run states, here used especially to not collide with DISABLED state
      GanttRunMove:"Slide,Move,Selected,Clear", // Slides the row inside row or moves the run to another row. Moves all selected boxes together and clears selection after that

      // Exclude settings
      GanttCalendar:"CALENDAR", // Column with custom calendars
      GanttExclude:"Special", // Global calendar - the excluded dates are not used for Gantt calculations and behaves like they don't exist at all
      GanttHideExclude:"0", // By default are the Excluded dates in global calendar shown in chart, it can be changed by a user
      GanttChangeExclude:"1", // When changing exclude, the main bars will preserve duration and change end date
      GanttExcludeComplete:"1", // It shows percentage completion related to task workdays, not for task full length
      GanttAvailabilityExclude:"0", // The resources chart is not rounded to the excluded dates

      // Basic zoom settings
      GanttZoom:"weeks and days", // Predefined zoom level name
      GanttZoomChange:"1", // Resets actual view size when changing zoom to higher zoom levels with GanttSize:""
      GanttChartMinStart:"1/1/2000", GanttChartMaxEnd:"1/1/2020",
      GanttLeft:"2", GanttRight:"0", // At least two units will be let empty on left side (no Exclude applied here)
      MinWidth:"450" // Minimal width of the column will be 450 pixels
      }
   ],

   // Gantt Zoom defines zoom levels definition
   // The individual levels predefine various Gantt zoom settings
   // GanttUnits and GanttWidth specify the zooming size, to GanttUnits are all the dates rounded for display and drag
   // GanttChartRound specifies rounding of first and last date in the chart
   // GanttBackground highlights given dates
   // GanttHeader1 specifies the dates shown in the first line in Gantt header
   // GanttHeader2 and possibly also 3,4,5 specify next lines in Gantt header
   // GanttSize specifies exact range that is shown in the zoom level
   // Pager... settings control the side Gantt pagers
   // The ...Ex values are chosen when Exclude is hidden, they are appropriate only for the actual Exclude dates (days and hours)
Zoom: [

   // Zoom levels without GanttSize and without Gantt pagers
   {  Name:"years and halves", GanttUnits:"M6", GanttChartRound:"y", GanttWidth:"18", GanttWidthEx:"76", GanttPrintRound:"y", GanttBackground:";y#1/1/2008",
         GanttSize:"", GanttHeader1:"y#yyyy", GanttHeader2:"M6#MMMMMM" },
   {  Name:"years and quarters", GanttUnits:"M3", GanttChartRound:"y", GanttWidth:"24", GanttWidthEx:"101", GanttPrintRound:"y", GanttBackground:";y#1/1/2008",
         GanttSize:"", GanttHeader1:"y#yyyy", GanttHeader2:"M3#MMMMM" },
   {  Name:"halves and months", GanttUnits:"M", GanttChartRound:"y", GanttWidth:"18", GanttWidthEx:"76", GanttPrintRound:"M6", GanttBackground:";M6#1/1/2008",
         GanttSize:"", GanttHeader1:"M6#MMMMMM. yyyy", GanttHeader2:"M#MM" },
   {  Name:"quarters and months", GanttUnits:"M", GanttChartRound:"M6", GanttWidth:"28", GanttWidthEx:"118", GanttPrintRound:"M3", GanttBackground:";M3#1/1/2008",
         GanttSize:"", GanttHeader1:"M3#MMMMM. yyyy", GanttHeader2:"M#MMM" },
   {  Name:"months and weeks", GanttUnits:"d", GanttChartRound:"M", GanttWidth:"3", GanttWidthEx:"12.6",  GanttPrintRound:"M", GanttBackground:";M#1/1/2008",
         GanttSize:"", GanttHeader1:"M#MMM yyyy", GanttHeader2:"w#d." },
   {  Name:"months and days", GanttUnits:"d", GanttChartRound:"M", GanttWidth:"8", GanttWidthEx:"33.6", GanttPrintRound:"M", GanttBackground:"M#1/1/2008#5",
         GanttSize:"", GanttHeader1:"M#MMMM yyyy", GanttHeader2:"d#'<div style=\";font:8px Arial;\";>'DDDDDD'<br/>'DDDDDDD'</div>'", GanttHeaderHeight2:"20" },
   {  Name:"weeks and days", GanttUnits:"d", GanttChartRound:"w", GanttWidth:"18", GanttWidthEx:"76", GanttPrintRound:"w", GanttBackground:"M#1/1/2008#5",
         GanttSize:"", GanttHeader1:"w#'<span style=\";color:red;font-size:8px;\";>week 'ddddddd'</span>' MMMM yyyy", GanttHeader2:"d#%d", GanttHeader3:"d#ddddd" },
   {  Name:"days and quarters", GanttUnits:"h", GanttChartRound:"w", GanttWidth:"3", GanttWidthEx:"9", GanttPrintRound:"d", GanttBackground:"M#1/1/2008#5",
         GanttSize:"", GanttHeader1:"d#dd MMM yyyy", GanttHeader2:"d#dddd", GanttHeader3:"h6#HH", GanttHeaderRound3:"1" },
   {  Name:"days and hours", GanttUnits:"h", GanttChartRound:"d", GanttWidth:"8", GanttWidthEx:"24", GanttPrintRound:"d", GanttBackground:"M#1/1/2008#5",
         GanttSize:"", GanttHeader1:"d#dddd dddddd MMMM yyyy", GanttHeader2:"h#'<div style=\";font:8px Arial;\";>'HHHH'<br/>'HHHHH'</div>'", GanttHeader2Ex:"h#HH", GanttHeaderHeight2:"20" },

   // Zoom levels with GanttSize set and side Gantt pagers
   { Name:"halves and hours", GanttUnits:"h", GanttChartRound:"d", GanttWidth:"19", GanttWidthEx:"25",
      GanttHeader1:"h12#dddd dddddd MMMM yyyy tt", GanttHeader1Ex:"d#dddd dddddd MMMM yyyy", GanttHeader2:"h#HH",
      GanttSize:"w", GanttSizeLeft:"24", GanttSizeRight:"24", PagerPageSize:"w", PagerChartSize:"M6", PagerFormat:"Week ddddddd", PagerTipFormat:"M/d; - M/d", PagerCaptionFormat:"MMMMMM. yyyy" },
   { Name:"hours and quarters", GanttUnits:"h", GanttChartRound:"d", GanttWidth:"60", GanttBackground:"w#1/5/2008~1/7/2008; h#00:00", 
      GanttHeader1:"h3#dddd dddddd MMMM yyyy", GanttHeader2:"h#HH 'hour'", GanttHeader3:"m15#mm", 
      GanttSize:"d", GanttSizeLeft:"3", GanttSizeRight:"3", PagerPageSize:"d", PagerChartSize:"M", PagerFormat:"dddddd", PagerTipFormat:"M/d", PagerCaptionFormat:"MMMM" },
   { Name:"hours and 5 minutes", GanttUnits:"m5", GanttChartRound:"h", GanttWidth:"18", GanttBackground:"w#1/5/2008~1/7/2008; h#00:00", 
      GanttHeader1:"h#dddd dddddd MMMM yyyy", GanttHeader2:"h#HH 'hour'", GanttHeader3:"m5#mm", 
      GanttSize:"d", GanttSizeLeft:"12", GanttSizeRight:"12", PagerPageSize:"d", PagerChartSize:"M", PagerFormat:"dddddd", PagerTipFormat:"M/d", PagerCaptionFormat:"MMMM" },
   { Name:"hours and minutes", GanttUnits:"m", GanttChartRound:"h", GanttWidth:"8", GanttBackground:"m15#00:00; h#00:00",
      GanttHeader1:"h#dddd dddddd MMMM yyyy, '<span style=\"color:red;\">'HH 'hour</span>'",
      GanttHeader2:"m#'<div style=\"font:8px Arial;\">'mmmm'<br/>'mmmmm'</div>'", 
      GanttSize:"h6", GanttSizeLeft:"60", GanttSizeRight:"60", PagerPageSize:"h", PagerChartSize:"d", PagerFormat:"HH:00", PagerTipFormat:"M/d HH:00", PagerCaptionFormat:"dddddd MMM<br>yyyy" },
   { Name:"halves and minutes", GanttUnits:"m", GanttChartRound:"h", GanttWidth:"12", GanttBackground:"m15#00:00; h#00:00",
      GanttHeader1:"m30#dddd dddddd MMMM yyyy, '<span style=\"color:red;\">'HH:mm '</span>'",
      GanttHeader2:"m#'<div style=\"font:8px Arial;\">'mmmm'<br/>'mmmmm'</div>'", 
      GanttSize:"h3", GanttSizeLeft:"30", GanttSizeRight:"30", PagerPageSize:"h", PagerChartSize:"d", PagerFormat:"HH:00", PagerTipFormat:"M/d HH:00", PagerCaptionFormat:"dddddd MMM<br>yyyy" },
   { Name:"quarters and minutes", GanttUnits:"m", GanttChartRound:"h", GanttWidth:"18", GanttBackground:"m15#00:00; h#00:00",
      GanttHeader1:"m15#dddd dddddd MMMM yyyy, '<span style=\"color:red;\">'HH:mm '</span>'", GanttHeader2:'m#mm', 
      GanttSize:"h2", GanttSizeLeft:"15", GanttSizeRight:"15", PagerPageSize:"h", PagerChartSize:"d", PagerFormat:"HH:00", PagerTipFormat:"M/d HH:00", PagerCaptionFormat:"dddddd MMM<br>yyyy" },
   { Name:"5 minutes and minutes", GanttUnits:"m", GanttChartRound:"m15", GanttWidth:"36", GanttBackground:"m5#00:00; h#00:00",
      GanttHeader1:"m5#dddd d MMM yyyy, '<span style=\"color:red;\">'HH:mm'</span>'", GanttHeader2:"m#mm", 
      GanttSize:"h", GanttSizeLeft:"5", GanttSizeRight:"5", PagerPageSize:"m15", PagerChartSize:"h6", PagerFormat:"HH:mm", PagerTipFormat:"M/d HH:mm", PagerCaptionFormat:"dddddd MMM<br>yyyy" },
   { Name:"minutes and 15 seconds", GanttUnits:"s15", GanttChartRound:"m15", GanttWidth:"18", GanttBackground:"m#00:00; h#00:00",
      GanttHeader1:"m2#dddd d MMM yyyy", GanttHeader2:"m#HH:mm", GanttHeader3:"s15#ss", 
      GanttSize:"m30", GanttSizeLeft:"8", GanttSizeRight:"8", PagerPageSize:"m5", PagerChartSize:"h2", PagerFormat:"HH:mm", PagerTipFormat:"M/d HH:mm", PagerCaptionFormat:"dddddd MMM<br>yyyy" },
   { Name:"minutes and 5 seconds", GanttUnits:"s5", GanttChartRound:"m15", GanttWidth:"18", GanttBackground:"m#00:00; h#00:00",
      GanttHeader1:"m#dddd dddddd MMMM yyyy", GanttHeader2:"m#HH:mm", GanttHeader3:"s5#ss", 
      GanttSize:"m15", GanttSizeLeft:"12", GanttSizeRight:"12", PagerPageSize:"m5", PagerChartSize:"h2", PagerFormat:"HH:mm", PagerTipFormat:"M/d HH:mm", PagerCaptionFormat:"dddddd MMM<br>yyyy" },
   { Name:"minutes and seconds", GanttUnits:"s", GanttChartRound:"m5", GanttWidth:"8", GanttBackground:"s15#00:00; m#00:00",
      GanttHeader1:"m#dddd dddddd MMMM yyyy, '<span style=\"color:red;\">'HH:mm 'minute</span>'",
      GanttHeader2:"s#'<div style=\"font:8px Arial;\">'ssss'<br/>'sssss'</div>'", 
      GanttSize:"m5", GanttSizeLeft:"60", GanttSizeRight:"60", PagerPageSize:"m", PagerChartSize:"m30", PagerFormat:"HH:mm", PagerTipFormat:"M/d HH:mm", PagerCaptionFormat:"dddddd MMM<br>yyyy" },
   { Name:"halves and seconds", GanttUnits:"s", GanttChartRound:"m5", GanttWidth:"12", GanttBackground:"s15#00:00; m#00:00",
      GanttHeader1:"s30#dddd d MMM yyyy, '<span style=\"color:red;\">'HH:mm 'minute</span>'",
      GanttHeader2:"s#'<div style=\"font:8px Arial;\">'ssss'<br/>'sssss'</div>'", 
      GanttSize:"m2", GanttSizeLeft:"15", GanttSizeRight:"15", PagerPageSize:"m", PagerChartSize:"m30", PagerFormat:"HH:mm", PagerTipFormat:"M/d HH:mm", PagerCaptionFormat:"dddddd MMM<br>yyyy" },
   { Name:"quarters and seconds", GanttUnits:"s", GanttChartRound:"m", GanttWidth:"18", GanttBackground:"s15#00:00; m#00:00",
      GanttHeader1:"s15#dddd dddddd MMMM yyyy, '<span style=\"color:red;\">'HH:mm:ss'</span>'", GanttHeader2:"s#ss", 
      GanttSize:"m2", GanttSizeLeft:"15", GanttSizeRight:"15", PagerPageSize:"m", PagerChartSize:"m30", PagerFormat:"HH:mm", PagerTipFormat:"M/d HH:mm", PagerCaptionFormat:"dddddd MMM<br>yyyy" },
   { Name:"5 seconds and seconds", GanttUnits:"s", GanttChartRound:"s15", GanttWidth:"36", GanttBackground:"s5#00:00; m#00:00",
      GanttHeader1:"s5#dddd d MMM yyyy, '<span style=\"color:red;\">'HH:mm'</span>'", GanttHeader2:"s#ss", 
      GanttSize:"m", GanttSizeLeft:"5", GanttSizeRight:"5", PagerPageSize:"m", PagerChartSize:"m30", PagerFormat:"HH:mm", PagerTipFormat:"M/d HH:mm", PagerCaptionFormat:"dddddd MMM<br>yyyy" },
   { Name:"seconds and 100 ms", GanttUnits:"ms100", GanttChartRound:"s2", GanttWidth:"9", GanttBackground:"s#00:00; m#00:00",
      GanttHeader1:"s2#dddd dddddd MMMM yyyy", GanttHeader2:"s#HH:mm:ss", GanttHeader3:"ms100#%f", 
      GanttSize:"s15", GanttSizeLeft:"20", GanttSizeRight:"20", PagerPageSize:"s5", PagerChartSize:"m2", PagerFormat:"HH:mm:ss", PagerTipFormat:"M/d HH:mm:ss", PagerCaptionFormat:"dddddd MMM<br>yyyy" },
   { Name:"seconds and 100 ms 2", GanttUnits:"ms100", GanttChartRound:"s", GanttWidth:"60", GanttBackground:"s#00:00; m#00:00",
      GanttHeader1:"s#dddd dddddd MMMM yyyy", GanttHeader2:"ms100#HH:mm:ss.'<span style=\"color:red;\">'f'</span>'", 
      GanttSize:"s5", GanttSizeLeft:"10", GanttSizeRight:"10", PagerPageSize:"s5", PagerChartSize:"m2", PagerFormat:"HH:mm:ss", PagerTipFormat:"M/d HH:mm:ss", PagerCaptionFormat:"dddddd MMM<br>yyyy" },
   { Name:"100 ms and 10 ms", GanttUnits:"ms10", GanttChartRound:"ms100", GanttWidth:"10", GanttBackground:"ms100#00:00; s#00:00",
      GanttHeader1:"ms100#ddd d MMM yyyy", GanttHeader2:"ms100#HH:mm:ss.'<span style=\"color:red;\">'f'</span>'", GanttHeader3:"ms10#ffff", 
      GanttSize:"s", GanttSizeLeft:"10", GanttSizeRight:"10", PagerPageSize:"s", PagerChartSize:"s30", PagerFormat:"HH:mm:ss", PagerTipFormat:"M/d HH:mm:ss", PagerCaptionFormat:"dddddd MMM<br>yyyy" },
   { Name:"100 ms and 10 ms 2", GanttUnits:"ms10", GanttChartRound:"ms100", GanttWidth:"65", GanttBackground:"ms100#00:00; s#00:00",
      GanttHeader1:"ms100#dddd dddddd MMMM yyyy",  GanttHeader2:"ms10#HH:mm:ss.'<span style=\"color:red;\">'ff'</span>'", 
      GanttSize:"s", GanttSizeLeft:"10", GanttSizeRight:"10", PagerPageSize:"s", PagerChartSize:"s30", PagerFormat:"HH:mm:ss", PagerTipFormat:"M/d HH:mm:ss", PagerCaptionFormat:"dddddd MMM<br>yyyy" },
   { Name:"10 ms and ms", GanttUnits:"ms", GanttChartRound:"ms10", GanttWidth:"11", GanttBackground:"ms10#00:00; ms100#00:00",
      GanttHeader1:"ms10#ddd d MMM yyyy", GanttHeader2:"ms10#HH:mm:ss.'<span style=\"color:red;\">'ff'</span>'", GanttHeader3:"ms#fffff", 
      GanttSize:"ms100", GanttSizeLeft:"10", GanttSizeRight:"10", PagerPageSize:"ms100", PagerChartSize:"s2", PagerFormat:"HH:mm:ss.fff", PagerTipFormat:"M/d HH:mm:ss.fff", PagerCaptionFormat:"dddddd MMM<br>yyyy" },
   { Name:"10 ms and ms 2", GanttUnits:"ms", GanttChartRound:"ms10", GanttWidth:"70", GanttBackground:"ms10#00:00; ms100#00:00",
      GanttHeader1:'ms10#dddd dddddd MMMM yyyy', GanttHeader2:"ms#HH:mm:ss.'<span style=\"color:red;\">'fff'</span>'", 
      GanttSize:"ms100", GanttSizeLeft:"10", GanttSizeRight:"10", PagerPageSize:"ms100", PagerChartSize:"s2", PagerFormat:"HH:mm:ss.fff", PagerTipFormat:"M/d HH:mm:ss.fff", PagerCaptionFormat:"dddddd MMM<br>yyyy" },
   { Name:"10 ms and ms 3", GanttUnits:"ms", GanttChartRound:"ms10", GanttWidth:"180", GanttBackground:"ms10#00:00; ms100#00:00",
      GanttHeader1:'ms#dddd dddddd MMMM yyyy', GanttHeader2:"ms#HH:mm:ss.'<span style=\"color:red;\">'fff'</span>'", 
      GanttSize:"ms10", GanttSizeLeft:"1", GanttSizeRight:"1", PagerPageSize:"ms10", PagerChartSize:"ms100", PagerFormat:"HH:mm:ss.fff", PagerTipFormat:"M/d HH:mm:ss.fff", PagerCaptionFormat:"dddddd MMM<br>yyyy" }
   ],

   // Side pagers showing Gantt zoom dates
Pagers: [
   {  Name:"Year", Caption:"Year", Type:"Gantt", PageSize:"y", ChartSize:"0", Left:"1", Format:"yyyy", Width:"35", ZoomToPage:"5" },
   {  Name:"Month", Caption:"Month", Type:"Gantt", PageSize:"M", ChartSize:"y", Left:"1", Format:"MMM", Width:"42", ZoomToPage:"5" },
   {  Name:"Pager", Caption:"Pager", Type:"Gantt", Width:"70", FirstZoom:"halves and hours", ZoomToPage:"4", ChartPrev:"1", ChartNext:"1" }
   ],
   
   // Defines all calendars (excluded dates) available in grid
Calendars: [
   {  Name:"Standard", Exclude:"d#18:00~9:00; d#13:00~14:00#1; w#1/5/2008~1/7/2008#1;" }, // Workdays Monday - Friday, only hours 9:00-13:00 and 14:00-18:00
   {  Name:"24 hours", Exclude:"" }, // 24 hours per day, 7 days per week
   {  Name:"Night shift", Exclude:"d#8:00~23:00; d#3:00~4:00#1; w#1/5/2008 8:00~1/7/2008 8:00#1;" }, // Workdays Monday night - Saturday morning, only hours 23:00-3:00 and 4:00-8:00
   {  Name:"Special", Exclude:"d#18:00~9:00; d#13:00~14:00#1; w#1/5/2008~1/7/2008#1; 5/28/2008~5/29/2008#2" } // Like Standard, but without 28th May 2008
   ],
   
Solid: [
      
   // Top tabber, defines the two view tabs, uploads changes to server for PDF export
   {  Kind:"Tabber2", id:"Tabber", Cells:"Gantt,Diagram,Sep,Info", NoUpload:"0",
      GanttButtonText:"Gantt chart", Gantt:"1", GanttOnClick:"return SwitchViewMessage(0);", GanttTip:"Switches to Gantt chart view",
      DiagramButtonText:"Network diagram", DiagramOnClick:"return SwitchViewMessage(1);", DiagramTip:"Switches to Network diagram view",
      SepButton:"TabSep",
      InfoType:"Html", InfoWrap:"0", InfoClass:"Info", InfoCanFocus:"0", InfoCanPrint:"0",
      Info:"<i>All the demonstrated features can be fully customized via XML / JSON data or via JavaScript API</i>"
      },

   // Defines the first top toolbar with combos to choose grouping, zoom, calendars and bar height
   {  Kind:"Group", id:"Group", Space:"0", Panel:"0", Cells:"List,Zoom,Fit,Max,Ex,HidEx,Cal,Bar", CanPrint:"5", NoUpload:"0",
        
      ListLeft:"2", 
      ListHtmlPrefix:'<b>Group by <span style="color:blue;">', ListHtmlPostfix:'</span></b>',
  		List:'|none|Task|Complete Task|Complete|Start|End',
      Cols:'||TASK|COMPLETE,TASK|COMPLETE|START|END',
      ListWidth:'108',
      ListPrintHPage:'1',
      ListTip:'Grouping rows according to some column(s) values',
			
      ZoomType:'SelectGanttZoom',
      ZoomHtmlPrefix:'<b>Zoom to <span style="color:blue;">', ZoomHtmlPostfix:'</span></b>',
      ZoomLeft:'2', ZoomWidth:'170', ZoomPrintHPage:'1',
      ZoomTip:'Zoom level, available from milliseconds to years',

      FitType:'Button', FitWidth:'60', FitButtonText:'<b>Zoom</b> <b style="color:blue;">fit</b>', FitButton:'Button',
      FitOnClick:'Grid.Cols.GANTT.GanttZoomFit = Grid.Cols.GANTT.GanttZoomFit==1 ? 2 : 0; Grid.ActionZoomFit();',
      FitTip:'Chooses zoom level to show all the Gantt objects in one window',FitCanPrint:"0",

      MaxType:'Button', MaxWidth:'85', MaxButtonText:'<b>Zoom</b> <b style="color:blue;">fit max</b>', MaxButton:'Button',
      MaxOnClick:'Grid.Cols.GANTT.GanttZoomFit = 1; Grid.ActionZoomFit();',
      MaxTip:'Chooses zoom level to show all the Gantt objects in one window.<br>Maximizes the place for the Gantt chart by shrinking the columns section.', MaxCanPrint:"0",
       
      ExLabel:"<b style='color:blue;'>Holidays</b>", ExWidth:"50", ExLeft:"2", ExPrintHPage:"2",
      ExType:"Select", ExOnClickSideDefaults:"Grid.ShowGanttCalendars(Row,Col)",
      ExFormula:"Grid.Cols.GANTT.GanttExclude", 
      ExOnChange:"Grid.ChangeExclude(Value);", ExUndo:"1",
      ExTip:"Global calendar for the whole project",

      HidExType:'Bool', HidExLeft:'5', HidExCanFocus:'0', HidExPrintHPage:"2",
      HidExLabelRight:'Hide holidays',
      HidExFormula:'Grid.Cols.GANTT.GanttHideExclude',
      HidExOnChange:'Grid.SetHideExclude(Value)',
      HidExCanEditFormula:'gantthasexclude()!=0',
      HidExTip:'Hides dates excluded by the global calendar',

      CalType:'Bool', CalLeft:'5', CalCanFocus:'0', CalCanEdit:'1', CalPrintHPage:"2",
      CalLabelRight:'Custom calendars',
      CalFormula:'Grid.Cols.GANTT.GanttCalendar?1:0',
      CalOnChange:'Grid.ChangeExclude(Value?"CALENDAR":"","GanttCalendar"); if(Value) Grid.ShowCol("CALENDAR"); else Grid.HideCol("CALENDAR");',
      CalTip:'Permits custom calendars for individual tasks',

      BarType:'Bool', BarLeft:'5', BarCanFocus:'0', BarCanEdit:'1', BarPrintHPage:"3",
      BarLabelRight:'Low bars',
      BarFormula:'Grid.Cols.GANTT.GanttHeight?1:0',
      BarOnChange:'Grid.Cols.GANTT.GanttHeight = Value ? 4 : ""; Grid.Cols.GANTT.GanttTop1 = Value ? 9 : 4; Grid.RefreshGantt();',
      BarTip:'Demonstrates changing bar heights and vertical positions'
      },

   // Defines the second top toolbar with Start date, Finish date, Progress date, critical path and dependency violation checking and configuration button
   {  Kind:"Topbar2", id:'Project', Space:'0', Panel:'0', Cells:'Base,Finish,Progress,Crit,Dep,Cfg', CanPrint:'5', NoUpload:"0",
            
      BaseType:'Date', BaseCanEdit:'1', BaseWidth:'100', BaseUndo:'1', BaseLeft:'2', BasePrintHPage:'1',
      BaseLabel:'Start',
      BaseFormat:"ddd M/d/yyyy, '<span style=\";color:blue\";>'HH'</span>'",
      BaseEditFormat:'M/d/yyyy HH',
      BaseFormula:'Grid.GetGanttBase()',
      BaseOnChange:'Grid.SetGanttBase(Value,2);',
      BaseHtmlPrefixFormula:'Grid.Cols.GANTT.GanttBase==""?"<span style=\'color:gray;\'>":"<span>"',
      BaseHtmlPostfix:'</span>',
      BaseTip:'Starting date of the whole project.<br>If grayed, it is calculated from the first task.<br>No task should start before it.<br>It is also used when correcting dependencies.',
              
      FinishType:'Date', FinishCanEdit:'1', FinishWidth:'100', FinishUndo:'1', FinishLeft:'2', FinishPrintHPage:'1',
      FinishLabel:'Finish',
      FinishFormat:"ddd M/d/yyyy, '<span style=\";color:blue\";>'HH'</span>&nbsp;'",
      FinishEditFormat:'M/d/yyyy HH',
      FinishFormula:'Grid.GetGanttFinish()',
      FinishOnChange:'Grid.SetGanttFinish(Value);',
      FinishHtmlPrefixFormula:'Grid.Cols.GANTT.GanttFinish==""?"<span style=\'color:gray;\'>":"<span>"',
      FinishHtmlPostfix:'</span>',
      FinishTip:'Finish date of the whole project.<br>If grayed, it is calculated from the last task.<br>It is used to calculate critical path.',    

      ProgressType:'Date', ProgressCanEdit:'1', ProgressWidth:'100', ProgressUndo:'1', ProgressLeft:'2', ProgressPrintHPage:'2',
      Progress:'5/23/2008 18:00',
      ProgressLabel:'Progress',
      ProgressFormat:"ddd M/d/yyyy, '<span style=\";color:blue\";>'HH'</span>&nbsp;'",
      ProgressEditFormat:'M/d/yyyy HH',
      ProgressOnChange:'Grid.SetGanttLine(1,Value);Grid.Calculate(1)',
      ProgressTip:'Progress line connects incomplete tasks before the progress date<br> It is possible to have more such lines in chart, even with different meaning',     

      CritType:'Bool', CritCanEdit:'1', CritLeft:'2', CritCanFocus:'0', CritPrintHPage:'2',
      CritLabelRight:'Show <b style="color:blue;">critical path</b>',
      CritOnChange:'Grid.SetFilter("Crit",Value?"SLACK!==\'\' && SLACK<=Grid.Cols.GANTT.GanttMinSlack && COMPLETE!=100":"")',
      CritTip:'Show only critical tasks, all other rows will be hidden',
              
      DepType:'Select', DepCanPrint:'0',
      DepDefaults:'|Manual schedule|Auto schedule|Ask for auto schedule',
      DepFormula:'Grid.GetDefaultsValue(Row,Col,Grid.Cols.GANTT.GanttCorrectDependencies)',
      DepOnChange:'var v=Grid.GetDefaultsIndex(Row,Col,Value);Grid.Cols.GANTT.GanttCorrectDependencies=v;Grid.Cols.GANTT.GanttCheckExclude=v;Grid.SaveCfg();',
      DepTip:'If the dependent tasks will automatically be scheduled after some task is moved or resized',
      DepWidth:'110',
      DepLeft:'5',
        
      CfgType:'Button', CfgWidth:'100', CfgButtonText:'Change <b>settings</b>', CfgButton:'Button', CfgCanPrint:"0",
      CfgLeft:'10', CfgOnClick:'ShowCfg',
      CfgTip:'Shows global dialog to change Gantt settings'
      },

   // Defines the middle toolbar for editing, by default shown on tablet
   { Kind:"Toolbar", id:'Tablet', Space:'1', Visible:'0', Cells:'Right,Objects,All,Main,Main1,Flags,Dependency,Constraints,Bounds,None,Sep,Actions,Every,Move,Resize,New,End',
         
      RightRelWidth:'1', RightType:'Html', RightCanFocus:'0',

      Objects:'<b>Change object:</b>', ObjectsType:'Html', ObjectsCanFocus:'0', ObjectsWrap:'0',
      AllButtonText:'All', AllRadio:'1', AllOnChange:'UpdateActions()', AllWidth:'30',
      MainButtonText:'Task', MainRadio:'1', MainOnChange:'UpdateActions()', Main:'1', MainWidth:'35',
      Main1ButtonText:'Task 1', Main1Radio:'1', Main1OnChange:'UpdateActions()', Main1Width:'40',
      FlagsButtonText:'Flag', FlagsRadio:'1', FlagsOnChange:'UpdateActions()', FlagsWidth:'30',
      DependencyButtonText:'Dependency', DependencyRadio:'1', DependencyOnChange:'UpdateActions()', DependencyWidth:'75',
      ConstraintsButtonText:'Constraint', ConstraintsRadio:'1', ConstraintsOnChange:'UpdateActions()', ConstraintsWidth:'65',
      BoundsButtonText:'Vertical lines', BoundsRadio:'1', BoundsOnChange:'UpdateActions()', BoundsWidth:'80',
      NoneButtonText:'None', NoneRadio:'1', NoneOnChange:'UpdateActions()', NoneWidth:'35',

      SepType:'Html', SepWidth:'20', SepCanFocus:'0',

      Actions:'<b>Do action:</b>', ActionsType:'Html', ActionsCanFocus:'0', ActionsWrap:'0', ActionsNoColor:'1',
      EveryButtonText:'All', EveryRadio:'2', Every:'1', EveryOnChange:'UpdateActions()', EveryWidth:'30',
      MoveButtonText:'Move', MoveRadio:'2', MoveOnChange:'UpdateActions()', MoveWidth:'40',
      ResizeButtonText:'Resize', ResizeRadio:'2', ResizeOnChange:'UpdateActions()', ResizeWidth:'40',
      NewButtonText:'Create', NewRadio:'2', NewOnChange:'UpdateActions()', NewWidth:'40',
      EndType:'Html', EndWidth:'10', EndCanFocus:'0'
      },

   // Defines the first bottom toolbar with resources filters, resource charts, columns combo, single edit checkbox and incorrect dependencies info
   {  Kind:"Toolbar1", id:"Controls", Space:'4', Cells:'Resources,Chart,Cols,Single,Empty,Dep', Panel:'0', CanPrint:'5', NoUpload:"0",
      ResourcesType:'SelectGanttResources',
      ResourcesHtmlPrefix:'<b>Show tasks with <span style="color:blue;">', ResourcesHtmlPostfix:'</span></b>',
      ResourcesEmptyValue:'all resources',
      ResourcesLeft:'2',
      ResourcesWidth:'200',
      ResourcesPrintHPage:'1',
      ResourcesTip:'Shows only rows containing selected resources',

      ChartType:'Select', ChartCanPrint:'5', ChartRange:'1',
      ChartDefaults:'{Items:[{Name:"Default",Value:"Used;Available",Bool:0},{Name:"*All"},{Name:"*None"},{Name:"-"},{Name:"Used"},{Name:"Available"},{Name:"Free"},{Name:"Errors"}]}',
      Chart:'Used;Available',
      ChartEmptyValue:'none',
      ChartHtmlPrefix:'<b>Show resource charts <span style="color:blue;">', ChartHtmlPostfix:'</span></b>',
      ChartOnChange:'var v = Value?Value:""; Grid.Def.Resource.GANTTGanttAvailability = (v.indexOf("Available")>=0?",SECTION#3#R":"") + (v.indexOf("Used")>=0?",SECTION#1#R":"") + (v.indexOf("Available")>=0&&v.indexOf("Used")>=0?",SECTION#8#R":"") + (v.indexOf("Free")>=0?",SECTION#5#R":"") + (v.indexOf("Errors")>=0?",SECTION#6#R":""); if(!v||v&&!Grid.GetRowById(-2).Visible) { var F = Grid.GetRows(Grid.Foot); Grid.StartUpdate(); for(var i=0;i<F.length;i++) if(v) Grid.ShowRow(F[i]); else Grid.HideRow(F[i]); Grid.EndUpdate(); } else Grid.RefreshGantt();',
      ChartTip:'Select which resource charts in grid bottom will be shown',
      ChartWidth:'200',
      ChartPrintHPage:'1',
      ChartLeft:'5',

      ColsType:'Select', ColsCanPrint:'5', ColsRange:'1',
      ColsDefaults:'{Items:[{Name:"Default",Value:"Name;Tasks;Dependencies;Calendar;Gantt",Bool:0},{Name:"*All"},{Name:"Gantt only",Value:"Gantt",Bool:0},{Name:"*None"},{Name:"-"},{Name:"Name"},{Name:"Tasks"},{Name:"Tasks 1"},{Name:"Dependencies"},{Name:"Flags"},{Name:"Constraints"},{Name:"Calendar"},{Name:"Resources"},{Name:"Texts"},{Name:"Slack"},{Name:"-"},{Name:"Gantt"},{Name:"-"},{Name:"Choose individual columns",Bool:0,OnClick:function(){Grids.Gantt.ActionShowColumns(); return true; }}]}',
      Cols:'Name;Tasks;Dependencies;Calendar;Gantt',
      ColsEmptyValue:'none',
      ColsHtmlPrefix:'<b>Show columns <span style="color:blue;">', ColsHtmlPostfix:'</span></b>',
      ColsOnChange:'var G = {Name:["Panel","SECTION"], Tasks:["START","END","COMPLETE","DURATION","CLASS","TEXT"], "Tasks 1":["START1","END1","DURATION1","PARTS1","CLASS1","TEXT1"],Dependencies:["DESCENDANTS","ANCESTORS"], Flags:["FLAGS","FLAGSTEXT"], Constraints:["MINSTART","MINEND","MAXSTART","MAXEND"],Calendar:["CALENDAR"], Resources: ["RESOURCES","PRICE"], Texts:["TEXT","TEXT1","FLAGSTEXT"], Slack:["SLACK"], Gantt:["GANTT"] }; var S = ["id"], H = ["PROGRESS"], v = Value?Value:""; if(Grid.Cols.TASK.Visible) S = S.concat("TASK"); else H = H.concat("TASK"); for(var g in G) if(v.indexOf(g)>=0) S = S.concat(G[g]); else H = H.concat(G[g]); Grid.ChangeColsVisibility(S,H,1);',
      ColsTip:'Select column groups to show<br>To show or hide particular columns use Columns menu on bottom toolbar',
      ColsWidth:'200',
      ColsPrintHPage:'2',
      ColsLeft:'5',
         
      SingleType:'Bool', SingleCanEdit:'1', SingleLeft:'2', SingleCanFocus:'0', SingleCanPrint:'0',
      SingleLabelRight:'Single edit', SingleFormula:'Grid.GetRowById("Tablet").Visible',
      SingleOnChange:'if(Value) Grid.ShowRow(Grid.GetRowById("Tablet")); else Grid.HideRow(Grid.GetRowById("Tablet")); UpdateActions(); ',
      SingleTip:'Show the toolbar row to choose individual objects and editing actions<br>Useful especially for controlling Gantt chart by single finger on touch screen',
    

      EmptyRelWidth:"1", EmptyType:"Html", EmptyPrintHPage:'1', EmptyCanFocus:'0',
      DepFormula:"ganttdependencyerrors(null,1)", DepOnClick:"CorrectAllDependencies", DepTip:"Click to correct the dependencies", DepPrintHPage:'2'
      }

   ],
   
// Bottom rows
Foot: [

   // Bottom summary row for all tasks
   {  id:'Summary', Def:'Sum', // The summary uses default for task summaries
      CalcOrder:"idHtmlPostfix,START,END,DURATION,COMPLETE,PARTS1,START1,END1,DURATION1,PRICE,PROGRESS", // The CalcOrder from default Sum is redefined, because the name is shown in id instead of SECTION
      Spanned:'1', idVisible:'1', idSpan:'3', idType:'Text', idHtmlPostfixFormula:"' <span style=\"color:green;\">('+count(4)+')</span>'" // id column shows the Summary and the task count, spanned through TASK and SECTION
      },

   // Column captions for resources
   {  Kind:"Header", id:'Resource', idTip:'Resource name. By this name is the resource assigned to the individual tasks',
      SortIcons:'0', // This header does not provide sorting, because it is for fixed rows
      CanPrint:'1', // This header is printed only once
      Spanned:'1', idSpan:'3', // Shows the resource name and spans it through id, TASK and SECTION
      GANTTOnClick:'ZoomIn', GANTTOnRightClick:'ZoomOut', // Specifies actions for click to the header
      START:'Unit price', STARTTip:'Price for one resource unit in USD',
      END:'Availability', ENDTip:'Amount of available resource units per dates',
      DURATION:'Peak', DURATIONTip:'Maximal used resource units at one time in the whole Gantt chart',
      COMPLETE:'Type', COMPLETETip:'Type of the resource consuming, work or material',
      DESCENDANTS:'Total', DESCENDANTSTip:'Amount of all resource units used by all tasks',
      ANCESTORS:'Price', ANCESTORSTip:'Price for all used resource units in the whole chart',
      GANTT:'Resources usage', GANTTTip:'Resource usage chart&lt;br>Click to zoom in, right click to zoom out&lt;br>Control the displed charts in bottom combo "Show resource charts"',
      CLASS:'', MINSTART:'', MAXSTART:'', MINEND:'', MAXEND:'', TEXT:'', START1:'', END1:'', DURATION1:'', PARTS1:'', TEXT1:'', CLASS1:'', CALENDAR:'', SLACK:'', RESOURCES:'', PRICE:'', FLAGS:'', FLAGSTEXT:'', PROGRESS:'', DISABLED:'' // All other resource cells have no meaning and are empty
      },

   // Fixed bottom rows with resource usage charts, one row per resource, the row id is assigned to resource Name
   {  id:"Support", Def:"Resource" },
   {  id:"Sales", Def:"Resource" },
   {  id:"Management", Def:"Resource" },
   {  id:"Development", Def:"Resource" },
   {  id:"Material", Def:"Resource", Height:"40" }

   ],
   
// Resources definition
Resources: [
   {  Name:"Sales", Price:"20", Type:"1", Availability:"3" },
   {  Name:"Support", Price:"30", Type:"1", Availability:"5" },
   {  Name:"Management", Price:"37", Type:"1", Availability:"w#1/4/2011~1/7/2011#1" },
   {  Name:"Development", Price:"40", Type:"1", Availability:"20;5/26/2008~6/7/2008#-8" },
   {  Name:"Material", Price:"1", Type:"2", Availability:"15;w#5/20/2008~6/4/2008#20" }
   ],
   
   
 
Lang: {
   // --- Colors the separators to be better visible, there must be also set Cfg NoFormatEscape for it ---
   Format : {
      ValueSeparatorHtml:"<b style='color:red;'>; </b>",
      RangeSeparatorHtml:"<b style='color:red;'> ~ </b>"
      }
   },

// --- Defines the second toolbar as standard TreeGrid toolbar ---
Toolbar: {   
   Kind:"Toolbar2", Indent:"0", Outdent:"0" // Hides the Indent / Outdent buttons, because the tree structure is fixed in this example
   }
} 

) // End of JSONP header