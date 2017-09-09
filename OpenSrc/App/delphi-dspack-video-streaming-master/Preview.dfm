object frmPreview: TfrmPreview
  Left = 215
  Top = 123
  BorderStyle = bsSingle
  Caption = 'Preview'
  ClientHeight = 240
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object VideoWindow: TVideoWindow
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    FilterGraph = dmMain.fgMain
    VMROptions.Mode = vmrWindowed
    VMROptions.Streams = 1
    VMROptions.Preferences = []
    Color = clBlack
    Align = alClient
  end
end
