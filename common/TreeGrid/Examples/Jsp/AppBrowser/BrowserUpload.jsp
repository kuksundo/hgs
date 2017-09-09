<%@page contentType="text/xml"%><%@page pageEncoding="UTF-8"%><%@include file="../Framework/TreeGridFramework.jsp"%><%
// --------------------------------------------------------------------------
  
// --- Response initialization ---
String Base = application.getRealPath(request.getServletPath().replaceAll("[^\\/\\\\]*$","")) + "\\TestFiles\\";
response.addHeader("Cache-Control","max-age=1, must-revalidate");

try{
   org.w3c.dom.Element[] Ch = getChanges(request.getParameter("Data"));
   if(Ch!=null) {
      java.util.Hashtable N = new java.util.Hashtable();
      for(int i=0;i<Ch.length;i++){
         org.w3c.dom.Element I = Ch[i];
         String id = I.getAttribute("id");
         String[] ids = (N.get(id) != null ? (String)N.get(id) : id).split("\\$");
         String Path = ids[0].replace('/', '\\') + "\\" + ids[2] + "." + ids[1];
         boolean Clear = false;
         if (isDeleted(I)) {
            (new java.io.File(Base + Path)).delete();
            N.remove(id);
            Clear = true;
            }
         else {
            String[] Names = { "P", "E", "N" };
            for (int j = 0; j < 3; j++) if (I.hasAttribute(Names[j])) ids[j] = I.getAttribute(Names[j]);
            String New = ids[0].replace('/', '\\') + "\\" + ids[2] + "." + ids[1];
            if (New != Path || isAdded(I)) {
               N.put(id,ids[0] + "$" + ids[1] + "$" + ids[2]); // Changes the id path for next use
               String dir = Base + New.substring(0, New.lastIndexOf('\\'));
               (new java.io.File(dir)).mkdirs();
               }
            String Copy = I.getAttribute("Copy");
            
            if (!Copy.equals("")) {
               if (N.get(Copy) != null) Copy = (String) N.get(Copy);
               String[] cids = Copy.split("\\$");
               String cpath = cids[0].replace('/', '\\') + "\\" + cids[2] + "." + cids[1];
               java.io.FileInputStream src = new java.io.FileInputStream(new java.io.File(Base+cpath));
               java.io.FileOutputStream dest = new java.io.FileOutputStream(new java.io.File(Base+New));
               byte[] buf = new byte[1024]; int len;
               while ((len = src.read(buf)) > 0) dest.write(buf, 0, len);
               src.close(); dest.close();
               }
            else {
               java.io.File P = new java.io.File(Base+Path);
               if (P.exists()) { P.renameTo(new java.io.File(Base + New)); Clear = true; } // Move or rename
               else (new java.io.File(Base+New)).createNewFile(); // New
               }
            }
         if (Clear) { // Deletes empty directories
            int idx = Path.lastIndexOf('\\');
            while(idx>=0){
               Path = Path.substring(0, idx);
               java.io.File P = new java.io.File(Base+Path);
               if (P.list().length>0) break;
               P.delete();
               idx = Path.lastIndexOf('\\');
               }
            } 
         }
      }
   }
catch (Exception Ex) { out.print("<Grid><IO Result='-1' Message=\"" + Ex.getMessage().replace("\"", "&quot;").replace("<", "&lt;").replace("&", "&amp;") + "\"/></Grid>"); }
// --------------------------------------------------------------------------
%><?xml version="1.0"?>
<Grid>
   <IO Result='0'/>
</Grid>