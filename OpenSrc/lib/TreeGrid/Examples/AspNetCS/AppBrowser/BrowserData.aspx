<%@ Page language="c#" Debug="true"%>
<script runat='server'>
// --------------------------------------------------------------------------  
// Adds files from the Path directory to the B
// Calls AddDir for all subdirectories
void AddDir(string Base, string Path, StringBuilder B) {
string[] D = System.IO.Directory.GetDirectories(Base + Path);
foreach (string s in D) AddDir(Base, Path + "\\" + s.Substring(s.LastIndexOf('\\')+1), B);
string[] F = System.IO.Directory.GetFiles(Base + Path);
foreach (string s in F) {
   string f = s.Substring(s.LastIndexOf('\\') + 1), e = "";
   int p = f.LastIndexOf(".");
   if (p >= 0) { e = f.Substring(p + 1); f = f.Substring(0, p); }
   B.AppendLine("<I P=\"" + (Path==""?"":Path.Replace('\\', '/').Substring(1)) + "\" N=\"" + f + "\" E=\"" + e + "\" />");
   }
}
// -------------------------------------------------------------------------- 
</script>
<%
// --------------------------------------------------------------------------
   
// --- Database initialization ---
string Base = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath)+"\\TestFiles";

// --- Response initialization ---
Response.ContentType = "text/xml";
Response.Charset = "utf-8";
Response.AppendHeader("Cache-Control","max-age=1, must-revalidate");
System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US");

// --- Generating data ---
Response.Write("<Grid><Body><B>");
StringBuilder B = new StringBuilder();
AddDir(Base, "", B);
Response.Write(B.ToString());
Response.Write("</B></Body></Grid>");
// --------------------------------------------------------------------------
%>