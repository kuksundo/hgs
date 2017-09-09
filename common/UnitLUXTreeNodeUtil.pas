unit UnitLUXTreeNodeUtil;

interface //#################################################################### ■

uses Vcl.ComCtrls, //FMX.Types, FMX.TreeView,
     LUX.Graph.Tree;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeNode

     TpjhTreeNode = class( TLUXTreeNode<TLUXTreeNode> )
     private
     protected
     public
       Name :String;
       /////
       constructor Create; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyMaterialSource

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

function RandString( const N_:Integer ) :String;

procedure ShowTree( const TreeView_:TTreeView; const Root_:TpjhTreeNode );

function RandNode( const Node_:TpjhTreeNode ) :TpjhTreeNode;
function RandKnot( const Node_:TpjhTreeNode ) :TpjhTreeNode;

function FindNode( const Node_:TpjhTreeNode ) :TpjhTreeNode;
function FindKnot( const Knot_:TpjhTreeNode ) :TpjhTreeNode;
function FindLeaf( const Node_:TpjhTreeNode ) :TpjhTreeNode;

procedure AddNode( const Root_:TpjhTreeNode );
procedure TransNode( const Root0_,Root1_:TpjhTreeNode );
procedure SwapSibliNodes( const Root_:TpjhTreeNode );
procedure SwapOtherNodes( const Root1_,Root2_:TpjhTreeNode );
procedure DelNode( const Root_:TpjhTreeNode );

implementation //############################################################### ■

uses System.SysUtils;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TpjhTreeNode

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TpjhTreeNode.Create;
begin
     inherited;

     Name := RandString( 8 );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

function RandString( const N_:Integer ) :String;
const
     Cs = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
   I :Integer;
begin
     Result := '';

     for I := 1 to N_ do Result := Result + Cs.Chars[ Random( 26 ) ];
end;

//------------------------------------------------------------------------------

procedure ShowTree( const TreeView_:TTreeView; const Root_:TpjhTreeNode );
var
  RootNode :TTreeNode;

//･･･････････････････････････････････････････････････････････････････････････
     procedure AddNode( const Parent_:TTreeNode; const TreeNode_:TpjhTreeNode );
     var
        I :Integer;
        P :TTreeNode;
        S :String;
        LP: TpjhTreeNode;
     begin
        with TreeNode_ do
        begin
           for I := 0 to ChildsN-1 do
           begin
              P := TreeView_.Items.AddChild( Parent_, TreeNode_.Name );
              P.Data := TreeNode_;
              AddNode( P, TpjhTreeNode(Childs[ I ]) );
           end;
        end;

//          TreeNode_.Paren := Parent_;

//          if Assigned( TreeNode_.Paren ) then S := TreeNode_.Order.ToString
//                                         else S := '-';

//          P.Text   := S + ' [' + TreeNode_.Name + '] ' + TreeNode_.ChildsN.ToString;

     end;
//･･･････････････････････････････････････････････････････････････････････････
begin
     TreeView_.Items.Clear;
     RootNode := TreeView_.Items.AddChild( nil, Root_.Name );
     AddNode( RootNode, Root_ );
     TreeView_.FullExpand;
end;

//------------------------------------------------------------------------------

function RandNode( const Node_:TpjhTreeNode ) :TpjhTreeNode;
begin
     Result := TpjhTreeNode(Node_.Childs[ Random(Node_.ChildsN)]);
end;

function RandKnot( const Node_:TpjhTreeNode ) :TpjhTreeNode;
var
   I, N :Integer;
   P :TpjhTreeNode;
   Ps :TArray<TpjhTreeNode>;
begin
     with Node_ do
     begin
          SetLength( Ps, ChildsN );

          N := 0;
          for I := 0 to ChildsN-1 do
          begin
               P := TpjhTreeNode(Childs[ I ]);

               if P.ChildsN > 0 then
               begin
                    Ps[ N ] := P;  Inc( N );
               end;
          end;
     end;

     if N = 0 then Result := nil
              else Result := Ps[ Random( N ) ];
