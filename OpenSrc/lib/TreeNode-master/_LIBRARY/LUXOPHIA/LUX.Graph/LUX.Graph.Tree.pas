unit LUX.Graph.Tree;

interface //#################################################################### ■

uses LUX, LUX.Graph;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     TLUXTreeItem                          = class;
     TLUXTreeNode                          = class;
     TLUXTreeNode<_TParen_,_TChild_:class> = class;
     TLUXTreeNode<_TNode_:class>           = class;
     TLUXTreeRoot<_TChild_:class>          = class;
     TLUXTreeLeaf<_TParen_:class>          = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLUXTreeNodeZero

     TLUXTreeItem = class( TNode )
     private
     protected
       _Prev :TLUXTreeNode;
       _Next :TLUXTreeNode;
     public
       constructor Create;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLUXTreeNode

     TLUXTreeNode = class( TLUXTreeItem )
     private
       ///// アクセス
       function GetZero :TLUXTreeNode;
       procedure SetZero( const Zero_:TLUXTreeNode );
       function GetIsOrdered :Boolean;
       ///// メソッド
       class procedure Bind( const C0_,C1_:TLUXTreeNode ); overload; inline;
       class procedure Bind( const C0_,C1_,C2_:TLUXTreeNode ); overload; inline;
       class procedure Bind( const C0_,C1_,C2_,C3_:TLUXTreeNode ); overload; inline;
     protected
       _Paren    :TLUXTreeNode;
       _Order    :Integer;
       _Childs   :TMarginArray<TLUXTreeNode>;
       _ChildsN  :Integer;
       _MaxOrder :Integer;
       ///// アクセス
       function GetParen :TLUXTreeNode;
       procedure SetParen( const Paren_:TLUXTreeNode );
       function GetOrder :Integer;
       procedure SetOrder( const Order_:Integer );
       function GetHead :TLUXTreeNode;
       function GetTail :TLUXTreeNode;
       function GetChilds( const I_:Integer ) :TLUXTreeNode;
       procedure SetChilds( const I_:Integer; const Child_:TLUXTreeNode );
       ///// プロパティ
       property Zero      :TLUXTreeNode read GetZero      write SetZero;
       property IsOrdered :Boolean   read GetIsOrdered              ;
       ///// メソッド
       procedure FindTo( const Child_:TLUXTreeNode ); overload;
       procedure FindTo( const Order_:Integer   ); overload;
       procedure _Insert( const C0_,C1_,C2_:TLUXTreeNode );
       procedure _Remove;
       procedure _InsertHead( const Child_:TLUXTreeNode );
       procedure _InsertTail( const Child_:TLUXTreeNode );
       procedure _InsertPrev( const Sibli_:TLUXTreeNode );
       procedure _InsertNext( const Sibli_:TLUXTreeNode );
     public
       constructor Create; overload; virtual;
       constructor Create( const Paren_:TLUXTreeNode ); overload; virtual;
       procedure BeforeDestruction; override;
       destructor Destroy; override;
       ///// プロパティ
       property Paren                      :TLUXTreeNode read GetParen   write SetParen ;
       property Order                      :Integer   read GetOrder   write SetOrder ;
       property Head                       :TLUXTreeNode read GetHead                   ;
       property Tail                       :TLUXTreeNode read GetTail                   ;
       property Childs[ const I_:Integer ] :TLUXTreeNode read GetChilds  write SetChilds; default;
       property ChildsN                    :Integer   read   _ChildsN                ;
       ///// メソッド
       procedure Remove;
       class procedure RemoveChild( const Child_:TLUXTreeNode );
       procedure DeleteChilds; virtual;
       procedure InsertHead( const Child_:TLUXTreeNode );
       procedure InsertTail( const Child_:TLUXTreeNode );
       procedure InsertPrev( const Sibli_:TLUXTreeNode );
       procedure InsertNext( const Sibli_:TLUXTreeNode );
       class procedure Swap( const C1_,C2_:TLUXTreeNode ); overload;
       procedure Swap( const I1_,I2_:Integer ); overload;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLUXTreeNode<_TParen_,_TChild_>

     TLUXTreeNode<_TParen_,_TChild_:class> = class( TLUXTreeNode )
     private
     protected
       ///// アクセス
       function GetParen :_TParen_; reintroduce;
       procedure SetParen( const Paren_:_TParen_ ); reintroduce;
       function GetHead :_TChild_; reintroduce;
       function GetTail :_TChild_; reintroduce;
       function GetChilds( const I_:Integer ) :_TChild_; reintroduce;
       procedure SetChilds( const I_:Integer; const Child_:_TChild_ ); reintroduce;
     public
       ///// プロパティ
       property Paren                      :_TParen_ read GetParen  write SetParen ;
       property Head                       :_TChild_ read GetHead                  ;
       property Tail                       :_TChild_ read GetTail                  ;
       property Childs[ const I_:Integer ] :_TChild_ read GetChilds write SetChilds; default;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLUXTreeNode<_TNode_>

     TLUXTreeNode<_TNode_:class> = class( TLUXTreeNode<_TNode_,_TNode_> )
     private
     protected
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLUXTreeRoot<_TChild_>

     TLUXTreeRoot<_TChild_:class> = class( TLUXTreeNode<_TChild_> )
     private
     protected
       ///// プロパティ
       property Paren;
     public
       ///// プロパティ
       property Head  ;
       property Tail  ;
       property Childs;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLUXTreeLeaf<_TParen_>

     TLUXTreeLeaf<_TParen_:class> = class( TLUXTreeNode<_TParen_> )
     private
     protected
       ///// プロパティ
       property Head  ;
       property Tail  ;
       property Childs;
     public
       ///// プロパティ
       property Paren;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLUXTreeItem

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TLUXTreeItem.Create;
begin
     inherited;

     _Prev := TLUXTreeNode( Self );
     _Next := TLUXTreeNode( Self );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLUXTreeNode

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TLUXTreeNode.GetZero :TLUXTreeNode;
begin
     Result := _Childs[ -1 ];
