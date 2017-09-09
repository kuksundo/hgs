object ConfigF: TConfigF
  Left = 0
  Top = 0
  Caption = 'Configuration'
  ClientHeight = 399
  ClientWidth = 484
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 484
    Height = 358
    ActivePage = TabSheet5
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #51200#51109#51068#49884
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 131
        Top = 61
        Width = 12
        Height = 16
        Caption = #49884
      end
      object Label2: TLabel
        Left = 195
        Top = 61
        Width = 12
        Height = 16
        Caption = #48516
      end
      object Label3: TLabel
        Left = 67
        Top = 117
        Width = 12
        Height = 16
        Caption = #50900
      end
      object Label4: TLabel
        Left = 131
        Top = 117
        Width = 12
        Height = 16
        Caption = #51068
      end
      object Label5: TLabel
        Left = 24
        Top = 8
        Width = 195
        Height = 48
        Caption = #49444#51221#54620' '#49884#44036#48324#47196' '#46608#45716' '#45216#51676', '#49884#44036#48324#47196#13#10#13#10#45936#51060#53440#47484'  '#51200#51109#54632
      end
      object ampm_combo: TComboBox
        Left = 24
        Top = 57
        Width = 57
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 0
        Text = #50724#51204
        Items.Strings = (
          #50724#51204
          #50724#54980)
      end
      object Hour_SpinEdit: TSpinEdit
        Left = 88
        Top = 57
        Width = 41
        Height = 26
        MaxValue = 12
        MinValue = 0
        TabOrder = 1
        Value = 0
      end
      object Minute_SpinEdit: TSpinEdit
        Left = 152
        Top = 57
        Width = 41
        Height = 26
        MaxValue = 59
        MinValue = 0
        TabOrder = 2
        Value = 0
      end
      object UseDate_ChkBox: TCheckBox
        Left = 24
        Top = 89
        Width = 129
        Height = 17
        Caption = #45216#51676' '#49324#50857#54616#44592
        TabOrder = 3
      end
      object Month_SpinEdit: TSpinEdit
        Left = 24
        Top = 113
        Width = 41
        Height = 26
        MaxValue = 12
        MinValue = 1
        TabOrder = 4
        Value = 1
      end
      object Date_SpinEdit: TSpinEdit
        Left = 88
        Top = 113
        Width = 41
        Height = 26
        MaxValue = 31
        MinValue = 1
        TabOrder = 5
        Value = 1
      end
      object Repeat_ChkBox: TCheckBox
        Left = 24
        Top = 145
        Width = 129
        Height = 17
        Caption = #48152#48373' '#51652#54665
        TabOrder = 6
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Monitor Items'
      ImageIndex = 4
      object GroupBox1: TGroupBox
        Left = 0
        Top = 25
        Width = 476
        Height = 302
        Align = alClient
        Caption = 'Select Items'
        TabOrder = 0
        object ParamSourceCLB: TCheckListBox
          Left = 2
          Top = 18
          Width = 472
          Height = 282
          Align = alClient
          Columns = 2
          ImeName = 'Microsoft IME 2010'
          TabOrder = 0
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 476
        Height = 25
        Align = alTop
        TabOrder = 1
        object Label19: TLabel
          Left = 2
          Top = 3
          Width = 236
          Height = 16
          Caption = '*) Items can be enabled by paramter file'
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'File'
      ImageIndex = 3
      object Label14: TLabel
        Left = 19
        Top = 15
        Width = 151
        Height = 16
        Caption = 'Modbus Map File Name1'
        ParentShowHint = False
        ShowHint = False
      end
      object Label16: TLabel
        Left = 19
        Top = 67
        Width = 128
        Height = 16
        Caption = 'Parameter File Name'
        ParentShowHint = False
        ShowHint = False
      end
      object Label11: TLabel
        Left = 19
        Top = 194
        Width = 203
        Height = 16
        Caption = 'Append String To CSV File Name:'
        ParentShowHint = False
        ShowHint = False
      end
      object MapFilenameEdit: TJvFilenameEdit
        Left = 19
        Top = 34
        Width = 241
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
        Text = ''
      end
      object ParaFilenameEdit: TJvFilenameEdit
        Left = 19
        Top = 86
        Width = 241
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
        Text = ''
      end
      object ConfFileFormatRG: TRadioGroup
        Left = 19
        Top = 116
        Width = 129
        Height = 57
        Caption = 'Param File Format'
        Columns = 2
        Items.Strings = (
          'XML'
          'JSON')
        TabOrder = 2
      end
      object EngParamEncryptCB: TCheckBox
        Left = 168
        Top = 129
        Width = 159
        Height = 17
        Caption = 'Parameter File Encrypt'
        TabOrder = 3
      end
      object AppendStrEdit: TEdit
        Left = 19
        Top = 216
        Width = 294
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 4
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Save Device'
      ImageIndex = 2
      object Label9: TLabel
        Left = 8
        Top = 8
        Width = 180
        Height = 39
        Caption = #45936#51060#53440#47484' '#51200#51109#54624' '#47588#52404#47484' '#49440#53469#54632'.'#13#10#48373#49688#44060' '#49440#53469#51060' '#44032#45733#54616#47728' '#50500#47924#44163#46020' '#13#10#49440#53469#51012' '#50504#54616#47732' '#51200#51109#51012' '#54616#51648' '#50506#51020
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object SaveDB_ChkBox: TCheckBox
        Left = 16
        Top = 57
        Width = 129
        Height = 17
        Caption = #45936#51060#53440#48288#51060#49828
        TabOrder = 0
      end
      object SaveFile_ChkBox: TCheckBox
        Left = 16
        Top = 116
        Width = 129
        Height = 17
        Caption = #54028#51068
        TabOrder = 1
      end
      object FNameType_RG: TRadioGroup
        Left = 16
        Top = 139
        Width = 273
        Height = 57
        Enabled = False
        ItemIndex = 0
        Items.Strings = (
          'Filename Auto Change(yyyymmdd.txt)'
          'Fixed Filename')
        TabOrder = 2
      end
      object DB_Type_RG: TRadioGroup
        Left = 120
        Top = 53
        Width = 137
        Height = 60
        Enabled = False
        ItemIndex = 0
        Items.Strings = (
          'Oracle'
          'MongoDB')
        TabOrder = 3
      end
    end
    object OracleTS: TTabSheet
      Caption = 'OracleTS'
      ImageIndex = 6
      object Label20: TLabel
        Left = 13
        Top = 28
        Width = 119
        Height = 16
        Caption = 'DB Server Address:'
      end
      object Label21: TLabel
        Left = 82
        Top = 66
        Width = 48
        Height = 16
        Caption = 'User ID:'
      end
      object Label22: TLabel
        Left = 67
        Top = 101
        Width = 63
        Height = 16
        Caption = 'Password:'
      end
      object Label23: TLabel
        Left = 18
        Top = 138
        Width = 114
        Height = 16
        Caption = 'Save Table Name:'
      end
      object Label25: TLabel
        Left = 16
        Top = 188
        Width = 114
        Height = 16
        Caption = 'Reconnect Interval:'
      end
      object Label26: TLabel
        Left = 223
        Top = 190
        Width = 27
        Height = 13
        Caption = 'mSec'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object ServerEdit: TEdit
        Left = 136
        Top = 24
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object UserEdit: TEdit
        Left = 136
        Top = 63
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
      end
      object PasswdEdit: TEdit
        Left = 136
        Top = 98
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
      end
      object TableNameCombo: TComboBox
        Left = 136
        Top = 136
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
      end
      object ReConnectIntervalEdit: TSpinEdit
        Left = 136
        Top = 185
        Width = 81
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 4
        Value = 1
      end
    end
    object MongoDBTS: TTabSheet
      Caption = 'MongoDBTS'
      ImageIndex = 6
      object Label18: TLabel
        Left = 38
        Top = 36
        Width = 97
        Height = 16
        Caption = 'Server Address:'
      end
      object Label27: TLabel
        Left = 90
        Top = 74
        Width = 48
        Height = 16
        Caption = 'User ID:'
      end
      object Label28: TLabel
        Left = 75
        Top = 109
        Width = 63
        Height = 16
        Caption = 'Password:'
      end
      object Label29: TLabel
        Left = 76
        Top = 147
        Width = 62
        Height = 16
        Caption = 'DB Name:'
      end
      object Label30: TLabel
        Left = 21
        Top = 260
        Width = 114
        Height = 16
        Caption = 'Reconnect Interval:'
      end
      object Label31: TLabel
        Left = 228
        Top = 262
        Width = 27
        Height = 13
        Caption = 'mSec'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label32: TLabel
        Left = 36
        Top = 187
        Width = 102
        Height = 16
        Caption = 'Collection Name:'
      end
      object MongoServerEdit: TEdit
        Left = 144
        Top = 32
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object MongoUserEdit: TEdit
        Left = 144
        Top = 71
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
      end
      object MongoPasswdEdit: TEdit
        Left = 144
        Top = 106
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
      end
      object MongoDBNameCombo: TComboBox
        Left = 144
        Top = 144
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
      end
      object MongoReConnectEdit: TSpinEdit
        Left = 141
        Top = 257
        Width = 81
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 4
        Value = 1
      end
      object MongoCollNameCombo: TComboBox
        Left = 144
        Top = 184
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 5
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 358
    Width = 484
    Height = 41
    Align = alBottom
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 56
      Top = 8
      Width = 75
      Height = 25
      Caption = #54869' '#51064
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 210
      Top = 8
      Width = 75
      Height = 25
      Caption = #52712' '#49548
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
end
