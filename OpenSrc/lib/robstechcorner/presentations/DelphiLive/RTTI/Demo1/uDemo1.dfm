object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 548
  ClientWidth = 608
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    608
    548)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 344
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Query RTTI'
    TabOrder = 0
    OnClick = Button1Click
  end
  object pcMain: TPageControl
    Left = 8
    Top = 39
    Width = 592
    Height = 501
    ActivePage = tsQuery
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    object tsQuery: TTabSheet
      Caption = 'Query'
      object pcQuery: TPageControl
        Left = 0
        Top = 0
        Width = 584
        Height = 473
        ActivePage = tsPropListData
        Align = alClient
        TabOrder = 0
        object tsPropListData: TTabSheet
          Caption = 'PProp List Data (TypInfo.pas)'
          object ListView1: TListView
            Left = 0
            Top = 0
            Width = 576
            Height = 445
            Align = alClient
            Columns = <
              item
                Caption = 'Name'
                Width = 100
              end
              item
                Caption = 'PropType'
              end
              item
                Caption = 'PropKind'
              end
              item
                Caption = 'GetProc'
              end
              item
                Caption = 'SetProc'
              end
              item
                Caption = 'StoredProc'
              end
              item
                Caption = 'Index'
              end
              item
                Caption = 'Default'
              end
              item
                Caption = 'NameIndex'
              end
              item
                Caption = 'CurrentValue'
                Width = 200
              end>
            TabOrder = 0
            ViewStyle = vsReport
          end
        end
        object tsOther: TTabSheet
          Caption = 'Other Info (System.pas)'
          ImageIndex = 1
          object ListView2: TListView
            Left = 0
            Top = 0
            Width = 576
            Height = 445
            Align = alClient
            Columns = <
              item
                Caption = 'Name'
                Width = 200
              end
              item
                Caption = 'Value'
                Width = 200
              end
              item
              end
              item
              end>
            TabOrder = 0
            ViewStyle = vsReport
          end
        end
        object tsMethodInfo: TTabSheet
          Caption = 'MethodInfo (ObjAuto.pas)'
          ImageIndex = 2
          object ListView3: TListView
            Left = 0
            Top = 0
            Width = 576
            Height = 445
            Align = alClient
            Columns = <
              item
                Caption = 'Name'
                Width = 150
              end
              item
                Caption = 'Defined As'
                Width = 1000
              end>
            TabOrder = 0
            ViewStyle = vsReport
          end
        end
      end
    end
    object tsInteract: TTabSheet
      Caption = 'Interact'
      ImageIndex = 1
      object pcInteract: TPageControl
        Left = 0
        Top = 0
        Width = 584
        Height = 473
        ActivePage = tsMethodInvoke
        Align = alClient
        TabOrder = 0
        object tsSetValues: TTabSheet
          Caption = 'Set Values'
          object Label1: TLabel
            Left = 24
            Top = 112
            Width = 95
            Height = 13
            Caption = 'Property to Change'
          end
          object Label2: TLabel
            Left = 24
            Top = 165
            Width = 50
            Height = 13
            Caption = 'New Value'
          end
          object edtNewValue: TEdit
            Left = 24
            Top = 184
            Width = 329
            Height = 21
            TabOrder = 0
          end
          object cbxPropListSetValues: TComboBox
            Left = 24
            Top = 131
            Width = 329
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 1
            OnChange = cbxPropListSetValuesChange
          end
          object Button2: TButton
            Left = 236
            Top = 227
            Width = 117
            Height = 30
            Caption = 'Set'
            TabOrder = 2
            OnClick = Button2Click
          end
          object Button3: TButton
            Left = 24
            Top = 40
            Width = 145
            Height = 31
            Caption = 'Prep Tab'
            TabOrder = 3
            OnClick = Button3Click
          end
        end
        object tsCopy: TTabSheet
          Caption = 'Make a Copy'
          ImageIndex = 1
          object Button4: TButton
            Left = 384
            Top = 24
            Width = 105
            Height = 25
            Caption = 'Make a Copy'
            TabOrder = 0
            OnClick = Button4Click
          end
        end
        object tsMethodInvoke: TTabSheet
          Caption = 'Method Invoke'
          ImageIndex = 2
          object GroupBox1: TGroupBox
            Left = 16
            Top = 16
            Width = 529
            Height = 137
            Caption = 'Possible Type Known'
            TabOrder = 0
            object Label3: TLabel
              Left = 16
              Top = 22
              Width = 65
              Height = 13
              Caption = 'Method name'
            end
            object edtMethodName1: TEdit
              Left = 16
              Top = 41
              Width = 161
              Height = 21
              TabOrder = 0
              Text = 'HelloWorldMessage'
            end
            object btnInvokeProc: TButton
              Left = 199
              Top = 41
              Width = 106
              Height = 25
              Caption = 'Invoke'
              TabOrder = 1
              OnClick = btnInvokeProcClick
            end
            object edtMethodName2: TEdit
              Left = 16
              Top = 88
              Width = 161
              Height = 21
              TabOrder = 2
              Text = 'NotifyEventExample'
            end
            object btnInvokeNotify: TButton
              Left = 199
              Top = 88
              Width = 106
              Height = 25
              Caption = 'Invoke'
              TabOrder = 3
              OnClick = btnInvokeNotifyClick
            end
          end
          object GroupBox2: TGroupBox
            Left = 16
            Top = 159
            Width = 529
            Height = 281
            Caption = 'Type Unknown'
            TabOrder = 1
            object Label4: TLabel
              Left = 97
              Top = 17
              Width = 87
              Height = 13
              Caption = 'Available Methods'
            end
            object cbxMethodNames: TComboBox
              Left = 97
              Top = 36
              Width = 376
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              OnChange = cbxMethodNamesChange
            end
            object Button6: TButton
              Left = 16
              Top = 33
              Width = 75
              Height = 25
              Caption = 'Populate'
              TabOrder = 1
              OnClick = Button6Click
            end
            object Button7: TButton
              Left = 384
              Top = 241
              Width = 89
              Height = 25
              Caption = 'Execute'
              TabOrder = 2
              OnClick = Button7Click
            end
            object vlParms: TValueListEditor
              Left = 16
              Top = 63
              Width = 457
              Height = 161
              KeyOptions = [keyUnique]
              TabOrder = 3
              TitleCaptions.Strings = (
                'Parameter'
                'Value')
              ColWidths = (
                142
                309)
            end
            object Button5: TButton
              Left = 16
              Top = 246
              Width = 75
              Height = 25
              Caption = 'Sample'
              TabOrder = 4
              OnClick = Button5Click
            end
          end
        end
      end
    end
  end
end
