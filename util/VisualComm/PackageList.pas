unit PackageList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons, ExtCtrls, Menus, Grids, Mask, IniFiles,
  JvExCheckLst, JvCheckListBox, Vcl.CheckLst;

type
  TProjOption = class(TForm)
    Panel1: TPanel;
    OkButton: TButton;
    CancelButton: TButton;
    Panel2: TPanel;
    PageControl1: TPageControl;
    PakListSheet: TTabSheet;
    GroupBox16: TGroupBox;
    PackageNameDialog: TOpenDialog;
    Panel4: TPanel;
    Panel3: TPanel;
    LabelPackageFile: TLabel;
    AddButton: TButton;
    RemoveButton: TButton;
    EditButton: TButton;
    ButtonComponents: TButton;
    DesignPackageList: TJvCheckListBox;
    procedure AddButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RemoveButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
  public
    FPackageList2: TStringList;

    procedure LoadKnownPackages;
  end;

implementation

uses UtilUnit;

{$R *.DFM}

procedure TProjOption.LoadKnownPackages;
var
  I:Integer;
  PackageName, PackageDescrip:string;
begin
  if not Assigned(FPackageList2) then
    exit;

  FPackageList2.Clear;
  DesignPackageList.Clear;
  //FIniFile.ReadSectionValues(PACKAGE_SECTION, FPackageList2);

  for I:=0 to FPackageList2.Count - 1 do
  begin
    PackageName:= FPackageList2.Names[I];
    PackageDescrip:= FPackageList2.Values[PackageName];

    if PackageDescrip <> 'None' then
      DesignPackageList.Items.Add(PackageDescrip)
    else
      DesignPackageList.Items.Add(PackageName);
  end;//for
end;

procedure TProjOption.AddButtonClick(Sender: TObject);
var
  PackageName:string;
begin
  if PackageNameDialog.Execute then
  begin
    PackageName:= PackageNameDialog.FileName;
    if DesignPackageList.Items.IndexOf(Packagename) < 0  then
    begin
      DesignPackageList.Items.Add(PackageName);
      //DesignPackageList.Items.IndexOfName(PackageName);
      FPackageList2.Add(PackageName + ' = None');
    end
    else
      ShowMessage(PackageName + ' is already exist');
  end;
end;

procedure TProjOption.FormActivate(Sender: TObject);
begin
  if DesignPackageList.Count = 0 then
    LoadKnownPackages;
end;

procedure TProjOption.RemoveButtonClick(Sender: TObject);
var i: integer;
begin
  for i := 0 to DesignPackageList.Count - 1 do
    if DesignPackageList.Selected[i] then
      FPackageList2.Delete(FPackageList2.IndexOfName(DesignPackageList.Items.Strings[i]));

  DesignPackageList.DeleteSelected;
end;

procedure TProjOption.OkButtonClick(Sender: TObject);
var i: integer;
begin
  //FIniFile.EraseSection(PACKAGE_SECTION);

  for i := 0 to FPackageList2.Count - 1 do
    ;//FIniFile.WriteString(PACKAGE_SECTION, FPackageList2.Names[i], 'None');

  //_LoadPackages('');
end;

procedure TProjOption.FormCreate(Sender: TObject);
var Str1: String;
begin
  Str1 := ExtractFilePath(Application.ExeName);
  //FIniFile := TIniFile.Create(Str1 + INI_FILE_NAME);
  //FPackageList2 := TStringList.Create;  Main Form에서 생성 후 Assign 해 줌
end;

procedure TProjOption.FormDestroy(Sender: TObject);
begin
  //FPackageList2.Free;
  //FIniFile.Free;
end;

end.
