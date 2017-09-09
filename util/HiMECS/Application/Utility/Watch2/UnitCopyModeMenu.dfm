object CopyModeMenuF: TCopyModeMenuF
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Select Copy Mode'
  ClientHeight = 84
  ClientWidth = 179
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object JvItemsPanel1: TJvItemsPanel
    Left = 0
    Top = 0
    Width = 179
    Height = 84
    DotNetHighlighting = True
    AutoGrow = False
    AutoSize = False
    Items.Strings = (
      'Copy None Exist Item(s)'
      'Copy Existing Item(s) Overwrite'
      'Copy All Item(s) Add or Overwrite'
      'Copy Cancel')
    ItemHeight = 20
    HotTrack = True
    OnItemClick = JvItemsPanel1ItemClick
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 60
  end
end
