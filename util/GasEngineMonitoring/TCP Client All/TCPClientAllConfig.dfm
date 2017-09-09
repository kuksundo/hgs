object TCPConfigF: TTCPConfigF
  Left = 446
  Top = 186
  Caption = 'TCP '#53685#49888' '#54872#44221' '#49444#51221' '#54868#47732
  ClientHeight = 200
  ClientWidth = 280
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
    Top = 159
    Width = 280
    Height = 41
    Align = alBottom
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 48
      Top = 8
      Width = 75
      Height = 25
      Caption = #54869' '#51064
      DoubleBuffered = True
      Kind = bkOK
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 160
      Top = 8
      Width = 75
      Height = 25
      Caption = #52712' '#49548
      DoubleBuffered = True
      Kind = bkCancel
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 1
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 280
    Height = 159
    ActivePage = TabSheet1
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
        Visible = False
      end
      object Label3: TLabel
        Left = 20
        Top = 74
        Width = 51
        Height = 16
        Caption = 'Local IP:'
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
      object HostIPEdit: TEdit
        Left = 106
        Top = 9
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 1
        Text = '10.14.23.40'
        Visible = False
      end
      object HostIpCB: TComboBox
        Left = 82
        Top = 71
        Width = 145
        Height = 24
        ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
        TabOrder = 2
        Text = '10.14.23.11'
        OnDropDown = HostIpCBDropDown
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'etc.'
      ImageIndex = 1
      object Label2: TLabel
        Left = 11
        Top = 13
        Width = 87
        Height = 16
        Caption = 'Shared Name:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label4: TLabel
        Left = 11
        Top = 43
        Width = 86
        Height = 16
        Caption = 'Simulate Step:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label6: TLabel
        Left = 231
        Top = 43
        Width = 35
        Height = 16
        Caption = 'mSec'
        ParentShowHint = False
        ShowHint = False
      end
      object Label7: TLabel
        Left = 3
        Top = 73
        Width = 105
        Height = 16
        Caption = 'Req TCP Interval:'
        ParentShowHint = False
        ShowHint = False
      end
      object Label8: TLabel
        Left = 231
        Top = 73
        Width = 35
        Height = 16
        Caption = 'mSec'
        ParentShowHint = False
        ShowHint = False
      end
      object SharedMMNameEdit: TEdit
        Left = 104
        Top = 10
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 0
      end
      object SimStepEdit: TEdit
        Left = 104
        Top = 40
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 1
      end
      object ReqIntervalEdit: TEdit
        Left = 121
        Top = 70
        Width = 104
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 2
      end
    end
  end
end
