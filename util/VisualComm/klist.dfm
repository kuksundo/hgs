object keylist: Tkeylist
  Left = 287
  Top = 207
  BorderStyle = bsToolWindow
  Caption = 'Keyboard shortcuts'
  ClientHeight = 252
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 354
    Height = 211
    Align = alClient
    ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
    Lines.Strings = (
      'Editor Key:'
      ''
      'Ctrl + Arrow Key: move a selected component to direction'
      ''
      'Shift + Arrow Key: Change the selected component size '
      ''
      'Shift + Mouse Left Button: Multi-Select the components'
      '')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 211
    Width = 354
    Height = 41
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 264
      Top = 8
      Width = 73
      Height = 25
      Cancel = True
      Caption = '&Close'
      Default = True
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
