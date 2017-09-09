object AlarmConfigF: TAlarmConfigF
  Left = 0
  Top = 0
  Caption = 'Alarm Config'
  ClientHeight = 354
  ClientWidth = 385
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
    Width = 385
    Height = 313
    ActivePage = Tabsheet2
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Tabsheet2: TTabSheet
      Caption = 'File'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      DesignSize = (
        377
        282)
      object Label1: TLabel
        Left = 47
        Top = 80
        Width = 96
        Height = 16
        Caption = 'Alarm DB Driver:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label3: TLabel
        Left = 24
        Top = 107
        Width = 119
        Height = 16
        Caption = 'Alarm DB File Name:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label2: TLabel
        Left = 47
        Top = 49
        Width = 93
        Height = 16
        Caption = 'Alarm Item File:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object AlarmDBFilenameEdit: TJvFilenameEdit
        Left = 148
        Top = 107
        Width = 204
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
        Text = ''
      end
      object DBDriverEdit: TJvFilenameEdit
        Left = 149
        Top = 77
        Width = 204
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
        Text = ''
      end
      object GroupBox1: TGroupBox
        Left = 38
        Top = 151
        Width = 280
        Height = 120
        Caption = 'Create Alarm DB in'
        TabOrder = 2
        object RB_bydate: TRadioButton
          Left = 96
          Top = 23
          Width = 89
          Height = 17
          Caption = 'every Day'
          TabOrder = 0
        end
        object RB_byfilename: TRadioButton
          Left = 96
          Top = 62
          Width = 113
          Height = 17
          Caption = 'Fixed Filename'
          TabOrder = 1
        end
        object RadioButton1: TRadioButton
          Left = 96
          Top = 42
          Width = 113
          Height = 17
          Caption = 'every Month'
          Checked = True
          TabOrder = 2
          TabStop = True
        end
        object ED_csv: TEdit
          Left = 96
          Top = 85
          Width = 169
          Height = 24
          Enabled = False
          ImeName = 'Microsoft Office IME 2007'
          TabOrder = 3
        end
      end
      object AlarmItemFileEdit: TJvFilenameEdit
        Left = 149
        Top = 46
        Width = 204
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
        Text = ''
      end
      object RelPathCB: TCheckBox
        Left = 148
        Top = 13
        Width = 98
        Height = 17
        Anchors = [akRight, akBottom]
        Caption = 'Relative Path'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        State = cbChecked
        TabOrder = 4
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Comm Server'
      ImageIndex = 1
      object Label20: TLabel
        Left = 61
        Top = 27
        Width = 66
        Height = 16
        Caption = 'IP Address:'
      end
      object Label21: TLabel
        Left = 82
        Top = 90
        Width = 47
        Height = 16
        Caption = 'User ID:'
      end
      object Label22: TLabel
        Left = 43
        Top = 226
        Width = 83
        Height = 16
        Caption = 'Shared Name:'
      end
      object Label25: TLabel
        Left = 16
        Top = 172
        Width = 111
        Height = 16
        Caption = 'Reconnect Interval:'
      end
      object Label26: TLabel
        Left = 223
        Top = 174
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
        Width = 47
        Height = 16
        Caption = 'Port No:'
      end
      object Label23: TLabel
        Left = 79
        Top = 120
        Width = 48
        Height = 16
        Caption = 'Passwd:'
      end
      object ServerIPEdit: TEdit
        Left = 136
        Top = 24
        Width = 185
        Height = 24
        Hint = 'Comm Server;Server IP'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object UserEdit: TEdit
        Left = 136
        Top = 87
        Width = 185
        Height = 24
        Hint = 'Comm Server;User ID'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
      end
      object PasswdEdit: TEdit
        Left = 136
        Top = 117
        Width = 185
        Height = 24
        Hint = 'Comm Server;PassWord'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
      end
      object ReConnectIntervalEdit: TSpinEdit
        Left = 136
        Top = 169
        Width = 81
        Height = 26
        Hint = 'Comm Server;'
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
        Hint = 'Comm Server;Server Port'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 4
      end
      object SharedNameEdit: TEdit
        Left = 136
        Top = 218
        Width = 185
        Height = 24
        Hint = 'Comm Server;Shared Name'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 5
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'DB Server'
      ImageIndex = 2
      object Label6: TLabel
        Left = 13
        Top = 28
        Width = 112
        Height = 16
        Caption = 'DB Server Address:'
      end
      object Label7: TLabel
        Left = 82
        Top = 66
        Width = 47
        Height = 16
        Caption = 'User ID:'
      end
      object Label8: TLabel
        Left = 67
        Top = 101
        Width = 60
        Height = 16
        Caption = 'Password:'
      end
      object Label10: TLabel
        Left = 18
        Top = 138
        Width = 106
        Height = 16
        Caption = 'Save Table Name:'
      end
      object Label12: TLabel
        Left = 16
        Top = 188
        Width = 111
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
    Top = 313
    Width = 385
    Height = 41
    Align = alBottom
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 66
      Top = 6
      Width = 75
      Height = 25
      Caption = #54869' '#51064
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 198
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
