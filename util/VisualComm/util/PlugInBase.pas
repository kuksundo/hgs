{+-----------------------------------------------------------------------------+
 | Class:       TBasePlugIn
 | Created:     01/04/2000
 | Author:      Eli Yukelzon a.k.a Fulgore
 |              Ported from Plugger by Tobin Schwaiger-Hastanan
 | Description: Base Class for writing Plugins
 | Version:     0.0.1
 | Copyright (c) 2000 Eli Yukelzon a.k.a Fulgore
 | All rights reserved.
 |
 | Thanks to: Tobin Schwaiger-Hastanan
 +----------------------------------------------------------------------------+}
unit PlugInBase;

interface

type
  TBasePlugIn = class
  private
	  // pointers for binary tree...
	  m_pLeft:TBasePlugIn;
	  m_pRight:TBasePlugIn;
  public
    property Left:TBasePlugIn read m_pLeft write m_pLeft;
    property Right:TBasePlugIn read m_pRight write m_pRight;
    constructor Create;
    destructor Destroy;
    // override this one with your unique name identifier
	  function GetPlugInName:String; virtual;
	  // create your own generic interface as needed... this is just a sample
    function ProcessFile(FileName:string):string; virtual;
    procedure RegisterDefaultComponent; virtual;
  end;

implementation

{ TBasePlugIn }

constructor TBasePlugIn.Create;
begin
//
end;

destructor TBasePlugIn.Destroy;
begin
//
end;

function TBasePlugIn.GetPlugInName: String;
begin
 result:='';
end;

function TBasePlugIn.ProcessFile(FileName: string): string;
begin
 result:='';
end;

procedure TBasePlugIn.RegisterDefaultComponent;
begin
;
end;

end.
