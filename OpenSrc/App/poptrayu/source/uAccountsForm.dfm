object AccountsForm: TAccountsForm
  Left = 0
  Top = 0
  Caption = 'Email Accounts'
  ClientHeight = 769
  ClientWidth = 543
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object panAccounts: TPanel
    Left = 0
    Top = 0
    Width = 543
    Height = 769
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    ParentBackground = False
    TabOrder = 0
    object tabAccounts: TTabControl
      Left = 4
      Top = 38
      Width = 535
      Height = 698
      Margins.Left = 12
      Margins.Top = 12
      Margins.Right = 12
      Margins.Bottom = 12
      Align = alClient
      Images = dm.imlTabs
      MultiLine = True
      TabOrder = 0
      OnChange = tabAccountsChange
      OnChanging = tabAccountsChanging
      OnDragDrop = tabDragDrop
      OnDragOver = tabAccountsDragOver
      OnMouseDown = DragMouseDown
      object ScrollBox2: TScrollBox
        Left = 4
        Top = 6
        Width = 527
        Height = 688
        Align = alClient
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        OnDragDrop = tabDragDrop
        OnDragOver = tabAccountsDragOver
        OnMouseDown = DragMouseDown
        object panelGrp1: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 527
          Height = 688
          VertScrollBar.Tracking = True
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          ChevronColor = clBtnText
          ChevronHotColor = clHighlight
          Color = clWindow
          GradientBaseColor = clBtnFace
          GradientColor = clWindow
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -11
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = [fsBold]
          TabOrder = 0
          object catPopTrayAccountPrefs: TCategoryPanel
            Top = 427
            Height = 159
            Caption = 'PopTrayU Account Preferences'
            Color = clWindow
            TabOrder = 0
            StyleElements = [seFont, seClient]
            object btnAccountProgramTest: TSpeedButton
              Left = 362
              Top = 9
              Width = 72
              Height = 23
              Hint = 'Test to run the e-mail program'
              Anchors = [akTop, akRight]
              Caption = 'Test'
              Enabled = False
              ParentShowHint = False
              ShowHint = True
              OnClick = btnAccountProgramTestClick
              ExplicitLeft = 464
            end
            object btnAccountSoundTest: TSpeedButton
              Left = 362
              Top = 38
              Width = 72
              Height = 23
              Hint = 'Test the sound file'
              Anchors = [akTop, akRight]
              Caption = 'Test'
              Enabled = False
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
              OnClick = btnAccountSoundTestClick
              ExplicitLeft = 464
            end
            object btnEdAccountProgram: TSpeedButton
              Left = 335
              Top = 9
              Width = 21
              Height = 23
              Anchors = [akTop, akRight]
              Enabled = False
              Glyph.Data = {
                96000000424D960000000000000076000000280000000A000000040000000100
                040000000000200000000000000000000000100000000000000000000000FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000111111111100
                0000001100110000000000110011000000001111111111000000}
              OnClick = btnEdAccountProgramClick
              ExplicitLeft = 437
            end
            object btnEdSound: TSpeedButton
              Left = 335
              Top = 38
              Width = 21
              Height = 23
              Anchors = [akTop, akRight]
              Enabled = False
              Glyph.Data = {
                96000000424D960000000000000076000000280000000A000000040000000100
                040000000000200000000000000000000000100000000000000000000000FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000111111111100
                0000001100110000000000110011000000001111111111000000}
              OnClick = btnEdSoundClick
              ExplicitLeft = 437
            end
            object lblEmailApp: TLabel
              Left = 8
              Top = 9
              Width = 75
              Height = 13
              Caption = '&E-Mail Program:'
              FocusControl = edAccountProgram
            end
            object lblAccountSound: TLabel
              Left = 9
              Top = 39
              Width = 34
              Height = 13
              Caption = 'So&und:'
              FocusControl = edSound
            end
            object edAccountProgram: TEdit
              Left = 89
              Top = 9
              Width = 240
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              Color = clBtnFace
              Enabled = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              Text = '[Use Default Program]'
              OnChange = edAccChange
              OnClick = edAccChange
              OnEnter = edAccountProgramEnter
              OnExit = edAccountProgramExit
            end
            object edSound: TEdit
              Left = 89
              Top = 40
              Width = 240
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              Color = clBtnFace
              Enabled = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              Text = '[Use Default Sound]'
              OnChange = edAccChange
              OnClick = edAccChange
              OnEnter = edSoundEnter
              OnExit = edSoundExit
            end
            object panNoCheckHours: TPanel
              Left = 8
              Top = 103
              Width = 428
              Height = 25
              Anchors = [akLeft, akTop, akRight]
              BevelOuter = bvNone
              TabOrder = 2
              object lblAnd: TLabel
                Left = 265
                Top = 3
                Width = 18
                Height = 13
                Alignment = taCenter
                Caption = 'and'
              end
              object chkDontCheckTimes: TCheckBox
                Left = 1
                Top = 2
                Width = 181
                Height = 17
                Caption = '&Don'#39't check this account between'
                TabOrder = 0
                OnClick = chkDontCheckTimesClick
              end
              object dtStart: TDateTimePicker
                Left = 188
                Top = 0
                Width = 68
                Height = 21
                Date = 37759.833333333300000000
                Format = 'hh:mmtt'
                Time = 37759.833333333300000000
                Enabled = False
                Kind = dtkTime
                TabOrder = 1
                OnClick = edAccChange
              end
              object dtEnd: TDateTimePicker
                Left = 296
                Top = 0
                Width = 68
                Height = 21
                Date = 37759.333333333300000000
                Format = 'hh:mmtt'
                Time = 37759.333333333300000000
                Enabled = False
                Kind = dtkTime
                TabOrder = 2
                OnClick = edAccChange
              end
            end
            object panIntervalAccount: TPanel
              Left = 0
              Top = 67
              Width = 561
              Height = 29
              BevelOuter = bvNone
              TabOrder = 3
              Visible = False
              object btnNeverAccount: TSpeedButton
                Left = 230
                Top = 4
                Width = 72
                Height = 23
                Caption = 'Ne&ver'
                OnClick = btnNeverAccountClick
              end
              object lblCheckMins: TLabel
                Left = 183
                Top = 7
                Width = 41
                Height = 13
                Caption = 'minutes.'
              end
              object lblCheckEvery: TLabel
                Left = 8
                Top = 7
                Width = 121
                Height = 13
                Caption = 'Chec&k for new mail every'
                FocusControl = edIntervalAccount
              end
              object lblTest: TLabel
                Left = 308
                Top = 17
                Width = 31
                Height = 13
                Caption = 'lblTest'
                Visible = False
              end
              object edIntervalAccount: TEdit
                Left = 135
                Top = 4
                Width = 29
                Height = 21
                TabOrder = 0
                Text = '5'
                OnChange = edAccChange
                OnClick = edAccChange
              end
              object UpDownAccount: TUpDown
                Left = 164
                Top = 4
                Width = 16
                Height = 21
                Associate = edIntervalAccount
                Max = 999
                Position = 5
                TabOrder = 1
              end
            end
          end
          object catImap: TCategoryPanel
            Top = 246
            Height = 181
            Caption = 'IMAP Account Options'
            Color = clWindow
            TabOrder = 1
            object lblSpamFolder: TLabel
              Left = 29
              Top = 54
              Width = 63
              Height = 13
              Caption = 'Spam Folder:'
            end
            object lblTrashFolder: TLabel
              Left = 28
              Top = 101
              Width = 64
              Height = 13
              Caption = 'Trash Folder:'
            end
            object btnSpamFolder: TSpeedButton
              Left = 225
              Top = 54
              Width = 23
              Height = 22
              Caption = '...'
              Enabled = False
              OnClick = btnPickFolderClick
            end
            object btnTrashFolder: TSpeedButton
              Left = 225
              Top = 100
              Width = 23
              Height = 22
              Caption = '...'
              Enabled = False
              OnClick = btnPickFolderClick
            end
            object lblArchiveFolder: TLabel
              Left = 8
              Top = 137
              Width = 73
              Height = 13
              Caption = 'Archive Folder:'
            end
            object btnArchiveFolder: TSpeedButton
              Left = 214
              Top = 128
              Width = 23
              Height = 22
              Caption = '...'
              Enabled = False
              OnClick = btnPickFolderClick
            end
            object chkGmailExt: TCheckBox
              Left = 8
              Top = 8
              Width = 510
              Height = 17
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Use Gmail IMAP Extensions'
              Enabled = False
              TabOrder = 0
              OnClick = edAccChange
            end
            object chkMoveSpam: TCheckBox
              Left = 8
              Top = 31
              Width = 509
              Height = 17
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Use Server Spam Folder (when Deleting Spam)'
              Enabled = False
              TabOrder = 1
              OnClick = chkMoveSpamClick
            end
            object edSpamFolder: TEdit
              Left = 98
              Top = 54
              Width = 121
              Height = 21
              Enabled = False
              TabOrder = 2
              Text = '[Gmail]/Spam'
              OnChange = edAccChange
              OnClick = edAccChange
            end
            object chkMoveTrash: TCheckBox
              Left = 8
              Top = 78
              Width = 509
              Height = 17
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Use Server Trash Folder'
              Enabled = False
              TabOrder = 3
              OnClick = chkMoveTrashClick
            end
            object edTrashFolder: TEdit
              Left = 87
              Top = 128
              Width = 121
              Height = 21
              Enabled = False
              TabOrder = 4
              Text = '[Gmail]/Trash'
              OnChange = edAccChange
              OnClick = edAccChange
            end
            object edArchiveFolder: TEdit
              Left = 98
              Top = 101
              Width = 121
              Height = 21
              Enabled = False
              TabOrder = 5
              Text = '[Gmail]/All Mail'
              OnChange = edAccChange
              OnClick = edAccChange
            end
          end
          object catAdvAcc: TCategoryPanel
            Top = 170
            Height = 76
            Caption = 'Advanced Connection Settings'
            Color = clWindow
            TabOrder = 2
            StyleElements = [seFont, seClient]
            object lblAuthMode: TLabel
              AlignWithMargins = True
              Left = 8
              Top = 6
              Width = 103
              Height = 13
              Alignment = taRightJustify
              Caption = 'Authentication Mode:'
              FocusControl = edName
            end
            object lblSslVer: TLabel
              AlignWithMargins = True
              Left = 225
              Top = 6
              Width = 80
              Height = 13
              Alignment = taRightJustify
              Caption = 'SSL/TLS Version:'
              FocusControl = edName
            end
            object lblStartls: TLabel
              AlignWithMargins = True
              Left = 60
              Top = 30
              Width = 53
              Height = 13
              Alignment = taRightJustify
              Caption = 'STARTTLS:'
            end
            object cmbSslVer: TComboBox
              AlignWithMargins = True
              Left = 311
              Top = 3
              Width = 100
              Height = 21
              TabOrder = 0
              Text = 'Auto'
              OnChange = edAccChange
              OnClick = edAccChange
              Items.Strings = (
                'Auto'
                'SSL 2.0'
                'SSL 3.0'
                'TLS 1.0'
                'TLS 1.1'
                'TLS 1.2')
            end
            object chkStartTLS: TCheckBox
              Left = 120
              Top = 27
              Width = 44
              Height = 21
              Hint = 'AKA Explicit TLS'
              TabOrder = 1
              OnClick = chkSSLClick
            end
            object cmbAuthType: TComboBox
              AlignWithMargins = True
              Left = 119
              Top = 3
              Width = 100
              Height = 21
              TabOrder = 2
              Text = 'Auto'
              OnChange = edAccChange
              OnClick = edAccChange
              Items.Strings = (
                'Auto'
                'Password'
                'APOP'
                'SASL')
            end
          end
          object catBasicAccount: TCategoryPanel
            Top = 57
            Height = 113
            Caption = 'Connection Settings'
            Color = clWindow
            TabOrder = 3
            StyleElements = [seFont, seClient]
            object lblServer: TLabel
              AlignWithMargins = True
              Left = 8
              Top = 9
              Width = 103
              Height = 13
              Alignment = taRightJustify
              Caption = 'Incoming Mail &Server:'
              FocusControl = edServer
            end
            object lblUsername: TLabel
              AlignWithMargins = True
              Left = 59
              Top = 36
              Width = 52
              Height = 13
              Alignment = taRightJustify
              Caption = '&Username:'
              FocusControl = edUsername
            end
            object lblPw: TLabel
              AlignWithMargins = True
              Left = 61
              Top = 63
              Width = 50
              Height = 13
              Alignment = taRightJustify
              Caption = 'Pass&word:'
              FocusControl = edPassword
            end
            object lblProt: TLabel
              AlignWithMargins = True
              Left = 273
              Top = 9
              Width = 43
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = '&Protocol:'
              FocusControl = cmbProtocol
              ExplicitLeft = 375
            end
            object lblPort: TLabel
              AlignWithMargins = True
              Left = 292
              Top = 63
              Width = 24
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = 'P&ort:'
              FocusControl = edPort
              ExplicitLeft = 394
            end
            object lblUseSsl: TLabel
              AlignWithMargins = True
              Left = 253
              Top = 36
              Width = 63
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = 'Use SSL/TLS:'
              ExplicitLeft = 355
            end
            object edServer: TEdit
              AlignWithMargins = True
              Left = 117
              Top = 6
              Width = 122
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 0
              OnChange = edAccChange
              OnClick = edAccChange
            end
            object edUsername: TEdit
              AlignWithMargins = True
              Left = 117
              Top = 33
              Width = 122
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 1
              OnChange = edAccChange
              OnClick = edAccChange
            end
            object edPassword: TEdit
              AlignWithMargins = True
              Left = 117
              Top = 60
              Width = 122
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              Color = clBtnFace
              Enabled = False
              PasswordChar = '*'
              TabOrder = 2
              OnChange = edAccChange
              OnClick = edAccChange
            end
            object chkSSL: TCheckBox
              AlignWithMargins = True
              Left = 322
              Top = 32
              Width = 110
              Height = 22
              Anchors = [akTop, akRight]
              Enabled = False
              TabOrder = 3
              OnClick = chkSSLClick
            end
            object edPort: TEdit
              AlignWithMargins = True
              Left = 322
              Top = 60
              Width = 63
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 4
              OnChange = edAccChange
              OnClick = edAccChange
            end
            object cmbProtocol: TComboBox
              Left = 322
              Top = 5
              Width = 110
              Height = 21
              Style = csDropDownList
              Anchors = [akRight]
              Color = clBtnFace
              Enabled = False
              ItemIndex = 0
              TabOrder = 5
              Text = 'POP3'
              OnChange = cmbProtocolChange
              Items.Strings = (
                'POP3')
            end
          end
          object catAccName: TCategoryPanel
            Top = 0
            Height = 57
            Caption = 'Display Options'
            Color = clWindow
            TabOrder = 4
            StyleElements = [seFont, seClient]
            object lblName: TLabel
              Left = 8
              Top = 8
              Width = 31
              Height = 13
              Alignment = taRightJustify
              Caption = '&Name:'
              FocusControl = edName
            end
            object lblColor: TLabel
              Left = 208
              Top = 8
              Width = 29
              Height = 13
              Alignment = taRightJustify
              Caption = '&Color:'
              FocusControl = colAccount
            end
            object lblEnableAccount: TLabel
              Left = 369
              Top = 3
              Width = 42
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = 'Enabled:'
              Layout = tlCenter
            end
            object chkAccEnabled: TCheckBox
              Left = 414
              Top = 2
              Width = 18
              Height = 24
              Alignment = taLeftJustify
              Anchors = [akTop, akRight]
              Enabled = False
              TabOrder = 0
              OnClick = edAccChange
            end
            object edName: TEdit
              Left = 45
              Top = 5
              Width = 142
              Height = 21
              Color = clBtnFace
              Enabled = False
              TabOrder = 1
              OnChange = edAccChange
              OnClick = edAccChange
            end
            object colAccount: TColorBox
              Left = 243
              Top = 5
              Width = 113
              Height = 22
              Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
              Color = clBtnFace
              TabOrder = 2
              OnChange = edAccChange
              OnClick = edAccChange
              OnGetColors = colAccountGetColors
            end
          end
        end
      end
    end
    object panAccountsButtons: TPanel
      Left = 4
      Top = 736
      Width = 535
      Height = 29
      Align = alBottom
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 1
      DesignSize = (
        535
        29)
      object btnSave: TBitBtn
        Left = 315
        Top = 4
        Width = 120
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Save Account'
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
        OnClick = btnSaveAccountClick
      end
      object btnCancelAccount: TBitBtn
        Left = 442
        Top = 4
        Width = 90
        Height = 25
        Anchors = [akTop, akRight]
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
        OnClick = btnCancelAccountClick
      end
      object btnHelpAccounts: TPngBitBtn
        Left = 4
        Top = 4
        Width = 70
        Height = 25
        Caption = '&Help'
        TabOrder = 2
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
    object AccountsToolbar: TActionToolBar
      Left = 4
      Top = 4
      Width = 535
      Height = 34
      ActionManager = AccountsActionManager
      Caption = 'Accounts'
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
  end
  object AccountsActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = actAddAccount
            Caption = '&Add Account'
            ImageIndex = 5
          end
          item
            Action = actDeleteAccount
            Caption = '&Delete Account'
            ImageIndex = 6
          end
          item
            Action = actTestAccount
            Caption = '&Test Account'
            ImageIndex = 23
          end
          item
            Action = actExport
            Caption = '&Export'
            ImageIndex = 31
          end
          item
            Action = actImport
            Caption = '&Import'
            ImageIndex = 13
          end>
        ActionBar = AccountsToolbar
      end>
    DisabledImages = dm.imlActionsDisabled
    Images = dm.imlActions
    Left = 373
    Top = 9
    StyleName = 'Platform Default'
    object actAddAccount: TAction
      Category = 'Accounts'
      Caption = 'Add Account'
      ImageIndex = 5
      OnExecute = actAddAccountExecute
    end
    object actDeleteAccount: TAction
      Category = 'Accounts'
      Caption = 'Delete Account'
      Enabled = False
      ImageIndex = 6
      OnExecute = actDeleteAccountExecute
    end
    object actTestAccount: TAction
      Category = 'Accounts'
      Caption = 'Test Account'
      Enabled = False
      ImageIndex = 23
      OnExecute = actTestAccountExecute
    end
    object actExport: TAction
      Category = 'Accounts'
      Caption = 'Export'
      OnExecute = actExportExecute
    end
    object actImport: TAction
      Category = 'Accounts'
      Caption = 'Import'
      ImageIndex = 13
      OnExecute = actImportExecute
    end
  end
end
