object SelectProjectForm: TSelectProjectForm
  Left = 0
  Top = 0
  Caption = 'Open Project'
  ClientHeight = 421
  ClientWidth = 538
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 195
    Width = 538
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 49
    ExplicitWidth = 171
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 538
    Height = 49
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 56
      Top = 16
      Width = 131
      Height = 16
      Caption = 'Open recent project'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Image1: TImage
      Left = 8
      Top = 8
      Width = 41
      Height = 33
    end
  end
  object projectLV: TListView
    Left = 0
    Top = 49
    Width = 538
    Height = 146
    Align = alClient
    Columns = <
      item
        Caption = 'Project Name'
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
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 1
    ViewStyle = vsReport
    OnDblClick = projectLVDblClick
    OnSelectItem = projectLVSelectItem
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 397
    Width = 538
    Height = 24
    Panels = <>
  end
  object Panel2: TPanel
    Left = 0
    Top = 348
    Width = 538
    Height = 49
    Align = alBottom
    TabOrder = 3
    object BitBtn1: TBitBtn
      Left = 16
      Top = 8
      Width = 97
      Height = 33
      Caption = 'Open'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 128
      Top = 8
      Width = 89
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
    object BitBtn3: TBitBtn
      Left = 331
      Top = 10
      Width = 89
      Height = 33
      Caption = 'Browse'
      TabOrder = 2
      OnClick = BitBtn3Click
    end
    object CreateBtn: TBitBtn
      Left = 434
      Top = 10
      Width = 89
      Height = 33
      Caption = 'Create'
      TabOrder = 3
      OnClick = CreateBtnClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 198
    Width = 538
    Height = 150
    Align = alBottom
    TabOrder = 4
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 536
      Height = 148
      Align = alClient
      Caption = 'Description'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object DescriptMemo: TMemo
        Left = 2
        Top = 18
        Width = 532
        Height = 128
        Align = alClient
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 0
      end
    end
  end
  object JvSaveDialog1: TJvSaveDialog
    Height = 0
    Width = 0
    Left = 8
    Top = 80
  end
  object PopupMenu1: TPopupMenu
    Left = 48
    Top = 80
    object ProjectPropertyView1: TMenuItem
      Caption = 'Project Property View'
      OnClick = ProjectPropertyView1Click
    end
  end
  object JvSelectDirectory1: TJvSelectDirectory
    Left = 88
    Top = 80
  end
end
