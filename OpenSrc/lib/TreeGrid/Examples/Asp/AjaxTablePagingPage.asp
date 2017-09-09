<%
'! Support file only, run AjaxTablePaging.html instead !
' This file is used as Page_Url
' Generates data for one TreeGrid page from database, according to sorting information
' This is only simple example with not ideal database access (for every page gets all data)
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

' --- Helper function parses string Str to array Arr, items in string are delimited by Del ---
Function ParseString(byval Str,byval Del, byref Arr)
if IsNull(Str) then exit function
dim start,pos,cnt
start=1 : cnt=0
pos = InStr(start,Str,Del)
do while pos>0
   Arr(cnt) = Mid(Str,start,pos-start)
   cnt = cnt+1
   start = pos+1
   pos = InStr(start,Str,Del)
loop
Arr(cnt) = Mid(Str,start,Len(Str)-start+1)
if Arr(cnt)<>"" then cnt = cnt+1
ParseString = cnt
End Function

' --- Parses TreeGrid configuration ---
Dim XML,X,E,S,cnt,pos,start,idx,SC(3),ST(3)
XML = Request.Form("TGData")
XML = Replace(Replace(Replace(XML,"&lt;","<"),"&gt;",">"),"&amp;","&")
If XML = "" Then XML = "<Grid><Cfg/><Body><B Pos='2'/></Body></Grid>"   'Just for examples if called directly

set X = Server.CreateObject("Microsoft.XMLDOM")
X.LoadXml XML 

' --- Parses sorting settings ---
set E = X.getElementsByTagName("Cfg")
cnt = ParseString(E(0).GetAttribute("SortCols"),",",SC)
ParseString E(0).GetAttribute("SortTypes"),",",ST
S = ""
for i=0 to cnt-1
   if S<>"" then S = S & ", "
   S = S & SC(i)
   if CInt(ST(i)) >= 1  then S = S & " DESC"
next
if cnt then S = " ORDER BY " & S

' --- Gets information about page number ---
set E = X.getElementsByTagName("B")
pos = E(0).GetAttribute("Pos")
start = CInt(pos)*20 ' PageLength

' --- Reads data from database ---
RS.Open "SELECT * FROM TableData" & S, DB, 1, 3, 1

' --- Throws away data in front of requested page ---
idx = 0
Do While RS.EOF <> True And idx<start 
   idx = idx + 1
   RS.MoveNext
Loop

' --- Writes data for requested page ---
Response.Write "<Grid><Body><B Pos='"&pos&"'>"
Do While RS.EOF <> True And idx<start+20
   Response.Write "<I id='" & CStr(RS.Fields(0).Value) & "'" _ 
         & " Project='" & Replace(Replace(Replace(CStr(RS.Fields(1).Value),"&","&amp;"),"'","&apos;"),"<","&lt;") & "'" _
         & " Resource='" & Replace(Replace(Replace(CStr(RS.Fields(2).Value),"&","&amp;"),"'","&apos;"),"<","&lt;") & "'" _
         & " Week='" & CStr(RS.Fields(3).Value) & "'" _
         & " Hours='" & CStr(RS.Fields(4).Value) & "'" _
         & "/>"   
   idx = idx + 1
   RS.MoveNext
Loop 
Response.Write "</B></Body></Grid>"
' --------------------------------------------------------------------------
%>