unit menu_plugin_interface;
{*****************************************************************************
* The contents of this file are used with permission, subject to
* the Mozilla Public License Version 1.1 (the "License"); you may
* not use this file except in compliance with the License. You may
* obtain a copy of the License at
* http://www.mozilla.org/MPL/MPL-1.1.html
*
* Software distributed under the License is distributed on an
* "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
* implied. See the License for the specific language governing
* rights and limitations under the License.
*
*****************************************************************************
*
* This file was created by Mason Wheeler.  He can be reached for support at
* www.turbu-rpg.com.
*****************************************************************************}

interface

uses
   SysUtils, Generics.Collections;

type

   TPlugBase = class(TInterfacedObject)
   public
      constructor Create; virtual;
      function IsDesign: boolean; virtual;
   end;

   TPlugClass = class of TPlugBase;

   IMenuPlugin = interface(IInterface)
   ['{EC78AE5D-1B52-4982-9AC7-19D95D67A26E}']
      //function listPlugins: TEngineDataList;
   end;

   EMenuPlugin = class(Exception);

implementation

{ TRpgPlugBase }

//does nothing, but just leave it. It's virtual and shouldn't be abstract
constructor TRpgPlugBase.Create;
begin
   inherited Create;
end;

function TRpgPlugBase.IsDesign: boolean;
begin
   result := false;
end;

end.
