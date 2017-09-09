object AutoUpdateConfigF: TAutoUpdateConfigF
  Left = 0
  Top = 0
  Caption = 'AutoUpdateConfigF'
  ClientHeight = 183
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 32
    Width = 66
    Height = 13
    Caption = 'Update Type:'
  end
  object Label2: TLabel
    Left = 48
    Top = 64
    Width = 59
    Height = 13
    Caption = 'Inf File URL:'
  end
  object Label3: TLabel
    Left = 48
    Top = 96
    Width = 70
    Height = 13
    Caption = 'Log File Name:'
  end
  object UpdateTypeCombo: TComboBox
    Left = 120
    Top = 29
    Width = 145
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 0
    Text = 'httpUpdate'
    OnSelect = UpdateTypeComboSelect
    Items.Strings = (
      'fileUpdate'
      'ftpUpdate'
      'httpUpdate')
  end
  object URLEdit: TEdit
    Left = 120
    Top = 61
    Width = 377
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 1
  end
  object JvFilenameEdit1: TJvFilenameEdit
    Left = 120
    Top = 93
    Width = 377
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 2
    Text = ''
  end
  object Panel1: TPanel
    Left = 0
    Top = 142
    Width = 520
    Height = 41
    Align = alBottom
    TabOrder = 3
    ExplicitTop = 232
    object BitBtn1: TBitBtn
      Left = 136
      Top = 8
      Width = 75
      Height = 25
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 344
      Top = 8
      Width = 75
      Height = 25
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
    end
  end
end
