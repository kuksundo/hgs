object frmFolderSelect: TfrmFolderSelect
  Left = 107
  Top = 496
  BorderStyle = bsSizeToolWin
  Caption = 'Select Folder'
  ClientHeight = 366
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PopupMode = pmAuto
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 253
    Width = 378
    Height = 110
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitLeft = 8
    object GroupBox1: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 372
      Height = 63
      Align = alTop
      Caption = 'Options'
      TabOrder = 0
      ExplicitLeft = 8
      ExplicitTop = 4
      ExplicitWidth = 358
      DesignSize = (
        372
        63)
      object Label1: TLabel
        Left = 8
        Top = 20
        Width = 90
        Height = 13
        Caption = 'Filename Wildcard:'
      end
      object comboBoxWildcards: TComboBox
        Left = 8
        Top = 36
        Width = 201
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        Text = '*.*'
        Items.Strings = (
          '*.*'
          '*.pst'
          '*.doc'
          '*.xls'
          '*.ppt'
          '*.mdb'
          '*.sxc'
          '*.sxw')
        ExplicitWidth = 187
      end
      object cbRecurse: TCheckBox
        Left = 220
        Top = 40
        Width = 145
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Include files in sub-folders.'
        Checked = True
        State = cbChecked
        TabOrder = 2
        ExplicitLeft = 206
      end
      object cbShowHidden: TCheckBox
        Left = 220
        Top = 16
        Width = 129
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Show hidden folders'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = cbShowHiddenClick
        ExplicitLeft = 206
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 77
      Width = 378
      Height = 33
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitTop = 72
      object btnOk: TBitBtn
        AlignWithMargins = True
        Left = 219
        Top = 3
        Width = 75
        Height = 27
        Align = alRight
        Caption = 'Ok'
        Default = True
        ModalResult = 1
        TabOrder = 0
        ExplicitLeft = 100
      end
      object btnCancel: TBitBtn
        AlignWithMargins = True
        Left = 300
        Top = 3
        Width = 75
        Height = 27
        Align = alRight
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
        ExplicitLeft = 200
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 384
    Height = 25
    Align = alTop
    TabOrder = 0
    object DriveCombo: TJvDriveCombo
      Left = 1
      Top = 1
      Width = 382
      Height = 22
      Align = alClient
      DriveTypes = [dtFixed, dtRemote, dtCDROM]
      Offset = 4
      TabOrder = 0
    end
  end
  object DirectoryListBox: TJvDirectoryListBox
    AlignWithMargins = True
    Left = 3
    Top = 28
    Width = 378
    Height = 219
    Align = alClient
    Directory = 'C:\'
    DriveCombo = DriveCombo
    ItemHeight = 17
    ShowAllFolders = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
end
