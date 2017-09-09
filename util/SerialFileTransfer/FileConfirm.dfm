object Form3: TForm3
  Left = 347
  Top = 206
  Caption = #45796#50868#47196#46300' OK ?'
  ClientHeight = 130
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #44404#47548
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 0
    Width = 297
    Height = 97
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 32
      Width = 148
      Height = 36
      Caption = #54028#51068' '#51204#49569#50836#52397#51060' '#51080#49845#45768#45796'. '#13#10#13#10#51204#49569#51012' '#54728#46973#54616#49884#44192#49845#45768#44620' ?'
    end
    object FileNameLbl: TLabel
      Left = 24
      Top = 14
      Width = 16
      Height = 12
      Caption = ' ...'
    end
    object DontAskDnLdConfirmCB: TJvCheckBox
      Left = 24
      Top = 77
      Width = 101
      Height = 17
      BiDiMode = bdRightToLeft
      Caption = #51060#54980' '#47931#51648' '#50506#44592
      ParentBiDiMode = False
      TabOrder = 0
      LinkedControls = <>
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -13
      HotTrackFont.Name = 'MS Sans Serif'
      HotTrackFont.Style = []
    end
  end
  object Button1: TButton
    Left = 8
    Top = 104
    Width = 81
    Height = 25
    Caption = #54869' '#51064
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 96
    Top = 104
    Width = 121
    Height = 25
    Caption = #45796#47480#51060#47492#51004#47196' '#51200#51109
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button4: TButton
    Left = 224
    Top = 104
    Width = 81
    Height = 25
    Caption = #52712' '#49548
    TabOrder = 3
    OnClick = Button4Click
  end
  object SaveDialog1: TSaveDialog
    Left = 16
  end
end
