object frameMainWindowOptions: TframeMainWindowOptions
  Left = 0
  Top = 0
  Width = 357
  Height = 533
  TabOrder = 0
  OnResize = FrameResize
  object CategoryPanelGroup1: TCategoryPanelGroup
    Left = 0
    Top = 0
    Width = 357
    Height = 533
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
    object catMinimize: TCategoryPanel
      Top = 405
      Height = 100
      Caption = 'Minimize Window Options'
      Color = clWindow
      TabOrder = 0
      object chkCloseMinimize: TCheckBox
        Left = 6
        Top = 6
        Width = 341
        Height = 17
        Hint = 
          'The X close button in the top right-hand corner will minimize'#13#10'P' +
          'opTrayU instead of closing it.'#13#10'To close use the "Quit" button.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'X &Button Minimizes'
        TabOrder = 0
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkMinimizeTray: TCheckBox
        Left = 6
        Top = 26
        Width = 341
        Height = 17
        Hint = 'Minimize PopTrayU to the System Tray instead of the Taskbar.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Minimi&ze to Tray'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkAutoClosePreviewWindows: TCheckBox
        Left = 6
        Top = 46
        Width = 341
        Height = 17
        Hint = 
          'Closes any open message preview windows when '#39'to tray'#39' is presse' +
          'd'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Auto-close Preview Windows'
        TabOrder = 2
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
    end
    object catBehaviors: TCategoryPanel
      Top = 200
      Height = 205
      Caption = 'Main Window Behaviors'
      Color = clWindow
      TabOrder = 1
      object lblErrorDisp: TLabel
        Left = 6
        Top = 98
        Width = 65
        Height = 13
        Caption = 'Error Display:'
      end
      object lblDefaultSpamAct: TLabel
        Left = 6
        Top = 134
        Width = 175
        Height = 13
        Hint = 'Changes the action of the Spam toolbar button on the Main Window'
        Caption = 'Default Spam Toolbar Button Action:'
      end
      object chkDoubleClickDelay: TCheckBox
        Left = 6
        Top = 51
        Width = 341
        Height = 17
        Hint = 
          'Delay on a SingleClick to wait and see if a DoubleClick is comin' +
          'g.'
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Double Click delay on Click'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkMultilineAccounts: TCheckBox
        Left = 6
        Top = 31
        Width = 341
        Height = 17
        Hint = 
          'Display the tabs for the different accounts in'#13#10'multiple lines i' +
          'nstead of one scrolling line.'
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Multi-line Account Tabs'
        TabOrder = 1
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkOnTop: TCheckBox
        Left = 6
        Top = 8
        Width = 341
        Height = 17
        Hint = 'Show the PopTrayU window always on top of other windows.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Stay on &Top'
        TabOrder = 2
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkPasswordProtect: TCheckBox
        Left = 6
        Top = 71
        Width = 145
        Height = 17
        Hint = 'Requires that you enter the specified password to open PopTrayU.'
        Caption = '&Password Protect'
        TabOrder = 3
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object cmbErrorDisplay: TComboBox
        Left = 77
        Top = 96
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 4
        Text = 'Balloon Popup'
        OnChange = OptionsChange
        Items.Strings = (
          'Balloon Popup'
          'Modal Dialog'
          'Show in Statusbar')
      end
      object cmbSpamAct: TComboBox
        Left = 187
        Top = 134
        Width = 109
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 5
        Text = 'None'
        OnChange = OptionsChange
        Items.Strings = (
          'None'
          'Delete Spam'
          'Mark as Spam')
      end
      object edPassword: TEdit
        Left = 112
        Top = 69
        Width = 69
        Height = 21
        PasswordChar = '*'
        TabOrder = 6
        OnChange = OptionsChange
      end
    end
    object catMsgList: TCategoryPanel
      Top = 0
      Caption = 'Main Window Message List'
      Color = clWindow
      TabOrder = 2
      object lblDateExample: TLabel
        Left = 254
        Top = 87
        Width = 63
        Height = 13
        Caption = 'Current Date'
        Enabled = False
      end
      object lblNumMsgs: TLabel
        Left = 23
        Top = 132
        Width = 104
        Height = 13
        Caption = 'Number of Messages:'
        Enabled = False
      end
      object chkDateFormat: TCheckBox
        Left = 6
        Top = 86
        Width = 138
        Height = 17
        Hint = 
          'Changes the appearance of Date/Time for emails in the Main Windo' +
          'w message list.'
        Caption = 'Use &Custom Date Format'
        TabOrder = 0
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkHideViewed: TCheckBox
        Left = 6
        Top = 46
        Width = 341
        Height = 17
        Hint = 'Once a message has been viewed, don'#39't show it again.'
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Hide Viewed Messages'
        TabOrder = 1
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkLimitInboxSize: TCheckBox
        Left = 6
        Top = 109
        Width = 341
        Height = 17
        Hint = 'Only the newest emails will be shown if this option is selected.'
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Limit Inbox Size'
        TabOrder = 2
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkRememberViewed: TCheckBox
        Left = 6
        Top = 26
        Width = 341
        Height = 17
        Hint = 
          'Remember which messages on the server has already been viewed'#13#10'e' +
          'ven after closing PopTrayU.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Remember &Viewed Messages for POP Accounts'
        TabOrder = 3
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkShowViewed: TCheckBox
        Left = 6
        Top = 6
        Width = 341
        Height = 17
        Hint = 'Unviewed messages will be shown in Bold.'
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Indicate Viewed and Unviewed Messages'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 4
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkShowWhileChecking: TCheckBox
        Left = 6
        Top = 66
        Width = 341
        Height = 17
        Hint = 'While checking, show each message as it is downloaded.'
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Show Messages while Checking'
        TabOrder = 5
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object cmbInboxSize: TComboBox
        Left = 133
        Top = 129
        Width = 59
        Height = 21
        Enabled = False
        TabOrder = 6
        Text = '100'
        OnChange = cmbInboxSizeChange
        OnExit = cmbInboxSizeExit
        Items.Strings = (
          '10'
          '50'
          '100'
          '250'
          '500')
      end
      object edDateFormat: TEdit
        Left = 150
        Top = 84
        Width = 98
        Height = 21
        Hint = 'See help file for date/time format codes.'
        Enabled = False
        HideSelection = False
        TabOrder = 7
        Text = 'm/d h:mma/p'
        OnChange = OptionsChange
      end
    end
  end
end
