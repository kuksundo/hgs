<%@ Page language="c#" Debug="true"%>
<%
// --------------------------------------------------------------------------

   
// --- Response initialization ---
string Base = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath)+"\\TestFiles\\";
Response.ContentType = "text/xml";
Response.Charset = "utf-8";
Response.AppendHeader("Cache-Control","max-age=1, must-revalidate");
System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US");

// --- Save data to disk ---
string XML = Request["Data"];
if (XML != "" && XML != null)
{
   try
   {
      System.Xml.XmlDocument X = new System.Xml.XmlDocument();
      X.LoadXml(HttpUtility.HtmlDecode(XML));
      System.Xml.XmlNodeList Ch = X.GetElementsByTagName("Changes");

      if (Ch.Count > 0)
      {
         System.Collections.Specialized.StringDictionary N = new StringDictionary(); // Actual File paths according to their ids
         foreach (System.Xml.XmlElement I in Ch[0])
         {
            string id = I.GetAttribute("id");
            string[] ids = (N[id] != null ? N[id] : id).Split('$');
            string Path = ids[0].Replace('/', '\\') + "\\" + ids[2] + "." + ids[1];
            bool Clear = false;
            if (I.GetAttribute("Deleted") == "1")
            {
               System.IO.File.Delete(Base + Path);
               N[id] = null;
               Clear = true;
            }
            else
            {
               string[] Names = { "P", "E", "N" };
               for (int i = 0; i < 3; i++) if (I.HasAttribute(Names[i])) ids[i] = I.GetAttribute(Names[i]);
               string New = ids[0].Replace('/', '\\') + "\\" + ids[2] + "." + ids[1];
               if (New != Path || I.GetAttribute("Added") == "1")
               {
                  N[id] = ids[0] + "$" + ids[1] + "$" + ids[2]; // Changes the id path for next use
                  string dir = Base + New.Substring(0, New.LastIndexOf('\\'));
                  if (!System.IO.Directory.Exists(dir)) System.IO.Directory.CreateDirectory(dir); // Creates directories if required
               }
               string Copy = I.GetAttribute("Copy");
               if (Copy != "")
               {
                  if (N[Copy] != null) Copy = N[Copy];
                  string[] cids = Copy.Split('$');
                  string cpath = cids[0].Replace('/', '\\') + "\\" + cids[2] + "." + cids[1];
                  System.IO.File.Copy(Base + cpath, Base + New);
               }
               else if (System.IO.File.Exists(Base + Path)) { System.IO.File.Move(Base + Path, Base + New); Clear = true; } // Move or rename
               else System.IO.File.Create(Base + New).Close(); // New
            }
            if (Clear) // Deletes empty directories
            {
               int idx = Path.LastIndexOf('\\');
               while(idx>=0){
                  Path = Path.Substring(0, idx);
                  if (System.IO.Directory.GetFiles(Base + Path).Length>0 || System.IO.Directory.GetDirectories(Base + Path).Length>0) break;
                  System.IO.Directory.Delete(Base + Path);
                  idx = Path.LastIndexOf('\\');
               }
            }
         }   
      }
      Response.Write("<Grid><IO Result='0'/></Grid>");    
   }
   catch (Exception Ex) { Response.Write("<Grid><IO Result='-1' Message=\"" + Ex.Message.Replace("\"", "&quot;").Replace("<", "&lt;").Replace("&", "&amp;") + "\"/></Grid>"); }
}
// --------------------------------------------------------------------------
%>