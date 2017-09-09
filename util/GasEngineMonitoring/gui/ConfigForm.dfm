object ConfigFormF: TConfigFormF
  Left = 362
  Top = 148
  ActiveControl = JvPagedTreeView1
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Engine Spec. Configuration'
  ClientHeight = 375
  ClientWidth = 670
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 180
    Top = 0
    Width = 4
    Height = 322
  end
  object Label64: TLabel
    Left = 30
    Top = 23
    Width = 32
    Height = 16
    Caption = 'CO'#8322
  end
  object Label65: TLabel
    Left = 30
    Top = 61
    Width = 33
    Height = 16
    Caption = 'CO(L)'
  end
  object Label66: TLabel
    Left = 31
    Top = 102
    Width = 24
    Height = 16
    Caption = 'O'#8322
  end
  object Label67: TLabel
    Left = 31
    Top = 137
    Width = 23
    Height = 16
    Caption = 'NOx'
  end
  object Label68: TLabel
    Left = 31
    Top = 179
    Width = 24
    Height = 16
    Caption = 'THC'
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 356
    Width = 670
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 180
    Height = 322
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 4
    Caption = ' '
    TabOrder = 1
    object JvPagedTreeView1: TJvSettingsTreeView
      Left = 4
      Top = 4
      Width = 172
      Height = 314
      PageDefault = 0
      PageList = JvPageList1
      Align = alClient
      Images = ImageList1
      Indent = 19
      TabOrder = 0
      Items.NodeData = {
        03020000002A000000010000000100000000000000FFFFFFFFFFFFFFFF010000
        0007000000010645006E00670069006E00650024000000FFFFFFFFFFFFFFFF00
        000000FFFFFFFFFFFFFFFF010000000000000001034D004500500036000000FF
        FFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF0200000000000000010C41006D
        006200690065006E007400200044006100740061002E000000FFFFFFFFFFFFFF
        FF00000000FFFFFFFFFFFFFFFF0300000000000000010847006F007600650072
        006E006F00720026000000FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF04
        0000000000000001044600750065006C002C000000FFFFFFFFFFFFFFFF000000
        00FFFFFFFFFFFFFFFF0500000000000000010747006100730065006F00750073
        0024000000FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF06000000000000
        0001034E004F00780030000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF07000000000000000109470065006E0065007200610074006F0072002A0000
        000100000001000000FFFFFFFFFFFFFFFFFFFFFFFF0000000001000000010643
        006F006E0066006900670034000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFF0000000000000000010B45006E007600690072006F006E006D0061006E
        007400}
      Items.Links = {
        0A00000001000000010000000200000003000000040000000500000006000000
        070000000000000000000000}
    end
  end
  object JvStandardPage2: TJvStandardPage
    Left = 184
    Top = 0
    Width = 486
    Height = 322
    Caption = 'JvStandardPage2'
  end
  object JvStandardPage4: TJvStandardPage
    Left = 184
    Top = 0
    Width = 486
    Height = 322
    Caption = 'JvStandardPage4'
  end
  object JvStandardPage1: TJvStandardPage
    Left = 184
    Top = 0
    Width = 486
    Height = 322
    Caption = 'JvStandardPage1'
  end
  object JvStandardPage5: TJvStandardPage
    Left = 184
    Top = 0
    Width = 486
    Height = 322
    Caption = 'JvStandardPage5'
  end
  object JvFooter1: TJvFooter
    Left = 0
    Top = 322
    Width = 670
    Height = 34
    Align = alBottom
    DesignSize = (
      670
      34)
    object JvFooterBtn2: TJvFooterBtn
      Left = 508
      Top = 5
      Width = 75
      Height = 23
      Anchors = [akRight, akBottom]
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = JvFooterBtn2Click
      Kind = bkOK
      ButtonIndex = 0
      SpaceInterval = 6
      ExplicitLeft = 435
    end
    object JvFooterBtn3: TJvFooterBtn
      Left = 587
      Top = 5
      Width = 75
      Height = 23
      Anchors = [akRight, akBottom]
      Cancel = True
      ModalResult = 2
      TabOrder = 1
      OnClick = JvFooterBtn3Click
      Kind = bkCancel
      ButtonIndex = 1
      SpaceInterval = 6
    end
  end
  object JvPageList1: TJvPageList
    Left = 184
    Top = 0
    Width = 486
    Height = 322
    ActivePage = pgMEP
    PropagateEnable = True
    Align = alClient
    object pgEnvironment: TJvStandardPage
      Left = 0
      Top = 17
      Width = 486
      Height = 303
      object Label3: TLabel
        Left = 16
        Top = 30
        Width = 90
        Height = 16
        Caption = 'XML File Name:'
      end
      object Bevel1: TBevel
        Left = 6
        Top = 96
        Width = 477
        Height = 4
      end
      object XMLFilenameEdit: TJvFilenameEdit
        Left = 112
        Top = 30
        Width = 256
        Height = 24
        ImeName = 'Microsoft Office IME 2007'
        TabOrder = 0
        Text = ''
      end
      object GroupBox1: TGroupBox
        Left = 32
        Top = 106
        Width = 209
        Height = 81
        Caption = 'Display real time data'
        TabOrder = 1
        object RealtimeKnockCB: TCheckBox
          Left = 24
          Top = 24
          Width = 97
          Height = 17
          Caption = 'Knocking Data'
          TabOrder = 0
        end
        object RealtimeMisFireCB: TCheckBox
          Left = 24
          Top = 55
          Width = 97
          Height = 17
          Caption = 'Misfiring Data'
          TabOrder = 1
        end
      end
      object CloseTCPCB: TCheckBox
        Left = 32
        Top = 199
        Width = 353
        Height = 17
        Caption = 'Close TCP Client Program When main form closed'
        TabOrder = 2
      end
    end
    object pgMEP: TJvStandardPage
      Left = 0
      Top = 17
      Width = 486
      Height = 303
      ParentCustomHint = False
      ParentShowHint = False
      ShowHint = False
      object Label5: TLabel
        Left = 8
        Top = 21
        Width = 31
        Height = 16
        Caption = 'Bore:'
      end
      object Label6: TLabel
        Left = 6
        Top = 48
        Width = 42
        Height = 16
        Caption = 'Stroke:'
      end
      object Label9: TLabel
        Left = 6
        Top = 78
        Width = 90
        Height = 16
        Caption = 'Number of Cyl.:'
      end
      object Label10: TLabel
        Left = 6
        Top = 110
        Width = 31
        Height = 16
        Caption = 'MCR:'
      end
      object Label11: TLabel
        Left = 167
        Top = 20
        Width = 19
        Height = 16
        Caption = 'Cm'
      end
      object Label12: TLabel
        Left = 167
        Top = 50
        Width = 19
        Height = 16
        Caption = 'Cm'
      end
      object Label13: TLabel
        Left = 168
        Top = 110
        Width = 23
        Height = 16
        Caption = 'rpm'
      end
      object Label50: TLabel
        Left = 6
        Top = 200
        Width = 104
        Height = 16
        Caption = 'Generator Output:'
      end
      object Label51: TLabel
        Left = 168
        Top = 200
        Width = 84
        Height = 16
        Caption = 'kW(Measured)'
      end
      object Label52: TLabel
        Left = 6
        Top = 232
        Width = 83
        Height = 16
        Caption = 'Engine Speed:'
      end
      object Label53: TLabel
        Left = 168
        Top = 232
        Width = 89
        Height = 16
        Caption = 'rpm(Measured)'
      end
      object Label88: TLabel
        Left = 6
        Top = 140
        Width = 78
        Height = 16
        Caption = 'Rated Power:'
      end
      object Label89: TLabel
        Left = 168
        Top = 140
        Width = 18
        Height = 16
        Caption = 'kW'
      end
      object Label92: TLabel
        Left = 6
        Top = 170
        Width = 63
        Height = 16
        Caption = 'T/C Count:'
      end
      object BoreEdit: TEdit
        Left = 111
        Top = 15
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 0
      end
      object StrokeEdit: TEdit
        Left = 111
        Top = 45
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 1
      end
      object CylEdit: TEdit
        Left = 111
        Top = 75
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 2
      end
      object MCREdit: TEdit
        Left = 111
        Top = 107
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 3
      end
      object GOEdit: TEdit
        Left = 111
        Top = 197
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 4
      end
      object ESEdit: TEdit
        Left = 111
        Top = 229
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 5
      end
      object RatedPowerEdit: TEdit
        Left = 111
        Top = 137
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 6
      end
      object TCCountEdit: TEdit
        Left = 111
        Top = 167
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 7
      end
    end
    object pgAmbient: TJvStandardPage
      Left = 0
      Top = 17
      Width = 486
      Height = 303
      object Label14: TLabel
        Left = 6
        Top = 140
        Width = 121
        Height = 16
        Caption = 'Barometric Pressure:'
      end
      object Label15: TLabel
        Left = 273
        Top = 143
        Width = 20
        Height = 16
        Caption = 'kPa'
      end
      object Label16: TLabel
        Left = 6
        Top = 24
        Width = 139
        Height = 16
        Caption = 'Intake Air Temperature:'
      end
      object Label17: TLabel
        Left = 273
        Top = 30
        Width = 14
        Height = 16
        Caption = #176'C'
      end
      object Label18: TLabel
        Left = 6
        Top = 109
        Width = 204
        Height = 16
        Caption = 'Scavenge(Intake) Air Temperature:'
      end
      object Label19: TLabel
        Left = 6
        Top = 80
        Width = 179
        Height = 16
        Caption = 'Scavenge(Intake) Air Pressure:'
      end
      object Label20: TLabel
        Left = 274
        Top = 84
        Width = 41
        Height = 16
        Caption = 'kg/cm'#178
      end
      object Label21: TLabel
        Left = 274
        Top = 114
        Width = 14
        Height = 16
        Caption = #176'C'
      end
      object Label22: TLabel
        Left = 6
        Top = 52
        Width = 156
        Height = 16
        Caption = 'Saturation Vapor Pressure:'
      end
      object Label23: TLabel
        Left = 274
        Top = 56
        Width = 20
        Height = 16
        Caption = 'kPa'
      end
      object BPEdit: TEdit
        Left = 217
        Top = 138
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 0
      end
      object IATEdit: TEdit
        Left = 217
        Top = 25
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 1
      end
      object SATEdit: TEdit
        Left = 217
        Top = 110
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 2
      end
      object SAPEdit: TEdit
        Left = 217
        Top = 81
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 3
      end
      object SVPEdit: TEdit
        Left = 217
        Top = 53
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 4
      end
    end
    object pgGovernor: TJvStandardPage
      Left = 0
      Top = 17
      Width = 486
      Height = 303
      object Label24: TLabel
        Left = 6
        Top = 24
        Width = 113
        Height = 16
        Caption = 'Intake Air Humidity:'
      end
      object Label25: TLabel
        Left = 250
        Top = 30
        Width = 12
        Height = 16
        Caption = '%'
      end
      object Label26: TLabel
        Left = 6
        Top = 52
        Width = 190
        Height = 16
        Caption = 'Intecooled Air Ref. Temperature:'
      end
      object Label27: TLabel
        Left = 251
        Top = 56
        Width = 14
        Height = 16
        Caption = #176'C'
      end
      object Label28: TLabel
        Left = 6
        Top = 80
        Width = 142
        Height = 16
        Caption = 'C.W. Inlet/Outlet Temp.:'
      end
      object Label29: TLabel
        Left = 251
        Top = 84
        Width = 14
        Height = 16
        Caption = #176'C'
      end
      object Label30: TLabel
        Left = 6
        Top = 109
        Width = 86
        Height = 16
        Caption = 'Fuel Index MV:'
        Enabled = False
      end
      object Label31: TLabel
        Left = 251
        Top = 114
        Width = 22
        Height = 16
        Caption = 'mm'
        Enabled = False
      end
      object Label32: TLabel
        Left = 6
        Top = 140
        Width = 142
        Height = 16
        Caption = 'Load Indicator Governor:'
        Enabled = False
      end
      object Label34: TLabel
        Left = 344
        Top = 84
        Width = 14
        Height = 16
        Caption = #176'C'
      end
      object Label33: TLabel
        Left = 6
        Top = 165
        Width = 133
        Height = 16
        Caption = 'Exhaust Back Pressure:'
        Enabled = False
      end
      object Label35: TLabel
        Left = 251
        Top = 170
        Width = 42
        Height = 16
        Caption = 'mmWC'
        Enabled = False
      end
      object Label36: TLabel
        Left = 6
        Top = 193
        Width = 153
        Height = 16
        Caption = 'Exhaust Gas Temperature:'
        Enabled = False
      end
      object Label37: TLabel
        Left = 251
        Top = 198
        Width = 14
        Height = 16
        Caption = #176'C'
        Enabled = False
      end
      object Label38: TLabel
        Left = 6
        Top = 220
        Width = 123
        Height = 16
        Caption = 'Turbocharger Speed:'
        Enabled = False
      end
      object Label39: TLabel
        Left = 251
        Top = 225
        Width = 23
        Height = 16
        Caption = 'rpm'
        Enabled = False
      end
      object Label54: TLabel
        Left = 324
        Top = 31
        Width = 25
        Height = 16
        Caption = 'g/kg'
      end
      object IAHEdit: TEdit
        Left = 194
        Top = 25
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 0
      end
      object IARTEdit: TEdit
        Left = 194
        Top = 53
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 1
      end
      object CWITEdit: TEdit
        Left = 194
        Top = 81
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 2
      end
      object FIMVEdit: TEdit
        Left = 194
        Top = 110
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Enabled = False
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 3
      end
      object LIGEdit: TEdit
        Left = 194
        Top = 138
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Enabled = False
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 4
      end
      object CWOTEdit: TEdit
        Left = 287
        Top = 81
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 5
      end
      object EBPEdit: TEdit
        Left = 194
        Top = 166
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Enabled = False
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 6
      end
      object EGTEdit: TEdit
        Left = 194
        Top = 194
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Enabled = False
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 7
      end
      object TCSEdit: TEdit
        Left = 194
        Top = 221
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Enabled = False
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 8
      end
      object IAH2Edit: TEdit
        Left = 268
        Top = 26
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 9
      end
    end
    object pgFuel: TJvStandardPage
      Left = 0
      Top = 17
      Width = 486
      Height = 303
      object Label40: TLabel
        Left = 6
        Top = 140
        Width = 82
        Height = 16
        Caption = 'Grade of Fuel:'
        Enabled = False
      end
      object Label42: TLabel
        Left = 6
        Top = 24
        Width = 107
        Height = 16
        Caption = 'Fuel Consumption:'
      end
      object Label43: TLabel
        Left = 250
        Top = 30
        Width = 25
        Height = 16
        Caption = 'kg/h'
      end
      object Label44: TLabel
        Left = 6
        Top = 109
        Width = 81
        Height = 16
        Caption = 'Name of Fuel:'
        Enabled = False
      end
      object Label45: TLabel
        Left = 6
        Top = 80
        Width = 72
        Height = 16
        Caption = 'Kind of Fuel:'
        Enabled = False
      end
      object Label48: TLabel
        Left = 6
        Top = 52
        Width = 180
        Height = 16
        Caption = 'Uncorrected Fuel Consumption:'
      end
      object Label49: TLabel
        Left = 251
        Top = 56
        Width = 35
        Height = 16
        Caption = 'g/kwh'
      end
      object Label82: TLabel
        Left = 6
        Top = 172
        Width = 52
        Height = 16
        Caption = 'Gas LCV:'
      end
      object Label83: TLabel
        Left = 255
        Top = 173
        Width = 29
        Height = 16
        Caption = 'kJ/kg'
      end
      object GOFEdit: TEdit
        Left = 194
        Top = 138
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Enabled = False
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 0
      end
      object FCEdit: TEdit
        Left = 194
        Top = 25
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 1
      end
      object NOFEdit: TEdit
        Left = 194
        Top = 110
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Enabled = False
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 2
      end
      object KOFEdit: TEdit
        Left = 194
        Top = 81
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Enabled = False
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 3
      end
      object UFCEdit: TEdit
        Left = 194
        Top = 53
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 4
      end
      object LCVEdit: TEdit
        Left = 194
        Top = 170
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 5
      end
    end
    object pgGaseous: TJvStandardPage
      Left = 0
      Top = 17
      Width = 486
      Height = 303
      object Label41: TLabel
        Left = 14
        Top = 23
        Width = 32
        Height = 16
        Caption = 'CO'#8322
      end
      object Label46: TLabel
        Left = 14
        Top = 61
        Width = 33
        Height = 16
        Caption = 'CO(L)'
      end
      object Label47: TLabel
        Left = 15
        Top = 102
        Width = 24
        Height = 16
        Caption = 'O'#8322
      end
      object Label55: TLabel
        Left = 15
        Top = 137
        Width = 23
        Height = 16
        Caption = 'NOx'
      end
      object Label56: TLabel
        Left = 15
        Top = 179
        Width = 24
        Height = 16
        Caption = 'THC'
      end
      object Label57: TLabel
        Left = 16
        Top = 220
        Width = 31
        Height = 16
        Caption = 'CH'#8324
      end
      object Label58: TLabel
        Left = 16
        Top = 255
        Width = 57
        Height = 16
        Caption = 'non-CH'#8324
      end
      object Label59: TLabel
        Left = 358
        Top = 23
        Width = 30
        Height = 16
        Caption = 'C(%)'
      end
      object Label60: TLabel
        Left = 358
        Top = 48
        Width = 30
        Height = 16
        Caption = 'H(%)'
      end
      object Label61: TLabel
        Left = 376
        Top = 78
        Width = 8
        Height = 16
        Caption = 'N'
      end
      object Label62: TLabel
        Left = 376
        Top = 108
        Width = 9
        Height = 16
        Caption = 'O'
      end
      object Label63: TLabel
        Left = 376
        Top = 138
        Width = 8
        Height = 16
        Caption = 'S'
      end
      object Label69: TLabel
        Left = 173
        Top = 229
        Width = 86
        Height = 16
        Caption = 'Density(kg/m'#179')'
      end
      object Label70: TLabel
        Left = 173
        Top = 258
        Width = 49
        Height = 16
        Caption = 'Viscosity'
      end
      object Label71: TLabel
        Left = 340
        Top = 224
        Width = 57
        Height = 16
        Caption = 'C_residue'
      end
      object Label72: TLabel
        Left = 341
        Top = 250
        Width = 35
        Height = 16
        Caption = 'Water'
      end
      object Label1: TLabel
        Left = 179
        Top = 18
        Width = 31
        Height = 16
        Caption = 'CH'#8324
      end
      object Label2: TLabel
        Left = 179
        Top = 48
        Width = 30
        Height = 16
        Caption = 'C2H6'
      end
      object Label4: TLabel
        Left = 179
        Top = 78
        Width = 30
        Height = 16
        Caption = 'C3H8'
      end
      object Label7: TLabel
        Left = 179
        Top = 108
        Width = 37
        Height = 16
        Caption = 'C4H10'
      end
      object Label8: TLabel
        Left = 179
        Top = 138
        Width = 37
        Height = 16
        Caption = 'C5H12'
      end
      object Label73: TLabel
        Left = 289
        Top = 18
        Width = 43
        Height = 16
        Caption = '%,m/m'
      end
      object Label84: TLabel
        Left = 289
        Top = 48
        Width = 43
        Height = 16
        Caption = '%,m/m'
      end
      object Label85: TLabel
        Left = 289
        Top = 78
        Width = 43
        Height = 16
        Caption = '%,m/m'
      end
      object Label86: TLabel
        Left = 289
        Top = 108
        Width = 43
        Height = 16
        Caption = '%,m/m'
      end
      object Label87: TLabel
        Left = 289
        Top = 138
        Width = 43
        Height = 16
        Caption = '%,m/m'
      end
      object Label91: TLabel
        Left = 193
        Top = 181
        Width = 155
        Height = 16
        Caption = 'Stoichiometric Ratio(kg/kg)'
      end
      object co2lbl: TiAnalogDisplay
        Tag = 1
        Left = 70
        Top = 18
        Width = 97
        Height = 33
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ErrorActive = False
        ErrorText = 'Error'
        ErrorFont.Charset = DEFAULT_CHARSET
        ErrorFont.Color = clRed
        ErrorFont.Height = -11
        ErrorFont.Name = 'Tahoma'
        ErrorFont.Style = [fsBold]
        ErrorBackGroundColor = clBlack
      end
      object collbl: TiAnalogDisplay
        Tag = 2
        Left = 70
        Top = 57
        Width = 97
        Height = 33
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -24
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ErrorActive = False
        ErrorText = 'Error'
        ErrorFont.Charset = DEFAULT_CHARSET
        ErrorFont.Color = clRed
        ErrorFont.Height = -11
        ErrorFont.Name = 'Tahoma'
        ErrorFont.Style = [fsBold]
        ErrorBackGroundColor = clBlack
      end
      object o2lbl: TiAnalogDisplay
        Tag = 3
        Left = 70
        Top = 96
        Width = 97
        Height = 33
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ErrorActive = False
        ErrorText = 'Error'
        ErrorFont.Charset = DEFAULT_CHARSET
        ErrorFont.Color = clRed
        ErrorFont.Height = -11
        ErrorFont.Name = 'Tahoma'
        ErrorFont.Style = [fsBold]
        ErrorBackGroundColor = clBlack
      end
      object noxlbl: TiAnalogDisplay
        Tag = 4
        Left = 70
        Top = 135
        Width = 97
        Height = 33
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -24
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ErrorActive = False
        ErrorText = 'Error'
        ErrorFont.Charset = DEFAULT_CHARSET
        ErrorFont.Color = clRed
        ErrorFont.Height = -11
        ErrorFont.Name = 'Tahoma'
        ErrorFont.Style = [fsBold]
        ErrorBackGroundColor = clBlack
      end
      object thclbl: TiAnalogDisplay
        Tag = 5
        Left = 70
        Top = 174
        Width = 97
        Height = 33
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -24
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ErrorActive = False
        ErrorText = 'Error'
        ErrorFont.Charset = DEFAULT_CHARSET
        ErrorFont.Color = clRed
        ErrorFont.Height = -11
        ErrorFont.Name = 'Tahoma'
        ErrorFont.Style = [fsBold]
        ErrorBackGroundColor = clBlack
      end
      object ch4lbl: TiAnalogDisplay
        Tag = 6
        Left = 70
        Top = 213
        Width = 97
        Height = 33
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -24
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ErrorActive = False
        ErrorText = 'Error'
        ErrorFont.Charset = DEFAULT_CHARSET
        ErrorFont.Color = clRed
        ErrorFont.Height = -11
        ErrorFont.Name = 'Tahoma'
        ErrorFont.Style = [fsBold]
        ErrorBackGroundColor = clBlack
      end
      object nonch4lbl: TiAnalogDisplay
        Tag = 7
        Left = 70
        Top = 252
        Width = 97
        Height = 33
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -24
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ErrorActive = False
        ErrorText = 'Error'
        ErrorFont.Charset = DEFAULT_CHARSET
        ErrorFont.Color = clRed
        ErrorFont.Height = -11
        ErrorFont.Name = 'Tahoma'
        ErrorFont.Style = [fsBold]
        ErrorBackGroundColor = clBlack
      end
      object CarbonEdit: TEdit
        Left = 394
        Top = 18
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 7
      end
      object HydrogenEdit: TEdit
        Left = 394
        Top = 48
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 8
      end
      object NitrogenEdit: TEdit
        Left = 394
        Top = 78
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 9
      end
      object OxygenEdit: TEdit
        Left = 394
        Top = 108
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 10
      end
      object SulfurEdit: TEdit
        Left = 394
        Top = 138
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 11
      end
      object DensityEdit: TEdit
        Left = 265
        Top = 224
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 12
      end
      object ViscosityEdit: TEdit
        Left = 265
        Top = 254
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = clWhite
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 13
      end
      object C_residueEdit: TEdit
        Left = 403
        Top = 220
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 14
      end
      object WaterEdit: TEdit
        Left = 403
        Top = 250
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 15
      end
      object CH4Edit: TEdit
        Left = 228
        Top = 18
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 16
      end
      object C2H6Edit: TEdit
        Left = 228
        Top = 48
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 17
      end
      object C3H8Edit: TEdit
        Left = 228
        Top = 78
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 18
      end
      object C4H10Edit: TEdit
        Left = 228
        Top = 108
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 19
      end
      object C5H12Edit: TEdit
        Left = 228
        Top = 138
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 20
      end
      object UseInputDensityCB: TCheckBox
        Left = 192
        Top = 204
        Width = 128
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Use Input Density'
        TabOrder = 21
      end
      object StoiRatioEdit: TEdit
        Left = 354
        Top = 179
        Width = 104
        Height = 24
        BiDiMode = bdRightToLeft
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 22
      end
    end
    object pgNox: TJvStandardPage
      Left = 0
      Top = 17
      Width = 486
      Height = 303
      object Label74: TLabel
        Left = 6
        Top = 24
        Width = 219
        Height = 16
        Caption = 'Nox humidity/temp. Correction Factor:'
      end
      object Label75: TLabel
        Left = 288
        Top = 83
        Width = 25
        Height = 16
        Caption = 'kg/h'
      end
      object Label76: TLabel
        Left = 6
        Top = 52
        Width = 203
        Height = 16
        Caption = 'Dry/Wet Correction Factor Exhaust:'
      end
      object Label77: TLabel
        Left = 289
        Top = 109
        Width = 25
        Height = 16
        Caption = 'kg/h'
      end
      object Label78: TLabel
        Left = 6
        Top = 80
        Width = 105
        Height = 16
        Caption = 'Exhaust Gas Flow:'
      end
      object Label79: TLabel
        Left = 6
        Top = 109
        Width = 52
        Height = 16
        Caption = 'Air Flow:'
      end
      object Label80: TLabel
        Left = 289
        Top = 139
        Width = 41
        Height = 16
        Caption = 'kg/kwh'
      end
      object Label81: TLabel
        Left = 289
        Top = 169
        Width = 24
        Height = 16
        Caption = 'kg/s'
      end
      object NhtCFEdit: TEdit
        Left = 231
        Top = 24
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 0
      end
      object DWCFEEdit: TEdit
        Left = 231
        Top = 52
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 1
      end
      object EGFEdit: TEdit
        Left = 231
        Top = 80
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 2
      end
      object AFEdit: TEdit
        Left = 231
        Top = 109
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 3
      end
      object AF2Edit: TEdit
        Left = 231
        Top = 139
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 4
      end
      object AF3Edit: TEdit
        Left = 231
        Top = 169
        Width = 55
        Height = 24
        BiDiMode = bdRightToLeft
        Color = 8454143
        ImeName = 'Microsoft Office IME 2007'
        ParentBiDiMode = False
        TabOrder = 5
      end
      object UseMT210CB: TCheckBox
        Left = 158
        Top = 208
        Width = 128
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Use MT210 Data'
        TabOrder = 6
      end
    end
    object pgGenerator: TJvStandardPage
      Left = 0
      Top = 17
      Width = 486
      Height = 303
      object JvListView1: TJvListView
        Left = 0
        Top = 41
        Width = 486
        Height = 262
        Align = alClient
        Columns = <
          item
            Caption = 'Engine Load(%)'
            Width = 110
          end
          item
            Caption = 'Eng. Output(kW)'
            Width = 110
          end
          item
            Caption = 'Gen.Efficiency(%/100)'
            Width = 140
          end
          item
            Caption = 'Gen.Output(kW)'
            Width = 120
          end>
        TabOrder = 0
        ViewStyle = vsReport
        ColumnsOrder = '0=110,1=110,2=140,3=120'
        ExtendedColumns = <
          item
          end
          item
          end
          item
          end
          item
          end>
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 486
        Height = 41
        Align = alTop
        TabOrder = 1
        object Label90: TLabel
          Left = 16
          Top = 14
          Width = 111
          Height = 16
          Caption = 'File Name(csv file):'
        end
        object JvFilenameEdit1: TJvFilenameEdit
          Left = 133
          Top = 11
          Width = 193
          Height = 24
          Filter = 'csv files (*.csv)|*.csv'
          ImeName = 'Microsoft Office IME 2007'
          TabOrder = 0
          Text = ''
        end
        object JvBitBtn1: TJvBitBtn
          Left = 360
          Top = 10
          Width = 121
          Height = 25
          Caption = 'Data Load'
          TabOrder = 1
          OnClick = JvBitBtn1Click
        end
      end
    end
    object JvGroupHeader1: TJvGroupHeader
      Left = 0
      Top = 320
      Width = 486
      Height = 2
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      BevelSpace = 4
      ExplicitWidth = 413
    end
    object JvGroupHeader2: TJvGroupHeader
      Left = 0
      Top = 0
      Width = 486
      Height = 17
      Align = alTop
      Caption = 'Engine Settings'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      BevelSpace = 4
      OnClick = JvGroupHeader2Click
      ExplicitWidth = 413
    end
  end
  object ImageList1: TImageList
    Left = 8
    Top = 128
    Bitmap = {
      494C010103000400080010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008484840000000000C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF0084848400000000000000000000000000848484000000000000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00000000008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000848484000000000000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C600848484000000000000000000000000008484840000000000C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF008484
      8400000000008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008484840000000000C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF008484840000000000000000008484840000000000C6C6C60000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C6000000
      0000848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000848484000000000000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C6008484840000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF008484840000000000000000000000000000000000000000000000
      0000848484008484840084848400848484008484840084848400848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008484840000000000C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF008484840000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400C6C6C6008484840000000000000000000000000000000000000000000000
      00008484840084848400C6C6C60084848400C6C6C60084848400C6C6C6008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000848484000000000000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C600848484000000000000000000000000008484840000000000C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF008484840000000000000000000000000000000000000000000000
      000084848400C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084848400000000000000000000000000848484000000000000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000000000000000000000
      0000000000008484840000000000000000000000000000000000000000000000
      000084848400848484008484840084848400C6C6C600C6C6C600848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400C6C6C60000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60084848400848484008484
      8400848484008484840000000000000000000000000084848400000000000000
      000000FFFF00C6C6C60000FFFF00000000000000000084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      000000000000000000000000000084848400C6C6C60084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C6008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFFFFFFFFF0000
      C001E001FFFF00008001C001FEFF0000A001A001FE7F0000A001A001FE3F0000
      A0014001F01F0000A0017FE1F00F0000A0010001F0070000A001A001F00F0000
      BFF9A079F01F00008003B183FE3F0000C07FDF7FFE7F0000E0FFE0FFFEFF0000
      FFFFFFFFFFFF0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
  object ActionList1: TActionList
    Images = ImageList1
    Left = 8
    Top = 160
  end
  object ImageList2: TImageList
    Left = 8
    Top = 96
    Bitmap = {
      494C010104000900080010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C6C6C600C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      000084000000C6C6C60000000000000000000000000000000000000000008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000084848400FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000840000008400000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008484840000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008484840000000000000000000000000000000000000000008484
      8400C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C6008484840000000000000000000000000084848400FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000840000008400000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008484840000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008484840000000000000000000000000000000000000000008484
      8400C6C6C600C6C6C600C6C6C60000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C6008484840000000000000000000000000084848400FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000840000008400000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008484840000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008484840000000000000000000000000000000000000000008484
      8400C6C6C600C6C6C600000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C6008484840000000000000000000000000084848400FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000840000008400000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008484840000000000000000000000000000000000000000008484
      8400FFFFFF000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF008484840000000000000000000000000000000000000000008484
      8400C6C6C6000000000000000000000000000000000000000000C6C6C600C6C6
      C600C6C6C6008484840000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C6C6C6008400000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008484840000000000000000000000000000000000000000008484
      8400FFFFFF000000000000000000FFFFFF00000000000000000000000000FFFF
      FF00FFFFFF008484840000000000000000000000000000000000000000008484
      8400C6C6C6000000000000000000C6C6C600000000000000000000000000C6C6
      C600C6C6C60084848400000000000000000084848400C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C6C6C600C6C6C60000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008484840000000000000000000000000000000000000000008484
      8400FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000FFFFFF008484840000000000000000000000000000000000000000008484
      8400C6C6C60000000000C6C6C600C6C6C600C6C6C60000000000000000000000
      0000C6C6C60084848400000000000000000084848400C6C6C60084848400C6C6
      C600C6C6C600C6C6C6000000000000FF0000FFFF0000C6C6C600C6C6C6000000
      0000000000008484840000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008484840000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000FFFFFF008484840000000000000000000000000000000000000000008484
      8400C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600000000000000
      0000C6C6C600848484000000000000000000000000008484840084848400C6C6
      C600C6C6C60000FF0000FFFFFF0000000000C6C6C600C6C6C600C6C6C6000000
      0000848484000000000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008484840000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF008484840000000000000000000000000000000000000000008484
      8400C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000C6C6C600848484000000000000000000000000000000000084848400C6C6
      C60000FF00008484000084840000C6C6C600FFFFFF00C6C6C600C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008484840000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008484840000000000000000000000000000000000000000008484
      8400C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C6008484840000000000000000000000000000000000C6C6C60000FF
      0000FFFF0000FFFF000000FFFF00C6C6C600C6C6C600FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000008484
      84008484000000FFFF0000FFFF00C6C6C600C6C6C6008484840000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484008484840084848400848484008484840000000000848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000008007FFFFFFFFFFFF8003FFFFFFFFFFFF
      8001FFFFFFFFFFFF8001E003E003E0038001E003E003E0038001E003E003E003
      8001E003E003E0038001E003E003E0038001E003E003E0030001E003E003E003
      0000E003E003E0038001E003E003E003C007E003E003E003C007E003E003E003
      E007FFFFFFFFFFFFF007FFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object JvgXMLSerializer: TJvgXMLSerializer
    ExcludeEmptyValues = True
    ExcludeDefaultValues = True
    ReplaceReservedSymbols = True
    IgnoreUnknownTags = False
    Left = 8
    Top = 64
  end
end
