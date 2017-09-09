object FrameDataSaveAll: TFrameDataSaveAll
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 41
    Align = alTop
    TabOrder = 0
    object Label2: TLabel
      Left = 211
      Top = 14
      Width = 49
      Height = 13
      Caption = 'Run Hour:'
      Visible = False
    end
    object CB_Active: TCheckBox
      Left = 16
      Top = 18
      Width = 97
      Height = 17
      Caption = 'Start Datasave'
      TabOrder = 0
      OnClick = CB_ActiveClick
    end
    object RunHourPanel: TPanel
      Left = 266
      Top = 7
      Width = 131
      Height = 26
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      Visible = False
    end
    object AutoStartCheck: TCheckBox
      Left = 16
      Top = 0
      Width = 244
      Height = 17
      Caption = 'Auto start after 1 minute'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = AutoStartCheckClick
    end
  end
  object Protocol: TMemo
    Left = 0
    Top = 41
    Width = 451
    Height = 81
    Align = alClient
    Color = clWhite
    ImeName = 'Microsoft Office IME 2007'
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 122
    Width = 451
    Height = 182
    Align = alBottom
    TabOrder = 2
    object GroupBox1: TGroupBox
      Left = 16
      Top = 1
      Width = 280
      Height = 96
      Caption = 'Save To'
      TabOrder = 0
      object CB_DBlogging: TCheckBox
        Left = 18
        Top = 16
        Width = 97
        Height = 17
        Caption = 'Database'
        TabOrder = 0
      end
      object CB_CSVlogging: TCheckBox
        Left = 18
        Top = 39
        Width = 97
        Height = 17
        Caption = 'CSV File'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object ED_csv: TEdit
        Left = 96
        Top = 62
        Width = 169
        Height = 21
        Enabled = False
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
      end
      object RB_bydate: TRadioButton
        Left = 96
        Top = 39
        Width = 65
        Height = 17
        Caption = 'By Date'
        Checked = True
        TabOrder = 3
        TabStop = True
        OnClick = RB_bydateClick
      end
      object RB_byfilename: TRadioButton
        Left = 167
        Top = 39
        Width = 82
        Height = 17
        Caption = 'By Filename'
        TabOrder = 4
        OnClick = RB_byfilenameClick
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 103
      Width = 280
      Height = 64
      Caption = 'Save Interval'
      TabOrder = 1
      object Label1: TLabel
        Left = 152
        Top = 40
        Width = 24
        Height = 13
        Caption = 'msec'
      end
      object RB_byevent: TRadioButton
        Left = 18
        Top = 16
        Width = 113
        Height = 17
        Caption = 'By Event'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = RB_byeventClick
      end
      object RB_byinterval: TRadioButton
        Left = 18
        Top = 39
        Width = 113
        Height = 17
        Caption = 'By Interval'
        TabOrder = 1
        OnClick = RB_byintervalClick
      end
      object ED_interval: TEdit
        Left = 96
        Top = 37
        Width = 49
        Height = 21
        BiDiMode = bdRightToLeft
        Enabled = False
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 2
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 11
    Top = 48
    object FILE1: TMenuItem
      Caption = 'File'
      object Connect1: TMenuItem
        Caption = 'DB Connect'
        OnClick = Connect1Click
      end
      object Disconnect1: TMenuItem
        Caption = 'DB Disconnect'
        GroupIndex = 1
      end
      object N1: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object Close1: TMenuItem
        Caption = 'Close'
        GroupIndex = 1
      end
    end
    object HELP1: TMenuItem
      Caption = 'Setting'
      object Option1: TMenuItem
        Caption = 'Option'
        OnClick = Option1Click
      end
    end
    object Help2: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About'
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 80
    Top = 48
    object Actionsave1: TMenuItem
      Caption = 'Action save for Auto start'
      OnClick = Actionsave1Click
    end
    object ActionLoadFromFile1: TMenuItem
      Caption = 'Action Load From File'
      OnClick = ActionLoadFromFile1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object ShowEventName1: TMenuItem
      Caption = 'Show Event Name'
      OnClick = ShowEventName1Click
    end
    object ShowTagNameHeader1: TMenuItem
      Caption = 'Show Tag Name Header'
      OnClick = ShowTagNameHeader1Click
    end
    object ShowParamCount1: TMenuItem
      Caption = 'Show Param Count'
      OnClick = ShowParamCount1Click
    end
    object Show0thTagValue1: TMenuItem
      Caption = 'Show 0 th Tag Value'
      OnClick = Show0thTagValue1Click
    end
    object ShowEvendDataListCount1: TMenuItem
      Caption = 'Show EventDataList Count'
      OnClick = ShowEvendDataListCount1Click
    end
    object ShowEventDataListUniqName1: TMenuItem
      Caption = 'Show EventaList Uniq Name'
      OnClick = ShowEventDataListUniqName1Click
    end
    object ShowBulkMode1: TMenuItem
      Caption = 'Show BulkMode'
      OnClick = ShowBulkMode1Click
    end
    object ShowSaveInterval1: TMenuItem
      Caption = 'Show SaveInterval'
      OnClick = ShowSaveInterval1Click
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 120
    Top = 48
  end
  object OpenDialog1: TOpenDialog
    Left = 160
    Top = 48
  end
  object JvFormStorage1: TJvFormStorage
    AppStorage = JvAppIniFileStorage1
    AppStoragePath = '%FORM_NAME%\'
    Options = []
    StoredValues = <>
    Left = 200
    Top = 48
  end
  object JvAppIniFileStorage1: TJvAppIniFileStorage
    StorageOptions.BooleanStringTrueValues = 'TRUE, YES, Y'
    StorageOptions.BooleanStringFalseValues = 'FALSE, NO, N'
    DefaultSection = '%FORM_NAME%\'
    SubStorages = <>
    Left = 240
    Top = 48
  end
end