end;

procedure TLUXTreeNode.SetZero( const Zero_:TLUXTreeNode );
begin
     _Childs[ -1 ] := Zero_;
end;

//------------------------------------------------------------------------------

function TLUXTreeNode.GetIsOrdered :Boolean;
begin
     Result := ( _Order <= _Paren._MaxOrder )
           and ( _Paren._Childs[ _Order ] = Self );
end;

/////////////////////////////////////////////////////////////////////// メソッド

class procedure TLUXTreeNode.Bind( const C0_,C1_:TLUXTreeNode );
begin
     C0_._Next := C1_;
     C1_._Prev := C0_;
end;

class procedure TLUXTreeNode.Bind( const C0_,C1_,C2_:TLUXTreeNode );
begin
     Bind( C0_, C1_ );
     Bind( C1_, C2_ );
end;

class procedure TLUXTreeNode.Bind( const C0_,C1_,C2_,C3_:TLUXTreeNode );
begin
     Bind( C0_, C1_ );
     Bind( C1_, C2_ );
     Bind( C2_, C3_ );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TLUXTreeNode.GetParen :TLUXTreeNode;
begin
     Result := _Paren;
end;

procedure TLUXTreeNode.SetParen( const Paren_:TLUXTreeNode );
begin
     Remove;

     if Assigned( Paren_ ) then Paren_._InsertTail( Self );
end;

//------------------------------------------------------------------------------

function TLUXTreeNode.GetOrder :Integer;
begin
     if not IsOrdered then _Paren.FindTo( Self );

     Result := _Order;
end;

procedure TLUXTreeNode.SetOrder( const Order_:Integer );
begin
     Swap( Self, _Paren.Childs[ Order_ ] );
end;

//------------------------------------------------------------------------------

function TLUXTreeNode.GetHead :TLUXTreeNode;
begin
     Result := Zero._Next;
