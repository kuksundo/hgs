{ Canonicalize an xml document

  The acronym for canonicalization is "C14N"

  An xml document after C14N must be:
  - encoded in UTF-8 only
  - xml declaration removed
  - entities expanded to their character equivalent
  - CDATA sections replaced by character equivalent
  - special &lt; &gt; and &quot; entities encoded
  - attributes normalized as if by validating parser
  - empty elements opened with start and end tags
  - namespace declarations and attributes sorted

  Experimental!

  Author: Nils Haeck M.Sc.
  Copyright (c) 2010 - 2011 Simdesign B.V. (www.simdesign.nl)

  It is NOT allowed under ANY circumstances to publish, alter or copy this code
  without accepting the license conditions in accompanying LICENSE.txt
  first!

  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
  ANY KIND, either express or implied.

  Please visit http://www.simdesign.nl/xml.html for more information.
}
unit NativeXmlC14n;

interface

uses
  SysUtils, NativeXml, sdDebug;

type

  TNativeXmlC14N = class(TDebugComponent)
  public
    class procedure Canonicalize(AXml: TNativeXml);
  end;

implementation

{ TNativeXmlC14N }

class procedure TNativeXmlC14N.Canonicalize(AXml: TNativeXml);
var
  Decl: TXmlNode;
  DTD: TsdDocType;
  DtdEntityNodes: array of TXmlNode;
  i, j, TotalNodeCount, CharDataCount, ReferencesCount: integer;
  Node: TXmlNode;
  CharData: TsdCharData;
  SubstituteText: Utf8String;
begin
  TotalNodeCount := 0;
  CharDataCount := 0;
  ReferencesCount := 0;

  // encode in UTF-8 only - this is already achieved by the parser

  // xml compacted
  //AXml.XmlFormat := xfCompact;

  // remove xml declaration
  Decl := AXml.RootNodes[0];
  if Decl is TsdDeclaration then
  begin
    AXml.RootNodes.Delete(0);
  end;

  // recursively expand entities to their character equivalent:

  // find dtdentity nodes in the dtd
  DTD := TsdDocType(AXml.RootNodes.ByType(xeDocType));
  if assigned(DTD) then
  begin
    j := 0;
    SetLength(DtdEntityNodes, j);
    for i := 0 to DTD.NodeCount - 1 do
      if DTD.Nodes[i] is TsdDtdEntity then
      begin
        inc(j);
        SetLength(DtdEntityNodes, j);
        DtdEntityNodes[j - 1] := TsdDtdEntity(DTD.Nodes[i]);
      end;
  end;

  // find references

  Node := AXml.FindFirst;
  while assigned(Node) do
  begin
    inc(TotalNodeCount);

    // check for entity references
    if Node is TsdCharData then
    begin
      inc(CharDataCount);

      // non-standard references usually come from entity references in the dtd
      if TsdCharData(Node).HasNonStandardReferences then
      begin
        inc(ReferencesCount);

        CharData := TsdCharData(Node);

        // substitute chardata value using the references
        SubstituteText := AnsiDequotedStr(CharData.GetValueUsingReferences(DtdEntityNodes), '"');

        Node := AXml.ParseSubstituteContentFromNode(Chardata, SubstituteText);
      end;
    end;

    Node := AXml.FindNext(Node);
  end;


  // replace CDATA sections by character equivalent

  // encode special &lt; &gt; and &quot; entities

  // normalize attributes as if by validating parser

  // open empty elements with start and end tags

  // sort namespace declarations and attributes

  AXml.DoDebugOut(AXml, wsInfo, format('total node count: %d, chardata count: %d, references count: %d',
  [TotalNodeCount, CharDataCount, ReferencesCount]));
  AXml.DoDebugOut(AXml, wsInfo, 'C14N created');
end;

end.
