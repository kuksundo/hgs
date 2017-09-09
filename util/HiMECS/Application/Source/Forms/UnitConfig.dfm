object ConfigF: TConfigF
  Left = 339
  Top = 152
  Caption = 'Options Configuration'
  ClientHeight = 351
  ClientWidth = 396
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 27
    Width = 396
    Height = 283
    ActivePage = Tabsheet2
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitTop = 33
    ExplicitHeight = 277
    object Tabsheet2: TTabSheet
      Caption = 'File Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 246
      object Label1: TLabel
        Left = 47
        Top = 35
        Width = 97
        Height = 16
        Caption = 'Menu File Name:'
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
        Left = 14
        Top = 61
        Width = 130
        Height = 16
        Caption = 'Engine Info File Name:'
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
        Left = 18
        Top = 121
        Width = 126
        Height = 16
        Caption = 'Parameter File Name:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label4: TLabel
        Left = 52
        Top = 93
        Width = 92
        Height = 16
        Caption = 'User File Name:'
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label11: TLabel
        Left = 12
        Top = 151
        Width = 132
        Height = 16
        Caption = 'Project Info File Name:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label12: TLabel
        Left = 15
        Top = 211
        Width = 130
        Height = 16
        Caption = 'Kill Process File Name:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label22: TLabel
        Left = 11
        Top = 181
        Width = 133
        Height = 16
        Caption = 'Manual Info File Name:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object MenuFilenameEdit: TJvFilenameEdit
        Left = 150
        Top = 31
        Width = 204
        Height = 24
        OnAfterDialog = MenuFilenameEditAfterDialog
        DefaultExt = '.menu'
        Filter = 'Menu File|*.menu|All files (*.*)|*.*'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
        Text = ''
      end
      object EngInfoFilenameEdit: TJvFilenameEdit
        Left = 149
        Top = 61
        Width = 204
        Height = 24
        OnAfterDialog = EngInfoFilenameEditAfterDialog
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
        Text = ''
      end
      object ParamFilenameEdit: TJvFilenameEdit
        Left = 149
        Top = 121
        Width = 204
        Height = 24
        OnAfterDialog = ParamFilenameEditAfterDialog
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
        Text = ''
      end
      object UserFilenameEdit: TJvFilenameEdit
        Left = 149
        Top = 91
        Width = 204
        Height = 24
        OnAfterDialog = UserFilenameEditAfterDialog
        ImeName = 'Microsoft Office IME 2007'
        Enabled = False
        TabOrder = 3
        Text = ''
      end
      object ProjInfoFilenameEdit: TJvFilenameEdit
        Left = 149
        Top = 151
        Width = 204
        Height = 24
        OnAfterDialog = ProjInfoFilenameEditAfterDialog
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 4
        Text = ''
      end
      object KillProcFilenameEdit: TJvFilenameEdit
        Left = 149
        Top = 211
        Width = 204
        Height = 24
        OnAfterDialog = KillProcFilenameEditAfterDialog
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 5
        Text = ''
      end
      object ManualInfoFilenameEdit: TJvFilenameEdit
        Left = 149
        Top = 181
        Width = 204
        Height = 24
        OnAfterDialog = ManualInfoFilenameEditAfterDialog
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 6
        Text = ''
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Directories'
      ImageIndex = 1
      ExplicitHeight = 246
      object Label6: TLabel
        Left = 18
        Top = 30
        Width = 119
        Height = 16
        Caption = 'Form File(.bpl) Path:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label7: TLabel
        Left = 43
        Top = 61
        Width = 94
        Height = 16
        Caption = 'Config File Path:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label8: TLabel
        Left = 5
        Top = 83
        Width = 132
        Height = 16
        Caption = '(.option, .menu, .form)'
        ParentShowHint = False
        ShowHint = False
      end
      object Label9: TLabel
        Left = 58
        Top = 106
        Width = 79
        Height = 16
        Caption = 'Doc File Path:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label10: TLabel
        Left = 53
        Top = 135
        Width = 84
        Height = 16
        Caption = 'Exes File Path:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label13: TLabel
        Left = 59
        Top = 199
        Width = 78
        Height = 16
        Caption = 'Log File Path:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label5: TLabel
        Left = 53
        Top = 167
        Width = 81
        Height = 16
        Caption = 'Bpls File Path:'
        ParentShowHint = False
        ShowHint = False
      end
      object FormPathEdit: TJvDirectoryEdit
        Left = 143
        Top = 27
        Width = 186
        Height = 24
        OnAfterDialog = FormPathEditAfterDialog
        DialogKind = dkWin32
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
        Text = ''
      end
      object ConfigPathEdit: TJvDirectoryEdit
        Left = 143
        Top = 58
        Width = 186
        Height = 24
        OnAfterDialog = ConfigPathEditAfterDialog
        DialogKind = dkWin32
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
        Text = ''
      end
      object DocPathEdit: TJvDirectoryEdit
        Left = 143
        Top = 102
        Width = 186
        Height = 24
        OnAfterDialog = DocPathEditAfterDialog
        DialogKind = dkWin32
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
        Text = ''
      end
      object ExePathEdit: TJvDirectoryEdit
        Left = 143
        Top = 132
        Width = 186
        Height = 24
        OnAfterDialog = ExePathEditAfterDialog
        DialogKind = dkWin32
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
        Text = ''
      end
      object LogPathEdit: TJvDirectoryEdit
        Left = 143
        Top = 196
        Width = 186
        Height = 24
        OnAfterDialog = LogPathEditAfterDialog
        DialogKind = dkWin32
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 4
        Text = ''
      end
      object BplPathEdit: TJvDirectoryEdit
        Left = 143
        Top = 164
        Width = 186
        Height = 24
        OnAfterDialog = BplPathEditAfterDialog
        DialogKind = dkWin32
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 5
        Text = ''
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Etc.'
      ImageIndex = 3
      ExplicitHeight = 246
      object CBExtAppInMDI: TCheckBox
        Left = 40
        Top = 32
        Width = 169
        Height = 17
        Caption = 'External Program In MDI '
        TabOrder = 0
      end
      object ConfFileFormatRG: TRadioGroup
        Left = 40
        Top = 136
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
        Left = 40
        Top = 101
        Width = 159
        Height = 17
        Caption = 'Parameter File Encrypt'
        TabOrder = 2
      end
      object CBUseMonLauncher: TCheckBox
        Left = 40
        Top = 55
        Width = 265
        Height = 17
        Caption = 'Use External MonitorLauncher Program'
        TabOrder = 3
      end
      object CBUseCommLauncher: TCheckBox
        Left = 40
        Top = 78
        Width = 265
        Height = 17
        Caption = 'Use External Comm Launcher Program'
        TabOrder = 4
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'TCP'
      ImageIndex = 3
      ExplicitHeight = 246
      object Label14: TLabel
        Left = 49
        Top = 31
        Width = 66
        Height = 16
        Caption = 'IP Address:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label15: TLabel
        Left = 50
        Top = 71
        Width = 58
        Height = 16
        Caption = 'Port Num:'
        ParentShowHint = False
        ShowHint = False
      end
      object PortNumEdit: TEdit
        Left = 120
        Top = 71
        Width = 111
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 0
        Text = '1'
      end
      object JvIPAddress1: TJvIPAddress
        Left = 124
        Top = 31
        Width = 150
        Height = 24
        Address = 0
        ParentColor = False
        TabOrder = 1
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Update'
      ImageIndex = 4
      ExplicitHeight = 246
      object Label21: TLabel
        Left = 3
        Top = 166
        Width = 157
        Height = 16
        Caption = ' URL: HTTP or Network File'
        ParentShowHint = False
        ShowHint = False
      end
      object SelProtocolRG: TRadioGroup
        Left = 14
        Top = 16
        Width = 161
        Height = 113
        Caption = 'Protocol'
        ItemIndex = 0
        Items.Strings = (
          'HTTP'
          'HTTPS'
          'FTP'
          'Network File')
        TabOrder = 0
        OnClick = SelProtocolRGClick
      end
      object UpdateCB: TCheckBox
        Left = 3
        Top = 216
        Width = 273
        Height = 17
        Caption = 'Check the update when program start'
        TabOrder = 1
      end
      object URLEdit: TEdit
        Left = 3
        Top = 185
        Width = 374
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 2
      end
      object GroupBox1: TGroupBox
        Left = 181
        Top = 16
        Width = 196
        Height = 163
        Caption = 'FTP Setup'
        Enabled = False
        TabOrder = 3
        object Label16: TLabel
          Left = 38
          Top = 34
          Width = 30
          Height = 16
          Caption = 'Host:'
          ParentShowHint = False
          ShowHint = False
        end
        object Label17: TLabel
          Left = 40
          Top = 56
          Width = 28
          Height = 16
          Caption = 'Port:'
          ParentShowHint = False
          ShowHint = False
        end
        object Label18: TLabel
          Left = 21
          Top = 82
          Width = 47
          Height = 16
          Caption = 'User ID:'
          ParentShowHint = False
          ShowHint = False
        end
        object Label19: TLabel
          Left = 20
          Top = 109
          Width = 48
          Height = 16
          Caption = 'Passwd:'
          ParentShowHint = False
          ShowHint = False
        end
        object Label20: TLabel
          Left = 12
          Top = 134
          Width = 56
          Height = 16
          Caption = 'Directory:'
          ParentShowHint = False
          ShowHint = False
        end
        object HostEdit: TEdit
          Left = 74
          Top = 28
          Width = 111
          Height = 24
          ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
          TabOrder = 0
        end
        object PortEdit: TEdit
          Left = 74
          Top = 53
          Width = 111
          Height = 24
          ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
          TabOrder = 1
        end
        object UserIdEdit: TEdit
          Left = 74
          Top = 79
          Width = 111
          Height = 24
          ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
          TabOrder = 2
        end
        object PasswdEdit: TEdit
          Left = 74
          Top = 104
          Width = 111
          Height = 24
          ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
          TabOrder = 3
        end
        object DirEdit: TEdit
          Left = 74
          Top = 131
          Width = 111
          Height = 24
          ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
          TabOrder = 4
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 310
    Width = 396
    Height = 41
    Align = alBottom
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ExplicitTop = 277
    object BitBtn1: TBitBtn
      Left = 40
      Top = 6
      Width = 75
      Height = 25
      Caption = #54869' '#51064
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 282
      Top = 6
      Width = 75
      Height = 25
      Caption = #52712' '#49548
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 396
    Height = 27
    Align = alTop
    TabOrder = 2
    object RelativeCB: TCheckBox
      Left = 16
      Top = 4
      Width = 133
      Height = 17
      Caption = 'Use Relative Path'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
  end
end
