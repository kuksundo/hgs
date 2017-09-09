object Form1: TForm1
  Left = 286
  Top = 106
  Width = 314
  Height = 522
  Caption = 'RegCode generator for product XXXX'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 32
    Width = 75
    Height = 13
    Caption = 'Start from code:'
  end
  object Label2: TLabel
    Left = 24
    Top = 80
    Width = 71
    Height = 13
    Caption = 'End with code:'
  end
  object Label3: TLabel
    Left = 24
    Top = 62
    Width = 249
    Height = 13
    Caption = 'Make sure this value is LESS than cMaxCodesUsed:'
  end
  object Label4: TLabel
    Left = 24
    Top = 192
    Width = 255
    Height = 13
    Caption = 'This list you can issue to the registration code provider'
  end
  object Label5: TLabel
    Left = 24
    Top = 14
    Width = 101
    Height = 13
    Caption = 'Last issued code + 1:'
  end
  object Label6: TLabel
    Left = 24
    Top = 112
    Width = 104
    Height = 13
    Caption = 'Separator char (if any)'
  end
  object Label7: TLabel
    Left = 24
    Top = 432
    Width = 24
    Height = 13
    Caption = 'Test!'
  end
  object Label8: TLabel
    Left = 24
    Top = 456
    Width = 49
    Height = 13
    Caption = 'Not tested'
  end
  object Button1: TButton
    Left = 24
    Top = 160
    Width = 217
    Height = 25
    Caption = 'Generate codes!'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 104
    Top = 28
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '0'
  end
  object Edit2: TEdit
    Left = 104
    Top = 76
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '99'
  end
  object Memo1: TMemo
    Left = 24
    Top = 208
    Width = 257
    Height = 209
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 3
    WordWrap = False
  end
  object DecCheck: TCheckBox
    Left = 24
    Top = 136
    Width = 97
    Height = 17
    Caption = 'Use Decryption'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object Edit3: TEdit
    Left = 168
    Top = 108
    Width = 57
    Height = 21
    TabOrder = 5
    Text = '-'
  end
  object Edit4: TEdit
    Left = 56
    Top = 428
    Width = 145
    Height = 21
    TabOrder = 6
  end
  object BitBtn1: TBitBtn
    Left = 216
    Top = 466
    Width = 75
    Height = 25
    Caption = 'Dialog'
    TabOrder = 7
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 216
    Top = 430
    Width = 75
    Height = 25
    Caption = 'Q and D'
    TabOrder = 8
    OnClick = BitBtn2Click
    Kind = bkOK
  end
end
