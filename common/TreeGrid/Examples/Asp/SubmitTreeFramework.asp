<!--
Example of TreeGrid using synchronous (submit, non AJAX) communication with server
Example of tree table
Uses MS Access database TreeData.mdb as data and XML file TreeDef.xml as TreeGrid layout
Uses routines in TreeGridFramework.asp to load and save data
! Check if ASP application has write access to TreeData.mdb file 
-->

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
XMLDef = "TreeDef.xml"    'TreeGrid Layout file, relative path to this page

' --------------------------------------------------------------------------
' Saves and loads data using functions in TreeGridFramework.asp
Dim XML
XML = Request.Form("TGData")
if XML <> "" then SaveXMLToDB(XML) ' Saves changes
XML = LoadXMLFromDB()              ' Loads data
XML = Replace(Replace(XML,"&","&amp;"),"""","&quot;")

' --------------------------------------------------------------------------
%>
<html>
   <head>
      <script src="../../Grid/GridE.js"> </script>
      <link href="../../Styles/Examples.css" rel="stylesheet" type="text/css" />
   </head>
   <body>
      <h2>Submit tree with framework</h2>
      <div style="WIDTH:100%;HEIGHT:98%">
         <bdo 
            Layout_Url='<%=XMLDef%>' 
            Data_Tag='TGData' 
            Upload_Tag='TGData' Upload_Format='Internal'
            Export_Url="Export.asp" Export_Data="TGData" Export_Param_File="SubmitTree.xls"
            ></bdo>
      </div>
      <form>
         <input id="TGData" name="TGData" type="hidden" value="<%=XML%>">
         <input type="submit" value="Submit changes to server"/>
      </form>
   </body>
</html>