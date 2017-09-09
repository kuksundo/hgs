object fMain: TfMain
  Left = 0
  Top = 0
  Caption = 'IMC(Inter-Machine Communication) Server'
  ClientHeight = 603
  ClientWidth = 929
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
  inline TFrameCommServer1: TFrameCommServer
    Left = 0
    Top = 0
    Width = 929
    Height = 603
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 152
    ExplicitTop = 112
    inherited Splitter1: TSplitter
      Width = 929
    end
    inherited PageControl1: TPageControl
      Width = 929
      inherited TabSheet1: TTabSheet
        inherited lvConnections: TListView
          Width = 921
        end
      end
    end
    inherited PageControl2: TPageControl
      Width = 929
      Height = 255
      inherited TabSheet4: TTabSheet
        inherited SMUDPSysLog: TSynMemo
          Width = 921
          Height = 227
        end
      end
    end
    inherited Panel1: TPanel
      Width = 929
    end
    inherited Panel2: TPanel
      Width = 929
    end
    inherited AdvOfficeStatusBar1: TAdvOfficeStatusBar
      Top = 584
      Width = 929
    end
  end
end
