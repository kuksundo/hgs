<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%!
/*-----------------------------------------------------------------------------------------------------------------
! Support file only, run GroupingChild.html instead !
  This file is used as Page_Url
  Generates data for one TreeGrid page or parent row from database, according to grouping information
! Demonstrates Server paging with Server child paging
  This is only simple example with not ideal database access (for every page gets all data)
  Uses TreeGridFramework.asp
  -------------------------------------------------------------------------------------------------------------------------------*/

// ------------------------------------------------------------------------------------------------------------------------------- 
// Writes one level of grouped children
// Level is actual level to write
// Where is WHERE clause for SQL, for every level there is added one condition
void WriteLevel(int Level, String Where, String[] GroupCols, java.sql.Statement Cmd, int Levels, int Start, JspWriter out) throws Exception
{
   java.sql.ResultSet R;
   if (Level == Levels) R = Cmd.executeQuery("SELECT * FROM TableData" + Where);
   else R = Cmd.executeQuery("SELECT DISTINCT " + GroupCols[Level] + " FROM TableData" + Where);
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
         out.print("<I Def='Group' Project=" + toXML(R.getString(1))); // writes the grouping row
         String Where2 = (Level == 0 ? " WHERE " : " AND ") + GroupCols[Level] + "=" 
                 + (GroupCols[Level].equals("Week") || GroupCols[Level].equals("Hours") ? R.getString(1) : toSQL(R.getString(1)));
         String Rows = String.valueOf(Level + 1) + Where + Where2; // Builds new attribute Rows for identification
         out.print(" Rows=" + toXML(Rows) + " Count='1'></I>"); // Sets Count to 1 instead of searching exact count of children to speed up the process
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

// --- Database connection ---
java.sql.Statement Cmd = getHsqlStatement(request,out,"../Database","sa","");

// --- Writes data for requested page ---   

out.print("<Grid><Body>"); // XML Header
String Rows = ((org.w3c.dom.Element)(X.getElementsByTagName("B").item(0))).getAttribute("Rows");
if (!Rows.equals(""))
{
   out.print("<B Rows=" + toXML(Rows) + ">"); // XML Header
   int Level = Integer.valueOf(Rows.substring(0, 1)); // First character is the level
   Rows = Rows.substring(1); // Next string is Where
   WriteLevel(Level, Rows, GroupCols, Cmd, Levels,0,out);
}
else
{
   int pos = getPagePos(X);
   int start = pos*21;      // 21 = PageLength
   out.print("<B Pos=" + toXML(pos) + ">"); // XML Header
   WriteLevel(0, "", GroupCols, Cmd, Levels, start,out);
}
out.print ("</B></Body></Grid>"); // XML Footer
 
// -------------------------------------------------------------------------------------------------------------------------------
%>