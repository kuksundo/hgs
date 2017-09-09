object SettingsF: TSettingsF
  Left = 215
  Top = 158
  Caption = 'Settings'
  ClientHeight = 242
  ClientWidth = 452
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    452
    242)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 4
    Top = 212
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 92
    Top = 212
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnApply: TButton
    Left = 180
    Top = 212
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Apply'
    TabOrder = 2
    OnClick = btnApplyClick
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 460
    Height = 203
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    Style = tsButtons
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'Video Streaming'
      DesignSize = (
        452
        172)
      object Label1: TLabel
        Left = 0
        Top = 4
        Width = 34
        Height = 13
        Caption = 'Device'
      end
      object Label2: TLabel
        Left = 0
        Top = 52
        Width = 32
        Height = 13
        Caption = 'Format'
      end
      object Label3: TLabel
        Left = 0
        Top = 100
        Width = 31
        Height = 13
        Caption = 'Codec'
      end
      object cbxCameras: TComboBox
        Left = 0
        Top = 20
        Width = 452
        Height = 21
        BevelKind = bkFlat
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ImeName = 'Microsoft IME 2010'
        TabOrder = 0
        OnChange = cbxCamerasChange
      end
      object cbxFormats: TComboBox
        Left = 0
        Top = 68
        Width = 452
        Height = 21
        BevelKind = bkFlat
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ImeName = 'Microsoft IME 2010'
        TabOrder = 1
      end
      object cbxCodecs: TComboBox
        Left = 0
        Top = 116
        Width = 452
        Height = 21
        BevelKind = bkFlat
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ImeName = 'Microsoft IME 2010'
        TabOrder = 2
      end
      object chkPreview: TCheckBox
        Left = 0
        Top = 152
        Width = 97
        Height = 17
        Caption = 'Video Preview'
        Checked = True
        Ctl3D = False
        ParentCtl3D = False
        State = cbChecked
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TCP/IP Server'
      ImageIndex = 1
      DesignSize = (
        452
        172)
      object Label5: TLabel
        Left = 0
        Top = 8
        Width = 19
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'Port'
      end
      object txtServerPort: TEdit
        Left = 0
        Top = 24
        Width = 89
        Height = 21
        Anchors = [akLeft, akBottom]
        BevelKind = bkFlat
        BorderStyle = bsNone
        ImeName = 'Microsoft IME 2010'
        TabOrder = 0
        Text = '33000'
      end
      object chkServer: TCheckBox
        Left = 104
        Top = 24
        Width = 97
        Height = 17
        Caption = 'Active'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TCP/IP Client'
      ImageIndex = 2
      DesignSize = (
        452
        172)
      object Label4: TLabel
        Left = 0
        Top = 4
        Width = 22
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'Host'
      end
      object Label6: TLabel
        Left = 208
        Top = 4
        Width = 19
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'Port'
      end
      object lbFrames: TLabel
        Left = 0
        Top = 96
        Width = 46
        Height = 13
        Caption = 'Frames: 0'
      end
      object Label7: TLabel
        Left = 0
        Top = 120
        Width = 23
        Height = 13
        Caption = 'FCC:'
      end
      object lbFCC: TLabel
        Left = 28
        Top = 120
        Width = 20
        Height = 13
        Caption = 'FCC'
      end
      object Label8: TLabel
        Left = 0
        Top = 144
        Width = 25
        Height = 13
        Caption = 'Error:'
      end
      object lbClientError: TLabel
        Left = 32
        Top = 144
        Width = 24
        Height = 13
        Caption = 'none'
      end
      object txtClientHost: TEdit
        Left = 0
        Top = 20
        Width = 201
        Height = 21
        Anchors = [akLeft, akBottom]
        BevelKind = bkFlat
        BorderStyle = bsNone
        ImeName = 'Microsoft IME 2010'
        TabOrder = 0
        Text = '192.168.1.31'
      end
      object txtClientPort: TEdit
        Left = 208
        Top = 20
        Width = 113
        Height = 21
        Anchors = [akLeft, akBottom]
        BevelKind = bkFlat
        BorderStyle = bsNone
        ImeName = 'Microsoft IME 2010'
        TabOrder = 1
        Text = '33000'
      end
      object btnConnect: TButton
        Left = 0
        Top = 53
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Connect'
        TabOrder = 2
        OnClick = btnConnectClick
      end
      object btnDisconnect: TButton
        Left = 88
        Top = 53
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Disconnect'
        Enabled = False
        TabOrder = 3
        OnClick = btnDisconnectClick
      end
    end
  end
end
