object frmMain: TfrmMain
  Left = 264
  Top = 114
  Width = 988
  Height = 640
  Caption = 'Triangulation demo by Nils Haeck (www.simdesign.nl)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 169
    Height = 567
    Align = alLeft
    TabOrder = 0
    object lbBeta: TLabel
      Left = 16
      Top = 85
      Width = 53
      Height = 13
      Caption = 'Min. Angle:'
    end
    object Label1: TLabel
      Left = 16
      Top = 144
      Width = 137
      Height = 13
      Caption = 'Remove triangles afterwards:'
    end
    object Label2: TLabel
      Left = 32
      Top = 125
      Width = 35
      Height = 13
      Caption = 'Sq. pix:'
    end
    object btnTriangulate: TButton
      Left = 16
      Top = 16
      Width = 137
      Height = 25
      Caption = 'Triangulate'
      TabOrder = 0
      OnClick = btnTriangulateClick
    end
    object chbCenter: TCheckBox
      Left = 16
      Top = 232
      Width = 97
      Height = 17
      Caption = 'Triangle Centers'
      Checked = True
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbChecked
      TabOrder = 1
      OnClick = chbCenterClick
    end
    object chbDelaunayCircle: TCheckBox
      Left = 16
      Top = 248
      Width = 97
      Height = 17
      Caption = 'Delaunay Circle'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = chbDelaunayCircleClick
    end
    object chbExecutionSteps: TCheckBox
      Left = 16
      Top = 272
      Width = 121
      Height = 17
      Caption = 'Execution Steps'
      TabOrder = 3
      OnClick = chbExecutionStepsClick
    end
    object btnNext: TButton
      Left = 40
      Top = 312
      Width = 75
      Height = 25
      Caption = 'Next >'
      Enabled = False
      TabOrder = 4
      OnClick = btnNextClick
    end
    object chbPolygon: TCheckBox
      Left = 16
      Top = 184
      Width = 97
      Height = 17
      Caption = 'Polygon'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      State = cbChecked
      TabOrder = 5
      OnClick = chbPolygonClick
    end
    object mmInfo: TMemo
      Left = 1
      Top = 376
      Width = 167
      Height = 190
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssHorizontal
      TabOrder = 6
    end
    object chbVertices: TCheckBox
      Left = 16
      Top = 200
      Width = 97
      Height = 17
      Caption = 'Vertices'
      Checked = True
      State = cbChecked
      TabOrder = 7
      OnClick = chbVerticesClick
    end
    object chbDelaunayMesh: TCheckBox
      Left = 16
      Top = 48
      Width = 97
      Height = 17
      Caption = 'Delaunay Mesh'
      Checked = True
      State = cbChecked
      TabOrder = 8
      OnClick = chbDelaunayMeshClick
    end
    object chbQualityMesh: TCheckBox
      Left = 16
      Top = 64
      Width = 97
      Height = 17
      Caption = 'Quality Mesh'
      Checked = True
      State = cbChecked
      TabOrder = 9
      OnClick = chbQualityMeshClick
    end
    object edMinAngle: TEdit
      Left = 80
      Top = 82
      Width = 73
      Height = 21
      TabOrder = 10
      Text = '20'
      OnExit = edMinAngleExit
    end
    object chbSegments: TCheckBox
      Left = 16
      Top = 216
      Width = 97
      Height = 17
      Caption = 'Segments'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 11
      OnClick = chbSegmentsClick
    end
    object cbbRemoval: TComboBox
      Left = 16
      Top = 160
      Width = 137
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 12
      Text = 'Leave construction'
      Items.Strings = (
        'Leave construction'
        'Outside only'
        'Even-Odd Fillrule'
        'Non-Zero Fillrule')
    end
    object chbPhaseSteps: TCheckBox
      Left = 16
      Top = 288
      Width = 121
      Height = 17
      Caption = 'Phase Steps'
      TabOrder = 13
      OnClick = chbPhaseStepsClick
    end
    object btnAuto: TButton
      Left = 40
      Top = 344
      Width = 75
      Height = 25
      Caption = 'Auto >>'
      TabOrder = 14
      OnClick = btnAutoClick
    end
    object chbMaxElementSize: TCheckBox
      Left = 16
      Top = 104
      Width = 137
      Height = 17
      Caption = 'Max. element size:'
      TabOrder = 15
    end
    object edMaxElementSize: TEdit
      Left = 80
      Top = 120
      Width = 73
      Height = 21
      TabOrder = 16
      Text = '100'
    end
  end
  object pnlMain: TPanel
    Left = 169
    Top = 0
    Width = 811
    Height = 567
    Align = alClient
    TabOrder = 1
    object pbMain: TPaintBox
      Left = 1
      Top = 1
      Width = 809
      Height = 565
      Align = alClient
      OnClick = pbMainClick
      OnMouseDown = pbMainMouseDown
      OnPaint = pbMainPaint
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 567
    Width = 980
    Height = 19
    Panels = <
      item
        Width = 400
      end
      item
        Width = 200
      end>
  end
  object MainMenu1: TMainMenu
    Left = 817
    Top = 24
    object mnuFile: TMenuItem
      Caption = 'File'
      object mnuLoadPSLG: TMenuItem
        Caption = 'Load PSLG'
        OnClick = mnuLoadPSLGClick
      end
      object mnuSavePSLG: TMenuItem
        Caption = 'Save PSLG'
        OnClick = mnuSavePSLGClick
      end
      object mnuExit: TMenuItem
        Caption = 'Exit'
        OnClick = mnuExitClick
      end
    end
    object mnuEdit: TMenuItem
      Caption = 'Edit'
      object mnuClearAll: TMenuItem
        Caption = 'Clear All'
        OnClick = mnuClearAllClick
      end
      object mnuClearMesh: TMenuItem
        Caption = 'Clear Mesh'
        OnClick = mnuClearMeshClick
      end
      object mnuAddPolygon: TMenuItem
        Caption = 'Add Polygon'
        OnClick = mnuAddPolygonClick
      end
      object mnuClosePolygon: TMenuItem
        Caption = 'Close Polygon'
        OnClick = mnuClosePolygonClick
      end
    end
    object mnuGraphs: TMenuItem
      Caption = 'Graphs'
      object mnuRandomPoints: TMenuItem
        Caption = 'Random Points'
        OnClick = mnuRandomPointsClick
      end
      object mnuCircle: TMenuItem
        Caption = 'Circle'
        OnClick = mnuCircleClick
      end
      object mnuEllipse: TMenuItem
        Caption = 'Ellipse'
        OnClick = mnuEllipseClick
      end
      object mnuBox: TMenuItem
        Caption = 'Box'
        OnClick = mnuBoxClick
      end
      object mnuPlatewithholes: TMenuItem
        Caption = 'Plate with holes'
        OnClick = mnuPlatewithholesClick
      end
      object mnuIntersection: TMenuItem
        Caption = 'Intersecting Rectangles'
        OnClick = mnuIntersectionClick
      end
      object mnuSimpleBox: TMenuItem
        Caption = 'Simple Box'
        OnClick = mnuSimpleBoxClick
      end
      object mnuOnePoint: TMenuItem
        Caption = 'One Point'
        OnClick = mnuOnePointClick
      end
    end
    object mnuMesh: TMenuItem
      Caption = 'Mesh'
      object mnuLocalRefine: TMenuItem
        Caption = 'Local refine (click)'
        OnClick = mnuLocalRefineClick
      end
    end
  end
  object tmAuto: TTimer
    Enabled = False
    Interval = 50
    OnTimer = tmAutoTimer
    Left = 785
    Top = 24
  end
end
