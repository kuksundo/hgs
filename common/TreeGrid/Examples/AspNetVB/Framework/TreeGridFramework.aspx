<script language="vb" runat="server">
   ' -------------------------------------------------------------------------------------------------------------------------------
   ' File with shared functions for loading and uploading TreeGrid XML data to and from database
   ' -------------------------------------------------------------------------------------------------------------------------------


   ' +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ' Returns directory path to aspx file
   Function GetPath() As String
      GetPath = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath)
   End Function

   ' +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ' Main component to load and save TreeGrid XML data from and to database
   Class TreeGrid
      Private DBIdCol As String        'Column name in database table where are stored unique row ids
      Private IdPrefix As String       'Prefix added in front of id, used if ids are number type
      Private DBParentCol As String    'Column name in database table where are stored parent row ids, if is empty, the grid does not contain tree
      Private DBDefCol As String       'Column name in database table where are stored Def parameters (predefined values in Layout, used usually in tree
      Private D As System.Data.DataTable
      Private Sql As System.Data.Common.DbDataAdapter
      Private EngFormat As System.Globalization.CultureInfo
      Private SQLite As System.Reflection.Assembly  'Library for SQLite only
   
      ' -------------------------------------------------------------------------------------------------------------------------------
      ' Constructor, creates and initializes object according to input parameters
      Sub New(ByVal connectionString As String, ByVal selectString As String, ByVal pDBIdCol As String, ByVal pIdPrefix As String, ByVal pDBParentCol As String, ByVal pDBDefCol As String, ByVal SQLiteDLL As String)
         If pDBIdCol = Nothing Or pDBIdCol = "" Then DBIdCol = "id" Else DBIdCol = pDBIdCol
         'DBIdCol = dBIdCol==null || dBIdCol=="" ? "id" : dBIdCol;
         If pIdPrefix = Nothing Then IdPrefix = "" Else IdPrefix = pIdPrefix
         'IdPrefix = idPrefix==null ? "" : idPrefix;
         If pDBParentCol = Nothing Then DBParentCol = "" Else DBParentCol = pDBParentCol
         'DBParentCol = dBParentCol == null ? "" : dBParentCol;
         If pDBDefCol = Nothing Then DBDefCol = "" Else DBDefCol = pDBDefCol
         'DBDefCol = dBDefCol==null || dBDefCol=="" ? "Def" : "";
         EngFormat = System.Globalization.CultureInfo.CreateSpecificCulture("en-US") ' English culture is used by TreeGrid input
         
         Dim Conn As System.Data.IDbConnection
         If connectionString.IndexOf("Microsoft.Jet") >= 0 Or SQLiteDLL = Nothing Then ' For MS Acess database
            SQLite = Nothing
            Conn = New System.Data.OleDb.OleDbConnection(connectionString)
            Sql = New System.Data.OleDb.OleDbDataAdapter(selectString, CType(Conn, System.Data.OleDb.OleDbConnection))
         Else ' For SQLite database
            Dim bits As String = "32" : If IntPtr.Size <> 4 Then bits = "64"
            SQLite = System.Reflection.Assembly.LoadFrom(SQLiteDLL)
            Conn = Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteConnection"), connectionString)
            Sql = Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteDataAdapter"), selectString, Conn)
         End If
         
         D = New System.Data.DataTable()
         Sql.Fill(D)
      End Sub
   
      ' -------------------------------------------------------------------------------------------------------------------------------
      ' Helper function for LoadXMLFromDB to read data from database table and convert them to TreeGrid XML
      ' Adds to E as children all rows with Parent==Sec
      ' If Sec is null adds all rows (for non tree tables)
      Sub GetChildrenXML(ByVal E As System.Xml.XmlElement, ByVal Sec As String)
         Dim Rows As System.Data.DataRow()
         If DBParentCol = "" Then Rows = D.Select("") Else Rows = D.Select("[" + DBParentCol + "]='" + Sec + "'")
         For Each R As System.Data.DataRow In Rows
            Dim I As System.Xml.XmlElement = E.OwnerDocument.CreateElement("I")
            E.AppendChild(I)
            For Each C As System.Data.DataColumn In D.Columns
               If C.ColumnName = "Parent" Then GoTo cont
               Dim S As String : Dim O As Object = R(C) : Dim T As Type = O.GetType()
               If T Is Type.GetType("System.String") Then
                  S = O.ToString()
               ElseIf T Is Type.GetType("System.DateTime") Then
                  S = CType(O, DateTime).ToString("M/d/yyyy HH:mm:ss", EngFormat)
               ElseIf T Is Type.GetType("System.Double") Then
                  S = CType(O, Double).ToString(EngFormat)
               ElseIf T Is Type.GetType("System.Single") Then
                  S = CType(O, Single).ToString(EngFormat)
               ElseIf T Is Type.GetType("System.DBNull") Or O Is Nothing Then
                  GoTo cont
               Else
                  S = O.ToString()
               End If
               If C.ColumnName = DBIdCol Then
                  I.SetAttribute("id", IdPrefix + S)
               Else
                  I.SetAttribute(C.ColumnName, S)
               End If
