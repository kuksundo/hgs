object frmBackupProgress: TfrmBackupProgress
  Left = 226
  Top = 106
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Please Wait, Backup in progress...'
  ClientHeight = 213
  ClientWidth = 487
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PopupMode = pmAuto
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 487
    Height = 213
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    object Panel1: TPanel
      Left = 2
      Top = 32
      Width = 483
      Height = 179
      BevelOuter = bvNone
      BorderWidth = 5
      TabOrder = 1
      object pnlProgress: TPanel
        Left = 65
        Top = 5
        Width = 413
        Height = 169
        Align = alClient
        BevelKind = bkTile
        BevelOuter = bvNone
        TabOrder = 1
        OnMouseDown = pnlProgressMouseDown
        object lblBackupProgress: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 62
          Width = 403
          Height = 43
          Align = alTop
          AutoSize = False
          Caption = 'Please Wait...'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Calibri Light'
          Font.Style = []
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          WordWrap = True
          ExplicitLeft = 13
          ExplicitTop = 54
          ExplicitWidth = 364
        end
        object lblProfileProgress: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 403
          Height = 33
          Align = alTop
          AutoSize = False
          Caption = 'Gathering profile information...'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Calibri Light'
          Font.Style = []
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          WordWrap = True
          ExplicitLeft = 14
          ExplicitTop = -1
          ExplicitWidth = 340
        end
        object ProgressBarProfile: TProgressBar
          AlignWithMargins = True
          Left = 3
          Top = 39
          Width = 403
          Height = 17
          Align = alTop
          TabOrder = 0
        end
        object ProgressBarBackup: TProgressBar
          AlignWithMargins = True
          Left = 3
          Top = 108
          Width = 403
          Height = 17
          Align = alTop
          TabOrder = 1
        end
        object Panel2: TPanel
          Left = 0
          Top = 128
          Width = 409
          Height = 37
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          object btnCancel: TBitBtn
            AlignWithMargins = True
            Left = 331
            Top = 3
            Width = 75
            Height = 31
            Action = ActionCancel
            Align = alRight
            Caption = 'Cancel'
            TabOrder = 2
          end
          object btnHide: TBitBtn
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 75
            Height = 31
            Action = ActionHide
            Align = alLeft
            Caption = 'Hide'
            TabOrder = 1
          end
          object Panel3: TPanel
            Left = 81
            Top = 0
            Width = 247
            Height = 37
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object lblTimeElapsed: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 241
              Height = 15
              Align = alTop
              Alignment = taCenter
              AutoSize = False
              Caption = 'Calculating...'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -8
              Font.Name = 'Small Fonts'
              Font.Style = []
              ParentFont = False
              Transparent = True
              Layout = tlCenter
              ExplicitLeft = 77
              ExplicitTop = 4
              ExplicitWidth = 170
            end
            object lblTimeRemaining: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 22
              Width = 241
              Height = 15
              Align = alBottom
              Alignment = taCenter
              AutoSize = False
              Caption = 'Calculating...'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -8
              Font.Name = 'Small Fonts'
              Font.Style = []
              ParentFont = False
              Transparent = True
              Layout = tlCenter
              ExplicitTop = 21
            end
          end
        end
      end
      object pnlTotalProgress: TPanel
        Left = 5
        Top = 5
        Width = 60
        Height = 169
        Align = alLeft
        BevelKind = bkTile
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        OnMouseDown = pnlProgressMouseDown
        object lblTotalProgress: TJvLabel
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 18
          Height = 149
          Align = alLeft
          AutoSize = False
          Caption = '0% Complete'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Calibri Light'
          Font.Style = []
          Layout = tlCenter
          ParentFont = False
          Transparent = True
          Angle = 90
          AutoOpenURL = False
          ExplicitLeft = 5
          ExplicitTop = 5
          ExplicitHeight = 137
        end
        object ProgressBarTotal: TJvProgressBar
          AlignWithMargins = True
          Left = 32
          Top = 8
          Width = 16
          Height = 149
          Align = alClient
          Orientation = pbVertical
          TabOrder = 0
        end
      end
    end
    object ImgHeader: TPanel
      Left = 2
      Top = 2
      Width = 483
      Height = 30
      Align = alTop
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      OnMouseDown = pnlProgressMouseDown
      object Image1: TImage
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 24
        Height = 22
        Align = alLeft
        AutoSize = True
        Center = True
        Picture.Data = {
          07544269746D6170F6060000424DF60600000000000036000000280000001800
          0000180000000100180000000000C00600000000000000000000000000000000
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEE6E6E6DEDEDEDEDEDEDE
          DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE
          DEDEDEDEDEDEDEDEDEE6E6E6EEEEEEFFFFFFFFFFFFFFFFFFC5C5C50000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000413129000000A4A4A4E6E6E6FFFFFFFFFFFFCDCDCD
          1010086A5A4A7B6A5A625A529C9CA4B4BDBDACB4B4C5C5CDC5C5CDCDD5D5DEDE
          E6E6E6E6D5DEDEACB4B44A4A4173624A73624AD5C59C413939000000DEDEDEFF
          FFFFFFFFFF0000009C8B739C8B6A9C8362393931CDD5D5CDD5D5414A4A414A4A
          414A4AB4BDBDC5CDCDDEE6E6E6EEEEDEE6E652524173624A7B624ADEBDA44139
          39000000DEDEDEFFFFFFFFFFFF000000DEC5A4A48B6AA48B73414139DEDEDEE6
          E6EE4A4A52414A52414A52BDC5C5B4BDBDC5C5CDDEDEDEE6E6E65A524A7B6A4A
          836A4ADEC5A4414139000000DEDEDEFFFFFFFFFFFF000000DEC5A4A48B6AA48B
          734A4A41DEDEDEEEEEEE5A626A4A52524A5252C5CDCDB4BDC5B4BDBDBDC5CDD5
          DEDE5A524A7B6A4A836A52DECDBD4A4131000000DEDEDEFFFFFFFFFFFF000000
          DEC5ACA48B6AA48B6A4A4A41D5D5DEDEE6E65A626A4A52524A5252D5D5D5BDC5
          C5B4BDBDACB4B4C5CDCD524A417B6A4A836A52DECDB44A4131000000DEDEDEFF
          FFFFFFFFFF000000DEC5ACAC9473A48B6A5A524A8B9494DEDEDEDEDEE6E6E6EE
          E6E6EEE6E6E6DEDEDEC5CDCDBDC5C58B949C6A62527B624A8B7352DEC5AC4A4A
          31000000DEDEDEFFFFFFFFFFFF000000DEC5ACAC9473AC946AAC94734A4A4152
          4A41625A527B6A62736A62736A5A6A625A6A625A6A625A625A526252394A4139
          B4947BCDB4A4524A39000000DEDEDEFFFFFFFFFFFF000000DEC5ACAC9473B49C
          83B49C83B4A483B49C83B49C7BB49C7BB49C83B4947BB4A483B4A483B4A483BD
          A483B49C83BDA48BB49C83BDA48B5A4A39000000DEDEDEFFFFFFFFFFFF000000
          E6CDACB49C7B9C8B7B7B7B7B737373737373737373737373737373736A6A6A6A
          6A7373737373737373737373736A6A6A7B736AB4A4835A5239000000DEDEDEFF
          FFFFFFFFFF000000E6CDACB4A4835A5A73FFFFFFFFFFFFFFFFFFFFFFFFDEDEDE
          CDBDBDCDACACD5BDC5DEDEDEFFFFFFFFFFFFFFFFFFFFFFFF737373B49C83625A
          52000000DEDEDEFFFFFFFFFFFF000000E6CDACB49C7B737373FFFFFFFFFFFFFF
          FFFFB4B4B4B4AC9C8341317320087B4A31C59C9CB4B4B4FFFFFFFFFFFFFFFFFF
          737373BDA4836A6252000000DEDEDEFFFFFFFFFFFF000000E6CDB4B4A47B7373
          73FFFFFFFFFFFFFFFFFFC5B4B4735229413100395A00008B007B5A39C5B4BDFF
          FFFFFFFFFFFFFFFF737373BDA4836A5A41000000DEDEDEFFFFFFFFFFFF000000
          E6D5B4BD9C83626262FFFFFFFFFFFFFFFFFFC5A4A45241085239006A3108207B
          005A4A10C5A4ACFFFFFFFFFFFFFFFFFF737373BDA48B735A4A000000DEDEDEFF
          FFFFFFFFFF000000E6D5B4BDA483737373FFFFFFFFFFFFFFFFFFBDA4AC5A7329
          0094002973005220009C3131B4ACACFFFFFFFFFFFFFFFFFF737373BDA48B7362
          4A000000DEDEDEFFFFFFFFFFFF000000E6D5B4BDA483737373FFFFFFFFFFFFFF
          FFFFDEDEDEACAC944A8B31316A086A6231C59C9CDEDEDEFFFFFFFFFFFFFFFFFF
          737373B49C837B6A52000000DEDEDEFFFFFFFFFFFF000000E6D5B4BDAC837373
          73FFFFFFFFFFFFFFFFFFFFFFFFDEDEDEC5B4BDC5A4A4C5B4BDDEDEDEFFFFFFFF
          FFFFFFFFFFFFFFFF737373B49C83836A52000000DEDEDEFFFFFFFFFFFF000000
          E6D5BDC5A48B73626A7B83C5737BCD737BCD737BCD737BCD737BCD626ABD737B
          CD626ABD737BCD5A62C55A62C56A6ABD73626AB49C83837352000000DEDEDEFF
          FFFFFFFFFF000000E6D5BDC5AC8B6A62627B8BDE6A83DE6A83DE6A7BDE7383DE
          6A7BDE7383D56A7BD56273CD6273CD6A73CD5A6AC55A62C56A6262B4A4838373
          52000000E6E6E6FFFFFFFFFFFF000000F6D5C5E6CDAC7B7373BDC5EEBDC5EEBD
          C5EEB4BDEEB4BDEEB4BDEEB4BDEEACB4E6ACB4E6ACB4E6ACB4E6B4B4E6BDBDE6
          737373E6CDB4D5BDA4000000EEEEEEFFFFFFFFFFFFACACAC0000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000A4A4A4FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFF}
        Transparent = True
        OnMouseDown = pnlProgressMouseDown
        ExplicitLeft = 1
        ExplicitTop = 1
        ExplicitHeight = 24
      end
      object lblProfileName: TLabel
        AlignWithMargins = True
        Left = 34
        Top = 4
        Width = 445
        Height = 25
        Align = alClient
        AutoSize = False
        Caption = 'Please Wait, Backup in progress...'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnMouseDown = pnlProgressMouseDown
        ExplicitTop = 2
      end
    end
  end
  object ActionListProgress: TActionList
    Left = 16
    Top = 38
    object ActionCancel: TAction
      Caption = 'Cancel'
      OnExecute = ActionCancelExecute
      OnUpdate = ActionCancelUpdate
    end
    object ActionHide: TAction
      Caption = 'Hide'
      OnExecute = ActionHideExecute
      OnUpdate = ActionHideUpdate
    end
  end
end
