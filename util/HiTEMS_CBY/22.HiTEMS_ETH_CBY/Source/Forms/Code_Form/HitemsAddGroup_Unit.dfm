object HitemsAddGroup_Frm: THitemsAddGroup_Frm
  Left = 0
  Top = 0
  Caption = #49352#47196#50868' '#44536#47353' '#52628#44032
  ClientHeight = 146
  ClientWidth = 422
  Color = 3223857
  Constraints.MaxHeight = 180
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel7: TPanel
    Left = 0
    Top = 112
    Width = 422
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    Color = clGray
    ParentBackground = False
    TabOrder = 0
    object Button1: TButton
      AlignWithMargins = True
      Left = 344
      Top = 3
      Width = 75
      Height = 28
      Margins.Left = 1
      Align = alRight
      Caption = #45803#44592
      ImageIndex = 2
      ImageMargins.Left = 10
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 268
      Top = 3
      Width = 75
      Height = 28
      Margins.Left = 1
      Margins.Right = 0
      Align = alRight
      Caption = #52628#44032
      ImageIndex = 0
      ImageMargins.Left = 10
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Panel8: TPanel
    Left = 0
    Top = 0
    Width = 422
    Height = 30
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Panel9: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 93
      Height = 24
      Margins.Right = 1
      Align = alLeft
      Alignment = taRightJustify
      Caption = #49345#50948' '#47336#53944#47749' '
      Color = 10938619
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
    end
    object pCdGrpNm: TEdit
      AlignWithMargins = True
      Left = 100
      Top = 3
      Width = 213
      Height = 24
      Align = alLeft
      ImeName = 'Microsoft Office IME 2007'
      ReadOnly = True
      TabOrder = 1
      ExplicitHeight = 21
    end
    object pCdGrpCd: TEdit
      AlignWithMargins = True
      Left = 319
      Top = 3
      Width = 100
      Height = 24
      Align = alClient
      ImeName = 'Microsoft Office IME 2007'
      ReadOnly = True
      TabOrder = 2
      ExplicitHeight = 21
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 30
    Width = 422
    Height = 27
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Panel2: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 0
      Width = 93
      Height = 24
      Margins.Top = 0
      Margins.Right = 1
      Align = alLeft
      Alignment = taRightJustify
      Caption = #49888#44508' '#47336#53944#53076#46300' '
      Color = 10938619
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
    end
    object cdGrp: TEdit
      AlignWithMargins = True
      Left = 100
      Top = 0
      Width = 121
      Height = 24
      Margins.Top = 0
      Align = alLeft
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 1
      ExplicitHeight = 21
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 57
    Width = 422
    Height = 27
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object Panel4: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 0
      Width = 93
      Height = 24
      Margins.Top = 0
      Margins.Right = 1
      Align = alLeft
      Alignment = taRightJustify
      Caption = #49888#44508' '#47336#53944#47749' '
      Color = 10938619
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
    end
    object cdGrpNm: TEdit
      AlignWithMargins = True
      Left = 100
      Top = 0
      Width = 319
      Height = 24
      Margins.Top = 0
      Align = alClient
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 1
      ExplicitHeight = 21
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 84
    Width = 422
    Height = 27
    Margins.Top = 0
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object Panel6: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 0
      Width = 93
      Height = 24
      Margins.Top = 0
      Margins.Right = 1
      Align = alLeft
      Alignment = taRightJustify
      Caption = #49888#44508' '#47336#53944#49444#47749' '
      Color = 10938619
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
    end
    object cdGrpDesc: TEdit
      AlignWithMargins = True
      Left = 100
      Top = 0
      Width = 319
      Height = 24
      Margins.Top = 0
      Align = alClient
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 1
      ExplicitHeight = 21
    end
  end
end
