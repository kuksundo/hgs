object FrameRulesOptions: TFrameRulesOptions
  Left = 0
  Top = 0
  Width = 404
  Height = 365
  TabOrder = 0
  OnMouseDown = HelpMouseDown
  object CategoryPanelGroup1: TCategoryPanelGroup
    Left = 0
    Top = 0
    Width = 404
    Height = 365
    VertScrollBar.Tracking = True
    Align = alClient
    ChevronColor = clCaptionText
    ChevronHotColor = clHighlight
    Color = clWindow
    GradientBaseColor = clBtnFace
    GradientColor = clWindow
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    TabOrder = 0
    object catStartup: TCategoryPanel
      Top = 256
      Height = 59
      Caption = 'Whitelist/Blacklist'
      Color = clWindow
      TabOrder = 0
      object lblBlacklistAct: TLabel
        Left = 4
        Top = 7
        Width = 74
        Height = 13
        Caption = 'Blacklist Action:'
        OnMouseDown = HelpMouseDown
      end
      object cmbBlacklistAction: TComboBox
        Left = 84
        Top = 5
        Width = 100
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 0
        Text = 'Mark as Spam'
        OnChange = OptionsChange
        OnClick = OptionsChange
        Items.Strings = (
          'Mark as Spam'
          'Delete')
      end
    end
    object catMsgDl: TCategoryPanel
      Top = 74
      Height = 182
      Caption = 'Message Download Options'
      Color = clWindow
      TabOrder = 1
      object lblGetBodyLines: TLabel
        Left = 210
        Top = 98
        Width = 21
        Height = 13
        Caption = 'lines'
      end
      object lblGetBodySize: TLabel
        Left = 232
        Top = 74
        Width = 12
        Height = 13
        Caption = 'KB'
      end
      object lblMsgDlInfo: TLabel
        Left = 8
        Top = 4
        Width = 213
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        Caption = 'These options allow more sophisticated rules'
      end
      object chkGetBody: TCheckBox
        Left = 8
        Top = 51
        Width = 387
        Height = 17
        Hint = 
          'While checking for new mail, also retrieve the message body.'#13#10'Th' +
          'is will slow down checking, but if gives you the option to check' +
          #13#10'the body contents in the rules.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Retrieve &Body while Checking'
        TabOrder = 0
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkGetBodyLines: TCheckBox
        Left = 24
        Top = 97
        Width = 141
        Height = 17
        Hint = 'Maximum number of lines to download.'
        Caption = 'Limit download to the first'
        TabOrder = 1
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkGetBodySize: TCheckBox
        Left = 24
        Top = 74
        Width = 165
        Height = 17
        Hint = 
          'Retrieve complete message while checking,'#13#10'if message smaller th' +
          'an specified size.'
        Caption = 'Only download if size less than'
        TabOrder = 2
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkRetrieveTop: TCheckBox
        Left = 8
        Top = 28
        Width = 109
        Height = 17
        Hint = 
          'When previewing a message, only load the'#13#10'specified number of li' +
          'nes.'
        Caption = '&Preview Top Lines'
        TabOrder = 3
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object edGetBodyLines: TEdit
        Left = 171
        Top = 97
        Width = 33
        Height = 21
        Hint = 'Maximum number of lines to download.'
        TabOrder = 4
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object edGetBodySize: TEdit
        Left = 193
        Top = 71
        Width = 33
        Height = 21
        Hint = 
          'Retrieve complete message while checking,'#13#10'if message smaller th' +
          'an specified size.'
        TabOrder = 5
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object edTopLines: TEdit
        Left = 123
        Top = 27
        Width = 33
        Height = 21
        Hint = 'Number of message lines to preview.'
        TabOrder = 6
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkDlForPreview: TCheckBox
        Left = 24
        Top = 117
        Width = 389
        Height = 17
        Hint = 
          'Retrieve complete message while checking,'#13#10'if message smaller th' +
          'an specified size.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Download full message on Preview'
        Enabled = False
        TabOrder = 7
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkPreferEnvelopes: TCheckBox
        Left = 8
        Top = 134
        Width = 389
        Height = 17
        Hint = 
          'Makes checking faster, but limits what headers are available for' +
          ' rule checking'
        Anchors = [akLeft, akTop, akRight]
        Caption = 
          'Download Envelopes (Partial Headers) Instead of Full Headers (IM' +
          'AP)'
        Enabled = False
        TabOrder = 8
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
    end
    object catRules: TCategoryPanel
      Top = 0
      Height = 74
      Caption = 'Rules'
      Color = clWindow
      TabOrder = 2
      object chkLogRules: TCheckBox
        Left = 8
        Top = 4
        Width = 387
        Height = 17
        Hint = 
          'Write all rules actions to a log file.'#13#10'Filename: RULES.LOG in t' +
          'he user settings directory for PopTrayU.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Log &Rules'
        TabOrder = 0
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkDeleteConfirmProtected: TCheckBox
        Left = 8
        Top = 24
        Width = 387
        Height = 17
        Hint = 
          'Extra confirmation when you try to delete messages'#13#10'protected by' +
          ' rules or the WhiteList.'
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Extra Confirmation when Deleting Protected Messages'
        TabOrder = 1
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
    end
  end
end
