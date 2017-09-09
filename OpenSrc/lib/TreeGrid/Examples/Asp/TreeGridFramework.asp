<%
' -------------------------------------------------------------------------------------------
' TreeGrid Framework for accessing database
' It contains two basic functions:
'  String LoadXMLFromDB()  Returns data in XML, from database for TreeGrid 
'  SaveXMLToDB(String XML) Saves changes in XML from TreeGrid to database

' Predefined global variables to be set by using script
' ConnectionString = "" ' Required - Connection string for accessing database, that can be used global variable Path as path to actual script
' DBTable = ""          ' Required - Table name in database
' DBIdCol = "ID"        ' Column name in database table where are stored unique row ids
' IdPrefix = ""         ' Prefix added in front of id, used if ids are number type, the same prefix must be in Layout <Cfg IdPrefix=''/>
' DBParentCol = ""      ' Column name in database table where are stored parent row ids, if is empty, the grid does not contain tree
' DBDefCol = ""         ' Column name in database table where are stored Def parameters (predefined values in Layout, used usually in tree)
' -------------------------------------------------------------------------------------------

' -------------------------------------------------------------------------------------------
' Initialization of global parameters
Dim DB, Path,ConnectionString, DBTable, DBIdCol, IdPrefix, DBParentCol, XMLDef
Path = Request.ServerVariables("PATH_TRANSLATED")
Path = Left(Path,InStrRev(Path,"\"))
SetLocale "en-us"
Set DB = Server.CreateObject("ADODB.Connection")
DBIdCol = "id"
IdPrefix = ""
DBParentCol = "Parent"

' -------------------------------------------------------------------------------------------
' Response initialization
Session.Codepage=65001
Response.Charset= "utf-8"
Response.AddHeader "Cache-Control","max-age=1, must-revalidate"

' -------------------------------------------------------------------------------------------
' Helper function for LoadXMLFromDB to read data from database table and convert them to TreeGrid XML
' Returns XML string width all children with Parent
' If Parent is null returns all rows (for non tree tables)
Function GetChildrenXML(byval Parent)
Dim RS : Set RS = Server.CreateObject("ADODB.Recordset")
if IsNull(Parent) then Parent = "" else Parent = " WHERE "&DBParentCol&"='"&Parent&"'"
RS.Open "SELECT * FROM "&DBTable&Parent, DB, 1, 3, 1
Dim f,S,val,name
S = ""
do while RS.EOF<>true
   S=S & "<I "
   for f=0 to RS.Fields.Count-1
      val = RS.Fields(f).Value
      name = RS.Fields(f).Name
      if not IsNull(val) then
         if name=DBIdCol then 
            name="id"
            val = IdPrefix & val
         else val = Replace(Replace(Replace(val&"","&","&amp;"),"'","&apos;"),"<","&lt;")
         End if
         if name<>DBParentCol then S = S & name & "='" & val & "' "
      End if
   next
   S = S & ">"
   if Parent<>"" then S = S & GetChildrenXML(RS.Fields(DBIdCol).Value)
   S = S & "</I>" & Chr(13)
   RS.MoveNext
loop
RS.Close
GetChildrenXML = S
End Function

' -------------------------------------------------------------------------------------------
' Loads data from database table and returns them as XML string
Function LoadXMLFromDB
if DB.State = adStateClosed then DB.Open ConnectionString
Dim XML
XML = "<Grid>"
if DBParentCol <> "" then
   XML = XML & "<Head>"&GetChildrenXML("#Head")&"</Head>"
   XML = XML & "<Foot>"&GetChildrenXML("#Foot")&"</Foot>"
   XML = XML & "<Body><B>"&GetChildrenXML("#Body")&"</B></Body>"
else
   XML = XML & "<Body><B>"&GetChildrenXML(null)&"</B></Body>"
end if
XML = XML & "</Grid>"
LoadXMLFromDB = XML
End Function

' -------------------------------------------------------------------------------------------
' Saves to database changes in TreeGrid XML format
Sub SaveXMLToDB(byval XML)
if DB.State = adStateClosed then DB.Open ConnectionString
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
      id = Right(id,Len(id)-Len(IdPrefix))
      if not IsNumeric(id) then id = "'" & id & "'"
      if I.GetAttribute("Deleted")="1" then 
         SQL = "DELETE FROM "&DBTable&" WHERE ["&DBIdCol&"]="&id
      elseif I.GetAttribute("Added")="1" then
         dim Cols,Vals,A,name,par,val
         Cols = "INSERT INTO "&DBTable&"("
         Vals = ") VALUES ("
         for idx=0 to I.attributes.length
            set A = I.attributes(idx)
            if not (A is nothing) then 
               name = I.attributes(idx).name
               val = I.attributes(idx).value
               if not IsNumeric(val) then val = "'" & Replace(val, "'","''") & "'"
               if name<>"Added" and name<>"Changed" and name<>"Moved" and name<>"Next" and name<>"Prev" and name<>"Parent" then
                  if name="id" then name = DBIdCol : val = id
                  if name="Def" then name = DBDefCol
                  if name<>"" then
                     Cols = Cols & "["&name&"],"
                     Vals = Vals & val & ","
                  end if
               end if
            end if
         next
         if DBParentCol <> "" then
            Cols = Cols & "["&DBParentCol&"]"
            par = I.getAttribute("Parent")
            if par = "" then par = "#Body"
            Vals = Vals & "'" & par & "'"
         else
            Cols = Left(Cols,Len(Cols)-1)
            Vals = Left(Vals,Len(Vals)-1)
         end if
         SQL = Cols & Vals & ")"
      elseif I.GetAttribute("Changed")="1" or I.GetAttribute("Moved")="1" or I.GetAttribute("Moved")="2" then
         SQL = "UPDATE "&DBTable&" SET "
         for idx=0 to I.attributes.length
            set A = I.attributes(idx)
            if not (A is nothing) then 
               name = I.attributes(idx).name
               val = I.attributes(idx).value
               if not IsNumeric(val) then val = "'" & Replace(val, "'","''") & "'"
               if name<>"Added" and name<>"Changed" and name<>"Moved" and name<>"Next" and name<>"Prev" and name<>"Parent" and name <> "id" then
                  SQL = SQL & "["&name&"] = " & val & ","
               end if
               if DBParentCol <> "" and name="Parent" then
                  SQL = SQL & "["&DBParentCol&"] = " & val & ","
               end if
            end if
         next
         SQL = Left(SQL,Len(SQL)-1)
         SQL = SQL & " WHERE ["&DBIdCol&"]="&id
      end if      
      DB.Execute SQL, rec
      set I = I.nextSibling
   loop
end if
End Sub

' -------------------------------------------------------------------------------------------
%>