unit adxtHeadersFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdxToysForm, ExtCtrls, StdCtrls, Buttons, ToolWin, ComCtrls;

type
  TfrmIHeaders = class(TfrmTemplate)
    panMain: TPanel;
    panRightBtns: TPanel;
    btnDelete: TBitBtn;
    pcMain: TPageControl;
    tsHeaders: TTabSheet;
    memHeaders: TMemo;
    btnOpen: TBitBtn;
    btnClose: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses Outlook2000;

{$R *.dfm}

procedure TfrmIHeaders.FormCreate(Sender: TObject);
begin
  inherited;
  pcMain.ActivePageIndex := 0;
end;

procedure TfrmIHeaders.btnDeleteClick(Sender: TObject);
var
  Intf: Outlook2000._MailItem;
begin
  IDispatch(Intf) := AddIn.OutlookApp.ActiveExplorer.Selection.Item(1);
  Intf.Delete;
  ModalResult := mrCancel;
end;

procedure TfrmIHeaders.btnOpenClick(Sender: TObject);
begin
  ModalResult := mrYes;
end;

end.
