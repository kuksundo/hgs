<%
'! Support file only, run AjaxGrid.html instead !
' This file is used as Upload_Url for TreeGrid
' It stores changed from TreeGrid to database
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

' --- Request processing ---
Dim XML
XML = Request.Form("TGData")
XML = Replace(Replace(Replace(XML,"&lt;","<"),"&gt;",">"),"&amp;","&")
dim X,Ch,I,id,idx,rec,Last(50),LastCount
LastCount = 1
set X = Server.CreateObject("Microsoft.XMLDOM")
X.LoadXml XML 
set Ch = X.getElementsByTagName("Changes")
if Ch.length>0 then
   set I = Ch(0).firstChild
   do while not (I is nothing)
      id = I.GetAttribute("id")
      
      dim pos,where,prj,res,week
      pos = InStr(1,id,"$")
      
      ' --- Project row ---
      if pos = 0 then  
         prj = "'" & Replace(id, "'","''") & "'"
         where = " WHERE Project=" & prj & " "
         if I.GetAttribute("Deleted")="1" then 
            DB.Execute "DELETE FROM TableData" & where, rec
         elseif I.GetAttribute("Added")="1" or I.GetAttribute("Changed")="1" then
            res = I.GetAttribute("Project")    ' Changed resource name
            if not IsNull(res) then
               res = "'" & Replace(res, "'","''") & "'"
               Last(LastCount) = "UPDATE TableData SET Project=" & res & where
               LastCount = LastCount + 1
            end if
         end if
         
      ' --- Resource row ---
      else             
         prj = "'" & Replace(Left(id,pos-1), "'","''") & "'"
         res = "'" & Replace(Right(id,Len(id)-pos), "'","''") & "'"
         where = " WHERE Project=" & prj & " AND Resource=" & res & " "
         if I.GetAttribute("Deleted")="1" then 
            DB.Execute "DELETE FROM TableData" & where, rec
         elseif I.GetAttribute("Added")="1" or I.GetAttribute("Changed")="1" then
            for idx=0 to I.attributes.length
               set A = I.attributes(idx)
               if not (A is nothing) then 
                  name = A.name
                  if Left(name,1)="W" then ' Hours number
                     val = A.value
                     week = Right(name,Len(name)-1)
                     RS.Open "SELECT ID FROM TableData" & where & " AND Week=" & week, DB, 1, 3, 1
                     if RS.EOF = True then ' New item
                        RS.Close
                        RS.Open "SELECT MAX(ID) FROM TableData", DB, 1, 3, 1 'Creates new id, but better is to define Id in database as incremental
                        DB.Execute "INSERT INTO TableData(ID,Project,Resource,Week,Hours) VALUES (" & CStr((CInt(RS.Fields(0).Value)+1)) & "," & prj & "," & res & "," & week & "," & val & ")",rec
                     else             ' Existing item
                        DB.Execute "UPDATE TableData SET Hours=" & val & where & " AND Week=" & week, rec
                     end if
                     RS.Close
                  end if
               end if
            next
            res = I.GetAttribute("Project")    ' Changed resource name
            if not IsNull(res) then
               res = "'" & Replace(res, "'","''") & "'"
               DB.Execute "UPDATE TableData SET Resource=" & res & where,rec
            end if
         elseif I.GetAttribute("Moved")="2" then
            DB.Execute "UPDATE TableData SET Project='" & Replace(I.GetAttribute("Parent"), "'","''") & "'" & where, rec
         end if      
                  
      ' ---      
      end if
      set I = I.nextSibling
   loop
   
' --- Delayed changing project names ---'
' It must be done after changing all resources for the project
for i=1 to LastCount-1
   DB.Execute Last(i),rec
next
end if
' --------------------------------------------------------------------------
%><?xml version="1.0"?>
<Grid>
   <IO Result='0'/>
</Grid>