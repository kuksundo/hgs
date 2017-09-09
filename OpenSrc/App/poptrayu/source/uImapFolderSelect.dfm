inherited ImapFolderSelectDlg: TImapFolderSelectDlg
  Anchors = [akTop]
  BorderStyle = bsSizeable
  Caption = 'Select IMAP Folder'
  ClientHeight = 285
  ClientWidth = 385
  ExplicitWidth = 401
  ExplicitHeight = 323
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Height = 343
    Visible = False
    ExplicitHeight = 343
  end
  inherited OKBtn: TButton
    Anchors = [akTop, akRight]
  end
  inherited CancelBtn: TButton
    Anchors = [akTop, akRight]
  end
  object HelpBtn: TButton
    Left = 300
    Top = 68
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Help'
    TabOrder = 2
    OnClick = HelpBtnClick
  end
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 282
    Height = 267
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 3
  end
end
