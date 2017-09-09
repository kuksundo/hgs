object DisplayF: TDisplayF
  Left = 288
  Top = 190
  BorderStyle = bsSingle
  Caption = 'Delphi Streaming'
  ClientHeight = 289
  ClientWidth = 320
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object imgDisplay: TImage
    Left = 0
    Top = 29
    Width = 320
    Height = 240
    Align = alClient
    Center = True
    Proportional = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 4
      Top = 4
      Width = 23
      Height = 22
      Hint = 'Settings'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555550FF0559
        1950555FF75F7557F7F757000FF055591903557775F75557F77570FFFF055559
        1933575FF57F5557F7FF0F00FF05555919337F775F7F5557F7F700550F055559
        193577557F7F55F7577F07550F0555999995755575755F7FFF7F5570F0755011
        11155557F755F777777555000755033305555577755F75F77F55555555503335
        0555555FF5F75F757F5555005503335505555577FF75F7557F55505050333555
        05555757F75F75557F5505000333555505557F777FF755557F55000000355557
        07557777777F55557F5555000005555707555577777FF5557F55553000075557
        0755557F7777FFF5755555335000005555555577577777555555}
      NumGlyphs = 2
      OnClick = SpeedButton1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 269
    Width = 320
    Height = 20
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 1
    object Label1: TLabel
      Left = 4
      Top = 4
      Width = 34
      Height = 13
      Caption = 'Server:'
    end
    object lbServerSt: TLabel
      Left = 40
      Top = 4
      Width = 20
      Height = 13
      Caption = 'OFF'
    end
    object Label2: TLabel
      Left = 68
      Top = 4
      Width = 29
      Height = 13
      Caption = 'Client:'
    end
    object lbClientSt: TLabel
      Left = 100
      Top = 4
      Width = 85
      Height = 13
      Caption = 'DISCONNECTED'
    end
  end
end
