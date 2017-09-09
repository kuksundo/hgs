{ unit TempMessages

  Project: ABC-View Manager

  Author: Nils Haeck M.Sc.
  Copyright (c) 2000 - 2005 by SimDesign B.V.

  It is NOT allowed to publish or copy this software without express permission
  of the author!
}
unit guiTempMessages;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TdlgTempMessage = class(TForm)
    lblMessage: TLabel;
    btnOK: TBitBtn;
    CheckBox1: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgTempMessage: TdlgTempMessage;

implementation

{$R *.DFM}

end.
