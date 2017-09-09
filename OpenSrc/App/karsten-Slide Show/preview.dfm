object PreviewForm: TPreviewForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSizeToolWin
  Caption = 'Preview'
  ClientHeight = 304
  ClientWidth = 467
  Color = clBtnFace
  DockSite = True
  DragKind = dkDock
  DragMode = dmAutomatic
  ParentFont = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PreviewBox: TPaintBox
    Left = 0
    Top = 0
    Width = 467
    Height = 244
    Align = alClient
    OnPaint = PreviewBoxPaint
    ExplicitLeft = 152
    ExplicitTop = 112
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object PropertiesPanel: TPanel
    Left = 0
    Top = 244
    Width = 467
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object FilenameLabel: TLabel
      Left = 0
      Top = 0
      Width = 3
      Height = 13
      ShowAccelChar = False
    end
    object FrequencyLabel: TLabel
      Left = 0
      Top = 15
      Width = 3
      Height = 13
      ShowAccelChar = False
    end
    object DisplayTimeLabel: TLabel
      Left = 0
      Top = 30
      Width = 3
      Height = 13
      ShowAccelChar = False
    end
    object SequenceNumberLabel: TLabel
      Left = 0
      Top = 45
      Width = 3
      Height = 13
      ShowAccelChar = False
    end
  end
  object JvDockClient: TJvDockClient
    LRDockWidth = 200
    DirectDrag = False
    EnableCloseButton = False
    EachOtherDock = False
    DockStyle = JvDockVIDStyle
    Left = 8
    Top = 8
  end
  object JvDockDelphiStyle: TJvDockDelphiStyle
    TabServerOption.TabPosition = tpBottom
    Left = 40
    Top = 8
  end
  object JvDockVIDStyle: TJvDockVIDStyle
    AlwaysShowGrabber = False
    TabServerOption.ActiveFont.Charset = DEFAULT_CHARSET
    TabServerOption.ActiveFont.Color = clWindowText
    TabServerOption.ActiveFont.Height = -11
    TabServerOption.ActiveFont.Name = 'Tahoma'
    TabServerOption.ActiveFont.Style = []
    TabServerOption.InactiveFont.Charset = DEFAULT_CHARSET
    TabServerOption.InactiveFont.Color = clWhite
    TabServerOption.InactiveFont.Height = -11
    TabServerOption.InactiveFont.Name = 'Tahoma'
    TabServerOption.InactiveFont.Style = []
    TabServerOption.ShowCloseButtonOnTabs = False
    Left = 72
    Top = 8
  end
end
