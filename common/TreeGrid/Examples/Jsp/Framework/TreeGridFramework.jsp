<%!
//------------------------------------------------------------------------------------------------------------------
// TreeGrid JSP framework
// Support functions for using TreeGrid in JAVA
//------------------------------------------------------------------------------------------------------------------





// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Functions for parsing uploaded XML
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//------------------------------------------------------------------------------------------------------------------
// Returns XML Document from String
// Returns null when XML is empty or not valid
private org.w3c.dom.Document parseXML(String XML){
if(XML==null) XML="";
if(XML.equals("")) return null;
if(XML.charAt(0)=='&') XML = XML.replaceAll("&lt;","<").replaceAll("&gt;",">").replaceAll("&amp;","&").replaceAll("&quot;","\"").replaceAll("&apos;","'");
try { return javax.xml.parsers.DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(new org.xml.sax.InputSource(new java.io.StringReader(XML)));  }
catch(Exception E){ return null; }
}
//------------------------------------------------------------------------------------------------------------------
// Returns array of XML <I> elements in <Changes> tag
org.w3c.dom.Element[] getChanges(String XML){ return getChanges(parseXML(XML)); }
org.w3c.dom.Element[] getChanges(org.w3c.dom.Document XML){
if(XML==null) return null;
org.w3c.dom.NodeList Ch = XML.getElementsByTagName("Changes");
if(Ch.getLength()==0) return null;
Ch = Ch.item(0).getChildNodes();
int len = Ch.getLength();
org.w3c.dom.Element[] E = new org.w3c.dom.Element[len];
for(int i=0;i<len;i++) E[i] = (org.w3c.dom.Element) Ch.item(i);
return E;
}
//------------------------------------------------------------------------------------------------------------------
// Returns page number from input XML
int getPagePos(String XML){ return getPagePos(parseXML(XML)); }
int getPagePos(org.w3c.dom.Document XML){
if(XML==null) return -1;
return Integer.valueOf(((org.w3c.dom.Element)(XML.getElementsByTagName("B").item(0))).getAttribute("Pos")).intValue();
}
//------------------------------------------------------------------------------------------------------------------
// Returns page id from input XML
String getPageId(String XML){ return getPageId(parseXML(XML)); }
String getPageId(org.w3c.dom.Document XML){
if(XML==null) return null;
return ((org.w3c.dom.Element)(XML.getElementsByTagName("B").item(0))).getAttribute("id");
}
//------------------------------------------------------------------------------------------------------------------
// Returns array of columns according to is grid sorted
// Returns null if there are no columns
String[] getSortCols(String XML){ return getSortCols(parseXML(XML)); }
String[] getSortCols(org.w3c.dom.Document XML){
if(XML==null) return null;
org.w3c.dom.Element Cfg = (org.w3c.dom.Element) XML.getElementsByTagName("Cfg").item(0);
String[] s = Cfg.getAttribute("SortCols").split("\\,");
return s.length==0 || s[0].length()==0 ? null : s;
}
//------------------------------------------------------------------------------------------------------------------
// Returns array of columns according to is grid sorted
// Returns null if there are no columns
String[] getGroupCols(String XML){ return getGroupCols(parseXML(XML)); }
String[] getGroupCols(org.w3c.dom.Document XML){
if(XML==null) return null;
org.w3c.dom.Element Cfg = (org.w3c.dom.Element) XML.getElementsByTagName("Cfg").item(0);
String[] s = Cfg.getAttribute("GroupCols").split("\\,");
return s.length==0 || s[0].length()==0 ? null : s;
}
//------------------------------------------------------------------------------------------------------------------
// Returns array of sorting types for columns according to is grid sorted
// Returns null if there are no columns
int[] getSortTypes(String XML){ return getSortTypes(parseXML(XML)); }
int[] getSortTypes(org.w3c.dom.Document XML){
if(XML==null) return null;
org.w3c.dom.Element Cfg = (org.w3c.dom.Element) XML.getElementsByTagName("Cfg").item(0);
String[] tt = Cfg.getAttribute("SortTypes").split("\\,");
if(tt.length==0 || tt[0].length()==0) return null;
int[] t = new int[tt.length];
for (int i = 0; i < t.length; i++) t[i] = Integer.valueOf(tt[i]).intValue();
return t;
}
//------------------------------------------------------------------------------------------------------------------
// Returns array of sorting types for columns according to is grid sorted
// Returns null if there are no columns
int[] getGroupTypes(String XML){ return getGroupTypes(parseXML(XML)); }
int[] getGroupTypes(org.w3c.dom.Document XML){
if(XML==null) return null;
org.w3c.dom.Element Cfg = (org.w3c.dom.Element) XML.getElementsByTagName("Cfg").item(0);
String[] tt = Cfg.getAttribute("GroupTypes").split("\\,");
if(tt.length==0 || tt[0].length()==0) return null;
int[] t = new int[tt.length];
for (int i = 0; i < t.length; i++) t[i] = Integer.valueOf(tt[i]).intValue();
return t;
}
//------------------------------------------------------------------------------------------------------------------
// Compares attribute value with value
boolean isAttribute(org.w3c.dom.Element I, String name,String value){ return I.getAttribute(name).equals(value); }
//------------------------------------------------------------------------------------------------------------------
// Tests if given row has set the flag
boolean isDeleted(org.w3c.dom.Element I){ return I.getAttribute("Deleted").equals("1"); }
boolean isAdded(org.w3c.dom.Element I){ return I.getAttribute("Added").equals("1"); }
boolean isChanged(org.w3c.dom.Element I){ return I.getAttribute("Changed").equals("1"); }
boolean isMoved(org.w3c.dom.Element I){ return I.getAttribute("Moved").equals("2"); } // Moved only to another parent !
//------------------------------------------------------------------------------------------------------------------
// Returns row's id attribute
String getId(org.w3c.dom.Element I){ return I.getAttribute("id"); }
String[] getIds(org.w3c.dom.Element I){ return I.getAttribute("id").split("\\$"); }
//------------------------------------------------------------------------------------------------------------------
// Returns request parameter value, for null returns ""
String getParameter(HttpServletRequest request, String name) {
String P = request.getParameter(name);
return P==null ? "" : P;
}
//------------------------------------------------------------------------------------------------------------------



// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Functions for generating SQL commands, from strings and XML nodes
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//------------------------------------------------------------------------------------------------------------------
// Returns string in ' ' with doubled all '
String toSQL(String value){ return "'" + (value==null ? "" : value.replaceAll("'","''")) + "'"; }
String toSQL(org.w3c.dom.Element I, String name){ return "'" + I.getAttribute(name).replaceAll("'","''") + "'"; }

// Returns one string for UPDATE command, for string types
// Returns "name='value',"
String toSQLUpdateString(String name, String value){ return value==null ? "" : name+"='" + value.replaceAll("'","''") + "',"; }
String toSQLUpdateString(String name, org.w3c.dom.Element I, String attname){ return I.hasAttribute(attname) ? name+"='" + I.getAttribute(attname).replaceAll("'","''") + "'," : ""; }

// Returns one string for UPDATE command, for number types
// Returns "name=value,"
String toSQLUpdateNumber(String name, String value){ return value==null || value.length()==0 ? "" : name+"=" + value + ","; }
String toSQLUpdateNumber(String name, org.w3c.dom.Element I, String attname){ return I.hasAttribute(attname) ? name+"=" + I.getAttribute(attname) + "," : ""; }

// Deletes all commas on the end of string
// Useful when building comma separated list in loop, call it after list is built to strip ending comma(s)
String trimSQL(String value){ return value==null ? "" : value.replaceAll("[\\,\\s]*$",""); }

