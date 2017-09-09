object dlgAnchors: TdlgAnchors
  Left = 289
  Top = 156
  BorderStyle = bsDialog
  Caption = 'Edit Anchors'
  ClientHeight = 309
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 56
    Top = 272
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 152
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 32
    Width = 265
    Height = 129
    Caption = 'Proportional position and size relative to parent'
    TabOrder = 2
    object chbPosXprop: TCheckBox
      Left = 16
      Top = 24
      Width = 240
      Height = 17
      Caption = 'Position in X proportional to parent'
      TabOrder = 0
      OnClick = BusinessRules
    end
    object chbPosYprop: TCheckBox
      Left = 16
      Top = 48
      Width = 240
      Height = 17
      Caption = 'Position in Y proportional to parent'
      TabOrder = 1
      OnClick = BusinessRules
    end
    object chbSizeXprop: TCheckBox
      Left = 16
      Top = 72
      Width = 240
      Height = 17
      Caption = 'Resize in X proportional to parent'
      TabOrder = 2
      OnClick = BusinessRules
    end
    object chbSizeYprop: TCheckBox
      Left = 16
      Top = 96
      Width = 240
      Height = 17
      Caption = 'Resize in Y proportional to parent'
      TabOrder = 3
      OnClick = BusinessRules
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 168
    Width = 265
    Height = 89
    Caption = 'Lock directly to parent edges'
    TabOrder = 3
    object chbTopLock: TCheckBox
      Left = 104
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Top'
      TabOrder = 0
      OnClick = BusinessRules
    end
    object chbLeftLock: TCheckBox
      Left = 16
      Top = 40
      Width = 97
      Height = 17
      Caption = 'Left'
      TabOrder = 1
      OnClick = BusinessRules
    end
    object chbRightLock: TCheckBox
      Left = 200
      Top = 40
      Width = 57
      Height = 17
      Caption = 'Right'
      TabOrder = 2
      OnClick = BusinessRules
    end
    object chbBottomLock: TCheckBox
      Left = 104
      Top = 64
      Width = 97
      Height = 17
      Caption = 'Bottom'
      TabOrder = 3
      OnClick = BusinessRules
    end
  end
  object chbOverrideDefault: TCheckBox
    Left = 24
    Top = 8
    Width = 241
    Height = 17
    Caption = 'Override default settings'
    TabOrder = 4
    OnClick = BusinessRules
  end
end
