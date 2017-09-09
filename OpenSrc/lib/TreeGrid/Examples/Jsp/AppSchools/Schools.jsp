<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%
/*-----------------------------------------------------------------------------------------------------------------
! Support file only, run Schools.html instead !
  This file is used as Data_Url and Upload_Url
  Main application for Schools, generates data, saves changes, adds or modifies users and so on
  Uses TreeGridFramework.jsp
------------------------------------------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------------------------------------------
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Database connection ---
java.sql.Statement Cmd = getHsqlStatement(request,out,"../Database","sa","");
java.sql.ResultSet R;

// --- Input parameters initalization ---
String User = getParameter(request,"User").toLowerCase();
String Pass = getParameter(request,"Pass");
boolean NewUser = getParameter(request,"New").equals("1");

out.print("<Grid>");
boolean Err = false;

// --- Adding new user ---
if(NewUser) {
   R = Cmd.executeQuery("SELECT Pass FROM Schools_Users WHERE Name=" + toSQL(User));
   if(!R.next()) {   //Ok, possible
      R.close();
      Cmd.executeUpdate("INSERT INTO Schools_Users(Name,Pass) VALUES (" + toSQL(User) + "," + toSQL(Pass) + ")");
      out.print ("<IO Message='User " + toXMLString(User) + " has been added successfuly'/>");
      }
   else {
      R.close();
      out.print ("<IO Result='-1' Message='User name already exists !'/><Lang><Text StartErr='User name already exists !'/></Lang></Grid>");
      Err = true;
      }
   }

// --- Password verification ---
if (!Err && User.length()>0){
   R = Cmd.executeQuery ("SELECT Pass FROM Schools_Users WHERE Name=" + toSQL(User));
   if(!R.next() || !Pass.equals(R.getString(1))) {
      out.print ("<IO Result='-1' Message='Wrong user name or password !'/><Lang><Text StartErr='Wrong user name or password !'/></Lang></Grid>");
      Err = true;
      }
   R.close();
   }
boolean Admin = User.equals("admin");   // @@@ Or change this code to another admin

//------------------------------------------------------------------------------------------------------------------
// --- Saves data ---
org.w3c.dom.Element[] Ch = getChanges(request.getParameter("TGData"));
if(Ch!=null) {
   if(User.length()==0) out.print ("<IO Result='-1' Message='The user have not permission to save data !'/></Grid>");  //Attack or bug
   else {
      for(int i=0;i<Ch.length;i++){
         org.w3c.dom.Element I = Ch[i];
         String[] ids = getIds(I);  // User$Def$Ident
         String id = " Owner=" + toSQL(ids[0]) + " AND Id=" + ids[2];
         if(!ids[1].equals("Main")) { // Child row (Address, Phone, Link, Map)
            if ((isAdded(I) || isChanged(I)) && I.hasAttribute("CCountry")) {
               Cmd.executeUpdate("UPDATE Schools_Schools SET " + ids[1] + " = " + toSQL(I,"CCountry") + " WHERE" + id);
               }
            }      
         else if (isDeleted(I)) {
            Cmd.executeUpdate("DELETE FROM Schools_Schools WHERE" + id);
            Cmd.executeUpdate("DELETE FROM Schools_Ratings WHERE" + id);
            }     
         else if (isAdded(I)) {
            Cmd.executeUpdate("INSERT INTO Schools_Schools(Owner,Id,Name,Country,State,County,Town,SLevel,Type,FromGrade,ToGrade,Enrollment,Students) VALUES (" 
            //out.print("INSERT INTO Schools_Schools(Owner,Id,Name,Country,State,County,Town,SLevel,Type,FromGrade,ToGrade,Enrollment,Students) VALUES (" 
               + toSQL(I,"CUser") + "," + ids[2] + "," + toSQL(I,"CName") + ","
               + I.getAttribute("CCountry") + "," + I.getAttribute("CState") + "," + I.getAttribute("CCounty") + ","
               + toSQL(I,"CTown") + "," 
               + I.getAttribute("CLevel") + "," + I.getAttribute("CType") + ","
               + I.getAttribute("CGrade1") + "," + I.getAttribute("CGrade2") + ","
               + I.getAttribute("CEnrollment") + "," + I.getAttribute("CStudents")
               + ")");
            }     
         else if (isChanged(I)) {
            String Str = "";
            Str += toSQLUpdateString("Name",I,"CName");
            Str += toSQLUpdateNumber("Country",I,"CCountry");
            Str += toSQLUpdateNumber("State",I,"CState");
            Str += toSQLUpdateNumber("County",I,"CCounty");
            Str += toSQLUpdateString("Town",I,"CTown");
            Str += toSQLUpdateNumber("SLevel",I,"CLevel");
            Str += toSQLUpdateNumber("Type",I,"CType");
            Str += toSQLUpdateNumber("FromGrade",I,"CGrade1");
            Str += toSQLUpdateNumber("ToGrade",I,"CGrade2");
            Str += toSQLUpdateNumber("Enrollment",I,"CEnrollment");
            Str += toSQLUpdateNumber("Students",I,"CStudents");
            String Str2 = "";
            if (Admin) Str2+= toSQLUpdateString("Owner",I,"CUser");
            if (Admin) Str2+= toSQLUpdateNumber("Id",I,"Ident");
            Str = Str + Str2;
            if(Str.length()>0)  {
               Cmd.executeUpdate("UPDATE Schools_Schools SET " + trimSQL(Str) + " WHERE " + id);
               }
            if(Str2.length()>0) {           //Updates changes in user/id in Ratings
               Cmd.executeUpdate("UPDATE Schools_Ratings SET " + trimSQL(Str2) + " WHERE " + id);   
               }
            }
         }
      }
   out.print("<IO Result='0'/></Grid>");
   }
//------------------------------------------------------------------------------------------------------------------
// --- Reads data ---
else if (!Err) {
   StringBuffer Str = new StringBuffer();
   if (User.length()==0) Str.append("<Cfg Adding='0' Deleting='0' Editing='0'/><Toolbar Save='0'/>");
   else {
      Str.append("<Def><D Name='R' CUser=" + toXML(User) + "/></Def>");
      Str.append( "<Cols><C Name='CRating' Button='None'/></Cols>");
      }
   if(!Admin) Str.append("<RightCols><C Name='CUser' Visible='0' CanHide='0' CanPrint='0' CanExport='0'/></RightCols>");
   
   Str.append("<Body><B>");
   String SQL = "SELECT * FROM Schools_Schools";
   if (User.length()>0 && !Admin) SQL += " WHERE Owner=" + toSQL(User);
   R = Cmd.executeQuery(SQL);
   while(R.next()) {
      String id = toXML("Ident",R,"ID") + toXML("CUser",R,"Owner");
      Str.append("<I Def='Main' " + id);
      toXML(Str,"CName",R,"Name");
      toXML(Str,"CCountry",R,"Country");
      toXML(Str,"CState",R,"State");
      toXML(Str,"CCounty",R,"County");
      toXML(Str,"CTown",R,"Town");
      toXML(Str,"CLevel",R,"SLevel");
      toXML(Str,"CType",R,"Type");
      toXML(Str,"CGrade1",R,"FromGrade");
      toXML(Str,"CGrade2",R,"ToGrade");
      toXML(Str,"CEnrollment",R,"Enrollment");
      toXML(Str,"CStudents",R,"Students");
      Str.append(">");
      Str.append("<I Def='Address' " + id + toXML("CCountry",R,"Address") + "/>");
      Str.append("<I Def='Phone' " + id + toXML("CCountry",R,"Phone") + "/>");
      Str.append("<I Def='Link' " + id + toXML("CCountry",R,"Link") + "/>");
      Str.append("<I Def='Map' " + id + toXML("CCountry",R,"Map") + "/>");
      Str.append("<I Def='Reviews' " + id + toXML("Count",R,"RatingCnt") + toXML("CRatingsum",R,"RatingSum") + ">");
      Str.append("</I>");
      Str.append("</I>\n");
      }
   Str.append("</B></Body></Grid>");
   out.print(Str);
   }
//------------------------------------------------------------------------------------------------------------------
%>
