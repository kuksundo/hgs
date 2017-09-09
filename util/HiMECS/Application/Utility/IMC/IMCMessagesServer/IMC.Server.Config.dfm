object ServerConfigF: TServerConfigF
  Left = 446
  Top = 186
  Caption = 'Comm Server Config'
  ClientHeight = 217
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 176
    Width = 370
    Height = 41
    Align = alBottom
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 48
      Top = 8
      Width = 75
      Height = 25
      Caption = #54869' '#51064
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 160
      Top = 8
      Width = 75
      Height = 25
      Caption = #52712' '#49548
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 370
    Height = 176
    ActivePage = Tabsheet2
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Tabsheet2: TTabSheet
      Caption = 'TCP '#51452#49548#49444#51221
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      object Label5: TLabel
        Left = 44
        Top = 45
        Width = 58
        Height = 16
        Caption = 'Port Num:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label1: TLabel
        Left = 44
        Top = 13
        Width = 56
        Height = 16
        Caption = 'HOST IP:'
        ParentShowHint = False
        ShowHint = False
      end
      object PortEdit: TEdit
        Left = 106
        Top = 41
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 0
        Text = '5000'
      end
      object HostIpCB: TComboBox
        Left = 104
        Top = 8
        Width = 145
        Height = 24
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 1
        Text = '10.14.23.11'
        OnDropDown = HostIpCBDropDown
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Etc.'
      ImageIndex = 1
      object Label3: TLabel
        Left = 3
        Top = 17
        Width = 106
        Height = 16
        Caption = 'Auto Start Interval:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label2: TLabel
        Left = 3
        Top = 48
        Width = 108
        Height = 16
        Caption = 'Param File Name:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label4: TLabel
        Left = 228
        Top = 18
        Width = 35
        Height = 16
        Caption = 'mSec'
        ParentShowHint = False
        ShowHint = False
      end
      object AutoStartIntervalEdit: TEdit
        Left = 121
        Top = 14
        Width = 99
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 0
      end
      object JvFilenameEdit1: TJvFilenameEdit
        Left = 120
        Top = 46
        Width = 239
        Height = 24
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 1
      end
      object ConfFileFormatRG: TRadioGroup
        Left = 19
        Top = 76
        Width = 129
        Height = 57
        Caption = 'Param File Format'
        Columns = 2
        ItemIndex = 1
        Items.Strings = (
          'XML'
          'JSON')
        TabOrder = 2
      end
      object EngParamEncryptCB: TCheckBox
        Left = 169
        Top = 99
        Width = 159
        Height = 17
        Caption = 'Parameter File Encrypt'
        TabOrder = 3
      end
    end
  end
end
