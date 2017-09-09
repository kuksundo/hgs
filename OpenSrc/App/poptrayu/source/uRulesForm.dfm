object RulesForm: TRulesForm
  Left = 0
  Top = 0
  Caption = 'Rules'
  ClientHeight = 549
  ClientWidth = 648
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object panRulesButtons: TPanel
    Left = 0
    Top = 517
    Width = 648
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object panRulesButtonsRight: TPanel
      Left = 435
      Top = 0
      Width = 213
      Height = 32
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnSaveRules: TBitBtn
        Left = 10
        Top = 3
        Width = 113
        Height = 25
        Caption = 'Save Rules'
        Default = True
        Enabled = False
        Glyph.Data = {
          36060000424D3606000000000000360000002800000020000000100000000100
          18000000000000060000230B0000230B0000000000000000000000FF0000FF00
          00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
          FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
          8080806363636363635050505050504040404040404040404040404040404040
          4040404050505063636300FF0000FF0000FF0000FF0000FF0000FF0000FF0000
          FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
          AA5000D36605C85E00B5B2B5B5B2B5B5B2B5B5B2B5B5B2B5B5B2B59B49009B49
          00D36605D3660550505000FF0000FF006F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F
          6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F55555500FF0000FF0000FF00FF973B
          ED801FED801FD36605AD9E9CFC8F2EDEB6B5FFFBFFF7F3F7E7E7E79B49009B49
          00ED801FD3660540404000FF0087878700FF0000FF006F6F6F9F9F9F00FF0000
          FF0000FF0000FF00E7E7E76F6F6F00FF006F6F6F00FF0000FF0000FF00FF973B
          ED801FED801FD36605CEB6B5DB6E0DFFA24FDEDBDEFFFBFFF7F3F79B49009B49
          00ED801FD3660540404000FF0087878700FF0000FF006F6F6FB8B8B800FF0000
          FF0000FF0000FF00E7E7E76F6F6F00FF006F6F6F00FF0000FF0000FF00FF973B
          ED801FED801FD36605E7C7C6C85E00F98C2BB5B2B5DEDBDEFFFBFF9B49009B49
          00ED801FD3660540404000FF0087878700FF0000FF006F6F6FCACACA00FF0000
          FF0000FF0000FF00E7E7E76F6F6F00FF006F6F6F00FF0000FF0000FF00FF973B
          ED801FED801FD36605DECBCECE9694CEB2B5ADAAADB5B2B5D6CFCE9B4900A14C
          00ED801FD3660540404000FF0087878700FF0000FF006F6F6FCECECE9C9C9CB6
          B6B6ABABABB3B3B3CFCFCF6F6F6F00FF006F6F6F00FF0000FF0000FF00FF973B
          ED801FED801FED801FED801FED801FED801FED801FED801FED801FED801FED80
          1FED801FD3660540404000FF0087878700FF0000FF0000FF0000FF0000FF0000
          FF0000FF0000FF0000FF0000FF0000FF006F6F6F00FF0000FF0000FF00FF973B
          ED801FED801FFFA24FFFA24FFFA24FFFA24FFFA24FFFA24FFFA24FFFA24FED80
          1FED801FD3660540404000FF0087878700FF0000FF0093939393939393939393
          939393939393939393939393939300FF006F6F6F00FF0000FF0000FF00FF973B
          ED801FFFA24FFFFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFA2
          4FED801FD3660550505000FF0087878700FF0093939300FF0000FF0000FF0000
          FF0000FF0000FF0000FF0000FF009393936F6F6F00FF0000FF0000FF00FF973B
          ED801FFFA24FFFFBFFC6C3C6C6C3C6C6C3C6C6C7C6C6C7C6C6C7C6FFFBFFFFA2
          4FED801FD3660550505000FF0087878700FF0093939300FF00C4C4C4C4C4C4C4
          C4C4C7C7C7C7C7C7C7C7C700FF009393936F6F6F00FF0000FF0000FF00FF973B
          ED801FFFA24FFFFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFA2
          4FED801FD3660563636300FF0087878700FF0093939300FF0000FF0000FF0000
          FF0000FF0000FF0000FF0000FF009393936F6F6F00FF0000FF0000FF00FF973B
          ED801FFFA24FFFFBFFBDBEBDC6C3C6C6C3C6C6C3C6C6C7C6C6C7C6FFFBFFFFA2
          4FED801FD3660563636300FF0087878700FF0093939300FF00BDBEBDC6C3C6C6
          C3C6C6C3C6C6C7C6C6C7C600FF009393936F6F6F00FF0000FF0000FF00FF973B
          ED801FFFA24FFFFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFA2
          4FED801FD3660580808000FF0087878700FF0093939300FF0000FF0000FF0000
          FF0000FF0000FF0000FF0000FF009393936F6F6F00FF0000FF0000FF00FF973B
          D36605FFA24F0000C00000C00000C00000C00000C00000C00000C00000C0FFA2
          4FD3660500FF0000FF0000FF008787876F6F6F9393936F6F6F6F6F6F6F6F6F6F
          6F6F6F6F6F6F6F6F6F6F6F6F6F6F93939355555500FF0000FF0000FF0000FF00
          00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
          FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00}
        NumGlyphs = 2
        TabOrder = 0
        OnClick = btnSaveRulesClick
      end
      object btnCancelRule: TBitBtn
        Left = 132
        Top = 3
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Cancel'
        Enabled = False
        Glyph.Data = {
          36060000424D3606000000000000360000002800000020000000100000000100
          18000000000000060000230B0000230B00000000000000000000008284008284
          6E6E6E6E6E6E0082840082840082840082840082840082840082840082840082
          84008284008284008284008284008284008284FFFFFF00828400828400828400
          82840082840082840082840082840082840082840082840082840082843159FF
          0029DA0019B06E6E6E0082840082840082840082840082843159FF6E6E6E0082
          84008284008284008284008284008284848284848284FFFFFF00828400828400
          8284008284008284008284FFFFFF0082840082840082840082840082843159FF
          0030EF0029DA0019B06E6E6E0082840082840082843159FF0020CE0019B06E6E
          6E008284008284008284008284848284FFFFFF008284848284FFFFFF00828400
          8284008284FFFFFF848284848284FFFFFF0082840082840082840082846382FF
          0030EF0030EF0029DA0019B06E6E6E0082843159FF0020CE0020CE0020CE0019
          B06E6E6E008284008284008284848284FFFFFF008284008284848284FFFFFF00
          8284FFFFFF848284008284008284848284FFFFFF008284008284008284008284
          6382FF0030EF0030EF0029DA0019B06E6E6E0029DA0020CE0020CE0020CE0019
          B06E6E6E008284008284008284848284FFFFFF008284008284008284848284FF
          FFFF848284008284008284008284008284848284FFFFFF008284008284008284
          0082846382FF0030EF0030EF0029DA0029DA0029DA0029DA0020CE0020CE6E6E
          6E008284008284008284008284008284848284FFFFFF00828400828400828484
          8284008284008284008284008284FFFFFF848284008284008284008284008284
          0082840082846382FF0030EF0029DA0029DA0029DA0029DA0029DA6E6E6E0082
          84008284008284008284008284008284008284848284FFFFFF00828400828400
          8284008284008284008284FFFFFF848284008284008284008284008284008284
          0082840082840082840030EF0030EF0029DA0029DA0019B06E6E6E0082840082
          84008284008284008284008284008284008284008284848284FFFFFF00828400
          8284008284008284008284848284008284008284008284008284008284008284
          0082840082840082843159FF0030EF0030EF0029DA0019B06E6E6E0082840082
          84008284008284008284008284008284008284008284008284848284FFFFFF00
          8284008284008284848284008284008284008284008284008284008284008284
          0082840082843159FF0030EF0030EF0030EF0030EF0019B06E6E6E0082840082
          8400828400828400828400828400828400828400828400828484828400828400
          8284008284008284848284FFFFFF008284008284008284008284008284008284
          0082843159FF0030EF0030EF0030EF6E6E6E0030EF0029DA0019B06E6E6E0082
          8400828400828400828400828400828400828400828484828400828400828400
          8284008284008284848284FFFFFF008284008284008284008284008284008284
          6382FF0030EF0030EF0030EF6E6E6E0082843159FF0030EF0029DA0019B06E6E
          6E00828400828400828400828400828400828484828400828400828400828484
          8284FFFFFF008284008284848284FFFFFF008284008284008284008284008284
          6382FF0030EF0020CE6E6E6E0082840082840082846382FF0030EF0029DA0019
          B06E6E6E008284008284008284008284848284FFFFFF00828400828484828400
          8284848284FFFFFF008284008284848284FFFFFF008284008284008284008284
          0082846382FF0030EF0082840082840082840082840082846382FF0030EF0030
          EF0029DA008284008284008284008284848284FFFFFFFFFFFF84828400828400
          8284008284848284FFFFFF008284008284848284FFFFFF008284008284008284
          0082840082840082840082840082840082840082840082840082846382FF0030
          EF0029DA00828400828400828400828400828484828484828400828400828400
          8284008284008284848284FFFFFFFFFFFFFFFFFF848284008284008284008284
          0082840082840082840082840082840082840082840082840082840082840082
          8400828400828400828400828400828400828400828400828400828400828400
          8284008284008284008284848284848284848284008284008284}
        NumGlyphs = 2
        TabOrder = 1
        OnClick = btnCancelRuleClick
      end
    end
    object btnHelpRules: TPngBitBtn
      Left = 8
      Top = 3
      Width = 65
      Height = 25
      Caption = '&Help'
      TabOrder = 1
      OnClick = btnHelpRules1Click
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        61000003144944415478DA75936B4853611CC61FCFB6E3DCA62E333DEA36D734
        6F119AB72ED20D89CA2F9A61D185886E041554D205024BFA2041F4A108822823
        63A5945241885DA8344D0BD73D2F35B5B636E7DCF46C67DBD9D9D93AECC3A0B4
        FFC7F77D9EDFFBF0BECF1B8559A6FEED14F5C2C86667259347E44420AFFB177F
        EFCD76EAF46CDAA87F1756349997ADCD53EC1BB27359063B5766FBE5428C5444
        FF3C92113F2B604DD3982A554696C5C8445B292559C9723CAEBDA7A11373480A
        71F8E4F0C33C19844A33E783E998AE6006A0A167CAA99B1FAFECB5B2308CBAF1
        D9C2A2AE44864345C22E3309CE3A81C287243E9B44C8502B5A7E1CCDDCF217A0
        E681855F9593487CF585306CF64047F2B85A9E80964F0E989C348EE9A6B1B72B
        88EBEF0810D210326265FB874F655F8B00322E0D799312E4D2936B5371CFC8C2
        4B33A0C4415CE967B14507DC5DEDC286561EED4689209F868C10819290CB8D67
        17F5840109C7FBEA1DA4A2EE4CA5062929723C31329870B0F832CEE261B918C5
        4A37B4B7395868411DE401BF1B724282C4809F1A3BBF643CFC0AE2C3BD3F25DA
        79EA1B9BD4F8C8843062F7A177CC07FD4A124B950C74B7588CD03C44A11078CE
        07F02CE202223ACEE59E1B06A80EBE2A3091324369A90AF5E5C96816CCF6092F
        2C0C8F1DE93C7E5818DC1C0202011E3E2E28A4F00869428863B8B6480FE47B9F
        3532C9D4AE13151A14EA14D00FBA20F2F1685D27164EB4A3B03188012701AF5F
        B0385C82C305852F30100124ED6C276DD1D1D34496467AB35A83118EC0EB5106
        0732019B9B436D9F183EEB6FA404ACD8964D604F71122A2E5973FE6A626C75EB
        669746DD9C5FA4C2C50A0A6D36E0D9B0176EB319254E03AA72E3B1B1200D0AED
        C2B03EEF60877E4695C99A072FFCB999ABB6AE48472E46E13574A12C8D4469F1
        62CCD352822011BDDF27F1A8CB8286FB83C33300F2F5FAB94C6AAA5D9DAFC6ED
        B46E642F48036294608262DC31B078DC3981EE0FE34F31C93660E0C0F31980F0
        9435D51654E55CE8D82C46E7208BE6BE29B474D18370326DC2ED9FC3DBDD9EFF
        FEC648924AFD4B4D7AE2CA6FFDA6CBF0E02EFA7777CFA6FB03CB4E49A33B4AE8
        A90000000049454E44AE426082}
    end
  end
  object panRulesTop: TPanel
    Left = 0
    Top = 0
    Width = 648
    Height = 517
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    ParentBackground = False
    TabOrder = 0
    object spltRules: TSplitter
      Left = 104
      Top = 38
      Width = 5
      Height = 475
      ResizeStyle = rsUpdate
      ExplicitHeight = 297
    end
    object RulesToolbar: TActionToolBar
      Left = 4
      Top = 4
      Width = 640
      Height = 34
      ActionManager = RulesActionManager
      Caption = 'Rules'
      Color = clMenuBar
      ColorMap.DisabledFontColor = 7171437
      ColorMap.HighlightColor = clWhite
      ColorMap.BtnSelectedFont = clBlack
      ColorMap.UnusedColor = clWhite
      EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
      EdgeInner = esLowered
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      HorzMargin = 4
      ParentFont = False
      PopupMenu = dm.mnuToolbar
      Spacing = 8
      VertMargin = 4
    end
    object panRuleList: TPanel
      Left = 4
      Top = 38
      Width = 100
      Height = 475
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object listRules: TCheckListBox
        Left = 0
        Top = 0
        Width = 100
        Height = 453
        OnClickCheck = listRulesClickCheck
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnClick = listRulesClick
        OnDragDrop = listRulesDragDrop
        OnDragOver = listRulesDragOver
        OnKeyDown = listRulesKeyDown
        OnKeyUp = listRulesKeyUp
        OnMouseDown = listRulesMouseDown
      end
      object panRuleListButtons: TPanel
        Left = 0
        Top = 453
        Width = 100
        Height = 22
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        OnResize = panRuleListButtonsResize
        object btnRuleDown: TSpeedButton
          Left = 3
          Top = 0
          Width = 45
          Height = 22
          Hint = 'Move Down'
          Enabled = False
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333033333
            33333333373F33333333333330B03333333333337F7F33333333333330F03333
            333333337F7FF3333333333330B00333333333337F773FF33333333330F0F003
            333333337F7F773F3333333330B0B0B0333333337F7F7F7F3333333300F0F0F0
            333333377F73737F33333330B0BFBFB03333337F7F33337F33333330F0FBFBF0
            3333337F7333337F33333330BFBFBFB033333373F3333373333333330BFBFB03
            33333337FFFFF7FF3333333300000000333333377777777F333333330EEEEEE0
            33333337FFFFFF7FF3333333000000000333333777777777F33333330000000B
            03333337777777F7F33333330000000003333337777777773333}
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
          OnClick = btnRuleDownClick
        end
        object btnRuleUp: TSpeedButton
          Left = 51
          Top = 0
          Width = 45
          Height = 22
          Hint = 'Move Up'
          Enabled = False
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333000000000
            333333777777777F33333330B00000003333337F7777777F3333333000000000
            333333777777777F333333330EEEEEE033333337FFFFFF7F3333333300000000
            333333377777777F3333333330BFBFB03333333373333373F33333330BFBFBFB
            03333337F33333F7F33333330FBFBF0F03333337F33337F7F33333330BFBFB0B
            03333337F3F3F7F7333333330F0F0F0033333337F7F7F773333333330B0B0B03
            3333333737F7F7F333333333300F0F03333333337737F7F33333333333300B03
            333333333377F7F33333333333330F03333333333337F7F33333333333330B03
            3333333333373733333333333333303333333333333373333333}
          NumGlyphs = 2
          OnClick = btnRuleUpClick
        end
      end
    end
    object CategoryPanelGroup1: TCategoryPanelGroup
      Left = 109
      Top = 38
      Width = 535
      Height = 475
      VertScrollBar.Tracking = True
      Align = alClient
      ChevronColor = clCaptionText
      ChevronHotColor = clHighlight
      Color = clWindow
      GradientBaseColor = clBtnFace
      GradientColor = clWindow
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Tahoma'
      HeaderFont.Style = []
      TabOrder = 2
      Visible = False
      OnResize = CategoryPanelGroup1Resize
      object catRuleActions: TCategoryPanel
        Top = 229
        Height = 193
        Caption = 'Rule Actions'
        Color = clWindow
        TabOrder = 0
        object btnEdRuleEXE: TSpeedButton
          Left = 508
          Top = 30
          Width = 19
          Height = 28
          Anchors = [akTop, akRight]
          Glyph.Data = {
            96000000424D960000000000000076000000280000000A000000040000000100
            040000000000200000000000000000000000100000000000000000000000FFFF
            FF00000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000111111111100
            0000001100110000000000110011000000001111111111000000}
          Visible = False
          OnClick = btnEdRuleEXEClick
          ExplicitLeft = 491
        end
        object btnEdRuleWav: TSpeedButton
          Left = 480
          Top = 3
          Width = 21
          Height = 21
          Anchors = [akTop, akRight]
          Glyph.Data = {
            96000000424D960000000000000076000000280000000A000000040000000100
            040000000000200000000000000000000000100000000000000000000000FFFF
            FF00000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000111111111100
            0000001100110000000000110011000000001111111111000000}
          Visible = False
          OnClick = btnEdRuleWavClick
          ExplicitLeft = 463
        end
        object btnRuleSoundTest: TSpeedButton
          Left = 507
          Top = 3
          Width = 21
          Height = 21
          Hint = 'Test the sound file'
          Anchors = [akTop, akRight]
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000010000000000000000000
            BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777800087777777777800000877777777780000007777777777800080777
            7777777777770770777777777777077707777777777707770777777777770777
            0777777777770777077777777777077087777777777700007777777777770007
            7777777777770077777777777777087777777777777707777777}
          ParentShowHint = False
          ShowHint = True
          Visible = False
          OnClick = btnRuleSoundTestClick
          ExplicitLeft = 490
        end
        object chkRuleSpam: TCheckBox
          Left = 4
          Top = 39
          Width = 141
          Height = 17
          Caption = '&Mark as Spam'
          TabOrder = 0
          OnClick = chkRuleSpamClick
        end
        object chkRuleDelete: TCheckBox
          Left = 4
          Top = 6
          Width = 141
          Height = 17
          Caption = 'Delete &from server'
          TabOrder = 1
          OnClick = chkRuleDeleteClick
        end
        object chkRuleEXE: TCheckBox
          Left = 148
          Top = 39
          Width = 81
          Height = 17
          Caption = 'E&xecute File'
          TabOrder = 2
          OnClick = chkRuleEXEClick
        end
        object chkRuleIgnore: TCheckBox
          Left = 4
          Top = 63
          Width = 141
          Height = 17
          Caption = 'Igno&re (don'#39't notify)'
          TabOrder = 3
          OnClick = chkRuleIgnoreClick
        end
        object chkRuleImportant: TCheckBox
          Left = 148
          Top = 84
          Width = 197
          Height = 17
          Caption = 'Important (&Balloon Pop-up)'
          TabOrder = 4
          OnClick = chkRuleImportantClick
        end
        object chkRuleLog: TCheckBox
          Left = 4
          Top = 104
          Width = 141
          Height = 17
          Caption = '&Log Rule'
          Checked = True
          State = cbChecked
          TabOrder = 5
          OnClick = chkRuleLogClick
        end
        object chkRuleProtect: TCheckBox
          Left = 148
          Top = 104
          Width = 197
          Height = 17
          Caption = '&Protect against auto-delete'
          TabOrder = 6
          OnClick = chkRuleProtectClick
        end
        object chkRuleTrayColor: TCheckBox
          Left = 148
          Top = 63
          Width = 85
          Height = 17
          Caption = 'Tray &Color'
          TabOrder = 7
          OnClick = chkRuleTrayColorClick
        end
        object chkRuleWav: TCheckBox
          Left = 148
          Top = 5
          Width = 85
          Height = 17
          Caption = 'Play &Sound'
          TabOrder = 8
          OnClick = chkRuleWavClick
        end
        object colRuleTrayColor: TColorBox
          Left = 227
          Top = 62
          Width = 113
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
          TabOrder = 9
          Visible = False
          OnChange = colRuleTrayColorChange
          OnGetColors = colRuleTrayColorGetColors
        end
        object edRuleEXE: TEdit
          Left = 227
          Top = 36
          Width = 275
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 10
          Visible = False
          OnChange = edRuleEXEChange
        end
        object edRuleWav: TEdit
          Left = 227
          Top = 3
          Width = 247
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 11
          Visible = False
          OnChange = edRuleWavChange
        end
        object chkAddLabel: TCheckBox
          Left = 148
          Top = 127
          Width = 99
          Height = 17
          Caption = 'Add Gmail Label'
          TabOrder = 12
          OnClick = chkAddLabelClick
        end
        object edAddLabel: TEdit
          Left = 247
          Top = 127
          Width = 275
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 13
          Visible = False
          OnChange = edAddLabelChange
        end
      end
      object catRuleDetail: TCategoryPanel
        Top = 60
        Height = 169
        Caption = 'Rule Conditions'
        Color = clWindow
        TabOrder = 1
        object panRuleDetail: TPanel
          Left = 0
          Top = 0
          Width = 531
          Height = 139
          Align = alTop
          BevelOuter = bvNone
          Color = clWindow
          ParentBackground = False
          TabOrder = 0
          object lblAccount: TLabel
            Left = 17
            Top = 13
            Width = 39
            Height = 13
            Alignment = taRightJustify
            Caption = 'Acco&unt'
            FocusControl = cmbRuleAccount
          end
          object lblNeeded: TLabel
            Left = 19
            Top = 37
            Width = 37
            Height = 13
            Alignment = taRightJustify
            Caption = 'Nee&ded'
            FocusControl = cmbRuleOperator
          end
          object btnRuleAddRow: TButton
            Left = 184
            Top = 33
            Width = 79
            Height = 21
            Caption = 'Add Row'
            TabOrder = 0
            OnClick = btnRuleAddRowClick
          end
          object btnRuleDeleteRow: TButton
            Left = 268
            Top = 33
            Width = 81
            Height = 21
            Caption = 'Delete Row'
            TabOrder = 1
            OnClick = btnRuleDeleteRowClick
          end
          object chkRuleNew: TCheckBox
            Left = 184
            Top = 11
            Width = 149
            Height = 17
            Caption = 'New Messages &Only'
            TabOrder = 2
            OnClick = chkRuleNewClick
          end
          object cmbRuleAccount: TComboBox
            Left = 60
            Top = 9
            Width = 117
            Height = 21
            Style = csDropDownList
            TabOrder = 3
            OnChange = cmbRuleAccountChange
            Items.Strings = (
              '0'
              '1'
              '2'
              '3')
          end
          object cmbRuleOperator: TComboBox
            Left = 60
            Top = 33
            Width = 117
            Height = 21
            Style = csDropDownList
            TabOrder = 4
            OnChange = cmbRuleOperatorChange
            Items.Strings = (
              'ANY Row'
              'ALL Rows')
          end
          object grdRule: TStringGrid
            Left = 0
            Top = 60
            Width = 531
            Height = 79
            Align = alBottom
            BorderStyle = bsNone
            ColCount = 4
            DefaultRowHeight = 19
            FixedCols = 0
            RowCount = 2
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
            ScrollBars = ssVertical
            TabOrder = 5
            OnSelectCell = grdRuleSelectCell
            OnTopLeftChanged = grdRuleTopLeftChanged
          end
          object panRuleEdit: TPanel
            Left = -1
            Top = 116
            Width = 334
            Height = 21
            BevelOuter = bvNone
            TabOrder = 6
            object btnTestRegExpr: TSpeedButton
              Left = 287
              Top = 0
              Width = 21
              Height = 21
              Hint = 'Test the Reg Expr syntax'
              Glyph.Data = {
                F6000000424DF600000000000000760000002800000010000000100000000100
                04000000000080000000CF0E0000CF0E00001000000000000000000000000000
                80000080000000808000800000008000800080800000C0C0C000808080000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
                7777777774F7777777777777444F777777777774444F7777777777444F44F777
                77777444F7744F777777774F77774F7777777777777774F7777777777077774F
                7777777070707774F7777777000777774F7777000000077774F7777700077777
                7747777070707777777777777077777777777777777777777777}
              ParentShowHint = False
              ShowHint = True
              Visible = False
              OnClick = btnTestRegExprClick
            end
            object cmbRuleArea: TComboBox
              Left = 0
              Top = 0
              Width = 93
              Height = 21
              Style = csDropDownList
              TabOrder = 0
              OnChange = cmbRuleAreaChange
              Items.Strings = (
                'Header'
                'From'
                'Subject'
                'To'
                'CC'
                'From (name)'
                'From (address)'
                'Status')
            end
            object cmbRuleComp: TComboBox
              Left = 92
              Top = 0
              Width = 76
              Height = 21
              Style = csDropDownList
              TabOrder = 1
              OnChange = cmbRuleCompChange
              Items.Strings = (
                'Contains'
                'Equals'
                'Wildcard'
                'Empty'
                'Reg Expr')
            end
            object edRuleText: TEdit
              Left = 167
              Top = 0
              Width = 120
              Height = 21
              TabOrder = 2
              OnChange = edRuleTextChange
            end
            object chkRuleNot: TCheckBox
              Left = 315
              Top = 4
              Width = 13
              Height = 13
              TabOrder = 4
              OnClick = chkRuleNotClick
            end
            object cmbRuleStatus: TComboBox
              Left = 167
              Top = -1
              Width = 98
              Height = 21
              TabOrder = 3
              Visible = False
              OnChange = cmbRuleStatusChange
              Items.Strings = (
                'Protected'
                'To Be Deleted'
                'Ignored'
                'Spam'
                'Important'
                'Has Attachment'
                'Viewed'
                'New')
            end
          end
        end
      end
      object catRuleName: TCategoryPanel
        Top = 0
        Height = 60
        Caption = 'Rule Settings'
        Color = clWindow
        TabOrder = 2
        object lblRuleName: TLabel
          Left = 6
          Top = 9
          Width = 31
          Height = 13
          Caption = '&Name:'
          FocusControl = edRuleName
        end
        object chkRuleEnabled: TCheckBox
          Left = 462
          Top = 8
          Width = 65
          Height = 17
          Alignment = taLeftJustify
          Anchors = [akTop, akRight]
          Caption = '&Enabled:'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = chkRuleEnabledClick
        end
        object edRuleName: TEdit
          Left = 43
          Top = 6
          Width = 171
          Height = 21
          TabOrder = 1
          OnChange = edRuleNameChange
        end
      end
    end
  end
  object RulesActionManager: TActionManager
    ActionBars = <
      item
        Items.CaptionOptions = coAll
        Items = <
          item
            Action = actRuleAdd
            Caption = '&Add Rule'
            ImageIndex = 7
          end
          item
            Action = actRuleDelete
            Caption = '&Delete Rule'
            ImageIndex = 1
          end
          item
            Action = actRulesImport
            ImageIndex = 13
          end>
        ActionBar = RulesToolbar
      end>
    DisabledImages = dm.imlActionsDisabled
    Images = dm.imlActions
    Left = 41
    Top = 146
    StyleName = 'Platform Default'
    object actRuleAdd: TAction
      Category = 'Rules'
      Caption = 'Add Rule'
      ImageIndex = 7
      OnExecute = actRuleAddExecute
    end
    object actRuleDelete: TAction
      Category = 'Rules'
      Caption = 'Delete Rule'
      Enabled = False
      ImageIndex = 1
      OnExecute = actRuleDeleteExecute
    end
    object actRulesImport: TAction
      Category = 'Rules'
      Caption = '&Import Rules'
      ImageIndex = 13
      OnExecute = actRulesImportExecute
    end
  end
end
