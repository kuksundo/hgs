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
        Left = 56
        Top = 21
        Width = 40
        Height = 16
        Caption = 'Name:'
        ParentShowHint = False
        ShowHint = False
      end
      object SharedMMNameEdit: TEdit
        Left = 110
        Top = 17
        Width = 121
        Height = 24
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        TabOrder = 0
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Timer '#49444#51221
      ImageIndex = 2
      object Label3: TLabel
        Left = 11
        Top = 43
        Width = 95
        Height = 16
        AutoSize = False
        Caption = #51204#49569' '#51452#44592':'
        Enabled = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label4: TLabel
        Left = 212
        Top = 41
        Width = 35
        Height = 16
        Caption = 'mSec'
        Enabled = False
        ParentShowHint = False
        ShowHint = False
      end
      object UseTimerCB: TCheckBox
        Left = 11
        Top = 15
        Width = 246
        Height = 18
        Caption = #53440#51060#47672#47484' '#49324#50857#54616#50668' '#45936#50612#53552' '#51204#49569
        TabOrder = 0
        OnClick = UseTimerCBClick
      end
      object IntervalEdit: TEdit
        Left = 112
        Top = 39
        Width = 95
        Height = 24
        BiDiMode = bdRightToLeft
        Enabled = False
        ImeName = #54620#44397#50612'('#54620#44544') (MS-IME98)'
        ParentBiDiMode = False
        TabOrder = 1
      end
    end
  end
end
