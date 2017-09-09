object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 700
  ClientWidth = 796
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object NextGrid1: TNextGrid
    Left = 8
    Top = 86
    Width = 777
    Height = 225
    TabOrder = 0
    TabStop = True
    object NxIncrementColumn1: TNxIncrementColumn
      DefaultWidth = 51
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'No.'
      ParentFont = False
      Position = 0
      SortType = stAlphabetic
      Width = 51
    end
    object NxTextColumn3: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'RowNum.'
      ParentFont = False
      Position = 1
      SortType = stAlphabetic
    end
    object NxTextColumn1: TNxTextColumn
      DefaultWidth = 198
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'CODE'
      ParentFont = False
      Position = 2
      SortType = stAlphabetic
      Width = 198
    end
    object NxTextColumn2: TNxTextColumn
      DefaultWidth = 260
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'DESCRIPTION'
      ParentFont = False
      Position = 3
      SortType = stAlphabetic
      Width = 260
    end
  end
  object Button1: TButton
    Left = 710
    Top = 57
    Width = 75
    Height = 25
    Caption = 'File Open'
    TabOrder = 1
    OnClick = Button1Click
  end
  object NxEdit1: TNxEdit
    Left = 8
    Top = 59
    Width = 696
    Height = 21
    TabOrder = 2
  end
  object Button2: TButton
    Left = 710
    Top = 637
    Width = 75
    Height = 25
    Caption = 'DB INSERT'
    TabOrder = 3
    OnClick = Button2Click
  end
  object NextGrid2: TNextGrid
    Left = 8
    Top = 332
    Width = 777
    Height = 299
    AutoScroll = True
    TabOrder = 4
    TabStop = True
    object NxTextColumn4: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'SCODE'
      ParentFont = False
      Position = 0
      SortType = stAlphabetic
    end
    object NxTextColumn5: TNxTextColumn
      DefaultWidth = 94
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'LEV'
      ParentFont = False
      Position = 1
      SortType = stAlphabetic
      Width = 94
    end
    object NxTextColumn6: TNxTextColumn
      DefaultWidth = 110
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'POSNO.'
      ParentFont = False
      Position = 2
      SortType = stAlphabetic
      Width = 110
    end
    object NxTextColumn7: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'EXIT'
      ParentFont = False
      Position = 3
      SortType = stAlphabetic
    end
    object NxTextColumn22: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'INFO. NO.'
      ParentFont = False
      Position = 4
      SortType = stAlphabetic
    end
    object NxTextColumn8: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'DRAWING NO.'
      ParentFont = False
      Position = 5
      SortType = stAlphabetic
    end
    object NxTextColumn9: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'REV'
      ParentFont = False
      Position = 6
      SortType = stAlphabetic
    end
    object NxTextColumn10: TNxTextColumn
      DefaultWidth = 168
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'DESCRIPTION'
      ParentFont = False
      Position = 7
      SortType = stAlphabetic
      Width = 168
    end
    object NxTextColumn11: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'MATERIAL'
      ParentFont = False
      Position = 8
      SortType = stAlphabetic
    end
    object NxTextColumn12: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'UNIT'
      ParentFont = False
      Position = 9
      SortType = stAlphabetic
    end
    object NxTextColumn13: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Q'#39'TY CYL1'
      ParentFont = False
      Position = 10
      SortType = stAlphabetic
    end
    object NxTextColumn14: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Q'#39'TY CYL2'
      ParentFont = False
      Position = 11
      SortType = stAlphabetic
    end
    object NxTextColumn15: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Q'#39'TY CYL3'
      ParentFont = False
      Position = 12
      SortType = stAlphabetic
    end
    object NxTextColumn16: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Q'#39'TY CYL4'
      ParentFont = False
      Position = 13
      SortType = stAlphabetic
    end
    object NxTextColumn17: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Q'#39'TY CYL5'
      ParentFont = False
      Position = 14
      SortType = stAlphabetic
    end
    object NxTextColumn18: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'WEIGHT'
      ParentFont = False
      Position = 15
      SortType = stAlphabetic
    end
    object NxTextColumn19: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'MAKE SECTION'
      ParentFont = False
      Position = 16
      SortType = stAlphabetic
    end
    object NxTextColumn20: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'SHIP NO.'
      ParentFont = False
      Position = 17
      SortType = stAlphabetic
    end
    object NxTextColumn21: TNxTextColumn
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'REMARK'
      ParentFont = False
      Position = 18
      SortType = stAlphabetic
    end
  end
  object AdvOfficeStatusBar1: TAdvOfficeStatusBar
    Left = 0
    Top = 681
    Width = 796
    Height = 19
    AnchorHint = False
    Panels = <
      item
        AppearanceStyle = psLight
        DateFormat = 'yyyy-MM-dd'
        Progress.BackGround = clNone
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        TimeFormat = 'AMPM h:mm:ss'
        Width = 80
      end
      item
        AppearanceStyle = psLight
        DateFormat = 'yyyy-MM-dd'
        Progress.BackGround = clNone
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        TimeFormat = 'AMPM h:mm:ss'
        Width = 100
      end
      item
        AppearanceStyle = psLight
        DateFormat = 'yyyy-MM-dd'
        Progress.BackGround = clNone
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        TimeFormat = 'AMPM h:mm:ss'
        Width = 130
      end
      item
        AppearanceStyle = psLight
        DateFormat = 'yyyy-MM-dd'
        Progress.BackGround = clNone
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        TimeFormat = 'AMPM h:mm:ss'
        Width = 50
      end>
    SimplePanel = False
    URLColor = clBlue
    Version = '1.3.0.2'
  end
  object NxPanel1: TNxPanel
    Left = 0
    Top = 0
    Width = 796
    Height = 53
    Align = alTop
    BackgroundStyle = pbHorzGradient
    Caption = 'Engine Part List DB Insert'
    UseDockManager = False
    InnerMargins.Left = 0
    InnerMargins.Top = 0
    InnerMargins.Bottom = 0
    InnerMargins.Right = 0
    TabOrder = 6
  end
  object OpenDialog1: TOpenDialog
    Left = 88
    Top = 8
  end
  object ZConnection1: TZConnection
    Protocol = 'sqlite-3'
    Left = 16
    Top = 8
  end
  object ZQuery1: TZQuery
    Connection = ZConnection1
    Params = <>
    Left = 48
    Top = 8
  end
  object MainMenu1: TMainMenu
    Left = 708
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object Close1: TMenuItem
        Caption = 'Close'
      end
    end
  end
end