end;

function TLUXTreeNode.GetTail :TLUXTreeNode;
begin
     Result := Zero._Prev;
end;

//------------------------------------------------------------------------------

function TLUXTreeNode.GetChilds( const I_:Integer ) :TLUXTreeNode;
begin
     if I_ > _MaxOrder then FindTo( I_ );

     Result := _Childs[ I_ ];
end;

procedure TLUXTreeNode.SetChilds( const I_:Integer; const Child_:TLUXTreeNode );
var
   S :TLUXTreeNode;
begin
     with Childs[ I_ ] do
     begin
          S := Childs[ I_ ]._Prev;

          Remove;
     end;

     S.InsertNext( Child_ );
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TLUXTreeNode.FindTo( const Child_:TLUXTreeNode );
var
   P :TLUXTreeNode;
begin
     if _ChildsN > _Childs.Count then _Childs.Count := _ChildsN;

     P := _Childs[ _MaxOrder ];

     repeat
           P := P._Next;

           Inc( _MaxOrder );

           _Childs[ _MaxOrder ] := P;  P._Order := _MaxOrder;

     until P = Child_;
end;

procedure TLUXTreeNode.FindTo( const Order_:Integer );
var
   P :TLUXTreeNode;
   I :Integer;
begin
     if _ChildsN > _Childs.Count then _Childs.Count := _ChildsN;

     P := _Childs[ _MaxOrder ];

     for I := _MaxOrder + 1 to Order_ do
     begin
           P := P._Next;

           _Childs[ I ] := P;  P._Order := I;
     end;

     _MaxOrder := Order_;
end;

//------------------------------------------------------------------------------

procedure TLUXTreeNode._Insert( const C0_,C1_,C2_:TLUXTreeNode );
begin
     C1_._Paren := Self;

     Bind( C0_, C1_, C2_ );

     Inc( _ChildsN );
end;

procedure TLUXTreeNode._Remove;
begin
     Bind( _Prev, _Next );

     if IsOrdered then _Paren._MaxOrder := _Order - 1;

     with _Paren do
     begin
          Dec( _ChildsN );

          if _ChildsN * 2 < _Childs.Count then _Childs.Count := _ChildsN;
     end;

     _Paren := nil;  _Order := -1;
end;

//------------------------------------------------------------------------------

procedure TLUXTreeNode._InsertHead( const Child_:TLUXTreeNode );
begin
     _Insert( Zero, Child_, Head );

     _MaxOrder := -1;  { if Head.IsOrdered then _MaxOrder := Head._Order - 1; }
end;

procedure TLUXTreeNode._InsertTail( const Child_:TLUXTreeNode );
begin
     _Insert( Tail, Child_, Zero );

     { if Tail.IsOrdered then _MaxOrder := Tail._Order; }
end;

procedure TLUXTreeNode._InsertPrev( const Sibli_:TLUXTreeNode );
begin
     _Paren._Insert( _Prev, Sibli_, Self );

     if IsOrdered then _Paren._MaxOrder := _Order - 1;
end;

procedure TLUXTreeNode._InsertNext( const Sibli_:TLUXTreeNode );
begin
     _Paren._Insert( Self, Sibli_, _Next );

     if IsOrdered then _Paren._MaxOrder := _Order;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TLUXTreeNode.Create;
begin
     inherited;

     _Paren := nil;  _Order := -1;

     _ChildsN := 0;

     _Childs := TMarginArray<TLUXTreeNode>.Create( 1, _ChildsN, 0 );

     Zero := TLUXTreeNode( TLUXTreeItem.Create );

     _MaxOrder := -1;
end;

constructor TLUXTreeNode.Create( const Paren_:TLUXTreeNode );
begin
     Create;

     Paren_._InsertTail( Self );
end;

procedure TLUXTreeNode.BeforeDestruction;
begin
     Remove;

     DeleteChilds;
end;

