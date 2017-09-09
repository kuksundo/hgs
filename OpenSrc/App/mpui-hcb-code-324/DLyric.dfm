object DLyricForm: TDLyricForm
  Left = 305
  Top = 69
  Width = 601
  Height = 478
  Color = clBtnFace
  Constraints.MinHeight = 478
  Constraints.MinWidth = 526
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnHide = TntFormHide
  OnShow = TntFormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PLS: TTntPageControl
    Left = 0
    Top = 0
    Width = 593
    Height = 444
    ActivePage = SSubtitle
    Align = alClient
    TabOrder = 0
    OnChange = PLSChange
    object SLyric: TTntTabSheet
      Caption = 'Lyric'
      DesignSize = (
        585
        416)
      object LArtist: TTntLabel
        Left = 16
        Top = 16
        Width = 30
        Height = 13
        Caption = 'Artist:'
      end
      object LTitle: TTntLabel
        Left = 16
        Top = 43
        Width = 24
        Height = 13
        Caption = 'Title:'
      end
      object EArtist: TTntEdit
        Left = 88
        Top = 13
        Width = 369
        Height = 21
        TabOrder = 3
      end
      object ETitle: TTntEdit
        Left = 88
        Top = 40
        Width = 369
        Height = 21
        TabOrder = 0
      end
      object BSearch: TTntButton
        Left = 470
        Top = 12
        Width = 105
        Height = 49
        Caption = 'Search'
        Default = True
        TabOrder = 1
        OnClick = BSearchClick
      end
      object LyricListView: TTntListView
        Left = 4
        Top = 72
        Width = 575
        Height = 307
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Lyric ID'
            Width = 0
          end
          item
            AutoSize = True
            Caption = 'Artist'
          end
          item
            AutoSize = True
            Caption = 'Title'
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 2
        ViewStyle = vsReport
        OnDblClick = BApplyClick
      end
      object BLSave: TTntButton
        Left = 9
        Top = 390
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Save'
        Enabled = False
        TabOrder = 4
        OnClick = BSaveClick
      end
      object BLApply: TTntButton
        Left = 211
        Top = 390
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Apply'
        Enabled = False
        TabOrder = 5
        OnClick = BApplyClick
      end
      object BLClose: TTntButton
        Left = 500
        Top = 390
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Close'
        TabOrder = 6
        OnClick = BCloseClick
      end
    end
    object SSubtitle: TTntTabSheet
      Caption = 'Subtitle'
      DesignSize = (
        585
        416)
      object LSTitle: TTntLabel
        Left = 228
        Top = 11
        Width = 24
        Height = 13
        Alignment = taRightJustify
        Caption = 'Title:'
      end
      object LSLang: TTntLabel
        Left = 6
        Top = 11
        Width = 51
        Height = 13
        Caption = 'Language:'
      end
      object SubListView: TTntListView
        Left = 4
        Top = 40
        Width = 577
        Height = 339
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Sub ID'
            Width = 0
          end
          item
            AutoSize = True
            Caption = 'Movie Name'
          end
          item
            Caption = 'Language'
            Width = 80
          end
          item
            Caption = 'Format'
          end
          item
            Caption = 'CD Sum'
          end
          item
            Caption = 'Download Count'
            Width = 100
          end
          item
            Caption = 'Add Date'
            Width = 100
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        SortType = stText
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = BApplyClick
      end
      object CLang: TTntComboBox
        Left = 83
        Top = 8
        Width = 105
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'All'
        OnClick = CLangClick
        Items.Strings = (
          'All'
          'Albanian'
          'Arabic'
          'Armenian'
          'Bengali'
          'Bosnian'
          'Portuguese-BR'
          'Bulgarian'
          'Catalan'
          'Chinese'
          'Croatian'
          'Czech'
          'Danish'
          'Dutch'
          'English'
          'Esperanto'
          'Estonian'
          'Finnish'
          'French'
          'Galician'
          'Georgian'
          'German'
          'Greek'
          'Hebrew'
          'Hindi'
          'Hungarian'
          'Icelandic'
          'Indonesian'
          'Italian'
          'Japanese'
          'Kazakh'
          'Korean'
          'Latvian'
          'Lithuanian'
          'Luxembourgish'
          'Macedonian'
          'Malay'
          'Norwegian'
          'Occitan'
          'Farsi'
          'Polish'
          'Portuguese'
          'Romanian'
          'Russian'
          'Serbian'
          'Sinhalese'
          'Slovak'
          'Slovenian'
          'Spanish'
          'Swedish'
          'Syriac'
          'Tagalog'
          'Thai'
          'Turkish'
          'Ukrainian'
          'Urdu'
          'Vietnamese')
      end
      object ESTitle: TTntEdit
        Left = 256
        Top = 8
        Width = 236
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
      end
      object BSSearch: TTntButton
        Left = 507
        Top = 4
        Width = 73
        Height = 29
        Anchors = [akTop, akRight]
        Caption = 'Search'
        Default = True
        TabOrder = 3
        OnClick = BSearchClick
      end
      object BSave: TTntButton
        Left = 9
        Top = 390
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Save'
        Enabled = False
        TabOrder = 4
        OnClick = BSaveClick
      end
      object BApply: TTntButton
        Left = 211
        Top = 390
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Apply'
        Enabled = False
        TabOrder = 5
        OnClick = BApplyClick
      end
      object BClose: TTntButton
        Left = 500
        Top = 390
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Close'
        TabOrder = 6
        OnClick = BCloseClick
      end
    end
  end
end
