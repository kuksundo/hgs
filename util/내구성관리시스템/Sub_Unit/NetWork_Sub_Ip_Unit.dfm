object NetWork_Sub_Ip_Frm: TNetWork_Sub_Ip_Frm
  Left = 0
  Top = 0
  Caption = 'IP'#44160#49353
  ClientHeight = 335
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object NxHeaderPanel1: TNxHeaderPanel
    Left = 0
    Top = 0
    Width = 356
    Height = 335
    Align = alClient
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    ParentHeaderFont = False
    TabOrder = 0
    FullWidth = 356
    object Panel1: TPanel
      Left = 0
      Top = 27
      Width = 354
      Height = 306
      Align = alClient
      Color = clInactiveCaptionText
      ParentBackground = False
      TabOrder = 0
      object Panel2: TPanel
        Left = 1
        Top = 1
        Width = 352
        Height = 288
        Align = alTop
        TabOrder = 0
        object Panel32: TPanel
          Left = 1
          Top = 1
          Width = 350
          Height = 32
          Align = alTop
          Caption = #45348#53944#50892#53356' IP'#44160#49353
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
          Width = 350
          Height = 208
          Align = alTop
          TabOrder = 1
          object Label1: TLabel
            Left = 29
            Top = 77
            Width = 136
            Height = 16
            Caption = #44160#49353' '#45348#53944#50892#53356' '#51221#48372
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object NAMEPanel1: TPanel
            Left = 152
            Top = 95
            Width = 171
            Height = 28
            BevelInner = bvSpace
            BevelOuter = bvNone
            Color = clSkyBlue
            ParentBackground = False
            TabOrder = 0
            OnClick = NAMEPanel1Click
          end
          object Panel5: TPanel
            Left = 29
            Top = 129
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
            TabOrder = 1
          end
          object LOCATION1: TPanel
            Left = 152
            Top = 129
            Width = 171
            Height = 28
            BevelInner = bvSpace
            BevelOuter = bvNone
            Color = clSkyBlue
            ParentBackground = False
            TabOrder = 2
          end
          object Panel6: TPanel
            Left = 29
            Top = 163
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
            TabOrder = 3
          end
          object MAKER1: TPanel
            Left = 152
            Top = 163
            Width = 171
            Height = 28
            BevelInner = bvSpace
            BevelOuter = bvNone
            Color = clSkyBlue
            ParentBackground = False
            TabOrder = 4
          end
          object Panel10: TPanel
            Left = 29
            Top = 95
            Width = 117
            Height = 28
            BevelInner = bvSpace
            BevelOuter = bvNone
            Caption = #45348#53944#50892#53356#47749
            Color = clSkyBlue
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 5
          end
          object Panel3: TPanel
            Left = 29
            Top = 15
            Width = 117
            Height = 28
            BevelInner = bvSpace
            BevelOuter = bvNone
            Caption = #45348#53944#50892#53356' IP'
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
          object Button2: TButton
            Left = 248
            Top = 49
            Width = 75
            Height = 25
            Caption = #44160#49353
            TabOrder = 7
            OnClick = Button2Click
          end
          object Edit1: TEdit
            Left = 152
            Top = 17
            Width = 171
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ImeName = 'Microsoft Office IME 2007'
            ParentFont = False
            TabOrder = 8
          end
        end
      end
      object Button1: TButton
        Left = 250
        Top = 254
        Width = 75
        Height = 25
        Caption = #45803' '#44592
        TabOrder = 1
        OnClick = Button1Click
      end
    end
  end
end
