object AlarmConfigF: TAlarmConfigF
  Left = 0
  Top = 0
  Caption = 'Alarm Config'
  ClientHeight = 405
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 421
    Height = 364
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
        413
        333)
      object Label1: TLabel
        Left = 35
        Top = 80
        Width = 108
        Height = 16
        Caption = 'Run Condition File:'
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
        Left = 82
        Top = 49
        Width = 61
        Height = 16
        Caption = 'Items File:'
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
      object RunCondFileEdit: TJvFilenameEdit
        Left = 149
        Top = 77
        Width = 204
        Height = 24
        Hint = 'File;Run Condition File Name'
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
        Hint = 'File;Items File Name'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
        Text = ''
      end
      object RelPathCB: TCheckBox
        Left = 184
        Top = 64
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
    object TabSheet5: TTabSheet
      Caption = 'MQ Server'
      ImageIndex = 5
      object Label14: TLabel
        Left = 72
        Top = 64
        Width = 58
        Height = 16
        Caption = 'Port Num:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label15: TLabel
        Left = 56
        Top = 24
        Width = 66
        Height = 16
        Caption = 'IP Address:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label16: TLabel
        Left = 256
        Top = 64
        Width = 42
        Height = 16
        Caption = 'STOMP'
      end
      object Label24: TLabel
        Left = 77
        Top = 101
        Width = 47
        Height = 16
        Caption = 'User ID:'
      end
      object Label17: TLabel
        Left = 84
        Top = 139
        Width = 48
        Height = 16
        Caption = 'Passwd:'
      end
      object Label18: TLabel
        Left = 28
        Top = 178
        Width = 96
        Height = 16
        Caption = 'Subscribe Topic:'
      end
      object MQIPAddress: TJvIPAddress
        Left = 140
        Top = 23
        Width = 150
        Height = 24
        Hint = 'MQ Server;MQ Server IP'
        Address = 168695157
        ParentColor = False
        TabOrder = 0
      end
      object MQPortEdit: TEdit
        Left = 140
        Top = 60
        Width = 111
        Height = 24
        Hint = 'MQ Server;MQ Server Port'
        Alignment = taRightJustify
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 1
        Text = '61613'
      end
      object MQUserEdit: TEdit
        Left = 140
        Top = 98
        Width = 187
        Height = 24
        Hint = 'MQ Server;MQ Server UserId'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
      end
      object MQPasswdEdit: TEdit
        Left = 140
        Top = 136
        Width = 187
        Height = 24
        Hint = 'MQ Server;MQ Server Passwd'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
      end
      object MQTopicLB: TListBox
        Left = 139
        Top = 175
        Width = 222
        Height = 91
        MultiSelect = True
        TabOrder = 4
        Visible = False
      end
      object Button1: TButton
        Left = 134
        Top = 272
        Width = 100
        Height = 25
        Caption = 'Add Topic'
        TabOrder = 5
        Visible = False
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 134
        Top = 303
        Width = 100
        Height = 25
        Caption = 'Delete Topic'
        TabOrder = 6
        Visible = False
        OnClick = Button2Click
      end
      object Edit3: TEdit
        Left = 240
        Top = 272
        Width = 121
        Height = 24
        TabOrder = 7
        Visible = False
      end
      object MQTopicEdit: TEdit
        Left = 140
        Top = 175
        Width = 187
        Height = 24
        Hint = 'MQ Server;MQ Server Topic'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 8
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Etc.'
      ImageIndex = 3
      object Label4: TLabel
        Left = 24
        Top = 140
        Width = 190
        Height = 16
        Caption = 'Get Item Value From DB Interval:'
      end
      object Label5: TLabel
        Left = 311
        Top = 142
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
      object Label11: TLabel
        Left = 147
        Top = 177
        Width = 67
        Height = 16
        Caption = 'My Port No:'
      end
      object ConfigSourceRG: TRadioGroup
        Left = 62
        Top = 16
        Width = 185
        Height = 97
        Caption = 'Config Source'
        ItemIndex = 0
        Items.Strings = (
          'From Alarm Config'
          'From Engine Parameter')
        TabOrder = 0
        OnClick = ConfigSourceRGClick
      end
      object ConfigSourceEdit: TEdit
        Left = 253
        Top = 32
        Width = 108
        Height = 24
        Hint = 'Etc;Config Source'
        ImeName = 'Microsoft IME 2010'
        TabOrder = 1
        Text = 'Config Source '#49440#53469' '#44050#51012' '#51200#51109#54632
        Visible = False
      end
      object ItemValueSelectInterval: TEdit
        Left = 216
        Top = 136
        Width = 89
        Height = 24
        Hint = 'Etc;Item Value Select Interval From DB'
        Alignment = taRightJustify
        TabOrder = 2
        Text = '1000'
      end
      object MyPortNoEdit: TEdit
        Left = 216
        Top = 175
        Width = 89
        Height = 24
        Hint = 'Etc;My Port No'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
      end
    end
    object AlarmConditionSheet: TTabSheet
      Caption = 'Run Condition'
      ImageIndex = 4
      object AdvGroupBox1: TAdvGroupBox
        Left = 0
        Top = 0
        Width = 413
        Height = 333
        CaptionPosition = cpTopCenter
        Align = alClient
        Caption = 'Engine Run Condition List'
        TabOrder = 0
        object RunConditionGrid: TNextGrid
          Left = 2
          Top = 19
          Width = 409
          Height = 312
          Touch.InteractiveGestures = [igPan, igPressAndTap]
          Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
          Align = alClient
          Caption = ''
          TabOrder = 0
          TabStop = True
          OnSelectCell = RunConditionGridSelectCell
          object ProjNo: TNxTextColumn
            Alignment = taCenter
            DefaultWidth = 100
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = 'Proj No.'
            Header.Alignment = taCenter
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'Tahoma'
            Header.Font.Style = []
            Options = [coCanClick, coCanInput, coPublicUsing, coShowTextFitHint]
            ParentFont = False
            Position = 0
            SortType = stAlphabetic
            Width = 100
          end
          object EngNo: TNxTextColumn
            Alignment = taCenter
            DefaultWidth = 30
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = 'Eng No.'
            Header.Alignment = taCenter
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'Tahoma'
            Header.Font.Style = []
            Options = [coCanClick, coCanInput, coPublicUsing, coShowTextFitHint]
            ParentFont = False
            Position = 1
            SortType = stAlphabetic
            Width = 30
          end
          object TagDesc: TNxTextColumn
            DefaultWidth = 200
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = 'Tag Desc'
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'Tahoma'
            Header.Font.Style = []
            Options = [coCanClick, coCanInput, coPublicUsing, coShowTextFitHint]
            ParentFont = False
            Position = 2
            SortType = stAlphabetic
            Width = 200
          end
          object BtnCol: TNxImageColumn
            Alignment = taCenter
            DefaultValue = '0'
            DefaultWidth = 30
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'Tahoma'
            Header.Font.Style = []
            Options = [coCanClick, coCanInput, coPublicUsing]
            ParentFont = False
            Position = 3
            SortType = stNumeric
            Width = 30
            Images = FormAlarmList.ImageList16x16
          end
          object TagName: TNxTextColumn
            DefaultWidth = 200
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = 'Tag Name'
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'Tahoma'
            Header.Font.Style = []
            Options = [coCanClick, coCanInput, coEditing, coPublicUsing, coShowTextFitHint]
            ParentFont = False
            Position = 4
            SortType = stAlphabetic
            Visible = False
            Width = 200
          end
          object ParamIndex: TNxTextColumn
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = 'ParamIndex'
            Header.Alignment = taCenter
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'Tahoma'
            Header.Font.Style = []
            ParentFont = False
            Position = 5
            SortType = stAlphabetic
            Visible = False
          end
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 364
    Width = 421
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
