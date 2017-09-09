object PMSOPCClientF: TPMSOPCClientF
  Left = 604
  Top = 370
  ClientHeight = 463
  ClientWidth = 642
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 642
    Height = 82
    Align = alTop
    TabOrder = 0
    object Label3: TLabel
      Left = 40
      Top = 17
      Width = 86
      Height = 16
      Caption = 'OPC Server IP:'
    end
    object Label1: TLabel
      Left = 40
      Top = 51
      Width = 60
      Height = 16
      Caption = 'TagName:'
    end
    object Label2: TLabel
      Left = 308
      Top = 21
      Width = 96
      Height = 16
      Caption = 'Alarm Server IP:'
    end
    object ServerIPEdit: TEdit
      Left = 126
      Top = 14
      Width = 99
      Height = 24
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 0
      Text = '10.14.21.116'
    end
    object SearchEdit: TEdit
      Left = 104
      Top = 48
      Width = 313
      Height = 24
      ImeName = 'Microsoft IME 2010'
      TabOrder = 1
      OnKeyDown = SearchEditKeyDown
    end
    object Button4: TButton
      Left = 424
      Top = 48
      Width = 57
      Height = 25
      Caption = 'Serach'
      TabOrder = 2
      OnClick = Button4Click
    end
    object AlarmServerIPEdit: TEdit
      Left = 410
      Top = 18
      Width = 111
      Height = 24
      Alignment = taCenter
      ImeName = 'Microsoft IME 2010'
      TabOrder = 3
      Text = '10.14.21.60'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 381
    Width = 642
    Height = 55
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 153
      Top = 15
      Width = 123
      Height = 25
      Caption = 'GetTagValues'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 282
      Top = 15
      Width = 106
      Height = 25
      Caption = 'GetTagNames'
      TabOrder = 1
      OnClick = Button2Click
    end
    object QuitButton: TButton
      Left = 394
      Top = 15
      Width = 75
      Height = 25
      Caption = 'Quit'
      TabOrder = 2
      OnClick = QuitButtonClick
    end
    object Button3: TButton
      Left = 16
      Top = 16
      Width = 131
      Height = 25
      Caption = 'GetTagList'
      TabOrder = 3
      OnClick = Button3Click
    end
  end
  object TagGrid: TNextGrid
    Left = 0
    Top = 82
    Width = 642
    Height = 299
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Align = alClient
    Caption = ''
    Options = [goHeader, goIndicator, goSelectFullRow]
    PopupMenu = PopupMenu1
    TabOrder = 2
    TabStop = True
    OnCellColoring = TagGridCellColoring
    object NxIncrementColumn1: TNxIncrementColumn
      Alignment = taCenter
      DefaultWidth = 30
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'No.'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Options = [coCanClick, coPublicUsing]
      ParentFont = False
      Position = 0
      SortType = stAlphabetic
      Width = 30
    end
    object TagNameText: TNxTextColumn
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'TagName'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Options = [coCanClick, coPublicUsing, coShowTextFitHint]
      ParentFont = False
      Position = 1
      SortType = stAlphabetic
    end
    object DescriptText: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Description'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Options = [coPublicUsing, coShowTextFitHint]
      ParentFont = False
      Position = 2
      SortType = stAlphabetic
    end
    object ValueText: TNxTextColumn
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Header.Caption = 'Value'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Options = [coPublicUsing, coShowTextFitHint]
      ParentFont = False
      Position = 3
      SortType = stAlphabetic
    end
    object DBNameCombo: TNxComboBoxColumn
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'DB Name'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Options = [coCanClick, coCanInput, coEditing, coPublicUsing, coShowTextFitHint]
      ParentFont = False
      Position = 4
      SortType = stAlphabetic
      Items.Strings = (
        '1'
        '2'
        '3')
    end
    object DBIndex: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'DB Index'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 5
      SortType = stAlphabetic
    end
    object NxTextColumn1: TNxTextColumn
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Bit Index'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 6
      SortType = stAlphabetic
    end
    object SaveOnlyCB: TNxCheckBoxColumn
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Save Only When True'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 7
      SortType = stBoolean
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 436
    Width = 642
    Height = 27
    Panels = <
      item
        Width = 250
      end
      item
        Width = 100
      end
      item
        Width = 50
      end>
    OnClick = StatusBar1Click
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 16
    Top = 16
  end
  object PopupMenu1: TPopupMenu
    Left = 16
    Top = 48
    object SaveToFile1: TMenuItem
      Caption = 'Save To Param File'
      OnClick = SaveToFile1Click
    end
  end
end
