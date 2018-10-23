unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitMSProjectUtil, Vcl.StdCtrls, MSProject_TLB;

type
  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
var
  LProjApp: OleVariant;//TProjectApplication;
  LVer: string;
begin
  LProjApp := GetActiveMSProjectOleObject;
//  LVer := GeMSProjectlVersion(LProjApp);
  ShowMessage(LVer);
  LProjApp.Quit(pjDoNotSave);
end;

procedure TForm4.Button2Click(Sender: TObject);
var
  LProjApp: OleVariant;//TProjectApplication;
begin
  LProjApp := GetActiveMSProjectOleObject;
  LProjApp.Connect;
  LProjApp.Visible := True;
  //파일명에 공란이 없어야 함
  LProjApp.FileOpen('E:\aaa\ttt\C_Majesty_Master_Schedule_for_EGCS_Retrofit_CHC1000094_r5.mpp',
    Null, //ReadOnly
    Null, //Merge
    Null, //TaskInformation
    Null,//Table
    Null,//Sheet
    Null,//NoAuto
    '',//UserID
    '',//DatabasePassWord
    'MSProject.MPP', //FormatID
    Null,//Map
    pjPoolReadWrite,//EmptyParam,  //openPool-pjDoNotOpenPool
    Null,//Password
    Null,//WriteResPassword
    Null,//IgnoreReadOnlyRecommended
    Null//XMLName
    );


end;

procedure TForm4.Button3Click(Sender: TObject);
var
  LProjApp: OleVariant;//TProjectApplication;
  LProject: OleVariant;//Project_;
  LTasks: OleVariant;//Tasks;
  i: integer;
  LStr:string;
begin
//  LProjApp := TProjectApplication.Create(Self);
  LProjApp := GetActiveMSProjectOleObject;
//  LProjApp.Connect;
  LProjApp.Visible := True;
  //파일명에 공란이 없어야 함
  LProjApp.FileOpenEx('E:\aaa\ttt\C_Majesty_Master_Schedule_for_EGCS_Retrofit_CHC1000094_r5.mpp',
    Null, //ReadOnly
    Null, //Merge
    Null, //TaskInformation
    Null,//Table
    Null,//Sheet
    Null,//NoAuto
    Null,//UserID
    Null,//DatabasePassWord
    'MSProject.MPP', //FormatID
    Null,//Map
    pjPoolReadWrite,//EmptyParam,  //openPool-pjDoNotOpenPool
    Null,//Password
    Null,//WriteResPassword
    Null,//IgnoreReadOnlyRecommended
    Null,//XMLName
    Null //DoNotLoadFromEnterprise
    );

  LProject :=  LProjApp.ActiveProject;
  LTasks := LProject.Tasks;
//  ShowMessage(LProject.Name);

  for i := 1 to LTasks.Count do
  begin
    LStr := LTasks.Item[i].Start;
  end;

  ShowMessage(LStr);
end;

end.
