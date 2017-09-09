object ScrMain: TScrMain
  Left = 368
  Top = 101
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Bildschirmschoner Kontrollfenster'
  ClientHeight = 321
  ClientWidth = 402
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LScrDoc: TLabel
    Left = 8
    Top = 32
    Width = 385
    Height = 17
    AutoSize = False
    Caption = 'Bilderschau-&Dokument'
  end
  object LDebugInfo: TLabel
    Left = 8
    Top = 152
    Width = 207
    Height = 13
    Caption = 'Bildschirmschoner Programm-&Informationen'
    FocusControl = SGDebugInfo
  end
  object EFScrDoc: TEdit
    Left = 8
    Top = 48
    Width = 385
    Height = 21
    AutoSize = False
    TabOrder = 1
    Text = 'EFScrDoc'
    OnChange = EFScrDocChange
  end
  object CBServerLoaded: TCheckBox
    Left = 8
    Top = 8
    Width = 385
    Height = 17
    Caption = 'Karsten Bilderschau ge&laden'
    TabOrder = 0
    OnClick = CBServerLoadedClick
  end
  object BUpdate: TButton
    Left = 8
    Top = 288
    Width = 113
    Height = 25
    Caption = 'Anzeige &aktualisieren'
    TabOrder = 3
    OnClick = BUpdateClick
  end
  object BClose: TButton
    Left = 280
    Top = 288
    Width = 113
    Height = 25
    Caption = '&Schliessen'
    Default = True
    TabOrder = 4
    OnClick = BCloseClick
  end
  object SGDebugInfo: TStringGrid
    Left = 8
    Top = 168
    Width = 385
    Height = 105
    ColCount = 2
    DefaultColWidth = 190
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 8
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
