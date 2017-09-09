object AxisSelectF: TAxisSelectF
  Left = 0
  Top = 0
  Caption = 'Axis Select'
  ClientHeight = 216
  ClientWidth = 303
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 175
    Width = 303
    Height = 41
    Align = alBottom
    TabOrder = 0
    ExplicitWidth = 296
    object BitBtn1: TBitBtn
      Left = 48
      Top = 6
      Width = 75
      Height = 27
      DoubleBuffered = True
      Kind = bkOK
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 176
      Top = 6
      Width = 75
      Height = 27
      DoubleBuffered = True
      Kind = bkCancel
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 1
    end
  end
  object XYSelectGrid: TNextGrid
    Left = 0
    Top = 35
    Width = 303
    Height = 140
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Options = [goGrid, goHeader]
    ParentFont = False
    TabOrder = 1
    TabStop = True
    object ItemName: TNxTextColumn
      DefaultWidth = 200
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Header.Caption = 'Item Name'
      ParentFont = False
      Position = 0
      SortType = stAlphabetic
      Width = 200
    end
    object NxComboBoxColumn1: TNxComboBoxColumn
      Alignment = taCenter
      DefaultValue = 'X'
      DefaultWidth = 30
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Header.Caption = 'Axis'
      Header.Alignment = taCenter
      Header.HideArrow = False
      Options = [coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint]
      ParentFont = False
      Position = 1
      SortType = stAlphabetic
      Width = 30
      Items.Strings = (
        'X'
        'Y')
    end
    object NxCheckBoxColumn1: TNxCheckBoxColumn
      Alignment = taCenter
      DefaultWidth = 70
      Header.Caption = 'Constant'
      Header.Alignment = taCenter
      Position = 2
      SortType = stBoolean
      Width = 70
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 303
    Height = 35
    Align = alTop
    TabOrder = 2
    ExplicitWidth = 296
    object CheckBox1: TCheckBox
      Left = 16
      Top = 10
      Width = 97
      Height = 17
      Caption = 'Data Duplicated'
      TabOrder = 0
    end
  end
end
