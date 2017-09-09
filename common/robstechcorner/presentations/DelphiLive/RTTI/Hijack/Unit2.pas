unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  {$M+}
    TNewHack = Class(TObject)
    public
      procedure NewVMTMethod; virtual;
    end;
    TTestObject = class(TObject)
      private
        procedure TestPrivate; virtual;
      protected
        procedure TestProtected; virtual;
      public
        procedure TestPublic; virtual;
      published
        procedure TestPublished; virtual;
    end;
  {$M-}
  TForm2 = class(TForm)
    ListBox1: TListBox;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
uses jclSysUtils;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
end;

{ TTestObject }

procedure TTestObject.TestPrivate;
begin
  ShowMessage('TestPrivate');
end;

procedure TTestObject.TestProtected;
begin
  ShowMessage('TestProtected');
end;

procedure TTestObject.TestPublic;
begin
   ShowMessage('TestPublic');
end;

procedure TTestObject.TestPublished;
begin
   ShowMessage('TestPublished');
end;

procedure TForm2.Button2Click(Sender: TObject);
var
 Test : TTestObject;
 I, Cnt: Integer;
 HackMethod : Pointer;
begin
{ Show the Virtual Address List
 Cnt := GetVirtualMethodCount(TTestObject);

 for I := 0 to Cnt - 1 do
 begin

    ListBox1.Items.Add(IntTostr(
    Integer(GetVirtualMethod(TTestObject,I))));
 end;
 // }

// { Now hack the method
 HackMethod := GetVirtualMethod(TNewHack,0);

 SetVirtualMethod(TTestObject,2,HackMethod);
 //}

// { Execute TestPublic
 Test := TTestObject.Create;
 Test.TestPublic;
 Test.Free;      //}
end;

{ TNewParent }


{ TNewHack }

procedure TNewHack.NewVMTMethod;
begin
  ShowMessage('Hacked');
end;

end.
