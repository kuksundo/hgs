object FrmDataSaveAllConfig: TFrmDataSaveAllConfig
  Left = 0
  Top = 0
  Caption = 'FrmDataSaveAllConfig'
  ClientHeight = 390
  ClientWidth = 348
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 349
    Width = 348
    Height = 41
    Align = alBottom
    TabOrder = 0
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 348
    Height = 349
    ActivePage = TabSheet5
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
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
    object TabSheet5: TTabSheet
      Caption = 'Monitor Items'
      ImageIndex = 4
      object GroupBox1: TGroupBox
        Left = 0
        Top = 25
        Width = 340
        Height = 293
        Align = alClient
        Caption = 'Select Items'
        TabOrder = 0
        object ParamSourceCLB: TCheckListBox
          Left = 2
          Top = 18
          Width = 336
          Height = 273
          Align = alClient
          AllowGrayed = True
          Columns = 2
          ImeName = 'Microsoft IME 2010'
          Style = lbOwnerDrawFixed
          TabOrder = 0
          OnDrawItem = ParamSourceCLBDrawItem
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 340
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
        object Button1: TButton
          Left = 256
          Top = 0
          Width = 81
          Height = 25
          Caption = 'Refresh'
          TabOrder = 0
          OnClick = Button1Click
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
    object TabSheet2: TTabSheet
      Caption = 'Save Condition'
      ImageIndex = 1
      object Label6: TLabel
        Left = 59
        Top = 60
        Width = 24
        Height = 13
        Caption = #49884#44036
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label7: TLabel
        Left = 134
        Top = 60
        Width = 12
        Height = 13
        Caption = #48516
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 16
        Top = 8
        Width = 162
        Height = 39
        Caption = #49444#51221#54620' '#49884#44036#51012' '#52852#50868#53944#45796#50868#54616#50668#13#10' '#13#10#39'0'#39' '#51060' '#46104#47732' '#45936#51060#53440#47484'  '#51200#51109#54632
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 198
        Top = 60
        Width = 12
        Height = 13
        Caption = #52488
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label15: TLabel
        Left = 187
        Top = 110
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
      object Label13: TLabel
        Left = 16
        Top = 177
        Width = 280
        Height = 16
        Caption = 'Last Block No(For Save one line on multi event)'
      end
      object Label17: TLabel
        Left = 13
        Top = 108
        Width = 81
        Height = 16
        Caption = 'Timer Interval'
      end
      object ParamIndexLabel: TLabel
        Left = 13
        Top = 155
        Width = 101
        Height = 16
        Caption = 'Parameter Index:'
        Enabled = False
      end
      object Label24: TLabel
        Left = 13
        Top = 253
        Width = 101
        Height = 16
        Caption = 'Parameter Index:'
        Enabled = False
      end
      object IntervalLbl: TLabel
        Left = 178
        Top = 256
        Width = 46
        Height = 16
        Caption = 'Interval:'
        Enabled = False
      end
      object mSecLbl: TLabel
        Left = 302
        Top = 256
        Width = 27
        Height = 13
        Caption = 'mSec'
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 100
        Top = 85
        Width = 215
        Height = 16
        Caption = '(When below 200ms then bulkmode)'
      end
      object Label18: TLabel
        Left = 13
        Top = 282
        Width = 134
        Height = 16
        Caption = 'Auto Monitor Start After'
      end
      object Label27: TLabel
        Left = 238
        Top = 284
        Width = 27
        Height = 13
        Caption = 'mSec'
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object HourCnt_SpinEdit: TSpinEdit
        Left = 16
        Top = 53
        Width = 41
        Height = 26
        Enabled = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 0
      end
      object MinuteCnt_SpinEdit: TSpinEdit
        Left = 91
        Top = 53
        Width = 41
        Height = 26
        Enabled = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 0
      end
      object RepeatCnt_ChkBox: TCheckBox
        Left = 17
        Top = 85
        Width = 77
        Height = 17
        Caption = #48152#48373' '#51652#54665
        Enabled = False
        TabOrder = 2
      end
      object SecondCnt_SpinEdit: TSpinEdit
        Left = 151
        Top = 53
        Width = 41
        Height = 26
        Enabled = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 3
        Value = 1
      end
      object IntervalSE: TSpinEdit
        Left = 100
        Top = 105
        Width = 81
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 4
        Value = 1
      end
      object BlockNoEdit: TEdit
        Left = 13
        Top = 199
        Width = 54
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 5
      end
      object SaveOnlyCB: TCheckBox
        Left = 17
        Top = 133
        Width = 193
        Height = 17
        Caption = 'Save only when Index is true'
        TabOrder = 6
        OnClick = SaveOnlyCBClick
      end
      object SaveRunHourCB: TCheckBox
        Left = 13
        Top = 230
        Width = 129
        Height = 17
        Caption = 'Save Run Hour'
        TabOrder = 7
        OnClick = SaveRunHourCBClick
      end
      object RunHourIndexEdit: TEdit
        Left = 117
        Top = 251
        Width = 43
        Height = 24
        Enabled = False
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 8
      end
      object RHIntervalSE: TSpinEdit
        Left = 230
        Top = 251
        Width = 66
        Height = 26
        Enabled = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 9
        Value = 1
      end
      object ParamIndexEdit: TEditBtn
        Left = 120
        Top = 154
        Width = 81
        Height = 24
        ReturnIsTab = False
        Flat = False
        Etched = False
        FocusBorder = False
        RightAlign = False
        TabOrder = 10
        Text = '0'
        Version = '1.5.2.0'
        OnClickBtn = ParamIndexEditClickBtn
      end
      object AutoStartAfterEdit: TSpinEdit
        Left = 154
        Top = 279
        Width = 81
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 11
        Value = 0
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
        Enabled = False
        TabOrder = 0
      end
      object SaveFile_ChkBox: TCheckBox
        Left = 16
        Top = 80
        Width = 129
        Height = 17
        Caption = #54028#51068
        Enabled = False
        TabOrder = 1
      end
      object FNameType_RG: TRadioGroup
        Left = 16
        Top = 99
        Width = 273
        Height = 57
        ItemIndex = 0
        Items.Strings = (
          'Filename Auto Change(yyyymmdd.txt)'
          'Fixed Filename')
        TabOrder = 2
      end
    end
    object Database: TTabSheet
      Caption = 'Database'
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
  end
end
