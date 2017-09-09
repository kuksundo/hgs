object frameInterval: TframeInterval
  Left = 0
  Top = 0
  Width = 373
  Height = 303
  TabOrder = 0
  TabStop = True
  OnResize = FrameResize
  object CategoryPanelGroup1: TCategoryPanelGroup
    Left = 0
    Top = 0
    Width = 373
    Height = 303
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
    object catCheckActions: TCategoryPanel
      Top = 198
      Height = 100
      Caption = 'Mail Check Actions'
      Color = clWindow
      TabOrder = 0
      object lblDeleteNextCheck: TLabel
        Left = 8
        Top = 10
        Width = 219
        Height = 13
        Caption = 'When deleting messages, delete from server:'
      end
      object cmbDeleteNextCheck: TComboBox
        Left = 233
        Top = 6
        Width = 110
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 0
        Text = 'Immediately'
        OnChange = OptionsChange
        Items.Strings = (
          'Immediately'
          'On Next Mail Check')
      end
      object chkDeleteConfirm: TCheckBox
        Left = 8
        Top = 29
        Width = 358
        Height = 17
        Hint = 
          'Ask for confirmation before deleting any e-mails.'#13#10'This only wor' +
          'ks for the Delete button.  Deleting messages'#13#10'using rules will n' +
          'ot ask for confirmation.'
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Confirm Deletion'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
    end
    object catIntervalConditions: TCategoryPanel
      Top = 98
      Height = 100
      Caption = 'Automatic Mail Check Conditions'
      Color = clWindow
      TabOrder = 1
      object lblAnd: TLabel
        Left = 195
        Top = 49
        Width = 18
        Height = 13
        Alignment = taCenter
        Caption = 'and'
      end
      object chkCheckWhileMinimized: TCheckBox
        Left = 8
        Top = 27
        Width = 358
        Height = 17
        Hint = 
          'Do not run the AutoCheck timer event while viewing the PopTrayU ' +
          'Window.'#13#10'This is useful to prevent an AutoCheck from happening'#13#10 +
          'while you are manually checking for mail.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Only while &Minimized'
        TabOrder = 0
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object chkDontCheckTimes: TCheckBox
        Left = 8
        Top = 47
        Width = 153
        Height = 17
        Hint = 
          'Disable AutoChecking between the hours specified.'#13#10'This is usefu' +
          'l when you do not want noisy notifications'#13#10'during the night.'
        Caption = '&Don'#39't Check between'
        TabOrder = 1
        OnClick = chkDontCheckTimesClick
        OnMouseDown = HelpMouseDown
      end
      object chkOnline: TCheckBox
        Left = 8
        Top = 6
        Width = 358
        Height = 17
        Hint = 
          'Used by dial-up users who don'#39't want the dial-up dialog'#13#10'to pop-' +
          'up when you are not connected.'#13#10'Makes checking a little bit slow' +
          'er.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Only when already online'
        TabOrder = 2
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object dtEnd: TDateTimePicker
        Left = 220
        Top = 45
        Width = 67
        Height = 21
        Date = 37759.333333333340000000
        Format = 'HH:mm'
        Time = 37759.333333333340000000
        Enabled = False
        Kind = dtkTime
        TabOrder = 3
        OnChange = OptionsChange
      end
      object dtStart: TDateTimePicker
        Left = 127
        Top = 45
        Width = 62
        Height = 21
        Date = 37759.833333333340000000
        Format = 'HH:mm'
        Time = 37759.833333333340000000
        Enabled = False
        Kind = dtkTime
        TabOrder = 4
        OnChange = OptionsChange
      end
    end
    object catMailCheckFreq: TCategoryPanel
      Top = 0
      Height = 98
      Caption = 'Mail Check Frequency'
      Color = clWindow
      TabOrder = 2
      object lblMinutes: TLabel
        Left = 204
        Top = 9
        Width = 41
        Height = 13
        Caption = 'minutes.'
      end
      object edTime: TEdit
        Left = 154
        Top = 6
        Width = 29
        Height = 21
        Hint = 
          'Delay in minutes to wait between mail check intervals.'#13#10'Set it t' +
          'o 0 to never automatically check.'
        TabOrder = 0
        Text = '0'
        OnChange = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object radioCheckEvery: TRadioButton
        Left = 8
        Top = 7
        Width = 140
        Height = 17
        Caption = 'C&heck for new mail every'
        TabOrder = 1
        OnClick = OptionsChange
      end
      object radioNever: TRadioButton
        Left = 8
        Top = 27
        Width = 358
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Don'#39't automatically check for new messages'
        TabOrder = 2
        OnClick = radioNeverClick
      end
      object radioTimerAccount: TRadioButton
        Left = 8
        Top = 47
        Width = 358
        Height = 17
        Hint = 'Specify a different timer interval for each account.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Set &Frequency per account'
        TabOrder = 3
        OnClick = OptionsChange
        OnMouseDown = HelpMouseDown
      end
      object UpDown: TUpDown
        Left = 181
        Top = 6
        Width = 17
        Height = 21
        Max = 999
        TabOrder = 4
        OnClick = UpDownClick
        OnMouseDown = HelpMouseDown
      end
    end
  end
end
