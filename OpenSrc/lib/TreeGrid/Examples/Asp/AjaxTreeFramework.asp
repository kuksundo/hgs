<%
'! Support file only, run AjaxTree.html instead !
' This file is used as both Data_Url and Upload_Url
' Generates data for TreeGrid when no data received or saves received changes to database
' Uses routines in TreeGridFramework.asp to load and save data
%>
<!--#include file="TreeGridFramework.asp"-->
<%
' --------------------------------------------------------------------------
' Sets global parameters for functions in TreeGridFramework.asp
ConnectionString = "DRIVER={Microsoft Access Driver (*.mdb)};DBQ="&Path&"Database.mdb"    'Database file has relative path to this page
DBTable = "TreeData"      'Table name in database
DBIdCol = "id"            'Column name in database table where are stored unique row ids
IdPrefix = ""             'Prefix added in front of id, used if ids are number type
DBParentCol = "Parent"    'Column name in database table where are stored parent row ids, if is empty, the grid does not contain tree
DBDefCol = "Def"          'Column name in database table where are stored Def parameters (predefined values in Layout, used usually in tree

' -------------------------------------------------------------------------------------------
' Response initialization
Response.ContentType = "text/xml"

' --------------------------------------------------------------------------
' Saves and loads data using functions in TreeGridFramework.asp
Dim XML
XML = Request.Form("TGData")
if XML <> "" then 
   SaveXMLToDB(XML) ' Saves changes
   Response.Write "<Grid><IO Result='0'/></Grid>"
else 
   Response.Write LoadXMLFromDB()              ' Loads data
end if
' --------------------------------------------------------------------------
%>