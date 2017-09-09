unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    FPackageHandles : array of HModule;
  end;

var
  Form1: TForm1;

implementation

uses CommonUtil;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
  LStrList: TStringList;
begin
    if FileExists('E:\pjh\project\util\HiMECS\Application\Bin\Bpls\pjhCommonUnit4ExtLib.bpl') then
    begin
      SetLength(FPackageHandles, 1);
      FPackageHandles[0] := LoadPackage('E:\pjh\project\util\HiMECS\Application\Bin\Bpls\pjhCommonUnit4ExtLib.bpl');
    end;

    if FileExists('E:\pjh\project\util\HiMECS\Application\Bin\Bpls\pjhCompSharedPkg.bpl') then
    begin
      SetLength(FPackageHandles, High(FPackageHandles) + 1 + 1);
      FPackageHandles[High(FPackageHandles)] := LoadPackage('E:\pjh\project\util\HiMECS\Application\Bin\Bpls\pjhCompSharedPkg.bpl');
    end;

    if FileExists('E:\pjh\project\util\HiMECS\Application\Bin\Bpls\ExtLib_DXE5.bpl') then
    begin
      SetLength(FPackageHandles, High(FPackageHandles) + 1 + 1);
      FPackageHandles[High(FPackageHandles)] := LoadPackage('E:\pjh\project\util\HiMECS\Application\Bin\Bpls\ExtLib_DXE5.bpl');
    end;

  LStrList := GetFileListFromDir('E:\pjh\project\util\HiMECS\Application\Bin\Bpls', '*.bpl', false);
  try
    SetLength(FPackageHandles, LStrList.Count);

    //ExtLib_XE5.bpl 보다 pjhCommonUnit4ExtLib.bpl이 반드시 먼저 Load 되어야 함
    for i := High(FPackageHandles) Downto Low(FPackageHandles) do
    begin
//      if (LStrList.Strings[i] <> 'pjhCommonUnit4ExtLib.bpl') and
//         (LStrList.Strings[i] <> 'pjhCompSharedPkg.bpl') then
//      begin
        FPackageHandles[i] := LoadPackage(LStrList.Strings[i]);
//      end;
    end;
  finally
    LStrList.Free;
  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i: integer;
begin
  for i := High(FPackageHandles) Downto Low(FPackageHandles) do
  begin
    UnLoadPackage(FPackageHandles[i]);
  end;

  FPackageHandles := nil;
end;

end.
