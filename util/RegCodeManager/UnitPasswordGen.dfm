object PasswordGenF: TPasswordGenF
  Left = 1097
  Top = 66
  Caption = 'Password generator'
  ClientHeight = 291
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblLength: TLabel
    Left = 16
    Top = 21
    Width = 96
    Height = 13
    Caption = 'Set password length'
  end
  object lblHowMany: TLabel
    Left = 280
    Top = 128
    Width = 56
    Height = 13
    Caption = 'How many?'
  end
  object lblCount: TLabel
    Left = 368
    Top = 216
    Width = 6
    Height = 13
    Alignment = taRightJustify
    Caption = '0'
  end
  object edtPassword: TEdit
    Left = 16
    Top = 183
    Width = 361
    Height = 28
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ImeName = 'Microsoft IME 2010'
    ParentFont = False
    TabOrder = 0
  end
  object btnPwdGen: TButton
    Left = 8
    Top = 246
    Width = 119
    Height = 25
    Action = actGenPwd
    TabOrder = 1
  end
  object btnReset: TButton
    Left = 266
    Top = 246
    Width = 119
    Height = 25
    Action = actCancel
    TabOrder = 2
  end
  object edtLength: TEdit
    Left = 128
    Top = 17
    Width = 33
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 3
    Text = '17'
  end
  object udLength: TUpDown
    Left = 161
    Top = 17
    Width = 16
    Height = 21
    Associate = edtLength
    Min = 8
    Position = 17
    TabOrder = 4
  end
  object cbxSep: TCheckBox
    Left = 16
    Top = 127
    Width = 113
    Height = 17
    Caption = 'Insert separator'
    TabOrder = 5
  end
  object rbtDash: TRadioButton
    Left = 152
    Top = 127
    Width = 113
    Height = 17
    Caption = 'Dash'
    Checked = True
    TabOrder = 6
    TabStop = True
  end
  object rbtUnderscore: TRadioButton
    Left = 152
    Top = 151
    Width = 113
    Height = 17
    Caption = 'Underscore'
    TabOrder = 7
  end
  object rbgPwdType: TRadioGroup
    Left = 16
    Top = 56
    Width = 361
    Height = 49
    Caption = 'Password type'
    Columns = 3
    ItemIndex = 2
    Items.Strings = (
      'Only letters'
      'Only numbers'
      'Both')
    TabOrder = 8
  end
  object edtSepNum: TEdit
    Left = 333
    Top = 123
    Width = 25
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 9
    Text = '1'
  end
  object udbSepNum: TUpDown
    Left = 358
    Top = 123
    Width = 16
    Height = 21
    Associate = edtSepNum
    Min = 1
    Max = 4
    Position = 1
    TabOrder = 10
  end
  object Button1: TButton
    Left = 136
    Top = 248
    Width = 105
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 11
    OnClick = Button1Click
  end
  object actmgr1: TActionManager
    Left = 352
    Top = 8
    StyleName = 'XP Style'
    object actGenPwd: TAction
      Caption = 'Generate pasword'
      OnExecute = actGenPwdExecute
      OnUpdate = actGenPwdUpdate
    end
    object actCancel: TAction
      Caption = 'Cancel'
      OnExecute = actCancelExecute
    end
  end
end
