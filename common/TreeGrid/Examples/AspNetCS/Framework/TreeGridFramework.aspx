<script language="c#" runat="server">
/// -------------------------------------------------------------------------------------------------------------------------------
/// TreeGrid Framework for accessing database
/// It contains two basic functions:
/// string LoadXMLFromDB()  Returns data in XML, from database for TreeGrid 
/// SaveXMLToDB(string XML) Saves changes in XML from TreeGrid to database
/// TreeGrid can be created by 
///    new TreeGrid(ConnectionString, SelectString, DBIdCol, IdPrefix, DBParentCol, DBDefCol)
///       ConnectionString = "" // Required - Connection string for accessing database, that can be used global variable Path as path to actual script
///       SelectString = ""     // Required - SQL command SELECT to get data from database
///       DBIdCol = "ID"        // Column name in database table where are stored unique row ids
///       IdPrefix = ""         // Prefix added in front of id, used if ids are number type, the same prefix must be in Layout <Cfg IdPrefix=''/>
///       DBParentCol = ""      // Column name in database table where are stored parent row ids, if is empty, the grid does not contain tree
///       DBDefCol = ""         // Column name in database table where are stored Def parameters (predefined values in Layout, used usually in tree)
///       SQLiteDLL = null      // Path to SQLite.DLL if used SQLite instead of MS Access MDB
/// -------------------------------------------------------------------------------------------------------------------------------


// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Returns directory path to aspx file
string GetPath()
{
   return System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath); 
}
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Main component to load and save TreeGrid XML data from and to database
class TreeGrid {
   string DBIdCol;           //Column name in database table where are stored unique row ids
   string IdPrefix;          //Prefix added in front of id, used if ids are number type
   string DBParentCol;       //Column name in database table where are stored parent row ids, if is empty, the grid does not contain tree
   string DBDefCol;          //Column name in database table where are stored Def parameters (predefined values in Layout, used usually in tree
   System.Data.DataTable D;
   System.Data.Common.DbDataAdapter Sql;
   System.Globalization.CultureInfo EngFormat;
   System.Reflection.Assembly SQLite; // Library for SQLite only
   
   // -------------------------------------------------------------------------------------------------------------------------------
   // Constructor, creates and initializes object according to input parameters
   public TreeGrid(string connectionString, string selectString, string dBIdCol, string idPrefix, string dBParentCol, string dBDefCol, string SQLiteDLL)
   {
      DBIdCol = dBIdCol==null || dBIdCol=="" ? "id" : dBIdCol;
      IdPrefix = idPrefix==null ? "" : idPrefix;
      DBParentCol = dBParentCol == null ? "" : dBParentCol;
      DBDefCol = dBDefCol==null || dBDefCol=="" ? "" : dBDefCol;
      EngFormat = System.Globalization.CultureInfo.CreateSpecificCulture("en-US"); // English culture is used by TreeGrid input
      System.Data.IDbConnection Conn;
      if (connectionString.IndexOf("Microsoft.Jet") >= 0 || SQLiteDLL==null)
      {
         SQLite = null;
         Conn = new System.Data.OleDb.OleDbConnection(connectionString);
         Sql = new System.Data.OleDb.OleDbDataAdapter(selectString, (System.Data.OleDb.OleDbConnection)Conn);
      }
      else
      {
         SQLite = System.Reflection.Assembly.LoadFrom(SQLiteDLL);
         Conn = (System.Data.IDbConnection)Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteConnection"), connectionString);
         Sql = (System.Data.Common.DbDataAdapter)Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteDataAdapter"), selectString, Conn); //*/
      }
      D = new System.Data.DataTable();
      Sql.Fill(D);
   }
   
   // -------------------------------------------------------------------------------------------------------------------------------
   // Helper function for LoadXMLFromDB to read data from database table and convert them to TreeGrid XML
   // Adds to E as children all rows with Parent==Sec
   // If Sec is null adds all rows (for non tree tables)
   void GetChildrenXML(System.Xml.XmlElement E, string Sec)
   {
      System.Data.DataRow[] Rows = DBParentCol == "" ? D.Select("") : D.Select("[" + DBParentCol + "]='" + Sec + "'");
      foreach (System.Data.DataRow R in Rows)
      {
         System.Xml.XmlElement I = E.OwnerDocument.CreateElement("I");
         E.AppendChild(I);
         foreach (System.Data.DataColumn C in D.Columns)
         {
            if (C.ColumnName == DBParentCol) continue;
            string S; object O = R[C]; Type T = O.GetType();
            if (T == Type.GetType("System.String")) S = O.ToString();
            else if (T == Type.GetType("System.DateTime")) S = ((DateTime)O).ToString("M/d/yyyy HH:mm:ss", EngFormat);
            else if (T == Type.GetType("System.Double")) S = ((double)O).ToString(EngFormat);
            else if (T == Type.GetType("System.Single")) S = ((float)O).ToString(EngFormat);
            else if (T == Type.GetType("System.DBNull") || O == null) continue;
            else S = O.ToString();
            if (C.ColumnName == DBIdCol) I.SetAttribute("id", IdPrefix+S);
            else I.SetAttribute(C.ColumnName, S);
         }
         if (DBParentCol != "") GetChildrenXML(I, R[DBIdCol].ToString());
      }
   }
   
