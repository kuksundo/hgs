<%@ Page language="c#"%>
<!-----------------------------------------------------------------------------------------------------------------
Example of TreeGrid using synchronous (submit, non AJAX) communication with server
Example of simple table without tree
Uses OleDbDataReader and OleDbCommand for database communication
Uses new ASP.NET style scripting with event Page_Load
Uses MS Access database Database.mdb and table "TableData" as data and XML file DBDef.xml as TreeGrid layout
! Check if ASP.NET application has write access to Database.mdb file
------------------------------------------------------------------------------------------------------------------>
<html>
   <head>
      <script src="../../../Grid/GridE.js"> </script>
      <link href="../../../Styles/Examples.css" rel="stylesheet" type="text/css" />
   </head>
   <body>
      <h2>OleDbCommand database access</h2>
      <div style="WIDTH:100%;HEIGHT:90%">
         <bdo 
            Layout_Url="DBDef.xml" 
            Data_Tag="TGData" 
            Upload_Tag="TGData" Upload_Format="Internal"
            Export_Url="../Framework/Export.aspx" Export_Data="TGData" Export_Param_File="Table.xls"
            ></bdo>
      </div>
      <form id="Form1" method="post" runat="server">
         <input id="TGData" type="hidden" runat="server"/>
         <input type="submit" value="Submit changes to server"/>
      </form>
   </body>
</html>
<script language="c#" runat="server">
// -------------------------------------------------------------------------------------------------------------------------------
void Page_Load(object sender, System.EventArgs e) 
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
   Response.ContentType = "text/html";
   Response.Charset = "utf-8";
   Response.AppendHeader("Cache-Control","max-age=1, must-revalidate");
   System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US");

   // --- Save data to database ---
   string XML = TGData.Value;
   if (XML != "" && XML != null)
   {
      System.Xml.XmlDocument X = new System.Xml.XmlDocument();
      X.LoadXml(HttpUtility.HtmlDecode(XML));
      System.Xml.XmlNodeList Ch = X.GetElementsByTagName("Changes");
      if (Ch.Count > 0) foreach (System.Xml.XmlElement I in Ch[0])
      {
         string SQL = "";
         string id = I.GetAttribute("id");
         
         if(I.GetAttribute("Deleted")=="1") SQL = "DELETE FROM TableData WHERE ID=" + id;
         else if(I.GetAttribute("Added")=="1")
         {
            SQL = "INSERT INTO TableData(ID,Project,Resource,Week,Hours) VALUES("
               + id + ","
               + "'" + I.GetAttribute("Project").Replace("'","''") + "'," 
               + "'" + I.GetAttribute("Resource").Replace("'","''") + "'," 
               + I.GetAttribute("Week") + "," 
               + I.GetAttribute("Hours") + ")";
         }
         else if(I.GetAttribute("Changed")=="1")
         {
            SQL = "UPDATE TableData SET ";
            for(int idx=0;idx<I.Attributes.Count;idx++)
            {
               System.Xml.XmlAttribute A = I.Attributes[idx];
               if (A!=null)
               { 
                  string name = A.Name;
                  string val = A.Value;
                  if(name=="Project" || name=="Resource") SQL += name + " = '" + val.Replace("'","''") + "',";
                  else if(name=="Week" || name=="Hours") SQL += name + " = " + val + ",";
               }
            }
            SQL = SQL.TrimEnd(",".ToCharArray()); // Last comma away
            SQL += " WHERE ID=" + id;
         }
         Cmd.CommandText = SQL;
         Cmd.ExecuteNonQuery();  
      }
   }

   // --- Load data from database ---
   {
      Cmd.CommandText = "SELECT * FROM TableData";
      System.Data.IDataReader R = Cmd.ExecuteReader();

      XML = "<Grid><Body><B>";
      while (R.Read())
      {
         XML += "<I id='" + R[0].ToString() + "'"
            + " Project='" + R[1].ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'"
            + " Resource='" + R[2].ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'"
            + " Week='" + R[3].ToString() + "'"
            + " Hours='" + R[4].ToString() + "'"
            + "/>";
      }
      XML += "</B></Body></Grid>";
      TGData.Value = XML;
      R.Close();
   }

   // ---   
   Conn.Close();      
}
// -------------------------------------------------------------------------------------------------------------------------------
</script>
