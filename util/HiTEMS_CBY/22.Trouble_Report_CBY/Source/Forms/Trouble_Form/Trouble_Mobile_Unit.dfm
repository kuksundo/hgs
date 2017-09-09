object Trouble_Mobile_Frm: TTrouble_Mobile_Frm
  Left = 0
  Top = 0
  Caption = #47784#48148#51068' '#47928#51228' '#51228#48372' '#45236#50857
  ClientHeight = 464
  ClientWidth = 693
  Color = clBtnFace
  Constraints.MaxHeight = 658
  Constraints.MaxWidth = 730
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 429
    Width = 693
    Height = 35
    Align = alBottom
    TabOrder = 0
    object Button3: TButton
      AlignWithMargins = True
      Left = 598
      Top = 4
      Width = 91
      Height = 27
      Align = alRight
      Caption = #45803#44592
      ImageIndex = 11
      ImageMargins.Left = 5
      Images = Main_Frm.Imglist16x16
      TabOrder = 0
      OnClick = Button3Click
    end
    object Button4: TButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 91
      Height = 27
      Align = alLeft
      Caption = #48372#44256#49436' '#51089#49457
      ImageIndex = 3
      ImageMargins.Left = 5
      Images = Main_Frm.Imglist16x16
      TabOrder = 1
      OnClick = Button4Click
    end
    object detailBtn: TButton
      AlignWithMargins = True
      Left = 488
      Top = 4
      Width = 104
      Height = 27
      Align = alRight
      Caption = #48372#44256#49436' '#54869#51064
      ImageIndex = 9
      ImageMargins.Left = 5
      Images = Main_Frm.Imglist16x16
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 693
    Height = 429
    Align = alClient
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object Label8: TLabel
      Left = 8
      Top = 7
      Width = 210
      Height = 30
      Caption = #47784#48148#51068' '#47928#51228' '#51228#48372' '#45236#50857
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 359
      Top = 103
      Width = 96
      Height = 17
      Caption = #47928#51228#54788#49345'('#51228#47785') :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 359
      Top = 168
      Width = 47
      Height = 17
      Caption = #48512#54408#47749' :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 359
      Top = 225
      Width = 60
      Height = 17
      Caption = #52628#51221#50896#51064' :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 359
      Top = 286
      Width = 78
      Height = 17
      Caption = #48372#44256#49436' '#53440#51077' :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 527
      Top = 286
      Width = 60
      Height = 17
      Caption = #50644#51652#53440#51077' :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 359
      Top = 346
      Width = 47
      Height = 17
      Caption = #51228#48372#51088' :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 527
      Top = 346
      Width = 47
      Height = 17
      Caption = #51228#48372#51068' :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 34
      Top = 273
      Width = 60
      Height = 17
      Caption = #45812#45817#54016#51109' :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 34
      Top = 353
      Width = 60
      Height = 17
      Caption = #51089#49457#45812#45817' :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label11: TLabel
      Left = 183
      Top = 353
      Width = 60
      Height = 17
      Caption = #49444#44228#45812#45817' :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object title: TLabel
      Left = 377
      Top = 126
      Width = 305
      Height = 34
      AutoSize = False
      Caption = #54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object itemname: TLabel
      Left = 377
      Top = 191
      Width = 305
      Height = 34
      AutoSize = False
      Caption = #54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object status: TLabel
      Left = 377
      Top = 248
      Width = 305
      Height = 34
      AutoSize = False
      Caption = #54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object rptype: TLabel
      Left = 377
      Top = 309
      Width = 105
      Height = 31
      AutoSize = False
      Caption = #54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object engtype: TLabel
      Left = 545
      Top = 309
      Width = 105
      Height = 31
      AutoSize = False
      Caption = #54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object informer: TLabel
      Left = 377
      Top = 369
      Width = 105
      Height = 31
      AutoSize = False
      Caption = #54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object indate: TLabel
      Left = 545
      Top = 369
      Width = 105
      Height = 31
      AutoSize = False
      Caption = #54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label12: TLabel
      Left = 359
      Top = 48
      Width = 78
      Height = 17
      Caption = #48372#44256#49436' '#48264#54840' :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
    end
    object codeid: TLabel
      Left = 377
      Top = 71
      Width = 305
      Height = 19
      AutoSize = False
      Caption = #54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616#54616
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object inemp: TEdit
      Left = 50
      Top = 376
      Width = 100
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      ReadOnly = True
      TabOrder = 0
    end
    object emp: TEdit
      Left = 199
      Top = 376
      Width = 100
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      ReadOnly = True
      TabOrder = 1
      Visible = False
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 152
      Top = 375
      Width = 25
      Height = 23
      Margins.Top = 0
      ImageIndex = 8
      Images = Main_Frm.Imglist16x16
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button1: TButton
      AlignWithMargins = True
      Left = 301
      Top = 375
      Width = 25
      Height = 23
      Margins.Top = 0
      ImageIndex = 8
      Images = Main_Frm.Imglist16x16
      TabOrder = 3
      Visible = False
      OnClick = Button1Click
    end
    object leftb: TButton
      AlignWithMargins = True
      Left = 142
      Top = 241
      Width = 33
      Height = 27
      Caption = #9664
      TabOrder = 4
      OnClick = leftbClick
    end
    object rightb: TButton
      AlignWithMargins = True
      Left = 181
      Top = 241
      Width = 33
      Height = 27
      Caption = #9654
      TabOrder = 5
      OnClick = rightbClick
    end
    object Panel2: TPanel
      Left = 34
      Top = 48
      Width = 289
      Height = 189
      Color = clBtnShadow
      ParentBackground = False
      TabOrder = 6
      object Image1: TImage
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 281
        Height = 181
        Align = alClient
        Stretch = True
        ExplicitLeft = 0
        ExplicitTop = 8
        ExplicitHeight = 174
      end
    end
    object Button5: TButton
      AlignWithMargins = True
      Left = 152
      Top = 295
      Width = 91
      Height = 23
      Margins.Top = 0
      Caption = #45812#45817#54016#48320#44221
      ImageIndex = 14
      Images = Main_Frm.Imglist16x16
      TabOrder = 7
      OnClick = Button5Click
    end
    object Chief: TEdit
      Left = 50
      Top = 296
      Width = 100
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 8
    end
  end
  object GDIPPictureContainer1: TGDIPPictureContainer
    Items = <>
    Version = '1.0.0.0'
    Left = 624
    Top = 24
  end
end
