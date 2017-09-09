object FormAlarmList: TFormAlarmList
  Left = 0
  Top = 0
  Caption = 'Alarm List'
  ClientHeight = 434
  ClientWidth = 766
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inline TFrameIPCMonitorAll1: TFrameIPCMonitorAll
    Left = 0
    Top = 0
    Width = 766
    Height = 434
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 766
    ExplicitHeight = 434
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 766
    Height = 434
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Alarm List'
      object AlarmListGrid: TNextGrid
        Left = 0
        Top = 0
        Width = 758
        Height = 406
        Align = alClient
        Options = [goGrid, goHeader]
        TabOrder = 0
        TabStop = True
        object NxCheckBoxColumn1: TNxCheckBoxColumn
          Alignment = taCenter
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = 'Ack'
          Header.Alignment = taCenter
          ParentFont = False
          Position = 0
          SortType = stBoolean
        end
        object NxTextColumn1: TNxTextColumn
          Alignment = taCenter
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = 'Time In'
          Header.Alignment = taCenter
          ParentFont = False
          Position = 1
          SortType = stAlphabetic
        end
        object NxTextColumn2: TNxTextColumn
          Alignment = taCenter
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = 'Module'
          Header.Alignment = taCenter
          ParentFont = False
          Position = 2
          SortType = stAlphabetic
        end
        object NxTextColumn3: TNxTextColumn
          DefaultWidth = 150
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = 'Description'
          Header.Alignment = taCenter
          ParentFont = False
          Position = 3
          SortType = stAlphabetic
          Width = 150
        end
        object NxTextColumn4: TNxTextColumn
          Alignment = taCenter
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = 'Alarm Type'
          Header.Alignment = taCenter
          ParentFont = False
          Position = 4
          SortType = stAlphabetic
        end
        object NxTextColumn5: TNxTextColumn
          DefaultWidth = 200
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = 'Alarm Message'
          Header.Alignment = taCenter
          ParentFont = False
          Position = 5
          SortType = stAlphabetic
          Width = 200
        end
        object NxTextColumn6: TNxTextColumn
          Alignment = taCenter
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = 'Priority'
          Header.Alignment = taCenter
          ParentFont = False
          Position = 6
          SortType = stAlphabetic
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 758
        Height = 41
        Align = alTop
        TabOrder = 0
      end
      object AdvOfficeStatusBar1: TAdvOfficeStatusBar
        Left = 0
        Top = 380
        Width = 758
        Height = 26
        AnchorHint = False
        Panels = <
          item
            AppearanceStyle = psLight
            DateFormat = 'yyyy/MM/dd'
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
            DateFormat = 'yyyy/MM/dd'
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
            DateFormat = 'yyyy/MM/dd'
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
            DateFormat = 'yyyy/MM/dd'
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
        ShowSplitter = True
        SimplePanel = False
        URLColor = clBlue
        Version = '1.5.0.0'
      end
      object AdvListView1: TAdvListView
        Left = 0
        Top = 41
        Width = 758
        Height = 339
        Align = alClient
        Columns = <>
        TabOrder = 2
        ViewStyle = vsReport
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'Tahoma'
        PrintSettings.Font.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'Tahoma'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'Tahoma'
        PrintSettings.FooterFont.Style = []
        PrintSettings.PageNumSep = '/'
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
        HeaderFont.Style = []
        ProgressSettings.ValueFormat = '%d%%'
        DetailView.Font.Charset = DEFAULT_CHARSET
        DetailView.Font.Color = clBlue
        DetailView.Font.Height = -11
        DetailView.Font.Name = 'Tahoma'
        DetailView.Font.Style = []
        Version = '1.6.8.0'
        ExplicitHeight = 338
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
      object ListView1: TListView
        Left = 0
        Top = 0
        Width = 758
        Height = 406
        Align = alClient
        Columns = <>
        TabOrder = 0
        OnDrawItem = ListView1DrawItem
      end
      object JvListView1: TJvListView
        Left = 0
        Top = 0
        Width = 758
        Height = 406
        Align = alClient
        Columns = <
          item
            Caption = 'Ack'
            Width = 30
          end
          item
            Alignment = taCenter
            Caption = 'Time In'
            Width = 80
          end
          item
            Alignment = taCenter
            Caption = 'Module/Param'
            Width = 100
          end
          item
            AutoSize = True
            Caption = 'Description'
          end
          item
            Alignment = taCenter
            Caption = 'Alarm'
          end
          item
            AutoSize = True
            Caption = 'Message'
          end
          item
            Alignment = taCenter
            Caption = 'Prority'
          end>
        TabOrder = 1
        ViewStyle = vsReport
        ColumnsOrder = '0=30,1=80,2=100,3=222,4=50,5=222,6=50'
        ExtendedColumns = <
          item
          end
          item
          end
          item
          end
          item
          end
          item
          end
          item
          end
          item
          end>
      end
    end
  end
  object Sivak3Database1: TSivak3Database
    Driver = 'sqlite3.dll'
    Left = 88
    Top = 216
  end
  object Sivak3Query1: TSivak3Query
    Left = 128
    Top = 216
  end
  object Sivak3Exec1: TSivak3Exec
    Left = 168
    Top = 216
  end
  object MainMenu1: TMainMenu
    Left = 216
    Top = 216
  end
  object Sivak3SimpleTable1: TSivak3SimpleTable
    StringIfEmpty = 'Empty table'
    Left = 40
    Top = 216
  end
  object AlarmListPopup: TPopupMenu
    Left = 256
    Top = 216
    object Config2: TMenuItem
      Caption = 'Config'
    end
    object est1: TMenuItem
      Caption = 'Test'
      OnClick = est1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object DeleteItem2: TMenuItem
      Caption = 'Delete Item'
    end
  end
  object DropTextTarget1: TDropTextTarget
    DragTypes = [dtCopy, dtLink]
    Target = PageControl1
    Left = 40
    Top = 272
  end
end
