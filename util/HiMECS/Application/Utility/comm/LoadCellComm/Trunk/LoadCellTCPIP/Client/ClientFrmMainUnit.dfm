object ClientFrmMain: TClientFrmMain
  Left = 192
  Top = 217
  Width = 366
  Height = 289
  Caption = 'ClientFrmMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnDestroy = FormDestroy
  DesignSize = (
    358
    243)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 28
    Width = 95
    Height = 13
    Caption = 'incoming messages:'
  end
  object Label4: TLabel
    Left = 156
    Top = 156
    Width = 101
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Recipient (empty=all):'
  end
  object Label2: TLabel
    Left = 4
    Top = 156
    Width = 50
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Command:'
  end
  object Label3: TLabel
    Left = 4
    Top = 200
    Width = 46
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Message:'
  end
  object Label5: TLabel
    Left = 144
    Top = 8
    Width = 42
    Height = 13
    Caption = 'Local IP:'
  end
  object Label6: TLabel
    Left = 144
    Top = 24
    Width = 38
    Height = 13
    Caption = 'Host IP:'
  end
  object Label7: TLabel
    Left = 192
    Top = 8
    Width = 93
    Height = 13
    Caption = '                               '
  end
  object Label8: TLabel
    Left = 186
    Top = 24
    Width = 93
    Height = 13
    Caption = '                               '
  end
  object Label9: TLabel
    Left = 280
    Top = 24
    Width = 22
    Height = 13
    Caption = 'Port:'
  end
  object Label10: TLabel
    Left = 304
    Top = 25
    Width = 45
    Height = 13
    Caption = '               '
  end
  object CBClientActive: TCheckBox
    Left = 4
    Top = 4
    Width = 65
    Height = 17
    Caption = 'active'
    TabOrder = 0
    OnClick = CBClientActiveClick
  end
  object IncomingMessages: TMemo
    Left = 4
    Top = 44
    Width = 349
    Height = 125
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object EditCommand: TComboBox
    Left = 4
    Top = 172
    Width = 149
    Height = 21
    Anchors = [akLeft, akBottom]
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ItemHeight = 13
    TabOrder = 2
    Text = 'MESSAGE'
    Items.Strings = (
      'MESSAGE'
      'DIALOG'
      '<custom>')
  end
  object EditRecipient: TEdit
    Left = 156
    Top = 172
    Width = 197
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    TabOrder = 3
  end
  object EditMessage: TEdit
    Left = 4
    Top = 216
    Width = 279
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    TabOrder = 4
  end
  object ButtonSend: TButton
    Left = 286
    Top = 216
    Width = 67
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'Send'
    Enabled = False
    TabOrder = 5
  end
  object Client: TIdTCPClient
    MaxLineAction = maException
    ReadTimeout = 47110
    Port = 0
    Left = 96
    Top = 48
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 56
    Top = 56
  end
  object MainMenu1: TMainMenu
    Left = 128
    Top = 48
    object N1: TMenuItem
      Caption = #49444#51221
      object N2: TMenuItem
        Caption = #54252#53944#49444#51221
        OnClick = N2Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Caption = #51333#47308
        OnClick = N4Click
      end
    end
  end
end
