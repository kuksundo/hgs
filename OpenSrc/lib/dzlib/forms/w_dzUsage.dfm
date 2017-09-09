object f_dzUsage: Tf_dzUsage
  Left = 0
  Top = 0
  Caption = 'Program caption goes here (do not translate)'
  ClientHeight = 389
  ClientWidth = 641
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object p_Error: TPanel
    Left = 0
    Top = 0
    Width = 641
    Height = 89
    Align = alTop
    TabOrder = 1
    DesignSize = (
      641
      89)
    object l_ErrorMessage: TLabel
      Left = 8
      Top = 8
      Width = 625
      Height = 25
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = False
      Caption = 'Error message goes here'#13#10'(do not translate)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object l_CalledAs: TLabel
      Left = 8
      Top = 40
      Width = 43
      Height = 13
      Caption = 'Called as'
    end
    object ed_CalledAs: TEdit
      Left = 8
      Top = 56
      Width = 625
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
  end
  object pc_Main: TPageControl
    Left = 0
    Top = 89
    Width = 641
    Height = 259
    ActivePage = ts_Usage
    Align = alClient
    TabOrder = 0
    object ts_Usage: TTabSheet
      Caption = 'Usage'
      DesignSize = (
        633
        231)
      object l_Parameters: TLabel
        Left = 0
        Top = 32
        Width = 55
        Height = 13
        Caption = 'Parameters'
      end
      object l_Options: TLabel
        Left = 0
        Top = 120
        Width = 37
        Height = 13
        Caption = 'Options'
      end
      object ed_Usage: TEdit
        Left = 0
        Top = 0
        Width = 631
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object m_Parameters: TMemo
        Left = 0
        Top = 48
        Width = 631
        Height = 65
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
        WordWrap = False
      end
      object m_Options: TMemo
        Left = 0
        Top = 136
        Width = 631
        Height = 89
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 2
        WordWrap = False
      end
    end
    object ts_Examples: TTabSheet
      Caption = 'Examples'
      ImageIndex = 1
      DesignSize = (
        633
        231)
      object m_Examples: TMemo
        Left = 0
        Top = 0
        Width = 631
        Height = 225
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        WordWrap = False
      end
    end
  end
  object p_Bottom: TPanel
    Left = 0
    Top = 348
    Width = 641
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      641
      41)
    object b_Close: TButton
      Left = 560
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Close'
      Default = True
      TabOrder = 0
      OnClick = b_CloseClick
    end
  end
end
