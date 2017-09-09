unit pjhDesignCompIntf;

interface

uses
  Windows, Messages, SysUtils, Classes, vcl.Graphics, vcl.Controls, vcl.Forms,
  vcl.Dialogs, pjhClasses;

type
  IpjhDesignCompInterface = interface ['{13218B69-2580-4B27-84B5-6B16F67E0EB4}']
    function GetpjhTagInfo: TpjhTagInfo;
    procedure SetpjhTagInfo(Value: TpjhTagInfo);
    function GetpjhValue: string;
    procedure SetpjhValue(Value: string);
    function GetBplFileName: string;
    procedure SetBplFileName(Value: string);

    property pjhTagInfo: TpjhTagInfo read GetpjhTagInfo write SetpjhTagInfo;
    property pjhValue: string read GetpjhValue write SetpjhValue;
    property pjhBplFileName: string read GetBplFileName write SetBplFileName;
  end;

implementation

end.
