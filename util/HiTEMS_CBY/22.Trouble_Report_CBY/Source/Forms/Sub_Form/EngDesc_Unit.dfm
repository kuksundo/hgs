object EngDesc_Frm: TEngDesc_Frm
  Left = 0
  Top = 0
  Caption = #50644#51652' '#44592#48376#51221#48372#46321#47197
  ClientHeight = 498
  ClientWidth = 1101
  Color = clBtnFace
  Constraints.MaxHeight = 536
  Constraints.MaxWidth = 1117
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 461
    Width = 1101
    Height = 37
    Align = alBottom
    Color = clCream
    ParentBackground = False
    TabOrder = 0
    object Button8: TButton
      AlignWithMargins = True
      Left = 821
      Top = 4
      Width = 90
      Height = 29
      Margins.Right = 0
      Align = alRight
      Caption = #45936#51060#53552' '#51200#51109
      ImageIndex = 2
      ImageMargins.Left = 5
      TabOrder = 0
      OnClick = Button8Click
    end
    object Button3: TButton
      AlignWithMargins = True
      Left = 914
      Top = 4
      Width = 90
      Height = 29
      Margins.Right = 0
      Align = alRight
      Caption = #52488#44592#54868
      ImageIndex = 4
      ImageMargins.Left = 5
      TabOrder = 1
      OnClick = Button3Click
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 1007
      Top = 4
      Width = 90
      Height = 29
      Align = alRight
      Caption = #45803#44592
      ImageIndex = 5
      ImageMargins.Left = 5
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 393
    Height = 461
    Align = alLeft
    TabOrder = 1
    object NxHeaderPanel1: TNxHeaderPanel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 385
      Height = 453
      Align = alClient
      Caption = 'ENGINE VIEW'
      ColorScheme = csSilver
      HeaderFont.Charset = ANSI_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -12
      HeaderFont.Name = #47569#51008' '#44256#46357
      HeaderFont.Style = [fsBold]
      HeaderStyle = psWindowsLive
      ParentHeaderFont = False
      TabOrder = 0
      FullWidth = 385
      object Panel3: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 419
        Width = 383
        Height = 32
        Margins.Left = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alBottom
        TabOrder = 0
        object Button6: TButton
          AlignWithMargins = True
          Left = 259
          Top = 4
          Width = 60
          Height = 24
          Margins.Left = 0
          Margins.Right = 0
          Align = alRight
          Caption = #52628#44032
          ImageIndex = 0
          TabOrder = 0
          OnClick = Button6Click
        end
        object Button11: TButton
          AlignWithMargins = True
          Left = 319
          Top = 4
          Width = 60
          Height = 24
          Margins.Left = 0
          Align = alRight
          Caption = #49325#51228
          ImageIndex = 1
          TabOrder = 1
          OnClick = Button11Click
        end
      end
      object NxPanel1: TNxPanel
        Left = 0
        Top = 27
        Width = 383
        Height = 389
        Align = alClient
        BorderPen.Color = clSilver
        BorderPen.Width = 2
        BorderWidth = 2
        UseDockManager = False
        TabOrder = 1
        object Image1: TImage
          AlignWithMargins = True
          Left = 3
          Top = 50
          Width = 373
          Height = 285
          Margins.Top = 50
          Margins.Bottom = 50
          Align = alClient
          AutoSize = True
          Center = True
          Stretch = True
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 396
          ExplicitHeight = 305
        end
      end
    end
  end
  object Panel4: TPanel
    Left = 393
    Top = 0
    Width = 708
    Height = 461
    Align = alClient
    TabOrder = 2
    object NxHeaderPanel2: TNxHeaderPanel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 700
      Height = 453
      Align = alClient
      Caption = 'ENGINE INFORMATION'
      ColorScheme = csSilver
      HeaderFont.Charset = ANSI_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -12
      HeaderFont.Name = #47569#51008' '#44256#46357
      HeaderFont.Style = [fsBold]
      HeaderStyle = psWindowsLive
      ParentHeaderFont = False
      TabOrder = 0
      FullWidth = 700
      object Panel5: TPanel
        Left = 0
        Top = 27
        Width = 698
        Height = 42
        Align = alTop
        TabOrder = 0
        object Label1: TLabel
          AlignWithMargins = True
          Left = 455
          Top = 24
          Width = 215
          Height = 14
          Margins.Top = 23
          Align = alLeft
          Caption = #8251'. '#48521#51008#49353' '#51077#47141#46976#51008' '#54596#49688' '#51077#47141' '#54637#47785' '#51077#45768#45796'.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitHeight = 13
        end
        object TEAM: TAdvOfficeRadioGroup
          AlignWithMargins = True
          Left = 137
          Top = 4
          Width = 312
          Height = 34
          Margins.Left = 0
          RoundEdges = True
          Version = '1.3.4.1'
          Align = alLeft
          Color = 8421631
          ParentBackground = False
          ParentColor = False
          TabOrder = 0
          Columns = 3
          Items.Strings = (
            #49884#50868#51204'1'#48152
            #49884#50868#51204'2'#48152
            #49884#50868#51204'3'#48152)
          Ellipsis = False
        end
        object Panel6: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 130
          Height = 34
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' '#50644#51652' '#44288#47532
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 1
        end
      end
      object Panel8: TPanel
        Left = 0
        Top = 69
        Width = 698
        Height = 29
        Align = alTop
        TabOrder = 1
        object Panel9: TPanel
          AlignWithMargins = True
          Left = 369
          Top = 4
          Width = 62
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' '#50644#51652#51077#44256#51068
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
        end
        object ENGIN: TNxDatePicker
          AlignWithMargins = True
          Left = 434
          Top = 4
          Width = 90
          Height = 21
          Margins.Left = 0
          Align = alLeft
          TabOrder = 3
          Text = '2012-01-27'
          HideFocus = False
          Date = 40935.000000000000000000
          NoneCaption = 'None'
          TodayCaption = 'Today'
        end
        object Panel10: TPanel
          AlignWithMargins = True
          Left = 530
          Top = 4
          Width = 62
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' '#50644#51652#52636#44256#51068
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 4
        end
        object ENGOUT: TNxDatePicker
          AlignWithMargins = True
          Left = 595
          Top = 4
          Width = 99
          Height = 21
          Margins.Left = 0
          Align = alClient
          TabOrder = 5
          Text = '2012-01-27'
          HideFocus = False
          Date = 40935.000000000000000000
          NoneCaption = 'None'
          TodayCaption = 'Today'
        end
        object Panel7: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' '#50644#51652#49345#54889
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object ESTATUS: TNxComboBox
          AlignWithMargins = True
          Left = 137
          Top = 4
          Width = 226
          Height = 21
          Margins.Left = 0
          Align = alLeft
          Color = 8421631
          TabOrder = 1
          Text = #49884#54744#51473
          ReadOnly = True
          OnButtonDown = ESTATUSButtonDown
          HideFocus = False
          AutoCompleteDelay = 0
          ItemIndex = 0
          Items.Strings = (
            #49884#54744#51473
            #49884#54744#51333#47308)
        end
      end
      object Panel12: TPanel
        Left = 0
        Top = 98
        Width = 698
        Height = 29
        Align = alTop
        TabOrder = 2
        object Panel11: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' '#44277#49324#48264#54840
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object PROJNO: TNxEdit
          AlignWithMargins = True
          Left = 137
          Top = 4
          Width = 90
          Height = 21
          Margins.Left = 0
          Align = alLeft
          Color = 8421631
          CharCase = ecUpperCase
          TabOrder = 1
        end
        object Panel13: TPanel
          AlignWithMargins = True
          Left = 233
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' '#44277#49324#47749
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
        end
        object PROJNAME: TNxEdit
          AlignWithMargins = True
          Left = 366
          Top = 4
          Width = 328
          Height = 21
          Margins.Left = 0
          Align = alClient
          TabOrder = 3
        end
      end
      object Panel14: TPanel
        Left = 0
        Top = 127
        Width = 698
        Height = 29
        Align = alTop
        TabOrder = 3
        object Panel15: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' '#54840#49440#48264#54840
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object SHIPNO: TNxEdit
          AlignWithMargins = True
          Left = 137
          Top = 4
          Width = 90
          Height = 21
          Margins.Left = 0
          Align = alLeft
          CharCase = ecUpperCase
          TabOrder = 1
        end
        object Panel16: TPanel
          AlignWithMargins = True
          Left = 233
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' '#54840#49440#47749
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
        end
        object SHIPNAME: TNxEdit
          AlignWithMargins = True
          Left = 366
          Top = 4
          Width = 328
          Height = 21
          Margins.Left = 0
          Align = alClient
          TabOrder = 3
        end
      end
      object Panel17: TPanel
        Left = 0
        Top = 156
        Width = 698
        Height = 29
        Align = alTop
        TabOrder = 4
        object Panel18: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' '#47784#45944#47749
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object ENGMODEL: TNxEdit
          AlignWithMargins = True
          Left = 137
          Top = 4
          Width = 90
          Height = 21
          Margins.Left = 0
          Align = alLeft
          TabOrder = 1
        end
        object Panel19: TPanel
          AlignWithMargins = True
          Left = 233
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' '#50644#51652#53440#51077
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
        end
        object ENGTYPE: TNxEdit
          AlignWithMargins = True
          Left = 366
          Top = 4
          Width = 90
          Height = 21
          Margins.Left = 0
          Align = alLeft
          Color = 8421631
          CharCase = ecUpperCase
          TabOrder = 3
        end
        object Panel20: TPanel
          AlignWithMargins = True
          Left = 462
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' '#54532#47196#51229#53944' '#47749
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 4
        end
        object ENGPROJ: TNxEdit
          AlignWithMargins = True
          Left = 595
          Top = 4
          Width = 99
          Height = 21
          Margins.Left = 0
          Align = alClient
          CharCase = ecUpperCase
          TabOrder = 5
        end
      end
      object Panel21: TPanel
        Left = 0
        Top = 214
        Width = 698
        Height = 29
        Align = alTop
        TabOrder = 5
        object Panel22: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' OPERATION TYPE'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object Panel23: TPanel
          AlignWithMargins = True
          Left = 233
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' '#49884#54744#45812#45817
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
        end
        object DESIGNID: TNxEdit
          AlignWithMargins = True
          Left = 596
          Top = 4
          Width = 27
          Height = 21
          Margins.Left = 0
          Align = alLeft
          TabOrder = 3
        end
        object Panel24: TPanel
          AlignWithMargins = True
          Left = 463
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' '#49444#44228#45812#45817
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 4
        end
        object DESIGNM: TNxEdit
          AlignWithMargins = True
          Left = 626
          Top = 4
          Width = 68
          Height = 21
          Margins.Left = 0
          Align = alClient
          TabOrder = 5
        end
        object MEASID: TNxEdit
          AlignWithMargins = True
          Left = 366
          Top = 4
          Width = 27
          Height = 21
          Margins.Left = 0
          Align = alLeft
          TabOrder = 6
        end
        object MEASNM: TNxEdit
          AlignWithMargins = True
          Left = 396
          Top = 4
          Width = 61
          Height = 21
          Margins.Left = 0
          Align = alLeft
          TabOrder = 7
        end
        object OPTYPE: TNxComboBox
          AlignWithMargins = True
          Left = 137
          Top = 4
          Width = 90
          Height = 21
          Margins.Left = 0
          Align = alLeft
          TabOrder = 1
          ReadOnly = True
          OnButtonDown = OPTYPEButtonDown
          HideFocus = False
          AutoCompleteDelay = 0
          Items.Strings = (
            'DIESEL'
            'GAS'
            'COMMON RAIL'
            'DUAL FUEL')
        end
      end
      object Panel25: TPanel
        Left = 0
        Top = 243
        Width = 698
        Height = 29
        Align = alTop
        TabOrder = 6
        object Panel26: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' CYLINDER NUM.'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object Panel27: TPanel
          AlignWithMargins = True
          Left = 233
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' BORE(Cm)'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 1
        end
        object Panel28: TPanel
          AlignWithMargins = True
          Left = 462
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' STROKE(Cm)'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
        end
        object CYLNUM: TNxNumberEdit
          AlignWithMargins = True
          Left = 137
          Top = 4
          Width = 90
          Height = 21
          Margins.Left = 0
          Align = alLeft
          TabOrder = 3
          Text = '0'
          Precision = 0
        end
        object BORE: TNxNumberEdit
          AlignWithMargins = True
          Left = 366
          Top = 4
          Width = 90
          Height = 21
          Margins.Left = 0
          Align = alLeft
          TabOrder = 4
          Text = '0'
          Precision = 0
        end
        object STROKE: TNxNumberEdit
          AlignWithMargins = True
          Left = 595
          Top = 4
          Width = 99
          Height = 21
          Margins.Left = 0
          Align = alClient
          TabOrder = 5
          Text = '0'
          Precision = 0
        end
      end
      object Panel29: TPanel
        Left = 0
        Top = 272
        Width = 698
        Height = 29
        Align = alTop
        TabOrder = 7
        object Panel30: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' RATED R.P.M'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object Panel31: TPanel
          AlignWithMargins = True
          Left = 233
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' RATED FREQUENCY(Hz)'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 1
        end
        object Panel32: TPanel
          AlignWithMargins = True
          Left = 462
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' ENGINE M.C.R(Kw)'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
        end
        object RPM: TNxNumberEdit
          AlignWithMargins = True
          Left = 137
          Top = 4
          Width = 90
          Height = 21
          Margins.Left = 0
          Align = alLeft
          TabOrder = 3
          Text = '0'
          Precision = 0
        end
        object FREQ: TNxNumberEdit
          AlignWithMargins = True
          Left = 366
          Top = 4
          Width = 90
          Height = 21
          Margins.Left = 0
          Align = alLeft
          TabOrder = 4
          Text = '0'
          Precision = 0
        end
        object MCR: TNxNumberEdit
          AlignWithMargins = True
          Left = 595
          Top = 4
          Width = 99
          Height = 21
          Margins.Left = 0
          Align = alClient
          TabOrder = 5
          Text = '0'
          Precision = 0
        end
      end
      object Panel33: TPanel
        Left = 0
        Top = 301
        Width = 698
        Height = 29
        Align = alTop
        TabOrder = 8
        object Panel34: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' ENG. ARRANGEMENT'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object Panel35: TPanel
          AlignWithMargins = True
          Left = 233
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' TEST BED'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 1
        end
        object Panel36: TPanel
          AlignWithMargins = True
          Left = 462
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' LBX NO'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
        end
        object ENGARR: TNxComboBox
          AlignWithMargins = True
          Left = 137
          Top = 4
          Width = 90
          Height = 21
          Margins.Left = 0
          Align = alLeft
          TabOrder = 3
          Text = 'In-line Type'
          ReadOnly = True
          HideFocus = False
          AutoCompleteDelay = 0
          ItemIndex = 0
          Items.Strings = (
            'In-line Type'
            'Vee-Type')
        end
        object TESTBED: TNxComboBox
          AlignWithMargins = True
          Left = 366
          Top = 4
          Width = 90
          Height = 21
          Margins.Left = 0
          Align = alLeft
          TabOrder = 4
          HideFocus = False
          AutoCompleteDelay = 0
        end
        object LBXNO: TNxNumberEdit
          AlignWithMargins = True
          Left = 595
          Top = 4
          Width = 99
          Height = 21
          Margins.Left = 0
          Align = alClient
          TabOrder = 5
          Text = '0'
          Precision = 0
        end
      end
      object Panel37: TPanel
        Left = 0
        Top = 330
        Width = 698
        Height = 29
        Align = alTop
        TabOrder = 9
        object Panel39: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' FIRING ORDER'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object FIRING: TNxEdit
          AlignWithMargins = True
          Left = 137
          Top = 4
          Width = 224
          Height = 21
          Margins.Left = 0
          Align = alLeft
          MaxLength = 48
          TabOrder = 1
        end
        object Panel59: TPanel
          AlignWithMargins = True
          Left = 367
          Top = 4
          Width = 87
          Height = 21
          Hint = #54648#46300#48513' '#50644#51652' '#49324#51060#51592' '#52280#44256
          Align = alLeft
          Caption = 'Server IP'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Visible = False
        end
        object Panel60: TPanel
          AlignWithMargins = True
          Left = 562
          Top = 4
          Width = 87
          Height = 21
          Hint = #54648#46300#48513' '#50644#51652' '#49324#51060#51592' '#52280#44256
          Align = alRight
          Caption = 'Server Port'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Visible = False
        end
        object svport: TNxNumberEdit
          AlignWithMargins = True
          Left = 652
          Top = 4
          Width = 42
          Height = 21
          Margins.Left = 0
          Align = alRight
          TabOrder = 4
          Text = '0'
          Visible = False
          Precision = 0
        end
        object svip: TNxEdit
          AlignWithMargins = True
          Left = 457
          Top = 4
          Width = 99
          Height = 21
          Margins.Left = 0
          Align = alClient
          MaxLength = 48
          TabOrder = 5
          Visible = False
        end
      end
      object Panel40: TPanel
        Left = 0
        Top = 359
        Width = 698
        Height = 29
        Align = alTop
        TabOrder = 10
        object Panel41: TPanel
          AlignWithMargins = True
          Left = 278
          Top = 4
          Width = 134
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' CRANKCASE RELIEF V/V'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object CRV: TNxNumberEdit
          AlignWithMargins = True
          Left = 415
          Top = 4
          Width = 42
          Height = 21
          Margins.Left = 0
          Align = alLeft
          Color = 8421631
          TabOrder = 1
          Text = '0'
          Precision = 0
        end
        object Panel38: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' ROTATING VIEWED'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
        end
        object ROTATE: TNxComboBox
          AlignWithMargins = True
          Left = 137
          Top = 4
          Width = 135
          Height = 21
          Margins.Left = 0
          Align = alLeft
          TabOrder = 3
          Text = 'CW(Clockwise)'
          ReadOnly = True
          HideFocus = False
          AutoCompleteDelay = 0
          ItemIndex = 0
          Items.Strings = (
            'CW(Clockwise)'
            'CCW(Count Clockwise)')
        end
        object Panel58: TPanel
          AlignWithMargins = True
          Left = 463
          Top = 4
          Width = 88
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' T.A.T'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 4
        end
        object TAT: TNxDatePicker
          AlignWithMargins = True
          Left = 554
          Top = 4
          Width = 140
          Height = 21
          Margins.Left = 0
          Align = alClient
          TabOrder = 5
          Text = '2012-01-27'
          HideFocus = False
          Date = 40935.000000000000000000
          NoneCaption = 'None'
          TodayCaption = 'Today'
        end
      end
      object Panel42: TPanel
        Left = 0
        Top = 388
        Width = 698
        Height = 29
        Align = alTop
        TabOrder = 11
        object Panel43: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' BEARING NUM.(EA)'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object MAINBN: TNxNumberEdit
          AlignWithMargins = True
          Left = 230
          Top = 4
          Width = 42
          Height = 21
          Margins.Left = 0
          Align = alLeft
          Color = 8421631
          TabOrder = 1
          Text = '0'
          Precision = 0
        end
        object Panel44: TPanel
          AlignWithMargins = True
          Left = 140
          Top = 4
          Width = 87
          Height = 21
          Align = alLeft
          Caption = 'MAIN'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
        end
        object Panel45: TPanel
          AlignWithMargins = True
          Left = 278
          Top = 4
          Width = 87
          Height = 21
          Align = alLeft
          Caption = 'CAMSHAFT'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 3
        end
        object CAMBN: TNxNumberEdit
          AlignWithMargins = True
          Left = 368
          Top = 4
          Width = 42
          Height = 21
          Margins.Left = 0
          Align = alLeft
          Color = 8421631
          TabOrder = 4
          Text = '0'
          Precision = 0
        end
        object Panel46: TPanel
          AlignWithMargins = True
          Left = 416
          Top = 4
          Width = 87
          Height = 21
          Align = alLeft
          Caption = 'BIG-END'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 5
        end
        object BIGBN: TNxNumberEdit
          AlignWithMargins = True
          Left = 506
          Top = 4
          Width = 42
          Height = 21
          Margins.Left = 0
          Align = alLeft
          Color = 8421631
          TabOrder = 6
          Text = '0'
          Precision = 0
        end
        object Panel47: TPanel
          AlignWithMargins = True
          Left = 554
          Top = 4
          Width = 87
          Height = 21
          Align = alLeft
          Caption = 'SMALL-END'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 7
        end
        object SMALLBN: TNxNumberEdit
          AlignWithMargins = True
          Left = 644
          Top = 4
          Width = 50
          Height = 21
          Margins.Left = 0
          Align = alClient
          Color = 8421631
          TabOrder = 8
          Text = '0'
          Precision = 0
        end
      end
      object Panel48: TPanel
        Left = 0
        Top = 417
        Width = 698
        Height = 34
        Align = alClient
        TabOrder = 12
        object Panel49: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 130
          Height = 26
          Hint = #54648#46300#48513' '#50644#51652' '#49324#51060#51592' '#52280#44256
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' DIMENSION(mm)'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
        object DIMA: TNxNumberEdit
          AlignWithMargins = True
          Left = 230
          Top = 4
          Width = 42
          Height = 26
          Margins.Left = 0
          Align = alLeft
          TabOrder = 1
          Text = '0'
          Precision = 0
          ExplicitHeight = 21
        end
        object Panel50: TPanel
          AlignWithMargins = True
          Left = 140
          Top = 4
          Width = 87
          Height = 26
          Hint = #54648#46300#48513' '#50644#51652' '#49324#51060#51592' '#52280#44256
          Align = alLeft
          Caption = '"A"'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
        end
        object Panel51: TPanel
          AlignWithMargins = True
          Left = 278
          Top = 4
          Width = 87
          Height = 26
          Hint = #54648#46300#48513' '#50644#51652' '#49324#51060#51592' '#52280#44256
          Align = alLeft
          Caption = '"B"'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
        end
        object DIMB: TNxNumberEdit
          AlignWithMargins = True
          Left = 368
          Top = 4
          Width = 42
          Height = 26
          Margins.Left = 0
          Align = alLeft
          TabOrder = 4
          Text = '0'
          Precision = 0
          ExplicitHeight = 21
        end
        object Panel52: TPanel
          AlignWithMargins = True
          Left = 416
          Top = 4
          Width = 87
          Height = 26
          Hint = #54648#46300#48513' '#50644#51652' '#49324#51060#51592' '#52280#44256
          Align = alLeft
          Caption = '"C"'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
        end
        object DIMC: TNxNumberEdit
          AlignWithMargins = True
          Left = 506
          Top = 4
          Width = 42
          Height = 26
          Margins.Left = 0
          Align = alLeft
          TabOrder = 6
          Text = '0'
          Precision = 0
          ExplicitHeight = 21
        end
        object Panel53: TPanel
          AlignWithMargins = True
          Left = 554
          Top = 4
          Width = 87
          Height = 26
          Hint = #54648#46300#48513' '#50644#51652' '#49324#51060#51592' '#52280#44256
          Align = alLeft
          Caption = '"D"'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
        end
        object DIMD: TNxNumberEdit
          AlignWithMargins = True
          Left = 644
          Top = 4
          Width = 50
          Height = 26
          Margins.Left = 0
          Align = alClient
          TabOrder = 8
          Text = '0'
          Precision = 0
          ExplicitHeight = 21
        end
      end
      object Panel54: TPanel
        Left = 0
        Top = 185
        Width = 698
        Height = 29
        Align = alTop
        TabOrder = 13
        object Panel55: TPanel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' OWNER'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object OWNER_: TNxEdit
          AlignWithMargins = True
          Left = 137
          Top = 4
          Width = 90
          Height = 21
          Margins.Left = 0
          Align = alLeft
          TabOrder = 1
        end
        object Panel56: TPanel
          AlignWithMargins = True
          Left = 233
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' CLASS'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
        end
        object CLASS_: TNxEdit
          AlignWithMargins = True
          Left = 366
          Top = 4
          Width = 90
          Height = 21
          Margins.Left = 0
          Align = alLeft
          TabOrder = 3
        end
        object Panel57: TPanel
          AlignWithMargins = True
          Left = 462
          Top = 4
          Width = 130
          Height = 21
          Align = alLeft
          Alignment = taLeftJustify
          Caption = ' SITE'
          Color = 13037821
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #47569#51008' '#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 4
        end
        object SITE: TNxComboBox
          AlignWithMargins = True
          Left = 595
          Top = 4
          Width = 99
          Height = 21
          Margins.Left = 0
          Align = alClient
          TabOrder = 5
          HideFocus = False
          AutoCompleteDelay = 0
        end
      end
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 32
    Top = 376
  end
end
