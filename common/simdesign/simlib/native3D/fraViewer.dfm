object frViewer: TfrViewer
  Left = 0
  Top = 0
  Width = 428
  Height = 332
  TabOrder = 0
  object GLViewer: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 428
    Height = 332
    Camera = GLCamera
    Buffer.BackgroundColor = clBackground
    FieldOfView = 117.869667053222700000
    Align = alClient
    OnMouseDown = GLViewerMouseDown
    OnMouseMove = GLViewerMouseMove
  end
  object GLScene: TGLScene
    Left = 36
    Top = 56
    object GLDummyCube: TGLDummyCube
      Direction.Coordinates = {00000000000080BF0000000000000000}
      ShowAxes = True
      Up.Coordinates = {00000000000000000000803F00000000}
      CubeSize = 1.000000000000000000
      object GLMesh1: TGLMesh
        Mode = mmTriangleStrip
        VertexMode = vmV
      end
    end
    object GLLightSource: TGLLightSource
      ConstAttenuation = 1.000000000000000000
      Position.Coordinates = {0000A0410000A0410000A0410000803F}
      LightStyle = lsOmni
      SpotCutOff = 180.000000000000000000
    end
    object GLCamera: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 100.000000000000000000
      NearPlaneBias = 0.100000001490116100
      TargetObject = GLDummyCube
      Position.Coordinates = {0000004000000040000000400000803F}
    end
  end
end
