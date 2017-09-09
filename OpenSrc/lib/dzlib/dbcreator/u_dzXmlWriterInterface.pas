unit u_dzXmlWriterInterface;

interface

uses
  SysUtils,
  Classes,
  u_dzNameValueList;

type
  IdzXmlWriter = interface ['{D8EC30ED-88EC-4908-9D8A-26876D366C14}']
    ///<summary> Does a WriteLn to the stream </summary>
    procedure WriteLine(const _Line: string);
    ///<summary> combines WriteLn and Format </summary>
    procedure WriteLineFmt(const _Format: string; _Args: array of const);
    ///<summary> starts a XML Entity by writing '<name attribname="attribvalue"... >'
    ///          to the stream
    ///          @param Name is a string specifying the name of the entity
    ///          @param Attribs is an array of string specifying alternatingly the
    ///                 name and the value of attributes like this:
    ///                 ['name1', 'value1', 'name2', 'value2'] </summary>
    procedure StartEntity(const _Name: string; const _Attribs: array of string); overload;
    procedure StartEntity(const _Name: string; _Attribs: TNameValueList); overload;
    ///<summary> Same as StartEntity but excpects the attributes to be stored as
    ///          name=value pairs in the stringlist
    ///          @bold(If you add a name with an empty value to a stringlist, the class will
    ///                ignore this entry or remove an existing entry, e.g.:
    ///                sl.Values['aname'] := '' will result in a list without
    ///                aname in it, NOT in a list with an 'aname=' line.
    ///                So be carefull when using this method for required attributes!) </summary>
    procedure StartEntity2(const _Name: string; _Attribs: TStrings);
    ///<summary> ends a XML Entity by writing '</name>' to the stream
    ///          @param Name is a string specifying the name of the entity. Note that
    ///                 the object does not verify that there is an opening tag
    ///                 for this entity. </summary>
    procedure EndEntity(const _Name: string);
    ///<summary> writes a XML Entity in the form '<name attribname="attribvalue"... />'
    ///          to the stream
    ///          @param Name is a string specifying the name of the entity
    ///          @param Attribs is an array of string specifying alternatingly the
    ///                 name and the value of attributes like this:
    ///                 ['name1', 'value1', 'name2', 'value2'] </summary>
    procedure WriteEntity(const _Name: string; const _Attribs: array of string); overload;
    procedure WriteEntity(const _Name: string; _Attribs: TNameValueList); overload;
    ///<summary> Same as WriteEntity but excpects the attributes to be stored as name=value pairs in the stringlist
    ///          @bold(If you add a name with an empty value to a stringlist, the class will
    ///                ignore this entry or remove an existing entry, e.g.:
    ///                sl.Values['aname'] := '' will result in a list without
    ///                aname in it, NOT in a list with an 'aname=' line.
    ///                So be carefull when using this method for required attributes!) </summary>
    procedure WriteEntity2(const _Name: string; _Attribs: TStrings); overload;
    ///<summary> writes a standard XML header <?xml ... </summary>
    procedure WriteHeader;
    ///<summary> starts a CDATA section within the xml file for storing verbatim text </summary>
    procedure StartCdata;
    ///<summary> ends a CDATA section started with StartCdata </summary>
    procedure EndCdata;
    ///<summary> calls StartCdata, writes the line and calls EndCdata </summary>
    procedure WriteCdataLine(const _Line: string);
  end;

type
  ///<summary> represents an xml attribute, consisting of a name and a value </summary>
  IdzXmlAttribute = interface ['{411CE974-27DD-4FE8-BC53-C95B0EF3D66E}']
    function Name: string;
    function Value: string;
  end;

type
  ///<summary> ancestor to IdzXMLEntity introduces the Write method </summary>
  IdzXmlNode = interface ['{A810A18F-A5BA-40DC-85E8-1BE9A4FCAFAC}']
    procedure Write(const _Writer: IdzXmlWriter);
  end;

type
  ///<summary> extends IdzXmlNode to represent an XML entity </summary>
  IdzXmlEntity = interface(IdzXmlNode) ['{EF64BBF3-45DD-43D6-8C63-815BB1F1EFD1}']
    ///<summary> Adds an attribute to the node </summary>
    procedure AddAttribute(_Attribute: IdzXmlAttribute);
    ///<summary> Adds a sub node to the node </summary>
    procedure AddNode(const _Node: IdzXmlNode);
  end;

implementation

end.

