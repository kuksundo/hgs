object frmWorkshop: TfrmWorkshop
  Left = 268
  Top = 272
  Width = 725
  Height = 672
  Caption = 'Shape Workshop'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mmWorkshop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 281
    Top = 0
    Width = 6
    Height = 599
    Beveled = True
  end
  object sbWorkshop: TStatusBar
    Left = 0
    Top = 599
    Width = 717
    Height = 19
    Panels = <>
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 281
    Height = 599
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 0
      Top = 186
      Width = 281
      Height = 6
      Cursor = crVSplit
      Align = alTop
      Beveled = True
    end
    object pnlExample: TPanel
      Left = 0
      Top = 25
      Width = 281
      Height = 161
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
    end
    object pnlTitle: TPanel
      Left = 0
      Top = 0
      Width = 281
      Height = 25
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = ' Preview of Shape'
      Color = clBtnShadow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object pnlControls: TPanel
      Left = 0
      Top = 192
      Width = 281
      Height = 407
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        281
        407)
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 76
        Height = 13
        Caption = 'Installed Masks:'
      end
      object Label2: TLabel
        Left = 168
        Top = 8
        Width = 80
        Height = 13
        Caption = 'Available Masks:'
      end
      object clbInstalled: TCheckListBox
        Left = 8
        Top = 24
        Width = 105
        Height = 105
        ItemHeight = 13
        TabOrder = 0
        OnClick = clbInstalledClick
      end
      object btnAddMask: TButton
        Left = 120
        Top = 24
        Width = 41
        Height = 25
        Caption = '<'
        TabOrder = 1
        OnClick = btnAddMaskClick
      end
      object btnRemoveMask: TButton
        Left = 120
        Top = 51
        Width = 41
        Height = 25
        Caption = '>'
        TabOrder = 2
        OnClick = btnRemoveMaskClick
      end
      object btnMaskUp: TButton
        Left = 120
        Top = 77
        Width = 41
        Height = 25
        Caption = 'Up'
        TabOrder = 3
        OnClick = btnMaskUpClick
      end
      object btnMaskDn: TButton
        Left = 120
        Top = 104
        Width = 41
        Height = 25
        Caption = 'Dn'
        TabOrder = 4
        OnClick = btnMaskDnClick
      end
      object lbAvailable: TListBox
        Left = 168
        Top = 24
        Width = 105
        Height = 105
        ItemHeight = 13
        TabOrder = 5
      end
      object pnlMask: TPanel
        Left = 0
        Top = 136
        Width = 281
        Height = 277
        Anchors = [akLeft, akTop, akBottom]
        BevelOuter = bvNone
        TabOrder = 6
      end
    end
  end
  object alWorkshop: TActionList
    Left = 632
    Top = 8
    object acReturnAccept: TAction
      Caption = 'Return and accept'
      Hint = 'Return and accept changes'
      OnExecute = acReturnAcceptExecute
    end
    object acReturnCancel: TAction
      Caption = 'Return and cancel'
      Hint = 'Return and cancel changes'
      OnExecute = acReturnCancelExecute
    end
  end
  object mmWorkshop: TMainMenu
    Left = 608
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object acReturnAccept1: TMenuItem
        Action = acReturnAccept
      end
      object acReturnCancel1: TMenuItem
        Action = acReturnCancel
      end
    end
  end
  object tiUpdateExample: TTimer
    Interval = 300
    OnTimer = tiUpdateExampleTimer
    Left = 664
    Top = 8
  end
end
