<%@ Page language="c#" Debug="true"%><%
// --------------------------------------------------------------------------
  
// --- Response initialization ---
string Base = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath)+"\\TestFiles\\";

// --- Save data to disk ---
string File = Request["File"];
string Data = Request["Data"]; if (Data == null) Data = "";
try {
   System.IO.File.WriteAllText(Base + File, Data.Replace("&lt;", "<").Replace("&gt;", ">").Replace("&amp;", "&"));
   Response.Write("OK");
   }
catch (Exception Ex) { Response.Write(Ex.Message); }

// --------------------------------------------------------------------------
%>