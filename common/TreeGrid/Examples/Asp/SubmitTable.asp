<!--
Example of TreeGrid using synchronous (submit, non AJAX) communication with server
Example of simple table without tree
Uses MS Access database Database.mdb, table "TableData" as data and XML file TableDef.xml as TreeGrid layout
Single file, without using TreeGridFramework.asp
! Check if ASP application has write access to TableData.mdb file
-->

<%
' --- Response initialization ---
Session.Codepage=65001
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

' --- Saves or loads data ---
Dim XML
XML = Request.Form("TGData")
if XML <> "" then 

   ' --- Saving changes to database ---
   XML = Replace(Replace(Replace(XML,"&lt;","<"),"&gt;",">"),"&amp;","&")
   dim X,Ch,I,id,SQL,idx,rec
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
         elseif I.GetAttribute("Added")="1" then
            SQL = "INSERT INTO TableData(ID,Project,Resource,Week,Hours) VALUES(" _
               & id & "," _
               & "'" & Replace(I.GetAttribute("Project"), "'","''") & "'," _
               & "'" & Replace(I.GetAttribute("Resource"), "'","''") & "'," _
               & I.GetAttribute("Week") & "," _
               & I.GetAttribute("Hours") & ")"
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
         'Response.Write "<br>"+SQL
         set I = I.nextSibling
      loop
   end if
   Response.Write "<Grid><IO Result='0'/></Grid>"  
end if 

' --- Generating data ---
RS.Open "SELECT * FROM TableData ORDER BY Project,Resource", DB, 1, 3, 1
XML =  "<Grid><Body><B>"
Do While RS.EOF <> True
   XML = XML & "<I id='" & CStr(RS.Fields(0).Value) & "'" _ 
      & " Project='" & Replace(Replace(Replace(CStr(RS.Fields(1).Value),"&","&amp;"),"'","&apos;"),"<","&lt;") & "'" _
      & " Resource='" & Replace(Replace(Replace(CStr(RS.Fields(2).Value),"&","&amp;"),"'","&apos;"),"<","&lt;") & "'" _
      & " Week='" & CStr(RS.Fields(3).Value) & "'" _
      & " Hours='" & CStr(RS.Fields(4).Value) & "'" _
      & "/>"   
   RS.MoveNext
Loop
XML = XML & "</B></Body></Grid>"

XML = Replace(Replace(XML,"&","&amp;"),"""","&quot;")
' --------------------------------------------------------------------------
%>
<html>
   <head>
      <script src="../../Grid/GridE.js"> </script>
      <link href="../../Styles/Examples.css" rel="stylesheet" type="text/css" />
   </head>
   <body>
      <h2>Submit table</h2>
      <div style="WIDTH:100%;HEIGHT:98%">
         <bdo 
            Layout_Url='TableDef.xml' 
            Data_Tag='TGData' 
            Upload_Tag='TGData' Upload_Format='Internal'
            Export_Url="Export.asp" Export_Data="TGData" Export_Param_File="SubmitTable.xls"
            ></bdo>
      </div>
      <form>
         <input id="TGData" name="TGData" type="hidden" value="<%=XML%>">
         <input type="submit" value="Submit changes to server"/>
      </form>
   </body>
</html>