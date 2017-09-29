object EmailInfoF: TEmailInfoF
  Left = 0
  Top = 0
  Caption = 'Email Info Edit'
  ClientHeight = 271
  ClientWidth = 477
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 249
    Height = 16
    Caption = 'Email'#51060' '#54252#54632#54616#44256' '#51080#45716' '#51221#48372#51032' '#51333#47448' :'
  end
  object Label2: TLabel
    Left = 92
    Top = 78
    Width = 165
    Height = 16
    Caption = 'Email'#51012' '#48372#45236#45716' '#44275' '#51648#51221' :'
  end
  object BitBtn1: TBitBtn
    Left = 120
    Top = 208
    Width = 81
    Height = 33
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 0
  end
  object BitBtn2: TBitBtn
    Left = 274
    Top = 208
    Width = 81
    Height = 33
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 1
  end
  object ContainDataCB: TComboBox
    Left = 263
    Top = 37
    Width = 204
    Height = 24
    Style = csDropDownList
    ImeName = 'Microsoft IME 2010'
    TabOrder = 2
    OnDropDown = ContainDataCBDropDown
  end
  object EmailDirectionCB: TComboBox
    Left = 263
    Top = 72
    Width = 204
    Height = 24
    Style = csDropDownList
    ImeName = 'Microsoft IME 2010'
    TabOrder = 3
    OnDropDown = EmailDirectionCBDropDown
  end
end
