<%@ WebService Language="c#" Class="Service" %>
///! Support file only, run Service.html instead !
/// Uses ASP.NET service as TreeGrid data source
/// -------------------------------------------------------------------------------------------------------------------------------
using System;
using System.Web;
using System.Web.Services;
// -------------------------------------------------------------------------------------------------------------------------------
[WebService(Namespace = "TreeGrid")]
public class Service : System.Web.Services.WebService
{

   // By default (false) it uses SQLite database (Database.db). You can switch to MS Access database (Database.mdb) by setting UseMDB = true 
   // The SQLite loads dynamically its DLL from TreeGrid distribution, it chooses 32bit or 64bit assembly
   // The MDB can be used only on 32bit IIS mode !!! The ASP.NET service program must have write access to the Database.mdb file !!!
   bool UseMDB = false;
   
   System.Reflection.Assembly SQLite = null; // Required only for SQLite database
   
   // ----------------------------------------------------------------------------------
   public Service()
   {
   
   }

   // ----------------------------------------------------------------------------------
   // Initializization for both web methods
   public System.Data.Common.DbDataAdapter Init()
   {

      // --- Response initialization ---
      Context.Response.ContentType = "text/xml";
      Context.Response.Charset = "utf-8";
      Context.Response.AppendHeader("Cache-Control", "max-age=1, must-revalidate");
      System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US");

      // --- Database initialization ---
      string Path = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath);
      System.Data.IDbConnection Conn = null;
      string SqlStr = "SELECT * FROM TableData";
      
   
      if (UseMDB) // For MS Acess database
      {
         Conn = new System.Data.OleDb.OleDbConnection("Data Source=\"" + Path + "\\..\\Database.mdb\";Mode=Share Deny None;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Registry Path=;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Engine Type=5;Provider=\"Microsoft.Jet.OLEDB.4.0\";Jet OLEDB:System database=;Jet OLEDB:SFP=False;persist security info=False;Extended Properties=;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Create System Database=False;Jet OLEDB:Don't Copy Locale on Compact=False;User ID=Admin;Jet OLEDB:Global Bulk Transactions=1");
         return new System.Data.OleDb.OleDbDataAdapter(SqlStr, (System.Data.OleDb.OleDbConnection)Conn);
      }
      else // For SQLite database
      {
         SQLite = System.Reflection.Assembly.LoadFrom(Path + "\\..\\..\\..\\Server\\SQLite" + (IntPtr.Size == 4 ? "32" : "64") + "\\System.Data.SQLite.DLL");
         Conn = (System.Data.IDbConnection)Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteConnection"), "Data Source=" + Path + "\\..\\Database.db");
         return (System.Data.Common.DbDataAdapter)Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteDataAdapter"), SqlStr, Conn); //*/
      }
   }
   
   // ----------------------------------------------------------------------------------
   // Web method returns xml data
   [WebMethod]
   public string GetData(string Userparam)
   {
   try 
   {
      // --- initialization ---
      System.Data.Common.DbDataAdapter Sql = Init();
      System.Data.DataTable D = new System.Data.DataTable();
      Sql.Fill(D);
      
      // --- generating data ---
      System.Xml.XmlDocument X = new System.Xml.XmlDocument();
      System.Xml.XmlElement G, BB, B, I; 
      G = X.CreateElement("Grid"); X.AppendChild(G);
      BB = X.CreateElement("Body"); G.AppendChild(BB);
      B = X.CreateElement("B"); BB.AppendChild(B);
      foreach (System.Data.DataRow R in D.Rows)
      {
         I = X.CreateElement("I");
         B.AppendChild(I);
         I.SetAttribute("id", R[0].ToString());
         I.SetAttribute("Project", R[1].ToString());
         I.SetAttribute("Resource", R[2].ToString());
         I.SetAttribute("Week", R[3].ToString());
         I.SetAttribute("Hours", R[4].ToString());
      }
      return X.InnerXml;   
   } catch(Exception E)
   {
      return "<Grid><IO Result=\"-1\" Message=\"Error in TreeGrid example:&#x0a;&#x0a;"+E.Message.Replace("&","&amp;").Replace("<","&lt;").Replace("\"","&quot;")+"\"/></Grid>";
   }
   }

   // ----------------------------------------------------------------------------------
   // Web method saves changes to database
   [WebMethod]
   public string SaveData(string TGData, string Userparam)
   {
   try
   {
      // --- initialization ---
      System.Data.Common.DbDataAdapter Sql = Init();
      System.Data.DataTable D = new System.Data.DataTable();
      Sql.Fill(D);
      
      // --- Save data to database ---
      if (TGData != "" && TGData != null)
      {
         System.Xml.XmlDocument X = new System.Xml.XmlDocument();
         X.LoadXml(HttpUtility.HtmlDecode(TGData));
         System.Xml.XmlNodeList Ch = X.GetElementsByTagName("Changes");
         if (Ch.Count > 0) foreach (System.Xml.XmlElement I in Ch[0])
         {
            string id = I.GetAttribute("id");
            System.Data.DataRow R;
            if (I.GetAttribute("Added") == "1")
            {
               R = D.NewRow();
               R["ID"] = id;
               D.Rows.Add(R);
            }
            else R = D.Select("[ID]='" + id + "'")[0];
      
            if (I.GetAttribute("Deleted") == "1") R.Delete();
            else if (I.GetAttribute("Added") == "1" || I.GetAttribute("Changed") == "1")
            {
               if (I.HasAttribute("Project")) R["Project"] = I.GetAttribute("Project");
               if (I.HasAttribute("Resource")) R["Resource"] = I.GetAttribute("Resource");
               if (I.HasAttribute("Week")) R["Week"] = System.Double.Parse(I.GetAttribute("Week"));
               if (I.HasAttribute("Hours")) R["Hours"] = System.Double.Parse(I.GetAttribute("Hours"));               
            }
         }
         
         if (UseMDB) new System.Data.OleDb.OleDbCommandBuilder((System.Data.OleDb.OleDbDataAdapter)Sql); // For MS Acess database
         else Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteCommandBuilder"), Sql); // For SQLite database

         Sql.Update(D);                     // Updates changed to database
      }
      return "<Grid><IO Result='0'/></Grid>";
      
   } catch(Exception E)
   {
      return "<Grid><IO Result=\"-1\" Message=\"Error in TreeGrid example:&#x0a;&#x0a;"+E.Message.Replace("&","&amp;").Replace("<","&lt;").Replace("\"","&quot;")+"\"/></Grid>";
   }
   }
   // ----------------------------------------------------------------------------------
}      

// -------------------------------------------------------------------------------------------------------------------------------