//------------------------------------------------------------------------------------------------------------------
// Returns attribute values in format "outName[0]=value_of_attrNames[0],outName[1]=value_of_attrNames[1], ..."
// The string never ends by comma
// If the attribute does not exists, is not included
// If attrIsString[x] is true, it encloses attribute value by ' '
String toSQLUpdate(org.w3c.dom.Element I, String[] attrNames, String[] outNames, boolean attrIsString[]){
StringBuffer S = new StringBuffer();
for(int i=0;i<attrNames.length;i++){
   org.w3c.dom.Node N = I.getAttributeNode(attrNames[i]);
   if(N!=null){ 
      if(attrIsString[i]) S.append(outNames[i]+"='"+N.getNodeValue().replaceAll("'","''")+"',");
      else S.append(outNames[i]+"="+N.getNodeValue()+",");
      }
   }
if(S.length()>0) S.setLength(S.length()-1);  // Last comma away
return S.toString();
}
//------------------------------------------------------------------------------------------------------------------
// Returns attribute values separated by comma
// The string never ends by comma
// If the attribute does not exists, is not included
// If attrIsString[x] is true, it encloses attribute value by ' '
String toSQLInsert(org.w3c.dom.Element I, String[] attrNames, boolean attrIsString[]){
StringBuffer S = new StringBuffer();
for(int i=0;i<attrNames.length;i++){
   org.w3c.dom.Node N = I.getAttributeNode(attrNames[i]);
   if(N!=null){ 
      if(attrIsString[i]) S.append("'"+N.getNodeValue().replaceAll("'","''")+"',");
      else S.append(N.getNodeValue()+",");
      }
   }
if(S.length()>0) S.setLength(S.length()-1);  // Last comma away
return S.toString();
}
//------------------------------------------------------------------------------------------------------------------



// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Advanced functions for updating changes in XML to database
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


//------------------------------------------------------------------------------------------------------------------
// Helper function for saveTree
// Returns value in or without ' '
// If name is found in names array, it checks types for string type and if found returns in ' '
String getValue(String[] names, int[] types, String name, String value){
for(int i=0;i<names.length;i++){ 
   if(names[i].equalsIgnoreCase(name)){
      int t = types[i];
      if(value.equals("") && (t==java.sql.Types.DATE || t==java.sql.Types.TIME)) return "NULL";
      if(t==java.sql.Types.VARCHAR || t==java.sql.Types.CHAR || t==java.sql.Types.LONGVARCHAR || t==java.sql.Types.DATE || t==java.sql.Types.TIME) return "'"+value.replaceAll("'","''") + "'";
      return value.equals("") ? "NULL" : value;
      }
   }
return "";
}
//------------------------------------------------------------------------------------------------------------------
// Saves changes in XML to database table
// idCol is database table column name where is stored id attribute
// parentCol is database table column name where is stored Parent attribute, for Parent<-Child relation. 
//    In Parent column the row has value of id column of parent row => All parent's children have its id in their Parent column
// bodyParent is value of Parent for new added root rows
boolean saveTree(String XML, java.sql.Statement Cmd, String table, String idCol, String parentCol, String bodyParent) throws java.sql.SQLException, java.io.IOException{

// --- Gets column names and types ---
java.sql.ResultSet R = Cmd.executeQuery("SELECT TOP 1 * FROM "+table);
java.sql.ResultSetMetaData M = R.getMetaData();
int cnt = M.getColumnCount();
String[] colNames = new String[cnt];
int[] types = new int[cnt];
for(int i=1;i<=cnt;i++){ 
   colNames[i-1] = M.getColumnName(i);
   types[i-1] = M.getColumnType(i);
   }
String[] names = colNames;

// --- saves data to database ---
org.w3c.dom.Element[] Ch = getChanges(XML);
if(Ch==null) return false;
for(int i=0;i<Ch.length;i++){
   org.w3c.dom.Element I = Ch[i];
   org.w3c.dom.NamedNodeMap A = I.getAttributes();
   String id = getId(I); if(id.equals("")) continue; // Error
   if(isDeleted(I)){ // Deleting
      Cmd.executeUpdate("DELETE FROM "+table+" WHERE "+idCol+"="+getValue(names,types,idCol,id));
      }
   else if(isAdded(I)){ // Adding
      StringBuffer Cols = new StringBuffer();
      StringBuffer Vals = new StringBuffer();
      Cols.append("INSERT INTO "+table+"(");
      Vals.append(") VALUES (");
      for(int a=0;a<A.getLength();a++){
         org.w3c.dom.Node N = A.item(a);
         String name = N.getNodeName();
         if(!name.equals("Added") && !name.equals("Changed") && !name.equals("Moved") && !name.equals("Next") && !name.equals("Prev") && !name.equals("Parent")){
            Cols.append(""+name+",");
            Vals.append(getValue(names,types,name,N.getNodeValue())+",");
            }
         }
      Cols.append(parentCol);
      Vals.append("'" + (!I.getAttribute("Parent").equals("") ? I.getAttribute("Parent") : bodyParent) + "'");
      Cmd.executeUpdate(Cols.toString() + Vals.toString() + ")");
      }
   else if(isChanged(I) || isMoved(I)){ // Updating
      StringBuffer S = new StringBuffer();
      S.append("UPDATE "+table+" SET ");
      for(int a=0;a<A.getLength();a++){
         org.w3c.dom.Node N = A.item(a);
         String name = N.getNodeName();
         if(name=="Parent") name=parentCol;
         if(!name.equals("Added") && !name.equals("Changed") && !name.equals("Moved") && !name.equals("Next") && !name.equals("Prev") && !name.equals("id")){
            S.append(name+"="+getValue(names,types,name,N.getNodeValue())+",");
            }
         }
      S.setLength(S.length()-1);
      S.append(" WHERE "+idCol+"="+getValue(names,types,idCol,id));
      Cmd.executeUpdate(S.toString());
      }    
   }
return true;
}
//------------------------------------------------------------------------------------------------------------------





// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Functions for creating XML from strings and Recordset
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// Returns string with replaced &,',< by XML entities
String toXMLString(String value){
if(value==null) return "";
return value.replaceAll("&", "&amp;").replaceAll("'", "&apos;").replaceAll("<", "&lt;").replaceAll("\n","&#x0a;").replaceAll("\r","&#x0d;");
}

// Returns string with replaced XML entities by &,',<,",> by characters
String fromXMLString(String value){
if(value==null) return ""; 
return value.replaceAll("&lt;","<").replaceAll("&gt;",">").replaceAll("&quot;","\"").replaceAll("&apos;","'").replaceAll("&#x0a;","\n").replaceAll("&#x0d;","\r").replaceAll("&amp;","&");
}

// Returns string with replaced &," by XML entities
String toHTMLString(String value){
if(value==null) return "";
return value.replaceAll("&", "&amp;").replaceAll("\\\"", "&quot;");
}


// Returns value as XML string quoted by single quote and replaced <,&,' by XML entities
String toXML(short value){ return "'"+String.valueOf(value)+"'"; }
String toXML(int value){ return "'"+String.valueOf(value)+"'"; }
String toXML(long value){ return "'"+String.valueOf(value)+"'"; }
String toXML(float value){ return "'"+String.valueOf(value)+"'"; }
String toXML(double value){ return "'"+String.valueOf(value)+"'"; }
String toXML(boolean value){ return "'"+(value?"1":"0")+"'"; }

void toXML(StringBuffer S, String value) { S.append(toXML(value)); }
String toXML(String value){
if(value==null) return "''";
return "'" + value.replaceAll("&", "&amp;").replaceAll("'", "&apos;").replaceAll("<", "&lt;").replaceAll("\n","&#x0a;").replaceAll("\r","&#x0d;") + "'";
}

void toXML(StringBuffer S, String name, String value){ S.append(toXML(name,value)); }
String toXML(String name, String value){
if(value==null) return "";
return " "+name+"='" + value.replaceAll("&", "&amp;").replaceAll("'", "&apos;").replaceAll("<", "&lt;").replaceAll("\n","&#x0a;").replaceAll("\r","&#x0d;") + "'";
}

