<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%!
/*-----------------------------------------------------------------------------------------------------------------
! Support file only, run Grouping.html instead !
  This file is used as Page_Url
  Generates data for one TreeGrid page from database, according to grouping information
! Demonstrates Server paging but client child paging - all children are sent to server at once
  This is only simple example with not ideal database access (for every page gets all data)
  Single file, without using TreeGridFramework.asp
  -------------------------------------------------------------------------------------------------------------------------------*/

// ------------------------------------------------------------------------------------------------------------------------------- 
// Writes one level of grouped children
// Uses recursion to write next levels
// Level is actual level to write
// Where is WHERE clause for SQL, for every level there is added one condition
void WriteLevel(int Level, String Where, String[] GroupCols, java.sql.Statement[] Cmd, int Levels, int Start, JspWriter out) throws Exception
{
   java.sql.ResultSet R;
   if (Level == Levels) R = Cmd[Level].executeQuery("SELECT * FROM TableData" + Where);
   else R = Cmd[Level].executeQuery("SELECT DISTINCT " + GroupCols[Level] + " FROM TableData" + Where);
   if (Level == 0) for (int i = 0; i < Start && R.next(); i++) ; // On level 0 throws away data in front of requested page
   int Max = 20; // 21 rows per page on level 0
   while(R.next())
   {
      if (Level == Levels)    // Final, writing data row
      {
         String[] Names = {"id","Project","Resource","Week","Hours"}; 
         out.print(getRowXML(R,Names));
      }
      else                    // Next grouping row
      {
         out.print("<I Def='Group' Project=" + toXML(R.getString(1)) + ">"); // writes the grouping row
         String Where2 = (Level == 0 ? " WHERE " : " AND ") + GroupCols[Level] + "=" 
                 + (GroupCols[Level].equals("Week") || GroupCols[Level].equals("Hours") ? R.getString(1) : toSQL(R.getString(1)));
         WriteLevel(Level + 1, Where + Where2, GroupCols, Cmd, Levels, 0,out);
         out.print("</I>");
      }
      if(Level==0 && --Max<0) break; // On level 0 maximally 21 rows per page
   }
   R.close();
}
// -------------------------------------------------------------------------------------------------------------------------------
%><%
//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Parses XML request ---
String XML = request.getParameter("TGData"); // was set <bdo ... Data_Data="TGData" ...>
if (XML==null) XML = "<Grid><Cfg GroupCols='Resource'/><Body><B Pos='2'/></Body></Grid>"; // Just for examples if called directly
org.w3c.dom.Document X = parseXML(XML);

// --- Parses grouping settings ---
String[] GroupCols = getGroupCols(X);
int Levels = GroupCols == null ? 0 : GroupCols.length; // Depth of grouping, 0 - no grouping

// --- Gets information about page number ---
int pos = getPagePos(X);
int start = pos*21;      // 21 = PageLength

// --- Database connection ---
java.sql.Statement Cmd[] = new java.sql.Statement[Levels+1];
for(int i=0;i<=Levels;i++) Cmd[i] = getHsqlStatement(request,out,"../Database","sa","");

// --- Writes data for requested page ---   
out.print("<Grid><Body><B Pos=" + toXML(pos) + ">"); // XML Header
WriteLevel(0, "", GroupCols, Cmd, Levels, start,out);
out.print ("</B></Body></Grid>"); // XML Footer
// -------------------------------------------------------------------------------------------------------------------------------
%>