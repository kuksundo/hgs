object frmMain: TfrmMain
  Left = 390
  Top = 263
  Width = 769
  Height = 450
  Caption = 
    'Geometric fitting to pointclouds (c) SimDesign B.V. (Nils Haeck ' +
    'M.Sc)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 557
    Top = 0
    Height = 377
    Align = alRight
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 377
    Width = 761
    Height = 19
    Panels = <>
  end
  object pnlRight: TPanel
    Left = 560
    Top = 0
    Width = 201
    Height = 377
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 201
      Height = 81
      Align = alTop
      TabOrder = 0
      object lbZoom: TLabel
        Left = 8
        Top = 8
        Width = 56
        Height = 13
        Caption = 'Zoom 100%'
      end
      object tbZoom: TTrackBar
        Left = 8
        Top = 24
        Width = 177
        Height = 41
        LineSize = 10
        Max = 300
        Min = -300
        PageSize = 20
        Frequency = 20
        TabOrder = 0
        ThumbLength = 10
        OnChange = tbZoomChange
      end
    end
    object pnlBtm: TPanel
      Left = 0
      Top = 81
      Width = 201
      Height = 296
      Align = alClient
      TabOrder = 1
      object mmDebug: TMemo
        Left = 1
        Top = 1
        Width = 199
        Height = 294
        Align = alClient
        Lines.Strings = (
          'debug info:')
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object pnlCenter: TPanel
    Left = 0
    Top = 0
    Width = 557
    Height = 377
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object GLSceneViewer: TGLSceneViewer
      Left = 0
      Top = 0
      Width = 557
      Height = 377
      Camera = GLCamera
      Buffer.BackgroundColor = clBlack
      FieldOfView = 150.288558959960900000
      Align = alClient
      OnMouseDown = GLSceneViewerMouseDown
      OnMouseMove = GLSceneViewerMouseMove
    end
  end
  object MainMenu1: TMainMenu
    Left = 392
    Top = 16
    object File1: TMenuItem
      Caption = 'File'
      object LoadPointcloud1: TMenuItem
        Action = acLoadPointcloud
      end
      object mnuClearAll: TMenuItem
        Caption = 'Clear all'
        OnClick = mnuClearAllClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Action = acExit
      end
    end
    object Geometry1: TMenuItem
      Caption = 'Geometry'
      object mnuFittogeometricalobject: TMenuItem
        Caption = 'Fit to geometrical object'
        object FittoCone1: TMenuItem
          Action = acGeomFitCone
        end
        object FittoSphere1: TMenuItem
          Action = acGeomFitSphere
        end
      end
    end
    object est1: TMenuItem
      Caption = 'Test'
      object mnuRandomconepoints: TMenuItem
        Caption = 'Random cone points (10.000)'
        OnClick = mnuRandomconepointsClick
      end
      object mnuRandomspherepoints: TMenuItem
        Caption = 'Random sphere points (10.000)'
        OnClick = mnuRandomspherepointsClick
      end
      object mnuEvenlydistributedspherepoints: TMenuItem
        Caption = 'Evenly distributed sphere points'
        OnClick = mnuEvenlydistributedspherepointsClick
      end
    end
  end
  object ActionList1: TActionList
    Left = 424
    Top = 16
    object acLoadPointcloud: TAction
      Caption = 'Load Pointcloud'
      OnExecute = acLoadPointcloudExecute
    end
    object acExit: TAction
      Caption = 'E&xit'
      OnExecute = acExitExecute
    end
    object acGeomFitCone: TAction
      Caption = 'Fit to Cone'
      OnExecute = acGeomFitConeExecute
    end
    object acGeomFitSphere: TAction
      Caption = 'Fit to Sphere'
      OnExecute = acGeomFitSphereExecute
    end
  end
  object GLScene1: TGLScene
    Left = 456
    Top = 16
    object GLLightSource1: TGLLightSource
      Ambient.Color = {0000803F0000803F0000803F0000803F}
      ConstAttenuation = 1.000000000000000000
      Position.Coordinates = {0000A0400000A0400000A0400000803F}
      LightStyle = lsParallel
      SpotCutOff = 180.000000000000000000
      SpotDirection.Coordinates = {000000000000803F0000803F00000000}
    end
    object dcMain: TGLDummyCube
      Direction.Coordinates = {00000000000000800000803F00000000}
      ShowAxes = True
      CubeSize = 1.000000000000000000
      object GLPointCloud: TGLPoints
        NoZWrite = False
        Static = False
      end
      object GLCone: TGLCone
        Material.BackProperties.Diffuse.Color = {ACC8483EACC8483ECDCC4C3F0000803F}
        Material.FrontProperties.Diffuse.Color = {ACC8483EACC8483ECDCC4C3F0000803F}
        Material.FrontProperties.Shininess = 50
        Material.FrontProperties.Specular.Color = {0000803F0000803F0000803F0000803F}
        Direction.Coordinates = {0000803F000000000000000000000000}
        Up.Coordinates = {00000080000000000000803F00000000}
        Visible = False
        BottomRadius = 2.500000000000000000
        Height = 5.000000000000000000
        Parts = [coSides]
      end
      object GLSphere: TGLSphere
        Material.FrontProperties.Diffuse.Color = {ACC8483EACC8483ECDCC4C3F0000803F}
        Direction.Coordinates = {0000803F000000000000000000000000}
        Up.Coordinates = {00000080000000000000803F00000000}
        Visible = False
        Radius = 4.000000000000000000
      end
    end
    object GLCamera: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      TargetObject = dcMain
      Position.Coordinates = {0000F0410000F0410000F0410000803F}
      Direction.Coordinates = {0000803F000000000000000000000000}
      Up.Coordinates = {00000080000000000000803F00000000}
    end
  end
end
