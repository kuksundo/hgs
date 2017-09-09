object GetUser_Frm: TGetUser_Frm
  Left = 0
  Top = 0
  Caption = 'GetUser_Frm'
  ClientHeight = 589
  ClientWidth = 771
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 0
    Width = 771
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 337
    ExplicitWidth = 138
  end
  object NxHeaderPanel1: TNxHeaderPanel
    Left = 0
    Top = 0
    Width = 1115
    Height = 665
    Caption = #50976#51200' '#51221#48372' '#44032#51256#50724#44592
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -19
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = [fsBold]
    HeaderSize = 40
    ParentFont = False
    ParentHeaderFont = False
    TabOrder = 0
    FullWidth = 1115
    object Panel2: TPanel
      Left = 0
      Top = 40
      Width = 1113
      Height = 623
      Align = alClient
      Color = clInactiveCaptionText
      ParentBackground = False
      TabOrder = 0
      object Panel1: TPanel
        Left = 1
        Top = 1
        Width = 336
        Height = 199
        Align = alLeft
        Color = clInactiveCaptionText
        ParentBackground = False
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 79
          Width = 50
          Height = 13
          Caption = 'File Name:'
        end
        object Button1: TButton
          Left = 192
          Top = 118
          Width = 121
          Height = 32
          Caption = #50976#51200' '#44032#51256#50724#44592'('#54028#51068')'
          TabOrder = 0
          OnClick = Button1Click
        end
        object JvFilenameEdit1: TJvFilenameEdit
          Left = 79
          Top = 75
          Width = 233
          Height = 21
          ImeName = 'Microsoft IME 2010'
          TabOrder = 1
          Text = ''
        end
        object Button3: TButton
          Left = 111
          Top = 118
          Width = 75
          Height = 32
          Caption = #46321' '#47197
          TabOrder = 2
          OnClick = Button3Click
        end
        object Button5: TButton
          Left = 30
          Top = 118
          Width = 75
          Height = 32
          Caption = #47784#46160' '#49325#51228
          TabOrder = 3
          OnClick = Button5Click
        end
        object DEPT: TEdit
          Left = 79
          Top = 31
          Width = 65
          Height = 21
          ImeName = 'Microsoft Office IME 2007'
          TabOrder = 4
          Text = 'DEPT'
          Visible = False
        end
        object chair: TEdit
          Left = 8
          Top = 31
          Width = 65
          Height = 21
          ImeName = 'Microsoft Office IME 2007'
          TabOrder = 5
          Visible = False
        end
        object Panel10: TPanel
          Left = 1
          Top = 1
          Width = 334
          Height = 24
          Align = alTop
          Caption = #46321' '#47197' / '#49688' '#51221
          Color = clSkyBlue
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 6
        end
      end
      object Panel3: TPanel
        Left = 1
        Top = 200
        Width = 1111
        Height = 422
        Align = alBottom
        TabOrder = 1
        object Panel5: TPanel
          Left = 1
          Top = 1
          Width = 1109
          Height = 64
          Align = alTop
          TabOrder = 0
          object Label1: TLabel
            Left = 7
            Top = 35
            Width = 40
            Height = 13
            Caption = #52509#51064#50896':'
          end
          object Edit1: TEdit
            Left = 53
            Top = 30
            Width = 65
            Height = 21
            ImeName = 'Microsoft IME 2010'
            TabOrder = 0
          end
          object Panel6: TPanel
            Left = 1
            Top = 1
            Width = 1107
            Height = 24
            Align = alTop
            Caption = #51312#54924#46108' '#44208#44284
            Color = clSkyBlue
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
          end
        end
        object userGrid: TNextGrid
          Left = 1
          Top = 65
          Width = 1109
          Height = 356
          Align = alClient
          Caption = ''
          TabOrder = 1
          TabStop = True
          object NxIncrementColumn1: TNxIncrementColumn
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            Position = 0
            SortType = stAlphabetic
          end
          object NxTextColumn1: TNxTextColumn
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = #49457#47749
            ParentFont = False
            Position = 1
            SortType = stAlphabetic
          end
          object NxTextColumn6: TNxTextColumn
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = #50689#47928#51060#47492
            ParentFont = False
            Position = 2
            SortType = stAlphabetic
          end
          object NxTextColumn2: TNxTextColumn
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = #49324#48264
            ParentFont = False
            Position = 3
            SortType = stAlphabetic
          end
          object NxTextColumn3: TNxTextColumn
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = #51649#44553
            ParentFont = False
            Position = 4
            SortType = stAlphabetic
          end
          object NxTextColumn4: TNxTextColumn
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = 'H.P'
            ParentFont = False
            Position = 5
            SortType = stAlphabetic
          end
          object NxTextColumn5: TNxTextColumn
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = #49324#47924#49892
            ParentFont = False
            Position = 6
            SortType = stAlphabetic
          end
          object NxTextColumn7: TNxTextColumn
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.Caption = 'E-Mail'
            ParentFont = False
            Position = 7
            SortType = stAlphabetic
          end
        end
      end
      object Panel4: TPanel
        Left = 337
        Top = 1
        Width = 775
        Height = 199
        Align = alClient
        TabOrder = 2
        object Memo1: TMemo
          Left = 1
          Top = 1
          Width = 773
          Height = 197
          Align = alClient
          ImeName = 'Microsoft IME 2010'
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
  end
end
