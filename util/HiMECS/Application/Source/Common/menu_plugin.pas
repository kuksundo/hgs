unit menu_plugin;

interface

uses
  SysUtils, Dialogs, Contnrs, JvPlugin, turbu_plugin_interface;

type
   TRpgPlugin = class(TJvPlugin, ITurbuPlugin)
   private
      { Private declarations }
   public
      { Public declarations }
      function listPlugins: TObjectList;
   end;

function RegisterPlugin: TRpgPlugin; stdcall;

exports
   RegisterPlugin;

implementation

// IMPORTANT NOTE: If you change the name of the Plugin container,
// you must set the type below to the same type. (Delphi changes
// the declaration, but not the procedure itself. Both the return
// type and the type created must be the same as the declared type above.

function RegisterPlugin: TRpgPlugin;
begin
   Result := TRpgPlugin.Create(nil);
end;

{ TRpgPlugin }

function TRpgPlugin.listPlugins: TObjectList;
begin
   result := TObjectList.Create;
end;

end.