   // -------------------------------------------------------------------------------------------------------------------------------
   // Loads data from database table and returns them as XML string
   public string LoadXMLFromDB()
   {
      System.Xml.XmlDocument X = new System.Xml.XmlDocument();
      System.Xml.XmlElement G, S, B;
      G = X.CreateElement("Grid"); X.AppendChild(G);
      if (DBParentCol != "")
      {
         S = X.CreateElement("Head"); G.AppendChild(S); GetChildrenXML(S, "#Head");
         S = X.CreateElement("Foot"); G.AppendChild(S); GetChildrenXML(S, "#Foot");
         S = X.CreateElement("Body"); G.AppendChild(S); B = X.CreateElement("B"); S.AppendChild(B); GetChildrenXML(B, "#Body");
      }
      else
      {
         S = X.CreateElement("Body"); G.AppendChild(S); B = X.CreateElement("B"); S.AppendChild(B); GetChildrenXML(B, "");
      }
      return X.InnerXml;
   }
   
   // -------------------------------------------------------------------------------------------------------------------------------
   // Saves to database changes in TreeGrid XML format
   public void SaveXMLToDB(string XML)
   {
      System.Xml.XmlDocument X = new System.Xml.XmlDocument();
      X.LoadXml(HttpUtility.HtmlDecode(XML));
      System.Xml.XmlNodeList A = X.GetElementsByTagName("Changes");
      if (A.Count > 0) foreach (System.Xml.XmlElement E in A[0])
         {
            try
            {
               string id = E.GetAttribute("id");
               if (IdPrefix != "") id = id.Substring(IdPrefix.Length);
               System.Data.DataRow R;
               if (E.GetAttribute("Added") == "1")
               {
                  R = D.NewRow();
                  R[DBIdCol] = id;
                  D.Rows.Add(R);
               }
                  
               else R = D.Select("[" + DBIdCol + "]="+"'" + id + "'")[0];
               if (E.GetAttribute("Deleted") == "1")
               {
                  R.Delete(); continue;
               }
               if (E.GetAttribute("Added") == "1" || E.GetAttribute("Moved") == "2")
               {
                  string Parent = E.GetAttribute("Parent");
                  if (DBParentCol != "")
                  {
                     if (Parent == "") Parent = "#Body";
                     R["Parent"] = Parent;
                  }
                  E.RemoveAttribute("Parent");
                  E.RemoveAttribute("Next");   // Next is ignored, because row position is variable by sorting
                  E.RemoveAttribute("Prev");
               }
               if (E.GetAttribute("Added") == "1" || E.GetAttribute("Changed") == "1")
               {
                  E.RemoveAttribute("Added");
                  E.RemoveAttribute("Changed");
                  E.RemoveAttribute("id");
                  foreach (System.Xml.XmlAttribute Att in E.Attributes)
                  {
                     if (D.Columns[Att.Name] == null) continue;
                     object O; string Str = Att.Value; Type T = D.Columns[Att.Name].DataType;
                     if (T == Type.GetType("System.String")) O = Str;
                     else if (T == Type.GetType("System.DateTime")) O = DateTime.Parse(Str, EngFormat);
                     else if (T == Type.GetType("System.Double")) O = Double.Parse(Str, EngFormat);
                     else if (T == Type.GetType("System.Single")) O = Single.Parse(Str, EngFormat);
                     else O = Int32.Parse(Str, EngFormat);
                     R[Att.Name] = O;
                  }
               }
            }
            catch {  }
         }
      if (SQLite == null) new System.Data.OleDb.OleDbCommandBuilder((System.Data.OleDb.OleDbDataAdapter)Sql);
      else Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteCommandBuilder"), Sql);
     
      Sql.Update(D);      // Updates changed to database
      D.AcceptChanges(); 
      
   }
};
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
</script>