<%@ Page language="vb" ContentType="text/xml"%>
<script language="vb" runat="server">
' Uses new ASP.NET style scripting with event Page_Load
' -------------------------------------------------------------------------------------------------------------------------------
Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)

dim XML As string: XML = Request("Data")
if XML <> "" and XML <> Nothing then
   dim Path As string: Path = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath) + "\\"
   System.IO.File.WriteAllText(Path + "GanttTreeData.xml", HttpUtility.HtmlDecode(XML))
end if
end sub
' -------------------------------------------------------------------------------------------------------------------------------
</script>
<Grid><IO Result='0'/></Grid>
