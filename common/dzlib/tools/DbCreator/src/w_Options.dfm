object f_Options: Tf_Options
  Left = 362
  Top = 168
  Caption = 'f_Options'
  ClientHeight = 374
  ClientWidth = 279
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
    Left = 0
    Top = 4
    Width = 26
    Height = 13
    Caption = 'Prefix'
  end
  object ed_Prefix: TEdit
    Left = 64
    Top = 0
    Width = 201
    Height = 21
    TabOrder = 0
  end
  object grp_Checksum: TGroupBox
    Left = 0
    Top = 24
    Width = 273
    Height = 49
    Caption = 'Checksum options'
    TabOrder = 1
    object Label2: TLabel
      Left = 136
      Top = 160
      Width = 32
      Height = 13
      Caption = 'Label2'
    end
    object chk_AddChecksum: TCheckBox
      Left = 8
      Top = 16
      Width = 129
      Height = 17
      Caption = 'add chksum field'
      TabOrder = 0
      OnClick = chk_AddChecksumClick
    end
    object chk_RemoveChksum: TCheckBox
      Left = 136
      Top = 16
      Width = 129
      Height = 17
      Caption = 'remove chksum field'
      TabOrder = 1
      OnClick = chk_RemoveChksumClick
    end
  end
  object grp_GraphViz: TGroupBox
    Left = 0
    Top = 88
    Width = 273
    Height = 81
    Caption = 'GraphViz options'
    TabOrder = 2
    object chk_ReferencedColumnsOnly: TCheckBox
      Left = 8
      Top = 48
      Width = 257
      Height = 17
      Caption = 'include only referenced fields'
      TabOrder = 0
    end
    object chk_ReferencedTablesOnly: TCheckBox
      Left = 8
      Top = 24
      Width = 257
      Height = 17
      Caption = 'include only referenced tables'
      TabOrder = 1
    end
  end
  object grp_HtmlOptions: TGroupBox
    Left = 0
    Top = 256
    Width = 273
    Height = 105
    Caption = 'HTML Options'
    TabOrder = 3
    object l_HeadingStartlevel: TLabel
      Left = 8
      Top = 24
      Width = 111
      Height = 13
      Caption = 'Heading Startlevel (1-6)'
    end
    object sed_HeadingStartLevel: TJvSpinEdit
      Left = 8
      Top = 40
      Width = 121
      Height = 21
      MaxValue = 6.000000000000000000
      MinValue = 1.000000000000000000
      Value = 1.000000000000000000
      TabOrder = 0
    end
  end
  object rg_AccessOptions: TRadioGroup
    Left = 0
    Top = 184
    Width = 273
    Height = 57
    Caption = 'MS Access Options'
    Columns = 2
    ItemIndex = 1
    Items.Strings = (
      'Access 97'
      'Access 2000')
    TabOrder = 4
  end
  object TheFormStorage: TJvFormStorage
    AppStoragePath = 'f_Options\'
    Options = []
    StoredProps.Strings = (
      'ed_Prefix.Text'
      'chk_AddChecksum.Checked'
      'chk_RemoveChksum.Checked'
      'rg_AccessOptions.ItemIndex')
    StoredValues = <>
    Left = 200
    Top = 72
  end
end
