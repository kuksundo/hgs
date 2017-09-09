<%@ Page language="vb" Debug="true"%>
<%
   '! Support file only, run Schools.html instead !
   ' This file is used as Data_Url and Upload_Url
   ' Main application for Schools, generates data, saves changes, adds or modifies users and so on
   ' Single file, without using TreeGridFramework.aspx

   ' By default (false) it uses SQLite database (Database.db). You can switch to MS Access database (Database.mdb) by setting UseMDB = true 
   ' The SQLite loads dynamically its DLL from TreeGrid distribution, it chooses 32bit or 64bit assembly
   ' The MDB can be used only on 32bit IIS mode !!! The ASP.NET service program must have write access to the Database.mdb file !!!
   Dim UseMDB As Boolean = False
   ' --- Database initialization ---
   Dim Path As String = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath)
   Dim Conn As System.Data.IDbConnection = Nothing
      
   If UseMDB Then ' For MS Acess database
      Conn = New System.Data.OleDb.OleDbConnection("Data Source=""" + Path + "\\..\\Database.mdb"";Provider=""Microsoft.Jet.OLEDB.4.0"";Mode=Share Deny None;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Registry Path=;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Engine Type=5;Jet OLEDB:System database=;Jet OLEDB:SFP=False;persist security info=False;Extended Properties=;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Create System Database=False;Jet OLEDB:Don't Copy Locale on Compact=False;User ID=Admin;Jet OLEDB:Global Bulk Transactions=1")
   Else ' For SQLite database
      Dim SQLite As System.Reflection.Assembly = Nothing ' Required only for SQLite database
      Dim bits As String = "32" : If IntPtr.Size <> 4 Then bits = "64"
      SQLite = System.Reflection.Assembly.LoadFrom(Path + "\\..\\..\\..\\Server\\SQLite" + bits + "\\System.Data.SQLite.DLL")
      Conn = Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteConnection"), "Data Source=" + Path + "\\..\\Database.db")
   End If
   Conn.Open()
   Dim Cmd As System.Data.IDbCommand = Conn.CreateCommand()
   Dim R As System.Data.IDataReader
   
   ' --- Response initialization ---
   Response.ContentType = "text/xml"
   Response.Charset = "utf-8"
   Response.AppendHeader("Cache-Control", "max-age=1, must-revalidate")
   System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US")


   ' --- Input parameters initalization ---
   Dim User, Pass As String, Err, NewUser, Admin As Boolean
   User = Request("User") : If User = Nothing Then User = ""
   User = User.ToLower()
   Pass = Request("Pass") : If Pass = Nothing Then Pass = ""
   NewUser = Request("New") <> Nothing And Request("New") <> "0"

   Response.Write("<Grid>")
   Err = False

   ' --- Adding new user ---
   If NewUser Then
      Cmd.CommandText = "SELECT Pass FROM Schools_Users WHERE Name='" + User.Replace("'", "''") + "'"
      R = Cmd.ExecuteReader()
      If Not R.Read() Then    'Ok, possible
         R.Close()
         Cmd.CommandText = "INSERT INTO Schools_Users(Name,Pass) VALUES ('" + User.Replace("'", "''") + "','" + Pass.Replace("'", "''") + "')"
         Cmd.ExecuteNonQuery()
         Response.Write("<IO Message='User " + User.Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + " has been added successfuly'/>")
      Else
         R.Close()
         Response.Write("<IO Result='-1' Message='User name already exists !'/><Lang><Text StartErr='User name already exists !'/></Lang></Grid>")
         Err = True
      End If
   End If

   ' --- Password verification ---
   If Not Err And User <> "" Then
      Cmd.CommandText = "SELECT Pass FROM Schools_Users WHERE Name='" + User.Replace("'", "''") + "'"
      R = Cmd.ExecuteReader()
      If Not R.Read() Or Pass <> R(0).ToString() Then
         Response.Write("<IO Result='-1' Message='Wrong user name or password !'/><Lang><Text StartErr='Wrong user name or password !'/></Lang></Grid>")
         Err = True
      End If
      R.Close()
   End If
   Admin = User = "admin"   ' @@@ Or change this code to another admin

   '------------------------------------------------------------------------------------------------------------------
   ' --- Saves data ---
   Dim XML As String : XML = Request("TGData")
   If XML <> "" And XML <> Nothing Then
      If User = "" Then
         Response.Write("<IO Result='-1' Message='The user have not permission to save data !'/></Grid>") 'Attack or bug
      Else
         Dim X As System.Xml.XmlDocument = New System.Xml.XmlDocument()
         X.LoadXml(HttpUtility.HtmlDecode(XML))
         Dim Ch As System.Xml.XmlNodeList = X.GetElementsByTagName("Changes")
         If Ch.Count > 0 Then
            For Each I As System.Xml.XmlElement In Ch(0)
               Dim id, ids() As String
               ids = I.GetAttribute("id").Split("$".ToCharArray())  ' User$Def$Ident
               id = " Owner='" + ids(0).Replace("'", "''") + "' AND Id=" + ids(2)
               If ids(1) <> "Main" Then ' Child row (Address, Phone, Link, Map)
                  If (I.GetAttribute("Added") = "1" Or I.GetAttribute("Changed") = "1") And I.HasAttribute("CCountry") Then
                     Cmd.CommandText = "UPDATE Schools_Schools SET " + ids(1) + " = '" + I.GetAttribute("CCountry").Replace("'", "''") + "' WHERE" + id
                     Cmd.ExecuteNonQuery()
                  End If

               ElseIf I.GetAttribute("Deleted") = "1" Then
                  Cmd.CommandText = "DELETE FROM Schools_Schools WHERE" + id
                  Cmd.ExecuteNonQuery()
                  Cmd.CommandText = "DELETE FROM Schools_Ratings WHERE" + id
                  Cmd.ExecuteNonQuery()
              
               ElseIf I.GetAttribute("Added") = "1" Then
                  Cmd.CommandText = "INSERT INTO Schools_Schools(Owner,Id,Name,Country,State,County,Town,SLevel,Type,FromGrade,ToGrade,Enrollment,Students) VALUES (" _
                     + "'" + I.GetAttribute("CUser").Replace("'", "''") + "','" + ids(2) + "','" + I.GetAttribute("CName").Replace("'", "''") + "'," _
                     + I.GetAttribute("CCountry") + "," + I.GetAttribute("CState") + "," + I.GetAttribute("CCounty") + "," _
                     + "'" + I.GetAttribute("CTown").Replace("'", "''") + "'," _
                     + I.GetAttribute("CLevel") + "," + I.GetAttribute("CType") + "," _
                     + I.GetAttribute("CGrade1") + "," + I.GetAttribute("CGrade2") + "," _
                     + I.GetAttribute("CEnrollment") + "," + I.GetAttribute("CStudents") _
                     + ")"
                  Cmd.ExecuteNonQuery()
                  
               ElseIf I.GetAttribute("Changed") = "1" Then
                  Dim Str, Str2 As String : Str = "" : Str = ""
                  If (I.HasAttribute("CName")) Then Str = Str + "Name='" + I.GetAttribute("CName").Replace("'", "''") + "',"
                  If (I.HasAttribute("CCountry")) Then Str = Str + "Country=" + I.GetAttribute("CCountry") + ","
                  If (I.HasAttribute("CState")) Then Str = Str + "State=" + I.GetAttribute("CState") + ","
                  If (I.HasAttribute("CCounty")) Then Str = Str + "County=" + I.GetAttribute("CCounty") + ","
                  If (I.HasAttribute("CTown")) Then Str = Str + "Town='" + I.GetAttribute("CTown").Replace("'", "''") + "',"
                  If (I.HasAttribute("CLevel")) Then Str = Str + "SLevel=" + I.GetAttribute("CLevel") + ","
                  If (I.HasAttribute("CType")) Then Str = Str + "Type=" + I.GetAttribute("CType") + ","
                  If (I.HasAttribute("CGrade1")) Then Str = Str + "FromGrade=" + I.GetAttribute("CGrade1") + ","
                  If (I.HasAttribute("CGrade2")) Then Str = Str + "ToGrade=" + I.GetAttribute("CGrade2") + ","
                  If (I.HasAttribute("CEnrollment")) Then Str = Str + "Enrollment=" + I.GetAttribute("CEnrollment") + ","
                  If (I.HasAttribute("CStudents")) Then Str = Str + "Students=" + I.GetAttribute("CStudents") + ","
                  If (Admin And I.HasAttribute("CUser")) Then Str2 = Str2 + "Owner='" + I.GetAttribute("CUser").Replace("'", "''") + "',"
                  If (Admin And I.HasAttribute("Ident")) Then Str2 = Str2 + "Id='" + I.GetAttribute("Ident") + "',"
                  Str = Str + Str2
                  If Str <> "" Then
                     Cmd.CommandText = "UPDATE Schools_Schools SET " + Str.TrimEnd(",".ToCharArray()) + " WHERE " + id
                     Cmd.ExecuteNonQuery()
                  End If
                  If Str2 <> "" Then
                     Cmd.CommandText = "UPDATE Schools_Ratings SET " + Str2.TrimEnd(",".ToCharArray()) + " WHERE " + id   'Updates changes in user/id in Ratings
                     Cmd.ExecuteNonQuery()
                  End If
               End If
            Next I
         End If
      End If
      Response.Write("<IO Result='0'/></Grid>")
   
      '------------------------------------------------------------------------------------------------------------------
      ' --- Reads data ---
   ElseIf Not Err Then

      Dim id, SQL, Str As String : Str = ""
      If User = "" Then
         Str = Str + "<Cfg Adding='0' Deleting='0' Editing='0'/><Toolbar Save='0'/>"
      Else
         Str = Str + "<Def><D Name='R' CUser='" + User.Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'/></Def>"
         Str = Str + "<Cols><C Name='CRating' Button='None'/></Cols>"
      End If
      If Not Admin Then Str = Str + "<RightCols><C Name='CUser' Visible='0' CanHide='0' CanPrint='0' CanExport='0'/></RightCols>"
   
      Str = Str + "<Body><B>"
      SQL = "SELECT * FROM Schools_Schools"
      If User <> "" And Not Admin Then SQL = SQL + " WHERE Owner='" + User.Replace("'", "''") + "'"
      Cmd.CommandText = SQL
      R = Cmd.ExecuteReader()
      Do While (R.Read())
         id = " Ident='" + R("ID").ToString() + "' CUser='" + R("Owner").ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'"
         Str = Str + "<I Def='Main' " + id
         Str = Str + " CName='" + R("Name").ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'"
         Str = Str + " CCountry='" + R("Country").ToString() + "'"
         Str = Str + " CState='" + R("State").ToString() + "'"
         Str = Str + " CCounty='" + R("County").ToString() + "'"
         Str = Str + " CTown='" + R("Town").ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'"
         Str = Str + " CLevel='" + R("SLevel").ToString() + "'"
         Str = Str + " CType='" + R("Type").ToString() + "'"
         Str = Str + " CGrade1='" + R("FromGrade").ToString() + "'"
         Str = Str + " CGrade2='" + R("ToGrade").ToString() + "'"
         Str = Str + " CEnrollment='" + R("Enrollment").ToString() + "'"
         Str = Str + " CStudents='" + R("Students").ToString() + "'"
         Str = Str + ">"
         Str = Str + "<I Def='Address' " + id + " CCountry='" + R("Address").ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'/>"
         Str = Str + "<I Def='Phone' " + id + " CCountry='" + R("Phone").ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'/>"
         Str = Str + "<I Def='Link' " + id + " CCountry='" + R("Link").ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'/>"
         Str = Str + "<I Def='Map' " + id + " CCountry='" + R("Map").ToString().Replace("&", "&amp;").Replace("'", "&apos;").Replace("<", "&lt;") + "'/>"
         Str = Str + "<I Def='Reviews' " + id + " Count='" + R("RatingCnt").ToString() + "'  CRatingsum='" + R("RatingSum").ToString() + "'>"
         Str = Str + "</I>"
         Str = Str + "</I>"
      Loop
      Str = Str + "</B></Body></Grid>"
      Response.Write(Str)
      R.Close()
   End If
   Conn.Close()
   ' --------------------------------------------------------------------------
%>