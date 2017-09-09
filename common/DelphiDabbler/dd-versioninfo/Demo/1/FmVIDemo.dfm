object MainForm: TMainForm
  Left = 492
  Top = 162
  Width = 599
  Height = 672
  Color = clBtnFace
  Constraints.MinHeight = 360
  Constraints.MinWidth = 320
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    583
    634)
  PixelsPerInch = 96
  TextHeight = 15
  object bvlSpacer1: TBevel
    Left = 0
    Top = 0
    Width = 583
    Height = 5
    Align = alTop
    Shape = bsTopLine
  end
  object sbFileName: TSpeedButton
    Left = 545
    Top = 9
    Width = 29
    Height = 27
    Hint = 'Click to browse for files.'
    Anchors = [akTop, akRight]
    Caption = '...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = sbFileNameClick
  end
  object gpFixed: TGroupBox
    Left = 0
    Top = 79
    Width = 583
    Height = 202
    Anchors = [akLeft, akTop, akRight]
    Caption = ' Fixed File &Information '
    TabOrder = 0
    DesignSize = (
      583
      202)
    object lvFixed: TListView
      Left = 10
      Top = 20
      Width = 562
      Height = 173
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <
        item
          Caption = 'Item'
          Width = 148
        end
        item
          Caption = 'Value'
          Width = 410
        end>
      GridLines = True
      Items.Data = {
        F50000000700000000000000FFFFFFFFFFFFFFFF00000000000000000C46696C
        652056657273696F6E00000000FFFFFFFFFFFFFFFF00000000000000000F5072
        6F647563742056657273696F6E00000000FFFFFFFFFFFFFFFF00000000000000
        000F46696C6520466C616773204D61736B00000000FFFFFFFFFFFFFFFF000000
        00000000000A46696C6520466C61677300000000FFFFFFFFFFFFFFFF00000000
        00000000104F7065726174696E672053797374656D00000000FFFFFFFFFFFFFF
        FF00000000000000000946696C65205479706500000000FFFFFFFFFFFFFFFF00
        000000000000000D46696C65205375622D74797065}
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnMouseMove = lvMouseMove
    end
  end
  object gpVar: TGroupBox
    Left = 0
    Top = 296
    Width = 583
    Height = 311
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' Variable Information '
    TabOrder = 1
    DesignSize = (
      583
      311)
    object lblTrans: TLabel
      Left = 10
      Top = 20
      Width = 65
      Height = 15
      Caption = 'Tr&anslation:'
      FocusControl = cmbTrans
    end
    object lblStr: TLabel
      Left = 10
      Top = 75
      Width = 120
      Height = 15
      Caption = '&String File Information'
      FocusControl = lvStr
    end
    object cmbTrans: TComboBox
      Left = 10
      Top = 39
      Width = 562
      Height = 23
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 15
      TabOrder = 0
      OnChange = cmbTransChange
    end
    object lvStr: TListView
      Left = 10
      Top = 95
      Width = 562
      Height = 205
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <
        item
          Caption = 'Name'
          Width = 148
        end
        item
          Caption = 'String'
          Width = 410
        end>
      GridLines = True
      Items.Data = {
        A70100000C00000000000000FFFFFFFFFFFFFFFF000000000000000008436F6D
        6D656E747300000000FFFFFFFFFFFFFFFF00000000000000000C436F6D70616E
        79204E616D6500000000FFFFFFFFFFFFFFFF00000000000000001046696C6520
        4465736372697074696F6E00000000FFFFFFFFFFFFFFFF00000000000000000C
        46696C652056657273696F6E00000000FFFFFFFFFFFFFFFF0000000000000000
        0D496E7465726E616C204E616D6500000000FFFFFFFFFFFFFFFF000000000000
        00000F4C6567616C20436F7079726967687400000000FFFFFFFFFFFFFFFF0000
        000000000000104C6567616C2054726164656D61726B7300000000FFFFFFFFFF
        FFFFFF0000000000000000124F726967696E616C2046696C65204E616D650000
        0000FFFFFFFFFFFFFFFF00000000000000000D50726976617465204275696C64
        00000000FFFFFFFFFFFFFFFF00000000000000000C50726F64756374204E616D
        6500000000FFFFFFFFFFFFFFFF00000000000000000F50726F64756374205665
        7273696F6E00000000FFFFFFFFFFFFFFFF00000000000000000D537065636961
        6C204275696C64}
      ReadOnly = True
      RowSelect = True
      TabOrder = 1
      ViewStyle = vsReport
      OnMouseMove = lvMouseMove
    end
  end
  object edFileName: TEdit
    Left = 10
    Top = 10
    Width = 523
    Height = 23
    Hint = 
      'Enter the name of a file here (or drag one from Explorer), then ' +
      'press Refresh.'
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object btnRefresh: TButton
    Left = 10
    Top = 42
    Width = 92
    Height = 31
    Hint = 'Click to display version info for the above file.'
    Caption = '&Refresh'
    Default = True
    TabOrder = 3
    OnClick = btnRefreshClick
  end
  object btnClose: TButton
    Left = 481
    Top = 42
    Width = 93
    Height = 31
    Hint = 'Click to exit.'
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = '&Close'
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object sbHints: TStatusBar
    Left = 0
    Top = 612
    Width = 583
    Height = 22
    AutoHint = True
    Panels = <>
    SimplePanel = True
  end
  object dlgBrowse: TOpenDialog
    Filter = 'All files|*.*'
    Options = [ofHideReadOnly, ofFileMustExist]
    Title = 'Browse'
    Left = 96
    Top = 34
  end
  object viInfo: TPJVersionInfo
    Left = 128
    Top = 34
  end
end
