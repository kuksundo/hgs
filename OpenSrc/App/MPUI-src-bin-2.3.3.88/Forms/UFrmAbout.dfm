object frmAbout: TfrmAbout
  Left = 480
  Top = 107
  ActiveControl = BClose
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'frmAbout'
  ClientHeight = 393
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  DesignSize = (
    356
    393)
  PixelsPerInch = 96
  TextHeight = 13
  object VersionMPUI: TLabel
    Left = 148
    Top = 54
    Width = 60
    Height = 13
    Caption = 'VersionMPUI'
  end
  object VersionMPlayer: TLabel
    Left = 148
    Top = 94
    Width = 73
    Height = 13
    Caption = 'VersionMPlayer'
  end
  object LVersionMPlayer: TLabel
    Left = 148
    Top = 80
    Width = 91
    Height = 13
    Caption = 'MPlayer version'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LVersionMPUI: TLabel
    Left = 148
    Top = 40
    Width = 75
    Height = 13
    Caption = 'MPUI version'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LURL: TLabel
    Left = 6
    Top = 128
    Width = 199
    Height = 13
    Cursor = crHandPoint
    Caption = 'http://sourceforge.net/projects/mpui-ve/'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = URLClick
  end
  object LTitle: TLabel
    Left = 146
    Top = 4
    Width = 210
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'MTitle'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object PLogo: TPanel
    Left = 4
    Top = 4
    Width = 140
    Height = 120
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clBlack
    TabOrder = 0
    object ILogo: TImage
      Left = 9
      Top = 9
      Width = 120
      Height = 100
    end
  end
  object BClose: TButton
    Left = 273
    Top = 363
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 1
    OnClick = BCloseClick
  end
  object MCredits: TMemo
    Left = 0
    Top = 143
    Width = 357
    Height = 214
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvNone
    BevelOuter = bvNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'This is free software, licensed under the terms of the'
      'GNU General Public License, Version 2.'
      ''
      '(C) 2008 Visenri'
      ''
      
        'Original source code by Martin J. Fiedler <martin.fiedler@gmx.ne' +
        't>'
      ''
      'Code contributions and hints from original version:'
      'Joackim Pennerup <joackim@pennerup.net>'
      'Vasily Khoruzhick <fenix-fen@mail.ru>'
      'Maxim Usov <UsovMV@kms.cctpu.edu.ru>'
      'Peter Pinter <pinterpeti@gmail.com>'
      ''
      'Contibuted translations:'
      'French by Francois Gagne <frenchfrog@gmail.com>'
      ''
      'This software is provided "as is" and any expressed or implied '
      
        'warranties, including, but not limited to, the implied warrantie' +
        's of '
      
        'merchantability and fitness for a particular purpose are disclai' +
        'med.'
      ''
      
        'In no event shall the author or its contributors be liable for a' +
        'ny '
      
        'direct, indirect, incidental, special, exemplary, or consequenti' +
        'al '
      
        'damages (including, but not limited to, procurement of substitut' +
        'e '
      'goods or services; loss of use, data, or profits; or business '
      
        'interruption) however caused and on any theory of liability, whe' +
        'ther '
      
        'in contract, strict liability, or tort (including negligence or ' +
        'otherwise) '
      
        'arising in any way out of the use of this software, even if advi' +
        'sed of '
      'the possibility of such damage.')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
