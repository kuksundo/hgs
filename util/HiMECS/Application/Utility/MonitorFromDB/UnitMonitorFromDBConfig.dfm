object MonitorDataFromDBConfigF: TMonitorDataFromDBConfigF
  Left = 0
  Top = 0
  Caption = 'Monitoring Data From DB Config'
  ClientHeight = 504
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 496
    Height = 463
    ActivePage = TabSheet4
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
    object TabSheet4: TTabSheet
      Caption = 'File'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 535
      ExplicitHeight = 392
      object Label16: TLabel
        Left = 19
        Top = 27
        Width = 128
        Height = 16
        Caption = 'Parameter File Name'
        ParentShowHint = False
        ShowHint = False
      end
      object ParaFilenameEdit: TJvFilenameEdit
        Left = 19
        Top = 46
        Width = 241
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
        Text = ''
      end
      object ConfFileFormatRG: TRadioGroup
        Left = 19
        Top = 76
        Width = 129
        Height = 57
        Caption = 'Param File Format'
        Columns = 2
        ItemIndex = 1
        Items.Strings = (
          'XML'
          'JSON')
        TabOrder = 1
      end
      object EngParamEncryptCB: TCheckBox
        Left = 168
        Top = 89
        Width = 159
        Height = 17
        Caption = 'Parameter File Encrypt'
        TabOrder = 2
      end
      object DB_Type_RG: TRadioGroup
        Left = 19
        Top = 149
        Width = 137
        Height = 60
        Caption = 'DB Select'
        Enabled = False
        ItemIndex = 0
        Items.Strings = (
          'Oracle'
          'MongoDB')
        TabOrder = 3
      end
    end
    object OracleTS: TTabSheet
      Caption = 'Oracle'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 535
      ExplicitHeight = 392
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
        Text = '10.100.23.114:1521:TBACS'
      end
      object UserEdit: TEdit
        Left = 136
        Top = 63
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
        Text = 'TBACS'
      end
      object PasswdEdit: TEdit
        Left = 136
        Top = 98
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
        Text = 'TBACS'
      end
      object TableNameCombo: TComboBox
        Left = 136
        Top = 136
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
        OnDropDown = TableNameComboDropDown
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
      Caption = 'MongoDB'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 535
      ExplicitHeight = 392
      object Label18: TLabel
        Left = 38
        Top = 11
        Width = 97
        Height = 16
        Caption = 'Server Address:'
      end
      object Label27: TLabel
        Left = 90
        Top = 49
        Width = 48
        Height = 16
        Caption = 'User ID:'
      end
      object Label28: TLabel
        Left = 75
        Top = 84
        Width = 63
        Height = 16
        Caption = 'Password:'
      end
      object Label29: TLabel
        Left = 76
        Top = 122
        Width = 62
        Height = 16
        Caption = 'DB Name:'
      end
      object Label30: TLabel
        Left = 21
        Top = 270
        Width = 114
        Height = 16
        Caption = 'Reconnect Interval:'
      end
      object Label31: TLabel
        Left = 228
        Top = 272
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
        Top = 162
        Width = 102
        Height = 16
        Caption = 'Collection Name:'
      end
      object Label33: TLabel
        Left = 26
        Top = 197
        Width = 112
        Height = 16
        Caption = 'Collection Name 2:'
      end
      object Label34: TLabel
        Left = 26
        Top = 231
        Width = 112
        Height = 16
        Caption = 'Collection Name 3:'
      end
      object MongoServerEdit: TEdit
        Left = 144
        Top = 7
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object MongoUserEdit: TEdit
        Left = 144
        Top = 46
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
      end
      object MongoPasswdEdit: TEdit
        Left = 144
        Top = 81
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
      end
      object MongoDBNameCombo: TComboBox
        Left = 144
        Top = 119
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
      end
      object MongoReConnectEdit: TSpinEdit
        Left = 141
        Top = 267
        Width = 81
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 4
        Value = 1000
      end
      object MongoCollNameCombo: TComboBox
        Left = 144
        Top = 159
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 5
      end
      object MongoCollNameCombo2: TComboBox
        Left = 144
        Top = 194
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 6
      end
      object MongoCollNameCombo3: TComboBox
        Left = 144
        Top = 228
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 7
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 463
    Width = 496
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 339
    ExplicitWidth = 348
    object BitBtn1: TBitBtn
      Left = 96
      Top = 6
      Width = 75
      Height = 25
      Caption = #54869' '#51064
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 370
      Top = 6
      Width = 75
      Height = 25
      Caption = #52712' '#49548
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
end
