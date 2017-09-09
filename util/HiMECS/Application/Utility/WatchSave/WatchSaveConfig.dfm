object WatchSaveConfigF: TWatchSaveConfigF
  Left = 143
  Top = 244
  Caption = 'Configuration'
  ClientHeight = 393
  ClientWidth = 398
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 352
    Width = 398
    Height = 41
    Align = alBottom
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 74
      Top = 6
      Width = 75
      Height = 25
      Caption = #54869' '#51064
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 224
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
    Width = 398
    Height = 352
    ActivePage = TabSheet1
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #44404#47548#52404
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Etc.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ImageIndex = 1
      ParentFont = False
      object Label10: TLabel
        Left = 70
        Top = 29
        Width = 113
        Height = 19
        Caption = 'Average Size:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 87
        Top = 65
        Width = 96
        Height = 19
        Caption = 'Split Count:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label14: TLabel
        Left = 238
        Top = 154
        Width = 71
        Height = 19
        Caption = 'Interval:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 24
        Top = 90
        Width = 258
        Height = 19
        Caption = '(Must use Save to By FileName)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object AvgEdit: TEdit
        Left = 191
        Top = 27
        Width = 41
        Height = 27
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        TabOrder = 0
      end
      object SplitEdit: TEdit
        Left = 191
        Top = 62
        Width = 91
        Height = 27
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        TabOrder = 1
      end
      object IntervalRG: TRadioGroup
        Left = 24
        Top = 132
        Width = 208
        Height = 46
        Caption = 'Display Value Interval'
        Columns = 2
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Items.Strings = (
          'By Event'
          'By Timer')
        ParentFont = False
        TabOrder = 2
        OnClick = IntervalRGClick
      end
      object IntervalEdit: TEdit
        Left = 315
        Top = 151
        Width = 41
        Height = 27
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        TabOrder = 3
      end
      object InitialCB: TCheckBox
        Left = 32
        Top = 192
        Width = 277
        Height = 17
        Caption = 'Initialize File Index Number when Start'
        TabOrder = 4
      end
      object InitialEdit: TEdit
        Left = 32
        Top = 215
        Width = 89
        Height = 27
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        TabOrder = 5
      end
    end
    object TabSheet3: TTabSheet
      Caption = ' File'
      ImageIndex = 2
      object Label1: TLabel
        Left = 16
        Top = 21
        Width = 112
        Height = 13
        Caption = 'Param File Name:'
      end
      object MapFilenameEdit: TJvFilenameEdit
        Left = 16
        Top = 40
        Width = 345
        Height = 21
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 0
        Text = ''
      end
      object ConfFileFormatRG: TRadioGroup
        Left = 16
        Top = 78
        Width = 143
        Height = 57
        Caption = 'Param File Format'
        Columns = 2
        Items.Strings = (
          'XML'
          'JSON')
        TabOrder = 1
      end
      object EngParamEncryptCB: TCheckBox
        Left = 165
        Top = 91
        Width = 159
        Height = 17
        Caption = 'Parameter File Encrypt'
        TabOrder = 2
      end
      object MonDataFromRG: TRadioGroup
        Left = 16
        Top = 141
        Width = 208
        Height = 46
        Caption = 'Monitoring Data Source'
        Columns = 3
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          'By IPC'
          'By DB'
          'By MQ')
        ParentFont = False
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'MQ Server'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label21: TLabel
        Left = 72
        Top = 56
        Width = 63
        Height = 13
        Caption = 'Port Num:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label22: TLabel
        Left = 56
        Top = 16
        Width = 77
        Height = 13
        Caption = 'IP Address:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label23: TLabel
        Left = 256
        Top = 56
        Width = 35
        Height = 13
        Caption = 'STOMP'
      end
      object Label24: TLabel
        Left = 77
        Top = 93
        Width = 56
        Height = 13
        Caption = 'User ID:'
      end
      object Label25: TLabel
        Left = 84
        Top = 131
        Width = 49
        Height = 13
        Caption = 'Passwd:'
      end
      object Label26: TLabel
        Left = 21
        Top = 170
        Width = 112
        Height = 13
        Caption = 'Subscribe Topic:'
      end
      object MQIPAddress: TJvIPAddress
        Left = 140
        Top = 15
        Width = 150
        Height = 24
        Hint = 'MQ Server;MQ Server IP'
        Address = 168695157
        ParentColor = False
        TabOrder = 0
      end
      object MQPortEdit: TEdit
        Left = 140
        Top = 52
        Width = 111
        Height = 21
        Hint = 'MQ Server;MQ Server Port'
        Alignment = taRightJustify
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 1
        Text = '61613'
      end
      object MQUserEdit: TEdit
        Left = 140
        Top = 90
        Width = 187
        Height = 21
        Hint = 'MQ Server;MQ Server UserId'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
      end
      object MQPasswdEdit: TEdit
        Left = 140
        Top = 128
        Width = 187
        Height = 21
        Hint = 'MQ Server;MQ Server Passwd'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
      end
      object MQTopicLB: TListBox
        Left = 139
        Top = 159
        Width = 222
        Height = 91
        ImeName = 'Microsoft IME 2010'
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 4
      end
      object Button1: TButton
        Left = 140
        Top = 256
        Width = 100
        Height = 25
        Caption = 'Add Topic'
        TabOrder = 5
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 140
        Top = 287
        Width = 100
        Height = 25
        Caption = 'Delete Topic'
        TabOrder = 6
        OnClick = Button2Click
      end
      object Edit1: TEdit
        Left = 246
        Top = 258
        Width = 121
        Height = 21
        ImeName = 'Microsoft IME 2010'
        TabOrder = 7
      end
    end
  end
end
