object ToDoDetailF: TToDoDetailF
  Left = 0
  Top = 0
  Caption = 'To-Do Detail'
  ClientHeight = 531
  ClientWidth = 676
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 676
    Height = 57
    Align = alTop
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 583
      Top = 11
      Width = 73
      Height = 41
      Caption = #52712#49548
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 465
      Top = 10
      Width = 73
      Height = 41
      Caption = #54869#51064
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
      OnClick = BitBtn2Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 57
    Width = 676
    Height = 32
    Align = alTop
    TabOrder = 1
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 32
      Height = 30
      Align = alLeft
      TabOrder = 0
      object Label1: TLabel
        Left = 2
        Top = 10
        Width = 28
        Height = 13
        Caption = #51228#47785':'
      end
    end
    object Panel5: TPanel
      Left = 33
      Top = 1
      Width = 642
      Height = 30
      Align = alClient
      TabOrder = 1
      object SubjectEdit: TEdit
        Left = 1
        Top = 1
        Width = 640
        Height = 28
        Align = alClient
        ImeName = 'Microsoft IME 2010'
        TabOrder = 0
        ExplicitHeight = 21
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 89
    Width = 676
    Height = 442
    Align = alClient
    TabOrder = 2
    object NoteMemo: TMemo
      Left = 1
      Top = 89
      Width = 674
      Height = 352
      Align = alClient
      ImeName = 'Microsoft IME 2010'
      TabOrder = 0
    end
    object Panel6: TPanel
      Left = 1
      Top = 1
      Width = 674
      Height = 88
      Align = alTop
      TabOrder = 1
      object Label2: TLabel
        Left = 16
        Top = 19
        Width = 52
        Height = 13
        Caption = #49884#51089#49884#44036':'
      end
      object Label3: TLabel
        Left = 16
        Top = 52
        Width = 52
        Height = 13
        Caption = #51333#47308#49884#44036':'
      end
      object Label4: TLabel
        Left = 368
        Top = 20
        Width = 52
        Height = 13
        Caption = #48120#47532#50508#47548':'
      end
      object Label5: TLabel
        Left = 368
        Top = 53
        Width = 52
        Height = 13
        Caption = #50508#47548#48169#48277':'
      end
      object dt_begin: TDateTimePicker
        Left = 74
        Top = 15
        Width = 175
        Height = 25
        Date = 42132.710435775470000000
        Time = 42132.710435775470000000
        DateFormat = dfLong
        ImeName = 'Microsoft IME 2010'
        TabOrder = 0
      end
      object Time_Begin: TDateTimePicker
        Left = 255
        Top = 15
        Width = 90
        Height = 25
        Date = 41527.000000000000000000
        Format = 'tt h:mm'
        Time = 41527.000000000000000000
        DateFormat = dfLong
        ImeName = 'Microsoft IME 2010'
        Kind = dtkTime
        TabOrder = 1
      end
      object dt_end: TDateTimePicker
        Left = 74
        Top = 46
        Width = 175
        Height = 25
        Date = 42132.710435775470000000
        Time = 42132.710435775470000000
        DateFormat = dfLong
        ImeName = 'Microsoft IME 2010'
        TabOrder = 2
      end
      object Time_End: TDateTimePicker
        Left = 255
        Top = 46
        Width = 90
        Height = 25
        Date = 41527.710435775470000000
        Format = 'tt h:mm'
        Time = 41527.710435775470000000
        DateFormat = dfLong
        ImeName = 'Microsoft IME 2010'
        Kind = dtkTime
        TabOrder = 3
      end
      object AlarmCombo: TComboBox
        Left = 426
        Top = 16
        Width = 145
        Height = 21
        ImeName = 'Microsoft IME 2010'
        TabOrder = 4
        Items.Strings = (
          ''
          '0'#48516
          '5'#48516
          '10'#48516
          '15'#48516
          '30'#48516
          '1'#49884#44036
          '2'#49884#44036
          '3'#49884#44036
          '4'#49884#44036
          '5'#49884#44036
          '6'#49884#44036
          '7'#49884#44036
          '8'#49884#44036
          '9'#49884#44036
          '10'#49884#44036
          '11'#49884#44036
          '18'#49884#44036
          '1'#51068
          '2'#51068
          '3'#51068
          '4'#51068
          '1'#51452
          '2'#51452)
      end
      object Button1: TButton
        Left = 582
        Top = 14
        Width = 75
        Height = 25
        Caption = #46104#54400#51060
        TabOrder = 5
        Visible = False
        OnClick = Button1Click
      end
      object MsgCB: TCheckBox
        Left = 432
        Top = 51
        Width = 57
        Height = 17
        Caption = #47928#51088
        TabOrder = 6
      end
      object NoteCB: TCheckBox
        Left = 495
        Top = 51
        Width = 58
        Height = 17
        Caption = #51901#51648
        TabOrder = 7
      end
    end
  end
end
