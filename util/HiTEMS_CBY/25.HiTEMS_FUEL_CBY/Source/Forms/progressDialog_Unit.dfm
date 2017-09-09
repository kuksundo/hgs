object progressDialog_Frm: TprogressDialog_Frm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'progressDialog_Frm'
  ClientHeight = 152
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object AdvCircularProgress1: TAdvCircularProgress
    Left = 117
    Top = 37
    Width = 60
    Height = 60
    Appearance.BackGroundColor = clNone
    Appearance.BorderColor = clNone
    Appearance.ActiveSegmentColor = 16752543
    Appearance.InActiveSegmentColor = clSilver
    Appearance.TransitionSegmentColor = 10485760
    Appearance.ProgressSegmentColor = 4194432
    Interval = 100
  end
  object Label1: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 105
    Width = 289
    Height = 17
    Margins.Bottom = 30
    Align = alBottom
    Alignment = taCenter
    Caption = 'elapsed : 0 sec'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #47569#51008' '#44256#46357
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 92
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 240
    Top = 16
  end
end
