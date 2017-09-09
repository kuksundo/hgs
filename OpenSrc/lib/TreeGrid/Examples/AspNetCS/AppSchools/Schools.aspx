<%@ Page language="c#" Debug="true"%>
<%
///! Support file only, run Schools.html instead !
/// This file is used as Data_Url and Upload_Url
/// Main application for Schools, generates data, saves changes, adds or modifies users and so on
/// Single file, without using TreeGridFramework.aspx
// -------------------------------------------------------------------------------------------------------------------------------

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
System.Data.IDataReader R;

// --- Response initialization ---
Response.ContentType = "text/xml";
Response.Charset = "utf-8";
Response.AppendHeader("Cache-Control","max-age=1, must-revalidate");
System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US");

// --- Input parameters initalization ---
string User = Request["User"] == null ? "" : Request["User"].ToLower();
string Pass = Request["Pass"] == null ? "" : Request["Pass"];
bool NewUser = Request["New"]!=null && Request["New"]!="0";

Response.Write("<Grid>");
bool Err = false;

// --- Adding new user ---
if(NewUser)
{
   Cmd.CommandText = "SELECT Pass FROM Schools_Users WHERE Name='" + User.Replace("'","''") + "'";
   R = Cmd.ExecuteReader();
   if(!R.Read())   //Ok, possible
   {
      R.Close();
      Cmd.CommandText = "INSERT INTO Schools_Users(Name,Pass) VALUES ('" + User.Replace("'","''") + "','" + Pass.Replace("'","''") + "')";
      Cmd.ExecuteNonQuery();
      Response.Write ("<IO Message='User " + User.Replace("&","&amp;").Replace("'","&apos;").Replace("<","&lt;") + " has been added successfuly'/>");
   }
   else
   {
      R.Close();
      Response.Write ("<IO Result='-1' Message='User name already exists !'/><Lang><Text StartErr='User name already exists !'/></Lang></Grid>");
      Err = true;
   }
}

// --- Password verification ---
if (!Err && User!="")
{
   Cmd.CommandText = "SELECT Pass FROM Schools_Users WHERE Name='" + User.Replace("'","''") + "'";
   R = Cmd.ExecuteReader();
   if(!R.Read() || Pass!=R[0].ToString())
   {
      Response.Write("<IO Result='-1' Message='Wrong user name or password !'/><Lang><Text StartErr='Wrong user name or password !'/></Lang></Grid>");
      Err = true;
   }
   R.Close();
}
bool Admin = User=="admin";   // @@@ Or change this code to another admin

