unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, HiMECSFormCollect, StdCtrls, HiMECSConst;

type
  TCreateEngineInfo = procedure of object;

  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FPackageModules : array of HModule;
    FCreateEngineInfo : TCreateEngineInfo;
    FHiMECSForms: THiMECSForms; //bpl로 부터 form list를 저장함
  public
    procedure CreateEngineInfoForm;
    procedure PackageLoad;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.CreateEngineInfoForm;
var
  i: Integer;
begin
  if Assigned(FCreateEngineInfo) then
    FCreateEngineInfo;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FHiMECSForms := THiMECSForms.Create(Self);
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  //if FPackageModule <> 0 then
  for i := 0 to High(FPackageModules) - 1 do
    if FPackageModules[i] <> 0 then
      UnloadPackage(FPackageModules[i]);

  FHiMECSForms.Free;
end;

procedure TForm1.PackageLoad;
var
  i: integer;
begin
  FHiMECSForms.PackageCollect.Clear;
  FHiMECSForms.LoadFromFile(DefaultFormsFileName,DefaultFormsFileName,True);
  SetLength(FPackageModules, FHiMECSForms.PackageCollect.Count);

  for i := 0 to FHiMECSForms.PackageCollect.Count - 1 do
  begin
    FPackageModules[i] := LoadPackage('e:\pjh\project\util\HiMECS\Application\Source\bpl\' + FHiMECSForms.PackageCollect.Items[i].PackageName);

    if FPackageModules[i] <> 0 then
    begin
      try
        @FCreateEngineInfo := GetProcAddress(FPackageModules[i], PWideChar(FHiMECSForms.PackageCollect.Items[i].CreateFuncName));
      except
        ShowMessage('Package not found!');
      end;
    end;
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if High(FPackageModules) < 0 then
    PackageLoad;

  CreateEngineInfoForm;

end;

end.
