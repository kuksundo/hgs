object ConfigProjectFileForm: TConfigProjectFileForm
  Left = 0
  Top = 0
  Caption = 'Configure Project File'
  ClientHeight = 479
  ClientWidth = 595
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    595
    479)
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 147
    Width = 595
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 191
    ExplicitWidth = 493
  end
  object Panel2: TPanel
    Left = 0
    Top = 430
    Width = 595
    Height = 49
    Align = alBottom
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 99
      Top = 8
      Width = 97
      Height = 33
      Caption = 'Create'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 427
      Top = 6
      Width = 89
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
    object BitBtn6: TBitBtn
      Left = 259
      Top = 6
      Width = 97
      Height = 33
      Caption = 'Save As'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 2
      Visible = False
      OnClick = BitBtn6Click
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 150
    Width = 595
    Height = 280
    ActivePage = TabSheet1
    Align = alBottom
    TabHeight = 30
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'General'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      object Label1: TLabel
        Left = 15
        Top = 40
        Width = 103
        Height = 16
        Caption = 'Option File Name:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label4: TLabel
        Left = 6
        Top = 136
        Width = 142
        Height = 16
        Caption = 'Project Item Description:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label6: TLabel
        Left = 4
        Top = 69
        Width = 111
        Height = 16
        Caption = 'Run List File Name:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label7: TLabel
        Left = 9
        Top = 99
        Width = 109
        Height = 16
        Caption = 'Monitor File Name:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label8: TLabel
        Left = 6
        Top = 12
        Width = 112
        Height = 16
        Caption = 'Project Item Name:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object OptionFilenameEdit: TJvFilenameEdit
        Left = 124
        Top = 39
        Width = 204
        Height = 24
        Filter = 'HiMECS Option(*.option)|*.option|All files (*.*)|*.*'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
      end
      object EncryptOptionCB: TCheckBox
        Left = 342
        Top = 41
        Width = 131
        Height = 17
        Caption = 'Encrypt Option File'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object PrjDescriptMemo: TMemo
        Left = 4
        Top = 158
        Width = 569
        Height = 79
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
      end
      object RunListFilenameEdit: TJvFilenameEdit
        Left = 124
        Top = 69
        Width = 204
        Height = 24
        Hint = 'Run program list file'
        Filter = ' Run list(*.rlist)|*.rlist|All files (*.*)|*.*'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 3
      end
      object MonitorFilenameEdit: TJvFilenameEdit
        Left = 124
        Top = 99
        Width = 204
        Height = 24
        Hint = 'Monitoring form list file'
        Filter = ' Monitor list(*.mlist)|*.mlist|All files (*.*)|*.*'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 4
      end
      object EncryptRunListCB: TCheckBox
        Left = 342
        Top = 70
        Width = 147
        Height = 17
        Caption = 'Encrypt RunList File'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
      end
      object EncryptMonitorCB: TCheckBox
        Left = 342
        Top = 100
        Width = 131
        Height = 17
        Caption = 'Encrypt Moitor File'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
      end
      object ProjectItemEdit: TEdit
        Left = 124
        Top = 8
        Width = 449
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 7
      end
      object BitBtn4: TBitBtn
        Left = 479
        Top = 69
        Width = 94
        Height = 25
        Caption = 'Run List Config'
        TabOrder = 8
        OnClick = BitBtn4Click
      end
      object BitBtn5: TBitBtn
        Left = 479
        Top = 99
        Width = 94
        Height = 25
        Caption = 'Monitor Config'
        TabOrder = 9
        OnClick = BitBtn5Click
      end
      object BitBtn3: TBitBtn
        Left = 478
        Top = 39
        Width = 94
        Height = 25
        Caption = 'Option Config'
        TabOrder = 10
        OnClick = BitBtn3Click
      end
    end
    object users: TTabSheet
      Caption = 'Users'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      object Label2: TLabel
        Left = 32
        Top = 48
        Width = 102
        Height = 16
        Caption = 'Authorized Users:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label3: TLabel
        Left = 36
        Top = 142
        Width = 98
        Height = 16
        Caption = 'Prohibited Users:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label5: TLabel
        Left = 31
        Top = 12
        Width = 92
        Height = 16
        Caption = 'User File Name:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object ListView1: TListView
        Left = 140
        Top = 49
        Width = 281
        Height = 73
        Columns = <
          item
            Caption = 'User ID'
            Width = 150
          end>
        TabOrder = 0
        ViewStyle = vsReport
      end
      object ListView2: TListView
        Left = 140
        Top = 142
        Width = 281
        Height = 73
        Columns = <
          item
            Caption = 'User ID'
            Width = 150
          end>
        TabOrder = 1
        ViewStyle = vsReport
      end
      object UserFilenameEdit: TJvFilenameEdit
        Left = 140
        Top = 9
        Width = 281
        Height = 24
        Filter = 'HiMECS User File(*.user)|*.user|All files (*.*)|*.*'
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 2
      end
    end
  end
  object ProjectItemLV: TListView
    Left = 0
    Top = 49
    Width = 595
    Height = 98
    Align = alClient
    Columns = <
      item
        Caption = 'Project Item Name'
        Width = 150
      end
      item
        Caption = 'Path'
        Width = 250
      end
      item
        Caption = 'Last Access'
        Width = 100
      end>
    GridLines = True
    HotTrackStyles = [htUnderlineCold]
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
    OnClick = ProjectItemLVClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 595
    Height = 49
    Align = alTop
    TabOrder = 3
    object Label9: TLabel
      Left = 442
      Top = 18
      Width = 104
      Height = 16
      Caption = 'Project Item Move'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
    end
    object Button1: TButton
      Left = 99
      Top = 8
      Width = 97
      Height = 35
      Caption = 'Add Item'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 315
      Top = 8
      Width = 89
      Height = 35
      Caption = 'Delete Item'
      TabOrder = 1
      OnClick = Button2Click
    end
    object SpinButton1: TSpinButton
      Left = 552
      Top = 16
      Width = 20
      Height = 25
      DownGlyph.Data = {
        0E010000424D0E01000000000000360000002800000009000000060000000100
        200000000000D800000000000000000000000000000000000000008080000080
        8000008080000080800000808000008080000080800000808000008080000080
        8000008080000080800000808000000000000080800000808000008080000080
        8000008080000080800000808000000000000000000000000000008080000080
        8000008080000080800000808000000000000000000000000000000000000000
        0000008080000080800000808000000000000000000000000000000000000000
        0000000000000000000000808000008080000080800000808000008080000080
        800000808000008080000080800000808000}
      TabOrder = 2
      UpGlyph.Data = {
        0E010000424D0E01000000000000360000002800000009000000060000000100
        200000000000D800000000000000000000000000000000000000008080000080
        8000008080000080800000808000008080000080800000808000008080000080
        8000000000000000000000000000000000000000000000000000000000000080
        8000008080000080800000000000000000000000000000000000000000000080
        8000008080000080800000808000008080000000000000000000000000000080
        8000008080000080800000808000008080000080800000808000000000000080
        8000008080000080800000808000008080000080800000808000008080000080
        800000808000008080000080800000808000}
      OnDownClick = SpinButton1DownClick
      OnUpClick = SpinButton1UpClick
    end
  end
  object Button3: TButton
    Left = 482
    Top = 152
    Width = 105
    Height = 28
    Anchors = [akRight, akBottom]
    Caption = 'Apply Item'
    TabOrder = 4
    OnClick = Button3Click
  end
end
