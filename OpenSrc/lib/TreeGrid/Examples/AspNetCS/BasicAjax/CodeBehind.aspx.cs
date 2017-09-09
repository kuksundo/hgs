using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

public class TreeGrid : System.Web.UI.Page 
{
    protected void Page_Load(object sender, EventArgs e)
    {
    try 
    {
        // By default (false) it uses SQLite database (Database.db). You can switch to MS Access database (Database.mdb) by setting UseMDB = true 
        // The SQLite loads dynamically its DLL from TreeGrid distribution, it chooses 32bit or 64bit assembly
        // The MDB can be used only on 32bit IIS mode !!! The ASP.NET service program must have write access to the Database.mdb file !!!
        bool UseMDB = false;

        // --- Response initialization ---
        Response.ContentType = "text/xml";
        Response.Charset = "utf-8";
        Response.AppendHeader("Cache-Control", "max-age=1, must-revalidate");
        System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US");

        // --- Database initialization ---
        string Path = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath);
        System.Data.IDbConnection Conn = null;
        System.Data.Common.DbDataAdapter Sql = null;
        System.Data.Common.DbCommandBuilder Bld = null;
        string SqlStr = "SELECT * FROM TableData";
        System.Reflection.Assembly SQLite = null; // Required only for SQLite database

        if (UseMDB) // For MS Acess database
        {
           Conn = new System.Data.OleDb.OleDbConnection("Data Source=\"" + Path + "\\..\\Database.mdb\";Mode=Share Deny None;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Registry Path=;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Engine Type=5;Provider=\"Microsoft.Jet.OLEDB.4.0\";Jet OLEDB:System database=;Jet OLEDB:SFP=False;persist security info=False;Extended Properties=;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Create System Database=False;Jet OLEDB:Don't Copy Locale on Compact=False;User ID=Admin;Jet OLEDB:Global Bulk Transactions=1");
           Sql = new System.Data.OleDb.OleDbDataAdapter(SqlStr, (System.Data.OleDb.OleDbConnection)Conn);
        }
        else // For SQLite database
        {
           SQLite = System.Reflection.Assembly.LoadFrom(Path + "\\..\\..\\..\\Server\\SQLite" + (IntPtr.Size == 4 ? "32" : "64") + "\\System.Data.SQLite.DLL");
           Conn = (System.Data.IDbConnection)Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteConnection"), "Data Source=" + Path + "\\..\\Database.db");
           Sql = (System.Data.Common.DbDataAdapter)Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteDataAdapter"), SqlStr, Conn); //*/
        }

        System.Data.DataTable D = new System.Data.DataTable();
        Sql.Fill(D);
        
        // --- Save data to database ---
        System.Xml.XmlDocument X = new System.Xml.XmlDocument();
        string XML = Request["TGData"];
        if (XML != "" && XML != null)
        {

            X.LoadXml(HttpUtility.HtmlDecode(XML));
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
            D.AcceptChanges();
            X.RemoveAll();
            Response.Write("<Grid><IO Result='0'/></Grid>");
        }

        // --- Load data from database ---
        else 
        {
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
            Response.Write(X.InnerXml);
        }
   }  catch(Exception E)
      {
         Response.Write("<Grid><IO Result=\"-1\" Message=\"Error in TreeGrid example:&#x0a;&#x0a;"+E.Message.Replace("&","&amp;").Replace("<","&lt;").Replace("\"","&quot;")+"\"/></Grid>");
      }
   }
}
