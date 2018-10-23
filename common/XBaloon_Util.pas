unit XBaloon_Util;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,XBaloon;

  procedure DisplayXBaloon( Ctrl: TControl; Baloon:TXBaloon;X, Y: Integer;
                              Msg:string;FSize:Integer=10;FColor:TColor=clYellow;
                              CColor:TColor = ClNavy;FName:String='MS Sans Serif';
                              FStyle:TFontStyle=fsBold);

implementation

//XBaloon을 동적으로 생성하지 않고 등록된 컴포넌트를 이용할 경우
//다음 소스를 OnMouseDown Event에 삽입한다.
{  if Button = mbLeft then
   begin
    Point.X := X + Label4.Left;
    Point.Y := Y + Label4.Top;
    Point := ClientToScreen(Point);
    Baloon.Font.Name := Label4.Font.Name;
    Baloon.Font.Size := Label4.Font.Size;
    Baloon.Font.Style := Label4.Font.Style;
    Baloon.Color := Label4.Font.Color;
    Baloon.Shape := sRectangle;
    Baloon.Align := alLeft;
    Baloon.Show(Point, Label4.Caption);
    Baloon.Align := alRight;
   end;
}
//Hint를 보여주고 싶은 컨트롤의 MouseDown Event에서 이 함수를 호출한다.
//Parameter ::
//            Ctro : 마우스로 클릭한 컨트롤 핸들
//            Baloon : 동적으로 생성한 TXBaloon_DynaCreate_pjh
//            X,Y : 마우스의 X,Y 포인터
//            Msg : 디스플레이할 메세지
//            FSize : 폰트 사이즈
//            FColor : 폰트 색상
//            CColor : 배경 색상
//            FName : 폰트 이름
//            FStyle : 폰트 스타일=(fsBold, fsItalic, fsUnderline, fsStrikeOut);
//EX)   DisplayXBaloon( GradLabel1,
//                  XBaloon1,
//                  X,Y,
//                  GradLabel1.Caption,
//                  GradLabel1.Font.Size,
//                  GradLabel1.Font.Color,
//                 );
procedure DisplayXBaloon( Ctrl: TControl; Baloon:TXBaloon;X, Y: Integer;
                              Msg:string;FSize:Integer=10;FColor:TColor=clYellow;
                              CColor:TColor = ClNavy;FName:String='MS Sans Serif';
                              FStyle:TFontStyle=fsBold);
var Point: TPoint;
begin
  Point.X := X + Ctrl.Left;
  Point.Y := Y + Ctrl.Top;
  Point := Ctrl.Parent.ClientToScreen(Point);

  with Baloon do
  begin
    Font.Name := FName;
    Font.Size := FSize;
    Font.Style := TFontStyles(FStyle);
    //Font.Color := FColor;
    Color := CColor;
    //Shape := sRectangle;
    //Align := alLeft;
    //Show(Point, Msg);
    Show(Msg);
    //Align := alRight;
  end;//with
end;

end.
