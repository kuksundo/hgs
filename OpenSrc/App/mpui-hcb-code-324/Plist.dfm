object PlaylistForm: TPlaylistForm
  Left = 437
  Top = 267
  Width = 365
  Height = 255
  Caption = 'PlaylistForm'
  Color = clBtnFace
  TransparentColorValue = 15204041
  Constraints.MinHeight = 105
  Constraints.MinWidth = 365
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    357
    221)
  PixelsPerInch = 96
  TextHeight = 13
  object TntPageControl1: TTntPageControl
    Left = -5
    Top = 0
    Width = 368
    Height = 237
    ActivePage = TntTabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TntTabSheet1: TTntTabSheet
      Caption = 'PlayList'
      ImageIndex = 16
      DesignSize = (
        360
        209)
      object CShuffle: TTntSpeedButton
        Left = 200
        Top = 1
        Width = 23
        Height = 22
        Hint = 'Shuffle'
        AllowAllUp = True
        GroupIndex = 1
        Glyph.Data = {
          7E000000424D7E000000000000003E000000280000000F000000100000000100
          01000000000040000000C30E0000C30E00000200000000000000FFFFFF000000
          00000000000043F00000421000004210000042540000423800007E1000000000
          0000000000000000000000200000001000007FF8000000100000002000000000
          0000}
        ParentShowHint = False
        ShowHint = True
        OnClick = CShuffleClick
      end
      object COneLoop: TTntSpeedButton
        Left = 248
        Top = 1
        Width = 23
        Height = 22
        Hint = 'Repeat Current'
        AllowAllUp = True
        GroupIndex = 3
        Glyph.Data = {
          76000000424D76000000000000003E000000280000000F0000000E0000000100
          01000000000038000000C30E0000C30E00000200000000000000FFFFFF000000
          000000000000380000003BFC0000380400000004000010040000380400005404
          0000100400001004000010040000100400001FFC000000000000}
        ParentShowHint = False
        ShowHint = True
        OnClick = COneLoopClick
      end
      object CLoop: TTntSpeedButton
        Left = 224
        Top = 1
        Width = 23
        Height = 22
        Hint = 'Repeat All'
        AllowAllUp = True
        GroupIndex = 2
        Glyph.Data = {
          76000000424D76000000000000003E00000028000000100000000E0000000100
          01000000000038000000C30E0000C30E00000200000000000000FFFFFF000000
          00000000000031CE000039CE000039CE00000000000010040000380400005404
          0000100400001004000010040000100400001FFC000000000000}
        ParentShowHint = False
        ShowHint = True
        OnClick = CLoopClick
      end
      object BSave: TTntBitBtn
        Left = 320
        Top = 1
        Width = 23
        Height = 22
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = BSaveClick
        Glyph.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          01000000000040000000C30E0000C30E00000200000000000000FFFFFF000000
          0000000000003FFE00004FCA00004FCA00004FCA00004FFA0000400200005FFA
          0000500A0000500A0000500A0000500A0000500E0000500A00007FFE00000000
          0000}
      end
      object BPlay: TBitBtn
        Left = 4
        Top = 1
        Width = 23
        Height = 22
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        OnClick = BPlayClick
        Glyph.Data = {
          72000000424D72000000000000003E000000280000000D0000000D0000000100
          01000000000034000000130B0000130B0000020000000000000000000000FFFF
          FF00FFF800009FF8000087F8000081F800008078000080180000800800008018
          00008078000081F8000087F800009FF80000FFF80000}
      end
      object BMoveUp: TTntBitBtn
        Tag = 1
        Left = 92
        Top = 1
        Width = 23
        Height = 22
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = BMoveClick
        Glyph.Data = {
          7E000000424D7E000000000000003E000000280000000E000000100000000100
          01000000000040000000C30E0000C30E00000200000000000000FFFFFF000000
          0000000000000700000007000000070000000700000007000000070000000700
          000067300000777000003FE000001FC000000F80000007000000020000000000
          0000}
      end
      object BMoveDown: TTntBitBtn
        Left = 116
        Top = 1
        Width = 23
        Height = 22
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = BMoveClick
        Glyph.Data = {
          7E000000424D7E000000000000003E000000280000000E000000100000000100
          01000000000040000000C30E0000C30E00000200000000000000FFFFFF000000
          00000000000002000000070000000F8000001FC000003FE00000777000006730
          0000070000000700000007000000070000000700000007000000070000000000
          0000}
      end
      object BDelete: TTntBitBtn
        Left = 146
        Top = 1
        Width = 23
        Height = 22
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = BDeleteClick
        Glyph.Data = {
          7A000000424D7A000000000000003E000000280000000F0000000F0000000100
          0100000000003C000000C30E0000C30E00000200000000000000FFFFFF000000
          000000000000200000007000000078080000181000001C3000000E60000006C0
          00000380000007C000000E6000003C300000781800007004000000000000}
      end
      object BClear: TTntBitBtn
        Left = 170
        Top = 1
        Width = 23
        Height = 22
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnClick = BClearClick
        Glyph.Data = {
          6A000000424D6A000000000000003E00000028000000110000000B0000000100
          0100000000002C000000C30E0000C30E00000200000000000000FFFFFF000000
          00003FE000002030000020380000202C00003FE60000183300000C198000060C
          8000030780000183800000FF8000}
      end
      object BAddDir: TTntBitBtn
        Left = 62
        Top = 1
        Width = 23
        Height = 22
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        OnClick = BAddDirClick
        Glyph.Data = {
          86000000424D86000000000000003E0000002800000014000000120000000100
          01000000000048000000C30E0000C30E00000200000000000000FFFFFF000000
          0000000000007FF000006008000050040000480200004401000043FF80004010
          00004017000047F7000038070000003FE000003FE000003FE000000700000007
          00000007000000000000}
      end
      object BAdd: TTntBitBtn
        Left = 38
        Top = 1
        Width = 23
        Height = 22
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = BAddClick
        Glyph.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          01000000000040000000C30E0000C30E00000200000000000000FFFFFF000000
          0000000000003FE00000202000002FA00000202000002FA00000202000002FB8
          0000203800002FB8000021FF000011FF00000FFF000000380000003800000038
          0000}
      end
      object PlaylistBox: TTntListBox
        Left = 2
        Top = 26
        Width = 355
        Height = 177
        Style = lbVirtualOwnerDraw
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 16
        MultiSelect = True
        TabOrder = 1
        OnDblClick = BPlayClick
        OnDrawItem = PlaylistBoxDrawItem
      end
      object dLyric: TTntBitBtn
        Left = 286
        Top = 1
        Width = 23
        Height = 22
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        OnClick = MDownloadLyricClick
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF000000FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFF0000
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF
          000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF000000FFFFFFFFFFFF000000FFFFFFFFFFFF000000000000FFFFFF00
          0000000000000000000000FFFFFF000000FFFFFFFFFFFF000000000000FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000000000000000FF
          FFFF000000000000FFFFFF000000000000000000FFFFFF000000000000FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFF00000000
          0000FFFFFF000000000000000000000000FFFFFFFFFFFF000000FFFFFF000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF000000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000
          0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      end
    end
    object TntTabSheet2: TTntTabSheet
      Caption = 'Lyric'
      ImageIndex = 24
      DesignSize = (
        360
        209)
      object TMLyric: TPaintBox
        Left = 0
        Top = 24
        Width = 360
        Height = 181
        Anchors = [akLeft, akTop, akRight, akBottom]
        PopupMenu = TntCP
        OnPaint = TMLyricPaint
      end
      object PLBC: TTntPanel
        Left = 264
        Top = 0
        Width = 30
        Height = 21
        Cursor = crHandPoint
        BevelInner = bvRaised
        BevelOuter = bvLowered
        BorderWidth = 1
        Color = clWindow
        ParentBackground = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = PLBCClick
      end
      object PLHC: TTntPanel
        Left = 232
        Top = 0
        Width = 30
        Height = 21
        Cursor = crHandPoint
        BevelInner = bvRaised
        BevelOuter = bvLowered
        BorderWidth = 1
        Color = clRed
        ParentBackground = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = PLHCClick
      end
      object PLTC: TTntPanel
        Left = 200
        Top = 0
        Width = 30
        Height = 21
        Cursor = crHandPoint
        BevelInner = bvRaised
        BevelOuter = bvLowered
        BorderWidth = 1
        Color = clWindowText
        ParentBackground = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = PLTCClick
      end
      object CLyricS: TComboBox
        Left = 146
        Top = 0
        Width = 47
        Height = 21
        ItemHeight = 13
        TabOrder = 3
        OnChange = CLyricSChange
        Items.Strings = (
          '8'
          '9'
          '10'
          '11'
          '12'
          '14'
          '16'
          '18'
          '20'
          '22'
          '24'
          '26'
          '28'
          '36'
          '48'
          '72')
      end
      object CLyricF: TComboBox
        Left = 2
        Top = 0
        Width = 143
        Height = 21
        ItemHeight = 0
        TabOrder = 4
        OnChange = CLyricFChange
      end
      object dlyric1: TTntBitBtn
        Left = 326
        Top = 0
        Width = 23
        Height = 20
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnClick = MDownloadLyricClick
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF000000FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFF0000
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF
          000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF000000FFFFFFFFFFFF000000FFFFFFFFFFFF000000000000FFFFFF00
          0000000000000000000000FFFFFF000000FFFFFFFFFFFF000000000000FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000000000000000FF
          FFFF000000000000FFFFFF000000000000000000FFFFFF000000000000FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFF00000000
          0000FFFFFF000000000000000000000000FFFFFFFFFFFF000000FFFFFF000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF000000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000
          0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      end
    end
  end
  object SaveDialog: TTntSaveDialog
    DefaultExt = 'm3u8'
    Filter = 
      'M3U8 Playlist [UTF-8] (*.m3u8)|*.m3u8|M3U Playlist [ANSI] (*.m3u' +
      ')|*.m3u'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save Playlist ...'
    Left = 168
    Top = 65528
  end
  object TntCP: TTntPopupMenu
    Left = 136
    Top = 65528
    object MLoadLyric: TTntMenuItem
      Caption = 'Load Lyric...'
      OnClick = MLoadLyricClick
    end
    object MDownloadLyric: TTntMenuItem
      Caption = 'Download Lyric...'
      OnClick = MDownloadLyricClick
    end
    object N2: TTntMenuItem
      Caption = '-'
    end
    object CPA: TTntMenuItem
      Caption = 'Auto Detect'
      RadioItem = True
      OnClick = TntCPClick
    end
    object CP0: TTntMenuItem
      Caption = 'System default'
      Checked = True
      RadioItem = True
      OnClick = TntCPClick
    end
    object CPO: TTntMenuItem
      Tag = 2
      Caption = 'Other'
      object SC: TTntMenuItem
        Caption = 'Chinese (PRC, Singapore)'
        object sc3: TTntMenuItem
          Tag = 936
          Caption = 'GBK (936)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object sc0: TTntMenuItem
          Tag = 20936
          Caption = 'GB2312 (20936)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object sc5: TTntMenuItem
          Tag = 54936
          Caption = 'GB18030 (54936)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object sc4: TTntMenuItem
          Tag = 52936
          Caption = 'HZ (52936,hz-gb-2312)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object sc1: TTntMenuItem
          Tag = 10008
          Caption = 'MAC (10008)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object sc2: TTntMenuItem
          Tag = 50227
          Caption = '50227,ISO-2022'
          RadioItem = True
          OnClick = TntCPClick
        end
      end
      object TC: TTntMenuItem
        Caption = 'Chinese (Taiwan, Hong Kong) '
        object tc0: TTntMenuItem
          Tag = 950
          Caption = 'Big5 (ANSI/OEM 950)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object tc1: TTntMenuItem
          Tag = 10002
          Caption = 'MAC (10002)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object tc2: TTntMenuItem
          Tag = 50229
          Caption = '50229,ISO-2022'
          RadioItem = True
          OnClick = TntCPClick
        end
        object tc8: TTntMenuItem
          Tag = 20000
          Caption = 'CNS (20000)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object CA1: TTntMenuItem
          Tag = 20001
          Caption = 'TCA (20001)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object tc6: TTntMenuItem
          Tag = 20002
          Caption = 'Eten (20002)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object tc5: TTntMenuItem
          Tag = 20003
          Caption = 'IBM5550 (20003)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object tc4: TTntMenuItem
          Tag = 20004
          Caption = 'Tele text (20004)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object tc3: TTntMenuItem
          Tag = 20005
          Caption = 'Wang (20005)'
          RadioItem = True
          OnClick = TntCPClick
        end
      end
      object KO: TTntMenuItem
        Caption = 'Korean'
        object ko0: TTntMenuItem
          Tag = 949
          Caption = 'Korean (ANSI/OEM 949,ks_c_5601-1987)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object ko3: TTntMenuItem
          Tag = 50949
          Caption = 'Auto-Select (50949)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object ko1: TTntMenuItem
          Tag = 20833
          Caption = 'IBM EBCDIC Korean Extended (20833)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object KO2: TTntMenuItem
          Tag = 1361
          Caption = 'Korean (Johab,1361)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object ko4: TTntMenuItem
          Tag = 10003
          Caption = 'MAC (10003)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object ko5: TTntMenuItem
          Tag = 51949
          Caption = 'EUC (51949)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object ko6: TTntMenuItem
          Tag = 50225
          Caption = 'ISO (50225,iso-2022-kr)'
          RadioItem = True
          OnClick = TntCPClick
        end
      end
      object JA: TTntMenuItem
        Caption = 'Japanese'
        object jp7: TTntMenuItem
          Tag = 932
          Caption = 'Shift-JIS (ANSI/OEM 932)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object jp0: TTntMenuItem
          Tag = 50932
          Caption = 'Auto-Select (50932)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object jp1: TTntMenuItem
          Tag = 10001
          Caption = 'MAC (10001)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object jp2: TTntMenuItem
          Tag = 20290
          Caption = 'IBM EBCDIC (20290,KataKana Extended)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object jp3: TTntMenuItem
          Tag = 51932
          Caption = 'EUC (51932,euc-jp)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object jp4: TTntMenuItem
          Tag = 50220
          Caption = 'JIS (50220,iso-2022-jp)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object jp5: TTntMenuItem
          Tag = 50221
          Caption = 'JIS-Allow 1 byte Kana (50221)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object jp6: TTntMenuItem
          Tag = 50222
          Caption = 'JIS-Allow 1 byte Kana - SO/SI (50222,ISO-2022 JIS X 0201-1989)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object jp8: TTntMenuItem
          Tag = 20932
          Caption = '20932 (JIS X 0208-1990 & 0212-1990)'
          RadioItem = True
          OnClick = TntCPClick
        end
      end
      object TH: TTntMenuItem
        Caption = 'Thai'
        object th1: TTntMenuItem
          Tag = 874
          Caption = 'ANSI/OEM 874,Windows-874'
          RadioItem = True
          OnClick = TntCPClick
        end
        object th0: TTntMenuItem
          Tag = 10021
          Caption = 'MAC (10021)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object th2: TTntMenuItem
          Tag = 20838
          Caption = 'IBM EBCDIC (20838)'
          RadioItem = True
          OnClick = TntCPClick
        end
      end
      object CY: TTntMenuItem
        Caption = 'Cyrillic'
        object cy7: TTntMenuItem
          Tag = 1251
          Caption = 'Windows (ANSI 1251)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object cy0: TTntMenuItem
          Tag = 866
          Caption = 'OEM - Russian (866)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object cy5: TTntMenuItem
          Tag = 855
          Caption = 'OEM - Cyrillic (855)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object cy3: TTntMenuItem
          Tag = 28595
          Caption = '28595,ISO-8859-5'
          RadioItem = True
          OnClick = TntCPClick
        end
        object cy4: TTntMenuItem
          Tag = 20866
          Caption = 'Russian (20866,KOI8-R)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object cy6: TTntMenuItem
          Tag = 21866
          Caption = 'UKrainian (21866,KOI8-U)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object cy1: TTntMenuItem
          Tag = 10007
          Caption = 'MAC (10007)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object cy2: TTntMenuItem
          Tag = 20880
          Caption = 'IBM EBCDIC (20880)'
          RadioItem = True
          OnClick = TntCPClick
        end
      end
      object BA: TTntMenuItem
        Caption = 'Baltic'
        object Ba2: TTntMenuItem
          Tag = 1257
          Caption = 'Windows (ANSI 1257)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object Ba0: TTntMenuItem
          Tag = 28594
          Caption = '28594,ISO-8859-4'
          RadioItem = True
          OnClick = TntCPClick
        end
        object Ba1: TTntMenuItem
          Tag = 775
          Caption = 'OEM (775)'
          RadioItem = True
          OnClick = TntCPClick
        end
      end
      object AR: TTntMenuItem
        Caption = 'Arabic'
        object Ar3: TTntMenuItem
          Tag = 1256
          Caption = 'Windows (ANSI 1256)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object Ar4: TTntMenuItem
          Tag = 864
          Caption = 'OEM (864)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object Ar2: TTntMenuItem
          Tag = 28596
          Caption = '28596,ISO-8859-6'
          RadioItem = True
          OnClick = TntCPClick
        end
        object Ar0: TTntMenuItem
          Tag = 708
          Caption = 'ASMO (708)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object Ar1: TTntMenuItem
          Tag = 720
          Caption = 'DOS (720)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object Ar5: TTntMenuItem
          Tag = 20420
          Caption = 'IBM EBCDIC (20420)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object Ar6: TTntMenuItem
          Tag = 10004
          Caption = 'MAC (10004)'
          RadioItem = True
          OnClick = TntCPClick
        end
      end
      object HE: TTntMenuItem
        Tag = 1255
        Caption = 'Hebrew'
        object he5: TTntMenuItem
          Tag = 1255
          Caption = 'Windows (ANSI 1255)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object he0: TTntMenuItem
          Tag = 862
          Caption = 'DOS (862)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object he4: TTntMenuItem
          Tag = 38598
          Caption = 'ISO-Logical (38598 ISO-8859-8)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object he3: TTntMenuItem
          Tag = 28598
          Caption = 'ISO-Visual (28598 ISO 8859-8)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object he1: TTntMenuItem
          Tag = 10005
          Caption = 'MAC (10005)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object he2: TTntMenuItem
          Tag = 20424
          Caption = 'IBM EBCDIC (20424)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object he6: TTntMenuItem
          Tag = 862
          Caption = 'OEM (862)'
          RadioItem = True
          OnClick = TntCPClick
        end
      end
      object TU: TTntMenuItem
        Caption = 'Turkish'
        object TU2: TTntMenuItem
          Tag = 1254
          Caption = 'Windows (ANSI 1254,iso-8859-9)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object tu4: TTntMenuItem
          Tag = 857
          Caption = 'OEM (857)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object tu1: TTntMenuItem
          Tag = 10081
          Caption = 'MAC (10081)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object tu0: TTntMenuItem
          Tag = 20905
          Caption = 'IBM EBCDIC (20905)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object tu3: TTntMenuItem
          Tag = 1026
          Caption = 'IBM EBCDIC Latin5 (1026)'
          RadioItem = True
          OnClick = TntCPClick
        end
      end
      object FR: TTntMenuItem
        Caption = 'French'
        object fr2: TTntMenuItem
          Tag = 863
          Caption = 'Canadian - French (OEM 863)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object fr0: TTntMenuItem
          Tag = 1147
          Caption = 'IBM EBCDIC France (20297 + Euro)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object fr1: TTntMenuItem
          Tag = 20297
          Caption = 'IBM EBCDIC  France (20297)'
          RadioItem = True
          OnClick = TntCPClick
        end
      end
      object IC: TTntMenuItem
        Tag = 861
        Caption = 'Icelandic'
        object ic0: TTntMenuItem
          Tag = 861
          Caption = 'OEM (861)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object ic1: TTntMenuItem
          Tag = 10079
          Caption = 'MAC (10079)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object ic2: TTntMenuItem
          Tag = 1149
          Caption = 'IBM EBCDIC (1149)'
          RadioItem = True
          OnClick = TntCPClick
        end
      end
      object Gr: TTntMenuItem
        Caption = 'Greek'
        object GR0: TTntMenuItem
          Tag = 1253
          Caption = 'Greek (Windows-ANSI 1253)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object GR1: TTntMenuItem
          Tag = 869
          Caption = 'OEM Modern (869)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object gr2: TTntMenuItem
          Tag = 28597
          Caption = '28597,ISO-8859-7'
          RadioItem = True
          OnClick = TntCPClick
        end
        object gr6: TTntMenuItem
          Tag = 737
          Caption = 'OEM (737)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object gr3: TTntMenuItem
          Tag = 875
          Caption = 'IBM EBCDIC Modern (875)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object gr4: TTntMenuItem
          Tag = 20423
          Caption = 'IBM EBCDIC (20423)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object gr5: TTntMenuItem
          Tag = 10006
          Caption = 'MAC (10006)'
          RadioItem = True
          OnClick = TntCPClick
        end
      end
      object CE: TTntMenuItem
        Caption = 'Central European'
        object Ce2: TTntMenuItem
          Tag = 1250
          Caption = 'Windows (ANSI 1250)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object Ce0: TTntMenuItem
          Tag = 852
          Caption = 'Slavic (Latin II)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object Ce1: TTntMenuItem
          Tag = 28592
          Caption = '28592,ISO-8859-2'
          RadioItem = True
          OnClick = TntCPClick
        end
        object Ce3: TTntMenuItem
          Tag = 10029
          Caption = 'MAC - Latin2 (10029)'
          RadioItem = True
          OnClick = TntCPClick
        end
      end
      object ISCII1: TTntMenuItem
        Caption = 'ISCII'
        object DV: TTntMenuItem
          Tag = 57002
          Caption = 'Devanagari (57002)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object BE: TTntMenuItem
          Tag = 57003
          Caption = 'Bengali (57003)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object TA: TTntMenuItem
          Tag = 57004
          Caption = 'Tamil (57004)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object TE: TTntMenuItem
          Tag = 57005
          Caption = 'Telugu (57005)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object AM: TTntMenuItem
          Tag = 57006
          Caption = 'Assamese (57006)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object OY: TTntMenuItem
          Tag = 57007
          Caption = 'Oriya (57007)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object KA: TTntMenuItem
          Tag = 57008
          Caption = 'Kannada (57008)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object MA: TTntMenuItem
          Tag = 57009
          Caption = 'Malayalam (57009)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object GU: TTntMenuItem
          Tag = 57010
          Caption = 'Gujarati (57010)'
          RadioItem = True
          OnClick = TntCPClick
        end
        object PG: TTntMenuItem
          Tag = 57011
          Caption = 'Punjabi(Gurmukhi) 57011'
          RadioItem = True
          OnClick = TntCPClick
        end
      end
      object BG: TTntMenuItem
        Tag = 1251
        Caption = 'Bulgarian (1251)'
        RadioItem = True
        OnClick = TntCPClick
      end
      object PO: TTntMenuItem
        Tag = 860
        Caption = 'Portuguese (OEM 860)'
        RadioItem = True
        OnClick = TntCPClick
      end
      object vi: TTntMenuItem
        Tag = 1258
        Caption = 'Vietnamese (ANSI/OEM 1258)'
        RadioItem = True
        OnClick = TntCPClick
      end
      object we: TTntMenuItem
        Tag = 1252
        Caption = 'Western European (ANSI 1252,iso-8859-1)'
        RadioItem = True
        OnClick = TntCPClick
      end
      object iso0: TTntMenuItem
        Tag = 28591
        Caption = 'ISO 8859-1 Latin1 (28591)'
        RadioItem = True
        OnClick = TntCPClick
      end
      object lt0: TTntMenuItem
        Tag = 28593
        Caption = 'ISO-8859-3 Latin3 (28593)'
        RadioItem = True
        OnClick = TntCPClick
      end
      object iso9: TTntMenuItem
        Tag = 28599
        Caption = 'ISO 8859-9 Latin5 (28599)'
        RadioItem = True
        OnClick = TntCPClick
      end
      object iso15: TTntMenuItem
        Tag = 28605
        Caption = 'ISO 8859-15 Latin9 (28605)'
        RadioItem = True
        OnClick = TntCPClick
      end
      object RO: TTntMenuItem
        Tag = 10000
        Caption = 'Roman (MAC 10000)'
        RadioItem = True
        OnClick = TntCPClick
      end
      object RM: TTntMenuItem
        Tag = 10010
        Caption = 'Romania (MAC 10010)'
        RadioItem = True
        OnClick = TntCPClick
      end
      object CO: TTntMenuItem
        Tag = 10082
        Caption = 'Croatia (MAC 10082)'
        RadioItem = True
        OnClick = TntCPClick
      end
      object I18: TTntMenuItem
        Tag = 500
        Caption = 'IBM EBCDIC-International (500)'
        RadioItem = True
        OnClick = TntCPClick
      end
      object ND: TTntMenuItem
        Tag = 865
        Caption = 'Nordic (OEM 865)'
        RadioItem = True
        OnClick = TntCPClick
      end
    end
    object N1: TTntMenuItem
      Caption = '-'
    end
    object MGB: TTntMenuItem
      Caption = #31616#20307'<-->'#32321#39636
      RadioItem = True
      object MG2B: TTntMenuItem
        Tag = 950
        Caption = #31616#20307'-->'#32321#39636
        RadioItem = True
        OnClick = TntCPClick
      end
      object MB2G: TTntMenuItem
        Tag = 936
        Caption = #32321#39636'-->'#31616#20307
        RadioItem = True
        OnClick = TntCPClick
      end
    end
  end
end
