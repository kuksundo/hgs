<%
'! Support file only, run Schools.html instead !
' This file is used as Page_Url
' Loads and returrns reviews for given record

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

' --- Helper function for converting string to XML ---
Function ToXml(byval Str)
ToXml = Replace(Replace(Replace(CStr(Str),"&","&amp;"),"'","&apos;"),"<","&lt;")
End Function

' --- Returns ratings for the row as server child page --- 
Dim XML,X,Ch,I,id,pos,pos2,Owner,Def,Ident
XML = Request.Form("TGData")
XML = Replace(Replace(Replace(XML,"&lt;","<"),"&gt;",">"),"&amp;","&")
If XML = "" Then XML = "<Grid><Cfg/><Body><B id='jan$Main$1'/></Body></Grid>"   'Just for examples if called directly
set X = Server.CreateObject("Microsoft.XMLDOM")
X.LoadXml XML 
set Ch = X.getElementsByTagName("B")
Response.Write "<Grid><Body>"
for each I in Ch
   ' --- id parsing ---
   id = CStr(I.GetAttribute("id"))
   pos = InStr(1,id,"$")
   Owner = Mid(id,1,pos-1)
   pos2 = InStr(pos+1,id,"$")
   Def = Mid(id,pos+1,pos2-pos-1)
   Ident = Mid(id,pos2+1,Len(id)-pos2)
   ' ---
   
   Response.Write "<B id='"&id&"'>"
   RS.Open "SELECT * FROM Schools_Ratings WHERE Owner='" & Replace(Owner,"'","''") & "' AND Id=" & Ident, DB, 1, 3, 1
   Do While RS.EOF <> True
      Response.Write "<I Def='Review' CName='" & CStr(RS.Fields("ADate").Value) & "' CCountry='" & ToXml(RS.Fields("Review")) & "' CRating='" & CStr(RS.Fields("Stars").Value) & "'/>"
      RS.MoveNext
   loop
   Response.Write "</B>"
   RS.Close
next
Response.Write "</Body></Grid>"
' --------------------------------------------------------------------------
%>