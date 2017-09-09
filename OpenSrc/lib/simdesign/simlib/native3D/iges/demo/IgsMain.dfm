object frmMain: TfrmMain
  Left = 260
  Top = 331
  Width = 844
  Height = 598
  Caption = 'IGES Analyse'
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
  object sbMain: TStatusBar
    Left = 0
    Top = 521
    Width = 828
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object pcMain: TPageControl
    Left = 0
    Top = 0
    Width = 828
    Height = 521
    ActivePage = tsViewer
    Align = alClient
    TabOrder = 1
    object tsStart: TTabSheet
      Caption = 'Start'
      DesignSize = (
        820
        493)
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 204
        Height = 13
        Caption = 'Start Section Information (max 72 columns):'
      end
      object mmStart: TMemo
        Left = 8
        Top = 32
        Width = 813
        Height = 428
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object tsGlobal: TTabSheet
      Caption = 'Global'
      ImageIndex = 1
      DesignSize = (
        820
        493)
      object lvGlobal: TListView
        Left = 8
        Top = 8
        Width = 385
        Height = 452
        Anchors = [akLeft, akTop, akBottom]
        Columns = <
          item
            Caption = 'Variable'
            Width = 180
          end
          item
            Caption = 'Value'
            Width = 180
          end>
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object tsEntities: TTabSheet
      Caption = 'Entities'
      ImageIndex = 2
      object Splitter1: TSplitter
        Left = 569
        Top = 0
        Height = 497
      end
      object vstIgs: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 569
        Height = 497
        Align = alLeft
        EditDelay = 300
        Header.AutoSizeIndex = -1
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoDrag, hoVisible]
        NodeDataSize = 4
        TabOrder = 0
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toMultiSelect]
        OnChange = vstIgsChange
        OnEditing = vstIgsEditing
        OnGetText = vstIgsGetText
        OnInitChildren = vstIgsInitChildren
        OnInitNode = vstIgsInitNode
        OnNewText = vstIgsNewText
        Columns = <
          item
            Position = 0
            WideText = 'SeqNo'
          end
          item
            Position = 1
            Width = 150
            WideText = 'EntityType'
          end
          item
            Position = 2
            Width = 40
            WideText = 'Level'
          end
          item
            Position = 3
            Width = 40
            WideText = 'Matrix'
          end
          item
            Position = 4
            Width = 60
            WideText = 'Status'
          end
          item
            Position = 5
            Width = 60
            WideText = 'Color'
          end
          item
            Position = 6
            WideText = 'Form'
          end
          item
            Position = 7
            WideText = 'Structure'
          end
          item
            Position = 8
            WideText = 'LineFont'
          end
          item
            Position = 9
            WideText = 'View'
          end
          item
            Position = 10
            WideText = 'LabelDispAssoc'
          end
          item
            Position = 11
            WideText = 'LineWeight'
          end
          item
            Position = 12
            WideText = 'EntityLabel'
          end
          item
            Position = 13
            WideText = 'EntitySubscript'
          end
          item
            Position = 14
            WideText = 'ParamData'
          end
          item
            Position = 15
            WideText = 'ParamLineCount'
          end>
      end
      object Panel2: TPanel
        Left = 572
        Top = 0
        Width = 256
        Height = 497
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object vstProps: TVirtualStringTree
          Left = 0
          Top = 97
          Width = 256
          Height = 400
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
          TabOrder = 0
          TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect]
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
              Width = 70
              WideText = 'Function'
            end
            item
              Position = 2
              Width = 100
              WideText = 'Value'
            end>
        end
        object vstStatus: TVirtualStringTree
          Left = 0
          Top = 0
          Width = 256
          Height = 97
          Align = alTop
          EditDelay = 200
          Header.AutoSizeIndex = 0
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'MS Sans Serif'
          Header.Font.Style = []
          Header.Options = [hoColumnResize, hoDrag, hoVisible]
          RootNodeCount = 2
          TabOrder = 1
          TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect]
          OnGetText = vstStatusGetText
          Columns = <
            item
              Position = 0
              Width = 80
              WideText = 'Status Flag'
            end
            item
              Position = 1
              Width = 150
              WideText = 'Value'
            end>
        end
      end
    end
    object tsViewer: TTabSheet
      Caption = 'Viewer'
      ImageIndex = 5
      DesignSize = (
        820
        493)
      object Label2: TLabel
        Left = 664
        Top = 24
        Width = 101
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Choose camera style:'
      end
      object Label3: TLabel
        Left = 664
        Top = 72
        Width = 80
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Imported entities:'
      end
      object Panel3: TPanel
        Left = 16
        Top = 16
        Width = 641
        Height = 465
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'pnlViewer'
        TabOrder = 0
        inline Viewer: TfrViewer
          Left = 1
          Top = 1
          Width = 639
          Height = 463
          Align = alClient
          TabOrder = 0
          inherited GLViewer: TGLSceneViewer
            Width = 639
            Height = 463
            FieldOfView = 133.274642944335900000
          end
          inherited GLScene: TGLScene
            inherited GLDummyCube: TGLDummyCube
              Direction.Coordinates = {00000000000080BF0000000000000000}
              Up.Coordinates = {00000000000000000000803F00000000}
            end
            inherited GLLightSource: TGLLightSource
              Position.Coordinates = {0000A0400000A0400000A0400000803F}
            end
            inherited GLCamera: TGLCamera
              FocalLength = 100.000015258789100000
              Position.Coordinates = {0000204100002041000020410000803F}
            end
          end
        end
      end
      object cbbCamStyle: TComboBox
        Left = 664
        Top = 40
        Width = 121
        Height = 21
        Style = csDropDownList
        Anchors = [akTop, akRight]
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Perspective'
        OnChange = cbbCamStyleChange
        Items.Strings = (
          'Perspective'
          'Orthogonal X'
          'Orthogonal Y'
          'Orthogonal Z')
      end
      object clbImports: TCheckListBox
        Left = 664
        Top = 88
        Width = 153
        Height = 201
        OnClickCheck = clbImportsClickCheck
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 2
      end
      object btnHideAll: TButton
        Left = 664
        Top = 304
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'btnHideAll'
        TabOrder = 3
        OnClick = btnHideAllClick
      end
    end
    object tsTest: TTabSheet
      Caption = 'Test'
      ImageIndex = 4
      object mmTest: TMemo
        Left = 8
        Top = 8
        Width = 249
        Height = 281
        TabOrder = 0
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 592
    object File1: TMenuItem
      Caption = 'File'
      object mnuNew: TMenuItem
        Caption = 'New'
        OnClick = mnuNewClick
      end
      object mnuOpenIGS: TMenuItem
        Caption = 'Open IGS'
        OnClick = mnuOpenIGSClick
      end
      object mnuSaveIGS: TMenuItem
        Caption = 'Save IGS'
        OnClick = mnuSaveIGSClick
      end
      object mnuSaveIgsAs: TMenuItem
        Caption = 'Save IGS As...'
        OnClick = mnuSaveIgsAsClick
      end
      object mnuExit: TMenuItem
        Caption = 'Exit'
        OnClick = mnuExitClick
      end
    end
    object View1: TMenuItem
      Caption = 'View'
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object mnuStructureOnly: TMenuItem
        Caption = 'Geometric structure only'
        OnClick = mnuStructureOnlyClick
      end
    end
    object est1: TMenuItem
      Caption = 'Test'
      object Nurbs1: TMenuItem
        Caption = 'Nurbs'
        OnClick = Nurbs1Click
      end
    end
  end
end
