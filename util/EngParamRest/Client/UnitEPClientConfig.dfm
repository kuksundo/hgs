object ConfigF: TConfigF
  Left = 0
  Top = 0
  Caption = 'ConfigF'
  ClientHeight = 388
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 389
    Height = 347
    ActivePage = DBServarTab
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
      object Label16: TLabel
        Left = 19
        Top = 27
        Width = 128
        Height = 16
        Caption = 'Parameter File Name'
        ParentShowHint = False
        ShowHint = False
      end
      object Label11: TLabel
        Left = 19
        Top = 154
        Width = 203
        Height = 16
        Caption = 'Append String To CSV File Name:'
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
      object AppendStrEdit: TEdit
        Left = 19
        Top = 176
        Width = 294
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
      end
      object FNameType_RG: TRadioGroup
        Left = 19
        Top = 235
        Width = 273
        Height = 57
        Caption = 'Data Source'
        ItemIndex = 0
        Items.Strings = (
          'Comm Server'
          'DB Server')
        TabOrder = 4
      end
    end
    object CommServerTab: TTabSheet
      Caption = 'Comm Server'
      ImageIndex = 6
      object Label20: TLabel
        Left = 61
        Top = 27
        Width = 69
        Height = 16
        Caption = 'IP Address:'
      end
      object Label21: TLabel
        Left = 82
        Top = 90
        Width = 48
        Height = 16
        Caption = 'User ID:'
      end
      object Label22: TLabel
        Left = 43
        Top = 269
        Width = 87
        Height = 16
        Caption = 'Shared Name:'
      end
      object Label25: TLabel
        Left = 16
        Top = 212
        Width = 114
        Height = 16
        Caption = 'Reconnect Interval:'
      end
      object Label26: TLabel
        Left = 223
        Top = 214
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
      object Label9: TLabel
        Left = 82
        Top = 58
        Width = 48
        Height = 16
        Caption = 'Port No:'
      end
      object Label23: TLabel
        Left = 79
        Top = 120
        Width = 51
        Height = 16
        Caption = 'Passwd:'
      end
      object ServerIPEdit: TEdit
        Left = 136
        Top = 24
        Width = 185
        Height = 24
        Hint = 'Parameter;Server IP'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object UserEdit: TEdit
        Left = 136
        Top = 87
        Width = 185
        Height = 24
        Hint = 'Parameter;User ID'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
      end
      object PasswdEdit: TEdit
        Left = 136
        Top = 117
        Width = 185
        Height = 24
        Hint = 'Parameter;PassWord'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
      end
      object ReConnectIntervalEdit: TSpinEdit
        Left = 136
        Top = 209
        Width = 81
        Height = 26
        Hint = 'Parameter;'
        MaxValue = 0
        MinValue = 0
        TabOrder = 3
        Value = 1
      end
      object ServerPortEdit: TEdit
        Left = 136
        Top = 55
        Width = 185
        Height = 24
        Hint = 'Parameter;Server Port'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 4
      end
      object SharedNameEdit: TEdit
        Left = 136
        Top = 266
        Width = 185
        Height = 24
        Hint = 'Parameter;'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 5
      end
    end
    object DBServarTab: TTabSheet
      Caption = 'DataBase'
      ImageIndex = 3
      object Label6: TLabel
        Left = 13
        Top = 28
        Width = 119
        Height = 16
        Caption = 'DB Server Address:'
      end
      object Label7: TLabel
        Left = 82
        Top = 66
        Width = 48
        Height = 16
        Caption = 'User ID:'
      end
      object Label8: TLabel
        Left = 67
        Top = 101
        Width = 63
        Height = 16
        Caption = 'Password:'
      end
      object Label10: TLabel
        Left = 18
        Top = 138
        Width = 114
        Height = 16
        Caption = 'Save Table Name:'
      end
      object Label12: TLabel
        Left = 16
        Top = 188
        Width = 114
        Height = 16
        Caption = 'Reconnect Interval:'
      end
      object Label13: TLabel
        Left = 231
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
        Left = 144
        Top = 32
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object Edit1: TEdit
        Left = 144
        Top = 63
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
      end
      object Edit2: TEdit
        Left = 144
        Top = 98
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
      end
      object TableNameCombo: TComboBox
        Left = 144
        Top = 136
        Width = 185
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
        OnDropDown = TableNameComboDropDown
      end
      object SpinEdit1: TSpinEdit
        Left = 144
        Top = 185
        Width = 81
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 4
        Value = 1
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 347
    Width = 389
    Height = 41
    Align = alBottom
    TabOrder = 1
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
      Left = 242
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
