<%@ Page language="vb" Debug="true"%>
<script runat='server'>
' --------------------------------------------------------------------------  
' Adds files from the Path directory to the B
' Calls AddDir for all subdirectories
Private Sub AddDir(ByVal Base As string, ByVal Path As string, ByRef B As StringBuilder)
Dim D As string(): D = System.IO.Directory.GetDirectories(Base + Path)
for each s as string in D  
AddDir(Base, Path + "\" + s.Substring(s.LastIndexOf("\")+1), B)
Next s
dim F As string(): F = System.IO.Directory.GetFiles(Base + Path)
for each s As String in F
   dim ff As string, ee As String
   ff = s.Substring(s.LastIndexOf("\") + 1)
   ee = ""
   Dim p As Integer: p = ff.LastIndexOf(".")
   if p >= 0 then 
      ee = ff.Substring(p + 1)
      ff = ff.Substring(0, p)
   End If
   Dim pa As String: pa = ""
   If Path <> "" then pa = Path.Replace("\", "/").Substring(1)
   B.AppendLine("<I P=""" + pa + """ N=""" + ff + """ E=""" + ee + """ />")
Next s
End Sub
' -------------------------------------------------------------------------- 
</script>
<%
' --------------------------------------------------------------------------
   
' --- Database initialization ---
dim Base As string: Base = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath)+"\TestFiles"

' --- Response initialization ---
Response.ContentType = "text/xml"
Response.Charset = "utf-8"
Response.AppendHeader("Cache-Control","max-age=1, must-revalidate")
System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US")

' --- Generating data ---
Response.Write("<Grid><Body><B>")
dim B As StringBuilder: B = new StringBuilder()
AddDir(Base, "", B)
Response.Write(B.ToString())
Response.Write("</B></Body></Grid>")
' --------------------------------------------------------------------------
%>