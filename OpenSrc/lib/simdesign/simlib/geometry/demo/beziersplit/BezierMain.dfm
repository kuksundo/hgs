object Form1: TForm1
  Left = 277
  Top = 105
  Width = 665
  Height = 502
  Caption = 'Recursive Divide Polybezier'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    657
    468)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 657
    Height = 25
    Align = alTop
    AutoSize = False
    Caption = 
      'This demo shows how split a Bezier curve at the point closest to' +
      ' the mouse'
    WordWrap = True
  end
  object pbMain: TPaintBox
    Left = 8
    Top = 95
    Width = 641
    Height = 354
    Anchors = [akLeft, akTop, akRight, akBottom]
    OnMouseMove = pbMainMouseMove
  end
  object lbSteps: TLabel
    Left = 304
    Top = 40
    Width = 30
    Height = 13
    Caption = 'Steps:'
  end
  object Label4: TLabel
    Left = 8
    Top = 452
    Width = 320
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Copyright '#169' 2005-2007 by N.Haeck (Simdesign) - www.simdesign.nl'
  end
  object lbDist: TLabel
    Left = 440
    Top = 40
    Width = 45
    Height = 13
    Caption = 'Distance:'
  end
  object Label2: TLabel
    Left = 216
    Top = 24
    Width = 73
    Height = 13
    Caption = 'Tolerance (pix):'
  end
  object btnDrawRandomBezier: TButton
    Left = 8
    Top = 64
    Width = 121
    Height = 25
    Caption = 'Draw Random Bezier'
    TabOrder = 0
    OnClick = btnDrawRandomBezierClick
  end
  object chbFollowMouse: TCheckBox
    Left = 8
    Top = 40
    Width = 97
    Height = 17
    Caption = 'Follow Mouse'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 216
    Top = 40
    Width = 49
    Height = 21
    TabOrder = 2
    Text = '1'
  end
  object udTolerance: TUpDown
    Left = 265
    Top = 40
    Width = 15
    Height = 21
    Associate = Edit1
    Min = 1
    Position = 1
    TabOrder = 3
  end
  object chbControlPoints: TCheckBox
    Left = 112
    Top = 40
    Width = 89
    Height = 17
    Caption = 'Control Points'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
end
