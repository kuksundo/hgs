object FrmModbusSlaveConfig: TFrmModbusSlaveConfig
  Left = 0
  Top = 0
  Caption = 'Modbus slave configuration'
  ClientHeight = 310
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 269
    Width = 367
    Height = 41
    Align = alBottom
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 76
      Top = 6
      Width = 75
      Height = 25
      Caption = #54869' '#51064
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 232
      Top = 6
      Width = 75
      Height = 25
      Caption = #52712' '#49548
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 367
    Height = 269
    ActivePage = TabSheet5
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object TabSheet5: TTabSheet
      Caption = 'Monitor Items'
      ImageIndex = 4
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 359
        Height = 25
        Align = alTop
        TabOrder = 0
        ExplicitWidth = 340
        object Label19: TLabel
          Left = 2
          Top = 3
          Width = 236
          Height = 16
          Caption = '*) Items can be enabled by paramter file'
        end
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 25
        Width = 359
        Height = 213
        Align = alClient
        Caption = 'Select Items'
        TabOrder = 1
        ExplicitWidth = 340
        ExplicitHeight = 283
        object ParamSourceCLB: TCheckListBox
          Left = 2
          Top = 18
          Width = 355
          Height = 193
          Align = alClient
          Columns = 2
          ImeName = 'Microsoft IME 2010'
          TabOrder = 0
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'File Name'
      ImageIndex = 3
      object Label16: TLabel
        Left = 18
        Top = 83
        Width = 128
        Height = 16
        Caption = 'Parameter File Name'
        ParentShowHint = False
        ShowHint = False
      end
      object Label14: TLabel
        Left = 19
        Top = 15
        Width = 151
        Height = 16
        Caption = 'Modbus Map File Name1'
        ParentShowHint = False
        ShowHint = False
      end
      object ParaFilenameEdit: TJvFilenameEdit
        Left = 18
        Top = 105
        Width = 241
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object ConfFileFormatRG: TRadioGroup
        Left = 18
        Top = 140
        Width = 129
        Height = 57
        Caption = 'Param File Format'
        Columns = 2
        Items.Strings = (
          'XML'
          'JSON')
        TabOrder = 1
      end
      object EngParamEncryptCB: TCheckBox
        Left = 167
        Top = 153
        Width = 159
        Height = 17
        Caption = 'Parameter File Encrypt'
        TabOrder = 2
      end
      object MapFilenameEdit: TJvFilenameEdit
        Left = 19
        Top = 34
        Width = 241
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
      end
    end
  end
end
