object ClientFrmMain: TClientFrmMain
  Left = 191
  Top = 228
  Width = 352
  Height = 290
  Caption = 'ClientFrmMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    344
    263)
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
    Top = 176
    Width = 101
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Recipient (empty=all):'
  end
  object Label2: TLabel
    Left = 4
    Top = 176
    Width = 50
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Command:'
  end
  object Label3: TLabel
    Left = 4
    Top = 220
    Width = 46
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Message:'
  end
  object CBClientActive: TCheckBox
    Left = 4
    Top = 4
    Width = 65
    Height = 17
    Caption = 'active'
    TabOrder = 0
  end
  object IncomingMessages: TMemo
    Left = 4
    Top = 44
    Width = 335
    Height = 125
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ParentFont = False
    TabOrder = 1
  end
  object EditCommand: TComboBox
    Left = 4
    Top = 192
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
    Top = 192
    Width = 183
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    TabOrder = 3
  end
  object EditMessage: TEdit
    Left = 4
    Top = 236
    Width = 265
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    TabOrder = 4
  end
  object ButtonSend: TButton
    Left = 272
    Top = 236
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
end
