unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Layouts, FMX.TreeView, FMX.StdCtrls, FMX.Controls.Presentation,
  LUX.Graph.Tree, Core;

type
  TForm1 = class(TForm)
    TreeView1: TTreeView;
    TreeView2: TTreeView;
    Panel1: TPanel;
    Button1: TButton;
    ButtonA: TButton;
    ButtonT: TButton;
    ButtonS: TButton;
    ButtonD: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ButtonAClick(Sender: TObject);
    procedure ButtonTClick(Sender: TObject);
    procedure ButtonSClick(Sender: TObject);
    procedure ButtonDClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { private 宣言 }
    ///// メソッド
    procedure ShowTrees;
  public
    { public 宣言 }
    _Root1 :TTreeNode;
    _Root2 :TTreeNode;
    ///// メソッド
    procedure AddNodes( const N_:Integer );
    procedure TransNodes( const N_:Integer );
    procedure SwapNodes( const N_:Integer );
    procedure DelNodes( const N_:Integer );
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.fmx}

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TForm1

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.ShowTrees;
begin
     ShowTree( TreeView1, _Root1 );
     ShowTree( TreeView2, _Root2 );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.AddNodes( const N_:Integer );
var
   N :Integer;
begin
     for N := 1 to N_ do
     begin
          AddNode( _Root1 );
          AddNode( _Root2 );
     end;
end;

procedure TForm1.TransNodes( const N_:Integer );
var
   N :Integer;
begin
     for N := 1 to N_ do
     begin
          TransNode( _Root1, _Root2 );
          TransNode( _Root2, _Root1 );
     end;
end;

procedure TForm1.SwapNodes( const N_:Integer );
var
   N :Integer;
begin
     for N := 1 to N_ do
     begin
          SwapSibliNodes( _Root1 );
          SwapSibliNodes( _Root2 );

          SwapOtherNodes( _Root1, _Root2 );
     end;
end;

procedure TForm1.DelNodes( const N_:Integer );
var
   N :Integer;
begin
     for N := 1 to N_ do DelNode( _Root1 );
     for N := 1 to N_ do DelNode( _Root2 );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _Root1 := TTreeNode.Create;
     _Root2 := TTreeNode.Create;

     _Root1.Name := 'Root1';
     _Root2.Name := 'Root2';

     ShowTrees;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Root1.Free;
     _Root2.Free;
end;

//------------------------------------------------------------------------------

procedure TForm1.FormResize(Sender: TObject);
begin
     TreeView1.Width := ( Width - (10+10+10+100+10) ) div 2;
end;

//------------------------------------------------------------------------------

procedure TForm1.Button1Click(Sender: TObject);
var
   N :Integer;
begin
     _Root1.DeleteChilds;
     _Root2.DeleteChilds;

     AddNodes( 100 );

     for N := 1 to 1000 do
     begin
          AddNodes( 10 );
          TransNodes( 10 );
          SwapNodes( 10 );
          DelNodes( 10 );
     end;

     ShowTrees;
end;

procedure TForm1.ButtonAClick(Sender: TObject);
begin
     AddNodes( 1 );

     ShowTrees;
end;

procedure TForm1.ButtonTClick(Sender: TObject);
begin
     TransNodes( 1 );

     ShowTrees;
end;

procedure TForm1.ButtonSClick(Sender: TObject);
begin
     SwapNodes( 1 );

     ShowTrees;
end;

procedure TForm1.ButtonDClick(Sender: TObject);
begin
     DelNodes( 1 );

     ShowTrees;
end;

end. //######################################################################### ■
