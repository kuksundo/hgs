object Viewer: TViewer
  Left = 0
  Top = 0
  Width = 318
  Height = 238
  TabOrder = 0
  object pbPicture: TPaintBox
    Left = 0
    Top = 0
    Width = 318
    Height = 238
    Align = alClient
    OnMouseDown = pbPictureMouseDown
    OnMouseMove = pbPictureMouseMove
    OnMouseUp = pbPictureMouseUp
    OnPaint = pbPicturePaint
  end
end