end;

//------------------------------------------------------------------------------

function FindNode( const Node_:TpjhTreeNode ) :TpjhTreeNode;
begin
     Result := Node_;

     while ( Result.ChildsN > 0 )
       and ( Random( 4 )    > 0 ) do Result := RandNode( Result );
end;

function FindKnot( const Knot_:TpjhTreeNode ) :TpjhTreeNode;
var
   P :TpjhTreeNode;
begin
     Result := Knot_;

     while Random( 4 ) > 0 do
     begin
          P := RandKnot( Result );

          if not Assigned( P ) then Exit;

          Result := P;
     end;
end;

function FindLeaf( const Node_:TpjhTreeNode ) :TpjhTreeNode;
begin
     Result := Node_;

     while Result.ChildsN > 0 do Result := RandNode( Result );
end;

//------------------------------------------------------------------------------

procedure AddNode( const Root_:TpjhTreeNode );
var
   P :TpjhTreeNode;
begin
     P := FindNode( Root_ );

     case Random( 2 ) of
       0: TpjhTreeNode.Create.Paren := P;
       1: TpjhTreeNode.Create( P );
     end;
end;

procedure TransNode( const Root0_,Root1_:TpjhTreeNode );
var
   C, P :TpjhTreeNode;
begin
     if Root0_.ChildsN > 0 then
     begin
          C := FindLeaf( RandNode( Root0_ ) );
          P := FindNode( Root1_ );

          if P.ChildsN = 0 then
          begin
               case Random( 3 ) of
                 0: C.Paren := P;
                 1: P.InsertHead( C );
                 2: P.InsertTail( C );
               end;
          end
          else
          begin
               case Random( 9 ) of
                 0: C.Paren := P;
                 1: P.InsertHead( C );
                 2: P.InsertTail( C );
                 3: TpjhTreeNode( P.Head ).InsertPrev( C );                           {本来キャスト不要}
                 4: TpjhTreeNode( P.Head ).InsertNext( C );                           {本来キャスト不要}
                 5: TpjhTreeNode( P.Tail ).InsertPrev( C );                           {本来キャスト不要}
                 6: TpjhTreeNode( P.Tail ).InsertNext( C );                           {本来キャスト不要}
                 7: TpjhTreeNode( P.Childs[ Random( P.ChildsN ) ] ).InsertPrev( C );  {本来キャスト不要}
                 8: TpjhTreeNode( P.Childs[ Random( P.ChildsN ) ] ).InsertNext( C );  {本来キャスト不要}
               end;
          end;
     end;
end;

procedure SwapSibliNodes( const Root_:TpjhTreeNode );
var
   P, C1, C2 :TpjhTreeNode;
   I1, I2 :Integer;
begin
     if Root_.ChildsN > 0 then
     begin
          P := FindKnot( Root_ );

          if Assigned( P ) then
          begin
               C1 := RandNode( P );  I1 := C1.Order;
               C2 := RandNode( P );  I2 := C2.Order;

               case Random( 4 ) of
                 0: C1.Order := I2;
                 1: C2.Order := I1;
                 2: P.Swap( I1, I2 );
                 3: TpjhTreeNode.Swap( C1, C2 );
               end;
          end;
     end;
end;

procedure SwapOtherNodes( const Root1_,Root2_:TpjhTreeNode );
var
   C1, C2 :TpjhTreeNode;
begin
     if ( Root1_.ChildsN > 0 )
     or ( Root2_.ChildsN > 0 ) then
     begin
          C1 := FindLeaf( RandNode( Root1_ ) );
          C2 := FindLeaf( RandNode( Root2_ ) );

          TpjhTreeNode.Swap( C1, C2 );
     end;
end;

procedure DelNode( const Root_:TpjhTreeNode );
begin
     if Root_.ChildsN > 0 then FindLeaf( RandNode( Root_ ) ).Free;
end;

//############################################################################## □

initialization //######################################################## 初期化

finalization //########################################################## 最終化

end. //######################################################################### ■
