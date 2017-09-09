object frameAdvancedOptions: TframeAdvancedOptions
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  AutoSize = True
  TabOrder = 0
  object CategoryPanelGroup1: TCategoryPanelGroup
    Left = 0
    Top = 0
    Width = 451
    Height = 304
    VertScrollBar.Tracking = True
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
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
    object catAdvProt: TCategoryPanel
      Top = 0
      Height = 98
      Caption = 'Advanced POP/IMAP Settings'
      Color = clWindow
      TabOrder = 0
      object lblSeconds: TLabel
        Left = 154
        Top = 8
        Width = 39
        Height = 13
        Caption = 'seconds'
      end
      object lblTimeOut: TLabel
        Left = 8
        Top = 8
        Width = 99
        Height = 13
        Caption = 'Connection Timeout:'
      end
      object edTimeOut: TEdit
        Left = 110
        Top = 4
        Width = 41
        Height = 21
        Hint = 
          'Number of seconds to wait during connection'#13#10'before giving an er' +
          'ror.'
        TabOrder = 0
        OnChange = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkQuickCheck: TCheckBox
        Left = 8
        Top = 23
        Width = 373
        Height = 17
        Hint = 
          'Use the POP3 UIDL command to quickly check if the mail on the se' +
          'rver has changed.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Enable &Quick Checking'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkSafeDelete: TCheckBox
        Left = 8
        Top = 43
        Width = 373
        Height = 17
        Hint = 
          'Use the POP3 UIDL command to check that message is still the sam' +
          'e'#13#10'before deleting it.'
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Safe Delete (using UIDL)'
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
    end
    object catErrHandling: TCategoryPanel
      Top = 98
      Height = 78
      Caption = 'Error Handling'
      Color = clWindow
      TabOrder = 1
      object chkIgnoreRetrieveErrors: TCheckBox
        Left = 8
        Top = 28
        Width = 373
        Height = 17
        Hint = 'Ignore errors that occurs while retrieving the header info.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Ignore Retrie&ve Errors'
        TabOrder = 0
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkNoError: TCheckBox
        Left = 8
        Top = 4
        Width = 373
        Height = 17
        Hint = 
          'When a connect error occurs, PopTrayU will display an error mess' +
          'age.'#13#10'If this option is enabled, the error message will only be ' +
          'displayed in the status bar and Tray Hint.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Ignore Connection &Errors'
        TabOrder = 1
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
    end
    object catMailClient: TCategoryPanel
      Top = 176
      Height = 71
      Caption = 'External Mail Client'
      Color = clWindow
      TabOrder = 2
      object chkUseMAPI: TCheckBox
        Left = 8
        Top = 3
        Width = 373
        Height = 17
        Hint = 
          'Use the Simple MAPI interface of you e-mail client,'#13#10'instead of ' +
          'using a "mailto:" link for replies and new messages.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Communicate using &MAPI instead of mailto:'
        TabOrder = 0
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
    end
  end
end
