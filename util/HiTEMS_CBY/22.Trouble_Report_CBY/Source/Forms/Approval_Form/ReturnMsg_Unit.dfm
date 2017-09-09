object ReturnMsg_Frm: TReturnMsg_Frm
  Left = 0
  Top = 0
  Caption = #47928#51228#51216' '#48372#44256#49436'-'#48372#44256#49436' '#48152#47140
  ClientHeight = 321
  ClientWidth = 550
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object NxHeaderPanel1: TNxHeaderPanel
    Left = 0
    Top = 27
    Width = 550
    Height = 260
    Align = alClient
    Caption = #48372#44256#49436' '#48152#47140' '#49324#50976
    HeaderFont.Charset = ANSI_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -12
    HeaderFont.Name = #47569#51008' '#44256#46357
    HeaderFont.Style = [fsBold, fsItalic]
    InnerMargins.Left = 5
    InnerMargins.Top = 5
    InnerMargins.Bottom = 5
    InnerMargins.Right = 5
    ParentHeaderFont = False
    TabOrder = 0
    ExplicitLeft = 208
    ExplicitTop = 72
    ExplicitWidth = 245
    ExplicitHeight = 245
    FullWidth = 550
    object Panel3: TPanel
      Left = 5
      Top = 32
      Width = 538
      Height = 221
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitLeft = -1
      ExplicitTop = 128
      ExplicitHeight = 33
      object RichEdit1: TRichEdit
        Left = 0
        Top = 0
        Width = 538
        Height = 221
        Align = alClient
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        TabOrder = 0
        ExplicitLeft = 176
        ExplicitTop = 64
        ExplicitWidth = 185
        ExplicitHeight = 89
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 287
    Width = 550
    Height = 34
    Align = alBottom
    Color = clCream
    ParentBackground = False
    TabOrder = 1
    ExplicitTop = 327
    ExplicitWidth = 333
    object Button2: TButton
      AlignWithMargins = True
      Left = 474
      Top = 4
      Width = 75
      Height = 26
      Margins.Right = 0
      Align = alRight
      Caption = #54869#51064
      ImageIndex = 2
      ImageMargins.Left = 5
      Images = Trouble_Frm.Imglist16x16
      TabOrder = 0
      OnClick = Button2Click
      ExplicitLeft = 176
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 550
    Height = 27
    Margins.Top = 10
    Align = alTop
    BevelOuter = bvNone
    Color = clCream
    ParentBackground = False
    TabOrder = 2
    object Label1: TLabel
      AlignWithMargins = True
      Left = 5
      Top = 10
      Width = 38
      Height = 14
      Margins.Left = 5
      Margins.Top = 10
      Align = alLeft
      Caption = 'Label1'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 3
      ExplicitHeight = 15
    end
  end
end
