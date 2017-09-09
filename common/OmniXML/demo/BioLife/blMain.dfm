object frmBioLife: TfrmBioLife
  Left = 374
  Top = 200
  ActiveControl = lbLog
  Caption = 'OmniXML: BioLife demo'
  ClientHeight = 573
  ClientWidth = 667
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 417
    Height = 444
    Align = alLeft
    DataSource = DataSource1
    ImeName = 'Microsoft IME 2010'
    Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object lbLog: TListBox
    Left = 0
    Top = 444
    Width = 667
    Height = 129
    Align = alBottom
    ImeName = 'Microsoft IME 2010'
    ItemHeight = 13
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 417
    Top = 0
    Width = 250
    Height = 444
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object DBMemo1: TDBMemo
      Left = 0
      Top = 0
      Width = 250
      Height = 225
      Align = alTop
      DataField = 'Notes'
      DataSource = DataSource1
      ImeName = 'Microsoft IME 2010'
      TabOrder = 0
    end
    object DBImage1: TDBImage
      Left = 0
      Top = 225
      Width = 250
      Height = 219
      Align = alClient
      DataField = 'Graphic'
      DataSource = DataSource1
      TabOrder = 1
    end
  end
  object tblBioLife: TTable
    DatabaseName = 'DBDEMOS'
    TableName = 'biolife.db'
    Left = 576
    Top = 16
  end
  object DataSource1: TDataSource
    Left = 640
    Top = 16
  end
end
