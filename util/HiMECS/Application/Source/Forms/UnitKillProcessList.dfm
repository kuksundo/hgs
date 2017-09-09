object KillProcessListF: TKillProcessListF
  Left = 0
  Top = 0
  Caption = 'Kill Process List'
  ClientHeight = 459
  ClientWidth = 303
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 392
    Width = 303
    Height = 67
    Align = alBottom
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 32
      Top = 16
      Width = 97
      Height = 41
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 176
      Top = 16
      Width = 97
      Height = 41
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 303
    Height = 67
    Align = alTop
    TabOrder = 1
    object Button1: TButton
      Left = 54
      Top = 36
      Width = 75
      Height = 25
      Caption = 'Add'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Edit1: TEdit
      Left = 16
      Top = 8
      Width = 275
      Height = 21
      ImeName = 'Microsoft IME 2010'
      TabOrder = 1
    end
    object Button2: TButton
      Left = 176
      Top = 36
      Width = 75
      Height = 25
      Caption = 'Delete'
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object ProcessLB: TCheckListBox
    Left = 0
    Top = 67
    Width = 303
    Height = 325
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = 'Microsoft IME 2010'
    ParentFont = False
    PopupMenu = PopupMenu1
    TabOrder = 2
  end
  object PopupMenu1: TPopupMenu
    Left = 16
    Top = 32
    object SelectAll1: TMenuItem
      Caption = 'Checked All'
      OnClick = SelectAll1Click
    end
    object CheckedOnlySelected1: TMenuItem
      Caption = 'Checked Only Selected'
      OnClick = CheckedOnlySelected1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object DeCheckedAll1: TMenuItem
      Caption = 'DeChecked All'
      OnClick = DeCheckedAll1Click
    end
    object DeCheckedOnlySelected1: TMenuItem
      Caption = 'DeChecked Only Selected'
      OnClick = DeCheckedOnlySelected1Click
    end
  end
end
