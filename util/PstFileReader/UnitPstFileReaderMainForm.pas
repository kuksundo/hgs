unit UnitPstFileReaderMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Redemption_TLB, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses ComObj;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
  LRDOSession: IRDOSession;
  LStore: RDOPstStore;
  LFolder: RDOFolder;
  LMail: RDOMail;
  LStr: string;

  procedure ProcessMail(AFolder: RDOFolder);
  var
    i: integer;
  begin
    for i := 1 to AFolder.Folders.Count do
    begin
      if AFolder.Folders.Item(i).Name <> '지운 편지함' then
        ProcessMail(AFolder.Folders.Item(i));
    end;

    for i := 1 to AFolder.Items.Count do
    begin
      LMail := AFolder.Items.Item(i);

      if (LMail.BodyFormat = olFormatPlain) or (LMail.BodyFormat = olFormatUnspecified) then
        ShowMessage(LMail.Body)
      else if LMail.BodyFormat = olFormatHTML then
        ShowMessage(LMail.HTMLBody)
      else if LMail.BodyFormat = olFormatRichText then
        ShowMessage(LMail.RTFBody);
    end;

//    ShowMessage(AFolder.Name);
  end;
begin
  LRDOSession := CreateOleObject('Redemption.RDOSession') as IRDOSession;
  try
    LStore := LRDOSession.LogonPstStore('c:\temp\test.pst',1,'test',null,null);
    LFolder := LStore.IPMRootFolder;

    ProcessMail(LFolder);

//    for i := 1 to LFolder.Folders.Count do
//    begin
//      LFolder.Folders.Item(i).Folders.Count;
//      LStr := LStr + LFolder.Folders.Item(i).Name + #13#10;
//    end;

//    ShowMessage(LStr);

  finally
    LRDOSession.Logoff;
//    LRDOSession := UnAssigned;
  end;
end;

end.
