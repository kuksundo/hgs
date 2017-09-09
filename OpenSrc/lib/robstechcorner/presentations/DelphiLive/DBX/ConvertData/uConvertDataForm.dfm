object frmBDEToDBX: TfrmBDEToDBX
  Left = 0
  Top = 0
  Caption = 'BDE to DBX Data Converter'
  ClientHeight = 360
  ClientWidth = 486
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 80
    Height = 13
    Caption = 'Source BDE Alias'
  end
  object Label2: TLabel
    Left = 24
    Top = 65
    Width = 79
    Height = 13
    Caption = 'Tables to Import'
  end
  object Label3: TLabel
    Left = 182
    Top = 0
    Width = 156
    Height = 13
    Caption = 'Destination DBX Connection Info'
  end
  object Label4: TLabel
    Left = 182
    Top = 57
    Width = 84
    Height = 13
    Caption = 'Connection Name'
  end
  object Label5: TLabel
    Left = 182
    Top = 19
    Width = 59
    Height = 13
    Caption = 'Driver Name'
  end
  object Label6: TLabel
    Left = 182
    Top = 136
    Width = 88
    Height = 13
    Caption = 'Conversion Status'
  end
  object cbxAlias: TComboBox
    Left = 24
    Top = 32
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    OnChange = cbxAliasChange
  end
  object clbTables: TCheckListBox
    Left = 24
    Top = 88
    Width = 145
    Height = 258
    ItemHeight = 13
    PopupMenu = mnuTables
    TabOrder = 1
  end
  object cbxConnName: TComboBox
    Left = 182
    Top = 78
    Width = 289
    Height = 21
    ItemHeight = 13
    TabOrder = 2
  end
  object lstStatus: TListBox
    Left = 182
    Top = 155
    Width = 289
    Height = 191
    ItemHeight = 13
    TabOrder = 3
  end
  object btnConvert: TButton
    Left = 396
    Top = 105
    Width = 75
    Height = 25
    Caption = 'Convert'
    TabOrder = 4
    OnClick = btnConvertClick
  end
  object chkMetaDataOnly: TCheckBox
    Left = 293
    Top = 105
    Width = 97
    Height = 17
    Caption = 'MetaData Only'
    TabOrder = 5
  end
  object cbxDriverName: TComboBox
    Left = 182
    Top = 32
    Width = 289
    Height = 21
    BevelInner = bvSpace
    ItemHeight = 13
    TabOrder = 6
    OnChange = cbxDriverNameChange
  end
  object mnuTables: TPopupMenu
    Left = 112
    Top = 168
    object SelectAll1: TMenuItem
      Caption = 'Select All'
      OnClick = SelectAll1Click
    end
    object SelectNone1: TMenuItem
      Caption = 'Select None'
      OnClick = SelectNone1Click
    end
  end
end
