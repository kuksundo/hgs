inherited ImportAcctDlg: TImportAcctDlg
  BorderStyle = bsSizeable
  Caption = 'Import Account(s)'
  ClientHeight = 244
  ClientWidth = 492
  ExplicitWidth = 508
  ExplicitHeight = 282
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Width = 390
    Height = 227
    Anchors = [akLeft, akTop, akRight, akBottom]
    ExplicitWidth = 390
    ExplicitHeight = 237
  end
  object Label1: TLabel [1]
    Left = 20
    Top = 18
    Width = 151
    Height = 13
    Caption = 'Select Accounts to Import:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  inherited OKBtn: TButton
    Left = 409
    Anchors = [akTop, akRight]
    ExplicitLeft = 409
  end
  inherited CancelBtn: TButton
    Left = 409
    Anchors = [akTop, akRight]
    ExplicitLeft = 409
  end
  object HelpBtn: TButton
    Left = 409
    Top = 68
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Help'
    TabOrder = 2
    OnClick = HelpBtnClick
  end
  object ListViewAccounts: TListView
    Left = 20
    Top = 38
    Width = 366
    Height = 184
    Anchors = [akLeft, akTop, akRight, akBottom]
    Checkboxes = True
    Columns = <
      item
        Caption = 'Account'
        Width = 120
      end
      item
        Caption = 'Server'
        Width = 120
      end
      item
        Caption = 'Username'
        Width = 120
      end>
    Items.ItemData = {
      05BC0000000400000000000000FFFFFFFFFFFFFFFF02000000FFFFFFFF000000
      000461006300630031000E69006D00610070002E0067006D00610069006C002E
      0063006F006D006000471C116500780061006D0070006C006500400067006D00
      610069006C002E0063006F006D003803471C00000000FFFFFFFFFFFFFFFF0000
      0000FFFFFFFF000000000000000000FFFFFFFFFFFFFFFF00000000FFFFFFFF00
      0000000000000000FFFFFFFFFFFFFFFF00000000FFFFFFFF0000000000FFFFFF
      FF}
    TabOrder = 3
    ViewStyle = vsReport
  end
  object chkSelAll: TCheckBox
    Left = 307
    Top = 15
    Width = 79
    Height = 17
    Alignment = taLeftJustify
    Anchors = [akTop, akRight]
    BiDiMode = bdLeftToRight
    Caption = 'All Accounts'
    ParentBiDiMode = False
    TabOrder = 4
    OnClick = chkSelAllClick
  end
end