//------------------------------------------------------------------------------------------------------------------
// --- Saves data ---
string XML = Request["TGData"];
if (XML != "" && XML != null)
{
   if(User=="") Response.Write ("<IO Result='-1' Message='The user have not permission to save data !'/></Grid>");  //Attack or bug
   else
   {
      System.Xml.XmlDocument X = new System.Xml.XmlDocument();
      X.LoadXml(HttpUtility.HtmlDecode(XML));
      System.Xml.XmlNodeList Ch = X.GetElementsByTagName("Changes");
      if (Ch.Count > 0) foreach (System.Xml.XmlElement I in Ch[0])
      {
         string[] ids = I.GetAttribute("id").Split("$".ToCharArray());  // User$Def$Ident
         string id = " Owner='" + ids[0].Replace("'","''") + "' AND Id=" + ids[2];
         if(ids[1]!="Main") // Child row (Address, Phone, Link, Map)
         {
            if ((I.GetAttribute("Added")=="1" || I.GetAttribute("Changed")=="1") && I.HasAttribute("CCountry"))
            {
               Cmd.CommandText = "UPDATE Schools_Schools SET " + ids[1] + " = '" + I.GetAttribute("CCountry").Replace("'","''") + "' WHERE" + id;
               Cmd.ExecuteNonQuery();
            }
         }      
         else if (I.GetAttribute("Deleted")=="1")
         {
            Cmd.CommandText = "DELETE FROM Schools_Schools WHERE" + id;
            Cmd.ExecuteNonQuery();
            Cmd.CommandText = "DELETE FROM Schools_Ratings WHERE" + id;
            Cmd.ExecuteNonQuery();
         }     
         else if (I.GetAttribute("Added")=="1")
         {
            Cmd.CommandText = "INSERT INTO Schools_Schools(Owner,Id,Name,Country,State,County,Town,SLevel,Type,FromGrade,ToGrade,Enrollment,Students) VALUES (" 
               + "'" + I.GetAttribute("CUser").Replace("'","''") + "','" + ids[2] + "','" + I.GetAttribute("CName").Replace("'","''") + "',"
               + I.GetAttribute("CCountry") + "," + I.GetAttribute("CState") + "," + I.GetAttribute("CCounty") + ","
               + "'" + I.GetAttribute("CTown").Replace("'","''") + "'," 
               + I.GetAttribute("CLevel") + "," + I.GetAttribute("CType") + ","
               + I.GetAttribute("CGrade1") + "," + I.GetAttribute("CGrade2") + ","
               + I.GetAttribute("CEnrollment") + "," + I.GetAttribute("CStudents")
               + ")";
            Cmd.ExecuteNonQuery();
         }     
         else if (I.GetAttribute("Changed")=="1")
         {
            string Str = "";
            if (I.HasAttribute("CName")) Str += "Name='" +I.GetAttribute("CName").Replace("'","''") + "',";
            if (I.HasAttribute("CCountry")) Str += "Country=" + I.GetAttribute("CCountry") + ",";
            if (I.HasAttribute("CState")) Str += "State=" + I.GetAttribute("CState") + ",";
            if (I.HasAttribute("CCounty")) Str += "County=" + I.GetAttribute("CCounty") + ",";
            if (I.HasAttribute("CTown")) Str += "Town='" + I.GetAttribute("CTown").Replace("'","''") + "',";
            if (I.HasAttribute("CLevel")) Str += "SLevel=" + I.GetAttribute("CLevel") + ",";
            if (I.HasAttribute("CType")) Str += "Type=" + I.GetAttribute("CType") + ",";
            if (I.HasAttribute("CGrade1")) Str += "FromGrade=" + I.GetAttribute("CGrade1") + ",";
            if (I.HasAttribute("CGrade2")) Str += "ToGrade=" + I.GetAttribute("CGrade2") + ",";
            if (I.HasAttribute("CEnrollment")) Str += "Enrollment=" + I.GetAttribute("CEnrollment") + ",";
            if (I.HasAttribute("CStudents")) Str += "Students=" + I.GetAttribute("CStudents") + ",";
            string Str2 = "";
            if (Admin && I.HasAttribute("CUser")) Str2 += "Owner='" + I.GetAttribute("CUser").Replace("'","''") + "',";
            if (Admin && I.HasAttribute("Ident")) Str2 += "Id='" + I.GetAttribute("Ident") + "',";
            Str = Str + Str2;
            if(Str != "") 
            {
               Cmd.CommandText = "UPDATE Schools_Schools SET " + Str.TrimEnd(",".ToCharArray()) + " WHERE " + id;
               Cmd.ExecuteNonQuery();
            }
            if(Str2 != "") 
            {
               Cmd.CommandText = "UPDATE Schools_Ratings SET " + Str2.TrimEnd(",".ToCharArray()) + " WHERE " + id;   //Updates changes in user/id in Ratings
               Cmd.ExecuteNonQuery();
            }
         }
      }
   }
   Response.Write ("<IO Result='0'/></Grid>");
}
//------------------------------------------------------------------------------------------------------------------
// --- Reads data ---
else if (!Err)
{
   string Str = "";
   if (User == "") Str += "<Cfg Adding='0' Deleting='0' Editing='0'/><Toolbar Save='0'/>";
   else 
   {
      Str += "<Def><D Name='R' CUser='" + User.Replace("&","&amp;").Replace("'","&apos;").Replace("<","&lt;") + "'/></Def>";
      Str += "<Cols><C Name='CRating' Button='None'/></Cols>";
   }
   if(!Admin) Str += "<RightCols><C Name='CUser' Visible='0' CanHide='0' CanPrint='0' CanExport='0'/></RightCols>";
   
   Str += "<Body><B>";
   string SQL = "SELECT * FROM Schools_Schools";
   if (User!="" && !Admin) SQL += " WHERE Owner='" + User.Replace("'","''") + "'";
   Cmd.CommandText = SQL;
   R = Cmd.ExecuteReader();
   while(R.Read())
   {
      string id = " Ident='" + R["ID"].ToString() + "' CUser='" + R["Owner"].ToString().Replace("&","&amp;").Replace("'","&apos;").Replace("<","&lt;") + "'";
      Str += "<I Def='Main' " + id;
      Str += " CName='" + R["Name"].ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'";
      Str += " CCountry='" + R["Country"].ToString() + "'";
      Str += " CState='" + R["State"].ToString() + "'";
      Str += " CCounty='" + R["County"].ToString() + "'";
      Str += " CTown='" + R["Town"].ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'";
      Str += " CLevel='"  + R["SLevel"].ToString() + "'";
      Str += " CType='" + R["Type"].ToString() + "'";
      Str += " CGrade1='" + R["FromGrade"].ToString() + "'";
      Str += " CGrade2='" + R["ToGrade"].ToString() + "'";
      Str += " CEnrollment='" + R["Enrollment"].ToString() + "'";
      Str += " CStudents='" + R["Students"].ToString() + "'";
      Str += ">";
      Str += "<I Def='Address' " + id + " CCountry='" + R["Address"].ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'/>";
      Str += "<I Def='Phone' " + id + " CCountry='" + R["Phone"].ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'/>";
      Str += "<I Def='Link' " + id + " CCountry='" + R["Link"].ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'/>";
      Str += "<I Def='Map' " + id + " CCountry='" + R["Map"].ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'/>";
      Str += "<I Def='Reviews' " + id + " Count='" + R["RatingCnt"].ToString() + "'  CRatingsum='" + R["RatingSum"].ToString() + "'>";
      Str += "</I>";
      Str += "</I>";
   }
   Str += "</B></Body></Grid>";
   Response.Write(Str);
   R.Close();
}
Conn.Close();
// --------------------------------------------------------------------------
%>