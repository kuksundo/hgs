object frmInfo: TfrmInfo
  Left = 401
  Top = 303
  AlphaBlend = True
  BorderStyle = bsDialog
  Caption = 'frmInfo'
  ClientHeight = 209
  ClientWidth = 373
  Color = 16115430
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClick = FormClick
  OnClose = FormClose
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object panInfoBorder: TPanel
    Left = 0
    Top = 0
    Width = 373
    Height = 209
    Align = alClient
    BevelOuter = bvLowered
    BevelWidth = 2
    TabOrder = 0
    OnClick = FormClick
    DesignSize = (
      373
      209)
    object pgInfo: TPageControl
      Left = 12
      Top = 9
      Width = 350
      Height = 167
      ActivePage = tsNewMail
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = pgInfoChange
      object tsNewMail: TTabSheet
        Caption = 'New Mail'
        object lvInfoNew: TListView
          Left = 0
          Top = 0
          Width = 342
          Height = 139
          Align = alClient
          Columns = <
            item
              Caption = 'Account'
              Width = 70
            end
            item
              Caption = 'From'
              Width = 85
            end
            item
              Caption = 'Subject'
              Width = 120
            end
            item
              Alignment = taRightJustify
              Caption = 'Size'
            end>
          FullDrag = True
          ParentColor = True
          SmallImages = dm.imlListView
          TabOrder = 0
          ViewStyle = vsReport
          OnClick = FormClick
        end
      end
      object tsSummary: TTabSheet
        Caption = 'Summary'
        ImageIndex = 1
        object lvInfoSummary: TListView
          Left = 0
          Top = 0
          Width = 342
          Height = 139
          Align = alClient
          Columns = <
            item
              Caption = 'Account'
              Width = 120
            end
            item
              Caption = 'Messages'
              Width = 70
            end
            item
              Caption = 'New'
              Width = 60
            end
            item
              Alignment = taRightJustify
              Caption = 'Size'
              Width = 55
            end>
          ParentColor = True
          SmallImages = dm.imlTabs
          TabOrder = 0
          ViewStyle = vsReport
          OnClick = FormClick
        end
      end
    end
    object panCloseX: TPanel
      Left = 349
      Top = 8
      Width = 16
      Height = 16
      Anchors = [akTop, akRight]
      BevelOuter = bvNone
      Color = 15656678
      TabOrder = 1
      object imgCloseX: TImage
        Left = 0
        Top = 0
        Width = 16
        Height = 16
        Align = alClient
        Picture.Data = {
          07544269746D61703E020000424D3E0200000000000036000000280000000D00
          00000D000000010018000000000008020000F00A0000F00A0000000000000000
          0000FF00FF8C79B56B59B56B61B56B61B56B61BD6B61B56B61B56B61B56B61B5
          6B59B58C79B5FF00FF008471B55241B55A49BD5A49BD5A49BD5A49BD5A49BD5A
          49BD5A49BD5A49BD5A49BD5241B58471B5006B61BD5A51C65A59D65A51D65A51
          CE5A59CE5A59CE5A59CE5A51CE5A51D65A59D65A51C66B61BD006B61BD5A59D6
          5249C6D6CFF7ADA6EF5251D65A59D65251D6ADA6EFD6CFF75249C65A59D66B61
          BD006B61BD6359DE4A49BD8C8EA5FFFFFFADA6EF5249D6ADA6EFFFFFFF8C8EA5
          4A49BD6359DE6B61BDFF6B69C66361DE6B69E74A49BD8486A5FFFFF7C6C7F7FF
          FFF78486A54A49BD6B69E76361DE6B69C6006B69C66361DE6369E76B69E74A49
          BDADAEBDFFFFFFADAEBD4A49BD6B69E76369E76361DE6B69C6007369C66B69E7
          6B69E76361DEADAEF7FFFFFFA5A6B5FFFFFFADAEF76361DE6B69E76B69E77369
          C6027369C66B69E76B69E7BDBEF7FFFFFF8486A54241AD8486A5FFFFFFBDBEF7
          6B69E76B69E77369C6007369C67371EF7371EFC6C7D68C8EA55A61CE848EF75A
          61CE8C8EA5C6C7D67371EF7371EF7369C6006B69C67B86F7848EF76371B57B8E
          CE9CAEF794A6EF9CAEF77B8ECE6371B5848EF77B86F76B69C6008479B57B86F7
          A5BEFFB5DFFFB5DFFFADD7FFADD7FFADD7FFB5DFFFB5DFFFA5BEFF7B86F78479
          B500FF00FF8479B57B79CE7B86C67B86C67B86C67B86C67B86C67B86C67B86C6
          7B79CE8479B5FF00FF00}
        Stretch = True
        Transparent = True
        OnClick = FormClick
      end
    end
    object panInfoToolbar: TPanel
      Left = 4
      Top = 173
      Width = 365
      Height = 25
      Anchors = [akLeft, akRight, akBottom]
      BevelOuter = bvLowered
      Color = 15454159
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      object btnMarkAsViewed: TSpeedButton
        Left = 250
        Top = 2
        Width = 108
        Height = 21
        Action = frmPopUMain.actMarkViewed
      end
      object btnMailProgram: TSpeedButton
        Left = 3
        Top = 2
        Width = 117
        Height = 21
        Action = frmPopUMain.actStartProgram
      end
      object btnShowMessages: TSpeedButton
        Left = 122
        Top = 2
        Width = 126
        Height = 21
        Action = frmPopUMain.actShowMessages
      end
    end
  end
end
