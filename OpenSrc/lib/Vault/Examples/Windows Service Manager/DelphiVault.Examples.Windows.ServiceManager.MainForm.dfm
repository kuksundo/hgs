object frmServiceManagerExample: TfrmServiceManagerExample
  Left = 0
  Top = 0
  Caption = 'Windows Service Manager Example'
  ClientHeight = 412
  ClientWidth = 776
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 776
    Height = 35
    Align = alTop
    Caption = 'Right Click Service For Action Menu (Admin rights required)'
    TabOrder = 0
    object butRefreshList: TButton
      Left = 11
      Top = 4
      Width = 75
      Height = 25
      Cursor = crHandPoint
      Caption = 'Refresh List'
      TabOrder = 0
      OnClick = butRefreshListClick
    end
  end
  object gridServices: TStringGrid
    Left = 0
    Top = 35
    Width = 776
    Height = 377
    Align = alClient
    ColCount = 4
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 1
    OnMouseDown = gridServicesMouseDown
  end
  object popServiceActions: TPopupMenu
    Left = 208
    Top = 88
    object Start1: TMenuItem
      Caption = 'Start'
      OnClick = StartExecute
    end
    object Stop1: TMenuItem
      Caption = 'Stop'
      OnClick = StopExecute
    end
    object Pause1: TMenuItem
      Caption = 'Pause'
      OnClick = PauseExecute
    end
    object Resume1: TMenuItem
      Caption = 'Resume'
      OnClick = StartExecute
    end
    object Restart1: TMenuItem
      Caption = 'Restart'
      OnClick = RestartExecute
    end
  end
end
