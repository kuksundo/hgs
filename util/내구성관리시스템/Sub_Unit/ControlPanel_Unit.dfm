object ControlPanel_Frm: TControlPanel_Frm
  Left = 0
  Top = 0
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = #54032#45356' '#51221#48372' '#48372#44592
  ClientHeight = 273
  ClientWidth = 487
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object NxHeaderPanel1: TNxHeaderPanel
    Left = 0
    Top = 0
    Width = 487
    Height = 273
    Align = alClient
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    ParentHeaderFont = False
    TabOrder = 0
    FullWidth = 487
    object Panel1: TPanel
      Left = 0
      Top = 27
      Width = 485
      Height = 244
      Align = alClient
      Color = clInactiveCaptionText
      ParentBackground = False
      TabOrder = 0
      object Panel2: TPanel
        Left = 1
        Top = 1
        Width = 483
        Height = 280
        Align = alTop
        TabOrder = 0
        object Panel32: TPanel
          Left = 1
          Top = 1
          Width = 481
          Height = 32
          Align = alTop
          Caption = #45348#53944#50892#53356' '#51221#48372' '#48372#44592
          Color = clSkyBlue
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object CurvyPanel2: TCurvyPanel
          Left = 1
          Top = 33
          Width = 481
          Height = 168
          Align = alTop
          TabOrder = 1
          object TPanel
            Left = 163
            Top = 15
            Width = 117
            Height = 28
            BevelInner = bvSpace
            BevelOuter = bvNone
            Caption = #54032#45356#47749
            Color = clSkyBlue
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
          end
          object NAMEPanel: TPanel
            Left = 286
            Top = 15
            Width = 171
            Height = 28
            BevelInner = bvSpace
            BevelOuter = bvNone
            Color = clSkyBlue
            ParentBackground = False
            TabOrder = 1
          end
          object Panel5: TPanel
            Left = 163
            Top = 50
            Width = 117
            Height = 28
            BevelInner = bvSpace
            BevelOuter = bvNone
            Caption = #50948#52824
            Color = clSkyBlue
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
          end
          object LOCATION: TPanel
            Left = 286
            Top = 50
            Width = 171
            Height = 28
            BevelInner = bvSpace
            BevelOuter = bvNone
            Color = clSkyBlue
            ParentBackground = False
            TabOrder = 3
          end
          object Panel6: TPanel
            Left = 163
            Top = 84
            Width = 117
            Height = 28
            BevelInner = bvSpace
            BevelOuter = bvNone
            Caption = #47700#51060#52964
            Color = clSkyBlue
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 4
          end
          object MAKER: TPanel
            Left = 286
            Top = 84
            Width = 171
            Height = 28
            BevelInner = bvSpace
            BevelOuter = bvNone
            Color = clSkyBlue
            ParentBackground = False
            TabOrder = 5
          end
          object Panel8: TPanel
            Left = 163
            Top = 118
            Width = 117
            Height = 28
            BevelInner = bvSpace
            BevelOuter = bvNone
            Caption = #49324#50577
            Color = clSkyBlue
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 6
          end
          object SN: TPanel
            Left = 286
            Top = 118
            Width = 171
            Height = 28
            BevelInner = bvSpace
            BevelOuter = bvNone
            Color = clSkyBlue
            ParentBackground = False
            TabOrder = 7
          end
          object CB_IMAGE: TNxImage
            Left = 12
            Top = 15
            Width = 145
            Height = 130
            TabOrder = 8
          end
        end
      end
      object Button1: TButton
        Left = 384
        Top = 210
        Width = 75
        Height = 25
        Caption = #45803' '#44592
        TabOrder = 1
        OnClick = Button1Click
      end
    end
  end
end
