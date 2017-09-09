object dlgEnvironmentOptions: TdlgEnvironmentOptions
  Left = 764
  Top = 218
  Width = 521
  Height = 416
  Caption = 'Environment Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pcEnvironmentOptions: TPageControl
    Left = 8
    Top = 16
    Width = 489
    Height = 313
    ActivePage = tsPreferences
    MultiLine = True
    TabOrder = 0
    object tsPreferences: TTabSheet
      Caption = 'Preferences'
    end
    object tsDesigner: TTabSheet
      Caption = 'Designer'
      ImageIndex = 1
    end
    object tsObjectInspector: TTabSheet
      Caption = 'Object Inspector'
      ImageIndex = 2
    end
    object tsPalette: TTabSheet
      Caption = 'Palette'
      ImageIndex = 3
    end
    object tsLibrary: TTabSheet
      Caption = 'Library'
      ImageIndex = 4
    end
    object tsExplorer: TTabSheet
      Caption = 'Explorer'
      ImageIndex = 5
    end
    object tsTypeLibrary: TTabSheet
      Caption = 'Type Library'
      ImageIndex = 6
    end
    object tsEnvironmVariables: TTabSheet
      Caption = 'Environment Variables'
      ImageIndex = 7
    end
    object tsDynodeDirect: TTabSheet
      Caption = 'Dynode Direct'
      ImageIndex = 8
    end
  end
  object btnOK: TButton
    Left = 8
    Top = 344
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 96
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
  end
  object btnHelp: TButton
    Left = 184
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 3
  end
end
