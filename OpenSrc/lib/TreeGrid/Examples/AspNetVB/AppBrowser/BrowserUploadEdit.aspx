<%@ Page language="vb" Debug="true"%><%
' --------------------------------------------------------------------------
  
' --- Response initialization ---
dim Base As string: Base = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath)+"\TestFiles\"

' --- Save data to disk ---
dim File As string: File = Request("File")
dim Data As string: Data = Request("Data"): If Data = Nothing then Data = ""
Try 
   System.IO.File.WriteAllText(Base + File, Data.Replace("&lt;", "<").Replace("&gt;", ">").Replace("&amp;", "&"))
   Response.Write("OK")
catch Ex As Exception
   Response.Write(Ex.Message)
End try

' --------------------------------------------------------------------------
%>