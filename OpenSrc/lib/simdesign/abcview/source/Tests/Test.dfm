object frmTest: TfrmTest
  Left = 511
  Top = 186
  Width = 621
  Height = 361
  Caption = 'frmTest'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblRoot: TLabel
    Left = 208
    Top = 8
    Width = 48
    Height = 13
    Caption = 'Unfiltered:'
  end
  object lblFilter: TLabel
    Left = 480
    Top = 8
    Width = 34
    Height = 13
    Caption = 'Filtered'
  end
  object lblProgress: TLabel
    Left = 16
    Top = 312
    Width = 51
    Height = 13
    Caption = 'lblProgress'
  end
  object lblInter: TLabel
    Left = 344
    Top = 8
    Width = 34
    Height = 13
    Caption = 'Filtered'
  end
  object btnCreate: TButton
    Left = 16
    Top = 8
    Width = 75
    Height = 25
    Caption = 'btnCreate'
    TabOrder = 0
    OnClick = btnCreateClick
  end
  object lbxRoot: TListBox
    Left = 208
    Top = 24
    Width = 121
    Height = 297
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 1
    OnClick = lbxRootClick
  end
  object lbxFilter: TListBox
    Left = 480
    Top = 24
    Width = 121
    Height = 297
    ItemHeight = 13
    TabOrder = 2
  end
  object btnDestroy: TButton
    Left = 16
    Top = 168
    Width = 75
    Height = 25
    Caption = 'btnDestroy'
    Enabled = False
    TabOrder = 3
    OnClick = btnDestroyClick
  end
  object btnRemove: TButton
    Left = 16
    Top = 72
    Width = 75
    Height = 25
    Caption = 'btnRemove'
    Enabled = False
    TabOrder = 4
    OnClick = btnRemoveClick
  end
  object btnAddFilter: TButton
    Left = 16
    Top = 208
    Width = 75
    Height = 25
    Caption = 'btnAddFilter'
    Enabled = False
    TabOrder = 5
    OnClick = btnAddFilterClick
  end
  object btnAdd: TButton
    Left = 16
    Top = 40
    Width = 75
    Height = 25
    Caption = 'btnAdd'
    TabOrder = 6
    OnClick = btnAddClick
  end
  object btnRestart: TButton
    Left = 16
    Top = 280
    Width = 75
    Height = 25
    Caption = 'btnRestart'
    TabOrder = 7
    OnClick = btnRestartClick
  end
  object btnUpdate: TButton
    Left = 16
    Top = 136
    Width = 75
    Height = 25
    Caption = 'btnUpdate'
    TabOrder = 8
    OnClick = btnUpdateClick
  end
  object cbThreaded: TCheckBox
    Left = 104
    Top = 8
    Width = 97
    Height = 17
    Caption = 'cbThreaded'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object btnClear: TButton
    Left = 16
    Top = 104
    Width = 75
    Height = 25
    Caption = 'btnClear'
    TabOrder = 10
    OnClick = btnClearClick
  end
  object lbxInter: TListBox
    Left = 344
    Top = 24
    Width = 121
    Height = 297
    ItemHeight = 13
    TabOrder = 11
  end
  object cbPaused: TCheckBox
    Left = 104
    Top = 40
    Width = 97
    Height = 17
    Caption = 'cbPaused'
    TabOrder = 12
    OnClick = cbPausedClick
  end
end
