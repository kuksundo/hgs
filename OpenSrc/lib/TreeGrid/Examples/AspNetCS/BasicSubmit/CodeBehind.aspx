<%@ Page Language="C#" AutoEventWireup="true"  Src="CodeBehind.aspx.cs" Inherits="TreeGrid"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- In Visual Studion .NET you can use attribute CodeBehind instead of Src. In this case you have to compile the .cs file. -->
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
   <title>TreeGrid example</title>
   <script src="../../../Grid/GridE.js" > </script>
   <link href="../../../Styles/Examples.css" rel="stylesheet" type="text/css" />
</head>
<body>
   <h2>Page with code behind</h2>
   <div style="WIDTH:100%;HEIGHT:90%">
      <bdo 
         Layout_Url="DBDef.xml" 
         Data_Tag="TGData" 
         Upload_Tag="TGData" Upload_Format="Internal"
         Export_Url="../Framework/Export.aspx" Export_Data="TGData" Export_Param_File="Table.xls"
         ></bdo>
    </div>
    <form id="form1" runat="server" method="post">
    <div>
      <input id="TGData" type="hidden" runat="server"/>
      <input type="submit" value="Submit changes to server"/>
    </div>
    </form>
</body>
</html>
