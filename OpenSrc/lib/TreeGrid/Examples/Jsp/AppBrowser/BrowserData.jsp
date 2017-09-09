<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%!
// --------------------------------------------------------------------------  
// Adds files from the Path directory to the B
// Calls AddDir for all subdirectories
void AddDir(java.io.File Dir, int len, JspWriter out) throws Exception {
java.io.File[] D = Dir.listFiles();
for(int i=0;i<D.length;i++) {
   java.io.File f = D[i];
   if(f.isDirectory()) AddDir(f, len, out);
   else{
      String n = f.getName(), e = "";
      int ep = n.lastIndexOf('.');
      if (ep >= 0) { e = n.substring(ep + 1); n = n.substring(0, ep); }
      String p = f.getPath().substring(len).replace("\\","/");
      int pp = p.lastIndexOf('/');
      if(pp >= 0) p = p.substring(0,pp);
      else p = "";
      out.print("<I P=\"" + p + "\" N=\"" + n + "\" E=\"" + e + "\" />");
      }
   }
}
// -------------------------------------------------------------------------- 
%><%
// --------------------------------------------------------------------------
 
// --- Response initialization ---
String Base = application.getRealPath(request.getServletPath().replaceAll("[^\\/\\\\]*$","")) + "\\TestFiles";
response.addHeader("Cache-Control","max-age=1, must-revalidate");

// --- Generating data ---
out.print("<Grid><Body><B>");
AddDir(new java.io.File(Base), Base.length()+1, out);
out.print("</B></Body></Grid>");
// --------------------------------------------------------------------------
%>