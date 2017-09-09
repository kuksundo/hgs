object ConfigF: TConfigF
  Left = 0
  Top = 0
  Caption = 'Configuration'
  ClientHeight = 368
  ClientWidth = 378
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
  object Panel1: TPanel
    Left = 0
    Top = 327
    Width = 378
    Height = 41
    Align = alBottom
    TabOrder = 0
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
      Left = 225
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
    Width = 378
    Height = 327
    ActivePage = MQServerTS
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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object MQServerTS: TTabSheet
      Caption = 'MQ Server'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label11: TLabel
        Left = 35
        Top = 255
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
        Left = 67
        Top = 116
        Width = 48
        Height = 16
        Caption = 'User ID:'
      end
      object Label23: TLabel
        Left = 64
        Top = 146
        Width = 51
        Height = 16
        Caption = 'Passwd:'
      end
      object Label18: TLabel
        Left = 77
        Top = 176
        Width = 38
        Height = 16
        Caption = 'Topic:'
      end
      object MQIPAddress: TJvIPAddress
        Left = 132
        Top = 39
        Width = 150
        Height = 24
        Hint = 'MQ Server;MQ Server IP'
        Address = 168695157
        ParentColor = False
        TabOrder = 0
      end
      object MQBindComboBox: TComboBox
        Left = 140
        Top = 252
        Width = 154
        Height = 24
        ImeName = 'Microsoft IME 2010'
        TabOrder = 1
      end
      object MQPortEdit: TEdit
        Left = 132
        Top = 76
        Width = 111
        Height = 24
        Hint = 'MQ Server;MQ Server Port'
        Alignment = taRightJustify
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 2
        Text = '61613'
      end
      object MQUserEdit: TEdit
        Left = 132
        Top = 114
        Width = 187
        Height = 24
        Hint = 'MQ Server;MQ Server UserId'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
      end
      object MQPasswdEdit: TEdit
        Left = 132
        Top = 144
        Width = 187
        Height = 24
        Hint = 'MQ Server;MQ Server Passwd'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 4
      end
      object MQTopicEdit: TEdit
        Left = 132
        Top = 174
        Width = 187
        Height = 24
        Hint = 'MQ Server;MQ Server Topic'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 5
      end
    end
    object FileTS: TTabSheet
      Caption = 'File'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label6: TLabel
        Left = 36
        Top = 16
        Width = 128
        Height = 16
        Caption = 'Parameter File Name'
        ParentShowHint = False
        ShowHint = False
      end
      object ParaFilenameEdit: TJvFilenameEdit
        Left = 36
        Top = 38
        Width = 286
        Height = 24
        Hint = 'File;Param File Name'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
        Text = ''
      end
    end
  end
end
