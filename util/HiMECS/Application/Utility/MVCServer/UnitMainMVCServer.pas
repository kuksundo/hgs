unit UnitMainMVCServer;

{$I Synopse.inc}

interface

uses
  System.SysUtils,
  SynCrtSock,
  SynCommons,
  SynLog,
  mORMot,
  SynSQLite3,
  SynSQLite3Static,
  mORMotSQLite3,
  mORMotHttpServer,
  mORMotMVC,
  HiMECSMVCModel,
  HiMECSMVCViewModel,
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Rtti, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FModel: TSQLModel;
    FServer: TSQLRestServerDB;
    FApplication: TBlogApplication;
    FHTTPServer: TSQLHttpServer;
  public
    procedure InitVar;
    procedure FinalizeVar;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

type
  TMyRecord = record
  private
    str: string;
  public
    property strProp: string read str;
  end;

procedure TForm1.Button1Click(Sender: TObject);
var
 c : TRttiContext;
 t : TRttiType;
 field : TRttiField;
 prop : TRttiProperty;
begin
 c := TRttiContext.Create;
 try
   Memo1.Lines.Append('Fields');
   for field in c.GetType(TypeInfo(TMyRecord)).GetFields do
   begin
     t := field.FieldType;
     Memo1.Lines.Append('Field:'+field.Name);
     Memo1.Lines.Append('RttiType:'+t.ClassName);
   end;

   Memo1.Lines.Append('Properties');
   for prop in c.GetType(TypeInfo(TMyRecord)).GetProperties do
   begin
     t := prop.PropertyType;
     Memo1.Lines.Append('Property:'+prop.Name);
     Memo1.Lines.Append('RttiType:'+t.ClassName);
   end;

 finally
   c.Free
 end;end;

procedure TForm1.FinalizeVar;
begin
  FHTTPServer.Free;
  FApplication.Free;
  FServer.Free;
  FModel.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  InitVar;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FinalizeVar;
end;

procedure TForm1.InitVar;
begin
  FModel := CreateModel;
  FServer := TSQLRestServerDB.Create(FModel,ChangeFileExt(ExeVersion.ProgramFileName,'.db'));
  FServer.DB.Synchronous := smNormal;
  FServer.DB.LockingMode := lmExclusive;
  FServer.CreateMissingTables;
  FApplication := TBlogApplication.Create;
  FApplication.Start(FServer);
  FHTTPServer := TSQLHttpServer.Create('8092',FServer
    {$ifndef ONLYUSEHTTPSOCKET},'+',useHttpApiRegisteringURI{$endif});
  FHTTPServer.RootRedirectToURI('blog/default'); // redirect / to blog/default
  FServer.RootRedirectGet := 'blog/default';  // redirect blog to blog/default
end;

end.
