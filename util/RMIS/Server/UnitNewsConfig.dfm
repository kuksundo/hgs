object ConfigF: TConfigF
  Left = 0
  Top = 0
  Caption = 'Configuration'
  ClientHeight = 469
  ClientWidth = 483
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
    Width = 483
    Height = 428
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
      object Label11: TLabel
        Left = 11
        Top = 50
        Width = 125
        Height = 16
        Caption = 'Number of News List:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label15: TLabel
        Left = 11
        Top = 98
        Width = 150
        Height = 16
        Caption = 'RSS Address File Name:'
        ParentShowHint = False
        ShowHint = False
      end
      object AppendStrEdit: TEdit
        Left = 174
        Top = 47
        Width = 145
        Height = 24
        Hint = 'Parameter;Number of News List'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object JvFilenameEdit1: TJvFilenameEdit
        Left = 174
        Top = 95
        Width = 241
        Height = 24
        Hint = 'File;RSS Address File Name'
        ImeName = 'Microsoft IME 2010'
        TabOrder = 1
        Text = ''
      end
    end
    object CommServerTab: TTabSheet
      Caption = 'Comm Server'
      ImageIndex = 6
      object Bevel1: TBevel
        Left = 32
        Top = 32
        Width = 361
        Height = 193
      end
      object Label20: TLabel
        Left = 66
        Top = 51
        Width = 72
        Height = 16
        Caption = ' IP Address:'
      end
      object Label21: TLabel
        Left = 90
        Top = 114
        Width = 48
        Height = 16
        Caption = 'User ID:'
      end
      object Label22: TLabel
        Left = 43
        Top = 181
        Width = 115
        Height = 16
        Caption = 'Time To Get News:'
      end
      object Label25: TLabel
        Left = 32
        Top = 340
        Width = 114
        Height = 16
        Caption = 'Reconnect Interval:'
      end
      object Label26: TLabel
        Left = 239
        Top = 342
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
        Left = 90
        Top = 82
        Width = 48
        Height = 16
        Caption = 'Port No:'
      end
      object Label23: TLabel
        Left = 87
        Top = 144
        Width = 51
        Height = 16
        Caption = 'Passwd:'
      end
      object Label14: TLabel
        Left = 56
        Top = 24
        Width = 140
        Height = 16
        Caption = 'HHI Office News Server'
        Transparent = False
      end
      object ServerIPEdit: TEdit
        Left = 170
        Top = 48
        Width = 187
        Height = 24
        Hint = 'Comm Server;HHI Office News Server IP'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object UserEdit: TEdit
        Left = 170
        Top = 111
        Width = 187
        Height = 24
        Hint = 'Parameter;User ID'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
      end
      object PasswdEdit: TEdit
        Left = 170
        Top = 141
        Width = 187
        Height = 24
        Hint = 'Parameter;PassWord'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
      end
      object ReConnectIntervalEdit: TSpinEdit
        Left = 152
        Top = 337
        Width = 81
        Height = 26
        Hint = 'Parameter;'
        MaxValue = 0
        MinValue = 0
        TabOrder = 3
        Value = 1
      end
      object ServerPortEdit: TEdit
        Left = 170
        Top = 79
        Width = 187
        Height = 24
        Hint = 'Comm Server;HHI Office News Server Port'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 4
      end
      object TimeToGetEdit: TEdit
        Left = 172
        Top = 178
        Width = 185
        Height = 24
        Hint = 'Comm Server;Time To Get HHI Office News From Server'
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
    Top = 428
    Width = 483
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
      Left = 322
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
