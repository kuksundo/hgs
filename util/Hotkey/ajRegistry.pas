          ///////////////////////////////////////////////////////////////////////
          //                                                                   //
          //       SoftSpot Software Component Library                         //
          //       Key Maker software component                                //
          //                                                                   //
          //       Copyright (c) 1996 - 2002 SoftSpot Software Ltd.            //
          //       ALL RIGHTS RESERVED                                         //
          //                                                                   //
          //   The entire contents of this file is protected by U.S. and       //
          //   International Copyright Laws. Unauthorized reproduction,        //
          //   reverse-engineering, and distribution of all or any portion of  //
          //   the code contained in this file is strictly prohibited and may  //
          //   result in severe civil and criminal penalties and will be       //
          //   prosecuted to the maximum extent possible under the law.        //
          //                                                                   //
          //   RESTRICTIONS                                                    //
          //                                                                   //
          //   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED      //
          //   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE        //
          //   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE       //
          //   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT  //
          //   AND PERMISSION FROM SOFTSPOT SOFTWARE LTD.                      //
          //                                                                   //
          //   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON       //
          //   ADDITIONAL RESTRICTIONS.                                        //
          //                                                                   //
          ///////////////////////////////////////////////////////////////////////

unit ajRegistry;

{                             -=< Key Maker Registry Functions >=-
{
{ Copyright SoftSpot Software 2002 - All Rights Reserved
{
{ Author        : Andrew J Jameson
{
{ Web site      : www.softspotsoftware.com
{ e-mail        : contact@softspotsoftware.com
{
{ Creation Date : 01 March 2002
{
{ Version       : 1.00
{
{ Description   : Registry functions for Key Maker.                                                }

interface

uses
  Windows;

{..................................................................................................}

const
  cNumRegHKEYKeys = 5; // Number of keys supported.
  cRegHKEYLookUp  : array[1..cNumRegHKEYKeys] of record
    Description : string;
    Value       : HKEY;
  end = ((Description : 'HKCR'; Value : HKEY_CLASSES_ROOT),
         (Description : 'HKCU'; Value : HKEY_CURRENT_USER),
         (Description : 'HKLM'; Value : HKEY_LOCAL_MACHINE),
         (Description : 'HKU';  Value : HKEY_USERS),
         (Description : 'HKCC'; Value : HKEY_CURRENT_CONFIG));

{..................................................................................................}

function RegNumSubKeys  (HKEYValue : HKEY; SubKey : string) : integer;
function HKEYTextToHKEY (HKEYText : string) : HKEY;

implementation

uses
  SysUtils;

{--------------------------------------------------------------------------------------------------}
{                                       Registry Functions                                         }
{--------------------------------------------------------------------------------------------------}

function HKEYTextToHKEY(HKEYText : string) : HKEY;
var
  lp1 : integer;
begin
  lp1 := 0;
  repeat
    inc(lp1);
  until (cRegHKEYLookUp[lp1].Description = HKEYText) or (lp1 = cNumRegHKEYKeys);

  if (cRegHKEYLookUp[lp1].Description = HKEYText) then
    Result  := cRegHKEYLookUp[lp1].Value
  else
    raise Exception.Create(HKEYText + ' - Invalid HKEY description');
end; {HKEYTextToHKEY}

{--------------------------------------------------------------------------------------------------}

function RegNumSubKeys(HKEYValue : HKEY; SubKey : string) : integer;
// Returns the number of keys.
var
  Key         : HKEY;
  NumSubKeys  : DWORD;
begin
  Result  := 0;
  if (RegOpenKeyEx(HKEYValue, PChar(SubKey), 0, KEY_QUERY_VALUE, Key) = ERROR_SUCCESS) then begin
    if (RegQueryInfoKey(Key, nil, nil, nil, @NumSubKeys, nil, nil, nil, nil, nil, nil, nil) = ERROR_SUCCESS) then
      Result  := NumSubKeys;
    RegCloseKey(Key);
  end; {if}
end; {RegNumSubKeys}

{--------------------------------------------------------------------------------------------------}
{ajRegistry}
end.
