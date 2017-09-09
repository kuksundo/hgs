object frameDefaults: TframeDefaults
  Left = 0
  Top = 0
  Width = 346
  Height = 307
  TabOrder = 0
  OnResize = FrameResize
  DesignSize = (
    346
    307)
  object lblTimeFormat: TLabel
    Left = 0
    Top = 226
    Width = 101
    Height = 13
    Caption = 'Default Time Format:'
  end
  object panProg: TPanel
    Left = 0
    Top = 60
    Width = 346
    Height = 58
    Margins.Bottom = 12
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      346
      58)
    object btnTestEmailClient: TSpeedButton
      Left = 272
      Top = 13
      Width = 74
      Height = 25
      Hint = 'Test to run the e-mail program'
      Anchors = [akTop, akRight]
      Caption = 'Test'
      ParentShowHint = False
      ShowHint = True
      OnClick = btnTestEmailClientClick
      OnMouseDown = HelpMouseDown
    end
    object btnEdProgram: TSpeedButton
      Left = 247
      Top = 13
      Width = 19
      Height = 25
      Anchors = [akTop, akRight]
      Glyph.Data = {
        96000000424D960000000000000076000000280000000A000000040000000100
        040000000000200000000000000000000000100000000000000000000000FFFF
        FF00000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000111111111100
        0000001100110000000000110011000000001111111111000000}
      OnClick = btnEdProgramClick
      OnMouseDown = HelpMouseDown
    end
    object lblProgram: TLabel
      Left = 0
      Top = 0
      Width = 75
      Height = 13
      Caption = '&E-Mail Program:'
      FocusControl = edProgram
      Transparent = False
    end
    object edProgram: TEdit
      Left = 0
      Top = 19
      Width = 241
      Height = 21
      Hint = 'Default e-mail program to open.'
      TabOrder = 0
      OnChange = OptionsChange
      OnMouseDown = HelpMouseDown
    end
  end
  object panLang: TPanel
    Left = 0
    Top = 0
    Width = 346
    Height = 60
    Margins.Bottom = 10
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    DesignSize = (
      346
      60)
    object lblLang: TLabel
      Left = 0
      Top = 1
      Width = 51
      Height = 13
      Caption = 'Language:'
    end
    object btnLanguageRefresh: TPngSpeedButton
      Left = 247
      Top = 16
      Width = 99
      Height = 25
      Hint = 'Refresh the list of languages'
      Anchors = [akTop, akRight]
      Caption = '&Refresh'
      ParentShowHint = False
      ShowHint = False
      OnClick = btnLanguageRefresh2Click
      OnMouseDown = HelpMouseDown
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        6100000009704859730000037600000376017DD582CC000001FA4944415478DA
        63FCFFFF3F032EC098B84180E9C7FF697F970746E15483CB00D6A8F54E0C8C8C
        0B814C99DF4B0318893680316F3B3BFBFB3FED0C0CFF0B405CA8F08EFF0C8C8B
        7E09B2ACFB3FC9F3275E03B81336CF61F8CF908CC3C2A70CFF18FDBE2EF63987
        DB058D0758F8EE7FA9FFCFC85009E4326331E4EBBFFF0CFE5F16F8ECC51B0642
        C93B6CFE33FE5B0264CA035D54CCC0C4D002A439A1D20F04FE7269DE9FEFF083
        115F2C08A5EFE167FAF77BDA9BD99ED1E2193BF5FFFEFBB70514A8609B19194A
        5ECFF4ECC56B003A90C8DC5EFDFF3F630B2C605FCEF0F0041B2091B92B0228A0
        0072DA8BE96E2B70192099B15D8B9189F92A03247A9E3F9DE6260536403A67D7
        734606460970FCFF6795BC3FD5E105360314B30F48FC61FCFD1CC2FBFFE2F114
        3749B001F2797B3701057C21E2FFC31E4E765D8DCD00F982DDA10CFF195741E3
        6BF3C389CE7E6003940BF757FE67F8DF069578FC9BF197C1E33EF777C89A658B
        760AB1FE67BB00B44116E205C6AABBFD8EED600334CA8FF2FEFDF3EB3238CA20
        E03130E59532333280E3FAEF7F06674686FFDD2073A0F20F9959D8746F745A7F
        86C78246E93E270606A63D0C88E48B0B0035FC73B9D1EDB40F232169971F7606
        CACF81C60836F000A825E56AA7ED5E9800463AD0693CC0C3F493390B688F1590
        6B0A153E0D74D7B17FEC7FA75DA977F882AC1E00442FD9E14EAE239B00000000
        49454E44AE426082}
    end
    object lblTester: TLabel
      Left = 247
      Top = 1
      Width = 38
      Height = 13
      Caption = 'Refresh'
      Visible = False
    end
    object cmbLanguage: TComboBox
      Tag = 999
      Left = 0
      Top = 20
      Width = 241
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cmbLanguageChange
    end
  end
  object panSnd: TPanel
    Left = 0
    Top = 118
    Width = 346
    Height = 59
    Margins.Bottom = 12
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 2
    DesignSize = (
      346
      59)
    object btnEdDefSound: TSpeedButton
      Left = 247
      Top = 15
      Width = 19
      Height = 25
      Anchors = [akTop, akRight]
      Glyph.Data = {
        96000000424D960000000000000076000000280000000A000000040000000100
        040000000000200000000000000000000000100000000000000000000000FFFF
        FF00000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000111111111100
        0000001100110000000000110011000000001111111111000000}
      OnClick = btnEdDefSoundClick
      OnMouseDown = HelpMouseDown
    end
    object btnSndTest: TSpeedButton
      Left = 272
      Top = 15
      Width = 74
      Height = 25
      Hint = 'Test the sound file'
      Anchors = [akTop, akRight]
      Caption = 'Test'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777800087777777777800000877777777780000007777777777800080777
        7777777777770770777777777777077707777777777707770777777777770777
        0777777777770777077777777777077087777777777700007777777777770007
        7777777777770077777777777777087777777777777707777777}
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSndTestClick
      OnMouseDown = HelpMouseDown
    end
    object lblSound: TLabel
      Left = 0
      Top = 0
      Width = 129
      Height = 13
      Caption = 'Def&ault Notification Sound:'
      FocusControl = edDefSound
    end
    object edDefSound: TEdit
      Left = -1
      Top = 19
      Width = 242
      Height = 21
      Hint = 'Default sound to play when new mail arrives.'
      TabOrder = 0
      OnChange = OptionsChange
      OnMouseDown = HelpMouseDown
    end
  end
  object panlIniFolder: TPanel
    Left = 0
    Top = 177
    Width = 346
    Height = 48
    Margins.Bottom = 12
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 3
    DesignSize = (
      346
      48)
    object btnStorageLoc: TSpeedButton
      Left = 327
      Top = 15
      Width = 19
      Height = 25
      Anchors = [akTop, akRight]
      Glyph.Data = {
        96000000424D960000000000000076000000280000000A000000040000000100
        040000000000200000000000000000000000100000000000000000000000FFFF
        FF00000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000111111111100
        0000001100110000000000110011000000001111111111000000}
      OnClick = btnStorageLocClick
      OnMouseDown = HelpMouseDown
    end
    object lblIni: TLabel
      Left = 0
      Top = 1
      Width = 90
      Height = 13
      Caption = 'Ini Storage Folder:'
    end
    object edIniFolder: TEdit
      Left = 0
      Top = 20
      Width = 321
      Height = 21
      Hint = 
        'This setting can be changed via setup or a command line paramete' +
        'r.'
      ReadOnly = True
      TabOrder = 0
      OnChange = OptionsChange
      OnMouseDown = HelpMouseDown
    end
  end
  object cmbTimeFormat: TComboBox
    Left = 107
    Top = 224
    Width = 239
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemIndex = 0
    TabOrder = 4
    Text = 'AM/PM Time (12:00am-11:59pm)'
    OnChange = cmbTimeFormatChange
    Items.Strings = (
      'AM/PM Time (12:00am-11:59pm)'
      '24-Hour Time (0:00-23:59)')
  end
end
