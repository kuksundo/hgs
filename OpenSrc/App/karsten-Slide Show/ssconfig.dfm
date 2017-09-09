object SSConfigForm: TSSConfigForm
  Left = 269
  Top = 104
  BorderIcons = [biSystemMenu, biHelp]
  Caption = 'Karsten Screen Saver Configuration'
  ClientHeight = 232
  ClientWidth = 375
  Color = clBtnFace
  Constraints.MinHeight = 259
  Constraints.MinWidth = 383
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  ShowHint = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    375
    232)
  PixelsPerInch = 96
  TextHeight = 13
  object BOk: TBitBtn
    Left = 8
    Top = 199
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&OK'
    TabOrder = 2
    Kind = bkOK
  end
  object BCancel: TBitBtn
    Left = 111
    Top = 199
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Cancel'
    TabOrder = 3
    Kind = bkCancel
  end
  object PCUsers: TPageControl
    Left = 8
    Top = 8
    Width = 361
    Height = 177
    ActivePage = TSCurrentUser
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 5
    OnChange = PCUsersChange
    OnChanging = PCUsersChanging
    object TSCurrentUser: TTabSheet
      Hint = 'Settings for the current user'
      Caption = 'Current &User'
    end
    object TSDefaultUser: TTabSheet
      Hint = 'Settings for new user accounts'
      Caption = '&Default User'
      ImageIndex = 1
    end
  end
  object GBSSDoc: TGroupBox
    Left = 20
    Top = 72
    Width = 337
    Height = 97
    Hint = 'Slide show file that the screen saver will run'
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Collection &File'
    TabOrder = 1
    DesignSize = (
      337
      97)
    object EFSSDocPath: TEdit
      Left = 14
      Top = 24
      Width = 305
      Height = 21
      Hint = 'Path to the collection file'
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = EFSSDocPathChange
    end
    object BFindSSDocPath: TBitBtn
      Left = 200
      Top = 56
      Width = 120
      Height = 25
      Hint = 'Browse the file system'
      HelpContext = 9031
      Anchors = [akTop, akRight]
      Caption = '&Browse...'
      TabOrder = 2
      OnClick = BFindSSDocPathClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        555555FFFFFFFFFF55555000000000055555577777777775FFFF00B8B8B8B8B0
        0000775F5555555777770B0B8B8B8B8B0FF07F75F555555575F70FB0B8B8B8B8
        B0F07F575FFFFFFFF7F70BFB0000000000F07F557777777777570FBFBF0FFFFF
        FFF07F55557F5FFFFFF70BFBFB0F000000F07F55557F777777570FBFBF0FFFFF
        FFF075F5557F5FFFFFF750FBFB0F000000F0575FFF7F777777575700000FFFFF
        FFF05577777F5FF55FF75555550F00FF00005555557F775577775555550FFFFF
        0F055555557F55557F755555550FFFFF00555555557FFFFF7755555555000000
        0555555555777777755555555555555555555555555555555555}
      NumGlyphs = 2
    end
    object BSelectCurDoc: TBitBtn
      Left = 14
      Top = 56
      Width = 120
      Height = 25
      Hint = 'Use the collection that is currently open in the main window'
      Caption = 'Use &Open Collection'
      Enabled = False
      TabOrder = 1
      OnClick = BSelectCurDocClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555FFFFFFFFFF5555550000000000555557777777777F5555550FFFFFFFF
        0555557F5FFFF557F5555550F0000FFF0555557F77775557F5555550FFFFFFFF
        0555557F5FFFFFF7F5555550F000000F0555557F77777757F5555550FFFFFFFF
        0555557F5FFFFFF7F5555550F000000F0555557F77777757F5555550FFFFFFFF
        0555557F5FFF5557F5555550F000FFFF0555557F77755FF7F5555550FFFFF000
        0555557F5FF5777755555550F00FF0F05555557F77557F7555555550FFFFF005
        5555557FFFFF7755555555500000005555555577777775555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
    end
  end
  object CBInstallScr: TCheckBox
    Left = 20
    Top = 40
    Width = 209
    Height = 17
    Hint = 'Set Karsten as the active screen saver program'
    Caption = '&Enable Karsten Screen Saver'
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = CBInstallScrClick
  end
  object BHelp: TBitBtn
    Left = 272
    Top = 199
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Enabled = False
    TabOrder = 4
    Kind = bkHelp
  end
  object OpenSSDocDialog: TOpenDialog
    DefaultExt = '.kbs'
    Filter = 'Karsten Slide Collection (*.kbs)|*.kbs'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofShareAware]
    Title = 'Select slide collection for the screen saver'
    Left = 8
    Top = 200
  end
end
