object Form2: TForm2
  Left = 0
  Top = 0
  Caption = #50644#51652#51221#48372' '#54028#51068' '#44288#47532' (*.einfo)'
  ClientHeight = 432
  ClientWidth = 323
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object EngineInfoInspector: TNextInspector
    Left = 0
    Top = 57
    Width = 323
    Height = 375
    Align = alClient
    HighlightTextColor = 33023
    PopupMenu = PopupMenu1
    Style = psOffice2010
    TabOrder = 0
    OnChange = EngineInfoInspectorChange
    ExplicitLeft = 8
    ExplicitTop = 128
    ExplicitWidth = 215
    ExplicitHeight = 213
    object SelectEngineCombo: TNxComboBoxItem
      Caption = 'Select Engine'
      Color = clBlack
      ValueFont.Charset = ANSI_CHARSET
      ValueFont.Color = clYellow
      ValueFont.Height = -11
      ValueFont.Name = 'Tahoma'
      ValueFont.Style = [fsBold]
      ParentIndex = -1
    end
    object NxTextItem1: TNxTextItem
      Caption = 'Basic Spec.'
      DrawingOptions = doBackgroundOnly
      ReadOnly = True
      ParentIndex = -1
    end
    object NxTextItem2: TNxTextItem
      Caption = 'Dimension(mm)'
      Expanded = False
      ReadOnly = True
      ParentIndex = -1
    end
    object NxTextItem3: TNxTextItem
      Caption = 'Dry Mass(ton)'
      Expanded = False
      ReadOnly = True
      ParentIndex = -1
    end
    object NxTextItem4: TNxTextItem
      Caption = 'CAM Profile'
      Expanded = False
      ReadOnly = True
      ParentIndex = -1
    end
    object FComponents: TNxTextItem
      Caption = 'Components'
      Expanded = False
      ReadOnly = True
      ParentIndex = -1
    end
    object NxTextItem5: TNxTextItem
      Caption = 'IP ADRESS'
      ReadOnly = True
      ParentIndex = -1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 323
    Height = 57
    Align = alTop
    TabOrder = 1
    object Button1: TButton
      Left = 0
      Top = 10
      Width = 57
      Height = 41
      Caption = 'Open'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 63
      Top = 10
      Width = 58
      Height = 41
      Caption = 'Save'
      TabOrder = 1
      OnClick = Button2Click
    end
    object RadioGroup1: TRadioGroup
      Left = 200
      Top = 10
      Width = 113
      Height = 41
      Columns = 2
      ItemIndex = 1
      Items.Strings = (
        'Old'
        'New')
      TabOrder = 2
    end
    object Button3: TButton
      Left = 127
      Top = 10
      Width = 58
      Height = 41
      Caption = 'xml->json'
      TabOrder = 3
      OnClick = Button3Click
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 24
    Top = 184
  end
  object SaveDialog1: TSaveDialog
    Left = 72
    Top = 184
  end
  object PopupMenu1: TPopupMenu
    Left = 120
    Top = 184
    object AddPart1: TMenuItem
      Caption = 'Add Component(Part)'
      OnClick = AddPart1Click
    end
    object DeleteSelectedPart1: TMenuItem
      Caption = 'Delete Selected Component'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object GetManualFromMSNo1: TMenuItem
      Caption = 'Get Manual Name From MS No'
    end
  end
end
