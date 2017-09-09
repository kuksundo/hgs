object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 301
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  DesignSize = (
    467
    301)
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 8
    Top = 32
    Width = 451
    Height = 261
    Anchors = [akLeft, akTop, akRight, akBottom]
    Brush.Color = clRed
    Pen.Style = psClear
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 9
    Width = 97
    Height = 17
    Caption = '&Maximized'
    TabOrder = 0
    OnClick = CheckBox1Click
  end
  object CheckBox2: TCheckBox
    Left = 111
    Top = 9
    Width = 97
    Height = 17
    Caption = '&Borderless'
    TabOrder = 1
    OnClick = CheckBox2Click
  end
end
