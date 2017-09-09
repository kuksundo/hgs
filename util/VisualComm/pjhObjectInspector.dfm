object frmProps: TfrmProps
  Left = 351
  Top = 275
  HorzScrollBar.Tracking = True
  BorderIcons = [biSystemMenu]
  Caption = 'Object Inspector'
  ClientHeight = 373
  ClientWidth = 209
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000FFFFFFFFFF000000F00F00000F000000FFFFFFFFFF000000F00
    F00000F000000FFFFFFFFFF000000FFFFFFF0FF000000F00FFF070F000000F07
    0F07070000440FF0707070777044000007070777774400000070777777440000
    000777777044000000000000004400000000000000000000000000000000000F
    0000000F0000000F0000000F0000000F0000000F0000000F0000000F00000004
    00000000000000000000F8000000FC000000FE040000FFFF0000FFFF0000}
  KeyPreview = True
  OldCreateOrder = False
  Scaled = False
  Visible = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 354
    Width = 209
    Height = 19
    Panels = <>
  end
  object Panel2: TPanel
    Left = 0
    Top = 25
    Width = 209
    Height = 329
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 0
      Top = 0
      Width = 209
      Height = 329
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'Properties'
        object PropInsp: TpjhPropertyInspector
          Left = 0
          Top = 0
          Width = 201
          Height = 301
          Splitter = 84
          Align = alClient
          TabOrder = 0
          OnGetComponent = PropInspGetComponent
          OnGetComponentNames = PropInspGetComponentNames
          OnFilterProp = PropInspFilterProp
          OnModified = PropInspModified
          OnUpdateParam = PropInspUpdateParam
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 209
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object ComponentList: TComboBox
      Left = 16
      Top = 1
      Width = 185
      Height = 21
      Style = csDropDownList
      ImeName = #54620#44397#50612'('#54620#44544')'
      Sorted = True
      TabOrder = 0
      OnChange = ComponentListChange
    end
  end
end
