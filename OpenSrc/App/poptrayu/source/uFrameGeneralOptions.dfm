object frameGeneralOptions: TframeGeneralOptions
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  AutoSize = True
  TabOrder = 0
  OnResize = FrameResize
  object CategoryPanelGroup1: TCategoryPanelGroup
    Left = 0
    Top = 0
    Width = 451
    Height = 304
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
    object catNotification: TCategoryPanel
      Top = 184
      Height = 153
      Caption = 'New Message Notification'
      Color = clWindow
      TabOrder = 0
      object lblAdvInfoDelay: TLabel
        Left = 237
        Top = 45
        Width = 43
        Height = 13
        Caption = 'seconds)'
      end
      object lblAdvInfoShowFor: TLabel
        Left = 146
        Top = 45
        Width = 46
        Height = 13
        Caption = '(show for'
      end
      object chkAnimated: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 490
        Height = 12
        Hint = 
          'Animate the Tray Icon when you receive new mail.'#13#10'This will prod' +
          'uce a flashing indicator instead of the normal static one.'
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Flash Tray Icon'
        TabOrder = 0
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkBalloon: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 24
        Width = 490
        Height = 12
        Hint = 'Show Info Balloon or Advanced Info when new mail arrives.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Show &Balloon Notification'
        TabOrder = 1
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkDeluxeBalloon: TCheckBox
        Left = 30
        Top = 44
        Width = 120
        Height = 17
        Hint = 'Show Info dialog with message details and buttons.'
        Caption = 'Use &Deluxe Balloon'
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkShowForm: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 64
        Width = 490
        Height = 12
        Hint = 'Show the PopTrayU window when new mail arrives.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Show Main Window'
        TabOrder = 3
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object edAdvInfoDelay: TEdit
        Left = 198
        Top = 42
        Width = 33
        Height = 21
        Hint = 'Number of seconds to display the Info window'#13#10'before closing it.'
        TabOrder = 4
        OnChange = OptionsChange
        OnMouseDown = HelpMouseDown
      end
    end
    object catTrayIcon: TCategoryPanel
      Top = 91
      Height = 93
      Caption = 'Tray Icon'
      Color = clWindow
      TabOrder = 1
      object lblTrayIcon: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 43
        Width = 123
        Height = 13
        Hint = 'What to show on the TrayIcon'#13#10'while checking for new mail.'
        Caption = 'Tray Icon while Checking:'
        OnMouseDown = HelpMouseDown
      end
      object chkResetTray: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 22
        Width = 388
        Height = 12
        Hint = 
          'Reset the Tray Icon message count when you view the PopTrayU'#13#10'wi' +
          'ndow.  When new mail arrives only the new count since last '#13#10'vie' +
          'w will be shown.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Reset Mail Count in Tra&y when Viewing'
        TabOrder = 0
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkRotateIcon: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 388
        Height = 12
        Hint = 'Rotate Icon to show messages in each account'
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Rotate Icon for each Account'
        TabOrder = 1
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object cmbCheckingIcon: TComboBox
        Left = 130
        Top = 40
        Width = 109
        Height = 21
        Style = csDropDownList
        ItemIndex = 3
        TabOrder = 2
        Text = 'Animated Star'
        OnChange = OptionsChange
        Items.Strings = (
          'None'
          'Lightning Bolt'
          'Star'
          'Animated Star')
      end
    end
    object catStartup: TCategoryPanel
      Top = 0
      Height = 91
      Caption = 'Startup'
      Color = clWindow
      TabOrder = 2
      StyleElements = [seFont, seClient]
      object lblFirstWait: TLabel
        Left = 31
        Top = 22
        Width = 46
        Height = 13
        Margins.Top = 0
        Anchors = [akTop]
        Caption = 'First Wait'
        ExplicitLeft = 28
      end
      object lblSeconds: TLabel
        Left = 119
        Top = 22
        Width = 39
        Height = 13
        Anchors = [akTop]
        Caption = 'seconds'
        ExplicitLeft = 111
      end
      object chkMinimized: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 45
        Width = 490
        Height = 12
        Hint = 
          'PopTrayU will startup in minimized state.'#13#10'Thus the window will ' +
          'be hidden and only the trayicon'#13#10'will be visible.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Start &Minimized'
        Color = clBtnFace
        Ctl3D = True
        ParentColor = False
        ParentCtl3D = False
        TabOrder = 0
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkStartUp: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 490
        Height = 12
        Hint = 'Immediately check for mail when PopTrayU starts.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Check for New Mail on Start&up'
        TabOrder = 1
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object edFirstWait: TEdit
        Left = 81
        Top = 20
        Width = 29
        Height = 21
        Hint = 
          'When starting PopTrayU, first wait a few seconds'#13#10'before checkin' +
          'g for mail.'
        Anchors = [akTop]
        ParentColor = True
        TabOrder = 2
        Text = '0'
        OnChange = OptionsChange
        OnMouseDown = HelpMouseDown
      end
    end
  end
end
