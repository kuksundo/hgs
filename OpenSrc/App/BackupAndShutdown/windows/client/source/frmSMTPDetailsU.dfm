object frmSMTPDetails: TfrmSMTPDetails
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'SMTP Details'
  ClientHeight = 228
  ClientWidth = 499
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 194
    Width = 499
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object JvXPButton1: TBitBtn
      AlignWithMargins = True
      Left = 344
      Top = 3
      Width = 73
      Height = 28
      Action = ActionOk
      Align = alRight
      Caption = 'Ok'
      Spacing = 3
      TabOrder = 0
      WordWrap = True
      ExplicitLeft = 335
      ExplicitTop = 4
      ExplicitHeight = 24
    end
    object JvXPButton2: TBitBtn
      AlignWithMargins = True
      Left = 423
      Top = 3
      Width = 73
      Height = 28
      Action = ActionCancel
      Align = alRight
      Caption = 'Cancel'
      Spacing = 3
      TabOrder = 1
      WordWrap = True
      ExplicitLeft = 414
      ExplicitTop = 4
      ExplicitHeight = 24
    end
  end
  object pnlDetails: TPanel
    Left = 0
    Top = 0
    Width = 499
    Height = 194
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    TabOrder = 0
    object GroupBoxSMTPDetails: TGroupBox
      Left = 10
      Top = 10
      Width = 479
      Height = 174
      Align = alClient
      Caption = 'SMTP Details'
      TabOrder = 0
      object Label11: TLabel
        Left = 337
        Top = 21
        Width = 49
        Height = 13
        Caption = 'SMTP Port'
      end
      object editSMTPServer: TLabeledEdit
        Left = 10
        Top = 38
        Width = 318
        Height = 21
        EditLabel.Width = 61
        EditLabel.Height = 13
        EditLabel.Caption = 'SMTP Server'
        TabOrder = 1
      end
      object editSMTPPort: TSpinEdit
        Left = 334
        Top = 37
        Width = 133
        Height = 22
        MaxValue = 1000000
        MinValue = 0
        TabOrder = 0
        Value = 0
      end
      object editSMTPPassword: TLabeledEdit
        Left = 169
        Top = 108
        Width = 153
        Height = 20
        EditLabel.Width = 46
        EditLabel.Height = 13
        EditLabel.Caption = 'Password'
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
        PasswordChar = 'l'
        TabOrder = 4
      end
      object editSMTPUsername: TLabeledEdit
        Left = 10
        Top = 108
        Width = 153
        Height = 21
        EditLabel.Width = 48
        EditLabel.Height = 13
        EditLabel.Caption = 'Username'
        TabOrder = 3
      end
      object cbSMTPSecure: TCheckBox
        Left = 10
        Top = 136
        Width = 125
        Height = 17
        Caption = 'Secure Connection'
        TabOrder = 5
      end
      object cbSMTPAuthentication: TCheckBox
        Left = 10
        Top = 70
        Width = 125
        Height = 17
        Caption = 'SMTP Authentication'
        TabOrder = 2
      end
    end
  end
  object ActionListSMTPDetails: TActionList
    Left = 8
    Top = 16
    object ActionOk: TAction
      Caption = 'Ok'
      OnExecute = ActionOkExecute
    end
    object ActionCancel: TAction
      Caption = 'Cancel'
      OnExecute = ActionCancelExecute
    end
  end
end
