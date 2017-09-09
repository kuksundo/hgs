<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%
/*-----------------------------------------------------------------------------------------------------------------
! Support file only, run Schools.html instead !
  This file is used as Page_Url
  Loads and returrns reviews for given record
------------------------------------------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Database connection ---
java.sql.Statement Cmd = getHsqlStatement(request,out,"../Database","sa","");

// --- Returns ratings for the row as server child page --- 
String Xml = request.getParameter("TGData");
if(Xml==null || Xml.equals("")) Xml = "<Grid><Body><B id='jan$Main$1'/></Body></Grid>";  // Just for examples if called directly
org.w3c.dom.NodeList B = parseXML(Xml).getElementsByTagName("B");
out.print("<Grid><Body>");   
int Pos = 0;
for(int i=0;i<B.getLength();i++){
   org.w3c.dom.Element I = (org.w3c.dom.Element) B.item(i);
   String[] id = getIds(I);                         // User$Def$Ident
   out.print("<B id='"+I.getAttribute("id")+"'>");
   java.sql.ResultSet R = Cmd.executeQuery("SELECT * FROM Schools_Ratings WHERE Owner=" + toSQL(id[0]) + " AND Id=" + id[2]);
   while(R.next()) {
      out.print("<I Def='Review'" + toXML("CName",R,"ADate") + toXML("CCountry",R,"Review") + " Ident='"+id[2]+"_"+(Pos++)+"' " + toXML("CRating",R,"Stars")+"/>");
      }
   out.print("</B>");
   }
out.print("</Body></Grid>");
// --------------------------------------------------------------------------
%>
