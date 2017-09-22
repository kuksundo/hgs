object FrameWatchGrid: TFrameWatchGrid
  Left = 0
  Top = 0
  Width = 548
  Height = 445
  TabOrder = 0
  object NextGrid1: TNextGrid
    Left = 0
    Top = 0
    Width = 548
    Height = 445
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Align = alClient
    Caption = ''
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Options = [goDisableColumnMoving, goGrid, goHeader, goIndicator, goMultiSelect, goSelectFullRow]
    ParentFont = False
    TabOrder = 0
    TabStop = True
    OnCellDblClick = NextGrid1CellDblClick
    OnCustomDrawCell = NextGrid1CustomDrawCell
    OnKeyDown = NextGrid1KeyDown
    OnKeyUp = NextGrid1KeyUp
    OnMouseDown = NextGrid1MouseDown
    OnMouseMove = NextGrid1MouseMove
    OnSelectCell = NextGrid1SelectCell
    object NxIndex: TNxIncrementColumn
      Alignment = taCenter
      DefaultWidth = 30
      Header.Caption = 'No.'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Position = 0
      SortType = stAlphabetic
      Visible = False
      Width = 30
    end
    object SimpleDisplay: TNxImageColumn
      DefaultValue = '0'
      DefaultWidth = 20
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Header.Caption = 'S'
      Header.Hint = 'Simple Display'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Options = [coCanClick, coCanInput, coPublicUsing]
      ParentFont = False
      Position = 1
      SortType = stNumeric
      Width = 20
      Images = ImageList1
    end
    object TrendDisplay: TNxImageColumn
      DefaultValue = '0'
      DefaultWidth = 20
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Header.Caption = 'T'
      Header.Hint = 'Trend Display'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Options = [coCanClick, coCanInput, coPublicUsing]
      ParentFont = False
      Position = 2
      SortType = stNumeric
      Width = 20
      Images = ImageList1
    end
    object ItemName: TNxTextColumn
      DefaultWidth = 200
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Item Name'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Options = [coCanClick, coCanInput, coPublicUsing, coShowTextFitHint]
      ParentFont = False
      Position = 3
      SortType = stAlphabetic
      Width = 200
    end
    object Value: TNxButtonColumn
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Header.Caption = 'Value'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Options = [coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint]
      ParentFont = False
      Position = 4
      SortType = stAlphabetic
      ButtonCaption = '...'
      ShowButton = False
    end
    object FUnit: TNxTextColumn
      Alignment = taCenter
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Unit'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Options = [coCanClick, coCanInput, coPublicUsing, coShowTextFitHint]
      ParentFont = False
      Position = 5
      SortType = stAlphabetic
    end
    object XYDisplay: TNxImageColumn
      DefaultValue = '0'
      DefaultWidth = 25
      Header.Caption = 'XY'
      Header.Hint = 'XY Graph Display'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Options = [coCanClick, coCanInput, coPublicUsing]
      Position = 6
      SortType = stNumeric
      Width = 25
      Images = ImageList1
    end
    object AlarmEnable: TNxImageColumn
      DefaultValue = '0'
      DefaultWidth = 20
      Header.Caption = 'A'
      Header.Hint = 'Alarm Display'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Options = [coCanClick, coCanInput, coPublicUsing]
      Position = 7
      SortType = stNumeric
      Width = 20
      Images = ImageList1
    end
    object IsAvg: TNxCheckBoxColumn
      Alignment = taCenter
      DefaultWidth = 40
      Footer.Alignment = taCenter
      Header.Caption = 'Avg'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Position = 8
      SortType = stBoolean
      Visible = False
      Width = 40
    end
    object AvgValue: TNxTextColumn
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Header.Caption = 'Avg Value'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 9
      SortType = stAlphabetic
      Visible = False
    end
    object ExcelRange: TNxButtonColumn
      Alignment = taCenter
      Header.Caption = 'Excel Range'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Options = [coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint]
      Position = 10
      SortType = stAlphabetic
      Visible = False
      OnButtonClick = ExcelRangeButtonClick
    end
    object ItemType: TNxTextColumn
      Header.Caption = 'Type'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Position = 11
      SortType = stAlphabetic
      Visible = False
    end
    object Description: TNxTextColumn
      Header.Caption = 'Description'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Position = 12
      SortType = stAlphabetic
      Visible = False
    end
    object SensorType: TNxTextColumn
      Header.Caption = 'Sensor Type'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Position = 13
      SortType = stAlphabetic
      Visible = False
    end
    object CollectIndex: TNxNumberColumn
      DefaultValue = '0'
      Header.Caption = 'Collect Index'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Position = 14
      SortType = stNumeric
      Visible = False
      Increment = 1.000000000000000000
      Precision = 0
    end
  end
  object EngParamSource2: TDropTextSource
    DragTypes = [dtCopy]
    Left = 408
    Top = 144
  end
  object DropTextTarget1: TDropTextTarget
    DragTypes = [dtCopy, dtLink]
    OnDrop = DropTextTarget1Drop
    Target = NextGrid1
    Left = 368
    Top = 144
  end
  object ImageList1: TImageList
    Left = 448
    Top = 104
    Bitmap = {
      494C010106000900D00110001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      000040B0C00040C0C00030B0C01030B0C02030B0C01030B0B01030A8B00030A8
      B00030A0B0001098A00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000050D0
      D0102098A04020889090108890E0108080E0208080D0107880A0207880701078
      803030A8C0101098A0001098A00000000000000000000058A0100050A0D00048
      9090004880100000000000000000000000000000000000000000004080100040
      8090004080D00040801000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000D8F00030E0F01010A0
      B09010A0B0FF10A0B0FF10A0C0FF0098C0FF0098C0FF0090C0FF1088A0FF2080
      90FF1078805020A8B01030A8B0001098A000000000000068C0201068A0E01070
      A0FF005080F00048904000000000000000000000000000408040004870F00050
      70FF105070F00040802000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000010E0F01010A8B0B010B8
      C0FF10C8D0FF20D0E0FF10C0D0FF10B8D0FF10B0D0FF10A8D0FF10A0C0FF0090
      C0FF1088A0F01078805020A8B01040B0C00000000000000000001070C0C01098
      C0FF10A0D0FF005080FF005090900048901000408090004060FF0078B0FF0068
      A0FF005070F00000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000C0D00010C0D06020C8D0FF20D0
      E0FF20D8E0FF107070FF103030FF001010FF004850FF006870FF10B8D0FF10A8
      D0FF1098C0FF108890B01078803030B0C00000000000000000001080D0201070
      B0F030C8E0FF20C8E0FF1070A0F0005090F0006090FF00A8D0FF00A0D0FF0038
      60FF105880300000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000040E8F00020C8D0E020D0E0FF20E0
      F0FF205860FF207880FF30B0C0FF30C8D0FF30A0B0FF007080FF005860FF20C0
      D0FF10A0C0FF1090B0FF207880703098A0100000000000000000000000002088
      D0902098C0F040D8F0FF30D0F0FF20B8E0FF10C0E0FF10B8E0FF0068A0FF1058
      80B0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000060F0FF1020D0E0FF30E8F0FF20B0
      C0FF40A8B0FF50E8F0FF50F0FFFF40F0F0FF20E0F0FF50D8E0FF107880FF20C8
      D0FF10B0D0FF1098C0FF108080B0308080000000000000000000000000003098
      E0702088C0F050E0F0FF40E0F0FF30D8F0FF20D0E0FF10C8E0FF005080FF0050
      9070000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000060F0FF1030D0D0FF60F0FFFF60F0
      FFFF50F0FFFF60F8FFFF60F8FFFF50F0FFFF40F0FFFF20E8F0FF10E0F0FF20D8
      F0FF20C0E0FF10A8D0FF1090A0F0000000000000000050B0F01050A8F0B040A0
      D0F070E0F0FF60E8F0FF50E0F0FF50E0F0FF40D8F0FF30D0F0FF10B8E0FF0058
      90FF0058A0B00050901000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000050F0FF0030D0D0FF80F8FFFF90F8
      FFFF60D0D0FF60D0D0FF70F8FFFF60F8FFFF50F8FFFF30D0E0FF20C8D0FF20E0
      F0FF20C8E0FF10B0D0FF108890C00000000060B8F03060B0E0E070C8E0F090F0
      FFFF90F8FFFF80F0FFFF70E8F0FF60E8F0FF50E0F0FF40D8F0FF30D0F0FF20C8
      E0FF1080B0FF005890F00050A030000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000070F0FF0030D8E0FF70F0F0FFC0F8
      FFFF203030FF101820FF70F8FFFF60F8FFFF50F8FFFF102820FF101820FF20E0
      F0FF20D0E0FF10A8C0FF108090A080D8E00060B8F0FF50B0E0FF50B0E0FF50A8
      E0FF50A8E0FF50B0E0F080F0F0FF80F0F0FF60E8F0FF3088C0E01078C0FF1068
      B0FF0060B0FF0058A0FF0060B0FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080E8FF0030D8E0C050E0F0FFC0F8
      FFFF707070FF303830FF80F8FFFF70F8FFFF50F8FFFF606870FF203830FF10E0
      F0FF10C8E0FF1098B0F01080907080E8F0000000000000000000000000000000
      00000000000070B0E0D080D8F0FF90F8FFFF60C8E0F040A0E0B0000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000020E0E04050D8E0FF80F0
      FFFFE0FFFFFFE0FFFFFFA0F8FFFF90F8FFFF70F8FFFF30F0FFFF20E8F0FF10D8
      F0FF10C8E0FF008890C00090A020D0F8FF000000000000000000000000000000
      00000000000070B8F05060C0F0FFA0F8FFFF60B0D0E050A8F050000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000020C8D0B050E8
      F0FF90F8FFFFC0F8FFFFC0F8FFFFB0F8FFFF80F8FFFF30E8F0FF20E0F0FF20D0
      E0FF10A0B0FF0090A07080F8FF00000000000000000000000000000000000000
      00000000000060B8F00060B0E0F090E8F0FF60B0E0F060B8F000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000020C8
      D0B050E0E0FF50F0F0FF80F0FFFF80F8FFFF30F0F0FF20D8E0FF20C8D0FF10B8
      C0FF0098A06060E8F00000000000000000000000000000000000000000000000
      0000000000000000000070B8E0A060B8E0F060B8F09000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E0F0
      FF0020D0E05020C8D08030D0D0E030C8D0FF20C8D0FF20C8D0F020C8D0B010B8
      C020D0FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000060B8F03060B8F0F060B8F03000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000090F8FF00A0F8FF00A0F0FF0080F0FF00E0F8FF0060F8FF000000
      0000E0E8FF000000000000000000000000000000000000000000000000000000
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
      00009070603090706080906850C0806850F0806050F0805840C0705840807050
      4030000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000010A8E050306880FF304860FF40607060000000000000
      000000000000000000000000000000000000000000000000000000000000A078
      6060907060E0907050FF706840FF906840FFB06840FF906040FF805040FF7050
      40E0705040600000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005088A0D04078
      90E0306880D0306080D0206880E0306890FF305870FF305060F0305060FF3048
      60FF304860FF305060F000000000000000000000000000000000A0806060A078
      60F0C08060FF807830FF607820FF506040FF906040FFC06840FFB06040FF9058
      40FF705040F07050406000000000000000000000000000000000000000000000
      0000000000000000000000000000A0503000A050200000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000657BC8002F4FB10000000000000000000000
      000000000000000000000000000000000000000000000000000060A8C0FFD0FF
      FFFFB0F8FFFF80E8FFFF60E0F0FF50C0E0FF40B0D0FF40A0C0FF3088A0FF3078
      A0FF305870FF305060FF000000000000000000000000B0807030A07860E0D088
      60FFF08860FFD08040FF608820FF308820FF606830FF706840FFB06840FFB060
      40FF905840FF705040E070504030000000000000000000000000000000000000
      00000000000000000000B0603000E0805000D0785000A0502000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000006080F0002048D00000000000000000000000
      000000000000000000000000000000000000000000000000000080A0E04070C8
      E0FFD0F8FFFFB0F8FFFFA0F0FFFF90E8FFFF70D0F0FF50C0E0FF40B8E0FF3080
      A0FF205870FF10305040000000000000000000000000B0807080C08870FFF098
      60FFF09060FFC08860FF508040FF409820FF408830FF707040FFB06840FF8060
      40FF606040FF605840FF70584080000000000000000000000000000000000000
      000000000000B0583000F0A07000F0A07000E0805000D0704000B05830000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000080B0
      C04080C8E0FF80D8F0FF70C0D0FF60B0D0FF50A0C0FF3080A0FF306880FF3050
      70FF1040504000000000000000000000000000000000B08070C0E09870FFFFA0
      70FFE09070FF707850FF50A840FF50A830FF809830FFD07850FF707040FF5068
      40FF307810FF606830FF805840C0000000000000000000000000000000000000
      0000E9B29C00E5A48A00E0907000FFA88000F0885000B0603000A0502000A050
      2000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000070B0C0D0C0F8FFFF90E8F0FF70D8F0FF40C0E0FF30A0C0FF3090B0FF3050
      60F00000000000000000000000000000000000000000B08870F0F0B890FFF0A8
      80FF607860FF609850FF60B040FF90A040FFE08860FFD08050FF507050FF4088
      30FF309010FF408020FF806050F0000000000000000000000000000000000000
      00000000000000000000E0906000FFA88000F0906000B0583000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000004970E5002F5CD80000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000070B8D0E0C0F8FFFFA0F0FFFF90E0F0FF60D0F0FF40C0E0FF30A0C0FF3060
      80F00000000000000000000000000000000000000000B08870F0FFB8A0FFA098
      80FF40A850FF60B850FF909860FFE09870FFE09060FFE08860FF60A030FF40A0
      20FF409820FF408820FF806850F0000000000000000000000000000000000000
      00000000000000000000E0907000FFB09000FF906000A0502000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003060F0000040FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080C0D0F0C0F8FFFFC0F8FFFFA0F0FFFF90E8F0FF60D0F0FF40B8E0FF3060
      80F00000000000000000000000000000000000000000B08870C0E0B8A0FF90B8
      80FF50C870FF50C870FF80A070FFC0A070FFD09870FFE09060FFA09840FF50A8
      30FF40A020FF508830FF906850C0000000000000000000000000000000000000
      00000000000000000000E0907000FFB89000FF986000A0502000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000006383E5004B78F0000048FF001F50D500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080C0D0F0C0F8FFFFC0F8FFFFC0F8FFFFB0F8FFFF90E0F0FF60C0E0FF4068
      80F00000000000000000000000000000000000000000B0907080B0A080FF90D0
      A0FF70E090FF90E0A0FF80E8A0FFA0D090FFB0A870FFF09870FFE09060FF50A8
      30FF50A830FF708840FF90706080000000000000000000000000000000000000
      00000000000000000000E0987000FFB89000FF987000A0502000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005078E0006088FF003060FF000038D000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080A0A050A0D8E0FFC0F0F0FFD0FFFFFFD0FFFFFFA0E8F0FF6090A0FF5060
      60500000000000000000000000000000000000000000B0907030B09080E090C8
      A0FFA0E8B0FFD0F0C0FFD0F8D0FFF0F8D0FFB0E8B0FF809860FFD09840FFB090
      40FF609840FF907050E090706030000000000000000000000000000000000000
      00000000000000000000F0A08000FFC0A000FFB89000A0502000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007088E00090A8FF006088FF002050D000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080B0B04090D0E0FF80C0D0FF70B0C0FF60A0B0FF608090300000
      0000000000000000000000000000000000000000000000000000B0908070B0A0
      80F0B0D8B0FFD0F0D0FFE0F8D0FF80B070FF80D890FF50B070FF908840FFD088
      60FFA07860F0A078606000000000000000000000000000000000000000000000
      00000000000000000000F0A57800E1A57800E19E7800D2876900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000788FE100697FE10000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B090
      8070B09080E0C0C0A0FFD0E0C0FFB0E8B0FF80E0A0FF60B870FFA08850FFA078
      60E0A08060600000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B0908030B0908080B09080C0B09080F0C09880F0B09080C0B0807080B080
      7030000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00F003FFFF00000000E00187C300000000
      80008383000000008000C007000000000000C007000000000000E00F00000000
      0000E00F00000000000180030000000000010001000000000000000100000000
      0000F83F000000008000F83F00000000C001F83F00000000E003FC7F00000000
      E007FC7F00000000F817FFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF00F
      FFFFFFFFFC3FE007FFFFFFFFC003C003FE7FFE7FC0038001FC3FFE7FC0038001
      F81FFFFFE0078001F00FFFFFF00F8001FC3FFE7FF00F8001FC3FFE7FF00F8001
      FC3FFC3FF00F8001FC3FFC3FF00F8001FC3FFC3FF81FC003FC3FFE7FFFFFE007
      FFFFFFFFFFFFF00FFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object cyMathParser1: TcyMathParser
    Left = 448
    Top = 152
  end
end