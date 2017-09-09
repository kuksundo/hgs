object frmOptions: TfrmOptions
  Left = 226
  Top = 301
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 401
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PopupMode = pmAuto
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object pnlBottom: TPanel
    Left = 0
    Top = 368
    Width = 496
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object BitBtn1: TBitBtn
      AlignWithMargins = True
      Left = 418
      Top = 3
      Width = 75
      Height = 27
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 414
      ExplicitTop = 4
      ExplicitHeight = 25
    end
    object BitBtn2: TBitBtn
      AlignWithMargins = True
      Left = 337
      Top = 3
      Width = 75
      Height = 27
      Align = alRight
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 0
      ExplicitLeft = 334
      ExplicitTop = 4
      ExplicitHeight = 25
    end
  end
  object PageControlMain: TPageControl
    Left = 0
    Top = 0
    Width = 496
    Height = 368
    ActivePage = tabAdvanced
    Align = alClient
    Images = frmBandS.ImageListCommon
    MultiLine = True
    TabOrder = 0
    OnChange = PageControlMainChange
    object tabGeneral: TTabSheet
      Caption = 'General'
      ImageIndex = 228
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        488
        335)
      object GroupBoxGeneral: TGroupBox
        Left = 4
        Top = 4
        Width = 194
        Height = 281
        Anchors = [akLeft, akTop, akBottom]
        Caption = 'General'
        TabOrder = 0
        ExplicitHeight = 285
        object Label10: TLabel
          Left = 8
          Top = 36
          Width = 125
          Height = 14
          Caption = 'Password protect options'
        end
        object cbAutoRun: TCheckBox
          Left = 8
          Top = 16
          Width = 133
          Height = 17
          Caption = 'Load on system startup.'
          TabOrder = 0
        end
        object editPassword: TEdit
          Left = 28
          Top = 56
          Width = 121
          Height = 20
          Font.Charset = SYMBOL_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Wingdings'
          Font.Style = []
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          PasswordChar = 'l'
          TabOrder = 1
        end
        object cbRememberLastSelection: TCheckBox
          Left = 8
          Top = 82
          Width = 153
          Height = 17
          Caption = 'Remember last selection.'
          TabOrder = 2
        end
        object ComboBoxLastSelection: TComboBox
          Left = 16
          Top = 105
          Width = 145
          Height = 22
          Style = csDropDownList
          ImeName = 'Microsoft IME 2010'
          TabOrder = 3
        end
        object cbAutoupdateEnabled: TCheckBox
          Left = 8
          Top = 138
          Width = 117
          Height = 17
          Caption = 'Check for Updates'
          TabOrder = 4
        end
      end
      object GroupBoxWarnings: TGroupBox
        Left = 204
        Top = 4
        Width = 281
        Height = 57
        Caption = 'Warnings'
        TabOrder = 1
        object cbLastBackupWarning: TCheckBox
          Left = 8
          Top = 16
          Width = 153
          Height = 17
          Caption = 'Last successful backup.'
          TabOrder = 0
        end
        object cbCheckActivePrograms: TCheckBox
          Left = 8
          Top = 36
          Width = 137
          Height = 17
          Caption = 'Check active programs.'
          TabOrder = 1
        end
      end
    end
    object tabBackupProfiles: TTabSheet
      Caption = 'Backup Profiles'
      ImageIndex = 274
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBoxBackupProfile: TGroupBox
        Left = 0
        Top = 0
        Width = 488
        Height = 335
        Align = alClient
        Caption = 'Backup Profiles'
        TabOrder = 0
        object pnlBackupProfiles: TPanel
          Left = 2
          Top = 16
          Width = 484
          Height = 317
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 10
          TabOrder = 0
          object ToolBar1: TToolBar
            Left = 10
            Top = 10
            Width = 464
            Height = 30
            ButtonHeight = 30
            ButtonWidth = 31
            Caption = 'ToolBarProfiles'
            Images = ImageListBackupProfiles
            TabOrder = 0
            object ToolButton4: TToolButton
              Left = 0
              Top = 0
              Action = ActionBackupProfileWizard
              ImageIndex = 4
            end
            object ToolButton6: TToolButton
              Left = 31
              Top = 0
              Width = 8
              Caption = 'ToolButton6'
              ImageIndex = 4
              Style = tbsSeparator
            end
            object btnAddProfile: TToolButton
              Left = 39
              Top = 0
              Hint = 'New backup profile.'
              Caption = 'btnAddProfile'
              ImageIndex = 0
              ParentShowHint = False
              ShowHint = True
              OnClick = btnAddProfileClick
            end
            object btnEditProfile: TToolButton
              Left = 70
              Top = 0
              Hint = 'Edit backup profile'
              Caption = 'btnEditProfile'
              ImageIndex = 2
              ParentShowHint = False
              ShowHint = True
              OnClick = btnEditProfileClick
            end
            object btnRemoveProfile: TToolButton
              Left = 101
              Top = 0
              Hint = 'Remove backup profile.'
              Caption = 'btnRemoveProfile'
              ImageIndex = 1
              ParentShowHint = False
              ShowHint = True
              OnClick = btnRemoveProfileClick
            end
            object ToolButton5: TToolButton
              Left = 132
              Top = 0
              Width = 8
              Caption = 'ToolButton5'
              ImageIndex = 4
              Style = tbsSeparator
            end
            object btnRemoveAllProfiles: TToolButton
              Left = 140
              Top = 0
              Hint = 'Remove all backup profiles'
              Caption = 'btnRemoveAllProfiles'
              ImageIndex = 3
              ParentShowHint = False
              ShowHint = True
              OnClick = btnRemoveAllProfilesClick
            end
          end
          object ListViewBackupProfiles: TListView
            Left = 10
            Top = 40
            Width = 464
            Height = 267
            Align = alClient
            Checkboxes = True
            Columns = <
              item
                Caption = 'Profile Name'
                Width = 200
              end
              item
                AutoSize = True
                Caption = 'Last Backup'
              end
              item
                AutoSize = True
                Caption = 'Zip File'
              end>
            GridLines = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 1
            ViewStyle = vsReport
            OnDblClick = ListViewBackupProfilesDblClick
            OnMouseUp = ListViewBackupProfilesMouseUp
          end
        end
      end
    end
    object tabConnectivity: TTabSheet
      Caption = 'Connectivity'
      ImageIndex = 346
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBoxAutoUpdate: TGroupBox
        Left = 0
        Top = 0
        Width = 488
        Height = 335
        Align = alClient
        Caption = 'Connectivity'
        TabOrder = 0
        object Bevel1: TBevel
          Left = 2
          Top = 325
          Width = 484
          Height = 8
          Align = alBottom
          Shape = bsBottomLine
          ExplicitTop = 96
          ExplicitWidth = 458
        end
        object PageControlProxy: TPageControl
          Left = 2
          Top = 16
          Width = 484
          Height = 309
          ActivePage = tabSMTP
          Align = alClient
          Images = frmBandS.ImageListCommon
          TabOrder = 0
          OnChange = PageControlProxyChange
          ExplicitHeight = 313
          object tabSMTP: TTabSheet
            Caption = 'SMTP'
            ImageIndex = 117
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object GroupBox3: TGroupBox
              Left = 0
              Top = 0
              Width = 476
              Height = 276
              Align = alClient
              Caption = 'SMTP Settings'
              TabOrder = 0
              object Label11: TLabel
                Left = 337
                Top = 21
                Width = 49
                Height = 14
                Caption = 'SMTP Port'
              end
              object editSMTPServer: TLabeledEdit
                Left = 10
                Top = 38
                Width = 318
                Height = 22
                EditLabel.Width = 63
                EditLabel.Height = 14
                EditLabel.Caption = 'SMTP Server'
                ImeName = 'Microsoft IME 2010'
                TabOrder = 1
              end
              object editSMTPPort: TSpinEdit
                Left = 334
                Top = 37
                Width = 133
                Height = 23
                MaxValue = 1000000
                MinValue = 0
                TabOrder = 0
                Value = 0
              end
              object cbSMTPAuthentication: TCheckBox
                Left = 10
                Top = 70
                Width = 125
                Height = 17
                Caption = 'SMTP Authentication'
                TabOrder = 2
              end
              object editSMTPUsername: TLabeledEdit
                Left = 10
                Top = 108
                Width = 153
                Height = 22
                EditLabel.Width = 49
                EditLabel.Height = 14
                EditLabel.Caption = 'Username'
                ImeName = 'Microsoft IME 2010'
                TabOrder = 3
              end
              object editSMTPPassword: TLabeledEdit
                Left = 169
                Top = 109
                Width = 153
                Height = 20
                EditLabel.Width = 50
                EditLabel.Height = 14
                EditLabel.Caption = 'Password'
                Font.Charset = SYMBOL_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Wingdings'
                Font.Style = []
                ImeName = 'Microsoft IME 2010'
                ParentFont = False
                PasswordChar = 'l'
                TabOrder = 4
              end
              object cbSMTPSecure: TCheckBox
                Left = 10
                Top = 136
                Width = 125
                Height = 17
                Caption = 'Secure Connection'
                TabOrder = 5
              end
            end
          end
          object tabHTTPProxy: TTabSheet
            Caption = 'HTTP Proxy'
            ImageIndex = 347
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object cbHTTPProxy: TCheckBox
              Left = 0
              Top = 0
              Width = 476
              Height = 17
              Align = alTop
              Caption = 'Enable HTTP Proxy'
              TabOrder = 0
            end
            object GroupBoxHTTPProxy: TGroupBox
              Left = 0
              Top = 17
              Width = 476
              Height = 259
              Align = alClient
              TabOrder = 1
              object Host: TLabel
                Left = 8
                Top = 12
                Width = 22
                Height = 14
                Caption = 'Host'
              end
              object Label2: TLabel
                Left = 184
                Top = 12
                Width = 19
                Height = 14
                Caption = 'Port'
              end
              object Label3: TLabel
                Left = 316
                Top = 28
                Width = 49
                Height = 14
                Caption = 'Username'
              end
              object Label4: TLabel
                Left = 316
                Top = 72
                Width = 50
                Height = 14
                Caption = 'Password'
              end
              object Bevel2: TBevel
                Left = 8
                Top = 60
                Width = 297
                Height = 9
              end
              object editHTTPHost: TEdit
                Left = 8
                Top = 28
                Width = 169
                Height = 22
                ImeName = 'Microsoft IME 2010'
                TabOrder = 1
              end
              object editHTTPPort: TEdit
                Left = 184
                Top = 28
                Width = 57
                Height = 22
                ImeName = 'Microsoft IME 2010'
                TabOrder = 2
              end
              object cbBasicHTTPAuthentication: TCheckBox
                Left = 316
                Top = 12
                Width = 125
                Height = 17
                Caption = 'Authentication'
                TabOrder = 0
              end
              object editHTTPUsername: TEdit
                Left = 316
                Top = 44
                Width = 121
                Height = 22
                ImeName = 'Microsoft IME 2010'
                TabOrder = 3
              end
              object editHTTPPassword: TEdit
                Left = 316
                Top = 88
                Width = 121
                Height = 22
                ImeName = 'Microsoft IME 2010'
                TabOrder = 4
              end
            end
          end
          object tabSOCKSProxy: TTabSheet
            Caption = 'Socks Proxy'
            ImageIndex = 347
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object cbSocksProxy: TCheckBox
              Left = 0
              Top = 0
              Width = 476
              Height = 17
              Align = alTop
              Caption = 'Enable Socks Proxy'
              TabOrder = 0
            end
            object GroupBoxSocksProxy: TGroupBox
              Left = 0
              Top = 17
              Width = 476
              Height = 259
              Align = alClient
              TabOrder = 1
              object Label5: TLabel
                Left = 8
                Top = 12
                Width = 22
                Height = 14
                Caption = 'Host'
              end
              object Label6: TLabel
                Left = 184
                Top = 12
                Width = 19
                Height = 14
                Caption = 'Port'
              end
              object Label7: TLabel
                Left = 316
                Top = 28
                Width = 49
                Height = 14
                Caption = 'Username'
              end
              object Label8: TLabel
                Left = 316
                Top = 72
                Width = 50
                Height = 14
                Caption = 'Password'
              end
              object Label9: TLabel
                Left = 8
                Top = 72
                Width = 73
                Height = 14
                Caption = 'Socks Version:'
              end
              object Bevel3: TBevel
                Left = 8
                Top = 60
                Width = 297
                Height = 9
              end
              object editSocksHost: TEdit
                Left = 8
                Top = 28
                Width = 169
                Height = 22
                ImeName = 'Microsoft IME 2010'
                TabOrder = 1
              end
              object editSocksPort: TEdit
                Left = 184
                Top = 28
                Width = 57
                Height = 22
                ImeName = 'Microsoft IME 2010'
                TabOrder = 2
              end
              object cbSocksAuthentication: TCheckBox
                Left = 316
                Top = 12
                Width = 125
                Height = 17
                Caption = 'Authentication'
                TabOrder = 0
              end
              object editSocksUsername: TEdit
                Left = 316
                Top = 44
                Width = 121
                Height = 22
                ImeName = 'Microsoft IME 2010'
                TabOrder = 3
              end
              object editSocksPassword: TEdit
                Left = 316
                Top = 88
                Width = 121
                Height = 22
                ImeName = 'Microsoft IME 2010'
                TabOrder = 5
              end
              object comboSocksVersion: TComboBox
                Left = 8
                Top = 88
                Width = 117
                Height = 22
                Style = csDropDownList
                ImeName = 'Microsoft IME 2010'
                TabOrder = 4
                Items.Strings = (
                  'Socks 4'
                  'Socks 5')
              end
            end
          end
        end
      end
    end
    object tabLog: TTabSheet
      Caption = 'Log'
      ImageIndex = 187
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 488
        Height = 335
        Align = alClient
        Caption = 'Log'
        TabOrder = 0
        object pnlLog: TPanel
          Left = 2
          Top = 16
          Width = 484
          Height = 317
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 10
          TabOrder = 0
          object ToolBarLog: TToolBar
            Left = 10
            Top = 10
            Width = 464
            Height = 26
            AutoSize = True
            ButtonHeight = 26
            ButtonWidth = 103
            Caption = 'ToolBarLog'
            Images = frmBandS.ImageListCommon
            List = True
            ShowCaptions = True
            TabOrder = 0
            object ToolButton1: TToolButton
              Left = 0
              Top = 0
              Action = ActionRefreshLog
            end
            object ToolButton2: TToolButton
              Left = 103
              Top = 0
              Width = 8
              Caption = 'ToolButton2'
              ImageIndex = 256
              Style = tbsSeparator
            end
            object ToolButton3: TToolButton
              Left = 111
              Top = 0
              Action = ActionOpenLogInExplorer
            end
          end
          object memoLog: TMemo
            Left = 10
            Top = 36
            Width = 464
            Height = 271
            Align = alClient
            ImeName = 'Microsoft IME 2010'
            ScrollBars = ssVertical
            TabOrder = 1
          end
        end
      end
    end
    object tabAdvanced: TTabSheet
      Caption = 'Advanced'
      ImageIndex = 159
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 488
        Height = 335
        Align = alClient
        Caption = 'Log'
        TabOrder = 0
        object pnlAdvanced: TPanel
          Left = 2
          Top = 16
          Width = 484
          Height = 317
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 10
          TabOrder = 0
          object Label1: TLabel
            Left = 10
            Top = 279
            Width = 464
            Height = 28
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            Caption = 
              'NOTE: The above settings are for advance users only. Changing th' +
              'ese setting may have an adverse effect on program performance.'
            Font.Charset = ANSI_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            WordWrap = True
            ExplicitLeft = 16
            ExplicitTop = 272
            ExplicitWidth = 449
          end
          object PageControlAdvanced: TPageControl
            Left = 10
            Top = 10
            Width = 464
            Height = 269
            ActivePage = TabSheetAdvancedAutoupdate
            Align = alClient
            TabOrder = 0
            object tabAdvancedGeneral: TTabSheet
              Caption = 'General'
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object cbDebug: TCheckBox
                Left = 10
                Top = 10
                Width = 97
                Height = 17
                Caption = 'Debug'
                TabOrder = 0
              end
            end
            object TabSheetAdvancedAutoupdate: TTabSheet
              Caption = 'Auto Update'
              ImageIndex = 2
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              DesignSize = (
                456
                240)
              object lblAutoupdateURLWarning: TLabel
                Left = 3
                Top = 40
                Width = 419
                Height = 28
                Alignment = taCenter
                Anchors = [akLeft, akTop, akRight]
                Caption = 
                  'Please do not modify the autoupdate URL unless specified by your' +
                  ' program vendor.'
                Font.Charset = ANSI_CHARSET
                Font.Color = clRed
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                WordWrap = True
              end
              object Label12: TLabel
                Left = 8
                Top = 105
                Width = 108
                Height = 14
                Caption = 'Check Interval (Hours)'
              end
              object editAutoUpdateURL: TEdit
                Left = 3
                Top = 15
                Width = 446
                Height = 22
                Anchors = [akLeft, akTop, akRight]
                ImeName = 'Microsoft IME 2010'
                TabOrder = 0
                Text = 'http://'
              end
              object cbAutoUpdateAutomatically: TCheckBox
                Left = 7
                Top = 80
                Width = 222
                Height = 17
                Caption = 'Automatically download and install update.'
                TabOrder = 1
              end
              object editAutoUpdateInterval: TSpinEdit
                Left = 7
                Top = 121
                Width = 133
                Height = 23
                MaxValue = 1000000
                MinValue = 0
                TabOrder = 2
                Value = 0
              end
              object editAutoUpdateApplication: TLabeledEdit
                Left = 149
                Top = 121
                Width = 132
                Height = 22
                EditLabel.Width = 83
                EditLabel.Height = 14
                EditLabel.Caption = 'Application Name'
                Enabled = False
                ImeName = 'Microsoft IME 2010'
                ReadOnly = True
                TabOrder = 3
              end
            end
          end
        end
      end
    end
  end
  object ImageListBackupProfiles: TImageList
    Height = 24
    Width = 24
    Left = 62
    Top = 8
    Bitmap = {
      494C010105000900080018001800FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000600000003000000001002000000000000048
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FDFDFD00FBFBFB00FBFBFB00FBFBFB00FBFBFB00FBFBFB00FAFA
      FA00FAFAFA00FAFAFA00F9F9F900F8F8F800F8F8F800F9F9F900F9F9F900F9F9
      F900F9F9F800FCFCFC00FEFEFE00FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FDFDFD00FDFDFD00FDFDFD00FDFDFD00FDFDFD00FCFC
      FC00F9F9F900F7F7F700F5F5F500F3F3F300F3F3F300F4F4F400F4F4F500F8F8
      F800F7F7F700F9F9F900FEFEFE00FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D5D5D600BFC0C100BDBEBE00BAB9B900B9B8B700B8B7B700B6B6B500B5B5
      B400B1B1B100ACACAC00AAA9A900ABAAAA00ACADAD00ADAEAF00B3B3B400B8B8
      B800DADBDB00F1F1F100F9F9F900FCFCFC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B8B8
      B9002C2B2A001B181500191916001E202000282A2B0032333400353637002F30
      30002E2E2F002E2E2E002627280018191900110F0D0014120E003B3327002621
      19005A5C5C00DADADA00F7F7F700F8F8F8000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F8F8F800BEBEBF003C39
      36006557460082715900635E5600B4BABD00ADB5B90090979C009CA2A600B7BC
      BF00CFD3D500D1D3D400BDC0C2007B7E7D0042392E005344310094836800675E
      4E0001020300B6B6B600F7F7F700F9F9F9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E2E4E5004D4E5000695A
      4900C0A686008D775B0059565200EBEEF000AAAEB0002E373B00393F43009197
      9B00BAC1C400BCC0C100C3C4C6008D8D8D0040382D004F422F008A7961005F57
      4B0001030300ACACAC00F0F0F000F5F5F5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E0E1E300515355008F7C
      6300CBAF8A008C775D00625D5800EFF1F200B8BBBD003840420037404200959A
      9E00AEB3B700999FA300A5A8AB00818181003D362C004A3D2A007B6E5B00564E
      440003030200A2A2A200E4E4E400EEEEEE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E1E3E400555759008A79
      6300C9AE89008E785B0065605A00E9EDEE00BBC0C100434A4C00384044005759
      5A00181919000B0C0C0046484A00757677003C332A00493B2700726758004F47
      3E000302000093949400D5D5D500E2E2E2000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E1E3E400545759008B79
      6300CBAF8B00937D5E005C585200AEB4BA00D5DADD00BBC0C2008F9495000001
      130000077300010A7500000019002E2F31003F382E0048392800706251004A43
      38000303010084858500C1C1C100D4D4D4000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E1E3E400545659008B75
      6400CBAF8C00A98F6B00988367005F5C530078716900968D8100383430000204
      46001A3AEA00001CC700010E8200000019001E1A1300504334007A6B5A00453E
      33000504020076767700AFAFAF00C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E1E3E500545759008A78
      6200CEB18F00B0987900AB957A0097856D00937E660096816800584D3F000001
      2B002E49DD002142F300001AC100010F850000001800352E270077695800453B
      2E00070603006E6E6F009D9D9D00ADADAD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E1E2E400545658008C7E
      6400CFB795008B817800949495009796940099989600959494008C8B8C003836
      350002013100304BDD002142F400001AC200010E830000001800322D27004E43
      3400080706006A6A6B00929292009E9E9E000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E1E2E400545558009081
      6800CAB5940071707C00F3F5F800FAFBFC00F3F5F600DFE3E4009D8B8C004B33
      34004835370001002E002F4ADF002142F100001ABF00010E8500000018002925
      1F00090909006A6B6B008E8E8E00969696000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E1E2E40054555800907C
      6900CEB5920084827E00F7F8FA0000000000E7E8EA0069625B00001A2500004D
      6E0000060900362D260001032F00304BDD002143F4000019BE00010C80000000
      1800050504006C6C6D0090909000969696000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E1E2E400535557009280
      6E00CFB496007B787500F5F6F70000000000F1E7ED001D171200006D9D00009B
      D9000046640022290D00483D4000010231002F4ADE002142F2000019BE00010C
      820000011B0036363600969696009D9D9D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E1E2E300545657009284
      6F00D2B698007C797600F5F6F70000000000EFDDE8005148350000121B00003D
      5A001915000031160D00958587005555550001033100304BDE002144F300000D
      A40000147A00001A310046464600A9A9A9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E1E2E400545557009182
      6F00D4B99A0084827E00F8F9FA0000000000F6F1F600BCB7AB00488334000D32
      04000044640000456500000B0F00C6C6C60053535300010333002432C0000047
      A20000A9EC000089C80000283B00565656000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E1E2E400535558009182
      6D00D6BE9B0083807D00F1F2F500FAFAFD00FAFBFD00EBECEF006E6A6A00002B
      3F00009EDD00009DDC00003A550077777900BDBDBE0038383A0000012E000092
      DE0000B0EC0000ACE9000086C0000A0A0A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E1E2E300545658009283
      6F00DABC990072686D007C84C8007982D100787FCF005F66A400001B2800006C
      9E000092CD00009AD7000070A50000304700000C110000030500000C14000041
      6500009DDB0000BFFC000076A900252525000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DEE0E00047494B00988D
      7900EFDAB50081777B008E9EED008B9EF5008596F3008495F000000101001618
      26000017220000202F0010121D00004E72000083BA00006C9900007BAF001210
      0C00003853000051740000101800868686000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EBECED0077777A00655B
      51008C836B004C4747006B728E00747B94006E7593006A7092006C7391006D74
      9200555A75004E536B00272A37000051770000B7F80000BCFB00007DB0000002
      04001F1D1B0053535300C6C6C600F1F1F1000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F2F2F2007B7C
      7D004F5053005A5B5B0058575300585752005857530059585200595752005858
      53005857530027272400004769000090CE0000B8F80000C1FF0000A1DF000063
      9100000C1100DADADA00F4F4F400F8F8F8000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000ECED
      EE00E0E1E300E7E7E700E4E3E100E3E2E000E3E3E000E4E3E000E4E3E000E3E3
      E000E4E3E100A1A09F0000263800002233000082B80000A2E100002F46000028
      3A0000090D00E9E9E900FBFBFB00FDFDFD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B4B4B4008787870000293C000044630069696900AFAF
      AF00EDEDED00FEFEFE00FEFEFE00FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFEF
      EF00E7E7E700DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00E7E7E700EFEFEF0000000000000000000000000000000000EFEF
      EF00E7E7E700DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00E7E7E700EFEFEF0000000000000000000000000000000000EFEF
      EF00E7E7E700DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00E7E7E700EFEFEF0000000000000000000000000000000000EFEF
      EF00E7E7E700DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00E7E7E700EFEFEF00000000000000000000000000C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004231
      290000000000A5A5A500E7E7E700000000000000000000000000C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004231
      290000000000A5A5A500E7E7E700000000000000000000000000C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004231
      290000000000A5A5A500E7E7E700000000000000000000000000C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004231
      290000000000A5A5A500E7E7E7000000000000000000CECECE00101008006B5A
      4A007B6B5A00635A52009C9CA500B5BDBD00ADB5B500C6C6CE00C6C6CE00CED6
      D600DEDEE700E7E7E700D6DEDE00ADB5B5004A4A420073634A0073634A00D6C6
      9C004239390000000000DEDEDE000000000000000000CECECE00101008006B5A
      4A007B6B5A00635A52009C9CA500B5BDBD00ADB5B500C6C6CE00C6C6CE00CED6
      D600DEDEE700E7E7E700D6DEDE00ADB5B5004A4A420073634A0073634A00D6C6
      9C004239390000000000DEDEDE000000000000000000CECECE00101008006B5A
      4A007B6B5A00635A52009C9CA500B5BDBD00ADB5B500C6C6CE00C6C6CE00CED6
      D600DEDEE700E7E7E700D6DEDE00ADB5B5004A4A420073634A0073634A00D6C6
      9C004239390000000000DEDEDE000000000000000000CECECE00101008006B5A
      4A007B6B5A00635A52009C9CA500B5BDBD00ADB5B500C6C6CE00C6C6CE00CED6
      D600DEDEE700E7E7E700D6DEDE00ADB5B5004A4A420073634A0073634A00D6C6
      9C004239390000000000DEDEDE000000000000000000000000009C8C73009C8C
      6B009C84630039393100CED6D600CED6D600424A4A00424A4A00424A4A00B5BD
      BD00C6CECE00DEE7E700E7EFEF00DEE7E7005252420073634A007B634A00DEBD
      A5004239390000000000DEDEDE000000000000000000000000009C8C73009C8C
      6B009C84630039393100CED6D600CED6D600424A4A00424A4A00424A4A00B5BD
      BD00C6CECE00DEE7E700E7EFEF00DEE7E7005252420073634A007B634A00DEBD
      A5004239390000000000DEDEDE000000000000000000000000009C8C73009C8C
      6B009C84630039393100CED6D600CED6D600424A4A00424A4A00424A4A00B5BD
      BD00C6CECE00DEE7E700E7EFEF00DEE7E7005252420073634A007B634A00DEBD
      A5004239390000000000DEDEDE000000000000000000000000009C8C73009C8C
      6B009C84630039393100CED6D600CED6D600424A4A00424A4A00424A4A00B5BD
      BD00C6CECE00DEE7E700E7EFEF00DEE7E7005252420073634A007B634A00DEBD
      A5004239390000000000DEDEDE00000000000000000000000000DEC6A500A58C
      6B00A58C730042423900DEDEDE00E7E7EF004A4A5200424A5200424A5200BDC6
      C600B5BDBD00C6C6CE00DEDEDE00E7E7E7005A524A007B6B4A00846B4A00DEC6
      A5004242390000000000DEDEDE00000000000000000000000000DEC6A500A58C
      6B00A58C730042423900DEDEDE00E7E7EF004A4A5200424A5200424A5200BDC6
      C600B5BDBD00C6C6CE00DEDEDE00E7E7E7005A524A007B6B4A00846B4A00DEC6
      A5004242390000000000DEDEDE00000000000000000000000000DEC6A500A58C
      6B00A58C730042423900DEDEDE00E7E7EF004A4A5200424A5200424A5200BDC6
      C600B5BDBD00C6C6CE00DEDEDE00E7E7E7005A524A007B6B4A00846B4A00DEC6
      A5004242390000000000DEDEDE00000000000000000000000000DEC6A500A58C
      6B00A58C730042423900DEDEDE00E7E7EF004A4A5200424A5200424A5200BDC6
      C600B5BDBD00C6C6CE00DEDEDE00E7E7E7005A524A007B6B4A00846B4A00DEC6
      A5004242390000000000DEDEDE00000000000000000000000000DEC6A500A58C
      6B00A58C73004A4A4200DEDEDE00EFEFEF005A636B004A5252004A525200C6CE
      CE00B5BDC600B5BDBD00BDC6CE00D6DEDE005A524A007B6B4A00846B5200DECE
      BD004A42310000000000DEDEDE00000000000000000000000000DEC6A500A58C
      6B00A58C73004A4A4200DEDEDE00EFEFEF005A636B004A5252004A525200C6CE
      CE00B5BDC600B5BDBD00BDC6CE00D6DEDE005A524A007B6B4A00846B5200DECE
      BD004A42310000000000DEDEDE00000000000000000000000000DEC6A500A58C
      6B00A58C73004A4A4200DEDEDE00EFEFEF005A636B004A5252004A525200C6CE
      CE00B5BDC600B5BDBD00BDC6CE00D6DEDE005A524A007B6B4A00846B5200DECE
      BD004A42310000000000DEDEDE00000000000000000000000000DEC6A500A58C
      6B00A58C73004A4A4200DEDEDE00EFEFEF005A636B004A5252004A525200C6CE
      CE00B5BDC600B5BDBD00BDC6CE00D6DEDE005A524A007B6B4A00846B5200DECE
      BD004A42310000000000DEDEDE00000000000000000000000000DEC6AD00A58C
      6B00A58C6B004A4A4200D6D6DE00DEE7E7005A636B004A5252004A525200D6D6
      D600BDC6C600000000000000000000000000000000000000000000000000DECE
      B5004A42310000000000DEDEDE00000000000000000000000000DEC6AD00A58C
      6B00A58C6B004A4A4200D6D6DE00DEE7E7005A636B004A5252004A525200D6D6
      D600BDC6C600B5BDBD00ADB5B500C6CECE00524A42007B6B4A00846B5200DECE
      B5004A42310000000000DEDEDE00000000000000000000000000DEC6AD00A58C
      6B00A58C6B004A4A4200D6D6DE00DEE7E7005A636B004A5252004A525200D6D6
      D600BDC6C600B5BDBD00ADB5B500C6CECE00524A42007B6B4A00846B5200DECE
      B5004A42310000000000DEDEDE00000000000000000000000000DEC6AD00A58C
      6B00A58C6B004A4A4200D6D6DE00DEE7E7005A636B004A5252004A525200D6D6
      D600BDC6C600B5BDBD00ADB5B500C6CECE00524A42007B6B4A00846B5200DECE
      B5004A42310000000000DEDEDE00000000000000000000000000DEC6AD00AD94
      7300A58C6B005A524A008C949400DEDEDE00DEDEE700E7E7EF00E7E7EF00E7E7
      E700DEDEDE00000000000000000000000000000000000000000000000000DEC6
      AD004A4A310000000000DEDEDE00000000000000000000000000DEC6AD00AD94
      7300A58C6B005A524A008C949400DEDEDE00DEDEE700E7E7EF00E7E7EF00E7E7
      E700DEDEDE00C6CECE00BDC6C6008C949C006B6352007B634A008C735200DEC6
      AD004A4A310000000000DEDEDE00000000000000000000000000DEC6AD00AD94
      7300A58C6B005A524A008C949400DEDEDE00DEDEE700E7E7EF00E7E7EF00E7E7
      E700DEDEDE00C6CECE00BDC6C6008C949C006B6352007B634A008C735200DEC6
      AD004A4A310000000000DEDEDE00000000000000000000000000DEC6AD00AD94
      7300A58C6B005A524A008C949400DEDEDE00DEDEE700E7E7EF00E7E7EF00E7E7
      E700DEDEDE00C6CECE00BDC6C6008C949C006B6352007B634A008C735200DEC6
      AD004A4A310000000000DEDEDE00000000000000000000000000DEC6AD00AD94
      7300AD946B00AD9473004A4A4200524A4200635A52007B6B6300736B6300736B
      5A006B635A00000000000000000031FF310031FF31000000000000000000CEB5
      A500524A390000000000DEDEDE00000000000000000000000000DEC6AD00AD94
      7300AD946B00AD9473004A4A4200524A4200635A52007B6B6300736B6300736B
      5A006B635A006B635A006B635A00635A5200635239004A423900B5947B00CEB5
      A500524A390000000000DEDEDE00000000000000000000000000DEC6AD00AD94
      7300AD946B00AD9473004A4A4200524A4200635A52007B6B6300736B6300736B
      5A006B635A006B635A006B635A00635A5200635239004A423900B5947B00CEB5
      A500524A390000000000DEDEDE00000000000000000000000000DEC6AD00AD94
      7300AD946B00AD9473004A4A4200524A4200635A52007B6B6300736B6300736B
      5A006B635A006B635A006B635A00635A5200635239004A423900B5947B00CEB5
      A500DEDEDE00DEDEDE00DEDEDE00000000000000000000000000DEC6AD00AD94
      7300B59C8400B59C8400B5A58400B59C8400B59C7B00B59C7B00B59C8400B594
      7B00B5A58400000000000000000031FF310031FF31000000000000000000BDA5
      8C005A4A390000000000DEDEDE00000000000000000000000000DEC6AD00AD94
      7300B59C8400B59C8400B5A58400B59C8400B59C7B00B59C7B00B59C8400B594
      7B00B5A58400B5A58400B5A58400BDA58400B59C8400BDA58C00B59C8400BDA5
      8C005A4A390000000000DEDEDE00000000000000000000000000DEC6AD00AD94
      7300B59C8400B59C8400B5A58400B59C8400B59C7B00B59C7B00B59C8400B594
      7B00B5A58400B5A58400B5A58400BDA58400B59C8400BDA58C00B59C8400BDA5
      8C005A4A390000000000DEDEDE00000000000000000000000000DEC6AD00AD94
      7300B59C8400B59C8400B5A58400B59C8400B59C7B0000000000000000000000
      0000DEDEDE00B5A58400B5A58400BDA58400B59C8400BDA58C00B59C8400DEDE
      DE00000000000000000000000000000000000000000000000000E7CEAD00B59C
      7B009C8C7B007B7B7B007373730073737300737373007373730073737300736B
      6B006B6B6B00000000000000000031FF310031FF31000000000000000000B5A5
      84005A52390000000000DEDEDE00000000000000000000000000E7CEAD00B59C
      7B009C8C7B007B7B7B007373730073737300737373007373730073737300736B
      6B006B6B6B00737373007373730073737300737373006B6B6B007B736B00B5A5
      84005A52390000000000DEDEDE00000000000000000000000000E7CEAD00B59C
      7B009C8C7B007B7B7B0073737300737373007373730073737300737373000000
      000000000000000000000000000000000000737373006B6B6B007B736B00B5A5
      84005A52390000000000DEDEDE00000000000000000000000000E7CEAD00B59C
      7B009C8C7B007B7B7B00737373007373730073737300000000000000CE000000
      CE0000000000DEDEDE007373730073737300737373006B6B6B007B736B000000
      00000000CE000000CE0000000000000000000000000000000000E7CEAD00B5A5
      84005A5A730000000000000000000000000000000000DEDEDE00CEBDBD00CEAD
      AD00D6BDC600000000000000000031FF310031FF31000000000000000000B59C
      8400635A520000000000DEDEDE00000000000000000000000000E7CEAD00B5A5
      84005A5A730000000000000000000000000000000000DEDEDE00CEBDBD00CEAD
      AD00D6BDC600DEDEDE000000000000000000000000000000000073737300B59C
      8400635A520000000000DEDEDE00000000000000000000000000E7CEAD00B5A5
      84005A5A730000000000000000000000000000000000DEDEDE00CEBDBD000000
      000000000000000000000000000000000000000000000000000073737300B59C
      8400635A520000000000DEDEDE00000000000000000000000000E7CEAD00B5A5
      84005A5A730000000000000000000000000000000000000000000000CE000000
      CE000000CE0000000000DEDEDE00000000000000000000000000000000000000
      CE000000CE000000CE0000000000000000000000000000000000E7CEAD00B59C
      7B00737373000000000000000000000000000000000000000000000000000000
      000000000000000000000000000031FF310031FF310000000000000000000000
      0000000000000000000000000000000000000000000000000000E7CEAD00B59C
      7B0073737300000000000000000000000000B5B5B500B5AD9C00844231007321
      08007B4A3100C69C9C00B5B5B50000000000000000000000000073737300BDA5
      84006B63520000000000DEDEDE00000000000000000000000000E7CEAD00B59C
      7B0073737300000000000000000000000000B5B5B500B5AD9C00844231000000
      000000000000000000000000000000000000000000000000000073737300BDA5
      84006B63520000000000DEDEDE00000000000000000000000000E7CEAD00B59C
      7B0073737300000000000000000000000000B5B5B500B5AD9C00000000000000
      CE000000CE000000CE0000000000DEDEDE0000000000000000000000CE000000
      CE000000CE0000000000DEDEDE00000000000000000000000000E7CEB500B5A5
      7B00737373000000000000000000000000000000000000000000000000000000
      000000000000000000000000000031FF310031FF310000000000000000000000
      0000000000000000000000000000000000000000000000000000E7CEB500B5A5
      7B0073737300000000000000000000000000C6B5B5007352290042310000395A
      0000008C00007B5A3900C6B5BD0000000000000000000000000073737300BDA5
      84006B5A420000000000DEDEDE00000000000000000000000000E7CEB500B5A5
      7B0073737300000000000000000000000000C6B5B50073522900423100000000
      000000000000000000008484840084848400000000000000000000000000BDA5
      84006B5A420000000000DEDEDE00000000000000000000000000E7CEB500B5A5
      7B0073737300000000000000000000000000C6B5B50073522900423100000000
      00000000CE000000CE000000CE0000000000000000000000CE000000CE000000
      CE000000000000000000DEDEDE00000000000000000000000000E7D6B500BD9C
      8400636363000000000000000000000000000000000031FF310031FF310031FF
      310031FF310031FF310031FF310031FF310031FF310031FF310031FF310031FF
      310031FF310031FF310031FF3100000000000000000000000000E7D6B500BD9C
      8400636363000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7D6B500BD9C
      840063636300000000000000000000000000C6A5A50052420800523900000000
      000000000000000000008484840000FFFF0000FFFF0000000000000000000000
      0000735A4A0000000000DEDEDE00000000000000000000000000E7D6B500BD9C
      840063636300000000000000000000000000C6A5A50052420800523900006B31
      0800000000000000CE000000CE000000CE000000CE000000CE000000CE000000
      0000735A4A0000000000DEDEDE00000000000000000000000000E7D6B500BDA5
      8400737373000000000000000000000000000000000031FF310031FF310031FF
      310031FF310031FF310031FF310031FF310031FF310031FF310031FF310031FF
      310031FF310031FF310031FF3100000000000000000000000000E7D6B500BDA5
      8400737373000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7D6B500BDA5
      840073737300000000000000000000000000BDA5AD005A732900009400002973
      000000000000000000000000000000FFFF0000FFFF0000FFFF00000000000000
      00000000000000000000DEDEDE00000000000000000000000000E7D6B500BDA5
      840073737300000000000000000000000000BDA5AD005A732900009400002973
      000052210000000000000000CE000000CE000000CE000000CE0000000000BDA5
      8C0073634A0000000000DEDEDE00000000000000000000000000E7D6B500BDA5
      8400737373000000000000000000000000000000000000000000000000000000
      000000000000000000000000000031FF310031FF310000000000000000000000
      0000000000000000000000000000000000000000000000000000E7D6B500BDA5
      84007373730000000000000000000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000E7D6B500BDA5
      840073737300000000000000000000000000DEDEDE00ADAD94004A8C3100316B
      08006B63310000000000000000000000000000FFFF0000FFFF0000FFFF000000
      00000000000000000000DEDEDE00000000000000000000000000E7D6B500BDA5
      840073737300000000000000000000000000DEDEDE00ADAD94004A8C3100316B
      0800DEDEDE00000000000000CE000000CE000000CE000000CE0000000000DEDE
      DE007B6B520000000000DEDEDE00000000000000000000000000E7D6B500BDAD
      8400737373000000000000000000000000000000000000000000000000000000
      000000000000000000000000000031FF310031FF310000000000000000000000
      0000000000000000000000000000000000000000000000000000E7D6B500BDAD
      84007373730000000000000000000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000E7D6B500BDAD
      84007373730000000000000000000000000000000000DEDEDE00C6B5BD00C6A5
      A500C6B5BD00DEDEDE0000000000000000000000000000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000E7D6B500BDAD
      84007373730000000000000000000000000000000000DEDEDE00C6B5BD00DEDE
      DE00000000000000CE000000CE000000CE000000CE000000CE000000CE000000
      0000DEDEDE0000000000DEDEDE00000000000000000000000000E7D6BD00C6A5
      8C0073636B007B84C600737BCE00737BCE00737BCE00737BCE00737BCE00636B
      BD00737BCE00000000000000000031FF310031FF31000000000000000000B59C
      84008473520000000000DEDEDE00000000000000000000000000E7D6BD00C6A5
      8C0073636B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7D6BD00C6A5
      8C0073636B007B84C600737BCE00737BCE00737BCE00737BCE00737BCE00636B
      BD00737BCE00636BBD00737BCE0000000000000000000000000000FFFF0000FF
      FF0000FFFF000000000000000000000000000000000000000000E7D6BD00C6A5
      8C0073636B007B84C600737BCE00737BCE00737BCE00737BCE00DEDEDE000000
      00000000CE000000CE000000CE0000000000000000000000CE000000CE000000
      CE0000000000DEDEDE00DEDEDE00000000000000000000000000E7D6BD00C6AD
      8C006B6363007B8CDE006B84DE006B84DE006B7BDE007384DE006B7BDE007384
      D6006B7BD600000000000000000031FF310031FF31000000000000000000B5A5
      84008473520000000000E7E7E700000000000000000000000000E7D6BD00C6AD
      8C006B6363000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7D6BD00C6AD
      8C006B6363007B8CDE006B84DE006B84DE006B7BDE007384DE006B7BDE007384
      D6006B7BD6006373CE006373CE006B73CE0000000000000000000000000000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000E7D6BD00C6AD
      8C006B6363007B8CDE006B84DE006B84DE006B7BDE00DEDEDE00000000000000
      CE000000CE000000CE00000000006B73CE005A6BC600000000000000CE000000
      CE000000CE0000000000DEDEDE00000000000000000000000000F7D6C600E7CE
      AD007B737300BDC6EF00BDC6EF00BDC6EF00B5BDEF00B5BDEF00B5BDEF00B5BD
      EF00ADB5E700000000000000000031FF310031FF31000000000000000000E7CE
      B500D6BDA50000000000EFEFEF00000000000000000000000000F7D6C600E7CE
      AD007B737300BDC6EF00BDC6EF00BDC6EF00B5BDEF00B5BDEF00B5BDEF00B5BD
      EF00ADB5E700ADB5E700ADB5E700ADB5E700B5B5E700BDBDE70073737300E7CE
      B500D6BDA50000000000EFEFEF00000000000000000000000000F7D6C600E7CE
      AD007B737300BDC6EF00BDC6EF00BDC6EF00B5BDEF00B5BDEF00B5BDEF00B5BD
      EF00ADB5E700ADB5E700ADB5E700ADB5E700B5B5E70000000000000000000000
      000000FFFF00848484006300FF00000000000000000000000000F7D6C600E7CE
      AD007B737300BDC6EF00BDC6EF00BDC6EF00B5BDEF00000000000000CE000000
      CE000000CE0000000000ADB5E700ADB5E700B5B5E700BDBDE700000000000000
      CE000000CE000000CE00000000000000000000000000ADADAD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000031FF310031FF310000000000000000000000
      000000000000A5A5A500000000000000000000000000ADADAD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A5A5A500000000000000000000000000ADADAD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006300FF006300FF000000000000000000ADADAD00000000000000
      00000000000000000000000000000000000000000000000000000000CE000000
      CE00000000000000000000000000000000000000000000000000000000000000
      00000000CE000000CE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000060000000300000000100010000000000400200000000000000000000
      000000000000000000000000FFFFFF00F80000000000000000000000FC000000
      0000000000000000F00000000000000000000000E00000000000000000000000
      8000000000000000000000008000000000000000000000008000000000000000
      0000000080000000000000000000000080000000000000000000000080000000
      0000000000000000800000000000000000000000800000000000000000000000
      8000000000000000000000008100000000000000000000008100000000000000
      0000000081000000000000000000000081000000000000000000000080000000
      0000000000000000800000000000000000000000800000000000000000000000
      800000000000000000000000C00000000000000000000000E000000000000000
      00000000FFFC00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFE00001E0
      0001E00001E00001C00001C00001C00001C00001800001800001800001800001
      8000018000018000018000018000018000018000018000018000018000018000
      0180000180000180000180000180000180000180000180000180000180000180
      0001800001800001800001800001800001800001800001800001800001800001
      8780018783C18780418781C18600008701C18700018700818600008701C18700
      0187000186000080000087000187000186000080000087000187000186000080
      0000870001870001860000800000878001878001800001800000800000800001
      8000018000008000008000018000018000018000008000018000038000038000
      00800001FFF81FFFFFFFFFFFE0FF8FF100000000000000000000000000000000
      000000000000}
  end
  object ActionListOptions: TActionList
    Images = frmBandS.ImageListCommon
    Left = 36
    Top = 8
    object ActionRefreshLog: TAction
      Category = 'Log'
      Caption = 'Refresh'
      ImageIndex = 255
      OnExecute = ActionRefreshLogExecute
    end
    object ActionOpenLogInExplorer: TAction
      Category = 'Log'
      Caption = 'Browse to Log'
      ImageIndex = 142
      OnExecute = ActionOpenLogInExplorerExecute
    end
    object ActionBackupProfileWizard: TAction
      Category = 'Backup Profiles'
      Caption = 'Profile Wizard'
      OnExecute = ActionBackupProfileWizardExecute
    end
  end
end
