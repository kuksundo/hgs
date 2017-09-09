{****************************************************************************
*                                                                           *
*                         An exponential backoff                            *
*                                                                           *
*                                                                           *
* Language:             FPC Pascal v2.2.0+ / Delphi 6+                      *
*                                                                           *
* Required switches:    none                                                *
*                                                                           *
* Authors:  Amine Moulay Ramdane                                            *                            
*                                                                           *   
*                                                                           * 
* Date:                 june 30, 2009                                       *
*                                                                           *
* Last update:          October 22,2010                                     *
*                                                                           *
* Version:              1.01                                                *
* Licence:              MPL or GPL                                          *
*                                                                           *
*        Send bug reports and feedback to  darekm @@ emadar @@ com          *
*   You can always get the latest version/revision of this package from     *
*                                                                           *
*           http://www.emadar.com/fpc/lockfree.htm                          *
*           http://pages.videotron.com/aminer/                              *
*                                                                           *
* Description:  Exponential backoff                                         *
*                                                                           *
*  This program is distributed in the hope that it will be useful,          *
*  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     *
*                                                                           *
*                                                                           *
*****************************************************************************
*                      BEGIN LICENSE BLOCK                                  *

The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: flqueue.pas, released 20.01.2008.
The Initial Developer of the Original Code is Dariusz Mazur


Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.

*                     END LICENSE BLOCK                                     * }



unit ExpBackoff;


interface

uses
{$IF defined(windows) or defined(Windows32) or defined(Windows64)}
winApi.windows,
{$IFEND}
{$IFDEF XE}system.math,system.sysutils;{$ENDIF}
{$IFDEF FreePascal}math,sysutils;{$ENDIF}


type

  TExpBackoff = class
  private
      mindelay,maxdelay,limit:integer;
     
  public
      constructor create(min:integer=1;max:integer=8);  {allocate tab with size equal 2^aPower, for 20 size is equal 1048576}
      destructor Destroy; override;
      function delay:integer; 
      procedure reset;

  end;


implementation



constructor TExpBackoff.create(min:integer=1;max:integer=8);
begin
  
 mindelay:=min;maxdelay:=max;
 limit:=min;
 randomize;
end;

destructor  TExpBackoff.Destroy;

begin
  
  inherited Destroy;
end;


function TExpBackoff.delay:integer;
var delay1:integer;
begin
  delay1:=random(limit);
  if limit<>maxdelay then limit:=min(maxdelay,2*limit);
  //sleep(delay1); 
  result:=delay1;
 end;

procedure TExpBackoff.reset;
begin
  limit:=mindelay;
 end;

end.

