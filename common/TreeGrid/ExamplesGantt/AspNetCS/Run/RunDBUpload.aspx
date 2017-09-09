<%@ Page language="c#" Debug="true"%>
<script language="c#" runat="server">
/// Uses new ASP.NET style scripting with event Page_Load, uses OleDbDataReader and OleDbCommand to access database
// -------------------------------------------------------------------------------------------------------------------------------
void Page_Load(object sender, System.EventArgs e) 
{
try
{

   // By default (false) it uses SQLite database (Database.db). You can switch to MS Access database (Database.mdb) by setting UseMDB = true 
   // The SQLite loads dynamically its DLL from TreeGrid distribution, it chooses 32bit or 64bit assembly
   // The MDB can be used only on 32bit IIS mode !!! The ASP.NET service program must have write access to the Database.mdb file !!!
   bool UseMDB = false;

   // --- Database initialization ---
   string Path = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath);
   System.Data.IDbConnection Conn = null;
   if (UseMDB) // For MS Acess database
   {
      Conn = new System.Data.OleDb.OleDbConnection("Data Source=\"" + Path + "\\..\\Database.mdb\";Mode=Share Deny None;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Registry Path=;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Engine Type=5;Provider=\"Microsoft.Jet.OLEDB.4.0\";Jet OLEDB:System database=;Jet OLEDB:SFP=False;persist security info=False;Extended Properties=;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Create System Database=False;Jet OLEDB:Don't Copy Locale on Compact=False;User ID=Admin;Jet OLEDB:Global Bulk Transactions=1");
   }
   else // For SQLite database
   {
      System.Reflection.Assembly SQLite = System.Reflection.Assembly.LoadFrom(Path + "\\..\\..\\..\\Server\\SQLite" + (IntPtr.Size == 4 ? "32" : "64") + "\\System.Data.SQLite.DLL");
      Conn = (System.Data.IDbConnection)Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteConnection"), "Data Source=" + Path + "\\..\\Database.db");
   }
   Conn.Open();
   System.Data.IDbCommand Cmd = Conn.CreateCommand();
   
   // --- Response initialization ---
   Response.ContentType = "text/xml";
   Response.Charset = "utf-8";
   Response.AppendHeader("Cache-Control","max-age=1, must-revalidate");
   System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US");
   
   // --- Save data to database ---
   string XML = Request["Data"];
   if (XML != "" && XML != null)
   {
      System.Xml.XmlDocument X = new System.Xml.XmlDocument();
      X.LoadXml(HttpUtility.HtmlDecode(XML));
      System.Xml.XmlNodeList Ch = X.GetElementsByTagName("Changes");
      if (Ch.Count > 0) foreach (System.Xml.XmlElement I in Ch[0])
      {
         string SQL = "";
         string id = I.GetAttribute("id");

         if (I.GetAttribute("Deleted") == "1") SQL = "DELETE FROM Run WHERE id=" + id;
         else if(I.GetAttribute("Added")=="1")
         {
            SQL = "INSERT INTO Run(id,T,S,R) VALUES("
               + id + ","
               + "'" + I.GetAttribute("T").Replace("'", "''") + "',"
               + "'" + I.GetAttribute("S") + "',"
               + "'" + I.GetAttribute("R").Replace("'", "''") + "')";
         }
         else if (I.GetAttribute("Changed") == "1")
         {
            SQL = "UPDATE Run SET ";
            for(int idx=0;idx<I.Attributes.Count;idx++)
            {
               System.Xml.XmlAttribute A = I.Attributes[idx];
               if (A!=null)
               { 
                  string name = A.Name;
                  string val = A.Value;
                  if(name=="T" || name=="R") SQL += name + " = '" + val.Replace("'","''") + "',";
                  else if (name == "S") SQL += name + " = '" + val + "',";
               }
            }
            SQL = SQL.TrimEnd(",".ToCharArray()); // Last comma away
            SQL += " WHERE id=" + id;
         }
         if (SQL != "")
         {
            Cmd.CommandText = SQL;
            //Response.Write(SQL);
            Cmd.ExecuteNonQuery();  
         }
         
      }
      Response.Write("<Grid><IO Result='0'/></Grid>");
   }
   // ---   
   Conn.Close();      
   
} catch(Exception E)
{
   Response.Write("<Grid><IO Result=\"-1\" Message=\"Error in TreeGrid example:&#x0a;&#x0a;"+E.Message.Replace("&","&amp;").Replace("<","&lt;").Replace("\"","&quot;")+"\"/></Grid>");
}
}
// -------------------------------------------------------------------------------------------------------------------------------
</script>
