object frmSelectType: TfrmSelectType
  Left = 274
  Top = 175
  Width = 367
  Height = 197
  Caption = 'Select Form Type'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 16
    Width = 255
    Height = 13
    Caption = 'Yoy may select from one of the following types of Form'
  end
  object RadioGroup1: TRadioGroup
    Left = 32
    Top = 40
    Width = 289
    Height = 73
    Items.Strings = (
      'Logic Design Panel'
      'Custom Form')
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 112
    Top = 128
    Width = 97
    Height = 33
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 224
    Top = 128
    Width = 97
    Height = 33
    TabOrder = 2
    Kind = bkCancel
  end
end
