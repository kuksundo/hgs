<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%
/*-----------------------------------------------------------------------------------------------------------------
! Support file only, run Grid.html instead !
  This file is used as Layout_Url for TreeGrid
  It generates layout structure for TreeGrid from database
------------------------------------------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Database connection ---
java.sql.Statement Cmd = getHsqlStatement(request,out,"../Database","sa","");

// --- Generating layout ---
java.sql.ResultSet R = Cmd.executeQuery("SELECT MIN(Week),MAX(Week) FROM TableData WHERE Week>0 AND Week<53");
R.next();
   
int Min = R.getInt(1);
int Max = R.getInt(2);
String Cols="", CSum="", DRes="", DDef="";
for(int i=Min;i<=Max;i++) {
   String Week = "W" + String.valueOf(i);
   Cols += "<C Name='" + Week + "' Type='Float'/>"; // Column definitions
   if (CSum.length()>0) CSum += "+";
   CSum += Week;                                   // Right fixed result column formula
   DRes += Week + "Formula='sum()' ";              // Tree result row formulas
   DDef += Week + "='0' ";                         // Default values for data rows
   }
// --------------------------------------------------------------------------
%><?xml version="1.0"?>
<Grid>
   <Cfg id='ResourceGrid' MainCol='Project' MaxHeight='1' ShowDeleted="0" DateStrings='1' 
      IdNames='Project' AppendId='1' FullId='1' IdChars='0123456789' NumberId='1' LastId='1' CaseSensitiveId='1'/>
   <LeftCols>
      <C Name='id' CanEdit='0'/>
      <C Name='Project' Width='250' Type='Text'/>
   </LeftCols>
   <Cols><%=Cols%>
   </Cols>
   <RightCols>
      <C Name='Sum' Width='50' Type='Float' Formula='<%=CSum%>' Format='0.##'/>
   </RightCols>
   <Def>
      <D Name='R' Project='New resource' CDef='' AcceptDef='' <%=DDef%>/>
      <D Name='Node' Project='New project' CDef='R' AcceptDef='R' Calculated='1' SumFormula='sum()' <%=DRes%> ProjectHtmlPrefix='&lt;B>' ProjectHtmlPostfix='&lt;/B>'/>
   </Def>
   <Root CDef='Node' AcceptDef='Node'/>
   <Header id='id (debug)' Project='Project / resource'/>
   <Foot>
      <I Kind='Space' RelHeight='100'/>
      <I Def='Node' Project='Total results' ProjectCanEdit='0'/>
   </Foot>
</Grid>

