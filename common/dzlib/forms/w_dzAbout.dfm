object f_dzAbout: Tf_dzAbout
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'About %s'
  ClientHeight = 279
  ClientWidth = 523
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pa_Left: TPanel
    Left = 0
    Top = 0
    Width = 233
    Height = 238
    Align = alLeft
    TabOrder = 0
    object l_ProductName: TLabel
      Left = 1
      Top = 1
      Width = 231
      Height = 48
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'ProductName (do not translate)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 207
    end
    object l_Version: TLabel
      Left = 1
      Top = 49
      Width = 231
      Height = 24
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'VersionGoesHere (do not translate)'
      Layout = tlCenter
      ExplicitWidth = 207
    end
    object l_Date: TLabel
      Left = 1
      Top = 73
      Width = 231
      Height = 24
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'DateGoesHere (do not translate)'
      Layout = tlCenter
      ExplicitWidth = 207
    end
    object l_Copyright: TLabel
      Left = 1
      Top = 97
      Width = 231
      Height = 24
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'CopyrightGoesHere (do not translate)'
      Layout = tlCenter
      ExplicitLeft = 0
      ExplicitTop = 80
      ExplicitWidth = 427
    end
  end
  object p_Bottom: TPanel
    Left = 0
    Top = 238
    Width = 523
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      523
      41)
    object b_OK: TButton
      Left = 440
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
  object pc_Info: TPageControl
    Left = 233
    Top = 0
    Width = 290
    Height = 238
    ActivePage = ts_ProgramInfo
    Align = alClient
    TabOrder = 2
    object ts_ProgramInfo: TTabSheet
      Caption = 'Program Info'
      object lv_ProgramInfo: TListView
        Left = 0
        Top = 0
        Width = 282
        Height = 210
        Align = alClient
        Columns = <>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        ShowColumnHeaders = False
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object ts_Contact: TTabSheet
      Caption = 'Contact'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 186
      ExplicitHeight = 133
      object m_Contact: TMemo
        Left = 0
        Top = 0
        Width = 282
        Height = 210
        Align = alClient
        ReadOnly = True
        TabOrder = 0
        ExplicitWidth = 186
        ExplicitHeight = 133
      end
    end
    object ts_Credits: TTabSheet
      Caption = 'Credits'
      ImageIndex = 2
      object lb_Credits: TListBox
        Left = 0
        Top = 0
        Width = 121
        Height = 210
        Align = alLeft
        ItemHeight = 13
        TabOrder = 0
      end
      object p_Credits: TPanel
        Left = 121
        Top = 0
        Width = 161
        Height = 210
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
      end
    end
  end
end
