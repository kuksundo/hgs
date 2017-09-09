object dlgPlugin: TdlgPlugin
  Left = 499
  Top = 265
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Add/Edit Plugin'
  ClientHeight = 301
  ClientWidth = 366
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 76
    Height = 13
    Caption = 'Plugin Location:'
  end
  object fePlugin: TFilenameEdit
    Left = 16
    Top = 24
    Width = 257
    Height = 21
    Filter = 'ABC-View Plugins (abc*.dll)|abc*.dll'
    NumGlyphs = 1
    TabOrder = 0
    Text = 'fePlugin'
  end
  object btnLoad: TBitBtn
    Left = 280
    Top = 22
    Width = 75
    Height = 25
    Caption = 'Load'
    Default = True
    TabOrder = 1
    OnClick = btnLoadClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 56
    Width = 257
    Height = 89
    Caption = 'Plugin properties'
    TabOrder = 2
    object Label2: TLabel
      Left = 16
      Top = 16
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object lblName: TLabel
      Left = 72
      Top = 16
      Width = 38
      Height = 13
      Caption = 'lblName'
    end
    object Label4: TLabel
      Left = 16
      Top = 32
      Width = 38
      Height = 13
      Caption = 'Version:'
    end
    object lblVersion: TLabel
      Left = 72
      Top = 32
      Width = 45
      Height = 13
      Caption = 'lblVersion'
    end
    object Label6: TLabel
      Left = 16
      Top = 48
      Width = 33
      Height = 13
      Caption = 'Status:'
    end
    object lblStatus: TLabel
      Left = 72
      Top = 48
      Width = 40
      Height = 13
      Caption = 'lblStatus'
    end
    object lblRegTo: TLabel
      Left = 16
      Top = 64
      Width = 43
      Height = 13
      Caption = 'lblRegTo'
    end
  end
  object BitBtn2: TBitBtn
    Left = 144
    Top = 264
    Width = 97
    Height = 25
    TabOrder = 3
    Kind = bkOK
  end
  object BitBtn4: TBitBtn
    Left = 16
    Top = 264
    Width = 89
    Height = 25
    TabOrder = 4
    Kind = bkHelp
  end
  object btnCancel: TBitBtn
    Left = 256
    Top = 264
    Width = 97
    Height = 25
    TabOrder = 5
    Kind = bkCancel
  end
  object btnInfo: TButton
    Left = 280
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Show &Info'
    TabOrder = 6
    OnClick = btnInfoClick
  end
  object btnSetup: TButton
    Left = 280
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Setup'
    TabOrder = 7
    OnClick = btnSetupClick
  end
  object btnAuthorize: TButton
    Left = 16
    Top = 158
    Width = 89
    Height = 25
    Caption = 'Authorize'
    TabOrder = 8
    OnClick = btnAuthorizeClick
  end
end
