object frmBackupProfiles: TfrmBackupProfiles
  Left = 213
  Top = 304
  BorderStyle = bsDialog
  Caption = 'Backup Profile'
  ClientHeight = 503
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMode = pmAuto
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlbottom: TPanel
    Left = 0
    Top = 470
    Width = 505
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnCancel: TBitBtn
      AlignWithMargins = True
      Left = 427
      Top = 3
      Width = 75
      Height = 27
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 2
      ExplicitLeft = 425
      ExplicitTop = 6
      ExplicitHeight = 25
    end
    object btnOk: TBitBtn
      AlignWithMargins = True
      Left = 346
      Top = 3
      Width = 75
      Height = 27
      Align = alRight
      Caption = 'Ok'
      Default = True
      TabOrder = 1
      OnClick = btnOkClick
      ExplicitLeft = 344
      ExplicitTop = 4
      ExplicitHeight = 25
    end
    object cbSaveAsDefaults: TCheckBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 61
      Height = 27
      Hint = 'Saves the current settings as the default for each new profile.'
      Align = alLeft
      Caption = 'Default'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      ExplicitLeft = 8
      ExplicitTop = 12
      ExplicitHeight = 17
    end
  end
  object PageControlMain: TPageControl
    Left = 0
    Top = 0
    Width = 505
    Height = 470
    ActivePage = tabFilesandFolders
    Align = alClient
    Images = frmBandS.ImageListCommon
    MultiLine = True
    TabOrder = 0
    OnChange = PageControlMainChange
    ExplicitHeight = 467
    object tabGeneral: TTabSheet
      Caption = 'General'
      ImageIndex = 349
      ExplicitHeight = 434
      object GroupBoxDetails: TGroupBox
        Left = 0
        Top = 0
        Width = 497
        Height = 189
        Align = alTop
        Caption = 'Profile Information'
        TabOrder = 0
        DesignSize = (
          497
          189)
        object Label1: TLabel
          Left = 8
          Top = 40
          Width = 31
          Height = 13
          Caption = 'Name:'
        end
        object Label2: TLabel
          Left = 8
          Top = 80
          Width = 53
          Height = 13
          Caption = 'Description'
        end
        object editProfileName: TEdit
          Left = 8
          Top = 56
          Width = 481
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
        end
        object cbProfileEnabled: TCheckBox
          Left = 8
          Top = 17
          Width = 61
          Height = 17
          Anchors = [akTop, akRight]
          Caption = 'Enabled'
          TabOrder = 1
        end
        object memoDescription: TMemo
          Left = 8
          Top = 96
          Width = 480
          Height = 85
          Anchors = [akLeft, akTop, akRight, akBottom]
          ScrollBars = ssVertical
          TabOrder = 3
        end
        object btnLoadDefaults: TBitBtn
          Left = 415
          Top = 12
          Width = 75
          Height = 25
          Action = ActionLoadDefaults
          Anchors = [akTop, akRight]
          Caption = 'Load Defaults'
          TabOrder = 0
        end
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 189
        Width = 497
        Height = 248
        Align = alClient
        Caption = 'Backup Alerts'
        TabOrder = 1
        ExplicitHeight = 245
        object pblLastBackup: TPanel
          Left = 249
          Top = 15
          Width = 246
          Height = 231
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          ExplicitHeight = 228
          DesignSize = (
            246
            231)
          object cbBackupAlertEnabled: TCheckBox
            Left = 8
            Top = 4
            Width = 65
            Height = 17
            Caption = 'Enabled'
            TabOrder = 0
          end
          object GroupBox4: TGroupBox
            Left = 8
            Top = 28
            Width = 233
            Height = 203
            Anchors = [akLeft, akTop, akRight, akBottom]
            TabOrder = 1
            ExplicitHeight = 200
            DesignSize = (
              233
              203)
            object lblBackupAlertDays: TLabel
              Left = 8
              Top = 12
              Width = 213
              Height = 29
              Anchors = [akLeft, akTop, akRight]
              AutoSize = False
              Caption = 
                'Alert if successful backup has not been performed in the last %d' +
                ' day(s)'
              WordWrap = True
              ExplicitWidth = 241
            end
            object TrackBarBackupAlertDays: TTrackBar
              Left = 8
              Top = 48
              Width = 217
              Height = 25
              Anchors = [akLeft, akTop, akRight]
              Max = 30
              Min = 1
              Position = 1
              TabOrder = 0
              OnChange = TrackBarBackupAlertDaysChange
            end
            object cbBackupAlertEmail: TCheckBox
              Left = 8
              Top = 92
              Width = 105
              Height = 17
              Caption = 'Send Alert E-Mail'
              TabOrder = 2
            end
            object btnBackupAlertEmail: TBitBtn
              Left = 119
              Top = 88
              Width = 75
              Height = 25
              Action = ActionAlertEmailDetails
              Caption = 'Details...'
              Glyph.Data = {
                76060000424D7606000000000000360000002800000014000000140000000100
                2000000000004006000000000000000000000000000000000000FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF0018DE180031B5310031B5310031B5310031B5310031B5310031B5310031B5
                310031B5310031B5310031B5310031B5310031B5310031B5310031B5310031B5
                310031B5310010E71000FF00FF00005A00000010000000000800080808000000
                0800080808000000080008080800000008000808080000000800080808000000
                08000808080000000800080808000000080008080800394A3900FF00FF000042
                000021212100004A520000526300106B730021737B0029737B0029737B002973
                7B0029737B0029737B0029737B0029737B00186B7B00005A630000526300214A
                52000000080039393900FF00FF000042000031636B006B7B7B0021737B000094
                AD0018A5BD0039B5BD0042BDC60031ADBD0021ADBD0042B5C60042BDC60029AD
                BD00089CB500007B9400527373006B9CA5000818180039393900FF00FF000042
                000031636B006BADB5005A8C8C0000849C000094AD00089CB500108CA500087B
                840008737B0010849400088CA500089CB500008CA5005273730063A5AD006BBD
                C6000818180039393900FF00FF000042000031636B006BCED6006BADB5003173
                840008849C000084940000737B00006B7B00006B7B00006B7B00007384000084
                9C00217B8C006B9CA5006BBDC6006BCED6000810180039393900FF00FF000042
                000031636B0052BDC6005AC6CE00319CA50008737B00004A4A00319CA50039AD
                BD0039B5BD0039ADBD00186B7B00005A6300188C94006BCED60052BDC6005AC6
                CE000818180039393900FF00FF0000420000295A63004ABDC60042B5C600088C
                A50000525A0010636B006BC6CE0073CED6005AC6CE0063C6CE0042A5AD00004A
                4A0008737B0039B5C60042B5C6004ABDC6000810180039393900FF00FF000042
                0000215A630021ADBD00088CA5000031310031949C007BCEDE0094D6E7008CD6
                DE008CD6DE008CD6DE007BCEDE004ABDC60018636B00007B9400189CB50039B5
                BD000810180039393900FF00FF000042000010526300088CA500005A6B003194
                9C007BCEDE00A5DEEF00ADDEF70094D6E70094D6E7008CD6DE008CD6DE0063C6
                CE0042A5AD0000424A0000738400189CAD000010180039393900FF00FF000042
                0000084A5200005A6300106B73007BCEDE00A5DEF700B5E7FF00B5E7FF00A5DE
                EF008CD6DE008CD6DE0094D6E7007BCEDE006BC6CE0021737B00005A63000873
                7B000010100039393900FF00FF000042000000181800A5C6D600C6E7F700D6EF
                FF00CEEFFF00C6E7F700ADE7F700B5E7FF00ADE7F700ADDEF7009CDEE7008CD6
                DE008CD6DE0063C6CE004AADBD00186B7B000000080039393900FF00FF000042
                0000525A5A00E7F7F700EFFFFF00D6EFFF00D6F7FF00CEEFFF00B5E7FF00B5E7
                FF00B5E7FF00B5E7FF00ADDEF700A5DEEF0094D6E70084D6DE0063C6CE0042A5
                AD000010100039393900FF00FF00004200000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000009C0000FF00FF0000CE
                000000BD000000BD000000BD000000BD000000BD000000BD000000BD000000BD
                000000BD000000BD000000BD000000BD000000BD000000BD000000BD000000BD
                000000BD000000E70000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
              TabOrder = 1
            end
            object cbCustomSMTPSettings: TCheckBox
              Left = 7
              Top = 127
              Width = 134
              Height = 17
              Caption = 'Custom SMTP Settings'
              TabOrder = 3
            end
            object BitBtn1: TBitBtn
              Left = 119
              Top = 150
              Width = 75
              Height = 25
              Action = ActionCustomSMTPDetails
              Caption = 'Details...'
              Glyph.Data = {
                76060000424D7606000000000000360000002800000014000000140000000100
                2000000000004006000000000000000000000000000000000000FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00ADADAD006363
                6300636363006363630063636300636363006363630063636300636363006363
                6300636363006363630063636300636363006363630063636300636363006363
                630063636300ADADAD0063636300000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000063636300636363000000
                00006B6B6B00007B94000094AD000000000000000000003131004ABDC6004ABD
                C6004ABDC6004ABDC6004ABDC6004ABDC60021ADBD000094AD00007B94006B6B
                6B00000000006363630039393900000000000063630000636300006363000000
                0000DE940000000000000031310021ADBD0021ADBD004ABDC6004ABDC60021AD
                BD000094AD00007B94006B6B6B006BCED6000000000063636300000000000000
                000000000000000000000000000000000000FFBD4A00DE940000000000000031
                310000636300007B94000094AD000094AD00007B94006B6B6B006BCED6006BCE
                D600000000006363630000000000DE940000DE940000DE940000DE940000DE94
                0000FFBD4A00FFBD4A00DE94000000000000004A4A000063630000636300007B
                94006B6B6B006BCED6006BCED6006BCED600000000006363630000000000FFD6
                8C00FFBD4A00FFBD4A00FFBD4A00FFBD4A00FFBD4A00FFBD4A00FFBD4A000000
                0000004A4A004ABDC600003131000063630021ADBD006BCED6004ABDC6006BCE
                D600000000006363630000000000000000000000000000000000000000000000
                0000FFBD4A00FFBD4A0000000000003131006BCED6006BCED6004ABDC6000031
                3100007B940021ADBD004ABDC6004ABDC6000000000063636300393939000000
                000000636300006363000063630000000000FFBD4A0000000000003131008CD6
                DE008CD6DE008CD6DE006BCED6004ABDC60000313100007B940021ADBD004ABD
                C6000000000063636300636363000000000021ADBD00007B9400003131000000
                00000000000000313100B5E7FF008CD6DE008CD6DE008CD6DE008CD6DE006BCE
                D6004ABDC60000313100007B940021ADBD000000000063636300636363000000
                0000007B9400003131004ABDC6000063630000636300B5E7FF00B5E7FF00B5E7
                FF008CD6DE008CD6DE008CD6DE008CD6DE006BCED6004ABDC60000313100007B
                94000000000063636300636363000000000000313100D6F7FF00D6F7FF00D6F7
                FF00D6F7FF00B5E7FF00B5E7FF00B5E7FF00B5E7FF00B5E7FF008CD6DE008CD6
                DE008CD6DE006BCED6004ABDC600003131000000000063636300636363000000
                0000FFFFFF00FFFFFF00FFFFFF00D6F7FF00D6F7FF00D6F7FF00B5E7FF00B5E7
                FF00B5E7FF00B5E7FF00B5E7FF00B5E7FF008CD6DE008CD6DE006BCED6004ABD
                C600000000006363630063636300000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000063636300ADADAD006363
                6300636363006363630063636300636363006363630063636300636363006363
                6300636363006363630063636300636363006363630063636300636363006363
                630063636300ADADAD00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
              TabOrder = 4
            end
          end
        end
        object Panel1: TPanel
          Left = 2
          Top = 15
          Width = 247
          Height = 231
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel1'
          TabOrder = 0
          ExplicitHeight = 228
          object lblDaysOverDue: TLabel
            Left = 0
            Top = 0
            Width = 247
            Height = 13
            Align = alTop
            Alignment = taCenter
            Caption = 'No backup details.'
            ExplicitWidth = 89
          end
          object CalendarBackupAlert: TJvMonthCalendar
            Left = 0
            Top = 13
            Width = 247
            Height = 218
            Align = alClient
            Date = 0.043387523146520830
            TabOrder = 0
            WeekNumbers = True
            ExplicitHeight = 215
          end
        end
      end
    end
    object tabFilesandFolders: TTabSheet
      Caption = 'Files and Folders'
      ImageIndex = 272
      ExplicitHeight = 434
      object PageControlFilesAndFolders: TPageControl
        Left = 0
        Top = 0
        Width = 497
        Height = 437
        ActivePage = tabSourceFiles
        Align = alClient
        TabOrder = 0
        OnChange = PageControlFilesAndFoldersChange
        ExplicitHeight = 434
        object tabSourceFiles: TTabSheet
          Caption = 'Source Files / Folders'
          ExplicitHeight = 406
          object GroupBox9: TGroupBox
            Left = 0
            Top = 0
            Width = 489
            Height = 409
            Align = alClient
            Caption = 'Source Files / Folders'
            TabOrder = 0
            ExplicitHeight = 406
            DesignSize = (
              489
              409)
            object ToolBar3: TToolBar
              Left = 8
              Top = 15
              Width = 481
              Height = 26
              Align = alNone
              Anchors = [akLeft, akTop, akRight]
              ButtonHeight = 26
              ButtonWidth = 27
              Caption = 'ToolBarFilesFolders'
              Images = frmBandS.ImageListCommon
              TabOrder = 0
              object ToolButton4: TToolButton
                Left = 0
                Top = 0
                Action = ActionAddFileSourceItem
                ParentShowHint = False
                ShowHint = True
              end
              object ToolButton8: TToolButton
                Left = 27
                Top = 0
                Action = ActionAddFolderSourceItem
                ParentShowHint = False
                ShowHint = True
              end
              object ToolButton9: TToolButton
                Left = 54
                Top = 0
                Width = 8
                Caption = 'ToolButton5'
                ImageIndex = 4
                Style = tbsSeparator
              end
              object ToolButton11: TToolButton
                Left = 62
                Top = 0
                Action = ActionRemoveSourceItem
                ParentShowHint = False
                ShowHint = True
              end
              object ToolButton12: TToolButton
                Left = 89
                Top = 0
                Width = 8
                Caption = 'ToolButton6'
                ImageIndex = 4
                Style = tbsSeparator
              end
              object ToolButton13: TToolButton
                Left = 97
                Top = 0
                Action = ActionRemoveAllSourceItems
                ParentShowHint = False
                ShowHint = True
              end
            end
            object ListViewFileFolders: TListView
              Left = 3
              Top = 47
              Width = 479
              Height = 352
              Anchors = [akLeft, akTop, akRight, akBottom]
              Columns = <
                item
                  Caption = 'Directory'
                  Width = 250
                end
                item
                  Alignment = taCenter
                  AutoSize = True
                  Caption = 'Filename'
                end
                item
                  AutoSize = True
                  Caption = 'Recusive'
                end>
              GridLines = True
              ReadOnly = True
              RowSelect = True
              TabOrder = 1
              ViewStyle = vsReport
              ExplicitHeight = 349
            end
          end
        end
        object tabExclusionFiles: TTabSheet
          Caption = 'Exclusion Files / Folders'
          ImageIndex = 1
          ExplicitHeight = 406
          object GroupBox2: TGroupBox
            Left = 0
            Top = 0
            Width = 489
            Height = 409
            Align = alClient
            Caption = 'Exclusion Files / Folders'
            TabOrder = 0
            ExplicitHeight = 406
            DesignSize = (
              489
              409)
            object ToolBar: TToolBar
              Left = 8
              Top = 15
              Width = 481
              Height = 26
              Align = alNone
              Anchors = [akLeft, akTop, akRight]
              ButtonHeight = 26
              ButtonWidth = 27
              Caption = 'ToolBarFilesFolders'
              Images = frmBandS.ImageListCommon
              TabOrder = 0
              object btnAddFile: TToolButton
                Left = 0
                Top = 0
                Action = ActionAddFileExclusionItem
                ParentShowHint = False
                ShowHint = True
              end
              object btnAddFolder: TToolButton
                Left = 27
                Top = 0
                Action = ActionAddFolderExclusionItem
                ParentShowHint = False
                ShowHint = True
              end
              object ToolButton5: TToolButton
                Left = 54
                Top = 0
                Width = 8
                Caption = 'ToolButton5'
                ImageIndex = 4
                Style = tbsSeparator
              end
              object btnRemoveFileFolder: TToolButton
                Left = 62
                Top = 0
                Action = ActionRemoveExclusionItem
                ParentShowHint = False
                ShowHint = True
              end
              object ToolButton6: TToolButton
                Left = 89
                Top = 0
                Width = 8
                Caption = 'ToolButton6'
                ImageIndex = 4
                Style = tbsSeparator
              end
              object btnRemoteAllFileFolder: TToolButton
                Left = 97
                Top = 0
                Action = ActionRemoveAllExclusionItems
                ParentShowHint = False
                ShowHint = True
              end
            end
            object ListViewExclusionFileFolders: TListView
              Left = 3
              Top = 47
              Width = 479
              Height = 347
              Anchors = [akLeft, akTop, akRight, akBottom]
              Columns = <
                item
                  Caption = 'Directory'
                  Width = 250
                end
                item
                  Alignment = taCenter
                  AutoSize = True
                  Caption = 'Filename'
                end
                item
                  AutoSize = True
                  Caption = 'Recusive'
                end>
              GridLines = True
              ReadOnly = True
              RowSelect = True
              TabOrder = 1
              ViewStyle = vsReport
              ExplicitHeight = 344
            end
          end
        end
        object tabDestination: TTabSheet
          Caption = 'Destination Settings'
          ImageIndex = 2
          ExplicitHeight = 406
          object GroupBox3: TGroupBox
            Left = 0
            Top = 0
            Width = 489
            Height = 409
            Align = alClient
            Caption = 'Destination'
            TabOrder = 0
            ExplicitHeight = 406
            DesignSize = (
              489
              409)
            object Label3: TLabel
              Left = 12
              Top = 76
              Width = 98
              Height = 13
              Caption = 'Destination Filename'
            end
            object Label4: TLabel
              Left = 12
              Top = 120
              Width = 46
              Height = 13
              Caption = 'Password'
            end
            object Label5: TLabel
              Left = 346
              Top = 119
              Width = 70
              Height = 13
              Caption = 'Spanning (MB)'
            end
            object Label6: TLabel
              Left = 151
              Top = 120
              Width = 84
              Height = 13
              Caption = 'Confirm Password'
            end
            object lblCompressionLevel: TLabel
              Left = 12
              Top = 166
              Width = 92
              Height = 13
              Caption = 'Compression Level:'
            end
            object Label7: TLabel
              Left = 12
              Top = 17
              Width = 42
              Height = 13
              Caption = 'Zip Type'
            end
            object editZIPFileName: TJvFilenameEdit
              Left = 12
              Top = 92
              Width = 467
              Height = 21
              OnBeforeDialog = editZIPFileNameBeforeDialog
              AddQuotes = False
              DialogKind = dkSave
              DefaultExt = '.7z'
              Filter = '7z Files|*.7z|Zip Files|*.zip|BKF Files|*.bkf|All Files|*.*'
              DialogOptions = [ofOverwritePrompt, ofHideReadOnly]
              DialogTitle = 'Backup Destination'
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 2
              Text = ''
            end
            object editPassword: TEdit
              Left = 12
              Top = 136
              Width = 133
              Height = 20
              Font.Charset = SYMBOL_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Wingdings'
              Font.Style = []
              ParentFont = False
              PasswordChar = 'l'
              TabOrder = 4
            end
            object editSpanning: TSpinEdit
              Left = 346
              Top = 135
              Width = 133
              Height = 22
              MaxValue = 1000000
              MinValue = 0
              TabOrder = 3
              Value = 0
            end
            object editConfirmPassword: TEdit
              Left = 151
              Top = 136
              Width = 133
              Height = 20
              Font.Charset = SYMBOL_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Wingdings'
              Font.Style = []
              ParentFont = False
              PasswordChar = 'l'
              TabOrder = 5
            end
            object TrackBarCompressionLevel: TTrackBar
              Left = 12
              Top = 185
              Width = 272
              Height = 45
              Max = 4
              ShowSelRange = False
              TabOrder = 6
              OnChange = TrackBarCompressionLevelChange
            end
            object comboZipType: TComboBox
              Left = 12
              Top = 36
              Width = 145
              Height = 21
              Style = csDropDownList
              TabOrder = 0
              OnChange = comboZipTypeChange
              Items.Strings = (
                'Zip'
                'Seven Zip'
                'NT Backup')
            end
            object cbSystemState: TCheckBox
              Left = 176
              Top = 38
              Width = 129
              Height = 17
              Caption = 'System State Backup'
              TabOrder = 1
            end
          end
        end
      end
    end
    object tabActivePrograms: TTabSheet
      Caption = 'Active Programs'
      ImageIndex = 122
      ExplicitHeight = 434
      object GroupBox5: TGroupBox
        Left = 0
        Top = 0
        Width = 497
        Height = 437
        Align = alClient
        Caption = 'Active Programs'
        TabOrder = 0
        ExplicitHeight = 434
        DesignSize = (
          497
          437)
        object Bevel1: TBevel
          Left = 8
          Top = 390
          Width = 479
          Height = 9
          Anchors = [akLeft, akRight, akBottom]
          Shape = bsBottomLine
          ExplicitTop = 389
        end
        object ToolBar1: TToolBar
          Left = 8
          Top = 15
          Width = 479
          Height = 29
          Align = alNone
          Anchors = [akLeft, akTop, akRight]
          ButtonHeight = 26
          ButtonWidth = 27
          Caption = 'ToolBar1'
          Images = frmBandS.ImageListCommon
          TabOrder = 0
          object btnAddActiveProgram: TToolButton
            Left = 0
            Top = 0
            Action = ActionAddActiveProgram
          end
          object btnEditActiveProgram: TToolButton
            Left = 27
            Top = 0
            Action = ActionEditActiveProgram
          end
          object ToolButton3: TToolButton
            Left = 54
            Top = 0
            Width = 8
            Caption = 'ToolButton3'
            ImageIndex = 80
            Style = tbsSeparator
          end
          object btnRemoveActivePrograms: TToolButton
            Left = 62
            Top = 0
            Action = ActionRemoveActiveProgram
          end
          object ToolButton10: TToolButton
            Left = 89
            Top = 0
            Width = 8
            Caption = 'ToolButton10'
            ImageIndex = 3
            Style = tbsSeparator
          end
          object btnRemoveAllActivePrograms: TToolButton
            Left = 97
            Top = 0
            Action = ActionRemoveAllActivePrograms
          end
        end
        object cbGracefullyCloseActivePrograms: TCheckBox
          Left = 8
          Top = 406
          Width = 301
          Height = 17
          Anchors = [akLeft, akBottom]
          Caption = 'Ask active applications to close gracefully. (recommended)'
          TabOrder = 3
          ExplicitTop = 403
        end
        object btnTestActivePrograms: TBitBtn
          Left = 410
          Top = 402
          Width = 75
          Height = 25
          Action = ActionTestActivePrograms
          Anchors = [akRight, akBottom]
          Caption = '&Test'
          TabOrder = 2
          ExplicitTop = 399
        end
        object ListViewActivePrograms: TListView
          Left = 8
          Top = 44
          Width = 479
          Height = 348
          Anchors = [akLeft, akTop, akRight, akBottom]
          Columns = <
            item
              AutoSize = True
              Caption = 'Window Name'
            end
            item
              Caption = 'Window Class'
              Width = 150
            end>
          GridLines = True
          ReadOnly = True
          RowSelect = True
          TabOrder = 1
          ViewStyle = vsReport
          ExplicitHeight = 345
        end
      end
    end
    object tabLogging: TTabSheet
      Caption = 'Logging'
      ImageIndex = 187
      ExplicitHeight = 434
      object GroupBox6: TGroupBox
        Left = 0
        Top = 0
        Width = 497
        Height = 437
        Align = alClient
        Caption = 'Logging'
        TabOrder = 0
        ExplicitHeight = 434
        DesignSize = (
          497
          437)
        object Bevel2: TBevel
          Left = 196
          Top = 25
          Width = 291
          Height = 8
          Anchors = [akLeft, akTop, akRight]
          Shape = bsBottomLine
        end
        object cbLogEmailEnabled: TCheckBox
          Left = 8
          Top = 20
          Width = 97
          Height = 17
          Caption = 'Send Log E-Mail'
          TabOrder = 1
        end
        object btnLogEmailDetails: TBitBtn
          Left = 112
          Top = 16
          Width = 77
          Height = 25
          Action = ActionLogEmailDetails
          Caption = 'Details...'
          Glyph.Data = {
            76060000424D7606000000000000360000002800000014000000140000000100
            2000000000004006000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF0018DE180031B5310031B5310031B5310031B5310031B5310031B5310031B5
            310031B5310031B5310031B5310031B5310031B5310031B5310031B5310031B5
            310031B5310010E71000FF00FF00005A00000010000000000800080808000000
            0800080808000000080008080800000008000808080000000800080808000000
            08000808080000000800080808000000080008080800394A3900FF00FF000042
            000021212100004A520000526300106B730021737B0029737B0029737B002973
            7B0029737B0029737B0029737B0029737B00186B7B00005A630000526300214A
            52000000080039393900FF00FF000042000031636B006B7B7B0021737B000094
            AD0018A5BD0039B5BD0042BDC60031ADBD0021ADBD0042B5C60042BDC60029AD
            BD00089CB500007B9400527373006B9CA5000818180039393900FF00FF000042
            000031636B006BADB5005A8C8C0000849C000094AD00089CB500108CA500087B
            840008737B0010849400088CA500089CB500008CA5005273730063A5AD006BBD
            C6000818180039393900FF00FF000042000031636B006BCED6006BADB5003173
            840008849C000084940000737B00006B7B00006B7B00006B7B00007384000084
            9C00217B8C006B9CA5006BBDC6006BCED6000810180039393900FF00FF000042
            000031636B0052BDC6005AC6CE00319CA50008737B00004A4A00319CA50039AD
            BD0039B5BD0039ADBD00186B7B00005A6300188C94006BCED60052BDC6005AC6
            CE000818180039393900FF00FF0000420000295A63004ABDC60042B5C600088C
            A50000525A0010636B006BC6CE0073CED6005AC6CE0063C6CE0042A5AD00004A
            4A0008737B0039B5C60042B5C6004ABDC6000810180039393900FF00FF000042
            0000215A630021ADBD00088CA5000031310031949C007BCEDE0094D6E7008CD6
            DE008CD6DE008CD6DE007BCEDE004ABDC60018636B00007B9400189CB50039B5
            BD000810180039393900FF00FF000042000010526300088CA500005A6B003194
            9C007BCEDE00A5DEEF00ADDEF70094D6E70094D6E7008CD6DE008CD6DE0063C6
            CE0042A5AD0000424A0000738400189CAD000010180039393900FF00FF000042
            0000084A5200005A6300106B73007BCEDE00A5DEF700B5E7FF00B5E7FF00A5DE
            EF008CD6DE008CD6DE0094D6E7007BCEDE006BC6CE0021737B00005A63000873
            7B000010100039393900FF00FF000042000000181800A5C6D600C6E7F700D6EF
            FF00CEEFFF00C6E7F700ADE7F700B5E7FF00ADE7F700ADDEF7009CDEE7008CD6
            DE008CD6DE0063C6CE004AADBD00186B7B000000080039393900FF00FF000042
            0000525A5A00E7F7F700EFFFFF00D6EFFF00D6F7FF00CEEFFF00B5E7FF00B5E7
            FF00B5E7FF00B5E7FF00ADDEF700A5DEEF0094D6E70084D6DE0063C6CE0042A5
            AD000010100039393900FF00FF00004200000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000009C0000FF00FF0000CE
            000000BD000000BD000000BD000000BD000000BD000000BD000000BD000000BD
            000000BD000000BD000000BD000000BD000000BD000000BD000000BD000000BD
            000000BD000000E70000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
          TabOrder = 0
        end
        object GroupBox7: TGroupBox
          Left = 8
          Top = 43
          Width = 481
          Height = 372
          Anchors = [akLeft, akTop, akRight, akBottom]
          Caption = 'Previous Log'
          TabOrder = 2
          ExplicitHeight = 369
          object memoLogFile: TMemo
            Left = 2
            Top = 15
            Width = 477
            Height = 355
            Align = alClient
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
            ExplicitHeight = 352
          end
        end
      end
    end
    object tabPlugins: TTabSheet
      Caption = 'Plugins'
      ImageIndex = 245
      ExplicitHeight = 434
      object GroupBox8: TGroupBox
        Left = 0
        Top = 0
        Width = 497
        Height = 437
        Align = alClient
        Caption = 'Plugins'
        TabOrder = 0
        ExplicitHeight = 434
        DesignSize = (
          497
          437)
        object ListViewPlugins: TListView
          Left = 8
          Top = 44
          Width = 481
          Height = 378
          Anchors = [akLeft, akTop, akRight, akBottom]
          Columns = <
            item
              AutoSize = True
              Caption = 'Plugin Name'
            end
            item
              Caption = 'Version'
              Width = 100
            end
            item
              Caption = 'Developer'
              Width = 200
            end>
          GridLines = True
          ReadOnly = True
          RowSelect = True
          TabOrder = 1
          ViewStyle = vsReport
          OnDblClick = ListViewPluginsDblClick
          ExplicitHeight = 375
        end
        object ToolBar2: TToolBar
          Left = 8
          Top = 19
          Width = 481
          Height = 26
          Align = alNone
          Anchors = [akLeft, akTop, akRight]
          ButtonHeight = 26
          ButtonWidth = 27
          Caption = 'ToolBarFilesFolders'
          Images = frmBandS.ImageListCommon
          TabOrder = 0
          object btnPluginsRefresh: TToolButton
            Left = 0
            Top = 0
            Action = ActionPluginsRefresh
          end
          object ToolButton7: TToolButton
            Left = 27
            Top = 0
            Width = 8
            Caption = 'ToolButton7'
            ImageIndex = 256
            Style = tbsSeparator
          end
          object btnPluginConfig: TToolButton
            Left = 35
            Top = 0
            Action = ActionPluginConfig
          end
        end
      end
    end
  end
  object OpenDialog: TJvOpenDialog
    DefaultExt = '*.*'
    Filter = 
      'All Files (*.*)|*.*|Microsoft Word Documents (*.doc)|*.doc|Micro' +
      'soft Excel Documents (*.xls)|*.xls|Microsoft Outlook Personal Fo' +
      'lders (*.pst)|*.pst|Microsoft Access Database Files (*.mdb)|*.md' +
      'b|Microsoft Powerpoint Document (*.ppt)|*.ppt'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    AutoSize = True
    Height = 382
    Width = 563
    Left = 406
    Top = 60
  end
  object ActionListBackupProfiles: TActionList
    Images = frmBandS.ImageListCommon
    Left = 432
    Top = 58
    object ActionAddFileSourceItem: TAction
      Category = 'Source Files / Folders'
      Caption = 'Add File'
      ImageIndex = 92
      OnExecute = ActionAddFileSourceItemExecute
    end
    object ActionAddFolderSourceItem: TAction
      Category = 'Source Files / Folders'
      Caption = 'Add Folder'
      ImageIndex = 223
      OnExecute = ActionAddFolderSourceItemExecute
    end
    object ActionRemoveSourceItem: TAction
      Category = 'Source Files / Folders'
      Caption = 'Remove'
      ImageIndex = 195
      OnExecute = ActionRemoveSourceItemExecute
    end
    object ActionRemoveAllSourceItems: TAction
      Category = 'Source Files / Folders'
      Caption = 'Remove All'
      ImageIndex = 79
      OnExecute = ActionRemoveAllSourceItemsExecute
    end
    object ActionLoadDefaults: TAction
      Category = 'General'
      Caption = 'Load Defaults'
      OnExecute = ActionLoadDefaultsExecute
    end
    object ActionAlertEmailDetails: TAction
      Category = 'General'
      Caption = 'Details...'
      ImageIndex = 115
      OnExecute = ActionAlertEmailDetailsExecute
    end
    object ActionAddActiveProgram: TAction
      Category = 'Active Programs'
      Caption = 'Add'
      ImageIndex = 246
      OnExecute = ActionAddActiveProgramExecute
    end
    object ActionEditActiveProgram: TAction
      Category = 'Active Programs'
      Caption = 'Edit'
      ImageIndex = 104
      OnExecute = ActionEditActiveProgramExecute
    end
    object ActionRemoveActiveProgram: TAction
      Category = 'Active Programs'
      Caption = 'Remove'
      ImageIndex = 195
      OnExecute = ActionRemoveActiveProgramExecute
    end
    object ActionRemoveAllActivePrograms: TAction
      Category = 'Active Programs'
      Caption = 'Remove All'
      ImageIndex = 79
      OnExecute = ActionRemoveAllActiveProgramsExecute
    end
    object ActionTestActivePrograms: TAction
      Category = 'Active Programs'
      Caption = '&Test'
      OnExecute = ActionTestActiveProgramsExecute
    end
    object ActionLogEmailDetails: TAction
      Category = 'General'
      Caption = 'Details...'
      ImageIndex = 115
      OnExecute = ActionLogEmailDetailsExecute
    end
    object ActionPluginsRefresh: TAction
      Category = 'Plugins'
      Caption = 'Refresh Plugins'
      ImageIndex = 255
      OnExecute = ActionPluginsRefreshExecute
    end
    object ActionPluginConfig: TAction
      Category = 'Plugins'
      Caption = 'Configure Plugin'
      ImageIndex = 228
      OnExecute = ActionPluginConfigExecute
    end
    object ActionAddFileExclusionItem: TAction
      Category = 'Exclusion Files / Folders'
      Caption = 'Add File'
      ImageIndex = 92
      OnExecute = ActionAddFileExclusionItemExecute
    end
    object ActionAddFolderExclusionItem: TAction
      Category = 'Exclusion Files / Folders'
      Caption = 'Add Folder'
      ImageIndex = 223
      OnExecute = ActionAddFolderExclusionItemExecute
    end
    object ActionRemoveExclusionItem: TAction
      Category = 'Exclusion Files / Folders'
      Caption = 'Remove'
      ImageIndex = 195
      OnExecute = ActionRemoveExclusionItemExecute
    end
    object ActionRemoveAllExclusionItems: TAction
      Category = 'Exclusion Files / Folders'
      Caption = 'Remove All'
      ImageIndex = 79
      OnExecute = ActionRemoveAllExclusionItemsExecute
    end
    object ActionCustomSMTPDetails: TAction
      Category = 'General'
      Caption = 'Details...'
      ImageIndex = 117
      OnExecute = ActionCustomSMTPDetailsExecute
      OnUpdate = ActionCustomSMTPDetailsUpdate
    end
  end
end