destructor TLUXTreeNode.Destroy;
begin
     Zero.Free;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TLUXTreeNode.Remove;
begin
     if Assigned( _Paren ) then _Remove;
end;

class procedure TLUXTreeNode.RemoveChild( const Child_:TLUXTreeNode );
begin
     Child_.Remove;
end;

//------------------------------------------------------------------------------

procedure TLUXTreeNode.DeleteChilds;
var
   N :Integer;
begin
     for N := 1 to _ChildsN do Tail.Free;
end;

//------------------------------------------------------------------------------

procedure TLUXTreeNode.InsertHead( const Child_:TLUXTreeNode );
begin
     Child_.Remove;  _InsertHead( Child_ );
end;

procedure TLUXTreeNode.InsertTail( const Child_:TLUXTreeNode );
begin
     Child_.Remove;  _InsertTail( Child_ );
end;

procedure TLUXTreeNode.InsertPrev( const Sibli_:TLUXTreeNode );
begin
     Sibli_.Remove;  _InsertPrev( Sibli_ );
end;

procedure TLUXTreeNode.InsertNext( const Sibli_:TLUXTreeNode );
begin
     Sibli_.Remove;  _InsertNext( Sibli_ );
end;

//------------------------------------------------------------------------------

class procedure TLUXTreeNode.Swap( const C1_,C2_:TLUXTreeNode );
var
   P1, P2,
   C1n, C1u,
   C2n, C2u :TLUXTreeNode;
   B1, B2 :Boolean;
   I1, I2 :Integer;
begin
     with C1_ do
     begin
          P1 := _Paren    ;
          B1 :=  IsOrdered;
          I1 := _Order    ;

          C1n := _Prev;
          C1u := _Next;
     end;

     with C2_ do
     begin
          P2 := _Paren    ;
          B2 :=  IsOrdered;
          I2 := _Order    ;

          C2n := _Prev;
          C2u := _Next;
     end;

     C1_._Paren := P2;
     C2_._Paren := P1;

     if C1_ = C2n then Bind( C1n, C2_, C1_, C2u )
     else
     if C1_ = C2u then Bind( C2n, C1_, C2_, C1u )
     else
     begin
          Bind( C1n, C2_, C1u );
          Bind( C2n, C1_, C2u );
     end;

     if B1 then
     begin
          P1._Childs[ I1 ] := C2_;  C2_._Order := I1;
     end;

     if B2 then
     begin
          P2._Childs[ I2 ] := C1_;  C1_._Order := I2;
     end;
end;

procedure TLUXTreeNode.Swap( const I1_,I2_:Integer );
begin
     Swap( Childs[ I1_ ], Childs[ I2_ ] );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLUXTreeNode<_TParen_,_TChild_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TLUXTreeNode<_TParen_,_TChild_>.GetParen :_TParen_;
begin
     Result := _TParen_( inherited GetParen );
end;

procedure TLUXTreeNode<_TParen_,_TChild_>.SetParen( const Paren_:_TParen_ );
begin
     inherited SetParen( TLUXTreeNode( Paren_ ) );
end;

//------------------------------------------------------------------------------

function TLUXTreeNode<_TParen_,_TChild_>.GetHead :_TChild_;
begin
     Result := _TChild_( inherited GetHead );
end;

function TLUXTreeNode<_TParen_,_TChild_>.GetTail :_TChild_;
begin
     Result := _TChild_( inherited GetTail );
end;

//------------------------------------------------------------------------------

function TLUXTreeNode<_TParen_,_TChild_>.GetChilds( const I_:Integer ) :_TChild_;
begin
     Result := _TChild_( inherited GetChilds( I_ ) );
end;

procedure TLUXTreeNode<_TParen_,_TChild_>.SetChilds( const I_:Integer; const Child_:_TChild_ );
begin
     inherited SetChilds( I_, TLUXTreeNode( Child_ ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLUXTreeNode<_TNode_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLUXTreeRoot<_TChild_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLUXTreeLeaf<_TParen_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
