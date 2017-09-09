<%@page contentType="application/vnd.ms-excel"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%
/*-----------------------------------------------------------------------------------------------------------------
! Support file only, run SortingExport.html instead !
  This file is used as Export_Url
  Generates data to export to Excel
  Uses TreeGridFramework.jsp
------------------------------------------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Database connection ---
java.sql.Statement Cmd = getHsqlStatement(request,out,"../Database","sa","");

request.setCharacterEncoding("utf-8");
String file = request.getParameter("File"); 
if(file==null || file.equals("")) file="Export.xls";
response.addHeader("Content-Disposition","attachment; filename=\""+file+"\"");

// --- Parses sorting settings ---
String Xml = request.getParameter("TGData");
if(Xml==null) Xml = "<Grid><Cfg SortCols='Week,Hours' SortTypes='1,0'/><Cols><C Name='Project' Visible='1' Width='200'/><C Name='Resource' Visible='1' Width='150'/><C Name='Week' Visible='1' Width='60'/><C Name='Hours' Visible='1' Width='60'/></Cols></Grid>"; // Just for examples if called directly
org.w3c.dom.Document XML = parseXML(Xml);
String[] SC = getSortCols(XML);
int[] ST = getSortTypes(XML);
String S = "";
if (SC!=null) {
   for (int i = 0; i < SC.length; i++) {
      if (S.length()>0) S += ", ";
      S += SC[i];
      if (ST[i] >= 1) S += " DESC";
      }
   if (S.length()>0) S = " ORDER BY " + S;
   }

// --- Parses Column position, visibility and width ---
org.w3c.dom.NodeList C = XML.getElementsByTagName("C");
String[] N = new String[4]; int p=0;
String[] W = new String[4];
for(int i=0;i<C.getLength();i++){
	org.w3c.dom.Element E = (org.w3c.dom.Element) C.item(i);
   if (!E.getAttribute("Visible").equals("0")){
      N[p] = E.getAttribute("Name");
      W[p] = E.getAttribute("Width");
      p++;
	   }
	}

// --- Reads data from database ---
java.sql.ResultSet R = Cmd.executeQuery("SELECT * FROM TableData" + S);


// --- Writes Excel settings ---
out.print("<html xmlns:o=\"urn:schemas-microsoft-com:office:office\" xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns=\"http://www.w3.org/TR/REC-html40\">");
out.print("<head><meta http-equiv=Content-Type content=\"text/html; charset=utf-8\"></head><body>");
out.print("<style>td {white-space:nowrap}</style>");
out.print("<table border=1 bordercolor=silver style='table-layout:fixed;border-collapse:collapse;border:1px solid black'>");
   
// --- Writes columns' widths ---
for (int i=0;i<p;i++) out.print("<col width='" + W[i] + "'>");

// --- Writes captions ---
out.print("<tr>");   
for(int i=0;i<p;i++) out.print("<td style='border-bottom:1px solid black;background:yellow;font-weight:bold;'>"+N[i]+"</td>");
out.print("</tr>");

// --- Writes data ---
while(R.next()){
   out.print("<tr>");
   for (int i=0;i<p;i++){
      if(N[i].equals("Resource") || N[i].equals("Project")) out.print("<td>" + toXMLString(R.getString(N[i])) + "</td>"); // string
      else out.print("<td x:num='" + R.getString(N[i]) + "'>" + R.getString(N[i]) + "</td>"); 
      }
   out.print("</tr>");
	}
	
// ---
out.print("</table></body></html>");
//------------------------------------------------------------------------------------------------------------------
%>
