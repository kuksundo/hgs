object Form1: TForm1
  Left = 310
  Top = 367
  Width = 776
  Height = 491
  Caption = 'DxfAnalyse'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 321
    Top = 0
    Height = 418
  end
  object vstDxf: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 321
    Height = 418
    Align = alLeft
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoVisible]
    NodeDataSize = 4
    TabOrder = 0
    TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect]
    OnChange = vstDxfChange
    OnGetText = vstDxfGetText
    OnInitChildren = vstDxfInitChildren
    OnInitNode = vstDxfInitNode
    Columns = <
      item
        Position = 0
        Width = 200
        WideText = 'Entity'
      end
      item
        Position = 1
        Width = 100
        WideText = 'Name'
      end>
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 418
    Width = 768
    Height = 19
    Panels = <>
  end
  object vstProps: TVirtualStringTree
    Left = 324
    Top = 0
    Width = 444
    Height = 418
    Align = alClient
    EditDelay = 200
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoVisible]
    RootNodeCount = 2
    TabOrder = 2
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toExtendedFocus]
    OnEditing = vstPropsEditing
    OnGetText = vstPropsGetText
    OnNewText = vstPropsNewText
    Columns = <
      item
        Position = 0
        WideText = 'ID'
      end
      item
        Position = 1
        Width = 150
        WideText = 'Function'
      end
      item
        Position = 2
        Width = 220
        WideText = 'Value'
      end>
  end
  object MainMenu1: TMainMenu
    Left = 592
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object mnuNew: TMenuItem
        Caption = 'New'
        OnClick = mnuNewClick
      end
      object mnuOpenDXF: TMenuItem
        Caption = 'Open DXF'
        OnClick = mnuOpenDXFClick
      end
      object mnuSaveDXF: TMenuItem
        Caption = 'Save DXF'
        OnClick = mnuSaveDXFClick
      end
      object mnuSaveDxfAs: TMenuItem
        Caption = 'Save Dxf As...'
        OnClick = mnuSaveDxfAsClick
      end
    end
  end
end