String toXML(String name, java.sql.ResultSet R, String colName) throws java.sql.SQLException { return toXML(name,R.getString(colName)); }
void toXML(StringBuffer S, String name, java.sql.ResultSet R, String colName) throws java.sql.SQLException { S.append(toXML(name,R.getString(colName))); }
//------------------------------------------------------------------------------------------------------------------



// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Advanced functions for creating XML
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


//------------------------------------------------------------------------------------------------------------------
// XML representation of one row with given attribute names and their values
// end is the string appended after row, for rows with children use ">", without children "/>", or you can set own attributes
String getRowXML(String[] names, String[] values){ return getRowXML(names,values,"/>"); }
String getRowXML(String[] names, String[] values, String end){
StringBuffer S = new StringBuffer();
S.append("<I");
for(int i=0;i<names.length;i++) toXML(S,names[i],values[i]);
S.append(end);
return S.toString();
}

//------------------------------------------------------------------------------------------------------------------
// XML representation of one row with given attribute names and their values from ResultSet in columns colNames
// end is the string appended after row, for rows with children use ">", without children "/>", or you can set own attributes
// Does not move cursor in ResultSet
String getRowXML(java.sql.ResultSet R, String[] names, String[] colNames) throws java.sql.SQLException { return getRowXML(R,names,colNames,"/>"); }
String getRowXML(java.sql.ResultSet R, String[] names, String[] colNames, String end) throws java.sql.SQLException {
StringBuffer S = new StringBuffer();
S.append("<I");
for(int i=0;i<names.length;i++) toXML(S,names[i],R.getString(colNames[i]));
S.append(end);
return S.toString();
}

//------------------------------------------------------------------------------------------------------------------
// XML representation of one row with given attribute names and their values from ResultSet in columns colNames
// end is the string appended after row, for rows with children use ">", without children "/>", or you can set own attributes
// Does not move cursor in ResultSet
String getRowXML(java.sql.ResultSet R, String[] names, int[] colIndexes) throws java.sql.SQLException { return getRowXML(R,names,colIndexes,"/>"); }
String getRowXML(java.sql.ResultSet R, String[] names, int[] colIndexes, String end) throws java.sql.SQLException {
StringBuffer S = new StringBuffer();
S.append("<I");
for(int i=0;i<names.length;i++) toXML(S,names[i],R.getString(colIndexes[i]));
S.append(end);
return S.toString();
}

//------------------------------------------------------------------------------------------------------------------
// XML representation of one row with given attribute names and their values from ResultSet in columns indexed as attribute names
// end is the string appended after row, for rows with children use ">", without children "/>", or you can set own attributes
// Does not move cursor in ResultSet
String getRowXML(java.sql.ResultSet R, String[] names) throws java.sql.SQLException { return getRowXML(R,names,"/>"); }
String getRowXML(java.sql.ResultSet R, String[] names, String end) throws java.sql.SQLException {
StringBuffer S = new StringBuffer();
S.append("<I");
for(int i=0;i<names.length;i++) toXML(S,names[i],R.getString(i+1));
S.append(end);
return S.toString();
}
//------------------------------------------------------------------------------------------------------------------
// Returns complete XML representation of all rows with given attribute names and their values from ResultSet in columns indexed as attribute names
String getTableXML(java.sql.ResultSet R, String[] names, String[] colNames) throws java.sql.SQLException {
StringBuffer S = new StringBuffer();
S.append("<Grid><Body><B>");
while(R.next()){
   S.append("<I");
   for(int i=0;i<names.length;i++) toXML(S,names[i],R.getString(colNames[i]));
   S.append("/>");
   }
S.append("</B></Body></Grid>");
return S.toString();
}
//------------------------------------------------------------------------------------------------------------------
// Returns complete XML representation of all rows with given attribute names and their values from ResultSet in columns indexed as attribute names
String getTableXML(java.sql.ResultSet R, String[] names, int[] colIndexes) throws java.sql.SQLException {
StringBuffer S = new StringBuffer();
S.append("<Grid><Body><B>");
while(R.next()){
   S.append("<I");
   for(int i=0;i<names.length;i++) toXML(S,names[i],R.getString(colIndexes[i]));
   S.append("/>");
   }
S.append("</B></Body></Grid>");
return S.toString();
}

