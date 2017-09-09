object frmMain: TfrmMain
  Left = 505
  Top = 155
  Caption = 'NativeXml Test'
  ClientHeight = 505
  ClientWidth = 670
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object mmDebug: TMemo
    Left = 0
    Top = 0
    Width = 670
    Height = 505
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Lucida Console'
    Font.Style = []
    ImeName = 'Microsoft IME 2010'
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object MainMenu1: TMainMenu
    Left = 432
    Top = 104
    object File1: TMenuItem
      Caption = 'File'
      object mnuParse: TMenuItem
        Caption = 'Parse'
        OnClick = mnuParseClick
      end
      object mnuParseCanonical: TMenuItem
        Caption = 'Parse Canonical'
        OnClick = mnuParseCanonicalClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = 'Exit'
        OnClick = mnuExitClick
      end
    end
    object est1: TMenuItem
      Caption = 'Test'
      object mnuTest1: TMenuItem
        Caption = 'Test 1'
      end
      object mnuTest2: TMenuItem
        Caption = 'Test 2'
      end
      object mnuTest3: TMenuItem
        Caption = 'Test 3'
        OnClick = mnuTest3Click
      end
      object mnuTest4: TMenuItem
        Caption = 'Test 4'
        OnClick = mnuTest4Click
      end
      object mnuTest5: TMenuItem
        Caption = 'Test 5'
        OnClick = mnuTest5Click
      end
      object mnuTest6: TMenuItem
        Caption = 'Test 6'
        OnClick = mnuTest6Click
      end
      object mnuTest7: TMenuItem
        Caption = 'Test 7'
      end
      object mnuTest8: TMenuItem
        Caption = 'Test 8'
      end
      object mnuTest9: TMenuItem
        Caption = 'Test 9'
        OnClick = mnuTest9Click
      end
      object mnuTest10: TMenuItem
        Caption = 'Test 10'
        OnClick = mnuTest10Click
      end
      object mnuTest11: TMenuItem
        Caption = 'Test 11'
      end
      object mnuTest12: TMenuItem
        Caption = 'Test 12'
      end
      object mnuTest13: TMenuItem
        Caption = 'Test 13'
        OnClick = mnuTest13Click
      end
      object mnuTest14: TMenuItem
        Caption = 'Test 14'
        OnClick = mnuTest14Click
      end
      object mnuTest15: TMenuItem
        Caption = 'Test 15'
        OnClick = mnuTest15Click
      end
      object mnuTest16: TMenuItem
        Caption = 'Test 16'
        OnClick = mnuTest16Click
      end
      object mnuTest17: TMenuItem
        Caption = 'Test 17'
      end
      object mnuTest18: TMenuItem
        Caption = 'Test 18'
        OnClick = mnuTest18Click
      end
      object mnuTest19: TMenuItem
        Caption = 'Test 19'
        OnClick = mnuTest19Click
      end
      object mnuTest20: TMenuItem
        Caption = 'Test 20'
        OnClick = mnuTest20Click
      end
      object mnuTest21: TMenuItem
        Caption = 'Test 21'
      end
      object mnuTest22: TMenuItem
        Caption = 'Test 22'
        OnClick = mnuTest22Click
      end
      object mnuTest23: TMenuItem
        Caption = 'Test 23'
        OnClick = mnuTest23Click
      end
      object mnuTest24: TMenuItem
        Caption = 'Test 24'
      end
      object mnuTest25: TMenuItem
        Caption = 'Test 25'
      end
      object mnuTest26: TMenuItem
        Caption = 'Test 26'
        OnClick = mnuTest26Click
      end
      object mnuTest27: TMenuItem
        Caption = 'Test 27'
        OnClick = mnuTest27Click
      end
      object mnuTest28: TMenuItem
        Caption = 'Test 28'
        OnClick = mnuTest28Click
      end
      object mnuTest29: TMenuItem
        Caption = 'Test 29'
        OnClick = mnuTest29Click
      end
      object mnuTest30: TMenuItem
        Caption = 'Test 30'
        OnClick = mnuTest30Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object mnuDebugOutput: TMenuItem
        AutoCheck = True
        Caption = 'Debug Output'
        Checked = True
      end
      object mnuSaveOutput: TMenuItem
        AutoCheck = True
        Caption = 'Save output to file'
      end
    end
  end
end
