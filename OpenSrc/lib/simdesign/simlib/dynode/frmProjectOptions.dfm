object dlgProjectOptions: TdlgProjectOptions
  Left = 512
  Top = 359
  Width = 436
  Height = 410
  Caption = 'Project Options for [#project]'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object cbDefault: TCheckBox
    Left = 16
    Top = 344
    Width = 97
    Height = 17
    Caption = 'Default'
    TabOrder = 0
  end
  object mnuOK: TButton
    Left = 176
    Top = 336
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object mnuCancel: TButton
    Left = 256
    Top = 336
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
  end
  object mnuHelp: TButton
    Left = 336
    Top = 336
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 3
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 401
    Height = 321
    ActivePage = tsDirectories
    MultiLine = True
    TabOrder = 4
    object tsDirectories: TTabSheet
      Caption = 'Directories/Conditionals'
      object gbDirectories: TGroupBox
        Left = 8
        Top = 0
        Width = 385
        Height = 161
        Caption = '&Directories'
        TabOrder = 0
        object lbOutputFolder: TLabel
          Left = 8
          Top = 18
          Width = 64
          Height = 13
          Caption = '&Output folder:'
        end
        object lbUnitOutputFolder: TLabel
          Left = 8
          Top = 42
          Width = 84
          Height = 13
          Caption = '&Unit output folder:'
        end
        object lbSearchPath: TLabel
          Left = 8
          Top = 66
          Width = 61
          Height = 13
          Caption = '&Search path:'
        end
        object lbDebugSourcePath: TLabel
          Left = 8
          Top = 90
          Width = 91
          Height = 13
          Caption = '&Debug source path'
        end
        object lbDPLOutputFolder: TLabel
          Left = 8
          Top = 114
          Width = 86
          Height = 13
          Caption = '&DPL output folder:'
        end
        object lbDCPOutputFolder: TLabel
          Left = 8
          Top = 138
          Width = 87
          Height = 13
          Caption = 'DC&P output folder:'
        end
        object cbbOutputFolder: TComboBox
          Left = 112
          Top = 14
          Width = 241
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = 'cbbOutputFolder'
        end
        object btnOutputFolder: TButton
          Left = 355
          Top = 14
          Width = 17
          Height = 21
          Caption = '...'
          TabOrder = 1
        end
        object cbbUnitOutputFolder: TComboBox
          Left = 112
          Top = 38
          Width = 241
          Height = 21
          ItemHeight = 13
          TabOrder = 2
          Text = 'cbbUnitOutputFolder'
        end
        object btnUnitOutputFolder: TButton
          Left = 355
          Top = 38
          Width = 17
          Height = 21
          Caption = '...'
          TabOrder = 3
        end
        object cbbSearchPath: TComboBox
          Left = 112
          Top = 62
          Width = 241
          Height = 21
          ItemHeight = 13
          TabOrder = 4
          Text = 'cbbSearchPath'
        end
        object btnSearchPath: TButton
          Left = 355
          Top = 62
          Width = 17
          Height = 21
          Caption = '...'
          TabOrder = 5
        end
        object cbbDebugSourcePath: TComboBox
          Left = 112
          Top = 86
          Width = 241
          Height = 21
          ItemHeight = 13
          TabOrder = 6
          Text = 'cbbDebugSourcePath'
        end
        object btnDebugSourcePath: TButton
          Left = 355
          Top = 86
          Width = 17
          Height = 21
          Caption = '...'
          TabOrder = 7
        end
        object cbbDPLOutputFolder: TComboBox
          Left = 112
          Top = 110
          Width = 241
          Height = 21
          ItemHeight = 13
          TabOrder = 8
          Text = 'cbbDPLOutputFolder'
        end
        object btnDPLOutputFolder: TButton
          Left = 355
          Top = 110
          Width = 17
          Height = 21
          Caption = '...'
          TabOrder = 9
        end
        object cbbDCPOutputFolder: TComboBox
          Left = 112
          Top = 134
          Width = 241
          Height = 21
          ItemHeight = 13
          TabOrder = 10
          Text = 'cbbDCPOutputFolder'
        end
        object btnDCPOutputFolder: TButton
          Left = 355
          Top = 134
          Width = 17
          Height = 21
          Caption = '...'
          TabOrder = 11
        end
      end
      object gbConditionals: TGroupBox
        Left = 8
        Top = 176
        Width = 385
        Height = 41
        Caption = 'Conditionals'
        TabOrder = 1
        object lbConditionalDefines: TLabel
          Left = 8
          Top = 18
          Width = 89
          Height = 13
          Caption = '&Conditional defines'
        end
        object cbbConditionalDefines: TComboBox
          Left = 112
          Top = 14
          Width = 241
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = 'lbConditionalDefines'
        end
        object btnConditionalDefines: TButton
          Left = 355
          Top = 14
          Width = 17
          Height = 21
          Caption = '...'
          TabOrder = 1
        end
      end
      object gbAliases: TGroupBox
        Left = 8
        Top = 232
        Width = 385
        Height = 41
        Caption = 'Aliases'
        TabOrder = 2
        object lbUnitAliases: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 13
          Caption = 'Unit &aliases'
        end
        object cbbUnitAliases: TComboBox
          Left = 112
          Top = 14
          Width = 241
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = 'cbbUnitAliases'
        end
        object btnUnitAliases: TButton
          Left = 355
          Top = 14
          Width = 17
          Height = 21
          Caption = '...'
          TabOrder = 1
        end
      end
    end
    object tsVersionInfo: TTabSheet
      Caption = 'Version Info'
      ImageIndex = 1
    end
    object tsPackages: TTabSheet
      Caption = 'Packages'
      ImageIndex = 2
    end
    object tsForms: TTabSheet
      Caption = 'Forms'
      ImageIndex = 3
    end
    object tsApplication: TTabSheet
      Caption = 'Application'
      ImageIndex = 4
    end
    object tsCompiler: TTabSheet
      Caption = 'Compiler'
      ImageIndex = 5
    end
    object tsCompilerMessages: TTabSheet
      Caption = 'Compiler Messages'
      ImageIndex = 6
    end
    object tsLinker: TTabSheet
      Caption = 'Linker'
      ImageIndex = 7
    end
  end
end
