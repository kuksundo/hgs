object InfoForm: TInfoForm
  Left = 589
  Top = 240
  ActiveControl = BClose
  AutoScroll = False
  BorderIcons = []
  Caption = 'InfoForm'
  ClientHeight = 315
  ClientWidth = 300
  Color = clBtnFace
  Constraints.MinHeight = 112
  Constraints.MinWidth = 200
  DefaultMonitor = dmMainForm
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnResize = TntFormResize
  OnShow = FormShow
  DesignSize = (
    300
    315)
  PixelsPerInch = 96
  TextHeight = 13
  object InfoBox: TTntListBox
    Left = 4
    Top = 4
    Width = 292
    Height = 277
    Style = lbOwnerDrawFixed
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 16
    TabOrder = 0
    OnDrawItem = InfoBoxDrawItem
  end
  object BClose: TTntButton
    Left = 221
    Top = 286
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    Default = True
    TabOrder = 1
    OnClick = BCloseClick
  end
  object TCB: TTntButton
    Left = 5
    Top = 286
    Width = 89
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Copy Info'
    Default = True
    TabOrder = 2
    OnClick = TCBClick
  end
end
