<!--
Example of TreeGrid using synchronous (submit, non AJAX) communication with server
Example of simple table without tree
Uses MS Access database Database.mdb, table "TableData" as data and XML file TableDef.xml as TreeGrid layout
Uses routines in TreeGridFramework.asp to load and save data
! Check if ASP application has write access to Database.mdb file
-->

<!--#include file="TreeGridFramework.asp"-->
<%
' --------------------------------------------------------------------------
' Sets global parameters for functions in TreeGridFramework.asp
ConnectionString = "DRIVER={Microsoft Access Driver (*.mdb)};DBQ="&Path&"Database.mdb"    'Database file has relative path to this page
DBTable = "TableData"      'Table name in database
DBIdCol = "ID"             'Column name in database table where are stored unique row ids
IdPrefix = ""              'Prefix added in front of id, used if ids are number type, the same prefix must be in Layout <Cfg IdPrefix=''/>
DBParentCol = ""           'Column name in database table where are stored parent row ids, if is empty, the grid does not contain tree
DBDefCol = ""              'Column name in database table where are stored Def parameters (predefined values in Layout, used usually in tree
XMLDef = "TableDef.xml"    'TreeGrid Layout file, relative path to this page
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
      <h2>Submit table with framework</h2>
      <div style="WIDTH:100%;HEIGHT:98%">
         <bdo 
            Layout_Url='<%=XMLDef%>' 
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