object ServerMainF: TServerMainF
  Left = 198
  Top = 124
  Caption = ' HTTP Server'
  ClientHeight = 501
  ClientWidth = 664
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label4: TLabel
    Left = 40
    Top = 96
    Width = 4
    Height = 16
    Visible = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 664
    Height = 139
    Align = alTop
    TabOrder = 0
    object Label3: TLabel
      Left = 40
      Top = 11
      Width = 58
      Height = 16
      Caption = 'Server IP:'
    end
    object Label1: TLabel
      Left = 40
      Top = 38
      Width = 601
      Height = 33
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 408
      Top = 14
      Width = 145
      Height = 16
      Caption = 'HTTP Server is running...'
      Visible = False
    end
    object Label5: TLabel
      Left = 432
      Top = 77
      Width = 64
      Height = 16
      Caption = 'Tag Count:'
    end
    object Label6: TLabel
      Left = 102
      Top = 77
      Width = 36
      Height = 16
      Caption = 'Topic:'
    end
    object ComboBox1: TComboBox
      Left = 102
      Top = 8
      Width = 145
      Height = 24
      ImeName = 'Microsoft IME 2010'
      TabOrder = 0
      Text = 'localhost'
      OnDropDown = ComboBox1DropDown
    end
    object Button2: TButton
      Left = 288
      Top = 7
      Width = 89
      Height = 25
      Caption = 'Start'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 432
      Top = 108
      Width = 209
      Height = 25
      Caption = 'LoadFromFile /  Start OPC'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 411
    Width = 664
    Height = 61
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 534
      Top = 20
      Width = 75
      Height = 25
      Caption = 'Quit'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object TagGrid: TNextGrid
    Left = 0
    Top = 139
    Width = 664
    Height = 272
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Align = alClient
    Caption = ''
    TabOrder = 2
    TabStop = True
    object NxIncrementColumn1: TNxIncrementColumn
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
    end
    object TagNameText: TNxTextColumn
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
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 472
    Width = 664
    Height = 29
    Panels = <>
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 48
    Top = 72
  end
end
