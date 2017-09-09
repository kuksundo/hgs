object frmConfig: TfrmConfig
  Left = 201
  Top = 109
  BorderStyle = bsDialog
  Caption = 'FTP'
  ClientHeight = 264
  ClientWidth = 414
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 223
    Width = 414
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Label2: TLabel
      Left = 0
      Top = 0
      Width = 96
      Height = 41
      Align = alLeft
      Caption = 'Little Earth Solutions'
      Layout = tlCenter
      ExplicitLeft = 8
      ExplicitTop = 18
      ExplicitHeight = 13
    end
    object btnCancel: TBitBtn
      AlignWithMargins = True
      Left = 336
      Top = 3
      Width = 75
      Height = 35
      Align = alRight
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 333
      ExplicitTop = 6
      ExplicitHeight = 25
    end
    object btnOk: TBitBtn
      AlignWithMargins = True
      Left = 255
      Top = 3
      Width = 75
      Height = 35
      Align = alRight
      Caption = 'Ok'
      ModalResult = 1
      TabOrder = 0
      ExplicitLeft = 253
      ExplicitTop = 6
      ExplicitHeight = 25
    end
  end
  object GroupBoxGeneral: TGroupBox
    Left = 0
    Top = 0
    Width = 414
    Height = 223
    Align = alClient
    Caption = 'General'
    TabOrder = 0
    DesignSize = (
      414
      223)
    object lblProfileName: TLabel
      Left = 160
      Top = 12
      Width = 248
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'No Profile Name Specified'
    end
    object cbEnabled: TCheckBox
      Left = 8
      Top = 28
      Width = 65
      Height = 17
      Caption = 'Enabled'
      TabOrder = 0
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 52
      Width = 397
      Height = 162
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'FTP Settings'
      TabOrder = 1
      object Label1: TLabel
        Left = 139
        Top = 28
        Width = 42
        Height = 13
        Caption = 'FTP Port'
      end
      object editFTPServer: TLabeledEdit
        Left = 12
        Top = 42
        Width = 121
        Height = 21
        EditLabel.Width = 54
        EditLabel.Height = 13
        EditLabel.Caption = 'FTP Server'
        TabOrder = 1
      end
      object editFTPPort: TJvSpinEdit
        Left = 139
        Top = 42
        Width = 121
        Height = 21
        TabOrder = 2
      end
      object editFTPRemotePath: TLabeledEdit
        Left = 12
        Top = 80
        Width = 371
        Height = 21
        EditLabel.Width = 62
        EditLabel.Height = 13
        EditLabel.Caption = 'Remote Path'
        TabOrder = 3
      end
      object editFTPUserName: TLabeledEdit
        Left = 12
        Top = 118
        Width = 121
        Height = 21
        EditLabel.Width = 48
        EditLabel.Height = 13
        EditLabel.Caption = 'Username'
        TabOrder = 4
      end
      object editFTPPassword: TLabeledEdit
        Left = 136
        Top = 118
        Width = 121
        Height = 21
        EditLabel.Width = 46
        EditLabel.Height = 13
        EditLabel.Caption = 'Password'
        PasswordChar = '*'
        TabOrder = 5
      end
      object cbPassive: TCheckBox
        Left = 276
        Top = 28
        Width = 65
        Height = 17
        Caption = 'Passive'
        TabOrder = 0
      end
    end
  end
  object ActionListConfig: TActionList
    Left = 252
    Top = 12
  end
end
