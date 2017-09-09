unit Watch2Interface;

interface

uses
  Windows, Messages, SysUtils, Classes, vcl.Graphics, vcl.Controls, vcl.Forms,
  vcl.Dialogs;

type
  IWatch2Interface = interface ['{19F89759-D622-431F-8E23-5A196D5908CB}']
    procedure GetTagNames(ATagNameList, ADescriptList: TStringList);
    procedure GetLoadedPackages(APackageList: TStringList);
  end;

implementation

end.
