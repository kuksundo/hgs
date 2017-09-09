object frMaskBase: TfrMaskBase
  Left = 0
  Top = 0
  Width = 270
  Height = 400
  TabOrder = 0
  object lbOperation: TLabel
    Left = 128
    Top = 34
    Width = 49
    Height = 13
    Caption = 'Operation:'
  end
  object pnlTitle: TPanel
    Left = 0
    Top = 0
    Width = 270
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    Color = clBtnShadow
    TabOrder = 0
    object lblTitle: TLabel
      Left = 8
      Top = 3
      Width = 57
      Height = 18
      Caption = 'lblTitle'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object chbFlipAlphaChannel: TCheckBox
    Left = 8
    Top = 32
    Width = 113
    Height = 17
    Caption = 'Flip Alpha Channel'
    TabOrder = 1
    OnClick = chbFlipAlphaChannelClick
  end
  object cbbOperation: TComboBox
    Left = 184
    Top = 32
    Width = 81
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    OnClick = cbbOperationClick
    Items.Strings = (
      'Multiply'
      'Add'
      'Substract'
      'Replace'
      'Max'
      'Min'
      'Difference'
      'Exclusion')
  end
end
