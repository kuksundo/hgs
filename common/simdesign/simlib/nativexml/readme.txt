 unit NativeXml

  This is a small-footprint implementation to read and write XML documents
  natively from Delpi code. NativeXml has very fast parsing speeds.

  You can use this code to read XML documents from files, streams or strings.
  The load routine generates events that can be used to display load progress
  on the fly.

  Note: any external encoding (ANSI, UTF16, etc) is converted to an internal
  encoding that is UTF8. NativeXml uses Utf8String as string type internally,
  and converts from strings with external encoding in the parsing process.
  When writing, UTtf8String strings are converted to the external encoding strings,
  if the encoding was set beforehand, or defaults to UTF8 if no encoding was set.

  Author: Nils Haeck M.Sc.
  Copyright (c) 2004 - 2011 Simdesign B.V. (www.simdesign.nl)


  It is NOT allowed under ANY circumstances to publish, alter or copy this code
  without accepting the license conditions in accompanying LICENSE.txt
  first!

  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
  ANY KIND, either express or implied.

  Please visit http://www.simdesign.nl/xml.html for more information.
