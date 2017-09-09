object fmAddPageWiz: TfmAddPageWiz
  Left = 373
  Top = 243
  BorderStyle = bsDialog
  Caption = 'Add multiple images to document'
  ClientHeight = 333
  ClientWidth = 299
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
  object lbStats: TLabel
    Left = 8
    Top = 256
    Width = 32
    Height = 13
    Caption = 'lbStats'
  end
  object Label1: TLabel
    Left = 24
    Top = 224
    Width = 140
    Height = 13
    Caption = 'Margin between images [mm]:'
  end
  object rgPerPage: TRadioGroup
    Left = 8
    Top = 8
    Width = 281
    Height = 105
    Caption = 'How many images per page?'
    ItemIndex = 1
    Items.Strings = (
      '1 per page'
      '2 per page'
      '4 per page'
      '8 per page')
    TabOrder = 0
    OnClick = rgPerPageClick
  end
  object chbAddShadow: TCheckBox
    Left = 8
    Top = 176
    Width = 185
    Height = 17
    Caption = 'Add Shadow'
    TabOrder = 1
  end
  object chbAddRandom: TCheckBox
    Left = 8
    Top = 200
    Width = 185
    Height = 17
    Caption = 'Add random rotation'
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 56
    Top = 288
    Width = 75
    Height = 25
    Caption = 'OK, Add'
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 160
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object chbStartNewPage: TCheckBox
    Left = 8
    Top = 128
    Width = 185
    Height = 17
    Caption = 'Start with new page'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object chbAutoCorrect: TCheckBox
    Left = 8
    Top = 152
    Width = 185
    Height = 17
    Caption = 'Auto-correct orientation'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object edMargin: TEdit
    Left = 176
    Top = 220
    Width = 73
    Height = 21
    TabOrder = 7
    Text = '4'
  end
end
