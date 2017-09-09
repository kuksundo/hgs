object f_LogWindow: Tf_LogWindow
  Left = 478
  Top = 215
  Width = 866
  Height = 605
  Caption = 'AccessExport - LogWindow'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ld_LogDisplay: THkLogDisplay
    Left = 0
    Top = 0
    Width = 858
    Height = 581
    Align = alClient
    TabOrder = 0
    TimeCaption = 'Time'
    LevelCaption = 'Level'
    MessageCaption = 'Message'
    MinLogLevel = llDebug
  end
end
