<%@ Page language="c#" ContentType="text/xml"%>
<script language="c#" runat="server">
/// Uses new ASP.NET style scripting with event Page_Load
// -------------------------------------------------------------------------------------------------------------------------------
void Page_Load(object sender, System.EventArgs e) 
{
string XML = Request["Data"];
if (XML != "" && XML != null)
   {
      string Path = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath) + "\\";
      System.IO.File.WriteAllText(Path + "GanttTreeData.xml", HttpUtility.HtmlDecode(XML));
   }
}
// -------------------------------------------------------------------------------------------------------------------------------
</script>
<Grid><IO Result='0'/></Grid>
