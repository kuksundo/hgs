<%
'! Support file only, run AjaxGrid.html instead !
' This file is used as Data_Url for TreeGrid
' It generates source data for TreeGrid from database
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

' --- Generating data ---
RS.Open "SELECT * FROM TableData WHERE Week>0 AND Week<53 ORDER BY Project,Resource", DB, 1, 3, 1

Dim Prj, Res, S, P, R
Prj = "" : Res = "" : S = ""

Do While RS.EOF <> True
   P = CStr(RS.Fields(1).Value)  ' Project
   R = CStr(RS.Fields(2).Value)  ' Resource

   If R <> Res And Res <> "" Then S = S+"/>"     ' End previous resource row
   
   If P <> Prj Then              ' New project row
      If Prj <> "" Then S = S+"</I>"   ' Ends previous project row
      Prj = P
      S = S + "<I Def='Node' Project='"+Replace(Replace(Replace(Prj,"&","&amp;"),"'","&apos;"),"<","&lt;")+"'>"
   End If
   
   If R <> Res Then              ' New resource row
      Res = R
      S = S + "<I Project='"+Replace(Replace(Replace(Res,"&","&amp;"),"'","&apos;"),"<","&lt;")+"' "
   End If
   
   S = S + "W"+CStr(RS.Fields(3).Value)+"='"+CStr(RS.Fields(4).Value)+"' " ' Week = Hours (like W42='17')
   RS.MoveNext
Loop
If Res <> "" Then S = S+"/>"     ' End previous resource row
If Prj <> "" Then S = S+"</I>"   ' Ends previous project row
' --------------------------------------------------------------------------
%><?xml version="1.0" ?>
<Grid>
   <Body>
      <B>
         <%=S%>
      </B>
   </Body>
</Grid>