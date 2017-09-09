object Form1: TForm1
  Left = 302
  Top = 107
  Width = 587
  Height = 540
  Caption = 'Test program for Douglas-Peucker Algorithm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    579
    506)
  PixelsPerInch = 96
  TextHeight = 13
  object pbMain: TPaintBox
    Left = 8
    Top = 120
    Width = 561
    Height = 385
    Anchors = [akLeft, akTop, akRight, akBottom]
    OnMouseDown = pbMainMouseDown
    OnMouseMove = pbMainMouseMove
    OnMouseUp = pbMainMouseUp
    OnPaint = pbMainPaint
  end
  object Label5: TLabel
    Left = 32
    Top = 104
    Width = 482
    Height = 13
    Caption = 
      'Draw a freeform here by holding the left mousebutton down, drawi' +
      'ng a shape and releasing the button:'
  end
  object Label6: TLabel
    Left = 352
    Top = 16
    Width = 126
    Height = 13
    Caption = 'Number of points originally:'
  end
  object lbNumPtsOrig: TLabel
    Left = 352
    Top = 32
    Width = 64
    Height = 13
    Caption = 'lbNumPtsOrig'
  end
  object Label7: TLabel
    Left = 352
    Top = 56
    Width = 181
    Height = 13
    Caption = 'Number of points for simplified polyline:'
  end
  object lbNumPtsSimple: TLabel
    Left = 352
    Top = 72
    Width = 76
    Height = 13
    Caption = 'lbNumPtsSimple'
  end
  object GroupBox1: TGroupBox
    Left = 32
    Top = 8
    Width = 305
    Height = 89
    Caption = 'Tolerances'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 46
      Height = 13
      Caption = 'Precision:'
    end
    object Label2: TLabel
      Left = 160
      Top = 24
      Width = 27
      Height = 13
      Caption = 'Pixels'
    end
    object Label8: TLabel
      Left = 16
      Top = 56
      Width = 53
      Height = 13
      Caption = 'Pen Width:'
    end
    object Label9: TLabel
      Left = 160
      Top = 56
      Width = 27
      Height = 13
      Caption = 'Pixels'
    end
    object sePrecision: TRxSpinEdit
      Left = 96
      Top = 24
      Width = 57
      Height = 21
      Decimal = 1
      Increment = 0.100000000000000000
      MaxValue = 20.000000000000000000
      MinValue = 0.100000000000000000
      ValueType = vtFloat
      Value = 5.000000000000000000
      TabOrder = 0
      OnChange = sePrecisionChange
    end
    object sePenWidth: TRxSpinEdit
      Left = 96
      Top = 56
      Width = 57
      Height = 21
      MaxValue = 10.000000000000000000
      MinValue = 1.000000000000000000
      Value = 5.000000000000000000
      MaxLength = 50
      TabOrder = 1
      OnChange = sePenWidthChange
    end
  end
end
