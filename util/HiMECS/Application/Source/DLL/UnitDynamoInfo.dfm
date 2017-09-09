object FrmGeneratorInfo: TFrmGeneratorInfo
  Left = 0
  Top = 0
  Caption = 'Generator Info.'
  ClientHeight = 587
  ClientWidth = 664
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object NxSplitter1: TNxSplitter
    Left = 0
    Top = 143
    Width = 664
    Height = 9
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 128
  end
  object NxSplitter2: TNxSplitter
    Left = 0
    Top = 348
    Width = 664
    Height = 9
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 378
  end
  object NxFlipPanel1: TNxFlipPanel
    Left = 0
    Top = 0
    Width = 664
    Height = 143
    Align = alTop
    Caption = 'Dynamo-meter Information'
    CollapseGlyph.Data = {
      7A010000424D7A01000000000000360000002800000009000000090000000100
      2000000000004401000000000000000000000000000000000000604830406048
      30FF604830FF604830FF604830FF604830FF604830FF604830FF60483040C0A8
      90FFFFF0E0FFE0D0C0FFE0C8B0FFE0C0B0FFD0B8A0FFD0B8A0FFD0B8A0FF6048
      30FFC0A890FFFFF8F0FFFFF0E0FFF0E0E0FFF0D8D0FFF0D8C0FFF0D0C0FFD0B8
      A0FF604830FFC0A890FFFFF8FFFFFFF8F0FFFFF0E0FFF0E0E0FFF0D8D0FFF0D0
      C0FFD0B8A0FF604830FFC0A8A0FFFFFFFFFF604830FF604830FF604830FF6048
      30FF604830FFE0C0B0FF604830FFC0A8A0FFFFFFFFFFFFFFFFFFFFF8FFFFFFF0
      F0FFFFF0E0FFF0E8E0FFE0C0B0FF604830FFC0B0A0FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFF8FFFFFFF0F0FFFFF0E0FFE0D0C0FF604830FFC0B0A0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFF8FFFFFFF0F0FFF0F0E0FF604830FFC0B0A040C0B0
      A0FFC0B0A0FFC0A8A0FFC0A8A0FFC0A8A0FFC0A890FFC0A090FF60483040}
    ExpandGlyph.Data = {
      7A010000424D7A01000000000000360000002800000009000000090000000100
      2000000000004401000000000000000000000000000000000000604830406048
      30FF604830FF604830FF604830FF604830FF604830FF604830FF60483040C0A8
      90FFFFF0E0FFE0D0C0FFE0C8B0FFE0C0B0FFD0B8A0FFD0B8A0FFD0B8A0FF6048
      30FFC0A890FFFFF8F0FFFFF0E0FFF0E0E0FF604830FFF0D8C0FFF0D0C0FFD0B8
      A0FF604830FFC0A890FFFFF8FFFFFFF8F0FFFFF0E0FF604830FFF0D8D0FFF0D0
      C0FFD0B8A0FF604830FFC0A8A0FFFFFFFFFF604830FF604830FF604830FF6048
      30FF604830FFE0C0B0FF604830FFC0A8A0FFFFFFFFFFFFFFFFFFFFF8FFFF6048
      30FFFFF0E0FFF0E8E0FFE0C0B0FF604830FFC0B0A0FFFFFFFFFFFFFFFFFFFFFF
      FFFF604830FFFFF0F0FFFFF0E0FFE0D0C0FF604830FFC0B0A0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFF8FFFFFFF0F0FFF0F0E0FF604830FFC0B0A040C0B0
      A0FFC0B0A0FFC0A8A0FFC0A8A0FFC0A8A0FFC0A890FFC0A090FF60483040}
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    FullHeight = 0
    object Label1: TLabel
      Left = 25
      Top = 32
      Width = 28
      Height = 13
      Caption = 'Type:'
    end
    object Label2: TLabel
      Left = 249
      Top = 32
      Width = 50
      Height = 13
      Caption = 'Serial No.:'
    end
    object Label3: TLabel
      Left = 25
      Top = 88
      Width = 113
      Height = 13
      Caption = 'Direction of revolution: '
    end
    object Label4: TLabel
      Left = 302
      Top = 88
      Width = 113
      Height = 13
      Caption = 'Current Ratio (If/Iexc):'
    end
    object Label5: TLabel
      Left = 25
      Top = 117
      Width = 53
      Height = 13
      Caption = 'Rarm(L_L):'
    end
    object Label6: TLabel
      Left = 241
      Top = 117
      Width = 48
      Height = 13
      Caption = 'Rfld(J_K):'
    end
    object Label7: TLabel
      Left = 25
      Top = 60
      Width = 82
      Height = 13
      Caption = 'Max. absorption:'
    end
    object Label8: TLabel
      Left = 359
      Top = 117
      Width = 10
      Height = 13
      Caption = 'at'
    end
    object Label9: TLabel
      Left = 415
      Top = 117
      Width = 12
      Height = 13
      Caption = #8451
    end
    object Label10: TLabel
      Left = 170
      Top = 60
      Width = 65
      Height = 13
      Caption = 'Max. Torque:'
    end
    object Label11: TLabel
      Left = 329
      Top = 59
      Width = 82
      Height = 13
      Caption = 'Max. Revolution:'
    end
    object Label14: TLabel
      Left = 167
      Top = 120
      Width = 8
      Height = 13
      Caption = #937
    end
    object Label15: TLabel
      Left = 341
      Top = 118
      Width = 8
      Height = 13
      Caption = #937
    end
    object TypeEdit: TEdit
      Left = 59
      Top = 29
      Width = 158
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 0
    end
    object SerialEdit: TEdit
      Left = 305
      Top = 29
      Width = 158
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 1
    end
    object APEdit: TEdit
      Left = 113
      Top = 57
      Width = 48
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 2
    end
    object PFEdit: TEdit
      Left = 241
      Top = 56
      Width = 65
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 3
    end
    object VoltageEdit: TEdit
      Left = 417
      Top = 56
      Width = 48
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 4
    end
    object STEdit: TEdit
      Left = 136
      Top = 84
      Width = 153
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 5
      Text = 'CCW-View from EG to Dynamo'
    end
    object CREdit: TEdit
      Left = 417
      Top = 83
      Width = 48
      Height = 21
      DragCursor = crDefault
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 6
    end
    object RarmEdit: TEdit
      Left = 84
      Top = 116
      Width = 77
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 7
    end
    object RfldEdit: TEdit
      Left = 290
      Top = 116
      Width = 48
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 8
    end
    object RfldTempEdit: TEdit
      Left = 375
      Top = 116
      Width = 34
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 9
    end
  end
  object NxFlipPanel2: TNxFlipPanel
    Left = 0
    Top = 152
    Width = 664
    Height = 196
    Align = alTop
    Caption = 'Generator Data at rated power factor'
    CollapseGlyph.Data = {
      7A010000424D7A01000000000000360000002800000009000000090000000100
      2000000000004401000000000000000000000000000000000000604830406048
      30FF604830FF604830FF604830FF604830FF604830FF604830FF60483040C0A8
      90FFFFF0E0FFE0D0C0FFE0C8B0FFE0C0B0FFD0B8A0FFD0B8A0FFD0B8A0FF6048
      30FFC0A890FFFFF8F0FFFFF0E0FFF0E0E0FFF0D8D0FFF0D8C0FFF0D0C0FFD0B8
      A0FF604830FFC0A890FFFFF8FFFFFFF8F0FFFFF0E0FFF0E0E0FFF0D8D0FFF0D0
      C0FFD0B8A0FF604830FFC0A8A0FFFFFFFFFF604830FF604830FF604830FF6048
      30FF604830FFE0C0B0FF604830FFC0A8A0FFFFFFFFFFFFFFFFFFFFF8FFFFFFF0
      F0FFFFF0E0FFF0E8E0FFE0C0B0FF604830FFC0B0A0FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFF8FFFFFFF0F0FFFFF0E0FFE0D0C0FF604830FFC0B0A0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFF8FFFFFFF0F0FFF0F0E0FF604830FFC0B0A040C0B0
      A0FFC0B0A0FFC0A8A0FFC0A8A0FFC0A8A0FFC0A890FFC0A090FF60483040}
    ExpandGlyph.Data = {
      7A010000424D7A01000000000000360000002800000009000000090000000100
      2000000000004401000000000000000000000000000000000000604830406048
      30FF604830FF604830FF604830FF604830FF604830FF604830FF60483040C0A8
      90FFFFF0E0FFE0D0C0FFE0C8B0FFE0C0B0FFD0B8A0FFD0B8A0FFD0B8A0FF6048
      30FFC0A890FFFFF8F0FFFFF0E0FFF0E0E0FF604830FFF0D8C0FFF0D0C0FFD0B8
      A0FF604830FFC0A890FFFFF8FFFFFFF8F0FFFFF0E0FF604830FFF0D8D0FFF0D0
      C0FFD0B8A0FF604830FFC0A8A0FFFFFFFFFF604830FF604830FF604830FF6048
      30FF604830FFE0C0B0FF604830FFC0A8A0FFFFFFFFFFFFFFFFFFFFF8FFFF6048
      30FFFFF0E0FFF0E8E0FFE0C0B0FF604830FFC0B0A0FFFFFFFFFFFFFFFFFFFFFF
      FFFF604830FFFFF0F0FFFFF0E0FFE0D0C0FF604830FFC0B0A0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFF8FFFFFFF0F0FFF0F0E0FF604830FFC0B0A040C0B0
      A0FFC0B0A0FFC0A8A0FFC0A8A0FFC0A8A0FFC0A890FFC0A090FF60483040}
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    OnMouseMove = NxFlipPanel2MouseMove
    FullHeight = 239
  end
  object NxFlipPanel3: TNxFlipPanel
    Left = 0
    Top = 357
    Width = 664
    Height = 187
    Align = alClient
    Caption = 'Dynamometer Load Table'
    CollapseGlyph.Data = {
      7A010000424D7A01000000000000360000002800000009000000090000000100
      2000000000004401000000000000000000000000000000000000604830406048
      30FF604830FF604830FF604830FF604830FF604830FF604830FF60483040C0A8
      90FFFFF0E0FFE0D0C0FFE0C8B0FFE0C0B0FFD0B8A0FFD0B8A0FFD0B8A0FF6048
      30FFC0A890FFFFF8F0FFFFF0E0FFF0E0E0FFF0D8D0FFF0D8C0FFF0D0C0FFD0B8
      A0FF604830FFC0A890FFFFF8FFFFFFF8F0FFFFF0E0FFF0E0E0FFF0D8D0FFF0D0
      C0FFD0B8A0FF604830FFC0A8A0FFFFFFFFFF604830FF604830FF604830FF6048
      30FF604830FFE0C0B0FF604830FFC0A8A0FFFFFFFFFFFFFFFFFFFFF8FFFFFFF0
      F0FFFFF0E0FFF0E8E0FFE0C0B0FF604830FFC0B0A0FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFF8FFFFFFF0F0FFFFF0E0FFE0D0C0FF604830FFC0B0A0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFF8FFFFFFF0F0FFF0F0E0FF604830FFC0B0A040C0B0
      A0FFC0B0A0FFC0A8A0FFC0A8A0FFC0A8A0FFC0A890FFC0A090FF60483040}
    ExpandGlyph.Data = {
      7A010000424D7A01000000000000360000002800000009000000090000000100
      2000000000004401000000000000000000000000000000000000604830406048
      30FF604830FF604830FF604830FF604830FF604830FF604830FF60483040C0A8
      90FFFFF0E0FFE0D0C0FFE0C8B0FFE0C0B0FFD0B8A0FFD0B8A0FFD0B8A0FF6048
      30FFC0A890FFFFF8F0FFFFF0E0FFF0E0E0FF604830FFF0D8C0FFF0D0C0FFD0B8
      A0FF604830FFC0A890FFFFF8FFFFFFF8F0FFFFF0E0FF604830FFF0D8D0FFF0D0
      C0FFD0B8A0FF604830FFC0A8A0FFFFFFFFFF604830FF604830FF604830FF6048
      30FF604830FFE0C0B0FF604830FFC0A8A0FFFFFFFFFFFFFFFFFFFFF8FFFF6048
      30FFFFF0E0FFF0E8E0FFE0C0B0FF604830FFC0B0A0FFFFFFFFFFFFFFFFFFFFFF
      FFFF604830FFFFF0F0FFFFF0E0FFE0D0C0FF604830FFC0B0A0FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFF8FFFFFFF0F0FFF0F0E0FF604830FFC0B0A040C0B0
      A0FFC0B0A0FFC0A8A0FFC0A8A0FFC0A8A0FFC0A890FFC0A090FF60483040}
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -21
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = [fsBold]
    ParentFont = False
    FullHeight = 187
    object Panel2: TPanel
      Left = 0
      Top = 18
      Width = 664
      Height = 41
      Align = alTop
      TabOrder = 0
      object Label90: TLabel
        Left = 16
        Top = 14
        Width = 121
        Height = 16
        Caption = 'File Name(csv file):'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object JvFilenameEdit1: TJvFilenameEdit
        Left = 136
        Top = 11
        Width = 193
        Height = 24
        Filter = 'csv files (*.csv)|*.csv'
        ImeName = 'Microsoft Office IME 2007'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object JvBitBtn1: TJvBitBtn
        Left = 360
        Top = 10
        Width = 121
        Height = 25
        Caption = 'CSV Data Load'
        DoubleBuffered = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentDoubleBuffered = False
        ParentFont = False
        TabOrder = 1
        OnClick = JvBitBtn1Click
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -13
        HotTrackFont.Name = 'Tahoma'
        HotTrackFont.Style = []
      end
      object CheckBox1: TCheckBox
        Left = 487
        Top = 13
        Width = 97
        Height = 17
        Caption = 'Data Editing'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = CheckBox1Click
      end
    end
    object NextGrid1: TNextGrid
      Left = 0
      Top = 59
      Width = 664
      Height = 128
      Align = alClient
      HeaderSize = 30
      Options = [goGrid, goHeader, goSelectFullRow]
      RowSize = 30
      TabOrder = 1
      TabStop = True
      ExplicitHeight = 150
      object NxTextColumn1: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 200
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Header.Caption = 'Engine Load(%)'
        Header.Alignment = taCenter
        Options = [coCanClick, coCanInput, coCanSort, coEditing, coEditorAutoSelect, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 0
        SortType = stAlphabetic
        Width = 200
      end
      object NxTextColumn2: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 200
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Header.Caption = 'Eng. Output(kW)'
        Header.Alignment = taCenter
        Options = [coCanClick, coCanInput, coCanSort, coEditing, coEditorAutoSelect, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 1
        SortType = stAlphabetic
        Width = 200
      end
      object NxTextColumn3: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 200
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Header.Caption = 'Gen.Efficiency(%/100)'
        Header.Alignment = taCenter
        Options = [coCanClick, coCanInput, coCanSort, coEditing, coEditorAutoSelect, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 2
        SortType = stAlphabetic
        Width = 200
      end
      object NxTextColumn4: TNxTextColumn
        Alignment = taCenter
        DefaultWidth = 200
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Header.Caption = 'Gen.Output(kW)'
        Header.Alignment = taCenter
        Options = [coCanClick, coCanInput, coCanSort, coEditing, coEditorAutoSelect, coPublicUsing, coShowTextFitHint]
        ParentFont = False
        Position = 3
        SortType = stAlphabetic
        Width = 200
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 544
    Width = 664
    Height = 43
    Align = alBottom
    TabOrder = 3
    object BitBtn1: TBitBtn
      Left = 568
      Top = 6
      Width = 75
      Height = 25
      DoubleBuffered = True
      Kind = bkClose
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 19
      Top = 6
      Width = 97
      Height = 25
      Caption = 'Save'
      DoubleBuffered = True
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000FF00FF00FF00FF000000
        0000008080000080800000000000000000000000000000000000000000000000
        0000C0C0C000C0C0C000000000000080800000000000FF00FF00FF00FF000000
        0000008080000080800000000000000000000000000000000000000000000000
        0000C0C0C000C0C0C000000000000080800000000000FF00FF00FF00FF000000
        0000008080000080800000000000000000000000000000000000000000000000
        0000C0C0C000C0C0C000000000000080800000000000FF00FF00FF00FF000000
        0000008080000080800000000000000000000000000000000000000000000000
        00000000000000000000000000000080800000000000FF00FF00FF00FF000000
        0000008080000080800000808000008080000080800000808000008080000080
        80000080800000808000008080000080800000000000FF00FF00FF00FF000000
        0000008080000080800000000000000000000000000000000000000000000000
        00000000000000000000008080000080800000000000FF00FF00FF00FF000000
        00000080800000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
        C000C0C0C000C0C0C000000000000080800000000000FF00FF00FF00FF000000
        00000080800000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
        C000C0C0C000C0C0C000000000000080800000000000FF00FF00FF00FF000000
        00000080800000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
        C000C0C0C000C0C0C000000000000080800000000000FF00FF00FF00FF000000
        00000080800000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
        C000C0C0C000C0C0C000000000000080800000000000FF00FF00FF00FF000000
        00000080800000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
        C000C0C0C000C0C0C000000000000000000000000000FF00FF00FF00FF000000
        00000080800000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
        C000C0C0C000C0C0C00000000000C0C0C00000000000FF00FF00FF00FF000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      ParentDoubleBuffered = False
      TabOrder = 1
      OnClick = BitBtn2Click
    end
    object BitBtn3: TBitBtn
      Left = 144
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Load'
      DoubleBuffered = True
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00708890006080
        9000607880005070800050607000405860004048500030384000203030002020
        3000101820001010100010102000FF00FF00FF00FF00FF00FF007088900090A0
        B00070B0D0000090D0000090D0000090D0000090C0001088C0001080B0001080
        B0002078A0002070900020486000FF00FF00FF00FF00FF00FF008088900080C0
        D00090A8B00080E0FF0060D0FF0050C8FF0050C8FF0040C0F00030B0F00030A8
        F00020A0E0001090D0002068800020283000FF00FF00FF00FF008090A00080D0
        F00090A8B00090C0D00070D8FF0060D0FF0060D0FF0050C8FF0050C0FF0040B8
        F00030B0F00030A8F0001088D00020486000FF00FF00FF00FF008090A00080D8
        F00080C8E00090A8B00080E0FF0070D0FF0060D8FF0060D0FF0060D0FF0050C8
        FF0040C0F00040B8F00030B0F0002068800010486000FF00FF008098A00090E0
        F00090E0FF0090A8B00090B8C00070D8FF0060D8FF0060D8FF0060D8FF0060D0
        FF0050D0FF0050C8FF0040B8F00030A0E00040607000FF00FF008098A00090E0
        F000A0E8FF0080C8E00090A8B00080E0FF0080E0FF0080E0FF0080E0FF0080E0
        FF0080E0FF0080E0FF0070D8FF0070D8FF0050A8D0005060700090A0A000A0E8
        F000A0E8FF00A0E8FF0090B0C00090B0C00090A8B00090A8B00080A0B00080A0
        B0008098A0008098A0008090A0008090A000808890007088900090A0B000A0E8
        F000A0F0FF00A0E8FF00A0E8FF0080D8FF0060D8FF0060D8FF0060D8FF0060D8
        FF0060D8FF0060D8FF0070889000FF00FF00FF00FF00FF00FF0090A0B000A0F0
        F000B0F0F000A0F0FF00A0E8FF00A0E8FF0070D8FF0090A0A0008098A0008098
        A0008090A0008090900070889000FF00FF00FF00FF00FF00FF0090A8B000A0D0
        E000B0F0F000B0F0F000A0F0FF00A0E8FF0090A0B000FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00906850009068500090685000FF00FF0090A8
        B00090A8B00090A8B00090A8B00090A8B00090A8B000FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF009068500090685000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF009078
        6000FF00FF00FF00FF00FF00FF00A0908000FF00FF0090786000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00A0908000A0888000B0988000FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      ParentDoubleBuffered = False
      TabOrder = 2
      OnClick = BitBtn3Click
    end
  end
  object JvOpenDialog1: TJvOpenDialog
    Filter = '*.himecs||*.*'
    Height = 425
    Width = 656
    Left = 488
    Top = 88
  end
end
