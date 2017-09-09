object f_SourceFile: Tf_SourceFile
  Left = 313
  Top = 295
  Caption = 'f_SourceFile'
  ClientHeight = 281
  ClientWidth = 291
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object l_DbPassword: TLabel
    Left = 0
    Top = 48
    Width = 60
    Height = 13
    Caption = 'DbPassword'
  end
  object fe_SourceFile: TJvFilenameEdit
    Left = 0
    Top = 24
    Width = 273
    Height = 21
    Filter = 'XML Files (*.xml)|*.xml|All Files|*.*|Access DB (*.mdb)|*.mdb'
    FilterIndex = 0
    DialogTitle = 'Source File'
    Constraints.MinWidth = 172
    TabOrder = 0
  end
  object chk_IncludeData: TCheckBox
    Left = 0
    Top = 96
    Width = 273
    Height = 17
    Caption = 'include Data'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object chk_MakeAutoInc: TCheckBox
    Left = 0
    Top = 120
    Width = 217
    Height = 17
    Caption = 'make Primary Key AutoInc'
    TabOrder = 2
  end
  object chk_ConsolidateIndices: TCheckBox
    Left = 0
    Top = 144
    Width = 281
    Height = 17
    Caption = 'Consolidate Indices (discards index names)'
    TabOrder = 3
  end
  object ed_DbPassword: TEdit
    Left = 0
    Top = 64
    Width = 273
    Height = 21
    TabOrder = 4
  end
  object TheFormStorage: TJvFormStorage
    AppStoragePath = 'f_SourceFile\'
    Options = []
    StoredProps.Strings = (
      'fe_SourceFile.Filename'
      'fe_SourceFile.History'
      'chk_IncludeData.Checked'
      'chk_MakeAutoInc.Checked'
      'chk_ConsolidateIndices.Checked')
    StoredValues = <>
    Left = 112
    Top = 8
  end
end
