<%@ Page language="vb" Debug="true"%>
<%
' --------------------------------------------------------------------------
   
' --- Response initialization ---
dim Base As string: Base = System.IO.Path.GetDirectoryName(Context.Request.PhysicalPath)+"\TestFiles\"
Response.ContentType = "text/xml"
Response.Charset = "utf-8"
Response.AppendHeader("Cache-Control","max-age=1, must-revalidate")
System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US")

' --- Save data to disk ---
dim XML As string: XML = Request("Data")
if XML <> "" and XML <> nothing then
   try
      dim X As System.Xml.XmlDocument: X = new System.Xml.XmlDocument()
      X.LoadXml(HttpUtility.HtmlDecode(XML))
      dim Ch As System.Xml.XmlNodeList: Ch = X.GetElementsByTagName("Changes")
      if Ch.Count > 0 then
         dim N As System.Collections.Specialized.StringDictionary: N = new StringDictionary() ' Actual File paths according to their ids
         for each I As System.Xml.XmlElement in Ch(0)
            dim id As string: id = I.GetAttribute("id")
            dim ids As string()
            ids = id.Split("$")
            if N(id) <> nothing then ids = N(id).Split("$")
            dim Path As string: Path = ids(0).Replace("/", "\") + "\" + ids(2) + "." + ids(1)
            dim Clear As boolean: Clear = false
            if I.GetAttribute("Deleted") = "1" then
               System.IO.File.Delete(Base + Path)
               N(id) = Nothing
               Clear = true
            else
               if I.HasAttribute("P") then ids(0) = I.GetAttribute("P")
               if I.HasAttribute("E") then ids(1) = I.GetAttribute("E")
               if I.HasAttribute("N") then ids(2) = I.GetAttribute("N")
               dim NewId As string: NewId = ids(0).Replace("/", "\") + "\" + ids(2) + "." + ids(1)
               if NewId <> Path or I.GetAttribute("Added") = "1" then
                  N(id) = ids(0) + "$" + ids(1) + "$" + ids(2) ' Changes the id path for next use
                  dim dir As string: dir = Base + NewId.Substring(0, NewId.LastIndexOf("\"))
                  if System.IO.Directory.Exists(dir) = false then System.IO.Directory.CreateDirectory(dir) ' Creates directories if required
               end if
               dim Copy As string: Copy = I.GetAttribute("Copy")
               if Copy <> "" then
                  if N(Copy) <> Nothing then Copy = N(Copy)
                  dim cids As string(): cids = Copy.Split("$")
                  dim cpath As string: cpath = cids(0).Replace("/", "\") + "\" + cids(2) + "." + cids(1)
                  System.IO.File.Copy(Base + cpath, Base + NewId)
               elseif System.IO.File.Exists(Base + Path) = True then ' Move or rename
                  System.IO.File.Move(Base + Path, Base + NewId)
                  Clear = True   
               else                                                  ' New
                  System.IO.File.Create(Base + NewId).Close() 
               End If
            End If

            if Clear = True then ' Deletes empty directories
               dim idx As Integer: idx = Path.LastIndexOf("\")
               do while idx>=0 
                  Path = Path.Substring(0, idx)
                  if System.IO.Directory.GetFiles(Base + Path).Length>0 or System.IO.Directory.GetDirectories(Base + Path).Length>0 then Exit Do
                  System.IO.Directory.Delete(Base + Path)
                  idx = Path.LastIndexOf("\")
               loop
            end if
         Next I
      End If
      Response.Write("<Grid><IO Result='0'/></Grid>")
   catch Ex As Exception 
      Response.Write("<Grid><IO Result='-1' Message=""" + Ex.Message.Replace("""", "&quot;").Replace("<", "&lt;").Replace("&", "&amp;") + """/></Grid>")
   End Try
end if
' --------------------------------------------------------------------------
%>