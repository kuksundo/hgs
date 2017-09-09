object f_dzDialog: Tf_dzDialog
  Left = 460
  Top = 203
  BorderIcons = [biSystemMenu]
  Caption = 'f_dzDialog'
  ClientHeight = 420
  ClientWidth = 423
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object p_Top: TPanel
    Left = 0
    Top = 0
    Width = 423
    Height = 217
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object l_Message: TLabel
      Left = 64
      Top = 8
      Width = 329
      Height = 81
      AutoSize = False
      Caption = 
        'Message to the user (do not translate), this is a very long mess' +
        'age repeated several times to force a word wrap Message to the u' +
        'ser (do not translate), this is a very long message repeated sev' +
        'eral times to force a word wrap Message to the user (do not tran' +
        'slate), this is a very long message repeated several times to fo' +
        'rce a word wrap Message to the user (do not translate), this is ' +
        'a very long message repeated several times to force a word wrap'
      WordWrap = True
    end
    object l_Options: TLabel
      Left = 8
      Top = 96
      Width = 385
      Height = 73
      AutoSize = False
      Caption = 'Option descriptions (do not translate)'
      WordWrap = True
    end
    object im_Icon: TImage
      Left = 8
      Top = 8
      Width = 49
      Height = 49
    end
  end
  object p_Details: TPanel
    Left = 0
    Top = 217
    Width = 423
    Height = 200
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    DesignSize = (
      423
      200)
    object m_Details: TMemo
      Left = 8
      Top = 0
      Width = 409
      Height = 193
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'ExcectionClass: (do not translate)'
        'Message of Exception (do not translate)')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      WordWrap = False
    end
  end
end
