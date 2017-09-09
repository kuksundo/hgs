object ModbusComF: TModbusComF
  Left = 138
  Top = 359
  Caption = 'Modbus Communication'
  ClientHeight = 476
  ClientWidth = 740
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poDesigned
  PrintScale = poNone
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 321
    Top = 41
    Height = 416
    ExplicitHeight = 366
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 740
    Height = 41
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 256
      Top = 16
      Width = 37
      Height = 16
      AutoSize = False
      Caption = #49569#49888
    end
    object Label2: TLabel
      Left = 348
      Top = 16
      Width = 37
      Height = 16
      AutoSize = False
      Caption = #49688#49888
    end
    object Label3: TLabel
      Left = 408
      Top = 16
      Width = 113
      Height = 16
      AutoSize = False
      Caption = #53685#49888#50640#47084' '#44148#49688':'
    end
    object Label4: TLabel
      Left = 520
      Top = 16
      Width = 73
      Height = 16
      AutoSize = False
      Caption = '0'
    end
    object Button1: TButton
      Left = 15
      Top = 10
      Width = 106
      Height = 25
      Caption = 'Start'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 127
      Top = 10
      Width = 106
      Height = 25
      Caption = 'Restart'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 624
      Top = 8
      Width = 97
      Height = 25
      Caption = 'Ping'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object ModBusSendComMemo: TMemo
    Left = 0
    Top = 41
    Width = 321
    Height = 416
    Align = alLeft
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object ModBusRecvComMemo: TMemo
    Left = 324
    Top = 41
    Width = 416
    Height = 416
    Align = alClient
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 457
    Width = 740
    Height = 19
    Panels = <
      item
        Width = 160
      end
      item
        Width = 200
      end
      item
        Width = 100
      end
      item
        Width = 50
      end>
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 16
    Top = 56
  end
  object MainMenu1: TMainMenu
    Left = 56
    Top = 56
    object N1: TMenuItem
      Caption = 'Setting'
      object N2: TMenuItem
        Caption = 'Config'
        OnClick = N2Click
      end
      object DisplayRecv1: TMenuItem
        Caption = 'Display Recv'
        OnClick = DisplayRecv1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Caption = 'Close'
        OnClick = N4Click
      end
    end
    object About1: TMenuItem
      Caption = 'About'
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 136
    Top = 56
    object ShowMainForm1: TMenuItem
      Caption = 'Show Main Form'
      OnClick = ShowMainForm1Click
    end
    object ShowHandle1: TMenuItem
      Caption = 'Show Handle'
      OnClick = ShowHandle1Click
    end
    object ShowProcessID1: TMenuItem
      Caption = 'Show ProcessID'
      OnClick = ShowProcessID1Click
    end
    object ShowEngineName1: TMenuItem
      Caption = 'Show Engine Name'
      OnClick = ShowEngineName1Click
    end
    object ShowEventName1: TMenuItem
      Caption = 'Show Event Name'
      OnClick = ShowEventName1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object About2: TMenuItem
      Caption = 'About'
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Close1: TMenuItem
      Caption = 'Close'
      OnClick = Close1Click
    end
  end
  object ImageList1: TImageList
    Left = 184
    Top = 56
    Bitmap = {
      494C010109001800780010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000083A080002467
      1C001A7C100060AA5800000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004F7D4A00083B02001770
      0E002E9B210036B828002EBD1F000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000042401000E4B07002F8E
      26005DBD52006BCF610049CB3A0072C2690000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000424000012540A00409A
      34007DCE740095DC8D0061D2520031C3210000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000032200000F5008003289
      290068C05E007AD26F0050C943004AC13B0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000D350900083A02001B6D
      1100379B2C0043B936002EBD1E009CBF980000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000012450C000B51
      0300147709001A950D0076B76E000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000097B5BF0000212D00001F
      2A00001D2600001C250097B4BE00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A6A89700101300000F11
      00000E1000000E100000A5A79700000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BFB8AD002C2519002922
      170026201500251F1500BDB7AD00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A4B0B2000E1B1D000D19
      1B000C1719000C171900A3AFB100000000000000000000000000000000000000
      00000000000000000000000000000000000098C5D50001425800013C50000132
      430000263300001E2900001C250098BDCA000000000000000000000000000000
      000000000000000000000000000000000000AEB19700212500001E220000191C
      0000121500000F1100000E100000AAAD97000000000000000000000000000000
      000000000000000000000000000000000000D4CABA00574831004F422C004237
      2500322A1C0028211600251F1500CAC1B4000000000000000000000000000000
      000000000000000000000000000000000000ABBDC0001C353A00193135001529
      2C00101F21000D191A000C171900A7B6B9000000000000000000000000000000
      00000000000000000000000000000000000002628300025F7E00025572000149
      6200013B4F00012B3A00001F2900001C25000000000000000000000000000000
      000000000000000000000000000000000000313700002F3500002A3000002529
      00001D210000161800000F1100000E1000000000000000000000000000000000
      000000000000000000000000000000000000816B49007D684600705E40006151
      36004E412C00392F200029221700251F15000000000000000000000000000000
      00000000000000000000000000000000000029505600284D530024454B001F3B
      410019303400122326000D191B000C1719000000000000000000000000000000
      0000000000000000000000000000000000000380AB00037AA300036E93000360
      810002506B00013E5300012B3900001D27000000000000000000000000000000
      000000000000000000000000000000000000404800003D440000373E00003036
      0000282D00001F230000151800000E1000000000000000000000000000000000
      000000000000000000000000000000000000A88C5F00A0855B00917952007E6A
      470069583C0052442E00382F2000272016000000000000000000000000000000
      0000000000000000000000000000000000003768710033636A002F596100294E
      5400224147001A333700122325000C181A000000000000000000000000000000
      000000000000000000000000000000000000049CD0000393C4000386B3000376
      9E000364860002506C00013B4F0000222E000000000000000000000000000000
      0000000000000000000000000000000000004F5800004A530000434C00003A42
      000032380000282D00001D210000111300000000000000000000000000000000
      000000000000000000000000000000000000CDAB7400C1A26D00B09364009B81
      5800846E4B006A593C004D402C002D2619000000000000000000000000000000
      000000000000000000000000000000000000427F89003F788200396D75003360
      68002B51580022414700193034000E1C1E000000000000000000000000000000
      00000000000000000000000000000000000005B6F30005ABE6006DFFFF001EA6
      D5000378A00003628300014A6300002D3C000000000000000000000000000000
      0000000000000000000000000000000000005C66000056610000B6C068006169
      1B003C43000031370000252A0000161900000000000000000000000000000000
      000000000000000000000000000000000000EEC78800E1BD8000FFFFDD00D2B4
      83009D845900816C4900615237003B3222000000000000000000000000000000
      0000000000000000000000000000000000004D949F00498C9700ABE8F200568D
      950033626A002A505600203C4100132528000000000000000000000000000000
      000000000000000000000000000000000000A0EEFE0024E1FF002DDBFF001DB7
      ED00038AB900037298000256740098C2D1000000000000000000000000000000
      000000000000000000000000000000000000C5CB9D00808C1D00828D28006872
      1800454E0000394000002B310000ADAF97000000000000000000000000000000
      000000000000000000000000000000000000FDF4D900FFF3B100FFECAC00EAC6
      8E00B5976700967D5500715F4100D0C6B7000000000000000000000000000000
      000000000000000000000000000000000000C0DFE40072BECA0074B9C5005C99
      A4003B717900305D640024464B00A9BABD000000000000000000000000000000
      00000000000000000000000000000000000000000000B3F4FE0028E9FF0005B1
      ED000499CD00037EA80098C8D800000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DAE0B000869222005964
      00004D5700003F470000AFB29700000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEF8EB00FFFBB600E8C2
      8400C9A97200A6895E00D7CCBC00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D4EDF00077C3CF004B90
      9C00417C870035666F00ACBFC200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A397B6000D0022000C00
      20000B001E000A001D00A297B500000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A8A59A00120F0300110E
      0300100D03000F0C0200A7A49A00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A9A7BA00131127001210
      2500100F2200100F2100A8A6BA00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B09E9E001B0808001907
      07001707070017070700AF9E9E00000000000000000000000000000000000000
      000000000000000000000000000000000000A997C7001900440017003E001300
      33000E0027000B001F000A001D00A697BF000000000000000000000000000000
      000000000000000000000000000000000000B1AD9C00241F0700211B06001C17
      050015110400100E03000F0C0200ACA99B000000000000000000000000000000
      000000000000000000000000000000000000B2B0CD0027234E00232047001D1B
      3B0016142D0011102300100F2100ADABC4000000000000000000000000000000
      000000000000000000000000000000000000BDA3A30035101000310F0F00290C
      0C001F0909001907070017070700B6A1A1000000000000000000000000000000
      0000000000000000000000000000000000002600640024006100210058001C00
      4B0017003C0011002C000C0020000A001D000000000000000000000000000000
      000000000000000000000000000000000000362D0A00342C0B002F2809002922
      0800211B060017140500110E03000F0C02000000000000000000000000000000
      0000000000000000000000000000000000003934730037326F00322E65002B27
      5600222045001917330012102400100F21000000000000000000000000000000
      000000000000000000000000000000000000501818004D181800451515003B12
      1200300F0F00230B0B0019070700170707000000000000000000000000000000
      000000000000000000000000000000000000320084002F007D002A0071002500
      63001F0052001800400010002C000B001E000000000000000000000000000000
      000000000000000000000000000000000000473B0E0044380E003D330C00352D
      0A002C250800221D060017140500100D03000000000000000000000000000000
      0000000000000000000000000000000000004B45970047428F00413B82003833
      71002F2B5E002421490019163200111023000000000000000000000000000000
      00000000000000000000000000000000000068202000631F1F00591C1C004E18
      180041141400330F0F00230A0A00180707000000000000000000000000000000
      0000000000000000000000000000000000003C00A0003900970034008A002E00
      7A00270067001F00520016003D000D0023000000000000000000000000000000
      00000000000000000000000000000000000056491200524411004A3E0E004137
      0C00372F0A002D250800211B0600130F03000000000000000000000000000000
      0000000000000000000000000000000000005B54B7005650AD004E489D004540
      8B003A3676002F2B5F00221F4500141229000000000000000000000000000000
      0000000000000000000000000000000000007F272700782525006D222200601E
      1E005119190041141400300F0F001C0808000000000000000000000000000000
      0000000000000000000000000000000000004700BB004200B000A568FF00521B
      AA002F007B00260065001C004C0011002E000000000000000000000000000000
      0000000000000000000000000000000000006555140060501300BEB07A00695B
      2B0043370D00362D0A0029220800191505000000000000000000000000000000
      0000000000000000000000000000000000006B62D600655DC900C4BCFF006C66
      BF0046408D00393574002B2857001A1835000000000000000000000000000000
      000000000000000000000000000000000000942E2E008C2B2B00E89090008D3E
      3E00621E1E00501818003C121200250B0B000000000000000000000000000000
      000000000000000000000000000000000000BD9DF0006A1DE5006D28DF005618
      BC0036008E002C00750022005800A897C3000000000000000000000000000000
      000000000000000000000000000000000000CAC3A6008B7A34008B7B3C007162
      2B004C400F003F350C002F280900AFAB9C000000000000000000000000000000
      000000000000000000000000000000000000CCC8F8009188FF009188FA00756E
      D300514AA200433E8600332E6600B0AECA000000000000000000000000000000
      000000000000000000000000000000000000DFB2B200BE505000B95555009940
      4000712323005D1D1D0046151500BAA2A2000000000000000000000000000000
      00000000000000000000000000000000000000000000D1B0F5007022ED004500
      B6003C009D0031008100AA97CA00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DFD7BA00907E39006252
      140055471100463B0E00B2AD9D00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E2DEFB00968CFF00685F
      D0005A53B5004A449400B4B1D100000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EDC5C500C3545400902D
      2D007C262600661F1F00BFA3A300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00FF80000000000000C380000000000000
      8180000000000000808000000000000080800000000000008080000000000000
      8080000000000000C180000000000000FF800000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFF81FF81FF81FF81FF
      00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF
      00FF00FF00FF00FF00FF00FF00FF00FF81FF81FF81FF81FFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF81FF81FF81FF81FF
      00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF
      00FF00FF00FF00FF00FF00FF00FF00FF81FF81FF81FF81FFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object TrayIcon1: TTrayIcon
    PopupMenu = PopupMenu2
    OnDblClick = TrayIcon1DblClick
    Left = 96
    Top = 64
  end
  object ApplicationEvents1: TApplicationEvents
    OnMinimize = ApplicationEvents1Minimize
    Left = 232
    Top = 56
  end
  object PopupMenu2: TPopupMenu
    Left = 136
    Top = 112
    object MenuItem1: TMenuItem
      Caption = 'Show Main Form'
      OnClick = ShowMainForm1Click
    end
    object MenuItem2: TMenuItem
      Caption = 'Show Handle'
      OnClick = ShowHandle1Click
    end
    object MenuItem3: TMenuItem
      Caption = 'Show ProcessID'
      OnClick = ShowProcessID1Click
    end
    object MenuItem4: TMenuItem
      Caption = 'About'
    end
    object MenuItem5: TMenuItem
      Caption = '-'
    end
    object MenuItem6: TMenuItem
      Caption = 'Close'
      OnClick = Close1Click
    end
  end
end
