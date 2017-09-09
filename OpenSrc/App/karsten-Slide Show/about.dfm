object AboutBox: TAboutBox
  Left = 278
  Top = 103
  BorderIcons = [biSystemMenu]
  Caption = 'About'
  ClientHeight = 433
  ClientWidth = 489
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    489
    433)
  PixelsPerInch = 96
  TextHeight = 13
  object LicenseInfo: TJvLinkLabel
    Left = 8
    Top = 111
    Width = 473
    Height = 273
    Text.Strings = (
      '')
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoHeight = False
    OnLinkClick = LicenseInfoLinkClick
    ExplicitWidth = 385
    ExplicitHeight = 242
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 473
    Height = 97
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvLowered
    TabOrder = 0
    object ProgramIcon: TImage
      Left = 8
      Top = 16
      Width = 65
      Height = 65
      Center = True
      IsControl = True
    end
    object ProductNameLabel: TLabel
      Left = 88
      Top = 16
      Width = 67
      Height = 13
      Caption = 'Product Name'
      IsControl = True
    end
    object VersionLabel: TLabel
      Left = 88
      Top = 45
      Width = 54
      Height = 13
      Caption = 'File Version'
      IsControl = True
    end
    object CopyrightLabel: TLabel
      Left = 88
      Top = 64
      Width = 75
      Height = 13
      Caption = 'Copyright Label'
      IsControl = True
    end
  end
  object CloseBtn: TBitBtn
    Left = 194
    Top = 400
    Width = 101
    Height = 25
    Anchors = [akBottom]
    Caption = '&Close'
    Default = True
    ModalResult = 1
    TabOrder = 1
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
      F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
      000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
      338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
      45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
      3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
      F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
      000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
      338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
      4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
      8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
      333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
      0000}
    NumGlyphs = 2
  end
end
