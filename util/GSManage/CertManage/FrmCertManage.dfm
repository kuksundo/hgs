object CertManageF: TCertManageF
  Left = 0
  Top = 0
  Caption = 'Cert ManageR'
  ClientHeight = 790
  ClientWidth = 1559
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 111
    Width = 1559
    Height = 6
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = -55
    ExplicitTop = 132
    ExplicitWidth = 1305
  end
  object CurvyPanel1: TCurvyPanel
    AlignWithMargins = True
    Left = 0
    Top = 0
    Width = 1559
    Height = 111
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    Rounding = 4
    TabOrder = 0
    object Panel1: TPanel
      Left = 1354
      Top = 0
      Width = 205
      Height = 111
      Align = alRight
      TabOrder = 0
      object btn_Search: TAeroButton
        AlignWithMargins = True
        Left = 3
        Top = 4
        Width = 62
        Height = 103
        ImageIndex = 3
        Images = ImageList32x32
        ImagePos = ipTop
        Version = '1.0.0.1'
        Align = alRight
        Caption = 'Find'
        TabOrder = 0
        OnClick = btn_SearchClick
      end
      object btn_Close: TAeroButton
        AlignWithMargins = True
        Left = 139
        Top = 4
        Width = 62
        Height = 103
        ImageIndex = 0
        Images = ImageList32x32
        ImagePos = ipTop
        Version = '1.0.0.1'
        Align = alRight
        Caption = 'Close'
        ModalResult = 8
        TabOrder = 1
        OnClick = btn_CloseClick
      end
      object AeroButton1: TAeroButton
        AlignWithMargins = True
        Left = 71
        Top = 4
        Width = 62
        Height = 103
        ImageIndex = 1
        Images = ImageList32x32
        ImagePos = ipTop
        Version = '1.0.0.1'
        Align = alRight
        Caption = 'Export'
        TabOrder = 2
        OnClick = AeroButton1Click
      end
    end
    object GroupBox1: TGroupBox
      Left = 1272
      Top = 0
      Width = 82
      Height = 111
      Align = alRight
      Caption = 'Cert Type'
      TabOrder = 1
      object EducationCheck: TCheckBox
        Left = 3
        Top = 19
        Width = 65
        Height = 17
        Caption = 'Education'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object APTServiceCheck: TCheckBox
        Left = 3
        Top = 41
        Width = 73
        Height = 17
        Caption = 'APT Service'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object APTApprovalCheck: TCheckBox
        Left = 4
        Top = 63
        Width = 72
        Height = 17
        Caption = 'Prod Approval'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 352
      Height = 111
      Align = alLeft
      TabOrder = 2
      object JvLabel2: TJvLabel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 80
        Height = 103
        Align = alLeft
        Alignment = taCenter
        AutoSize = False
        Caption = 'Period'
        Color = 14671839
        FrameColor = clGrayText
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = [fsBold]
        Layout = tlCenter
        ParentColor = False
        ParentFont = False
        RoundedFrame = 3
        Transparent = True
        HotTrackFont.Charset = ANSI_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -13
        HotTrackFont.Name = #47569#51008' '#44256#46357
        HotTrackFont.Style = []
        ExplicitLeft = -6
        ExplicitTop = 8
        ExplicitHeight = 92
      end
      object PeriodPanel: TCurvyPanel
        AlignWithMargins = True
        Left = 87
        Top = 4
        Width = 261
        Height = 103
        Margins.Left = 0
        Align = alLeft
        Rounding = 4
        TabOrder = 0
        object Label4: TLabel
          Left = 124
          Top = 60
          Width = 8
          Height = 13
          Caption = '~'
        end
        object rg_period: TAdvOfficeRadioGroup
          AlignWithMargins = True
          Left = 3
          Top = 26
          Width = 255
          Height = 35
          BorderStyle = bsNone
          Version = '1.3.8.5'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
          OnClick = rg_periodClick
          Columns = 4
          ItemIndex = 3
          Items.Strings = (
            '1Year'
            '2Year'
            '5Year'
            'Select')
          ButtonVertAlign = tlCenter
          Ellipsis = False
        end
        object dt_begin: TDateTimePicker
          Left = 5
          Top = 57
          Width = 113
          Height = 25
          Date = 41527.710435775480000000
          Time = 41527.710435775480000000
          Enabled = False
          ImeName = 'Microsoft IME 2010'
          TabOrder = 1
        end
        object dt_end: TDateTimePicker
          Left = 136
          Top = 56
          Width = 113
          Height = 25
          Date = 41527.710435775480000000
          Time = 41527.710435775480000000
          Enabled = False
          ImeName = 'Microsoft IME 2010'
          TabOrder = 2
        end
        object ComboBox1: TComboBox
          Left = 3
          Top = 5
          Width = 255
          Height = 25
          Style = csDropDownList
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = []
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 3
        end
      end
    end
    object Panel4: TPanel
      Left = 352
      Top = 0
      Width = 920
      Height = 111
      Align = alClient
      TabOrder = 3
      object Panel2: TPanel
        Left = 1
        Top = 1
        Width = 918
        Height = 38
        Align = alTop
        TabOrder = 0
        object JvLabel1: TJvLabel
          AlignWithMargins = True
          Left = 3
          Top = 8
          Width = 110
          Height = 25
          Alignment = taCenter
          AutoSize = False
          Caption = 'Product Type'
          Color = 14671839
          FrameColor = clGrayText
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          RoundedFrame = 3
          Transparent = True
          HotTrackFont.Charset = ANSI_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -13
          HotTrackFont.Name = #47569#51008' '#44256#46357
          HotTrackFont.Style = []
        end
        object JvLabel5: TJvLabel
          AlignWithMargins = True
          Left = 295
          Top = 8
          Width = 110
          Height = 25
          Alignment = taCenter
          AutoSize = False
          Caption = 'Company Name'
          Color = 14671839
          FrameColor = clGrayText
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          RoundedFrame = 3
          Transparent = True
          HotTrackFont.Charset = ANSI_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -13
          HotTrackFont.Name = #47569#51008' '#44256#46357
          HotTrackFont.Style = []
        end
        object JvLabel4: TJvLabel
          AlignWithMargins = True
          Left = 604
          Top = 8
          Width = 110
          Height = 25
          Alignment = taCenter
          AutoSize = False
          Caption = 'Cert No.'
          Color = 14671839
          FrameColor = clGrayText
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          RoundedFrame = 3
          Transparent = True
          HotTrackFont.Charset = ANSI_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -13
          HotTrackFont.Name = #47569#51008' '#44256#46357
          HotTrackFont.Style = []
        end
        object ProdTypeCB: TComboBox
          Left = 119
          Top = 11
          Width = 170
          Height = 21
          Style = csDropDownList
          ImeName = 'Microsoft IME 2010'
          TabOrder = 0
        end
        object CertNoEdit: TEdit
          Left = 715
          Top = 10
          Width = 198
          Height = 21
          CharCase = ecUpperCase
          ImeName = 'Microsoft IME 2010'
          TabOrder = 1
          OnKeyPress = CertNoEditKeyPress
        end
        object CompanyNameEdit: TAdvEditBtn
          Tag = 3
          Left = 411
          Top = 9
          Width = 190
          Height = 24
          EmptyTextStyle = []
          Flat = False
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          Lookup.Font.Charset = DEFAULT_CHARSET
          Lookup.Font.Color = clWindowText
          Lookup.Font.Height = -11
          Lookup.Font.Name = 'Arial'
          Lookup.Font.Style = []
          Lookup.Separator = ';'
          Color = clWindow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          ReadOnly = False
          TabOrder = 2
          Text = ''
          Visible = True
          Version = '1.3.5.0'
          ButtonStyle = bsButton
          ButtonWidth = 20
          Etched = False
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FF4D74AB234179C5ABA7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF4173AF008EEC009AF41F4B80FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFF2F6EB22BA7
            F516C0FF00A0F3568BC3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFEFFFF2974BB68C4F86BD4FF279CE66696C8FFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3D8FD5A4E3FEB5EEFF4CAA
            E7669DD2FFFFFFFFFFFFFFFFFFFFFFFFFEFEFEA188898A6A6A93736E866567B0
            9595BAA8B1359EE8BDF5FF77C4EF63A1DAFFFFFFFFFFFFFFFFFFFFFFFFD7CDCD
            7E5857DFD3CBFFFFF7FFFFE7FFFEDBD6BB9E90584D817B8E1794E46BB5E9FFFF
            FFFFFFFFFFFFFFFFFFFFEDE9E9886565FFFFFFFFFFFFFDF8E8FAF2DCF8EDCFFF
            F1CFF6DEBA9F5945C0C7D5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA38889F6EFEA
            FFFFFFFEFBF5FBF7E8F9F4DAF5EBCCE6CEACF3DAB8E2BD99AB8B8EFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF937674FFFFFFFDFBF1FCF8EEFAF3E1FCF5E3F7F0D7F0
            DFC1E7C9A9F0D1ABA87E75F8F6F6FFFFFFFFFFFFFFFFFFFFFFFF997D7AFFFFFC
            F9F2E1FAF3DEFAF7E5FAF1DCF1DFC0EDD9BAECD8B9EDCAA5AF8679EDE8E9FFFF
            FFFFFFFFFFFFFFFFFFFF9C807BFFFFEBF9EED5FAF1D7F9F2DAF2E3C6FEFBF9FF
            FFF0EFDFC0E9C69EB0857BF5F2F3FFFFFFFFFFFFFFFFFFFFFFFFAF9596F7EAC8
            F9EBCCEFDCBEF4E4C7F0E1C5FDFCECFAF5DDEFDCBCDFB087B59A9AFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFDED4D7BA998CFDECC4EDD4B0E5CAA8EFDBBFF2E3C4F2
            DEBCEABF93BB8E7DE7DFE2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCEBFC5
            BE9A8DE6C7A5EFCBA3ECC8A2E8BE94DCAA86BE9585DFD6D7FFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9E4E6C9B3B4B99C93C3A097BF9F96CC
            B9B7F1EEEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
          OnClickBtn = CompanyNameEditClickBtn
        end
      end
      object EducationPanel: TPanel
        Left = 1
        Top = 39
        Width = 918
        Height = 33
        Align = alTop
        TabOrder = 1
        object JvLabel6: TJvLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 110
          Height = 25
          Alignment = taCenter
          AutoSize = False
          Caption = 'Trained Subject'
          Color = 14671839
          FrameColor = clGrayText
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          RoundedFrame = 3
          Transparent = True
          HotTrackFont.Charset = ANSI_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -13
          HotTrackFont.Name = #47569#51008' '#44256#46357
          HotTrackFont.Style = []
        end
        object JvLabel3: TJvLabel
          AlignWithMargins = True
          Left = 295
          Top = 6
          Width = 110
          Height = 25
          Alignment = taCenter
          AutoSize = False
          Caption = 'Trained Course'
          Color = 14671839
          FrameColor = clGrayText
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          RoundedFrame = 3
          Transparent = True
          HotTrackFont.Charset = ANSI_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -13
          HotTrackFont.Name = #47569#51008' '#44256#46357
          HotTrackFont.Style = []
        end
        object JvLabel7: TJvLabel
          AlignWithMargins = True
          Left = 604
          Top = 6
          Width = 110
          Height = 25
          Alignment = taCenter
          AutoSize = False
          Caption = 'Trainee Name'
          Color = 14671839
          FrameColor = clGrayText
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          Layout = tlCenter
          ParentColor = False
          ParentFont = False
          RoundedFrame = 3
          Transparent = True
          HotTrackFont.Charset = ANSI_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -13
          HotTrackFont.Name = #47569#51008' '#44256#46357
          HotTrackFont.Style = []
        end
        object TraineeNameEdit: TEdit
          Left = 715
          Top = 8
          Width = 198
          Height = 21
          CharCase = ecUpperCase
          ImeName = 'Microsoft IME 2010'
          TabOrder = 0
          OnKeyPress = TraineeNameEditKeyPress
        end
        object SubjectEdit: TNxButtonEdit
          Tag = 7
          Left = 119
          Top = 4
          Width = 170
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnButtonDown = SubjectEditButtonDown
          ButtonCaption = '<<'
          ButtonGlyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            18000000000000030000000000000000000000000000000000003F3C398C8482
            6562602D2B292C2829312D2D383635FFFFFFFFFFFF3835358A84813533312120
            1F2221212C2829302E2E272323BAB7B075716C1310101110101A1A183C3835FF
            FFFFFFFFFF474444EBE6E4332F2E110F0F1716152F2D2B333131504B48CFC8CA
            BABAB556504E514B494B4645494443FFFFFFFFFFFF6B675FBEBCBAA5A09E514D
            494C4746494643312E2C76716FCCCCC8EFEDED8E88837F7B776F69664E4B46FF
            FFFFFFFFFF716D66AFAAA6F5F5F3857F7B736D6B615C5946424183807EBAB5B2
            E8E8E686827E6C68646863614B4646FFFFFFFFFFFF64635EABA6A0E0E0DE746D
            6B67625D625D5B5E5D5DB3B2AFABA5A0F9FBFB9E9A98746F6C716C69575352FF
            FFFFFFFFFF625F5CADA8A3F5F5F5807B78736D69635D5B9E9D9DB5B3B3888280
            F9F7F7B5ADAB716C69716C685A56558B8887AFAEAC5D5B58A6A29DF3F3F3827E
            79736F6B514C4A9291918481803935353834322F2B2A2521213D3A386F69685B
            56552A28276F68684D47441515140B090A0B0A0B0C0B0C3C3C3CBCBABA8B8682
            EBE8E8F1F1F3E0DAD77C7775645F61645D5C2927266F6966575151EFEDEBF9F9
            F5D7D3CFE9E2DA969494D2D0CF736F69D7D7D5DAD5D7C5C1BE716C6B5F5B595F
            58572826256B6663524F4DE6E6E4CECCCCBAB5B4A59E9BB2B2B1DFDEDE645D5B
            D5D1CFE9EBEDE2E2DE7B777766615F6B6362262323595451494542FDFDFBEBED
            EDE0E0DC97918ECCCCCCFFFFFF817D7AE8E2E0C3C3C07F787555514F59565440
            3D3B332F2FB7AFAB7F7B77A39D9D8C898697918F53504FFFFFFFFFFFFFC3C1C1
            A09B9B5B5755AAA6A37873703D3938FFFFFFFFFFFF9D9A98F5F5EB524E4D312E
            2E52504E767474FFFFFFFFFFFFFFFFFFFFFFFF6966629B98975E59572E2B28FF
            FFFFFFFFFF5651508C8B863C3838464444FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF6D6867FFFFFFF3EDEBA29D9AFFFFFFFFFFFFAAA5A5FFFFFFF1EBE66965
            63FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6A6865A5A2A08B87845E5956FF
            FFFFFFFFFF625E5C9C9997726E6E53514EFFFFFFFFFFFFFFFFFF}
          ButtonWidth = 30
          TransparentColor = clNone
        end
        object CourseEdit: TNxButtonEdit
          Tag = 8
          Left = 411
          Top = 6
          Width = 190
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnButtonClick = CourseEditButtonClick
          ButtonCaption = '<<'
          ButtonGlyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            18000000000000030000000000000000000000000000000000003F3C398C8482
            6562602D2B292C2829312D2D383635FFFFFFFFFFFF3835358A84813533312120
            1F2221212C2829302E2E272323BAB7B075716C1310101110101A1A183C3835FF
            FFFFFFFFFF474444EBE6E4332F2E110F0F1716152F2D2B333131504B48CFC8CA
            BABAB556504E514B494B4645494443FFFFFFFFFFFF6B675FBEBCBAA5A09E514D
            494C4746494643312E2C76716FCCCCC8EFEDED8E88837F7B776F69664E4B46FF
            FFFFFFFFFF716D66AFAAA6F5F5F3857F7B736D6B615C5946424183807EBAB5B2
            E8E8E686827E6C68646863614B4646FFFFFFFFFFFF64635EABA6A0E0E0DE746D
            6B67625D625D5B5E5D5DB3B2AFABA5A0F9FBFB9E9A98746F6C716C69575352FF
            FFFFFFFFFF625F5CADA8A3F5F5F5807B78736D69635D5B9E9D9DB5B3B3888280
            F9F7F7B5ADAB716C69716C685A56558B8887AFAEAC5D5B58A6A29DF3F3F3827E
            79736F6B514C4A9291918481803935353834322F2B2A2521213D3A386F69685B
            56552A28276F68684D47441515140B090A0B0A0B0C0B0C3C3C3CBCBABA8B8682
            EBE8E8F1F1F3E0DAD77C7775645F61645D5C2927266F6966575151EFEDEBF9F9
            F5D7D3CFE9E2DA969494D2D0CF736F69D7D7D5DAD5D7C5C1BE716C6B5F5B595F
            58572826256B6663524F4DE6E6E4CECCCCBAB5B4A59E9BB2B2B1DFDEDE645D5B
            D5D1CFE9EBEDE2E2DE7B777766615F6B6362262323595451494542FDFDFBEBED
            EDE0E0DC97918ECCCCCCFFFFFF817D7AE8E2E0C3C3C07F787555514F59565440
            3D3B332F2FB7AFAB7F7B77A39D9D8C898697918F53504FFFFFFFFFFFFFC3C1C1
            A09B9B5B5755AAA6A37873703D3938FFFFFFFFFFFF9D9A98F5F5EB524E4D312E
            2E52504E767474FFFFFFFFFFFFFFFFFFFFFFFF6966629B98975E59572E2B28FF
            FFFFFFFFFF5651508C8B863C3838464444FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF6D6867FFFFFFF3EDEBA29D9AFFFFFFFFFFFFAAA5A5FFFFFFF1EBE66965
            63FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6A6865A5A2A08B87845E5956FF
            FFFFFFFFFF625E5C9C9997726E6E53514EFFFFFFFFFFFFFFFFFF}
          ButtonWidth = 30
          TransparentColor = clNone
        end
      end
      object Panel5: TPanel
        Left = 1
        Top = 72
        Width = 918
        Height = 38
        Align = alClient
        TabOrder = 2
        object JvLabel23: TJvLabel
          AlignWithMargins = True
          Left = 3
          Top = 6
          Width = 110
          Height = 25
          Alignment = taCenter
          AutoSize = False
          Caption = 'IMO No.'
          Color = 14671839
          FrameColor = clGrayText
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          Layout = tlCenter
          Margin = 5
          ParentColor = False
          ParentFont = False
          RoundedFrame = 3
          Transparent = True
          HotTrackFont.Charset = ANSI_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -13
          HotTrackFont.Name = #47569#51008' '#44256#46357
          HotTrackFont.Style = []
        end
        object JvLabel19: TJvLabel
          AlignWithMargins = True
          Left = 295
          Top = 6
          Width = 110
          Height = 25
          Alignment = taCenter
          AutoSize = False
          Caption = 'Ship Name'
          Color = 14671839
          FrameColor = clGrayText
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          Layout = tlCenter
          Margin = 5
          ParentColor = False
          ParentFont = False
          RoundedFrame = 3
          Transparent = True
          HotTrackFont.Charset = ANSI_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -13
          HotTrackFont.Name = #47569#51008' '#44256#46357
          HotTrackFont.Style = []
        end
        object JvLabel21: TJvLabel
          AlignWithMargins = True
          Left = 604
          Top = 7
          Width = 110
          Height = 25
          Alignment = taCenter
          AutoSize = False
          Caption = 'Hull No.'
          Color = 14671839
          FrameColor = clGrayText
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          Layout = tlCenter
          Margin = 5
          ParentColor = False
          ParentFont = False
          RoundedFrame = 3
          Transparent = True
          HotTrackFont.Charset = ANSI_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -13
          HotTrackFont.Name = #47569#51008' '#44256#46357
          HotTrackFont.Style = []
        end
        object IMONoEdit: TNxButtonEdit
          Tag = 14
          Left = 119
          Top = 7
          Width = 170
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnKeyPress = IMONoEditKeyPress
          OnButtonClick = IMONoEditButtonClick
          ButtonCaption = '<<'
          ButtonGlyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            18000000000000030000000000000000000000000000000000003F3C398C8482
            6562602D2B292C2829312D2D383635FFFFFFFFFFFF3835358A84813533312120
            1F2221212C2829302E2E272323BAB7B075716C1310101110101A1A183C3835FF
            FFFFFFFFFF474444EBE6E4332F2E110F0F1716152F2D2B333131504B48CFC8CA
            BABAB556504E514B494B4645494443FFFFFFFFFFFF6B675FBEBCBAA5A09E514D
            494C4746494643312E2C76716FCCCCC8EFEDED8E88837F7B776F69664E4B46FF
            FFFFFFFFFF716D66AFAAA6F5F5F3857F7B736D6B615C5946424183807EBAB5B2
            E8E8E686827E6C68646863614B4646FFFFFFFFFFFF64635EABA6A0E0E0DE746D
            6B67625D625D5B5E5D5DB3B2AFABA5A0F9FBFB9E9A98746F6C716C69575352FF
            FFFFFFFFFF625F5CADA8A3F5F5F5807B78736D69635D5B9E9D9DB5B3B3888280
            F9F7F7B5ADAB716C69716C685A56558B8887AFAEAC5D5B58A6A29DF3F3F3827E
            79736F6B514C4A9291918481803935353834322F2B2A2521213D3A386F69685B
            56552A28276F68684D47441515140B090A0B0A0B0C0B0C3C3C3CBCBABA8B8682
            EBE8E8F1F1F3E0DAD77C7775645F61645D5C2927266F6966575151EFEDEBF9F9
            F5D7D3CFE9E2DA969494D2D0CF736F69D7D7D5DAD5D7C5C1BE716C6B5F5B595F
            58572826256B6663524F4DE6E6E4CECCCCBAB5B4A59E9BB2B2B1DFDEDE645D5B
            D5D1CFE9EBEDE2E2DE7B777766615F6B6362262323595451494542FDFDFBEBED
            EDE0E0DC97918ECCCCCCFFFFFF817D7AE8E2E0C3C3C07F787555514F59565440
            3D3B332F2FB7AFAB7F7B77A39D9D8C898697918F53504FFFFFFFFFFFFFC3C1C1
            A09B9B5B5755AAA6A37873703D3938FFFFFFFFFFFF9D9A98F5F5EB524E4D312E
            2E52504E767474FFFFFFFFFFFFFFFFFFFFFFFF6966629B98975E59572E2B28FF
            FFFFFFFFFF5651508C8B863C3838464444FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF6D6867FFFFFFF3EDEBA29D9AFFFFFFFFFFFFAAA5A5FFFFFFF1EBE66965
            63FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6A6865A5A2A08B87845E5956FF
            FFFFFFFFFF625E5C9C9997726E6E53514EFFFFFFFFFFFFFFFFFF}
          ButtonWidth = 30
          TransparentColor = clNone
        end
        object ShipNameEdit: TNxButtonEdit
          Tag = 15
          Left = 411
          Top = 7
          Width = 190
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnKeyPress = ShipNameEditKeyPress
          OnButtonClick = ShipNameEditButtonClick
          ButtonCaption = '<<'
          ButtonGlyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            18000000000000030000000000000000000000000000000000003F3C398C8482
            6562602D2B292C2829312D2D383635FFFFFFFFFFFF3835358A84813533312120
            1F2221212C2829302E2E272323BAB7B075716C1310101110101A1A183C3835FF
            FFFFFFFFFF474444EBE6E4332F2E110F0F1716152F2D2B333131504B48CFC8CA
            BABAB556504E514B494B4645494443FFFFFFFFFFFF6B675FBEBCBAA5A09E514D
            494C4746494643312E2C76716FCCCCC8EFEDED8E88837F7B776F69664E4B46FF
            FFFFFFFFFF716D66AFAAA6F5F5F3857F7B736D6B615C5946424183807EBAB5B2
            E8E8E686827E6C68646863614B4646FFFFFFFFFFFF64635EABA6A0E0E0DE746D
            6B67625D625D5B5E5D5DB3B2AFABA5A0F9FBFB9E9A98746F6C716C69575352FF
            FFFFFFFFFF625F5CADA8A3F5F5F5807B78736D69635D5B9E9D9DB5B3B3888280
            F9F7F7B5ADAB716C69716C685A56558B8887AFAEAC5D5B58A6A29DF3F3F3827E
            79736F6B514C4A9291918481803935353834322F2B2A2521213D3A386F69685B
            56552A28276F68684D47441515140B090A0B0A0B0C0B0C3C3C3CBCBABA8B8682
            EBE8E8F1F1F3E0DAD77C7775645F61645D5C2927266F6966575151EFEDEBF9F9
            F5D7D3CFE9E2DA969494D2D0CF736F69D7D7D5DAD5D7C5C1BE716C6B5F5B595F
            58572826256B6663524F4DE6E6E4CECCCCBAB5B4A59E9BB2B2B1DFDEDE645D5B
            D5D1CFE9EBEDE2E2DE7B777766615F6B6362262323595451494542FDFDFBEBED
            EDE0E0DC97918ECCCCCCFFFFFF817D7AE8E2E0C3C3C07F787555514F59565440
            3D3B332F2FB7AFAB7F7B77A39D9D8C898697918F53504FFFFFFFFFFFFFC3C1C1
            A09B9B5B5755AAA6A37873703D3938FFFFFFFFFFFF9D9A98F5F5EB524E4D312E
            2E52504E767474FFFFFFFFFFFFFFFFFFFFFFFF6966629B98975E59572E2B28FF
            FFFFFFFFFF5651508C8B863C3838464444FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF6D6867FFFFFFF3EDEBA29D9AFFFFFFFFFFFFAAA5A5FFFFFFF1EBE66965
            63FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6A6865A5A2A08B87845E5956FF
            FFFFFFFFFF625E5C9C9997726E6E53514EFFFFFFFFFFFFFFFFFF}
          ButtonWidth = 30
          TransparentColor = clNone
        end
        object HullNoEdit: TNxButtonEdit
          Tag = 16
          Left = 715
          Top = 7
          Width = 198
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnKeyPress = HullNoEditKeyPress
          OnButtonClick = HullNoEditButtonClick
          ButtonCaption = '<<'
          ButtonGlyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            18000000000000030000000000000000000000000000000000003F3C398C8482
            6562602D2B292C2829312D2D383635FFFFFFFFFFFF3835358A84813533312120
            1F2221212C2829302E2E272323BAB7B075716C1310101110101A1A183C3835FF
            FFFFFFFFFF474444EBE6E4332F2E110F0F1716152F2D2B333131504B48CFC8CA
            BABAB556504E514B494B4645494443FFFFFFFFFFFF6B675FBEBCBAA5A09E514D
            494C4746494643312E2C76716FCCCCC8EFEDED8E88837F7B776F69664E4B46FF
            FFFFFFFFFF716D66AFAAA6F5F5F3857F7B736D6B615C5946424183807EBAB5B2
            E8E8E686827E6C68646863614B4646FFFFFFFFFFFF64635EABA6A0E0E0DE746D
            6B67625D625D5B5E5D5DB3B2AFABA5A0F9FBFB9E9A98746F6C716C69575352FF
            FFFFFFFFFF625F5CADA8A3F5F5F5807B78736D69635D5B9E9D9DB5B3B3888280
            F9F7F7B5ADAB716C69716C685A56558B8887AFAEAC5D5B58A6A29DF3F3F3827E
            79736F6B514C4A9291918481803935353834322F2B2A2521213D3A386F69685B
            56552A28276F68684D47441515140B090A0B0A0B0C0B0C3C3C3CBCBABA8B8682
            EBE8E8F1F1F3E0DAD77C7775645F61645D5C2927266F6966575151EFEDEBF9F9
            F5D7D3CFE9E2DA969494D2D0CF736F69D7D7D5DAD5D7C5C1BE716C6B5F5B595F
            58572826256B6663524F4DE6E6E4CECCCCBAB5B4A59E9BB2B2B1DFDEDE645D5B
            D5D1CFE9EBEDE2E2DE7B777766615F6B6362262323595451494542FDFDFBEBED
            EDE0E0DC97918ECCCCCCFFFFFF817D7AE8E2E0C3C3C07F787555514F59565440
            3D3B332F2FB7AFAB7F7B77A39D9D8C898697918F53504FFFFFFFFFFFFFC3C1C1
            A09B9B5B5755AAA6A37873703D3938FFFFFFFFFFFF9D9A98F5F5EB524E4D312E
            2E52504E767474FFFFFFFFFFFFFFFFFFFFFFFF6966629B98975E59572E2B28FF
            FFFFFFFFFF5651508C8B863C3838464444FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF6D6867FFFFFFF3EDEBA29D9AFFFFFFFFFFFFAAA5A5FFFFFFF1EBE66965
            63FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6A6865A5A2A08B87845E5956FF
            FFFFFFFFFF625E5C9C9997726E6E53514EFFFFFFFFFFFFFFFFFF}
          ButtonWidth = 30
          TransparentColor = clNone
        end
      end
    end
  end
  object TaskTab: TAdvOfficeTabSet
    Left = 0
    Top = 117
    Width = 1559
    Height = 27
    AdvOfficeTabs = <
      item
        Caption = 'All'
        Name = 'TOfficeTabCollectionItem5'
        TabAppearance.BorderColor = clNone
        TabAppearance.BorderColorHot = 15383705
        TabAppearance.BorderColorSelected = 14922381
        TabAppearance.BorderColorSelectedHot = 6343929
        TabAppearance.BorderColorDisabled = clNone
        TabAppearance.BorderColorDown = clNone
        TabAppearance.Color = clBtnFace
        TabAppearance.ColorTo = clWhite
        TabAppearance.ColorSelected = 16709360
        TabAppearance.ColorSelectedTo = 16445929
        TabAppearance.ColorDisabled = clWhite
        TabAppearance.ColorDisabledTo = clSilver
        TabAppearance.ColorHot = 14542308
        TabAppearance.ColorHotTo = 16768709
        TabAppearance.ColorMirror = clWhite
        TabAppearance.ColorMirrorTo = clWhite
        TabAppearance.ColorMirrorHot = 14016477
        TabAppearance.ColorMirrorHotTo = 10736609
        TabAppearance.ColorMirrorSelected = 16445929
        TabAppearance.ColorMirrorSelectedTo = 16181984
        TabAppearance.ColorMirrorDisabled = clWhite
        TabAppearance.ColorMirrorDisabledTo = clSilver
        TabAppearance.Font.Charset = DEFAULT_CHARSET
        TabAppearance.Font.Color = clWindowText
        TabAppearance.Font.Height = -11
        TabAppearance.Font.Name = 'Tahoma'
        TabAppearance.Font.Style = []
        TabAppearance.Gradient = ggVertical
        TabAppearance.GradientMirror = ggVertical
        TabAppearance.GradientHot = ggRadial
        TabAppearance.GradientMirrorHot = ggVertical
        TabAppearance.GradientSelected = ggVertical
        TabAppearance.GradientMirrorSelected = ggVertical
        TabAppearance.GradientDisabled = ggVertical
        TabAppearance.GradientMirrorDisabled = ggVertical
        TabAppearance.TextColor = 9126421
        TabAppearance.TextColorHot = 9126421
        TabAppearance.TextColorSelected = 9126421
        TabAppearance.TextColorDisabled = clGray
        TabAppearance.ShadowColor = 15255470
        TabAppearance.HighLightColorSelected = 16775871
        TabAppearance.HighLightColorHot = 16643309
        TabAppearance.HighLightColorSelectedHot = 12451839
        TabAppearance.HighLightColorDown = 16776144
        TabAppearance.BackGround.Color = 16767935
        TabAppearance.BackGround.ColorTo = clNone
        TabAppearance.BackGround.Direction = gdHorizontal
      end>
    Align = alTop
    ActiveTabIndex = 0
    ButtonSettings.CloseButtonPicture.Data = {
      424DA20400000000000036040000280000000900000009000000010008000000
      00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001000001010100000100
      0000000202000100020200000000000202020002020200000000010002020202
      0200010000000101000202020001010000000100020202020200010000000002
      0202000202020000000000020200010002020000000001000001010100000100
      0000}
    ButtonSettings.ClosedListButtonPicture.Data = {
      424DA20400000000000036040000280000000900000009000000010008000000
      00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010101000101010100
      0000010101000200010101000000010100020202000101000000010002020202
      0200010000000002020200020202000000000002020001000202000000000100
      0001010100000100000001010101010101010100000001010101010101010100
      0000}
    ButtonSettings.TabListButtonPicture.Data = {
      424DA20400000000000036040000280000000900000009000000010008000000
      00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010101000101010100
      0000010101000200010101000000010100020202000101000000010002020202
      0200010000000002020200020202000000000002020001000202000000000100
      0001010100000100000001010101010101010100000001010101010101010100
      0000}
    ButtonSettings.ScrollButtonPrevPicture.Data = {
      424DA20400000000000036040000280000000900000009000000010008000000
      00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010101000001010100
      0000010101000202000101000000010100020202000101000000010002020200
      0101010000000002020200010101010000000100020202000101010000000101
      0002020200010100000001010100020200010100000001010101000001010100
      0000}
    ButtonSettings.ScrollButtonNextPicture.Data = {
      424DA20400000000000036040000280000000900000009000000010008000000
      00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010000010101010100
      0000010002020001010101000000010002020200010101000000010100020202
      0001010000000101010002020200010000000101000202020001010000000100
      0202020001010100000001000202000101010100000001010000010101010100
      0000}
    ButtonSettings.ScrollButtonFirstPicture.Data = {
      424DC60400000000000036040000280000001000000009000000010008000000
      000000000000C40E0000C40E00000001000000010000427B84FFDEEFEFFFFFFF
      FFFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF01010101010000010101
      0101000001010101010100020200010101000202000101010100020202000101
      0002020200010101000202020001010002020200010101000202020001010002
      0202000101010101000202020001010002020200010101010100020202000101
      0002020200010101010100020200010101000202000101010101010000010101
      010100000101}
    ButtonSettings.ScrollButtonLastPicture.Data = {
      424DC60400000000000036040000280000001000000009000000010008000000
      000000000000C40E0000C40E00000001000000010000427B84FFDEEFEFFFFFFF
      FFFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF01010000010101010100
      0001010101010100020200010101000202000101010101000202020001010002
      0202000101010101000202020001010002020200010101010100020202000101
      0002020200010101000202020001010002020200010101000202020001010002
      0202000101010100020200010101000202000101010101010000010101010100
      000101010101}
    ButtonSettings.CloseButtonHint = 'Close'
    ButtonSettings.InsertButtonHint = 'Insert new item'
    ButtonSettings.TabListButtonHint = 'TabList'
    ButtonSettings.ClosedListButtonHint = 'Closed Pages'
    ButtonSettings.ScrollButtonNextHint = 'Next'
    ButtonSettings.ScrollButtonPrevHint = 'Previous'
    ButtonSettings.ScrollButtonFirstHint = 'First'
    ButtonSettings.ScrollButtonLastHint = 'Last'
    TabSettings.Alignment = taCenter
    TabSettings.Width = 110
  end
  object StatusBarPro1: TStatusBarPro
    Left = 0
    Top = 770
    Width = 1559
    Height = 20
    Panels = <
      item
        Alignment = taCenter
        Bevel = pbRaised
        Text = 'Records'
        Width = 50
      end
      item
        Alignment = taCenter
        Width = 100
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object CertListGrid: TNextGrid
    Left = 0
    Top = 144
    Width = 1559
    Height = 626
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Align = alClient
    AppearanceOptions = [ao3DGridLines, aoAlphaBlendedSelection, aoBoldTextSelection, aoHideSelection]
    Caption = ''
    HeaderSize = 23
    HighlightedTextColor = clHotLight
    Options = [goGrid, goHeader, goSelectFullRow]
    RowSize = 18
    PopupMenu = PopupMenu1
    TabOrder = 3
    TabStop = True
    OnCellDblClick = CertListGridCellDblClick
    object NxIncrementColumn1: TNxIncrementColumn
      Alignment = taCenter
      DefaultWidth = 30
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'No'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 0
      SortType = stAlphabetic
      Width = 30
    end
    object CertNo: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 120
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Cert No'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 1
      SortType = stAlphabetic
      Width = 120
    end
    object ProductType: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 50
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Product'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 2
      SortType = stAlphabetic
      Width = 50
    end
    object TrainedSubject: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 150
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Trained Subject'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 3
      SortType = stAlphabetic
      Width = 150
    end
    object TrainedCourse: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 200
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'Trained Course'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 4
      SortType = stAlphabetic
      Width = 200
    end
    object TraineeName: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 200
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Trainee Name'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 5
      SortType = stAlphabetic
      Width = 200
    end
    object CompanyName: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 150
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Company Name'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 6
      SortType = stAlphabetic
      Width = 150
    end
    object TrainedBeginDate: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 82
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'Trained Begin'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 7
      SortType = stAlphabetic
      Width = 82
    end
    object TrainedEndDate: TNxTextColumn
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Trained End'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 8
      SortType = stAlphabetic
    end
    object HullNo: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 150
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Hull No'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 9
      SortType = stAlphabetic
      Width = 150
    end
    object ShipName: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 150
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Ship Name'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 10
      SortType = stAlphabetic
      Width = 150
    end
    object IMONo: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 150
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'IMO No'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 11
      SortType = stAlphabetic
      Width = 150
    end
    object UntilValidity: TNxTextColumn
      Alignment = taCenter
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'Until Validity'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 12
      SortType = stAlphabetic
    end
    object CertFileDBPath: TNxTextColumn
      Alignment = taCenter
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'FileDBPath'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 13
      SortType = stAlphabetic
      Visible = False
    end
    object CertFileDBName: TNxTextColumn
      Alignment = taCenter
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'FileDBName'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 14
      SortType = stAlphabetic
      Visible = False
    end
    object CertType: TNxTextColumn
      Alignment = taCenter
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      Header.Caption = 'Cert Type'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 15
      SortType = stAlphabetic
    end
    object Attachments: TNxButtonColumn
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Attachments'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Options = [coCanClick, coCanInput, coCanSort, coEditing, coPublicUsing, coShowTextFitHint]
      ParentFont = False
      Position = 16
      SortType = stAlphabetic
      OnButtonClick = AttachmentsButtonClick
    end
    object UpdateDate: TNxTextColumn
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Update Date'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 17
      SortType = stAlphabetic
    end
    object CompanyCode: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 150
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Company Code'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 18
      SortType = stAlphabetic
      Width = 150
    end
    object CompanyNation: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 150
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Company Nation'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 19
      SortType = stAlphabetic
      Width = 150
    end
    object ReportNo: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 150
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Report No'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 20
      SortType = stAlphabetic
      Width = 150
    end
    object VDRSerialNo: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 150
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'VDR Serial No'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 21
      SortType = stAlphabetic
      Width = 150
    end
    object PlaceOfSurvey: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 150
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Place Of Survey'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 22
      SortType = stAlphabetic
      Width = 150
    end
    object VDRType: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 150
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'VDR Type'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 23
      SortType = stAlphabetic
      Width = 150
    end
    object ClassSociety: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 150
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Class'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 24
      SortType = stAlphabetic
      Width = 150
    end
    object OwnerName: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 150
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Owner Name'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 25
      SortType = stAlphabetic
      Width = 150
    end
    object PICEmail: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 150
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'PIC Email'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 26
      SortType = stAlphabetic
      Width = 150
    end
    object PICPhone: TNxTextColumn
      Alignment = taCenter
      DefaultWidth = 150
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'PIC Phone'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 27
      SortType = stAlphabetic
      Width = 150
    end
    object APTServiceDate: TNxTextColumn
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'APT Service Date'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 28
      SortType = stAlphabetic
    end
    object OrderNo: TNxTextColumn
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Order No.'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 29
      SortType = stAlphabetic
    end
    object SalesAmount: TNxTextColumn
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Sales Amount'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 30
      SortType = stAlphabetic
    end
  end
  object imagelist24x24: TImageList
    ColorDepth = cd32Bit
    DrawingStyle = dsTransparent
    Height = 24
    Width = 24
    Left = 16
    Top = 208
    Bitmap = {
      494C010101007000B80318001800FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000600000001800000001002000000000000024
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005C43
      009F9C7200CF0000000F00000000000000000000000000000000000000000000
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
      00000000000000000000000000000000000000000000000000005C43009FEEAD
      00FFEEAD00FF9C7200CF0000000F000000000000000000000000000000000000
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
      000000000000000000000000000000000000000000005C43009FEEAD00FFEEAD
      00FFEEAD00FFEEAD00FF9C7200CF0000000F0000000000000000000000000000
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
      0000000000000000000000000000000000005C43009FEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F00000000000000000000
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
      00000000000000000000000000000302001FD19800EFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F000000000000
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
      0000000000000000000000000000000000000805002FD19800EFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F0000
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
      000000000000000000000000000000000000000000000805002FD19800EFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000
      000F000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000805002FD198
      00EFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C72
      00CF0000000F0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000E0A003F0E0A003F0E0A003F0E0A
      003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F2D20
      006FEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FF9C7200CF0000000F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FF9C7200CF0000000F000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FF9C7200CF0000000F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FF9C7200CF0000000F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FF9C7200CF0000000F000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000E0A003F0E0A003F0E0A003F0E0A
      003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F0E0A003F2D20
      006FEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD
      00FF9C7200CF0000000F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000805002FD198
      00EFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C72
      00CF0000000F0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000805002FD19800EFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000
      000F000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000805002FD19800EFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F0000
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
      00000000000000000000000000000302001FD19800EFEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F000000000000
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
      0000000000000000000000000000000000005C43009FEEAD00FFEEAD00FFEEAD
      00FFEEAD00FFEEAD00FFEEAD00FF9C7200CF0000000F00000000000000000000
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
      000000000000000000000000000000000000000000005C43009FEEAD00FFEEAD
      00FFEEAD00FFEEAD00FF9C7200CF0000000F0000000000000000000000000000
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
      00000000000000000000000000000000000000000000000000005C43009FEEAD
      00FFEEAD00FF9C7200CF0000000F000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000005C43
      009F9C7200CF0000000F00000000000000000000000000000000000000000000
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
      2800000060000000180000000100010000000000200100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object ImageList16x16: TImageList
    ColorDepth = cd32Bit
    DrawingStyle = dsTransparent
    Left = 96
    Top = 208
    Bitmap = {
      494C010102005402C80310001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      000000000000000000000000000000000000000000000505052E101010521717
      17611D1D1D6C1F1D1E6D272425792523257825232578262425791F1E1E6E1E1E
      1E6E18181862111111530505052F000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000030303240B0B0B420D0C
      0D482B332E8F4D9D6CF333B063FF27B35BFF27B35CFF3AB067FF4E8763E21C1F
      1D700F0E0E4C0B0B0B4203030324000000000000000000000000000000000000
      0000010103230D132E7D283B8BDB2F48AAF32A43A9F3213887DB0A122B7D0001
      0323000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001041
      259827B662FF2BB665FF2EB666FF2DB466FF2EB566FF2EB666FF2AB665FF27B7
      62FF06180D5B0000000000000000000000000000000000000000000000000709
      15533544A0E63A50CCFF7378E8FF8E91EEFF8E91EEFF6F76E4FF314BC0FF223B
      94E6040713530000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000186A3DBA2CBA
      6CFF2CBA6DFF2CBA6DFF27B868FF33BC71FF2CB96DFF2AB96BFF2CBA6DFF2CBA
      6DFF2BBA6CFF0823146B00000000000000000000000000000000080915534150
      B9F45A63E0FFA0A5F5FF7C85EFFF5961E9FF575BE7FF7B83EEFF9D9FF4FF4F5B
      D7FF2642A6F40407135300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000927176F2BBE71FF2BBE
      71FF2BBE71FF27BC6EFF44C583FFFFFFFFFFFFFFFFFF1CB968FF2ABE70FF2BBE
      71FF2BBE71FF2BBF71FF00040225000000000000000001010322424CA7E55F69
      E3FFA0ABF5FF525DECFF4E5AEAFF4B57E9FF4C57E6FF4A54E6FF4E54E6FF9DA1
      F4FF525ED6FF213B93E500010322000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000028C275FB27C075FF27C0
      75FF27C075FF22BF71FF4FCD8FFFFFFFFFFFFFFFFFFF1EBE70FF26C073FF27C0
      75FF27C075FF27C075FF166B40B800000000000000001517337E4954DBFFA1AA
      F6FF5462F0FF5064EEFF4B57E9FF4B57E9FF4B57E9FF4B57E9FF4A56E6FF5058
      E6FF9EA2F5FF324EC3FF09112C7E000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000020C074526C77AFF26C579FF1EC3
      74FF13C06DFF0EBF6AFF3FCA89FFFFFFFFFFFFFFFFFF0ABE69FF12BF6DFF13C0
      6EFF21C376FF26C579FF27CB7CFF000000000000000042479FDB808BEEFF7C90
      F7FF5B71F3FF4B57E9FF4B57E9FF4B57E9FF4B57E9FF4B57E9FF4B57E9FF4D59
      E9FF7982F0FF7379E2FF213688DB000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000082D1D7A24C97DFF1CC778FF68D9
      A5FFF9FDFCFFEEFAF5FFF0FBF7FFFFFFFFFFFFFFFFFFECFAF4FFEFFBF5FFF8FD
      FBFF3FCF8FFF1FC77AFF24CD80FF0005033100000000575BCAF6A0AAF7FF6E85
      F8FF6681F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4B57
      E9FF5A64EAFF959BF1FF2D49ADF6000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000A38248721CC81FF16C97AFF9CE7
      C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF66DAA7FF1ACA7CFF24CF85FF0109063F000000005C60CBF6AEB8F9FF7D92
      FAFF6E84F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4B57
      E9FF5C68EEFF959CF1FF3148AFF6000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000008291B721ECE84FF1DCE83FF2DD1
      8BFF81E3B9FF76E1B5FF92E7C3FFFFFFFFFFFFFFFFFF74E0B3FF78E1B6FF7CE2
      B8FF1ECE84FF1DCE83FF2CD58DFF0004022A000000004B4CA4DBA4AEF5FF9CAA
      FAFF758BF0FF525DECFF525DECFF525DECFF525DECFF525DECFF525DECFF6175
      F2FF808DF4FF767DE9FF293B8DDB000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000107043532DA94FF1DD086FF1CD0
      86FF15CE82FF10CD7EFF3FD799FFFFFFFFFFFFFFFFFF0CCC7DFF14CE82FF16CE
      82FF1DD087FF1CCF86FF34DE97FF00000000000000001919367E7B82EAFFCDD4
      FCFF8A9CFAFF7C92F7FF7389EEFF6A83F6FF6A83F6FF6A83F6FF6A83F6FF6177
      F3FFA3AEF8FF3C4DD0FF0E142E7E000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000037C289EA17D288FF1CD4
      8BFF1CD48BFF17D288FF49DCA1FFFFFFFFFFFFFFFFFF14D286FF1BD38AFF1CD4
      8BFF1BD48AFF1ED38CFF185A3E9E0000000000000000010103225453B4E5A2A6
      F3FFD4DBFDFF8699FAFF7D90F0FF788DF1FF7D93F8FF7C91F9FF748BF8FFA7B5
      F8FF616CE3FF3644A1E501010322000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000003120C4841DF9EFF15D4
      8BFF1CD68EFF1AD58CFF1FD68EFFC7F4E2FFB5F0D9FF0ED386FF1BD68EFF1BD6
      8EFF13D38AFF50E5A6FF0000000C0000000000000000000000000B0B17535F5F
      CCF4A9ACF2FFD8DCFDFFADB9FAFF90A2FAFF8A9CFAFF9BA8FBFFB9C7FCFF6E79
      E9FF4451BAF40709155300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000F402D8347E0
      A3FF12D48CFF17D58EFF19D68EFF0CD488FF0DD488FF19D68FFF16D58EFF14D5
      8DFF58E6ABFF020C083B00000000000000000000000000000000000000000B0B
      17535555B5E68D92EDFFBDC2F8FFCCD3F9FFC3CBF9FFA9B3F4FF646EE2FF424B
      AAE6080915530000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000621
      175F5AECAFFF41E1A1FF12D78EFF14D78FFF14D78FFF19D891FF4DE4A7FF48C2
      90E60006042A0000000000000000000000000000000000000000000000000000
      0000020204231918357D4B4CA3DB5859C8F35659C6F343479FDB1517337D0101
      0323000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000020623186626694DAD34906ACA328B66C61E59419F02130D4C0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 256
    object File1: TMenuItem
      Caption = 'File'
      object ImportGeneratorMasterFromXlsFile1: TMenuItem
        Caption = 'Create New Cert.'
        OnClick = ImportGeneratorMasterFromXlsFile1Click
      end
      object N2: TMenuItem
        Caption = '-'
        Visible = False
      end
      object ImportVDRMasterFromXlsFile1: TMenuItem
        Caption = 'Import VDRMaster From Xls File'
        OnClick = ImportVDRMasterFromXlsFile1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
    end
    object View1: TMenuItem
      Caption = 'View'
      object CertNoFormat1: TMenuItem
        Caption = 'Cert. No. Format'
        OnClick = CertNoFormat1Click
      end
    end
    object DataBase1: TMenuItem
      Caption = 'DataBase'
    end
    object ools1: TMenuItem
      Caption = 'Tools'
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Excel Files|*.xls;*.xlsx|All Files|*.*'
    Left = 56
    Top = 256
  end
  object PopupMenu1: TPopupMenu
    Left = 96
    Top = 256
    object Add1: TMenuItem
      Caption = 'Create New Cert.'
      OnClick = Add1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object CreateCertDocument2: TMenuItem
      Caption = 'Create Education Cert.'
      OnClick = CreateCertDocument2Click
    end
    object CreateAPTCert1: TMenuItem
      Caption = 'Create APT Service Cert.'
      OnClick = CreateAPTCert1Click
    end
    object CreateAPTApprovalCert1: TMenuItem
      Caption = 'Create Product Approval Cert.'
      OnClick = CreateAPTApprovalCert1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object DeleteSelectedCert1: TMenuItem
      Caption = 'Delete Selected Cert.'
      OnClick = DeleteSelectedCert1Click
    end
  end
  object ImageList32x32: TImageList
    ColorDepth = cd32Bit
    Height = 32
    Width = 32
    Left = 56
    Top = 208
    Bitmap = {
      494C01010400C8001C0520002000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000800000004000000001002000000000000080
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
      0000000000000000000000000000000000000000005F000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000001000000010000000200000002000000020000
      0003000000040000000500000005000000060000000600000006000000050000
      0004000000030000000200000002000000020000000100000001000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000005F000000FF3E6E00FF3E6E
      00FF3E6E00FF3E6E00FF3E6E00FF3E6E00FF3E6E00FF3E6E00FF3E6E00FF3E6E
      00FF3E6E00FF3E6E00FF3E6E00FF3E6E00FF3E6E00FF3E6E00FF3E6E00FF3E6E
      00FF3E6E00FF3E6E00FF3E6E00FF3E6E00FF3E6E00FF3E6E00FF3E6E00FF3E6E
      00FF3E6E00FF3E6E00FF3E6E00FF000000FF0000000000000000000000000000
      00000000000100000002000000050000000A0000000E00000011000000120000
      0014000000180000001C0101011D0101011E0101011E0101011E0101011D0000
      001A0000001500000013000000110000000F0000000C00000007000000030000
      0001000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000030303355F6060E85E6261E35E62
      61E35E6261E35E6261E35E6261E35E6261E35E6261E35E6261E35E6261E35E62
      61E35E6261E35E6261E35E6261E35E6261E35E6261E35E6261E35E6261E35E62
      61E35E6261E35F6161E42122228F000000000000000000000000000000000000
      0000000000000000000000000000000000000000005F000000FF3E7104FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFE7EDDFFF3E7104FF000000FF0000000000000000000000000000
      0000000000022D2D2D997D7D7EFF7D7D7EFF7D7D7EFF7D7D7EFF7D7D7EFF7D7D
      7EFF7D7D7EFF7D7D7EFF7D7D7EFF7D7D7EFF7D7D7EFF7D7D7EFF7D7D7EFF7D7D
      7EFF7D7D7EFF7D7D7EFF7D7D7EFF7D7D7EFF7D7D7EFF7D7D7EFF2E2E2E9B0000
      0004000000010000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000B000643B2042285E80000
      1490000000090000000000000000000000000A0B0A5ACACCCBFFC6C7C7FFC7C8
      C8FFEBEDEDFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000000000000000000
      0000000000000000000000000000000000000000005F000000FF3F7307FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEAF4E9FFFFFF
      FFFFD0E7CDFFC3E0BFFFE0EFDEFFFFFFFFFFFFFFFFFFFFFFFFFFDCEDDAFF76B9
      6DFF6AB35FFF5DAC51FF50A644FFFFFFFFFFFFFFFFFF71B369FF7DC674FF7DC6
      74FF7DC674FFE7EDE0FF3F7307FF000000FF0000000000000000000000000000
      0000000000037E7E80FFD9D9D9FFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDF
      DFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDF
      DFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFD9D9D9FF7E7E80FF0000
      0006000000010000000000000000000000000000000000000000000000000000
      0000000000020000001300000013000000130000001300000013000000130000
      0013000000130000001300000013000000130000001300000013000000130000
      00130000001300000013000000130000011E000750B70766F0FF1DA2FFFF2275
      DCFF00000C7E0000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFBCBD
      BDFF979898FFB2B3B3FFE0E2E2FFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000000000000000000
      0000000000000000000000000000000000000000005F000000FF3F750BFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFCFAFFEEF6ECFFF9FB
      F8FFFFFFFFFFFFFFFFFFFFFFFFFFDCEDDAFFA2CF9BFFEBF4E9FF88C280FF82BF
      78FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCCE3C9FF87CA7EFF87CA
      7EFF87CA7EFFE7EEE0FF3F750BFF000000FF0000000000000000000000000000
      000000000002818182FFCECECEFFCBCBCBFFCBCBCBFFCBCBCBFFCBCBCBFFCBCB
      CBFFCBCBCBFFCBCBCBFFCBCBCBFFCBCBCBFFCBCBCBFFCBCBCBFFCBCBCBFFCBCB
      CBFFCBCBCBFFCBCBCBFFCBCBCBFFCBCBCBFFCBCBCBFFCECECEFF818182FF0000
      0004000000010000000000000000000000000000000000000000000000000000
      0042101010CD2C2C2CEB2D2D2DEC2D2D2DEC2D2D2DEC2D2D2DEC2D2D2DEC2E2E
      2EEC2E2E2EEC2E2E2EEC2E2E2EEC2E2E2EEC2E2E2EEC2E2E2EEC2E2E2EEC2E2E
      2EEC2D2D2EEC30312FEC252126EB000B71F20667F6FF1A9AFFFF3DCBFFFF52E0
      FFFF050B43C40000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFC5C7C7FF909191FF838484FF9A9B9BFFD2D4D4FFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000000000000000000
      0000000000000000000000000000000000000000005F000000FF40770EFFFFFF
      FFFFE7F4E5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFEFEFEFFCCE4C8FFBFDEBAFFB2D7ADFFB3D8AEFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF75B96BFF62AF57FF5AAB4EFFFFFFFFFFFFFFFFFF86C17EFF8FCD
      88FF8FCD88FFE7EEE1FF40770EFF000000FF0000000000000000000000000000
      000000000001828283FFCFCFCFFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCC
      CCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCC
      CCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCFCFCFFF828283FF0000
      0001000000000000000000000000000000000000000000000000000000002020
      20E9DCDCDCFFF7F7F7FFF5F5F5FFF4F4F4FFF4F4F4FFF3F3F3FFF3F3F3FFF2F2
      F2FFF2F2F2FFF1F1F1FFF1F1F1FFF0F0F0FFF0F0F0FFEFEFEFFFEEEEEEFFEDED
      EEFFF5F5EFFFE3DEE5FF4450C7FF0260F4FF1A9AFFFF3BC8FFFF5AF3FFFF255B
      B8F7000004520000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFD2D4D4FF7D7E7EFF858585FF7B7B7BFF828383FFB8BABAFFE6E7
      E7FFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000000000000000000
      0000000000000000000000000000000000000000005F000000FF407912FFFFFF
      FFFF97D18FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6FAF5FFE9F4
      E8FFFFFFFFFFDEEEDBFFFFFFFFFFFFFFFFFFFFFFFFFFFCFDFCFFFFFFFFFFA1CF
      9AFF8FC586FF7BBC71FFEDF6ECFFFFFFFFFFFFFFFFFFFFFFFFFF88BD81FF97D1
      8FFF97D18FFFE7EEE1FF407912FF000000FF0000000000000000000000000000
      000000000000848485FFCFCFCFFFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFCDCD
      CDFFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFCDCD
      CDFFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFCFCFCFFF848485FF0000
      0000000000000000000000000000000000000000000000000000000000005151
      51FFF8F8F8FFECECECFFEBEBEBFFEAEAEAFFE9E9E9FFE8E8E8FFE7E7E7FFE7E7
      E7FFE7E7E7FFE8E8E8FFE8E8E8FFE6E6E6FFE3E3E3FFE1E1E1FFE0E0E0FFE6E6
      E1FFD6D1D9FF3541C0FF005AF0FF1A9BFFFF3CC8FFFF5AF3FFFF2356B7F20000
      0451000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFE1E3E3FF898A8AFF6E6E6EFF7C7C7CFF757575FF7172
      72FFA7A8A8FFD9DADAFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000738000000010000
      0000000000000000000000000000000000000000005F000000FF407B16FFFFFF
      FFFF9ED497FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFDFCFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFF1F8F1FFDFEEDDFFCCE5C9FFFAFCF9FFFCFD
      FCFFFFFFFFFFFFFFFFFFFFFFFFFF8FC687FFFFFFFFFFFFFFFFFFC1DCBEFF9ED4
      97FF9ED497FFE7EEE2FF407B16FF000000FF0000000000000000000000000000
      000000000000868687FFD0D0D0FFCECECEFFCECECEFFCECECEFFCECECEFFCECE
      CEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECE
      CEFFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFCECECEFFD0D0D0FF868687FF0000
      0000000000000000000000000000000000000000000000000000000000005050
      50FFF4F4F4FFEDEDEDFFECECECFFEBEBEBFFEAEAEAFFE9E9E9FFEDEDEDFFEEEE
      EEFFE4E4E4FFD6D6D6FFD1D1D1FFD4D4D4FFE1E1E1FFEBEBEBFFE9E9E6FFD9D6
      DFFF4658CBFF066FF6FF189AFFFF3CC9FFFF57EFFFFF2159C7FF00000B840000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFEAECECFFA5A6A6FF696969FF6D6D6DFF7878
      78FF717171FF696969FF868787FFBEBFBFFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC20000000000001A6500009DF9000000060000
      0000000000000000000000000000000000000000005F000000FF417D19FFFFFF
      FFFFA4D79EFFFAFDFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFF8FBF7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFE1EFDEFFB9DBB4FF96C98EFF72B768FFB6DAB1FFFFFFFFFFFFFFFFFF9DCD
      97FFA4D79EFFE7EFE2FF417D19FF000000FF0000000000000000000000000000
      000000000000888889FFD2D2D2FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0
      D0FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0D0FFCFCFCFFFCCCC
      CCFFC9D1D2FFC9D1D2FFC9D1D2FFC9D1D2FFC9D1D2FFCBD3D4FF888889FF0000
      0000000000000000000000000000000000000000000000000000000000005252
      52FFF4F4F4FFEEEEEEFFEDEDEDFFECECECFFEDEDEDFFF1F1F1FFCFCFCFFFA0A0
      A1FF898A8BFF818284FF7B7D7EFF757677FF777879FF939393FFD7D7CFFF9B99
      D0FF6582CDFF92DCE1FF48D6FFFF51EAFFFF356DE0FF473E75FF010100710000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFBEBFBFFF6D6E6EFF6969
      69FF6A6A6AFF6E6E6EFF6A6A6AFF696969FFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC20000165E000095EA00008BE3000000060000
      0000000000000000000000000000000000000000005F000000FF41801DFFFFFF
      FFFFAAD9A5FFAAD9A5FFFFFFFFFF51C88BFF54D29EFF51C78AFF4EBD73FF4BB3
      60FF48AA4FFFBADCB8FFFFFFFFFFFFFFFFFF459F39FF449B32FF429628FF4191
      1DFFF2F8F1FFE8F3E7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF99C4
      95FFAAD9A5FFE7EFE3FF41801DFF000000FF0000000000000000000000000000
      0000000000008A8A8BFFD3D3D3FFD1D1D1FFD1D1D1FFD1D1D1FFD1D1D1FFD1D1
      D1FFD1D1D1FFD1D1D1FFD1D1D1FFD1D1D1FFD1D1D1FFD1D1D1FFCECECEFFC9C9
      C9FFB9D4D8FFB9D4D8FFB9D4D8FFB9D4D8FFB9D4D8FFBBD5DAFF8A8A8BFF0000
      0000000000000000000000000000000000000000000000000000000000005454
      54FFF5F5F5FFEFEFEFFFEDEDEDFFF0F0F0FFEBEBEBFFA3A3A3FF868789FF9F9F
      9EFFBAB4AEFFC8BEB3FFC7BDB1FFB6AEA5FF96938EFF717273FF636464FF6161
      6BFFA7A5ACFFE8E0D8FF88E8F9FF205DD7FFA49BD5FFA3A297FF000000740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFD1D3D3FF8385
      85FF696969FF696969FF696969FF6A6B6BFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF2B2C60D9000095EA0000CBFF00008AE2000000060000
      0000000000000000000000000000000000000000005F000000FF418220FFFFFF
      FFFFB0DCABFFB0DCABFFFFFFFFFF7DD2A1FF50C686FF4FC17DFF4DB96DFF4AB1
      5CFF48A94CFFBADCB7FFFFFFFFFFEDF7EEFF47A749FF46A340FF449D36FFFCFD
      FCFFFFFFFFFFFFFFFFFFD1E8CEFF7EBD75FF5FAD53FFFFFFFFFFFFFFFFFFBAD6
      B7FFB0DCABFFE7EFE3FF418220FF000000FF0000000000000000000000000000
      0000000000008C8C8DFFD5D5D5FFD3D3D3FFD2D2D2FFD2D2D2FFD2D2D2FFD2D2
      D2FFD2D2D2FFD2D2D2FFD2D2D2FFD2D2D2FFD2D2D2FFD2D2D2FFCBCBCBFFC4C4
      C5FF9ED5DFFF9ED5DFFF9ED6DFFF9ED6DFFF9ED5DFFF9FD6E1FF8B8C8DFF0000
      0000000000000000000000000000000000000000000000000000000000005656
      56FFF6F6F6FFEFEFEFFFF1F1F1FFECECECFF949495FF9A9C9EFFD6CDC2FFF5E2
      CDFFFFEED9FFFFF3DEFFFFF4E0FFFFF2DEFFF7E6D1FFCFBEACFF8C8985FF9496
      95FFD6D5CEFF8386AFFF4C5BD8FF9793CCFFFCFCF0FF989898FF000000740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFDCDEDEFFCDCECEFFCACBCBFFE2E4E4FFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFF8789D0FF0505A9FB0000CCFF0000CCFF000091E7000044A20000
      42A0000042A0000042A00000419F0000021F0000005F000000FF428524FFFFFF
      FFFFB5DEB0FFB5DEB0FFFFFFFFFFFFFFFFFF4DBB70FF4CB96BFF4BB360FF49AC
      53FFFFFFFFFFFFFFFFFFFFFFFFFF4BB25FFF49AE58FF48AA4EFF4DA74AFFFFFF
      FFFFECF5EAFFC8E3C4FFA8D3A2FFA1CF9BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFB0D7ABFFE7EFE3FF428524FF000000FF0000000000000000000000000000
      0000000000008E8E8FFFD6D6D6FFD4D4D4FFD3D3D3FFD2D2D2FFD2D2D2FFD2D2
      D2FFD2D2D2FFD2D2D2FFD2D2D2FFD2D2D2FFD2D2D2FFD2D2D2FFC8C8C8FFBCBE
      C0FF87D4E4FF87D3E4FF74D5E9FF74D6EAFF87D4E5FF88D6E6FF8B8D8FFF0000
      0000000000000000000000000000000000000000000000000000000000005858
      58FFF6F6F6FFF0F0F0FFF6F6F6FFA1A2A2FFA2A3A5FFECDCCCFFFFEBD1FFFFF1
      DCFFFFEFDBFFFFEEDAFFFFEEDAFFFFEFDBFFFFF2DFFFFFF6E1FFE8D3B8FF9992
      8CFF727374FF686770FFE1DFE9FFE9E9E2FFF0F0F0FF989898FF010101740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFF8C8ED2FF1414B8FF0000CCFF0000CCFF0000CCFF0000CAFF0000C7FF0000
      C7FF0000C7FF0000C7FF0000B6FC00000F500000005F000000FF428728FFFFFF
      FFFFBAE0B5FFBAE0B5FFBAE0B6FFFFFFFFFFFFFFFFFF4AB05AFF49AC53FF47A7
      49FFAFD7ACFFFFFFFFFF4EBC73FF4DBA6EFF4CB565FF4AB05AFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFA8CAA3FFE7F0E4FF428728FF000000FF0000000000000000000000000000
      000000000000919191FFD8D8D8FFD6D6D6FFD6D6D6FFD5D5D5FFD2D2D2FFD2D2
      D2FFD2D2D2FFD2D2D2FFD2D2D2FFD2D2D2FFD2D2D2FFD2D2D2FFC2C2C2FFBBC1
      C8FF4CD2F3FF4DC5EFFF3CC5F4FF3CC8F5FF4DC8F0FF4CD4F4FF878C93FF0000
      0000000000000000000000000000000000000000000000000000000000005A5A
      5AFFF7F7F7FFF7F7F7FFCFCFCEFF929496FFE9DDD0FFFFE8CAFFFFEDD7FFFFEB
      D3FFFFEAD2FFFFEAD1FFFFEAD1FFFFEBD2FFFFEBD4FFFFECD6FFFFF5DFFFE1C7
      AAFF7C7977FF595A59FFD6D6D4FFE4E4E4FFF0F0F0FF9A9A9AFF020202740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFF9496
      D4FF1213B7FF0000CBFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000
      CCFF0000CCFF0000CCFF0000B9FC00000F500000005F000000FF43892BFFFFFF
      FFFFBEE2B9FFBEE2B9FFBEE2B9FFFFFFFFFFFFFFFFFF7DC180FF47A545FF46A2
      3EFF459D36FFEAF8F0FF50C482FF4FC07BFF4DBB71FFFEFEFEFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFEFDFFAECFAAFFAECFA9FFBDE1
      B9FFBEE2B9FFE7F0E4FF43892BFF000000FF0000000000000000000000000000
      000000000000939393FFDADADAFFD8D8D8FFD8D8D8FFD8D8D8FFD7D7D7FFD4D4
      D4FFD3D3D3FFD3D3D3FFD3D3D3FFD3D3D3FFD3D3D3FFD3D3D3FFC0C0C0FFB8C0
      CCFF3AC5F4FF38B3EDFF39B8EFFF39BDF0FF38B8EFFF3AC9F5FF818B96FF0000
      0000000000000000000000000000000000000000000000000000000000005C5C
      5CFFF7F7F7FFF8F8F8FF9FA0A0FFC3C2C0FFFFE3C3FFFFEAD0FFFFE8CEFFFFE7
      CBFFFFE6CAFFFFE6C9FFFFE6C9FFFFE7CAFFFFE8CCFFFFE9CFFFFFEBD3FFFFEF
      D2FFB39F8BFF545659FF949494FFECECECFFF1F1F1FF9B9B9BFF020202740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFF9495D4FF1213
      B7FF0000CBFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000
      CCFF0000CCFF0000CCFF0000B9FC00000F500000005F000000FF438B2FFFFFFF
      FFFFCBE7C9FFC2E3BDFFC2E3BDFFFFFFFFFFFFFFFFFFFFFFFFFF459F39FF449C
      34FF43992DFF52CB92FF52CA90FF50C687FF58C382FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF5F9F5FFB6D5B1FFB4D4B1FFC2E3BDFFC2E3BDFFC2E3BDFFC2E3
      BDFFC2E3BDFFE7F0E5FF438B2FFF000000FF0000000000000000000000000000
      000000000000959596FFE2E2E2FFE1E1E2FFE1E2E1FFE1E2E1FFE1E1E1FFE1E1
      E1FFE0E0E0FFDFDFDFFFDEDEDEFFDEDEDEFFDEDEDEFFDEDEDEFFC9C9C9FFB6C3
      D2FF38BEF1FF38ADECFF38B1EEFF38B7F0FF38B4EEFF38C3F3FF7C8999FF0000
      0000000000000000000000000000000000000000000000000000000000005E5E
      5EFFF9F9F9FFEAEAEAFF96989AFFEADCD0FFFFE2BEFFFFE6C9FFFFE2C0FFFFDF
      BBFFFFDDB7FFFFDCB6FFFFDCB6FFFFDEB9FFFFE0BDFFFFE3C3FFFFE6CAFFFFEF
      D5FFDFBE9EFF6C6B6AFF696969FFE9E9E9FFF2F2F2FF9C9C9CFF030303740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFF8D8FD3FF1414B9FF0000
      CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000
      CCFF0000CCFF0000CCFF0000B9FC00000F500000005F000000FF438D32FFFFFF
      FFFFD0E9CDFFD0E9CDFFCFE8CDFFCBE7C8FFFFFFFFFFFFFFFFFFFFFFFFFF4397
      2AFF52CC94FF54D29DFF53D09AFF52CA8EFFFFFFFFFFFFFFFFFFEBF4EAFFBBD9
      B8FFBBD9B7FFC5E5C1FFC5E5C1FFC5E5C1FFC5E5C1FFC5E5C1FFC5E5C1FFC5E5
      C1FFC5E5C1FFE7F0E5FF438D32FF000000FF0000000000000000000000000000
      000000000000979798FFE4E4E4FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3
      E3FFE3E3E3FFE3E3E3FFE2E2E2FFE2E2E2FFE1E1E1FFDFDFDFFFCACACAFFADBE
      D0FF35BEF3FF35A9EDFF36AFEEFF36B7F1FF35B2F0FF35C5F5FF76879BFF0000
      0000000000000000000000000000000000000000000000000000000000006060
      60FFFCFCFCFFDCDCDCFF9EA2A4FFF8E0CBFFFFDCB5FFFFDDB7FFFFD8ADFFFFD4
      A6FFFFD2A2FFFFD1A0FFFFD1A1FFFFD3A4FFFFD6A9FFFFDAB0FFFFDEBAFFFFE8
      C9FFF2CEAAFF827872FF595B5CFFE0E0E0FFF4F4F4FF9E9E9EFF040404740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFF7173CAFF1010BDFF0000
      CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000
      CCFF0000CCFF0000CCFF0000B9FC00000F500000005F000000FF448F36FFFFFF
      FFFFD4EBD2FFD4EBD2FFD4EBD2FFD4EBD2FFFFFFFFFFFFFFFFFFFFFFFFFF81BD
      77FF52CD94FF54D29EFF53D09AFFFFFFFFFFC1DEBDFFC2DFBEFFC8E6C4FFC8E6
      C4FFC8E6C4FFC8E6C4FFC8E6C4FFC8E6C4FFC8E6C4FFC8E6C4FFC8E6C4FFC8E6
      C4FFC8E6C4FFE7F1E6FF448F36FF000000FF0000000000000000000000000000
      0000000000009A9A9AFFE6E6E6FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
      E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFCFCFD0FFA5B9
      D1FF33BEF4FF32A5ECFF32A8EDFF32B3F0FF32B1F0FF33C6F6FF71869DFF0000
      0000000000000000000000000000000000000000000000000000000000006262
      62FFFDFDFDFFD8D8D8FFA3A7AAFFFADCC5FFFFD3A5FFFFD3A3FFFFCD99FFFFCC
      96FFFFCC96FFFFCC97FFFFCC96FFFFCB96FFFFCC97FFFFCF9DFFFFD5A7FFFFDF
      B8FFF5CBA3FF887C74FF57595AFFDDDDDDFFF5F5F5FF9F9F9FFF040404740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFF5C5DC4FF0F0F
      BEFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000
      CCFF0000CCFF0000CCFF0000B9FC00000F500000005F000000FF44913AFFFFFF
      FFFFD8EDD6FFD8EDD6FFD8EDD6FFD8EDD6FFFFFFFFFFFFFFFFFFFFFFFFFF50C3
      81FF51C88CFF52CC92FF50C789FF3F8A10FFCBE7C8FFCAE7C7FFCAE7C7FFCAE7
      C7FFCAE7C7FFCAE7C7FFCAE7C7FFCAE7C7FFCAE7C7FFCAE7C7FFCAE7C7FFCAE7
      C7FFCAE7C7FFE7F1E6FF44913AFF000000FF0000000000000000000000000000
      0000000000009C9C9CFFE8E8E8FFE6E7E7FFE7E7E7FFE7E7E6FFE7E7E7FFE7E7
      E7FFE7E7E6FFE6E6E6FFE6E7E7FFE7E7E7FFE7E6E7FFE7E7E6FFD1D1D1FF9CB4
      CFFF32BEF3FF31A4EBFF31A4EBFF31B2EFFF31B2EFFF32C8F6FF6B839FFF0000
      0000000000000000000000000000000000000000000000000000000000006464
      64FFFDFDFDFFE1E1E1FFA0A4A7FFF7DBC8FFFFC892FFFFCC97FFFFCD99FFFFD0
      9EFFFFD2A2FFFFD2A4FFFFD2A4FFFFD1A1FFFFCE9CFFFFCC96FFFFCC97FFFFD8
      A8FFECB88EFF817975FF5F6162FFE6E6E6FFF5F5F5FFA0A0A0FF040404740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFF5C5D
      C4FF0F0FBEFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000
      CCFF0000CCFF0000CCFF0000B9FC00000F500000005F000000FF44933EFFFFFF
      FFFFDCEFDBFFDCEFDBFFDCEFDBFFDCEFDBFFE7F3E5FFE2F1E1FF4CB86AFF4EBE
      76FF4FC280FF50C584FF3F8A0FFF3F890DFF9EC385FFCCE8C9FFCCE8C9FFCCE8
      C9FFCCE8C9FFCCE8C9FFCCE8C9FFCCE8C9FFCCE8C9FFCCE8C9FFCCE8C9FFCCE8
      C9FFCCE8C9FFE7F1E7FF44933EFF000000FF0000000000000000000000000000
      0000000000009E9E9EFFEAEAEAFFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
      E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFD3D3D3FF91AD
      CDFF2CBBF2FF2BA1EAFF2BA1EAFF2CB2EFFF2CB2EFFF2DC7F5FF6481A1FF0000
      0000000000000000000000000000000000000000000000000000000000006666
      66FFFBFBFBFFF3F3F3FF9B9EA0FFE8D9D1FFFFBF8BFFFFD19FFFFFD3A6FFFFD6
      ACFFFFD8B0FFFFD9B2FFFFD9B1FFFFD8AFFFFFD5AAFFFFD2A3FFFFCD9AFFFFD2
      9AFFD19C76FF6F7072FF787979FFF0F0F0FFF4F4F4FFA1A1A1FF050505740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFF5C5DC4FF0F0FBEFF0000CCFF0000CCFF0000CCFF0000CCFF0000CCFF0000
      CCFF0000CCFF0000CCFF0000B9FC00000F500000005F000000FF459541FFFFFF
      FFFFE1F1DFFFE1F1DFFFE1F1DFFFE1F1DFFFE1F1DFFFC9E6C9FF4BB35FFF4CB8
      69FF4DBB71FF87B568FF3F890DFF3E880BFF3E880AFFFEFEFEFFE1F1DFFFE0F0
      DFFFD6ECD4FFCEE9CBFFCEE9CBFFCEE9CBFFCEE9CBFFCEE9CBFFCEE9CBFFCEE9
      CBFFCEE9CBFFE8F1E7FF459541FF000000FF0000000000000000000000000000
      000000000000A0A0A0FFEBEBEBFFEBEBEBFFEBEAEAFFEAEBEAFFEAEAEAFFEBEB
      EBFFEBEBEBFFEBEBEAFFEBEAEAFFEBEAEAFFEBEAEAFFEBEBEAFFD4D4D4FF85A5
      CAFF28B8F2FF279DEAFF279EEAFF28B2F0FF28B1F0FF29C7F6FF5C7CA1FF0000
      0004000000000000000000000000000000000000000000000000000000006868
      68FFFBFBFBFFFFFFFFFFAFAFAFFFC0C2C4FFFCC3A2FFFFD0A1FFFFDBB4FFFFDD
      B8FFFFDFBDFFFFE0C0FFFFE0BFFFFFDEBCFFFFDBB6FFFFD7AEFFFFD8AAFFFDBD
      87FFA88A79FF5A5F61FFB2B2B1FFEFEFEFFFF5F5F5FFA3A3A3FF060606740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFF6767C6FF0505AEFB0000CCFF0000CCFF000099EB00006ACA0000
      66C6000066C6000066C6000066C6000003250000005F000000FF459745FFFFFF
      FFFFE5F3E3FFE5F3E3FFE5F3E3FFE5F3E3FFE5F3E3FF47A748FF49AC52FF4AB1
      5BFF59BA6EFFE5F3E3FF3E880BFF3E880AFF3E870AFF3E8709FFE6F3E4FFE5F3
      E3FFE5F3E3FFE5F3E3FFE5F3E3FFE5F3E3FFE5F3E3FFE5F3E3FFE5F3E3FFE5F3
      E3FFE5F3E3FFE8F2E8FF459745FF000000FF0000000000000000000000000000
      000000000000A2A2A2FFEDEDEDFFECEDEDFFEDEDEDFFEDEDECFFEDECEDFFEDED
      EDFFECEDECFFEDECEDFFEDEDEDFFECEDEDFFEDEDEDFFEDEDEDFFD6D6D6FF799E
      C7FF24B5F1FF2499E9FF249CEAFF25B3F1FF25B1F0FF25C6F6FF5478A3FF0000
      0009000000000000000000000000000000000000000000000000000000006A6A
      6AFFFBFBFBFFFCFCFCFFE6E6E6FF95999AFFE6D7D1FFFBB58CFFFFDFBCFFFFE6
      CAFFFFE5CBFFFFE7CEFFFFE7CDFFFFE4C9FFFFE1C2FFFFE3C0FFFFD0A1FFC78C
      6CFF828486FF696A6AFFECECECFFE9E9E9FFF6F6F6FFA4A4A4FF060606740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF1C1D79E70000A3EE0000CCFF00008DE4000000120000
      0000000000000000000000000000000000000000005F000000FF459A48FFFFFF
      FFFFE9F5E8FFE9F5E8FFE9F5E8FFE9F5E8FF439A2FFF45A03BFF47A545FF48A9
      4CFFF0F8EFFFE9F5E8FFE9F5E8FF3E8709FF3E8709FF3E8709FF96BD78FFE9F5
      E8FFE9F5E8FFE9F5E8FFE9F5E8FFE9F5E8FFE9F5E8FFE9F5E8FFE9F5E8FFE9F5
      E8FFE9F5E8FFE8F2E8FF459A48FF000000FF0000000000000000000000000000
      000000000000A4A4A4FFEFEFEFFFEEEEEEFFEEEEEEFFEFEEEEFFEEEEEEFFEEEE
      EEFFEEEFEEFFEEEEEEFFEEEEEFFFEEEEEEFFEEEEEEFFEFEEEEFFD7D7D7FF6C95
      C3FF1FB2F1FF1F97E8FF1F9BEAFF20B5F2FF20B2F0FF20C6F6FF4B73A2FF0000
      0007000000000000000000000000000000000000000000000000000000006C6C
      6CFFFCFCFCFFF9F9F9FFFFFFFFFFC1C1C1FF9FA4A6FFE7CFC5FFF6AD8AFFFFD6
      B8FFFFF2DEFFFFF6E6FFFFF6E5FFFFF3DFFFFFE9CEFFFBC099FFCB8B6DFF9794
      94FF5D5F60FFCECECEFFF0F0F0FFE9E9E9FFF6F6F6FFA5A5A5FF070707740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC200003D9B0000A3EE00008DE4000000120000
      0000000000000000000000000000000000000000005F000000FF469C4CFFFFFF
      FFFFEEF7EDFFEEF7EDFFEEF7EDFFCDE3C4FF419322FF43992DFF449D35FFFFFF
      FFFFEEF7EDFFEEF7EDFFEEF7EDFF88B567FF3E8709FF3E8709FF3E8709FFFEFE
      FEFFEEF7EDFFEEF7EDFFEEF7EDFFEEF7EDFFEEF7EDFFEEF7EDFFEEF7EDFFEEF7
      EDFFEEF7EDFFE8F2E8FF469C4CFF000000FF0000000000000000000000000000
      000000000000A6A6A6FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
      F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFD9D9D9FF608D
      BFFF1CB0F0FF1C95E7FF1C98E8FF1DB5F1FF1DB3F1FF1DC6F6FF284E7ADC0000
      0001000000000000000000000000000000000000000000000000000000006E6E
      6EFFFCFCFCFFFAFAFAFFF9F9F9FFFEFEFEFFB8B8B8FF9BA1A3FFD3C8C4FFE7AD
      98FFEEA78CFFF4B49CFFF5B79EFFEFAB8FFFDC9578FFBB9284FF929496FF686B
      6CFFC3C3C2FFF5F5F5FFEBEBEBFFEAEAEAFFF7F7F7FFA7A7A7FF080808740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000369000009BF5000000120000
      00000000000000000000000000000000000000000045000000FF469E50FFFFFF
      FFFFF2F9F1FFF2F9F1FFF2F9F1FFF2F9F1FFF2F9F1FFF2F9F1FFF2F9F1FFF2F9
      F1FFF2F9F1FFF2F9F1FFF2F9F1FFF2F9F1FFF2F9F1FFF2F9F1FFF2F9F1FFF2F9
      F1FFF2F9F1FFF2F9F1FFF2F9F1FFF2F9F1FFF2F9F1FFF2F9F1FFF2F9F1FFF2F9
      F1FFF2F9F1FFE8F3E9FF469E50FF000000FF0000000000000000000000000000
      000000000000A7A7A7FFF2F2F2FFF2F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F2
      F1FFF1F1F1FFF2F1F2FFF2F1F2FFECEBEBFF8EABCBFF5485BCFF5485BCFF5485
      BCFF19A6ECFF1890E7FF1894E7FF19B4F1FF19B2F1FF1AC1F4FF10335DC0092A
      51B3092A51B3030E1B6900000000000000000000000000000000000000007070
      70FFFDFDFDFFFBFBFBFFF9F9F9FFF9F9F9FFFFFFFFFFD0D0CFFF9B9E9FFFA7AD
      AFFFBBB4B2FFC1AAA3FFBEA29AFFB19F9AFF9C9C9DFF83898CFF8B8C8CFFDADA
      DAFFF7F7F7FFECECECFFECECECFFEBEBEBFFF7F7F7FFA8A8A8FF090909740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000001861000000050000
      00000000000000000000000000000000000000000000000000FF479F53FF9ACA
      A1FFF6FBF5FFF6FBF5FFF6FBF5FFF6FBF5FFF6FBF5FFF6FBF5FFF6FBF5FFF6FB
      F5FFF6FBF5FFF6FBF5FFF6FBF5FFF6FBF5FFF6FBF5FFF6FBF5FFF6FBF5FFF6FB
      F5FFF6FBF5FFF6FBF5FFF6FBF5FFF6FBF5FFF6FBF5FFF6FBF5FFF6FBF5FFF6FB
      F5FFF6FBF5FFE8F3E9FF47A053FF000000FF0000000000000000000000000000
      000000000000A9A9A9FFF1F0F1FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
      F0FFF0F0F0FFF0F0F0FFF0F0F0FFE5E5E5FF487BB7FF16CDF9FF15B4F1FF14A2
      ECFF0F89E2FF138AE4FF148CE5FF15B1F0FF14B0F0FF10AFEFFF15C0F5FF16CC
      F7FF17DDFCFF0A315EC100000000000000000000000000000000000000007272
      72FFFEFEFEFFFCFCFCFFFAFAFAFFF9F9F9FFF9F9F9FFFEFEFEFFF5F5F5FFCFCF
      CFFFB2B3B4FFA9ACADFFA7ABADFFA5A7A8FFB1B2B2FFD5D5D5FFF7F7F7FFF4F4
      F4FFEEEEEEFFEEEEEEFFEDEDEDFFECECECFFF8F8F8FFA9A9A9FF090909740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000FF000200FF47A2
      57FFFFFFFFFFFAFDFAFFFAFDFAFFFAFDFAFFFAFDFAFFFAFDFAFFFAFDFAFFFAFD
      FAFFFAFDFAFFFAFDFAFFFAFDFAFFFAFDFAFFFAFDFAFFFAFDFAFFFAFDFAFFFAFD
      FAFFFAFDFAFFFAFDFAFFFAFDFAFFFAFDFAFFFAFDFAFFFAFDFAFFFAFDFAFFFAFD
      FAFFFAFDFAFFE8F3EAFF47A257FF000000FF0000000000000000000000000000
      000000000000AAAAAAFFEFEFEFFFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3
      F3FFF3F3F3FFF3F3F3FFF3F3F3FFEDEDEDFF7C9DC2FF3D74B4FF12B2F1FF1090
      E6FF0B77DCFF0C7BDDFF1086E3FF11AFF0FF0DA9EDFF0CA6EDFF11B6F2FF13CC
      F8FF0C386BCE0413247900000000000000000000000000000000000000007474
      74FFFEFEFEFFFDFDFDFFFBFBFBFFFAFAFAFFFAFAFAFFF9F9F9FFF9F9F9FFFDFD
      FDFFFEFEFEFFFAFAFAFFF8F8F8FFFAFAFAFFFBFBFBFFF7F7F7FFF1F1F1FFF0F0
      F0FFEFEFEFFFEFEFEFFFEEEEEEFFECECECFFF9F9F9FFAAAAAAFF090909740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000FF000000FF5DB2
      75FF47A45AFFF3F9F4FFFEFEFEFFFDFEFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFE8F3EAFF47A45AFF000000FF0000000000000000000000000000
      0000000000003B3B3B96ABABABFFABABABFFABABABFFABABABFFABABABFFABAB
      ABFFABABABFFABABABFFABABABFFABABABFFA7A7A7FF5577A0FF2762A6FF0EAF
      F0FF087EDFFF0773DAFF0774DBFF08A7EDFF08A6ECFF09ADEFFF0FCCF8FF0D40
      7ADB051629810000000000000000000000000000000000000000000000007676
      76FFFFFFFFFFFEFEFEFFFCFCFCFFFBFBFBFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8
      F8FFF7F7F7FFF6F6F6FFF5F5F5FFF5F5F5FFF4F4F4FFF3F3F3FFF2F2F2FFF1F1
      F1FFF0F0F0FFEFEFEFFFEFEFEFFFEDEDEDFFF9F9F9FFACACACFF0A0A0A740000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000009000000FF3561
      06FF64B77DFF48A65EFF48A65EFF48A65EFF48A65EFF48A65EFF48A65EFF48A6
      5EFF48A65EFF48A65EFF48A65EFF48A65EFF48A65EFF48A65EFF48A65EFF48A6
      5EFF48A65EFF48A65EFF48A65EFF48A65EFF48A65EFF48A65EFF48A65EFF48A6
      5EFF48A65EFF48A65EFF48A65EFF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000C0E243EA00F46
      86E605A3EBFF047ADDFF0470D9FF05A6EDFF05ADEFFF06C6F6FF0F4686E60518
      2D87000000000000000000000000000000000000000000000000000000007A7A
      7AFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFDFDFDFFFCFCFCFFFBFBFBFFFBFB
      FBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF1F1F1FFF1F1F1FFEFEFEFFFFDFDFDFFB0B0B0FF0B0B0B780000
      0000000000000000000000000000000000000A0B0A5ACFD0D0FFEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE9EBEBFF3C3E3EC2000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000FF0000
      00FF3F760EFF407A15FF5AA863FF64B77DFF64B77DFF64B77DFF64B77DFF64B7
      7DFF64B77DFF64B77DFF64B77DFF64B77DFF64B77DFF64B77DFF64B77DFF64B7
      7DFF64B77DFF64B77DFF64B77DFF64B77DFF64B77DFF64B77DFF64B77DFF64B7
      7DFF64B77DFF64B77DFF549A65FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000C0E27
      43A6104C92F003A1EBFF0278DDFF03ADEFFF04C5F6FF104C92F0061A328D0000
      0000000000000000000000000000000000000000000000000000000000004040
      40DADDDDDDFFF6F6F6FFF5F5F5FFF5F5F5FFF4F4F4FFF4F4F4FFF3F3F3FFF3F3
      F3FFF2F2F2FFF2F2F2FFF1F1F1FFF1F1F1FFF0F0F0FFF0F0F0FFEFEFEFFFEFEF
      EFFFEFEFEFFFEEEEEEFFEEEEEEFFEDEDEDFFEFEFEFFF7E7E7EFF060606520000
      0000000000000000000000000000000000000A0B0A59CBCDCCFEEFF1F1FFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEEEEFFECEE
      EEFFECEEEEFFE6E8E8FF3C3D3DC1000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00FF000000FF0F1E04FF41801CFF428422FF428829FF438C30FF449037FF4494
      3EFF459845FF469C4CFF47A053FF47A45AFF48A860FF47A45AFF47A053FF469C
      4CFF459845FF44943EFF449037FF438C30FF428829FF428422FF41801CFF407A
      15FF3F760EFF3F7207FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000C0F2947AB11529BF801AAEFFF02CBF8FF11529BF8061C3592000000000000
      0000000000000000000000000000000000000000000000000000000000000303
      033B383838D35F5F5FF95D5D5DF85D5D5DF85D5D5DF85D5D5DF85D5D5DF85D5D
      5DF85D5D5DF85D5D5DF85D5D5DF85D5D5DF85D5D5DF85D5D5DF85D5D5DF85D5D
      5DF85D5D5DF85E5E5EF85E5E5EF8606060F9545454F316161696000000040000
      00000000000000000000000000000000000000000016353735B53E4040C63E40
      40C63E4040C63E4040C63E4040C63E4040C63E4040C63E4040C63E4040C63E40
      40C63E4040C63E4040C63E4040C63E4040C63E4040C63E4040C63E4040C63E40
      40C63E4040C63C3F3FC307070744000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FE000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000EB0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000C0C2543A51256A5FF1256A5FF061D389600000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000055000000EE000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000080000000400000000100010000000000000400000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
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
      000000000000}
  end
  object SplashScreen1: TAdvSmoothSplashScreen
    Version = '1.4.0.1'
    AutoShow = False
    BasicProgramInfo.ProgramName.Font.Charset = ANSI_CHARSET
    BasicProgramInfo.ProgramName.Font.Color = clWindowText
    BasicProgramInfo.ProgramName.Font.Height = -19
    BasicProgramInfo.ProgramName.Font.Name = 'Arial Narrow'
    BasicProgramInfo.ProgramName.Font.Style = [fsBold, fsItalic]
    BasicProgramInfo.ProgramName.Location = ilBottomCenter
    BasicProgramInfo.ProgramName.PosX = 170
    BasicProgramInfo.ProgramName.PosY = 190
    BasicProgramInfo.ProgramName.ColorStart = clBlue
    BasicProgramInfo.ProgramName.ColorEnd = clHighlight
    BasicProgramInfo.ProgramVersion.Font.Charset = DEFAULT_CHARSET
    BasicProgramInfo.ProgramVersion.Font.Color = clWindowText
    BasicProgramInfo.ProgramVersion.Font.Height = -19
    BasicProgramInfo.ProgramVersion.Font.Name = 'Tahoma'
    BasicProgramInfo.ProgramVersion.Font.Style = []
    BasicProgramInfo.ProgramVersion.PosX = 80
    BasicProgramInfo.CopyRightFont.Charset = DEFAULT_CHARSET
    BasicProgramInfo.CopyRightFont.Color = clWindowText
    BasicProgramInfo.CopyRightFont.Height = -11
    BasicProgramInfo.CopyRightFont.Name = 'Tahoma'
    BasicProgramInfo.CopyRightFont.Style = []
    Fill.Color = clNone
    Fill.ColorTo = clNone
    Fill.ColorMirror = clNone
    Fill.ColorMirrorTo = clNone
    Fill.GradientType = gtNone
    Fill.GradientMirrorType = gtNone
    Fill.PictureAspectRatio = True
    Fill.PictureAspectMode = pmNormal
    Fill.Opacity = 0
    Fill.OpacityTo = 0
    Fill.OpacityMirror = 0
    Fill.OpacityMirrorTo = 0
    Fill.BorderColor = clNone
    Fill.Rounding = 0
    Fill.ShadowColor = clNone
    Fill.ShadowOffset = 0
    Fill.Glow = gmNone
    ProgressBar.BackGroundFill.ColorMirror = clNone
    ProgressBar.BackGroundFill.ColorMirrorTo = clNone
    ProgressBar.BackGroundFill.GradientType = gtVertical
    ProgressBar.BackGroundFill.GradientMirrorType = gtSolid
    ProgressBar.BackGroundFill.BorderColor = clNone
    ProgressBar.BackGroundFill.Rounding = 0
    ProgressBar.BackGroundFill.ShadowOffset = 0
    ProgressBar.BackGroundFill.Glow = gmNone
    ProgressBar.ProgressFill.Color = clLime
    ProgressBar.ProgressFill.ColorMirror = clNone
    ProgressBar.ProgressFill.ColorMirrorTo = clNone
    ProgressBar.ProgressFill.GradientType = gtVertical
    ProgressBar.ProgressFill.GradientMirrorType = gtSolid
    ProgressBar.ProgressFill.BorderColor = clNone
    ProgressBar.ProgressFill.Rounding = 0
    ProgressBar.ProgressFill.ShadowOffset = 0
    ProgressBar.ProgressFill.Glow = gmNone
    ProgressBar.Font.Charset = DEFAULT_CHARSET
    ProgressBar.Font.Color = clWindowText
    ProgressBar.Font.Height = -11
    ProgressBar.Font.Name = 'Tahoma'
    ProgressBar.Font.Style = []
    ProgressBar.ProgressFont.Charset = DEFAULT_CHARSET
    ProgressBar.ProgressFont.Color = clWindowText
    ProgressBar.ProgressFont.Height = -11
    ProgressBar.ProgressFont.Name = 'Tahoma'
    ProgressBar.ProgressFont.Style = []
    ProgressBar.ValueFormat = '%.0f%%'
    ProgressBar.ValueType = vtPercentage
    ProgressBar.ValueVisible = True
    ProgressBar.Visible = True
    ProgressBar.Step = 10.000000000000000000
    ProgressBar.Maximum = 100.000000000000000000
    Items = <
      item
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end>
    ListItems = <>
    ListItemsSettings.HTMLFont.Charset = DEFAULT_CHARSET
    ListItemsSettings.HTMLFont.Color = clWindowText
    ListItemsSettings.HTMLFont.Height = -11
    ListItemsSettings.HTMLFont.Name = 'Tahoma'
    ListItemsSettings.HTMLFont.Style = []
    TopLayerItems = <>
    Left = 136
    Top = 208
  end
  object Timer1: TTimer
    Enabled = False
    Left = 136
    Top = 256
  end
  object JvSelectDirectory1: TJvSelectDirectory
    Left = 16
    Top = 304
  end
end
