object TCPConfigF: TTCPConfigF
  Left = 446
  Top = 186
  Caption = 'TCP '#53685#49888' '#54872#44221' '#49444#51221' '#54868#47732
  ClientHeight = 145
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
    Top = 104
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
      TabOrder = 0
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 160
      Top = 8
      Width = 75
      Height = 25
      Caption = #52712' '#49548
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 280
    Height = 104
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
        Visible = False
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
    end
    object TabSheet1: TTabSheet
      Caption = #44277#50976#47700#47784#47532' '#49444#51221
      ImageIndex = 1
      object Label2: TLabel
        Left = 66
        Top = 37
        Width = 40
        Height = 16
        Caption = 'Name:'
        ParentShowHint = False
        ShowHint = False
      end
      object SharedMMNameEdit: TEdit
        Left = 120
        Top = 33
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 0
      end
    end
    object TabSheet3: TTabSheet
      Caption = #44592#53440
      ImageIndex = 2
      object AllowOnlyOneClientCB: TCheckBox
        Left = 3
        Top = 16
        Width = 266
        Height = 17
        Caption = 'Power Meter '#45817' '#54620#44060#51032' Client'#47564' '#54728#50857
        TabOrder = 0
      end
    end
  end
end
