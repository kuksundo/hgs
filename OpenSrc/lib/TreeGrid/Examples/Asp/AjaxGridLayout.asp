<%
'! Support file only, run AjaxGrid.html instead !
' This file is used as Layout_Url for TreeGrid
' It generates layout structure for TreeGrid from database
' --------------------------------------------------------------------------

' --- Response initialization ---
Session.Codepage=65001
Response.ContentType = "text/xml"
Response.Charset= "utf-8"
Response.AddHeader "Cache-Control","max-age=1, must-revalidate"
SetLocale "en-us"

' --- Databaze initialization ---
Dim Path
Path = Request.ServerVariables("PATH_TRANSLATED")
Path = Left(Path,InStrRev(Path,"\"))
Dim DB
Set DB = Server.CreateObject("ADODB.Connection")
DB.Open "DRIVER={Microsoft Access Driver (*.mdb)};DBQ="&Path&"Database.mdb"    'Database file has relative path to this page
Dim RS
Set RS = Server.CreateObject("ADODB.Recordset")

' --- Generating layout ---
RS.Open "SELECT MIN(Week),MAX(Week) FROM TableData WHERE Week>0 AND Week<53", DB, 1, 3, 1
Dim Min,Max
Min = RS.Fields(0).Value
Max = RS.Fields(1).Value

Dim Cols,CSum,DRes,DDef,Week
Cols="" : CSum="" : DRes="" : DDef=""

For i=Min To Max 
Week = "W" & CStr(i)
Cols = Cols & "<C Name='" & Week & "' Type='Float'/>"   ' Column definitions
If CSum<>"" Then CSum = CSum & "+"
CSum = CSum & Week                                 ' Right fixed result column formula
DRes = DRes & Week & "Formula='sum()' "            ' Tree result row formulas
DDef = DDef & Week & "='0' "                       ' Default values for data rows
Next
' --------------------------------------------------------------------------
%><?xml version="1.0"?>
<Grid>
   <Cfg id='ResourceGrid' MainCol='Project' MaxHeight='1' ShowDeleted="0" DateStrings='1' 
      IdNames='Project' AppendId='1' FullId='1' IdChars='0123456789' NumberId='1' LastId='1'/>
   <LeftCols>
      <C Name='id' CanEdit='0'/>
      <C Name='Project' Width='250' Type='Text'/>
   </LeftCols>
   <Cols><%=Cols%>
   </Cols>
   <RightCols>
      <C Name='Sum' Width='50' Type='Float' Formula='<%=CSum%>'/>
   </RightCols>
   <Def>
      <D Name='R' Project='New resource' CDef='' AcceptDef='' <%=DDef%>/>
      <D Name='Node' Project='New project' CDef='R' AcceptDef='R' Calculated='1' SumFormula='sum()' <%=DRes%> ProjectHtmlPrefix='&lt;B>' ProjectHtmlPostfix='&lt;/B>'/>
   </Def>
   <Root CDef='Node' AcceptDef='Node' />
   <Header id='id (debug)' Project='Project / resource'/>
   <Foot>
      <I Kind='Space' RelHeight='100'/>
      <I Def='Node' Project='Total results' ProjectCanEdit='0'/>
   </Foot>
</Grid>