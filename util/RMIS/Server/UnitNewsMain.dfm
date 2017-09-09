object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 777
  ClientWidth = 1039
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object FChromium: TChromium
    Left = 0
    Top = 23
    Width = 1039
    Height = 688
    Color = clWhite
    Align = alClient
    DefaultUrl = 
      'http://news.kbs.co.kr/news/NewsCategory.do?SEARCH_SECTION=0001&&' +
      'source=http://news.kbs.co.kr/common/NewsMain.html'
    TabOrder = 0
  end
  object Panel20: TPanel
    Left = 0
    Top = 0
    Width = 1039
    Height = 23
    Align = alTop
    TabOrder = 1
    DesignSize = (
      1039
      23)
    object SpeedButton1: TSpeedButton
      Left = 0
      Top = 0
      Width = 23
      Height = 22
    end
    object SpeedButton2: TSpeedButton
      Left = 24
      Top = 0
      Width = 23
      Height = 22
    end
    object SpeedButton3: TSpeedButton
      Left = 48
      Top = 0
      Width = 23
      Height = 22
      Caption = 'H'
    end
    object SpeedButton4: TSpeedButton
      Left = 72
      Top = 0
      Width = 23
      Height = 22
      Caption = 'R'
    end
    object SpeedButton5: TSpeedButton
      Left = 665
      Top = 0
      Width = 23
      Height = 22
      Anchors = [akTop, akRight]
      OnClick = SpeedButton5Click
      ExplicitLeft = 707
    end
    object edAddress: TEdit
      Left = 95
      Top = 0
      Width = 568
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ImeName = 'Microsoft IME 2010'
      TabOrder = 0
      Text = 
        'http://news.kbs.co.kr/news/NewsCategory.do?SEARCH_SECTION=0001&&' +
        'source=http://news.kbs.co.kr/common/NewsMain.html'
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 752
    Width = 1039
    Height = 25
    Panels = <>
    SimplePanel = True
  end
  object Panel6: TPanel
    Left = 0
    Top = 711
    Width = 1039
    Height = 41
    Align = alBottom
    Color = clBlack
    Font.Charset = ANSI_CHARSET
    Font.Color = clLime
    Font.Height = -27
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 3
    object AAFadeText1: TAAFadeText
      Left = 1
      Top = 1
      Width = 1037
      Height = 39
      ParentEffect.ParentColor = False
      Align = alClient
      Fonts = <
        item
          Name = 'Title1'
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clLime
          Font.Height = -21
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          Effect.Shadow.Enabled = True
        end
        item
          Name = 'Title2'
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clLime
          Font.Height = -21
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          Effect.Shadow.Enabled = True
          Effect.Shadow.OffsetX = 1
          Effect.Shadow.OffsetY = 1
        end
        item
          Name = 'Title3'
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clLime
          Font.Height = -21
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          Effect.Shadow.Enabled = True
        end
        item
          Name = 'Text1'
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clLime
          Font.Height = -21
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          Effect.Shadow.OffsetX = 1
          Effect.Shadow.OffsetY = 1
        end
        item
          Name = 'Text2'
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clLime
          Font.Height = -21
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          Effect.Shadow.Enabled = True
          Effect.Shadow.OffsetX = 1
          Effect.Shadow.OffsetY = 1
        end
        item
          Name = 'Title4'
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clLime
          Font.Height = -21
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          Effect.Shadow.Enabled = True
          Effect.Gradual.Enabled = True
          Effect.Gradual.StartColor = 16720384
          Effect.Gradual.EndColor = 2232575
          Effect.Blur = 50
          Effect.Outline = True
        end
        item
          Name = 'Text3'
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clLime
          Font.Height = -21
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          Effect.Shadow.Enabled = True
          Effect.Shadow.OffsetX = 1
          Effect.Shadow.OffsetY = 1
          Effect.Gradual.Enabled = True
          Effect.Gradual.Style = gsTopToBottom
          Effect.Gradual.StartColor = 13404177
          Effect.Gradual.EndColor = 16720554
        end>
      Labels = <
        item
          Name = 'Left'
          Style = lsLeftJustify
        end
        item
          Name = 'Center'
          Style = lsCenter
        end
        item
          Name = 'Right'
          Style = lsRightJustify
        end
        item
          Name = 'Owner'
          Style = lsRegOwner
        end
        item
          Name = 'Organization'
          Style = lsRegOrganization
        end
        item
          Name = 'AppTitle'
          Style = lsAppTitle
        end
        item
          Name = 'Date'
          Style = lsDate
        end
        item
          Name = 'Time'
          Style = lsTime
        end>
      Text.Lines.Strings = (
        '<Title1><Center>KBS '#45684#49828' '#49549#48372)
      Text.Transparent = True
      ExplicitLeft = 289
      ExplicitTop = 4
      ExplicitWidth = 240
      ExplicitHeight = 34
    end
  end
end
