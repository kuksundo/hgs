inherited f_dbCreatorWizard: Tf_dbCreatorWizard
  Left = 54
  Top = 209
  Caption = 'dzlib-DBCreator-Wizard'
  ClientHeight = 232
  ClientWidth = 612
  OldCreateOrder = True
  ExplicitWidth = 620
  ExplicitHeight = 259
  PixelsPerInch = 96
  TextHeight = 13
  inherited p_Client: TPanel
    Width = 612
    Height = 191
    ExplicitWidth = 612
    ExplicitHeight = 191
    inherited p_WizardSpace: TPanel
      Width = 480
      Height = 191
      ExplicitWidth = 480
      ExplicitHeight = 191
      inherited p_Description: TPanel
        Width = 480
        ExplicitWidth = 480
        inherited l_Description: TLabel
          Width = 464
          ExplicitWidth = 464
        end
      end
      inherited p_MergeIn: TPanel
        Width = 462
        Height = 148
        ExplicitWidth = 462
        ExplicitHeight = 148
      end
      inherited p_SeparatorLeft: TPanel
        Height = 148
        ExplicitHeight = 148
      end
      inherited p_SeparatorRight: TPanel
        Left = 471
        Height = 148
        ExplicitLeft = 471
        ExplicitHeight = 148
      end
    end
    inherited p_Picture: TPanel
      Height = 191
      ExplicitHeight = 191
      inherited im_Image: TImage
        Height = 191
        ExplicitHeight = 191
      end
    end
  end
  inherited p_Buttons: TPanel
    Top = 191
    Width = 612
    ExplicitTop = 191
    ExplicitWidth = 612
    inherited Bevel1: TBevel
      Width = 612
      ExplicitWidth = 612
    end
    inherited b_Next: TButton
      Left = 443
      ExplicitLeft = 443
    end
    inherited b_Cancel: TButton
      Left = 531
      ExplicitLeft = 531
    end
    inherited b_Prev: TButton
      Left = 371
      ExplicitLeft = 371
    end
    object chk_Console: TCheckBox
      Left = 8
      Top = 12
      Width = 97
      Height = 17
      Caption = 'Show Console'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = chk_ConsoleClick
    end
  end
  object TheAppRegistryStorage: TJvAppRegistryStorage
    StorageOptions.BooleanStringTrueValues = 'TRUE, YES, Y'
    StorageOptions.BooleanStringFalseValues = 'FALSE, NO, N'
    Root = 'software\dzlib\AccessExport'
    SubStorages = <>
    Left = 80
    Top = 80
  end
end
