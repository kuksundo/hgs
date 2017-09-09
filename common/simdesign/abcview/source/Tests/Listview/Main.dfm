object frmMain: TfrmMain
  Left = 205
  Top = 106
  Width = 783
  Height = 540
  Caption = 'frmMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 352
    Top = 8
    Width = 169
    Height = 13
    Caption = 'Specify Folder that you want to load'
  end
  object Label2: TLabel
    Left = 352
    Top = 56
    Width = 30
    Height = 13
    Caption = 'Size X'
  end
  object Label3: TLabel
    Left = 416
    Top = 56
    Width = 30
    Height = 13
    Caption = 'Size Y'
  end
  object lblFileCount: TLabel
    Left = 648
    Top = 72
    Width = 54
    Height = 13
    Caption = 'lblFileCount'
  end
  object nbType: TNotebook
    Left = 0
    Top = 137
    Width = 775
    Height = 369
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TPage
      Left = 0
      Top = 0
      Caption = 'Listview'
      DesignSize = (
        775
        369)
      object lvList: TListView
        Left = 8
        Top = 16
        Width = 609
        Height = 345
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Name'
          end>
        LargeImages = ilList
        MultiSelect = True
        OwnerData = True
        SmallImages = ilList
        TabOrder = 0
        OnData = lvListData
      end
      object GroupBox2: TGroupBox
        Left = 632
        Top = 16
        Width = 129
        Height = 129
        Anchors = [akTop, akRight]
        Caption = 'Type'
        TabOrder = 1
        OnClick = ListStyleChanged
        object rbIcon: TRadioButton
          Left = 8
          Top = 24
          Width = 113
          Height = 17
          Caption = 'Icon'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = ListStyleChanged
        end
        object rbList: TRadioButton
          Left = 8
          Top = 48
          Width = 113
          Height = 17
          Caption = 'List'
          TabOrder = 1
          OnClick = ListStyleChanged
        end
        object rbReport: TRadioButton
          Left = 8
          Top = 72
          Width = 113
          Height = 17
          Caption = 'Report'
          TabOrder = 2
          OnClick = ListStyleChanged
        end
        object rbSmallIcon: TRadioButton
          Left = 8
          Top = 96
          Width = 113
          Height = 17
          Caption = 'Small Icon'
          TabOrder = 3
          OnClick = ListStyleChanged
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Treeview'
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Drawgrid'
      DesignSize = (
        775
        369)
      object dgList: TDrawGrid
        Left = 16
        Top = 8
        Width = 617
        Height = 353
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 6
        DefaultColWidth = 80
        DefaultRowHeight = 100
        FixedCols = 0
        FixedRows = 0
        GridLineWidth = 0
        TabOrder = 0
        OnDrawCell = dgListDrawCell
      end
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 321
    Height = 121
    Caption = 'Select Table type'
    TabOrder = 1
    object rbListview: TRadioButton
      Left = 16
      Top = 24
      Width = 113
      Height = 17
      Caption = 'Listview'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = TableTypeChanged
    end
    object rbTreeview: TRadioButton
      Left = 16
      Top = 48
      Width = 113
      Height = 17
      Caption = 'Virtual Treeview'
      TabOrder = 1
      OnClick = TableTypeChanged
    end
    object rbDrawgrid: TRadioButton
      Left = 16
      Top = 72
      Width = 113
      Height = 17
      Caption = 'Drawgrid'
      TabOrder = 2
      OnClick = TableTypeChanged
    end
  end
  object deFolder: TDirectoryEdit
    Left = 352
    Top = 24
    Width = 281
    Height = 21
    DialogKind = dkWin32
    NumGlyphs = 1
    TabOrder = 2
  end
  object btnLoad: TButton
    Left = 648
    Top = 22
    Width = 75
    Height = 25
    Caption = 'Load Now!'
    TabOrder = 3
    OnClick = btnLoadClick
  end
  object edSizeX: TEdit
    Left = 352
    Top = 72
    Width = 49
    Height = 21
    TabOrder = 4
    Text = '70'
  end
  object edSizeY: TEdit
    Left = 416
    Top = 72
    Width = 49
    Height = 21
    TabOrder = 5
    Text = '70'
  end
  object btnSizeApply: TButton
    Left = 472
    Top = 70
    Width = 75
    Height = 25
    Caption = 'Apply!'
    TabOrder = 6
    OnClick = btnSizeApplyClick
  end
  object chbInclude: TCheckBox
    Left = 648
    Top = 48
    Width = 113
    Height = 17
    Caption = 'Include Subfolders'
    TabOrder = 7
  end
  object ilList: TImageList
    Height = 70
    Width = 70
    Left = 320
    Top = 16
  end
end
