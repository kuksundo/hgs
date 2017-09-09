object f_ExportFormat: Tf_ExportFormat
  Left = 495
  Top = 119
  Caption = 'f_ExportFormat'
  ClientHeight = 373
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    272
    373)
  PixelsPerInch = 96
  TextHeight = 13
  object chk_DelphiCode: TCheckBox
    Tag = 1
    Left = 0
    Top = 0
    Width = 150
    Height = 17
    Caption = 'Delphi Code (.pas)'
    TabOrder = 0
    OnClick = chk_CheckboxClick
  end
  object chk_VbCode: TCheckBox
    Tag = 2
    Left = 0
    Top = 48
    Width = 150
    Height = 17
    Caption = 'VB Code (.bas)'
    Enabled = False
    TabOrder = 2
    OnClick = chk_CheckboxClick
  end
  object chk_Oracle: TCheckBox
    Tag = 3
    Left = 0
    Top = 96
    Width = 150
    Height = 17
    Caption = 'Oracle (.xml)'
    TabOrder = 4
    OnClick = chk_CheckboxClick
  end
  object chk_MsSql: TCheckBox
    Tag = 4
    Left = 0
    Top = 144
    Width = 150
    Height = 17
    Caption = 'MS SQL (.xml)'
    TabOrder = 8
    OnClick = chk_CheckboxClick
  end
  object chk_Access: TCheckBox
    Tag = 5
    Left = 0
    Top = 192
    Width = 150
    Height = 17
    Caption = 'MS Access (.mdb)'
    TabOrder = 10
    OnClick = chk_CheckboxClick
  end
  object chk_Xml: TCheckBox
    Tag = 6
    Left = 0
    Top = 240
    Width = 150
    Height = 17
    Caption = 'XML (.xml)'
    TabOrder = 15
    OnClick = chk_CheckboxClick
  end
  object chk_GraphViz: TCheckBox
    Tag = 7
    Left = 0
    Top = 288
    Width = 150
    Height = 17
    Caption = 'GraphViz (.dot)'
    TabOrder = 7
    OnClick = chk_CheckboxClick
  end
  object chk_Html: TCheckBox
    Tag = 8
    Left = 0
    Top = 336
    Width = 150
    Height = 17
    Caption = 'HTML (.html)'
    TabOrder = 13
    OnClick = chk_CheckboxClick
  end
  object ed_DelphiFile: TJvFilenameEdit
    Tag = 1
    Left = 16
    Top = 16
    Width = 217
    Height = 21
    OEMConvert = False
    Enabled = False
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'ed_DelphiFile'
  end
  object ed_VbFile: TJvFilenameEdit
    Tag = 2
    Left = 16
    Top = 64
    Width = 217
    Height = 21
    OEMConvert = False
    Enabled = False
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = 'ed_VbFile'
  end
  object ed_OracleFile: TJvFilenameEdit
    Tag = 3
    Left = 16
    Top = 112
    Width = 217
    Height = 21
    OEMConvert = False
    Enabled = False
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    Text = 'ed_OracleFile'
  end
  object ed_MsSqlFile: TJvFilenameEdit
    Tag = 4
    Left = 16
    Top = 160
    Width = 217
    Height = 21
    OEMConvert = False
    Enabled = False
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 6
    Text = 'ed_MsSqlFile'
  end
  object ed_AccessFile: TJvFilenameEdit
    Tag = 5
    Left = 16
    Top = 208
    Width = 217
    Height = 21
    OEMConvert = False
    Enabled = False
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 12
    Text = 'ed_AccessFile'
  end
  object ed_XmlFile: TJvFilenameEdit
    Tag = 6
    Left = 16
    Top = 256
    Width = 217
    Height = 21
    OEMConvert = False
    Enabled = False
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 9
    Text = 'ed_XmlFile'
  end
  object ed_GraphVizFile: TJvFilenameEdit
    Tag = 7
    Left = 16
    Top = 304
    Width = 217
    Height = 21
    OEMConvert = False
    Enabled = False
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 11
    Text = 'ed_GraphVizFile'
  end
  object ed_HtmlFile: TJvFilenameEdit
    Tag = 8
    Left = 16
    Top = 352
    Width = 217
    Height = 21
    OEMConvert = False
    Enabled = False
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 14
    Text = 'ed_HtmlFile'
  end
end
