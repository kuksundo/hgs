object frmMain: TfrmMain
  Left = 222
  Top = 116
  BorderWidth = 8
  Caption = 'Modbus/TCP Slave Demo (Port 502)'
  ClientHeight = 430
  ClientWidth = 521
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000910A20C4000000000000000000000000910A20C400000000000000
    00000FF888918A2FC4888888887000000000FF8888910A28C488888887800000
    000FF8888891FA28C48888887880000000FF88888891FA28C488888788800000
    0FF8888887918A28C488887888800000FF8888887F918A28C48887888880000F
    F8888887FF918A28C4887888888000000000000000910A20C4008888888000F7
    7777778F77917A27C4708888888000F77777778F77917A27C4708888888000F7
    9117777FFFFFFFFFFFF08888888000F79917777F7001002004708888888000F7
    9997777F7011022044708888888000F77777777F7711722744708888888000F7
    9117777F7711722744708888888000F79917777F7007007007708888888000F7
    9997777F7077077077708888888000F77777777FFFFFFFFFFFF08888880000F7
    777777777777777777708888800000F77777778F8888888888808888000000F7
    7777778F8888888888808880000000F77777778F8888888888808800000000F7
    7777778F8888888888808000000000FFFFFFFF8FFFFFFFFFFFF0000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000700000000000000000000000000000
    070700000000000000000000000077777000777777777777777777777777FFFC
    93FFFF800000FF000000FE000000FC000000F8000000F0000000E0000000C000
    0000800000008000000080000000800000008000000080000000800000008000
    000080000000800000008000000180000003800000078000000F8000001F8000
    003F8000007F800000FFFDFFFFFFF8FFFFFFF07FFFFF0200000007000000}
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inline TFrameIPCMonitorAll1: TFrameIPCMonitorAll
    Left = 16
    Top = 48
    Width = 320
    Height = 240
    TabOrder = 2
    ExplicitLeft = 16
    ExplicitTop = 48
  end
  object pnlInput: TPanel
    Left = 413
    Top = 0
    Width = 108
    Height = 430
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 48
      Width = 56
      Height = 13
      Caption = 'First register'
    end
    object Label2: TLabel
      Left = 8
      Top = 96
      Width = 57
      Height = 13
      Caption = 'Last register'
    end
    object btnStart: TBitBtn
      Left = 8
      Top = 0
      Width = 100
      Height = 26
      Caption = '&Start'
      Glyph.Data = {
        4E010000424D4E01000000000000760000002800000012000000120000000100
        040000000000D800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00666666666666
        6666660000006666680000008666660000006668002222220086660000006680
        2222222222086600000066022222222222206600000068022222222222208600
        000060222FFFF22FF222060000006022F222F2F22F22060000006022F222F2F2
        2F22060000006022F22FF2F22F22060000006022F222222FF222060000006022
        F222F22222220600000068022FFF222222208600000066022222222222206600
        0000668022222222220866000000666800222222008666000000666668000000
        866666000000666666666666666666000000}
      TabOrder = 0
      OnClick = btnStartClick
    end
    object edtFirstReg: TEdit
      Left = 8
      Top = 64
      Width = 100
      Height = 21
      ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
      TabOrder = 1
      Text = '1'
    end
    object edtLastReg: TEdit
      Left = 8
      Top = 112
      Width = 100
      Height = 21
      ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
      TabOrder = 2
      Text = '200'
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 413
    Height = 430
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 0
      Top = 316
      Width = 413
      Height = 8
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 336
    end
    object mmoErrorLog: TMemo
      Left = 0
      Top = 324
      Width = 413
      Height = 106
      Align = alBottom
      ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
      TabOrder = 0
    end
    object sgdRegisters: TAdvStringGrid
      Left = 0
      Top = 0
      Width = 413
      Height = 316
      Cursor = crDefault
      Align = alClient
      DefaultColWidth = 66
      DrawingStyle = gdsClassic
      FixedCols = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 1
      ActiveCellFont.Charset = DEFAULT_CHARSET
      ActiveCellFont.Color = clWindowText
      ActiveCellFont.Height = -11
      ActiveCellFont.Name = 'Tahoma'
      ActiveCellFont.Style = [fsBold]
      ControlLook.FixedGradientHoverFrom = clGray
      ControlLook.FixedGradientHoverTo = clWhite
      ControlLook.FixedGradientDownFrom = clGray
      ControlLook.FixedGradientDownTo = clSilver
      ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownHeader.Font.Color = clWindowText
      ControlLook.DropDownHeader.Font.Height = -11
      ControlLook.DropDownHeader.Font.Name = 'Tahoma'
      ControlLook.DropDownHeader.Font.Style = []
      ControlLook.DropDownHeader.Visible = True
      ControlLook.DropDownHeader.Buttons = <>
      ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownFooter.Font.Color = clWindowText
      ControlLook.DropDownFooter.Font.Height = -11
      ControlLook.DropDownFooter.Font.Name = 'Tahoma'
      ControlLook.DropDownFooter.Font.Style = []
      ControlLook.DropDownFooter.Visible = True
      ControlLook.DropDownFooter.Buttons = <>
      Filter = <>
      FilterDropDown.Font.Charset = DEFAULT_CHARSET
      FilterDropDown.Font.Color = clWindowText
      FilterDropDown.Font.Height = -11
      FilterDropDown.Font.Name = 'Tahoma'
      FilterDropDown.Font.Style = []
      FilterDropDownClear = '(All)'
      FixedColWidth = 66
      FixedRowHeight = 22
      FixedFont.Charset = DEFAULT_CHARSET
      FixedFont.Color = clWindowText
      FixedFont.Height = -11
      FixedFont.Name = 'Tahoma'
      FixedFont.Style = [fsBold]
      FloatFormat = '%.2f'
      PrintSettings.DateFormat = 'dd/mm/yyyy'
      PrintSettings.Font.Charset = DEFAULT_CHARSET
      PrintSettings.Font.Color = clWindowText
      PrintSettings.Font.Height = -11
      PrintSettings.Font.Name = 'Tahoma'
      PrintSettings.Font.Style = []
      PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
      PrintSettings.FixedFont.Color = clWindowText
      PrintSettings.FixedFont.Height = -11
      PrintSettings.FixedFont.Name = 'Tahoma'
      PrintSettings.FixedFont.Style = []
      PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
      PrintSettings.HeaderFont.Color = clWindowText
      PrintSettings.HeaderFont.Height = -11
      PrintSettings.HeaderFont.Name = 'Tahoma'
      PrintSettings.HeaderFont.Style = []
      PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
      PrintSettings.FooterFont.Color = clWindowText
      PrintSettings.FooterFont.Height = -11
      PrintSettings.FooterFont.Name = 'Tahoma'
      PrintSettings.FooterFont.Style = []
      PrintSettings.PageNumSep = '/'
      SearchFooter.FindNextCaption = 'Find &next'
      SearchFooter.FindPrevCaption = 'Find &previous'
      SearchFooter.Font.Charset = DEFAULT_CHARSET
      SearchFooter.Font.Color = clWindowText
      SearchFooter.Font.Height = -11
      SearchFooter.Font.Name = 'Tahoma'
      SearchFooter.Font.Style = []
      SearchFooter.HighLightCaption = 'Highlight'
      SearchFooter.HintClose = 'Close'
      SearchFooter.HintFindNext = 'Find next occurrence'
      SearchFooter.HintFindPrev = 'Find previous occurrence'
      SearchFooter.HintHighlight = 'Highlight occurrences'
      SearchFooter.MatchCaseCaption = 'Match case'
      Version = '6.1.1.0'
    end
  end
  object msrPLC: TIdModBusServer
    Bindings = <
      item
        IP = '127.0.0.1'
        Port = 502
      end>
    OnConnect = msrPLCConnect
    OnReadHoldingRegisters = msrPLCReadHoldingRegisters
    OnReadInputRegisters = msrPLCReadInputRegisters
    Left = 160
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 96
  end
  object MainMenu1: TMainMenu
    Left = 131
    object FILE1: TMenuItem
      Caption = 'File'
      object Close1: TMenuItem
        Caption = 'Close'
        GroupIndex = 1
      end
    end
    object HELP1: TMenuItem
      Caption = 'Setting'
      object Option1: TMenuItem
        Caption = 'Option'
        OnClick = Option1Click
      end
    end
    object Help2: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About'
      end
    end
  end
end
