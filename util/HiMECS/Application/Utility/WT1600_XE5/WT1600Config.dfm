object WT1600ConfigF: TWT1600ConfigF
  Left = 231
  Top = 114
  Caption = 'WT1600ConfigF'
  ClientHeight = 327
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 356
    Height = 286
    ActivePage = Tabsheet2
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Tabsheet2: TTabSheet
      Caption = 'Comm. Configuration'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      object Label1: TLabel
        Left = 53
        Top = 135
        Width = 81
        Height = 16
        Caption = 'Send Interval:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label2: TLabel
        Left = 23
        Top = 159
        Width = 111
        Height = 16
        Caption = 'Response Timeout:'
      end
      object Label3: TLabel
        Left = 265
        Top = 135
        Width = 32
        Height = 16
        Caption = 'mSec'
        ParentShowHint = False
        ShowHint = False
      end
      object Label4: TLabel
        Left = 266
        Top = 159
        Width = 32
        Height = 16
        Caption = 'mSec'
      end
      object Label5: TLabel
        Left = 17
        Top = 184
        Width = 117
        Height = 16
        Caption = 'Max Ping Fail Count:'
      end
      object ModbusModeRG: TRadioGroup
        Left = 23
        Top = 66
        Width = 233
        Height = 57
        Caption = 'Comm Mode'
        ItemIndex = 0
        Items.Strings = (
          'ACSII Mode'
          'Numeric Mode')
        TabOrder = 0
      end
      object QueryIntervalEdit: TEdit
        Left = 141
        Top = 131
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 1
      end
      object ResponseWaitTimeOutEdit: TEdit
        Left = 141
        Top = 156
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 2
      end
      object ModelSelectRG: TRadioGroup
        Left = 23
        Top = 3
        Width = 233
        Height = 57
        Caption = 'Model Select'
        ItemIndex = 0
        Items.Strings = (
          'WT500'
          'WT1600')
        TabOrder = 3
      end
      object MaxPingFailEdit: TEdit
        Left = 141
        Top = 181
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 4
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Parameter'
      ImageIndex = 1
      object Label16: TLabel
        Left = 12
        Top = 147
        Width = 111
        Height = 16
        Caption = 'IPC Shared Name:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label6: TLabel
        Left = 12
        Top = 27
        Width = 128
        Height = 16
        Caption = 'Parameter File Name'
        ParentShowHint = False
        ShowHint = False
      end
      object Label7: TLabel
        Left = 22
        Top = 187
        Width = 101
        Height = 16
        Caption = 'Display Caption::'
        ParentShowHint = False
        ShowHint = False
      end
      object SharedNameEdit: TComboBox
        Left = 129
        Top = 144
        Width = 177
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object ParaFilenameEdit: TJvFilenameEdit
        Left = 12
        Top = 46
        Width = 286
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 1
        Text = ''
      end
      object ConfFileFormatRG: TRadioGroup
        Left = 12
        Top = 76
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
        Left = 161
        Top = 89
        Width = 159
        Height = 17
        Caption = 'Parameter File Encrypt'
        TabOrder = 3
      end
      object DisplayEdit: TEdit
        Left = 129
        Top = 184
        Width = 177
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 4
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'MQ Server'
      ImageIndex = 2
      object MQServerEnable: TAdvGroupBox
        Left = 0
        Top = 0
        Width = 348
        Height = 255
        CaptionPosition = cpTopCenter
        CheckBox.Visible = True
        Align = alClient
        Caption = 'MQServerEnable'
        TabOrder = 0
        ExplicitWidth = 342
        ExplicitHeight = 263
        object Label11: TLabel
          Left = 27
          Top = 119
          Width = 99
          Height = 16
          Caption = 'Bind IP Address:'
          ParentShowHint = False
          ShowHint = False
        end
        object Label10: TLabel
          Left = 68
          Top = 79
          Width = 58
          Height = 16
          Caption = 'Port Num:'
          ParentShowHint = False
          ShowHint = False
        end
        object Label9: TLabel
          Left = 57
          Top = 39
          Width = 69
          Height = 16
          Caption = 'IP Address:'
          ParentShowHint = False
          ShowHint = False
        end
        object Label17: TLabel
          Left = 248
          Top = 80
          Width = 48
          Height = 16
          Caption = 'STOMP'
        end
        object Label21: TLabel
          Left = 74
          Top = 148
          Width = 48
          Height = 16
          Caption = 'User ID:'
        end
        object Label23: TLabel
          Left = 71
          Top = 178
          Width = 51
          Height = 16
          Caption = 'Passwd:'
        end
        object Label18: TLabel
          Left = 84
          Top = 208
          Width = 38
          Height = 16
          Caption = 'Topic:'
        end
        object MQIPAddress: TJvIPAddress
          Left = 132
          Top = 39
          Width = 150
          Height = 24
          Address = 168695157
          ParentColor = False
          TabOrder = 0
        end
        object MQBindComboBox: TComboBox
          Left = 132
          Top = 116
          Width = 154
          Height = 24
          ImeName = 'Microsoft IME 2010'
          TabOrder = 1
        end
        object MQPortEdit: TEdit
          Left = 132
          Top = 76
          Width = 111
          Height = 22
          ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
          TabOrder = 2
          Text = '61613'
        end
        object MQUserEdit: TEdit
          Left = 139
          Top = 146
          Width = 187
          Height = 22
          Hint = 'Parameter;User ID'
          ImeName = 'Microsoft Office IME 2007'
          TabOrder = 3
        end
        object MQPasswdEdit: TEdit
          Left = 139
          Top = 176
          Width = 187
          Height = 22
          Hint = 'Parameter;PassWord'
          ImeName = 'Microsoft Office IME 2007'
          TabOrder = 4
        end
        object MQTopicEdit: TEdit
          Left = 139
          Top = 206
          Width = 187
          Height = 22
          Hint = 'Parameter;PassWord'
          ImeName = 'Microsoft Office IME 2007'
          TabOrder = 5
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 286
    Width = 356
    Height = 41
    Align = alBottom
    TabOrder = 1
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
      Left = 207
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
