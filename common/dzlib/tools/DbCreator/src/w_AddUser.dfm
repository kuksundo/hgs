object f_AddUser: Tf_AddUser
  Left = 419
  Top = 258
  Caption = 'f_AddUser'
  ClientHeight = 158
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 132
    Width = 77
    Height = 13
    Caption = 'Database Name'
  end
  object grp_User: TGroupBox
    Left = 0
    Top = 0
    Width = 273
    Height = 97
    Caption = 'User'
    TabOrder = 0
    DesignSize = (
      273
      97)
    object Label2: TLabel
      Left = 8
      Top = 44
      Width = 28
      Height = 13
      Caption = 'Name'
    end
    object Label3: TLabel
      Left = 8
      Top = 68
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object chk_AddUser: TCheckBox
      Left = 8
      Top = 16
      Width = 257
      Height = 17
      Caption = 'Add user'
      TabOrder = 0
      OnClick = chk_AddUserClick
    end
    object ed_Username: TEdit
      Left = 64
      Top = 40
      Width = 201
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 1
      OnChange = ed_UsernameChange
    end
    object ed_Password: TEdit
      Left = 64
      Top = 64
      Width = 201
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 2
    end
  end
  object ed_DatabaseName: TEdit
    Left = 96
    Top = 128
    Width = 169
    Height = 21
    Enabled = False
    TabOrder = 2
  end
  object chk_DbEquUser: TCheckBox
    Left = 8
    Top = 104
    Width = 249
    Height = 17
    Caption = 'Database name like user name'
    Checked = True
    State = cbChecked
    TabOrder = 1
    OnClick = chk_DbEquUserClick
  end
  object TheFormStorage: TJvFormStorage
    AppStoragePath = 'f_AddUser'
    Options = []
    StoredProps.Strings = (
      'ed_Username.Text'
      'ed_Password.Text'
      'chk_DbEquUser.Checked')
    StoredValues = <>
    Left = 40
    Top = 40
  end
end
