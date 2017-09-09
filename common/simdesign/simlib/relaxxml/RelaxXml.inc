{ unit NativeXml.inc

  Nativexml a small-footprint implementation to read and write XML documents
  natively from Delpi code. NativeXml has very fast parsing speeds.

  Author: Nils Haeck M.Sc.
  Copyright (c) 2007 - 2010 Simdesign B.V.

  It is NOT allowed under ANY circumstances to publish, alter or copy this code
  without accepting the license conditions in accompanying LICENSE.txt
  first!

  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
  ANY KIND, either express or implied.

  Please visit http://www.simdesign.nl/xml.html for more information.
}
// Delphi and BCB versions

// Freepascal (MK)
{$ifdef FPC}
  {$MODE DELPHI}
  {$define D7UP}
{$endif FPC}
//Delphi 7
{$ifdef VER150}
  {$define D7UP}
{$endif}
// Delphi 2010
{$ifdef VER210}
  {$define D7UP}
  {$define D12UP}
{$endif}
// Delphi XE
{$ifdef VER220}
  {$define D7UP}
  {$define D12UP}
  {$define D15UP}
{$endif}

