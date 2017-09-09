object f_ShapeFileReader: Tf_ShapeFileReader
  Left = 0
  Top = 0
  Caption = 'Shape File Reader'
  ClientHeight = 803
  ClientWidth = 634
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    634
    803)
  PixelsPerInch = 96
  TextHeight = 13
  object im_Map: TImage
    Left = 8
    Top = 8
    Width = 537
    Height = 385
    Center = True
    Stretch = True
  end
  object b_Execute: TButton
    Left = 552
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Execute'
    TabOrder = 0
    OnClick = b_ExecuteClick
  end
  object m_Output: TMemo
    Left = 8
    Top = 400
    Width = 537
    Height = 396
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object b_Close: TButton
    Left = 552
    Top = 771
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 2
    OnClick = b_CloseClick
  end
  object od_Shape: TOpenDialog
    DefaultExt = '.shp'
    Filter = 'Shape Files|*.shp|All Files|*.*'
    Left = 472
    Top = 40
  end
end
