object TagInfoEditorDlg: TTagInfoEditorDlg
  Left = 0
  Top = 0
  Caption = 'TagInfoEditorDlg'
  ClientHeight = 423
  ClientWidth = 556
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 556
    Height = 57
    Align = alTop
    TabOrder = 0
    object RadioGroup1: TRadioGroup
      Left = 456
      Top = 1
      Width = 99
      Height = 55
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'Tag Name'
        'Description')
      ParentFont = False
      TabOrder = 0
    end
    object WholeWordCB: TCheckBox
      Left = 8
      Top = 4
      Width = 97
      Height = 17
      Caption = 'Whole words'
      TabOrder = 1
    end
    object SearchEdit: TEdit
      Left = 8
      Top = 24
      Width = 361
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ImeName = 'Microsoft IME 2010'
      ParentFont = False
      TabOrder = 2
      OnKeyPress = SearchEditKeyPress
    end
    object BitBtn3: TBitBtn
      Left = 376
      Top = 24
      Width = 77
      Height = 25
      Caption = 'Search'
      TabOrder = 3
      OnClick = BitBtn3Click
    end
    object CaseCB: TCheckBox
      Left = 103
      Top = 3
      Width = 97
      Height = 17
      Caption = 'Case Sensitive'
      TabOrder = 4
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 374
    Width = 556
    Height = 49
    Align = alBottom
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 112
      Top = 6
      Width = 105
      Height = 33
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 344
      Top = 6
      Width = 105
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object ListView1: TListView
    Left = 0
    Top = 57
    Width = 556
    Height = 317
    Align = alClient
    Columns = <
      item
        Caption = 'Tag Name'
        Width = 200
      end
      item
        Caption = 'Description'
        Width = 300
      end
      item
        Caption = 'Value'
      end
      item
        Caption = 'Index'
      end>
    ColumnClick = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    GridLines = True
    HideSelection = False
    RowSelect = True
    ParentFont = False
    TabOrder = 2
    ViewStyle = vsReport
  end
end
