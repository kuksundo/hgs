object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 207
  ClientWidth = 307
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 81
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object Button1: TButton
    Left = 16
    Top = 35
    Width = 99
    Height = 25
    Caption = 'Set Intial Value'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button7: TButton
    Left = 16
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Trunc'
    TabOrder = 2
    OnClick = Button7Click
  end
  object GroupBox1: TGroupBox
    Left = 152
    Top = 8
    Width = 145
    Height = 182
    Caption = 'Perform'
    TabOrder = 3
    object Edit2: TEdit
      Left = 16
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object Button8: TButton
      Left = 16
      Top = 43
      Width = 99
      Height = 25
      Caption = 'Add'
      TabOrder = 1
      OnClick = Button8Click
    end
    object Button9: TButton
      Left = 16
      Top = 136
      Width = 99
      Height = 25
      Caption = 'Div'
      TabOrder = 2
      OnClick = Button9Click
    end
    object Button10: TButton
      Left = 16
      Top = 105
      Width = 99
      Height = 25
      Caption = 'Multiply'
      TabOrder = 3
      OnClick = Button10Click
    end
    object Button11: TButton
      Left = 16
      Top = 74
      Width = 99
      Height = 25
      Caption = 'Subtract'
      TabOrder = 4
      OnClick = Button11Click
    end
  end
  object Button2: TButton
    Left = 16
    Top = 82
    Width = 75
    Height = 25
    Caption = 'Double'
    TabOrder = 4
    OnClick = Button2Click
  end
end