cont:          'Continue raised BC30451 error in Visual Basic for me, why ?
            Next C
            If DBParentCol <> "" Then GetChildrenXML(I, R(DBIdCol).ToString())
         Next R
      End Sub
   
      ' -------------------------------------------------------------------------------------------------------------------------------
      ' Loads data from database table and returns them as XML string
      Public Function LoadXMLFromDB() As String
         Dim X As System.Xml.XmlDocument = New System.Xml.XmlDocument()
         Dim G, S, B As System.Xml.XmlElement
         G = X.CreateElement("Grid") : X.AppendChild(G)
         If DBParentCol <> "" Then
            S = X.CreateElement("Head") : G.AppendChild(S) : GetChildrenXML(S, "#Head")
            S = X.CreateElement("Foot") : G.AppendChild(S) : GetChildrenXML(S, "#Foot")
            S = X.CreateElement("Body") : G.AppendChild(S) : B = X.CreateElement("B") : S.AppendChild(B) : GetChildrenXML(B, "#Body")
         Else
            S = X.CreateElement("Body") : G.AppendChild(S) : B = X.CreateElement("B") : S.AppendChild(B) : GetChildrenXML(B, "")
         End If
         LoadXMLFromDB = X.InnerXml
      End Function
      
      ' -------------------------------------------------------------------------------------------------------------------------------
      ' Saves to database changes in TreeGrid XML format
      Sub SaveXMLToDB(ByVal XML As String)
         Dim X As System.Xml.XmlDocument = New System.Xml.XmlDocument()
         X.LoadXml(HttpUtility.HtmlDecode(XML))
         Dim A As System.Xml.XmlNodeList = X.GetElementsByTagName("Changes")
         If A.Count > 0 Then
            For Each E As System.Xml.XmlElement In A(0)
               Try
                  Dim id As String : id = E.GetAttribute("id")
                  If IdPrefix <> "" Then id = id.Substring(IdPrefix.Length)
                  Dim R As System.Data.DataRow
                  If E.GetAttribute("Added") = "1" Then
                     R = D.NewRow()
                     R(DBIdCol) = id
                     D.Rows.Add(R)
                  Else
                     R = D.Select("[" + DBIdCol + "]=" + "'" + id + "'")(0)
                  End If
                  If E.GetAttribute("Deleted") = "1" Then
                     R.Delete() : GoTo cont1
                  End If
                  If E.GetAttribute("Added") = "1" Or E.GetAttribute("Moved") = "2" Then
                     Dim Parent As String = E.GetAttribute("Parent")
                     If DBParentCol <> "" Then
                        If Parent = "" Then Parent = "#Body"
                        R("Parent") = Parent
                     End If
                     E.RemoveAttribute("Parent")
                     E.RemoveAttribute("Next")   ' Next is ignored, because row position is variable by sorting
                     E.RemoveAttribute("Prev")
                  End If
                  If E.GetAttribute("Added") = "1" Or E.GetAttribute("Changed") = "1" Then
                     E.RemoveAttribute("Added")
                     E.RemoveAttribute("Changed")
                     E.RemoveAttribute("id")
                     For Each Att As System.Xml.XmlAttribute In E.Attributes
                        If D.Columns(Att.Name) Is Nothing Then GoTo cont2
                        Dim O As Object
                        Dim Str As String = Att.Value
                        Dim T As Type = D.Columns(Att.Name).DataType
                        If T Is Type.GetType("System.String") Then
                           O = Str
                        ElseIf T Is Type.GetType("System.DateTime") Then
                           O = DateTime.Parse(Str, EngFormat)
                        ElseIf T Is Type.GetType("System.Double") Then
                           O = Double.Parse(Str, EngFormat)
                        ElseIf T Is Type.GetType("System.Single") Then
                           O = Single.Parse(Str, EngFormat)
                        Else
                           O = Int32.Parse(Str, EngFormat)
                        End If
                        R(Att.Name) = O
cont2:
                     Next Att
                  End If
cont1:
               Catch
               End Try
            Next E
         End If
         ''Dim bld As System.Data.OleDb.OleDbCommandBuilder : bld = New System.Data.OleDb.OleDbCommandBuilder(Sql)
         If SQLite Is Nothing Then
            Dim Bld As System.Data.OleDb.OleDbCommandBuilder = New System.Data.OleDb.OleDbCommandBuilder(Sql)  ' For MS Acess database
         Else
            Activator.CreateInstance(SQLite.GetType("System.Data.SQLite.SQLiteCommandBuilder"), Sql) ' For SQLite database
         End If
         Sql.Update(D)      ' Updates changed to database
         D.AcceptChanges()
      End Sub
   End Class
   ' +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
</script>