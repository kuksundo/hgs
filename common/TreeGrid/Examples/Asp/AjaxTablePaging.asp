<%
'! Support file only, run AjaxTablePaging.html instead !
' This file is used as both Data_Url and Upload_Url
' Generates data for TreeGrid when no data received or saves received changes to database
' This is simple example, it simply reloads all body when rows are added or deleted instead of handling changes in pages
' Single file, without using TreeGridFramework.asp


' --- Response initialization ---
Session.Codepage=65001
Response.Charset= "utf-8"
Response.ContentType = "text/xml"
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

' --- Saves or loads data ---
Dim XML
XML = Request.Form("TGData")
if XML <> "" then 

   ' --- Saving changes to database ---
   XML = Replace(Replace(Replace(XML,"&lt;","<"),"&gt;",">"),"&amp;","&")
   dim X,Ch,I,id,SQL,idx,rec,reload
   reload = 0
   set X = Server.CreateObject("Microsoft.XMLDOM")
   X.LoadXml XML 
   set Ch = X.getElementsByTagName("Changes")
   if Ch.length>0 then
      set I = Ch(0).firstChild
      do while not (I is nothing)
         SQL = ""
         id = I.GetAttribute("id")
         if I.GetAttribute("Deleted")="1" then 
            SQL = "DELETE FROM TableData WHERE ID="&id
            reload = 1
         elseif I.GetAttribute("Added")="1" then
            SQL = "INSERT INTO TableData(ID,Project,Resource,Week,Hours) VALUES(" _
               & id & "," _
               & "'" & Replace(I.GetAttribute("Project"), "'","''") & "'," _
               & "'" & Replace(I.GetAttribute("Resource"), "'","''") & "'," _
               & I.GetAttribute("Week") & "," _
               & I.GetAttribute("Hours") & ")"
            reload = 1
         elseif I.GetAttribute("Changed")="1" then
            SQL = "UPDATE TableData SET "
            for idx=0 to I.attributes.length
               set A = I.attributes(idx)
               if not (A is nothing) then 
                  name = I.attributes(idx).name
                  val = I.attributes(idx).value
                  if name="Project" or name="Resource" then 
                     SQL = SQL & name & " = '" & Replace(val, "'","''") & "',"
                  elseif name="Week" or name="Hours" then
                     SQL = SQL & name & " = " & val & ","
                  end if
               end if
            next
            SQL = Left(SQL,Len(SQL)-1) ' Last comma away
            SQL = SQL & " WHERE ID=" & id
         end if      
         DB.Execute SQL, rec
         set I = I.nextSibling
      loop
   end if
   Response.Write "<Grid><IO Result='0' Reload='"&CStr(reload)&"'/></Grid>"  ' needs reloading pages when some rows were added or deleted
else 

   ' --- Generating data for body ---
   RS.Open "SELECT COUNT(*),MAX(ID) FROM TableData", DB, 1, 3, 1
   dim cnt
   cnt = CInt(RS.Fields(0).Value)
   Response.Write "<Grid><Cfg LastId='"&CStr(RS.Fields(1).Value)&"' RootCount='"&CStr(cnt)&"'/><Body>"
   cnt = CInt((cnt+19) / 20)-1
   for i=0 to cnt
      Response.Write "<B/>"
   next
   Response.Write "</Body></Grid>"
   RS.Close
end if
' --------------------------------------------------------------------------
%>