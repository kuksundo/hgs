//******************************************************************************
//
// EventSinkImp
//
// Copyright © 1999-2000 Binh Ly
// All Rights Reserved
//
// bly@techvanguards.com
// http://www.techvanguards.com
//******************************************************************************
unit AboutFrm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls;

type
  TfrmAbout = class(TForm)
    Panel1: TPanel;
    OKButton: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ProductName: TLabel;
    Version: TLabel;
    Shape1: TShape;
    Image1: TImage;
    Memo1: TMemo;
    TabSheet2: TTabSheet;
    Memo2: TMemo;
    BuildDate: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses
  Utils;

procedure TfrmAbout.FormShow(Sender: TObject);
begin
  Version.Caption := Format ('Version %s', [GetAppVersion]);
  BuildDate.Caption := FormatDateTime ('mmmm yyyy', GetFileTime (Application.ExeName));
end;

end.

