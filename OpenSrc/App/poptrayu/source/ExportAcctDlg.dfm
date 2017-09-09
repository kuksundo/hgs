inherited ExportAccountsDlg: TExportAccountsDlg
  BorderStyle = bsSizeable
  Caption = 'Export Account(s)'
  ClientHeight = 288
  ClientWidth = 526
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 542
  ExplicitHeight = 326
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Width = 427
    Height = 270
    Anchors = [akLeft, akTop, akRight, akBottom]
    ExplicitWidth = 437
    ExplicitHeight = 280
  end
  object Label1: TLabel [1]
    Left = 20
    Top = 18
    Width = 148
    Height = 13
    Caption = 'Select Accounts to Export:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  inherited OKBtn: TButton
    Left = 442
    Anchors = [akTop, akRight]
    OnClick = OKBtnClick
    ExplicitLeft = 442
  end
  inherited CancelBtn: TButton
    Left = 442
    Anchors = [akTop, akRight]
    ExplicitLeft = 442
  end
  object HelpBtn: TButton
    Left = 442
    Top = 68
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Help'
    Enabled = False
    TabOrder = 2
    OnClick = HelpBtnClick
  end
  object chkIncludePw: TCheckBox
    Left = 20
    Top = 250
    Width = 254
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Include Saved Passwords'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object ListViewAccounts: TListView
    Left = 20
    Top = 39
    Width = 403
    Height = 205
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
    TabOrder = 4
    ViewStyle = vsReport
    ExplicitWidth = 413
    ExplicitHeight = 215
  end
  object chkSelAll: TCheckBox
    Left = 344
    Top = 16
    Width = 79
    Height = 17
    Alignment = taLeftJustify
    Anchors = [akTop, akRight]
    BiDiMode = bdLeftToRight
    Caption = 'All Accounts'
    ParentBiDiMode = False
    TabOrder = 5
    OnClick = chkSelAllClick
  end
end
