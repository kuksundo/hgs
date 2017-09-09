<%
'! Support file only, run Schools.html instead !
' This file is used as Data_Url and Upload_Url
' Main application for Schools, generates data, saves changes, adds or modifies users and so on
' Single file, without using TreeGridFramework.asp


' --- Response initialization ---
Session.Codepage=65001
Response.Charset= "utf-8"
Response.ContentType = "text/xml"
Response.AddHeader "Cache-Control","max-age=1, must-revalidate"
SetLocale "en-us"

' --- Databaze initialization ---
Dim Path
Path = Request.ServerVariables("PATH_TRANSLATED")
Path = Left(Path,InStrRev(Path,"\"))
Dim DB
Set DB = Server.CreateObject("ADODB.Connection")
DB.Open "DRIVER={Microsoft Access Driver (*.mdb)};DBQ="&Path&"Database.mdb"    'Database file has relative path to this page
Dim RS
Set RS = Server.CreateObject("ADODB.Recordset")

' --- Input parameters initalization ---
User = Request.Form("User") : if IsNull(User) then User=""
Pass = Request.Form("Pass") : if IsNull(Pass) then Pass=""
NewUser = true: if IsNull(Request.Form("New")) or CInt(Request.Form("New"))=0 then NewUser=false
User = LCase(User)

Response.Write "<Grid>"
Err = false

' --- Helper function for converting string to XML ---
Function ToXml(byval Str)
if IsNull(Str) then 
   ToXml = ""
else 
   ToXml = Replace(Replace(Replace(CStr(Str),"&","&amp;"),"'","&apos;"),"<","&lt;")
end if
End Function

' --- Adding new user ---
if NewUser then
   RS.Open "SELECT Pass FROM Schools_Users WHERE Name='" & Replace(User,"'","''") & "'", DB, 1, 3, 1
   if RS.EOF then 'Ok, possible
      RS.Close
      DB.Execute "INSERT INTO Schools_Users(Name,Pass) VALUES ('" & Replace(User,"'","''") & "','" & Replace(Pass,"'","''") & "')", rec
      Response.Write "<IO Message='User " & ToXml(User) & " has been added successfuly'/>"
   else
      RS.Close
      Response.Write "<IO Result='-1' Message='User name already exists !'/><Lang><Text StartErr='User name already exists !'/></Lang></Grid>"
      Err = true
   end if  
end if

' --- Password verification ---
if not Err And User<>"" then
   RS.Open "SELECT Pass FROM Schools_Users WHERE Name='" & Replace(User,"'","''") & "'", DB, 1, 3, 1
   if not RS.EOF then xpass = RS.Fields(0).Value
   if RS.EOF or xpass<>Pass then
      Response.Write "<IO Result='-1' Message='Wrong user name or password !'/><Lang><Text StartErr='Wrong user name or password !'/></Lang></Grid>"
      Err = true
   end if
   RS.Close
end if
Admin = false
if User="admin" then Admin = true ' @@@ Or change this code to another admin

'------------------------------------------------------------------------------------------------------------------
Dim XML
XML = Request.Form("TGData")

' --- Saves data ---
if not Err And XML <> "" then 
   if User="" then 'Attack or bug
      Response.Write "<IO Result='-1' Message='The user have not permission to save data !'/></Grid>"
   else
      XML = Replace(Replace(Replace(XML,"&lt;","<"),"&gt;",">"),"&amp;","&")
      dim X,Ch,I,id,SQL,idx,rec
      set X = Server.CreateObject("Microsoft.XMLDOM")
      X.LoadXml XML 
      set Ch = X.getElementsByTagName("Changes")
      if Ch.length>0 then
         set I = Ch(0).firstChild
         do while not (I is nothing)
         
            ' --- id parsing ---
            id = CStr(I.GetAttribute("id"))
            pos = InStr(1,id,"$")
            Owner = Mid(id,1,pos-1)
            pos2 = InStr(pos+1,id,"$")
            Def = Mid(id,pos+1,pos2-pos-1)
            Ident = Mid(id,pos2+1,Len(id)-pos2)
            id = " Owner='" & Replace(Owner,"'","''") & "' AND Id=" & Ident
            ' ---

            if Def<>"Main" then  'Child row (Address, Phone, Link, Map)
               if (not IsNull(I.GetAttribute("Added")) Or not IsNull(I.GetAttribute("Changed"))) And not IsNull(I.GetAttribute("CCountry")) then
                  DB.Execute "UPDATE Schools_Schools SET " & Def & " = '" & Replace(I.GetAttribute("CCountry"),"'","''") & "' WHERE" & id, rec
               end if
               
            elseif not IsNull(I.GetAttribute("Deleted")) then
                DB.Execute "DELETE FROM Schools_Schools WHERE" & id, rec
                DB.Execute "DELETE FROM Schools_Ratings WHERE" & id, rec
               
            elseif not IsNull(I.GetAttribute("Added")) then
               Str = "'" & Replace(I.GetAttribute("CUser"),"'","''") & "','" & Ident & "','" & Replace(I.GetAttribute("CName"),"'","''") & "'," _
                  & I.GetAttribute("CCountry") & "," & I.GetAttribute("CState") & "," & I.GetAttribute("CCounty") & "," _
                  & "'" & Replace(I.GetAttribute("CTown"),"'","''") & "'," _
                  & I.GetAttribute("CLevel") & "," & I.GetAttribute("CType") & "," _
                  & I.GetAttribute("CGrade1") & "," & I.GetAttribute("CGrade2") & "," & I.GetAttribute("CEnrollment") & "," & I.GetAttribute("CStudents")
               DB.Execute "INSERT INTO Schools_Schools(Owner,Id,Name,Country,State,County,Town,SLevel,Type,FromGrade,ToGrade,Enrollment,Students) VALUES (" & Str & ")", rec
               
            elseif not IsNull(I.GetAttribute("Changed")) then
               Str = ""
               if not IsNull(I.GetAttribute("CName")) then Str = Str & "Name='" & Replace(I.GetAttribute("CName"),"'","''") & "',"
               if not IsNull(I.GetAttribute("CCountry")) then Str = Str & "Country=" & I.GetAttribute("CCountry") & ","
               if not IsNull(I.GetAttribute("CState")) then Str = Str & "State=" & I.GetAttribute("CState") & ","
               if not IsNull(I.GetAttribute("CCounty")) then Str = Str & "County=" & I.GetAttribute("CCounty") & ","
               if not IsNull(I.GetAttribute("CTown")) then Str = Str & "Town='" & Replace(I.GetAttribute("CTown"),"'","''") & "',"
               if not IsNull(I.GetAttribute("CLevel")) then Str = Str & "SLevel=" & I.GetAttribute("CLevel") & ","
               if not IsNull(I.GetAttribute("CType")) then Str = Str & "Type=" & I.GetAttribute("CType") & ","
               if not IsNull(I.GetAttribute("CGrade1")) then Str = Str & "FromGrade=" & I.GetAttribute("CGrade1") & ","
               if not IsNull(I.GetAttribute("CGrade2")) then Str = Str & "ToGrade=" & I.GetAttribute("CGrade2") & ","
               if not IsNull(I.GetAttribute("CEnrollment")) then Str = Str & "Enrollment=" & I.GetAttribute("CEnrollment") & ","
               if not IsNull(I.GetAttribute("CStudents")) then Str = Str & "Students=" & I.GetAttribute("CStudents") & ","
               Str2 = ""
               if Admin and  not IsNull(I.GetAttribute("CUser")) then Str2 = Str2 & "Owner='" & Replace(I.GetAttribute("CUser"),"'","''") & "',"
               if Admin and  not IsNull(I.GetAttribute("Ident")) then Str2 = Str2 & "Id='" & I.GetAttribute("Ident") & "',"
               Str = Str & Str2
               if Str <> "" then  DB.Execute "UPDATE Schools_Schools SET " & Left(Str,Len(Str)-1) & " WHERE " & id, rec
               if Str2 <> "" then DB.Execute "UPDATE Schools_Ratings SET " & Left(Str2,Len(Str2)-1) & " WHERE " & id, rec   'Updates changes in user/id in Ratings
            end if
         set I = I.nextSibling
         loop
      end if
      Response.Write "<IO Result='0'/></Grid>"  
   end if
'------------------------------------------------------------------------------------------------------------------
' --- Reads data ---
elseif not Err then
   Str = ""
   if User = "" then
      Str = Str & "<Cfg Adding='0' Deleting='0' Editing='0'/><Toolbar Save='0'/>"
   else 
      Str = Str & "<Def><D Name='R' CUser='" & ToXml(User) & "'/></Def>"
      Str = Str & "<Cols><C Name='CRating' Button='None'/></Cols>"
   end if
   if(not Admin) then Str = Str & "<RightCols><C Name='CUser' Visible='0' CanHide='0'/></RightCols>"
   
   Str = Str & "<Body><B>"
   SQL = "SELECT * FROM Schools_Schools"
   if User<>"" and not Admin then SQL = SQL & " WHERE Owner='" & Replace(User,"'","''") & "'"
   RS.Open SQL, DB, 1, 3, 1
   Do While RS.EOF <> True
      id = " Ident='" & CStr(RS.Fields("ID").Value) & "' CUser='" & ToXml(RS.Fields("Owner")) & "'"
      Str = Str & "<I Def='Main' " & id
      Str = Str & " CName='" & ToXml(RS.Fields("Name").Value) & "'"
      Str = Str & " CCountry='" & CStr(RS.Fields("Country").Value) & "'"
      Str = Str & " CState='" & CStr(RS.Fields("State").Value) & "'"
      Str = Str & " CCounty='" & CStr(RS.Fields("County").Value) & "'"
      Str = Str & " CTown='" & ToXml(RS.Fields("Town").Value) & "'"
      Str = Str & " CLevel='" & CStr(RS.Fields("SLevel").Value) & "'"
      Str = Str & " CType='" & CStr(RS.Fields("Type").Value) & "'"
      Str = Str & " CGrade1='" & CStr(RS.Fields("FromGrade").Value) & "'"
      Str = Str & " CGrade2='" & CStr(RS.Fields("ToGrade").Value) & "'"
      Str = Str & " CEnrollment='" & CStr(RS.Fields("Enrollment").Value) & "'"
      Str = Str & " CStudents='" & CStr(RS.Fields("Students").Value) & "'"
      Str = Str & ">"
      Str = Str & "<I Def='Address' " & id & " CCountry='" & ToXml(RS.Fields("Address").Value) & "'/>"
      Str = Str & "<I Def='Phone' " & id & " CCountry='" & ToXml(RS.Fields("Phone").Value) & "'/>"
      Str = Str & "<I Def='Link' " & id & " CCountry='" & ToXml(RS.Fields("Link").Value) & "'/>"
      Str = Str & "<I Def='Map' " & id & " CCountry='" & ToXml(RS.Fields("Map").Value) & "'/>"
      Str = Str & "<I Def='Reviews' " & id & " Count='" & CStr(RS.Fields("RatingCnt").Value) & "'  CRatingsum='" & CStr(RS.Fields("RatingSum").Value) & "'>"
      Str = Str & "</I>"
      Str = Str & "</I>"
   RS.MoveNext
   Loop
   Str = Str & "</B></Body></Grid>"
   Response.Write Str
end if

' --------------------------------------------------------------------------
%>