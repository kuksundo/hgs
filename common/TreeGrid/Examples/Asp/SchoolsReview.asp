<%
'! Support file only, run Schools.html instead !
' This file is used as target of custom AJAX call in Schools.html
' Saves Review to database

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

Dim id,Text,Stars,pos,pos2,Owner,Def,Ident,rec

' --- Reads input parameters ---
id = Request.Form("id")
Text = Request.Form("Text")
Stars = Request.Form("Stars")

if id<>"" then

   ' --- id parsing ---
   pos = InStr(1,id,"$")
   Owner = Replace(Mid(id,1,pos-1),"'","''")
   pos2 = InStr(pos+1,id,"$")
   Def = Mid(id,pos+1,pos2-pos-1)
   Ident = Mid(id,pos2+1,Len(id)-pos2)

   ' --- Saves Review to database ---
   Session.LCID = 1033 'Sets US data format for Date()
   DB.Execute "INSERT INTO Schools_Ratings(Owner,Id,Stars,Review,ADate) VALUES ('" & Owner & "'," & Ident & "," &Stars & ",'" & Replace(Text,"'","''") & "','" & CStr(Date()) & "')", rec
   DB.Execute "UPDATE Schools_Schools SET RatingSum=RatingSum+"+Stars+", RatingCnt=RatingCnt+1 WHERE Owner='" & Owner & "' AND Id=" & Ident, rec
end if

Response.Write "<Grid><IO Result='0' Message='Your review was successfully added'/></Grid>"  
' --------------------------------------------------------------------------
%>