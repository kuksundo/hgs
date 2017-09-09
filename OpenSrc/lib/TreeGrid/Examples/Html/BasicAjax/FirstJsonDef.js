TreeGridLoaded ( // JSONP header, to be possible to load from xxx_Jsonp data source

{
   Cfg : {
      id:'First', SuppressCfg:1,  // Configuration is not saved to cookies
      MainCol:'A',                // Shows tree in column 'A'
      ConstHeight:1,              // Grid will always fill its main tag
      UpCounter:'Pos',            // Adds up-counter column named 'Pos' that displays visible row position
      ReloadChanged:1,            // Grid can reload and automatically discard pending changes
      Undo:1,                     // Undo / redo is supported, Ctrl+Z / Ctrl+Y
      SuppressMessage:2,          // Grid produces no informational message
      Sort:'A',                   // Grid is sorted according to column A by default
      ResizingMain:2,             // User can resize grid main tag horizontally
      MaxHeight:1,                // Resizes / maximizes the grid main tag to fill the whole page
                                  // Set the MaxHeight='0' if you face 'Too small grid size' error message!
      SearchDefs:'Node', SearchCells:1, SearchExpression:'"Peter Orwell" OR "Janet Scheel"', SearchAction:'Select', // Default Search setting
      ExportType:'Expanded,Outline',   // Export setting, all rows will be exported expanded and will be used Excel outline
      ChildParts:0,               // Rendering children on background is disabled
      CalculateSelected:1,        // Recalculates rows after selection changed
      PrintPagePostfix:'<center style="width:%7px">Page %1 horizontally from %4 , page %2 vertically from %5</center>', 
      PrintPagePrefix:'<center style="width:%7px">Printed page %3 from %6</center>',  // Sample page header and footer
      PrintPaddingHeight:60, PrintPaddingWidth:3, // Reserved space for PrintPagePrefix / Postfix a and for default body margin and padding
      PrintPaddingHeightFirst:90  // Reserved space for sample header printed only to the first page
      },
   // --- Default rows definition ---
   Def : [
      // --- Data rows without children ---
      { 
         Name:'Data', CalcOrder:'F,B', CDef:'', AcceptDef:'',
         A:'Item', ASuggest:'|*RowsDef', XType:'Text', XCanEdit:0, XCanFilter:0, 
         CCanFilter:0, G:0, H:0, I:'', ICanFilter:0
         },
      
      // --- Order rows with children ---
      { 
         Name:'Node', CDef:'Data', AcceptDef:'Data', Expanded:0, Calculated:1, CalcOrder:'D,F,B', CanFilter:3,
         X:1, A:'Order', ACanFilter:0,
         BFormula:'F-F*G/100+H', BCanFilter:0,
         CCanEdit:1, CCanFilter:1, CButton:'Defaults', 
         CDefaults:'{ShowCursor:0,Items:[{Name:"*RowsVisibleDef"},"-",{Name:"All",Text:"<b>All customers</b>",Menu:1,MinHeight:200,Items:"|*RowsAllDef"}]}',
         TVisible:0, TCanEdit:0, TCanFilter:0,
         DType:'Enum', DFormula:'count()', DCanFilter:0, DAlign:'Right', DEnum:'|empty|1 item&#160;&#160;', DIntFormat:'0 "items"',
         EVisible:0, ECanEdit:0, ECanFilter:0,
         FFormula:'sum("B")', FCanFilter:0,
         G:0, GCanFilter:0,
         H:0, HCanFilter:0,
         ICanEdit:1, ICanFilter:1
         },

      //--- Footer summary rows ---
      { Name:'Foot', CalcOrder:'D,B', XVisible:0, EVisible:0, FVisible:0, HVisible:0, IVisible:0, TVisible:0 },

      // --- Row created when grouping rows ---
      { 
         Name:'Group', Def:'Node', CanSelect:0, AggChildren:1, CanFilter:2,
         XVisible:0,
         ACanEdit:1,
         CVisible:0, CCanEdit:0, CButton:'None', 
         IVisible:0, ICanEdit:0,
         BFormula:'sum("X==1")',
         DFormula:'count("X==1")', DEnum:'|no order|1 order&#160;&#160;', DIntFormat:'0 "orders"'
         }
      ],

   // --- Column definition ---
   LeftCols : [
      { Name:'X', Width:35, Type:'Bool', CanFilter:2, CanSort:0 }, // Used
      { Name:'A', PrintWidth:300, RelWidth:100, MinWidth:250, Type:'Text', ToolTip:1, CanFilter:2, SearchNames:'Product name,Product,Order name,Order' } // Product / Order name
      ],
   Cols: [
      { Name:'C', Width:100, Type:'Text', CanEdit:0, CanFilter:2 }, // Customer
      { Name:'I', Width:90, Type:'Date', Format:'d', CanEdit:0, CanFilter:2 }, // Date
      { Name:'T', Width:60, Type:'Enum', Enum:'|Comp|Access|Mon|Print|Soft', CanFilter:2 }, // Kind
      { Name:'D', Width:80, Type:'Int', CanFilter:2 }, // Amount
      { Name:'E', Width:80, Type:'Float', EditMask:'^\\-?\\d*\\.?\\d*$', Format:'0.00', CanFilter:2, CanGroup:0 }, // Unit price
      { Name:'F', Width:80, Type:'Float', Format:'0.00', Formula:'D*E', CanFilter:'2' }, // List price
      { Name:'G', Width:80, Type:'Int', Format:'0\\%', CanFilter:2 } ,// Discount
      { Name:'H', Width:80, Type:'Float', Format:'0.00', CanFilter:2 } // Shipping
      ],
   RightCols : [
      { Name:'B', Width:80, Type:'Float', Format:'0.00', Formula:'F-F*G/100+H', CanFilter:2 } // Price
      ],

   // --- Parent of root nodes, accepts only Node rows ---
   Root: { CDef:'Node', AcceptDef:'Node' },
	
   // --- Column captions ---
   Header : {
      X:"Used", A:"Product / Order name", ALevels:1, 
      C:"Customer", I:"Date", T:"Kind", D:"Amount", E:"Unit Price", F:"List Price", G:"Discount", H:"Shipping",
      B:"Price"
      },

   Head : [
      // --- Filter row ---
      { 
         Kind:'Filter', id:'Filter', NoColorState:1,
         XCanEdit:1, XType:'Bool',
         ASuggest:'|*RowsCanFilter',    
         CButton:'Defaults', CDefaults:'{Position:{Align:"below center"},Items:[{Name:"*FilterOff"},"-",{Columns:3,Items:"|*RowsAllCanFilter"}]}', CShowMenu:0, CRange:1,
         IRange:1, IShowMenu:0, IDefaultDate:"6/1/2005",
         B:500, BFilter:3
         }
      ],

   Solid : [
      // --- Top tabber ---
      { 
         Kind:"Tabber", id:"Tabber", Cells:"All,Y5,Y6,Y7,Y8,Y9,Cnt,Sel,Add,Del,Chg", Width:38, CanFocus:0, CanPrint:0,
         AllButtonText:"All", Y5ButtonText:"2005", Y6ButtonText:"2006", Y7ButtonText:"2007", Y8ButtonText:"2008", Y9ButtonText:"2009",
         AllOnClick:"Grid.SetFilter('Year','');",
         Y5OnClick:"Grid.FilterDateRange('I','1/1/2005~12/31/2005','Year');", Y5:"1",
         Y6OnClick:"Grid.FilterDateRange('I','1/1/2006~12/31/2006','Year');",
         Y7OnClick:"Grid.FilterDateRange('I','1/1/2007~12/31/2007','Year');",
         Y8OnClick:"Grid.FilterDateRange('I','1/1/2008~12/31/2008','Year');",
         Y9OnClick:"Grid.FilterDateRange('I','1/1/2009~12/31/2009','Year');",
         CntRelWidth:1, CntType:"Html", CntFormula:'"Rows:<b>"+count(7)+"</b>&#160;&#160;shown:<b>"+count(6)+"</b>"', CntAlign:"Right",
         SelType:"Html", SelFormula:'var cnt=count(15);return cnt?"selected:<b>"+cnt+"</b>":""', SelWidth:-1, SelWrap:0,
         AddType:"Html", AddFormula:'var cnt=count("Row.Added==1",7);return cnt?"added:<b>"+cnt+"</b>":""', AddWidth:-1, AddWrap:0,
         DelType:"Html", DelFormula:'var cnt=count("Row.Deleted==1",7);return cnt?"deleted:<b>"+cnt+"</b>":""', DelWidth:-1, DelWrap:0,
         ChgType:"Html", ChgFormula:'var cnt=count("Row.Changed==1",7);return cnt?"changed:<b>"+cnt+"</b>":""', ChgWidth:-1, ChgWrap:0,
         CanPrint:5, AllPrintHPage:1, Y5PrintHPage:1, Y6PrintHPage:1, Y7PrintHPage:1, Y8PrintHPage:1, Y9PrintHPage:1,
         CntPrintHPage:2, SelPrintHPage:2, AddPrintHPage:2, DelPrintHPage:2, ChgPrintHPage:2
         },
         
      // --- Group and special filter settings ---
      { 
         Kind:"Group", Space:1, Panel:1, id:'Group', CanFocus:0, Cells:'List,Custom,Month,Cust,Rev',
             
         List:'|Group by <span style="color:blue;">none</span>|Group by <span style="color:blue;">Customer</span>|Group by <span style="color:blue;">Date</span>|Group by <span style="color:blue;">Customer -> Date</span>|Group by <span style="color:blue;">Date -> Customer</span>',
         ListCustom:'<span style="color:red;">Custom grouping</span>',
         ListWidth:160,
         Cols:'||C|I|C,I|I,C',
         Custom:1,

         MonthLabel:'Filter&#160;orders&#160;from',
         MonthType:'Select',
			MonthDefaults:'|all&#160;months|January|February|March|April|May|<b>June</b>|<b>July</b>|August|September|October|November|December',
         Month:'all&#160;months',
         MonthWidth:80,
         MonthOnChange:"var idx=Grid.GetDefaultsIndex(Row,Col); Grid.SetFilter('Month',idx==0?'':'(new Date(I)).getMonth()=='+(idx-1),'I');",

         CustLeft:5,
         CustType:'Select',
         CustDefaults:'|all&#160;customers|personal&#160;cust.|limited&#160;cust.|corporate&#160;cust.',
         CustOnChange:"var idx=Grid.GetDefaultsIndex(Row,Col); Grid.SetFilter('Cust',idx==0?'':'Row.C.search('+['',/(Inc\.)|(Ltd\.)/,/Ltd\./,/Inc\./][idx]+(idx==1?')<0':')>=0'),'I');",

         Cust:'all&#160;customers',

         RevLeft:'5', RevType:"Bool", RevLabelRight:"Reversed tree", RevCanEdit:"1", RevFormula:"Grid.ReversedTree?1:0", RevOnChange:"Grid.SetReversedTree(Value);",

         CanPrint:5, ListPrintHPage:1, CustomPrintHPage:1, MonthPrintHPage:2, CustPrintHPage:2
         },
         
      // --- Search settings ---
      { 
         Kind:"Search", Space:1, Panel:1, id:'Search', CanFocus:0,
         Cells:'Defs,Case,Type,Expression,Sep1,Filter,Select,Mark,Find,Clear,Help,Sep2',
         ExpressionAction:'Last', ExpressionNoColor:0, ExpressionCanFocus:1, ExpressionLeft:'5', ExpressionMinWidth:'50',
         ExpressionEmptyValue:'<i style="color:#AAAAAA">Enter keywords to search for</i>',
         DefsDefaults:'|orders|products|orders&#160;with&#160;product',
         DefsDefs:'|Node|Data|',
         DefsLabel:'Search&#160;in',
         CaseLeft:5, CaseLabelRight:"case&#160;sensitive",
         TypeLeft:5, TypeLabelRight:"individual&#160;cells",
         Sep1Width:5, Sep1Type:"Html",
         Sep2Width:5, Sep2Type:"Html",

         CanPrint:5, DefsPrintHPage:1, CasePrintHPage:1, TypePrintHPage:1,
         ExpressionPrintHPage:2, Sep1PrintHPage:2, FilterPrintHPage:2, SelectPrintHPage:2, MarkPrintHPage:2, FindPrintHPage:2, ClearCanPrint:0, HelpCanPrint:0, Sep2PrintHPage:2
         }
      ],
   
   // --- Summary footer rows ---
   Foot: [
      { 
         Def:'Foot', id:'Fix1', CanDelete:0, CanEdit:0, Calculated:1,
         A:"Total income",
         BFormula:'sum("X==1")',
         DFormula:'count("X==1")', DType:'Enum', DAlign:'Right', DEnum:'|no order|1 order&#160;#160;', DIntFormat:'0 "orders"',
         GVisible:0
         },
      { 
         Def:'Foot', id:'Fix2', CanDelete:0, CanEdit:0, Calculated:1,
         A:"Taxes",
         BFormula:'-Get(Fix1,"B")*G/100',
         DVisible:0,
         G:22, GCanEdit:1
         },
      { 
         Def:'Foot', id:'Fix3', CanDelete:0, CanEdit:0, Calculated:1,
         A:"Profit",
         BFormula:'Get(Fix1,"B")+Get(Fix2,"B")', BHtmlPrefix:"<b>", BHtmlPostfix:"</b>",
         DVisible:0,
         GVisible:0
         }
      ],
   
   // --- Bottom toolbar formula ---
   Toolbar: { Formula:'count("X==1")+" / "+count(1)+" orders"', Indent:0, Outdent:0 }
   }

) // End of JSONP header