//------------------------------------------------------------------------------------------------------------------
// Returns complete XML representation of all rows with given attribute names and their values from ResultSet in columns indexed as attribute names
String getTableXML(java.sql.ResultSet R, String[] names) throws java.sql.SQLException {
StringBuffer S = new StringBuffer();
S.append("<Grid><Body><B>");
while(R.next()){
   S.append("<I");
   for(int i=0;i<names.length;i++) toXML(S,names[i],R.getString(i+1));
   S.append("/>");
   }
S.append("</B></Body></Grid>");
return S.toString();
}
//------------------------------------------------------------------------------------------------------------------
// Returns complete XML representation from database resultset. Uses the same TreeGrid column names as in resultset
// idCol is name of database column that will be stored to id attribute
String getTableXML(java.sql.ResultSet R) throws java.sql.SQLException { return getTableXML(R,"id"); }
String getTableXML(java.sql.ResultSet R, String idCol) throws java.sql.SQLException {
java.sql.ResultSetMetaData M = R.getMetaData();
int cnt = M.getColumnCount();
String[] names = new String[cnt];
for(int i=1;i<=cnt;i++){
   String Name= M.getColumnName(i);
   if(Name.equalsIgnoreCase(idCol)) Name="id";
   names[i-1] = Name;
   }
return getTableXML(R,names);
}
//------------------------------------------------------------------------------------------------------------------
// Returns complete XML representation of all rows with given attribute names and their values from ResultSet in columns indexed as attribute names
// table is name of database table
// names are TreeGrid attribute names in order in that are filled from columns from database table
// names must contain name "id", this is identify attribute
// names must also contain "Parent", this is column related to id in Parent<-Child. 
//    In Parent column the row has value of id column of parent row => All parent's children have its id in their Parent column
// For deep==false reads only one level of tree, for server side child paging
String getTreeXML(java.sql.Statement Cmd, String table, String[] names, String[] colNames, String bodyParent) throws java.sql.SQLException { return getTreeXML(Cmd,table,orderNames(Cmd,table,names,colNames),bodyParent); }
String getTreeXML(java.sql.Statement Cmd, String table, String[] names, String[] colNames, String bodyParent, String headParent, String footParent, boolean deep) throws java.sql.SQLException { return getTreeXML(Cmd,table,orderNames(Cmd,table,names,colNames),bodyParent,headParent,footParent,deep); }
String getTreeXML(java.sql.Statement Cmd, String table, String[] names, String bodyParent) throws java.sql.SQLException { return getTreeXML(Cmd,table,names,bodyParent,null,null,true); }
String getTreeXML(java.sql.Statement Cmd, String table, String[] names, String bodyParent, String headParent, String footParent, boolean deep) throws java.sql.SQLException {
StringBuffer S = new StringBuffer();
S.append("<Grid>");
if(headParent!=null) S.append("<Head>" + getTreeXML(Cmd,table,names,headParent,deep) + "</Head>");
if(bodyParent!=null) S.append("<Foot>" + getTreeXML(Cmd,table,names,footParent,deep) + "</Foot>");
S.append("<Body><B>" + getTreeXML(Cmd,table,names,bodyParent,deep) + "</B></Body>");
S.append("</Grid>");
//out.print(Str.toString().replaceAll("\\&","&amp;").replaceAll("\\<","&lt;").replaceAll("\\>","&gt;").replaceAll("\\\"","&quot;"));
return S.toString();
}
//------------------------------------------------------------------------------------------------------------------
// Helper function for getTreeXML()
// orders names (attribute names) to match indexes in table according to colNames
String[] orderNames(java.sql.Statement Cmd, String table, String[] names, String[] colNames) throws java.sql.SQLException {
java.sql.ResultSet R = Cmd.executeQuery("SELECT TOP 1 * FROM "+table);
java.sql.ResultSetMetaData M = R.getMetaData();
int cnt = M.getColumnCount();
String[] newnames = new String[cnt];
for(int i=1;i<=cnt;i++){
   String Name = M.getColumnName(i);
   for(int j=0;j<colNames.length;j++) if(Name.equalsIgnoreCase(colNames[j])) newnames[i-1] = names[j];
   }
return newnames;
}
//------------------------------------------------------------------------------------------------------------------
// Returns children of row with id parentVal => returns all rows that have in their Parent column value parentVal
// Other parameters are the same as in previous function getTreeXML
String getTreeXML(java.sql.Statement Cmd, String table, String[] names, String[] colNames, String parentVal, boolean deep) throws java.sql.SQLException { return getTreeXML(Cmd,table,orderNames(Cmd,table,names,colNames),parentVal,deep); }
String getTreeXML(java.sql.Statement Cmd, String table, String[] names, String parentVal, boolean deep) throws java.sql.SQLException {
StringBuffer S = new StringBuffer();
int cnt = names.length, id=0,parent=0;
for(int i=0;i<cnt;i++) {
   if(names[i]==null) continue;
   if(names[i].equalsIgnoreCase("id")) id = i+1;
   else if(names[i].equalsIgnoreCase("parent")) parent = i+1;
   }
java.sql.ResultSet R = Cmd.executeQuery("SELECT * FROM "+table+(parent>0?" WHERE "+names[parent-1]+"='"+parentVal+"'":""));
if(R==null) return "";
while(R.next()){
   S.append("<I");
   for(int i=1;i<=cnt;i++){
      String Name= names[i-1];
      String Value = R.getString(i);
      if(i!=parent && Value!=null && Value.length()>0){
         S.append(" "+Name+"='"+Value.replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll("'","&apos;").replaceAll("\n","&#x0a;").replaceAll("\r","&#x0d;")+"'");
         }
      }
   S.append(">");
   if(parent>0 && deep) S.append(getTreeXML(Cmd,table,names,R.getString(id),deep)+"\r\n");
   S.append("</I>");
   }
return S.toString();
}


// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Examples support
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//------------------------------------------------------------------------------------------------------------------
// Returns statemenet to HSQLDB database. This database provider is used for examples
java.sql.Statement getHsqlStatement(HttpServletRequest request, JspWriter out, String dbPath, String user, String pass) throws Exception{ return getHsqlStatement(request,out,dbPath,user,pass,false); }
java.sql.Statement getHsqlStatement(HttpServletRequest request, JspWriter out, String dbPath, String user, String pass, boolean fromHTML) throws Exception {
String Path = request.getServletPath().replaceAll("[^\\/\\\\]*$",""); // Relative path to script directory ending with "/"
java.sql.Connection Conn = null;
java.sql.Statement Cmd = null;
try {
	Class.forName("org.hsqldb.jdbcDriver").newInstance();
	Conn = java.sql.DriverManager.getConnection("jdbc:hsqldb:file:"+request.getRealPath(Path+dbPath), "sa", "");
	return Conn.createStatement();
   } catch (Exception e) {
      //String Err = "! Failed to load HSQLDB JDBC driver.<br>You need to copy <b>hsqldb.jar</b> file to your shared lib directory and <b>restart</b> your http server.";
      String Err = "! Failed to load HSQLDB JDBC driver.\n\nYou need to copy \"hsqldb.jar\" file to your shared lib directory and RESTART your http server.";
      try{
         out.print(fromHTML?"<font color=red>"+Err+"</font>" : "<Grid><IO Result='-1' Message='"+Err+"'/></Grid>");
         out.close();
      } catch(Exception e2) { }
      throw new Exception(Err);
   }
}
//------------------------------------------------------------------------------------------------------------------
%>