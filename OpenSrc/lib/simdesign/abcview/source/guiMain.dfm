object frmMain: TfrmMain
  Left = 666
  Top = 242
  Width = 832
  Height = 548
  Caption = 'ABCView'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sbMain: TStatusBar
    Left = 0
    Top = 491
    Width = 816
    Height = 19
    Panels = <
      item
        Text = '0 Files (0 Kb)'
        Width = 150
      end
      item
        Text = 'Press F1 for Help'
        Width = 500
      end
      item
        Text = 'Index status'
        Width = 50
      end>
  end
  object nbMain: TNotebook
    Left = 0
    Top = 52
    Width = 816
    Height = 439
    Align = alClient
    TabOrder = 1
    object TPage
      Left = 0
      Top = 0
      Caption = 'Default'
      object nbLft: TNotebook
        Left = 0
        Top = 0
        Width = 816
        Height = 439
        Align = alClient
        TabOrder = 0
        object TPage
          Left = 0
          Top = 0
          Caption = 'Standard'
          object Splitter1: TSplitter
            Left = 265
            Top = 0
            Width = 4
            Height = 439
          end
          inline ItemView1: TItemView
            Left = 269
            Top = 0
            Width = 547
            Height = 439
            Align = alClient
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            TabStop = True
            inherited ListView: TListView
              Width = 547
              Height = 357
            end
            inherited cbItems: TControlBar
              Width = 547
              inherited tbSorting: TToolBar
                Flat = True
                inherited ToolButton16: TToolButton
                  Top = 0
                end
                inherited ToolButton17: TToolButton
                  Top = 0
                end
                inherited ToolButton18: TToolButton
                  Top = 0
                end
                inherited ToolButton19: TToolButton
                  Top = 0
                end
                inherited ToolButton20: TToolButton
                  Top = 0
                end
                inherited ToolButton21: TToolButton
                  Top = 0
                end
                inherited ToolButton22: TToolButton
                  Top = 0
                end
                inherited ToolButton23: TToolButton
                  Top = 0
                end
              end
              inherited tbViews: TToolBar
                Flat = True
                inherited ToolButton24: TToolButton
                  Top = 0
                end
                inherited ToolButton25: TToolButton
                  Top = 0
                end
                inherited ToolButton26: TToolButton
                  Top = 0
                end
                inherited ToolButton27: TToolButton
                  Top = 0
                end
                inherited ToolButton28: TToolButton
                  Top = 0
                end
              end
              inherited tbItems: TToolBar
                Flat = True
                inherited ToolButton29: TToolButton
                  Top = 0
                end
                inherited ToolButton30: TToolButton
                  Top = 0
                end
                inherited ToolButton5: TToolButton
                  Top = 0
                end
                inherited ToolButton7: TToolButton
                  Top = 0
                end
              end
              inherited tbTypes: TToolBar
                Flat = True
                inherited ToolButton1: TToolButton
                  Top = 0
                end
                inherited ToolButton2: TToolButton
                  Top = 0
                end
                inherited ToolButton3: TToolButton
                  Top = 0
                end
                inherited ToolButton4: TToolButton
                  Top = 0
                end
              end
            end
            inherited pnlEdit: TPanel
              Top = 383
              Width = 547
              DesignSize = (
                547
                56)
              inherited pcEdit: TPageControl
                Width = 525
                inherited tsDescr: TTabSheet
                  inherited btnDescription: TBitBtn
                    Left = 442
                  end
                  inherited cbbDescr: TComboBox
                    Width = 429
                  end
                end
              end
            end
          end
          object Panel1: TPanel
            Left = 0
            Top = 0
            Width = 265
            Height = 439
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 1
            inline Browser1: TBrowser
              Left = 0
              Top = 0
              Width = 265
              Height = 334
              Align = alClient
              TabOrder = 0
              TabStop = True
              inherited cbItems: TControlBar
                Width = 265
                inherited ToolBar1: TToolBar
                  Flat = True
                  inherited ToolButton6: TToolButton
                    Top = 0
                  end
                  inherited ToolButton7: TToolButton
                    Top = 0
                  end
                  inherited ToolButton8: TToolButton
                    Top = 0
                  end
                  inherited ToolButton9: TToolButton
                    Top = 0
                  end
                  inherited ToolButton3: TToolButton
                    Top = 0
                  end
                  inherited ToolButton2: TToolButton
                    Top = 0
                  end
                  inherited ToolButton1: TToolButton
                    Top = 0
                  end
                end
              end
              inherited vstBrowse: TVirtualStringTree
                Width = 265
                Height = 308
                TreeOptions.PaintOptions = [toShowButtons, toShowRoot, toShowTreeLines, toUseBlendedImages]
                OnExpanding = Browser1vstBrowseExpanding
              end
            end
            object pnlBottom: TPanel
              Left = 0
              Top = 334
              Width = 265
              Height = 105
              Align = alBottom
              BevelOuter = bvNone
              TabOrder = 1
            end
          end
        end
      end
    end
  end
  object cbMain: TControlBar
    Left = 0
    Top = 0
    Width = 816
    Height = 52
    Align = alTop
    AutoSize = True
    BevelEdges = []
    Color = clBtnFace
    ParentColor = False
    PopupMenu = pmToolbars
    TabOrder = 2
    OnPaint = cbMainPaint
    object tbMenu: TToolBar
      Left = 11
      Top = 2
      Width = 406
      Height = 22
      ButtonHeight = 21
      ButtonWidth = 59
      Caption = 'tbMenu'
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      ShowCaptions = True
      TabOrder = 0
      Wrapable = False
      object ToolButton1: TToolButton
        Left = 0
        Top = 0
        AutoSize = True
        Caption = '&Collection'
        Grouped = True
        MenuItem = File1
      end
      object ToolButton2: TToolButton
        Left = 57
        Top = 0
        AutoSize = True
        Caption = '&View'
        Grouped = True
        MenuItem = View1
      end
      object ToolButton3: TToolButton
        Left = 91
        Top = 0
        AutoSize = True
        Caption = '&Items'
        Grouped = True
        MenuItem = Items1
      end
      object ToolButton37: TToolButton
        Left = 127
        Top = 0
        AutoSize = True
        Caption = '&Tools'
        Grouped = True
        MenuItem = Actions1
      end
      object ToolButton38: TToolButton
        Left = 164
        Top = 0
        Caption = '&Wizards'
        Grouped = True
        MenuItem = Wizards1
      end
      object ToolButton4: TToolButton
        Left = 223
        Top = 0
        AutoSize = True
        Caption = '&Window'
        Grouped = True
        MenuItem = Window1
      end
      object ToolButton5: TToolButton
        Left = 273
        Top = 0
        AutoSize = True
        Caption = '&Help'
        Grouped = True
        MenuItem = Help1
      end
    end
    object tbCatalog: TToolBar
      Left = 11
      Top = 28
      Width = 102
      Height = 22
      AutoSize = True
      Caption = 'tbCatalog'
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Images = dmActions.ilMenu
      TabOrder = 1
      object ToolButton6: TToolButton
        Left = 0
        Top = 0
        Action = dmActions.FileNew
      end
      object ToolButton7: TToolButton
        Left = 23
        Top = 0
        Action = dmActions.FileOpen
      end
      object ToolButton8: TToolButton
        Left = 46
        Top = 0
        Action = dmActions.FileSave
      end
      object ToolButton33: TToolButton
        Left = 69
        Top = 0
        Width = 8
        Caption = 'ToolButton33'
        ImageIndex = 2
        Style = tbsSeparator
      end
      object ToolButton34: TToolButton
        Left = 77
        Top = 0
        Action = dmActions.ExitAction
      end
    end
    object tbViews: TToolBar
      Left = 430
      Top = 2
      Width = 122
      Height = 22
      AutoSize = True
      ButtonWidth = 24
      Caption = 'tbViews'
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Images = dmActions.ilMenu
      TabOrder = 2
      Visible = False
      object ToolButton9: TToolButton
        Left = 0
        Top = 0
        Action = dmActions.ViewThumb
      end
      object ToolButton10: TToolButton
        Left = 24
        Top = 0
        Action = dmActions.ViewLarge
      end
      object ToolButton11: TToolButton
        Left = 48
        Top = 0
        Action = dmActions.ViewSmall
      end
      object ToolButton12: TToolButton
        Left = 72
        Top = 0
        Action = dmActions.ViewList
      end
      object ToolButton13: TToolButton
        Left = 96
        Top = 0
        Action = dmActions.ViewDetail
      end
    end
    object tbSorting: TToolBar
      Left = 565
      Top = 2
      Width = 158
      Height = 22
      Caption = 'tbSorting'
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Images = dmActions.ilMenu
      TabOrder = 3
      Visible = False
      Wrapable = False
      object ToolButton19: TToolButton
        Left = 0
        Top = 0
        Action = dmActions.Randomize
      end
      object ToolButton20: TToolButton
        Left = 23
        Top = 0
        Width = 8
        Caption = 'ToolButton17'
        ImageIndex = 1
        Style = tbsSeparator
      end
      object ToolButton21: TToolButton
        Left = 31
        Top = 0
        Action = dmActions.SortName
      end
      object ToolButton22: TToolButton
        Left = 54
        Top = 0
        Action = dmActions.SortDate
      end
      object ToolButton23: TToolButton
        Left = 77
        Top = 0
        Action = dmActions.SortSize
      end
      object ToolButton24: TToolButton
        Left = 100
        Top = 0
        Action = dmActions.SortSeries
      end
      object ToolButton25: TToolButton
        Left = 123
        Top = 0
        Width = 8
        Caption = 'ToolButton22'
        ImageIndex = 5
        Style = tbsSeparator
      end
      object ToolButton26: TToolButton
        Left = 131
        Top = 0
        Action = dmActions.SortDir
      end
    end
    object tbWindows: TToolBar
      Left = 126
      Top = 28
      Width = 81
      Height = 22
      AutoSize = True
      Caption = 'tbWindows'
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Images = dmActions.ilMenu
      TabOrder = 4
      object ToolButton27: TToolButton
        Left = 0
        Top = 0
        Action = dmActions.Preview
      end
      object ToolButton28: TToolButton
        Left = 23
        Top = 0
        Width = 8
        Caption = 'ToolButton28'
        ImageIndex = 11
        Style = tbsSeparator
      end
      object ToolButton29: TToolButton
        Left = 31
        Top = 0
        Action = dmActions.SingleView
      end
      object ToolButton30: TToolButton
        Left = 54
        Top = 0
        Action = dmActions.DualView
      end
    end
    object tbActions: TToolBar
      Left = 222
      Top = 28
      Width = 203
      Height = 22
      AutoSize = True
      Caption = 'tbActions'
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Images = dmActions.ilMenu
      TabOrder = 5
      object ToolButton47: TToolButton
        Left = 0
        Top = 0
        Action = dmActions.Rotate180
      end
      object ToolButton14: TToolButton
        Left = 23
        Top = 0
        Action = dmActions.AddFolders
      end
      object ToolButton15: TToolButton
        Left = 46
        Top = 0
        Width = 8
        Caption = 'ToolButton15'
        ImageIndex = 19
        Style = tbsSeparator
      end
      object ToolButton16: TToolButton
        Left = 54
        Top = 0
        Action = dmActions.RefreshAll
      end
      object ToolButton44: TToolButton
        Left = 77
        Top = 0
        Action = dmActions.RefreshFolder
      end
      object ToolButton17: TToolButton
        Left = 100
        Top = 0
        Width = 8
        Caption = 'ToolButton17'
        ImageIndex = 34
        Style = tbsSeparator
      end
      object ToolButton18: TToolButton
        Left = 108
        Top = 0
        Action = dmActions.SlideShow
      end
      object ToolButton31: TToolButton
        Left = 131
        Top = 0
        Width = 8
        Caption = 'ToolButton31'
        ImageIndex = 33
        Style = tbsSeparator
      end
      object ToolButton32: TToolButton
        Left = 139
        Top = 0
        Action = dmActions.OptionsDlg
      end
      object ToolButton42: TToolButton
        Left = 162
        Top = 0
        Width = 8
        Caption = 'ToolButton42'
        ImageIndex = 10
        Style = tbsSeparator
      end
      object ToolButton43: TToolButton
        Left = 170
        Top = 0
        Action = dmActions.BgrProcess
      end
    end
    object tbItems: TToolBar
      Left = 736
      Top = 2
      Width = 49
      Height = 24
      AutoSize = True
      Caption = 'tbItems'
      EdgeInner = esNone
      EdgeOuter = esNone
      Images = dmActions.ilMenu
      TabOrder = 6
      Visible = False
      object ToolButton35: TToolButton
        Left = 0
        Top = 2
        Action = dmActions.ItemDelete
      end
      object ToolButton36: TToolButton
        Left = 23
        Top = 2
        Action = dmActions.ItemRemove
      end
    end
    object tbWizards: TToolBar
      Left = 454
      Top = 28
      Width = 110
      Height = 22
      Caption = 'tbWizards'
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Images = dmActions.ilMenu
      TabOrder = 7
      object ToolButton39: TToolButton
        Left = 0
        Top = 0
        Action = dmActions.EmailFriend
      end
      object ToolButton40: TToolButton
        Left = 23
        Top = 0
        Action = dmActions.CreateCD
      end
      object ToolButton41: TToolButton
        Left = 46
        Top = 0
        Action = dmActions.BuildWeb
      end
      object ToolButton45: TToolButton
        Left = 69
        Top = 0
        Width = 8
        Caption = 'ToolButton45'
        ImageIndex = 39
        Style = tbsSeparator
      end
      object ToolButton46: TToolButton
        Left = 77
        Top = 0
        Hint = 'Help me!'
        Caption = 'ToolButton46'
        ImageIndex = 48
      end
    end
  end
  object MainMenu: TMainMenu
    Images = dmActions.ilMenu
    Left = 744
    Top = 8
    object File1: TMenuItem
      Caption = '&Collection'
      object NewCatalog1: TMenuItem
        Action = dmActions.FileNew
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Open1: TMenuItem
        Action = dmActions.FileOpen
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Save1: TMenuItem
        Action = dmActions.FileSave
      end
      object SaveAs1: TMenuItem
        Action = dmActions.FileSaveAs
      end
      object Export1: TMenuItem
        Action = dmActions.FileExport
      end
      object N16: TMenuItem
        Caption = '-'
      end
      object PageSetup1: TMenuItem
        Action = dmActions.PrinterSetup
      end
      object PrintPreview1: TMenuItem
        Action = dmActions.PrintPreview
      end
      object Print1: TMenuItem
        Action = dmActions.PrintDialog
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Action = dmActions.ExitAction
      end
    end
    object View1: TMenuItem
      Caption = '&View'
      object Thumbnails1: TMenuItem
        Action = dmActions.ViewThumb
        RadioItem = True
      end
      object Largeicons1: TMenuItem
        Action = dmActions.ViewLarge
        RadioItem = True
      end
      object Smallicons1: TMenuItem
        Action = dmActions.ViewSmall
        RadioItem = True
      end
      object List1: TMenuItem
        Action = dmActions.ViewList
        RadioItem = True
      end
      object Details1: TMenuItem
        Action = dmActions.ViewDetail
        RadioItem = True
      end
      object N8: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object Cut1: TMenuItem
        Action = dmActions.Cut
        GroupIndex = 1
      end
      object Copy1: TMenuItem
        Action = dmActions.Copy
        GroupIndex = 1
      end
      object CopyImage1: TMenuItem
        Action = dmActions.CopyImage
        GroupIndex = 1
      end
      object Paste1: TMenuItem
        Action = dmActions.Paste
        GroupIndex = 1
      end
      object N5: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object RefreshAll1: TMenuItem
        Action = dmActions.RefreshAll
        GroupIndex = 1
      end
      object RefreshFolder1: TMenuItem
        Action = dmActions.RefreshFolder
        GroupIndex = 1
      end
      object N7: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object Options1: TMenuItem
        Action = dmActions.OptionsDlg
        GroupIndex = 1
      end
    end
    object Items1: TMenuItem
      Caption = '&Items'
      object SelectAll1: TMenuItem
        Action = dmActions.SelectAll
      end
      object InvertSelection1: TMenuItem
        Action = dmActions.SelectInvert
      end
      object SelectSpecial1: TMenuItem
        Caption = 'Special Selection'
        object test: TMenuItem
          Action = dmActions.SelectDupes
        end
        object DuplicatesinthisFolder1: TMenuItem
          Action = dmActions.SelectDupeFolder
        end
        object SmartSeries1: TMenuItem
        end
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object DeleteItems1: TMenuItem
        Action = dmActions.ItemDelete
      end
      object RemoveItems1: TMenuItem
        Action = dmActions.ItemRemove
      end
    end
    object Actions1: TMenuItem
      Caption = '&Tools'
      object Lossless1: TMenuItem
        Caption = 'Lossless Operations'
        object test1: TMenuItem
          Action = dmActions.RotateLeft
        end
        object RotateRight1: TMenuItem
          Action = dmActions.RotateRight
        end
        object Rotate180deg1: TMenuItem
          Action = dmActions.Rotate180
        end
        object FlipHorizontal1: TMenuItem
          Action = dmActions.FlipHor
        end
        object FlipVertical1: TMenuItem
          Action = dmActions.FlipVer
        end
        object RotateusingEXIFflag1: TMenuItem
          Action = dmActions.RotateOri
        end
      end
      object Sorting1: TMenuItem
        Caption = '&Sorting'
        object SortonName1: TMenuItem
          Action = dmActions.SortName
        end
        object SortonDate1: TMenuItem
          Action = dmActions.SortDate
        end
        object SortonSize1: TMenuItem
          Action = dmActions.SortSize
        end
        object SortonFolder1: TMenuItem
          Action = dmActions.SortFolder
        end
        object SwitchDirection1: TMenuItem
          Action = dmActions.SortDir
        end
      end
      object Rename1: TMenuItem
        Action = dmActions.Rename
      end
      object ChangeFiledate1: TMenuItem
        Action = dmActions.ChangeFiledate
      end
      object RemoveEmbeddedInfo1: TMenuItem
        Caption = 'Embedded Info Tags'
        object RemoveTags1: TMenuItem
          Caption = 'Remove Tags'
          Enabled = False
        end
        object AddTags1: TMenuItem
          Caption = 'Add Tags'
          Enabled = False
        end
      end
      object SetAsBackground1: TMenuItem
        Action = dmActions.SetAsBackground
      end
      object AddItems1: TMenuItem
        Action = dmActions.AddFolders
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object ListProcesses1: TMenuItem
        Action = dmActions.BgrProcess
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object SlideShow2: TMenuItem
        Action = dmActions.SlideShow
      end
      object N15: TMenuItem
        Caption = '-'
      end
    end
    object Wizards1: TMenuItem
      Caption = '&Wizards'
      object EmailaFriend1: TMenuItem
        Action = dmActions.EmailFriend
      end
      object CreateaCD1: TMenuItem
        Action = dmActions.CreateCD
      end
      object BuildaWeb1: TMenuItem
        Action = dmActions.BuildWeb
      end
    end
    object Window1: TMenuItem
      Caption = '&Window'
      object SingleViews1: TMenuItem
        Action = dmActions.SingleView
      end
      object DualViews1: TMenuItem
        Action = dmActions.DualView
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object Contents1: TMenuItem
        Action = dmActions.HelpContents
      end
      object WhatsThis2: TMenuItem
        Caption = '&What'#39's This?'
        ImageIndex = 48
        ShortCut = 8304
      end
      object Rename2: TMenuItem
        Action = dmActions.Tipofday
      end
      object RegisterNow1: TMenuItem
        Action = dmActions.Register
      end
      object TellaFriend1: TMenuItem
        Action = dmActions.acForum
      end
      object VisitWebpage1: TMenuItem
        Action = dmActions.GotoWeb
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Action = dmActions.About
      end
    end
  end
  object AppIcons: TImageList
    Left = 672
    Top = 33
    Bitmap = {
      494C010107000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
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
      0000000000000000000084848400848484008484840084848400848484008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000848484008484840000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484008484840084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000008484840084848400C6C6C600C6C6C60000000000C6C6C6008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00000000000000000000000000000000008484
      840084848400C6C6C600C6C6C60000000000FFFFFF00FFFFFF0000000000C6C6
      C600848484000000000000000000000000000000000000000000848484008484
      84000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF000000000000FFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000000000000000008484840084848400C6C6
      C600C6C6C6000000000084848400FFFFFF008484840000000000FFFFFF000000
      0000C6C6C600848484000000000000000000000000000000000084848400FFFF
      FF000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF000000000000FF
      FF0000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF000000000000000000C6C6C600C6C6C6008484
      840000000000FFFFFF00FFFFFF0000000000848484008484840000000000FFFF
      FF0000000000C6C6C6008484840000000000848484008484840084848400FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000084848400FFFFFF00FFFF
      FF00FFFFFF0000000000C6C6C6000000000084848400FFFFFF0084848400FFFF
      FF0084848400FFFFFF0084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      000084848400FFFFFF0000000000FFFFFF00FFFFFF00C6C6C600000000008484
      840000000000FFFFFF00000000000000000084848400FFFFFF0084848400FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF0000FFFF000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF00FFFF
      FF000000000084848400FFFFFF0084848400000000008484840000000000FFFF
      FF00FFFFFF00FFFFFF00000000000000000084848400FFFFFF0084848400FFFF
      FF000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      0000848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000008484840000000000000000000000000000000000000000008484
      840000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00C6C6C600848484000000000084848400FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000084848400FFFFFF0084848400FFFF
      FF000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      0000FFFFFF008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000000000000000000000000000084848400FFFFFF0084848400FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000008400000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      8400000084000000840000008400000084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000008400000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      8400000084000000840000008400000084000000000000000000000000008484
      8400848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000FF000000840000FFFF000084
      840000FFFF000084840000FFFF008400840084008400840084008400840000FF
      FF0000FFFF0084008400000084000000840000000000C6C6C600848484008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000FFFF000084
      84000084840000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000084
      84000084840000FFFF0000000000000000000000FF000000840000FFFF0000FF
      FF000084840000FFFF0000FFFF008400840084008400840084008400840000FF
      FF0000FFFF00840084000000840000008400C6C6C60084848400848484008484
      8400848484008484840084848400848484008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000FFFF000084
      84000084840000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000084
      84000084840000FFFF0000000000000000000000FF000000840000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00C6C6C600C6C6C600C6C6C6008400840000FF
      FF0000FFFF00840084000000840000008400C6C6C600C6C6C600848484008484
      8400848484008484840084848400848484008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000FF000000840000FFFF0000FF
      FF000084840000FFFF0000FFFF008484840084848400C6C6C600C6C6C60000FF
      FF0000FFFF00FFFF00000000840000008400C6C6C60084848400848484008484
      8400848484008484840084848400848484008484840084008400840084008400
      840084008400840084000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000FF0000008400FFFF000000FF
      FF0000FFFF0000FFFF00C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60000FF
      FF0000FFFF00FFFF00000000840000008400C6C6C600C6C6C600848484008484
      8400848484008484840084848400848484008484840084008400840084008400
      840084008400840084000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000FF0000008400FFFF0000FFFF
      000000FFFF0000FFFF00C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60000FF
      FF00FFFF0000FFFF00000000840000008400C6C6C60084848400848484008484
      8400848484008484840084848400848484008484840084008400840084008400
      84008400840084008400000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000FF0000008400FFFF0000FFFF
      000000FFFF0000FFFF000000000000000000C6C6C600000000000000000000FF
      FF00FFFF0000FFFF00000000840000008400C6C6C600C6C6C600848484008484
      8400848484008484840084848400848484008484840084008400840084008400
      84008400840084008400000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000FF0000008400FFFF0000FFFF
      000000FFFF0000FFFF00C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60000FF
      FF00FFFF0000FFFF00000000840000008400C6C6C60084848400848484008484
      8400848484008484840084848400848484008484840084008400840084008400
      84008400840084008400000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000FF0000008400FFFF0000FFFF
      000000FFFF0000FFFF00C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60000FF
      FF00FFFF0000FFFF00000000840000008400C6C6C600C6C6C600848484008484
      8400848484008484840084848400848484008484840000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000FF00000000
      00000000FF000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000FF0000008400FFFF0000FFFF
      000000FFFF0000FFFF00C6C6C60000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00FFFF0000FFFF00000000840000008400C6C6C60084848400848484000000
      0000000000000000000084848400848484008484840000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF00000000
      00000000FF000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000FF0000008400FFFF0000FFFF
      0000FFFF000000FFFF0000FFFF0000FFFF000084840000FFFF0000FFFF00FFFF
      0000FFFF0000FFFF000000008400000084008484840000000000000000008484
      8400848484008484840000000000000000008484840000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000000000000000000000FF
      0000000000000000FF000000000000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000000000000000000000000000000FF0000008400FFFF0000FFFF
      0000FFFF0000FFFF000000FFFF000084840000FFFF0000FFFF00FFFF0000FFFF
      0000FFFF0000FFFF000000008400000084000000000084848400848484008484
      8400848484008484840084848400848484000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000008400000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      8400000084000000840000008400000084000000000000000000000000008484
      8400848484008484840000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFC000000F800FE1FFC000000
      F000F80FF0000000E000E007F0000000C0008003C000000080000001C0000000
      0000000000000000000000000000000000010000000000000003800000000000
      0007C00300030000000FE00F00030000001FF03F000F000080FFF8FF000F0000
      80FFFFFF003F0000FFFFFFFF003F0000FFFF0000E3FFFC008001000080FFFC00
      800100000000F00080010000002AF000800100000000C000800100000000C000
      8001000000000000800100000000000080010000000000008001000000000000
      800100000000000380010000002A0003800100000000000FC0030000007F000F
      C003000080FF003FFFFF0000E3FF003F00000000000000000000000000000000
      000000000000}
  end
  object pmToolbars: TPopupMenu
    Left = 768
    Top = 8
    object DualViews2: TMenuItem
      Action = dmActions.MenuToolbar
    end
    object CatalogToolbar1: TMenuItem
      Action = dmActions.CatalogToolbar
    end
    object WindowsToolbar1: TMenuItem
      Action = dmActions.WindowsToolbar
    end
    object ActionsToolbar1: TMenuItem
      Action = dmActions.ActionsToolbar
    end
    object ItemsToolbar1: TMenuItem
      Action = dmActions.ItemsToolbar
    end
    object ViewsToolbar1: TMenuItem
      Action = dmActions.ViewsToolbar
    end
    object SortingToolbar1: TMenuItem
      Action = dmActions.SortingToolbar
    end
  end
  object HelpRouter1: THelpRouter
    HelpType = htMixedMode
    ShowType = stMain
    CHMPopupTopics = 'CSHelp.txt'
    ValidateID = False
    Left = 640
    Top = 32
  end
  object tmMain: TTimer
    Enabled = False
    Interval = 100
    Left = 584
    Top = 32
  end
end
